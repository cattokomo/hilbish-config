local BunInstall = fs.join(os.getenv("HOME"), ".bun")
if pcall(fs.stat, BunInstall) then
  os.setenv("BUN_INSTALL", BunInstall)
  hilbish.prependPath(fs.join(BunInstall, "bin"))
end
