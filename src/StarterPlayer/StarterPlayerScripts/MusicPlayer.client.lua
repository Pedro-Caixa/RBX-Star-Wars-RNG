wait(3)
local Sound = script.Parent.Parent.PlayerGui.CurrentMusic
Sound:Play()

local musicIds = {
    "rbxassetid://17114176671", 
    "rbxassetid://17114193481",
    "rbxassetid://17114379559",
    "rbxassetid://17114384864",
    "rbxassetid://17114408741",
}

local currentIndex = 1

Sound.Ended:Connect(function()
    currentIndex = currentIndex + 1
    if currentIndex > #musicIds then
        currentIndex = 1 
    end
    Sound.SoundId = musicIds[currentIndex]
    Sound:Play()
end)