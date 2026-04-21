local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Remotes = require(ReplicatedStorage.Shared.Remotes.Remotes)
local InteractionPromptUI = require(script.Parent.Parent.UI.InteractionPromptUI)

local MainController = {}

local MAX_INTERACT_DISTANCE = 12
local currentTarget = nil

local function getCharacterRoot()
	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	return character:WaitForChild("HumanoidRootPart")
end

local function getNearestInteractable()
	local interactablesFolder = Workspace:FindFirstChild("Interactables")
	if not interactablesFolder then
		return nil
	end

	local rootPart = getCharacterRoot()
	local nearestTarget = nil
	local nearestDistance = MAX_INTERACT_DISTANCE

	for _, instance in interactablesFolder:GetChildren() do
		if instance:IsA("BasePart") and instance:GetAttribute("Interactable") == true then
			local distance = (rootPart.Position - instance.Position).Magnitude
			if distance <= nearestDistance then
				nearestDistance = distance
				nearestTarget = instance
			end
		end
	end

	return nearestTarget
end

function MainController.Start()
	print("MainController started")

	task.wait(2)
	Remotes.TestEvent:FireServer()

	RunService.RenderStepped:Connect(function()
		local nearestTarget = getNearestInteractable()

		if nearestTarget ~= currentTarget then
			currentTarget = nearestTarget

			if currentTarget then
				InteractionPromptUI.Show(currentTarget.Name)
			else
				InteractionPromptUI.Hide()
			end
		end
	end)

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.KeyCode == Enum.KeyCode.E then
			if not currentTarget then
				warn("No interactable nearby")
				return
			end

			Remotes.InteractRequest:FireServer(currentTarget.Name)
		end
	end)
end

MainController.Start()

return MainController
