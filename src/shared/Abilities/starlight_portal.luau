--—————— Services

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

--—————— VFX Functions
local zc = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("ZonitoCurves"))
local boat = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("BoatTween"))
local cs = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("CameraShaker"))
local camera = workspace.CurrentCamera

local camShake = cs.new(Enum.RenderPriority.Camera.Value, function(shakeCFrame)
	camera.CFrame = camera.CFrame * shakeCFrame
end)
camShake:Start()

local function ImpactFrame(Timing: number, Amount: number)

	local cc = game:GetService("Lighting"):FindFirstChild("Impact")
	if not cc then

		cc = Instance.new("ColorCorrectionEffect")
		cc.Brightness = 0
		cc.Contrast = 0
		cc.Saturation = 0
		cc.Enabled = true
		cc.TintColor = Color3.fromRGB(255,255,255)
		cc.Name = "Impact"
		cc.Parent = game:GetService("Lighting")

	end

	local colorCorrection = cc:Clone()
	colorCorrection.Parent = game:GetService("Lighting")

	colorCorrection.Brightness = -1
	colorCorrection.Contrast = -10
	colorCorrection.Saturation = -1

	for _ = 1, Amount do
		
		colorCorrection.Contrast = -10
		
		task.wait(Timing)

		colorCorrection.Contrast = 10
		
		task.wait(Timing)

	end
	colorCorrection.Brightness = 0
	colorCorrection.Contrast = 0
	colorCorrection.Saturation = 0

	colorCorrection:Destroy()

end

local function EmitAll(Parent: Instance)
	for _, v in Parent:GetChildren() do
		if v:IsA("ParticleEmitter") and v:GetAttribute("EmitCount") then
			task.delay(v:GetAttribute("EmitDelay"), function()
				v:Emit(v:GetAttribute("EmitCount"))
			end)
		end
	end
end

local function ToggleAll(Parent: Instance, Value: boolean, Switch: boolean, IncludeBeams: boolean)
	for _, v in Parent:GetChildren() do
		if v:IsA("ParticleEmitter") then
			if Switch then
				v.Enabled = not v.Enabled
			else
				v.Enabled = Value
			end
		end
		if IncludeBeams and (v:IsA("Beam")) or (v:IsA("Trail")) then
			if Switch then
				v.Enabled = not v.Enabled
			else
				v.Enabled = Value
			end
		end
	end
end

local function TaskDebris(Object: Instance, Lifetime: number)
	task.delay(Lifetime, function() Object:Destroy() end)
end

--—————— 

--—————— 

return function(RecievedInfo: any)


	local Player: Player = RecievedInfo[1]
	local Character: Model = Player.Character
	local humanoidRoot: BasePart = Character:FindFirstChild("HumanoidRootPart")
	local humanoid: Humanoid = Character:FindFirstChild("Humanoid")
	
	if not humanoidRoot or not humanoid then return end

	local Info = RecievedInfo[2]
	
	local ray = RaycastParams.new()
	ray.FilterDescendantsInstances = {workspace.Ignore, Character}
	ray.FilterType = Enum.RaycastFilterType.Exclude
	

	
	local floorRay = workspace:Raycast((humanoidRoot.CFrame * CFrame.new(Vector3.new(0, 0, 0))).Position, Vector3.new(0, -100, 0), ray)
	if floorRay then
		
		local walkspeed = humanoid.WalkSpeed
		humanoidRoot.Anchored = true
		humanoid.WalkSpeed = 0
		
		local Portal = ReplicatedStorage.VFX.Portal:Clone()
		Portal.Position = floorRay.Position + Vector3.new(0, .1, 0)
		Portal.Parent = workspace.Ignore
		
		if Player == Players.LocalPlayer then
			
			workspace.CurrentCamera.CameraSubject = Portal
			
		end
		
		task.wait(2)
		
		TweenService:Create(humanoidRoot, TweenInfo.new(1, Enum.EasingStyle.Quint), {CFrame = humanoidRoot.CFrame * CFrame.new(Vector3.new(0, -9, 0))}):Play()
		
		local CFram = ReplicatedStorage.PlayerInfo.MousePositions[Player.Name.."Mouse"].Value
		
		local portal = ReplicatedStorage.VFX.Portal:Clone()
		portal.Position = CFram + Vector3.new(0, .1, 0)
		portal.Parent = workspace.Ignore
		
		task.delay(1.01, function()
			
			humanoidRoot.CFrame = portal.CFrame * CFrame.new(Vector3.new(0, -10, 0))
			TweenService:Create(humanoidRoot, TweenInfo.new(1, Enum.EasingStyle.Quint), {CFrame = humanoidRoot.CFrame * CFrame.new(Vector3.new(0, 16, 0))}):Play()
			
			task.wait(1)
			
			ToggleAll(Portal, false)
			ToggleAll(Portal.Attachment, false)
			ToggleAll(portal, false)
			ToggleAll(portal.Attachment, false)
			humanoidRoot.Anchored = false
			humanoid.WalkSpeed = walkspeed
			TaskDebris(Portal, 3.1)
			TaskDebris(portal, 3.1)
			
			if Player == Players.LocalPlayer then

				workspace.CurrentCamera.CameraSubject = humanoid

			end
			
		end)
		
	end
	
end