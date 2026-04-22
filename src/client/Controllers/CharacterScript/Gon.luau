-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Gon = {}

local connections = {}

function Gon.Start()
	print("Gon logic started")
	
	local player = Players.LocalPlayer
	local mouse = player:GetMouse()
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	
	local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Gon")

	-- Cooldowns
	local canUse1 = true -- Rock
	local canUse2 = true -- Scissor
	local canUse3 = true -- Paper (charged)
	local canUse4 = true -- Paper2 (aimed)

	-- Paper charge state
	local paperCharging = false
	local paperChargeDone = false

	-- Clear old connections if any
	for _, conn in ipairs(connections) do
		conn:Disconnect()
	end
	connections = {}

	-- Listen for server callbacks
	table.insert(connections, remote.OnClientEvent:Connect(function(msg)
		if msg == "Done1" then
			canUse1 = true
		elseif msg == "Done2" then
			canUse2 = true
		elseif msg == "Done3" then
			canUse3 = true
			paperCharging = false
			paperChargeDone = false
		elseif msg == "Done4" then
			canUse4 = true
		end
	end))

	-- Input Handling
	table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if not character or not humanoid or humanoid.Health <= 0 then return end
		
		-- Check if player is still Gon (security check)
		if player:GetAttribute("SelectedCharacter") ~= "Gon" then 
			Gon.Stop()
			return 
		end

		-- Rock - Key Z
		if input.KeyCode == Enum.KeyCode.Z then
			if canUse1 then
				canUse1 = false
				remote:FireServer("Rock")
			end

		-- Scissor - Key X
		elseif input.KeyCode == Enum.KeyCode.X then
			if canUse2 then
				canUse2 = false
				remote:FireServer("Scissor")
			end

		-- Paper Charge - Key C
		elseif input.KeyCode == Enum.KeyCode.C then
			if canUse3 and not paperCharging then
				canUse3 = false
				paperCharging = true
				paperChargeDone = false
				remote:FireServer("PreparePaper")
				task.wait(0.5)
				if paperCharging then
					paperChargeDone = true
				end
			end

		-- Paper Aimed - Key V
		elseif input.KeyCode == Enum.KeyCode.V then
			if canUse4 then
				canUse4 = false
				local mousePos = mouse.Hit.Position
				remote:FireServer("Paper2", mousePos)
				task.delay(3, function()
					canUse4 = true
				end)
			end
		end
	end))

	table.insert(connections, UserInputService.InputEnded:Connect(function(input, gameProcessed)
		if input.KeyCode == Enum.KeyCode.C then
			if paperCharging then
				if paperChargeDone then
					remote:FireServer("Paper")
				else
					canUse3 = true
					paperCharging = false
					paperChargeDone = false
				end
			end
		end
	end))
end

function Gon.Stop()
	print("Gon logic stopped")
	for _, conn in ipairs(connections) do
		conn:Disconnect()
	end
	connections = {}
end

return Gon
