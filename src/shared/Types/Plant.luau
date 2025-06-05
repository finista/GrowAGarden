local shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local enumTypes = require(shared:WaitForChild("Types"):WaitForChild("General"))

export type SeedShopData = {
    moneyCost: number;
    robuxCost: number;
    productID: number;
    viewportName: string;
}

export type SeedData = {
    name: string;
    description: string;
    rarity: enumTypes.Rarity;
    shopData: SeedShopData;
}

export type PlantData = {
    name: string;
    description: string;
    rarity: enumTypes.Rarity;
}

return {}