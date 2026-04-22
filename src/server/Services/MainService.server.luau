local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Shared.Remotes.Remotes)

local MainService = {}

local BridgeNet = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("BridgeNet2"))
local ServerBridge = BridgeNet.ServerBridge("Replicator")

function MainService.Start()
	print("MainService started")

	Remotes.TestEvent.OnServerEvent:Connect(function(player)
		print(player.Name .. " fired TestEvent")
	end)
end

MainService.Start()

return MainService
