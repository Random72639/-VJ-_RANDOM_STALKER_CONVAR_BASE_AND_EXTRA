/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/

-- Base effect was taken from DrVrej's VJ Base addon.

function EFFECT:Init(data)
	local origin = data:GetOrigin()
	local emitter = ParticleEmitter(origin)
	local rnd = math.random(3, 9) 

	local useGray = math.random(1, 2) == 1
	local grayColors = {Color(100, 100, 100),Color(120, 120, 120),Color(90, 90, 90),Color(110, 110, 110),Color(80, 80, 80)}

	local brownColors = {Color(80, 60, 20),Color(100, 70, 30),Color(90, 65, 25),Color(110, 75, 40),Color(95, 60, 30)}

	local colorPool = useGray and grayColors or brownColors

	for _ = 1, rnd do
		local dust = emitter:Add("particles/smokey", origin)
		if dust then
			dust:SetVelocity(Vector(math.random(-45, 45), math.random(-45, 45), math.random(5, 15)))
			dust:SetDieTime(math.Rand(2, 10))
			dust:SetStartAlpha(140)
			dust:SetEndAlpha(0)
			dust:SetStartSize(math.Rand(5, 15))    
			dust:SetEndSize(math.Rand(15, 35))     
			dust:SetRoll(math.Rand(180, 360))
			dust:SetRollDelta(math.Rand(-0.3, 0.3))
			dust:SetColor((table.Random(colorPool)):Unpack())
			dust:SetGravity(Vector(0, 0, math.random(-5,5)))
			dust:SetAirResistance(25)
			dust:SetCollide(true)
		end
	end

	emitter:Finish()
end

---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render() end -- To avoid "ERROR" from appearing for single tick