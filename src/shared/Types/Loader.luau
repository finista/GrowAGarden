export type LoadData = {
    total: number;
    errors: number;
    time: number;
}

export type LoaderImpl = {
    __index: LoaderImpl;
    New: () -> (Loader);
    LoadModule: (self: Loader, module: ModuleScript) -> ();
    LoadGame: (self: Loader) -> ();
}

export type Loader = typeof(setmetatable({} :: {
    loaded: {[string]: any};
    isLoaded: boolean;
    loadData: LoadData;
}, {} :: LoaderImpl))

return {}