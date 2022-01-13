Respawn.SaveFile = "respawn_player_%s.json";

local json = require("json");

function Respawn.SaveUpdate()
    local path = Respawn.GetSaveName();
    local file = getFileWriter(path, true, false);

    local save = {};
    for i, recoverable in ipairs(Respawn.Recoverables) do
        save[recoverable.Type] = recoverable.Content;
    end
    
    file:write(json.stringify(save, false));
    file:close();
end

function Respawn.LoadUpdate()
    local path = Respawn.GetSaveName();
    local file = getFileReader(path, false);
    local line = file:readLine();
    
    local success, save = pcall(json.parse, line);

    if not success then
        return;
    end

    for i, recoverable in ipairs(Respawn.Recoverables) do
        recoverable.Content = save[recoverable.Type];
    end
end

function Respawn.GetSaveName()
    local world = getWorld():getWorld();

    if world == nil or world == "" then
        return nil;
    end

    return string.format(Respawn.SaveFile, world);
end