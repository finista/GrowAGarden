--!strict
local shared = game.ReplicatedStorage.Shared
local seeds = require(shared.Modules.Seeds)

local util = {}

function util.VerifySeedTypeExists(seedType: string)
    -- Verifies whether the given seed type is contained within the seeds module
    if not seeds[seedType] then
        return false
    end
    return true
end

return util