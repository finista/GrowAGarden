--!strict
local server = game.ServerScriptService.Server

local types = require(server.Types.GardenManager)
local plantTypes = require(server.Types.Plant)

local remotes = game.ReplicatedStorage:WaitForChild("Remotes")
local plantsFolder = server.Modules.Plants

local gardenUtils = require(server.Modules.Utils.Garden)
local seedUtils = require(server.Modules.Utils.Seed)
local generalUtils = require(server.Modules.Utils.General)

local manager = {} :: types.GardenManagerImpl
manager.__index = manager

function manager:SetOwner(player)
	self.owner = player
end

function manager:PlantSeed(seedType, target)
	if not self.owner then
		return
	end

	if not seedUtils.VerifySeedTypeExists(seedType) then
		warn(`Seed type {seedType} does not exist.`)
		return
	end

	if not plantsFolder:FindFirstChild(seedType) then
		warn(`Cannot find {seedType} in plants folder.`)
		return
	end

	local seedTool = seedUtils.FindSeedByTypeInPlayerInventory(seedType, self.owner)
	if not seedTool or seedTool:GetAttribute("Amount") <= 0 then
		warn("Player doesn't have a SeedTool with the given seedType")
		return
	end

	local plantPlot = nil
	for _, plot in pairs((self.plot:FindFirstChild("Plots") :: Folder):GetChildren()) do
		if gardenUtils.ValidateTarget(plot :: Model, target) then
			plantPlot = plot
			break
		end
	end

	if not plantPlot then
		warn("Seed is outside of the placeable area.")
		return
	end

	for _, plant in pairs(self.plants) do
		local distance = (plant.origin - target.Position).Magnitude
		if distance < 1.5 then
			warn("Seed is too close to another plant.")
			return
		end
	end

	local plantModule = (require(plantsFolder:FindFirstChild(seedType)) :: plantTypes.Plant & any).New({
		plot = self.plot,
		origin = target.Position,
		relativeOffset = generalUtils.getOffsetFromPart(target.Position, plantPlot:FindFirstChild("SeedArea") :: Part),
	})
	table.insert(self.plants, plantModule)

	seedUtils.CreateDebugVisual(target.Position)
	seedTool:SetAttribute("Amount", (seedTool:GetAttribute("Amount") :: number) - 1)

	remotes:FindFirstChild("EffectService"):WaitForChild("RunEffect"):FireAllClients("Plant", target.Position)
end

function manager.New(plot)
	local self = setmetatable({}, manager)

	self.plot = plot

	self.plants = {}
	self.owner = nil

	self.plantSeedConnection = remotes
		:WaitForChild("PlantSeed").OnServerEvent
		:Connect(function(player: Player, seedType: string, target: CFrame)
			if self.owner ~= player then
				return
			end

			self:PlantSeed(seedType, target)
		end)

	return self
end

return manager
