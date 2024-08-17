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

---@type osdate?
local before_exec_time, after_exec_time
bait.catch("command.preexec", function()
  before_exec_time = os.date("*t")
end)

bait.catch("command.exit", function()
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
  state = {
    elapsed = elapsed,
  }
  load_prompt()
  before_exec_time, after_exec_time = nil, nil
end)

load_prompt()
hilbish.multiprompt(C(">>> ", "prompt"))
