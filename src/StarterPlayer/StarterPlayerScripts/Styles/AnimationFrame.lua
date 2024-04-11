local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Gui = game:GetService("StarterGui")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local LocalPlayer = Players.LocalPlayer

local MorphCharacter = require(ReplicatedFirst.Modules.MorphModule)

local CharacterFolder = ReplicatedStorage.Characters:GetChildren()

local SoundLibrary = Gui.Sounds

local Component = require(ReplicatedStorage.Packages.component)
local RemoteManager = require(ReplicatedFirst.Modules.RemoteManager.init)

local AnimFrame = Component.new({
    Tag = "AnimationFrameArea",
})


function AnimFrame:Construct()
    self.CardFrame = self.Instance.Frame
    self.CharacterLabel = self.CardFrame.CLabel
    self.RarityLabel = self.CardFrame.RarityName
    self.ViewPortFrame = self.CardFrame.ViewportFrame

    self.ChoosenCharacter = self.CardFrame:GetAttribute("CharacterChoosen")
    self.CharacterRarity = self.CardFrame:GetAttribute("Rarity")
    self.RarityColor = Color3.fromRGB(0, 0, 0)

    self.ViewportCharacter = self.ViewPortFrame.FunCharacter
end

function AnimFrame:RandomizeCharacters()
    self.ChoosenCharacter = self.CardFrame:GetAttribute("CharacterChoosen")
    self.CharacterRarity = self.CardFrame:GetAttribute("Rarity")

    local randomFolder = CharacterFolder[math.random(1, #CharacterFolder)]
    local characterNames = randomFolder:GetChildren()
    local randomCharacter = characterNames[math.random(1, #characterNames)]

    SoundLibrary.RandoClick:Play()
   
    self.CharacterLabel.Text = randomCharacter.Name
    self.RarityLabel.Text = randomFolder.Name
    self.RarityLabel.TextColor3 = randomFolder:GetAttribute("Color")
    self.ViewPortFrame.LightColor = Color3.fromRGB(0 ,0, 0)
    self.ViewPortFrame.Ambient = Color3.fromRGB(0 ,0, 0)
    MorphCharacter(self.ViewPortFrame.FunCharacter, randomCharacter)
end

function AnimFrame:RandomizeCharacterFromRarity(rarity)

    local FolderToUse = nil

    for _, folder in ipairs(CharacterFolder) do
        if folder.Name == rarity then
            FolderToUse = folder
            break
        end
    end

    local characterNames = FolderToUse:GetChildren()
    local randomCharacter = characterNames[math.random(1, #characterNames)]

    SoundLibrary.RandoClick:Play()

    MorphCharacter(self.ViewPortFrame.FunCharacter, randomCharacter)

    self.CharacterLabel.Text = randomCharacter.Name
    self.RarityLabel.Text = FolderToUse.Name
    self.RarityLabel.TextColor3 = FolderToUse:GetAttribute("Color")
    self.ViewPortFrame.LightColor = Color3.fromRGB(0 ,0, 0)
    self.ViewPortFrame.Ambient = Color3.fromRGB(0 ,0, 0)
    MorphCharacter(self.ViewPortFrame.FunCharacter, randomCharacter)

end


function AnimFrame:GetReal()    
    local FolderToUse = nil
    local character_use = nil

    self.CharacterLabel.Text = self.ChoosenCharacter
    self.RarityLabel.Text =  self.CharacterRarity

    for _, folder in ipairs(CharacterFolder) do
        if folder.Name == self.CharacterRarity then
            FolderToUse = folder
            break
        end
    end


    for _, character in ipairs(FolderToUse:GetChildren()) do
        if character.Name == self.ChoosenCharacter then
            character_use = character
            break
        end
    end

    for _, sound in ipairs(SoundLibrary.Rarities:GetChildren()) do
        if sound.Name == self.CharacterRarity then
            sound:Play()
            break 
        end
    end


    self.RarityLabel.TextColor3 = FolderToUse:GetAttribute("Color")
    self.ViewPortFrame.Ambient = Color3.fromRGB(255, 255, 255)
    self.ViewPortFrame.LightColor = FolderToUse:GetAttribute("Color")
    MorphCharacter(self.ViewPortFrame.FunCharacter, character_use)
end

function AnimFrame:Roll() 
    RemoteManager:Get('BindableEvent', 'HideUi')(LocalPlayer)
    for _ = 1, 25 do
        self:RandomizeCharacters()
        wait(0.1) 
    end
    task.wait(0.1)
    for _ = 1, 5 do
        self:RandomizeCharacterFromRarity(self.CharacterRarity)
        wait(0.5) 
    end
    self:GetReal()
    wait(3)
    RemoteManager:Get('BindableEvent', 'ShowUi')(LocalPlayer)
end

function AnimFrame:Start()
    RemoteManager:Get('BindableEvent', 'StartRolling'):Connect(function(Player)
        self:Roll()
      end)
end

return AnimFrame