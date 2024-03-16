local hilbish = require("hilbish")
local class = require("3rd.30log")

local function git_cmd(args)
    local code, stdout, stderr = hilbish.run("GIT_OPTIONAL_LOCKS=0 command git "..table.concat(args, " "), true)
    if code ~= 0 then
        return false, false, code
    else
        return stdout, stderr, code
    end
end

local GitPrompt = class("GitPrompt", {
    prompt_prefix = "",
    prompt_suffix = "",
    
})
