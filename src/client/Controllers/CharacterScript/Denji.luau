-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Denji = {}
local connections = {}

function Denji.Start()
	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Denji")

	local canUse1, canUse2, canUse3, canUse4, canUseAwaken, canUseSlam, canUseFlash, canUseStab, canUseRampage = true, true, true, true, true, true, true, true, true
	local isAwakened = false

	for _, conn in ipairs(connections) do conn:Disconnect() end
	connections = {}

	table.insert(connections, remote.OnClientEvent:Connect(function(msg)
		if msg == "Done1" then canUse1 = true
		elseif msg == "Done2" then canUse2 = true
		elseif msg == "Done3" then canUse3 = true
		elseif msg == "Done4" then canUse4 = true
		elseif msg == "DoneAwaken" then canUseAwaken = true
		elseif msg == "DoneSlam" then canUseSlam = true
		elseif msg == "DoneFlash" then canUseFlash = true
		elseif msg == "DoneStab" then canUseStab = true
		elseif msg == "DoneRampage" then canUseRampage = true
		end
	end))

	table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if not character or not humanoid or humanoid.Health <= 0 then return end
		if player:GetAttribute("SelectedCharacter") ~= "Denji" then return end

		if input.KeyCode == Enum.KeyCode.Z then
			if canUse1 then canUse1 = false; remote:FireServer("Kick") end
		elseif input.KeyCode == Enum.KeyCode.X then
			if canUse2 then canUse2 = false; remote:FireServer("Power") end
		elseif input.KeyCode == Enum.KeyCode.C then
			if canUse3 then canUse3 = false; remote:FireServer("Barrage") end
		elseif input.KeyCode == Enum.KeyCode.V then
			if canUse4 then canUse4 = false; remote:FireServer("Aki") end
		elseif input.KeyCode == Enum.KeyCode.F then
			if canUseFlash then canUseFlash = false; remote:FireServer("Flash") end
		elseif input.KeyCode == Enum.KeyCode.G then
			if canUseAwaken and not isAwakened then canUseAwaken = false; isAwakened = true; remote:FireServer("Awaken") end
		elseif input.KeyCode == Enum.KeyCode.H then
			if canUseSlam then canUseSlam = false; remote:FireServer("Slam") end
		elseif input.KeyCode == Enum.KeyCode.E then
			if canUseStab then canUseStab = false; remote:FireServer("Stab") end
		elseif input.KeyCode == Enum.KeyCode.T then
			if canUseRampage then canUseRampage = false; remote:FireServer("Rampage") end
		end
	end))
end

function Denji.Stop()
	for _, conn in ipairs(connections) do conn:Disconnect() end
	connections = {}
end

return Denji
