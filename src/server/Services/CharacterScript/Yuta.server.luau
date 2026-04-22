local rep = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")
local remote = rep:WaitForChild("Remotes"):WaitForChild("Yuta")
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
									RagDoll(echar,ragTime)
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
							for i,v in pairs(echar:GetChildren()) do
								if v.Name == "Ragdolling" then
									v:Destroy()
								end
							end
							if echar:FindFirstChild("Block") then
								echar:FindFirstChild("Block"):Destroy()
								if ehum.Health <= 6 then
									task.spawn(function()
										DamageModule:Slash(pchar,echar,0,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								else
									task.spawn(function()
										DamageModule:Slash(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								end
							else
								if ehum.Health <= 6 then
									task.spawn(function()
										DamageModule:Slash(pchar,echar,0,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
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
							for i,v in pairs(echar:GetChildren()) do
								if v.Name == "Ragdolling" then
									v:Destroy()
								end
							end
							if echar:FindFirstChild("Block") then
								echar:FindFirstChild("Block"):Destroy()
								if ehum.Health <= dmg then
									DamageModule:Spec(char,echar,15,100,0.25,1,9,nil,true,10,false,false,false,true)
									local Trail = rep.VFX.BasicAttack.WhiteTrail:Clone()
									Trail.Parent = visuals
									Trail.CFrame = ehrp.CFrame
									local weld = Instance.new("Weld",Trail)
									weld.Part0 = ehrp
									weld.Part1 = Trail
									Trail.Trail.Enabled = true
									task.spawn(function()
										RagdollModule:Start(echar)
									end)
								else
									task.spawn(function()
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								end
							else
								if ehum.Health <= dmg then
									DamageModule:Spec(char,echar,15,100,0.25,1,9,nil,true,10,false,false,false,true)
									local Trail = rep.VFX.BasicAttack.WhiteTrail:Clone()
									Trail.Parent = visuals
									Trail.CFrame = ehrp.CFrame
									local weld = Instance.new("Weld",Trail)
									weld.Part0 = ehrp
									weld.Part1 = Trail
									Trail.Trail.Enabled = true
									task.spawn(function()
										RagdollModule:Start(echar)
									end)
								else
									task.spawn(function()
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
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
	local function DamageBox6(box,HitName,HitTime,pchar,dmg,Power,PT,ST,combo,breakAmount,Up,High,ragdoll,ragTime,GiveAwa)
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
										task.spawn(function()
											RagdollModule:Start(echar)
										end)
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
										task.spawn(function()
											RagdollModule:Start(echar)
										end)
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
									task.spawn(function()
										RagdollModule:Start(echar)
									end)
								else
									task.spawn(function()
										DamageModule:TrueDamage(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,false,GiveAwa)
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
	local function DamageBox7(box,HitName,HitTime,pchar,dmg,Power,PT,ST,combo,breakAmount,Up,High,ragdoll,ragTime,DirPush)
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
							for i,v in pairs(echar:GetChildren()) do
								if v.Name == "Ragdolling" then
									v:Destroy()
								end
							end
							if echar:FindFirstChild("Block") then
								echar:FindFirstChild("Block"):Destroy()
								if ehum.Health <= 10 then
									task.spawn(function()
										DamageModule:Spec(pchar,echar,0,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								else
									task.spawn(function()
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								end
							else
								if ehum.Health <= 10 then
									task.spawn(function()
										DamageModule:Spec(pchar,echar,0,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								else
									task.spawn(function()
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
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
	local function DamageBox8(box,HitName,HitTime,pchar,dmg,Power,PT,ST,combo,breakAmount,Up,High,ragdoll,ragTime,DirPush)
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
							for i,v in pairs(echar:GetChildren()) do
								if v.Name == "Ragdolling" then
									v:Destroy()
								end
							end
							if echar:FindFirstChild("Block") then
								echar:FindFirstChild("Block"):Destroy()
								if ehum.Health <= dmg then
									task.spawn(function()
										DamageModule:Spec(pchar,echar,dmg,0,PT,0.2,combo,breakAmount,true,50,false,false,DirPush)
									end)
									task.spawn(function()
										RagdollModule:Start(echar)
									end)
								else
									task.spawn(function()
										DamageModule:Spec(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								end
							else
								if ehum.Health <= dmg then
									task.spawn(function()
										DamageModule:Spec(pchar,echar,dmg,0,PT,0.2,combo,breakAmount,true,50,false,false,DirPush)
									end)
									task.spawn(function()
										RagdollModule:Start(echar)
									end)
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
	------------------------------------------------------------
	if wut == "Slashes" then
		local Katana = visuals:FindFirstChild("Katana")
		local track1 = hum:LoadAnimation(rep.Anims.Yuta.CursedSlashes)
		track1:Play()
		if not char:FindFirstChild("Stun") then
			local Cant = Instance.new("IntValue",char)
			Cant.Name = "StrongArmor"
			local Box = rep.VFX.Boxes.SlashesBox:Clone()
			Box.Parent = visuals
			Box.Transparency = 1
			Box.CFrame = hrp.CFrame
			Box.Anchored = false
			local weld = Instance.new("Weld",Box)
			weld.Part0 = Box
			weld.Part1 = hrp
			local SlashFX = rep.VFX.Characters.Yuta.CursedSlashes:Clone()
			SlashFX.Parent = visuals
			SlashFX.Weld.Part1 = hrp
			game.Debris:AddItem(SlashFX,4)
			delay(0.2,function()
				local sound1 = rep.Sounds.Yuta.Slashes:Clone()
				sound1.Parent = hrp
				sound1:Play()
				game.Debris:AddItem(sound1,sound1.TimeLength)
				task.spawn(function()
					DamageBox2(Box,"Slash",0.05,char,2.5,10,0.1,1,math.random(1,4),false,false,false,false,false,false)
					task.spawn(function()
						for i,v in pairs(SlashFX.Slash1:GetDescendants()) do
							if v:IsA("ParticleEmitter") then
								v:Emit(tonumber(v.Name))
							end
						end
					end)
				end)
			end)
			delay(0.6,function()
				local sound2 = rep.Sounds.Yuta.Slashes:Clone()
				sound2.Parent = hrp
				sound2:Play()
				game.Debris:AddItem(sound2,sound2.TimeLength)
				task.spawn(function()
					DamageBox2(Box,"Slash",0.05,char,3,10,0.1,1,math.random(1,4),false,false,false,false,false,false)
					task.spawn(function()
						for i,v in pairs(SlashFX.Slash2:GetDescendants()) do
							if v:IsA("ParticleEmitter") then
								v:Emit(tonumber(v.Name))
							end
						end
					end)
				end)
			end)
			delay(1,function()			
				local sound3 = rep.Sounds.Yuta.Slashes:Clone()
				sound3.Parent = hrp
				sound3:Play()
				game.Debris:AddItem(sound3,sound3.TimeLength)
				task.spawn(function()
					DamageBox2(Box,"Slash",0.05,char,4,10,0.1,1,math.random(1,4),false,false,false,false,false,false)
					task.spawn(function()
						for i,v in pairs(SlashFX.Slash3:GetDescendants()) do
							if v:IsA("ParticleEmitter") then
								v:Emit(tonumber(v.Name))
							end
						end
					end)
				end)
			end)
			task.wait(1.1)
			Box:Destroy()
			Cant:Destroy()
			remote:FireClient(plr,"Done1")
		else
			remote:FireClient(plr,"Done1")
		end
	end
	if wut == "Strike" then
		local Katana = visuals:FindFirstChild("Katana")
		local track1 = hum:LoadAnimation(rep.Anims.Yuta.Strike)
		track1:Play()
		task.wait(0.5)
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
			local NewCF = hrp.CFrame * CFrame.new(0,0,-45)
			local Result = workspace:Raycast(hrp.Position,NewCF.Position - hrp.Position,params)
			local function FarDash()
				hum.AutoRotate = false
				local Cant = Instance.new("IntValue",char)
				Cant.Name = "StrongArmor"
				local sound = rep.Sounds.Denji.Flash:Clone()
				sound.Parent = hrp
				sound:Play()
				game.Debris:AddItem(sound,sound.TimeLength)
				hrp.CFrame = hrp.CFrame * CFrame.new(0,0,-32)
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
			local DeathEffect = rep.VFX.Characters.Yuta.DeathStrike:Clone()
			DeathEffect.Parent = visuals
			DeathEffect.CFrame = hrp.CFrame * CFrame.new(0,0,-32/2)
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
				DamageBox3(DeathEffect,"Death",0.05,char,7,20,0.1,1.2,math.random(1,4),false,false,false,false,false,false)
			end)
			if Result then
				if Result.Distance < 32 then
					NearDash(Result.Distance)
				else
					FarDash()
				end
			else
				FarDash()
			end
			task.wait(0.2)
			remote:FireClient(plr,"Done2")
		else
			remote:FireClient(plr,"Done2")
		end
	end
	if wut == "Rampage" then
		local Katana = visuals:FindFirstChild("Katana")
		local track1 = hum:LoadAnimation(rep.Anims.Yuta.Rampage)
		track1:Play()
		if not char:FindFirstChild("Stun") then
			local cant = Instance.new("IntValue",char)
			cant.Name = "StrongArmor"
			local Box1 = rep.VFX.Boxes.UpperSlash:Clone()
			Box1.Parent = visuals
			Box1.Transparency = 1
			Box1.CFrame = hrp.CFrame * CFrame.new(0,0,2)
			local weld1 = Instance.new("Weld",Box1)
			weld1.Part0 = Box1
			weld1.Part1 = hrp
			weld1.C0 = CFrame.new(0,0,2)
			local SlashFX = rep.VFX.Characters.Yuta.Rampage:Clone()
			SlashFX.Parent = visuals
			SlashFX.Weld.Part1 = hrp
			game.Debris:AddItem(Box1,0.5)
			delay(0.3, function()
				local sound1 = rep.Sounds.Yuta.Slash2:Clone()
				sound1.Parent = hrp
				sound1.TimePosition = 0.25
				sound1:Play()
				game.Debris:AddItem(sound1,sound1.TimeLength)
				task.spawn(function()
					DamageBox4(Box1,"UpperSlash",0.05,char,3,0,0.1,1.25,math.random(1,4),false,true,25,false,false,false)
				end)
				task.spawn(function()
					for i,v in pairs(SlashFX.Slash1:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							v:Emit(tonumber(v.Name))
						end
					end
					game.Debris:AddItem(SlashFX,2)
				end)
			end)
			local Box2 = rep.VFX.Boxes.SlashesBox:Clone()
			Box2.Parent = visuals
			Box2.Transparency = 1
			Box2.CFrame = hrp.CFrame
			Box2.Anchored = false
			local weld2 = Instance.new("Weld",Box2)
			weld2.Part0 = Box2
			weld2.Part1 = hrp
			game.Debris:AddItem(Box2,0.5)
			delay(0.7, function()
				local sound2 = rep.Sounds.Yuta.Slashes:Clone()
				sound2.Parent = hrp
				sound2:Play()
				game.Debris:AddItem(sound2,sound2.TimeLength)
				task.spawn(function()
					DamageBox2(Box1,"LastSlash",0.05,char,3,50,0.2,1,math.random(1,4),false,true,20,false,false,false)
				end)
				task.spawn(function()
					for i,v in pairs(SlashFX.Slash2:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							v:Emit(tonumber(v.Name))
						end
					end
				end)
			end)
			task.wait(0.9)
			cant:Destroy()
			remote:FireClient(plr,"Done3")
		else
			remote:FireClient(plr,"Done3")
		end
	end
	if wut == "Heal" then
		local HealPart = rep.VFX.Characters.Yuta.HealPart:Clone()
		HealPart.Parent = visuals
		HealPart.CFrame = hrp.CFrame
		local weld = Instance.new("Weld",HealPart)
		weld.Part0 = hrp
		weld.Part1 = HealPart
		weld.C0 = CFrame.new(0,-2,0)
		remote:FireClient(plr,"Done4")
		local sound = rep.Sounds.Yuta.Heal:Clone()
		sound.Parent = hrp
		sound:Play()
		game.Debris:AddItem(sound,sound.TimeLength)
		for i = 1,10 do
			task.spawn(function()
				for i,v in pairs(HealPart:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(5)
						end)
					end
				end
			end)
			hum.Health += 1
			task.wait(0.1)
		end
		game.Debris:AddItem(HealPart,2)
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
		local Rika = rep.VFX.Characters.Yuta.TrueRika:Clone()
		Rika.Parent = visuals
		Rika.PrimaryPart.CFrame = hrp.CFrame
		Rika.TrueWeld.Part1 = hrp
		local track = hum:LoadAnimation(rep.Anims.Yuta.ComeOut)
		track:Play()
		local track2 = Rika.RootPart.Rika:LoadAnimation(rep.Anims.Yuta.Rika.ComeOut)
		track2:Play()
		local sound2 = rep.Sounds.Yuta.ComeRika:Clone()
		local chat = game:GetService("Chat")
		chat:Chat(hrp.Parent.Head,"Come Out, WINDAH!")
		sound2.Parent = hrp
		sound2:Play()
		game.Debris:AddItem(sound2,sound2.TimeLength)
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
		task.wait(3.8)
		local Smoke = rep.VFX.Characters.Yuta.Smoke:Clone()
		Smoke.Parent = visuals
		Smoke.CFrame = Rika.PrimaryPart.CFrame
		task.spawn(function()
			for i,v in pairs(Smoke:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					spawn(function()
						local EA = v:GetAttribute("EmitCount")
						v:Emit(EA)
					end)
				end
			end
			game.Debris:AddItem(Smoke,2)
		end)
		Rika:Destroy()
		task.spawn(function()
			for i, v in pairs(char:GetChildren()) do
				if v:IsA("BasePart") or v:IsA("MeshPart") then
					local modelAura = rep.VFX.Characters.Yuta.Aura:Clone()
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
		local Theme = rep.Sounds.Yuta.Theme:Clone()
		Theme.Parent = hrp
		Theme:Play()
		track:Stop()
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
	if wut == "Shine" then
		local track = hum:LoadAnimation(rep.Anims.Yuta.Shine)
		local Speaker = rep.VFX.Characters.Yuta.Speaker:Clone()
		Speaker.Parent = visuals
		Speaker.SpeakerArm.MainWeld.Part1 = char:FindFirstChild("Left Arm")
		local track2 = Speaker.AnimCtrl:LoadAnimation(rep.Anims.Yuta.ShineSpeaker)
		track:Play()
		track2:Play()
		task.wait(0.5)
		if not char:FindFirstChild("Stun") then
			local cant1 = Instance.new("IntValue",char)
			cant1.Name = "StrongArmor"
			local sound = rep.Sounds.Yuta.Shine:Clone()
			sound.Parent = hrp
			sound:Play()
			game.Debris:AddItem(sound,sound.TimeLength)
			task.wait(0.7)
			local Wind = rep.VFX.Characters.Yuta.ShineWind:Clone()
			Wind.Parent = visuals
			Wind.Anchored = true
			Wind.Transparency = 1
			Wind.CFrame = hrp.CFrame * CFrame.new(0,0,-Wind.Size.Z/2)
			task.spawn(function()
				for i,v in pairs(Wind:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						spawn(function()
							local EA = v:GetAttribute("EmitCount")
							v:Emit(EA)
						end)
					end
				end
				game.Debris:AddItem(Wind,2)
			end)
			task.spawn(function()
				RockModule.Front(hrp,2.5,0.2,20,true,0.2,0.15,1,5,0.05)
			end)
			task.spawn(function()
				RockModule.Ground(hrp.Position,10,Vector3.new(2,2,2),{char,Wind},8,false,5,0.2)
			end)
			task.spawn(function()
				camShake:FireClient(plr,"SpeechShake")
				LightingRemote:FireClient(plr,"Speech")
			end)
			task.spawn(function()
				DamageBox5(Wind,"Shined",0.1,char,15,100,0.2,0.75,nil,false,true,15,false,false,false)
			end)
			task.wait(0.4)
			cant1:Destroy()
			track:Stop()
			track2:Stop()
			Speaker:Destroy()
			remote:FireClient(plr,"Done5")
		else
			track:Stop()
			track2:Stop()
			Speaker:Destroy()
			remote:FireClient(plr,"Done5")
		end
	end
 	if wut == "BlackFlash" then
		hum:LoadAnimation(rep.Anims.Yuta.PrepareBlack):Play()
		task.wait(0.45)
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
			local function BlackFlash(playerBF,Char)
				local MainGui = playerBF.PlayerGui:WaitForChild("FramesBF")
				local oldGui = nil
				local newGui = nil
				local hrp2 = Char.HumanoidRootPart
				local sound = game:GetService("ReplicatedStorage"):WaitForChild("Sounds"):WaitForChild("Yuta").PrepareBlack:Clone()
				sound.Parent = hrp2
				sound:Play()
				game.Debris:AddItem(sound,sound.TimeLength)
				task.spawn(function()
					task.wait(sound.TimeLength)
					local sound2 = game:GetService("ReplicatedStorage"):WaitForChild("Sounds"):WaitForChild("Yuta").LastBlack:Clone()
					sound2.Parent = hrp2
					sound2:Play()
					game.Debris:AddItem(sound2,sound2.TimeLength)
				end)
				for i = 1,10 do
					newGui = MainGui:FindFirstChild("Frame"..i)
					newGui.Visible = true
					task.wait(0.04)
					if i ~= 10 then
						oldGui = newGui
						oldGui.Visible = false
					end
				end
				task.wait(0.6)
				MainGui:FindFirstChild("Frame"..10).Visible = false
				for i = 11,36 do
					newGui = MainGui:FindFirstChild("Frame"..i)
					newGui.Visible = true
					task.wait(0.048)
					oldGui = newGui
					oldGui.Visible = false
				end
			end
			
			task.spawn(function()
				local params = OverlapParams.new()
				params.FilterType = Enum.RaycastFilterType.Exclude
				params.MaxParts = 0
				params.FilterDescendantsInstances = {box,visuals}
				local HitName = "Blacked"
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
											remote:FireClient(plr,"Done6")
										else
											local Stun = Instance.new("IntValue",echar)
											Stun.Name = "Stun"
											local Massless = true
											hum.AutoRotate = false
											ehum.AutoRotate = false
											hrp.Anchored = true
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
											if ehrp then
												ehrp.CFrame = hrp.CFrame * CFrame.new(0,0,-2.7) * CFrame.Angles(0,math.rad(180),0)
											end
											task.wait(0.1)
											local WeldChar = Instance.new("Weld",echar)
											WeldChar.Part0 = ehrp
											WeldChar.Part1 = hrp
											WeldChar.C0 = CFrame.new(0,0,-2.7) * CFrame.Angles(0,math.rad(180),0)
											local Hold1 = hum:LoadAnimation(rep.Anims.Yuta.PlrHold)
											local Hold2 = hum:LoadAnimation(rep.Anims.Yuta.EnemyHold)
											Hold1:Play()
											Hold2:Play()
											task.spawn(function()
												local eplr = game:GetService("Players"):GetPlayerFromCharacter(echar)
												if eplr then
													BlackFlash(eplr,echar)
												end
											end)
											BlackFlash(plr,char)
											Hold1:Stop()
											Hold2:Stop()
											hum:LoadAnimation(rep.Anims.Yuta.PlrBlack):Play()
											ehum:LoadAnimation(rep.Anims.Yuta.EnemyBlack):Play()
											local CamParts = rep.VFX.Characters.Yuta.BlackFlashCam:Clone()
											CamParts.Parent = visuals
											CamParts.MainCamPart.CFrame = hrp.CFrame
											CutsenseRemote:FireClient(plr,"Yuta",nil,nil,CamParts)
											task.spawn(function()
												local eplr = game:GetService("Players"):GetPlayerFromCharacter(echar)
												if eplr then
													CutsenseRemote:FireClient(eplr,"Yuta",nil,nil,CamParts)
												end
											end)
											task.spawn(function()
												local BLP = rep.VFX.Characters.Yuta.BlackFlashPart:Clone()
												BLP.Parent = visuals
												BLP.CFrame = ehrp.CFrame
												BLP.Anchored = true
												task.spawn(function()
													for i,v in pairs(BLP:GetDescendants()) do
														if v:IsA("ParticleEmitter") then
															spawn(function()
																local EA = v:GetAttribute("EmitCount")
																v:Emit(EA)
															end)
														end
													end
													game.Debris:AddItem(BLP,2)
												end)
											end)
											task.wait(3.5)
											Stun:Destroy()
											Massless = false
											cant1:Destroy()
											cant2:Destroy()
											WeldChar.C0 = CFrame.new(0,0,0)
											WeldChar:Destroy()
											task.wait(0.05)
											if ehrp then
												ehum.AutoRotate = true
												ehrp.CFrame = hrp.CFrame * CFrame.new(0,0,3)
											end
											task.wait(0.05)
											task.spawn(function()
												if ehum.Health <= 20 then
													DamageModule:Spec(char,echar,20,80,0.25,1,9,nil,true,10,true,false,false,true)
													local Trail = rep.VFX.BasicAttack.WhiteTrail:Clone()
													Trail.Parent = visuals
													Trail.CFrame = ehrp.CFrame
													local weld = Instance.new("Weld",Trail)
													weld.Part0 = ehrp
													weld.Part1 = Trail
													Trail.Trail.Enabled = true
													task.spawn(function()
														RagdollModule:Start(echar)
													end)
												else
													DamageModule:Spec(char,echar,20,80,0.2,1,9,nil,true,10,true,false,false,true)
												end
											end)
											task.spawn(function()
												local BLP2 = rep.VFX.Characters.Yuta.BlackLighting:Clone()
												BLP2.Parent = visuals
												BLP2.CFrame = hrp.CFrame * CFrame.new(0,0,20)
												BLP2.Anchored = true
												task.spawn(function()
													for i,v in pairs(BLP2:GetDescendants()) do
														if v:IsA("ParticleEmitter") then
															spawn(function()
																local EA = v:GetAttribute("EmitCount")
																v:Emit(EA)
															end)
														end
													end
													game.Debris:AddItem(BLP2,2)
												end)
											end)
											task.spawn(function()
												camShake:FireClient(plr,"ShakeOnce")
												local eplr = game:GetService("Players"):GetPlayerFromCharacter(echar)
												if eplr then
													camShake:FireClient(eplr,"ShakeOnce")
												end
											end)
											task.wait(0.1)
											hrp.Anchored = false
											CamParts:Destroy()
											hum.AutoRotate = true
											remote:FireClient(plr,"Done6")
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
				remote:FireClient(plr,"Done6")
			end
		else
			remote:FireClient(plr,"Done6")
		end
	end
	if wut == "GroundBreak" then
		local cant = Instance.new("IntValue",char)
		cant.Name = "StrongArmor"
		local Rika = rep.VFX.Characters.Yuta.TrueRika:Clone()
		Rika.Parent = visuals
		Rika.PrimaryPart.CFrame = hrp.CFrame
		Rika.TrueWeld.C0 = CFrame.new(0,0,-5) * CFrame.Angles(0,math.rad(-180),0)
		Rika.TrueWeld.Part1 = hrp
		local Smoke = rep.VFX.Characters.Yuta.Smoke:Clone()
		Smoke.Parent = visuals
		Smoke.CFrame = Rika.PrimaryPart.CFrame
		task.spawn(function()
			for i,v in pairs(Smoke:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					spawn(function()
						local EA = v:GetAttribute("EmitCount")
						v:Emit(EA)
					end)
				end
			end
		end)
		local track2 = Rika.RootPart.Rika:LoadAnimation(rep.Anims.Yuta.Rika.BreakGround)
		track2:Play()
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
			table.insert(CheckChar,Rika)
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Exclude
			params.FilterDescendantsInstances = CheckChar
			for i = 1,2 do
				task.wait(0.5)
				local newCF = hrp.CFrame * CFrame.new(0,0,-11)
				local ray = workspace:Raycast(newCF.Position,Vector3.new(0,-100,0),params)
				if ray then
					local Slam1 = rep.VFX.Characters.Yuta.SlamEffect:Clone()
					Slam1.Parent = visuals
					Slam1.Position = ray.Position
					Slam1.Anchored = true
					local sound = rep.Sounds.BasicAttack.Slam:Clone()
					sound.Parent = hrp
					sound:Play()
					game.Debris:AddItem(sound,sound.TimeLength)
					task.spawn(function()
						DamageBox7(Slam1,"Slam1",0.1,char,5,0,0,1.25,nil,false,false,false,false,false)
					end)
					task.spawn(function()
						for i,v in pairs(Slam1:GetDescendants()) do
							if v:IsA("ParticleEmitter") then
								spawn(function()
									local EA = v:GetAttribute("EmitCount")
									v:Emit(EA)
								end)
							end
						end
						task.wait(3.5)
						Slam1:Destroy()
					end)
				end
			end
			task.wait(1)
			local newCF = hrp.CFrame * CFrame.new(0,0,-11)
			local ray = workspace:Raycast(newCF.Position,Vector3.new(0,-100,0),params)
			if ray then
				local Slam2 = rep.VFX.Characters.Yuta.SlamEffect2:Clone()
				Slam2.Parent = visuals
				Slam2.Position = ray.Position
				Slam2.Anchored = true
				local sound = rep.Sounds.BasicAttack.GroundSmash:Clone()
				sound.Parent = hrp
				sound:Play()
				game.Debris:AddItem(sound,sound.TimeLength)
				task.spawn(function()
					RockModule.Ground(newCF.Position,23,Vector3.new(4,4,4),{},13,false,3,0.25)
				end)
				task.spawn(function()
					DamageBox8(Slam2,"Slam2",0.1,char,10,0,0.2,2,nil,false,true,50,true,2)
				end)
				task.spawn(function()
					for i,v in pairs(Slam2:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(EA)
							end)
						end
					end
					task.wait(3.5)
					Slam2:Destroy()
				end)
			end
		end)
		task.wait(2.2)
		Smoke.CFrame = Rika.PrimaryPart.CFrame
		task.spawn(function()
			for i,v in pairs(Smoke:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					spawn(function()
						local EA = v:GetAttribute("EmitCount")
						v:Emit(EA)
					end)
				end
			end
			game.Debris:AddItem(Smoke,2)
		end)
		cant:Destroy()
		Rika:Destroy()
		remote:FireClient(plr,"Done7")
	end
	if wut == "PureLove" then
		local cant = Instance.new("IntValue",char)
		cant.Name = "HyperArmor"
		local Rika = rep.VFX.Characters.Yuta.TrueRika:Clone()
		Rika.Parent = visuals
		Rika.PrimaryPart.CFrame = hrp.CFrame
		Rika.TrueWeld.Part1 = hrp
		local track = hum:LoadAnimation(rep.Anims.Yuta.PureLove)
		track:Play()
		local track2 = Rika.RootPart.Rika:LoadAnimation(rep.Anims.Yuta.Rika.PureLove)
		track2:Play()
		local Smoke = rep.VFX.Characters.Yuta.Smoke:Clone()
		Smoke.Parent = visuals
		Smoke.CFrame = Rika.PrimaryPart.CFrame
		local sound = rep.Sounds.Yuta.PureLove:Clone()
		sound.Parent = hrp
		sound:Play()
		task.spawn(function()
			task.wait(sound.TimeLength)
			sound:Destroy()
		end)
		task.spawn(function()
			for i,v in pairs(Smoke:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					spawn(function()
						local EA = v:GetAttribute("EmitCount")
						v:Emit(EA)
					end)
				end
			end
		end)
		task.spawn(function()
			task.wait(6)
			local Hitting = true
			local Pure1 = rep.VFX.Characters.Yuta.Pure1:Clone()
			local Pure2 = rep.VFX.Characters.Yuta.Pure2:Clone()
			Pure1.Parent = visuals
			Pure2.Parent = visuals
			Pure1.Beam2.Attachment1 = Pure2.Attachment
			Pure1.Beam3.Attachment1 = Pure2.Attachment
			Rika.BallWeld.Part1 = Pure1
			Rika.EndWeld.Part1 = Pure2
			local BallEffect = true
			local FlameEffect = true
			task.spawn(function()
				while FlameEffect do
					task.spawn(function()
						for i,v in pairs(Pure1.CoreFire:GetDescendants()) do
							if v:IsA("ParticleEmitter") and v == Pure1.CoreFire.Effect then
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
			task.spawn(function()
				while BallEffect do
					task.spawn(function()
						for i,v in pairs(Pure1.CoreFire:GetDescendants()) do
							if v:IsA("ParticleEmitter") and v ~= Pure1.CoreFire.Effect then
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
			hum.AutoRotate = false
			camShake:FireClient(plr,"Shaking")
			FlameEffect = false
			local SparkEffect = true
			local OtherEffect = true
			local Ball2Effect = true
			task.spawn(function()
				while SparkEffect do
					task.spawn(function()
						for i,v in pairs(Pure1.Spark:GetDescendants()) do
							if v:IsA("ParticleEmitter") then
								spawn(function()
									local EA = v:GetAttribute("EmitCount")
									v:Emit(2)
								end)
							end
						end
					end)
					task.wait(0.05)
				end
			end)
			task.spawn(function()
				while OtherEffect do
					task.spawn(function()
						for i,v in pairs(Pure1.Attachment1:GetDescendants()) do
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
				while Ball2Effect do
					task.spawn(function()
						for i,v in pairs(Pure2:GetDescendants()) do
							if v:IsA("ParticleEmitter") then
								spawn(function()
									local EA = v:GetAttribute("EmitCount")
									v:Emit(1)
								end)
							end
						end
					end)
					task.wait(0.25)
				end
			end)
			Pure1.Beam2.Enabled = true
			Pure1.Beam3.Enabled = true
			local HitBox = rep.VFX.Boxes.PureBox:Clone()
			HitBox.Parent = visuals
			HitBox.CFrame = hrp.CFrame * CFrame.new(0,0,-HitBox.Size.Z/2)
			HitBox.Transparency = 1
			local Weld = Instance.new("Weld",HitBox)
			Weld.Part0 = hrp
			Weld.Part1 = HitBox
			Weld.C0 = CFrame.new(0,0,-HitBox.Size.Z/2)
			local puring = rep.Sounds.Yuta.Puring:Clone()
			puring.Parent = hrp
			puring:Play()
			task.spawn(function()
				while Hitting do
					DamageBox6(HitBox,"PureHit",0.05,char,0.5,5,0.1,1,nil,false,false,false,false,false,true)
					task.wait()
				end
			end)
			task.wait(10)
			cant:Destroy()
			Hitting = false
			puring:Destroy()
			camShake:FireClient(plr,"StopShaking")
			Ball2Effect = false
			SparkEffect = false
			OtherEffect = false
			BallEffect = false
			Pure1:Destroy()
			Pure2:Destroy()
			HitBox:Destroy()
			hum.AutoRotate = true
		end)
		task.wait(22)
		Smoke.CFrame = Rika.PrimaryPart.CFrame
		task.spawn(function()
			for i,v in pairs(Smoke:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					spawn(function()
						local EA = v:GetAttribute("EmitCount")
						v:Emit(EA)
					end)
				end
			end
			game.Debris:AddItem(Smoke,2)
		end)
		Rika:Destroy()
		remote:FireClient(plr,"Done8")
	end
	if wut == "OpenTrails" then
		local Katana = visuals:FindFirstChild("Katana")
		if Katana.Trail.Enabled == false then
			Katana.Trail.Enabled = true
		end
		if Katana.Trail2.Enabled == false then
			Katana.Trail2.Enabled = true
		end
	end
	if wut == "CloseTrails" then
		local Katana = visuals:FindFirstChild("Katana")
		if Katana.Trail.Enabled == true then
			Katana.Trail.Enabled = false
		end
		if Katana.Trail2.Enabled == true then
			Katana.Trail2.Enabled = false
		end
	end
end)
