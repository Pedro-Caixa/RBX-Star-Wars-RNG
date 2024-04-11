local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerStorage = game:GetService("ServerStorage")

local Cmdr = require(ServerStorage.Packages.Cmdr)
Cmdr:RegisterDefaultCommands()
Cmdr:RegisterHooksIn(script.Parent.Hooks)