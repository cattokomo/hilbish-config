package.path = package.path .. ";" .. fs.join(hilbish.userDir.config, "hilbish/.libs/?.lua")
local warna = require("warna")
local ufs = require("utils.fs")

local f = warna.format

local greeting = warna.apply("Welcome!", { "bright", "blue" })
if hilbish.which("nerdfetch") then
  local _
  _, greeting = hilbish.run("nerdfetch", false)
end

hilbish.opts = {
  autocd = true,
  history = true,
  greeting = not os.getenv("IN_NIX_SHELL") and greeting or false,
  motd = false,
  fuzzy = true,
  notifyJobFinish = true,
}

hilbish.appendPath({
  fs.join(os.getenv("HOME"), ".local/bin"),
  fs.join(os.getenv("HOME"), ".luarocks/bin"),
})

commander.register("clear", function(_, sink)
  sink.out:write("\27[2J\27[H")
end)

local notFoundHooks = bait.hooks("command.exit")
for _, hook in ipairs(notFoundHooks) do
  bait.release("command.exit", hook)
end

bait.catch("command.preexec", function(input)
  hilbish.history.add(input)
end)

bait.catch("cd", function(pwd)
  local oldpwd = ufs.normalize(os.getenv("OLDPWD"))
  pwd = ufs.normalize(hilbish.cwd())
	print((f"%{underl}Changing directory from %s → %s"):format(oldpwd, pwd))
  os.execute("eza --color --icons -F --hyperlink " .. pwd)
end)

require("plugins.zoxide")
require("config.prompt")
require("config.aliases")
