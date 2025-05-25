--!strict
local effect = {}
effect.__index = effect

function effect:Run(meta)
    print(`Ran effect with meta: {meta}`)
end

function effect.New()
    local self = setmetatable({}, effect)

    return self
end

return effect