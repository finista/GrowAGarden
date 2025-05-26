--!strict
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

local player = game:GetService("Players").LocalPlayer
local promptPresets = replicatedStorage:WaitForChild("Prefabs"):WaitForChild("CustomPrompts")
local shared = replicatedStorage:WaitForChild("Shared")

local tweenModule = require(shared:WaitForChild("Modules"):WaitForChild("Utils"):WaitForChild("TweenModule"))
local types = require(shared:WaitForChild("Types"):WaitForChild("CustomPromptService"))
local constants = require(shared:WaitForChild("Modules"):WaitForChild("Constants"))
local fruitTypes = require(shared:WaitForChild("Modules"):WaitForChild("Fruits"))

local customPrompt = {} :: types.CustomPromptImpl
customPrompt.__index = customPrompt

function customPrompt:HoldBegan(_)
end

function customPrompt:HoldEnded(_)
end

function customPrompt:Triggered(_)
    tweenModule.MultiTween(
        self.UI, "Size",
        UDim2.new(2.8, 0, 0.9, 0), .05,
        Enum.EasingDirection.InOut, Enum.EasingStyle.Sine
    )
end

function customPrompt:TriggerEnded(_)
    tweenModule.MultiTween(
        self.UI, "Size",
        UDim2.new(3, 0, 1, 0), .05,
        Enum.EasingDirection.InOut, Enum.EasingStyle.Sine
    )
end

function customPrompt:Hidden()
    tweenModule.MultiTween(
        self.UI, "Size",
        UDim2.new(0, 0, 0, 0), .2,
        Enum.EasingDirection.InOut, Enum.EasingStyle.Sine
    )

    task.delay(.2, function()
        self.UI:Destroy()

        if self.colorConnection then
            self.colorConnection:Disconnect()
        end
    end)
end

function customPrompt.New(prompt, platform)
    local self = setmetatable({}, customPrompt)
    
    local fruitType = prompt:GetAttribute(constants.FRUIT_PROMPT_TYPE_ATTR) :: string?
    assert(fruitType, `Prompt is missing {constants.FRUIT_PROMPT_TYPE_ATTR} attribute.`)

    local fruitData = fruitTypes[fruitType]
    assert(fruitData, `Fruit type {fruitType} doesn't exist.`)

    self.UI = promptPresets:WaitForChild("FruitPrompt"):Clone()
    self.main = self.UI:WaitForChild("Main")

    self.platform = platform :: any
    self.prompt = prompt

    self.UI.Size = UDim2.new(0, 0, 0, 0)
    self.UI.MaxDistance = prompt.MaxActivationDistance + 10

    self.main:WaitForChild("Plant").Text = fruitData.name
    self.main:WaitForChild("PromptDescription").Text = prompt.ActionText

    if typeof(fruitData.rarity.color) == "function" then
        self.colorConnection = runService.RenderStepped:Connect(function()
            self.main:WaitForChild("Plant").TextColor3 = fruitData.rarity.color()
        end)
    else
        self.main:WaitForChild("Plant").TextColor3 = fruitData.rarity.color
    end

    if platform == "PC" then
        self.main:WaitForChild("PCKeybind").Visible = true
        self.main.PCKeybind.Text = self.prompt.KeyboardKeyCode.Name
    elseif platform == "Mobile" or platform == "Console" then
        self.main:WaitForChild("ActionImage").Visible = true
        
        if platform == "Console" then
            self.main:WaitForChild("ActionImage").Image = types.gamepadButtonImage[self.prompt.GamepadKeyCode]
        end
    end

    local detector = self.main:WaitForChild("Detector") :: TextButton

    detector.MouseButton1Down:Connect(function()
        prompt:InputHoldBegin()
    end)

    detector.MouseButton1Up:Connect(function()
        prompt:InputHoldEnd()
    end)

    self.UI.Parent = player:WaitForChild("PlayerGui")
    self.UI.Adornee = prompt.Parent

    self.UI.Enabled = true

    tweenModule.MultiTween(
        self.UI, "Size",
        UDim2.new(3, 0, 1, 0), .2,
        Enum.EasingDirection.InOut, Enum.EasingStyle.Sine
    )
    
    return self
end

return customPrompt