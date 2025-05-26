--!strict
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()

local shared = replicatedStorage:WaitForChild("Shared")

local tweenModule = require(shared:WaitForChild("Modules"):WaitForChild("Utils"):WaitForChild("TweenModule"))
local types = require(shared:WaitForChild("Types"):WaitForChild("PlantViewer"))
local seeds = require(shared:WaitForChild("Modules"):WaitForChild("Seeds"))
local constants = require(shared:WaitForChild("Modules"):WaitForChild("Constants"))

local plantViewer = {} :: types.PlantViewerImpl
plantViewer.__index = plantViewer

function plantViewer:ResetUI()
	self.UI.Parent = nil
	self.UI.Adornee = nil :: any

	self.plantText.Position = UDim2.new(0, -10, 0, 0)
	self.growthText.Position = UDim2.new(0, -10, 0.5, 0)

	self.plantText.TextTransparency = 1
	self.growthText.TextTransparency = 1

	if self.targetChangeConnection then
		self.targetChangeConnection:Disconnect()
	end

	if self.colorConnection then
		self.colorConnection:Disconnect()
	end

	for _, tween in pairs(self.tweens) do
		tween:Cancel()
	end
	table.clear(self.tweens)
end

function plantViewer:UpdateUI()
	if not self.currentPlant then
		return
	end

	local growthProgress = self.currentPlant:GetAttribute(constants.PLANT_GROWTH_ATTRIB) :: number?
	self.growthText.Text = `{growthProgress or "?"}% grown`
end

function plantViewer:TweenInUI()
	table.insert(
		self.tweens,
		tweenModule.MultiTween(
			self.plantText,
			"TextTransparency",
			0,
			0.2,
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Sine
		)
	)
	table.insert(
		self.tweens,
		tweenModule.MultiTween(
			self.plantText,
			"Position",
			UDim2.new(0, 0, 0, 0),
			0.2,
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Sine
		)
	)

	table.insert(
		self.tweens,
		tweenModule.MultiTween(
			self.growthText,
			"TextTransparency",
			0,
			0.2,
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Sine
		)
	)
	table.insert(
		self.tweens,
		tweenModule.MultiTween(
			self.growthText,
			"Position",
			UDim2.new(0, 0, 0.5, 0),
			0.2,
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Sine
		)
	)
end

function plantViewer:SetTarget(target)
	local plantType = target:GetAttribute(constants.PLANT_SEED_ATTRIB) :: string
	local seedData = seeds[plantType]

	if not seedData then
		return
	end

	self:ResetUI()
	self.currentPlant = target

	self.UI.Parent = player:WaitForChild("PlayerGui")
	self.UI.Adornee = target

	self.plantText.Text = seedData.name
	self:UpdateUI()

	if typeof(seedData.rarity.color) == "function" then
		self.colorConnection = runService.RenderStepped:Connect(function()
			local color = seedData.rarity.color()
			self.plantText.TextColor3 = color
		end)
	else
		self.plantText.TextColor3 = seedData.rarity.color
	end

    self.targetChangeConnection = target.Changed:Connect(function()
        self:UpdateUI()
    end)

	self:TweenInUI()
end

function plantViewer.New()
	local self = setmetatable({}, plantViewer)

	self.UI = replicatedStorage:WaitForChild("Prefabs"):WaitForChild("PlantViewUI"):Clone()
	self.UI.Enabled = true

	self.plantText = self.UI:WaitForChild("Plant")
	self.growthText = self.UI:WaitForChild("GrowthProgress")

	self.currentPlant = nil
	self.tweens = {}

	self.targetChangeConnection = nil
	self.colorConnection = nil

	self.mouseConnection = runService.Heartbeat:Connect(function()
		local target = mouse.Target
		if not target or not target.Parent:HasTag(constants.PLANT_TAG) then
            if self.currentPlant then
                self:ResetUI()
                self.currentPlant = nil
            end

			return
		end

        if self.currentPlant == target.Parent then
            return
        end

		self:SetTarget(target.Parent)
	end)

	return self
end

return plantViewer
