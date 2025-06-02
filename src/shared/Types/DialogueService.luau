export type DialogeConfig = {
    Entrypoint: Dialoge;
    [string]: Dialoge;
}

export type DialogeOption = {
    content: string;
    onSelect: Dialoge | (dialogeService: DialogeService) -> (Dialoge?); 
}

export type Dialoge = {
    npcAnswer: string?;
    options: {DialogeOption} | "END"
}

export type DialogeServiceImpl = {
    __index: DialogeServiceImpl;
    New: () -> (DialogeService);
    LoadDialoge: (self: DialogeService, dialoge: Dialoge) -> ();
    ToggleDialoge: (self: DialogeService, state: boolean) -> ();
    ClearDialoge: (self: DialogeService) -> ();
    LoadOption: (self: DialogeService, option: DialogeOption, index: number) -> ();
    NPCSay: (self: DialogeService, content: string) -> ();
    ToggleNPCDialoge: (self: DialogeService, state: boolean, npc: Model?) -> ();
}

export type DialogeService = typeof(setmetatable({} :: {
    db: boolean;
    dialogeOpen: boolean;
    currentDialogeData: any?;
    npc: Model?;
    npcUI: BillboardGui;
    UI: BillboardGui;
    main: Frame;
    optionPreset: Frame;
    npcTypewriteThread: thread?;
    dialogeRemoteConnection: RBXScriptConnection?;
    distanceCheckConnection: RBXScriptConnection?;
}, {} :: DialogeServiceImpl))

return {}