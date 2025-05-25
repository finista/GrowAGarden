export type EffectServiceImpl = {
    __index: EffectServiceImpl;
    New: () -> (EffectService);
    RunEffect: (self: EffectService, effectType: string, meta: any) -> ();
    LoadEffects: (self: EffectService) -> ();
}

export type EffectService = typeof(setmetatable({} :: {
    effectsFolder: Folder,
    loaded: {[string]: any}
}, {} :: EffectServiceImpl))

return {}