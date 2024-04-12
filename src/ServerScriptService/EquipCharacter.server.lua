local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local CharacterFolder = ReplicatedStorage.Characters:GetChildren()
local OverheadUI = require(ReplicatedFirst.Modules.OverheadUI)

local RemoteManager = require(ReplicatedFirst.Modules.RemoteManager.init)
local MorphCharacter = require(ReplicatedFirst.Modules.MorphModule)

local OWN_CHARACTER = ReplicatedStorage.Assets["Idk Guy"]

RemoteManager:Get('RemoteFunction', "UseCharacter"):Connect(function(Player, morph_name)
   for _, folder in ipairs(CharacterFolder) do
        local morphModel = folder:FindFirstChild(morph_name)
    
        if morphModel then
            MorphCharacter(Player.Character, morphModel)
            OverheadUI.CharacterLoaded(Player, morphModel)
            break
        end
    end
end)

RemoteManager:Get('RemoteFunction', "Unequip"):Connect(function(Player)
    MorphCharacter(Player.Character, OWN_CHARACTER)
    OverheadUI.CharacterLoaded(Player, nil)
end)

-- NPC

RemoteManager:Get('RemoteFunction', "UseCharacterNPC"):Connect(function(Player, Character_NPC, Morph)
    MorphCharacter(Character_NPC, Morph)
end)