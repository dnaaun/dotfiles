--- On-disk cache: PR metadata + threads per PR, the pending op queue, and a
--- per-git-dir index from user-typed specifiers to PRs so that reopening a
--- review shows the last known state instantly (offline first).
local config = require("jj_gh_review.config")
local util = require("jj_gh_review.util")

local M = {}

---@class JjGhReviewPrRef
---@field owner string
---@field name string
---@field number integer

---@class JjGhReviewCachedPr
---@field pr JjGhReviewPr
---@field threads JjGhReviewThread[]
---@field pending_review_id string|nil
---@field fetched_at string|nil

---@return string
local function dir()
	return config.options.cache_dir
end

---@param pr JjGhReviewPrRef
---@return string
local function pr_key(pr)
	return string.format("%s__%s/%d", pr.owner, pr.name, pr.number)
end

---@param repo JjGhReviewRepo
---@return string
local function index_path(repo)
	return string.format("%s/specs/%s.json", dir(), vim.fn.sha256(repo.git_dir))
end

---@param repo JjGhReviewRepo
---@param spec string
---@return JjGhReviewPrRef|nil
function M.lookup_spec(repo, spec)
	local index = util.read_json(index_path(repo)) or {}
	return index[spec]
end

---@param repo JjGhReviewRepo
---@param spec string
---@param pr JjGhReviewPr
function M.remember_spec(repo, spec, pr)
	local path = index_path(repo)
	local index = util.read_json(path) or {}
	local entry = { owner = pr.owner, name = pr.name, number = pr.number }
	index[spec] = entry
	index[tostring(pr.number)] = entry
	if pr.headRefName then
		index[pr.headRefName] = entry
	end
	if pr.url then
		index[pr.url] = entry
	end
	util.write_json(path, index)
end

---@param ref JjGhReviewPrRef
---@return JjGhReviewCachedPr|nil
function M.load_pr(ref)
	return util.read_json(string.format("%s/%s.json", dir(), pr_key(ref)))
end

---@param session JjGhReviewSession
function M.save_pr(session)
	if not session.pr then
		return
	end
	util.write_json(string.format("%s/%s.json", dir(), pr_key(session.pr)), {
		pr = session.pr,
		threads = session.threads,
		pending_review_id = session.pending_review_id,
		fetched_at = session.fetched_at,
	})
end

---@param ref JjGhReviewPrRef
---@return JjGhReviewOp[]
function M.load_queue(ref)
	local queue = util.read_json(string.format("%s/%s.queue.json", dir(), pr_key(ref)))
	if type(queue) ~= "table" then
		return {}
	end
	return queue
end

---@param session JjGhReviewSession
function M.save_queue(session)
	if not session.pr then
		return
	end
	util.write_json(string.format("%s/%s.queue.json", dir(), pr_key(session.pr)), session.queue)
end

---@param repo JjGhReviewRepo
---@return string|nil
function M.load_viewer(repo)
	local data = util.read_json(string.format("%s/viewer/%s.json", dir(), vim.fn.sha256(repo.git_dir)))
	return type(data) == "table" and data.login or nil
end

---@param repo JjGhReviewRepo
---@param login string
function M.save_viewer(repo, login)
	util.write_json(string.format("%s/viewer/%s.json", dir(), vim.fn.sha256(repo.git_dir)), { login = login })
end

return M
