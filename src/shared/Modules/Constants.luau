local constants = {}

constants.CLIENT_VERSION = "1.0.0.1-a"
constants.LOADER_MODULE_TAG = "LoadableModule"

constants.PLANT_SEED_ATTRIB = "SeedType"
constants.PLANT_GROWTH_ATTRIB = "GrowthProgress"
constants.PLANT_TAG = "Plant"

constants.CUSTOM_PROMPT_TYPE_ATTR = "PromptType"
constants.FRUIT_PROMPT_TYPE_ATTR = "FruitType"

constants.DEFAULT_CAMERA_FOV = workspace.CurrentCamera.FieldOfView
constants.DIALOGE_CAMERA_FOV = constants.DEFAULT_CAMERA_FOV - 15

constants.MAX_DIALOGE_DISTANCE = 20

return constants