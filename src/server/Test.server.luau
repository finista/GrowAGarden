local players = game:GetService("Players")

local gardenManager = require(script.Parent.Modules.Classes.GardenManager).New(workspace:WaitForChild("Garden"))
local player = players:GetPlayers()[1] or players.PlayerAdded:Wait()

gardenManager:SetOwner(player)

game.ReplicatedStorage
    :WaitForChild("Remotes")
    :WaitForChild("Garden")
    :WaitForChild("Sell").OnServerEvent:Connect(function(plr: Player, tool: Tool)
        if not tool or not tool:GetAttribute("value") then
            return
        end

        if tool.Parent ~= plr.Character and tool.Parent ~= plr.Backpack then
            return
        end

        local value = tool:GetAttribute("value")
        local leaderstats = plr:WaitForChild("leaderstats")
        
        leaderstats:WaitForChild("Points").Value += value
        tool:Destroy()
    end)