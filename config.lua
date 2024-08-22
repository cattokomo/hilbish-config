hilbish.opts = {
  autocd = true,
  history = true,
  greeting = false,
  motd = false,
  fuzzy = true,
  notifyJobFinish = true,
}

hilbish.runnerMode("hybridRev")

local warna = require("warna")
local ufs = require("utils.fs")

local f = warna.format

local function fetchfile(n)
  return "'" .. fs.join(hilbish.userDir.config, "hilbish", "fetch." .. n) .. "'"
end

if
  not os.getenv("IN_NIX_SHELL")
  and hilbish.which("fastfetch")
  and hilbish.which("chafa")
  and not pcall(fs.stat, fetchfile("bin"))
  and os.execute("chafa --view-size=80x25 " .. fetchfile("jpg") .. ">" .. fetchfile("bin"))
then
  local flags = table.concat({
    "-c",
    "neofetch",
    "--raw",
    fetchfile("bin"),
    "--logo-width",
    "39",
    "--logo-height",
    "24",
  }, " ")
  os.execute("fastfetch " .. flags)
end

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
  if input == "exec " .. os.getenv("SHELL") then
    os.setenv("SHLVL", "0")
  end
end)

bait.catch("cd", function(pwd)
  local oldpwd = ufs.normalize(os.getenv("OLDPWD"))
  pwd = ufs.normalize(hilbish.cwd())
  print((f("%{underl}Changing directory from %s → %s")):format(oldpwd, pwd))
  os.execute("eza --color --icons -F --hyperlink " .. pwd)
end)

local envs = {
  EDITOR = hilbish.which("hx"),
  PAGER = hilbish.which("moar"),
}

for i, v in pairs(envs) do
  os.setenv(i, tostring(v))
end
