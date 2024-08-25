local type baitCallback = function(...: any): any...

global record bait
	catch: function(string, baitCallback): nil
	catchOnce: function(string, baitCallback): nil
	hooks: function(string): {baitCallback}
	release: function(string, baitCallback)
	throw: function(string, ...: any): any...
end

global record Sink
	autoFlush: function(Sink, boolean): nil
	flush: function(Sink): nil
	read: function(Sink): string
	readAll: function(Sink): string
	write: function(Sink, string): nil
	writeln: function(Sink, string): nil
end

local type commanderCallback = function({string}, Sink): integer

global record commander
	record command
		exec: commanderCallback
	end

	register: function(string, commanderCallback): nil
	deregister: function(string): nil
	registry: function(): {command}
end
