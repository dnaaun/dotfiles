--- All GitHub access. Every call shells out to `gh` with GIT_DIR pointed at the
--- jj repo's git dir, so it works in non-colocated jj workspaces.
local repo_mod = require("jj_gh_review.repo")
local util = require("jj_gh_review.util")

local M = {}

---@param stdout string
---@return table|nil
local function decode(stdout)
	local ok, value = pcall(vim.json.decode, stdout, { luanil = { object = true, array = true } })
	if not ok or type(value) ~= "table" then
		return nil
	end
	return value
end

---@param repo JjGhReviewRepo
---@param args string[]
---@param callback fun(result: JjGhReviewRunResult)
local function gh(repo, args, callback)
	util.run(vim.list_extend({ "gh" }, args), { cwd = repo.root, env = repo_mod.gh_env(repo) }, callback)
end

--- `gh pr view <spec>`; adds `owner` / `name` parsed from the PR URL.
---@param repo JjGhReviewRepo
---@param spec string|nil
---@param callback fun(pr: JjGhReviewPr|nil, err: string|nil)
function M.pr_view(repo, spec, callback)
	local fields = table.concat({
		"id",
		"number",
		"title",
		"url",
		"state",
		"isDraft",
		"author",
		"headRefName",
		"headRefOid",
		"baseRefName",
		"baseRefOid",
		"isCrossRepository",
	}, ",")
	local args = { "pr", "view", "--json", fields }
	if spec and spec ~= "" then
		table.insert(args, 3, spec)
	end
	gh(repo, args, function(result)
		if result.code ~= 0 then
			callback(nil, util.command_error("gh pr view", result))
			return
		end
		local pr = decode(result.stdout) --[[@as JjGhReviewPr|nil]]
		if not pr or not pr.url then
			callback(nil, "gh pr view returned invalid JSON")
			return
		end
		pr.owner, pr.name = pr.url:match("github%.com/([^/]+)/([^/]+)/pull/")
		if not pr.owner then
			callback(nil, "could not parse owner/repo from " .. pr.url)
			return
		end
		callback(pr)
	end)
end

--- Open PRs for command completion. Synchronous (with timeout).
---@param repo JjGhReviewRepo
---@param timeout_ms? integer
---@return {number: integer, title: string, headRefName: string}[]
function M.pr_list_sync(repo, timeout_ms)
	local result = vim.system(
		{ "gh", "pr", "list", "--limit", "200", "--json", "number,title,headRefName" },
		{ cwd = repo.root, env = repo_mod.gh_env(repo), text = true }
	):wait(timeout_ms or 4000)
	if not result or result.code ~= 0 then
		return {}
	end
	return decode(result.stdout or "") or {}
end

--- Login of the authenticated GitHub user.
---@param repo JjGhReviewRepo
---@param callback fun(login: string|nil, err: string|nil)
function M.viewer(repo, callback)
	gh(repo, { "api", "user", "--jq", ".login" }, function(result)
		if result.code ~= 0 then
			callback(nil, util.command_error("gh api user", result))
			return
		end
		callback(util.trim(result.stdout))
	end)
end

--- Run a GraphQL document. Non-paginated calls send `{query, variables}` as a
--- JSON body on stdin (so arrays/objects work as variables). Paginated calls
--- must use -f/-F flags because `gh --paginate` does not accept `--input`, so
--- only scalar variables are supported there.
---@param repo JjGhReviewRepo
---@param query string
---@param vars table<string, any>|nil
---@param callback fun(data: table|nil, err: string|nil) `data` is the parsed response (a list of pages when paginating)
---@param opts? {paginate?: boolean}
function M.graphql(repo, query, vars, callback, opts)
	opts = opts or {}
	local args = { "api", "graphql" }
	local stdin
	if opts.paginate then
		vim.list_extend(args, { "--paginate", "--slurp" })
		for key, value in pairs(vars or {}) do
			if type(value) == "string" then
				vim.list_extend(args, { "-f", key .. "=" .. value })
			else
				vim.list_extend(args, { "-F", key .. "=" .. tostring(value) })
			end
		end
		vim.list_extend(args, { "-f", "query=" .. query })
	else
		vim.list_extend(args, { "--input", "-" })
		stdin = vim.json.encode({ query = query, variables = vars or vim.empty_dict() })
	end
	util.run(
		vim.list_extend({ "gh" }, args),
		{ cwd = repo.root, env = repo_mod.gh_env(repo), stdin = stdin },
		function(result)
			local data = decode(result.stdout)
			if result.code ~= 0 then
				local message = util.command_error("gh api graphql", result)
				if data and data.errors and data.errors[1] and data.errors[1].message then
					message = "GitHub: " .. data.errors[1].message
				end
				callback(nil, message)
				return
			end
			if not data then
				callback(nil, "gh api graphql returned invalid JSON")
				return
			end
			if data.errors and data.errors[1] then
				callback(nil, "GitHub: " .. tostring(data.errors[1].message))
				return
			end
			callback(data)
		end
	)
end

local THREAD_FIELDS = [[
	id isResolved isOutdated path line startLine originalLine originalStartLine diffSide startDiffSide
	comments(first: 100) {
		nodes {
			id databaseId body createdAt updatedAt url state viewerDidAuthor
			author { login }
			pullRequestReview { id state }
		}
	}
]]

---@param node table raw GraphQL PullRequestReviewComment
---@return JjGhReviewComment
local function normalize_comment(node)
	return {
		id = node.id,
		database_id = node.databaseId,
		body = node.body or "",
		author = node.author and node.author.login or "ghost",
		created_at = node.createdAt,
		updated_at = node.updatedAt,
		url = node.url,
		pending = node.state == "PENDING",
		mine = node.viewerDidAuthor == true,
		review_id = node.pullRequestReview and node.pullRequestReview.id or nil,
	}
end

--- Convert a raw GraphQL PullRequestReviewThread into our shape.
---@param node table
---@return JjGhReviewThread
function M.normalize_thread(node)
	local comments = {}
	for _, comment in ipairs((node.comments and node.comments.nodes) or {}) do
		table.insert(comments, normalize_comment(comment))
	end
	return {
		id = node.id,
		path = node.path,
		line = node.line,
		start_line = node.startLine,
		original_line = node.originalLine,
		original_start_line = node.originalStartLine,
		side = node.diffSide or "RIGHT",
		start_side = node.startDiffSide,
		resolved = node.isResolved == true,
		outdated = node.isOutdated == true,
		comments = comments,
	}
end

---@class JjGhReviewFetchResult
---@field threads JjGhReviewThread[]
---@field pending_review_id string|nil
---@field head_oid string|nil
---@field base_oid string|nil

--- All review threads on the PR plus the viewer's pending review (if any).
---@param repo JjGhReviewRepo
---@param pr JjGhReviewPr
---@param callback fun(result: JjGhReviewFetchResult|nil, err: string|nil)
function M.fetch_threads(repo, pr, callback)
	local query = string.format(
		[[
		query($owner: String!, $name: String!, $number: Int!, $endCursor: String) {
			repository(owner: $owner, name: $name) {
				pullRequest(number: $number) {
					id headRefOid baseRefOid
					reviews(states: PENDING, first: 5) { nodes { id state } }
					reviewThreads(first: 100, after: $endCursor) {
						pageInfo { hasNextPage endCursor }
						nodes { %s }
					}
				}
			}
		}
	]],
		THREAD_FIELDS
	)
	M.graphql(repo, query, { owner = pr.owner, name = pr.name, number = pr.number }, function(pages, err)
		if err then
			callback(nil, err)
			return
		end
		local threads, pending_review_id, head_oid, base_oid = {}, nil, nil, nil
		for _, page in ipairs(pages or {}) do
			local pull = page.data and page.data.repository and page.data.repository.pullRequest
			if pull then
				head_oid = head_oid or pull.headRefOid
				base_oid = base_oid or pull.baseRefOid
				local pending = pull.reviews and pull.reviews.nodes and pull.reviews.nodes[1]
				if pending then
					pending_review_id = pending.id
				end
				for _, node in ipairs((pull.reviewThreads and pull.reviewThreads.nodes) or {}) do
					table.insert(threads, M.normalize_thread(node))
				end
			end
		end
		callback({ threads = threads, pending_review_id = pending_review_id, head_oid = head_oid, base_oid = base_oid })
	end, { paginate = true })
end

--- Start an empty pending review for the viewer.
---@param repo JjGhReviewRepo
---@param pr JjGhReviewPr
---@param callback fun(review_id: string|nil, err: string|nil)
function M.create_pending_review(repo, pr, callback)
	local query = [[
		mutation($pullRequestId: ID!) {
			addPullRequestReview(input: { pullRequestId: $pullRequestId }) {
				pullRequestReview { id }
			}
		}
	]]
	M.graphql(repo, query, { pullRequestId = pr.id }, function(data, err)
		if err or not data then
			return callback(nil, err or "empty response")
		end
		callback(data.data.addPullRequestReview.pullRequestReview.id)
	end)
end

---@class JjGhReviewNewThread
---@field path string
---@field body string
---@field line integer
---@field start_line integer|nil
---@field side "LEFT"|"RIGHT"
---@field start_side "LEFT"|"RIGHT"|nil

--- Post a single-comment review immediately (no pending review).
---@param repo JjGhReviewRepo
---@param pr JjGhReviewPr
---@param thread JjGhReviewNewThread
---@param callback fun(thread: JjGhReviewThread|nil, err: string|nil)
function M.add_immediate_thread(repo, pr, thread, callback)
	local query = string.format(
		[[
		mutation($pullRequestId: ID!, $threads: [DraftPullRequestReviewThread]) {
			addPullRequestReview(input: { pullRequestId: $pullRequestId, event: COMMENT, threads: $threads }) {
				pullRequestReview {
					id
					comments(first: 1) { nodes { pullRequestThread { %s } } }
				}
			}
		}
	]],
		THREAD_FIELDS
	)
	local draft = { path = thread.path, body = thread.body, line = thread.line, side = thread.side }
	if thread.start_line and thread.start_line ~= thread.line then
		draft.startLine = thread.start_line
		draft.startSide = thread.start_side or thread.side
	end
	M.graphql(repo, query, { pullRequestId = pr.id, threads = { draft } }, function(data, err)
		if err or not data then
			return callback(nil, err or "empty response")
		end
		local review = data.data.addPullRequestReview.pullRequestReview
		local node = review.comments.nodes[1] and review.comments.nodes[1].pullRequestThread
		callback(node and M.normalize_thread(node) or nil)
	end)
end

--- Add a thread to a pending review.
---@param repo JjGhReviewRepo
---@param review_id string
---@param thread JjGhReviewNewThread
---@param callback fun(thread: JjGhReviewThread|nil, err: string|nil)
function M.add_thread(repo, review_id, thread, callback)
	local query = string.format(
		[[
		mutation($reviewId: ID!, $path: String!, $body: String!, $line: Int!, $side: DiffSide!, $startLine: Int, $startSide: DiffSide) {
			addPullRequestReviewThread(input: {
				pullRequestReviewId: $reviewId, path: $path, body: $body, line: $line, side: $side,
				startLine: $startLine, startSide: $startSide
			}) { thread { %s } }
		}
	]],
		THREAD_FIELDS
	)
	local vars =
		{ reviewId = review_id, path = thread.path, body = thread.body, line = thread.line, side = thread.side }
	if thread.start_line and thread.start_line ~= thread.line then
		vars.startLine = thread.start_line
		vars.startSide = thread.start_side or thread.side
	end
	M.graphql(repo, query, vars, function(data, err)
		if err or not data then
			return callback(nil, err or "empty response")
		end
		callback(M.normalize_thread(data.data.addPullRequestReviewThread.thread))
	end)
end

--- Reply to a thread (attached to `review_id` when given).
---@param repo JjGhReviewRepo
---@param thread_id string
---@param review_id string|nil
---@param body string
---@param callback fun(thread: JjGhReviewThread|nil, err: string|nil)
function M.reply(repo, thread_id, review_id, body, callback)
	local query = string.format(
		[[
		mutation($threadId: ID!, $reviewId: ID, $body: String!) {
			addPullRequestReviewThreadReply(input: { pullRequestReviewThreadId: $threadId, pullRequestReviewId: $reviewId, body: $body }) {
				comment { pullRequestThread { %s } }
			}
		}
	]],
		THREAD_FIELDS
	)
	local vars = { threadId = thread_id, body = body }
	if review_id then
		vars.reviewId = review_id
	end
	M.graphql(repo, query, vars, function(data, err)
		if err or not data then
			return callback(nil, err or "empty response")
		end
		callback(M.normalize_thread(data.data.addPullRequestReviewThreadReply.comment.pullRequestThread))
	end)
end

--- Edit the body of one of the viewer's comments.
---@param repo JjGhReviewRepo
---@param comment_id string
---@param body string
---@param callback fun(comment: table|nil, err: string|nil)
function M.update_comment(repo, comment_id, body, callback)
	local query = [[
		mutation($id: ID!, $body: String!) {
			updatePullRequestReviewComment(input: { pullRequestReviewCommentId: $id, body: $body }) {
				pullRequestReviewComment { id updatedAt }
			}
		}
	]]
	M.graphql(repo, query, { id = comment_id, body = body }, function(data, err)
		if err or not data then
			return callback(nil, err or "empty response")
		end
		callback(data.data.updatePullRequestReviewComment.pullRequestReviewComment)
	end)
end

--- Delete one of the viewer's comments.
---@param repo JjGhReviewRepo
---@param comment_id string
---@param callback fun(ok: boolean|nil, err: string|nil)
function M.delete_comment(repo, comment_id, callback)
	local query = [[
		mutation($id: ID!) {
			deletePullRequestReviewComment(input: { id: $id }) { clientMutationId }
		}
	]]
	M.graphql(repo, query, { id = comment_id }, function(_, err)
		if err then
			return callback(nil, err)
		end
		callback(true)
	end)
end

--- Resolve or unresolve a thread.
---@param repo JjGhReviewRepo
---@param thread_id string
---@param resolved boolean
---@param callback fun(thread: table|nil, err: string|nil)
function M.set_resolved(repo, thread_id, resolved, callback)
	local mutation = resolved and "resolveReviewThread" or "unresolveReviewThread"
	local query = string.format(
		[[
		mutation($threadId: ID!) {
			%s(input: { threadId: $threadId }) { thread { id isResolved } }
		}
	]],
		mutation
	)
	M.graphql(repo, query, { threadId = thread_id }, function(data, err)
		if err or not data then
			return callback(nil, err or "empty response")
		end
		callback(data.data[mutation].thread)
	end)
end

--- Submit a (pending) review.
---@param repo JjGhReviewRepo
---@param review_id string
---@param event "COMMENT"|"APPROVE"|"REQUEST_CHANGES"
---@param body string|nil
---@param callback fun(review: table|nil, err: string|nil)
function M.submit_review(repo, review_id, event, body, callback)
	local query = [[
		mutation($reviewId: ID!, $event: PullRequestReviewEvent!, $body: String) {
			submitPullRequestReview(input: { pullRequestReviewId: $reviewId, event: $event, body: $body }) {
				pullRequestReview { id state }
			}
		}
	]]
	local vars = { reviewId = review_id, event = event }
	if body and body ~= "" then
		vars.body = body
	end
	M.graphql(repo, query, vars, function(data, err)
		if err or not data then
			return callback(nil, err or "empty response")
		end
		callback(data.data.submitPullRequestReview.pullRequestReview)
	end)
end

return M
