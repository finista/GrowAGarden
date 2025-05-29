export type GardenManagerImpl = {
    __index: GardenManagerImpl;
    New: (plot: Model) -> (GardenManager);
    SetOwner: (self: GardenManager, player: Player) -> ();
    PlantSeed: (self: GardenManager, seedType: string, target: CFrame) -> ();
    RemovePlant: (self: GardenManager, plant: string) -> ();
}

export type GardenManager = typeof(setmetatable({} :: {
    plot: Model;
    owner: Player?;
    plants: {[string]: any};
    plantSeedConnection: RBXScriptConnection?;
}, {} :: GardenManagerImpl))

return {}