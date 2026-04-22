local rep = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")
local remote = rep:WaitForChild("Remotes"):WaitForChild("Gojo")
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
		if (not echar:FindFirstChild("UltraSense") and not echar:FindFirstChild("HoraCounter") and not echar:FindFirstChild("ManjiCounter")) then
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

	local function RagDoll2(echar,ragTime)
		if not echar:FindFirstChild("Block") then
			if not echar:FindFirstChild("Ragdolling") then
				local Ragdolling = Instance.new("IntValue",echar)
				Ragdolling.Name = "Ragdolling"
				game.Debris:AddItem(Ragdolling,ragTime)
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

	local function DamageBox2(box,HitName,HitTime,pchar,dmg,Power,PT,ST,combo,breakAmount,Up,High,ragdoll,ragTime,DirPush)
		local params = OverlapParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.MaxParts = 0
		params.FilterDescendantsInstances = {box,visuals}

		task.spawn(function()
			for i,hit in pairs(workspace:GetPartsInPart(box,params)) do
				local echar = hit.Parent
				if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
					if echar ~= char and not echar:FindFirstChild("HyperArmor") and not echar:FindFirstChild("StrongArmor") then
						if not echar:FindFirstChild(HitName) then
							local GetHit = Instance.new("IntValue")
							GetHit.Parent = echar
							GetHit.Name = HitName
							game.Debris:AddItem(GetHit,HitTime)
							local ehum = echar:FindFirstChild("Humanoid")
							local ehrp = echar:FindFirstChild("HumanoidRootPart")
							if echar:FindFirstChild("Block") then
								echar:FindFirstChild("Block"):Destroy()
								if ehum.Health <= dmg then
									DamageModule:Spec(pchar,echar,30,200,0.25,ST,nil,breakAmount,true,0.65,false,false,DirPush)
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
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								end
							else
								if ehum.Health <= dmg then
									DamageModule:Spec(pchar,echar,30,200,0.25,ST,nil,breakAmount,true,0.65,false,false,DirPush)
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
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								end
							end
							task.spawn(function()
								if ragdoll == true then
									if CounterCheck(echar) then
										RagDoll2(echar,ragTime)
									end
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
					if echar ~= char and not echar:FindFirstChild("HyperArmor") and not echar:FindFirstChild("StrongArmor") and CheckDown(echar)  then
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
									if CounterCheck(echar) then
										RagDoll2(echar,ragTime)
									end
								end
							end)
						end
					end
				end
			end
		end)
	end

	local function DamageBox4(box,HitName,HitTime,pchar,dmg,Power,PT,ST,combo,breakAmount,Up,High,ragdoll,ragTime)
		local params = OverlapParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.MaxParts = 0
		params.FilterDescendantsInstances = {box,visuals}

		task.spawn(function()
			for i,hit in pairs(workspace:GetPartsInPart(box,params)) do
				local echar = hit.Parent
				if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
					if echar ~= char and not echar:FindFirstChild("HyperArmor") and not echar:FindFirstChild("StrongArmor") and CheckDown(echar) and CounterCheck(echar)  then
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
									echar:FindFirstChild("Block"):Destroy()
									if ehum.Health <= dmg then
										task.spawn(function()
											DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
										end)
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
							else
								if ehum.Health <= dmg then
									task.spawn(function()
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
									end)
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
									if CounterCheck(echar) then
										RagDoll2(echar,ragTime)
									end
								end
							end)
						end
					end
				end
			end
		end)
	end

	local function DamageBox5(box,HitName,HitTime,pchar,dmg,Power,PT,ST,combo,breakAmount,Up,High,ragdoll,ragTime,GiveAwa)
		local params = OverlapParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.MaxParts = 0
		params.FilterDescendantsInstances = {box,visuals}

		task.spawn(function()
			for i,hit in pairs(workspace:GetPartsInPart(box,params)) do
				local echar = hit.Parent
				if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
					if echar ~= char and not echar:FindFirstChild("HyperArmor") then
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
											DamageModule:TrueDamage(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,false,GiveAwa)
										end)
										for i,v in pairs(echar:GetDescendants()) do
											if v:IsA("BasePart") or v:IsA("MeshPart") then
												v.Color = Color3.new(0, 0, 0)
											end
										end
									else
										task.spawn(function()
											DamageModule:TrueDamage(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,false,GiveAwa)
										end)
									end
								else
									echar:FindFirstChild("Block"):Destroy()
									if ehum.Health <= dmg then
										task.spawn(function()
											DamageModule:TrueDamage(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,false,GiveAwa)
										end)
										for i,v in pairs(echar:GetDescendants()) do
											if v:IsA("BasePart") or v:IsA("MeshPart") then
												v.Color = Color3.new(0, 0, 0)
											end
										end
									else
										task.spawn(function()
											DamageModule:TrueDamage(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,false,GiveAwa)
										end)
									end
								end
							else
								if ehum.Health <= dmg then
									task.spawn(function()
										DamageModule:TrueDamage(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,false,GiveAwa)
									end)
									for i,v in pairs(echar:GetDescendants()) do
										if v:IsA("BasePart") or v:IsA("MeshPart") then
											v.Color = Color3.new(0, 0, 0)
										end
									end
								else
									task.spawn(function()
										DamageModule:TrueDamage(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,false,GiveAwa)
									end)
								end
							end
							task.spawn(function()
								if ragdoll == true then
									if CounterCheck(echar) then
										RagDoll(echar,ragTime)
									end
								end
							end)
						end
					end
				end
			end
		end)
	end
	-----------------------------------------------------------------
	if wut == "Blue" then
		hum:LoadAnimation(rep.Anims.Gojo.Blue):Play()
		local PrepareEffect = true
		local BluePart = rep.VFX.Characters.Gojo.Blue:Clone()
		BluePart.Parent = visuals
		BluePart.CFrame = hrp.CFrame
		local weld = Instance.new("Weld",BluePart)
		weld.Part0 = char:WaitForChild("Right Arm")
		weld.Part1 = BluePart
		weld.C0 = CFrame.new(0,-1.5,0)
		task.spawn(function()
			while PrepareEffect do
				task.spawn(function()
					for i,v in pairs(BluePart:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(1)
							end)
						end
					end
				end)
				task.wait(0.1)
			end
		end)
		task.wait(1.2)
		if not char:FindFirstChild("Stun") then

			PrepareEffect = false
			local Touched = false
			local sound = rep.Sounds.Gojo.Blue:Clone()
			sound.Parent = hrp
			sound:Play()
			game.Debris:AddItem(sound,sound.TimeLength)
			local effect = true
			local BlueThrow = rep.VFX.Characters.Gojo.Blue:Clone()
			BlueThrow.Parent = visuals
			BlueThrow.CFrame = hrp.CFrame
			BlueThrow.Trail.Enabled = true
			local flyTrack = ts:Create(BlueThrow,TweenInfo.new(0.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = hrp.CFrame * CFrame.new(0,0,-50)})
			flyTrack:Play()
			BlueThrow.Touched:Connect(function(hit)
				if Touched == false then
					local echar = hit.Parent
					if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
						if echar ~= char and not echar:FindFirstChild("CantDie") and Touched == false  then
							Touched = true
							effect = false
							flyTrack:Pause()
							BlueThrow.Trail.Enabled = false
							BlueThrow.CFrame = echar.HumanoidRootPart.CFrame
							game.Debris:AddItem(BlueThrow,0.5)
							local Explosion = rep.VFX.Characters.Gojo.BlueExplosion:Clone()
							Explosion.Parent = visuals
							Explosion.CFrame = echar.HumanoidRootPart.CFrame
							task.spawn(function()
								DamageBox3(Explosion,"Blue",0.1,char,20,1,0.05,0.75,nil,nil,false,false,false,nil)
							end)
							local sound2 = rep.Sounds.Gojo.BlueExplosion:Clone()
							sound2.Parent = Explosion
							sound2:Play()
							game.Debris:AddItem(sound2,sound2.TimeLength)
							task.spawn(function()
								for i,v in pairs(Explosion:GetDescendants()) do
									if v:IsA("ParticleEmitter") then
										spawn(function()
											local EA = v:GetAttribute("EmitCount")
											v:Emit(EA)
										end)
									end
								end
							end)
							game.Debris:AddItem(Explosion,3)
						end
					end
				end
			end)
			task.spawn(function()
				while effect do
					task.spawn(function()
						for i,v in pairs(BlueThrow:GetDescendants()) do
							if v:IsA("ParticleEmitter") then
								spawn(function()
									local EA = v:GetAttribute("EmitCount")
									v:Emit(1)
								end)
							end
						end
					end)
					task.wait(0.1)
				end
			end)
			local bv = Instance.new("BodyVelocity",BlueThrow)
			bv.MaxForce = Vector3.new(1,1,1) * 10000
			bv.P = 12345678
			bv.Velocity = Vector3.new(0,0,0)
			task.spawn(function()
				task.wait(0.5)
				if Touched == false then
					Touched = true
					effect = false
					game.Debris:AddItem(BlueThrow,0.5)
					local Explosion = rep.VFX.Characters.Gojo.BlueExplosion:Clone()
					Explosion.Parent = visuals
					Explosion.CFrame = BlueThrow.CFrame
					task.spawn(function()
						DamageBox3(Explosion,"Blue",0.1,char,20,1,0.05,0.5,nil,nil,false,false,false,nil)
					end)
					local sound2 = rep.Sounds.Gojo.BlueExplosion:Clone()
					sound2.Parent = Explosion
					sound2:Play()
					game.Debris:AddItem(sound2,sound2.TimeLength)
					task.spawn(function()
						for i,v in pairs(Explosion:GetDescendants()) do
							if v:IsA("ParticleEmitter") then
								spawn(function()
									local EA = v:GetAttribute("EmitCount")
									v:Emit(EA)
								end)
							end
						end
					end)
					game.Debris:AddItem(Explosion,3)
				end
			end)
			game.Debris:AddItem(BluePart,0.5)
			remote:FireClient(plr,"Done1")
		else
			PrepareEffect = false
			game.Debris:AddItem(BluePart,0.5)
			remote:FireClient(plr,"Done1")
		end
	end

	if wut == "Red" then
		local target
		local Properties = {
			Whitelist = {},
			Origin = char.HumanoidRootPart.CFrame,
			Range = 30,
			User = char,
			Width = 20,
			Length = 10,
			Height = 20,
		}

		local abs = math.abs
		if Properties.Origin and Properties.Range then
			local Detected = {}
			for i, v in pairs(workspace:GetChildren()) do
				if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and not game.Workspace[v.Name]:FindFirstChild("HyperArmor") then
					local Result = (v:FindFirstChild("HumanoidRootPart").Position - Properties.Origin.p).Magnitude < Properties.Range
					if Properties.Length then
						Result = Result and (Properties.Origin:Inverse() * v:FindFirstChild("HumanoidRootPart").CFrame).Z < Properties.Length
					end
					if Properties.Width then
						Result = Result and abs((Properties.Origin:Inverse() * v:FindFirstChild("HumanoidRootPart").CFrame).X) < Properties.Width
					end
					if Properties.Height then
						Result = Result and abs((Properties.Origin:Inverse() * v:FindFirstChild("HumanoidRootPart").CFrame).Y) < Properties.Height
					end
					if Result then
						if Properties.User and v ~= Properties.User and not table.find(Properties.Whitelist, v) and not target then
							target = v
						end
					end
				end
			end
			if next(Detected) then
				return Detected
			end
		end
		local Stunnedv = true
		local KickAnim = hum:LoadAnimation(rep.Anims.Gojo.Kick)
		local Kick = rep.VFX.Characters.Gojo.Kick:Clone()
		Kick.Parent = visuals
		delay(3.75,function()
			if target then
				if Stunnedv == false then
					KickAnim:Play()
					char.HumanoidRootPart.CFrame = CFrame.new(target.HumanoidRootPart.CFrame.Position + target.HumanoidRootPart.CFrame.LookVector * -2,target.HumanoidRootPart.CFrame.Position)
					Kick.CFrame = hrp.CFrame
					KickAnim:GetMarkerReachedSignal("Damage"):Connect(function()
						DamageBox2(Kick,"RedExplo",0.1,char,15,80,0.25,2,nil,false,true,0.3,true,2,true)
						Kick:Destroy()
					end)
				end
			end
		end)
		local track = hum:LoadAnimation(rep.Anims.Gojo.Red)
		track:Play()
		local PrepareEffect = true
		local RedPart = rep.VFX.Characters.Gojo.Red:Clone()
		RedPart.Parent = visuals
		RedPart.CFrame = hrp.CFrame
		local weld = Instance.new("Weld",RedPart)
		weld.Part0 = char:WaitForChild("Right Arm")
		weld.Part1 = RedPart
		weld.C0 = CFrame.new(0,-1.5,0)
		local Gojosound = rep.Sounds.Gojo.Red:Clone()
		Gojosound.Parent = hrp
		Gojosound.TimePosition = 1.2
		Gojosound:Play()
		game.Debris:AddItem(Gojosound,Gojosound.TimeLength)
		task.spawn(function()
			while PrepareEffect do
				task.spawn(function()
					for i,v in pairs(RedPart:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(1)
							end)
						end
					end
				end)
				task.wait(0.1)
			end
		end)
		task.wait(1.5)
		if not char:FindFirstChild("Stun") then
			Stunnedv = false
			PrepareEffect = false
			game.Debris:AddItem(RedPart,0.5)
			local Explosion = rep.VFX.Characters.Gojo.RedExplosion:Clone()
			Explosion.Parent = visuals
			Explosion.CFrame = hrp.CFrame
			local sound2 = rep.Sounds.Gojo.RedExplosion:Clone()
			sound2.Parent = hrp
			sound2:Play()
			game.Debris:AddItem(sound2,sound2.TimeLength)
			task.spawn(function()
				for i,v in pairs(Explosion:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(EA)
						end)
					end
				end
			end)
			game.Debris:AddItem(Explosion,4)
			task.spawn(function()
				for i,v in pairs(game:GetService("Players"):GetPlayers()) do
					if v ~= plr then
						if (v.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 35 then
							LightingRemote:FireClient(v,"RedExplosion")
							camShake:FireClient(v,"RedShake")
						end
					end
				end
				LightingRemote:FireClient(plr,"RedExplosion")
				camShake:FireClient(plr,"RedShake")
			end)
			task.spawn(function()
				DamageBox2(Explosion,"RedExplo",0.1,char,15,80,0.25,2,nil,false,true,0.3,true,2,true)

			end)
			task.spawn(function()
				RockModule.Ground(hrp.Position,25,Vector3.new(3,3,3),{visuals},15,false,5,0.25)
			end)

			track:Stop()
			task.wait(0.5)
			remote:FireClient(plr,"Done2")
		else
			track:Stop()
			PrepareEffect = false
			game.Debris:AddItem(RedPart,0.5)
			remote:FireClient(plr,"Done2")
		end
	end

	if wut == "Barrage" then
		hum:LoadAnimation(rep.Anims.Gojo.JumpKick):Play()
		task.wait(0.4)
		if not char:FindFirstChild("Stun") then
			local Beated = false
			local sound = rep.Sounds.BasicAttack.PunchSwing:Clone()
			sound.Parent = hrp
			sound:Play()
			game.Debris:AddItem(sound,sound.TimeLength)
			local box = rep.VFX.Boxes.SlamDown:Clone()
			box.Parent = visuals
			box.CFrame = hrp.CFrame * CFrame.new(0,2,2)
			box.Transparency = 1
			local w1 = Instance.new("Weld",box)
			w1.Part0 = box
			w1.Part1 = hrp
			w1.C0 = CFrame.new(0,2,2)
			game.Debris:AddItem(box,0.2)
			task.spawn(function()
				local params = OverlapParams.new()
				params.FilterType = Enum.RaycastFilterType.Exclude
				params.MaxParts = 0
				params.FilterDescendantsInstances = {box,visuals}
				local HitName = "PunchBarrage"
				local HitTime = 0.1
				task.spawn(function()
					for i,hit in pairs(workspace:GetPartsInPart(box,params)) do
						local echar = hit.Parent
						if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
							if echar ~= char and not echar:FindFirstChild("HyperArmor") and not echar:FindFirstChild("StrongArmor")  then
								if not echar:FindFirstChild(HitName) and Beated == false and CheckDown(echar) then
									local GetHit = Instance.new("IntValue")
									GetHit.Parent = echar
									GetHit.Name = HitName
									game.Debris:AddItem(GetHit,HitTime)
									Beated = true
									task.wait(0.1)
									local ehum = echar:FindFirstChild("Humanoid")
									local ehrp = echar:FindFirstChild("HumanoidRootPart")
									local function Beating()
										for i,v in pairs(char:GetChildren()) do
											if v.Name == "Ragdolling" then
												v:Destroy()
											end
										end
										if not CounterCheck(echar) then
											task.spawn(function()
												DamageModule:Spec(char,echar,1,1,0.05,2,math.random(1,4),nil,false,nil,false)
											end)
											remote:FireClient(plr,"Done3")
										else
											task.spawn(function()
												DamageModule:Spec(char,echar,1,1,0.05,2,math.random(1,4),nil,false,nil,false)
											end)
											if ehum.Health > 0 then
												local Massless = true
												ehum.AutoRotate = false
												local cant1 = Instance.new("IntValue",char)
												cant1.Name = "StrongArmor"
												local cant2 = Instance.new("IntValue",echar)
												cant2.Name = "StrongArmor"
												for i,v in pairs(echar:GetDescendants()) do
													if v:IsA("MeshPart") or v:IsA("BasePart") then
														if v.Massless == false then
															v.Massless = true
															task.spawn(function()
																repeat
																	task.wait()
																until Massless == false
																v.Massless = false
															end)
														end
													end
												end
												ehrp.CFrame = hrp.CFrame * CFrame.new(0,0,-3) * CFrame.Angles(0,math.rad(180),0)
												task.wait(0.1)
												local WeldChar = Instance.new("Weld",echar)
												WeldChar.Part0 = ehrp
												WeldChar.Part1 = hrp
												WeldChar.C0 = CFrame.new(0,0,-3) * CFrame.Angles(0,math.rad(180),0)
												local BaTrack = hum:LoadAnimation(rep.Anims.Gojo.PlrBarrage)
												BaTrack:Play()
												local Martial = rep.VFX.Characters.Gojo.MartialPunch:Clone()
												Martial.Parent = visuals
												Martial.CFrame = ehrp.CFrame
												Martial.Weld.Part1 = ehrp
												BaTrack:GetMarkerReachedSignal("Damage"):Connect(function()
													task.spawn(function()
														if ehum.Health <= 5 then
															DamageModule:Spec2(char,echar,0,10,0.2,1,math.random(6,7),nil,false,nil,false,false,false,false,true)
														else
															DamageModule:Spec2(char,echar,0.4,10,0.2,1,math.random(6,7),nil,false,nil,false,false,false,false,true)
														end
														local ranNum = math.random(1,2)
														if ranNum == 1 then
															ehum:LoadAnimation(rep.Anims.Combat.Hit1):Play()
														else
															ehum:LoadAnimation(rep.Anims.Combat.Hit2):Play()
														end
														task.spawn(function()
															for i,v in pairs(Martial:GetDescendants()) do
																if v:IsA("ParticleEmitter") then
																	spawn(function()
																		local EA = v:GetAttribute("EmitCount")
																		v:Emit(EA)
																	end)
																end
															end
														end)
													end)
												end)
												BaTrack:GetMarkerReachedSignal("End"):Connect(function()
													task.spawn(function()
														Massless = false
														ehum.AutoRotate = true
														cant1:Destroy()
														cant2:Destroy()
														WeldChar.C0 = CFrame.new(0,0,0)
														WeldChar:Destroy()
														game.Debris:AddItem(Martial,1)
														task.spawn(function()
															for i,v in pairs(Martial:GetDescendants()) do
																if v:IsA("ParticleEmitter") then
																	spawn(function()
																		local EA = v:GetAttribute("EmitCount")
																		v:Emit(EA)
																	end)
																end
															end
														end)
														task.spawn(function()
															if ehum.Health <= 5 then
																DamageModule:Spec(char,echar,15,200,0.25,1,5,nil,true,100,false)
																local Trail = rep.VFX.BasicAttack.WhiteTrail:Clone()
																Trail.Parent = visuals
																Trail.CFrame = ehrp.CFrame
																local weld = Instance.new("Weld",Trail)
																weld.Part0 = ehrp
																weld.Part1 = Trail
																Trail.Trail.Enabled = true
																task.spawn(function()
																	RagdollModule:Start(echar)
																	RockModule.Front(hrp,3,0.2,60,true,0.2,0.05,1,5,0)
																end)
																task.spawn(function()
																	camShake:FireClient(plr,"ShakeOnce")
																	local eplr = game:GetService("Players"):GetPlayerFromCharacter(echar)
																	if eplr then
																		camShake:FireClient(eplr,"ShakeOnce")
																	end
																end)
															else
																DamageModule:Spec(char,echar,5,80,0.25,1,5,nil,true,25,false)
															end
														end)
														remote:FireClient(plr,"Done3")
													end)
												end)
											else
												remote:FireClient(plr,"Done3")
											end
										end
									end
									if echar:FindFirstChild("Block") then
										echar:FindFirstChild("Block"):Destroy()
										Beating()
									else
										Beating()
									end
								end
							end
						end
					end
				end)
			end)
			task.wait(0.1)
			if Beated == false then
				remote:FireClient(plr,"Done3")
			end
		else
			remote:FireClient(plr,"Done3")
		end
	end

	if wut == "Hora" then
		local track = hum:LoadAnimation(rep.Anims.Gojo.Hora)
		track:Play()
		local sound = rep.Sounds.Gojo.Hora:Clone()
		sound.Parent = hrp
		sound:Play()
		game.Debris:AddItem(sound,sound.TimeLength)
		local HoraCounter = Instance.new("IntValue",char)
		HoraCounter.Name = "HoraCounter"
		task.spawn(function()
			repeat
				task.wait()
			until not char:FindFirstChild("HoraCounter")
			if track.IsPlaying then
				track:Stop()
			end
			if sound.IsPlaying then
				sound:Destroy()
			end
		end)
		task.wait(1.5)
		if char:FindFirstChild("HoraCounter") then
			HoraCounter:Destroy()
			task.wait(0.4)
			remote:FireClient(plr,"Done4")
		end
	end

	if wut == "Awaken" then
		local cant = Instance.new("IntValue",char)
		cant.Name = "HyperArmor"
		local Awakening = Instance.new("IntValue",char)
		Awakening.Name = "Awakened"
		hum.Health = hum.MaxHealth
		local Aura = true
		local PlayerDied = false
		hum:LoadAnimation(rep.Anims.Gojo.Sokamona):Play()
		local sound = rep.Sounds.Gojo.Sokamona:Clone()
		sound.Parent = hrp
		sound:Play()
		game.Debris:AddItem(sound,sound.TimeLength)
		local SkillGui = plr.PlayerGui:WaitForChild("SkillsGui").Backpack
		task.spawn(function()
			SkillGui.Skill1.Visible = false
			SkillGui.Skill2.Visible = false
			SkillGui.Skill3.Visible = false
			SkillGui.Skill4.Visible = false
			SkillGui.Skill5.Visible = true
			SkillGui.Skill6.Visible = true
			SkillGui.Skill7.Visible = true
			SkillGui.Skill8.Visible = true
		end)
		task.spawn(function()
			hum.Died:Connect(function()
				PlayerDied = true
				Aura = false
				plr:WaitForChild("AwakenBar").Value = 0
				SkillGui.Skill1.Visible = true
				SkillGui.Skill2.Visible = true
				SkillGui.Skill3.Visible = true
				SkillGui.Skill4.Visible = true
				SkillGui.Skill5.Visible = false
				SkillGui.Skill6.Visible = false
				SkillGui.Skill7.Visible = false
				SkillGui.Skill8.Visible = false
			end)
		end)
		task.wait(6)
		local theme = rep.Sounds.Gojo.Theme:Clone()
		theme.Parent = hrp
		theme:Play()
		local AuraPart = rep.VFX.Characters.Gojo.Aura:Clone()
		AuraPart.Parent = visuals
		AuraPart.CFrame = hrp.CFrame
		local weld = Instance.new("Weld",AuraPart)
		weld.Part0 = hrp
		weld.Part1 = AuraPart
		task.spawn(function()
			while Aura do
				task.spawn(function()
					for i,v in pairs(AuraPart:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(1)
							end)
						end
					end
				end)
				task.wait(0.2)
			end
		end)
		task.spawn(function()
			task.spawn(function()
				for i = 1,60 do
					if PlayerDied == false then
						plr:WaitForChild("AwakenBar").Value -= 200/60
					else
						break
					end
					task.wait(1)
				end
			end)
			task.wait(60)
			if PlayerDied == false then
				Awakening:Destroy()
				Aura = false
				plr:WaitForChild("AwakenBar").Value = 0
				game.Debris:AddItem(AuraPart,1)
				theme:Destroy()
				SkillGui.Skill1.Visible = true
				SkillGui.Skill2.Visible = true
				SkillGui.Skill3.Visible = true
				SkillGui.Skill4.Visible = true
				SkillGui.Skill5.Visible = false
				SkillGui.Skill6.Visible = false
				SkillGui.Skill7.Visible = false
				SkillGui.Skill8.Visible = false
			end
		end)
		cant:Destroy()
		remote:FireClient(plr,"DoneAwa")
	end

	if wut == "MaxRed" then
		local track = hum:LoadAnimation(rep.Anims.Gojo.MaxRed)
		track:Play()
		local PrepareEffect = true
		local Red = rep.VFX.Characters.Gojo.MaxRed:Clone()
		Red.Parent = visuals
		Red.CFrame = char:FindFirstChild("Right Arm").CFrame
		local weld = Instance.new("Weld",Red)
		weld.Part0 = Red
		weld.Part1 = char:FindFirstChild("Right Arm")
		weld.C0 = CFrame.Angles(math.rad(90),0,0)
		local voice = rep.Sounds.Gojo.Jamada:Clone()
		voice.Parent = hrp
		voice:Play()
		game.Debris:AddItem(voice,voice.TimeLength)
		task.spawn(function()
			while PrepareEffect do
				task.spawn(function()
					for i,v in pairs(Red.MainRed:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(1)
							end)
						end
					end
				end)
				task.wait(0.1)
			end
		end)
		task.wait(1.1)
		if not char:FindFirstChild("Stun") then
			hum.AutoRotate = false
			PrepareEffect = false
			game.Debris:AddItem(Red,0.5)
			Red.Beam1.Enabled = false
			Red.Beam2.Enabled = false
			Red.Beam3.Enabled = false
			Red.Beam4.Enabled = false
			local Explosion = rep.VFX.Characters.Gojo.MaxRedExplosion:Clone()
			Explosion.Parent = visuals
			Explosion.CFrame = hrp.CFrame * CFrame.new(0,0,-20)
			local sound2 = rep.Sounds.Gojo.RedExplosion:Clone()
			sound2.Parent = hrp
			sound2:Play()
			game.Debris:AddItem(sound2,sound2.TimeLength)
			task.spawn(function()
				for i,v in pairs(game:GetService("Players"):GetPlayers()) do
					if v ~= plr then
						if (v.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 35 then
							LightingRemote:FireClient(v,"RedExplosion")
							camShake:FireClient(v,"RedShake")
						end
					end
				end
				LightingRemote:FireClient(plr,"RedExplosion")
				camShake:FireClient(plr,"RedShake")
			end)
			task.spawn(function()
				for i,v in pairs(Explosion.PushAttach:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(EA)
						end)
					end
				end
				for i,v in pairs(Explosion.SmallAttach:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(EA)
						end)
					end
				end
				for i,v in pairs(Explosion.ExplodeAttach:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(EA)
						end)
					end
				end
			end)
			task.spawn(function()
				DamageBox2(Explosion,"MaxEplo",0.1,char,25,80,0.25,2,nil,false,true,25,true,2,false)
			end)
			task.spawn(function()
				RockModule.Ground(hrp.Position,15,Vector3.new(3,3,3),{visuals},10,false,5,0.25)
			end)
			task.spawn(function()
				RockModule.Front(hrp,6,0.2,40,true,0.1,0,1,5)
			end)
			track:Stop()
			task.wait(0.5)
			hum.AutoRotate = true
			remote:FireClient(plr,"Done6")
		else
			track:Stop()
			PrepareEffect = false
			game.Debris:AddItem(Red,0.5)
			Red.Beam1.Enabled = false
			Red.Beam2.Enabled = false
			Red.Beam3.Enabled = false
			Red.Beam4.Enabled = false
			remote:FireClient(plr,"Done6")
		end
	end

	if wut == "MaxBlue" then
		local cant = Instance.new("IntValue",char)
		cant.Name = "StrongArmor"
		hum:LoadAnimation(rep.Anims.Gojo.CreateBlue):Play()
		local PrepareEffect = true
		local voice = rep.Sounds.Gojo.MaxBlueVoice:Clone()
		voice.Parent = hrp
		voice:Play()
		game.Debris:AddItem(voice,voice.TimeLength)
		hum.AutoRotate = false
		local BluePart = rep.VFX.Characters.Gojo.Blue:Clone()
		BluePart.Parent = visuals
		BluePart.Anchored = true
		BluePart.CFrame = hrp.CFrame * CFrame.new(0,0,-1.5)
		local weld = Instance.new("Weld",BluePart)
		weld.Part0 = hrp
		weld.Part1 = BluePart
		weld.C0 = CFrame.new(0,0,-1.5)
		task.spawn(function()
			while PrepareEffect do
				task.spawn(function()
					for i,v in pairs(BluePart:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(1)
							end)
						end
					end
				end)
				task.wait(0.1)
			end
		end)
		task.wait(6)
		if not char:FindFirstChild("Stun") then
			PrepareEffect = false
			local OrbEffect = true
			game.Debris:AddItem(BluePart,0.5)
			local BlueOrb = rep.VFX.Characters.Gojo.MaxBlueOrb:Clone()
			BlueOrb.Parent = visuals
			BlueOrb.CFrame = hrp.CFrame * CFrame.new(0,3,-3)
			BlueOrb.Anchored = false
			local bv = Instance.new("BodyVelocity",BlueOrb)
			bv.Name = "BV"
			bv.MaxForce = Vector3.new(1,1,1) * math.huge
			bv.P = 123456789
			bv.Velocity = Vector3.new(0,0,0)
			local windsound = rep.Sounds.Gojo.BlueLoop:Clone()
			windsound.Parent = BlueOrb
			windsound:Play()
			task.spawn(function()
				while BlueOrb do
					task.spawn(function()
						for i,v in pairs(BlueOrb:GetDescendants()) do
							if v:IsA("ParticleEmitter") then
								spawn(function()
									local EA = v:GetAttribute("EmitCount")
									v:Emit(3)
								end)
							end
						end
					end)
					task.wait(0.1)
				end
			end)
			task.spawn(function()
				local CheckChar = {workspace.Debris,visuals}
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

				while OrbEffect do
					RockModule.Ground(BlueOrb.Position,15,Vector3.new(2.5,2.5,2.5),{visuals},15,false,4,0.3)
					task.wait(0.25)
				end
			end)
			task.spawn(function()
				while OrbEffect do
					DamageBox4(BlueOrb,"BlueHit",0.1,char,1,0,0.05,1,nil,false,false,nil,false,false)
					task.wait(0.05)
				end
			end)
			remote:FireClient(plr,"StartBlue")
			task.wait(8)
			remote:FireClient(plr,"StopBlue")
			OrbEffect = false
			game.Debris:AddItem(BlueOrb,1)
			hum.AutoRotate = true
			cant:Destroy()
			remote:FireClient(plr,"Done5")
		else
			remote:FireClient(plr,"Done5")
			PrepareEffect = false
			game.Debris:AddItem(BluePart,0.5)
			hum.AutoRotate = true
		end
	end

	if wut == "BackHand" then
		local TrueEchar = nil
		local box = rep.VFX.Boxes.BackHand:Clone()
		box.Parent = visuals
		box.Transparency = 1
		box.CFrame = hrp.CFrame * CFrame.new(0,0,25)
		local weld = Instance.new("Weld",box)
		weld.Part0 = box
		weld.Part1 = hrp
		weld.C0 = CFrame.new(0,0,25)
		local params = OverlapParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.MaxParts = 0
		params.FilterDescendantsInstances = {box,visuals}
		for i,hit in pairs(workspace:GetPartsInPart(box,params)) do
			local echar = hit.Parent
			if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
				if echar ~= char and not echar:FindFirstChild("HyperArmor") and not echar:FindFirstChild("StrongArmor") and CheckDown(echar) then
					if TrueEchar == nil then
						TrueEchar = echar
					else
						local dis1 = (TrueEchar.HumanoidRootPart.Position - hrp.Position).Magnitude
						local dis2 = (echar.HumanoidRootPart.Position - hrp.Position).Magnitude
						if dis2 < dis1 then
							TrueEchar = echar
						end
					end
				end
			end
		end
		box:Destroy()
		if TrueEchar ~= nil then
			local tpPart = rep.VFX.Dash.TeleportPart:Clone()
			tpPart.Parent = visuals
			tpPart.Anchored = true
			tpPart.CFrame = hrp.CFrame
			local sound = rep.Sounds.Dash.Teleport:Clone()
			sound.Parent = hrp
			sound:Play()
			game.Debris:AddItem(sound,sound.TimeLength)
			for i,v in pairs(tpPart:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					spawn(function()
						local EA = v:GetAttribute("EmitCount")
						v:Emit(EA)
					end)
				end
			end
			hum.AutoRotate = false
			hrp.CFrame = TrueEchar.HumanoidRootPart.CFrame * CFrame.new(0,0,2)
			hum:LoadAnimation(rep.Anims.Gojo.BackHand):Play()
			task.wait(0.2)
			task.spawn(function()
				DamageModule:Spec(char,TrueEchar,16,100,0.25,1,math.random(6,7),false,true,30,false,false,false)
			end)
			task.wait(0.2)
			hum.AutoRotate = true
			remote:FireClient(plr,"Done5")
		else
			remote:FireClient(plr,"Done5")
		end
	end

	if wut == "UpdateBlue" then
		local BlueOrb = visuals:FindFirstChild("MaxBlueOrb")
		local dis = (BlueOrb.Position - MousePos).Magnitude
		local dis2 = (hrp.Position - MousePos).Magnitude
		local dis3 = (hrp.Position - BlueOrb.Position).Magnitude
		local bv = BlueOrb:FindFirstChild("BV")
		local speed = 80
		if dis2 < 200 then
			if dis <= 10 then
				bv.Velocity = Vector3.new(0,0,0)
			else
				bv.Velocity = ((MousePos+Vector3.new(0,5,0)) - BlueOrb.Position).Unit * speed
			end
		else
			if dis3 < 200 then
				if dis <= 10 then
					bv.Velocity = Vector3.new(0,0,0)
				else
					bv.Velocity = ((MousePos+Vector3.new(0,5,0)) - BlueOrb.Position).Unit * speed
				end
			else
				bv.Velocity = Vector3.new(0,0,0)
			end
		end
	end

	if wut == "HollowPurple" then
		hum.AutoRotate = false
		local cant = Instance.new("IntValue",char)
		cant.Name = "HyperArmor"
		hum:LoadAnimation(rep.Anims.Gojo.HollowPurple):Play()
		local voice = rep.Sounds.Gojo.HollowPurpleVoice:Clone()
		voice.Parent = hrp
		voice:Play()
		game.Debris:AddItem(voice,voice.TimeLength)
		task.spawn(function()
			task.wait(0.5)
			local Red = rep.VFX.Characters.Gojo.RedSmall:Clone()
			Red.Parent = visuals
			Red.Color = Color3.new(1, 1, 1)
			Red.CFrame = hrp.CFrame * CFrame.new(8,0,-7)
			Red.LightPart.CFrame = Red.CFrame
			ts:Create(Red,TweenInfo.new(0.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Color = Color3.new(1, 0, 0)}):Play()
			local Blue = rep.VFX.Characters.Gojo.BlueSmall:Clone()
			Blue.Parent = visuals
			Blue.Color = Color3.new(1, 1, 1)
			Blue.CFrame = hrp.CFrame * CFrame.new(-8,0,-7)
			ts:Create(Blue,TweenInfo.new(0.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Color = Color3.new(0, 0, 1)}):Play()
			Blue.LightPart.CFrame = Blue.CFrame
			task.wait(0.5)
			ts:Create(Red,TweenInfo.new(0.75,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = hrp.CFrame * CFrame.new(0,0,-7),Size = Vector3.new(3,1,1)}):Play()
			ts:Create(Blue,TweenInfo.new(0.75,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = hrp.CFrame * CFrame.new(-0,0,-7),Size = Vector3.new(3,1,1)}):Play()
			ts:Create(Red.LightPart,TweenInfo.new(0.75,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = hrp.CFrame * CFrame.new(0,0,-7),Size = Vector3.new(2,0.5,0.5)}):Play()
			ts:Create(Blue.LightPart,TweenInfo.new(0.75,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = hrp.CFrame * CFrame.new(-0,0,-7),Size = Vector3.new(2,0.5,0.5)}):Play()
			task.wait(0.75)
			ts:Create(Red,TweenInfo.new(0.25,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = hrp.CFrame * CFrame.new(0,0,-7),Size = Vector3.new(1.5,4,4),Transparency = 1}):Play()
			ts:Create(Blue,TweenInfo.new(0.25,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = hrp.CFrame * CFrame.new(0,0,-7),Size = Vector3.new(1.5,4,4),Transparency = 1}):Play()
			ts:Create(Red.LightPart,TweenInfo.new(0.25,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = hrp.CFrame * CFrame.new(0,0,-7),Size = Vector3.new(1,3,3),Transparency = 1}):Play()
			ts:Create(Blue.LightPart,TweenInfo.new(0.25,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = hrp.CFrame * CFrame.new(0,0,-7),Size = Vector3.new(1,3,3),Transparency = 1}):Play()
			local PurpleSplash = rep.VFX.Characters.Gojo.PurpleSparkle:Clone()
			PurpleSplash.Parent = visuals
			PurpleSplash.CFrame = hrp.CFrame * CFrame.new(0,0,-7)
			task.spawn(function()
				for i,v in pairs(PurpleSplash:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(EA)
						end)
					end
				end
			end)
			game.Debris:AddItem(PurpleSplash,4)
			task.wait(0.25)
			Red:Destroy()
			Blue:Destroy()
		end)
		task.spawn(function()
			task.wait(6.5)
			local PurpleArm = rep.VFX.Characters.Gojo.PurpleArm:Clone()
			PurpleArm.Parent = visuals
			PurpleArm.CFrame = char:FindFirstChild("Right Arm").CFrame
			local Weld = Instance.new("Weld",PurpleArm)
			Weld.Part0 = char:FindFirstChild("Right Arm")
			Weld.Part1 = PurpleArm
			local PurpleEffect = true
			task.spawn(function()
				while PurpleEffect do
					task.spawn(function()
						for i,v in pairs(PurpleArm.Attachment:GetChildren()) do
							if v:IsA("ParticleEmitter") then
								spawn(function()
									local EA = v:GetAttribute("EmitCount")
									v:Emit(1)
								end)
							end
						end
					end)
					task.wait(0.5)
				end
			end)
			ts:Create(PurpleArm.Attachment.PointLight,TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Brightness = 20}):Play()
			LightingRemote:FireClient(plr,"HPDark")
			hum.AutoRotate = true
			task.wait(3.5)
			LightingRemote:FireClient(plr,"HPDarkEnd")
			LightingRemote:FireClient(plr,"HPLight")
			PurpleEffect = false
			game.Debris:AddItem(PurpleArm,1)
			local PurpleTrail = rep.VFX.Characters.Gojo.PurpleOrb:Clone()
			PurpleTrail.Parent = visuals
			PurpleTrail.CFrame = hrp.CFrame
			PurpleTrail.Trail.Enabled = true
			task.wait(0.1)
			local HitBox = rep.VFX.Boxes.HollowBox:Clone()
			HitBox.Parent = visuals
			HitBox.CFrame = hrp.CFrame * CFrame.new(0,-5,-275)
			HitBox.Transparency = 1
			game.Debris:AddItem(HitBox,1)
			task.spawn(function()
				DamageBox5(HitBox,"Hollow",0.1,char,40,0,0.05,1,nil,false,false,false,false,false,true)
			end)
			ts:Create(PurpleTrail,TweenInfo.new(0.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = hrp.CFrame * CFrame.new(0,0,-550)}):Play()
			task.spawn(function()
				task.wait(0.5)
				PurpleTrail.Transparency = 1
				game.Debris:AddItem(PurpleTrail,5)
			end)
			task.spawn(function()
				RockModule.Front2(hrp,6,3,350,false,nil,0.35,1,6,0)
			end)
			task.wait(0.2)
			remote:FireClient(plr,"Done7")
			cant:Destroy()
		end)
	end

	if wut == "HollowPurpleBig" then
		hum.AutoRotate = false
		local cant = Instance.new("IntValue",char)
		cant.Name = "HyperArmor"
		hum:LoadAnimation(rep.Anims.Gojo.HollowPurpleBig):Play()
		local sound = rep.Sounds.Gojo.HollowPurpleBig:Clone()
		sound.Parent = hrp
		sound:Play()
		local SmallEffect = true
		local BigEffect = true
		task.spawn(function()
			task.wait(sound.TimeLength)
			sound:Destroy()
		end)
		task.wait(7)
		local Blue = rep.VFX.Characters.Gojo.BigBlue:Clone()
		Blue.Parent = visuals
		Blue.CFrame = hrp.CFrame
		Blue.TrueWeld.Part1 = hrp
		Blue.Beam.Enabled = true
		Blue.Beam2.Enabled = true
		task.spawn(function()
			ts:Create(Blue.PointLight,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut,0,false,0),{Range = 17}):Play()
			while SmallEffect do
				task.spawn(function()
					for i,v in pairs(Blue:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(1)
							end)
						end
					end
				end)
				task.wait(0.1)
			end
		end)
		task.wait(3)
		local Red = rep.VFX.Characters.Gojo.BigRed:Clone()
		Red.Parent = visuals
		Red.CFrame = hrp.CFrame
		Red.TrueWeld.Part1 = hrp
		Red.Beam.Enabled = true
		Red.Beam2.Enabled = true
		task.spawn(function()
			ts:Create(Red.PointLight,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut,0,false,0),{Range = 17}):Play()
			while SmallEffect do
				task.spawn(function()
					for i,v in pairs(Red:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(1)
							end)
						end
					end
				end)
				task.wait(0.1)
			end
		end)
		task.wait(4.5)
		ts:Create(Blue.TrueWeld,TweenInfo.new(2,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut,0,false,0),{C0 = CFrame.new(0,0,10)}):Play()
		ts:Create(Red.TrueWeld,TweenInfo.new(2,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut,0,false,0),{C0 = CFrame.new(0,0,10)}):Play()
		task.wait(2)
		SmallEffect = false
		Blue:Destroy()
		Red:Destroy()
		local Purple = rep.VFX.Characters.Gojo.BigPurple:Clone()
		Purple.Parent = visuals
		Purple.CFrame = hrp.CFrame
		Purple.TrueWeld.Part1 = hrp
		ts:Create(Purple.PointLight,TweenInfo.new(0.95,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut,0,false,0),{Range = 15}):Play()
		task.spawn(function()
			while BigEffect do
				task.spawn(function()
					for i,v in pairs(Purple.StartSlow:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(1)
							end)
						end
					end
				end)
				task.wait()
			end
		end)
		task.spawn(function()
			ts:Create(Purple.TrueWeld,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut,0,false,0),{C0 = CFrame.new(0,-3,10)}):Play()
			for i = 1,10,1 do
				task.spawn(function()
					for i,v in pairs(Purple.StartSlow:GetChildren()) do
						if v:IsA("ParticleEmitter") then
							v.Size = NumberSequence.new((v:FindFirstChild("MaxSize").Value/10)*i)
						end
					end
				end)
				task.wait(0.1)
			end
		end)
		task.wait(1)
		task.spawn(function()
			task.spawn(function()
				while BigEffect do
					task.spawn(function()
						for i,v in pairs(Purple["SlowerEmit(0.4)"]:GetDescendants()) do
							if v:IsA("ParticleEmitter") then
								spawn(function()
									local EA = v:GetAttribute("EmitCount")
									v:Emit(1)
								end)
							end
						end
					end)
					task.wait(0.4)
				end
			end)
			task.spawn(function()
				while BigEffect do
					task.spawn(function()
						for i,v in pairs(Purple.FastEmit:GetDescendants()) do
							if v:IsA("ParticleEmitter") then
								spawn(function()
									local EA = v:GetAttribute("EmitCount")
									v:Emit(1)
								end)
							end
						end
					end)
					task.wait(0.1)
				end
			end)
		end)
		ts:Create(Purple.PointLight,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut,0,false,0),{Range = 30}):Play()
		hum.AutoRotate = true
		task.wait(4)
		Purple.TrueWeld:Destroy()
		local bv = Instance.new("BodyVelocity",Purple)
		bv.MaxForce = Vector3.new(1,1,1) * math.huge
		bv.P = 12345678
		bv.Velocity = Vector3.new(0,0,0)
		local Hitting = true
		task.spawn(function()
			while Hitting do
				task.spawn(function()
					RockModule.Projectile(Purple,Vector3.new(3,3,3),10,4)
				end)
				task.wait()
			end
		end)
		local flyTrack = ts:Create(Purple,TweenInfo.new(8,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = hrp.CFrame * CFrame.new(0,0,-2000)})
		flyTrack:Play()
		Purple.Touched:Connect(function(hit)
			if Hitting then 
				local echar = hit.Parent
				if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
					if echar ~= char and not echar:FindFirstChild("HyperArmor") then
						if not echar:FindFirstChild("HollowPurpled") then
							local GetHit = Instance.new("IntValue")
							GetHit.Parent = echar
							GetHit.Name = "HollowPurpled"
							game.Debris:AddItem(GetHit,1)
							local ehum = echar:FindFirstChild("Humanoid")
							local ehrp = echar:FindFirstChild("HumanoidRootPart")
							task.spawn(function()
								DamageModule:TrueDamage(char,echar,100,0,0.05,1,nil,false,false,false,false,false,false,true)
								RagDoll2(echar,5)
							end)
						end
					end
				end
			end
		end)
		flyTrack.Completed:Connect(function()
			Hitting = false
			BigEffect = false
			Purple:Destroy()
		end)
		cant:Destroy()
		remote:FireClient(plr,"Done7")
	end

	if wut == "Domain" then
		local DomainStart = true
		local Died = false
		local cant = Instance.new("IntValue",char)
		cant.Name = "HyperArmor"
		local CheckDomain = Instance.new("IntValue",char)
		CheckDomain.Name = "GetDomain"
		task.spawn(function()
			hum.Died:Connect(function()
				if DomainStart == true and Died == false then
					Died = true
					CheckDomain:Destroy()
				end
			end)
		end)
		hum.AutoRotate = false
		local track1 = hum:LoadAnimation(rep.Anims.Gojo.Domain1)
		local track2 = hum:LoadAnimation(rep.Anims.Gojo.Domain2)
		track1:Play()
		local Voice = rep.Sounds.Gojo.Domain:Clone()
		Voice.Parent = hrp
		Voice:Play()
		game.Debris:AddItem(Voice,Voice.TimeLength)
		task.wait(1.5)
		local Domain = rep.VFX.Characters.Gojo.DomainGojo:Clone()
		Domain.Parent = visuals
		Domain.PrimaryPart.CFrame = hrp.CFrame
		ts:Create(Domain.Domain,TweenInfo.new(3,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 0}):Play()
		task.wait(5.5)
		local params2 = OverlapParams.new()
		params2.FilterType = Enum.RaycastFilterType.Exclude
		params2.MaxParts = 0
		params2.FilterDescendantsInstances = {Domain.Domain.HitBoxMain,visuals}
		for i,hit in pairs(workspace:GetPartsInPart(Domain.Domain.HitBoxMain,params2)) do
			local echar = hit.Parent
			if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
				if echar ~= char then
					if not echar:FindFirstChild("GetDomain") then
						local Check = Instance.new("IntValue",echar)
						Check.Name = "GetDomain"
						local Stun = Instance.new("IntValue",echar)
						Stun.Name = "Stun"
						local EDied = false
						local eplr = game:GetService("Players"):GetPlayerFromCharacter(echar)
						if eplr then
							local CamCF2 = hrp.CFrame * CFrame.new(0,1.5,-12)
							CamCF2 = CFrame.lookAt(CamCF2.Position,hrp.Position)
							CutsenseRemote:FireClient(eplr,"Domain",nil,CamCF2)
							LightingRemote:FireClient(eplr,"Domain")
						end
						task.spawn(function()
							echar.Humanoid.Died:Connect(function()
								if DomainStart == true and EDied == false then
									EDied = true
									Check:Destroy()
								end
							end)
						end)
						task.spawn(function()
							repeat
								task.wait()
							until DomainStart == false
							if not EDied then
								Check:Destroy()
								Stun:Destroy()
							end
						end)
					end
				end
			end
		end
		task.spawn(function()
			local CamCF = hrp.CFrame * CFrame.new(0,1.5,-12)
			CamCF = CFrame.lookAt(CamCF.Position,hrp.Position)
			CutsenseRemote:FireClient(plr,"Domain",nil,CamCF)
			LightingRemote:FireClient(plr,"Domain")
		end)
		track1:Stop()
		track2:Play()
		ts:Create(Domain.Domain,TweenInfo.new(0.3,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Color = Color3.new(0, 0, 0)}):Play()
		local LineEffect = true
		task.spawn(function()
			while LineEffect do
				task.spawn(function()
					for i,v in pairs(Domain.Domain.LinePart:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(20)
							end)
						end
					end
				end)
				task.wait()
			end
		end)
		task.wait(7)
		LineEffect = false
		track2:Stop()
		hum.AutoRotate =  true
		remote:FireClient(plr,"Done8")
		task.wait(2)
		local GlowEffect = true
		task.spawn(function()
			while GlowEffect do
				task.spawn(function()
					for i,v in pairs(Domain.Domain:GetChildren()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(1)
							end)
						end
					end
				end)
				task.wait(1)
			end
		end)
		task.spawn(function()
			while GlowEffect do
				task.spawn(function()
					for i,v in pairs(Domain.Domain.CorePart.Attachment1:GetChildren()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(1)
							end)
						end
					end
				end)
				task.wait(1.9)
			end
		end)
		task.spawn(function()
			while GlowEffect do
				task.spawn(function()
					for i,v in pairs(Domain.Domain.CorePart.Attachment2:GetChildren()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(1)
							end)
						end
					end
				end)
				task.spawn(function()
					for i,v in pairs(Domain.Domain.CorePart.Attachment3:GetChildren()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(1)
							end)
						end
					end
				end)
				task.wait(0.2)
			end
		end)
		task.wait(15)
		GlowEffect = false
		ts:Create(Domain.Domain,TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Color = Color3.new(1, 1, 1)}):Play()
		task.wait(1.1)
		cant:Destroy()
		DomainStart = false
		if not Died then
			CheckDomain:Destroy()
		end
		local BreakSound = rep.Sounds.Gojo.DomainBreak:Clone()
		BreakSound.Parent = hrp
		BreakSound:Play()
		game.Debris:AddItem(BreakSound,BreakSound.TimeLength)
		Domain.Domain.HitBoxMain.Glass:Emit(250)
		Domain.Domain.Transparency = 1
		Domain.Domain.BarrierPart.CanCollide = false
		game.Debris:AddItem(Domain,3)
	end
end)


