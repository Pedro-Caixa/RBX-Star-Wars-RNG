local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Gui = game:GetService("StarterGui")

local SoundLibrary = Gui.Sounds

local Component = require(ReplicatedStorage.Packages.component)

local Button = Component.new({
    Tag = "GenericButton",
})

function Button:GetColor()
    --
end

function Button:Construct()
    self.Type = self.Instance:GetAttribute("Type") or "Normal"
    self.Sound = self.Instance:GetAttribute("Sound")

    self._mover = self.Instance:FindFirstChild("Holder")
	self._startSize = self._mover.Size

    local background = self._mover:FindFirstChild("Background")
	local isAnImage = background:IsA("ImageLabel") or background:IsA("ImageButton")

    self.Color = self._mover.Background.uIGradient

	if background and isAnImage then
		self._background = background
	end
    self.TypeChangedConnection = self.Instance:GetAttributeChangedSignal("Type"):Connect(function()
        self:UpdateAppearance()
    end)

    self.Text = self._mover.TextLabel
    self.isHovering = false
end

function Button:UpdateAppearance()
    self.Type = self.Instance:GetAttribute("Type") or "Normal"

    if self.Type == "Confirm" then
        self.Color.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#3cff01")),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(247, 247, 247)),
          })
        self.Text.TextColor3 = Color3.fromRGB(0, 70, 11)
    elseif self.Type == "Unequip" then
        self.Color.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 27, 27)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 27, 27)),
          })
        self.Text.TextColor3 = Color3.fromRGB(255, 255, 255)
        self.Text.Text = "Unequip"
    elseif self.Type == "Regular" then
        self.Color.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
          })
        self.Text.TextColor3 = Color3.fromRGB(255, 255, 255)
    elseif self.Type == "BlueRegular" then
        self.Color.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 140, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 140, 255)),
        })
        self.Text.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

function Button:AddToV(addNumber: number)
	if not self._background then
		return
	end

	addNumber = addNumber / 255


end

function Button:ScaleSize(newScale: number)
	local newSize = UDim2.new(
		self._startSize.X.Scale * newScale,
		self._startSize.X.Offset * newScale,
		self._startSize.Y.Scale * newScale,
		self._startSize.Y.Offset * newScale
	)

	local tween =
		TweenService:Create(self._mover, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			Size = newSize,
		})

	tween:Play()
end


function Button:Start()
    self:UpdateAppearance()
    self.Instance.MouseEnter:Connect(function()
        if self.Sound then
        Gui.Sounds.Hover:Play()
        end
        self:ScaleSize(1.05)
		self:AddToV(100)
    end)
    self.Instance.MouseLeave:Connect(function()
		self:ScaleSize(1)
		self:AddToV(0)
	end)

    self.Instance.MouseButton1Down:Connect(function()
		self:ScaleSize(0.95)
	end)

	self.Instance.MouseButton1Up:Connect(function()
		self:ScaleSize(1.05)
	end)

    self.Instance.Activated:Connect(function()
        if self.Sound then
            Gui.Sounds.Click:Play()
        end	
    end)
end

return Button
