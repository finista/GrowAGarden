local shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local enumTypes = require(shared:WaitForChild("Types"):WaitForChild("Enums"))

export type SeedData = {
    name: string;
    description: string;
    rarity: enumTypes.Rarity;
}

export type PlantData = {
    name: string;
    description: string;
    rarity: enumTypes.Rarity;
}

return {}