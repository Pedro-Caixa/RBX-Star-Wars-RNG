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

local function formatTime(seconds)
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local remainingSeconds = seconds % 60
    
    local formattedTime = ""
    if days > 0 then
        formattedTime = formattedTime .. days .. "d:"
    end
    if hours > 0 or days > 0 then
        formattedTime = formattedTime .. hours .. "h:"
    end
    if minutes > 0 or hours > 0 or days > 0 then
        formattedTime = formattedTime .. minutes .. "m:"
    end
    formattedTime = formattedTime .. remainingSeconds .. "s"
    
    return formattedTime
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
			Replica:ListenToChange("TotalRolls", function(NewValue, OldValue)
				local checkstat = leaderstats and leaderstats:FindFirstChild("⭐ Rolls")
				checkstat.Value = NewValue --IMPORTANT
			end)	
			Replica:ListenToChange("TotalTimeSpent", function(NewValue, OldValue)
				local timeStat = leaderstats and leaderstats:FindFirstChild("🕒 Time Spent")
				timeStat.Value = formatTime(NewValue) --IMPORTANT
			end)
		end)
		--Set player data on join game
		PlayerDataManager:GetPlayerProfile(Player):andThen(function(Profile)
			totalRoll.Value = Profile.Data.TotalRolls
		end)
	end)
	
end

Players.PlayerAdded:Connect(function(plr)
	SetupPlayer(plr)
end)