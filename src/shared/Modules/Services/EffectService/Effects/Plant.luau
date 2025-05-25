--!strict
local replicatedStorage = game:GetService("ReplicatedStorage")
local debris = game:GetService("Debris")

local plantEffect = replicatedStorage:WaitForChild("Prefabs"):WaitForChild("PlantEffect") :: Part
local tweenModule = require(
	replicatedStorage:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Utils"):WaitForChild("TweenModule")
)

local effect = {}
effect.__index = effect

function effect:Run(position: Vector3)
    local effectPart = plantEffect:Clone()

    effectPart.Position = position
    effectPart.Transparency = 1
    effectPart.Size = Vector3.new(0.133, 1.772, 1.772)
    effectPart.Parent = workspace
    
    debris:AddItem(effectPart, 5.1)

    local plantSound = effectPart:WaitForChild("Sound") :: Sound
    plantSound:Play()

    tweenModule.MultiTween(
        effectPart, "Size",
        Vector3.new(0.133, 1.392, 1.579), .3,
        Enum.EasingDirection.Out, Enum.EasingStyle.Quad
    )

    tweenModule.MultiTween(
        effectPart, "Transparency",
        0, .3,
        Enum.EasingDirection.Out, Enum.EasingStyle.Sine
    )

    task.wait(4)

    tweenModule.MultiTween(
        effectPart, "Size",
        Vector3.new(0.133, 1.772, 0.893), 1,
        Enum.EasingDirection.Out, Enum.EasingStyle.Quad
    )

    tweenModule.MultiTween(
        effectPart, "Transparency",
        1, 1,
        Enum.EasingDirection.Out, Enum.EasingStyle.Sine
    )
end

function effect.New()
    local self = setmetatable({}, effect)
    return self
end

return effect