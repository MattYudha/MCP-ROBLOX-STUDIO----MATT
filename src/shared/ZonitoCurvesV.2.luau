local ZC = {}
ZC.__index = ZC

local BZ_NUM_SAMPLE_POINTS = 1000
local BZ_ARC_RADIUS = 20
local BULLET_VELOCITY = 20.0
local BULLET_MAX_LIFETIME = 60.0


local Signal = require(script.Parent.Signal)

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

export type ZonitoSettings = {
	
	CurveType : String;
	Projectile : Instance;
	StartPosition : Vector3;
	EndPosition : Vector3;
	KeyPoints : KeyPoints;
	Speed : Number;
	Lifetime  : Number
}

export type KeyPoints = {
	
	Key1 : Vector3;
	Key2 : Vector3;
	Key3 : Vector3
	
}

function lerp(a, b, c) -- Linear interpolation 

	return a + (b - a) * c

end

local function QuadraticBezier(t : number, p0 : Vector3, p1 : Vector3, p2 : Vector3) -- math.

	return (1-t)^2*p0+2*(1-t)*t*p1+t^2*p2

end

function cubicBezier(t, p0, p1, p2, p3) -- uhh math yeah

	local l1 = lerp(p0, p1, t)
	local l2 = lerp(p1, p2, t)
	local l3 = lerp(p2, p3, t)

	local a = lerp(l1, l2, t)
	local b = lerp(l2, l3, t)

	local cubic = lerp(a, b, t)

	return cubic

end

function cubicBzLength(p0, p1, p2, p3) -- uhhh more math..?!

	local calcLength = function(n, func, ...)

		local sum, ranges, sums = 0, {}, {}

		for i = 0, n-1 do

			local p1, p2 = func(i/n, ...), func((i+1)/n, ...)

			local dist = (p2 - p1).magnitude

			ranges[sum] = {dist, p1, p2}

			table.insert(sums, sum)

			sum = sum + dist

		end

		return sum, ranges, sums

	end

	local sum = calcLength(BZ_NUM_SAMPLE_POINTS, cubicBezier, p0, p1, p2, p3)

	return sum

end

function ZC.Create(Info : ZonitoSettings)
	
	--+ Checking for errors +--
	assert((string.lower(Info.CurveType) == "quadratic" or "cubic" or "cubic2"),"ZonitoCurves only supports 'Quadratic' 'Cubic' or 'Cubic2' type curves. Invalid curve type. (1)")
	assert((#Info.KeyPoints<2),"ZonitoCurves requires at least one keypoint to be provided. (4)")
	if (Info.Speed > 0.99) then warn("ZonitoCurves works best with Speed under 1. Automatically adjusting to fix this issue.") end
	
	local self = setmetatable({},ZC)
	
	self.Projectile = Info.Projectile
	
	self.StartPosition = Info.StartPosition
	self.EndPosition = Info.EndPosition
	
	self.Key1 = Info.KeyPoints.Key1
	self.Key2 = Info.KeyPoints.Key2
	self.Key3 = Info.KeyPoints.Key3
	
	self.PlaySpeed = Info.Speed
	self.Lifetime = Info.Lifetime
	
	if (Info.Speed > 0.99) then
		
		if (Info.Speed > 100) then
			
			self.PlaySpeed = (Info.Speed/10000)
			
		elseif (Info.Speed > 1000) then
			
			self.PlaySpeed = (Info.Speed/100000)
			
		elseif (Info.Speed > 10000) then
			
			self.PlaySpeed = (Info.Speed/1000000) -- PLEASE FOR THE LOVE OF GOD DONT SET YOYR SPOEED THIS HIGH YOU WEIRDO 😭
			
		else
			
			self.PlaySpeed = (Info.Speed/100)
			
		end
		
	end
	
	--+ Events +--
	self.Started = Signal.new()
	self.Finished = Signal.new()
	self.Moved = Signal.new()
	self.Cancelled = Signal.new()
	self.Paused = Signal.new()
	self.Resumed = Signal.new()
	self.LifetimeEnded = Signal.new()

	self.curvetype = Info.CurveType
	
	self.Status = "Empty"
	self.Debounce = false
	
	self.AutomatedSpeed = (self.PlaySpeed*1000)
	
	return self
	
end

function ZC:Start()
	
	assert(not (self.Status == "Curving"),"ZonitoCurves is already curving this projectile! (2)")
	assert(not (self.Status == "Cancelled"),"ZonitoCurves cannot start a curve that is already cancelled. (3)")
	
	task.spawn(function()
		
		if (string.lower(self.curvetype) == "quadratic") then
			
			self.Started:Fire()
			self.Status = "Curving"
			
			task.spawn(function()
				
				repeat self.Lifetime=-1 task.wait(1) until self.Lifetime == 0
				self.LifetimeEnded:Fire(self.Projectile)
				
			end)
			
			local KeyPoint = (self.StartPosition + self.EndPosition)/2+self.Key1
			
			for i = 0,1,self.PlaySpeed do
				if (self.Status == "Paused") then repeat task.wait() until (self.Status == "Curving") end
				if (self.Status == "Cancelled") then return end
				
				local Path = QuadraticBezier(i,self.StartPosition,self.Key1,self.EndPosition)
				
				self.Projectile.Position = Path
				
				self.Moved:Fire(self.Projectile)
				
				task.wait()
				
			end
			
			self.Finished:Fire(self.Projectile)
			self.Status = "Empty"
			
		elseif (string.lower(self.curvetype) == "cubic") then
			
			self.Started:Fire()
			self.Status = "Curving"
			
			
			local bullet = self.Projectile
			
			self.Debounce = false
			
			-- calculate the path
			local startingCFrame = CFrame.new(self.StartPosition,self.EndPosition)
			local targetCFrame = CFrame.new(self.EndPosition,self.StartPosition)

			-- calculate the control points as Vector3s
			-- p1 and p2 will be right angles to the starting and ending positions, but rotated based on input
			local p0 = (startingCFrame).Position
			local p1 = (startingCFrame + (startingCFrame:ToWorldSpace(CFrame.Angles(0, 0, math.rad(self.Key1.Y))).RightVector * BZ_ARC_RADIUS)).Position
			local p2 = (targetCFrame + (targetCFrame:ToWorldSpace(CFrame.Angles(0, 0, math.rad(-self.Key1.Y))).RightVector * -BZ_ARC_RADIUS)).Position -- EUW MATH
			local p3 = (targetCFrame).Position

			-- calculate the length of the curve
			local distance = cubicBzLength(p0, p1, p2, p3) -- Distance in studs

			-- Calculate length / time
			local totalTime = distance / (self.AutomatedSpeed or BULLET_VELOCITY) -- Time in seconds
			local startingTime = tick()
			
			self.Started:Fire(self.Projectile)
			
			-- Localization
			local connection -- naming it connection cus im so creative

			connection = RunService.Heartbeat:Connect(function(step)

				-- calculate the percentage complete based on how much time has passed
				local passedTime = tick() - startingTime
				local alpha = passedTime / totalTime

				-- Moving the projectile
				local updatedPos = cubicBezier(alpha, p0, p1, p2, p3) -- Alpha = %
				bullet.Position = updatedPos
				
				self.Moved:Fire(self.Projectile)
				
				if  totalTime > (self.Lifetime or BULLET_MAX_LIFETIME) then
					if self.Debounce == false then
						self.Debounce = true
						
						task.delay(self.Lifetime,function()

							connection:Disconnect()
							self.Status = "Empty"
							self.LifetimeEnded:Fire(self.Projectile)
							
							return "Lifetime ended"

						end)
					end

				end

				if alpha > 1 then -- Once the curve ends, or the projectile runs out of time...


					connection:Disconnect() -- Stop

					self.Finished:Fire(self.Projectile)
					self.Status = "Empty"
					
					return "Curve finished" -- In your script you can check for this being returned, then do hitboxes or whatever
				end
			end)
		elseif (string.lower(self.curvetype) == "cubic2") then
			local Projectile = self.Projectile
			Projectile.Position = self.StartPosition
			local KeyPoint1 = (self.StartPosition + self.EndPosition) / 2 + self.Key1
			local KeyPoint2 = (self.StartPosition + self.EndPosition) / 2 + self.Key2
			local KeyPoint3 = (self.StartPosition + self.EndPosition) / 2 + self.Key3
			task.spawn(function()
				repeat self.Lifetime=-1 task.wait(1) until self.Lifetime == 0
				self.LifetimeEnded:Fire(self.Projectile)
			end)
			self.Started:Fire(self.Projectile)
			self.Status = "Curving"
			for i = 0,1,self.PlaySpeed do -- Keep speed under 0.05 pls
				if (self.Status == "Paused") then repeat task.wait() until (self.Status == "Curving") end
				if (self.Status == "Cancelled") then return end
				local One=lerp(self.StartPosition,KeyPoint1,i) -- ok i literally cba to explain whats going on here so um
				local Two=lerp(KeyPoint1,self.EndPosition,i) -- math is happening ok
				local Three=lerp(KeyPoint2,self.EndPosition,i)
				local Four=lerp(KeyPoint3,self.EndPosition,i)
				local One_Two=lerp(One,Two,i)
				local Two_Two=lerp(Two,Three,i)
				local Three_Two=lerp(Three,Four,i)
				local One_Three=lerp(One_Two,Two_Two,i)
				local Two_Three=lerp(Two_Two,Three_Two,i)
				local Path=lerp(One_Three,Two_Three,i)
				Projectile.Position = Path -- yes and it moves projectile to that position. yes.
				self.Moved:Fire(self.Projectile)
				task.wait() -- do NNOT REMOVE THE GOSH DARN WAIT PLS
			end
			self.Finished:Fire(self.Projectile)
			self.Status = "Empty"
			return "Curve finished"
		end
	end)
end
function ZC:PauseCurve()
	if (self.Status == "Curving")then 
		self.Status = "Paused"
		self.Paused:Fire()
	end
end
function ZC:ResumeCurve()
	if (self.Status == "Paused") then
		self.Status = "Curving"
		self.Resumed:Fire()
	end
end
function ZC:Cancel()
	if (self.Status ~= "Cancelled") then
		self.Status = "Cancelled"
		self.Cancelled:Fire()
	end
end
function ZC:GetStatus()
	return (self.Status)
end
function ZC:ChangeProperty(PropertyName : String, Value)
	if self[PropertyName] then
		print(self[PropertyName])
		self[PropertyName] = Value
		print(self[PropertyName])
	end
end
return ZC
