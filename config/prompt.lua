local warna = require("warna")

local palette = {
  exit_error = "ef476f",
  exit_success = "16b4e9",
  prompt = "b9e9f8",
  username = "48cae4",
  hostname = "ffd166",
  elapsed = "168aad",
  parens = "5ccbf0",
  dir = "8ecae6",
  nix = "7ebae4",
  git = "A6E0AC",
}

-- generate colored text
local function C(s, k, ...)
  return warna.apply(s, { k and "hex:" .. palette[k] or "", ... })
end

local state = {
  elapsed = "",
}

local function load_prompt()
  local prompt = table.concat({
    "\27[2K\n",
    C(os.getenv("IN_NIX_SHELL") and "󱄅 " or "", "nix"),
    C(hilbish.exitCode ~= 0 and tostring(hilbish.exitCode) .. " " or "", "exit_error"),
    C(state.elapsed, "elapsed"),
    C("(", "parens", "bold"),
    C("%u", "username", "bold"),
    " ",
    C("%h", "hostname", "bold"),
    C(")", "parens", "bold"),
    " ",
    C("%d", "dir"),
    "\n",
    C("🢖 ", hilbish.exitCode ~= 0 and "exit_error" or "exit_success"),
  })
  hilbish.prompt(prompt)
end

local function load_rprompt()
  local git = require("utils.git")
  hilbish.prompt(C("...", "git"), "right")
  hilbish.goro(function()
    ---@param num integer?
    ---@param sym string
    ---@param ws boolean?
    ---@param explicit_num boolean?
    ---@return string
    local function format_info(num, sym, ws, explicit_num)
      if num and num > 0 then
        return (ws and " " or "") .. sym .. ((explicit_num or num > 1) and num or "")
      end
      return ""
    end

    local info = git.get_info(tostring(os.time()), hilbish.cwd())

    if not info.is_git_repo then
      return hilbish.prompt("", "right")
    end

    local prompt = table.concat({
      info.branch_name or info.tag or info.commit_hash:sub(1, 7),
      format_info(info.commits_behind, "«", true, true),
      format_info(info.commits_ahead, "»", true, true),
      format_info(info.push_commits_behind, "«‹", true, true),
      format_info(info.push_commits_ahead, "›»", true, true),
      info.action and " " .. info.action or "",
      format_info(info.stashes, "=", true),
      format_info(info.conflicted_changes, "≠"),
      format_info(info.staged_changes, "+"),
      format_info(info.unstaged_changes, "!"),
      -- format_info(info.untracked_files, "?"), -- disable for now
    })

    hilbish.prompt(C(prompt, "git"),"right")
  end)
end

---@type osdate?
local before_exec_time, after_exec_time
bait.catch("command.preexec", function()
  before_exec_time = os.date("*t")
end)

bait.catch("command.exit", function()
  if before_exec_time then
    after_exec_time = os.date("*t")
    local sec, min, hour =
        after_exec_time.sec - before_exec_time.sec,
        after_exec_time.min - before_exec_time.min,
        after_exec_time.hour - before_exec_time.hour
    local elapsed = table.concat({
      hour > 0 and hour .. "h " or "",
      min > 0 and min .. "m " or "",
      sec > 3 and sec .. "s " or "",
    })
  end
  state = {
    elapsed = elapsed or "",
  }
  load_prompt()
  load_rprompt()
  before_exec_time, after_exec_time = nil, nil
end)

load_prompt()
load_rprompt()
hilbish.multiprompt(C(">>> ", "prompt"))
