--!strict
local server = game:GetService("ServerScriptService").Server
local types = require(server.Types.Plant)

local util = require(server.Modules.Utils.Garden)

local plant = {} :: types.PlantImpl
plant.__index = plant

function plant:CreateHarvestPrompt(fruitType)
   local prompt = Instance.new("ProximityPrompt")

   prompt.Name = "HarvestPrompt"
   prompt.MaxActivationDistance = 10
   prompt.Style = Enum.ProximityPromptStyle.Custom
   prompt.RequiresLineOfSight = false

   prompt:SetAttribute("PromptType", "FruitPrompt")
   prompt:SetAttribute("FruitType", fruitType)

   return prompt
end

function plant:OnFullyGrown()
    warn(`Method :OnFullyGrown is not implemeted.`)
end

function plant:Grow(_)
    warn(`Method :Grow is not implemented`)
end

function plant:LoadSaveData(_)
    warn('Method :LoadSaveData is not implemented')
end

function plant:GetSaveData()
    warn('Method :GetSaveData is not implemented')
    return {}
end

function plant:Teardown()
    warn('Method :Teardown is not implemeted')
end

function plant.New(config, manager, id)
    local self = setmetatable({}, plant)

    self.manager = manager
    self.id = id
    self.plot = config.plot

    self.origin = config.origin
    self.relativeOffset = config.relativeOffset

    self.growthProgress = 0
    self.growthSpeed = 1
    self.isGrowing = true
    
    self.size = util.getRandomSizeWithRarity()
    self.orientationOffset = math.random(-360, 360)

    self.growthRate = 1
    self.growthDelay = 1

    self.seedData = nil
    self.model = nil

    --[[
        Had to use a data property for data storing for any child classes
        because Roblox is a pain in the ass with it's class inheritance
    --]]

    self.data = {}

    self.growthCoroutine = coroutine.create(function()
        while task.wait(self.growthDelay) do
            if not self.isGrowing or self.growthProgress >= 100 then
                if self.growthProgress >= 100 then
                    self:OnFullyGrown()
                end

                coroutine.yield()
            end

            self:Grow(self.growthRate)
        end
    end)

    return self
end

return plant