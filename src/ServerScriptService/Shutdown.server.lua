--[[ SERVICES ]]--
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RemoteManager = require(ReplicatedFirst.Modules.RemoteManager.init)

--[[ UI FUNCTION ]]--

local blur = game.Lighting.Blur
local softGui = game.ReplicatedStorage.SoftShutdown

local function AddUI(pl)
	blur.Size = 30
	softGui:Clone().Parent = pl:WaitForChild("PlayerGui")
	local PlayerGui = pl:WaitForChild("PlayerGui")
	local Frame = PlayerGui:WaitForChild("SoftShutdown").Frame
end


--[[ TELEPORT SERVICE ]]--

if (game.VIPServerId ~= "" and game.VIPServerOwnerId == 0) then

	warn("[AXYONIN SHUTDOWN] ▲ Initializing Server!")

	local waitTime = 10

	Players.PlayerAdded:connect(function(player)
		wait(waitTime)
		waitTime = waitTime / 2
		TeleportService:Teleport(game.PlaceId, player)
	end)

	for _,player in pairs(Players:GetPlayers()) do
        RemoteManager:Get('RemoteFunction', "HideServerGUI")(player)
		TeleportService:Teleport(game.PlaceId, player)
		wait(waitTime)
		waitTime = waitTime / 2
	end
else
	game:BindToClose(function()

		local con

		if (#Players:GetPlayers() == 0) then
			return
		end

		if (game:GetService("RunService"):IsStudio()) then
			return
		end

		for i,v in pairs(game.Players:GetChildren()) do
			AddUI(v)
		end

		con = Players.PlayerAdded:connect(function(v)
			wait(1)
			AddUI(v)
		end)

		wait(15) 
		con:Disconnect()

		local reservedServerCode = TeleportService:ReserveServer(game.PlaceId)

		for _,player in pairs(Players:GetPlayers()) do
			TeleportService:TeleportToPrivateServer(game.PlaceId, reservedServerCode, { player })
		end
		Players.PlayerAdded:connect(function(player)
			TeleportService:TeleportToPrivateServer(game.PlaceId, reservedServerCode, { player })
		end)
		while (#Players:GetPlayers() > 0) do
			wait(1)
		end 
		
		for _, player in ipairs(Players:GetPlayers()) do
			RemoteManager:Get('RemoteFunction', "HideServerGUI")(player)
		end


	end)
end