-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Yuji = {}
local connections = {}

function Yuji.Start()
	print("Yuji logic started")
	local player = Players.LocalPlayer
	local mouse = player:GetMouse()
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	
	local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Yuji")

	local canUse1 = true
	local canUse2 = true
	local canUse3 = true
	local canUse4 = true
	local canUseManji = true
	local canUseAwaken = true
	local canUseCleave = true
	local canUseFireArrow = true
	local canUseDismantle = true
	local canUseDomain = true

	local isAwakened = false

	for _, conn in ipairs(connections) do conn:Disconnect() end
	connections = {}

	table.insert(connections, remote.OnClientEvent:Connect(function(msg)
		if msg == "Done1" then canUse1 = true
		elseif msg == "Done2" then canUse2 = true
		elseif msg == "Done3" then canUse3 = true
		elseif msg == "Done4" then canUse4 = true
		elseif msg == "DoneManji" then canUseManji = true
		elseif msg == "DoneAwaken" then canUseAwaken = true
		elseif msg == "DoneCleave" then canUseCleave = true
		elseif msg == "DoneFireArrow" then canUseFireArrow = true
		elseif msg == "DoneDismantle" then canUseDismantle = true
		elseif msg == "DoneDomain" then canUseDomain = true
		end
	end))

	table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if not character or not humanoid or humanoid.Health <= 0 then return end
		if player:GetAttribute("SelectedCharacter") ~= "Yuji" then return end

		if input.KeyCode == Enum.KeyCode.Z then
			if canUse1 then canUse1 = false; remote:FireServer("Brother") end
		elseif input.KeyCode == Enum.KeyCode.X then
			if canUse2 then canUse2 = false; remote:FireServer("Barrage") end
		elseif input.KeyCode == Enum.KeyCode.C then
			if canUse3 then canUse3 = false; remote:FireServer("Divergent") end
		elseif input.KeyCode == Enum.KeyCode.V then
			if canUse4 then canUse4 = false; remote:FireServer("Black") end
		elseif input.KeyCode == Enum.KeyCode.F then
			if canUseManji then canUseManji = false; remote:FireServer("Manji") end
		elseif input.KeyCode == Enum.KeyCode.G then
			if canUseAwaken and not isAwakened then canUseAwaken = false; isAwakened = true; remote:FireServer("Awaken") end
		elseif input.KeyCode == Enum.KeyCode.H then
			if isAwakened and canUseCleave then canUseCleave = false; remote:FireServer("Cleave") end
		elseif input.KeyCode == Enum.KeyCode.J then
			if isAwakened and canUseFireArrow then canUseFireArrow = false; remote:FireServer("FireArrow", mouse.Hit.Position) end
		elseif input.KeyCode == Enum.KeyCode.K then
			if isAwakened and canUseDismantle then canUseDismantle = false; remote:FireServer("Dismantle") end
		elseif input.KeyCode == Enum.KeyCode.T then
			if canUseDomain then canUseDomain = false; remote:FireServer("Domain") end
		end
	end))
end

function Yuji.Stop()
	print("Yuji logic stopped")
	for _, conn in ipairs(connections) do conn:Disconnect() end
	connections = {}
end

return Yuji
