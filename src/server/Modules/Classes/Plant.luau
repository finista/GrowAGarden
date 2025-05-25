--!strict
local server = game:GetService("ServerScriptService").Server
local types = require(server.Types.Plant)

local plant = {} :: types.PlantImpl
plant.__index = plant

function plant:Grow(_)
    warn(`Method :Grow is not implemented`)
end

function plant:LoadSaveData(_)
    warn('Method :LoadSaveData is not implemented')
end

function plant:GetSaveData()
    warn('Method :GetSaveData() is not implemented')
    return {}
end

function plant.New(config)
    local self = setmetatable({}, plant)

    self.plot = config.plot

    self.origin = config.origin
    self.relativeOffset = config.relativeOffset

    self.growthProgress = 0
    self.growthSpeed = 1
    self.isGrowing = true
    
    self.size = math.random(20, 200) / 100
    self.orientationOffset = math.random(-360, 360)

    self.growthRate = 1
    self.growthDelay = 1

    self.seedData = nil

    --[[
        Had to use a data property for data storing for any child classes
        because Roblox is a pain in the ass with it's class inheritance
    --]]

    self.data = {}

    self.growthCoroutine = coroutine.create(function()
        while task.wait(self.growthDelay) do
            if not self.isGrowing or self.growthProgress >= 100 then
                coroutine.yield()
            end

            self:Grow(self.growthRate)
        end
    end)

    return self
end

return plant