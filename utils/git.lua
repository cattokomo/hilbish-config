-- Wrapper around gitstatus

if not hilbish.which("gitstatusd") then
	error("Requires gitstatusd to retrieve git repo information")
end

local git = {}

---@param str string
---@return string?
local function non_empty(str)
	return str ~= "" and str or nil
end

---@param id string
---@param path string
---@param disable_git_index boolean?
---@return table<string, (string|number)?>
function git.get_info(id, path, disable_git_index)
	local f = assert(io.popen("gitstatusd -t $(nproc) 2>/dev/null >.gitstatusd", "w"))
	local payload = table.concat({
		id, path, disable_git_index and "1" or "0"
	}, "\31") .. "\30"

	f:write(payload)

	local ok, _, code = f:close()

	if not ok then
		os.remove(".gitstatusd")
		error("gitstatusd returned exit code " .. code)
	end

	local responses = {}

	f = assert(io.open(".gitstatusd"))
	---@type string
	local raw_response = f:read("a")
	f:close()
	os.remove(".gitstatusd")

	for response in raw_response:gsub("\30$", ""):gmatch("([^\31]*)") do
		responses[#responses + 1] = response
	end

	return {
		request_id = responses[1],
		is_git_repo = responses[2] == "1",
		path = non_empty(responses[3]),
		commit_hash = non_empty(responses[4]),
		branch_name = non_empty(responses[5]),
		upstream_branch_name = non_empty(responses[6]),
		remote_name = non_empty(responses[7]),
		remote_url = non_empty(responses[8]),
		action = non_empty(responses[9]),
		indexed_files = tonumber(responses[10]),
		staged_changes = tonumber(responses[11]),
		unstaged_changes = tonumber(responses[12]),
		conflicted_changes = tonumber(responses[13]),
		untracked_files = tonumber(responses[14]),
		commits_ahead = tonumber(responses[15]),
		commits_behind = tonumber(responses[16]),
		stashes = tonumber(responses[17]),
		tag = non_empty(responses[18]),
		unstaged_staged_deleted_files = tonumber(responses[19]),
		staged_new_files = tonumber(responses[20]),
		staged_deleted_files = tonumber(responses[21]),
		push_remote_name = non_empty(responses[22]),
		push_remote_url = non_empty(responses[23]),
		push_commits_ahead = tonumber(responses[24]),
		push_commits_behind = tonumber(responses[25]),
		skip_worktree_files = tonumber(responses[26]),
		assume_unchanged_files = tonumber(responses[27]),
		commit_message_encoding = non_empty(responses[28]),
		short_commit_message = non_empty(responses[29]),
	}
end

return git
