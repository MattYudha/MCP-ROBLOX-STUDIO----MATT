-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Luffy = {}
local connections = {}

function Luffy.Start()
	local player = Players.LocalPlayer
	local mouse = player:GetMouse()
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Luffy")

	local canUse1, canUse2, canUse3, canUse4, canUseAwaken = true, true, true, true, true
	local isAwakened = false

	for _, conn in ipairs(connections) do conn:Disconnect() end
	connections = {}

	table.insert(connections, remote.OnClientEvent:Connect(function(msg)
		if msg == "Done1" then canUse1 = true
		elseif msg == "Done2" then canUse2 = true
		elseif msg == "Done3" then canUse3 = true
		elseif msg == "Done4" then canUse4 = true
		elseif msg == "DoneAwaken" then canUseAwaken = true
		end
	end))

	table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if not character or not humanoid or humanoid.Health <= 0 then return end
		if player:GetAttribute("SelectedCharacter") ~= "Luffy" then return end

		if input.KeyCode == Enum.KeyCode.Z then
			if canUse1 then canUse1 = false; remote:FireServer("Gatling") end
		elseif input.KeyCode == Enum.KeyCode.X then
			if canUse2 then canUse2 = false; remote:FireServer("Axe") end
		elseif input.KeyCode == Enum.KeyCode.C then
			if canUse3 then canUse3 = false; remote:FireServer("Bazooka") end
		elseif input.KeyCode == Enum.KeyCode.V then
			if canUse4 then canUse4 = false; remote:FireServer("Bullet", mouse.Hit.Position) end
		elseif input.KeyCode == Enum.KeyCode.G then
			if canUseAwaken and not isAwakened then canUseAwaken = false; isAwakened = true; remote:FireServer("Awaken") end
		end
	end))
end

function Luffy.Stop()
	for _, conn in ipairs(connections) do conn:Disconnect() end
	connections = {}
end

return Luffy
