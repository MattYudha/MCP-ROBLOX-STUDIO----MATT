local rep = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")
local remote = rep:WaitForChild("Remotes"):WaitForChild("Gon")
local DamageModule = require(game:GetService("ServerScriptService"):WaitForChild("Modules").DamageModule)
local RagdollModule = require(game:GetService("ServerScriptService"):WaitForChild("Modules").RagdollModule)
local RockModule = require(game:GetService("ServerScriptService"):WaitForChild("Modules").RocksModule)
local RaycastModule = require(game:GetService("ServerScriptService"):WaitForChild("Modules").RaycastHitbox)
local PhysicsService = game:GetService("PhysicsService")
local camShake = rep:WaitForChild("Remotes"):WaitForChild("CamShake")
local LightingRemote = rep:WaitForChild("Remotes"):WaitForChild("Lighting")
local CutsenseRemote = rep:WaitForChild("Remotes"):WaitForChild("Cutsense")

PhysicsService:RegisterCollisionGroup("Players")

PhysicsService:CollisionGroupSetCollidable("Players","Players",false)


function lerp(a, b, t)
	return a + (b - a) * t
end

function quadraticBezier(t, p0, p1, p2)
	local l1 = lerp(p0, p1, t)
	local l2 = lerp(p1, p2, t)
	local quad = lerp(l1, l2, t)
	return quad
end

remote.OnServerEvent:Connect(function(plr,wut,MousePos)
	local char = plr.Character
	local hum = char:WaitForChild("Humanoid")
	local hrp = char:WaitForChild("HumanoidRootPart")
	local visuals = workspace:WaitForChild("Visuals"..plr.UserId)
	char.Archivable = true
	------------------------------------------------------------

	local function CounterCheck(echar)
		if (not echar:FindFirstChild("UltraSense")) then
			return true
		else
			return false
		end
	end


	local function RagDoll(echar,ragTime)
		if not echar:FindFirstChild("Block") then
			if not echar:FindFirstChild("Ragdolling") then
				local Ragdolling = Instance.new("IntValue",echar)
				Ragdolling.Name = "Ragdolling"
				game.Debris:AddItem(Ragdolling,ragTime)
				local TooClose = Instance.new("IntValue",echar)
				TooClose.Name = "TooClose"
				game.Debris:AddItem(TooClose,ragTime + 0.25)
				task.spawn(function()
					RagdollModule:Start(echar)
				end)
				task.spawn(function()
					repeat
						task.wait()
					until not echar:FindFirstChild("Ragdolling")
					task.spawn(function()
						RagdollModule:Stop(echar)
					end)
				end)
			else
				local Ragdolling = Instance.new("IntValue",echar)
				Ragdolling.Name = "Ragdolling"
				game.Debris:AddItem(Ragdolling,ragTime)
				local TooClose = Instance.new("IntValue",echar)
				TooClose.Name = "TooClose"
				game.Debris:AddItem(TooClose,ragTime + 0.25)
			end
		end
	end

	local function CheckDown(echar)
		if echar:FindFirstChild("Ragdolling") then
			return false
		else
			return true
		end
	end
	
	local function DamageBox2(box,HitName,HitTime,pchar,dmg,Power,PT,ST,combo,breakAmount,Up,High,ragdoll,ragTime)
		local params = OverlapParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.MaxParts = 0
		params.FilterDescendantsInstances = {box,visuals}

		task.spawn(function()
			for i,hit in pairs(workspace:GetPartsInPart(box,params)) do
				local echar = hit.Parent
				if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
					if echar ~= char and not echar:FindFirstChild("CantDie")  then
						if not echar:FindFirstChild(HitName) then
							local GetHit = Instance.new("IntValue")
							GetHit.Parent = echar
							GetHit.Name = HitName
							game.Debris:AddItem(GetHit,HitTime)
							local ehum = echar:FindFirstChild("Humanoid")
							local ehrp = echar:FindFirstChild("HumanoidRootPart")
							if echar:FindFirstChild("Block") then
								local lookVector = echar.HumanoidRootPart.CFrame.LookVector
								local Position = hrp.Position - echar.HumanoidRootPart.Position
								if (lookVector:Dot(Position)) < 0 then
									echar:FindFirstChild("Block"):Destroy()
									if ehum.Health <= dmg then
										DamageModule:Spec(pchar,echar,15,200,0.25,ST,5,breakAmount,true,100)
										local Trail = rep.VFX.BasicAttack.WhiteTrail:Clone()
										Trail.Parent = visuals
										Trail.CFrame = ehrp.CFrame
										local weld = Instance.new("Weld",Trail)
										weld.Part0 = ehrp
										weld.Part1 = Trail
										Trail.Trail.Enabled = true
										RagdollModule:Start(echar)
									else
										task.spawn(function()
											DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,true)
										end)
									end
								else
									task.spawn(function()
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
									end)
								end
							else
								if ehum.Health <= dmg then
									DamageModule:Spec(pchar,echar,15,200,0.25,ST,5,breakAmount,true,100)
									local Trail = rep.VFX.BasicAttack.WhiteTrail:Clone()
									Trail.Parent = visuals
									Trail.CFrame = ehrp.CFrame
									local weld = Instance.new("Weld",Trail)
									weld.Part0 = ehrp
									weld.Part1 = Trail
									Trail.Trail.Enabled = true
									RagdollModule:Start(echar)
								else
									task.spawn(function()
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,true)
									end)
								end
							end
							task.spawn(function()
								if ragdoll == true then
									RagDoll(echar,ragTime)
								end
							end)
						end
					end
				end
			end
		end)
	end
	
	local function DamageBox3(box,HitName,HitTime,pchar,dmg,Power,PT,ST,combo,breakAmount,Up,High,ragdoll,ragTime)
		local params = OverlapParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.MaxParts = 0
		params.FilterDescendantsInstances = {box,visuals}

		task.spawn(function()
			for i,hit in pairs(workspace:GetPartsInPart(box,params)) do
				local echar = hit.Parent
				if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
					if echar ~= char and not echar:FindFirstChild("CantDie")  then
						if not echar:FindFirstChild(HitName) then
							local GetHit = Instance.new("IntValue")
							GetHit.Parent = echar
							GetHit.Name = HitName
							game.Debris:AddItem(GetHit,HitTime)
							local ehum = echar:FindFirstChild("Humanoid")
							local ehrp = echar:FindFirstChild("HumanoidRootPart")
							if echar:FindFirstChild("Block") then
								local lookVector = echar.HumanoidRootPart.CFrame.LookVector
								local Position = hrp.Position - echar.HumanoidRootPart.Position
								if (lookVector:Dot(Position)) < 0 then
									echar:FindFirstChild("Block"):Destroy()
									if ehum.Health <= dmg then
										task.spawn(function()
											DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
										end)
										RagdollModule:Start(echar)
										for i,v in pairs(echar:GetDescendants()) do
											if v:IsA("BasePart") or v:IsA("MeshPart") then
												v.Color = Color3.new(0, 0, 0)
											end
										end
									else
										task.spawn(function()
											DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
										end)
									end
								else
									task.spawn(function()
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
									end)
								end
							else
								if ehum.Health <= dmg then
									task.spawn(function()
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
									end)
									RagdollModule:Start(echar)
									for i,v in pairs(echar:GetDescendants()) do
										if v:IsA("BasePart") or v:IsA("MeshPart") then
											v.Color = Color3.new(0, 0, 0)
										end
									end
								else
									task.spawn(function()
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
									end)
								end
							end
							task.spawn(function()
								if ragdoll == true then
									RagDoll(echar,ragTime)
								end
							end)
						end
					end
				end
			end
		end)
	end
	--------------------------------------------------------------
	if wut == "Rock" then
		local tracks = hum:LoadAnimation(rep.Anims.Gon.RockPunch)
		tracks:Play()
		local FakeBall = rep.VFX.Characters.Gon.FakeBall:Clone()
		FakeBall.Parent = visuals
		FakeBall.CFrame = char:FindFirstChild("Right Arm").CFrame * CFrame.new(0,1.5,0)
		local weld = Instance.new("Weld",FakeBall)
		weld.Part0 = FakeBall
		weld.Part1 = char:FindFirstChild("Right Arm")
		weld.C0 = CFrame.new(0,1.5,0)
		ts:Create(FakeBall,TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 1,Size = Vector3.new(1.5,1.5,1.5)}):Play()
		task.wait(1)
		if not char:FindFirstChild("Stun") then
			FakeBall:Destroy()
			local RockBall = rep.VFX.Characters.Gon.RockBall:Clone()
			RockBall.Parent = visuals
			RockBall.CFrame = char:FindFirstChild("Right Arm").CFrame * CFrame.new(0,1.5,0)
			local weld = Instance.new("Weld",RockBall)
			weld.Part0 = RockBall
			weld.Part1 = char:FindFirstChild("Right Arm")
			weld.C0 = CFrame.new(0,1.5,0)
			RockBall.Trail.Enabled = true
			local sound = rep.Sounds.Gon.ChargeRock:Clone()
			sound.Parent = hrp
			sound.TimePosition = 0.5
			sound:Play()
			game.Debris:AddItem(sound,sound.TimeLength)
			for i,v in pairs(RockBall:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					spawn(function()
						local EA = v:GetAttribute("EmitCount")
						v:Emit(EA)
					end)
				end
			end
			task.wait(0.5)
			LightingRemote:FireClient(plr,"Rock")
			camShake:FireClient(plr,"ShakeOnce")
			local sound2 = rep.Sounds.Gon.ExplosionRock:Clone()
			sound2.Parent = hrp
			sound2:Play()
			game.Debris:AddItem(sound2,sound2.TimeLength)
			task.spawn(function()
				local FlamePart = rep.VFX.Characters.Gon.FlamePart:Clone()
				FlamePart.Parent = visuals
				FlamePart.CFrame = hrp.CFrame
				for i,v in pairs(FlamePart:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(EA)
						end)
					end
				end
				game.Debris:AddItem(FlamePart,1)
			end)
			task.spawn(function()
				local ExplosionPart = rep.VFX.Characters.Gon.RockExplosion:Clone()
				ExplosionPart.Parent = visuals
				ExplosionPart.CFrame = hrp.CFrame * CFrame.new(0,0,-8)
				for i,v in pairs(ExplosionPart:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(EA)
						end)
					end
				end
				DamageBox2(ExplosionPart,"Rocked",0.05,char,10,30,0.5,2,nil,false,false,false,false,false)
				game.Debris:AddItem(ExplosionPart,1)
			end)
			RockModule.Front(hrp,5,0.2,20,true,0.1,0.05,1,5,0)
			RockBall.Transparency = 1
			RockBall.Trail.Enabled = false
			game.Debris:AddItem(RockBall,0.5)
			task.wait(0.5)
			remote:FireClient(plr,"Done1")
		else
			FakeBall:Destroy()
			tracks:Stop()
			remote:FireClient(plr,"Done1")
		end
	end
	if wut == "Scissor" then
		local tracks = hum:LoadAnimation(rep.Anims.Gon.Scissor)
		tracks:Play()
		local Sword = rep.VFX.Characters.Gon.Scissor:Clone()
		Sword.Parent = visuals
		Sword.CFrame = char:FindFirstChild("Right Arm").CFrame
		local weld = Instance.new("Weld",Sword)
		weld.Part0 = Sword
		weld.Part1 = char:FindFirstChild("Right Arm")
		task.wait(0.5)
		if not char:FindFirstChild("Stun") then
			Sword.ScissorUnion.Trail1.Enabled = true
			Sword.ScissorUnion.Trail2.Enabled = true
			local CheckChar = {workspace.Debris}
			for i,plr in pairs(game:GetService("Players"):GetPlayers()) do
				if plr.Character then
					table.insert(CheckChar,plr.Character)
				end
			end
			for i,v in pairs(workspace:GetChildren()) do
				if v:FindFirstChild("Humanoid") then
					table.insert(CheckChar,v)
				end
			end
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Exclude
			params.FilterDescendantsInstances = CheckChar
			local NewCF = hrp.CFrame * CFrame.new(0,0,-30)
			local Result = workspace:Raycast(hrp.Position,NewCF.Position,params)
			local function FarDash()
				hum.AutoRotate = false
				local Cant = rep.VFX.BasicAttack.CantDie:Clone()
				Cant.Parent = char
				local SWR = rep.VFX.Characters.Goku.ShockwaveR:Clone()
				SWR.Parent = visuals
				SWR.CFrame = hrp.CFrame * CFrame.new(4,-1.25,2) * CFrame.Angles(0,math.rad(90),0)
				local SWL = rep.VFX.Characters.Goku.ShockwaveL:Clone()
				SWL.Parent = visuals
				SWL.CFrame = hrp.CFrame * CFrame.new(-4,-1.25,2) * CFrame.Angles(0,math.rad(90),0)
				ts:Create(SWR,TweenInfo.new(0.35,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 1,Size = Vector3.new(15, 6, 1.895),CFrame = SWR.CFrame * CFrame.new(-5,0.5,0)}):Play()
				ts:Create(SWL,TweenInfo.new(0.35,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 1,Size = Vector3.new(15, 6, 1.895),CFrame = SWL.CFrame * CFrame.new(-5,0.5,0)}):Play()
				local KameBox = rep.VFX.Boxes.FastBox:Clone()
				KameBox.Parent = visuals
				KameBox.CFrame = hrp.CFrame * CFrame.new(0,0,-30/2)
				KameBox.Transparency = 1
				KameBox.Size = Vector3.new(10,10,30)
				task.spawn(function()
					DamageBox3(KameBox,"MulHit",0.25,char,15,0,0.05,0.5,nil,nil,false,nil,false,nil)
				end)
				task.spawn(function()
					task.wait(0.35)
					SWR:Destroy()
					SWL:Destroy()
				end)
				local Beam = rep.VFX.Characters.Goku.BeamWave:Clone()
				Beam.Parent = visuals
				Beam.Color = Color3.new(1, 0.333333, 0)
				Beam.CFrame = hrp.CFrame * CFrame.Angles(0,math.rad(90),0)
				ts:Create(Beam,TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(30,3,3),CFrame = hrp.CFrame * CFrame.new(0,0,-30/2) * CFrame.Angles(0,math.rad(90),0)}):Play()
				task.spawn(function()
					task.wait(0.2)
					ts:Create(Beam,TweenInfo.new(0.35,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(30,0,0),Transparency = 1}):Play()
					task.wait(0.35)
					Beam:Destroy()
				end)
				hrp.CFrame = hrp.CFrame * CFrame.new(0,0,-30)
				task.wait(0.1)
				local SlashPart = rep.VFX.Characters.Gon.SlashPart:Clone()
				SlashPart.Parent = visuals
				SlashPart.CFrame = hrp.CFrame * CFrame.new(0,0,-3)
				for i,v in pairs(SlashPart:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(EA)
						end)
					end
				end
				game.Debris:AddItem(SlashPart,1)
				task.wait(0.3)
				Sword:Destroy()
				KameBox:Destroy()
				Cant:Destroy()
				hum.AutoRotate = true
				remote:FireClient(plr,"Done2")
			end
			local function NearDash(Distance)
				hum.AutoRotate = false
				local Cant = rep.VFX.BasicAttack.CantDie:Clone()
				Cant.Parent = char
				local SWR = rep.VFX.Characters.Goku.ShockwaveR:Clone()
				SWR.Parent = visuals
				SWR.CFrame = hrp.CFrame * CFrame.new(4,-1.25,2) * CFrame.Angles(0,math.rad(90),0)
				local SWL = rep.VFX.Characters.Goku.ShockwaveL:Clone()
				SWL.Parent = visuals
				SWL.CFrame = hrp.CFrame * CFrame.new(-4,-1.25,2) * CFrame.Angles(0,math.rad(90),0)
				local KameBox = rep.VFX.Boxes.FastBox:Clone()
				KameBox.Parent = visuals
				KameBox.CFrame = hrp.CFrame * CFrame.new(0,0,-Distance/2)
				KameBox.Transparency = 1
				KameBox.Size = Vector3.new(10,10,Distance)
				task.spawn(function()
					DamageBox3(KameBox,"MulHit",0.25,char,15,0,0.05,0.5,nil,nil,false,nil,false,nil)
				end)
				ts:Create(SWR,TweenInfo.new(0.35,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 1,Size = Vector3.new(15, 6, 1.895),CFrame = SWR.CFrame * CFrame.new(-5,0.5,0)}):Play()
				ts:Create(SWL,TweenInfo.new(0.35,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 1,Size = Vector3.new(15, 6, 1.895),CFrame = SWL.CFrame * CFrame.new(-5,0.5,0)}):Play()
				task.spawn(function()
					task.wait(0.35)
					SWR:Destroy()
					SWL:Destroy()
				end)
				local Beam = rep.VFX.Characters.Goku.BeamWave:Clone()
				Beam.Parent = visuals
				Beam.CFrame = hrp.CFrame * CFrame.Angles(0,math.rad(90),0)
				ts:Create(Beam,TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(Distance+2,3,3),CFrame = hrp.CFrame * CFrame.new(0,0,-Distance+1/2) * CFrame.Angles(0,math.rad(90),0)}):Play()
				task.spawn(function()
					task.wait(0.2)
					ts:Create(Beam,TweenInfo.new(0.35,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(Distance,0,0),Transparency = 1}):Play()
					task.wait(0.35)
					Beam:Destroy()
				end)
				hrp.CFrame = hrp.CFrame * CFrame.new(0,0,-Distance+2)
				task.wait(0.1)
				local SlashPart = rep.VFX.Characters.Gon.SlashPart:Clone()
				SlashPart.Parent = visuals
				SlashPart.CFrame = hrp.CFrame * CFrame.new(0,0,-3)
				for i,v in pairs(SlashPart:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(EA)
						end)
					end
				end
				game.Debris:AddItem(SlashPart,1)
				task.wait(0.3)
				Sword:Destroy()
				KameBox:Destroy()
				Cant:Destroy()
				hum.AutoRotate = true
				remote:FireClient(plr,"Done2")
			end
			local sound = rep.Sounds.Gon.FireSlash:Clone()
			sound.Parent = visuals
			sound.TimePosition = 0.2
			sound:Play()
			game.Debris:AddItem(sound,sound.TimeLength)
			if Result then
				if Result.Distance < 30 then
					NearDash(Result.Distance)
				else
					FarDash()
				end
			else
				FarDash()
			end
		else
			Sword:Destroy()
			tracks:Stop()
			remote:FireClient(plr,"Done2")
		end
	end
	if wut == "Paper" then
		local Hited = false
		local sound = rep.Sounds.Gon.ChargeRock:Clone()
		sound.Parent = hrp
		sound.TimePosition = 0.5
		sound:Play()
		game.Debris:AddItem(sound,sound.TimeLength)
		task.spawn(function()
			local FlamePart = rep.VFX.Characters.Gon.FlamePart:Clone()
			FlamePart.Parent = visuals
			FlamePart.CFrame = hrp.CFrame
			for i,v in pairs(FlamePart:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					spawn(function()
						local EA = v:GetAttribute("EmitCount")
						v:Emit(EA)
					end)
				end
			end
			game.Debris:AddItem(FlamePart,1)
		end)
		local FireBall = rep.VFX.Characters.Gon.FireBall:Clone()
		FireBall.Parent = visuals
		FireBall.CFrame = hrp.CFrame * CFrame.new(0,0,-3)
		FireBall.Trail.Enabled = true
		local bv = Instance.new("BodyVelocity",FireBall)
		bv.MaxForce = Vector3.new(1,1,1) * 10000000
		bv.P = 123456789
		bv.Velocity = hrp.CFrame.LookVector * 0
		ts:Create(FireBall,TweenInfo.new(0.35,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = hrp.CFrame * CFrame.new(0,0,-65)}):Play()
		local effect = true
		task.spawn(function()
			while effect do
				FireBall.MainAttach.Dots:Emit(1)
				FireBall.MainAttach.Dots2:Emit(1)
				task.wait()
			end
		end)
		task.spawn(function()
			while effect do
				FireBall.MainAttach.Wave:Emit(1)
				task.wait(0.1)
			end
		end)
		FireBall.Touched:Connect(function(hit)
			local echar = hit.Parent
			if echar ~= char and echar:FindFirstChild("Humanoid") then
				Hited = true
				effect = false
				bv:Destroy()
				FireBall.CanTouch = false
				FireBall.Transparency = 1
				FireBall.Anchored = true
				FireBall.Trail.Enabled = false
				FireBall.CFrame = echar:FindFirstChild("HumanoidRootPart").CFrame
				task.wait(0.1)
				task.spawn(function()
					local ExplosionPart = rep.VFX.Characters.Gon.RockExplosion:Clone()
					ExplosionPart.Parent = visuals
					ExplosionPart.CFrame = echar:FindFirstChild("HumanoidRootPart").CFrame
					local sound2 = rep.Sounds.Gon.ExplosionRock:Clone()
					sound2.Parent = ExplosionPart
					sound2:Play()
					game.Debris:AddItem(sound2,sound2.TimeLength)
					for i,v in pairs(ExplosionPart:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(EA)
							end)
						end
					end
					DamageBox3(ExplosionPart,"Paper",0.05,char,12,30,0.15,0.65,nil,false,false,false,false,false)
					game.Debris:AddItem(ExplosionPart,1)
				end)
				game.Debris:AddItem(FireBall,1)
			end
		end)
		task.wait(0.35)
		if Hited == false then
			Hited = false
			effect = false
			bv:Destroy()
			FireBall.CanTouch = false
			FireBall.Transparency = 1
			FireBall.Anchored = true
			task.wait(0.1)
			task.spawn(function()
				local ExplosionPart = rep.VFX.Characters.Gon.RockExplosion:Clone()
				ExplosionPart.Parent = visuals
				ExplosionPart.CFrame = FireBall.CFrame
				local sound2 = rep.Sounds.Gon.ExplosionRock:Clone()
				sound2.Parent = ExplosionPart
				sound2:Play()
				game.Debris:AddItem(sound2,sound2.TimeLength)
				for i,v in pairs(ExplosionPart:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(EA)
						end)
					end
				end
				DamageBox3(ExplosionPart,"Paper",0.05,char,12,30,0.15,0.65,nil,false,false,false,false,false)
				game.Debris:AddItem(ExplosionPart,1)
			end)
			game.Debris:AddItem(FireBall,1)
		end
	end
	if wut == "Paper2" then
		-- Pastikan MousePos adalah Vector3
		if MousePos and typeof(MousePos) == "Vector3" then
			hrp.CFrame = CFrame.lookAt(hrp.Position, MousePos)
		else
			warn("MousePos tidak valid atau nil.")
			return
		end

		task.wait(0.05)
		local sound = rep.Sounds.Gon.ChargeRock:Clone()
		sound.Parent = hrp
		sound.TimePosition = 0.5
		sound:Play()
		game.Debris:AddItem(sound, sound.TimeLength)
		local Hited = false
		task.spawn(function()
			local FlamePart = rep.VFX.Characters.Gon.FlamePart:Clone()
			FlamePart.Parent = visuals
			FlamePart.CFrame = hrp.CFrame
			for i, v in pairs(FlamePart:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					spawn(function()
						local EA = v:GetAttribute("EmitCount")
						v:Emit(EA)
					end)
				end
			end
			game.Debris:AddItem(FlamePart, 1)
		end)

		local FireBall = rep.VFX.Characters.Gon.FireBall:Clone()
		FireBall.Parent = visuals
		FireBall.CFrame = hrp.CFrame * CFrame.new(0,0,-3)
		FireBall.Trail.Enabled = true
		local bv = Instance.new("BodyVelocity",FireBall)
		bv.MaxForce = Vector3.new(1,1,1) * 10000000
		bv.P = 123456789
		bv.Velocity = hrp.CFrame.LookVector * 0
		local dis = (hrp.Position - MousePos).Magnitude
		if dis < 65 then
			ts:Create(FireBall,TweenInfo.new(0.35,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = hrp.CFrame * CFrame.new(0,0,-dis)}):Play()
		else
			ts:Create(FireBall,TweenInfo.new(0.35,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = hrp.CFrame * CFrame.new(0,0,-65)}):Play()
		end
		local effect = true
		task.spawn(function()
			while effect do
				FireBall.MainAttach.Dots:Emit(1)
				FireBall.MainAttach.Dots2:Emit(1)
				task.wait()
			end
		end)
		task.spawn(function()
			while effect do
				FireBall.MainAttach.Wave:Emit(1)
				task.wait(0.1)
			end
		end)

		FireBall.Touched:Connect(function(hit)
			local echar = hit.Parent
			if echar ~= char and echar:FindFirstChild("Humanoid") then
				Hited = true
				effect = false
				bv:Destroy()
				FireBall.CanTouch = false
				FireBall.Transparency = 1
				FireBall.Anchored = true
				FireBall.Trail.Enabled = false
				FireBall.CFrame =  echar:FindFirstChild("HumanoidRootPart").CFrame
				task.wait(0.1)
				task.spawn(function()
					local ExplosionPart = rep.VFX.Characters.Gon.RockExplosion:Clone()
					ExplosionPart.Parent = visuals
					ExplosionPart.CFrame = echar:FindFirstChild("HumanoidRootPart").CFrame
					local sound2 = rep.Sounds.Gon.ExplosionRock:Clone()
					sound2.Parent = ExplosionPart
					sound2:Play()
					game.Debris:AddItem(sound2,sound2.TimeLength)
					for i,v in pairs(ExplosionPart:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(EA)
							end)
						end
					end
					DamageBox3(ExplosionPart,"Paper",0.05,char,12,30,0.15,0.65,nil,false,false,false,false,false)
					game.Debris:AddItem(ExplosionPart,1)
				end)
				game.Debris:AddItem(FireBall,1)
			end
		end)
		task.wait(0.35)
		if Hited == false then
			Hited = true
			effect = false
			bv:Destroy()
			FireBall.CanTouch = false
			FireBall.Transparency = 1
			FireBall.Anchored = true
			task.wait(0.1)
			task.spawn(function()
				local ExplosionPart = rep.VFX.Characters.Gon.RockExplosion:Clone()
				ExplosionPart.Parent = visuals
				ExplosionPart.CFrame = FireBall.CFrame
				local sound2 = rep.Sounds.Gon.ExplosionRock:Clone()
				sound2.Parent = ExplosionPart
				sound2:Play()
				game.Debris:AddItem(sound2,sound2.TimeLength)
				for i,v in pairs(ExplosionPart:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(EA)
						end)
					end
				end
				DamageBox3(ExplosionPart,"Paper",0.05,char,12,30,0.15,0.65,nil,false,false,false,false,false)
				game.Debris:AddItem(ExplosionPart,1)
			end)
			game.Debris:AddItem(FireBall,1)
		end
	end
	if wut == "PreparePaper" then
		local FakeBall = rep.VFX.Characters.Gon.FakeBall:Clone()
		FakeBall.Parent = visuals
		FakeBall.CFrame = char:FindFirstChild("Right Arm").CFrame * CFrame.new(0,1.5,0)
		local weld = Instance.new("Weld",FakeBall)
		weld.Part0 = FakeBall
		weld.Part1 = char:FindFirstChild("Right Arm")
		weld.C0 = CFrame.new(0,1.5,0)
		ts:Create(FakeBall,TweenInfo.new(0.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 1,Size = Vector3.new(1.5,1.5,1.5)}):Play()
		task.wait(0.5)
		FakeBall:Destroy()
	end
end)

