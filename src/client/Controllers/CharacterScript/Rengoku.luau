-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rengoku = {}
local connections = {}

function Rengoku.Start()
	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Rengoku")

	local canUse1, canUse2, canUse3, canUse4, canUseAwaken, canUseUlt = true, true, true, true, true, true

	for _, conn in ipairs(connections) do conn:Disconnect() end
	connections = {}

	table.insert(connections, remote.OnClientEvent:Connect(function(msg)
		if msg == "Done1" then canUse1 = true
		elseif msg == "Done2" then canUse2 = true
		elseif msg == "Done3" then canUse3 = true
		elseif msg == "Done4" then canUse4 = true
		elseif msg == "DoneAwaken" then canUseAwaken = true
		elseif msg == "DoneUlt" then canUseUlt = true
		end
	end))

	table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if not character or not humanoid or humanoid.Health <= 0 then return end
		if player:GetAttribute("SelectedCharacter") ~= "Rengoku" then return end

		if input.KeyCode == Enum.KeyCode.Z then
			if canUse1 then canUse1 = false; remote:FireServer("Unknown") end
		elseif input.KeyCode == Enum.KeyCode.X then
			if canUse2 then canUse2 = false; remote:FireServer("Rising") end
		elseif input.KeyCode == Enum.KeyCode.C then
			if canUse3 then canUse3 = false; remote:FireServer("Blazing") end
		elseif input.KeyCode == Enum.KeyCode.V then
			if canUse4 then canUse4 = false; remote:FireServer("Bloom") end
		elseif input.KeyCode == Enum.KeyCode.G then
			if canUseAwaken then canUseAwaken = false; remote:FireServer("Awaken") end
		elseif input.KeyCode == Enum.KeyCode.H then
			if canUseUlt then canUseUlt = false; remote:FireServer("Rengoku") end
		end
	end))
end

function Rengoku.Stop()
	for _, conn in ipairs(connections) do conn:Disconnect() end
	connections = {}
end

return Rengoku
