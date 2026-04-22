--[[

	lmao this is a personal note, i always forget the CreateTween data

		Time=.5;
		EasingStyle="Smooth";
		EasingDirection="In";

		Reverses=false;
		DelayTime=0;
		RepeatCount=0;

		StepType="Heartbeat";

		Goal = {

			Transparency = NumberSequence.new(0)

		};

]]

--// Module Start \\--

local ZonitoVFX = {}

--// Services \\--

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

--// Local Variables \\--

local Camera = workspace.CurrentCamera
local Random = Random.new()
local FullCircle = 2 * math.pi

local BlurSize = 0 --// Set this to whatever your default blur size is, more info in :BlurFrame

--// Modules \\--

local CameraShaker = require(script.Parent.CameraShaker)
local BoatTween = require(script.Parent.BoatTween)
local Crater = require(script.Parent.Crater)

--// Setup \\--

export type TweenData = { --// For type checking outside of the module
	
	Time: number;
	EasingStyle: string;
	EasingDirection: string;

	Reverses: boolean;
	DelayTime: number;
	RepeatCount: number;

	StepType: string;

	Goal: {}
	
}

local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCFrame) --// Initiating CameraShaker (This might interact with other .new instances, so be careful)
	Camera.CFrame = Camera.CFrame * shakeCFrame
end)
camShake:Start()

--// ZonitoVFX Functions \\--

function ZonitoVFX.CreateTween(Object: Instance, TweenData: TweenData) --// Tweens using BoatTween
	local Tween = BoatTween.Create(Object, TweenData)
	return Tween
end

function ZonitoVFX.CreateCrater(CenterPart: Instance, AmountOfRocks: number, Radius: number, Offset: number, Lifetime: number, Size: Vector3) --// Creates a two-layered crater
	local crater = Crater.CreateCircle(CenterPart, AmountOfRocks, Radius, Offset, Lifetime, Size)
	return crater --// Returns the rocks
end

function ZonitoVFX:CameraShake(PresetName: string) --// Shakes the Camera using one of the presets in script.CameraShaker.CameraShakePresets
	camShake:Shake(CameraShaker.Presets[PresetName])
end

function ZonitoVFX:BlurFrame(FadeInTime: number, FadeOutTime: number, size: number) --// Tweens a blur-frame in and out for Impacts & Effects
	
	local blur = Instance.new("BlurEffect")
	blur.Name = "Blur"
	blur.Size = BlurSize
	blur.Parent = Lighting
	
	TweenService:Create(blur, TweenInfo.new(FadeInTime), {Size = size}):Play()
	
	task.delay(FadeInTime, function()
		TweenService:Create(blur, TweenInfo.new(FadeOutTime), {Size = BlurSize}):Play()
		task.wait(FadeOutTime + 0.05)
		blur:Destroy()
	end)
	
end

function ZonitoVFX:ColorFrame(FadeInTime: number, FadeOutTime: number, Color: Color3)
	
	local colorCorrection = Instance.new("ColorCorrectionEffect")
	colorCorrection.TintColor = Color3.new(1, 1, 1)
	colorCorrection.Parent = Lighting
	
	TweenService:Create(colorCorrection, TweenInfo.new(FadeInTime), {TintColor = Color}):Play()

	task.delay(FadeInTime, function()
		TweenService:Create(colorCorrection, TweenInfo.new(FadeOutTime), {TintColor = Color3.new(1,1,1)}):Play()
		task.wait(FadeOutTime + 0.05)
		colorCorrection:Destroy()
	end)
	
end

function ZonitoVFX:ImpactFrame(Timing: number, Amount: number, Highlighted: {}, HighlightColor: Color3) --// Flashes the screen black & white (Amount) times, waiting (Timing) seconds imbetween each flash
	
	for _, v in Highlighted do
		
		local Highlight = Instance.new("Highlight")
		Highlight.Name = "ImpactHighlight"
		Highlight.FillColor = HighlightColor
		Highlight.OutlineTransparency = 1
		Highlight.Parent = v
		
	end
	
	local cc = Lighting:FindFirstChild("Impact")
	if not cc then
		cc = Instance.new("ColorCorrectionEffect")
		cc.Brightness = 0
		cc.Contrast = 0
		cc.Saturation = 0
		cc.Enabled = true
		cc.TintColor = Color3.fromRGB(255,255,255)
		cc.Name = "Impact"
		cc.Parent = Lighting
	end

	local colorCorrection = cc:Clone()
	colorCorrection.Parent = game:GetService("Lighting")

	colorCorrection.Brightness = -1
	colorCorrection.Contrast = -100
	colorCorrection.Saturation = -1

	for _ = 1, Amount do
		colorCorrection.Contrast = -100
		task.wait(Timing)
		colorCorrection.Contrast = 100
		task.wait(Timing)
	end

	colorCorrection.Brightness = 0
	colorCorrection.Contrast = 0
	colorCorrection.Saturation = 0
	colorCorrection:Destroy()
	
	for _, v in Highlighted do
		
		v:FindFirstChild("ImpactHighlight"):Destroy()
		
	end
	
end

function ZonitoVFX:TaskDebris(Object: Instance, Lifetime: number) --// Destroys (Object) after (Lifetime) seconds using the task library
	task.delay(Lifetime, function() Object:Destroy() end)
end

function ZonitoVFX:GetXAndZPositions(Angle: number, Radius: number): any --// Used to get Positions for circle generation
	local X = math.cos(Angle) * Radius 
	local Z = math.sin(Angle) * Radius
	return X, Z
end

function ZonitoVFX.CreateCircle(Part: Instance, Number: number, Radius: number, Type: string): list --// Creates a circle of (Type)s around (Part) with a radius of (Radius)
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
		local X, Z = ZonitoVFX:GetXAndZPositions(Angle, Radius)

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

function ZonitoVFX:ToggleAll(Parent: Instance, Value: boolean, Switch: boolean, IncludeBeams: boolean, Descendants : boolean) --// Toggles the Enabled property ParticleEmitters (and Beams if IncludeBeams is true) in (Parent) to (Value), or reverses the value if (Switch)
	if not Descendants then
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
	else
		for _, v in Parent:GetDescendants() do
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
end

function ZonitoVFX:EmitAll(Parent: Instance, Descendants : boolean) --// Emits all ParticleEmitters parented to (Parent) using their EmitCount attribute
	if not Descendants then
		for _, v in Parent:GetChildren() do
			if v:IsA("ParticleEmitter") and v:GetAttribute("EmitCount") then
				task.delay(v:GetAttribute("EmitDelay"), function()
					v:Emit(v:GetAttribute("EmitCount"))
				end)
			end
		end
	else
		for _, v in Parent:GetDescendants() do
			if v:IsA("ParticleEmitter") and v:GetAttribute("EmitCount") then
				task.delay(v:GetAttribute("EmitDelay"), function()
					v:Emit(v:GetAttribute("EmitCount"))
				end)
			end
		end
	end
end

--// Module End \\--
return ZonitoVFX
