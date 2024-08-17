bait.catch("cd", function()
  hilbish.run("zoxide add -- '" .. os.getenv("OLDPWD") .. "'")
end)

local cd_cmd = commander.registry().cd.exec

commander.register("z", function(args, sink)
  local s = args[1]
  local ok, stat = pcall(fs.stat, s)
  if #args == 0 then
    return cd_cmd({ "~" })
  elseif #args == 1 and (s == "-" or (ok and stat or {}).isDir) then
    return cd_cmd({ s }, sink)
  end
  local code, out =
    hilbish.run(("zoxide query --exclude '%s' -- %s"):format(hilbish.cwd(), table.concat(args, " ")), false)
  if code == 0 then
    code = cd_cmd({ out })
  end
  return code
end)

commander.register("zi", function(args, sink)
  local out = fs.join(hilbish.cwd(), ".out")
  local ok, code = os.execute("zoxide query --interactive -- " .. table.concat(args, " ") .. ">" .. out)
  if ok then
    local f = io.open(out)
    code = cd_cmd({ f:read("*a") })
    f:close()
  end
  os.remove(out)
  return code
end)
