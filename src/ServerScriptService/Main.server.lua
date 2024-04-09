local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")

local RemoteManager = require(ReplicatedFirst.Modules.RemoteManager.init)
local ProfileService =  require(ReplicatedStorage.Packages.profileservice)
local Rarities = require(ReplicatedStorage.Source.RarityService.Rarities)
local Characters = require(ReplicatedStorage.Source.RarityService.Characters)
local OverheadUI = require(ReplicatedFirst.Modules.OverheadUI)

local RarityService = require(ReplicatedStorage.Source.RarityService.MainRarity)

local ProfileTemplate = {
    TotalRolls = 0,
    Luck = 0,
    Items = {},
    TimesLogIn = 0,
}

local ProfileStore = ProfileService.GetProfileStore(
    "PlayerData",
    ProfileTemplate
)

local Profiles = {}

local function PlayerAdded(player)
    OverheadUI.CharacterLoaded(player, nil)
    local profile = ProfileStore:LoadProfileAsync("Dev3_Player_" .. player.UserId)
    if profile ~= nil then
        profile:AddUserId(player.UserId) 
        profile:Reconcile() 
        profile:ListenToRelease(function()
            Profiles[player] = nil
            player:Kick()
        end)
        if player:IsDescendantOf(Players) == true then
            Profiles[player] = profile
        else
            profile:Release()
        end
    else
        player:Kick('DataStore Issue, Roblox servers may be down') 
    end 
end

for _, player in ipairs(Players:GetPlayers()) do
    task.spawn(PlayerAdded, player)
end

Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayerRemoving:Connect(function(player)
    local profile = Profiles[player]
    if profile ~= nil then
        profile:Release()
    end
end)

------------------------
-- DATASTORE FUNCTIONS
------------------------

local function GiveRolls(player, amount) 
    local profile = Profiles[player]

    if profile.Data.TotalRolls == nil then 
        profile.Data.TotalRolls = 0
    end
    profile.Data.TotalRolls = profile.Data.TotalRolls + amount
end

local function GiveItem(player, item)
    local profile = Profiles[player]
  
    profile.Data.Items = profile.Data.Items or {}
  
    for itemName, itemCount in pairs(profile.Data.Items) do
      if itemName == item then
        profile.Data.Items[itemName] = itemCount + 1 
        return  
      end
    end
    profile.Data.Items[item] = 1 
  end


  local function ResetPlayerData(player)
    local profile = Profiles[player]
    if profile then
        ProfileStore:WipeProfileAsync("Dev3_Player_" .. player.UserId)
    end
  end

  local function GetInventoryData(player)
    local profile = Profiles[player]    
    if profile then
      return profile.Data.Items or {}  
    else
      return {}  
    end
  end
  
------------------------
-- RNG
------------------------
local function selectRandomItem(items)
    return items[math.random(1, #items)]
end

RemoteManager:Get('RemoteFunction', "StartRNG"):Connect(function(Player, Luck)
    local index = RarityService.chooseIndex(Rarities, Luck)
    local item = selectRandomItem(Characters[index])
    GiveItem(Player, item)
    GiveRolls(Player, 1)
    return item, index
end)

RemoteManager:Get('RemoteFunction', "GetInventoryData"):Connect(function(Player)
    local items = GetInventoryData(Player)
    return items
end)