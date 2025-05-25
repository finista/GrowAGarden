--!strict
local server = game.ServerScriptService.Server
local types = require(server.Types.GardenManager)

local gardenUtils = require(server.Modules.Utils.Garden)
local seedUtils = require(server.Modules.Utils.Seed)

local remotes = game.ReplicatedStorage:WaitForChild("Remotes")

local manager = {} :: types.GardenManagerImpl
manager.__index = manager

function manager:SetOwner(player)
	self.owner = player
end

function manager:PlantSeed(seedType, target)
	if not seedUtils.VerifySeedTypeExists(seedType) then
		warn(`Seed type {seedType} does not exist.`)
		return
	end

	for _, plot in pairs((self.plot:FindFirstChild("Plots") :: Folder):GetChildren()) do
		if not gardenUtils.ValidateTarget(plot :: Model, target) then
			warn("Seed is outside of the placeable area.")
			return
		end
	end

	local testVisual = Instance.new("Part")
	testVisual.Name = "SeedVisual"
	testVisual.CanCollide = false
	testVisual.Size = Vector3.new(1, 1, 1)
	testVisual.Color = Color3.fromRGB(255, 255, 0)
	testVisual.Anchored = true
	testVisual.Position = target.Position
    testVisual.Transparency = .8
	testVisual.Parent = workspace

	remotes:FindFirstChild("EffectService"):WaitForChild("RunEffect"):FireAllClients(
        "Plant", target.Position
    )

	print("Planted seed or something")
end

function manager.New(plot)
	local self = setmetatable({}, manager)

	self.plot = plot

	self.seeds = {}
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
