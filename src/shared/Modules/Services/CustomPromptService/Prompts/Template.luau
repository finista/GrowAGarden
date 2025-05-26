--!strict
local replicatedStorage = game:GetService("ReplicatedStorage")
-- local promptPresets = replicatedStorage:WaitForChild("Prefabs"):WaitForChild("CustomPrompts")

local shared = replicatedStorage:WaitForChild("Shared")
local types = require(shared:WaitForChild("Types"):WaitForChild("CustomPromptService"))

local customPrompt = {} :: types.CustomPromptImpl
customPrompt.__index = customPrompt

function customPrompt:HoldBegan(_)
    warn(":HoldBegan() not implemented")
end

function customPrompt:HoldEnded(_)
    warn(":HoldEnded() not implemented")
end

function customPrompt:Triggered(_)
    warn(":Triggered() not implemented.")
end

function customPrompt:TriggerEnded(_)
    warn(":TriggerEnded() not implemented.")
end

function customPrompt:Hidden()
    warn(":Hidden() not implemented.")
end

function customPrompt.New(prompt, platform)
    local self = setmetatable({}, customPrompt)
    
    self.prompt = prompt
    self.platform = platform :: any

    return self
end

return customPrompt