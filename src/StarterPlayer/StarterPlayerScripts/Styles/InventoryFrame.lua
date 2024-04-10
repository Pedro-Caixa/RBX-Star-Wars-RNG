local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Gui = game:GetService("StarterGui")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local MorphCharacter = require(ReplicatedFirst.Modules.MorphModule)

local CharacterFolder = ReplicatedStorage.Characters:GetChildren()

local SoundLibrary = Gui.Sounds

local Component = require(ReplicatedStorage.Packages.component)
local RemoteManager = require(ReplicatedFirst.Modules.RemoteManager.init)

local AnimFrame = Component.new({
    Tag = "InventoryFrame",
})


function AnimFrame:Construct()
    self.ViewPortFrame = self.Instance.ViewportFrame
    self.ChoosenCharacter = self.Instance.Name
    self.ViewportCharacter = self.ViewPortFrame.FunCharacter
end



function AnimFrame:GetReal()    
    local character_use = nil


    for _, folder in ipairs(CharacterFolder) do
        for _, character in ipairs(folder:GetChildren()) do
            if self.ChoosenCharacter ~= "Template" and  character.Name == self.ChoosenCharacter then
                character_use = character
                break
            end
        end
        if character_use then
            break
        end
    end
    if character_use then 
        print(self.ViewPortFrame.FunCharacter)
        RemoteManager:Get('RemoteFunction', "UseCharacterNPC")(self.ViewPortFrame.FunCharacter, character_use)
    end
end

function AnimFrame:Start()
    self:GetReal()
end

return AnimFrame