hook.Add("PlayerDeath", "VJ_Stalker_ResetEffects", function(ply)
    if not IsValid(ply) then return end

    -- DSP cleanup
    if ply.VJ_Stalker_DSPActive then
        ply:SetDSP(0)
        ply.VJ_Stalker_DSPActive = nil
    end

    -- Knockdown cleanup
    if ply.VJ_Stalker_KnockedDown then
	local defJumpPwr = ply:GetJumpPower()
        ply:ConCommand("-duck")
        ply:SetJumpPower(200)
        ply.VJ_Stalker_KnockedDown = nil
    end
end)