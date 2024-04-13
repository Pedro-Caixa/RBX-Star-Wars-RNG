local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer:WaitForChild("StarterPlayerScripts")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Blur = game.Lighting.Blur
local Camera = workspace.CurrentCamera
local RunService = game:GetService('RunService')

local RemoteManager = require(ReplicatedFirst.Modules.RemoteManager.init)

local UIComponents = StarterPlayerScripts:WaitForChild("Styles")

local components = {}
local function loadComponents()
	for _, component in ipairs(UIComponents:GetChildren()) do
		if component.Name ~= 'AnimationFrame' then
			components[component.Name] = require(component)
		end
	end
end

RemoteManager:Get('BindableEvent', 'HideUi'):Connect(function(Player)
	local PlayerUi = Player.PlayerGui
	PlayerUi.Main_UI.RollFrame.Visible = false
	PlayerUi.Main_UI.SideFrame.Visible = false
	Blur.Size = 20
	Camera.FieldOfView = 120
end)

RemoteManager:Get('BindableEvent', 'ShowUi'):Connect(function(Player)
	local PlayerUi = Player.PlayerGui
	PlayerUi.Main_UI.RollFrame.Visible = true
	PlayerUi.Main_UI.SideFrame.Visible = true
	PlayerUi.Main_UI.AnimationFrame.Visible = false
	Blur.Size = 0
	Camera.FieldOfView = 70
end)

local coreCall do
	local MAX_RETRIES = 8

	function coreCall(method, ...)
		local result = {}
		for retries = 1, MAX_RETRIES do
			result = {pcall(StarterGui[method], StarterGui, ...)}
			if result[1] then
				break
			end
			RunService.Stepped:Wait()
		end
		return unpack(result)
	end
end

assert(coreCall('SetCore', 'ResetButtonCallback', false))

loadComponents()

while true do 
	RemoteManager:Get('RemoteFunction', "UpdateLeaderboard")()
	RemoteManager:Get("RemoteFunction", "UpdateTimer")()
	wait(1)
end