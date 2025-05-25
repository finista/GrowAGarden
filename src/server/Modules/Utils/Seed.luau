--!strict
local shared = game.ReplicatedStorage.Shared
local seeds = require(shared.Modules.Seeds)

local util = {}

function util.VerifySeedTypeExists(seedType: string): boolean
    -- Verifies whether the given seed type is contained within the seeds module
    if not seeds[seedType] then
        return false
    end
    return true
end

function util.FindSeedByTypeInPlayerInventory(seedType: string, player: Player): Instance?
    -- Finds a seed tool in players inventory based on seed type, returns nil if doesn't find anything
    local function validateObj(obj: Instance): boolean
        if obj:IsA("Tool") and obj:HasTag("SeedTool") then
            if obj:GetAttribute("SeedType") == seedType then
                return true
            end
        end

        return false
    end

    for _, obj in pairs(player.Backpack:GetChildren()) do
        if validateObj(obj) then
            return obj
        end
    end

    if player.Character then
        for _, obj in pairs(player.Character:GetChildren()) do 
            if validateObj(obj) then
                return obj
            end
        end
    end

    return nil
end

function util.CreateDebugVisual(position: Vector3)
    -- Creates a yellow 1x1 brick at the given position
    local testVisual = Instance.new("Part")

	testVisual.Name = "SeedVisual"
	testVisual.Position = position

	testVisual.CanCollide = false
	testVisual.Size = Vector3.new(1, 1, 1)
	testVisual.Color = Color3.fromRGB(255, 255, 0)
	testVisual.Anchored = true
    testVisual.Transparency = .8
	
    testVisual.Parent = workspace
end

return util