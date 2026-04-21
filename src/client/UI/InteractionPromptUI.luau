local Players = game:GetService("Players")

local InteractionPromptUI = {}

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InteractionPromptGui"
screenGui.ResetOnSpawn = false
screenGui.Enabled = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "PromptFrame"
frame.AnchorPoint = Vector2.new(0.5, 1)
frame.Position = UDim2.new(0.5, 0, 0.9, 0)
frame.Size = UDim2.new(0, 320, 0, 60)
frame.BackgroundTransparency = 0.2
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local textLabel = Instance.new("TextLabel")
textLabel.Name = "PromptLabel"
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = ""
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.Font = Enum.Font.GothamBold
textLabel.TextScaled = true
textLabel.Parent = frame

function InteractionPromptUI.Show(targetName)
	textLabel.Text = "[E] Interact with " .. targetName
	screenGui.Enabled = true
end

function InteractionPromptUI.Hide()
	screenGui.Enabled = false
	textLabel.Text = ""
end

return InteractionPromptUI
