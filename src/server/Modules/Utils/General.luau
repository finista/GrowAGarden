local utils = {}

function utils.isPositionInPart(position: Vector3, part: BasePart)
    -- Checks whether the given position is inside of a target part

    local partCFrame = part.CFrame
    local partSize = part.Size
    
    local localPos = partCFrame:PointToObjectSpace(position)
    
    local halfSize = partSize / 2
    
    return math.abs(localPos.X) <= halfSize.X and
           math.abs(localPos.Y) <= halfSize.Y and
           math.abs(localPos.Z) <= halfSize.Z
end

return utils