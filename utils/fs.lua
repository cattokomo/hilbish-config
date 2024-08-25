---@param path string
local function normalize(path)
  return (path:gsub("^(/home/([^/]*))", function(_, c2)
    if c2 == hilbish.user then
      return "~"
    else
      return "~" .. c2
    end
  end))
end

return {
  normalize = normalize,
}
