local players = game:GetService("Players")

local gardenManager = require(script.Parent.Modules.Classes.GardenManager).New(workspace:WaitForChild("Garden"))
local player = players:GetPlayers()[1] or players.PlayerAdded:Wait()

gardenManager:SetOwner(player)