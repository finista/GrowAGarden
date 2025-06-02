export type PlayerSaveData = {
    leaderstats: LeaderstatsInitialData;
}

export type LeaderstatsInitialData = {[string]: any}
export type LeaderstatsData = {[string]: {
    instanceType: string;
    default: any?;
}}

export type PlayerServiceImpl = {
    __index: PlayerServiceImpl;
    New: () -> (PlayerService);
    CreateLeaderstats: (self: PlayerService, player: Player, initialData: LeaderstatsInitialData?) -> ();
    RetriveLeaderstatsData: (self: PlayerService, player: Player) -> (LeaderstatsInitialData);
    LoadPlayer: (self: PlayerService, player: Player) -> ();
    SavePlayer: (self: PlayerService, player: Player) -> ();
}

export type PlayerService = typeof(setmetatable({} :: {
    leaderstatsData: LeaderstatsData;
    loadedPlayers: {[string]: Player};
    playerAddedConnection: RBXScriptConnection?;
    playerRemovedConnection: RBXScriptConnection?;
}, {} :: PlayerServiceImpl))

return {}