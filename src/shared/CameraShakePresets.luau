-- Camera Shake Presets
-- Stephen Leitnick
-- February 26, 2018

--[[
	
	CameraShakePresets.Bump
	CameraShakePresets.Explosion
	CameraShakePresets.Earthquake
	CameraShakePresets.BadTrip
	CameraShakePresets.HandheldCamera
	CameraShakePresets.Vibration
	CameraShakePresets.RoughDriving
	
--]]



local CameraShakeInstance = require(script.Parent.CameraShakeInstance)

local CameraShakePresets = {
	Buildup = function()
		local c = CameraShakeInstance.new(.5, 4, 0.2, 1.5)
		c.PositionInfluence = Vector3.new(0,0,0)
		c.RotationInfluence = Vector3.new(1, 1, 1)
		return c
	end;
	Circle = function()
		local c = CameraShakeInstance.new(.5, 10, 0.01, .8)
		c.PositionInfluence = Vector3.new(0,0,0)
		c.RotationInfluence = Vector3.new(1, 1, 1)
		return c
	end;
	PurpleProjectile = function()
		local c = CameraShakeInstance.new(1, 15, 0.01, .3)
		c.PositionInfluence = Vector3.new(0,0,0)
		c.RotationInfluence = Vector3.new(1, 0, 1)
		return c
	end;
	HammerImpact = function()
		local c = CameraShakeInstance.new(2, 15, 0.01, .8)
		c.PositionInfluence = Vector3.new(0,0,0)
		c.RotationInfluence = Vector3.new(1, 1, 1)
		return c
	end;
	Hit = function()
		local c = CameraShakeInstance.new(1, 15, 0, .3)
		c.PositionInfluence = Vector3.new(0,0,0)
		c.RotationInfluence = Vector3.new(1, 0, 1)
		return c
	end;
	SpawnTwo = function()
		local c = CameraShakeInstance.new(.25, 1, 0, 1)
		c.PositionInfluence = Vector3.new(0,0,0)
		c.RotationInfluence = Vector3.new(1, 1, 1)
		return c
	end;
	SpawnFX = function()
		local c = CameraShakeInstance.new(.25, 5, 0, .25)
		c.PositionInfluence = Vector3.new(0,0,0)
		c.RotationInfluence = Vector3.new(1, 1, 1)
		return c
	end;

	ExplosionFX = function()
		local c = CameraShakeInstance.new(1, .3, 0, 1)
		c.PositionInfluence = Vector3.new(0, 0, 0)
		c.RotationInfluence = Vector3.new(1, 1, 1)
		return c
	end;
	custom2 = function()
		local c = CameraShakeInstance.new(.6, 1, 0.1, 0.75)
		c.PositionInfluence = Vector3.new(0.1, 0.1, 0.16)
		c.RotationInfluence = Vector3.new(.3,.23,.3)
		return c
	end;
	custom3 = function()
		local c = CameraShakeInstance.new(1.5, 3, 0.15, 0.8)
		c.PositionInfluence = Vector3.new(0.7, 0.52, 0.52)
		c.RotationInfluence = Vector3.new(.41,.31,.351)
		return c
	end;
	custom = function()
		local c = CameraShakeInstance.new(.5, 1, 0.2, 0.75)
		c.PositionInfluence = Vector3.new(0.1, 0.1, 0.1)
		c.RotationInfluence = Vector3.new(.5,.5,.5)
		return c
	end;
	-- An intense and rough shake.
	-- Should happen once.
	Explosion = function()
		local c = CameraShakeInstance.new(5, 10, 0, 1.5)
		c.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
		c.RotationInfluence = Vector3.new(4, 1, 1)
		return c
	end;
	
	
	-- A continuous, rough shake
	-- Sustained.
	Earthquake = function()
		local c = CameraShakeInstance.new(0.6, 3.5, 2, 10)
		c.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
		c.RotationInfluence = Vector3.new(1, 1, 4)
		return c
	end;
	
	
	-- A bizarre shake with a very high magnitude and low roughness.
	-- Sustained.
	BadTrip = function()
		local c = CameraShakeInstance.new(10, 0.15, 5, 10)
		c.PositionInfluence = Vector3.new(0, 0, 0.15)
		c.RotationInfluence = Vector3.new(2, 1, 4)
		return c
	end;
	
	
	-- A subtle, slow shake.
	-- Sustained.
	HandheldCamera = function()
		local c = CameraShakeInstance.new(1, 0.25, 5, 10)
		c.PositionInfluence = Vector3.new(0, 0, 0)
		c.RotationInfluence = Vector3.new(1, 0.5, 0.5)
		return c
	end;
	
	
	-- A very rough, yet low magnitude shake.
	-- Sustained.
	Vibration = function()
		local c = CameraShakeInstance.new(0.4, 20, 2, 2)
		c.PositionInfluence = Vector3.new(0, 0.15, 0)
		c.RotationInfluence = Vector3.new(1.25, 0, 4)
		return c
	end;
	
	
	-- A slightly rough, medium magnitude shake.
	-- Sustained.
	RoughDriving = function()
		local c = CameraShakeInstance.new(1, 2, 1, 1)
		c.PositionInfluence = Vector3.new(0, 0, 0)
		c.RotationInfluence = Vector3.new(1, 1, 1)
		return c
	end;
	
	
}


return setmetatable({}, {
	__index = function(t, i)
		local f = CameraShakePresets[i]
		if (type(f) == "function") then
			return f()
		end
		error("No preset found with index \"" .. i .. "\"")
	end;
})