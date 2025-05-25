--!strict
local generalUtil = require(script.Parent.General)
local util = {}

function util.ValidateTarget(plot: Model, target: CFrame)
    --Verifies that the given target CFrame is within plot's seed placeable area
    local seedArea = plot:FindFirstChild("SeedArea") :: BasePart
    if not seedArea then
        warn(`Plot {plot.Name} is missing SeedArea part.`)
        return false
    end

    return generalUtil.isPositionInPart(target.Position, seedArea)
end

return util