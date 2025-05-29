local server = game:GetService("ServerScriptService").Server
local shared = game:GetService("ReplicatedStorage").Shared

local gardenManagerTypes = require(server.Types.GardenManager)
local seedTypes = require(shared.Types.Plant)

export type PlantConfig = {
    plot: Folder;
    origin: Vector3;
    relativeOffset: Vector3;
} & any

export type PlantImpl = {
    __index: PlantImpl;
    New: (config: PlantConfig, manager: gardenManagerTypes.GardenManager, id: string) -> (Plant);
    Teardown: (self: Plant) -> ();
    GetSaveData: (self: Plant) -> (any);
    LoadSaveData: (self: Plant, saveData: any) -> ();
    Grow: (self: Plant, amount: number) -> ();
    OnFullyGrown: (self: Plant) -> ();
    CreateHarvestPrompt: (self: Plant, fruitType: string) -> (ProximityPrompt);
}

export type Plant = typeof(setmetatable({} :: {
    manager: gardenManagerTypes.GardenManager;
    id: string;
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