local type baitCallback = function(...: any): any...

global record bait
	catch: function(string, baitCallback): nil
	catchOnce: function(string, baitCallback): nil
	hooks: function(string): {baitCallback}
	release: function(string, baitCallback)
	throw: function(string, ...: any): any...
end

local record sink
	autoFlush: function(boolean): nil
	flush: function(): nil
	read: function(): string
	readAll: function(): string
	write: function(string): nil
	writeln: function(string): nil
end

local type commanderCallback = function({string}, sink): integer 

global record commander
	record command
		exec: commanderCallback
	end

	register: function(string, commanderCallback): nil
	deregister: function(string): nil
	registry: function(): {command}
end
