local rep = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")
local remote = rep:WaitForChild("Remotes"):WaitForChild("Luffy")
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
	
	local function GatlingArmRight(MainPart)
		local P0 = MainPart.A0R.WorldPosition
		local PosRan = math.random(-60,60)/10
		local PosRan2 = math.random(-20,20)/10
		local P1 = MainPart.A1R.WorldPosition + Vector3.new(0,PosRan,0)
		local P2 = MainPart.A2R.WorldPosition + Vector3.new(0,PosRan2,0)
		local FakeArm = rep.VFX.Characters.Luffy.FakeArm:Clone()
		FakeArm.Parent = visuals
		local Size = math.random(30,50)/10
		FakeArm.Size = Vector3.new(1.5,Size,2)
		FakeArm.Color = char:FindFirstChild("Right Arm").Color
		task.spawn(function()
			task.wait(0.0000000001)
			for i,v in pairs(FakeArm:GetDescendants()) do
				if v:IsA("Trail") then
					v.Color = ColorSequence.new(char:FindFirstChild("Right Arm").Color)
					v.Enabled = true
				end
			end
		end)
		for i = 1,15 do
			local t = i/15
			local PosR = quadraticBezier(t,P0,P1,P2)
			local DirR = quadraticBezier(t + 0.0005,P0,P1,P2)
			FakeArm.CFrame = CFrame.new(PosR,DirR) * CFrame.Angles(math.rad(90),math.rad(-90),0)
			task.wait()
		end
		FakeArm:Destroy()
	end
	local function GatlingArmLeft(MainPart)
		local P0 = MainPart.A0L.WorldPosition
		local PosRan = math.random(-60,60)/10
		local PosRan2 = math.random(-20,20)/10
		local P1 = MainPart.A1L.WorldPosition + Vector3.new(0,PosRan,0)
		local P2 = MainPart.A2L.WorldPosition + Vector3.new(0,PosRan2,0)
		local FakeArm = rep.VFX.Characters.Luffy.FakeArm:Clone()
		FakeArm.Parent = visuals
		local Size = math.random(30,50)/10
		FakeArm.Size = Vector3.new(1.5,Size,2)
		FakeArm.Color = char:FindFirstChild("Left Arm").Color
		task.spawn(function()
			task.wait(0.0000000001)
			for i,v in pairs(FakeArm:GetDescendants()) do
				if v:IsA("Trail") then
					v.Color = ColorSequence.new(char:FindFirstChild("Left Arm").Color)
					v.Enabled = true
				end
			end
		end)
		for i = 1,15 do
			local t = i/15
			local PosR = quadraticBezier(t,P0,P1,P2)
			local DirR = quadraticBezier(t + 0.0005,P0,P1,P2)
			FakeArm.CFrame = CFrame.new(PosR,DirR) * CFrame.Angles(math.rad(90),math.rad(90),0)
			task.wait()
		end
		FakeArm:Destroy()
	end
	local function GatlingArmRight2(MainPart)
		local P0 = MainPart.A0R.WorldPosition
		local PosRan = math.random(-40,40)/10
		local PosRan2 = math.random(-20,20)/10
		local P1 = MainPart.A3R.WorldPosition + Vector3.new(0,PosRan,0)
		local P2 = MainPart.A4R.WorldPosition + Vector3.new(0,PosRan2,0)
		local FakeArm = rep.VFX.Characters.Luffy.FakeArm:Clone()
		FakeArm.Parent = visuals
		local Size = math.random(30,50)/10
		FakeArm.Size = Vector3.new(1.5,Size,2)
		FakeArm.Color = char:FindFirstChild("Right Arm").Color
		task.spawn(function()
			task.wait(0.0000000001)
			for i,v in pairs(FakeArm:GetDescendants()) do
				if v:IsA("Trail") then
					v.Color = ColorSequence.new(char:FindFirstChild("Right Arm").Color)
					v.Enabled = true
				end
			end
		end)
		for i = 1,15 do
			local t = i/15
			local PosR = quadraticBezier(t,P0,P1,P2)
			local DirR = quadraticBezier(t + 0.0005,P0,P1,P2)
			FakeArm.CFrame = CFrame.new(PosR,DirR) * CFrame.Angles(math.rad(90),math.rad(-90),0)
			task.wait()
		end
		FakeArm:Destroy()
	end
	local function GatlingArmLeft2(MainPart)
		local P0 = MainPart.A0L.WorldPosition
		local PosRan = math.random(-40,40)/10
		local PosRan2 = math.random(-20,20)/10
		local P1 = MainPart.A3L.WorldPosition + Vector3.new(0,PosRan,0)
		local P2 = MainPart.A4L.WorldPosition + Vector3.new(0,PosRan2,0)
		local FakeArm = rep.VFX.Characters.Luffy.FakeArm:Clone()
		FakeArm.Parent = visuals
		local Size = math.random(30,50)/10
		FakeArm.Size = Vector3.new(1.5,Size,2)
		FakeArm.Color = char:FindFirstChild("Left Arm").Color
		task.spawn(function()
			task.wait(0.0000000001)
			for i,v in pairs(FakeArm:GetDescendants()) do
				if v:IsA("Trail") then
					v.Color = ColorSequence.new(char:FindFirstChild("Left Arm").Color)
					v.Enabled = true
				end
			end
		end)
		for i = 1,15 do
			local t = i/15
			local PosR = quadraticBezier(t,P0,P1,P2)
			local DirR = quadraticBezier(t + 0.0005,P0,P1,P2)
			FakeArm.CFrame = CFrame.new(PosR,DirR) * CFrame.Angles(math.rad(90),math.rad(90),0)
			task.wait()
		end
		FakeArm:Destroy()
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
											DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
										end)
										RagdollModule:Start(echar)
									else
										task.spawn(function()
											DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
										end)
									end
								else
									task.spawn(function()
										DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								end
							else
								if ehum.Health <= dmg then
									task.spawn(function()
										DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
									RagdollModule:Start(echar)
								else
									task.spawn(function()
										DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
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
								echar:FindFirstChild("Block"):Destroy()
								if ehum.Health <= dmg then								
									task.spawn(function()
										task.spawn(function()
											RagdollModule:Start(echar)
											RockModule.Front(hrp,3,0.2,20,true,0.2,0.05,1,5,0)
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
										DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								end
							else
								if ehum.Health <= dmg then								
									task.spawn(function()
										task.spawn(function()
											RagdollModule:Start(echar)
											RockModule.Front(hrp,3,0.2,20,true,0.2,0.05,1,5,0)
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
										DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
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
	local function DamageBox5(box,HitName,HitTime,pchar,dmg,Power,PT,ST,combo,breakAmount,Up,High,ragdoll,ragTime,DirPush)
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
										task.spawn(function()
											RagdollModule:Start(echar)
											RockModule.Front(hrp,3,0.2,20,true,0.2,0.05,1,5,0)
										end)
										task.spawn(function()
											camShake:FireClient(plr,"ShakeOnce")
											local eplr = game:GetService("Players"):GetPlayerFromCharacter(echar)
											if eplr then
												camShake:FireClient(eplr,"ShakeOnce")
											end
										end)
										DamageModule:Spec(pchar,echar,dmg,200,0.25,ST,5,breakAmount,true,100)
										local Trail = rep.VFX.BasicAttack.WhiteTrail:Clone()
										Trail.Parent = visuals
										Trail.CFrame = ehrp.CFrame
										local weld = Instance.new("Weld",Trail)
										weld.Part0 = ehrp
										weld.Part1 = Trail
										Trail.Trail.Enabled = true
										for i,v in pairs(echar:GetDescendants()) do
											if v:IsA("BasePart") or v:IsA("MeshPart") then
												v.Color = Color3.new(0, 0, 0)
											end
										end
									end)
								else
									task.spawn(function()
										DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
									end)
								end
							else
								if ehum.Health <= dmg then								
									task.spawn(function()
										task.spawn(function()
											RagdollModule:Start(echar)
											RockModule.Front(hrp,3,0.2,20,true,0.2,0.05,1,5,0)
										end)
										task.spawn(function()
											camShake:FireClient(plr,"ShakeOnce")
											local eplr = game:GetService("Players"):GetPlayerFromCharacter(echar)
											if eplr then
												camShake:FireClient(eplr,"ShakeOnce")
											end
										end)
										DamageModule:Spec(pchar,echar,dmg,200,0.25,ST,5,breakAmount,true,100)
										local Trail = rep.VFX.BasicAttack.WhiteTrail:Clone()
										Trail.Parent = visuals
										Trail.CFrame = ehrp.CFrame
										local weld = Instance.new("Weld",Trail)
										weld.Part0 = ehrp
										weld.Part1 = Trail
										Trail.Trail.Enabled = true
										for i,v in pairs(echar:GetDescendants()) do
											if v:IsA("BasePart") or v:IsA("MeshPart") then
												v.Color = Color3.new(0, 0, 0)
											end
										end
									end)
								else
									task.spawn(function()
										DamageModule:Spec2(pchar,echar,dmg,Power,PT,ST,combo,breakAmount,Up,High,false,false,DirPush)
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
	if wut == "Gatling" then
		hum:LoadAnimation(rep.Anims.Luffy.PrepareGat):Play()
		task.wait(0.5)
		if not char:FindFirstChild("Stun") then
			local Gatling = true
			local track = hum:LoadAnimation(rep.Anims.Luffy.Gat)
			track:Play()
			char:FindFirstChild("Right Arm").Transparency = 1
			char:FindFirstChild("Left Arm").Transparency = 1
			local GatPart = rep.VFX.Characters.Luffy.GatMain:Clone()
			GatPart.Parent = visuals
			GatPart.CFrame = hrp.CFrame 
			local weld = Instance.new("Weld",GatPart)
			weld.Part0 = hrp
			weld.Part1 = GatPart
			local Box = rep.VFX.Boxes.Gatling:Clone()
			Box.Parent = visuals
			Box.CFrame = hrp.CFrame * CFrame.new(0,0,-6)
			Box.Transparency = 1
			local weld2 = Instance.new("Weld",Box)
			weld2.Part0 = hrp
			weld2.Part1 = Box
			weld2.C0 = CFrame.new(0,0,-4)
			task.spawn(function()
				while Gatling do
					task.spawn(function()
						DamageBox2(Box,"Gatling",0.1,char,0.25,2.5,0.1,0.75,math.random(1,2),false,false,false,false,false)
					end)
					task.wait()
				end
			end)
			task.spawn(function()
				while Gatling do
					task.spawn(function()
						task.spawn(function()
							GatlingArmLeft(GatPart)
						end)
						task.wait(0.05)
						task.spawn(function()
							GatlingArmRight(GatPart)
						end)
					end)
					task.spawn(function()
						task.wait(0.05)
						task.spawn(function()
							GatlingArmLeft2(GatPart)
						end)
						task.wait(0.05)
						task.spawn(function()
							GatlingArmRight2(GatPart)
						end)
					end)
					task.wait(0.09)
				end
			end)
			task.spawn(function()
				while Gatling do
					task.spawn(function()
						local PunSound = rep.Sounds.BasicAttack.PunchSwing:Clone()
						PunSound.Parent = hrp
						PunSound:Play()
						game.Debris:AddItem(PunSound,PunSound.TimeLength)
					end)
					task.wait(0.1)
				end
			end)
			task.spawn(function()
				while Gatling do
					if char:FindFirstChild("Stun") then
						Gatling = false
						track:Stop()
						Box:Destroy()
						GatPart:Destroy()
						remote:FireClient(plr,"Done3")
						char:FindFirstChild("Right Arm").Transparency = 0
						char:FindFirstChild("Left Arm").Transparency = 0
					end
					task.wait()
				end
			end)
			task.wait(4)
			if Gatling == true then
				Gatling = false
				track:Stop()
				Box:Destroy()
				GatPart:Destroy()
				remote:FireClient(plr,"Done3")
				char:FindFirstChild("Right Arm").Transparency = 0
				char:FindFirstChild("Left Arm").Transparency = 0
			end
		else
			remote:FireClient(plr,"Done3")
		end
	end
	if wut == "Axe" then
		local track = hum:LoadAnimation(rep.Anims.Luffy.Axe)
		track:Play()
		task.wait(0.5)
		if not char:FindFirstChild("Stun") then
			local cant = Instance.new("IntValue",char)
			cant.Name = "StrongArmor"
			local FakeLeg = rep.VFX.Characters.Luffy.FakeLeg:Clone()
			FakeLeg.Parent = visuals
			FakeLeg.CFrame = char:FindFirstChild("Right Leg").CFrame
			FakeLeg.Color = char:FindFirstChild("Right Leg").Color
			local weld = Instance.new("Weld",FakeLeg)
			weld.Part0 = FakeLeg
			weld.Part1 = char:FindFirstChild("Right Leg")
			local sound = rep.Sounds.Luffy.Stretch:Clone()
			sound.Parent = hrp
			sound:Play()
			game.Debris:AddItem(sound,sound.TimeLength)
			ts:Create(FakeLeg,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(1,40,1)}):Play()
			ts:Create(weld,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{C0 = CFrame.new(0,19.5,0)}):Play()
			task.spawn(function()
				local cf1 = 10
				for i = 1,3 do
					local Wave = rep.VFX.Characters.Luffy.Wave:Clone()
					Wave.Parent = visuals
					Wave.CFrame = char:FindFirstChild("Right Leg").CFrame * CFrame.new(0,-cf1,0)
					ts:Create(Wave,TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(25,2,25),Transparency = 1}):Play()
					task.spawn(function()
						task.wait(0.2)
						Wave:Destroy()
					end)
					cf1 = cf1 + 10
					task.wait(0.1)
				end
				local cf2 = 30
				for i = 1,3 do
					local Wave = rep.VFX.Characters.Luffy.Wave:Clone()
					Wave.Parent = visuals
					Wave.CFrame = char:FindFirstChild("Right Leg").CFrame * CFrame.new(0,-cf2,0)
					ts:Create(Wave,TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(25,2,25),Transparency = 1}):Play()
					task.spawn(function()
						task.wait(0.2)
						Wave:Destroy()
					end)
					cf2 = cf2 - 10
					task.wait(0.1)
				end
			end)
			task.wait(0.3)
			ts:Create(FakeLeg,TweenInfo.new(0.2,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(1,2,1)}):Play()
			ts:Create(weld,TweenInfo.new(0.2,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out,0,false,0),{C0 = CFrame.new(0,0,0)}):Play()
			task.wait(0.2)
			FakeLeg:Destroy()
			local sound2 = rep.Sounds.BasicAttack.Slam:Clone()
			sound2.Parent = hrp
			sound2.Volume = 5
			sound2:Play()
			game.Debris:AddItem(sound2,sound2.TimeLength)
			local Ball = rep.VFX.Characters.Luffy.Ball:Clone()
			Ball.Parent = visuals
			Ball.Size = Vector3.new(1,1,1)
			Ball.CFrame = hrp.CFrame
			ts:Create(Ball,TweenInfo.new(0.35,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(30,30,30),Transparency = 1}):Play()
			task.spawn(function()
				task.wait(0.35)
				Ball:Destroy()
			end)
			local BallBox = rep.VFX.Characters.Luffy.AxeBox:Clone()
			BallBox.Parent = visuals
			BallBox.CFrame = hrp.CFrame
			BallBox.Transparency = 1
			game.Debris:AddItem(BallBox,0.25)
			task.spawn(function()
				DamageBox3(BallBox,"Axed",0.1,char,12,0,0.05,3,5,false,false,false,true,3)
			end)
			task.spawn(function()
				RockModule.Ground2(hrp.Position,15,Vector3.new(2.5,2.5,2.5),12,5,hrp,25,5,90,1,5,0.15)
			end)
			task.wait(0.2)
			cant:Destroy()
			remote:FireClient(plr,"Done1")
		else
			track:Stop()
			remote:FireClient(plr,"Done1")
		end
	end
	if wut == "Bazooka" then
		local track = hum:LoadAnimation(rep.Anims.Luffy.Bazooka)
		track:Play()
		task.wait(0.5)
		if not char:FindFirstChild("Stun") then
			local cant = Instance.new("IntValue",char)
			cant.Name = "StrongArmor"
			char:FindFirstChild("Right Arm").Transparency = 1
			char:FindFirstChild("Left Arm").Transparency = 1
			local sound = rep.Sounds.Luffy.Stretch:Clone()
			sound.Parent = hrp
			sound:Play()
			game.Debris:AddItem(sound,sound.TimeLength)
			local Box = rep.VFX.Boxes.Gatling:Clone()
			Box.Parent = visuals
			Box.CFrame = hrp.CFrame * CFrame.new(0,0,-6)
			Box.Transparency = 1
			local weld2 = Instance.new("Weld",Box)
			weld2.Part0 = hrp
			weld2.Part1 = Box
			weld2.C0 = CFrame.new(0,0,-6)
			game.Debris:AddItem(Box,0.5)
			task.spawn(function()
				task.wait(0.25)
				hum.AutoRotate = false
			end)
			task.spawn(function()
				local FakeArm1 = rep.VFX.Characters.Luffy.FakeArm2:Clone()
				FakeArm1.Parent = visuals
				FakeArm1.CFrame = char:FindFirstChild("Right Arm").CFrame
				FakeArm1.Color = char:FindFirstChild("Right Arm").Color
				local weld1 = Instance.new("Weld",FakeArm1)
				weld1.Part0 = FakeArm1
				weld1.Part1 = char:FindFirstChild("Right Arm")
				ts:Create(FakeArm1,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(1,35,1)}):Play()
				ts:Create(weld1,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{C0 = CFrame.new(0,35/2-1,0)}):Play()
				task.wait(0.3)
				ts:Create(FakeArm1,TweenInfo.new(0.2,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(1,2,1)}):Play()
				ts:Create(weld1,TweenInfo.new(0.2,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out,0,false,0),{C0 = CFrame.new(0,0,0)}):Play()
				task.wait(0.3)
				ts:Create(FakeArm1,TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(1,10,1)}):Play()
				ts:Create(weld1,TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{C0 = CFrame.new(0,10/2-1,0)}):Play()
				task.wait(0.15)
				ts:Create(FakeArm1,TweenInfo.new(0.15,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(1,2,1)}):Play()
				ts:Create(weld1,TweenInfo.new(0.15,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out,0,false,0),{C0 = CFrame.new(0,0,0)}):Play()
				task.wait(0.2)
				FakeArm1:Destroy()
			end)
			task.spawn(function()
				local FakeArm2 = rep.VFX.Characters.Luffy.FakeArm2:Clone()
				FakeArm2.Parent = visuals
				FakeArm2.CFrame = char:FindFirstChild("Left Arm").CFrame
				FakeArm2.Color = char:FindFirstChild("Left Arm").Color
				local weld2 = Instance.new("Weld",FakeArm2)
				weld2.Part0 = FakeArm2
				weld2.Part1 = char:FindFirstChild("Left Arm")
				ts:Create(FakeArm2,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(1,35,1)}):Play()
				ts:Create(weld2,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{C0 = CFrame.new(0,35/2-1,0)}):Play()
				task.wait(0.3)
				ts:Create(FakeArm2,TweenInfo.new(0.2,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(1,2,1)}):Play()
				ts:Create(weld2,TweenInfo.new(0.2,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out,0,false,0),{C0 = CFrame.new(0,0,0)}):Play()
				task.wait(0.3)
				ts:Create(FakeArm2,TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(1,10,1)}):Play()
				ts:Create(weld2,TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{C0 = CFrame.new(0,10/2-1,0)}):Play()
				task.wait(0.15)
				ts:Create(FakeArm2,TweenInfo.new(0.15,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(1,2,1)}):Play()
				ts:Create(weld2,TweenInfo.new(0.15,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out,0,false,0),{C0 = CFrame.new(0,0,0)}):Play()
				task.wait(0.2)
				FakeArm2:Destroy()
			end)
			task.wait(0.5)
			task.spawn(function()
				local wave4 = rep.VFX.Characters.Luffy.Wave2:Clone()
				wave4.Parent = visuals
				wave4.CFrame = hrp.CFrame * CFrame.new(0,0,-5) * CFrame.Angles(math.rad(90),0,0)
				ts:Create(wave4,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(20,2.5,20),Transparency = 1}):Play()
				local wave2 = rep.VFX.Characters.Luffy.Wave2:Clone()
				wave2.Parent = visuals
				wave2.CFrame = hrp.CFrame * CFrame.new(0,0,-10) * CFrame.Angles(math.rad(90),0,0)
				ts:Create(wave2,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(15,2,15),Transparency = 1}):Play()
				task.wait(0.3)
				wave2:Destroy()
				wave4:Destroy()
			end)
			local sound2 = rep.Sounds.Luffy.Bazooka:Clone()
			sound2.Parent = hrp
			sound2:Play()
			game.Debris:AddItem(sound2,sound2.TimeLength)
			task.spawn(function()
				DamageBox4(Box,"Bazooka",0.1,char,13,75,0.3,2,5,false,true,30,true,2)
			end)
			task.wait(0.25)
			cant:Destroy()
			char:FindFirstChild("Right Arm").Transparency = 0
			char:FindFirstChild("Left Arm").Transparency = 0
			hum.AutoRotate = true
			remote:FireClient(plr,"Done2")
		else
			track:Stop()
			remote:FireClient(plr,"Done2")
		end
	end
	if wut == "Bullet" then
		hum:LoadAnimation(rep.Anims.Luffy.PrepareHead):Play()
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
				local HitName = "HeadBut"
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
										remote:FireClient(plr,"Done4")
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
											task.wait(0.1)
											local HeadbutModel = rep.VFX.Characters.Luffy.HeadButParts:Clone()
											HeadbutModel.Parent = visuals
											HeadbutModel.Beam.Color = ColorSequence.new(char:FindFirstChild("Head").Color)
											HeadbutModel.FakeHead.CFrame = char:FindFirstChild("Head").CFrame
											local w2 = Instance.new("Weld",HeadbutModel.FakeHead)
											w2.Part0 = HeadbutModel.FakeHead
											w2.Part1 = char:FindFirstChild("Head")
											HeadbutModel.FakeTorso.CFrame = char:FindFirstChild("Torso").CFrame
											local w3 = Instance.new("Weld",HeadbutModel.FakeTorso)
											w3.Part0 = HeadbutModel.FakeTorso
											w3.Part1 = char:FindFirstChild("Torso")
											local WeldChar = Instance.new("Weld",echar)
											WeldChar.Part0 = ehrp
											WeldChar.Part1 = hrp
											WeldChar.C0 = CFrame.new(0,0,-2.5) * CFrame.Angles(0,math.rad(180),0)
											hum:LoadAnimation(rep.Anims.Luffy.HeadBut):Play()
											task.spawn(function()
												task.wait(1.2)
												local soundStr = rep.Sounds.Luffy.Stretch:Clone()
												soundStr.Parent = hrp
												soundStr:Play()
												game.Debris:AddItem(soundStr,soundStr.TimeLength)
											end)
											task.wait(1.9)
											local bloodpart = game.ServerStorage.Bloodie:Clone()
											game:GetService("Debris"):AddItem(bloodpart,1)
											Massless = false
											ehum.AutoRotate = true
											cant1:Destroy()
											cant2:Destroy()
											WeldChar.C0 = CFrame.new(0,0,0)
											WeldChar:Destroy()
											task.wait(0.1)
											Stun:Destroy()
											task.spawn(function()
												DamageModule:Spec2(char,echar,8,8,0.2,1,4,nil,false,false,false)
												bloodpart.Parent = echar.Head
												bloodpart:Emit(50)
											end)
											remote:FireClient(plr,"Done4")
											HeadbutModel:Destroy()
										else
											remote:FireClient(plr,"Done4")
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
			task.wait(0.2)
			if Grabbed == false then
				Grabbed = true
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
		hum.Health = hum.MaxHealth
		local Aura = true
		local PlayerDied = false
		local track = hum:LoadAnimation(rep.Anims.Luffy.GearSecondo)
		track:Play()
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
		task.wait(1)
		local sound2 = rep.Sounds.Luffy.GearSeconding:Clone()
		sound2.Parent = hrp
		sound2:Play()
		game.Debris:AddItem(sound2,sound2.TimeLength)
		task.spawn(function()
			for i,v in pairs(char:GetChildren()) do
				if v:IsA("BasePart") or v:IsA("MeshPart") then
					local oldColor = v.Color
					ts:Create(v,TweenInfo.new(2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Color = Color3.new(1, 0.701961, 0.937255)}):Play()
					task.spawn(function()
						repeat
							task.wait()
						until Aura == false
						ts:Create(v,TweenInfo.new(2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Color = oldColor}):Play()
					end)
				end
			end
		end)
		task.wait(2)
		local SmokeSound = rep.Sounds.Luffy.Smoke:Clone()
		SmokeSound.Parent = hrp
		SmokeSound:Play()
		local SmokePart = rep.VFX.Characters.Luffy.Smoke:Clone()
		SmokePart.Parent = hrp
		task.spawn(function()
			while Aura do
				SmokePart:Emit(5)
				task.wait(0.1)
			end
		end)
		task.wait(1)
		local sound = rep.Sounds.Luffy.GearSecond:Clone()
		sound.Parent = hrp
		sound:Play()
		game.Debris:AddItem(sound,sound.TimeLength)
		task.wait(2)
		local Theme = rep.Sounds.Luffy.Theme:Clone()
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
				SkillGui.Skill1.Visible = true
				SkillGui.Skill2.Visible = true
				SkillGui.Skill3.Visible = true
				SkillGui.Skill4.Visible = true
				SkillGui.Skill5.Visible = false
				SkillGui.Skill6.Visible = false
				SkillGui.Skill7.Visible = false
				SkillGui.Skill8.Visible = false
				Theme:Destroy()
				game.Debris:AddItem(SmokePart,1)
			end
		end)
		cant:Destroy()
		remote:FireClient(plr,"DoneAwa")
	end
	if wut == "JetPistol" then
		hum:LoadAnimation(rep.Anims.Luffy.JetPistol):Play()
		task.wait(0.5)
		if not char:FindFirstChild("Stun") then
			local sound = rep.Sounds.Luffy.JetPistol:Clone()
			sound.Parent = hrp
			sound.TimePosition = 0.4
			sound:Play()
			game.Debris:AddItem(sound,sound.TimeLength)
			task.spawn(function()
				local Jet1 = rep.VFX.Characters.Luffy.JetPistol:Clone()
				local smokeparticle = game.ServerStorage.Smoke:Clone()
				smokeparticle.Parent = hrp
				smokeparticle:Emit(50)
				game:GetService("Debris"):AddItem(smokeparticle,1)
				Jet1.Parent = visuals
				Jet1.CFrame = hrp.CFrame * CFrame.new(0,0,-3) * CFrame.Angles(math.rad(180),0,math.rad(0))
				local Jet2 = rep.VFX.Characters.Luffy.JetPistolEnd:Clone()
				Jet2.Parent = visuals
				Jet2.CFrame = hrp.CFrame * CFrame.new(0,0,-38) * CFrame.Angles(math.rad(180),0,math.rad(0))
				local JetPunch = rep.VFX.Characters.Luffy.JetPunch:Clone()
				JetPunch.Parent = visuals
				JetPunch.CFrame = hrp.CFrame * CFrame.new(0,0,-38) * CFrame.Angles(math.rad(90),0,0)
				local Beam = rep.VFX.Characters.Luffy.BeamWave:Clone()
				Beam.Parent = visuals
				Beam.CFrame = hrp.CFrame * CFrame.new(0,0,-3) * CFrame.Angles(0,math.rad(90),0)
				ts:Create(Beam,TweenInfo.new(0.1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(35,3,3),CFrame = hrp.CFrame * CFrame.new(0,0,-38/2) * CFrame.Angles(0,math.rad(90),0)}):Play()
				task.spawn(function()
					task.wait(0.1)
					ts:Create(Beam,TweenInfo.new(0.1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(35,0,0),Transparency = 1}):Play()
					task.wait(0.1)
					Beam:Destroy()
				end)
				task.spawn(function()
					ts:Create(JetPunch,TweenInfo.new(0.25,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(10,8,10),Transparency = 1}):Play()
					task.wait(0.25)
					JetPunch:Destroy()
				end)
				task.spawn(function()
					for i,v in pairs(Jet1:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(EA)
							end)
						end
					end
					game.Debris:AddItem(Jet1,2)
				end)
				task.spawn(function()
					for i,v in pairs(Jet2:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(EA)
							end)
						end
					end
					game.Debris:AddItem(Jet2,2)
				end)
			end)
			local KameBox = rep.VFX.Boxes.JetPistol:Clone()
			KameBox.Parent = visuals
			KameBox.CFrame = hrp.CFrame * CFrame.new(0,0,-40/2)
			KameBox.Transparency = 1
			game.Debris:AddItem(KameBox,0.25)
			task.spawn(function()
				DamageBox2(KameBox,"JetPistol",0.1,char,18,80,0.35,1,math.random(6,7),false,true,20,false,false,false)
			end)
			task.wait(0.25)
			remote:FireClient(plr,"Done5")
		else
			remote:FireClient(plr,"Done5")
		end
	end
	if wut == "JetGat" then
		hum:LoadAnimation(rep.Anims.Luffy.PrepareGat):Play()
		task.wait(0.5)
		if not char:FindFirstChild("Stun") then
			local Gatling = true
			local track = hum:LoadAnimation(rep.Anims.Luffy.Gat)
			track:Play()
			char:FindFirstChild("Right Arm").Transparency = 1
			char:FindFirstChild("Left Arm").Transparency = 1
			local JetModel = rep.VFX.Characters.Luffy.JetGatling:Clone()
			JetModel.Parent = visuals
			JetModel.PrimaryPart.CFrame = hrp.CFrame
			local weld = Instance.new("Weld",JetModel)
			weld.Part0 = JetModel.PrimaryPart
			weld.Part1 = hrp
			task.spawn(function()
				while Gatling do
					task.spawn(function()
						DamageBox2(JetModel.MainBox,"Gatling2",0.08,char,0.5,2.5,0.1,0.75,math.random(1,2),false,false,false,false,false)
					end)
					task.wait()
				end
			end)
			task.spawn(function()
				while Gatling do
					task.spawn(function()
						JetModel.JetGat.Attachment.WhiteLine:Emit(2)
					end)
					task.spawn(function()
						JetModel.CirclePart.Circle:Emit(2)
					end)
					task.spawn(function()
						JetModel.RightCircle.Circle:Emit(1)
					end)
					task.spawn(function()
						JetModel.LeftCircle.Circle:Emit(1)
					end)
					task.wait()
				end
			end)
			task.spawn(function()
				while Gatling do
					task.spawn(function()
						local PunSound = rep.Sounds.BasicAttack.PunchSwing:Clone()
						PunSound.Parent = hrp
						PunSound:Play()
						game.Debris:AddItem(PunSound,PunSound.TimeLength)
					end)
					task.wait(0.1)
				end
			end)
			task.spawn(function()
				while Gatling do
					if char:FindFirstChild("Stun") then
						Gatling = false
						track:Stop()
						JetModel:Destroy()
						remote:FireClient(plr,"Done7")
						char:FindFirstChild("Right Arm").Transparency = 0
						char:FindFirstChild("Left Arm").Transparency = 0
					end
					task.wait()
				end
			end)
			task.wait(4)
			if Gatling == true then
				Gatling = false
				track:Stop()
				JetModel:Destroy()
				remote:FireClient(plr,"Done7")
				char:FindFirstChild("Right Arm").Transparency = 0
				char:FindFirstChild("Left Arm").Transparency = 0
			end
		else
			remote:FireClient(plr,"Done7")
		end
	end
	if wut == "RedHawk" then
		local track = hum:LoadAnimation(rep.Anims.Luffy.RedHawk)
		track:Play()
		task.wait(0.5)
		if not char:FindFirstChild("Stun") then
			local cant = Instance.new("IntValue",char)
			cant.Name = "StrongArmor"
			local FakeArm = rep.VFX.Characters.Luffy.RedHawk:Clone()
			FakeArm.Parent = visuals
			FakeArm.CFrame = char:FindFirstChild("Right Arm").CFrame
			local weld = Instance.new("Weld",FakeArm)
			weld.Part0 = FakeArm
			weld.Part1 = char:FindFirstChild("Right Arm")
			char:FindFirstChild("Right Arm").Transparency = 1
			task.spawn(function()
				local Fire = true
				task.spawn(function()
					while Fire do
						FakeArm.Embers:Emit(4)
						task.wait(0.1)
					end
				end)
				local sound = rep.Sounds.Luffy.Stretch:Clone()
				sound.Parent = hrp
				sound:Play()
				game.Debris:AddItem(sound,sound.TimeLength)
				local PrepareRed = rep.Sounds.Luffy.PrepareRed:Clone()
				PrepareRed.Parent = hrp
				PrepareRed:Play()
				game.Debris:AddItem(PrepareRed,PrepareRed.TimeLength)
				ts:Create(FakeArm,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(1,25,1)}):Play()
				ts:Create(weld,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{C0 = CFrame.new(0,25/2-1,0)}):Play()
				ts:Create(FakeArm.LightPart,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(1.1,25.1,1.1)}):Play()
				task.wait(0.8)
				ts:Create(FakeArm,TweenInfo.new(0.2,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(1,2,1)}):Play()
				ts:Create(weld,TweenInfo.new(0.2,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out,0,false,0),{C0 = CFrame.new(0,0,0)}):Play()
				ts:Create(FakeArm.LightPart,TweenInfo.new(0.2,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(1.1,2.1,1.1)}):Play()
				task.wait(0.2)
				local Explode = rep.Sounds.Luffy.RedHawk:Clone()
				Explode.Parent = hrp
				Explode:Play()
				game.Debris:AddItem(Explode,Explode.TimeLength)
				local Explosion = rep.VFX.Characters.Luffy.RedHawkExplosion:Clone()
				Explosion.Parent = visuals
				Explosion.CFrame = hrp.CFrame * CFrame.new(0,0,-1.5)
				local Box = rep.VFX.Boxes.RedHawkBox:Clone()
				Box.Parent = visuals
				Box.CFrame = hrp.CFrame * CFrame.new(0,0,-20)
				Box.Transparency = 1
				game.Debris:AddItem(Box,0.2)
				task.spawn(function()
					DamageBox5(Box,"RedHawk",0.1,char,20,90,0.3,1,5,false,true,30,false,false)
				end)
				task.spawn(function()
					for i,v in pairs(Explosion:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(EA)
							end)
						end
					end
					game.Debris:AddItem(Explosion,2)
				end)
				Fire = false
				FakeArm:Destroy()
				char:FindFirstChild("Right Arm").Transparency = 0
			end)
			task.wait(1.2)
			cant:Destroy()
			remote:FireClient(plr,"Done8")
		else
			track:Stop()
			remote:FireClient(plr,"Done8")
		end
	end
	if wut == "JetBazooka" then
		hum:LoadAnimation(rep.Anims.Luffy.JetBazooka):Play()
		task.wait(0.45)
		if not char:FindFirstChild("Stun") then
			local sound = rep.Sounds.Luffy.JetPistol:Clone()
			local smokeparticle = game.ServerStorage.Smoke:Clone()
			smokeparticle.Parent = hrp
			smokeparticle:Emit(50)
			game:GetService("Debris"):AddItem(smokeparticle,1)
			sound.Parent = hrp
			sound.TimePosition = 0.4
			sound:Play()
			game.Debris:AddItem(sound,sound.TimeLength)
			task.spawn(function()
				local Jet1 = rep.VFX.Characters.Luffy.JetPistol:Clone()
				Jet1.Parent = visuals
				Jet1.CFrame = hrp.CFrame * CFrame.new(3,0,-3) * CFrame.Angles(math.rad(180),0,math.rad(0))
				local Jet2 = rep.VFX.Characters.Luffy.JetPistolEnd:Clone()
				Jet2.Parent = visuals
				Jet2.CFrame = hrp.CFrame * CFrame.new(3,0,-38) * CFrame.Angles(math.rad(180),0,math.rad(0))
				local JetPunch = rep.VFX.Characters.Luffy.JetPunch:Clone()
				JetPunch.Parent = visuals
				JetPunch.CFrame = hrp.CFrame * CFrame.new(3,0,-38) * CFrame.Angles(math.rad(90),0,0)
				local Beam = rep.VFX.Characters.Luffy.BeamWave:Clone()
				Beam.Parent = visuals
				Beam.CFrame = hrp.CFrame * CFrame.new(3,0,-3) * CFrame.Angles(0,math.rad(90),0)
				ts:Create(Beam,TweenInfo.new(0.1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(35,3,3),CFrame = hrp.CFrame * CFrame.new(3,0,-38/2) * CFrame.Angles(0,math.rad(90),0)}):Play()
				task.spawn(function()
					task.wait(0.1)
					ts:Create(Beam,TweenInfo.new(0.1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(35,0,0),Transparency = 1}):Play()
					task.wait(0.1)
					Beam:Destroy()
				end)
				task.spawn(function()
					ts:Create(JetPunch,TweenInfo.new(0.25,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(10,8,10),Transparency = 1}):Play()
					task.wait(0.25)
					JetPunch:Destroy()
				end)
				task.spawn(function()
					for i,v in pairs(Jet1:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(EA)
							end)
						end
					end
					game.Debris:AddItem(Jet1,2)
				end)
				task.spawn(function()
					for i,v in pairs(Jet2:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(EA)
							end)
						end
					end
					game.Debris:AddItem(Jet2,2)
				end)
			end)
			task.spawn(function()
				local Jet1 = rep.VFX.Characters.Luffy.JetPistol:Clone()
				Jet1.Parent = visuals
				Jet1.CFrame = hrp.CFrame * CFrame.new(-3,0,-3) * CFrame.Angles(math.rad(180),0,math.rad(0))
				local Jet2 = rep.VFX.Characters.Luffy.JetPistolEnd:Clone()
				Jet2.Parent = visuals
				Jet2.CFrame = hrp.CFrame * CFrame.new(-3,0,-38) * CFrame.Angles(math.rad(180),0,math.rad(0))
				local JetPunch = rep.VFX.Characters.Luffy.JetPunch:Clone()
				JetPunch.Parent = visuals
				JetPunch.CFrame = hrp.CFrame * CFrame.new(-3,0,-38) * CFrame.Angles(math.rad(90),0,0)
				local Beam = rep.VFX.Characters.Luffy.BeamWave:Clone()
				Beam.Parent = visuals
				Beam.CFrame = hrp.CFrame * CFrame.new(-3,0,-3) * CFrame.Angles(0,math.rad(90),0)
				ts:Create(Beam,TweenInfo.new(0.1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(35,3,3),CFrame = hrp.CFrame * CFrame.new(-3,0,-38/2) * CFrame.Angles(0,math.rad(90),0)}):Play()
				task.spawn(function()
					task.wait(0.1)
					ts:Create(Beam,TweenInfo.new(0.1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(35,0,0),Transparency = 1}):Play()
					task.wait(0.1)
					Beam:Destroy()
				end)
				task.spawn(function()
					ts:Create(JetPunch,TweenInfo.new(0.25,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(10,8,10),Transparency = 1}):Play()
					task.wait(0.25)
					JetPunch:Destroy()
				end)
				task.spawn(function()
					for i,v in pairs(Jet1:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(EA)
							end)
						end
					end
					game.Debris:AddItem(Jet1,2)
				end)
				task.spawn(function()
					for i,v in pairs(Jet2:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							spawn(function()
								local EA = v:GetAttribute("EmitCount")
								v:Emit(EA)
							end)
						end
					end
					game.Debris:AddItem(Jet2,2)
				end)
			end)
			local KameBox = rep.VFX.Boxes.JetBazooka:Clone()
			KameBox.Parent = visuals
			KameBox.CFrame = hrp.CFrame * CFrame.new(0,0,-40/2)
			KameBox.Transparency = 1
			game.Debris:AddItem(KameBox,0.25)
			task.spawn(function()
				DamageBox2(KameBox,"JetBazooka",0.1,char,18,80,0.35,1,math.random(6,7),false,true,20,false,false,false)
			end)
			task.wait(0.2)
			remote:FireClient(plr,"Done6")
		else
			remote:FireClient(plr,"Done6")
		end
	end
end)