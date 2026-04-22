-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Ichigo = {}
local connections = {}

function Ichigo.Start()
	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Ichigo")

	local canUse1 = true
	for _, conn in ipairs(connections) do conn:Disconnect() end
	connections = {}

	table.insert(connections, remote.OnClientEvent:Connect(function(msg)
		if msg == "Done1" then canUse1 = true end
	end))

	table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if not character or not humanoid or humanoid.Health <= 0 then return end
		if player:GetAttribute("SelectedCharacter") ~= "Ichigo" then return end

		if input.KeyCode == Enum.KeyCode.Z then
			if canUse1 then
				canUse1 = false
				remote:FireServer("OpenTrails")
				remote:FireServer("Slashes")
			end
		end
	end))

	table.insert(connections, UserInputService.InputEnded:Connect(function(input, gameProcessed)
		if input.KeyCode == Enum.KeyCode.Z then
			remote:FireServer("CloseTrails")
		end
	end))
end

function Ichigo.Stop()
	for _, conn in ipairs(connections) do conn:Disconnect() end
	connections = {}
end

return Ichigo
