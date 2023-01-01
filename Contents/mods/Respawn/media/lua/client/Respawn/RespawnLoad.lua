local LoadingPlayer = false;

local function LoadPlayer(player)
    if not player:HasTrait(Respawn.Id) then
        return;
    end

    LoadingPlayer = false;
    for i, recoverable in ipairs(Respawn.Recoverables) do
        recoverable:Load(player);
    end
end

local function OnCreatePlayer(id, player)
    print(IsoPlayer:getUniqueFileName());
    if isClient() then
        Respawn.Sync.LoadRemote();
    else
        Respawn.Data.Stats = ModData.get(Respawn.GetModDataStatsKey()) or {};
    end

    if not player:HasTrait(Respawn.Id) then
        return;
    end

    LoadingPlayer = true;

    if not isClient() then
        LoadPlayer(player);
    end
end

local function OnReceiveModData(key, modData)
    if not LoadingPlayer or key ~= Respawn.GetModDataStatsKey() or not modData then
        return;
    end

    LoadPlayer(getPlayer());
end

Events.OnCreatePlayer.Add(OnCreatePlayer);
Events.OnReceiveGlobalModData.Add(OnReceiveModData);