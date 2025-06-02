--!strict
local replicatedStorage = game:GetService("ReplicatedStorage")
local player = game:GetService("Players").LocalPlayer

local shared = replicatedStorage:WaitForChild("Shared")
local types = require(shared:WaitForChild("Types"):WaitForChild("DialogueService"))

local sellRemote = replicatedStorage:WaitForChild("Remotes"):WaitForChild("Garden"):WaitForChild("Sell")

local dialoge = {} :: types.DialogeConfig

function getTool()
	if not player.Character then
		return false, nil :: any
	end

	local tool = player.Character:FindFirstChildOfClass("Tool")
	if not tool then
		return false, {
			npcAnswer = "You don't seem to be holding anything..",
			options = "END",
		} :: any
	end

	local value = tool:GetAttribute("value")
	if not value then
		return false, {
			npcAnswer = "Doesn't seem very valuable to me.",
			options = "END",
		} :: any
	end

    return true, tool
end

function getAllItems()
	if not player.Character then
		return {}, 0
	end

	local totalValue = 0
	local result = {}
	for _, tool in pairs(player.Backpack:GetChildren()) do
		local value = tool:GetAttribute("value")
		if not value then
			continue
		end

		totalValue += value
		table.insert(result, tool)
	end

	local success, tool = getTool()
	if success then
		totalValue += tool:GetAttribute("value")
		table.insert(result, tool)
	end

	return result, totalValue
end

local goodbyePhrases = { "Goodbye!", "Farewell!", "See you around!", "Come back later!", "Bye bye!" }

dialoge.Entrypoint = {
	npcAnswer = "Hello! What do you have for me today?",
	options = {
		{
			content = "How much is this worth?",
			onSelect = function(_)
                local success, result = getTool()
                if not success then
                    return result
                end

                local value = result:GetAttribute("value")
				return {
					npcAnswer = `I'd value it around ${value}.`,
					options = "END",
				} :: any
			end :: any,
		},

		{
			content = "I want to sell this.",
			onSelect = function(_)
                local success, result = getTool()
                if not success then
                    return result
                end

                local value = result:GetAttribute("value")
                sellRemote:FireServer(result)

				return {
					npcAnswer = `Here's your ${value}.`,
					options = "END",
				} :: any
			end,
		},

		{
			content = "I want to sell my inventory.",
			onSelect = function(_)
				local items, totalValue = getAllItems()
				if #items == 0 then
					return {
						npcAnswer = "You don't have anything..",
						options = "END"
					}
				end

				for _, tool in pairs(items) do
					sellRemote:FireServer(tool)
				end

				return {
					npcAnswer = `Here's your ${totalValue}.`,
					options = "END"
				}
			end :: any
		},

		{
			content = "What's my inventory worth?",
			onSelect = function(_)
				local items, totalValue = getAllItems()
				if #items == 0 then
					return {
						npcAnswer = "You don't have anything..",
						options = "END"
					}
				end

				return {
					npcAnswer = `It's worth about ${totalValue}.`,
					options = "END"
				}
			end :: any
		},

		{
			content = "Goodbye.",
			onSelect = function(_)
				return {
					npcAnswer = goodbyePhrases[math.random(1, #goodbyePhrases)],
					options = "END",
				}
			end
		},
	},
}

return dialoge
