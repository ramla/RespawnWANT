RecoverableLevels = Recoverable:Derive("Levels");

function RecoverableLevels:Update(player)
    self.Content = {};

    local perks = PerkFactory.PerkList;

    for i = 0, perks:size() - 1 do
        local perk = perks:get(i);
        local level = player:getPerkLevel(perk);

        self.Content[perk:getName()] = level;
    end
end

function RecoverableLevels:Recover(player)
    for perkName, targetLevel in pairs(self.Content) do
        local perk = PerkFactory.getPerkFromName(perkName);

        while player:getPerkLevel(perk) < targetLevel do
            player:LevelPerk(perk, false);
        end

        while player:getPerkLevel(perk) > targetLevel do
            player:LoseLevel(perk);
        end

        player:getXp():setXPToLevel(perk, targetLevel);
    end
end