local function cmd_comp(query, ctx, fields)
  local comps, pfx = hilbish.completion.bins(query, ctx, fields)

  local compGroup = {
    items = comps,
    type = "grid",
  }
  return { compGroup }, pfx
end

hilbish.complete("command.sudo", cmd_comp)
hilbish.complete("command.exec", cmd_comp)
