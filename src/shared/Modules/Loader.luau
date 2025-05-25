--!strict
local collectionService = game:GetService("CollectionService")
local shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")

local types = require(shared:WaitForChild("Types"):WaitForChild("Loader"))
local constants = require(shared:WaitForChild("Modules"):WaitForChild("Constants"))
local utils = require(shared:WaitForChild("Modules"):WaitForChild("Utils"):WaitForChild("General"))

local loader = {} :: types.LoaderImpl
loader.__index = loader

function output(type: 'info' | 'warn' | 'err', message: string)
    local typeToPrefix = {
        info = "[INFO]",
        warn = "[WARN]",
        err = "[ERROR]"
    }

    local msg = `[CLIENT] - {typeToPrefix[type]}: {message}.`
    if type == 'info' then
        print(msg)
    else 
        warn(msg)
    end
end

function loader:LoadModule(module)
    local success, result = pcall(function()
        local loaded = require(module) :: any
        assert(loaded.New, `Module {module.Name} is missing method .New().`)

        return loaded.New()
    end)

    if not success then
        output('warn', `Failed to load module {module.Name} - {result}`)
        self.loadData.errors += 1

        return
    end

    self.loaded[module.Name] = result
    self.loadData.total += 1

    output('info', `Loaded module {module.Name}`)
end

function loader:LoadGame()
    local startTick = tick()

    output("info", `Begin client load. Client version: {constants.CLIENT_VERSION}`)
    output("info", "Collecting modules")

    local modules = collectionService:GetTagged(constants.LOADER_MODULE_TAG)

    for _, module in pairs(modules) do
        self:LoadModule(module)
    end

    local loadTime = tick() - startTick
    output("info", `Client load finished. ({utils.formatDecimal(loadTime, 3)}s)`)
end

function loader.New()
    local self = setmetatable({}, loader)

    self.isLoaded = false
    self.loadData = {
        total = 0,
        errors = 0,
        time = 0
    }

    self.loaded = {}

    return self
end

return loader