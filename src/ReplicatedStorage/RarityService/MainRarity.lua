local Module = {}

function Module.chooseIndex(rarity_table, luck)
    local newRarityArray = {}
    
    local totalWeight = 0

    for index, rarity in pairs(rarity_table) do
        local weight = rarity[2]

        local newWeight = weight - luck

        if newWeight < 1 then 
            continue
        end

        local fraction = (1/newWeight)
        totalWeight += fraction

        newRarityArray[index] = {fraction}
    end
    local random = Random.new()
    local rnd = random:NextNumber(0, totalWeight)

    local selectedRarity = "Common"

    local accumulatedWeight = 0

    for index, rarity in pairs(newRarityArray) do 
        accumulatedWeight += rarity[1]

        if rnd <= accumulatedWeight then
            selectedRarity = index
            break
        end
    end
    return selectedRarity
end

return Module