AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Gut Gib"
ENT.Spawnable = false
ENT.AdminOnly = false

function ENT:Initialize()
    if SERVER then
        local ragdollGuts = ents.Create("prop_ragdoll")
        if not IsValid(ragdollGuts) then return end

    	self:SetModel("models/1_stalker_extra_gore/guts.mdl")
        ragdollGuts:SetPos(self:GetPos())
        ragdollGuts:SetAngles(self:GetAngles())
        ragdollGuts:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        ragdollGuts:Spawn()

        local phys = ragdollGuts:GetPhysicsObject()
        if IsValid(phys) then
            phys:ApplyForceCenter(Vector(0, 0, 300)) 
        end

        timer.Simple(math.Rand(30, 60), function()
            if IsValid(ragdollGuts) then ragdoll:Remove() end
        end)
        self:Remove()
    end
end
