RecoverableOccupation = Recoverable:Derive("Occupation");

function RecoverableOccupation:Recover(player)
    player:getDescriptor():setProfession(self.Content);
end

function RecoverableOccupation:Update(player)
    self.Content = player:getDescriptor():getProfession();
end