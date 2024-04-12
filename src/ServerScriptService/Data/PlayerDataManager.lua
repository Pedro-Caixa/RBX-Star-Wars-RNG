--//Services
local Replicated = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = Replicated:WaitForChild('Modules')
local Players = game:GetService("Players")

local ReplicaService = require(Replicated.Modules.Replica.ReplicaServiceListeners)
local ProfileService =  require(ReplicatedStorage.Packages.profileservice)
local Promise = require(Modules.promise)

--//Variables
local ProfileTemplate = {
    TotalRolls = 0,
    Luck = 0,
    Items = {},
    TimesLogIn = 0,
    TotalTimeSpent =0,
}
local Profiles = {}
local Replicas = {}
local PlayerProfileClassToken = ReplicaService.NewClassToken("PlayerData")
local ProfileStore = ProfileService.GetProfileStore("PlayerData", ProfileTemplate)

local PlayerDataManager = {}

--//Functions
function PlayerDataManager:GetPlayerDataReplica(Player: Player)
	return Promise.new(function(Resolve, Reject)
		assert(typeof(Player) == "Instance" and Player:IsDescendantOf(Players), "Value passed is not a valid player")

		if not Profiles[Player] and not Replicas[Player] then
			repeat 
				if Player and Player:IsDescendantOf(Players) then
					wait()
				else
					Reject("Player left the game")
				end
			until Profiles[Player] and Replicas[Player]
		end

		local Profile = Profiles[Player]
		local Replica = Replicas[Player]
		if Profile and Profile:IsActive() then
			if Replica and Replica:IsActive() then
				Resolve(Replica)
			else
				Reject("Replica did not exist or wasn't active")

			end
		else
			Reject("Profile did not exist or wasn't active")
		end
	end)
end

function PlayerDataManager:GetPlayerProfile(Player: Player)
	return Promise.new(function(Resolve, Reject)
		assert(typeof(Player) == "Instance" and Player:IsDescendantOf(Players), "Value passed is not a valid player")

		if not Profiles[Player] and not Replicas[Player] then
			repeat 
				if Player and Player:IsDescendantOf(Players) then
					wait()
				else
					Reject("Player left the game")
				end
			until Profiles[Player] and Replicas[Player]
		end

		local Profile = Profiles[Player]
		local Replica = Replicas[Player]
		if Profile and Profile:IsActive() then
			if Replica and Replica:IsActive() then
				Resolve(Profile)
			else
				Reject("Replica did not exist or wasn't active")

			end
		else
			Reject("Profile did not exist or wasn't active")
		end
	end)
end


local function PlayerAdded(Player: Player)
	local StartTime = tick()
	local Profile = ProfileStore:LoadProfileAsync("Player_" .. Player.UserId)

	if Profile then
		Profile:AddUserId(Player.UserId)
		Profile:Reconcile()

		Profile:ListenToRelease(function()
			Profiles[Player] = nil
			Replicas[Player]:Destroy()
			Replicas[Player]= nil
			Player:Kick("Profile was released")
		end)

		if Player:IsDescendantOf(Players) == true then
			Profiles[Player] = Profile
			local Replica = ReplicaService.NewReplica({
				ClassToken = PlayerProfileClassToken,
				Tags = {["Player"] = Player},
				Data = Profile.Data,
				Replication = "All"
			})

			Replicas[Player] = Replica
			warn(Player.Name.. "'s profile has been loaded. ".."("..string.sub(tostring(tick()-StartTime),1,5)..")")
		else
			Profile:Release()
		end
	else
		Player:Kick("Profile == nil") 
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(PlayerAdded, player)
end

Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayerRemoving:Connect(function(Player)
	if Profiles[Player] then
		Profiles[Player]:Release()
	end
end)

function PlayerDataManager:GiveRolls(Player, Amount) 
	local profile = Profiles[Player]

    if profile.Data.TotalRolls == nil then 
        profile.Data.TotalRolls = 0
    end
    profile.Data.TotalRolls = profile.Data.TotalRolls + Amount
end


return PlayerDataManager
