local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Gui = game:GetService("StarterGui")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local SoundLibrary = Gui.Sounds

local RemoteManager = require(ReplicatedFirst.Modules.RemoteManager.init)

local Component = require(ReplicatedStorage.Packages.component)

local Button = Component.new({
    Tag = "EquipButton",
})


function Button:Construct()
    self.Type = self.Instance:GetAttribute("Type") or "Normal"
    self.Sound = self.Instance:GetAttribute("Sound")
    self.Equiped = false
    self.CharacterToUse = self.Instance.Parent.Name
    self.ButtonText = self.Instance.Holder.TextLabel.Text
    self.BackgroundColor3 = self.Instance.Holder.Background.uIGradient.Color
end

function Button:Start()
    self.Instance.MouseButton1Down:Connect(function()
    if self.Equiped == false then
        self.Equiped = true
        RemoteManager:Get('RemoteFunction', "UseCharacter")(self.CharacterToUse)
        self.Instance:SetAttribute("Type", "Unequip")
    elseif self.Equiped == true then
        self.Equiped = false
        RemoteManager:Get('RemoteFunction', "Unequip")()
        self.Instance:SetAttribute("Type", "BlueRegular")
    end
	end)
 
end

return Button