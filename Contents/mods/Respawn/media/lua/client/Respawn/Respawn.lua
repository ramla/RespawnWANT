Respawn = {};

Respawn.Id = "respawn";
Respawn.Name = "Respawn";

Respawn.Recoverables = {};

function Respawn.AddRecoverable(recoverable)
    table.insert(Respawn.Recoverables, recoverable);
end

Respawn.AddRecoverable(RecoverableBoosts);
Respawn.AddRecoverable(RecoverableLevels);
Respawn.AddRecoverable(RecoverableTraits);
Respawn.AddRecoverable(RecoverableOccupation);
