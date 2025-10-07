AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Intestine Gib"
ENT.Spawnable = false
ENT.AdminOnly = false

function ENT:Initialize()
    if SERVER then
        local ragdoll = ents.Create("prop_ragdoll")
        if not IsValid(ragdoll) then return end

        ragdoll:SetModel("models/1_stalker_extra_gore/intestines.mdl") 
        ragdoll:SetPos(self:GetPos())
        ragdoll:SetAngles(self:GetAngles())
        ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        ragdoll:Spawn()

        local phys = ragdoll:GetPhysicsObject()
        if IsValid(phys) then
            phys:ApplyForceCenter(Vector(0, 0, 300)) 
        end

        timer.Simple(math.Rand(30, 60), function()
            if IsValid(ragdoll) then ragdoll:Remove() end
        end)
        self:Remove()
    end
end
