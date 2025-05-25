export type GardenManagerImpl = {
    __index: GardenManagerImpl;
    New: (plot: Model) -> (GardenManager);
    SetOwner: (self: GardenManager, player: Player) -> ();
    PlantSeed: (self: GardenManager, seedType: string, target: CFrame) -> ();
}

export type GardenManager = typeof(setmetatable({} :: {
    plot: Model;
    owner: Player?;
    seeds: {any};
    plantSeedConnection: RBXScriptConnection?;
}, {} :: GardenManagerImpl))

return {}