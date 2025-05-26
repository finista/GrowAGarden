export type PlantViewerImpl = {
    __index: PlantViewerImpl;
    New: () -> (PlantViewer);
    SetTarget: (self: PlantViewer, target: Model | BasePart) -> ();
    ResetUI: (self: PlantViewer) -> ();
    UpdateUI: (self: PlantViewer) -> ();
    TweenInUI: (self: PlantViewer) -> ();
}

export type PlantViewer = typeof(setmetatable({} :: {
    currentPlant: (Model | Instance)?;
    UI: BillboardGui;
    plantText: TextLabel;
    growthText: TextLabel;
    mouseConnection: RBXScriptConnection;
    targetChangeConnection: RBXScriptConnection?;
    colorConnection: RBXScriptConnection?;
    tweens: {any};
}, {} :: PlantViewerImpl))

return {}