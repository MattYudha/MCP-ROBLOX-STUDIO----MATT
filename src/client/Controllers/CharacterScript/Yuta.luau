-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Yuta = {}
local connections = {}

function Yuta.Start()
	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Yuta")

	local canUse1, canUse2, canUse3, canUse4, canUseAwaken, canUseShine, canUseBlackFlash, canUseGroundBreak, canUsePureLove = true, true, true, true, true, true, true, true, true
	local isAwakened = false

	for _, conn in ipairs(connections) do conn:Disconnect() end
	connections = {}

	table.insert(connections, remote.OnClientEvent:Connect(function(msg)
		if msg == "Done1" then canUse1 = true
		elseif msg == "Done2" then canUse2 = true
		elseif msg == "Done3" then canUse3 = true
		elseif msg == "Done4" then canUse4 = true
		elseif msg == "DoneAwaken" then canUseAwaken = true
		elseif msg == "DoneShine" then canUseShine = true
		elseif msg == "DoneBlackFlash" then canUseBlackFlash = true
		elseif msg == "DoneGroundBreak" then canUseGroundBreak = true
		elseif msg == "DonePureLove" then canUsePureLove = true
		end
	end))

	table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if not character or not humanoid or humanoid.Health <= 0 then return end
		if player:GetAttribute("SelectedCharacter") ~= "Yuta" then return end

		if input.KeyCode == Enum.KeyCode.Z then
			if canUse1 then canUse1 = false; remote:FireServer("OpenTrails"); remote:FireServer("Slashes") end
		elseif input.KeyCode == Enum.KeyCode.X then
			if canUse2 then canUse2 = false; remote:FireServer("Strike") end
		elseif input.KeyCode == Enum.KeyCode.C then
			if canUse3 then canUse3 = false; remote:FireServer("Rampage") end
		elseif input.KeyCode == Enum.KeyCode.V then
			if canUse4 then canUse4 = false; remote:FireServer("Heal") end
		elseif input.KeyCode == Enum.KeyCode.F then
			if canUseBlackFlash then canUseBlackFlash = false; remote:FireServer("BlackFlash") end
		elseif input.KeyCode == Enum.KeyCode.G then
			if canUseAwaken and not isAwakened then canUseAwaken = false; isAwakened = true; remote:FireServer("Awaken") end
		elseif input.KeyCode == Enum.KeyCode.H then
			if canUseShine then canUseShine = false; remote:FireServer("Shine") end
		elseif input.KeyCode == Enum.KeyCode.E then
			if canUseGroundBreak then canUseGroundBreak = false; remote:FireServer("GroundBreak") end
		elseif input.KeyCode == Enum.KeyCode.T then
			if canUsePureLove then canUsePureLove = false; remote:FireServer("PureLove") end
		end
	end))

	table.insert(connections, UserInputService.InputEnded:Connect(function(input, gameProcessed)
		if input.KeyCode == Enum.KeyCode.Z then remote:FireServer("CloseTrails") end
	end))
end

function Yuta.Stop()
	for _, conn in ipairs(connections) do conn:Disconnect() end
	connections = {}
end

return Yuta
