local rep = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")
local remote = rep:WaitForChild("Remotes"):WaitForChild("Rengoku")
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
	local function PlaySound(Sound,Parent:Parent,TimePos:position,DesTime)
		task.spawn(function()
			Sound.Parent = Parent
			Sound.TimePosition = TimePos
			Sound:Play()
			if DesTime then
				task.wait(DesTime)
				Sound:Destroy()
			else
				task.wait(Sound.TimeLength)
				Sound:Destroy()
			end
		end)
	end
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
					if echar ~= char and not echar:FindFirstChild("HyperArmor") and not echar:FindFirstChild("StrongArmor") and CheckDown(echar) then
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
											DamageModule:Slash(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
										end)
										if echar:FindFirstChild("Torso"):FindFirstChild("Neck") then
											echar:FindFirstChild("Torso"):FindFirstChild("Neck"):Destroy()
											local bv = Instance.new("BodyVelocity",echar:FindFirstChild("Head"))
											bv.MaxForce = Vector3.new(1,1,1) * math.huge
											bv.P = 1234567
											bv.Velocity = (hrp.CFrame.LookVector * 30) + (hrp.CFrame.UpVector * 15)
											game.Debris:AddItem(bv,0.15)
										end
										RagdollModule:Start(echar)
									else
										task.spawn(function()
											DamageModule:Slash(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
										end)
										
									end
								else
									task.spawn(function()
										DamageModule:Slash(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								end
							else
								if ehum.Health <= dmg then
									task.spawn(function()
										DamageModule:Slash(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
									if echar:FindFirstChild("Torso"):FindFirstChild("Neck") then
										echar:FindFirstChild("Torso"):FindFirstChild("Neck"):Destroy()
										local bv = Instance.new("BodyVelocity",echar:FindFirstChild("Head"))
										bv.MaxForce = Vector3.new(1,1,1) * math.huge
										bv.P = 1234567
										bv.Velocity = (hrp.CFrame.LookVector * 30) + (hrp.CFrame.UpVector * 15)
										game.Debris:AddItem(bv,0.15)
									end
									RagdollModule:Start(echar)
								else
									task.spawn(function()
										DamageModule:Slash(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
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
	local function DamageBox1(box,HitName,HitTime,pchar,dmg,Power,PT,ST,combo,breakAmount,Up,High,ragdoll,ragTime,DirPush)
		local params = OverlapParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.MaxParts = 0
		params.FilterDescendantsInstances = {box,visuals}

		task.spawn(function()
			for i,hit in pairs(workspace:GetPartsInPart(box,params)) do
				local echar = hit.Parent
				if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
					if echar ~= char and not echar:FindFirstChild("HyperArmor") and not echar:FindFirstChild("StrongArmor") and CheckDown(echar) then
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
									task.spawn(function()
										DamageModule:Slash(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
									if echar:FindFirstChild("Torso"):FindFirstChild("Neck") then
										echar:FindFirstChild("Torso"):FindFirstChild("Neck"):Destroy()
										local bv = Instance.new("BodyVelocity",echar:FindFirstChild("Head"))
										bv.MaxForce = Vector3.new(1,1,1) * math.huge
										bv.P = 1234567
										bv.Velocity = (hrp.CFrame.LookVector * 30) + (hrp.CFrame.UpVector * 15)
										game.Debris:AddItem(bv,0.15)
									end
									RagdollModule:Start(echar)
								else
									task.spawn(function()
										DamageModule:Slash(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								end
							else
								if ehum.Health <= dmg then
									task.spawn(function()
										DamageModule:Slash(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
									if echar:FindFirstChild("Torso"):FindFirstChild("Neck") then
										echar:FindFirstChild("Torso"):FindFirstChild("Neck"):Destroy()
										local bv = Instance.new("BodyVelocity",echar:FindFirstChild("Head"))
										bv.MaxForce = Vector3.new(1,1,1) * math.huge
										bv.P = 1234567
										bv.Velocity = (hrp.CFrame.LookVector * 30) + (hrp.CFrame.UpVector * 15)
										game.Debris:AddItem(bv,0.15)
									end
									RagdollModule:Start(echar)
								else
									task.spawn(function()
										DamageModule:Slash(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
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
	local function DamageBox3(box,HitName,HitTime,pchar,dmg,Power,PT,ST,combo,breakAmount,Up,High,ragdoll,ragTime,DirPush)
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
									task.spawn(function()
										DamageModule:Slash(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
									RagdollModule:Start(echar)
								else
									task.spawn(function()
										DamageModule:Slash(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								end
							else
								if ehum.Health <= dmg then
									task.spawn(function()
										DamageModule:Slash(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
									RagdollModule:Start(echar)
								else
									task.spawn(function()
										DamageModule:Slash(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
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
	------------------------------------------------------------
	if wut == "Unknown" then
		local Katana = visuals:WaitForChild("RengokuKatana")
		local track = hum:LoadAnimation(rep.Anims.Rengoku.PrepareUnknown)
		track:Play()
		local FireTrail = rep.VFX.Characters.Rengoku.UnknownFire:Clone()
		FireTrail.Parent = visuals
		FireTrail.TrueWeld.Part1 = hrp
		FireTrail.AnimCtrl:LoadAnimation(FireTrail.SpinAnim):Play(0.1,1,1.75)
		task.wait(0.5)
		if not char:FindFirstChild("Stun") then
			local cant = Instance.new("IntValue",char)
			cant.Name = "StrongArmor"
			local Hitting = true
			local Invisible = true
			for i,v in pairs(char:GetDescendants()) do
				if (v:IsA("MeshPart") or v:IsA("BasePart") or v:IsA("Decal")) then
					if v.Name ~= "HumanoidRootPart" then
						if v.Transparency ~= 1 then
							local old = v.Transparency
							v.Transparency = 1
							task.spawn(function()
								repeat
									task.wait()
								until Invisible == false
								v.Transparency = old
							end)
						end
					end
				end
			end
			for i, v in pairs(Katana:GetDescendants()) do
				if v:IsA("BasePart") or v:IsA("MeshPart") then
					if v.Transparency ~= 1 then
						local old = v.Transparency
						v.Transparency = 1
						task.spawn(function()
							repeat
								task.wait()
							until Invisible == false
							v.Transparency = old
						end)
					end
				end
			end
			local TranEffect = rep.VFX.Characters.Rengoku.FireTrans:Clone()
			TranEffect.Parent = visuals
			TranEffect.Weld.Part1 = hrp
			task.spawn(function()
				task.wait()
				for i,v in pairs(TranEffect:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(EA)
						end)
					end
				end
			end)
			FireTrail.Trail1.Enabled = true
			FireTrail.Trail2.Enabled = true
			local Sound4 = rep.Sounds.Rengoku.FlameMove:Clone()
			Sound4.Parent = hrp
			Sound4.TimePosition = 0.2
			Sound4:Play()
			remote:FireClient(plr,"UnknownMove")
			CutsenseRemote:FireClient(plr,"UnknownCam")
			local Box = rep.VFX.Characters.Rengoku.FlameBox:Clone()
			Box.Parent = visuals
			Box.Weld.Part1 = hrp
			Box.Transparency = 1
			local DoneFly = task.delay(1,function()
				if Hitting == true then
					Hitting = false
					remote:FireClient(plr,"UnknownStop")
					CutsenseRemote:FireClient(plr,"UnknownStop")
					task.spawn(function()
						task.wait()
						FireTrail:Destroy()
						for i,v in pairs(TranEffect:GetDescendants()) do
							if v:IsA("ParticleEmitter") then
								spawn(function()
									local EA = v:GetAttribute("EmitCount")
									v:Emit(EA)
								end)
							end
						end
						game.Debris:AddItem(TranEffect,1)
						Invisible = false
					end)
					local Sound2 = rep.Sounds.Rengoku.UnknownStart:Clone()
					PlaySound(Sound2,hrp,0)
					Sound4:Destroy()
					task.wait(0.1)
					hum:LoadAnimation(rep.Anims.Rengoku.UnknownFire):Play()
					task.wait(0.2)
					local FireSlash = rep.VFX.Characters.Rengoku.FireSlash:Clone()
					FireSlash.Parent = visuals
					FireSlash.Weld.Part1 = hrp
					task.wait(0.05)
					task.spawn(function()
						for i,v in pairs(FireSlash:GetDescendants()) do
							if v:IsA("ParticleEmitter") then
								spawn(function()
									local EA = v:GetAttribute("EmitCount")
									v:Emit(EA)
								end)
							end
						end
						task.wait(1)
						FireSlash:Destroy()
					end)
					task.spawn(function()
						DamageBox1(FireSlash,"UnknownHit",0.1,char,10,15,0.1,1.25,math.random(1,4),false,false,nil,false,false)
					end)
					local Sound3 = rep.Sounds.Rengoku.FireSlash:Clone()
					PlaySound(Sound3,hrp,0)
					Box:Destroy()
					cant:Destroy()
					task.wait(0.4)
					remote:FireClient(plr,"Done1")
				end
			end)
			task.spawn(function()
				Box.Touched:Connect(function(hit)
					local echar = hit.Parent
					if echar:FindFirstChild("Humanoid") and echar ~= char and Hitting == true then
						Hitting = false
						remote:FireClient(plr,"UnknownStop")
						CutsenseRemote:FireClient(plr,"UnknownStop")
						task.cancel(DoneFly)
						task.spawn(function()
							task.wait()
							FireTrail:Destroy()
							for i,v in pairs(TranEffect:GetDescendants()) do
								if v:IsA("ParticleEmitter") then
									spawn(function()
										local EA = v:GetAttribute("EmitCount")
										v:Emit(EA)
									end)
								end
							end
							game.Debris:AddItem(TranEffect,1)
							Invisible = false
						end)
						local Sound2 = rep.Sounds.Rengoku.UnknownStart:Clone()
						PlaySound(Sound2,hrp,0)
						Sound4:Destroy()
						task.wait(0.1)
						hum:LoadAnimation(rep.Anims.Rengoku.UnknownFire):Play()
						task.wait(0.2)
						local FireSlash = rep.VFX.Characters.Rengoku.FireSlash:Clone()
						FireSlash.Parent = visuals
						FireSlash.Weld.Part1 = hrp
						task.wait(0.05)
						task.spawn(function()
							for i,v in pairs(FireSlash:GetDescendants()) do
								if v:IsA("ParticleEmitter") then
									spawn(function()
										local EA = v:GetAttribute("EmitCount")
										v:Emit(EA)
									end)
								end
							end
							task.wait(1)
							FireSlash:Destroy()
						end)
						local Sound3 = rep.Sounds.Rengoku.FireSlash:Clone()
						PlaySound(Sound3,hrp,0)
						Box:Destroy()
						task.spawn(function()
							DamageBox1(FireSlash,"UnknownHit",0.1,char,10,15,0.1,1.35,math.random(1,4),false,false,nil,false,false)
						end)
						cant:Destroy()
						task.wait(0.4)
						remote:FireClient(plr,"Done1")
					end
				end)
			end)
		else
			FireTrail:Destroy()
			remote:FireClient(plr,"Done1")
		end
	end
	if wut == "Rising" then
		local Katana = visuals:WaitForChild("RengokuKatana")
		Katana.AnimCtrl:LoadAnimation(rep.Anims.Rengoku.SwordFolder.Rising):Play()
		local track = hum:LoadAnimation(rep.Anims.Rengoku.Rising)
		track:Play()
		task.wait(0.4)
		if not char:FindFirstChild("Stun") then
			local Rising = rep.VFX.Characters.Rengoku.RisingSun:Clone()
			Rising.Parent = visuals
			Rising.Weld.Part1 = hrp
			Rising.Transparency = 1
			task.spawn(function()
				task.wait()
				for i,v in pairs(Rising:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(EA)
						end)
					end
				end
			end)
			local Sound3 = rep.Sounds.Rengoku.FireSlash:Clone()
			PlaySound(Sound3,hrp,0)
			task.spawn(function()
				DamageBox2(Rising,"RisingSun",0.1,char,8,0,0.2,1,math.random(1,4),false,true,30,false,false)
			end)
			task.wait(0.2)
			remote:FireClient(plr,"Done2")
		else
			remote:FireClient(plr,"Done2")
		end
	end
	if wut == "Blazing" then
		local Katana = visuals:WaitForChild("RengokuKatana")
		Katana.AnimCtrl:LoadAnimation(rep.Anims.Rengoku.SwordFolder.Blazing):Play()
		local track = hum:LoadAnimation(rep.Anims.Rengoku.Blazing)
		track:Play()
		task.spawn(function()
			task.wait(0.1)
			Katana.Trail.Enabled = true
			Katana.Trail2.Enabled = true
		end)
		task.wait(0.45)
		if not char:FindFirstChild("Stun") then
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Include
			params.FilterDescendantsInstances = {workspace.Map}
			local newCF = hrp.CFrame * CFrame.new(0,0,-4)
			local ray = workspace:Raycast(newCF.Position,Vector3.new(0,-20,0),params)
			if ray then
				local Rising = rep.VFX.Characters.Rengoku.BlazingUniverse:Clone()
				Rising.Parent = visuals
				Rising.Transparency = 1
				Rising.CFrame = newCF * CFrame.new(0,-ray.Distance,0)
				task.spawn(function()
					task.wait(0.025)
					for i,v in pairs(Rising:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(EA)
							end)
						end
					end
					task.wait(2)
					Rising:Destroy()
				end)
				local Sound3 = rep.Sounds.Rengoku.FireSlash:Clone()
				PlaySound(Sound3,hrp,0)
				local Sound4 = rep.Sounds.Rengoku.GroundSlam:Clone()
				PlaySound(Sound4,hrp,0)
				Katana.Trail.Enabled = false
				Katana.Trail2.Enabled = false
				task.spawn(function()
					DamageBox3(Rising,"BlazingSun",0.1,char,14,0,0.3,2.5,nil,false,true,35,true,2.5)
				end)
				task.spawn(function()
					RockModule.Ground(newCF.Position,12,Vector3.new(math.random(10,20)/10,math.random(10,20)/10,math.random(10,20)/10),{visuals},12,false,5,0.35)
				end)
				task.wait(0.25)
				remote:FireClient(plr,"Done3")
			else
				Katana.Trail.Enabled = false
				Katana.Trail2.Enabled = false
				task.wait(0.25)
				remote:FireClient(plr,"Done3")
			end
		else
			remote:FireClient(plr,"Done3")
		end
	end
	if wut == "Bloom" then
		local Katana = visuals:WaitForChild("RengokuKatana")
		local track = hum:LoadAnimation(rep.Anims.Rengoku.UnknownFire)
		track:Play()
		task.wait(0.25)
		if not char:FindFirstChild("Stun") then
			local FireSlash = rep.VFX.Characters.Rengoku.FireSlash2:Clone()
			FireSlash.Parent = visuals
			FireSlash.Weld.Part1 = hrp
			task.spawn(function()
				task.wait()
				for i,v in pairs(FireSlash:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(EA)
						end)
					end
				end
				task.wait(1)
				FireSlash:Destroy()
			end)
			task.spawn(function()
				DamageBox1(FireSlash,"UnknownHit2",0.1,char,10,60,0.25,1,math.random(1,4),false,false,nil,false,false,true)
			end)
			local Sound3 = rep.Sounds.Rengoku.FireSlash:Clone()
			PlaySound(Sound3,hrp,0)
			task.wait(0.25)
			remote:FireClient(plr,"Done4")
		else
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
				plr:WaitForChild("AwakenBar").Value = 0
				PlayerDied = true
				Aura = false
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
		local voice = rep.Sounds.Rengoku.Voice:Clone()
		voice.Parent = hrp
		voice:Play()
		local track = hum:LoadAnimation(rep.Anims.Rengoku.Awaken)
		track:Play()
		track:GetMarkerReachedSignal("Flare"):Connect(function()
			local FireTrans = rep.VFX.Characters.Rengoku.FireTrans2:Clone()
			FireTrans.Parent = visuals
			FireTrans.Weld.Part1 = hrp
			task.spawn(function()
				task.wait()
				for i,v in pairs(FireTrans:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(EA)
						end)
					end
				end
				task.wait(2)
				FireTrans:Destroy()
			end)
			task.spawn(function()
				for i, v in pairs(char:GetChildren()) do
					if v:IsA("BasePart") or v:IsA("MeshPart") then
						local modelAura = rep.VFX.Characters.Rengoku.Aura:Clone()
						modelAura.Parent = visuals
						task.spawn(function()
							for t,n in pairs(modelAura:GetDescendants()) do
								task.spawn(function()
									if n:IsA("ParticleEmitter") then
										n.Parent = v
										task.spawn(function()
											while Aura do
												n:Emit(1)
												task.wait(0.05)
											end
										end)
										task.spawn(function()
											repeat
												task.wait()
											until Aura == false
											game.Debris:AddItem(n,1)
										end)
									end
								end)
							end
							game.Debris:AddItem(modelAura,0.5)
						end)
					end
				end
			end)
		end)
		task.wait(9.5)
		voice:Destroy()
		local Theme = rep.Sounds.Rengoku.Theme:Clone()
		Theme.Parent = hrp
		Theme:Play()
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
				plr:WaitForChild("AwakenBar").Value = 0
				Awakening:Destroy()
				Aura = false
				Theme:Destroy()
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
	if wut == "Rengoku" then
		local Katana = visuals:WaitForChild("RengokuKatana")
		local cant = Instance.new("IntValue",char)
		cant.Name = "HyperArmor"
		local track = hum:LoadAnimation(rep.Anims.Rengoku.Rengoku)
		track:Play()
		local sound = rep.Sounds.Rengoku.LastRengoku:Clone()
		sound.Parent = hrp
		sound:Play()
		local Dragon = rep.VFX.Characters.Rengoku.Dragon:Clone()
		Dragon.Parent = visuals
		Dragon.TrueWeld.Part1 = hrp
		Dragon.AnimationController:LoadAnimation(Dragon.DragonAnim):Play()
		Dragon.SpinModel.AnimCtrl:LoadAnimation(Dragon.SpinModel.SpinAnim):Play()
		camShake:FireClient(plr,"Shaking2")
		local Aura = rep.VFX.Characters.Rengoku.RenAura:Clone()
		Aura.Parent = visuals
		Aura.Weld.Part1 = hrp
		local PreEffect = true
		task.spawn(function()
			while PreEffect do
				task.spawn(function()
					for i,v in pairs(Aura:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(1)
							end)
						end
					end
				end)
				task.wait(0.02)
			end
		end)
		task.wait(3)
		track:Stop()
		local Hitting = true
		PreEffect = false
		game.Debris:AddItem(Aura,1)
		task.spawn(function()
			Dragon.C1.Trail.Enabled = true
			Dragon.SpinModel.Trail.Enabled = true
			Dragon.SpinModel.Trail2.Enabled = true
			Dragon.Beam.Enabled = true
			Dragon.Beam2.Enabled = true
			for i = 1,8 do
				Dragon:FindFirstChild("C"..i).Transparency = 0
			end
		end)
		local effect = true
		local Invisible = true
		for i,v in pairs(char:GetDescendants()) do
			if (v:IsA("MeshPart") or v:IsA("BasePart") or v:IsA("Decal")) then
				if v.Name ~= "HumanoidRootPart" then
					if v.Transparency ~= 1 then
						local old = v.Transparency
						v.Transparency = 1
						task.spawn(function()
							repeat
								task.wait()
							until Invisible == false
							v.Transparency = old
						end)
					end
				end
			end
		end
		for i, v in pairs(Katana:GetDescendants()) do
			if v:IsA("BasePart") or v:IsA("MeshPart") then
				if v.Transparency ~= 1 then
					local old = v.Transparency
					v.Transparency = 1
					task.spawn(function()
						repeat
							task.wait()
						until Invisible == false
						v.Transparency = old
					end)
				end
			end
		end
		task.spawn(function()
			while effect do
				task.spawn(function()
					Dragon.C1.Attachment.Fire1:Emit(3)
					Dragon.C1.Attachment.Fire2:Emit(3)
					Dragon.C1.Attachment.Fire3:Emit(3)
				end)
				task.wait()
			end
		end)
		task.spawn(function()
			while effect do
				task.spawn(function()
					Dragon.C1.Attachment.Cirlcle:Emit(1)
				end)
				task.wait(0.05)
			end
		end)
		task.spawn(function()
			while Invisible do
				RockModule.Projectile(hrp,Vector3.new(1.5,1.5,1.5),-8,2.5)
				task.wait()
			end
		end)
		local TranEffect = rep.VFX.Characters.Rengoku.FireTrans:Clone()
		TranEffect.Parent = visuals
		TranEffect.Weld.Part1 = hrp
		task.spawn(function()
			task.wait()
			for i,v in pairs(TranEffect:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					spawn(function()
						local EA = v:GetAttribute("EmitCount")
						v:Emit(EA)
					end)
				end
			end
		end)
		remote:FireClient(plr,"UnknownMove2")
		CutsenseRemote:FireClient(plr,"UnknownCam2")
		local Box = rep.VFX.Characters.Rengoku.FlameBox:Clone()
		Box.Parent = visuals
		Box.Weld.Part1 = hrp
		Box.Transparency = 1
		local StopTrack = task.delay(6.5,function()
			if Hitting == true then
				Hitting = false
				task.spawn(function()
					effect = false
					remote:FireClient(plr,"UnknownStop2")
					CutsenseRemote:FireClient(plr,"UnknownStop")
					camShake:FireClient(plr,"StopShaking2")
					Invisible = false
					task.spawn(function()
						for i,v in pairs(TranEffect:GetDescendants()) do
							if v:IsA("ParticleEmitter") then
								spawn(function()
									local EA = v:GetAttribute("EmitCount")
									v:Emit(EA)
								end)
							end
						end
						task.wait(1.5)
						TranEffect:Destroy()
					end)
					task.wait(0.2)
					local Gobal = Instance.new("IntValue",char)
					Gobal.Name = "Gobal"
					Dragon:Destroy()
					remote:FireClient(plr,"Done5")
					task.wait(0.2)
					hum.WalkSpeed = 0
					hum.JumpPower = 0
					hum:LoadAnimation(rep.Anims.Rengoku.Death):Play()
					task.wait(3)
					hum.Health = 0
				end)
			end
		end)
		Box.Touched:Connect(function(hit)
			local echar = hit.Parent
			if  echar:FindFirstChild("Humanoid") and echar ~= char and Hitting == true then
				if not echar:FindFirstChild("HyperArmor") and echar:FindFirstChild("Humanoid").Health > 0 then
					Hitting = false
					task.spawn(function()
						local ehum = echar:FindFirstChild("Humanoid")
						local ehrp = echar:FindFirstChild("HumanoidRootPart")
						local Explode = rep.VFX.Characters.Rengoku.RengokuExplode:Clone()
						Explode.Parent = visuals
						Explode.CFrame = ehrp.CFrame
						task.spawn(function()
							task.wait()
							local sound5 = rep.Sounds.Rengoku.Explode:Clone()
							sound5.Parent = hrp
							sound5:Play()
							game.Debris:AddItem(sound5,sound5.TimeLength)
							for i,v in pairs(Explode:GetDescendants()) do
								if v:IsA("ParticleEmitter") then
									spawn(function()
										local EA = v:GetAttribute("EmitCount")
										v:Emit(EA)
									end)
								end
							end
							task.wait(2.5)
							Explode:Destroy()
						end)
						if echar:FindFirstChild("Block") then
							echar:FindFirstChild("Block"):Destroy()
							if ehum.Health <= 70 then
								task.spawn(function()
									DamageModule:Slash(char,echar,ehum.Health,25,0.2,2,math.random(1,4),nil,true,30,nil,nil,nil,true)
								end)
								if echar:FindFirstChild("Torso"):FindFirstChild("Neck") then
									echar:FindFirstChild("Torso"):FindFirstChild("Neck"):Destroy()
									local bv = Instance.new("BodyVelocity",echar:FindFirstChild("Head"))
									bv.MaxForce = Vector3.new(1,1,1) * math.huge
									bv.P = 1234567
									bv.Velocity = (hrp.CFrame.LookVector * 30) + (hrp.CFrame.UpVector * 15)
									game.Debris:AddItem(bv,0.15)
								end
								RagdollModule:Start(echar)
							else
								task.spawn(function()
									DamageModule:Slash(char,echar,70,25,0.2,2,math.random(1,4),nil,true,30,nil,nil,nil,true)
								end)
							end
						else
							if ehum.Health <= 70 then
								task.spawn(function()
									DamageModule:Slash(char,echar,ehum.Health,25,0.2,2,math.random(1,4),nil,true,30,nil,nil,nil,true)
								end)
								if echar:FindFirstChild("Torso"):FindFirstChild("Neck") then
									echar:FindFirstChild("Torso"):FindFirstChild("Neck"):Destroy()
									local bv = Instance.new("BodyVelocity",echar:FindFirstChild("Head"))
									bv.MaxForce = Vector3.new(1,1,1) * math.huge
									bv.P = 1234567
									bv.Velocity = (hrp.CFrame.LookVector * 30) + (hrp.CFrame.UpVector * 15)
									game.Debris:AddItem(bv,0.15)
								end
								RagdollModule:Start(echar)
							else
								task.spawn(function()
									DamageModule:Slash(char,echar,70,25,0.2,2,math.random(1,4),nil,true,30,nil,nil,nil,true)
								end)
							end
						end
					end)
					task.spawn(function()
						effect = false
						remote:FireClient(plr,"UnknownStop2")
						CutsenseRemote:FireClient(plr,"UnknownStop")
						camShake:FireClient(plr,"StopShaking2")
						Invisible = false
						task.spawn(function()
							for i,v in pairs(TranEffect:GetDescendants()) do
								if v:IsA("ParticleEmitter") then
									spawn(function()
										local EA = v:GetAttribute("EmitCount")
										v:Emit(EA)
									end)
								end
							end
							task.wait(1.5)
							TranEffect:Destroy()
						end)
						task.wait(0.2)
						local Gobal = Instance.new("IntValue",char)
						Gobal.Name = "Gobal"
						Dragon:Destroy()
						remote:FireClient(plr,"Done5")
						task.wait(0.2)
						hum.WalkSpeed = 0
						hum.JumpPower = 0
						hum:LoadAnimation(rep.Anims.Rengoku.Death):Play()
						task.wait(3)
						hum.Health = 0
					end)
				end
			end
		end)
	end
end)
