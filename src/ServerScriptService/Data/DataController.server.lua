--//Services
local Replicated = game:GetService('ReplicatedStorage')
local Players = game:GetService("Players")

--//Required modules
local PlayerDataManager = require(game:GetService("ServerScriptService").Data.PlayerDataManager)

--//Functions
local function formatNumberWithCommas(number)
	local formattedNumber = tostring(number)
	formattedNumber = formattedNumber:reverse():gsub("(%d%d%d)", "%1,")
	return formattedNumber:reverse():gsub("^,", "")
end

function SetupPlayer(Player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = Player

    local totalRoll = Instance.new("IntValue")
    totalRoll.Name = "⭐ Rolls"
    totalRoll.Value = 0
    totalRoll.Parent = leaderstats

    local totalTimeSpent = Instance.new("StringValue")
    totalTimeSpent.Name = "🕒 Time Spent"
    totalTimeSpent.Value = '00:00:00'
    totalTimeSpent.Parent = leaderstats

	task.delay(.5, function()
		--Detect changes on data
		PlayerDataManager:GetPlayerDataReplica(Player):andThen(function(Replica)		
			Replica:ListenToChange("⭐ Rolls", function(NewValue, OldValue)
				print(Player.Name .. "'s Money has been changed on the server: " .. NewValue)
				local checkstat = leaderstats and leaderstats:FindFirstChild("⭐ Rolls")
				checkstat.Value = NewValue--IMPORTANT
			end)	
		end)

		--Set player data on join game
		PlayerDataManager:GetPlayerProfile(Player):andThen(function(Profile)
			totalRoll.Value = Profile.Data.TotalRolls
			warn(Player.Name .. "'s Data Loaded!")
		end)
	end)
end

Players.PlayerAdded:Connect(function(plr)
	SetupPlayer(plr)
end)