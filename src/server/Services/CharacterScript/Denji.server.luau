local rep = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")
local remote = rep:WaitForChild("Remotes"):WaitForChild("Denji")
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
	
	local function CheckUp(echar)
		if echar:FindFirstChild("Uppering") then
			return true
		else
			return false
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
									task.spawn(function()
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								else
									task.spawn(function()
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								end
							else
								if ehum.Health <= dmg then
									task.spawn(function()
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)								else
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
										DamageModule:Spec(pchar,echar,0,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								else
									task.spawn(function()
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								end
							else
								if ehum.Health <= dmg then
									task.spawn(function()
										DamageModule:Spec(pchar,echar,0,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)								else
									task.spawn(function()
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								end
							end
							task.spawn(function()
								if ragdoll == true then
									if not CounterCheck(echar) then
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
	local function DamageBox4(box,HitName,HitTime,pchar,dmg,Power,PT,ST,combo,breakAmount,Up,High,ragdoll,ragTime,DirPush)
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
											bv.Velocity = (hrp.CFrame.UpVector * 20)
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
										bv.Velocity = (hrp.CFrame.UpVector * 20)
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
									RagDoll(echar,ragTime)
								end
							end)
						end
					end
				end
			end
		end)
	end
	local function DamageBox5(box,HitName,HitTime,pchar,dmg,Power,PT,ST,combo,breakAmount,Up,High,ragdoll,ragTime,DirPush)
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
								else
									task.spawn(function()
										DamageModule:Slash(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								end
							else
								if ehum.Health <= dmg then
									task.spawn(function()
										DamageModule:Slash(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)								else
									task.spawn(function()
										DamageModule:Slash(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								end
							end
							task.spawn(function()
								if ragdoll == true then
									if not CounterCheck(echar) then
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
	--------------------------------------------------------------
	if wut == "Kick" then
		hum:LoadAnimation(rep.Anims.Luffy.PrepareHead):Play()
		task.wait(0.4)
		if not char:FindFirstChild("Stun") then
			local Beated = false
			local box = rep.VFX.Boxes.SlamDown:Clone()
			box.Parent = visuals
			box.CFrame = hrp.CFrame * CFrame.new(0,2,2)
			box.Transparency = 1
			local w1 = Instance.new("Weld",box)
			w1.Part0 = box
			w1.Part1 = hrp
			w1.C0 = CFrame.new(0,2,2)
			game.Debris:AddItem(box,0.2)
			local sound = rep.Sounds.BasicAttack.PunchSwing:Clone()
			sound.Parent = hrp
			sound:Play()
			game.Debris:AddItem(sound,1)
			task.spawn(function()
				local params = OverlapParams.new()
				params.FilterType = Enum.RaycastFilterType.Exclude
				params.MaxParts = 0
				params.FilterDescendantsInstances = {box,visuals}
				local HitName = "Kicked"
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
											remote:FireClient(plr,"Done1")
										else
											local Stun = Instance.new("IntValue",echar)
											Stun.Name = "Stun"
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
											ehrp.CFrame = hrp.CFrame * CFrame.new(0,0,-2.7) * CFrame.Angles(0,math.rad(180),0)
											task.wait(0.1)
											local WeldChar = Instance.new("Weld",echar)
											WeldChar.Part0 = ehrp
											WeldChar.Part1 = hrp
											WeldChar.C0 = CFrame.new(0,0,-2.7) * CFrame.Angles(0,math.rad(180),0)
											hum:LoadAnimation(rep.Anims.Denji.BallBreaker):Play()
											task.wait(0.45)
											Stun:Destroy()
											Massless = false
											ehum.AutoRotate = true
											cant1:Destroy()
											cant2:Destroy()
											WeldChar.C0 = CFrame.new(0,0,0)
											WeldChar:Destroy()
											task.spawn(function()
												if ehum.Health <= 8 then
													DamageModule:Spec(char,echar,15,50,0.25,1,5,nil,true,20,false)
													local Trail = rep.VFX.BasicAttack.WhiteTrail:Clone()
													Trail.Parent = visuals
													Trail.CFrame = ehrp.CFrame
													local weld = Instance.new("Weld",Trail)
													weld.Part0 = ehrp
													weld.Part1 = Trail
													Trail.Trail.Enabled = true
													task.spawn(function()
														RagdollModule:Start(echar)
														RockModule.Front(hrp,3,0.2,10,true,0.2,0.05,1,5,0)
													end)
													task.spawn(function()
														camShake:FireClient(plr,"ShakeOnce")
														local eplr = game:GetService("Players"):GetPlayerFromCharacter(echar)
														if eplr then
															camShake:FireClient(eplr,"ShakeOnce")
														end
													end)
												else
													DamageModule:Spec(char,echar,8,10,0.1,1,8,nil,false,0,false)
												end
											end)
											ehum:LoadAnimation(rep.Anims.Denji.EnemyKicked):Play()
											remote:FireClient(plr,"Done1")
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
			task.wait(0.2)
			if Beated == false then
				remote:FireClient(plr,"Done1")
			end
		else
			task.wait(0.2)
			remote:FireClient(plr,"Done1")
		end
	end
	
	if wut == "Power" then
		if not char:FindFirstChild("Stun") then
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Include
			params.FilterDescendantsInstances = {workspace.Map}
			local ray = workspace:Raycast(hrp.Position,Vector3.new(0,-100,0),params)
			if ray then
				local Power = rep.VFX.Characters.Denji.Power:Clone()
				Power.Parent = visuals
				Power.PrimaryPart.CFrame = hrp.CFrame * CFrame.new(0,-ray.Distance+3,-5)
				Power.HumanoidRootPart.Anchored = true
				task.spawn(function()
					for i,v in pairs(Power:GetDescendants()) do
						if v:IsA("BasePart") or v:IsA("MeshPart") then
							v.CanCollide = false
						end
					end
				end)
				task.spawn(function()
					for i,v in pairs(Power:GetDescendants()) do
						if v:IsA("BasePart") then
							v.CollisionGroup = "Players"
						end
					end
				end)
				local smoke = rep.VFX.Characters.Denji.Smoke:Clone()
				smoke.Parent = visuals
				smoke.CFrame = Power.HumanoidRootPart.CFrame
				task.spawn(function()
					task.wait(0.1)
					smoke.Smoke:Emit(50)
				end)
				local sound2 = rep.Sounds.Denji.Spawn:Clone()
				sound2.Parent = hrp
				sound2:Play()
				game.Debris:AddItem(sound2,sound2.TimeLength)
				task.wait(0.1)
				Power.HumanoidRootPart.Sound:Play()
				Power.Humanoid:LoadAnimation(Power.Slam):Play()
				task.wait(0.25)
				local EffectSlam = Power.SlamEffect
				EffectSlam.Parent = visuals
				EffectSlam.CFrame = Power.Pos.CFrame * CFrame.new(0,-1,0)
				Power.Pos.Attachment.Ring:Emit(30)
				task.spawn(function()
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
					table.insert(CheckChar,visuals)
					RockModule.Ground(Power.Pos.Position,10,Vector3.new(2,2,2),CheckChar,13,false,5,0.25)
				end)
				task.spawn(function()
					DamageBox2(EffectSlam,"PowerSlam",0.1,char,12,0,0.25,2,nil,false,true,50,true,2)
				end)
				local sound3 = rep.Sounds.Denji.Slam:Clone()
				sound3.Parent = hrp
				sound3:Play()
				game.Debris:AddItem(sound3,sound3.TimeLength)
				task.spawn(function()
					for i,v in pairs(EffectSlam:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(EA)
							end)
						end
					end
					game.Debris:AddItem(EffectSlam,4)
				end)
				task.wait(0.7)
				smoke.Smoke:Emit(50)
				game.Debris:AddItem(smoke,1)
				Power:Destroy()
				remote:FireClient(plr,"Done2")
			else
				remote:FireClient(plr,"Done2")
			end
		else
			remote:FireClient(plr,"Done2")
		end
	end
	
	if wut == "Barrage" then
		local track = hum:LoadAnimation(rep.Anims.Denji.PrepareGrab)
		track:Play()
		track:GetMarkerReachedSignal("Hit"):Connect(function()
			if not char:FindFirstChild("Stun") then
				local Grabbed = false
				local Hitting = true
				local box = rep.VFX.Characters.Yuji.BarrageBox:Clone()
				box.Parent = visuals
				box.CFrame = hrp.CFrame
				box.Weld.Part1 = hrp
				game.Debris:AddItem(box,0.4)
				local function Grabbing()
					if Grabbed == false then
						local params = OverlapParams.new()
						params.FilterType = Enum.RaycastFilterType.Exclude
						params.MaxParts = 0
						params.FilterDescendantsInstances = {box,visuals}
						local HitName = "Barraged"
						local HitTime = 0.1
						for i,hit in pairs(workspace:GetPartsInPart(box,params)) do
							local echar = hit.Parent
							if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
								if echar ~= char and not echar:FindFirstChild("HyperArmor") and not echar:FindFirstChild("StrongArmor") then
									local function StartBeating()
										if not echar:FindFirstChild(HitName) and Grabbed == false then
											Grabbed = true
											Hitting = false
											track:Stop()
											local GetHit = Instance.new("IntValue")
											GetHit.Parent = echar
											GetHit.Name = HitName
											game.Debris:AddItem(GetHit,HitTime)
											local ehum = echar:FindFirstChild("Humanoid")
											local ehrp = echar:FindFirstChild("HumanoidRootPart")
											local function Beating()
												for i,v in pairs(echar:GetChildren()) do
													if v.Name == "Ragdolling" then
														v:Destroy()
													end
												end
												if not CounterCheck(echar) then
													task.spawn(function()
														DamageModule:Spec(char,echar,1,0,0.05,2,math.random(6,7),nil,false,nil,false)
													end)
													remote:FireClient(plr,"Done3")
												else
													task.spawn(function()
														DamageModule:Spec(char,echar,1,0,0.05,2,math.random(6,7),nil,false,nil,false)
													end)
													if ehum.Health > 0 then
														local Stun = Instance.new("IntValue",echar)
														Stun.Name = "Stun"
														local Massless = true
														ehum.AutoRotate = false
														hum.AutoRotate = false
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
														local WeldChar = Instance.new("Weld",echar)
														WeldChar.Part0 = ehrp
														WeldChar.Part1 = hrp
														WeldChar.C0 = CFrame.new(0,0,0) * CFrame.Angles(0,math.rad(0),0)
														local PlrBeat = hum:LoadAnimation(rep.Anims.Denji.PlrGrab)
														PlrBeat:Play()
														local EBeat = ehum:LoadAnimation(rep.Anims.Denji.EnemyGrab)
														EBeat:Play()
														PlrBeat:GetMarkerReachedSignal("Hit"):Connect(function()
															task.spawn(function()
																if ehum.Health > 2 then
																	DamageModule:Spec(char,echar,2,0,0,1.5,nil,nil,false,0,false)
																else
																	DamageModule:Spec(char,echar,0,0,0,1.5,nil,nil,false,0,false)
																end
															end)
															local HitSound = rep.Sounds.Denji.HitSound:Clone()
															HitSound.Parent = ehrp
															HitSound:Play()
															task.spawn(function()
																task.wait(HitSound.TimeLength)
																HitSound:Destroy()
															end)
															local HitFX = rep.VFX.Characters.Yuji.HitFX:Clone()
															HitFX.Parent = visuals
															HitFX.CFrame = ehrp.CFrame
															HitFX.Weld.Part1 = echar.Torso
															task.spawn(function()
																RockModule.Ground(echar.Torso.Position,6,Vector3.new(1,1,1),{visuals},6,false,5,0.25)
															end)
															task.spawn(function()
																task.wait()
																for i,v in pairs(HitFX:GetDescendants()) do
																	if v:IsA("ParticleEmitter") then
																		spawn(function()
																			local EA = v:GetAttribute("EmitCount")
																			v:Emit(EA)
																		end)
																	end
																end
															end)
														end)
														PlrBeat:GetMarkerReachedSignal("Hit2"):Connect(function()
															task.spawn(function()
																if ehum.Health > 4 then
																	DamageModule:Spec(char,echar,4,0,0,1.5,nil,nil,false,0,false)
																else
																	DamageModule:Spec(char,echar,0,0,0,1.5,nil,nil,false,0,false)
																end
															end)
															local HitSound = rep.Sounds.Denji.HitSound:Clone()
															HitSound.Parent = ehrp
															HitSound:Play()
															task.spawn(function()
																task.wait(HitSound.TimeLength)
																HitSound:Destroy()
															end)
															local HitFX = rep.VFX.Characters.Yuji.HitFX:Clone()
															HitFX.Parent = visuals
															HitFX.CFrame = ehrp.CFrame
															HitFX.Weld.Part1 = echar.Torso
															task.spawn(function()
																RockModule.Ground(echar.Torso.Position,10,Vector3.new(2,2,2),{visuals},8,false,5,0.25)
															end)
															task.spawn(function()
																task.wait()
																for i,v in pairs(HitFX:GetDescendants()) do
																	if v:IsA("ParticleEmitter") then
																		spawn(function()
																			local EA = v:GetAttribute("EmitCount")
																			v:Emit(EA)
																		end)
																	end
																end
															end)
														end)
														PlrBeat:GetMarkerReachedSignal("FinalHit"):Connect(function()
															WeldChar:Destroy()
															Massless = false
															ehum.AutoRotate = true
															task.wait(0.05)
															EBeat:Stop()
															task.spawn(function()
																DamageModule:Spec(char,echar,5,60,0.25,3,5,nil,true,25,false)
															end)
															task.spawn(function()
																RagDoll2(echar,3)
															end)
															hum.AutoRotate = true
															Stun:Destroy()
															cant1:Destroy()
															cant2:Destroy()
															remote:FireClient(plr,"Done3")
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
									if CheckDown(echar) then
										StartBeating()
									else
										if CheckUp(echar) then
											StartBeating()
										end
									end
								end
							end
						end
					end
				end
				task.spawn(function()
					while Hitting do
						task.spawn(function()
							Grabbing()
						end)
						task.wait()
					end
				end)
				task.spawn(function()
					task.wait(0.25)
					Hitting = false
				end)
				task.wait(0.45)
				if Grabbed == false then
					remote:FireClient(plr,"Done3")
				end
			else
				track:Stop()
				remote:FireClient(plr,"Done3")
			end
		end)
	end
	
	if wut == "Aki" then
		if not char:FindFirstChild("Stun") then
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Include
			params.FilterDescendantsInstances = {workspace.Map}
			local ray = workspace:Raycast(hrp.Position,Vector3.new(0,-100,0),params)
			if ray then
				local Aki = rep.VFX.Characters.Denji.Aki:Clone()
				Aki.Parent = visuals
				Aki.HumanoidRootPart.Anchored = true
				task.spawn(function()
					for i,v in pairs(Aki:GetDescendants()) do
						if v:IsA("BasePart") or v:IsA("MeshPart") then
							v.CanCollide = false
						end
					end
				end)
				task.spawn(function()
					for i,v in pairs(Aki:GetDescendants()) do
						if v:IsA("BasePart") then
							v.CollisionGroup = "Players"
						end
					end
				end)
				local sound2 = rep.Sounds.Denji.Spawn:Clone()
				sound2.Parent = hrp
				sound2:Play()
				game.Debris:AddItem(sound2,sound2.TimeLength)
				Aki.Humanoid:LoadAnimation(Aki.Kon):Play()
				task.spawn(function()
					local sound = rep.Sounds.Denji.Kon:Clone()
					sound.Parent = Aki.HumanoidRootPart
					sound:Play()
					game.Debris:AddItem(sound,sound.TimeLength)
					task.spawn(function()
						Aki.PrimaryPart.CFrame = hrp.CFrame * CFrame.new(0,-ray.Distance+3,-5)
						local smoke = rep.VFX.Characters.Denji.Smoke:Clone()
						smoke.Parent = visuals
						smoke.CFrame = Aki.HumanoidRootPart.CFrame
						task.spawn(function()
							task.wait(3.5)
							smoke.Smoke:Emit(50)
							game.Debris:AddItem(smoke,1)
						end)
						task.spawn(function()
							task.wait(0.1)
							smoke.Smoke:Emit(50)
						end)
						local HitBox = rep.VFX.Characters.Denji.HitBoxAki:Clone()
						HitBox.Parent = visuals
						HitBox.CFrame = Aki.HumanoidRootPart.CFrame
						HitBox.Weld.Part1 = Aki.HumanoidRootPart
						task.wait(0.3)
						local TrueEchar = nil
						local params = OverlapParams.new()
						params.FilterType = Enum.RaycastFilterType.Exclude
						params.MaxParts = 0
						params.FilterDescendantsInstances = {HitBox,visuals}
						for i,hit in pairs(workspace:GetPartsInPart(HitBox,params)) do
							local echar = hit.Parent
							if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
								if echar ~= char and not echar:FindFirstChild("HyperArmor") and not echar:FindFirstChild("StrongArmor") then
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
						if TrueEchar ~= nil then
							task.wait(0.6)
							for i,v in pairs(TrueEchar:GetChildren()) do
								if v.Name == "Ragdolling" then
									v:Destroy()
								end
							end
							task.wait()
							local Kon = rep.VFX.Characters.Denji.KonKak:Clone()
							Kon.Parent = visuals
							Kon.PrimaryPart.CFrame = TrueEchar.HumanoidRootPart.CFrame * CFrame.new(0,-2.5,0) * CFrame.Angles(math.rad(90),0,0)
							Kon.AnimationController:LoadAnimation(Kon.Bited):Play()
							Kon.Box.Attachment.Smoke:Emit(50)
							Kon.Head.Transparency = 1
							Kon.Lower_Jaw.Transparency = 1
							task.spawn(function()
								task.wait(0.1)
								Kon.Head.Transparency = 0
								Kon.Lower_Jaw.Transparency = 0
								task.wait(0.2)
								task.spawn(function()
									DamageBox2(Kon.Box,"Bited",0.1,char,14,0,0.25,2,nil,false,true,50,true,2)
								end)
							end)
							task.wait(1.5)
							Kon.Box.Attachment.Smoke:Emit(50)
							Kon.Head.Transparency = 1
							Kon.Lower_Jaw.Transparency = 1
							game.Debris:AddItem(Kon,1)
						else
							task.wait(0.5)
							sound:Destroy()
						end
					end)
					task.wait(3.5)
					Aki:Destroy()
				end)
				task.wait(0.2)
				remote:FireClient(plr,"Done4")
			else
				remote:FireClient(plr,"Done4")
			end
		else
			remote:FireClient(plr,"Done4")
		end
	end
	
	if wut == "Awaken" then
		local cant = Instance.new("IntValue",char)
		cant.Name = "HyperArmor"
		local Awakening = Instance.new("IntValue",char)
		Awakening.Name = "Awakened"
		local Checker = Instance.new("IntValue",char)
		Checker.Name = "ChainsawCombat"
		if char:FindFirstChild("AnimateNormal") then
			char:FindFirstChild("AnimateNormal"):Destroy()
		end
		local Animate = game:GetService("ServerStorage"):WaitForChild("AnimateLocal"):WaitForChild("AnimateChainSaw"):Clone()
		Animate.Parent = char
		Animate.Enabled = true
		hum.Health = hum.MaxHealth
		local Aura = true
		local PlayerDied = false
		hum:LoadAnimation(rep.Anims.Denji.Awaken):Play()
		local SkillGui = plr.PlayerGui:WaitForChild("SkillsGui").Backpack
		local Saw1 = rep.VFX.Characters.Denji.Saw:Clone()
		local Saw2 = rep.VFX.Characters.Denji.Saw:Clone()
		local HeadSaw = rep.VFX.Characters.Denji.Helmet:Clone()
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
				plr:WaitForChild("AwakenBar").Value = 0
				Aura = false
				Saw1:Destroy()
				Saw2:Destroy()
				HeadSaw:Destroy()
				Checker:Destroy()
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
		task.spawn(function()
			task.wait(1.75)
			local PullSound = rep.Sounds.Denji.PullString:Clone()
			PullSound.Parent = hrp
			PullSound:Play()
			game.Debris:AddItem(PullSound,PullSound.TimeLength)
			task.wait(0.65)
			Saw1.Parent = visuals
			Saw2.Parent = visuals
			HeadSaw.Parent = visuals
			Saw1.TrueWeld.Part1 = char:FindFirstChild("Right Arm")
			Saw2.TrueWeld.Part1 = char:FindFirstChild("Left Arm")
			HeadSaw.TrueWeld.Part1 = char:FindFirstChild("Head")
			local blood = rep.VFX.BasicAttack.Blood:Clone()
			blood.Parent = char:FindFirstChild("Right Arm")
			blood:Emit(60)
			local blood2 = rep.VFX.BasicAttack.Blood:Clone()
			blood2.Parent = char:FindFirstChild("Left Arm")
			blood2:Emit(60)
			local blood3 = rep.VFX.BasicAttack.Blood:Clone()
			blood3.Parent = char:FindFirstChild("Head")
			blood3:Emit(60)
			local soundblood = rep.Sounds.BasicAttack.Blood:Clone()
			soundblood.Parent = hrp
			soundblood:Play()
			game.Debris:AddItem(soundblood,soundblood.TimeLength)
			local Scream = rep.Sounds.Denji.Scream:Clone()
			Scream.Parent = hrp
			Scream:Play()
			game.Debris:AddItem(Scream,Scream.TimeLength)
			game.Debris:AddItem(blood,1.5)
			game.Debris:AddItem(blood2,1.5)
			game.Debris:AddItem(blood3,1.5)
		end)
		task.wait(5)
		local theme = rep.Sounds.Denji.Theme:Clone()
		theme.Parent = hrp
		theme:Play()
		task.spawn(function()
			for i, v in pairs(char:GetChildren()) do
				if v:IsA("BasePart") or v:IsA("MeshPart") then
					local modelAura = rep.VFX.Characters.Denji.Aura:Clone()
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
				Animate:Destroy()
				Saw1:Destroy()
				Saw2:Destroy()
				Checker:Destroy()
				HeadSaw:Destroy()
				local newanim = game:GetService("ServerStorage"):WaitForChild("AnimateLocal"):WaitForChild("AnimateNormal"):Clone()
				newanim.Parent = char
				newanim.Enabled = true
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
	
	if wut == "Landed" then
		if char:FindFirstChild("CSJumping") then
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Include
			params.FilterDescendantsInstances = {workspace.Map}
			local ray = workspace:Raycast(hrp.Position,Vector3.new(0,-30,0),params)
			if ray then
				char:FindFirstChild("CSJumping"):Destroy()
				hum:LoadAnimation(rep.Anims.Denji.Jumped):Play()
				local SlamEffect = rep.VFX.Characters.Denji.SlamEffect:Clone()
				SlamEffect.Parent = visuals
				SlamEffect.CFrame = hrp.CFrame * CFrame.new(0,-ray.Distance,0)
				task.spawn(function()
					for i,v in pairs(SlamEffect:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(EA)
							end)
						end
					end
					game.Debris:AddItem(SlamEffect,5)
				end)
				task.spawn(function()
					RockModule.Ground(hrp.Position,20,Vector3.new(3,3,3),{workspace.Map},10,false,5,0.2)
				end)
				local sound = rep.Sounds.BasicAttack.GroundSmash:Clone()
				sound.Parent = hrp
				sound:Play()
				game.Debris:AddItem(sound,sound.TimeLength)
				task.spawn(function()
					DamageBox2(SlamEffect,"Slamed",0.1,char,20,0,0.3,2,nil,false,true,60,true,2)
				end)
				task.wait(0.2)
				remote:FireClient(plr,"Done8")
			else
				char:FindFirstChild("CSJumping"):Destroy()
				remote:FireClient(plr,"Done8")
			end
		end
	end
	
	if wut == "Slam" then
		hum:LoadAnimation(rep.Anims.Denji.ChainJump):Play()
		task.wait(0.5)
		if not char:FindFirstChild("Stun") then
			local Effect = rep.VFX.Characters.Denji.CSJump:Clone()
			Effect.Parent = visuals
			Effect.CFrame = hrp.CFrame
			Effect.Weld.Part1 = hrp
			task.spawn(function()
				for i,v in pairs(Effect:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(EA)
						end)
					end
				end
				game.Debris:AddItem(Effect,3)
			end)
			task.spawn(function()
				RockModule.Ground(hrp.Position,13,Vector3.new(1.5,1.5,1.5),{workspace.Map},12,false,5,0.2)
			end)
			local JumpTrack = hum:LoadAnimation(rep.Anims.Denji.Jumping)
			JumpTrack:Play()
			local sound = rep.Sounds.BasicAttack.Slam:Clone()
			sound.Parent = hrp
			sound:Play()
			game.Debris:AddItem(sound,sound.TimeLength)
			task.wait(0.05)
			local bv = Instance.new("BodyVelocity",hrp)
			bv.Parent = hrp
			bv.P = 12345678
			bv.MaxForce = Vector3.new(1,1,1) * 100000
			bv.Velocity = ((hrp.CFrame.LookVector * 90) + (hrp.CFrame.UpVector * 50))
			game.Debris:AddItem(bv,0.1)
			task.wait(0.25)
			local Jumping = Instance.new("IntValue",char)
			Jumping.Name = "CSJumping"
			local NotDone = true
			local After5s = task.delay(5,function()
				if char:FindFirstChild("CSJumping") then
					char:FindFirstChild("CSJumping"):Destroy()
					NotDone = false
					JumpTrack:Stop()
					remote:FireClient(plr,"Done8")
				end
			end)
			task.spawn(function()
				repeat
					task.wait()
				until not char:FindFirstChild("CSJumping")
				JumpTrack:Stop()
				if NotDone == true then
					NotDone = false
					task.cancel(After5s)
				end
			end)
		else
			remote:FireClient(plr,"Done8")
		end
	end
	
	if wut == "Flash" then
		hum:LoadAnimation(rep.Anims.Denji.FlashSlash):Play()
		task.wait(0.75)
		if not char:FindFirstChild("Stun") then
			local CheckChar = {workspace.Debris}
			for i,plr in pairs(game:GetService("Players"):GetPlayers()) do
				if plr.Character then
					table.insert(CheckChar,plr.Character)
				end
			end
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Exclude
			params.FilterDescendantsInstances = CheckChar
			local NewCF = hrp.CFrame * CFrame.new(0,0,-60)
			local Result = workspace:Raycast(hrp.Position,NewCF.Position - hrp.Position,params)
			local function FarDash()
				hum.AutoRotate = false
				local Cant = Instance.new("IntValue",char)
				Cant.Name = "StrongArmor"
				local sound = rep.Sounds.Denji.Flash:Clone()
				sound.Parent = hrp
				sound:Play()
				game.Debris:AddItem(sound,sound.TimeLength)
				hrp.CFrame = hrp.CFrame * CFrame.new(0,0,-60)
				task.wait(0.2)
				Cant:Destroy()
				hum.AutoRotate = true
			end
			local function NearDash(Distance)
				hum.AutoRotate = false
				local Cant = Instance.new("IntValue",char)
				Cant.Name = "StrongArmor"
				local sound = rep.Sounds.Denji.Flash:Clone()
				sound.Parent = hrp
				sound:Play()
				game.Debris:AddItem(sound,sound.TimeLength)
				hrp.CFrame = hrp.CFrame * CFrame.new(0,0,-Distance)
				task.wait(0.2)
				Cant:Destroy()
				hum.AutoRotate = true
			end
			local DeathEffect = rep.VFX.Characters.Denji.FlashSlash:Clone()
			DeathEffect.Parent = visuals
			DeathEffect.CFrame = hrp.CFrame * CFrame.new(0,0,-60/2)
			task.spawn(function()
				for i,v in pairs(DeathEffect:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(EA)
						end)
					end
				end
				game.Debris:AddItem(DeathEffect,2)
			end)
			task.spawn(function()
				DamageBox4(DeathEffect,"FlashSlash",0.05,char,15,20,0.1,1.5,nil,false,false,false,false,false,false)
			end)
			if Result then
				if Result.Distance < 60 then
					NearDash(Result.Distance)
				else
					FarDash()
				end
			else
				FarDash()
			end
			task.wait(0.2)
			remote:FireClient(plr,"Done7")
		else
			remote:FireClient(plr,"Done7")
		end
	end
	
	if wut == "Stab" then
		hum:LoadAnimation(rep.Anims.Denji.PrepareStab):Play()
		task.wait(0.5)

		if not char:FindFirstChild("Stun") then
			local Beated = false
			local box = rep.VFX.Boxes.SlamDown:Clone()
			box.Parent = visuals
			box.CFrame = hrp.CFrame * CFrame.new(0, 2, 2)
			box.Transparency = 1

			local w1 = Instance.new("Weld", box)
			w1.Part0 = box
			w1.Part1 = hrp
			w1.C0 = CFrame.new(0, 2, 2)
			game.Debris:AddItem(box, 0.2)

			task.spawn(function()
				local params = OverlapParams.new()
				params.FilterType = Enum.RaycastFilterType.Exclude
				params.MaxParts = 0
				params.FilterDescendantsInstances = {box, visuals}

				local HitName = "Stabbed"
				local HitTime = 0.1

				task.spawn(function()
					for i, hit in pairs(workspace:GetPartsInPart(box, params)) do
						local echar = hit.Parent

						if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
							if echar ~= char and not echar:FindFirstChild("HyperArmor") and not echar:FindFirstChild("StrongArmor") then
								if not echar:FindFirstChild(HitName) and not Beated and CheckDown(echar) then
									local GetHit = Instance.new("IntValue")
									GetHit.Parent = echar
									GetHit.Name = HitName
									game.Debris:AddItem(GetHit, HitTime)
									Beated = true
									task.wait(0.1)
									local ehum = echar:FindFirstChild("Humanoid")
									local ehrp = echar:FindFirstChild("HumanoidRootPart")
									local function Beating()
										for i, v in pairs(char:GetChildren()) do
											if v.Name == "Ragdolling" then
												v:Destroy()
											end
										end
										if not CounterCheck(echar) then
											task.spawn(function()
												DamageModule:Spec(char, echar, 1, 1, 0.05, 2, math.random(1, 4), nil, false, nil, false)
											end)
											remote:FireClient(plr, "Done1")
										else
											task.spawn(function()
												DamageModule:Slash(char, echar, 6, 0, 0.05, 2, math.random(1, 4), nil, false, nil, false)
											end)
											local Stun = Instance.new("IntValue", echar)
											Stun.Name = "Stun"
											local Massless = true
											ehum.AutoRotate = false
											local cant1 = Instance.new("IntValue", char)
											cant1.Name = "StrongArmor"
											local cant2 = Instance.new("IntValue", echar)
											cant2.Name = "StrongArmor"
											for i, v in pairs(echar:GetDescendants()) do
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
											ehrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -3) * CFrame.Angles(0, math.rad(180), 0)
											task.wait(0.1)
											local WeldChar = Instance.new("Weld", echar)
											WeldChar.Part0 = ehrp
											WeldChar.Part1 = hrp
											WeldChar.C0 = CFrame.new(0, 0, -3) * CFrame.Angles(0, math.rad(180), 0)
											hum:LoadAnimation(rep.Anims.Denji.PlrStab):Play()
											ehum:LoadAnimation(rep.Anims.Denji.EnemyStab):Play()
											task.wait(0.65)
											Stun:Destroy()
											Massless = false
											ehum.AutoRotate = true
											cant1:Destroy()
											cant2:Destroy()
											WeldChar.C0 = CFrame.new(0, 0, 0)
											WeldChar:Destroy()
											task.spawn(function()
												if ehum.Health <= 10 then
													DamageModule:Slash(char, echar, 10, 50, 0.25, 2.5, math.random(1, 4), nil, false, 0, false)
													local Trail = rep.VFX.BasicAttack.WhiteTrail:Clone()
													Trail.Parent = visuals
													Trail.CFrame = ehrp.CFrame
													local weld = Instance.new("Weld", Trail)
													weld.Part0 = ehrp
													weld.Part1 = Trail
													Trail.Trail.Enabled = true
													task.spawn(function()
														RagdollModule:Start(echar)
													end)
												else
													DamageModule:Slash(char, echar, 10, 50, 0.25, 2.5, math.random(1, 4), nil, false, 0, false)
													RagDoll2(echar, 2.5)
												end
											end)
											task.wait(0.25)
											remote:FireClient(plr, "Done6")
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

			task.wait(0.2)

			if not Beated then
				remote:FireClient(plr, "Done6")
			end
		else
			remote:FireClient(plr, "Done6")
		end
	end



	
	if wut == "Rampage" then
		local cant = Instance.new("IntValue",char)
		cant.Name = "StrongArmor"
		local NoCam = Instance.new("IntValue",char)
		NoCam.Name = "NoCamMove"
		local track = hum:LoadAnimation(rep.Anims.Denji.Rampage)
		track:Play(0.1,1,5)
		local hitting = true
		local BallEffect = rep.VFX.Characters.Denji.Rampage:Clone()
		BallEffect.Parent = visuals
		BallEffect.CFrame = hrp.CFrame
		BallEffect.Weld.Part1 = hrp
		task.spawn(function()
			while hitting do
				task.spawn(function()
					for i,v in pairs(BallEffect:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(2)
							end)
						end
					end
				end)
				task.spawn(function()
					local ranNum = math.random(1,4)
					local sound = rep.Sounds.Yuji:FindFirstChild("Slash"..ranNum):Clone()
					if sound then
						sound.Parent = hrp
						sound:Play()
						game.Debris:AddItem(sound,sound.TimeLength)
					end
				end)
				task.spawn(function()
					DamageBox5(BallEffect,"slashied",0.09,char,0.5,3,0.1,1,math.random(1,4),false,false,false,false,false)
				end)
				task.wait(0.1)
			end
		end)
		task.wait(3)
		NoCam:Destroy()
		game.Debris:AddItem(BallEffect,1)
		cant:Destroy()
		track:Stop()
		hitting = false
		remote:FireClient(plr,"Done5")
	end
end)
