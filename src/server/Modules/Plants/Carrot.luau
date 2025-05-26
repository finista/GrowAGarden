--!strict
local storage = game:GetService("ServerStorage")

local server = game:GetService("ServerScriptService").Server
local shared = game:GetService("ReplicatedStorage").Shared

local plantTypes = require(server.Types.Plant)
local utils = require(server.Modules.Utils.General)
local constants = require(shared.Modules.Constants)

local plant = require(server.Modules.Classes.Plant)
local seeds = require(shared.Modules.Seeds)

local carrot = {} :: plantTypes.PlantImpl
carrot.__index = carrot
setmetatable(carrot :: any, plant)

function carrot:Grow(amount)
    if not self.model then
        return
    end

	self.growthProgress = math.clamp(self.growthProgress + amount, 0, 100)
    self.model:SetAttribute(constants.PLANT_GROWTH_ATTRIB, self.growthProgress)

    local mult = 1 - self.growthProgress / 100
    self.model:PivotTo(CFrame.new(self.origin) 
        * CFrame.Angles(0, math.rad(self.orientationOffset), 0) * CFrame.new(0, -2.6 * self.size  * mult, 0)
    )
end

function carrot.New(config)
	local self = plant.New(config)
	setmetatable(self :: any, carrot)

	self.seedData = seeds.Carrot

    self.growthRate = 1
    self.growthDelay = 5 / 100

    local model = storage.Plants.Carrot:Clone()
	self.model = model
    
	model.Parent = self.plot:FindFirstChild("Fruits")
	model:PivotTo(CFrame.new(self.origin) 
        * CFrame.Angles(0, math.rad(self.orientationOffset), 0) * CFrame.new(0, -2.6 * self.size, 0)
    )
    utils.scaleModel(model, self.size)

	coroutine.resume(self.growthCoroutine)

	return self
end

return carrot
