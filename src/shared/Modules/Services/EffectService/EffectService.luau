--!strict
local replicatedStorage = game:GetService("ReplicatedStorage")

local shared = replicatedStorage:WaitForChild("Shared")
local types = require(shared:WaitForChild("Types"):WaitForChild("EffectService"))

local remotes = replicatedStorage:WaitForChild("Remotes"):WaitForChild("EffectService")

local effectService = {} :: types.EffectServiceImpl
effectService.__index = effectService

function effectService:RunEffect(effectType, meta)
	local effect = self.loaded[effectType]
	if not effect then
		warn(`Failed to run effect {effectType} because it doesn't exist.`)
		return
	end

	local success, errorMessage = pcall(function()
		effect:Run(meta)
	end)

	if not success then
		warn(`Failed to run effect {effectType}, error: {errorMessage or "No error given."}`)
	end
end

function effectService:LoadEffects()
	for _, module in pairs(self.effectsFolder:GetChildren()) do
		local success, result = pcall(function()
			return require(module).New() :: any
		end)

		if not success then
			warn(`Failed to load effect module {module.Name}, error: {result or "No error given."}`)
			continue
		end

		self.loaded[module.Name] = result
	end
end

function effectService.New()
	local self = setmetatable({}, effectService)

	self.effectsFolder = script.Parent:WaitForChild("Effects")
	self.loaded = {}

	self:LoadEffects()

	self.effectConnection = remotes:WaitForChild("RunEffect").OnClientEvent:Connect(function(...)
		self:RunEffect(...)
	end)

	self.localEffectConnection = remotes:WaitForChild("RunEffectLocal").Event:Connect(function(...)
		self:RunEffect(...)
	end)

	return self
end

return effectService
