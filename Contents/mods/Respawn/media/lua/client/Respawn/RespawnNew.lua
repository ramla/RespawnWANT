local Recovers = {};

function Respawn.OnCreatePlayer(id, player)
    if not Respawn.CanRecover(player) then
        return;
    end

    Respawn.RecoverBoosts(player);
    Respawn.RecoverLevels(player);
    Respawn.RecoverTraits(player);
    Respawn.RecoverOccupation(player);
end

function Respawn.CanRecover(player)
    return player:HasTrait(Respawn.Id) and Respawn.Update ~= nil;
end

function Respawn.RecoverBoosts(player)
    local prof = ProfessionFactory.getProfession(Respawn.Id);

    for perkName, boost in pairs(Respawn.Update.Boosts) do
        prof:addXPBoost(PerkFactory.getPerkFromName(perkName), boost);
    end

    player:getDescriptor():setProfessionSkills(prof);
end

function Respawn.RecoverLevels(player)
    for perkName, targetLevel in pairs(Respawn.Update.Levels) do
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

function Respawn.RecoverTraits(player)
    player:getTraits():clear();

    for i, trait in ipairs(Respawn.Update.Traits) do
        player:getTraits():add(trait);
    end
end

function Respawn.RecoverOccupation(player)
    player:getDescriptor():setProfession(Respawn.Update.Occupation);
end

Events.OnCreatePlayer.Add(Respawn.OnCreatePlayer);