--!strict
local shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local prefabs = game:GetService("ReplicatedStorage"):WaitForChild("Prefabs")

local seedData = require(shared:WaitForChild("Modules"):WaitForChild("Seeds"))
local framePrefab = prefabs:WaitForChild("UI"):WaitForChild("SeedShop"):WaitForChild("Seed")

local seedDisplay = require(
	shared
		:WaitForChild("Modules")
		:WaitForChild("UI")
		:WaitForChild("Components")
		:WaitForChild("SeedShop")
		:WaitForChild("SeedDisplay")
)

return function(seedType: string, amount: number)
	local data = seedData[seedType]
	assert(data, `Seed with seedType {seedType} doesn't exist.`)

	local frame = framePrefab:Clone()

	local buyMoneyBtn = frame:WaitForChild("BuyMoney")
	local buyRobuxBtn = frame:WaitForChild("BuyRobux")

	frame:WaitForChild("Name").Text = data.name
	frame:WaitForChild("Stock").Text = `(x{amount})`

	buyMoneyBtn.Text = `${data.shopData.moneyCost}`
	buyRobuxBtn.Text = `{data.shopData.robuxCost}R$`

    seedDisplay(frame:WaitForChild("Display"):WaitForChild("VPFrame"), seedType, `{seedType}Fruit`)

	return frame
end
