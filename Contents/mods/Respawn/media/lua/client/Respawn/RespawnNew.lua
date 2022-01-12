function Respawn.OnCreatePlayer(id, player)
    if not Respawn.CanRecover(player) then
        return;
    end

    for i, recoverable in ipairs(Respawn.Recoverables) do
        print(recoverable.Type);
        recoverable:Recover(player);
    end
end

function Respawn.CanRecover(player)
    return player:HasTrait(Respawn.Id) and Respawn.Recoverables ~= nil;
end

Events.OnCreatePlayer.Add(Respawn.OnCreatePlayer);