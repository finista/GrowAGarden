--!strict
local promptService = game:GetService("ProximityPromptService")
local userInputService = game:GetService("UserInputService")

local shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")

local constants = require(shared:WaitForChild("Modules"):WaitForChild("Constants"))
local types = require(shared:WaitForChild("Types"):WaitForChild("CustomPromptService"))

local promptsFolder = script.Parent:WaitForChild("Prompts")

local customPrompt = {} :: types.PromptServiceImpl
customPrompt.__index = customPrompt

function customPrompt:LoadPrompt(prompt)
    local promptType = prompt:GetAttribute(constants.CUSTOM_PROMPT_TYPE_ATTR)
    if not promptType then
        return
    end
    
    local module = promptsFolder:WaitForChild(promptType)
    if not module then
        warn(`Failed to load prompt {prompt.Name} because prompt type {promptType} doesn't exist.`)
        return
    end

    local success, result = pcall(function()
        return require(module).New(prompt, self.platform) :: types.CustomPrompt
    end)

    if not success then
        warn(`Failed to load {prompt.Name}, error: {result or "No error given."}`)
        return    
    end

    self.loadedPrompts[prompt] = result
end

function customPrompt:CreateHandlerWrapper(methodType)
    return function(prompt: ProximityPrompt, player: Player)
        if prompt.Style ~= Enum.ProximityPromptStyle.Custom then
            return
        end

        local handler = self.loadedPrompts[prompt]
        if not handler then
            return
        end
        
        local success, errorMessage = pcall(handler[methodType], handler, player)
        if not success then
            warn(`Failed to run {methodType} on {prompt.Name}, error: {errorMessage or "No error given."}`)
        end
    end
end

function customPrompt:UnloadPrompt(prompt)
    local handler = self.loadedPrompts[prompt]
    if not handler then
        return
    end

	local success, errorMessage = pcall(handler.Hidden, handler)
	if not success then
		warn(`Failed to hide {prompt.Name}, error: {errorMessage or "No error given."}`)
	end

    self.loadedPrompts[prompt] = nil
end

function customPrompt.New()
    local self = setmetatable({}, customPrompt)

    self.platform = "PC" :: any
    if userInputService.TouchEnabled then
        self.platform = "Mobile"
    elseif userInputService.GamepadEnabled then
        self.platform = "Console"
    elseif userInputService.VREnabled then
        self.platform = "VR"
    end

    self.loadedPrompts = {}

    self.shownConnection = promptService.PromptShown:Connect(function(prompt: ProximityPrompt)
        self:LoadPrompt(prompt)
    end)

    self.hiddenConnection = promptService.PromptHidden:Connect(function(prompt: ProximityPrompt) 
        self:UnloadPrompt(prompt)
    end)

    self.holdBeginConnection = promptService.PromptButtonHoldBegan:Connect(self:CreateHandlerWrapper("HoldBegan"))
    self.holdEndConnection = promptService.PromptButtonHoldEnded:Connect(self:CreateHandlerWrapper("HoldEnded"))

    self.triggerConnection = promptService.PromptTriggered:Connect(self:CreateHandlerWrapper("Triggered"))
    self.triggerEndConnection = promptService.PromptTriggerEnded:Connect(self:CreateHandlerWrapper("TriggerEnded"))

    print("Meow")

    return self
end

return customPrompt