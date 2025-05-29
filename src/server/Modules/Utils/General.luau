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

function utils.setInstanceAnchor(instance: Instance, anchored: boolean)
    -- Sets anchored property for all instance descendants
    for _, i in pairs(instance:GetDescendants()) do
        if i:IsA("BasePart") or i:IsA("UnionOperation") then
            i.Anchored = anchored
        end
    end
end

function utils.weldInstance(instance: Instance, target: BasePart)
    -- Welds the instance and all its descendants to target
    if instance:IsA("BasePart") or instance:IsA("UnionOperation") then
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = instance
        weld.Part1 = target
        weld.Parent = target    
    end

    for _, i in pairs(instance:GetChildren()) do
        if i == target then
            continue
        end

        utils.weldInstance(i, target)
    end
end

function utils.formatDecimal(number: number, n: number)
    -- Leaves only n amount of digits after the comma
    local multiplier = 10^n
    return math.floor(number * multiplier + 0.5) / multiplier
end

function utils.generateRandomString(length: number): string
    local characters = "abcdefghiklmopqrsxyz1234567890"
    local result = ""

    for i=1, length do 
        local index = math.random(1, string.len(characters))
        result = result..string.sub(characters, index, index)
    end

    return result
end

return utils