--!strict
local shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")

local enums = require(shared:WaitForChild("Modules"):WaitForChild("Enums"))
local types = require(shared:WaitForChild("Types"):WaitForChild("Plant"))

local fruits = {} :: {[string]: types.PlantData}

fruits.Carrot = {
    name = "Carrot",
    description = "A regular carrot",
    rarity = enums.SeedRarities.Rainbow
}

return fruits