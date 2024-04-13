local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local PlayerDataManager = require(game:GetService("ServerScriptService").Data.PlayerDataManager)

local RemoteManager = require(ReplicatedFirst.Modules.RemoteManager.init)

RemoteManager:Get('RemoteFunction', "HideServerGUI"):Connect(function(Player)
    local PlayerUi = Player.PlayerGui
    PlayerUi.Main_UI.Enabled = false
    PlayerUi.Main_UI.RollFrame.Visible = false
	PlayerUi.Main_UI.SideFrame.Visible = false
    PlayerUi.Main_UI.Inventory.Visible = false
    PlayerUi.Main_UI.AnimationFrame.Visible = false
end)    

RemoteManager:Get("RemoteFunction", "UpdateTimer"):Connect(function(Player)
    PlayerDataManager:GiveTime(Player, 1)
end)