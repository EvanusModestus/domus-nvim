-- Features Layer
-- Custom systems loaded after plugins

-- MOTD (Message of the Day)
local motd_ok, motd = pcall(require, "domus.features.motd")
if motd_ok then
    motd.init()
end
