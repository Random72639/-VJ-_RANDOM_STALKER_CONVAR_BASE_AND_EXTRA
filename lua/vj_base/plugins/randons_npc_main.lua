/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
VJ.AddPlugin("Random's S.T.A.L.K.E.R. Base", "NPC")

	// -- Required Addons! -- \\
        if SERVER then
        resource.AddWorkshop("131759821") -- VJ Base --
        resource.AddWorkshop("3252071421") -- Random's edited Bsmod animations --
    	resource.AddWorkshop("2052642961") -- Particle resource addon 
        end

	// -- Menu -- \\
	local AddConvars = {}
        -- Faction convars
	AddConvars["vj_stalker_mil_faction_friendly"] = 1 -- Military faction friendly?

        -- Abilities and functions convars
	AddConvars["vj_stalker_reposition_while_reloading"] = 1 -- Move and reload?
	AddConvars["vj_stalker_death_anim"] = 1 -- Death animations?
	AddConvars["vj_stalker_dent_dodge_requires_visibility"] = 1 -- Dodging dangerous ents vis check?
	AddConvars["vj_stalker_death_ex_crpse_phys"] = 1 -- Extra death physics?
	AddConvars["vj_stalker_death_finger_manip"] = 1 -- Death finger manipulation?
	AddConvars["vj_stalker_gib"] = 1 -- Gibbing ability?
        AddConvars["vj_stalker_taunt"] = 1 -- Taunting ability?
        AddConvars["vj_stalker_incapacitated"] = 1 -- Being downed ability?
        AddConvars["vj_stalker_weapon_switching"] = 1 -- Weapon switch ability?
        AddConvars["vj_stalker_fire_react"] = 1 -- Fire burn mechanic?
        AddConvars["vj_stalker_death_anims"] = 1 -- Death anims?
        AddConvars["vj_stalker_dodging"] = 1 -- Dodging?
        AddConvars["vj_stalker_wep_flashlight"] = 1 -- Flashlight?
        AddConvars["vj_stalker_gren_trail"] = 1 -- Grenade trail?
        AddConvars["vj_stalker_avoid_ply_crosshair"] = 1 -- Avoid ply crosshair?
        AddConvars["vj_stalker_fire_flares"] = 1 -- Fire flares on alert?
        AddConvars["vj_stalker_fire_quick_flares"] = 1 -- Fire quick flares?
        AddConvars["vj_stalker_throw_flares"] = 1 --Throw flares?
        AddConvars["vj_stalker_place_flares"] = 1 -- Place flares?
        AddConvars["vj_stalker_place_flares_ally_check"] = 1 -- Flare ally check?
        AddConvars["vj_stalker_place_flares_ally_vis_check"] = 1 -- Flare ally vis check?
        AddConvars["vj_stalker_cus_ragdoll_blood"] = 1 -- Custom ragdoll blood?
        AddConvars["vj_stalker_shovedback"] = 1 -- Shove back mechanic?
        AddConvars["vj_stalker_kickdoor"] = 1 -- Door kick?
        AddConvars["vj_stalker_brutal_pain_vo"] = 1 -- Brutal Pain?
        AddConvars["vj_stalker_brutal_death_vo"] = 1 -- Brutal Death?
        AddConvars["vj_stalker_brutal_cry_vo"] = 1 -- Brutal cry for help?
        AddConvars["vj_stalker_fire_dmg_vo"] = 1 -- Specific fire damage sounds?
        AddConvars["vj_stalker_passively_dodge_incom_danger"] = 1 -- Avoid incoming danger?
        AddConvars["vj_stalker_never_forget"] = 1 -- Never reset on enemy?
	AddConvars["vj_stalker_armor_ricochet"] = 1 -- Armor richochet?
	AddConvars["vj_stalker_gib_death_sounds"] = 1 -- Unique death sound before gibbing?
        AddConvars["vj_stalker_armored_helmet"] = 1 -- Arm helm?
        AddConvars["vj_stalker_breakable_helmet"] = 1 -- Arm helm break?
        AddConvars["vj_stalker_helm_prev_dmg"] = 1 -- Arm helm no dmg?
        AddConvars["vj_stalker_headshot_insa_kill"] = 1 -- Instand headshot death?
        AddConvars["vj_stalker_headshot_sfx"] = 1 -- Headshot sound effects?
        AddConvars["vj_stalker_headshot_fx"] = 1 -- Headshot effects?
	AddConvars["vj_stalker_headshot_gore_sound"] = 1 -- Has gore sound?
	AddConvars["vj_stalker_headshot_kill_chance"] = 1 -- In-Kill chance?
	AddConvars["vj_stalker_headshot_min_dmg_check"] = 1 -- mindmg check?
        AddConvars["vj_stalker_disable_headshot_death_anim"] = 1 -- Headshot death anim?
        AddConvars["vj_stalker_radio_chatter"] = 1 -- Radio chatter?
        AddConvars["vj_stalker_can_lean"] = 1 -- Leaning mechanic?
        AddConvars["vj_stalker_lp_wep"] = 1 -- Leaning point comes from weapon?
        AddConvars["vj_stalker_limited_grenades"] = 1 -- Limited grenade count?
        AddConvars["vj_stalker_lm_tr_vj_creature"] = 1 -- Lone member trigger at VJ creatures?
        AddConvars["vj_stalker_flash_blind_fri"] = 1 -- Flashlight blind friendly SNPCs?
        AddConvars["vj_stalker_flash_blind_ene"] = 1 -- Flashlight blind hostile SNPCs?
        AddConvars["vj_stalker_jump_land_particles"] = 1 -- Jump landing particles?
        AddConvars["vj_stalker_extended_delay"] = 1 -- Make SNPC take longer to shoot ?
        AddConvars["vj_stalker_red_grenade_trail"] = 1 -- More obvious grenades ?
        AddConvars["vj_stalker_snpc_view_angle"] = 177 -- Change SNPC's view angle?
        AddConvars["vj_stalker_npc_copy_ply_stance"] = 1 -- Stance copy?
        AddConvars["vj_stalker_coughing"] = 1 -- Coughing?
        AddConvars["vj_stalker_armor_spark"] = 1 -- Armor sparking?
        AddConvars["vj_stalker_ges_flinch"] = 1 -- Layered ges flinching?
        AddConvars["vj_stalker_shove_wall_collide"] = 1 -- Collide into wall when shoved?
        AddConvars["vj_stalker_looting"] = 1 -- Can loot?
        AddConvars["vj_stalker_rng_combat_var_times"] = 1 -- Rng var times?
        AddConvars["vj_stalker_flatline"] = 1 -- Flatline?
        AddConvars["vj_stalker_ele_death_fx"] = 1 -- Ele death fx?
        AddConvars["vj_stalker_corpse_dissolve"] = 1 -- Corpse dissolve?
        AddConvars["vj_stalker_inst_corpse_dissolve"] = 1 -- Instantly dissolve corpse?
        AddConvars["vj_stalker_corpse_dissolve_wep"] = 1 -- Corpse dissolve weapon?
        AddConvars["vj_stalker_cus_wep_tracer"] = 0 -- Cus wep tracer?
        AddConvars["vj_stalker_override_all_wep_tracers"] = 0 -- All tracers?
        AddConvars["vj_stalker_tracer_imp_light"] = 0 -- Imp light?
        AddConvars["vj_stalker_tracer_glow"] = 0 -- Subtle light?
        AddConvars["vj_stalker_tracer_tip_light"] = 0 -- Tip light?
        AddConvars["vj_stalker_tracer_crack"] = 0 -- Tracer crack?
        AddConvars["vj_stalker_fire_smoke"] = 0 -- Smoke?
        AddConvars["vj_stalker_cus_wep_muz_flash"] = 0 -- Muz flash?
        AddConvars["vj_stalker_drop_seq_wep"] = 0 -- Secondary weapon?
        AddConvars["vj_stalker_body_twitching"] = 0 -- PM Twitching?
        AddConvars["vj_stalker_body_writhe"] = 0 -- Body writhe?
        AddConvars["vj_stalker_min_dmg_cap"] = 0 -- Dmg cap (min)? 
        AddConvars["vj_stalker_min_dmg_cap_sfx"] = 0 -- Dmg cap (min) sfx? 
        AddConvars["vj_stalker_panic_after_dmg"] = 1 -- Dmg panic? 
        AddConvars["vj_stalker_ron_death_sounds"] = 1 -- Death snd? 
        AddConvars["vj_stalker_dmg_cancel_dial"] = 1 -- Dmg cancel? 

        // Extra Credits \\
	-- ["pekena_larva"] - Free jump grunt & landing sounds

	for k, v in pairs(AddConvars) do
		if !ConVarExists( k ) then CreateConVar( k, v, {FCVAR_ARCHIVE} ) end
	end

	if CLIENT then
	local function VJ_RSTLK_MENU_MAIN(Panel)
		if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
			Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
			Panel:ControlHelp("#vjbase.menu.general.admin.only")
			return
		end		
		Panel:AddControl( "Label", {Text = "Notice: Only admins can change this settings."})
                Panel:AddControl("Button",{Text = "#vjbase.menu.general.reset.everything", Command = "vj_stalker_dmg_cancel_dial 0\n vj_stalker_ron_death_sounds 0\n vj_stalker_panic_after_dmg 1\n vj_stalker_min_dmg_cap_sfx 0\n vj_stalker_min_dmg_cap 0\n vj_stalker_body_writhe 1\n vj_stalker_body_twitching 1\n vj_stalker_drop_seq_wep 1\n vj_stalker_breakable_helmet 1\n vj_stalker_helm_prev_dmg 1\n vj_stalker_armored_helmet 1\n vj_stalker_tracer_crack 0\n vj_stalker_fire_smoke 0\n vj_stalker_tracer_tip_light 0\n vj_stalker_tracer_glow 0\n vj_stalker_tracer_imp_light 0\n vj_stalker_cus_wep_muz_flash 0\n vj_stalker_override_all_wep_tracers 0\n vj_stalker_cus_wep_tracer 0\n vj_stalker_inst_corpse_dissolve 0\n vj_stalker_corpse_dissolve_wep 0\n vj_stalker_corpse_dissolve 0\n vj_stalker_ele_death_fx 1\n vj_stalker_flatline 1\n vj_stalker_headshot_min_dmg_check 1\n vj_stalker_headshot_kill_chance 3\n vj_stalker_rng_combat_var_times 1\n vj_stalker_place_flares_ally_vis_check 1\n vj_stalker_place_flares_ally_check 1\n vj_stalker_looting 1\n vj_stalker_npc_copy_ply_stance 1\n vj_stalker_shove_wall_collide 1\n vj_stalker_ges_flinch 1\n vj_stalker_armor_spark 1\n vj_stalker_coughing 1\n vj_stalker_snpc_view_angle 177\n vj_stalker_reposition_while_reloading 1\n vj_stalker_headshot_gore_sound 1\n vj_stalker_dent_dodge_requires_visibility 1\n vj_stalker_death_ex_crpse_phys 1\n vj_stalker_death_finger_manip 1\n vj_stalker_red_grenade_trail 1\n vj_stalker_extended_delay 1\n vj_stalker_throw_flares 1\n vj_stalker_cus_ragdoll_blood 1\n vj_stalker_place_flares 1\n vj_stalker_fire_quick_flares 1\n vj_stalker_jump_land_particles 1\n vj_stalker_flash_blind_fri 1\n vj_stalker_flash_blind_ene 1\n vj_stalker_lm_tr_vj_creature 1\n vj_stalker_limited_grenades 1\n vj_stalker_lp_wep 1\n vj_stalker_radio_chatter 1\n vj_stalker_headshot_sfx 1\n vj_stalker_disable_headshot_death_anim 1\n vj_stalker_gib_death_sounds 1\n vj_stalker_armor_ricochet 1\n vj_stalker_headshot_fx 1\n vj_stalker_headshot_insa_kill 1\n vj_stalker_never_forget 1\n vj_stalker_passively_dodge_incom_danger 1\n vj_stalker_brutal_cry_vo 1\n vj_stalker_fire_dmg_vo 1\n vj_stalker_brutal_death_vo 0\n vj_stalker_brutal_pain_vo 0\n vj_stalker_kickdoor 1\n vj_stalker_shovedback 1\n vj_stalker_fire_flares 1\n vj_stalker_avoid_ply_crosshair 1\n vj_stalker_gren_trail 1\n vj_stalker_wep_flashlight 1\n vj_stalker_dodging 1\n vj_stalker_death_anims 1\n vj_stalker_fire_react 1\n vj_stalker_mil_faction_friendly 1\n vj_stalker_weapon_switching 1\n vj_stalker_gib 1\n vj_stalker_taunt 1\n vj_stalker_incapacitated 1 "})

		//Panel:AddControl("Checkbox", {Label = "?", Command = ""}) -- 
		//Panel:ControlHelp(".") 

		Panel:AddControl("Checkbox", {Label = "Allow damage to cancel/interupt idle dialogue?", Command = "vj_stalker_dmg_cancel_dial"}) -- dmg cancel
		Panel:ControlHelp("If enabled, if an SNPC is playing some idle dialogue, any damage will interupt/cancel it.") 

		Panel:AddControl("Checkbox", {Label = "Allow Ready or Not death sounds?", Command = "vj_stalker_ron_death_sounds"}) -- Ready Or Not SFX 
		Panel:ControlHelp("Adds ready or not death sounds to the death sound table.") 

		Panel:AddControl("Checkbox", {Label = "Panic after being damaged?", Command = "vj_stalker_panic_after_dmg"}) -- Panic
		Panel:ControlHelp("An extra function where SNPCs are more likely to re-position or find cover after damage.") 

		Panel:AddControl("Checkbox", {Label = "Minimum damage cap?", Command = "vj_stalker_min_dmg_cap"}) -- MD-Cap
		Panel:ControlHelp("Allows the minimum damage cap to be active, meaning you have to do more than 'x' amount of damage to deal anything, ranging from 3 - 8 only.")

		Panel:AddControl("Checkbox", {Label = "Minimum damage cap sfx feedback?", Command = "vj_stalker_min_dmg_cap_sfx"}) -- MD-Cap Sfx
		Panel:ControlHelp("Allow small audio feedback everytime the minimum dmg cap is triggered.")

		Panel:AddControl("Checkbox", {Label = "Allow post-mortem twitching?", Command = "vj_stalker_body_twitching"}) -- Body twitching
		Panel:ControlHelp("After some time the SNPC is killed, there is a chance for their body to start twitching.")

		Panel:AddControl("Checkbox", {Label = "Allow corpse writhing?", Command = "vj_stalker_body_writhe"}) -- Body writhing
		Panel:ControlHelp("When an SNPC is killed, their body may twitch or roll around before fully dying .")

		Panel:AddControl("Checkbox", {Label = "Random timers for certain behaviours?", Command = "vj_stalker_rng_combat_var_times"}) -- Rng var T's
		Panel:ControlHelp("This allows for random durations to be allocated for the enemy occlusion behaviour, strafe timers, and combat damage response timers.")

		Panel:AddControl("Checkbox", {Label = "Allow picking up loot?", Command = "vj_stalker_looting"}) -- Looting 
		Panel:ControlHelp("Allows the SNPCs to pick up certain ents when idle, like the default hl2 ammo ents.")

		Panel:AddControl("Checkbox", {Label = "Friendly SNPC's copy player stance when following?", Command = "vj_stalker_npc_copy_ply_stance"}) -- Follow copy
		Panel:ControlHelp("This allows the SNPC to copy the players stance/crouch when the player is crouched.")

		Panel:AddControl("Checkbox", {Label = "Allow coughing?", Command = "vj_stalker_coughing"}) -- Coughing
		Panel:ControlHelp("Allows SNPC's to play a coughing sound when they are hit with certain toxic dmg types.")

		Panel:AddControl("Checkbox", {Label = "Armor sparking?", Command = "vj_stalker_armor_spark"}) -- Arm spark
		Panel:ControlHelp("Chance for spark/armor impact effect to play when damaged by bullets.")

		Panel:AddControl("Checkbox", {Label = "Allow armor ricocheting?", Command = "vj_stalker_armor_ricochet"}) -- Armor rocochet
		Panel:ControlHelp("This will enable the feature where there is a chance a bullet may richochet of the SNPC when shot.")

		Panel:AddControl("Checkbox", {Label = "Layered gesture flinching?", Command = "vj_stalker_ges_flinch"}) -- Ges flinch
		Panel:ControlHelp("Chance for flinch gesture animation to play whenever damaged, seperate from regular flinching.")

		Panel:AddControl("Checkbox", {Label = "Allowed to be shoved back?", Command = "vj_stalker_shovedback"}) -- Shoved back 
		Panel:ControlHelp("This allows the SNPCs to have the ability to be knocked back.")

		Panel:AddControl("Checkbox", {Label = "Collide into walls when shoved?", Command = "vj_stalker_shove_wall_collide"}) -- Wall collide
		Panel:ControlHelp("Allows the SNPC's to collide into walls, props, or other npcs when shoved.")

		Panel:AddControl("Slider",{Label = "SNPC's view angle.", min = 1, max = 360, Command = "vj_stalker_snpc_view_angle"})
		Panel:ControlHelp("Change the SNPC's view angle/fov.")

		Panel:AddControl("Checkbox", {Label = "Reposition whilst reloading?", Command = "vj_stalker_reposition_while_reloading"}) -- Move & reload
		Panel:ControlHelp("This allows the SNPC the chance to reload and move to a new position at the same time.")

		Panel:AddControl("Checkbox", {Label = "Dodging dangerous entities requires visibility?", Command = "vj_stalker_dent_dodge_requires_visibility"}) -- Dodg d-ent vis check 
		Panel:ControlHelp("This makes it so a visibility check of the dangerous entity is required before the SNPC can dodge the dangerous entity.")

		Panel:AddControl("Checkbox", {Label = "Extra corpse death physics?", Command = "vj_stalker_death_ex_crpse_phys"}) -- Death corpse extra physics
		Panel:ControlHelp("This applies extra random regular and angular velocity.")

		Panel:AddControl("Checkbox", {Label = "Corpse finger manipulation?", Command = "vj_stalker_death_finger_manip"}) -- Death finger manip
		Panel:ControlHelp("When the SNPC's corpse is spawned, their finger bones will be manipulated to different angles.")

		Panel:AddControl("Checkbox", {Label = "Extended fire delay?", Command = "vj_stalker_extended_delay"}) -- Ext delay
		Panel:ControlHelp("This makes it so the SNPC's take longer to shoot.")

		Panel:AddControl("Checkbox", {Label = "Red grenade trails?", Command = "vj_stalker_red_grenade_trail"}) -- Red gren trail
		Panel:ControlHelp("This makes the SNPC's thrown grenades more obvious as it attaches a red trail to them.")

		Panel:AddControl("Checkbox", {Label = "Can the SNPC's throw flares?", Command = "vj_stalker_throw_flaress"}) -- Throw flares
		Panel:ControlHelp("This controls the ability for the SNPC's to throw flares at the enemies positions.")

		Panel:AddControl("Checkbox", {Label = "Can the SNPC's fire quick flares?", Command = "vj_stalker_fire_quick_flares"}) -- Firing flares
		Panel:ControlHelp("This controls the ability for the SNPC's to fire flares at the enemies positions.")

		Panel:AddControl("Checkbox", {Label = "Can the SNPC's place down flares whilst in combat?", Command = "vj_stalker_place_flares"}) -- Flare placing
		Panel:ControlHelp("This allows the SNPC's fo place down flares when in combat.")

		Panel:AddControl("Checkbox", {Label = "Combat flare placement requires allies?", Command = "vj_stalker_place_flares_ally_check"}) -- Flare place ally check
		Panel:ControlHelp("Enables a check that makes it so the SNPC must have nearby allies before placing down a flare.")

		Panel:AddControl("Checkbox", {Label = "Place flare ally visibility check?", Command = "vj_stalker_place_flares_ally_vis_check"}) -- Flare place ally vis check
		Panel:ControlHelp("Enables a check to make sure the allies detected before placing a flare are visible.")

		Panel:AddControl("Checkbox", {Label = "Do the SNPC's ragdolls have custom ragdoll blood?", Command = "vj_stalker_cus_ragdoll_blood"}) -- Ragdoll blood
		Panel:ControlHelp("This enables custom ragdoll blood/effects when the SNPC's ragdolls are damaged.")

		Panel:AddControl("Checkbox", {Label = "Jump landing particles?", Command = "vj_stalker_jump_land_particles"}) -- Landing particles
		Panel:ControlHelp("This allows particles to appear when an SNPC lands after jumping.")

		Panel:AddControl("Checkbox", {Label = "Flashlight blind friendly SNPCs?", Command = "vj_stalker_flash_blind_fri"}) -- Flashlight blind friednly SNPCs
		Panel:ControlHelp("This allows the players flashlight to blind the friendly SNPCs.")

		Panel:AddControl("Checkbox", {Label = "Flashlight blind enemy SNPCs?", Command = "vj_stalker_flash_blind_ene"}) -- Flashlight blind enemy SNPCs
		Panel:ControlHelp("This allows the players flashlight to blind the enemy SNPCs.")

		Panel:AddControl("Checkbox", {Label = "Lone member behavior trigger towards VJ Creatures?", Command = "vj_stalker_lm_tr_vj_creature"}) -- Lone member behavior apply to VJ Creatures
		Panel:ControlHelp("This enables/disables the SNPCs lone member behavior apply to VJ creatures.")

		Panel:AddControl("Checkbox", {Label = "Enable limited grenade count?", Command = "vj_stalker_limited_grenades"}) -- Grenade count
		Panel:ControlHelp("Makes it so the SNPC's don't have an infinite stock of grenades.")

		Panel:AddControl("Checkbox", {Label = "Enable leaning?", Command = "vj_stalker_can_lean"}) -- Leaning
		Panel:ControlHelp("Allows the SNPCs to lean around corners to when engaging an enemy.")

		Panel:AddControl("Checkbox", {Label = "[Somewhat buggy] Lp comes from active weapon?", Command = "vj_stalker_lp_wep"}) -- Lp
		Panel:ControlHelp("Makes it so the trace start point comes from the SNPCs weapons muzzle.")

		Panel:AddControl("Checkbox", {Label = "Enable radio chatter?", Command = "vj_stalker_radio_chatter"}) -- Radio chatter
		Panel:ControlHelp("This will enable/disable some SNPCs having radios, where you can hear radio chatter coming through them.")

		Panel:AddControl("Checkbox", {Label = "Unique death sounds when being gibbed?", Command = "vj_stalker_gib_death_sounds"}) -- Gib death sounds
		Panel:ControlHelp("This will enable specific unique death sounds when gibbed.")

		Panel:AddControl("Checkbox", {Label = "Can the SNPCs evade certain dangerous incoming entities?", Command = "vj_stalker_passively_dodge_incom_danger"}) -- Dodge incoming dangerous ents 
		Panel:ControlHelp("This will allow the SNPCs to roll to the left or right if detecting certain dangerous entities.")

		Panel:AddControl("Checkbox", {Label = "Allowed to forget enemies?", Command = "vj_stalker_never_forget"}) -- Never reset on enemy
		Panel:ControlHelp("This will make it so the SNPCs won't forget an enemies existance if they are out of sight for too long.")

		Panel:AddControl("Checkbox", {Label = "Instantly kill SNPCs on a headshot?", Command = "vj_stalker_headshot_insa_kill"}) -- Instant headshot
		Panel:ControlHelp("This makes it so if the SNPCs are shot in the head, they will instantly die.")

		Panel:AddControl("Checkbox", {Label = "Allowed to have effects when headshoted?", Command = "vj_stalker_headshot_fx"}) -- Headshot effects
		Panel:ControlHelp("Allows certain effects to occur when the SNPC is headshoted.") 

		Panel:AddControl("Checkbox", {Label = "Enable minimum damage requirement for headshot instakilling?", Command = "vj_stalker_headshot_min_dmg_check"}) -- min dmg check
		Panel:ControlHelp("Controls whether the min damage check is acknowledged in the headshot instakill code.")

		Panel:AddControl("Checkbox", {Label = "Enable headshot sound effects?", Command = "vj_stalker_headshot_sfx"}) -- Headshot sfx
		Panel:ControlHelp("This will enable/disable the headshot sfx.")

		Panel:AddControl("Slider",{Label = "Headshot instakill chacne.", min = 1, max = 100, Command = "vj_stalker_headshot_kill_chance"})
		Panel:ControlHelp("This scroller changes the chance the SNPC is instantly killeld via a headhshot.")

		Panel:AddControl("Checkbox", {Label = "Disable headshot death anims?", Command = "vj_stalker_disable_headshot_death_anim"}) -- Headshot death anim
		Panel:ControlHelp("This will disable the chance for specific headshot death anims, making the SNPCs a bit more realistic.")

		Panel:AddControl("Checkbox", {Label = "Headshot death gore sound effect?", Command = "vj_stalker_headshot_gore_sound"}) -- Hs gore sound
		Panel:ControlHelp("Allows gore sound effect to play when the SNPC is killed via a headshot.")

		Panel:AddControl("Checkbox", {Label = "Allowed to have brutal cry for help vo?", Command = "vj_stalker_brutal_cry_vo"}) --  Brutal cry vo
		Panel:ControlHelp("Switches the default cry for help sounds to more brutal ones.")

		Panel:AddControl("Checkbox", {Label = "Fire specific pain sounds?", Command = "vj_stalker_fire_dmg_vo"}) --  Fire pain vo
		Panel:ControlHelp("Allows the SNPCs to have specific/unique pain sounds when damaged with fire.")

		Panel:AddControl("Checkbox", {Label = "Allowed to have brutal pain vo?", Command = "vj_stalker_brutal_pain_vo"}) --  Brutal pain vo
		Panel:ControlHelp("Switches the SNPCs pain/hurt sound vo to new more brutal ones.")

		Panel:AddControl("Checkbox", {Label = "Allowed to have brutal death vo?", Command = "vj_stalker_brutal_death_vo"}) --  Brutal death vo
		Panel:ControlHelp("Switches the SNPCs death/killed sound vo to more brutal vo.")

		Panel:AddControl("Checkbox", {Label = "Allowed to kick down doors?", Command = "vj_stalker_kickdoor"}) -- Kick door
		Panel:ControlHelp("This allows the SNPCs to have the ability to kick down the doors.")

		Panel:AddControl("Checkbox", {Label = "Allowed to fire flares?", Command = "vj_stalker_fire_flares"}) -- Fire flares 
		Panel:ControlHelp("This allows the SNPCs to fire flares.")

		Panel:AddControl("Checkbox", {Label = "Avoid player crosshair?", Command = "vj_stalker_avoid_ply_crosshair"}) -- Avoid ply crosshair 
		Panel:ControlHelp("This allows the SNPCs to move to a new position when players crosshair is on them for too long.")

		Panel:AddControl("Checkbox", {Label = "Do the SNPCs grenades have a trail?", Command = "vj_stalker_gren_trail"}) -- Grenade trail 
		Panel:ControlHelp("This allows the SNPCs grenades to have trails.")

		Panel:AddControl("Checkbox", {Label = "Have weapon flashlight?", Command = "vj_stalker_wep_flashlight"}) -- Wep flashlight 
		Panel:ControlHelp("This allows the SNPCs to have a flashlight entity emitted from the muzzle of their weapon.")

		Panel:AddControl("Checkbox", {Label = "allowed to have death animations?", Command = "vj_stalker_death_anims"}) -- Death animations 
		Panel:ControlHelp("This allows the SNPCs to have death animations.")

		Panel:AddControl("Checkbox", {Label = "Allowed to dodge?", Command = "vj_stalker_dodging"}) -- Dodging 
		Panel:ControlHelp("This allows the SNPCs to have the ability to dodge.")

		Panel:AddControl("Checkbox", {Label = "Can they react to fire?", Command = "vj_stalker_fire_react"}) -- Fire reaction 
		Panel:ControlHelp("This allows the SNPCs to react to fire like Combine soldiers.")

		Panel:AddControl("Checkbox", {Label = "Is the Military faction friendly to the player?", Command = "vj_stalker_mil_faction_friendly"}) -- Friendly military
		Panel:ControlHelp("This allows the military faction to be friendly to the player, and their allies.")

		Panel:AddControl("Checkbox", {Label = "Can the SNPCs be gibbed?", Command = "vj_stalker_gib"}) -- Gibbing ability
		Panel:ControlHelp("This allows the SNPCs to be gibbed from certain damage types.")

		Panel:AddControl("Checkbox", {Label = "Can The SNPCs taunt", Command = "vj_stalker_taunt"}) -- Taunting system
		Panel:ControlHelp("This allows the NPCs to taunt after killing an enemy.")
                
                Panel:AddControl("Checkbox", {Label = "Can The SNPCs be incapacitated?", Command = "vj_stalker_incapacitated"}) -- Downing system
		Panel:ControlHelp("This allows the SNPCs to be incapacitated under certain conditions.")

                Panel:AddControl("Checkbox", {Label = "Can The SNPCs switch to a secondary weapon?", Command = "vj_stalker_weapon_switching"}) -- Weapon switching
		Panel:ControlHelp("This allows the SNPCs to be able to switch to a secondary weapon under certain conditions.")

		Panel:AddControl("Checkbox", {Label = "Audible death flatline?", Command = "vj_stalker_flatline"}) -- Flatline
		Panel:ControlHelp("This allows a flatline sound to play for certain SNPCs when killed.")

		Panel:AddControl("Checkbox", {Label = "Electrical death effects?", Command = "vj_stalker_ele_death_fx"}) -- Electrical death fx
		Panel:ControlHelp("For certain SNPCs, when killed, special electrical death effects will come from their corpse.")

		Panel:AddControl("Checkbox", {Label = "Corpse dissolving?", Command = "vj_stalker_corpse_dissolve"}) -- Corpse dissolving
		Panel:ControlHelp("Allows SNPC's corpse dissolve after some time.")

		Panel:AddControl("Checkbox", {Label = "Instantly dissolve corpse?", Command = "vj_stalker_inst_corpse_dissolve"}) -- Inst diss crpse
		Panel:ControlHelp("Allows certain specific NPCs to be instantly dissolved when killed.")

		Panel:AddControl("Checkbox", {Label = "Corpse dissolve sequence include weapon?", Command = "vj_stalker_corpse_dissolve_wep"}) -- Diss crpse wep
		Panel:ControlHelp("This makes it so during the corpse dissolve sequence, the NPCs weapon is also dissolved.")

		Panel:AddControl("Checkbox", {Label = "Alternative muzzle flash (Custom Weapons)?", Command = "vj_stalker_cus_wep_muz_flash"}) -- Custom weapons (Mine)
		Panel:ControlHelp("This changes the default muzzle flash particles to a different one. This convar only affects custom VJ Base weapons made by me.")

		Panel:AddControl("Checkbox", {Label = "Override all default VJ bullet tracers?", Command = "vj_stalker_override_all_wep_tracers"}) -- All tracers
		Panel:ControlHelp("Any VJ Base weapon equiped by my SNPCs will use the custom tracer effects made by me.")

		Panel:AddControl("Checkbox", {Label = "Custom tracer impact dynamic light?", Command = "vj_stalker_tracer_imp_light"}) -- Imp light
		Panel:ControlHelp("Allows short impact light to appear from where the tracers impact.")

		Panel:AddControl("Checkbox", {Label = "Override custom weapon bullet tracers?", Command = "vj_stalker_cus_wep_tracer"}) -- Specific tracers 
		Panel:ControlHelp("Overrides the default bullet tracer effects with custom ones made by me, but only affects my custom VJ NPC weapons.")

		Panel:AddControl("Checkbox", {Label = "Tracer subtle glow?", Command = "vj_stalker_tracer_glow"}) -- Glow light
		Panel:ControlHelp("Dynamic light that follows tracer.")

		Panel:AddControl("Checkbox", {Label = "Weapon fire smoke?", Command = "vj_stalker_fire_smoke"}) -- Smoke
		Panel:ControlHelp("This adds more weapon smoke when firing. This is for cinematic purposes. This only affects my custom weapons.")

		Panel:AddControl("Checkbox", {Label = "Tracer bullet crack?", Command = "vj_stalker_tracer_crack"}) -- Crack
		Panel:ControlHelp("This adds bullet crack sound to the tracers.")

		Panel:AddControl("Checkbox", {Label = "Tracer tip glow?", Command = "vj_stalker_tracer_tip_light"}) -- Tip light
		Panel:ControlHelp("Small point at tracers tip.")

		Panel:AddControl("Checkbox", {Label = "Drop secondary weapon on death?", Command = "vj_stalker_drop_seq_wep"}) -- Drop seq weapon
		Panel:ControlHelp("When killed, the SNPC will also drop their secondary weapon they had saved in their inventory.")

		Panel:AddControl("Checkbox", {Label = "Armored helmets?", Command = "vj_stalker_armored_helmet"}) -- Arm helmets
		Panel:ControlHelp("This allows certain SNPCs to have special traits when equipped with certain helmets.")

		Panel:AddControl("Checkbox", {Label = "Armored helmets prevent damage?", Command = "vj_stalker_helm_prev_dmg"}) -- helm prev dmg
		Panel:ControlHelp("This makes it so armored helmets negate all damage that impacts them.")

		Panel:AddControl("Checkbox", {Label = "Should armored helmets be breakable?", Command = "vj_stalker_breakable_helmet"}) -- Breakable helm 
		Panel:ControlHelp("After 'x' amount of shots done to the helmet, they lose their ability to prevent headshots.")
        end
	function VJ_ADDTOMENU_RSTLK()
		spawnmenu.AddToolMenuOption( "DrVrej", "SNPC Configures", "[VJ] Random's S.T.A.L.K.E.R. SNPCs", "[VJ] Random's S.T.A.L.K.E.R. SNPCs", "", "", VJ_RSTLK_MENU_MAIN, {} )
	end
		hook.Add( "PopulateToolMenu", "VJ_ADDTOMENU_RSTLK", VJ_ADDTOMENU_RSTLK )
	end



function RagdollBloodEffects(ent, corpse)
    if GetConVarNumber("vj_stalker_cus_ragdoll_blood") ~= 1 or GetConVar("vj_npc_blood"):GetInt() == 0 then return end
    local defPos = Vector(0, 0, 0)
    corpse.SnpcRagdoll = true
    if ent.HasBloodParticle then
        corpse.BleedParticle = ent.BloodParticle or ""
    end
    corpse.BleedDecal = ent.HasBloodDecal and VJ.PICK(ent.BloodDecal) or ""
    corpse.SnpcRagdoll_StartT = CurTime() + 1

    hook.Add("EntityTakeDamage", "CorpseRagdollBloodEffects", function(target, dmginfo)
        if target.SnpcRagdoll and not target.Dead and CurTime() > target.SnpcRagdoll_StartT and target:GetColor().a > 50 then
            local dmgForce = dmginfo:GetDamageForce()
            sound.Play("physics/flesh/flesh_impact_bullet" .. math.random(1, 3) .. ".wav", dmginfo:GetDamagePosition(), 60, 100)

            local pos = dmginfo:GetDamagePosition()
            if pos == defPos then
                pos = target:GetPos() + target:OBBCenter()
            end

            local part = VJ.PICK(target.BleedParticle)
            if part then
                local function SpawnParticle()
                    local particle = ents.Create("info_particle_system")
                    particle:SetKeyValue("effect_name", part)
                    particle:SetPos(pos)
                    particle:Spawn()
                    particle:Activate()
                    particle:Fire("Start")
                    particle:Fire("Kill", "", math.Rand(0.05, 0.15))
                end

                SpawnParticle()

                if math.random(1, 3) == 1 then -- 1 in 3 chance
                    timer.Simple(math.Rand(0.05, 0.25), function()
                        if IsValid(target) then
                            SpawnParticle()
                        end
                    end)
                end
            end

            local decal = VJ.PICK(target.BleedDecal)
            if decal then
                local tr = util.TraceLine({
                    start = pos,
                    endpos = pos + dmgForce:GetNormal() * math.Clamp(dmgForce:Length() * 10, 100, 150),
                    filter = target
                })
                util.Decal(decal, tr.HitPos + tr.HitNormal + Vector(math.random(-45, 45), math.random(-45, 45), 0), tr.HitPos - tr.HitNormal, target)
            end
        end
    end)
end

