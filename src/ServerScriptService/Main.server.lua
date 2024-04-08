local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local RemoteManager = require(ReplicatedFirst.Modules.RemoteManager.init)
local Rarities = require(ReplicatedStorage.Source.RarityService.Rarities)
local RarityService = require(ReplicatedStorage.Source.RarityService.MainRarity)

local function selectRandomItem(items)
    return items[math.random(1, #items)]
end

RemoteManager:Get('RemoteFunction', "StartRNG"):Connect(function(Player, Luck)
    local index = RarityService.chooseIndex(Rarities, Luck)
    local item = selectRandomItem(Rarities[index])
    return index
end)