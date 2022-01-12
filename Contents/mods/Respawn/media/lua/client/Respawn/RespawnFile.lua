Respawn.SaveFile = "respawn_player_%s.json";

local json = require("json");

function Respawn.SaveUpdate()
    local save = Respawn.GetSaveName();
    local file = getFileWriter(save, true, false);

    if file == nil then
        return nil;
    end
    
    local str = json.stringify(Respawn.Update, false);
    
    file:write(str);
    file:close();
end

function Respawn.LoadUpdate()
    local save = Respawn.GetSaveName();
    local file = getFileReader(save, false);

    if file == nil then
        return nil;
    end

    return json.parse(file:readLine());
end

function Respawn.GetSaveName()
    local world = getWorld():getWorld();

    if world == nil or world == "" then
        return nil;
    end

    return string.format(Respawn.SaveFile, world);
end