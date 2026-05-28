EFFECT.MainMat = Material("effects/spark") //Material("effects/strider_tracer")
EFFECT.GlowMat = Material("sprites/light_glow02_add")
local heatwaveMat = Material("sprites/heatwave")
function EFFECT:Init(data)
    self.StartPos = data:GetStart()
    self.EndPos = data:GetOrigin()
    self.RandomScale = math.Rand(0.75, 1.15)
    self.colorBeam = Color(math.random(180, 255), math.random(160, 224), math.random(59, 190)) Color(255,224,182)
    local ent = data:GetEntity()
    local att = data:GetAttachment()
    local locPly = LocalPlayer()

    if GetConVar("vj_stalker_tracer_crack"):GetInt() == 1 then
        sound.Play("vj_randoms_shared_wep/crack/med_crack_0" .. math.random(1, 9) .. ".ogg",self.EndPos, math.random(85, 115), math.random(85, 110))
    end 

    self.Dir = self.EndPos - self.StartPos
    self:SetRenderBoundsWS(self.StartPos, self.EndPos)
    self.TracerTime = math.min(1, self.StartPos:Distance(self.EndPos) / 10000) -- Calculate death time
    self.Length = math.Rand(0.05, 0.15)
    self.DieTime = CurTime() + self.TracerTime
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
    local fDelta = (self.DieTime - CurTime()) / self.TracerTime
    fDelta = math.Clamp(fDelta, 0, 1)
    local tracerPos = LerpVector(1 - fDelta, self.StartPos, self.EndPos)

    if GetConVar("vj_stalker_tracer_glow"):GetInt() == 1 then
	local dlight = DynamicLight(self:EntIndex() + 1000) 
        if dlight then
            dlight.pos = tracerPos
            dlight.r = self.colorBeam.r
            dlight.g = self.colorBeam.g
            dlight.b = self.colorBeam.b
            dlight.brightness = math.Rand(1, 5)
            dlight.Decay = math.Rand(55, 300)
            dlight.Size = math.Rand(45, 120)
            dlight.DieTime = CurTime() + math.Rand(1, 5.5)
        end
    end

    if CurTime() > self.DieTime then
        if not self.ImpactLightCreated and GetConVar("vj_stalker_tracer_imp_light"):GetInt() == 1 then
            self.ImpactLightCreated = true

            local dlight = DynamicLight(self:EntIndex())
            if dlight then
                dlight.pos = self.EndPos
                dlight.r = self.colorBeam.r
                dlight.g = self.colorBeam.g
                dlight.b = self.colorBeam.b
                dlight.brightness = math.Rand(1, 3)
                dlight.Decay = math.Rand(150, 350)
                dlight.Size = math.Rand(10, 35)
                dlight.DieTime = CurTime() + 0.01
            end
        end
        return false
    end
    return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render()

    -- Main tracer body. 
    local fDelta = (self.DieTime - CurTime()) / self.TracerTime
    fDelta = math.Clamp(fDelta, 0, 1) ^ math.Rand(0.2, 0.5)
    render.SetMaterial(self.MainMat)
    local sinWave = math.sin(fDelta * math.pi)
    render.DrawBeam(
		self.EndPos - self.Dir * (fDelta - sinWave * self.Length),
		self.EndPos - self.Dir * (fDelta + sinWave * self.Length), math.Rand(0.5, 5) + sinWave * math.Rand(0.2, 1), math.Rand(0.2, 1), 0, self.colorBeam)

    -- Glowing Tip
    local tipPos = self.EndPos - self.Dir * (fDelta - sinWave * self.Length)
    if GetConVar("vj_stalker_tracer_tip_light"):GetInt() == 1 then 	
        render.SetMaterial(self.GlowMat)
        render.DrawSprite(tipPos, math.Rand(1.5, 6) * self.RandomScale, math.Rand(1.5, 6) * self.RandomScale ,self.colorBeam)
    end 

    -- Heatwave
    render.SetMaterial(heatwaveMat)
    render.DrawBeam(self.EndPos - self.Dir * (fDelta - sinWave * self.Length),self.EndPos - self.Dir * (fDelta + sinWave * self.Length), math.Rand(0.5, 2), 0, 1, Color(255, 255, 255, 150))
end