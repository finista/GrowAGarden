--!strict
local shared = game.ReplicatedStorage.Shared

local generalTypes = require(shared.Types.General)
local seeds = require(shared.Modules.Seeds)
local generalUtil = require(script.Parent.General)

local util = {}

function util.validateTarget(plot: Model, target: CFrame): boolean
    --Verifies that the given target CFrame is within plot's seed placeable area
    local seedArea = plot:FindFirstChild("SeedArea") :: BasePart
    if not seedArea then
        warn(`Plot {plot.Name} is missing SeedArea part.`)
        return false
    end

    return generalUtil.isPositionInPart(target.Position, seedArea)
end

function util.verifySeedTypeExists(seedType: string): boolean
    -- Verifies whether the given seed type is contained within the seeds module
    if not seeds[seedType] then
        return false
    end
    return true
end

function util.findSeedByTypeInPlayerInventory(seedType: string, player: Player): Instance?
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

function util.getRandomSizeWithRarity(min: number?, max: number?, lambda: number?): number
    --[[
     Generates a random size from 0.8 to 2
     Where 0.8 is the most common and 2 has around 5% chance of occuring

     Lambda controls how common the max size is. (The bigger lambda is, the rarer max size is)
    ]]


    local _lambda = lambda or 6
    local xMax = 1
    
    local u = math.random()
    
    local x = -math.log(1 - u) / _lambda

    x = math.clamp(x, 0, xMax)
    
    local minSize = min or 0.8
    local maxSize = max or 2.0 
    local size = minSize + (maxSize - minSize) * (x / xMax)
    
    return size
end

function util.createDebugVisual(position: Vector3)
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

function util.generateFruitTool(preset: Tool, size: number): Tool?
    local module = preset:FindFirstChild("Config")
    if not module then
        warn(`{preset.Name} is missing Config module.`)
        return
    end

    local config = require(module) :: generalTypes.FruitConfig
    local data = {
        weight = config.weight * size,
        value = math.floor((config.weight * size) * config.costPerKg),
        mutated = config.isMutated,
    }

    local tool = preset:Clone()
    for name, value in pairs(data) do
        tool:SetAttribute(name, value)
    end

    tool.Name = `[{config.rarity.name}] {config.name} ({generalUtil.formatDecimal(data.weight, 2)} kg)`

    generalUtil.scaleModel(tool:WaitForChild("Main") :: any, size)
    generalUtil.weldInstance(tool, tool:WaitForChild("Handle") :: any)

    generalUtil.setInstanceAnchor(tool, false)

    return tool
end

return util