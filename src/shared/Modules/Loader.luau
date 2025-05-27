--!strict
local collectionService = game:GetService("CollectionService")
local shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")

local types = require(shared:WaitForChild("Types"):WaitForChild("Loader"))
local constants = require(shared:WaitForChild("Modules"):WaitForChild("Constants"))
local utils = require(shared:WaitForChild("Modules"):WaitForChild("Utils"):WaitForChild("General"))

local loader = {} :: types.LoaderImpl
loader.__index = loader

function output(type: 'info' | 'warn' | 'err', message: string, module: string?)
    local typeToPrefix = {
        info = "[INFO]",
        warn = "[WARN]",
        err = "[ERROR]"
    }

    local msg = `[{module or "CLIENT"}] - {typeToPrefix[type]}: {message}.`
    if type == 'info' then
        print(msg)
    else 
        warn(msg)
    end
end

function loader:SetupEnvironment(func, moduleName, additional)
    local originalEnvironment = getfenv(func)
    local environment = {
        print = function(content: string)
            output("info", content, moduleName)
        end;

        warn = function(content: string)
            output("warn", content, moduleName)
        end;    

        error = function(content: string)
            output("err", content, moduleName)
        end;
    }

    local metaEnvironment: any = setmetatable({}, {
        __index = function(_, index)
            if additional and additional[index] then
                return additional[index]
            end

            return environment[index] or originalEnvironment[index]
        end;

        __newindex = function(_, index, key)
            originalEnvironment[index] = key
        end;

        __metatable = {};
    })

    setfenv(func, metaEnvironment)
end

function loader:LoadModule(module)
    local success, result = pcall(function()
        local loaded = require(module) :: any
        assert(loaded.New, `Module {module.Name} is missing method .New().`)

        for _, prop in pairs(loaded) do
            if typeof(prop) ~= "function" then
                continue
            end
            
            self:SetupEnvironment(prop, module.Name)
        end

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

    self.loadData.time = tick() - startTick
    output("info", `Client initialized. Loaded {self.loadData.total} modules. ({utils.formatDecimal(self.loadData.time, 3)}s)`)
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