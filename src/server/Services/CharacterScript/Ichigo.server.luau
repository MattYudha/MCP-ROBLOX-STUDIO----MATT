local rep = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")
local remote = rep:WaitForChild("Remotes"):WaitForChild("Ichigo")
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
		local Katana = visuals:FindFirstChild("GreatSword")
		local track1 = hum:LoadAnimation(rep.Anims.Ichigo.Slashes)
		track1:Play()
		local track2 = Katana.AnimCtrl:LoadAnimation(rep.Anims.Ichigo.SwordFolder.Slashes)
		track2:Play()
		local check = Instance.new("IntValue",char)
		check.Name = "NoCamMove"
		local Hitting = true
		local SlashPart = rep.VFX.Characters.Ichigo.SlashesParticle:Clone()
		SlashPart.Parent = visuals
		SlashPart.CFrame = hrp.CFrame
		SlashPart.Weld.Part1 = hrp
		task.spawn(function()
			while Hitting do
				task.spawn(function()
					for i,v in pairs(SlashPart:GetDescendants()) do
						if v:IsA("ParticleEmitter") and v ~= SlashPart.Line then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(1)
							end)
						end
					end
				end)
				task.wait(0.08)
			end
		end)
		task.spawn(function()
			while Hitting do
				task.spawn(function()
					for i,v in pairs(SlashPart:GetChildren()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(1)
							end)
						end
					end
				end)
				task.wait(0.05)
			end
		end)
		local AfterDelay = task.delay(3,function()
			if Hitting then
				Hitting = false
				track1:Stop()
				track2:Stop()
				remote:FireClient(plr,"Done1")
				check:Destroy()
			end
		end)
		task.spawn(function()
			while Hitting do
				if char:FindFirstChild("Stun") then
					if Hitting then
						Hitting = false
						task.cancel(AfterDelay)
						track1:Stop()
						track2:Stop()
						remote:FireClient(plr,"Done1")
						check:Destroy()
					end
				end
				task.wait()
			end
		end)
	end
	if wut == "OpenTrails" then
		local Katana = visuals:FindFirstChild("GreatSword")
		if Katana.Trail.Enabled == false then
			Katana.Trail.Enabled = true
		end
		if Katana.Trail2.Enabled == false then
			Katana.Trail2.Enabled = true
		end
	end
	if wut == "CloseTrails" then
		local Katana = visuals:FindFirstChild("GreatSword")
		if Katana.Trail.Enabled == true then
			Katana.Trail.Enabled = false
		end
		if Katana.Trail2.Enabled == true then
			Katana.Trail2.Enabled = false
		end
	end
end)
