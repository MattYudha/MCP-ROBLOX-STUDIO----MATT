local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Shared.Remotes.Remotes)

local MainController = {}

function MainController.Start()
	print("MainController started")

	task.wait(2)
	Remotes.TestEvent:FireServer()
end

MainController.Start()

return MainController
