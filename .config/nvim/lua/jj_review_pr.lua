local M = {}

-- https://docs.github.com/en/search-github/searching-on-github/searching-issues-and-pull-requests
local SEARCH_COMPLETIONS = {
	"assignee:",
	"assignee:@me",
	"author:",
	"author:@me",
	"base:",
	"closed:",
	"commenter:",
	"commenter:@me",
	"comments:",
	"created:",
	"draft:false",
	"draft:true",
	"head:",
	"in:body",
	"in:comments",
	"in:title",
	"interactions:",
	"involves:",
	"involves:@me",
	"is:closed",
	"is:merged",
	"is:open",
	"is:unmerged",
	"label:",
	"language:",
	"linked:issue",
	"mentions:",
	"mentions:@me",
	"merged:",
	"milestone:",
	"no:assignee",
	"no:label",
	"no:milestone",
	"no:project",
	"project:",
	"reactions:",
	"review:approved",
	"review:changes_requested",
	"review:none",
	"review:required",
	"review-involves:",
	"review-involves:@me",
	"review-requested:",
	"review-requested:@me",
	"reviewed-by:",
	"reviewed-by:@me",
	"status:failure",
	"status:pending",
	"status:success",
	"team-review-requested:",
	"team-review-requested-user:",
	"team:",
	"updated:",
	"user-review-requested:@me",
}

local function notify(message, level)
	vim.schedule(function()
		vim.notify(message, level, { title = "JjReviewPR" })
	end)
end

local function trim(value)
	return (value:gsub("%s+$", ""))
end

local function run(args, opts, callback)
	vim.system(args, opts or {}, function(result)
		vim.schedule(function()
			callback(result)
		end)
	end)
end

local function command_error(command, result)
	local details = trim(result.stderr or "")
	if details == "" then
		details = trim(result.stdout or "")
	end
	if details == "" then
		details = "exit code " .. result.code
	end
	return command .. " failed: " .. details
end

local function resolve_jj_repo(callback)
	local cwd = vim.fn.getcwd()
	run({ "jj", "root", "--ignore-working-copy" }, { cwd = cwd, text = true }, function(root_result)
		if root_result.code ~= 0 then
			callback(nil, command_error("jj root", root_result))
			return
		end

		run({ "jj", "git", "root", "--ignore-working-copy" }, { cwd = cwd, text = true }, function(git_result)
			if git_result.code ~= 0 then
				callback(nil, command_error("jj git root", git_result))
				return
			end

			callback({
				root = trim(root_result.stdout),
				git_dir = trim(git_result.stdout),
			})
		end)
	end)
end

local function local_completions()
	local bookmarks = vim.system({
		"jj",
		"bookmark",
		"list",
		"--ignore-working-copy",
		"-T",
		'name ++ "\\n"',
	}, { cwd = vim.fn.getcwd(), text = true }):wait()

	local completions = {}
	if bookmarks.code == 0 then
		for _, bookmark in ipairs(vim.split(trim(bookmarks.stdout), "\n", { plain = true, trimempty = true })) do
			table.insert(completions, "base:" .. bookmark)
			table.insert(completions, "head:" .. bookmark)
		end
	end

	local remotes = vim.system({ "jj", "git", "remote", "list" }, { cwd = vim.fn.getcwd(), text = true }):wait()
	if remotes.code == 0 then
		local user_qualifiers = {
			"assignee:",
			"author:",
			"commenter:",
			"involves:",
			"mentions:",
			"review-involves:",
			"review-requested:",
			"reviewed-by:",
			"team-review-requested-user:",
		}
		local seen_owners = {}
		for url in remotes.stdout:gmatch("%S+") do
			local owner = url:match("[:/]([^/:]+)/[^/]+%.git$") or url:match("[:/]([^/:]+)/[^/]+$")
			if owner and not seen_owners[owner] then
				seen_owners[owner] = true
				for _, qualifier in ipairs(user_qualifiers) do
					table.insert(completions, qualifier .. owner)
				end
			end
		end
	end
	return completions
end

local function complete_search(arg_lead)
	local negative = vim.startswith(arg_lead, "-")
	local lead = negative and arg_lead:sub(2) or arg_lead
	local candidates = vim.list_extend(vim.deepcopy(SEARCH_COMPLETIONS), local_completions())
	local matches = {}

	for _, candidate in ipairs(candidates) do
		if vim.startswith(candidate, lead) then
			table.insert(matches, negative and "-" .. candidate or candidate)
		end
	end

	table.sort(matches)
	return matches
end

local function fetch_prs(repo, search, callback)
	local env = vim.tbl_extend("force", vim.fn.environ(), { GIT_DIR = repo.git_dir })
	local fields = table.concat({
		"number",
		"title",
		"author",
		"isDraft",
		"baseRefName",
		"baseRefOid",
		"headRefName",
		"headRefOid",
	}, ",")

	local args = {
		"gh",
		"pr",
		"list",
		"--state",
		"open",
		"--limit",
		"1000",
		"--json",
		fields,
	}
	if search ~= "" then
		vim.list_extend(args, { "--search", search })
	end

	run(args, { cwd = repo.root, env = env, text = true }, function(result)
		if result.code ~= 0 then
			callback(nil, command_error("gh pr list", result))
			return
		end

		local ok, prs = pcall(vim.json.decode, result.stdout)
		if not ok or type(prs) ~= "table" then
			callback(nil, "gh pr list returned invalid JSON")
			return
		end

		callback(prs)
	end)
end

local function bookmark_revset(name)
	return "bookmarks(exact:" .. vim.json.encode(name) .. ")"
end

local function inspect_bookmark(repo, name, callback)
	run({
		"jj",
		"log",
		"--ignore-working-copy",
		"--no-graph",
		"-r",
		bookmark_revset(name),
		"-T",
		'commit_id ++ "\\n"',
	}, { cwd = repo.root, text = true }, function(result)
		if result.code ~= 0 then
			callback(nil, command_error("jj log", result))
			return
		end

		local commits = vim.split(trim(result.stdout), "\n", { plain = true, trimempty = true })
		callback(commits)
	end)
end

local function abbreviated(oid)
	return oid and oid:sub(1, 12) or "unknown"
end

local function review_pr(repo, pr)
	local checks = {
		{ role = "source", name = pr.headRefName, expected = pr.headRefOid },
		{ role = "target", name = pr.baseRefName, expected = pr.baseRefOid },
	}
	local remaining = #checks
	local warnings = {}

	local function finish()
		if #warnings > 0 then
			notify("Local bookmark warning:\n" .. table.concat(warnings, "\n"), vim.log.levels.WARN)
		end

		-- A PR shows the changes needed to turn its target (base) into its source (head).
		require("diffview").open({ "--from=" .. pr.baseRefName, "--to=" .. pr.headRefName })
	end

	for _, check in ipairs(checks) do
		local bookmark = check
		inspect_bookmark(repo, bookmark.name, function(commits, err)
			if err then
				table.insert(
					warnings,
					string.format("- Could not inspect %s bookmark %q: %s", bookmark.role, bookmark.name, err)
				)
			elseif #commits == 0 then
				table.insert(
					warnings,
					string.format("- %s bookmark %q is not present locally", bookmark.role, bookmark.name)
				)
			elseif #commits > 1 then
				table.insert(
					warnings,
					string.format("- %s bookmark %q is conflicted locally", bookmark.role, bookmark.name)
				)
			elseif commits[1] ~= bookmark.expected then
				table.insert(
					warnings,
					string.format(
						"- %s bookmark %q may be out of date (local %s, GitHub %s)",
						bookmark.role,
						bookmark.name,
						abbreviated(commits[1]),
						abbreviated(bookmark.expected)
					)
				)
			end

			remaining = remaining - 1
			if remaining == 0 then
				finish()
			end
		end)
	end
end

local function open_picker(repo, prs)
	if #prs == 0 then
		notify("No open pull requests", vim.log.levels.INFO)
		return
	end

	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local finders = require("telescope.finders")
	local pickers = require("telescope.pickers")
	local sorters = require("telescope.config").values
	local sorter = sorters.generic_sorter({})
	local score = sorter.scoring_function

	-- Keep every displayed field searchable, but substantially prefer a match in
	-- the title. Telescope scores lower values as better matches.
	sorter.scoring_function = function(self, prompt, line, entry, ...)
		local overall_score = score(self, prompt, line, entry, ...)
		if prompt == "" or overall_score < 0 then
			return overall_score
		end

		local title_score = score(self, prompt, entry.value.title, entry, ...)
		if title_score < 0 then
			return overall_score
		end

		return math.min(overall_score, title_score * 0.35)
	end

	pickers
		.new({}, {
			prompt_title = "Open pull requests",
			finder = finders.new_table({
				results = prs,
				entry_maker = function(pr)
					local author = pr.author and pr.author.login or "unknown"
					local draft = pr.isDraft and " [draft]" or ""
					return {
						value = pr,
						display = string.format(
							"#%d%s %s (%s -> %s) @%s",
							pr.number,
							draft,
							pr.title,
							pr.headRefName,
							pr.baseRefName,
							author
						),
						ordinal = table.concat({
							tostring(pr.number),
							pr.title,
							pr.headRefName,
							pr.baseRefName,
							author,
						}, " "),
					}
				end,
			}),
			sorter = sorter,
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					if selection then
						review_pr(repo, selection.value)
					end
				end)
				return true
			end,
		})
		:find()
end

function M.open(search)
	search = search or ""
	resolve_jj_repo(function(repo, err)
		if err then
			notify(err, vim.log.levels.ERROR)
			return
		end

		fetch_prs(repo, search, function(prs, fetch_err)
			if fetch_err then
				notify(fetch_err, vim.log.levels.ERROR)
				return
			end
			open_picker(repo, prs)
		end)
	end)
end

function M.setup()
	vim.api.nvim_create_user_command("JjReviewPR", function(opts)
		M.open(opts.args)
	end, {
		complete = complete_search,
		desc = "Select an open GitHub PR matching an optional search and review it with jj diffview",
		nargs = "*",
	})
end

return M
