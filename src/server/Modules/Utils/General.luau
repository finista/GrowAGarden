local utils = {}

function utils.isPositionInPart(position: Vector3, part: BasePart): boolean
    -- Checks whether the given position is inside of a target part

    local partCFrame = part.CFrame
    local partSize = part.Size
    
    local localPos = partCFrame:PointToObjectSpace(position)
    
    local halfSize = partSize / 2
    
    return math.abs(localPos.X) <= halfSize.X and
           math.abs(localPos.Y) <= halfSize.Y and
           math.abs(localPos.Z) <= halfSize.Z
end

function utils.getOffsetFromPart(worldPosition: Vector3, part: BasePart): Vector3
    -- Calculates an offset of the given position relative to a part

    assert(typeof(part) == "Instance" and part:IsA("BasePart"), "Second argument must be a BasePart")
    assert(typeof(worldPosition) == "Vector3", "First argument must be a Vector3")

    local offset: Vector3 = part.CFrame:PointToObjectSpace(worldPosition)
    return offset
end

function utils.getWorldPositionFromOffset(offset: Vector3, part: BasePart): Vector3
    -- Calculates the world position based on offset and part

    assert(typeof(part) == "Instance" and part:IsA("BasePart"), "Second argument must be a BasePart")
    assert(typeof(offset) == "Vector3", "First argument must be a Vector3")

    local worldPosition: Vector3 = part.CFrame:PointToWorldSpace(offset)
    return worldPosition
end

function utils.scaleModel(model: Model, multiplier: number)
    -- Scales the given model based on the multiplier number

    if not model.PrimaryPart then
        warn('Model must have a primary part set to scale it.')
        return
    end

    local primaryCFrame = model.PrimaryPart.CFrame

    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Size = part.Size * multiplier

            local relativeCFrame = primaryCFrame:ToObjectSpace(part.CFrame)
            local scaledRelativeCFrame = CFrame.new(relativeCFrame.Position * multiplier) * relativeCFrame.Rotation
            part.CFrame = primaryCFrame * scaledRelativeCFrame
        end
    end
end

return utils