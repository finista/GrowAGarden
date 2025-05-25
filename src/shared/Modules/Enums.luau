--!strict
local shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local types = require(shared:WaitForChild("Types"):WaitForChild("Enums"))

local enums = {}

enums.SeedRarities = {
    Common = {
        name = "Common",
        color = Color3.fromRGB(0, 89, 255)
    };
} :: {[string]: types.SeedRarity}

return enums