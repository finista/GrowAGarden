export type Rarity = {
    name: string,
    color: Color3 | () -> (Color3),
}

export type FruitConfig = {
    name: string;
    relevantSeedType: string; 
    weight: number;
    costPerKg: number;
    isMutated: boolean;
    rarity: Rarity;
}

export type SeedViewportConfig = {
    basePart: BasePart?;
    offset: Vector3?;
    distance: number;
    animationAngle: number;
    animationSpeed: number;
    mainLoop: ((delta: number, model: Model) -> ())?
}

return {}