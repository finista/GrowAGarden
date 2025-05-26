local shared = game:GetService("ReplicatedStorage").Shared
local seedTypes = require(shared.Types.Seed)

export type PlantConfig = {
    plot: Folder;
    origin: Vector3;
    relativeOffset: Vector3;
} & any

export type PlantImpl = {
    __index: PlantImpl;
    New: (config: PlantConfig) -> (Plant);
    GetSaveData: (self: Plant) -> (any);
    LoadSaveData: (self: Plant, saveData: any) -> ();
    Grow: (self: Plant, amount: number) -> ();
}

export type Plant = typeof(setmetatable({} :: {
    origin: Vector3;
    plot: Folder;
    relativeOffset: Vector3;
    model: Model?;
    data: any;
    size: number;
    orientationOffset: number;
    growthProgress: number;
    growthSpeed: number;
    growthRate: number;
    growthDelay: number;
    growthCoroutine: thread;
    isGrowing: boolean;
    seedData: seedTypes.SeedData?;
}, {} :: PlantImpl))

return {}