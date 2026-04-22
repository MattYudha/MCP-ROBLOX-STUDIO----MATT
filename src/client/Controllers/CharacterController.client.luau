local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Remotes = require(ReplicatedStorage.Shared.Remotes.Remotes)

local CharacterController = {}

local activeCharacterScript = nil

function CharacterController.InitCharacter(characterName)
	print("Initializing client logic for: " .. characterName)
	
	if activeCharacterScript and activeCharacterScript.Stop then
		activeCharacterScript.Stop()
	end
	
	local characterScriptsFolder = script.Parent:WaitForChild("CharacterScript")
	local characterModule = characterScriptsFolder:FindFirstChild(characterName)
	
	if characterModule and characterModule:IsA("ModuleScript") then
		local logic = require(characterModule)
		activeCharacterScript = logic
		if type(logic) == "table" and logic.Start then
			logic.Start()
		elseif type(logic) == "function" then
			logic()
		end
	else
		warn("No client logic module found for character: " .. characterName)
	end
end

function CharacterController.Start()
	print("CharacterController started")

	-- Listen for initialization signal from server
	Remotes.Characters.OnClientEvent:Connect(function(action, characterName)
		if action == "Init" then
			CharacterController.InitCharacter(characterName)
		end
	end)
end

CharacterController.Start()

return CharacterController
