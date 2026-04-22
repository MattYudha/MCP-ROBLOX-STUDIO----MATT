 local rep = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")
local remote = rep:WaitForChild("Remotes"):WaitForChild("Goku")
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
	local char = plr.Character or plr.CharacterAdded:Wait()
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
	
	
	local function DamageBox(box,HitName,HitTime,pchar,dmg,Power,PT,ST,combo,ragdoll,ragTime)
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
							if CheckDown(echar) then
								local GetHit = Instance.new("IntValue")
								GetHit.Parent = echar
								GetHit.Name = HitName
								game.Debris:AddItem(GetHit,HitTime)
								if echar:FindFirstChild("Block") then
									local lookVector = echar.HumanoidRootPart.CFrame.LookVector
									local Position = hrp.Position - echar.HumanoidRootPart.Position
									if (lookVector:Dot(Position)) < 0 then
										echar:FindFirstChild("Block"):Destroy()
										task.spawn(function()
											DamageModule:Normal(pchar,echar,dmg,Power,PT,ST,combo)
										end)
									else
										task.spawn(function()
											DamageModule:Normal(pchar,echar,dmg,Power,PT,ST,combo)
										end)
									end
								else
									task.spawn(function()
										DamageModule:Normal(pchar,echar,dmg,Power,PT,ST,combo)
									end)
								end
								task.spawn(function()
									if ragdoll == true then
										if not CounterCheck(echar) then
											RagDoll(echar,ragTime)
										end
									end
								end)
							end
						end
					end
				end
			end
		end)
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
										if CounterCheck(echar) then
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
									task.spawn(function()
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
									end)
								end
							else
								if ehum.Health <= dmg then
									if CounterCheck(echar) then
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
							end
							task.spawn(function()
								if ragdoll == true then
									if not CounterCheck(echar) then
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
	
	local function DamageBox3(box,HitName,HitTime,pchar,dmg,Power,PT,ST,combo,breakAmount,Up,High,ragdoll,ragTime)
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
									if CounterCheck(echar) then
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
										DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
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
										DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
									end)
								end
							end
							task.spawn(function()
								if ragdoll == true then
									if not CounterCheck(echar) then
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
	
	local function DamageBox4(box,HitName,HitTime,pchar,dmg,Power,PT,ST,combo,breakAmount,Up,High,ragdoll,ragTime)
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
							if CheckDown(echar) then
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
										if ehum.Health < 10 then
											task.spawn(function()
												DamageModule:Spec(pchar,echar,0,Power,PT,ST,combo,breakAmount,Up,High)
											end)
										else
											task.spawn(function()
												DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
											end)
										end
									else
										task.spawn(function()
											DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
										end)
									end
								else
									if ehum.Health < 10 then
										task.spawn(function()
											DamageModule:Spec(pchar,echar,0,Power,PT,ST,combo,breakAmount,Up,High)
										end)
									else
										task.spawn(function()
											DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
										end)
									end
								end
								task.spawn(function()
									if ragdoll == true then
										if not CounterCheck(echar) then
											RagDoll(echar,ragTime)
										end
									end
								end)
							end
						end
					end
				end
			end
		end)
	end
	
	local function DamageBox5(box,HitName,HitTime,pchar,dmg,Power,PT,ST,combo,breakAmount,Up,High,ragdoll,ragTime)
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
							if CheckDown(echar) then
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
											if CounterCheck(echar) then
												task.spawn(function()
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
													DamageModule:Spec(pchar,echar,15,200,0.25,ST,5,breakAmount,true,100)
													local Trail = rep.VFX.BasicAttack.WhiteTrail:Clone()
													Trail.Parent = visuals
													Trail.CFrame = ehrp.CFrame
													local weld = Instance.new("Weld",Trail)
													weld.Part0 = ehrp
													weld.Part1 = Trail
													Trail.Trail.Enabled = true
												end)
											else
												task.spawn(function()
													DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
												end)
											end
										else
											task.spawn(function()
												DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
											end)
											task.spawn(function()
												if ragdoll == true then
													if CounterCheck(echar) then
														RagDoll(echar,ragTime)
													end
												end
											end)
										end
									else
										task.spawn(function()
											DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
										end)
									end
								else
									if ehum.Health <= dmg then
										if CounterCheck(echar) then
											task.spawn(function()
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
												DamageModule:Spec(pchar,echar,15,200,0.25,ST,5,breakAmount,true,100)
												local Trail = rep.VFX.BasicAttack.WhiteTrail:Clone()
												Trail.Parent = visuals
												Trail.CFrame = ehrp.CFrame
												local weld = Instance.new("Weld",Trail)
												weld.Part0 = ehrp
												weld.Part1 = Trail
												Trail.Trail.Enabled = true
											end)
										else
											task.spawn(function()
												DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
											end)
										end
									else
										task.spawn(function()
											DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High)
										end)
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
					end
				end
			end
		end)
	end
	
	local function DamageBox6(box,HitName,HitTime,pchar,dmg,Power,PT,ST,combo,breakAmount,Up,High,ragdoll,ragTime)
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
							local Hitting = true
							if not CounterCheck(echar) then
								task.spawn(function()
									DamageModule:Spec2(pchar,echar,10,70,0.25,1,5,breakAmount,true,20,true)
								end)
							else
								if echar:FindFirstChild("Block") then
									local lookVector = echar.HumanoidRootPart.CFrame.LookVector
									local Position = hrp.Position - echar.HumanoidRootPart.Position
									if (lookVector:Dot(Position)) < 0 then
										echar:FindFirstChild("Block"):Destroy()
										local cant = rep.VFX.BasicAttack.CantDie:Clone()
										cant.Parent = echar
										local Slash = rep.VFX.Characters.Goku.HitPart:Clone()
										Slash.Parent = visuals
										Slash.CFrame = hrp.CFrame
										local weld = Instance.new("Weld",Slash)
										weld.Part0 = Slash
										weld.Part1 = ehrp
										task.spawn(function()
											while Hitting do
												Slash.Attachment.Hits:Emit(2)
												task.wait(0.1)
											end
										end)
										task.spawn(function()
											task.wait(2)
											Hitting = false
											game.Debris:AddItem(Slash,0.5)
											task.wait(0.5)
											if ehum.Health <= 8 then
												task.spawn(function()
													DamageModule:Spec(pchar,echar,15,70,0.25,1,5,breakAmount,true,20,true)
												end)
											else
												task.spawn(function()
													DamageModule:Spec2(pchar,echar,10,70,0.25,1,5,breakAmount,true,20,true)
												end)
											end
											cant:Destroy()
										end)
										task.spawn(function()
											while Hitting do
												if ehum.Health <= dmg then
													task.spawn(function()
														DamageModule:Spec2(pchar,echar,0,Power,PT,ST,math.random(1,2),breakAmount,Up,High)
													end)
												else
													task.spawn(function()
														DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,math.random(1,2),breakAmount,Up,High)
													end)
												end
												task.wait(0.1)
											end
										end)
									else
										task.spawn(function()
											DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,math.random(1,2),breakAmount,Up,High)
										end)
									end
								else
									local cant = rep.VFX.BasicAttack.CantDie:Clone()
									cant.Parent = echar
									local Slash = rep.VFX.Characters.Goku.HitPart:Clone()
									Slash.Parent = visuals
									Slash.CFrame = hrp.CFrame
									local weld = Instance.new("Weld",Slash)
									weld.Part0 = Slash
									weld.Part1 = ehrp
									task.spawn(function()
										while Hitting do
											Slash.Attachment.Hits:Emit(2)
											task.wait(0.1)
										end
									end)
									task.spawn(function()
										task.wait(2)
										Hitting = false
										game.Debris:AddItem(Slash,0.5)
										task.wait(0.5)
										if ehum.Health <= 8 then
											task.spawn(function()
												DamageModule:Spec(pchar,echar,15,70,0.25,1,5,breakAmount,true,20,true)
											end)
										else
											task.spawn(function()
												DamageModule:Spec2(pchar,echar,10,70,0.25,1,5,breakAmount,true,20,true)
											end)
										end
										cant:Destroy()
									end)
									task.spawn(function()
										while Hitting do
											if ehum.Health <= dmg then
												task.spawn(function()
													DamageModule:Spec2(pchar,echar,0,Power,PT,ST,math.random(1,2),breakAmount,Up,High)
												end)
											else
												task.spawn(function()
													DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,math.random(1,2),breakAmount,Up,High)
												end)
											end
											task.wait(0.1)
										end
									end)
								end
							end
							task.spawn(function()
								if ragdoll == true then
									if not CounterCheck(echar) then
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
	local function DamageBox7(box,HitName,HitTime,pchar,dmg,Power,PT,ST,combo,breakAmount,Up,High,ragdoll,ragTime)
		local RS = game:GetService("ReplicatedStorage")
		local Blood = require(RS:WaitForChild("Blood"))
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
							local Hitting = true
							if not CounterCheck(echar) then
								task.spawn(function()
									DamageModule:Spec2(pchar,echar,10,70,0.25,1,5,breakAmount,true,20,true)
								end)
							else
								if echar:FindFirstChild("Block") then
									local lookVector = echar.HumanoidRootPart.CFrame.LookVector
									local Position = hrp.Position - echar.HumanoidRootPart.Position
									if (lookVector:Dot(Position)) < 0 then
										echar:FindFirstChild("Block"):Destroy()
										local cant = rep.VFX.BasicAttack.CantDie:Clone()
										cant.Parent = echar
										local Slash = rep.VFX.Characters.Goku.HitPart:Clone()
										Slash.Parent = visuals
										Slash.CFrame = hrp.CFrame
										local weld = Instance.new("Weld",Slash)
										weld.Part0 = Slash
										weld.Part1 = ehrp
										task.spawn(function()
											while Hitting do
												Slash.Attachment.Hits:Emit(2)
												task.wait(0.1)
											end
										end)
										task.spawn(function()
											task.wait(2)
											Hitting = false
											game.Debris:AddItem(Slash,0.5)
											task.wait(0.5)
											if ehum.Health <= 8 then
												task.spawn(function()
													DamageModule:Spec(pchar,echar,15,70,0.25,1,5,breakAmount,true,20,true)
													local bloodPosition = ehrp.Position --+ Vector3.new(math.random(-10, 10), 20, math.random(-10, 10))
													local bloodVelocity = Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10))

													Blood.spawnDroplet(bloodPosition, bloodVelocity)
												end)
											else
												task.spawn(function()
													DamageModule:Spec2(pchar,echar,10,70,0.25,1,5,breakAmount,true,20,true)
												end)
											end
											cant:Destroy()
										end)
										task.spawn(function()
											while Hitting do
												if ehum.Health <= dmg then
													task.spawn(function()
														DamageModule:Spec2(pchar,echar,0,Power,PT,ST,math.random(1,2),breakAmount,Up,High)
													end)
												else
													task.spawn(function()
														DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,math.random(1,2),breakAmount,Up,High)
													end)
												end
												task.wait(0.1)
											end
										end)
									else
										task.spawn(function()
											DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,math.random(1,2),breakAmount,Up,High)
										end)
									end
								else
									local cant = rep.VFX.BasicAttack.CantDie:Clone()
									cant.Parent = echar
									local Slash = rep.VFX.Characters.Goku.HitPart:Clone()
									Slash.Parent = visuals
									Slash.CFrame = hrp.CFrame
									local weld = Instance.new("Weld",Slash)
									weld.Part0 = Slash
									weld.Part1 = ehrp
									task.spawn(function()
										while Hitting do
											task.wait(0.1)
										end
									end)
									task.spawn(function()
										task.wait(2)
										Hitting = false
										game.Debris:AddItem(Slash,0.5)
										task.wait(0.5)
										if ehum.Health <= 8 then
											task.spawn(function()
												DamageModule:Spec(pchar,echar,15,70,0.25,1,5,breakAmount,true,20,true)
											end)
										else
											task.spawn(function()
												DamageModule:Spec2(pchar,echar,10,70,0.25,1,5,breakAmount,true,20,true)
											end)
										end
										cant:Destroy()
									end)
									task.spawn(function()
										while Hitting do
											if ehum.Health <= dmg then
												task.spawn(function()
													DamageModule:Spec2(pchar,echar,0,Power,PT,ST,math.random(1,2),breakAmount,Up,High)
												end)
											else
												task.spawn(function()
													DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,math.random(1,2),breakAmount,Up,High)
												end)
											end
											task.wait(0.1)
										end
									end)
								end
							end
							task.spawn(function()
								if ragdoll == true then
									if not CounterCheck(echar) then
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
	if wut == "KiBarrage" then
		local tracks = hum:LoadAnimation(rep.Anims.Goku.KiBarrage)
		tracks:Play(0.1,1,1.3)
		local CF = 1.5
		for i = 1,6 do
			if not char:FindFirstChild("Stun") then
				local Hited = false
				local Blast = rep.VFX.Characters.Goku.KiBlast:Clone()
				Blast.Parent = visuals
				Blast.CFrame = hrp.CFrame * CFrame.new(CF,0.5,-3)
				local bv = Instance.new("BodyVelocity",Blast)
				bv.P = 123456789
				bv.MaxForce = Vector3.new(1,1,1) * 10000000
				bv.Velocity = hrp.CFrame.LookVector * 100
				Blast.KiBlast.Sound:Play()
				task.spawn(function()
					local wave = rep.VFX.Characters.Goku.Wave:Clone()
					wave.Parent = visuals
					wave.CFrame = hrp.CFrame * CFrame.new(CF,0.5,-2) * CFrame.Angles(math.rad(-90),0,0)
					ts:Create(wave,TweenInfo.new(0.25,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 1,Size = Vector3.new(5,0.5,5)}):Play()
					task.wait(0.35)
					wave:Destroy()
				end)

				task.spawn(function()
					task.wait(1)
					if Hited == false then
						Blast:Destroy()
						local Explosion = rep.VFX.Characters.Goku.Explosion:Clone()
						Explosion.Parent = visuals
						Explosion.CFrame = Blast.CFrame
						local ExplosionBox = rep.VFX.Characters.Goku.Explosion:Clone()
						ExplosionBox.Parent = visuals
						ExplosionBox.CFrame = Blast.CFrame
						ExplosionBox.Size = Vector3.new(15,15,15)
						ExplosionBox.Transparency = 1
						DamageBox2(ExplosionBox,"KiBlast",0.05,char,1.5,4,0.1,0.75,nil,nil,false,nil,false,nil)
						ts:Create(Explosion,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(15,15,15),Transparency = 1}):Play()
						task.spawn(function()
							task.wait(0.3)
							Explosion:Destroy()
							game.Debris:AddItem(ExplosionBox,0.5)
						end)
					end
				end)
				Blast.Touched:Connect(function(hit)
					if hit.Parent ~= char then
						Hited = true
						Blast:Destroy()
						local Explosion = rep.VFX.Characters.Goku.Explosion:Clone()
						Explosion.Parent = visuals
						Explosion.CFrame = Blast.CFrame
						local ExplosionBox = rep.VFX.Characters.Goku.Explosion:Clone()
						ExplosionBox.Parent = visuals
						ExplosionBox.CFrame = Blast.CFrame
						ExplosionBox.Size = Vector3.new(15,15,15)
						ExplosionBox.Transparency = 1
						DamageBox2(ExplosionBox,"KiBlast",0.05,char,1.5,4,0.1,0.75,nil,nil,false,nil,false,nil)
						ts:Create(Explosion,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(15,15,15),Transparency = 1}):Play()
						task.spawn(function()
							task.wait(0.3)
							Explosion:Destroy()
							game.Debris:AddItem(ExplosionBox,0.5)
						end)
					end
				end)
			end
			CF = -CF
			task.wait(0.15)
		end
		remote:FireClient(plr,"Done1")
	end
	if wut == "KiR" then
		hrp.CFrame = CFrame.lookAt(hrp.Position,MousePos)
		local Hited = false
		local Blast = rep.VFX.Characters.Goku.KiBlast:Clone()
		Blast.Parent = visuals
		Blast.CFrame = hrp.CFrame * CFrame.new(1.5,0.5,-3)
		Blast.KiBlast.Sound:Play()
		task.spawn(function()
			local wave = rep.VFX.Characters.Goku.Wave:Clone()
			wave.Parent = visuals
			wave.CFrame = hrp.CFrame * CFrame.new(1.5,0.5,-3) * CFrame.Angles(math.rad(-90),0,0)
			ts:Create(wave,TweenInfo.new(0.25,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 1,Size = Vector3.new(5,0.5,5)}):Play()
			task.wait(0.35)
			wave:Destroy()
		end)
		local bv = Instance.new("BodyVelocity",Blast)
		bv.P = 123456789
		bv.MaxForce = Vector3.new(1,1,1) * 10000000
		bv.Velocity = hrp.CFrame.LookVector * 0
		local P0 = Blast.Position
		local CF1 = Blast.CFrame * CFrame.new(math.random(2,12),math.random(-5,5),0)
		local P1 = CF1.Position
		local P2 = nil
		if (hrp.Position - MousePos).Magnitude < 50 then
			P2 = MousePos
		else
			local part = Instance.new("Part",visuals)
			part.Anchored = true
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.Transparency = 1
			part.CFrame = hrp.CFrame
			part.CFrame = CFrame.lookAt(part.Position,MousePos)
			game.Debris:AddItem(part,0.2)
			local TCF = part.CFrame * CFrame.new(0,0,-50)
			P2 = TCF.Position
		end
		Blast.Touched:Connect(function(hit)
			if hit.Parent ~= char then
				Hited = true
				Blast:Destroy()
				local Explosion = rep.VFX.Characters.Goku.Explosion:Clone()
				Explosion.Parent = visuals
				Explosion.CFrame = Blast.CFrame
				local ExplosionBox = rep.VFX.Characters.Goku.Explosion:Clone()
				ExplosionBox.Parent = visuals
				ExplosionBox.CFrame = Blast.CFrame
				ExplosionBox.Size = Vector3.new(15,15,15)
				ExplosionBox.Transparency = 1
				DamageBox2(ExplosionBox,"KiBlast",0.05,char,1.5,4,0.1,0.75,nil,nil,false,nil,false,nil)
				ts:Create(Explosion,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(15,15,15),Transparency = 1}):Play()
				task.spawn(function()
					task.wait(0.3)
					Explosion:Destroy()
					game.Debris:AddItem(ExplosionBox,0.5)
				end)
			end
		end)
		task.spawn(function()
			for i = 1,20 do
				if Hited == false then
					local t = i/20
					local PosR = quadraticBezier(t,P0,P1,P2)
					local DirR = quadraticBezier(t + 0.005,P0,P1,P2)
					Blast.CFrame = CFrame.new(PosR,DirR)
					task.wait()
				end
			end
			task.spawn(function()
				if Hited == false then
					Blast:Destroy()
					local Explosion = rep.VFX.Characters.Goku.Explosion:Clone()
					Explosion.Parent = visuals
					Explosion.CFrame = Blast.CFrame
					local ExplosionBox = rep.VFX.Characters.Goku.Explosion:Clone()
					ExplosionBox.Parent = visuals
					ExplosionBox.CFrame = Blast.CFrame
					ExplosionBox.Size = Vector3.new(15,15,15)
					ExplosionBox.Transparency = 1
					DamageBox2(ExplosionBox,"KiBlast",0.05,char,1.5,4,0.1,0.75,nil,nil,false,nil,false,nil)
					ts:Create(Explosion,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(15,15,15),Transparency = 1}):Play()
					task.spawn(function()
						task.wait(0.3)
						Explosion:Destroy()
						game.Debris:AddItem(ExplosionBox,0.5)
					end)
				end
			end)
		end)
	end
	if wut == "KiL" then
		hrp.CFrame = CFrame.lookAt(hrp.Position,MousePos)
		local Hited = false
		local Blast = rep.VFX.Characters.Goku.KiBlast:Clone()
		Blast.Parent = visuals
		Blast.CFrame = hrp.CFrame * CFrame.new(-1.5,0.5,-3)
		Blast.KiBlast.Sound:Play()
		task.spawn(function()
			local wave = rep.VFX.Characters.Goku.Wave:Clone()
			wave.Parent = visuals
			wave.CFrame = hrp.CFrame * CFrame.new(-1.5,0.5,-3) * CFrame.Angles(math.rad(-90),0,0)
			ts:Create(wave,TweenInfo.new(0.25,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 1,Size = Vector3.new(5,0.5,5)}):Play()
			task.wait(0.35)
			wave:Destroy()
		end)
		local bv = Instance.new("BodyVelocity",Blast)
		bv.P = 123456789000000
		bv.MaxForce = Vector3.new(1,1,1) * 1000000000000
		bv.Velocity = hrp.CFrame.LookVector * 0
		local P0 = Blast.Position
		local CF1 = Blast.CFrame * CFrame.new(math.random(-12,-2),math.random(-5,5),0)
		local P1 = CF1.Position
		local P2 = nil
		if (hrp.Position - MousePos).Magnitude < 50 then
			P2 = MousePos
		else
			local part = Instance.new("Part",visuals)
			part.Anchored = true
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.Transparency = 1
			part.CFrame = hrp.CFrame
			part.CFrame = CFrame.lookAt(part.Position,MousePos)
			game.Debris:AddItem(part,0.2)
			local TCF = part.CFrame * CFrame.new(0,0,-50)
			P2 = TCF.Position
		end
		Blast.Touched:Connect(function(hit)
			if hit.Parent ~= char and hit.Parent == visuals then
				Hited = true
				Blast:Destroy()
				local Explosion = rep.VFX.Characters.Goku.Explosion:Clone()
				Explosion.Parent = visuals
				Explosion.CFrame = Blast.CFrame
				local ExplosionBox = rep.VFX.Characters.Goku.Explosion:Clone()
				ExplosionBox.Parent = visuals
				ExplosionBox.CFrame = Blast.CFrame
				ExplosionBox.Size = Vector3.new(15,15,15)
				ExplosionBox.Transparency = 1
				DamageBox2(ExplosionBox,"KiBlast",0.05,char,1.5,4,0.1,0.75,nil,nil,false,nil,false,nil)
				ts:Create(Explosion,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(15,15,15),Transparency = 1}):Play()
				task.spawn(function()
					task.wait(0.3)
					Explosion:Destroy()
					game.Debris:AddItem(ExplosionBox,0.5)
				end)
			end
		end)
		task.spawn(function()
			for i = 1,20 do
				if Hited == false then
					local t = i/20
					local PosR = quadraticBezier(t,P0,P1,P2)
					local DirR = quadraticBezier(t + 0.005,P0,P1,P2)
					Blast.CFrame = CFrame.new(PosR,DirR)
					task.wait()
				end
			end
			task.spawn(function()
				if Hited == false then
					Blast:Destroy()
					local Explosion = rep.VFX.Characters.Goku.Explosion:Clone()
					Explosion.Parent = visuals
					Explosion.CFrame = Blast.CFrame
					local ExplosionBox = rep.VFX.Characters.Goku.Explosion:Clone()
					ExplosionBox.Parent = visuals
					ExplosionBox.CFrame = Blast.CFrame
					ExplosionBox.Size = Vector3.new(15,15,15)
					ExplosionBox.Transparency = 1
					DamageBox2(ExplosionBox,"KiBlast",0.05,char,1.5,4,0.1,0.75,nil,nil,false,nil,false,nil)
					ts:Create(Explosion,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(15,15,15),Transparency = 1}):Play()
					task.spawn(function()
						task.wait(0.3)
						Explosion:Destroy()
						game.Debris:AddItem(ExplosionBox,0.5)
					end)
				end
			end)
		end)
	end
	if wut =="Kamehameha" then
		local tracks = hum:LoadAnimation(rep.Anims.Goku.Kame)
		tracks:Play()
		local sound1 = rep.Sounds.Goku.GokuKamehameha:Clone()
		sound1.Parent = hrp
		sound1:Play()
		local sound2 = rep.Sounds.Goku.Charge:Clone()
		sound2.Parent = hrp
		sound2:Play()
		local EnergyBall = rep.VFX.Characters.Goku.KameBall:Clone(wait(1))
		EnergyBall.Parent = visuals
		EnergyBall.CFrame = char:FindFirstChild("Right Arm").CFrame
		local weld = Instance.new("Weld",EnergyBall)
		weld.Part0 = EnergyBall
		weld.Part1 = char:FindFirstChild("Right Arm")
		weld.C0 = CFrame.new(0,1.5,0)
		local effectGo = true
		task.spawn(function()
			while effectGo do
				for i,v in pairs(EnergyBall:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							v:Emit(1)
						end)
					end
				end
				task.wait(0.5)
			end
		end)
		task.wait(1.3)
		if not char:FindFirstChild("Stun") then
			local StillKame = true
			sound1:Destroy()
			effectGo = false
			EnergyBall:Destroy()
			hum.AutoRotate = false
			local effect = true
			local hitting = true
			local Kame1 = rep.VFX.Characters.Goku.Kame1:Clone()
			Kame1.Parent = visuals
			Kame1.CFrame = hrp.CFrame * CFrame.new(0,0,-3)
			local Kame2 = rep.VFX.Characters.Goku.Kame2:Clone()
			Kame2.Parent = visuals
			Kame2.CFrame = Kame1.CFrame
			Kame1.Beam2.Attachment0 = Kame1.Attachment
			Kame1.Beam3.Attachment0 = Kame1.Attachment
			Kame1.Beam2.Attachment1 = Kame2.Attachment
			Kame1.Beam3.Attachment1 = Kame2.Attachment
			Kame1.Beam2.Enabled = true
			Kame1.Beam3.Enabled = true
			local KameBox = rep.VFX.Boxes.KameBox:Clone()
			KameBox.Parent = visuals
			KameBox.CFrame = Kame1.CFrame
			KameBox.Transparency = 1
			local sound2 = rep.Sounds.Goku.KameFire:Clone()
			sound2.Parent = hrp
			sound2:Play()
			local sound3 = rep.Sounds.Goku.GokuScream2:Clone()
			sound3.Parent = hrp
			sound3:Play()
			ts:Create(KameBox,TweenInfo.new(0.35,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{CFrame = hrp.CFrame * CFrame.new(0,0,-26),Size = Vector3.new(6,6,52)}):Play()
			ts:Create(Kame2,TweenInfo.new(0.35,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{CFrame = hrp.CFrame * CFrame.new(0,0,-50)}):Play()
			task.spawn(function()
				RockModule.Front(hrp,5,3,40,false,nil,0.05,1,5,0)
			end)
			task.spawn(function()
				while hitting do
					DamageBox3(KameBox,"KameHa",0.1,char,0.5,10,0.1,0.7,math.random(1,2),nil,false,nil,false,nil)
					task.wait()
				end
			end)
			task.spawn(function()
				while effect do
					Kame1.Attachment2.Wave:Emit(1)
					Kame1.Attachment2.Wave2:Emit(1)
					task.wait(0.1)
				end
			end)
			task.spawn(function()
				while effect do
					Kame1.Attachment.Ball:Emit(1)
					Kame1.Attachment.Ball2:Emit(1)
					Kame2.Attachment.Ball:Emit(1)
					Kame2.Attachment.Ball2:Emit(1)
					task.wait(0.2)
				end
			end)
			task.spawn(function()
				while effect do
					Kame1.Attachment.Dots:Emit(1)
					Kame2.Attachment.Dots:Emit(1)
					task.wait()
				end
			end)
			task.spawn(function()
				while StillKame do
					if char:FindFirstChild("Stun") then
						StillKame = false
						sound2:Destroy()
						sound3:Destroy()
						effect = false
						hitting = false
						KameBox:Destroy()
						Kame1:Destroy()
						Kame2:Destroy()
						hum.AutoRotate = true
						remote:FireClient(plr,"Done2")
					end
					task.wait()
				end
			end)
			task.wait(3)
			if StillKame then
				StillKame = false
				sound2:Destroy()
				sound3:Destroy()
				effect = false
				hitting = false
				KameBox:Destroy()
				Kame1:Destroy()
				Kame2:Destroy()
				hum.AutoRotate = true
				remote:FireClient(plr,"Done2")
			end
		else
			tracks:Stop()
			sound1:Destroy()
			effectGo = false
			EnergyBall:Destroy()
			remote:FireClient(plr,"Done2")
		end
	end
	if wut == "DragonCombo" then
		hum:LoadAnimation(rep.Anims.Goku.DraKick):Play()
		task.wait(0.4)
		if not char:FindFirstChild("Stun") then
			local Kicked = false
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
				local HitName = "DraKicked"
				local HitTime = 0.1
				task.spawn(function()
					for i,hit in pairs(workspace:GetPartsInPart(box,params)) do
						local echar = hit.Parent
						if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
							if echar ~= char and not echar:FindFirstChild("HyperArmor") and not echar:FindFirstChild("StrongArmor")  then
								if not echar:FindFirstChild(HitName) and Kicked == false then
									local GetHit = Instance.new("IntValue")
									GetHit.Parent = echar
									GetHit.Name = HitName
									game.Debris:AddItem(GetHit,HitTime)
									Kicked = true
									local ehum = echar:FindFirstChild("Humanoid")
									local ehrp = echar:FindFirstChild("HumanoidRootPart")
									local function Beating()
										if not CounterCheck(echar) then
											task.spawn(function()
												DamageModule:Spec(char,echar,5,1,0.05,2,5,nil,false,nil,false)
											end)
											remote:FireClient(plr,"Done3")
										else
											for i,v in pairs(char:GetChildren()) do
												if v.Name == "Ragdolling" then
													v:Destroy()
												end
											end
											task.spawn(function()
												DamageModule:Spec(char,echar,5,1,0.05,2,math.random(1,4),nil,false,nil,false)
											end)
											ehum.AutoRotate = false
											ehrp.Anchored = true
											ehrp.CFrame = hrp.CFrame * CFrame.new(0,0,-3)
											ts:Create(ehrp,TweenInfo.new(0.3,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = ehrp.CFrame * CFrame.new(0,30,0)}):Play()
											task.wait(0.5)
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
											game.Debris:AddItem(tpPart,0.5)
											task.wait()
											hum.AutoRotate = false
											hrp.Anchored = true
											hrp.CFrame = ehrp.CFrame * CFrame.new(0,1,4)
											hum:LoadAnimation(rep.Anims.Goku.DraSlam):Play()
											task.wait(0.4)
											task.spawn(function()
												DamageModule:Spec(char,echar,5,1,0.05,2,5,nil,false,nil,false)
											end)
											local rayParams = RaycastParams.new()
											rayParams.FilterType = Enum.RaycastFilterType.Include
											rayParams.FilterDescendantsInstances = {workspace.Map}
											local result = workspace:Raycast(ehrp.Position,Vector3.new(0,-500,0),rayParams)
											if result then
												ts:Create(ehrp,TweenInfo.new(0.35,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = ehrp.CFrame * CFrame.new(0,-(result.Distance)+5,0)}):Play()
												task.spawn(function()
													task.wait(0.35)
													local smokeparticle = game.ServerStorage.Smoke:Clone()
													
													hum.AutoRotate = true
													hrp.Anchored = false
													ehum.AutoRotate = true
													ehrp.Anchored = false
													local sound2 = rep.Sounds.BasicAttack.Slam:Clone()
													sound2.Parent = ehrp
													sound2:Play()
													game.Debris:AddItem(sound2,sound2.TimeLength)
													task.spawn(function()
														DamageModule:Spec(char,echar,3,0,0.05,2.5,math.random(1,4),nil,false,nil,false)
													end)
													task.spawn(function()
														RagDoll(echar,2.5)
													end)
													task.spawn(function()
														RockModule.Ground(ehrp.Position,20,Vector3.new(3,3,3),{visuals,echar,char},10,false,6,0.4)
														smokeparticle.Parent = ehrp
														smokeparticle:Emit(56)
														game:GetService("Debris"):AddItem(smokeparticle,1)
													end)
													remote:FireClient(plr,"Done3")
												end)
											else
												hum.AutoRotate = true
												hrp.Anchored = false
												ehum.AutoRotate = true
												ehrp.Anchored = false
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
			task.wait(0.2)
			if Kicked == false then
				remote:FireClient(plr,"Done3")
			end
		else
			remote:FireClient(plr,"Done3")
		end
	end
	if wut == "FrenzyKicks" then
		local tracks = hum:LoadAnimation(rep.Anims.Goku.FrenzyKick)
		tracks:Play(0.1,1,1.5)
		local Kicking = true
		char:FindFirstChild("Right Leg").Transparency = 1
		local box = rep.VFX.Boxes.FrenzyBox:Clone()
		box.Parent = visuals
		box.CFrame = hrp.CFrame * CFrame.new(0,0,4.5)
		box.Transparency = 1
		local w1 = Instance.new("Weld",box)
		w1.Part0 = box
		w1.Part1 = hrp
		w1.C0 = CFrame.new(0,0,4.5)
		task.spawn(function()
			while Kicking do
				DamageBox4(box,"Kicked",0.125,char,0.3,2,0.1,0.65,math.random(1,2),nil,false,nil,false,nil)
				task.wait()
			end
		end)
		task.spawn(function()
			while Kicking do
				task.spawn(function()
					local leg = char:FindFirstChild("Right Leg"):Clone()
					local newcf = hrp.CFrame * CFrame.new(math.random(-3,3),math.random(-3,3),math.random(-15,-5))
					leg.CFrame = leg.CFrame * CFrame.new(0,1,0)
					leg.CFrame = CFrame.lookAt(leg.Position,newcf.Position)
					leg.CFrame = leg.CFrame * CFrame.Angles(math.rad(90),0,0)
					leg.Parent = visuals
					leg.Anchored = true
					leg.Transparency = 0
					ts:Create(leg,TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 1, CFrame = leg.CFrame * CFrame.new(0,-8,0)}):Play()
					task.spawn(function()
						local wave = rep.VFX.Characters.Goku.Wave:Clone()
						wave.Parent = visuals
						wave.CFrame = leg.CFrame * CFrame.Angles(math.rad(-180),0,0)
						ts:Create(wave,TweenInfo.new(0.3,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 1, Size = Vector3.new(2,0.3,2)}):Play()
						task.wait(0.3)
						wave:Destroy()
					end)
					task.spawn(function()
						wait(0.2)
						local wave = rep.VFX.Characters.Goku.Wave:Clone()
						wave.Parent = visuals
						wave.CFrame = leg.CFrame * CFrame.new(0,-0.25,0) * CFrame.Angles(math.rad(-180),0,0)
						ts:Create(wave,TweenInfo.new(0.3,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 1, Size = Vector3.new(4,0.3,4)}):Play()
						task.wait(0.3)
						wave:Destroy()
					end)
					task.wait(0.2)
					leg:Destroy()
				end)
				task.wait(0.025)
			end
		end)
		task.spawn(function()
			while Kicking do
				if char:FindFirstChild("Stun") then
					Kicking = false
					tracks:Stop()
					char:FindFirstChild("Right Leg").Transparency = 0
					box:Destroy()
					remote:FireClient(plr,"Done4")
				end
				task.wait()
			end
		end)
		task.spawn(function()
			while Kicking do
				local sound = rep.Sounds.Goku.Frenzy:Clone()
				sound.Parent = hrp
				sound:Play()
				game.Debris:AddItem(sound,sound.TimeLength)
				task.wait(0.085)
			end
		end)
		task.spawn(function()
			task.wait(2)
			if Kicking == true then
				Kicking = false
				tracks:Stop()
				box:Destroy()
				char:FindFirstChild("Right Leg").Transparency = 0
				hum:LoadAnimation(rep.Anims.Goku.LastKick):Play()
				task.wait(0.45)
				local box2 = rep.VFX.Boxes.NormalPunch:Clone()
				box2.Parent = visuals
				box2.CFrame = hrp.CFrame * CFrame.new(0,0,2.5)
				box2.Transparency = 1
				local w2 = Instance.new("Weld",box2)
				w2.Part0 = box2
				w2.Part1 = hrp
				w2.C0 = CFrame.new(0,0,2.5)
				game.Debris:AddItem(box2,0.2)
				local sound = rep.Sounds.BasicAttack.PunchSwing:Clone()
				sound.Parent = hrp
				sound:Play()
				game.Debris:AddItem(sound,1)
				task.spawn(function()
					DamageBox5(box,"LastKick",0.1,char,8.5,45,0.3,2,5,nil,true,25,true,2)
				end)
				remote:FireClient(plr,"Done4")
			end
		end)
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
		hum:LoadAnimation(rep.Anims.Goku.Awaken):Play()
		local HeadRoku = rep.VFX.Characters.Denji.Helmet:Clone()
		
		local sound = rep.Sounds.Goku.Awakening:Clone()
		sound.Parent = hrp
		sound:Play()
		game.Debris:AddItem(sound,sound.TimeLength)
		task.spawn(function()
			local CF = 35
			for i = 1,2 do
				task.spawn(function()
					
					local WhiteBall = rep.VFX.Characters.Goku.UBall:Clone()
					WhiteBall.Parent = visuals
					WhiteBall.CFrame = hrp.CFrame * CFrame.new(CF,2,0)
					ts:Create(WhiteBall,TweenInfo.new(0.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 0}):Play()
					task.wait(2.5)
					ts:Create(WhiteBall,TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 1}):Play()
					task.wait(2.5)
					ts:Create(WhiteBall,TweenInfo.new(0.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 0}):Play()
					task.wait(2.5)
					ts:Create(WhiteBall,TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Transparency = 1,Size = Vector3.new(15,15,15)}):Play()
					task.wait(3.3)
					WhiteBall:Destroy()
				end)
				task.spawn(function()
					local WhiteBall = rep.VFX.Characters.Goku.UBall:Clone()
					WhiteBall.Parent = visuals
					WhiteBall.CFrame = hrp.CFrame * CFrame.new(0,2,CF)
					ts:Create(WhiteBall,TweenInfo.new(0.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 0}):Play()
					task.wait(2.5)
					ts:Create(WhiteBall,TweenInfo.new(0.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 1}):Play()
					task.wait(2.5)
					ts:Create(WhiteBall,TweenInfo.new(0.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 0}):Play()
					task.wait(2.5)
					ts:Create(WhiteBall,TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Transparency = 1,Size = Vector3.new(15,15,15)}):Play()
					task.wait(3.3)
					WhiteBall:Destroy()
					sound:Destroy()
				end)
				CF = -CF
			end
		end)
		task.wait(1)
		local pillar = rep.VFX.Characters.Goku.WhitePillar:Clone()
		pillar.Parent = visuals
		pillar.CFrame = hrp.CFrame * CFrame.Angles(0,0,math.rad(90))
		ts:Create(pillar,TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(500, 30, 30)}):Play()
		task.spawn(function()
			task.wait(1)
			for i = 1,4 do
				ts:Create(pillar,TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(500, 25, 25)}):Play()
				task.wait(1)
				ts:Create(pillar,TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(500, 30, 30)}):Play()
				task.wait(1)
			end
			ts:Create(pillar,TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(1000, 1, 1),Transparency = 1}):Play()
			task.wait(1)
			pillar:Destroy()
			for i, v in pairs(char:GetChildren()) do
				if v:IsA("BasePart") or v:IsA("MeshPart") then
					local modelAura = rep.VFX.Characters.Goku.Aura:Clone()
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
			local RS = game:GetService("ReplicatedStorage")
		--	local NewCutscene = RS:FindFirstChild("Cutscene")
		--	local Cutscenes = RS:FindFirstChild("Cutscenes")
			--local CutsceneFolder = Cutscenes:FindFirstChild("GokuAwaken")
		--	NewCutscene:FireClient(plr, hrp, CutsceneFolder)
			task.wait(5)
			local theme = rep.Sounds.Goku.Theme:Clone()
			theme.Parent = hrp
			theme:Play()
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
					SkillGui.Skill1.Visible = true
					SkillGui.Skill2.Visible = true
					SkillGui.Skill3.Visible = true
					SkillGui.Skill4.Visible = true
					SkillGui.Skill5.Visible = false
					SkillGui.Skill6.Visible = false
					SkillGui.Skill7.Visible = false
					SkillGui.Skill8.Visible = false
					theme:Destroy()
				end
			end)
			cant:Destroy()
			remote:FireClient(plr,"DoneAwa")
		end)
		
	end
	if wut == "QuickCombo" then
		local RS = game:GetService("ReplicatedStorage")
		local Blood = require(RS:WaitForChild("Blood"))
		local CheckChar = {workspace.Debris}
		for i,plr in pairs(game:GetService("Players"):GetPlayers()) do
			if plr.Character then
				table.insert(CheckChar,plr.Character)
			end
		end
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = CheckChar
		local NewCF = hrp.CFrame * CFrame.new(0,0,-40)
		local Result = workspace:Raycast(hrp.Position,NewCF.Position - hrp.Position,params)
		local function FarDash()
			hum.AutoRotate = false
			local Cant = Instance.new("IntValue",char)
			Cant.Name = "StrongArmor"
			hum:LoadAnimation(rep.Anims.Goku.FastAttack):Play()
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
			KameBox.CFrame = hrp.CFrame * CFrame.new(0,0,-40/2)
			KameBox.Transparency = 1
			KameBox.Size = Vector3.new(10,10,40)
			task.spawn(function()
				DamageBox7(KameBox,"MulHit",0.25,char,0.75,0,0.05,0.5,math.random(1,4),nil,false,nil,false,nil)
				
			end)
			task.spawn(function()
				task.wait(0.35)
				SWR:Destroy()
				SWL:Destroy()
			end)
			local shadow = char:Clone()
			local cant = Instance.new("IntValue",shadow)
			cant.Name = "StrongArmor"
			if shadow:FindFirstChildWhichIsA("Highlight") then
				shadow:FindFirstChildWhichIsA("Highlight"):Destroy()
			end
			shadow.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			shadow.Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
			shadow.Parent = visuals
			local sound = rep.Sounds.Dash.Teleport:Clone()
			sound.Parent = hrp
			sound:Play()
			game.Debris:AddItem(sound,sound.TimeLength)
			task.spawn(function()
				for i,v in pairs(shadow:GetDescendants()) do
					if v:IsA("BasePart") or v:IsA("MeshPart") then
						v.Anchored = true
						v.CastShadow = false
						v.Material = Enum.Material.Neon
						v.CanCollide = false
						ts:Create(v,TweenInfo.new(0.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 1}):Play()
						task.spawn(function()
							wait(.5)
							v:Destroy()
						end)
					end
				end
			end)
			game.Debris:AddItem(shadow,0.5)
			local Beam = rep.VFX.Characters.Goku.BeamWave:Clone()
			Beam.Parent = visuals
			Beam.CFrame = hrp.CFrame * CFrame.Angles(0,math.rad(90),0)
			ts:Create(Beam,TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(40,5,5),CFrame = hrp.CFrame * CFrame.new(0,0,-40/2) * CFrame.Angles(0,math.rad(90),0)}):Play()
			task.spawn(function()
				task.wait(0.2)
				ts:Create(Beam,TweenInfo.new(0.35,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(40,0,0),Transparency = 1}):Play()
				task.wait(0.35)
				Beam:Destroy()
			end)
			hrp.CFrame = hrp.CFrame * CFrame.new(0,0,-40)
			task.wait(2.5)
			KameBox:Destroy()
			Cant:Destroy()
			hum.AutoRotate = true
			remote:FireClient(plr,"Done5")
		end
		local function NearDash(Distance)
			hum.AutoRotate = false
			local Cant = Instance.new("IntValue",char)
			Cant.Name = "StrongArmor"
			hum:LoadAnimation(rep.Anims.Goku.FastAttack):Play()
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
				DamageBox7(KameBox,"MulHit",0.25,char,0.75,0,0.05,0.5,math.random(1,4),nil,false,nil,false,nil)
			end)
			ts:Create(SWR,TweenInfo.new(0.35,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 1,Size = Vector3.new(15, 6, 1.895),CFrame = SWR.CFrame * CFrame.new(-5,0.5,0)}):Play()
			ts:Create(SWL,TweenInfo.new(0.35,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 1,Size = Vector3.new(15, 6, 1.895),CFrame = SWL.CFrame * CFrame.new(-5,0.5,0)}):Play()
			task.spawn(function()
				task.wait(0.35)
				SWR:Destroy()
				SWL:Destroy()
			end)
			local shadow = char:Clone()
			local cant = Instance.new("IntValue",shadow)
			cant.Name = "StrongArmor"
			if shadow:FindFirstChildWhichIsA("Highlight") then
				shadow:FindFirstChildWhichIsA("Highlight"):Destroy()
			end
			shadow.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			shadow.Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
			shadow.Parent = visuals
			local sound = rep.Sounds.Dash.Teleport:Clone()
			sound.Parent = hrp
			sound:Play()
			game.Debris:AddItem(sound,sound.TimeLength)
			task.spawn(function()
				for i,v in pairs(shadow:GetDescendants()) do
					if v:IsA("BasePart") or v:IsA("MeshPart") then
						v.Anchored = true
						v.CastShadow = false
						v.Material = Enum.Material.Neon
						v.CanCollide = false
						ts:Create(v,TweenInfo.new(0.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 1}):Play()
						task.spawn(function()
							wait(.5)
							v:Destroy()
						end)
					end
				end
			end)
			game.Debris:AddItem(shadow,0.5)
			local Beam = rep.VFX.Characters.Goku.BeamWave:Clone()
			Beam.Parent = visuals
			Beam.CFrame = hrp.CFrame * CFrame.Angles(0,math.rad(90),0)
			ts:Create(Beam,TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(Distance+2,5,5),CFrame = hrp.CFrame * CFrame.new(0,0,-Distance+1/2) * CFrame.Angles(0,math.rad(90),0)}):Play()
			task.spawn(function()
				task.wait(0.2)
				ts:Create(Beam,TweenInfo.new(0.35,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(Distance,0,0),Transparency = 1}):Play()
				task.wait(0.35)
				Beam:Destroy()
			end)
			hrp.CFrame = hrp.CFrame * CFrame.new(0,0,-Distance+2)
			task.wait(2.5)
			KameBox:Destroy()
			Cant:Destroy()
			hum.AutoRotate = true
			remote:FireClient(plr,"Done5")
		end
		if Result then
			if Result.Distance < 40 then
				NearDash(Result.Distance)
			else
				FarDash()
			end
		else
			FarDash()
		end
	end
	if wut == "SuperKamehameha" then
		local tracks = hum:LoadAnimation(rep.Anims.Goku.Kame)
		tracks:Play()
		local EnergyBall = rep.VFX.Characters.Goku.KameBall:Clone()
		EnergyBall.Parent = visuals
		EnergyBall.CFrame = char:FindFirstChild("Right Arm").CFrame
		local weld = Instance.new("Weld",EnergyBall)
		weld.Part0 = EnergyBall
		weld.Part1 = char:FindFirstChild("Right Arm")
		weld.C0 = CFrame.new(0,1.5,0)
		local sound1 = rep.Sounds.Goku.GokuKamehameha2:Clone()
		sound1.Parent = hrp
		sound1:Play()
		local effectGo = true
		local sound2 = rep.Sounds.Goku.Charge:Clone()
		sound2.Parent = hrp
		sound2:Play()
		local effectGo = true
		task.spawn(function()
			while effectGo do
				for i,v in pairs(EnergyBall:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							v:Emit(1)
						end)
					end
				end
				task.wait(0.5)
			end
		end)
		task.wait(1)
		if not char:FindFirstChild("Stun") then
			local StillKame = true
			sound1:Destroy()
			effectGo = false
			EnergyBall:Destroy()
			hum.AutoRotate = false
			local effect = true
			local hitting = true
			local Kame1 = rep.VFX.Characters.Goku.Kame3:Clone()
			Kame1.Parent = visuals
			Kame1.CFrame = hrp.CFrame * CFrame.new(0,0,-3)
			local Kame2 = rep.VFX.Characters.Goku.Kame4:Clone(wait(1.1))
			Kame2.Parent = visuals
			Kame2.CFrame = Kame1.CFrame
			Kame1.Beam2.Attachment0 = Kame1.Attachment
			Kame1.Beam3.Attachment0 = Kame1.Attachment
			Kame1.Beam2.Attachment1 = Kame2.Attachment
			Kame1.Beam3.Attachment1 = Kame2.Attachment
			Kame1.Beam2.Enabled = true
			Kame1.Beam3.Enabled = true
			local KameBox = rep.VFX.Boxes.KameBox:Clone()
			KameBox.Parent = visuals
			KameBox.CFrame = Kame1.CFrame
			KameBox.Transparency = 1
			local sound3 = rep.Sounds.Goku.KameFire:Clone()
			sound3.Parent = hrp
			sound3:Play()
			
			local sound4 = rep.Sounds.Goku.GokuScream:Clone()
			sound4.Parent = hrp
			sound4:Play()
			
			ts:Create(KameBox,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{CFrame = hrp.CFrame * CFrame.new(0,0,-156),Size = Vector3.new(10,10,312)}):Play()
			ts:Create(Kame2,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{CFrame = hrp.CFrame * CFrame.new(0,0,-300)}):Play()
			task.spawn(function()
				RockModule.Front(hrp,10,6,110,false,nil,0,1,5,0)
			end)
			task.spawn(function()
				while hitting do
					DamageBox3(KameBox,"KameHa",0.1,char,1.5,10,0.1,0.7,math.random(1,2),nil,false,nil,false,nil)
					task.wait()
				end
			end)
			task.spawn(function()
				while effect do
					Kame1.Attachment2.Wave:Emit(1)
					Kame1.Attachment2.Wave2:Emit(1)
					task.wait(0.1)
				end
			end)
			task.spawn(function()
				while effect do
					Kame1.Attachment.Ball:Emit(1)
					Kame1.Attachment.Ball2:Emit(1)
					Kame2.Attachment.Ball:Emit(1)
					Kame2.Attachment.Ball2:Emit(1)
					task.wait(0.2)
				end
			end)
			task.spawn(function()
				while effect do
					Kame1.Attachment.Dots:Emit(1)
					Kame2.Attachment.Dots:Emit(1)
					task.wait()
				end
			end)
			task.spawn(function()
				while StillKame do
					if char:FindFirstChild("Stun") then
						sound2:Destroy()
						effect = false
						hitting = false
						KameBox:Destroy()
						Kame1:Destroy()
						Kame2:Destroy()
						hum.AutoRotate = true
						remote:FireClient(plr,"Done6")
					end
					task.wait()
				end
			end)
			task.wait(3)
			if StillKame then
				StillKame = false
				sound2:Destroy()
				sound3:Destroy()
				sound4:Destroy()
				effect = false
				hitting = false
				KameBox:Destroy()
				Kame1:Destroy()
				Kame2:Destroy()
				hum.AutoRotate = true
				remote:FireClient(plr,"Done6")
			end
		else
			tracks:Stop()
			sound1:Destroy()
			sound2:Destroy()
			effectGo = false
			EnergyBall:Destroy()
			remote:FireClient(plr,"Done6")
		end
	end
	if wut == "UltraSense" then
		local PlayerDied = false
		local sound = rep.Sounds.Goku.UltraSense:Clone()
		sound.Parent = hrp
		sound:Play()
		game.Debris:AddItem(sound,sound.TimeLength)
		local UltraSense = rep.VFX.BasicAttack.UltraSense:Clone()
		UltraSense.Parent = char
		LightingRemote:FireClient(plr,"UltraSenseOpen")
		task.spawn(function()
			hum.Died:Connect(function()
				PlayerDied = true
				LightingRemote:FireClient(plr,"UltraSenseClose")
			end)
		end)
		task.wait(0.5)
		remote:FireClient(plr,"Done7")
		task.wait(7.5)
		if not PlayerDied then
			UltraSense:Destroy()
			LightingRemote:FireClient(plr,"UltraSenseClose")
		end
	end
	if wut == "GodlyCombo" then
		hum:LoadAnimation(rep.Anims.Goku.DraKick):Play()
		task.wait(0.4)
		if not char:FindFirstChild("Stun") then
			local PlayerHited = false
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
				local HitName = "Godly"
				local HitTime = 0.1
				task.spawn(function()
					for i,hit in pairs(workspace:GetPartsInPart(box,params)) do
						local echar = hit.Parent
						if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
							if echar ~= char and not echar:FindFirstChild("HyperArmor") and not echar:FindFirstChild("StrongArmor") then
								if not echar:FindFirstChild(HitName) and PlayerHited == false then
									local GetHit = Instance.new("IntValue")
									GetHit.Parent = echar
									GetHit.Name = HitName
									game.Debris:AddItem(GetHit,HitTime)
									PlayerHited = true
									local ehum = echar:FindFirstChild("Humanoid")
									local ehrp = echar:FindFirstChild("HumanoidRootPart")
									local function Beating()
										if not CounterCheck(echar) then
											task.spawn(function()
												DamageModule:Spec(char,echar,5,50,0.05,2,math.random(1,4),nil,false,nil,false,true)
											end)
											remote:FireClient(plr,"Done8")
										else
											for i,v in pairs(char:GetChildren()) do
												if v.Name == "Ragdolling" then
													v:Destroy()
												end
											end
											local Cant = Instance.new("IntValue",char)
											Cant.Name = "StrongArmor"
											local Cant2 = Instance.new("IntValue",echar)
											Cant2.Name = "StrongArmor"
											task.spawn(function()
												hum.AutoRotate = false
												hrp.Anchored = true
											end)
											task.spawn(function()
												ehum.AutoRotate = false
												ehrp.Anchored = true
											end)
											ehrp.CFrame = hrp.CFrame * CFrame.new(0,0,-3) * CFrame.Angles(0,math.rad(180),0)
											task.spawn(function()
												DamageModule:Spec(char,echar,5,50,0.05,2,math.random(1,4),nil,false,nil,false,false)
											end)
											ts:Create(ehrp,TweenInfo.new(0.75,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = ehrp.CFrame * CFrame.new(0,100,0)}):Play()
											task.wait(0.75)
											local OldECF = ehrp.CFrame
											ehrp.Anchored = true
											hum:LoadAnimation(rep.Anims.Goku.PlayerGo):Play()
											task.wait(1)
											local oldCF = hrp.CFrame
											CutsenseRemote:FireClient(plr,"GodlikeSpeed",echar)
											for _, v in pairs(char:GetDescendants()) do
												if v:IsA("BasePart") or v:IsA("MeshPart") or v:IsA("Decal") then
													if v.Name ~= "HumanoidRootPart" then
														v.Transparency = 1
													end
												end
											end
											local tpPart = rep.VFX.Dash.TeleportPart:Clone()
											tpPart.Parent = visuals
											tpPart.CFrame = hrp.CFrame
											local weld = Instance.new("Weld",tpPart)
											weld.Part0 = tpPart
											weld.Part1 = hrp
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
											game.Debris:AddItem(tpPart,0.5)
											local track2 = ehum:LoadAnimation(rep.Anims.Goku.FlyOut)
											track2:Play()
											for i = 1,25 do
												if i ~= 25 then
													local newCF = OldECF * CFrame.new(math.random(-20,20),math.random(-20,20),math.random(-20,20))
													local newPos = newCF.Position
													ehrp.CFrame = CFrame.lookAt(ehrp.Position,newPos)
													ts:Create(ehrp,TweenInfo.new(0.1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = ehrp.CFrame * CFrame.new(0,0,-8)}):Play()
													task.spawn(function()
														local Wave1 = rep.VFX.Characters.Goku.BlueWave:Clone()
														Wave1.Parent = visuals
														Wave1.CFrame = ehrp.CFrame
														Wave1.CFrame = CFrame.lookAt(Wave1.Position,newPos)
														Wave1.CFrame  = Wave1.CFrame * CFrame.Angles(math.rad(90),0,0)
														ts:Create(Wave1,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(20,2,20),Transparency = 1}):Play()
														task.wait(0.2)
														Wave1:Destroy()
													end)
													task.spawn(function()
														local Wave2 = rep.VFX.Characters.Goku.YellowWave:Clone()
														Wave2.Parent = visuals
														Wave2.CFrame = ehrp.CFrame
														Wave2.CFrame = CFrame.lookAt(Wave2.Position,newPos)
														Wave2.CFrame  = Wave2.CFrame * CFrame.Angles(math.rad(90),0,0)
														ts:Create(Wave2,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(13,1,13),Transparency = 1}):Play()
														task.wait(0.2)
														Wave2:Destroy()
													end)
													task.spawn(function()
														DamageModule:Spec(char,echar,1,1,0.05,5,5,nil,false,nil,false,false)
													end)
												else
													local newCF = OldECF
													local newPos = newCF.Position
													ehrp.CFrame = CFrame.lookAt(ehrp.Position,newPos)
													ts:Create(ehrp,TweenInfo.new(0.1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = newCF}):Play()
													task.spawn(function()
														local Wave1 = rep.VFX.Characters.Goku.BlueWave:Clone()
														Wave1.Parent = visuals
														Wave1.CFrame = ehrp.CFrame
														Wave1.CFrame = CFrame.lookAt(Wave1.Position,newPos)
														Wave1.CFrame  = Wave1.CFrame * CFrame.Angles(math.rad(90),0,0)
														ts:Create(Wave1,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(20,2,20),Transparency = 1}):Play()
														task.wait(0.2)
														Wave1:Destroy()
													end)
													task.spawn(function()
														local Wave2 = rep.VFX.Characters.Goku.YellowWave:Clone()
														Wave2.Parent = visuals
														Wave2.CFrame = ehrp.CFrame
														Wave2.CFrame = CFrame.lookAt(Wave2.Position,newPos)
														Wave2.CFrame  = Wave2.CFrame * CFrame.Angles(math.rad(90),0,0)
														ts:Create(Wave2,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(13,1,13),Transparency = 1}):Play()
														task.wait(0.2)
														Wave2:Destroy()
													end)
													task.spawn(function()
														DamageModule:Spec(char,echar,1,1,0.05,5,5,nil,false,nil,false,false)
													end)
												end
												task.wait(0.1)
											end
											for i,v in pairs(char:GetDescendants()) do
												if v:IsA("BasePart") or v:IsA("MeshPart") or v:IsA("Decal") then
													if v.Name ~= "HumanoidRootPart" then
														v.Transparency = 0
													end
												end
											end
											CutsenseRemote:FireClient(plr,"Reset")
											hrp.CFrame = ehrp.CFrame * CFrame.new(math.random(-2,2),math.random(-2,2),math.random(-2,2))
											hrp.CFrame = CFrame.lookAt(hrp.Position,ehrp.Position)
											hum:LoadAnimation(rep.Anims.Goku.DraSlam):Play()
											track2:Stop()
											task.wait(0.4)
											task.spawn(function()
												DamageModule:Spec(char,echar,5,1,0.05,2,5,nil,false,nil,false)
											end)
											local rayParams = RaycastParams.new()
											rayParams.FilterType = Enum.RaycastFilterType.Include
											rayParams.FilterDescendantsInstances = {workspace.Map}
											local result = workspace:Raycast(ehrp.Position,Vector3.new(0,-500,0),rayParams)
											if result then
												ts:Create(ehrp,TweenInfo.new(0.35,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{CFrame = ehrp.CFrame * CFrame.new(0,-(result.Distance)+5,0)}):Play()
												task.spawn(function()
													task.wait(0.35)
													local smokeparticle = game.ServerStorage.Smoke:Clone()
													hum.AutoRotate = true
													hrp.Anchored = false
													ehum.AutoRotate = true
													ehrp.Anchored = false
													local sound2 = rep.Sounds.BasicAttack.Slam:Clone()
													sound2.Parent = ehrp
													sound2:Play()
													game.Debris:AddItem(sound2,sound2.TimeLength)
													task.spawn(function()
														DamageModule:Spec(char,echar,3,0,0.05,2.5,5,nil,false,nil,false)
													end)
													task.spawn(function()
														RagDoll(echar,2.5)
													end)
													task.spawn(function()
														RockModule.Ground(ehrp.Position,20,Vector3.new(3,3,3),{visuals,echar,char},10,false,6,0.4)
														smokeparticle.Parent = ehrp
														smokeparticle:Emit(56)
														game:GetService("Debris"):AddItem(smokeparticle,1)
													end)
													hum.AutoRotate = true
													hrp.Anchored = false
													ehum.AutoRotate = true
													ehrp.Anchored = false
													Cant:Destroy()
													Cant2:Destroy()
													remote:FireClient(plr,"Done8")
												end)
											else
												hum.AutoRotate = true
												hrp.Anchored = false
												ehum.AutoRotate = true
												ehrp.Anchored = false
												Cant:Destroy()
												Cant2:Destroy()
												remote:FireClient(plr,"Done8")
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
			task.wait(0.15)
			if PlayerHited == false then
				remote:FireClient(plr,"Done8")
			end
		else
			remote:FireClient(plr,"Done8")
		end
	end
end)


