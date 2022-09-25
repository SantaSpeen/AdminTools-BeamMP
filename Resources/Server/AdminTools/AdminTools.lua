---
--- Created by SantaSpeen.
--- DateTime: 25.09.2022 13:38
---
json = require("json")

-- -- -- -- -- Init Variables -- -- -- -- --

pluginName = "AdminTools"
pluginPath = FS.GetParentFolder(string.gsub(debug.getinfo(1).source,"\\", "/"))
pluginConfigFile = "config.json"

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- Init functions -- -- -- -- --

function log(...)
    print("[".. pluginName .."] " .. tostring(...))
end

function jsonReadFile(path)
    local jsonFile, error = io.open(path,"r")
    if error then
        return nil, error
    end
    local jsonText = jsonFile:read("*a")
    jsonFile:close()
    return json.decode(jsonText), false
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function onInit()
    log("Start init")
    log("Plugin path: " .. pluginPath)
    log("Reading config..")
    local configData = jsonReadFile(pluginConfigFile)
    if configData then
        admins = configData.admins
    end

    log("Wait CommandEngine init..")
    local isCommandEngineReady = false
    while not isCommandEngineReady do
        local Future = MP.TriggerGlobalEvent("CE_isReady")
        while not Future:IsDone() do MP.Sleep(100) end
        local result = Future:GetResults()
        if result[1] == true then isCommandEngineReady = true end
    end

    MP.TriggerGlobalEvent("CE_addCommand", {
            ban = { "banUser", "a", { "ban  <name> [reason]", "Ban user." }},
            unban = { "unbanUser", "a", { "unban <name>", "Unban user." }},
            banlist = { "seeBanList", "a", "See ban list on server."}
        }
    )

    log("Init complete.")
end
