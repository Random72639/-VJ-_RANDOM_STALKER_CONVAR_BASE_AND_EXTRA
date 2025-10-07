local matSmoke = Material("particle/particle_smokegrenade")
function EFFECT:Init(data)
    self.Position = self:GetTracerShootPos(data:GetOrigin(), data:GetEntity(), data:GetAttachment())
    self.Normal   = data:GetNormal()
    self.LifeTime = self.Duration

    local emitter = ParticleEmitter(self.Position)
    if emitter then
        for i = 1, 6 do
            local particle = emitter:Add(matSmoke:GetName(), self.Position + self.Normal * 2)
            particle:SetVelocity((self.Normal + VectorRand() * 0.2):GetNormal() * math.Rand(5, 150))
            particle:SetDieTime(math.Rand(0.5, 1.5))
            particle:SetStartAlpha(math.Rand(50, 180))
            particle:SetEndAlpha(0)
            particle:SetStartSize(math.Rand(1, 15))
            particle:SetEndSize(math.Rand(5, 20))
            particle:SetRoll(math.Rand(0, 360))
            particle:SetRollDelta(math.Rand(-0.5, 0.5))
            local c = math.Rand(180, 220)
            particle:SetColor(c, c, c)
            particle:SetAirResistance(150)
            particle:SetGravity(Vector(0, 0, math.Rand(5, 15))) 
        end
        emitter:Finish()
    end
end

function EFFECT:Think()
end

function EFFECT:Render()
end
