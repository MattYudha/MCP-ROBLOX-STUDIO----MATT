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
local cs = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("CameraShaker"))
local camera = workspace.CurrentCamera

local camShake = cs.new(Enum.RenderPriority.Camera.Value, function(shakeCFrame)
	camera.CFrame = camera.CFrame * shakeCFrame
end)
camShake:Start()

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
	
	local walkspeed = humanoid.WalkSpeed
	humanoidRoot.Anchored = true
	humanoid.WalkSpeed = 0
	
	local originalVFX = ReplicatedStorage.VFX.Original:Clone()
	
	--local vfxValue = 1
	local maxVFXValue = #originalVFX:GetChildren()
	local waitTime = 2
	
	originalVFX.CFrame = humanoidRoot.CFrame * CFrame.new(Vector3.new(0, 13, 0))
	originalVFX.Parent = workspace.Ignore
	local vfxvalue2;
	local function hitFunction(HitPart)
		
		camShake:Shake(cs.Presets.SpawnFX)
		ToggleAll(HitPart, false)
		ToggleAll(HitPart.Attachment, false)
		TaskDebris(HitPart, 2)

		ToggleAll(originalVFX[tostring(HitPart.Name)], false)

		local vfxValue = tonumber(HitPart.Name)
		
		vfxValue+=1

		originalVFX[tostring(vfxValue)].Emit1:Emit(originalVFX[tostring(vfxValue)].Emit1:GetAttribute("EmitCount"))
		originalVFX[tostring(vfxValue)].Emit2:Emit(originalVFX[tostring(vfxValue)].Emit2:GetAttribute("EmitCount"))
		originalVFX[tostring(vfxValue)].Emit3:Emit(originalVFX[tostring(vfxValue)].Emit3:GetAttribute("EmitCount"))

		ToggleAll(originalVFX[tostring(vfxValue)], true)
		vfxvalue2=vfxValue

	end
	
	task.wait(waitTime)
	
	local rp = RaycastParams.new()
	rp.FilterDescendantsInstances = {Character, workspace.Ignore}
	rp.FilterType = Enum.RaycastFilterType.Exclude
	
	for i = 1, maxVFXValue-1, 1 do
		
		local newPart = ReplicatedStorage.VFX.ChargeUp:Clone()
		
		local newPosition = humanoidRoot.Position + Vector3.new(math.random(-15, 15), 15, math.random(-15 ,15))
		local newRay = workspace:Raycast(newPosition, Vector3.new(0, -100, 0), rp)
		
		if newRay then
			
			local spawnfx = ReplicatedStorage.VFX.Spawn:Clone()
			spawnfx.Position = newRay.Position + Vector3.new(0, .1, 0)
			spawnfx.Parent = workspace.Ignore
			EmitAll(spawnfx.Attachment)
			TaskDebris(spawnfx, 1.5)
			
			newPart.Position = newRay.Position
			newPart.Name = i
			newPart.Parent = workspace.Ignore
			
			task.wait()
			
			zc.CubicCurve2(newPart, newPart.Position, originalVFX.Position, 0.02, Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10)), Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10)), Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10)), false, hitFunction)
			
		else
			newPart:Destroy()
			continue
		end
		
		task.wait(waitTime)
		
	end
	humanoid.WalkSpeed = walkspeed
	task.wait()
	
	originalVFX[tostring(vfxvalue2)].Emit1:Emit(originalVFX[tostring(vfxvalue2)].Emit1:GetAttribute("EmitCount"))
	originalVFX[tostring(vfxvalue2)].Emit2:Emit(originalVFX[tostring(vfxvalue2)].Emit2:GetAttribute("EmitCount"))
	originalVFX[tostring(vfxvalue2)].Emit3:Emit(originalVFX[tostring(vfxvalue2)].Emit3:GetAttribute("EmitCount"))
	
	task.wait(3)
	
	local value = maxVFXValue+1
	for _ = 1, maxVFXValue-1, 1 do
		
		value-=1
		print(value)
		
		for _, v in originalVFX:GetChildren() do

			if v:IsA("Attachment") then

				ToggleAll(v, false)

			end

		end
		
		ToggleAll(originalVFX[tostring(value)], true)
		originalVFX[tostring(value)].Emit1:Emit(originalVFX[tostring(value)].Emit1:GetAttribute("EmitCount"))
		originalVFX[tostring(value)].Emit2:Emit(originalVFX[tostring(value)].Emit2:GetAttribute("EmitCount"))
		originalVFX[tostring(value)].Emit3:Emit(originalVFX[tostring(value)].Emit3:GetAttribute("EmitCount"))
		
		local projectile = ReplicatedStorage.VFX.ChargeUp:Clone()
		projectile.CanCollide = true
		projectile.Anchored = false
		projectile.Position = originalVFX.Position
		projectile.Parent = workspace.Ignore
		projectile:ApplyImpulse(Vector3.new(math.random(-100, 100), math.random(300, 400), math.random(-100, 100)))
		task.delay(2.6, function()
			
			local exp = ReplicatedStorage.VFX.Explosion:Clone()
			exp.Position = projectile.Position
			exp.Parent = workspace.Ignore
			camShake:Shake(cs.Presets.ExplosionFX)
			
			EmitAll(exp.Attachment)
			TaskDebris(exp, 3)
			
			projectile:Destroy()
			
		end)
		task.wait(1)
		
	end
	
	for _, v in originalVFX:GetChildren() do

		if v:IsA("Attachment") then

			ToggleAll(v, false)

		end

	end
	
	humanoidRoot.Anchored = false
	
end