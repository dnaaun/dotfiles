local M = {}

---@class JjGhReviewIcons
---@field resolved string
---@field outdated string
---@field pending string
---@field syncing string
---@field error string
---@field review string

---@class JjGhReviewFloatConfig
---@field border "none"|"single"|"double"|"rounded"|"solid"|"shadow"|string[]
---@field min_width integer
---@field max_width number fraction of &columns when < 1, else absolute
---@field min_height integer
---@field max_height number fraction of &lines when < 1, else absolute
---@field close_on_save boolean

---@class JjGhReviewRetryConfig
---@field min integer seconds
---@field max integer seconds

---@class JjGhReviewConfig
---@field icon string glyph shown next to comments (ghost text and statusline)
---@field icons JjGhReviewIcons
---@field virt_text_pos "eol"|"right_align"|"inline"|"overlay"
---@field preview_width integer max display width of the body preview in ghost text
---@field show_outdated boolean show threads GitHub marks outdated (at their original line)
---@field show_resolved boolean show resolved threads (dimmed)
---@field highlight_range boolean highlight the whole commented range, not just the first line
---@field format_thread nil|fun(thread: JjGhReviewThread): string|[string, string][] custom ghost text
---@field use_pending_review boolean batch new comments into a pending review (submit later)
---@field jj_new boolean run `jj new <pr head>` when a review is opened
---@field diffview_cmd string|false command to run once the working copy is prepared; `{base}` becomes the commit GitHub diffs the PR against
---@field float JjGhReviewFloatConfig
---@field open_quickfix boolean open the quickfix window in `list()`
---@field retry_seconds JjGhReviewRetryConfig backoff for failed syncs
---@field cache_dir string

---@class JjGhReviewConfigPartial: JjGhReviewConfig
---@field icon? string
---@field icons? JjGhReviewIcons
---@field virt_text_pos? "eol"|"right_align"|"inline"|"overlay"
---@field preview_width? integer
---@field show_outdated? boolean
---@field show_resolved? boolean
---@field highlight_range? boolean
---@field use_pending_review? boolean
---@field jj_new? boolean
---@field diffview_cmd? string|false
---@field float? JjGhReviewFloatConfig
---@field open_quickfix? boolean
---@field retry_seconds? JjGhReviewRetryConfig
---@field cache_dir? string

---@type JjGhReviewConfig
M.defaults = {
	-- Any Nerd Font has these (FontAwesome/Octicons ranges); override if yours doesn't.
	icon = "\u{f075}", -- nf-fa-comment
	icons = {
		resolved = "\u{f00c}", -- nf-fa-check
		outdated = "\u{f1da}", -- nf-fa-history
		pending = "\u{f040}", -- nf-fa-pencil
		syncing = "\u{f0ee}", -- nf-fa-cloud_upload
		error = "\u{f071}", -- nf-fa-exclamation_triangle
		review = "\u{f407}", -- nf-oct-git_pull_request
	},
	virt_text_pos = "eol",
	preview_width = 50,
	show_outdated = true,
	show_resolved = true,
	highlight_range = false,
	format_thread = nil,
	use_pending_review = true,
	jj_new = true,
	diffview_cmd = "JjDiffviewOpen --from {base}",
	float = {
		border = "rounded",
		min_width = 40,
		max_width = 0.8,
		min_height = 3,
		max_height = 0.6,
		close_on_save = true,
	},
	open_quickfix = true,
	retry_seconds = { min = 15, max = 300 },
	cache_dir = vim.fn.stdpath("cache") .. "/jj-gh-review",
}

---@type JjGhReviewConfig
M.options = vim.deepcopy(M.defaults)

---@param opts? JjGhReviewConfigPartial
---@return JjGhReviewConfig
function M.setup(opts)
	local overrides = opts or {} --[[@as table]]
	M.options = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults) --[[@as table]], overrides) --[[@as JjGhReviewConfig]]
	return M.options
end

return M
