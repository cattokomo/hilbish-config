hilbish.complete("command.sudo", function(query, ctx, fields)
		-- complete for commands

		local comps, pfx = hilbish.completion.bins(query, ctx, fields)

		local compGroup = {

			items = comps, -- our list of items to complete

			type = 'grid' -- what our completions will look like.

		}


		return {compGroup}, pfx
	end)
