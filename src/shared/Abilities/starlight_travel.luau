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
local camera = workspace.CurrentCamera

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
	

	
	local floorRay = workspace:Raycast((humanoidRoot.CFrame * CFrame.new(Vector3.new(0, 0, -3))).Position, Vector3.new(0, -100, 0), ray)
	if floorRay then
		
		local walkspeed = humanoid.WalkSpeed
		humanoidRoot.Anchored = true
		humanoid.WalkSpeed = 0
		
		local floorBeam = ReplicatedStorage.VFXX.BeamPart:Clone()
		floorBeam.CFrame = humanoidRoot.CFrame * CFrame.new(Vector3.new(0, 0, -3))
		floorBeam.Position = floorRay.Position + Vector3.new(0, .1, 0)
		floorBeam.Parent = workspace.Ignore
		
		for _, v in floorBeam.Folder:GetChildren() do

			local Tween1 = boat:Create(v,{

				Time=.5;
				EasingStyle="EntranceExpressive";
				EasingDirection="In";

				Reverses=false;
				DelayTime=0;
				RepeatCount=0;

				StepType="Heartbeat";

				Goal = {

					Transparency = ReplicatedStorage.VFXX.Goals2:FindFirstChild(v.Name).Transparency

				};

			})
			Tween1:Play()

		end
		
		local Stars = {}
		for i = 0, 1, .2 do -- A + (B-A) * i
			
			local Star = ReplicatedStorage.VFXX.FallingStar:Clone()
			
			for _, v in Star.Beams:GetChildren() do
				
				local Tween1 = boat:Create(v,{

					Time=1;
					EasingStyle="EntranceExpressive";
					EasingDirection="In";

					Reverses=false;
					DelayTime=0;
					RepeatCount=0;

					StepType="Heartbeat";

					Goal = {

						Transparency = ReplicatedStorage.VFXX.Goals:FindFirstChild(v.Name).Transparency

					};

				})
				Tween1:Play()
				
			end
			
			Star.Position = (floorBeam.Position + (floorBeam.End.WorldPosition - floorBeam.Position) * i) + Vector3.new(0, 7, 0)
			Star.Name = "Star_"..tostring(i)
			Star.Parent = workspace.Ignore
			
			table.insert(Stars, Star)
			
		end
		
		local CharacterVFX = ReplicatedStorage.VFXX.Explosion2:Clone()
		CharacterVFX.CFrame = humanoidRoot.CFrame
		CharacterVFX.Parent = workspace.Ignore
		EmitAll(CharacterVFX.Attachment)
		TaskDebris(CharacterVFX, 2.6)
		
		task.wait(.4)
		
		for _, v in Character:GetDescendants() do
			
			if v:IsA("BasePart") then TweenService:Create(v, TweenInfo.new(.3), {Transparency = 1}):Play() end
			if v:IsA("Decal") then TweenService:Create(v, TweenInfo.new(.1), {Transparency = 1}):Play() end
			
		end
		
		task.wait(.6)
		
		for i = 1, #Stars, 1 do
			
			local Star = Stars[i]
			local camPart = Instance.new("Part")
			camPart.Transparency = 1
			camPart.Anchored = true
			camPart.CanCollide = false
			camPart.Position = Star.Position
			camPart.Size = Vector3.one
			camPart.Parent = workspace.Ignore
			TaskDebris(camPart, 1)
			
			TweenService:Create(Star, TweenInfo.new(.7, Enum.EasingStyle.Quint), {Position = Star.Position - Vector3.new(0, 7, 0)}):Play()
			
			
			
			if Player == game.Players.LocalPlayer then
				
				camera.CameraSubject = camPart
				
			end
			
			task.delay(.3, function()
				
				local Exp = ReplicatedStorage.VFXX.Explosion3:Clone()
				Exp.Position = Star.Position
				Exp.Parent = workspace.Ignore
				EmitAll(Exp.Attachment)
				ToggleAll(Star, false, false, true)
				ToggleAll(Star.Attachment, false, false, true)
				ToggleAll(Star.Beams, false, false, true)
				TaskDebris(Star, 2)
				TaskDebris(Exp, 3.5)
				--ImpactFrame(.02, 1)
				
			end)
			
			task.wait(.2)
			
		end
		
		if Player == game.Players.LocalPlayer then

			camera.CameraSubject = humanoid

		end
		humanoidRoot.CFrame *= CFrame.new(Vector3.new(0, 0, -46))
		local exp = ReplicatedStorage.VFXX.Explosion2:Clone()
		exp.Position = floorBeam.End.WorldPosition + Vector3.new(0,3,0)
		exp.Parent = workspace.Ignore
		EmitAll(exp.Attachment)
		task.wait(.4)

		for _, v in Character:GetDescendants() do
			if v == humanoidRoot then continue end
			if v:IsA("BasePart") then TweenService:Create(v, TweenInfo.new(.3), {Transparency = 0}):Play() end
			if v:IsA("Decal") then TweenService:Create(v, TweenInfo.new(.31), {Transparency = 0}):Play() end

		end
		
		humanoidRoot.Anchored = false
		humanoid.WalkSpeed = walkspeed
		

		TaskDebris(exp, 2.6)
		
		local Transparenc = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 1)})
		
		for _, v in floorBeam.Folder:GetChildren() do
			local Tween1 = boat:Create(v,{

				Time=1;
				EasingStyle="EntranceExpressive";
				EasingDirection="In";

				Reverses=false;
				DelayTime=0;
				RepeatCount=0;

				StepType="Heartbeat";

				Goal = {

					Transparency = Transparenc

				};

			})
			Tween1:Play()
		end
		
	end
	
end