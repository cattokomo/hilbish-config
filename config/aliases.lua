local aliases = {
  ["ns"] = "nix-shell --command $SHELL",
  ["ls"] = "eza --color --icons -F --hyperlink",
  ["L"] = "ls --git-ignore",
  ["tree"] = "ls -T",
  ["T"] = "L -T",
}

for i, v in pairs(aliases) do
  hilbish.aliases.add(i, v)
end
