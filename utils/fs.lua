local function normalize(path)
  return path:gsub("^(/home/([^/]*))", function(c1, c2)
    if c2 == hilbish.user then
      return "~"
    else
      return "~" .. c2
    end
  end)
end

return {
  normalize = normalize,
}
