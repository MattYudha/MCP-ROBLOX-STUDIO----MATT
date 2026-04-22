--—————— Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local ContextActionService = game:GetService("ContextActionService")

--—————— BridgeNet

local BridgeNet = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("BridgeNet2"))

local Client = BridgeNet.ClientBridge("Replicator")

--—————— Replication

local function FindAbility(AbilityName: string)
	-- Pastikan AbilityName bukan nil dan merupakan string
	if not AbilityName or type(AbilityName) ~= "string" then
		warn("Invalid AbilityName: " .. tostring(AbilityName))
		return false
	end
	
	local Module: any = false
	for _, v in ipairs( ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Abilities"):GetDescendants() ) do
		if v:IsA('ModuleScript') and string.lower(v.Name) == string.lower(AbilityName) then
			Module = require(v)
		end
	end
	return Module
	
end

Client:Connect(function(Recieved: any)
	local abilityName = Recieved[2][1]
	local grabbedAbility = FindAbility(abilityName)

	if grabbedAbility == false then return end	
	
	grabbedAbility(Recieved)
end)
