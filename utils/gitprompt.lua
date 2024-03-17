local hilbish = require("hilbish")
local class = require("3rd.30log")

local function git_cmd(args)
    local code, stdout, stderr = hilbish.run("GIT_OPTIONAL_LOCKS=0 command git "..table.concat(args, " "), false)
    if code ~= 0 then
        return false, false, code
    elseif stdout and stderr then
        return
            stdout
                :gsub("^%s+", "")
                :gsub("%s+$", ""),
            stderr
                :gsub("^%s+", "")
                :gsub("%s+$", ""),
            code
    end
end

local GitPrompt = class("GitPrompt", {
    prompt_prefix = "",
    prompt_suffix = "",
    show_upstream = false,
})

function GitPrompt:get_prompt()
    if not git_cmd({ "rev-parse", "--git-dir" })
    or git_cmd({ "config", "--get", "hilbish.hide-info" })
    then
        return ""
    end

    local ref =
        git_cmd({ "symbolic-ref", "--short", "HEAD" }) or
        git_cmd({ "describe", "--tags", "--exact-match", "HEAD" }) or
        git_cmd({ "rev-parse", "--short", "HEAD" })

    local upstream = ""
    if self.show_upstream then
        upstream = " -> " .. git_cmd({ "rev-parse", "--abbrev-ref", "--symbolic-full-name", '"@{upstream}"' })
    end

    return self.prompt_prefix .. ref .. upstream .. self.prompt_suffix
end

return GitPrompt
