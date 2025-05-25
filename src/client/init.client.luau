local shared = game.ReplicatedStorage:WaitForChild("Shared")
local loader = require(shared:WaitForChild("Modules"):WaitForChild("Loader")).New()

loader:LoadGame()