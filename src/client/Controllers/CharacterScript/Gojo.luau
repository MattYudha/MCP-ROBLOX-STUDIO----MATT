-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Gojo = {}
local connections = {}

function Gojo.Start()
	print("Gojo logic started")
	local player = Players.LocalPlayer
	local mouse = player:GetMouse()
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	
	local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Gojo")

	local canUse1 = true
	local canUse2 = true
	local canUse3 = true
	local canUse4 = true
	local canUseBackHand = true
	local canUseAwaken = true
	local canUseMaxBlue = true
	local canUseMaxRed = true
	local canUseHollowPurple = true
	local canUseHollowPurpleBig = true
	local canUseDomain = true

	local isAwakened = false
	local blueHeld = false

	for _, conn in ipairs(connections) do conn:Disconnect() end
	connections = {}

	table.insert(connections, remote.OnClientEvent:Connect(function(msg)
		if msg == "Done1" then canUse1 = true
		elseif msg == "Done2" then canUse2 = true
		elseif msg == "Done3" then canUse3 = true
		elseif msg == "Done4" then canUse4 = true
		elseif msg == "DoneBackHand" then canUseBackHand = true
		elseif msg == "DoneAwaken" then canUseAwaken = true
		elseif msg == "DoneMaxBlue" then canUseMaxBlue = true
		elseif msg == "DoneMaxRed" then canUseMaxRed = true
		elseif msg == "DoneHollowPurple" then canUseHollowPurple = true
		elseif msg == "DoneHollowPurpleBig" then canUseHollowPurpleBig = true
		elseif msg == "DoneDomain" then canUseDomain = true
		end
	end))

	task.spawn(function()
		while true do
			task.wait(0.05)
			if not blueHeld then continue end
			if player:GetAttribute("SelectedCharacter") ~= "Gojo" then break end
			remote:FireServer("UpdateBlue", mouse.Hit.Position)
		end
	end)

	table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if not character or not humanoid or humanoid.Health <= 0 then return end
		if player:GetAttribute("SelectedCharacter") ~= "Gojo" then return end

		if input.KeyCode == Enum.KeyCode.Z then
			if canUse1 then canUse1 = false; blueHeld = true; remote:FireServer("Blue") end
		elseif input.KeyCode == Enum.KeyCode.X then
			if canUse2 then canUse2 = false; remote:FireServer("Red") end
		elseif input.KeyCode == Enum.KeyCode.C then
			if canUse3 then canUse3 = false; remote:FireServer("Barrage") end
		elseif input.KeyCode == Enum.KeyCode.V then
			if canUse4 then canUse4 = false; remote:FireServer("Hora") end
		elseif input.KeyCode == Enum.KeyCode.F then
			if canUseBackHand then canUseBackHand = false; remote:FireServer("BackHand") end
		elseif input.KeyCode == Enum.KeyCode.G then
			if canUseAwaken and not isAwakened then canUseAwaken = false; isAwakened = true; remote:FireServer("Awaken") end
		elseif input.KeyCode == Enum.KeyCode.H then
			if isAwakened and canUseMaxBlue then canUseMaxBlue = false; remote:FireServer("MaxBlue") end
		elseif input.KeyCode == Enum.KeyCode.J then
			if isAwakened and canUseMaxRed then canUseMaxRed = false; remote:FireServer("MaxRed") end
		elseif input.KeyCode == Enum.KeyCode.Q then
			if isAwakened and canUseHollowPurple then canUseHollowPurple = false; remote:FireServer("HollowPurple", mouse.Hit.Position) end
		elseif input.KeyCode == Enum.KeyCode.T then
			if isAwakened and canUseHollowPurpleBig then canUseHollowPurpleBig = false; remote:FireServer("HollowPurpleBig", mouse.Hit.Position) end
		elseif input.KeyCode == Enum.KeyCode.R then
			if canUseDomain then canUseDomain = false; remote:FireServer("Domain") end
		end
	end))

	table.insert(connections, UserInputService.InputEnded:Connect(function(input, gameProcessed)
		if input.KeyCode == Enum.KeyCode.Z then blueHeld = false end
	end))
end

function Gojo.Stop()
	print("Gojo logic stopped")
	for _, conn in ipairs(connections) do conn:Disconnect() end
	connections = {}
end

return Gojo
