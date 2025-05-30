--!strict
local player = game:GetService("Players").LocalPlayer
local camera = workspace.CurrentCamera

local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local shared = replicatedStorage:WaitForChild("Shared")
local remotes = replicatedStorage:WaitForChild("Remotes")

local presetsFolder = script.Parent:WaitForChild("Dialoges")
local dialogeEvent = remotes:WaitForChild("RunDialoge") :: RemoteEvent

local constants = require(shared:WaitForChild("Modules"):WaitForChild("Constants"))
local tweenModule = require(shared:WaitForChild("Modules"):WaitForChild("Utils"):WaitForChild("TweenModule"))
local types = require(shared:WaitForChild("Types"):WaitForChild("DialogueService"))

local dialogeService = {} :: types.DialogeServiceImpl
dialogeService.__index = dialogeService

function dialogeService:ClearDialoge()
	for _, obj in pairs(self.main:GetChildren()) do
		if obj:IsA("Frame") then
			obj:Destroy()
		end
	end
end

function dialogeService:ToggleDialoge(state)
	if self.dialogeOpen == state then
		return
	end

	if state then
		self.UI.Parent = player:WaitForChild("PlayerGui")
		self.UI.Adornee = player.Character

		tweenModule.MultiTween(
			camera,
			"FieldOfView",
			constants.DIALOGE_CAMERA_FOV,
			1,
			Enum.EasingDirection.InOut,
			Enum.EasingStyle.Sine
		)
	else
		self.UI.Parent = nil
		self.UI.Adornee = nil :: any

		self:ClearDialoge()
        self:ToggleNPCDialoge(false)

		tweenModule.MultiTween(
			camera,
			"FieldOfView",
			constants.DEFAULT_CAMERA_FOV,
			1,
			Enum.EasingDirection.InOut,
			Enum.EasingStyle.Sine
		)
	end

    self.dialogeOpen = state
	task.wait(1)
end

function dialogeService:NPCSay(content)
    if not self.npc then
        return
    end

    if self.npcTypewriteThread then
        task.cancel(self.npcTypewriteThread)
    end

    local label = self.npcUI:WaitForChild("Main"):WaitForChild("Content") :: TextLabel
    label.Text = ""

    self.npcTypewriteThread = task.spawn(function()
        local delay = .3 / string.len(content)

        for i=1, string.len(content) do
            (self.npcUI:WaitForChild("Main"):WaitForChild("Talk") :: Sound):Play()
            label.Text = string.sub(content, 1, i)

            task.wait(delay)
        end

        self.npcTypewriteThread = nil
    end)
end

function dialogeService:ToggleNPCDialoge(state, npc)
    if not state then
        self.npc = nil

        self.npcUI.Parent = nil
        self.npcUI.Adornee = nil :: any

		if self.npcTypewriteThread then
			task.cancel(self.npcTypewriteThread)
		end

        (self.npcUI:WaitForChild("Main") :: Frame).BackgroundTransparency = 1

        return
    end

    assert(npc, "Missing NPC argument.")

    self.npc = npc

    self.npcUI.Parent = player:WaitForChild("PlayerGui")
    self.npcUI.Adornee = npc;
    (self.npcUI:WaitForChild("Main"):WaitForChild("Content") :: TextLabel).Text = ""

    tweenModule.MultiTween(
        self.npcUI:WaitForChild("Main"), "BackgroundTransparency",
        .8, .5,
        Enum.EasingDirection.InOut, Enum.EasingStyle.Sine
    )

    task.wait(.5)
end

function dialogeService:LoadOption(optionData, index)
	local option = self.optionPreset:Clone()
	option.Name = `Option{index}`
    option.Visible = true

	(option:WaitForChild("Number") :: TextLabel).Text = `#{index}`
	(option:WaitForChild("Description") :: TextLabel).Text = `[{optionData.content}]`

    option.Parent = self.main

	local detector = option:WaitForChild("ClickDetector") :: TextButton

	tweenModule.MultiTween(
		option:WaitForChild("Description"),
		"Position",
		UDim2.new(0.07, 0, 0, 0),
		0.2,
		Enum.EasingDirection.InOut,
		Enum.EasingStyle.Quad
	)

	detector.MouseEnter:Connect(function()
        (option:WaitForChild("Hover") :: Sound):Play()

		tweenModule.MultiTween(
			option,
			"BackgroundTransparency",
			0.6,
			0.2,
			Enum.EasingDirection.InOut,
			Enum.EasingStyle.Quad
		)

		tweenModule.MultiTween(
			option:WaitForChild("Description"),
			"Position",
			UDim2.new(0.07, 25, 0, 0),
			0.2,
			Enum.EasingDirection.InOut,
			Enum.EasingStyle.Quad
		)
	end)

	detector.MouseLeave:Connect(function()
		tweenModule.MultiTween(
			option,
			"BackgroundTransparency",
			0.8,
			0.2,
			Enum.EasingDirection.InOut,
			Enum.EasingStyle.Quad
		)

		tweenModule.MultiTween(
			option:WaitForChild("Description"),
			"Position",
			UDim2.new(0.07, 0, 0, 0),
			0.2,
			Enum.EasingDirection.InOut,
			Enum.EasingStyle.Quad
		)
	end)

    detector.MouseButton1Click:Connect(function()
        if self.db then
            return
        end

        (self.UI:WaitForChild("Click") :: Sound):Play()

        if typeof(optionData.onSelect) == "function" then
            local success, result = pcall(optionData.onSelect, self)
            if not success then
                warn(`Failed to run onSelect, error: {result or "No error given"}`)
                return
            end

            if result then
                self:LoadDialoge(result)
            end
        else
            self:LoadDialoge(optionData.onSelect)
        end
    end)
end

function dialogeService:LoadDialoge(dialoge)
    if not dialoge then
        return
    end

    self.db = true

	if not self.dialogeOpen then
		self:ToggleDialoge(true)
	end
    self:ClearDialoge()

    if dialoge.npcAnswer then
        self:NPCSay(dialoge.npcAnswer)
        task.wait(.3)
    end

    if dialoge.options == "END" then
        task.wait(2)

        self:ToggleDialoge(false)
        self.db = false

        return
    end

    for index, option in pairs(dialoge.options) do
        self:LoadOption(option, index)
        task.wait(.1)
    end

    self.db = false
end

function dialogeService.New()
	local self = setmetatable({}, dialogeService)

	self.db = false
	self.dialogeOpen = false
	self.currentDialogeData = nil
    self.npc = nil

    self.npcUI = replicatedStorage:WaitForChild("Prefabs"):WaitForChild("NpcDialogeUI"):Clone()
	self.UI = replicatedStorage:WaitForChild("Prefabs"):WaitForChild("DialogeUI"):Clone()

	self.main = self.UI:WaitForChild("Main")
	self.optionPreset = self.UI:WaitForChild("Option")

    self.npcTypewriteThread = nil

    self.dialogeRemoteConnection = dialogeEvent.OnClientEvent:Connect(function(presetName: string, npc: Model?)
        if self.dialogeOpen or self.db then
            return
        end

        local preset = presetsFolder:FindFirstChild(presetName)
        if not preset then
            warn(`Couldn't find dialoge preset called {presetName}.`)
            return
        end

        local dialogeData = require(preset) :: types.DialogeConfig
        if not dialogeData.Entrypoint then
            warn(`{presetName} is missing .Entrypoint`)
            return
        end

        self.db = true

        if npc then
            self:ToggleNPCDialoge(true, npc)
        end

        self:LoadDialoge(dialogeData.Entrypoint)
    end)

    self.distanceCheckConnection = runService.Heartbeat:Connect(function()
        if not self.npc or not self.dialogeOpen or self.db then
            return
        end

        if not player.Character or not player.Character.PrimaryPart or not self.npc.PrimaryPart then
            return
        end

        local distance = (self.npc.PrimaryPart.Position - player.Character.PrimaryPart.Position).Magnitude
        if distance >= constants.MAX_DIALOGE_DISTANCE then
            self.db = true
            self:ToggleDialoge(false)
            self.db = false
        end
    end)

	return self
end

return dialogeService
