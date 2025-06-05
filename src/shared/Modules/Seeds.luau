--!strict
local shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")

local enums = require(shared:WaitForChild("Modules"):WaitForChild("Enums"))
local types = require(shared:WaitForChild("Types"):WaitForChild("Plant"))

local seeds = {} :: {[string]: types.SeedData}

seeds.Carrot = {
    name = "Carrot",
    description = "A regular carrot",
    rarity = enums.SeedRarities.Common,
    shopData = {
        moneyCost = 20,
        robuxCost = 5,
        productID = 0,
        viewportName = "Carrot"
    }
}

return seeds