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
    local randomFolder = CharacterFolder[math.random(1, #CharacterFolder)]
    local characterNames = randomFolder:GetChildren()
    local randomCharacter = characterNames[math.random(1, #characterNames)]

    self.CharacterLabel.Text = randomCharacter.Name
    self.RarityLabel.Text = randomFolder.Name
    self.RarityLabel.TextColor3 = randomFolder:GetAttribute("Color")
    self.ViewPortFrame.LightColor = Color3.fromRGB(0 ,0, 0)
    self.ViewPortFrame.Ambient = Color3.fromRGB(0 ,0, 0)

    RemoteManager:Get('RemoteFunction', "UseCharacterNPC")(self.ViewPortFrame.FunCharacter, randomCharacter)
end

function AnimFrame:GetReal()


    self.CharacterLabel.Text = self.ChoosenCharacter
    self.RarityLabel.Text =  self.CharacterRarity
    self.RarityLabel.TextColor3 = CharacterFolder[self.CharacterRarity]:GetAttribute("Color")
    self.ViewPortFrame.LightColor = randomFolder:GetAttribute("Color")
end

function AnimFrame:Start()
    while true do
        self:RandomizeCharacters()
        wait(0.1) 
    end
end

return AnimFrame