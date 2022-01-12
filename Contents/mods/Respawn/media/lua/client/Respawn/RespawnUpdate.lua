function Respawn.UpdatePlayer(player)
    Respawn.Update =
    {
        Occupation = Respawn.Id,
        Traits = {},
        Levels = {},
        Boosts = {}
    };

    Respawn.UpdateTraits(player);
    Respawn.UpdateLevels(player);
    Respawn.UpdateBoosts(player);
    Respawn.UpdateOccupation(player);

    Respawn.SaveUpdate();
end

function Respawn.UpdateBoosts(player)
    local perks = PerkFactory.PerkList;
    local xp = player:getXp();

    for i = 0, perks:size() - 1 do
        local perk = perks:get(i);
        local boost = xp:getPerkBoost(perk);

        if boost > 0 then
            Respawn.Update.Boosts[perk:getName()] = boost;
        end
    end
end

function Respawn.UpdateLevels(player)
    local perks = PerkFactory.PerkList;

    for i = 0, perks:size() - 1 do
        local perk = perks:get(i);
        local level = player:getPerkLevel(perk);

        if level > 0 then
            Respawn.Update.Levels[perk:getName()] = level;
        end
    end
end

function Respawn.UpdateTraits(player)
    local traits = player:getTraits();

    for i = 0, traits:size() - 1 do
        table.insert(Respawn.Update.Traits, traits:get(i));
    end
end

function Respawn.UpdateOccupation(player)
    Respawn.Update.Occupation = player:getDescriptor():getProfession();
end

Events.OnPlayerDeath.Add(Respawn.UpdatePlayer);