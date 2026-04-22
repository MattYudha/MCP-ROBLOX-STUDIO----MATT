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
local function GetXAndZPositions(Angle: number, Radius: number): any
	local X = math.cos(Angle) * Radius 
	local Z = math.sin(Angle) * Radius
	return X, Z
end

local Random = Random.new()
local function CreateCircle(Part, Number, Radius, Type): list
	local Attachments = { }
	local FullCircle = 2 * math.pi

	for i = 1, Number do
		local Attachment = Instance.new(Type)
		if Attachment:IsA('Part') then
			Attachment.Transparency = 1
			Attachment.Anchored = true
			Attachment.CanCollide = false
			Attachment.Size = Vector3.new(1, 1, 1)
		end
		Attachment.Parent = Part

		local Angle = i * (FullCircle / Number)
		local X, Z = GetXAndZPositions(Angle, Radius)

		local Position = ( Part.CFrame * CFrame.new(X, 0, Z) ).Position
		local LookAt = Part.Position

		if Attachment:IsA('Attachment') then
			Attachment.WorldCFrame = CFrame.lookAt(Position, LookAt) * CFrame.fromEulerAnglesXYZ(0, -math.pi / Random:NextNumber(1.85, 2), 0)
		else
			Attachment.CFrame = CFrame.lookAt(Position, LookAt) * CFrame.fromEulerAnglesXYZ(0, -math.pi / Random:NextNumber(1.85, 2), 0)
		end

		table.insert(Attachments, Attachment)
	end
	return Attachments
end

--—————— 

--—————— 
local FullCircle = 2 * math.pi
return function(RecievedInfo: any)


	local Player: Player = RecievedInfo[1]
	local Character: Model = Player.Character
	local humanoidRoot: BasePart = Character:FindFirstChild("HumanoidRootPart")
	local humanoid: Humanoid = Character:FindFirstChild("Humanoid")
	
	if not humanoidRoot or not humanoid then return end

	local Info = RecievedInfo[2]
	warn(Info)
	
	local Attachments = { }

	local Part = humanoidRoot
	
	local walkspeed = humanoid.WalkSpeed
	humanoidRoot.Anchored = true
	humanoid.WalkSpeed = 0
	
	for i = 1, 12 do
		local Attachment = ReplicatedStorage.VFX.Ball:Clone()
		Attachment.Parent = workspace.Ignore

		local Angle = i * (FullCircle / 12)
		local X, Z = GetXAndZPositions(Angle, 7)

		local Position = ( Part.CFrame * CFrame.new(X, 0, Z) ).Position
		local LookAt = Part.Position

		if Attachment:IsA('Attachment') then
			Attachment.WorldCFrame = CFrame.lookAt(Position, LookAt) * CFrame.fromEulerAnglesXYZ(0, -math.pi / Random:NextNumber(1.85, 2), 0)
		else
			Attachment.CFrame = CFrame.lookAt(Position, LookAt) * CFrame.Angles(0, math.rad(180), 0) --[[ * CFrame.fromEulerAnglesXYZ(0, -math.pi / Random:NextNumber(1.85, 2), 0)]]
		end
		
		table.insert(Attachments, Attachment)
		EmitAll(Attachment.Spawn)
		task.wait(.1)
	end
	
	task.wait(1)
	
	local Force = 155
	
	for _, v in Attachments do
		
		
		v.Elasticity *= RecievedInfo[2][2] + .25

		
		v.Anchored = false
		v:ApplyImpulse((v.CFrame * CFrame.Angles(math.rad(45), 0, 0)).LookVector * (Force * RecievedInfo[2][2]))
		
		task.delay(1.35, function()
			
			local exp = ReplicatedStorage.VFX.Explosion3:Clone()
			exp.Position = v.Position
			exp.Parent = workspace.Ignore
			EmitAll(exp.Attachment)
			camShake:Shake(cs.Presets.OrbExplosion)
			TaskDebris(exp, 3)
			TaskDebris(v, .2)
			
		end)
		
		task.wait(.1)
		
	end
	
	task.wait(.1)
	
	humanoid.WalkSpeed = walkspeed
	humanoidRoot.Anchored = false
	
end