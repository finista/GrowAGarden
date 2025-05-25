--!strict
local replicatedStorage = game:GetService("ReplicatedStorage")

local shared = replicatedStorage:WaitForChild("Shared")
local seedData = require(shared:WaitForChild("Modules"):WaitForChild("Seeds"))

local remotes = replicatedStorage:WaitForChild("Remotes")
local plantSeedRemote: RemoteEvent = remotes:WaitForChild("PlantSeed")

local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()

return function(tool: Tool)
    local seedType = tool:GetAttribute("SeedType") :: string
    if not seedType or not seedData[seedType] then
        warn(`Failed to load tool {tool.Name} because seedType is missing or doesnt exist.`)
        return
    end

    tool.Activated:Connect(function()
        plantSeedRemote:FireServer(seedType, mouse.Hit)
    end)
end