-- ============================================================
-- Template Module Script
-- ============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Template = {}
local connections = {}

function Template.Start()
	local player = Players.LocalPlayer
	local mouse = player:GetMouse()
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	
	-- [EDIT] Change "Template" to your character's name
	local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Template")

	-- Cooldowns
	local canUse1, canUse2, canUse3, canUse4, canUseAwaken = true, true, true, true, true

	-- Clear old connections
	for _, conn in ipairs(connections) do conn:Disconnect() end
	connections = {}

	-- Server callbacks
	table.insert(connections, remote.OnClientEvent:Connect(function(msg)
		if msg == "Done1" then canUse1 = true
		elseif msg == "Done2" then canUse2 = true
		elseif msg == "Done3" then canUse3 = true
		elseif msg == "Done4" then canUse4 = true
		elseif msg == "DoneAwaken" then canUseAwaken = true
		end
	end))

	-- Input Handling
	table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if not character or not humanoid or humanoid.Health <= 0 then return end
		
		-- [EDIT] Change "Template"
		if player:GetAttribute("SelectedCharacter") ~= "Template" then return end

		if input.KeyCode == Enum.KeyCode.Z then
			if canUse1 then canUse1 = false; remote:FireServer("Ability1") end
		elseif input.KeyCode == Enum.KeyCode.X then
			if canUse2 then canUse2 = false; remote:FireServer("Ability2") end
		elseif input.KeyCode == Enum.KeyCode.C then
			if canUse3 then canUse3 = false; remote:FireServer("Ability3") end
		elseif input.KeyCode == Enum.KeyCode.V then
			if canUse4 then canUse4 = false; remote:FireServer("Ability4", mouse.Hit.Position) end
		elseif input.KeyCode == Enum.KeyCode.G then
			if canUseAwaken then canUseAwaken = false; remote:FireServer("Awaken") end
		end
	end))
end

function Template.Stop()
	for _, conn in ipairs(connections) do conn:Disconnect() end
	connections = {}
end

return Template
