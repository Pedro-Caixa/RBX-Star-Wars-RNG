local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local LBDataStore = DataStoreService:GetOrderedDataStore("Leaderboard")
local LBTDataStore = DataStoreService:GetOrderedDataStore("TimeLeaderboard")

local PlayerDataManager = require(game:GetService("ServerScriptService").Data.PlayerDataManager)
local RemoteManager = require(ReplicatedFirst.Modules.RemoteManager.init)
local ProfileService =  require(ReplicatedStorage.Packages.profileservice)
local Rarities = require(ReplicatedStorage.Source.RarityService.Rarities)
local Characters = require(ReplicatedStorage.Source.RarityService.Characters)
local OverheadUI = require(ReplicatedFirst.Modules.OverheadUI)

local RarityService = require(ReplicatedStorage.Source.RarityService.MainRarity)

------------------------
-- RNG
------------------------
local function selectRandomItem(items)
    return items[math.random(1, #items)]
end

RemoteManager:Get('RemoteFunction', "StartRNG"):Connect(function(Player, Luck)
    PlayerDataManager:GiveRolls(Player, 1)
    local index = RarityService.chooseIndex(Rarities, Luck)
    local item = selectRandomItem(Characters[index])
    PlayerDataManager:GiveItem(Player, item)
    return item, index
end)

RemoteManager:Get('RemoteFunction', "GetInventoryData"):Connect(function(Player)
    local items = PlayerDataManager:GetInvData(Player)
    return items
end)

RemoteManager:Get('RemoteFunction', "UpdateLeaderboard"):Connect(function(Player)
    LBTDataStore:UpdateAsync(Player.UserId,function(oldVal)
        return tonumber(PlayerDataManager:GetTime(Player))
    end)
    LBDataStore:UpdateAsync(Player.UserId,function(oldVal)
        return tonumber(Player:WaitForChild('leaderstats'):FindFirstChild("⭐ Rolls").Value)--IMPORTANT [UPDATE LEADERBOARD DATA WITH PLAYER FOLDER VALUE]
    end)
end)