local shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local enumTypes = require(shared:WaitForChild("Types"):WaitForChild("Enums"))

export type FruitConfig = {
    name: string;
    relevantSeedType: string; 
    weight: number;
    costPerKg: number;
    isMutated: boolean;
    rarity: enumTypes.Rarity;
}

return {}