-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Goku = {}
local connections = {}

function Goku.Start()
	print("Goku logic started")
	local player = Players.LocalPlayer
	local mouse = player:GetMouse()
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	
	local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Goku")

	-- Cooldowns
	local canUse1 = true
	local canUse2 = true
	local canUse3 = true
	local canUse4 = true
	local canUseDragon = true
	local canUseFrenzy = true
	local canUseAwaken = true
	local canUseQuickCombo = true
	local canUseSuperKame = true
	local canUseUltraSense = true
	local canUseGodlyCombo = true

	local isAwakened = false

	for _, conn in ipairs(connections) do conn:Disconnect() end
	connections = {}

	table.insert(connections, remote.OnClientEvent:Connect(function(msg)
		if msg == "Done1" then canUse1 = true
		elseif msg == "Done2" then canUse2 = true
		elseif msg == "Done3" then canUse3 = true
		elseif msg == "Done4" then canUse4 = true
		elseif msg == "DoneDragon" then canUseDragon = true
		elseif msg == "DoneFrenzy" then canUseFrenzy = true
		elseif msg == "DoneAwaken" then canUseAwaken = true
		elseif msg == "DoneQuickCombo" then canUseQuickCombo = true
		elseif msg == "DoneSuperKame" then canUseSuperKame = true
		elseif msg == "DoneUltraSense" then canUseUltraSense = true
		elseif msg == "DoneGodlyCombo" then canUseGodlyCombo = true
		end
	end))

	table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if not character or not humanoid or humanoid.Health <= 0 then return end
		if player:GetAttribute("SelectedCharacter") ~= "Goku" then return end

		if input.KeyCode == Enum.KeyCode.Z then
			if canUse1 then canUse1 = false; remote:FireServer("KiBarrage") end
		elseif input.KeyCode == Enum.KeyCode.X then
			if canUse2 then canUse2 = false; remote:FireServer("KiR", mouse.Hit.Position) end
		elseif input.KeyCode == Enum.KeyCode.C then
			if canUse3 then canUse3 = false; remote:FireServer("KiL", mouse.Hit.Position) end
		elseif input.KeyCode == Enum.KeyCode.V then
			if canUse4 then canUse4 = false; remote:FireServer("Kamehameha", mouse.Hit.Position) end
		elseif input.KeyCode == Enum.KeyCode.F then
			if canUseDragon then canUseDragon = false; remote:FireServer("DragonCombo") end
		elseif input.KeyCode == Enum.KeyCode.E then
			if canUseFrenzy then canUseFrenzy = false; remote:FireServer("FrenzyKicks") end
		elseif input.KeyCode == Enum.KeyCode.G then
			if canUseAwaken and not isAwakened then canUseAwaken = false; isAwakened = true; remote:FireServer("Awaken") end
		elseif input.KeyCode == Enum.KeyCode.H then
			if isAwakened and canUseQuickCombo then canUseQuickCombo = false; remote:FireServer("QuickCombo") end
		elseif input.KeyCode == Enum.KeyCode.J then
			if isAwakened and canUseSuperKame then canUseSuperKame = false; remote:FireServer("SuperKamehameha", mouse.Hit.Position) end
		elseif input.KeyCode == Enum.KeyCode.K then
			if isAwakened and canUseUltraSense then canUseUltraSense = false; remote:FireServer("UltraSense") end
		elseif input.KeyCode == Enum.KeyCode.T then
			if canUseGodlyCombo then canUseGodlyCombo = false; remote:FireServer("GodlyCombo") end
		end
	end))
end

function Goku.Stop()
	print("Goku logic stopped")
	for _, conn in ipairs(connections) do conn:Disconnect() end
	connections = {}
end

return Goku
