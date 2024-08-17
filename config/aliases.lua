local aliases = {
  ["ns"] = "nix-shell --command $SHELL",
}

for i, v in pairs(aliases) do
  hilbish.aliases.add(i, v)
end
