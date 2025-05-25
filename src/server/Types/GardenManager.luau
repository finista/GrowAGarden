local server = game:GetService("ServerScriptService").Server
local plantTypes = require(server.Types.Plant)

export type GardenManagerImpl = {
    __index: GardenManagerImpl;
    New: (plot: Model) -> (GardenManager);
    SetOwner: (self: GardenManager, player: Player) -> ();
    PlantSeed: (self: GardenManager, seedType: string, target: CFrame) -> ();
}

export type GardenManager = typeof(setmetatable({} :: {
    plot: Model;
    owner: Player?;
    plants: {plantTypes.Plant & any};
    plantSeedConnection: RBXScriptConnection?;
}, {} :: GardenManagerImpl))

return {}