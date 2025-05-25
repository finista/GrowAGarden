--!strict
local storage = game:GetService("ServerStorage")

local server = game:GetService("ServerScriptService").Server
local shared = game:GetService("ReplicatedStorage").Shared

local plantTypes = require(server.Types.Plant)
local utils = require(server.Modules.Utils.General)

local plant = require(server.Modules.Classes.Plant)
local seeds = require(shared.Modules.Seeds)

local carrot = {} :: plantTypes.PlantImpl
carrot.__index = carrot
setmetatable(carrot :: any, plant)

function carrot:Grow(amount)
	self.growthProgress = math.clamp(self.growthProgress + amount, 0, 100)

    local mult = 1 - self.growthProgress / 100
    self.data.model:PivotTo(CFrame.new(self.origin) 
        * CFrame.Angles(0, math.rad(self.orientationOffset), 0) * CFrame.new(0, -2.6 * self.size  * mult, 0)
    )
end

function carrot.New(config)
	local self = plant.New(config)
	setmetatable(self :: any, carrot)

	self.seedData = seeds.Carrot

    self.growthRate = 25
    self.growthDelay = 2.5

	self.data.model = storage.Fruits.Carrot:Clone()
	self.data.model.Parent = self.plot:FindFirstChild("Fruits")

	self.data.model:PivotTo(CFrame.new(self.origin) 
        * CFrame.Angles(0, math.rad(self.orientationOffset), 0) * CFrame.new(0, -2.6 * self.size, 0)
    )
    utils.scaleModel(self.data.model, self.size)

	coroutine.resume(self.growthCoroutine)

	return self
end

return carrot
