local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Remotes = require(ReplicatedStorage.Shared.Remotes.Remotes)

local InteractionService = {}

local MAX_INTERACT_DISTANCE = 12

local function getCharacterRoot(player)
	local character = player.Character
	if not character then
		return nil
	end

	return character:FindFirstChild("HumanoidRootPart")
end

local function isValidInteractable(targetName)
	local interactablesFolder = Workspace:FindFirstChild("Interactables")
	if not interactablesFolder then
		return nil
	end

	local target = interactablesFolder:FindFirstChild(targetName)
	if not target then
		return nil
	end

	if not target:IsA("BasePart") then
		return nil
	end

	if target:GetAttribute("Interactable") ~= true then
		return nil
	end

	return target
end

function InteractionService.Start()
	print("InteractionService started")

	Remotes.InteractRequest.OnServerEvent:Connect(function(player, targetName)
		if typeof(targetName) ~= "string" then
			warn("Invalid interact target from " .. player.Name)
			return
		end

		local rootPart = getCharacterRoot(player)
		if not rootPart then
			return
		end

		local target = isValidInteractable(targetName)
		if not target then
			warn(player.Name .. " tried to interact with invalid target: " .. tostring(targetName))
			return
		end

		local distance = (rootPart.Position - target.Position).Magnitude
		if distance > MAX_INTERACT_DISTANCE then
			warn(player.Name .. " is too far from " .. targetName)
			return
		end

		print(player.Name .. " interacted with " .. targetName)
	end)
end

InteractionService.Start()

return InteractionService
