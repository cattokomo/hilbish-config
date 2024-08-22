package.path = package.path .. ";" .. fs.join(hilbish.userDir.config, "hilbish/.libs/?.lua")

local config = fs.join(hilbish.userDir.config, "hilbish")

dofile(fs.join(config, "config.lua"))

for _, v in pairs(fs.readdir(fs.join(config, "plugins"))) do
  dofile(fs.join(config, "plugins", v))
end

for _, v in pairs(fs.readdir(fs.join(config, "config"))) do
  dofile(fs.join(config, "config", v))
end
