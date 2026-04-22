local rep = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")
local remote = rep:WaitForChild("Remotes"):WaitForChild("Yuji")
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
				local Tracks = echar.Humanoid:LoadAnimation(rep.Anims.Combat.Ragdoll)
				Tracks:Play()
				task.spawn(function()
					repeat
						task.wait()
					until not echar:FindFirstChild("Ragdolling")
					Tracks:Stop()
				end)
			else
				local Ragdolling = Instance.new("IntValue",echar)
				Ragdolling.Name = "Ragdolling"
				game.Debris:AddItem(Ragdolling,ragTime)
			end
		end
	end
	
	local function RagDoll2(echar,ragTime)
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
									end)								
								else
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
									DamageModule:Spec(pchar,echar,15,200,0.25,ST,nil,breakAmount,true,0.65,false,false,DirPush)
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
									DamageModule:Spec(pchar,echar,15,200,0.25,ST,nil,breakAmount,true,0.65,false,false,DirPush)
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
									RagDoll2(echar,ragTime)
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
					if echar ~= char and not echar:FindFirstChild("HyperArmor") and not echar:FindFirstChild("StrongArmor") then
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
											DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
										end)
										echar:FindFirstChild("Right Leg").Transparency = 1
										echar:FindFirstChild("Left Leg").Transparency = 1
										RagDoll2(echar,5)
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
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
									echar:FindFirstChild("Right Leg").Transparency = 1
									echar:FindFirstChild("Left Leg").Transparency = 1
									RagDoll2(echar,5)
								else
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
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
									echar:FindFirstChild("Right Leg").Transparency = 1
									echar:FindFirstChild("Left Leg").Transparency = 1
									RagDoll2(echar,5)
								else
									task.spawn(function()
										DamageModule:TrueDamage(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
									end)
								end
							else
								if ehum.Health <= dmg then
									task.spawn(function()
										DamageModule:TrueDamage(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
									echar:FindFirstChild("Right Leg").Transparency = 1
									echar:FindFirstChild("Left Leg").Transparency = 1
									RagDoll2(echar,5)
								else
									task.spawn(function()
										DamageModule:TrueDamage(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								end
							end
							local slashEffect = rep.VFX.Characters.Yuji.SlashedPart:Clone()
							slashEffect.Parent = visuals
							slashEffect.CFrame = ehrp.CFrame
							slashEffect.Weld.Part1 = ehrp
							slashEffect.Slash:Emit(8)
							game.Debris:AddItem(slashEffect,0.5)
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
	if wut == "Brother" then
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Include
		params.FilterDescendantsInstances = {workspace.Map}
		local ray = workspace:Raycast(hrp.Position,Vector3.new(0,-100,0),params)
		if ray then
			local Power = rep.VFX.Characters.Yuji.Todo:Clone()
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
			task.wait(0.05)
			Power.HumanoidRootPart.Smoke:Emit(50)
			Power.Humanoid:LoadAnimation(Power.ClapAnim):Play()
			task.wait(0.5)
			local params2 = OverlapParams.new()
			params2.FilterType = Enum.RaycastFilterType.Exclude
			params2.MaxParts = 0
			params2.FilterDescendantsInstances = {Power.HitBox,visuals}
			local TodoCF = Power.HumanoidRootPart.CFrame
			task.spawn(function()
				local TrueEchar = nil
				for i,hit in pairs(workspace:GetPartsInPart(Power.HitBox,params2)) do
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
					for i,v in pairs(TrueEchar:GetChildren()) do
						if v.Name == "Ragdolling" then
							v:Destroy()
						end
					end
					local Stun = Instance.new("IntValue",TrueEchar)
					Stun.Name = "Stun"
					game.Debris:AddItem(Stun,1)
					local HitCursed = rep.VFX.Characters.Yuji.HitedCurse:Clone()
					HitCursed.Parent = visuals
					HitCursed.CFrame = TrueEchar.HumanoidRootPart.CFrame
					HitCursed.Anchored = true
					TrueEchar.HumanoidRootPart.CFrame = TodoCF
					game.Debris:AddItem(HitCursed,1)
					task.spawn(function()
						task.wait(0.05)
						for i,v in pairs(HitCursed:GetDescendants()) do
							if v:IsA("ParticleEmitter") then
								spawn(function()
									local EA = v:GetAttribute("EmitCount")
									v:Emit(EA)
								end)
							end
						end
					end)
				end
			end)
			local Sound = rep.Sounds.Yuji.Clap:Clone()
			Sound.Parent = hrp
			Sound:Play()
			game.Debris:AddItem(Sound,Sound.TimeLength)
			local HitFX = Power.HitedCurse
			HitFX.Weld:Destroy()
			HitFX.Anchored = true
			HitFX.Parent = visuals
			game.Debris:AddItem(HitFX,1)
			task.spawn(function()
				for i,v in pairs(HitFX:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(EA)
						end)
					end
				end
			end)
			task.wait(0.05)
			Power:Destroy()
			task.wait(0.2)
			remote:FireClient(plr,"Done1")
		else
			
		end
	end
	if wut == "Barrage" then
		local track = hum:LoadAnimation(rep.Anims.Yuji.PrepareBarrage)
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
													remote:FireClient(plr,"Done1")
												else
													task.spawn(function()
														DamageModule:Spec(char,echar,1,0,0.05,2,math.random(6,7),nil,false,nil,false)
													end)
													if ehum.Health > 0 then
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
														local WeldChar = Instance.new("Weld",echar)
														WeldChar.Part0 = ehrp
														WeldChar.Part1 = hrp
														WeldChar.C0 = CFrame.new(0,0,-3.5) * CFrame.Angles(0,math.rad(180),0)
														local PlrBeat = hum:LoadAnimation(rep.Anims.Yuji.PlrBarrage)
														PlrBeat:Play()
														local EBeat = ehum:LoadAnimation(rep.Anims.Yuji.EnemyBarrage)
														EBeat:Play()
														PlrBeat:GetMarkerReachedSignal("Hit"):Connect(function()
															task.spawn(function()
																if ehum.Health > 2 then
																	DamageModule:Spec(char,echar,2,0,0,1.5,nil,nil,false,0,false)
																else
																	DamageModule:Spec(char,echar,0,0,0,1.5,nil,nil,false,0,false)
																end
															end)
															local HitSound = rep.Sounds.Yuji.HitSound:Clone()
															HitSound.Parent = ehrp
															HitSound:Play()
															task.spawn(function()
																task.wait(HitSound.TimeLength)
																HitSound:Destroy()
															end)
															local HitFX = rep.VFX.Characters.Yuji.HitFX:Clone()
															HitFX.Parent = visuals
															HitFX.CFrame = ehrp.CFrame
															HitFX.Weld.Part1 = ehrp
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
																if ehum.Health > 3 then
																	DamageModule:Spec(char,echar,3,0,0,1.5,nil,nil,false,0,false)
																else
																	DamageModule:Spec(char,echar,0,0,0,1.5,nil,nil,false,0,false)
																end
															end)
															local HitSound = rep.Sounds.Yuji.HitSound2:Clone()
															HitSound.Parent = ehrp
															HitSound:Play()
															task.spawn(function()
																task.wait(HitSound.TimeLength)
																HitSound:Destroy()
															end)
															local HitFX = rep.VFX.Characters.Yuji.ArmBreak:Clone()
															HitFX.Parent = ehrp
															task.spawn(function()
																for i,v in pairs(HitFX:GetDescendants()) do
																	if v:IsA("ParticleEmitter") then
																		spawn(function()
																			v.Parent = echar:FindFirstChild("Right Arm")
																			local EA = v:GetAttribute("EmitCount")
																			v:Emit(EA)
																			task.wait(1)
																			v:Destroy()
																		end)
																	end
																end
																task.wait(1)
																HitFX:Destroy()
																local ArmEffect = true
																local CursedArm1 = rep.VFX.Characters.Yuji.CursedArm:Clone()
																CursedArm1.Parent = visuals
																CursedArm1.CFrame = char:FindFirstChild("Right Arm").CFrame
																CursedArm1.TrueWeld.Part1 = char:FindFirstChild("Right Arm")
																task.spawn(function()
																	while ArmEffect do
																		task.spawn(function()
																			task.wait(0.2)
																			for i,v in pairs(CursedArm1:GetDescendants()) do
																				if v:IsA("ParticleEmitter") then
																					spawn(function()
																						local EA = v:GetAttribute("EmitCount")
																						v:Emit(1)
																						game:GetService("Debris"):AddItem(CursedArm1,1.1)
																					end)
																				end
																			end
																		end)
																		task.wait(0.075)
																	end
																end)
															end)
														end)
														PlrBeat:GetMarkerReachedSignal("EndHit"):Connect(function()
															WeldChar:Destroy()
															Massless = false
															ehum.AutoRotate = true
															task.wait(0.05)
															EBeat:Stop()
															task.spawn(function()
																DamageModule:Spec(char,echar,5,60,0.25,3,5,nil,true,20,false)
															end)
															local HitFX = rep.VFX.Characters.Yuji.LastPunchFX:Clone()
															HitFX.Parent = visuals
															HitFX.CFrame = ehrp.CFrame
															HitFX.Weld.Part1 = hrp
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
															task.spawn(function()
																RagDoll2(echar,3)
															end)
															Stun:Destroy()
															cant1:Destroy()
															cant2:Destroy()
															remote:FireClient(plr,"Done1")
														end)
													else
														remote:FireClient(plr,"Done1")
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
					task.wait(0.3)
					Hitting = false
				end)
				task.wait(0.45)
				if Grabbed == false then
					remote:FireClient(plr,"Done1")
				end
			else
				track:Stop()
				remote:FireClient(plr,"Done1")
			end
		end)
	end
	if wut == "Divergent" then
		local track = hum:LoadAnimation(rep.Anims.Yuji.Divergent)
		track:Play()
		local ArmEffect = true
		local CursedArm1 = rep.VFX.Characters.Yuji.CursedArm:Clone()
		CursedArm1.Parent = visuals
		CursedArm1.CFrame = char:FindFirstChild("Right Arm").CFrame
		CursedArm1.TrueWeld.Part1 = char:FindFirstChild("Right Arm")
		task.spawn(function()
			while ArmEffect do
				task.spawn(function()
					for i,v in pairs(CursedArm1:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(1)
							end)
						end
					end
				end)
				task.wait(0.075)
			end
		end)
		task.wait(0.25)
		if not char:FindFirstChild("Stun") then
			local Hitted = false
			local box = rep.VFX.Boxes.NormalPunch:Clone()
			box.Parent = visuals
			box.CFrame = hrp.CFrame * CFrame.new(0,0,3.5)
			box.Transparency = 1
			local w1 = Instance.new("Weld",box)
			w1.Part0 = box
			w1.Part1 = hrp
			w1.C0 = CFrame.new(0,0,3.5)
			game.Debris:AddItem(box,0.2)
			local sound = rep.Sounds.BasicAttack.PunchSwing:Clone()
			sound.Parent = hrp
			sound:Play()
			game.Debris:AddItem(sound,1)
			local function Grabbing()
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
							if CheckDown(echar) then
								if not echar:FindFirstChild(HitName) and Hitted == false then
									Hitted = true
									track:Stop()
									local GetHit = Instance.new("IntValue")
									GetHit.Parent = echar
									GetHit.Name = HitName
									game.Debris:AddItem(GetHit,HitTime)
									local ehum = echar:FindFirstChild("Humanoid")
									local ehrp = echar:FindFirstChild("HumanoidRootPart")
									local function Beating()
										for i,v in pairs(char:GetChildren()) do
											if v.Name == "Ragdolling" then
												v:Destroy()
											end
										end
										local CurseEffect = rep.VFX.Characters.Yuji.HitedCurse:Clone()
										CurseEffect.Parent = visuals
										CurseEffect.CFrame = ehrp.CFrame
										CurseEffect.Weld.Part1 = ehrp
										task.spawn(function()
											DamageModule:Spec(char,echar,2,0,0.05,1,math.random(6,7),nil,false,nil,false)
										end)
										if not CounterCheck(echar) then
											task.spawn(function()
												CursedArm1.Trail.Enabled = false
												ArmEffect = false
												task.wait(0.5)
												CursedArm1:Destroy()
											end)
											remote:FireClient(plr,"Done2")
										else
											if ehum.Health > 0 then
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
												local sound2 = rep.Sounds.Yuji.Divegent:Clone()
												sound2.Parent = hrp
												sound2:Play()
												game.Debris:AddItem(sound2,sound2.TimeLength)
												local WeldChar = Instance.new("Weld",echar)
												WeldChar.Part0 = ehrp
												WeldChar.Part1 = hrp
												WeldChar.C0 = CFrame.new(0,0,-3) * CFrame.Angles(0,math.rad(180),0)
												track:Stop()
												hum:LoadAnimation(rep.Anims.Yuji.DivergentHited):Play()
												task.wait(0.45)
												WeldChar:Destroy()
												Massless = false
												ehum.AutoRotate = true
												task.wait(0.05)
												task.spawn(function()
													for i,v in pairs(CurseEffect:GetDescendants()) do
														if v:IsA("ParticleEmitter") then
															spawn(function()
																local EA = v:GetAttribute("EmitCount")
																v:Emit(EA)
															end)
														end
													end
													game.Debris:AddItem(CurseEffect,1)
												end)
												task.spawn(function()
													DamageModule:Spec(char,echar,8,10,0.05,1,nil,nil,false,0,false)
												end)
												task.spawn(function()
													CursedArm1.Trail.Enabled = false
													ArmEffect = false
													task.wait(0.5)
													CursedArm1:Destroy()
												end)
												Stun:Destroy()
												cant1:Destroy()
												cant2:Destroy()
												remote:FireClient(plr,"Done2")
											else
												task.spawn(function()
													CursedArm1.Trail.Enabled = false
													ArmEffect = false
													task.wait(0.5)
													CursedArm1:Destroy()
												end)
												remote:FireClient(plr,"Done2")
											end
										end
									end
									if echar:FindFirstChild("Block") then
										echar:FindFirstChild("Block"):Destroy()
										task.spawn(function()
											DamageModule:Spec(char,echar,2,0,0.05,1,math.random(6,7),nil,false,nil,false)
										end)
										task.spawn(function()
											CursedArm1.Trail.Enabled = false
											ArmEffect = false
											task.wait(0.5)
											CursedArm1:Destroy()
										end)
										remote:FireClient(plr,"Done2")
									else
										Beating()
									end
								end
							end
						end
					end
				end
			end
			task.spawn(function()
				Grabbing()
			end)
			task.wait(0.3)
			if Hitted == false then
				task.spawn(function()
					CursedArm1.Trail.Enabled = false
					ArmEffect = false
					task.wait(0.5)
					CursedArm1:Destroy()
				end)
				remote:FireClient(plr,"Done2")
			end
		else
			task.spawn(function()
				CursedArm1.Trail.Enabled = false
				ArmEffect = false
				task.wait(0.5)
				CursedArm1:Destroy()
			end)
			remote:FireClient(plr,"Done2")
		end
	end
	if wut == "Black" then
		hum:LoadAnimation(rep.Anims.Yuji.PrepareHead):Play()
		task.wait(0.5)
		if not char:FindFirstChild("Stun") then
			local Grabbed = false
			local box = rep.VFX.Boxes.NormalPunch:Clone()
			box.Parent = visuals
			box.CFrame = hrp.CFrame * CFrame.new(0,0,3.5)
			box.Transparency = 1
			local w1 = Instance.new("Weld",box)
			w1.Part0 = box
			w1.Part1 = hrp
			w1.C0 = CFrame.new(0,0,3.5)
			game.Debris:AddItem(box,0.2)
			task.spawn(function()
				local params = OverlapParams.new()
				params.FilterType = Enum.RaycastFilterType.Exclude
				params.MaxParts = 0
				params.FilterDescendantsInstances = {box,visuals}
				local HitName = "Black"
				local HitTime = 0.1
				for i,hit in pairs(workspace:GetPartsInPart(box,params)) do
					local echar = hit.Parent
					if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
						if echar ~= char and not echar:FindFirstChild("HyperArmor") and not echar:FindFirstChild("StrongArmor") and CheckDown(echar) then
							if not echar:FindFirstChild(HitName) and Grabbed == false then
								Grabbed = true
								local GetHit = Instance.new("IntValue")
								GetHit.Parent = echar
								GetHit.Name = HitName
								game.Debris:AddItem(GetHit,HitTime)
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
										if ehum.Health > 0 then
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
											ehrp.CFrame = hrp.CFrame * CFrame.new(0,0,-2.5) * CFrame.Angles(0,math.rad(180),0)
											local WeldChar = Instance.new("Weld",echar)
											WeldChar.Part0 = ehrp
											WeldChar.Part1 = hrp
											WeldChar.C0 = CFrame.new(0,0,-2.5) * CFrame.Angles(0,math.rad(180),0)
											hum:LoadAnimation(rep.Anims.Yuji.PlrHeadBut):Play()
											ehum:LoadAnimation(rep.Anims.Yuji.EnemyHeadBut):Play()
											task.spawn(function()
												local Blood = rep.VFX.BasicAttack.Blood:Clone()
												Blood.Parent = echar:FindFirstChild("Head")
												task.wait(0.5)
												task.spawn(function()
													if ehum.Health <= 2.5 then
														DamageModule:Spec(char,echar,0,0,0.05,1,nil,nil,false,0,false)
													else
														DamageModule:Spec(char,echar,2.5,0,0.05,1,nil,nil,false,0,false)
													end
												end)
												task.spawn(function()
													local hitsound = rep.Sounds.BasicAttack.BloodHead1:Clone()
													hitsound.Parent = ehrp
													hitsound:Play()
													task.wait(hitsound.TimeLength)
													hitsound:Destroy()
												end)
												Blood:Emit(25)
												task.wait(0.75)
												task.spawn(function()
													if ehum.Health <= 2.5 then
														DamageModule:Spec(char,echar,0,0,0.05,1,nil,nil,false,0,false)
													else
														DamageModule:Spec(char,echar,2.5,0,0.05,1,nil,nil,false,0,false)
													end
												end)
												task.spawn(function()
													local hitsound = rep.Sounds.BasicAttack.BloodHead2:Clone()
													hitsound.Parent = ehrp
													hitsound:Play()
													task.wait(hitsound.TimeLength)
													hitsound:Destroy()
												end)
												Blood:Emit(25)
												task.wait(0.75)
												task.spawn(function()
													if ehum.Health <= 2.5 then
														DamageModule:Spec(char,echar,0,0,0.05,1,nil,nil,false,0,false)
													else
														DamageModule:Spec(char,echar,2.5,0,0.05,1,nil,nil,false,0,false)
													end
												end)
												task.spawn(function()
													local hitsound = rep.Sounds.BasicAttack.BloodHead3:Clone()
													hitsound.Parent = ehrp
													hitsound:Play()
													task.wait(hitsound.TimeLength)
													hitsound:Destroy()
												end)
												Blood:Emit(25)
												task.wait(1)
												local ArmEffect = true
												local CursedArm1 = rep.VFX.Characters.Yuji.CursedArmRed:Clone()
												CursedArm1.Parent = visuals
												CursedArm1.CFrame = char:FindFirstChild("Right Arm").CFrame
												CursedArm1.TrueWeld.Part1 = char:FindFirstChild("Right Arm")
												task.spawn(function()
													while ArmEffect do
														task.spawn(function()
															for i,v in pairs(CursedArm1:GetDescendants()) do
																if v:IsA("ParticleEmitter") then
																	spawn(function()
																		local EA = v:GetAttribute("EmitCount")
																		v:Emit(1)
																	end)
																end
															end
														end)
														task.wait(0.075)
													end
												end)
												task.spawn(function()
													local hitsound = rep.Sounds.Yuji.Kokusen:Clone()
													hitsound.Parent = hrp
													hitsound:Play()
													task.wait(hitsound.TimeLength)
													hitsound:Destroy()
												end)
												task.wait(1)
												ArmEffect = false
												task.spawn(function()
													CursedArm1.Trail.Enabled = false
													ArmEffect = false
													task.wait(0.5)
													CursedArm1:Destroy()
												end)
											end)
											task.wait(3.95)
											WeldChar:Destroy()
											Massless = false
											ehum.AutoRotate = false
											task.wait(0.05)
											task.spawn(function()
												DamageModule:Spec(char,echar,5,40,0.2,3,nil,nil,true,15,false)
											end)
											task.spawn(function()
												local hitsound = rep.Sounds.Yuta.Lightning2:Clone()
												hitsound.Parent = hrp
												hitsound:Play()
												task.wait(hitsound.TimeLength)
												hitsound:Destroy()
											end)
											task.spawn(function()
												local BlackFlash = rep.VFX.Characters.Yuji.BlackFlashPart:Clone()
												BlackFlash.Parent = visuals
												BlackFlash.CFrame = ehrp.CFrame
												local weld2 = Instance.new("Weld",BlackFlash)
												weld2.Part0 = ehrp
												weld2.Part1 = BlackFlash
												task.wait(0.01)
												task.spawn(function()
													for i,v in pairs(BlackFlash:GetDescendants()) do
														if v:IsA("ParticleEmitter") then
															spawn(function()
																local EA = v:GetAttribute("EmitCount")
																v:Emit(EA)
															end)
														end
													end
												end)
												task.wait(3)
												BlackFlash:Destroy()
											end)
											task.spawn(function()
												RagDoll2(echar,3)
											end)
											Stun:Destroy()
											cant1:Destroy()
											cant2:Destroy()
											task.wait(0.2)
											remote:FireClient(plr,"Done3")
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
			task.wait(0.3)
			if Grabbed == false then
				Grabbed = true
				remote:FireClient(plr,"Done3")
			end
		else
			remote:FireClient(plr,"Done3")
		end
	end
	if wut == "Manji" then
		local track = hum:LoadAnimation(rep.Anims.Yuji.PrepareManji)
		track:Play()
		local HoraCounter = Instance.new("IntValue",char)
		HoraCounter.Name = "ManjiCounter"
		task.spawn(function()
			repeat
				task.wait()
			until not char:FindFirstChild("ManjiCounter")
			if track.IsPlaying then
				track:Stop()
			end
		end)
		task.wait(1)
		if char:FindFirstChild("ManjiCounter") and not char:FindFirstChild("Manjing") then
			HoraCounter:Destroy()
			task.wait(0.4)
			remote:FireClient(plr,"Done4")
		end
	end
	if wut == "ManjiActive" then
		local cant = Instance.new("IntValue",char)
		cant.Name = "StrongArmor"
		local check = Instance.new("IntValue",char)
		check.Name = "Manjing"
		hum:LoadAnimation(rep.Anims.Yuji.ManjiKick):Play()
		local SpinEffect = rep.VFX.Characters.Yuji.SpinKick:Clone()
		SpinEffect.Parent = visuals
		SpinEffect.Transparency = 1
		SpinEffect.CFrame = hrp.CFrame
		SpinEffect.TrueWeld.Part1 = hrp
		local sound = rep.Sounds.BasicAttack.Slam:Clone()
		sound.Parent = hrp
		sound:Play()
		game.Debris:AddItem(sound,sound.TimeLength)
		task.spawn(function()
			for i,v in pairs(SpinEffect:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					spawn(function()
						local EA = v:GetAttribute("EmitCount")
						v:Emit(EA)
					end)
				end
			end
			game.Debris:AddItem(SpinEffect,2)
		end)
		task.spawn(function()
			DamageBox3(SpinEffect,"KickedManji",0.1,char,8,60,0.2,2,nil,false,true,0.25,true,2,true)
		end)
		task.wait(1)
		check:Destroy()
		cant:Destroy()
		remote:FireClient(plr,"Done4")
	end
	if wut == "Awaken" then
		local cant = Instance.new("IntValue",char)
		cant.Name = "HyperArmor"
		local Awakening = Instance.new("IntValue",char)
		Awakening.Name = "Awakened"
		hum.Health = hum.MaxHealth
		local Aura = true
		local PlayerDied = false
		hum:LoadAnimation(rep.Anims.Yuji.Awaken):Play()
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
		task.spawn(function()
			task.wait(0.5)
			local blood = rep.VFX.BasicAttack.Blood:Clone()
			blood.Parent = hrp
			blood:Emit(50)
			local soundblood = rep.Sounds.BasicAttack.Blood:Clone()
			soundblood.Parent = hrp
			soundblood:Play()
			game.Debris:AddItem(soundblood,soundblood.TimeLength)
			task.wait(0.5)
			blood:Emit(50)
			local soundblood2 = rep.Sounds.BasicAttack.Blood:Clone()
			soundblood2.Parent = hrp
			soundblood2:Play()
			game.Debris:AddItem(soundblood2,soundblood2.TimeLength)
			local heart = rep.VFX.Characters.Yuji.Heart:Clone()
			heart.Parent = visuals
			heart.CFrame = hrp.CFrame
			heart.TrueWeld.Part1 = char:FindFirstChild("Right Arm")
			task.wait(0.5)
			heart.TrueWeld.Part1 = nil
			heart.CanCollide = true
			game.Debris:AddItem(heart,5)
		end)
		task.wait(2)
		local theme = rep.Sounds.Yuji.Theme:Clone()
		theme.Parent = hrp
		theme:Play()
		task.spawn(function()
			for i, v in pairs(char:GetChildren()) do
				if v:IsA("BasePart") or v:IsA("MeshPart") then
					local modelAura = rep.VFX.Characters.Yuji.Aura:Clone()
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
				Awakening:Destroy()
				Aura = false
				plr:WaitForChild("AwakenBar").Value = 0
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
	if wut == "Cleave" then
		local TrueEchar = nil
		local box = rep.VFX.Boxes.BackHand:Clone()
		local debris = game:GetService("Debris")
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
			local slashEffect = rep.VFX.Characters.Yuji.SlashedPart:Clone()
			slashEffect.Parent = visuals
			slashEffect.CFrame = TrueEchar.HumanoidRootPart.CFrame
			slashEffect.Weld.Part1 = TrueEchar.HumanoidRootPart
			task.spawn(function()
				for i = 1,10 do
					task.spawn(function()
						DamageModule:Spec(char,TrueEchar,2,0,0.05,0.5,nil,false,false,0,false,false,false)
						if TrueEchar.Humanoid.Health <= 2 and not TrueEchar:FindFirstChild("Block") then
							TrueEchar:FindFirstChild("Right Leg").Transparency = 1
							TrueEchar:FindFirstChild("Left Leg").Transparency = 1
							RagDoll2(TrueEchar,5)
						end
					end)
					task.spawn(function()
						slashEffect.Slash:Emit(5)
						local ranNum = math.random(1,4)
						local sound = rep.Sounds.Yuji:FindFirstChild("Slash"..ranNum):Clone()
						if sound then
							sound.Parent = TrueEchar.HumanoidRootPart
							sound:Play()
							game.Debris:AddItem(sound,sound.TimeLength)
						end
					end)
					task.wait(0.1)
				end
				game.Debris:AddItem(slashEffect,1)
			end)
			remote:FireClient(plr,"Done5")
		else
			remote:FireClient(plr,"Done5")
		end
	end
	if wut == "FireArrow" then
		hum:LoadAnimation(rep.Anims.Yuji.FireArrow):Play()
		task.wait(0.5)
		if not char:FindFirstChild("Stun") then
			local Effect = true
			local Hitted = false
			local wave = rep.VFX.Characters.Yuji.FireWave:Clone()
			wave.Parent = visuals
			wave.CFrame = hrp.CFrame * CFrame.new(0,0,-2) * CFrame.Angles(math.rad(-90),0,0)
			ts:Create(wave,TweenInfo.new(0.35,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(10,1,10),Transparency = 1}):Play()
			task.spawn(function()
				task.wait(0.35)
				wave:Destroy()
			end)
			local sound1 = rep.Sounds.Yuji.FlameLight:Clone()
			sound1.Parent = hrp
			sound1:Play()
			game.Debris:AddItem(sound1,sound1.TimeLength)
			local FireArrow = rep.VFX.Characters.Yuji.FireArrow:Clone()
			FireArrow.Parent = visuals
			FireArrow.CFrame = hrp.CFrame
			task.spawn(function()
				while Effect do
					task.spawn(function()
						for i,v in pairs(FireArrow:GetDescendants()) do
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
			local flyTrack = ts:Create(FireArrow,TweenInfo.new(0.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = hrp.CFrame * CFrame.new(0,0,-100)})
			flyTrack:Play()
			task.spawn(function()
				flyTrack.Completed:Connect(function()
					if Hitted == false then
						Hitted = true
						Effect = false
						game.Debris:AddItem(FireArrow,1)
						local Explode = rep.VFX.Characters.Yuji.FireExplode:Clone()
						Explode.Parent = visuals
						Explode.CFrame = FireArrow.CFrame
						local sound2 = rep.Sounds.Yuji.FireExplode:Clone()
						sound2.Parent = Explode
						sound2:Play()
						game.Debris:AddItem(sound2,sound2.TimeLength)
						task.spawn(function()
							for i,v in pairs(Explode:GetDescendants()) do
								if v:IsA("ParticleEmitter") then
									spawn(function()
										local EA = v:GetAttribute("EmitCount")
										v:Emit(EA)
									end)
								end
							end
							game.Debris:AddItem(Explode,3)
						end)
						task.spawn(function()
							DamageBox2(Explode,"Fired",0.1,char,15,50,0.2,1,nil,false,true,20,false,0)
						end)
					end
				end)
			end)
			task.spawn(function()
				FireArrow.Touched:Connect(function(hit)
					if Hitted == false then
						local echar = hit.Parent
						if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
							if echar ~= char and Hitted == false  then
								flyTrack:Pause()
								Hitted = true
								Effect = false
								game.Debris:AddItem(FireArrow,1)
								local Explode = rep.VFX.Characters.Yuji.FireExplode:Clone()
								Explode.Parent = visuals
								Explode.CFrame = FireArrow.CFrame
								local sound2 = rep.Sounds.Yuji.FireExplode:Clone()
								sound2.Parent = Explode
								sound2:Play()
								game.Debris:AddItem(sound2,sound2.TimeLength)
								task.spawn(function()
									for i,v in pairs(Explode:GetDescendants()) do
										if v:IsA("ParticleEmitter") then
											spawn(function()
												local EA = v:GetAttribute("EmitCount")
												v:Emit(EA)
											end)
										end
									end
									game.Debris:AddItem(Explode,3)
								end)
								task.spawn(function()
									DamageBox2(Explode,"Fired",0.1,char,15,50,0.2,1,nil,false,true,20,false,0)
								end)
							end
						end
					end
				end)
			end)
			task.wait(0.2)
			remote:FireClient(plr,"Done6")
		else
			remote:FireClient(plr,"Done6")
		end
	end
	if wut == "Dismantle" then
		local Effect = true
		local Hitting = true
		local Slashing = rep.VFX.Characters.Yuji.Slashing:Clone()
		Slashing.Parent = visuals
		Slashing.CFrame = hrp.CFrame
		Slashing.Weld.Part1 = hrp
		task.spawn(function()
			while Hitting do
				task.spawn(function()
					DamageBox4(Slashing,"Slashed",0.1,char,1,0,0.05,0.75,nil,false,false,false,false,false)
				end)
				task.wait()
			end
		end)
		task.spawn(function()
			while Effect do
				task.spawn(function()
					task.spawn(function()
						for i,v in pairs(Slashing:GetDescendants()) do
							if v:IsA("ParticleEmitter") then
								spawn(function()
									local EA = v:GetAttribute("EmitCount")
									v:Emit(1)
								end)
							end
						end
					end)
				end)
				task.wait()
			end
		end)
		task.spawn(function()
			while Effect do
				task.spawn(function()
					local ranNum = math.random(1,4)
					local sound = rep.Sounds.Yuji:FindFirstChild("Slash"..ranNum):Clone()
					if sound then
						sound.Parent = hrp
						sound:Play()
						game.Debris:AddItem(sound,sound.TimeLength)
					end
				end)
				task.wait(0.1)
			end
		end)
		task.wait(2.5)
		Effect = false
		Hitting = false
		game.Debris:AddItem(Slashing,0.5)
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
		track1:Play()
		local sound = rep.Sounds.Yuji.Domain:Clone()
		sound.Parent = hrp
		sound:Play()
		game.Debris:AddItem(sound,sound.TimeLength)
		local Domain = rep.VFX.Characters.Yuji.Domain:Clone()
		Domain.Parent = visuals
		Domain.Inside.Shell.CanCollide = false
		Domain.Location.CFrame = hrp.CFrame
		task.wait(1.5)
		Domain.Inside.Shell.CanCollide = true
		task.spawn(function()
			Domain.Inside.Shell.Transparency = 0
			Domain.Water.Transparency = 0
			Domain.Water.Texture.Transparency = 0.5
		end)
		task.spawn(function()
			task.wait(9)
			for i, v in pairs(Domain.Shrine:GetDescendants()) do
				if v:IsA("BasePart") or v:IsA("MeshPart") then
					ts:Create(v,TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut,0,false,0),{Transparency = 0}):Play()
				end
			end
		end)
		local params2 = OverlapParams.new()
		params2.FilterType = Enum.RaycastFilterType.Exclude
		params2.MaxParts = 0
		params2.FilterDescendantsInstances = {Domain.Inside.Shell,visuals}
		CutsenseRemote:FireClient(plr,"SukunaDomain",char)
		LightingRemote:FireClient(plr,"SukunaDomain")
		task.spawn(function()
			for i,hit in pairs(workspace:GetPartsInPart(Domain.HitBox,params2)) do
				local echar = hit.Parent
				if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
					if echar ~= char then
						if not echar:FindFirstChild("GetDomain") then
							local Check = Instance.new("IntValue",echar)
							Check.Name = "GetDomain"
							local Stun = Instance.new("IntValue",echar)
							Stun.Name = "Stun"
							game.Debris:AddItem(Stun,11)
							local EDied = false
							local eplr = game:GetService("Players"):GetPlayerFromCharacter(echar)
							if eplr then
								CutsenseRemote:FireClient(eplr,"SukunaDomain",char)
								LightingRemote:FireClient(eplr,"SukunaDomain")
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
								end
							end)
						end
					end
				end
			end
		end)
		task.wait(11)
		track1:Stop()
		hum.AutoRotate = true
		remote:FireClient(plr,"Done8")
		local effect = true
		task.spawn(function()
			task.spawn(function()
				while effect do
					task.spawn(function()
						task.spawn(function()
							for i,v in pairs(Domain.MainPart:GetDescendants()) do
								if v:IsA("ParticleEmitter") then
									spawn(function()
										local EA = v:GetAttribute("EmitCount")
										v:Emit(2)
									end)
								end
							end
						end)
					end)
					task.wait()
				end
			end)
			task.spawn(function()
				while effect do
					task.spawn(function()
						local ranNum = math.random(1,4)
						local sound = rep.Sounds.Yuji:FindFirstChild("Slash"..ranNum):Clone()
						if sound then
							sound.Parent = hrp
							sound:Play()
							game.Debris:AddItem(sound,sound.TimeLength)
						end
					end)
					task.wait(0.1)
				end
			end)
			task.spawn(function()
				while effect do
					task.spawn(function()
						DamageBox5(Domain.HitBox,"Domained",0.1,char,0.75,0,0.05,0.75,nil,false,false,0,false,false)
					end)
					task.wait()
				end
			end)
		end)
		task.wait(5)
		effect = false
		ts:Create(Domain.Inside.Shell,TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Color = Color3.new(1, 1, 1)}):Play()
		task.wait(1.1)
		cant:Destroy()
		DomainStart = false
		if not Died then
			CheckDomain:Destroy()
		end
		task.spawn(function()
			for i, v in pairs(Domain.Shrine:GetDescendants()) do
				if v:IsA("BasePart") or v:IsA("MeshPart") then
					v.Transparency = 1
				end
			end
		end)
		local BreakSound = rep.Sounds.Gojo.DomainBreak:Clone()
		BreakSound.Parent = hrp
		BreakSound:Play()
		game.Debris:AddItem(BreakSound,BreakSound.TimeLength)
		Domain.Inside.Shell.Glass:Emit(250)
		Domain.Inside.Shell.Transparency = 1
		Domain.Water.Transparency = 1
		Domain.Water.Texture.Transparency = 1
		Domain.Inside.Shell.CanCollide = false
		game.Debris:AddItem(Domain,3)
	end
end)

