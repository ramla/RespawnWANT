local LoadingPlayer = false

local function LoadPlayer(player)
    if not player:HasTrait(Respawn.Id) then
        return
    end

    --TODO
    --check for possible conflicts: 
    -- -more than one trait?
    -- -pos trait does not match saved pos traits?
    -- -neg trait matches saved neg traits?
    -- -HUGE? check for other mutual exclusivity of selected and existing traits
    --  how are these defined is there a shortcut to check them
    --  if so should it be checked on char creation
    
    -- if true --player has a trait other than respawn.id at this point
    --     then --remove a pos trait or add a random nonconflicting negative
    --     else --randomize a trait or removal of positive
    -- end

    LoadingPlayer = false
    
    for i, recoverable in ipairs(Respawn.Recoverables) do
        recoverable:Load(player)
    end
end

local function OnCreatePlayer(id, player)
    if isClient() then
        Respawn.Sync.LoadRemote()
    else
        Respawn.Data.Stats = ModData.get(Respawn.GetModDataStatsKey()) or {}
    end

    if not player:HasTrait(Respawn.Id) then
        return
    end

    LoadingPlayer = true

    if not isClient() then
        LoadPlayer(player)
    end
end

local function OnReceiveModData(key, modData)
    if not LoadingPlayer or key ~= Respawn.GetModDataStatsKey() or not modData then
        return
    end

    LoadPlayer(getPlayer())
end

Events.OnCreatePlayer.Add(OnCreatePlayer)
Events.OnReceiveGlobalModData.Add(OnReceiveModData)