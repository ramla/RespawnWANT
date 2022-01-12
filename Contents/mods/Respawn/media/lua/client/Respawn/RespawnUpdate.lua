function Respawn.UpdatePlayer(player)
    for i, recoverable in ipairs(Respawn.Recoverables) do
        recoverable:Update(player);
    end

    Respawn.SaveUpdate();
end

Events.OnPlayerDeath.Add(Respawn.UpdatePlayer);