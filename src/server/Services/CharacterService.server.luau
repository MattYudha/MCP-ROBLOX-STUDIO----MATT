local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Remotes = require(ReplicatedStorage.Shared.Remotes.Remotes)

local CharacterService = {}

local function createVisualsFolder(player)
	local folderName = "Visuals" .. player.UserId
	local folder = Workspace:FindFirstChild(folderName)
	
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = folderName
		folder.Parent = Workspace
		print("Created visuals folder for: " .. player.Name)
	end
	
	return folder
end

local function onPlayerAdded(player)
	createVisualsFolder(player)
	
	player.CharacterAdded:Connect(function(character)
		-- Ensure visuals folder exists on respawn
		createVisualsFolder(player)
	end)
end

local function onPlayerRemoving(player)
	local folderName = "Visuals" .. player.UserId
	local folder = Workspace:FindFirstChild(folderName)
	if folder then
		folder:Destroy()
		print("Cleaned up visuals folder for: " .. player.Name)
	end
end

function CharacterService.Start()
	print("CharacterService started")

	-- Initialize for existing players
	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(onPlayerAdded, player)
	end

	-- Listen for new players
	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(onPlayerRemoving)

	-- Handle character selection from GUI
	Remotes.Characters.OnServerEvent:Connect(function(player, characterName)
		if typeof(characterName) ~= "string" then return end
		
		print(player.Name .. " selected character: " .. characterName)
		
		-- Here you would typically handle spawning the character model
		-- For now, we will just tag the player with their selected character
		player:SetAttribute("SelectedCharacter", characterName)
		
		-- Tell the client to initialize the specific character script
		Remotes.Characters:FireClient(player, "Init", characterName)
	end)
end

CharacterService.Start()

return CharacterService
