commander.register("lua!", function(_, sink)
  assert(load(sink["in"]:readAll()))()
end)
