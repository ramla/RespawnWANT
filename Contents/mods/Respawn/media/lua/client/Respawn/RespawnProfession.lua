local Original_Create = CharacterCreationProfession.create
local Original_SetVisible = CharacterCreationProfession.setVisible
local Profession

local function ModDataInitialised()
    print("isclient?")
    if isClient() then
        Respawn.Sync.LoadRemote()
        print("true: respawn.sync.loadremote")
    else
        print("false: moddata.get")
        Respawn.Data.Stats = ModData.get(Respawn.GetModDataStatsKey()) or {}
    end

    if Respawn.Data.Stats.Traits ~= nil then
        print("respawn.data.stats.traits not nil")
        return true
    else
        print("respawn.data.stats.traits is nil")
        return false
    end
end

local function CreateRespawnTrait(initialised)
    local allTraits = TraitFactory.getTraits()
    if allTraits == nil then
        print("allTraits nil!!! wtf")
    end

    if isClient() then
        Respawn.Sync.LoadRemote()
        print("isclient = true: respawn.sync.loadremote")
    else
        print("isclient = false: moddata.get")
        Respawn.Data.Stats = ModData.get(Respawn.GetModDataStatsKey()) or {}
    end

    local playerTraits = Respawn.Data.Stats.Traits
    if playerTraits ~= nil then
        print("list of playerTraits:")
        for i, trait in ipairs(playerTraits) do
            print(trait)
        end
    end

    if initialised then
        TraitFactory.addTrait(Respawn.Id, Respawn.Name, 0, "Reject zombiehood \n\nSelect a negative trait to gain. If it is mutually exclusive with an existing positive trait, you lose the positive trait instead. If there is an unexpected conflict your selection is ignored and you just gain a random negative trait.", true, false)
        print("moddata initialised: setmutualexclusive to matching playertraits of cost <0 and nonmatching playertraits of cost >0")
        for i = 0, allTraits:size() - 1 do
            local ithTrait = allTraits:get(i):getType()
            print(ithTrait)
            if allTraits:get(i):getCost() < 0 then
                for j, trait in ipairs(playerTraits) do
                    print("handling player trait "..trait)
                    if trait == ithTrait then
                        print("excluding negative trait "..ithTrait)
                        TraitFactory.setMutualExclusive(Respawn.Id, ithTrait)
                    end
                end
            else
                local exclude = true
                for j, trait in ipairs(playerTraits) do
                    print("handling player trait "..trait)
                    if trait == ithTrait then
                        exclude = false
                    end
                end
                if exclude then
                    print("excluding positive trait "..ithTrait)
                    TraitFactory.setMutualExclusive(Respawn.Id, ithTrait)
                else
                    --invert cost
                end
            end
        end
    else
        TraitFactory.addTrait(Respawn.Id, Respawn.Name, 0, "Reject zombiehood \n\nSince you quit before respawning, you either get a random negative trait or lose a random positive one.", true, false)
        if allTraits == nil then
            print("allTraits nil!!! wtf")
        end
        
        for i = 0, allTraits:size() - 1 do
            print(allTraits:get(i):getType())
            print("that's what's printing!")
            TraitFactory.setMutualExclusive(Respawn.Id, allTraits:get(i):getType())
        end
    end
end

local function CreateRespawnProfession()
    local prof
    local initialised = ModDataInitialised()

    if initialised then
        print("moddata initialised")
        prof = ProfessionFactory.addProfession(Respawn.Id, Respawn.Name, "", -1)
    else
        print("moddata not initialised")
        prof = ProfessionFactory.addProfession(Respawn.Id, Respawn.Name, "", 0)
    end
    
    CreateRespawnTrait(initialised)
    prof:addFreeTrait(Respawn.Id)

    return prof
end

local function GetRespawnAvailable()
    local available = Respawn.File.Load(Respawn.AvailablePath)

    return available and available[Respawn.GetUserID()]
end

function CharacterCreationProfession:create()
    Original_Create(self)

    Profession = CreateRespawnProfession()
end

function CharacterCreationProfession:setVisible(visible, joypadData)
    Original_SetVisible(self, visible, joypadData)

    if not visible then
        return
    end

    self:removeRespawnProfession()

    if GetRespawnAvailable() then
        writeLog(Respawn.GetLogName(), "respawn available!")
        self:addRespawnProfession()
    end
end

function CharacterCreationProfession:addRespawnProfession()
    self.listboxProf:insertItem(0, Respawn.Id, Profession)
    self:onSelectProf(Profession)
end

function CharacterCreationProfession:removeRespawnProfession()
    self.listboxProf:removeItem(Respawn.Id)

    self.listboxProf.selected = 1
    self:onSelectProf(self.listboxProf.items[1].item)
end