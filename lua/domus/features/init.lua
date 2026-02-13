-- Features Layer
-- Custom systems loaded after plugins

-- MOTD (Message of the Day)
local motd_ok, motd = pcall(require, "domus.features.motd")
if motd_ok then
    motd.init()
end

-- Regex Mastery (optional)
-- Uncomment when migrating regex-mastery module
-- pcall(require, "domus.features.regex-mastery")

-- Captures (optional)
-- Uncomment when migrating capture systems
-- pcall(require, "domus.features.captures")
