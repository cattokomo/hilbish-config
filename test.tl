commander.register("test", function(args: {string}, sink: Sink): integer
	sink:write("a")
end)
