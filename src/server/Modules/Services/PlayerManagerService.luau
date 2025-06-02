--!strict
local players = game:GetService("Players")
local dataStoreService = game:GetService("DataStoreService")
local server = game:GetService("ServerScriptService").Server

local types = require(server:WaitForChild("Types"):WaitForChild("PlayerManagerService"))
local constants = require(server:WaitForChild("Modules"):WaitForChild("Constants"))

local playerService = {} :: types.PlayerServiceImpl
playerService.__index = playerService

function playerService:CreateLeaderstats(player, initialData)
	if player:FindFirstChild("Leaderstats") then
		warn(`Player {player.Name} already has leaderstats loaded.`)
		return
	end

	if not initialData then
		initialData = {}
	end

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	for name, data in pairs(self.leaderstatsData) do
		local value = Instance.new(data.instanceType)
		value.Parent = leaderstats
		value.Name = name;

		(value :: any).Value = (initialData :: types.LeaderstatsInitialData)[name] or data.default
	end
end

function playerService:RetriveLeaderstatsData(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	assert(leaderstats, `Player {player.Name} doesn't have a leaderstats folder.`)

	local result = {}
	for _, value: any in pairs(leaderstats:GetChildren()) do
		result[value.Name] = value.Value
	end

	return result
end

function playerService:LoadPlayer(player)
	if self.loadedPlayers[player.Name] then
		warn(`Player {player.Name} is already loaded.`)
		return
	end

    local datastore = dataStoreService:GetDataStore(constants.PLAYER_DATASTORE_KEY)
	local success, result: types.PlayerSaveData = pcall(function()
		return datastore:GetAsync(constants.PLAYER_SAVE_KEY:format(player.UserId))
	end)

	if not success then
		warn(`Failed to retrive player {player.UserId} save data, error: {result :: any}!`)

		if constants.KICK_PLAYER_ON_SAVE_LOAD_FAIL then
			player:Kick("Failed to load save data, Roblox's services might be experiencing difficulties. Please rejoin later.")
			return
		end
	end

	self:CreateLeaderstats(player, (result and result.leaderstats) or nil)

	self.loadedPlayers[player.Name] = player
end

function playerService:SavePlayer(player)
	if not self.loadedPlayers[player.Name] then
		warn(`Can't save {player.Name}'s data because player isn't loaded.`)
		return
	end

	local leaderstats = self:RetriveLeaderstatsData(player)
	local save = {
		leaderstats = leaderstats
	} :: types.PlayerSaveData

	local datastore = dataStoreService:GetDataStore(constants.PLAYER_DATASTORE_KEY)
	xpcall(function()
		datastore:SetAsync(constants.PLAYER_SAVE_KEY:format(player.UserId), save)
	end, function(err)
		warn(`Failed to save data for {player.Name}, error: {err or "No error given."}`)
	end)
end

function playerService.New()
	local self = setmetatable({}, playerService)

	self.loadedPlayers = {}
	self.leaderstatsData = {
		Points = {
			instanceType = "NumberValue",
			default = 0,
		},
	}

	for _, player in pairs(players:GetPlayers()) do
		self:LoadPlayer(player)
	end

	self.playerAddedConnection = players.PlayerAdded:Connect(function(player: Player)
		self:LoadPlayer(player)
	end)

	self.playerRemovedConnection = players.PlayerRemoving:Connect(function(player: Player)
		self:SavePlayer(player)
	end)

	return self
end

return playerService
