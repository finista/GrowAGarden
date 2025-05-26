export type HandlerType = "HoldBegan" | "HoldEnded" | "Triggered" | "TriggerEnded"
export type PlatformType = "PC" | "Mobile" | "Console" | "VR"

export type PromptServiceImpl = {
    __index: PromptServiceImpl;
    New: () -> (PromptService);
    LoadPrompt: (self: PromptService, prompt: ProximityPrompt) -> ();
    CreateHandlerWrapper: (self: PromptService, methodType: HandlerType) -> (prompt: ProximityPrompt, player: Player) -> ();
    UnloadPrompt: (self: PromptService, prompt: ProximityPrompt) -> ();
}

export type PromptService = typeof(setmetatable({} :: {
    loadedPrompts: {[ProximityPrompt]: CustomPrompt};
    platform: PlatformType;
}, {} :: PromptServiceImpl))


export type CustomPromptMethod = (self: CustomPrompt, player: Player) -> ();

export type CustomPromptImpl = {
    __index: CustomPromptImpl;
    New: (prompt: ProximityPrompt, platform: PlatformType) -> (CustomPrompt);
    Hidden: (self: CustomPrompt) -> ();
    HoldBegan: CustomPromptMethod;
    HoldEnded: CustomPromptMethod;
    Triggered: CustomPromptMethod;
    TriggerEnded: CustomPromptMethod;
}

export type CustomPrompt = typeof(setmetatable({} :: {
    prompt: ProximityPrompt,
    platform: PlatformType,
    [any]: any;
}, {} :: CustomPromptImpl))

return {
    gamepadButtonImage = {
        [Enum.KeyCode.ButtonX] = "rbxasset://textures/ui/Controls/xboxX.png",
        [Enum.KeyCode.ButtonY] = "rbxasset://textures/ui/Controls/xboxY.png",
        [Enum.KeyCode.ButtonA] = "rbxasset://textures/ui/Controls/xboxA.png",
        [Enum.KeyCode.ButtonB] = "rbxasset://textures/ui/Controls/xboxB.png",
        [Enum.KeyCode.DPadLeft] = "rbxasset://textures/ui/Controls/dpadLeft.png",
        [Enum.KeyCode.DPadRight] = "rbxasset://textures/ui/Controls/dpadRight.png",
        [Enum.KeyCode.DPadUp] = "rbxasset://textures/ui/Controls/dpadUp.png",
        [Enum.KeyCode.DPadDown] = "rbxasset://textures/ui/Controls/dpadDown.png",
        [Enum.KeyCode.ButtonSelect] = "rbxasset://textures/ui/Controls/xboxmenu.png",
        [Enum.KeyCode.ButtonL1] = "rbxasset://textures/ui/Controls/xboxLS.png",
        [Enum.KeyCode.ButtonR1] = "rbxasset://textures/ui/Controls/xboxRS.png",
    }
}