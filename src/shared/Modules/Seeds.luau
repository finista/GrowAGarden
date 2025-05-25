--!strict
local shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")

local enums = require(shared:WaitForChild("Modules"):WaitForChild("Enums"))
local seedTypes = require(shared:WaitForChild("Types"):WaitForChild("Seed"))

local seeds = {} :: {[string]: seedTypes.SeedData}

seeds.Carrot = {
    name = "Carrot",
    description = "A regular carrot",
    rarity = enums.SeedRarities.Common
}

return seeds