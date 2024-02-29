local fs = require "bee.filesystem"

if not DBM_LIBRARIES then
        error("Usage: parameter --dbm_libraries is required")
end

-- debugging why plugin isn't being loaded
-- i bet the canonicalization is the problem, maybe we just get rid of this self-adding logic and make the script add it
local basePath = fs.canonical(CONFIGPATH):parent_path()
local pluginPath = "/home/runner/work/test-gh-actions/test-gh-actions/luals-config/Plugin/Plugin.lua"

print(CONFIGPATH)
print(basePath:string())
print(pluginPath)

local libs = {}
for lib in DBM_LIBRARIES:gmatch("([^,]+)") do
        libs[#libs + 1] = lib
end
libs[#libs + 1] = (basePath / "Definitions"):string()

-- Add ourselves to the list of trusted plugins
-- At first glance this may be a bit surprising that this is possible, but we are already executing code,
-- so I guess the safety check has no meaning anyways if the user opts to run a Lua config file
local trustedPluginsPath = fs.path(LOGPATH) / "TRUSTED"
print(trustedPluginsPath:string())
print(LOGPATH)
local trustedPluginsFile, err = io.open(trustedPluginsPath:string(), "a+")
if not trustedPluginsFile then
        error("Could not write to TRUSTED file: " .. err)
end
local found = false
local empty = true
for line in trustedPluginsFile:lines() do
        empty = false
        if line == pluginPath then
                found = true
                break
        end
end
print(found, empty)
if not found then
        if not empty then
                trustedPluginsFile:write("\n")
        end
        trustedPluginsFile:write(pluginPath)
        print("wrote", pluginPath)
end
trustedPluginsFile:flush()
trustedPluginsFile:close()

return {
        ["Lua.workspace.library"] = libs,
        ["Lua.runtime.version"] = "Lua 5.1",
        ["Lua.runtime.plugin"] = pluginPath,
}
