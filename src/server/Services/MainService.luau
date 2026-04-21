local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Shared.Remotes.Remotes)

local MainService = {}

function MainService.Start()
	print("MainService started")

	Remotes.TestEvent.OnServerEvent:Connect(function(player)
		print(player.Name .. " fired TestEvent")
	end)
end

MainService.Start()

return MainService
