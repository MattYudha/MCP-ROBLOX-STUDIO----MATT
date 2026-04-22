local rep = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")
local remote = rep:WaitForChild("Remotes"):WaitForChild("Deku")
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

remote.OnServerEvent:Connect(function(plr, wut, MousePos)
	local char = plr.Character
	if not char then return end
	local hum = char:WaitForChild("Humanoid")
	local hrp = char:WaitForChild("HumanoidRootPart")
	local visuals = workspace:WaitForChild("Visuals"..plr.UserId)
	char.Archivable = true
	------------------------------------------------------------

	local function CounterCheck(echar)
		if not echar:FindFirstChild("UltraSense") and not echar:FindFirstChild("HoraCounter") and not echar:FindFirstChild("ManjiCounter") then
			return true
		else
			return false
		end
	end

	local function RagDoll(echar, ragTime)
		if not echar:FindFirstChild("Block") then
			if not echar:FindFirstChild("Ragdolling") then
				local Ragdolling = Instance.new("IntValue", echar)
				Ragdolling.Name = "Ragdolling"
				game.Debris:AddItem(Ragdolling, ragTime)
				local TooClose = Instance.new("IntValue", echar)
				TooClose.Name = "TooClose"
				game.Debris:AddItem(TooClose, ragTime + 0.25)
				task.spawn(function()
					RagdollModule:Start(echar)
				end)
				task.spawn(function()
					repeat task.wait() until not echar:FindFirstChild("Ragdolling")
					task.spawn(function()
						RagdollModule:Stop(echar)
					end)
				end)
			else
				local Ragdolling = Instance.new("IntValue", echar)
				Ragdolling.Name = "Ragdolling"
				game.Debris:AddItem(Ragdolling, ragTime)
				local TooClose = Instance.new("IntValue", echar)
				TooClose.Name = "TooClose"
				game.Debris:AddItem(TooClose, ragTime + 0.25)
			end
		end
	end

	local function CheckDown(echar)
		return not echar:FindFirstChild("Ragdolling")
	end

	local function DamageBox(box, HitName, HitTime, pchar, dmg, Power, PT, ST, combo, breakAmount, Up, High, ragdoll, ragTime, DirPush)
		local params = OverlapParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.MaxParts = 0
		params.FilterDescendantsInstances = {box, visuals}

		task.spawn(function()
			for _, hit in pairs(workspace:GetPartsInPart(box, params)) do
				local echar = hit.Parent
				if echar:FindFirstChild("Humanoid") and echar:FindFirstChild("Humanoid").Health > 0 then
					if echar ~= char and not echar:FindFirstChild("HyperArmor") and not echar:FindFirstChild("StrongArmor") and CheckDown(echar) then
						if not echar:FindFirstChild(HitName) then
							local GetHit = Instance.new("IntValue")
							GetHit.Parent = echar
							GetHit.Name = HitName
							game.Debris:AddItem(GetHit, HitTime)
							local ehum = echar:FindFirstChild("Humanoid")
							local ehrp = echar:FindFirstChild("HumanoidRootPart")
							if echar:FindFirstChild("Block") then
								local lookVector = echar.HumanoidRootPart.CFrame.LookVector
								local Position = hrp.Position - echar.HumanoidRootPart.Position
								if (lookVector:Dot(Position)) < 0 then
									echar:FindFirstChild("Block"):Destroy()
								end
							end
							task.spawn(function()
								DamageModule:Spec(pchar, echar, dmg, Power, PT, ST, combo, breakAmount, Up, High, false, false, DirPush)
							end)
							task.spawn(function()
								if ragdoll then
									RagDoll(echar, ragTime)
								end
							end)
						end
					end
				end
			end
		end)
	end

	------------------------------------------------------------
	-- Detroit Smash - heavy downward punch with shockwave
	if wut == "DetroitSmash" then
		local track = hum:LoadAnimation(rep.Anims.Deku.DetroitSmash)
		track:Play()
		task.wait(0.4)
		if not char:FindFirstChild("Stun") then
			local sound = rep.Sounds.Deku.Smash:Clone()
			sound.Parent = hrp
			sound:Play()
			game.Debris:AddItem(sound, sound.TimeLength)
			camShake:FireClient(plr, "ShakeOnce")
			local box = rep.VFX.Boxes.NormalPunch:Clone()
			box.Parent = visuals
			box.CFrame = hrp.CFrame * CFrame.new(0, 0, -3)
			box.Transparency = 1
			local w = Instance.new("Weld", box)
			w.Part0 = box
			w.Part1 = hrp
			w.C0 = CFrame.new(0, 0, -3)
			game.Debris:AddItem(box, 0.15)
			DamageBox(box, "DetroitHit", 0.1, char, 18, 80, 0.3, 2.5, nil, nil, false, false, true, 2.5, nil)
			RockModule.Front(hrp, 3, 0.15, 10, true, 0.1, 0.05, 1, 4, 0)
			task.wait(0.5)
		else
			track:Stop()
		end
		remote:FireClient(plr, "Done1")

	-- Delaware Smash - rapid finger flick shockwave
	elseif wut == "DelawareSmash" then
		local track = hum:LoadAnimation(rep.Anims.Deku.DelawareSmash)
		track:Play()
		task.wait(0.25)
		if not char:FindFirstChild("Stun") then
			camShake:FireClient(plr, "ShakeOnce")
			local sound = rep.Sounds.Deku.Flick:Clone()
			sound.Parent = hrp
			sound:Play()
			game.Debris:AddItem(sound, sound.TimeLength)
			local box = rep.VFX.Boxes.FastBox:Clone()
			box.Parent = visuals
			box.CFrame = hrp.CFrame * CFrame.new(0, 0, -5)
			box.Transparency = 1
			box.Size = Vector3.new(8, 6, 12)
			game.Debris:AddItem(box, 0.1)
			DamageBox(box, "DelawareHit", 0.1, char, 12, 50, 0.15, 1.5, nil, nil, false, false, true, 1.5, nil)
			task.wait(0.4)
		else
			track:Stop()
		end
		remote:FireClient(plr, "Done2")

	-- Shoot Style - rapid kicks combo
	elseif wut == "ShootStyle" then
		local track = hum:LoadAnimation(rep.Anims.Deku.ShootStyle)
		track:Play()
		track:GetMarkerReachedSignal("Kick"):Connect(function()
			if not char:FindFirstChild("Stun") then
				local box = rep.VFX.Boxes.NormalPunch:Clone()
				box.Parent = visuals
				box.CFrame = hrp.CFrame * CFrame.new(0, 0, -2.5)
				box.Transparency = 1
				local w = Instance.new("Weld", box)
				w.Part0 = box
				w.Part1 = hrp
				w.C0 = CFrame.new(0, 0, -2.5)
				game.Debris:AddItem(box, 0.1)
				DamageBox(box, "KickHit", 0.1, char, 8, 30, 0.1, 1, nil, nil, false, false, false, 0, nil)
				local sound = rep.Sounds.Deku.Kick:Clone()
				sound.Parent = hrp
				sound:Play()
				game.Debris:AddItem(sound, sound.TimeLength)
			end
		end)
		task.wait(2)
		if char:FindFirstChild("Stun") then
			track:Stop()
		end
		remote:FireClient(plr, "Done3")

	-- Smash Awakened (One For All Full Cowl burst)
	elseif wut == "FullCowl" then
		local track = hum:LoadAnimation(rep.Anims.Deku.FullCowl)
		track:Play()
		task.wait(0.3)
		if not char:FindFirstChild("Stun") then
			camShake:FireClient(plr, "ShakeOnce")
			LightingRemote:FireClient(plr, "GreenFlash")
			local SmashBox = rep.VFX.Boxes.FastBox:Clone()
			SmashBox.Parent = visuals
			SmashBox.CFrame = hrp.CFrame * CFrame.new(0, 0, -4)
			SmashBox.Transparency = 1
			SmashBox.Size = Vector3.new(12, 10, 16)
			game.Debris:AddItem(SmashBox, 0.15)
			DamageBox(SmashBox, "FullCowlHit", 0.1, char, 25, 120, 0.5, 3, nil, nil, true, 40, true, 3.5, nil)
			RockModule.Front(hrp, 6, 0.25, 25, true, 0.15, 0.05, 1, 6, 0)
			task.wait(0.6)
		else
			track:Stop()
		end
		remote:FireClient(plr, "Done4")

	-- Awaken (One For All: 20% Full Release)
	elseif wut == "Awaken" then
		if not char:FindFirstChild("Awakened") then
			local AwakenTag = Instance.new("IntValue", char)
			AwakenTag.Name = "Awakened"
			local track = hum:LoadAnimation(rep.Anims.Deku.Awaken)
			track:Play()
			camShake:FireClient(plr, "ShakeOnce")
			LightingRemote:FireClient(plr, "GreenAwaken")
			local bv = Instance.new("BodyVelocity", hrp)
			bv.MaxForce = Vector3.new(1,1,1) * 1e9
			bv.Velocity = Vector3.new(0, 50, 0)
			bv.P = 1e9
			game.Debris:AddItem(bv, 0.25)
			task.wait(1)
			remote:FireClient(plr, "DoneAwaken")
		end
	end
	------------------------------------------------------------
end)
