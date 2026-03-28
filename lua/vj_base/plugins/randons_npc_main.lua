/*--------------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
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
		AddConvars["vj_stalker_randoms_console_debug"] = 0 -- Move and reload?
        -- Abilities and functions convars
		AddConvars["vj_stalker_radio_death_cancel"] = 0 -- Move and reload?
		AddConvars["vj_stalker_reposition_while_reloading"] = 1 -- Move and reload?
		AddConvars["vj_stalker_death_anim"] = 1 -- Death animations?
		AddConvars["vj_stalker_death_ex_crpse_phys"] = 1 -- Extra death physics?
		AddConvars["vj_stalker_death_finger_manip"] = 1 -- Death finger manipulation?
		AddConvars["vj_stalker_death_wound_grabbing"] = 1 -- Death finger manipulation?
		AddConvars["vj_stalker_gib"] = 1 -- Gibbing ability?
		AddConvars["vj_stalker_minimal_gib"] = 1 -- Gibbing ability?
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
		AddConvars["vj_stalker_kickdoor_req_allies"] = 1 -- Door kicking requires nearby allies?
        AddConvars["vj_stalker_brutal_pain_vo"] = 1 -- Brutal Pain?
        AddConvars["vj_stalker_brutal_death_vo"] = 1 -- Brutal Death?
        AddConvars["vj_stalker_brutal_cry_vo"] = 1 -- Brutal cry for help?
        AddConvars["vj_stalker_fire_dmg_vo"] = 1 -- Specific fire damage sounds?
		AddConvars["vj_stalker_dent_dodge_requires_visibility"] = 1 -- Dodging dangerous ents vis check?
		AddConvars["vj_stalker_dent_dodge_requires_move"] = 1 -- Dodging dangerous ents vis check?
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
        AddConvars["vj_stalker_can_lean"] = 0 -- Leaning mechanic?
        AddConvars["vj_stalker_lp_wep"] = 0 -- Leaning point comes from weapon?
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
		AddConvars["vj_stalker_heal_self"] = 1 -- Self healing?
        AddConvars["vj_stalker_flatline"] = 1 -- Flatline?
        AddConvars["vj_stalker_wep_fire_adapt"] = 1 -- Weapon adaption?
        AddConvars["vj_stalker_ele_death_fx"] = 1 -- Ele death fx?
        AddConvars["vj_stalker_corpse_dissolve"] = 1 -- Corpse dissolve?
        AddConvars["vj_stalker_inst_corpse_dissolve"] = 1 -- Instantly dissolve corpse?
        AddConvars["vj_stalker_corpse_dissolve_wep"] = 1 -- Corpse dissolve weapon?
        AddConvars["vj_stalker_cus_wep_tracer"] = 0 -- Cus wep tracer?
        AddConvars["vj_stalker_override_all_wep_tracers_yel"] = 0 -- All tracers (Yellow)?
		AddConvars["vj_stalker_override_all_wep_tracers_whi"] = 0 -- All tracers (White)?
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
        AddConvars["vj_stalker_dmg_cancel_dial"] = 1 -- Dmg cancel idle? 
		AddConvars["vj_stalker_pain_vo_cancel"] = 1 -- pain vo cancel? 
        AddConvars["vj_stalker_ply_flashlight_alert"] = 1 -- Alert to ply flashlight (Ene ply solo)? 
		AddConvars["vj_stalker_no_fire_delay"] = 0 -- Removes fire delay from all weapons.
		AddConvars["vj_stalker_dynamic_firing"] = 0 -- Change fire type on ene dist?
		AddConvars["vj_stalker_damage_gibs"] = 0 -- Spawn gib on damage
		
		AddConvars["vj_stalker_corpse_rng_faceflex"] = 0 -- Corpse rng face
		AddConvars["vj_stalker_corpse_rng_eyelids"] = 0 -- corpse rng eyelids
		AddConvars["vj_stalker_corpse_rng_eyepos"] = 0 -- Corpse rng eyepos

        // Extra Credits \\
		-- ["pekena_larva"] - Free jump grunt & landing sounds.
		-- ["VOID Interactive"] -- Ready Or Not assets/sounds.
		-- ["🆂🅸🅼🆇🅽◈🅽🆇🆆🅸🆂"] - For porting the ready or not death sounds to the workshop. 
 

		for k, v in pairs(AddConvars) do
			if !ConVarExists( k ) then CreateConVar( k, v, {FCVAR_ARCHIVE} ) end
		end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	hook.Add("PopulateToolMenu", "VJ_RSTLK_MENU_MAIN", function()
		spawnmenu.AddToolMenuOption("DrVrej", "SNPC Configures", "[VJ] Random's S.T.A.L.K.E.R. SNPCs", "[VJ] Random's S.T.A.L.K.E.R. SNPCs", "", "", function(panel)
			if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
				panel:Help("#vjbase.menu.general.admin.not")
				panel:Help("#vjbase.menu.general.admin.only")
				return
			end

			panel:AddControl( "Label", {Text = "Notice: Only admins can change this settings."})
			panel:AddControl("Button",{Text = "#vjbase.menu.general.reset.everything", Command = "vj_stalker_override_all_wep_tracers_whi 0\n vj_stalker_wep_fire_adapt 0\n vj_stalker_kickdoor_req_allies 0\n vj_stalker_damage_gibs 0\n vj_stalker_heal_self 0\n vj_stalker_can_lean 0\n vj_stalker_corpse_rng_eyepos 0\n vj_stalker_corpse_rng_eyelids 0\n vj_stalker_corpse_rng_faceflex 0\n vj_stalker_death_wound_grabbing 0\n vj_stalker_radio_death_cancel 0\n vj_stalker_dent_dodge_requires_move 0\n vj_stalker_randoms_console_debug 0\n vj_stalker_dynamic_firing 0\n vj_stalker_minimal_gib 0\n vj_stalker_no_fire_delay 0\n vj_stalker_ply_flashlight_alert 0\n vj_stalker_dmg_cancel_dial 0\n vj_stalker_ron_death_sounds 0\n vj_stalker_panic_after_dmg 0\n vj_stalker_min_dmg_cap_sfx 0\n vj_stalker_min_dmg_cap 0\n vj_stalker_body_writhe 0\n vj_stalker_body_twitching 0\n vj_stalker_drop_seq_wep 0\n vj_stalker_breakable_helmet 0\n vj_stalker_helm_prev_dmg 0\n vj_stalker_armored_helmet 0\n vj_stalker_tracer_crack 0\n vj_stalker_fire_smoke 0\n vj_stalker_tracer_tip_light 0\n vj_stalker_tracer_glow 0\n vj_stalker_tracer_imp_light 0\n vj_stalker_cus_wep_muz_flash 0\n vj_stalker_override_all_wep_tracers_yel 0\n vj_stalker_cus_wep_tracer 0\n vj_stalker_inst_corpse_dissolve 0\n vj_stalker_corpse_dissolve_wep 0\n vj_stalker_corpse_dissolve 0\n vj_stalker_ele_death_fx 0\n vj_stalker_flatline 0\n vj_stalker_headshot_min_dmg_check 0\n vj_stalker_headshot_kill_chance 3\n vj_stalker_rng_combat_var_times 0\n vj_stalker_place_flares_ally_vis_check 0\n vj_stalker_place_flares_ally_check 0\n vj_stalker_looting 0\n vj_stalker_npc_copy_ply_stance 0\n vj_stalker_shove_wall_collide 0\n vj_stalker_ges_flinch 0\n vj_stalker_armor_spark 0\n vj_stalker_coughing 0\n vj_stalker_snpc_view_angle 177\n vj_stalker_reposition_while_reloading 0\n vj_stalker_headshot_gore_sound 0\n vj_stalker_dent_dodge_requires_visibility 0\n vj_stalker_death_ex_crpse_phys 0\n vj_stalker_death_finger_manip 0\n vj_stalker_red_grenade_trail 0\n vj_stalker_extended_delay 0\n vj_stalker_throw_flares 0\n vj_stalker_cus_ragdoll_blood 0\n vj_stalker_place_flares 0\n vj_stalker_fire_quick_flares 0\n vj_stalker_jump_land_particles 0\n vj_stalker_flash_blind_fri 0\n vj_stalker_flash_blind_ene 0\n vj_stalker_lm_tr_vj_creature 0\n vj_stalker_limited_grenades 0\n vj_stalker_lp_wep 0\n vj_stalker_radio_chatter 0\n vj_stalker_headshot_sfx 0\n vj_stalker_disable_headshot_death_anim 0\n vj_stalker_gib_death_sounds 0\n vj_stalker_armor_ricochet 0\n vj_stalker_headshot_fx 0\n vj_stalker_headshot_insa_kill 0\n vj_stalker_never_forget 0\n vj_stalker_passively_dodge_incom_danger 0\n vj_stalker_brutal_cry_vo 0\n vj_stalker_fire_dmg_vo 0\n vj_stalker_brutal_death_vo 0\n vj_stalker_brutal_pain_vo 0\n vj_stalker_kickdoor 0\n vj_stalker_shovedback 0\n vj_stalker_fire_flares 0\n vj_stalker_avoid_ply_crosshair 0\n vj_stalker_gren_trail 0\n vj_stalker_wep_flashlight 0\n vj_stalker_dodging 0\n vj_stalker_death_anims 0\n vj_stalker_fire_react 0\n vj_stalker_mil_faction_friendly 0\n vj_stalker_weapon_switching 0\n vj_stalker_gib 0\n vj_stalker_taunt 0\n vj_stalker_incapacitated 0"})
			panel:ControlHelp("\nTHIS WILL RESET EVERY CONVAR, SETTING THEM ALL TO 0! USE AT YOUR OWN DISCRETION!\n") 

			//panel:AddControl("Checkbox", {Label = "?", Command = ""}) -- 
			//panel:ControlHelp(".")  

			panel:AddControl("Checkbox", {Label = "Enable console print debugging?", Command = "vj_stalker_randoms_console_debug"}) 
			panel:ControlHelp("This will print our information into the console when certian SNPC events are tiggered. (Intended for debugging.)") 

			panel:AddControl("Checkbox", {Label = "Enable self healing?", Command = "vj_stalker_heal_self"}) 
			panel:ControlHelp("Enabling this feautre allows the SNPCs to be able to heal themselves.")  

			panel:AddControl("Checkbox", {Label = "Enable friendly military faction?", Command = "vj_stalker_mil_faction_friendly"}) -- Friendly military
			panel:ControlHelp("This allows the military faction to be friendly to the player, and their allies.")

			panel:AddControl("Checkbox", {Label = "Enable death cutting radio chatter?", Command = "vj_stalker_radio_death_cancel"}) 
			panel:ControlHelp("When the SNPC is killed, any current background radio chatter will be stopped.")  

			panel:AddControl("Checkbox", {Label = "Remove weapon fire delay?", Command = "vj_stalker_no_fire_delay"}) 
			panel:ControlHelp("This makes it so the SNPC does not have to wait 'x' amount of time to fire their weapon when using a weapon.") 

			panel:AddControl("Checkbox", {Label = "Allow enemy SNPCs to be alerted to the players flashlight?", Command = "vj_stalker_ply_flashlight_alert"}) -- alert ply flsh
			panel:ControlHelp("If the players flashlight is within a certain radius or on the SNPC, it will instantly alert them.") 

			panel:AddControl("Checkbox", {Label = "Allow damage to cancel/interupt idle dialogue?", Command = "vj_stalker_dmg_cancel_dial"}) -- dmg cancel
			panel:ControlHelp("If enabled, if an SNPC is playing some idle dialogue, any damage will interupt/cancel it.") 

			panel:AddControl("Checkbox", {Label = "Allow Ready or Not death sounds?", Command = "vj_stalker_ron_death_sounds"}) -- Ready Or Not SFX 
			panel:ControlHelp("Adds ready or not death sounds to the death sound table.") 

			panel:AddControl("Checkbox", {Label = "Panic after being damaged?", Command = "vj_stalker_panic_after_dmg"}) -- Panic
			panel:ControlHelp("An extra function where SNPCs are more likely to re-position or find cover after damage.") 

			panel:AddControl("Checkbox", {Label = "Minimum damage cap?", Command = "vj_stalker_min_dmg_cap"}) -- MD-Cap
			panel:ControlHelp("Allows the minimum damage cap to be active, meaning you have to do more than 'x' amount of damage to deal anything, ranging from 3 - 8 only.")

			panel:AddControl("Checkbox", {Label = "Minimum damage cap sfx feedback?", Command = "vj_stalker_min_dmg_cap_sfx"}) -- MD-Cap Sfx
			panel:ControlHelp("Allow small audio feedback everytime the minimum dmg cap is triggered.")

			panel:AddControl("Checkbox", {Label = "Random timers for certain behaviours?", Command = "vj_stalker_rng_combat_var_times"}) -- Rng var T's
			panel:ControlHelp("This allows for random durations to be allocated for the enemy occlusion behaviour, strafe timers, and combat damage response timers.")

			panel:AddControl("Checkbox", {Label = "Allow picking up loot?", Command = "vj_stalker_looting"}) -- Looting 
			panel:ControlHelp("Allows the SNPCs to pick up certain ents when idle, like the default hl2 ammo ents.")

			panel:AddControl("Checkbox", {Label = "Friendly SNPC's copy player stance when following?", Command = "vj_stalker_npc_copy_ply_stance"}) -- Follow copy
			panel:ControlHelp("This allows the SNPC to copy the players stance/crouch when the player is crouched.")

			panel:AddControl("Checkbox", {Label = "Allow coughing?", Command = "vj_stalker_coughing"}) -- Coughing
			panel:ControlHelp("Allows SNPC's to play a coughing sound when they are hit with certain toxic dmg types.")

			panel:AddControl("Checkbox", {Label = "Armor sparking?", Command = "vj_stalker_armor_spark"}) -- Arm spark
			panel:ControlHelp("Chance for spark/armor impact effect to play when damaged by bullets.")

			panel:AddControl("Checkbox", {Label = "Allow armor ricocheting?", Command = "vj_stalker_armor_ricochet"}) -- Armor rocochet
			panel:ControlHelp("This will enable the feature where there is a chance a bullet may richochet of the SNPC when shot.")

			panel:AddControl("Checkbox", {Label = "Layered gesture flinching?", Command = "vj_stalker_ges_flinch"}) -- Ges flinch
			panel:ControlHelp("Chance for flinch gesture animation to play whenever damaged, seperate from regular flinching.")

			panel:AddControl("Checkbox", {Label = "Allowed to be shoved back?", Command = "vj_stalker_shovedback"}) -- Shoved back 
			panel:ControlHelp("This allows the SNPCs to have the ability to be knocked back.")

			panel:AddControl("Checkbox", {Label = "Collide into walls when shoved?", Command = "vj_stalker_shove_wall_collide"}) -- Wall collide
			panel:ControlHelp("Allows the SNPC's to collide into walls, props, or other npcs when shoved.")

			panel:AddControl("Slider",{Label = "SNPC's view angle.", min = 1, max = 360, Command = "vj_stalker_snpc_view_angle"})
			panel:ControlHelp("Allows the user to manually change the SNPC's view angle/fov.")

			panel:AddControl("Checkbox", {Label = "Reposition whilst reloading?", Command = "vj_stalker_reposition_while_reloading"}) -- Move & reload
			panel:ControlHelp("This allows the SNPC the chance to reload and move to a new position at the same time.")

			panel:AddControl("Checkbox", {Label = "Allowed to avoid dangerous entities?", Command = "vj_stalker_passively_dodge_incom_danger"}) -- Dodge incoming dangerous ents 
			panel:ControlHelp("This will allow the SNPCs to roll to the left or right if detecting specific dangerous entities.")

			panel:AddControl("Checkbox", {Label = "Only dodge moving dangerous entities?", Command = "vj_stalker_dent_dodge_requires_move"}) 
			panel:ControlHelp("This makes it so the SNPCs will only try to evade a dangerous entity if they are  moving.") 

			panel:AddControl("Checkbox", {Label = "Dodging dangerous entities requires visibility?", Command = "vj_stalker_dent_dodge_requires_visibility"}) -- Dodg d-ent vis check 
			panel:ControlHelp("This makes it so a visibility check of the dangerous entity is required before the SNPC can dodge the dangerous entity.")

			panel:AddControl("Checkbox", {Label = "Extended fire delay?", Command = "vj_stalker_extended_delay"}) -- Ext delay
			panel:ControlHelp("This makes it so the SNPC's take longer to shoot.")

			panel:AddControl("Checkbox", {Label = "Red grenade trails?", Command = "vj_stalker_red_grenade_trail"}) -- Red gren trail
			panel:ControlHelp("This makes the SNPC's thrown grenades more obvious as it attaches a red trail to them.")

			panel:AddControl("Checkbox", {Label = "Can the SNPC's throw flares?", Command = "vj_stalker_throw_flares"}) -- Throw flares
			panel:ControlHelp("This controls the ability for the SNPC's to throw flares at the enemies positions.")

			panel:AddControl("Checkbox", {Label = "Can the SNPC's fire quick flares?", Command = "vj_stalker_fire_quick_flares"}) -- Firing flares
			panel:ControlHelp("This controls the ability for the SNPC's to fire flares at the enemies positions.")

			panel:AddControl("Checkbox", {Label = "Can the SNPC's place down flares whilst in combat?", Command = "vj_stalker_place_flares"}) -- Flare placing
			panel:ControlHelp("This allows the SNPC's fo place down flares when in combat.")

			panel:AddControl("Checkbox", {Label = "Combat flare placement requires allies?", Command = "vj_stalker_place_flares_ally_check"}) -- Flare place ally check
			panel:ControlHelp("Enables a check that makes it so the SNPC must have nearby allies before placing down a flare.")

			panel:AddControl("Checkbox", {Label = "Place flare ally visibility check?", Command = "vj_stalker_place_flares_ally_vis_check"}) -- Flare place ally vis check
			panel:ControlHelp("Enables a check to make sure the allies detected before placing a flare are visible.")

			panel:AddControl("Checkbox", {Label = "Jump landing particles?", Command = "vj_stalker_jump_land_particles"}) -- Landing particles
			panel:ControlHelp("This allows particles to appear when an SNPC lands after jumping.")

			panel:AddControl("Checkbox", {Label = "Flashlight blind friendly SNPCs?", Command = "vj_stalker_flash_blind_fri"}) -- Flashlight blind friednly SNPCs
			panel:ControlHelp("This allows the players flashlight to blind the friendly SNPCs.")

			panel:AddControl("Checkbox", {Label = "Flashlight blind enemy SNPCs?", Command = "vj_stalker_flash_blind_ene"}) -- Flashlight blind enemy SNPCs
			panel:ControlHelp("This allows the players flashlight to blind the enemy SNPCs.")

			panel:AddControl("Checkbox", {Label = "Lone member behavior trigger towards VJ Creatures?", Command = "vj_stalker_lm_tr_vj_creature"}) -- Lone member behavior apply to VJ Creatures
			panel:ControlHelp("This enables/disables the SNPCs lone member behavior apply to VJ creatures.")

			panel:AddControl("Checkbox", {Label = "Enable limited grenade count?", Command = "vj_stalker_limited_grenades"}) -- Grenade count
			panel:ControlHelp("Makes it so the SNPC's don't have an infinite stock of grenades.")

			panel:AddControl("Checkbox", {Label = "Enable leaning?", Command = "vj_stalker_can_lean"}) -- Leaning
			panel:ControlHelp("Allows the SNPCs to lean around corners to when engaging an enemy.")

			panel:AddControl("Checkbox", {Label = "[Somewhat buggy] Lp comes from active weapon?", Command = "vj_stalker_lp_wep"}) -- Lp
			panel:ControlHelp("Makes it so the trace start point comes from the SNPCs weapons muzzle.")

			panel:AddControl("Checkbox", {Label = "Enable radio chatter?", Command = "vj_stalker_radio_chatter"}) -- Radio chatter
			panel:ControlHelp("This will enable/disable some SNPCs having radios, where you can hear radio chatter coming through them.")

			panel:AddControl("Checkbox", {Label = "Allowed to forget enemies?", Command = "vj_stalker_never_forget"}) -- Never reset on enemy
			panel:ControlHelp("This will make it so the SNPCs won't forget an enemies existance if they are out of sight for too long.")

			panel:AddControl("Checkbox", {Label = "Enable minimum damage requirement for headshot instakilling?", Command = "vj_stalker_headshot_min_dmg_check"}) -- min dmg check
			panel:ControlHelp("Controls whether the min damage check is acknowledged in the headshot instakill code.")

			panel:AddControl("Checkbox", {Label = "Allowed to have brutal cry for help vo?", Command = "vj_stalker_brutal_cry_vo"}) --  Brutal cry vo
			panel:ControlHelp("Switches the default cry for help sounds to more brutal ones.")

			panel:AddControl("Checkbox", {Label = "Fire specific pain sounds?", Command = "vj_stalker_fire_dmg_vo"}) --  Fire pain vo
			panel:ControlHelp("Allows the SNPCs to have specific/unique pain sounds when damaged with fire.")

			panel:AddControl("Checkbox", {Label = "Allowed to have brutal pain vo?", Command = "vj_stalker_brutal_pain_vo"}) --  Brutal pain vo
			panel:ControlHelp("Switches the SNPCs pain/hurt sound vo to new more brutal ones.")

			panel:AddControl("Checkbox", {Label = "Allowed to have brutal death vo?", Command = "vj_stalker_brutal_death_vo"}) --  Brutal death vo
			panel:ControlHelp("Switches the SNPCs death/killed sound vo to more brutal vo.")

			panel:AddControl("Checkbox", {Label = "Door breaking requires nearby allies?", Command = "vj_stalker_kickdoor_req_allies"}) 
			panel:ControlHelp("SNPCs will only break down doors if there are allies nearby to aid them.")  

			panel:AddControl("Checkbox", {Label = "Allowed to kick down doors?", Command = "vj_stalker_kickdoor"}) -- Kick door
			panel:ControlHelp("This allows the SNPCs to have the ability to kick down the doors.")

			panel:AddControl("Checkbox", {Label = "Allowed to fire flares?", Command = "vj_stalker_fire_flares"}) -- Fire flares 
			panel:ControlHelp("This allows the SNPCs to fire flares.")

			panel:AddControl("Checkbox", {Label = "Avoid players crosshair?", Command = "vj_stalker_avoid_ply_crosshair"}) -- Avoid ply crosshair 
			panel:ControlHelp("This allows the SNPCs to reposition when a players crosshair is on them for too long.")

			panel:AddControl("Checkbox", {Label = "Do the SNPCs grenades have a trail?", Command = "vj_stalker_gren_trail"}) -- Grenade trail 
			panel:ControlHelp("This allows the SNPCs grenades to have trails.")

			panel:AddControl("Checkbox", {Label = "Weapon flashlight?", Command = "vj_stalker_wep_flashlight"}) -- Wep flashlight 
			panel:ControlHelp("This allows the SNPCs to have a flashlight entity attactched from the muzzle of their weapon.")

			panel:AddControl("Checkbox", {Label = "allowed to have death animations?", Command = "vj_stalker_death_anims"}) -- Death animations 
			panel:ControlHelp("This allows the SNPCs to have death animations.")

			panel:AddControl("Checkbox", {Label = "Allowed to dodge?", Command = "vj_stalker_dodging"}) -- Dodging 
			panel:ControlHelp("This allows the SNPCs to have the ability to dodge.")

			panel:AddControl("Checkbox", {Label = "Can they react to fire?", Command = "vj_stalker_fire_react"}) -- Fire reaction 
			panel:ControlHelp("This allows the SNPCs to react to fire like Combine soldiers.")

			panel:AddControl("Checkbox", {Label = "Can The SNPCs taunt", Command = "vj_stalker_taunt"}) -- Taunting system
			panel:ControlHelp("This allows the NPCs to taunt after killing an enemy.")
					
			panel:AddControl("Checkbox", {Label = "Can The SNPCs be incapacitated?", Command = "vj_stalker_incapacitated"}) -- Downing system
			panel:ControlHelp("This allows the SNPCs to be incapacitated under certain conditions.")


			-- Gibbing SEG
			panel:AddControl( "Label", {Text = "\nNotice: SNPC [Gibbing/Gibs] Specific ConVars. \n"})



			panel:AddControl("Checkbox", {Label = "Spawn gibs when damaged?", Command = "vj_stalker_damage_gibs"}) 
			panel:ControlHelp("Chance to spawn a gib whne the SNPC is damaged.")  

			panel:AddControl("Checkbox", {Label = "Can the SNPCs be gibbed?", Command = "vj_stalker_gib"}) -- Gibbing ability 
			panel:ControlHelp("This allows the SNPCs to be gibbed from certain damage types.")

			panel:AddControl("Checkbox", {Label = "Minimal gibbing effects?", Command = "vj_stalker_minimal_gib"}) 
			panel:ControlHelp("[For Lower End PCs] This convar disables most of the excess gib models, disables the paprticles attached to each gib, and reduce the amount of gibs in total.")

			panel:AddControl("Checkbox", {Label = "Unique death sounds when being gibbed?", Command = "vj_stalker_gib_death_sounds"}) -- Gib death sounds
			panel:ControlHelp("This will enable specific unique death sounds when gibbed.")


			-- HeadShot SEG
			panel:AddControl( "Label", {Text = "\nNotice: SNPC [Headshot] Specific ConVars. \n"})


			panel:AddControl("Checkbox", {Label = "Instantly kill SNPCs on a headshot?", Command = "vj_stalker_headshot_insa_kill"}) -- Instant headshot
			panel:ControlHelp("This makes it so if the SNPCs are shot in the head, they will instantly die.")

			panel:AddControl("Checkbox", {Label = "Allowed to have effects when headshoted?", Command = "vj_stalker_headshot_fx"}) -- Headshot effects
			panel:ControlHelp("Allows certain effects to occur when the SNPC is headshoted.") 

			panel:AddControl("Checkbox", {Label = "Enable headshot sound effects?", Command = "vj_stalker_headshot_sfx"}) -- Headshot sfx
			panel:ControlHelp("This will enable/disable the headshot sfx.")

			panel:AddControl("Checkbox", {Label = "Headshot death gore sound effect?", Command = "vj_stalker_headshot_gore_sound"}) -- Hs gore sound
			panel:ControlHelp("Allows gore sound effect to play when the SNPC is killed via a headshot.")

			panel:AddControl("Slider",{Label = "Headshot instakill chacne.", min = 1, max = 100, Command = "vj_stalker_headshot_kill_chance"})
			panel:ControlHelp("This scroller changes the chance the SNPC is instantly killeld via a headhshot.")

			panel:AddControl("Checkbox", {Label = "Disable headshot death anims?", Command = "vj_stalker_disable_headshot_death_anim"}) -- Headshot death anim
			panel:ControlHelp("This will disable the chance for specific headshot death anims, making the SNPCs a bit more realistic.")

			-- Corpse SEG
			panel:AddControl( "Label", {Text = "\nNotice: SNPC [Corpse] Specific ConVars. \n"})


			panel:AddControl("Checkbox", {Label = "Allow post-mortem twitching?", Command = "vj_stalker_body_twitching"}) -- Body twitching
			panel:ControlHelp("After some time the SNPC is killed, there is a chance for their body to start twitching.")

			panel:AddControl("Checkbox", {Label = "Allow corpse writhing?", Command = "vj_stalker_body_writhe"}) -- Body writhing
			panel:ControlHelp("When an SNPC is killed, their body may twitch or roll around before fully dying .")

			panel:AddControl("Checkbox", {Label = "Extra corpse death physics?", Command = "vj_stalker_death_ex_crpse_phys"}) -- Death corpse extra physics
			panel:ControlHelp("This applies extra random regular and angular velocity.")

			panel:AddControl("Checkbox", {Label = "Corpse finger manipulation?", Command = "vj_stalker_death_finger_manip"}) -- Death finger manip
			panel:ControlHelp("When the SNPC's corpse is spawned, their finger bones will be manipulated to different angles.")

			panel:AddControl("Checkbox", {Label = "Enable corpse face flex manipulation?", Command = "vj_stalker_corpse_rng_faceflex"}) 
			panel:ControlHelp("Enables the chance for valid face flexes on the SNPCs corpses to be manipulated.")  

			panel:AddControl("Checkbox", {Label = "Enable corpse eyelid manipulation?", Command = "vj_stalker_corpse_rng_eyelids"}) 
			panel:ControlHelp("Enab;es the SNPCs corpses eyes to have their eyelids to be manipulated")  

			panel:AddControl("Checkbox", {Label = "Enable corpse eye position manipulation?", Command = "vj_stalker_corpse_rng_eyepos"}) 
			panel:ControlHelp("Enab;es the SNPCs corpses eyes to have their position changed/repositioned.")  

			panel:AddControl("Checkbox", {Label = "Enable corpse wound grabbing?", Command = "vj_stalker_death_wound_grabbing"})  
			panel:ControlHelp("Just a cosmetic effect where the SNPCs corpse after death may grab a specific point on their body to replicate them grabbing onto a wound.")  

			panel:AddControl("Checkbox", {Label = "Do the SNPC's ragdolls have custom ragdoll blood?", Command = "vj_stalker_cus_ragdoll_blood"}) -- Ragdoll blood
			panel:ControlHelp("This enables custom ragdoll blood/effects when the SNPC's ragdolls are damaged.")

			panel:AddControl("Checkbox", {Label = "Audible death flatline?", Command = "vj_stalker_flatline"}) -- Flatline
			panel:ControlHelp("This allows a flatline sound to play for certain SNPCs when killed.")

			panel:AddControl("Checkbox", {Label = "Electrical death effects?", Command = "vj_stalker_ele_death_fx"}) -- Electrical death fx
			panel:ControlHelp("For certain SNPCs, when killed, special electrical death effects will come from their corpse.")

			panel:AddControl("Checkbox", {Label = "Corpse dissolving?", Command = "vj_stalker_corpse_dissolve"}) -- Corpse dissolving
			panel:ControlHelp("Allows SNPC's corpse dissolve after some time.")

			panel:AddControl("Checkbox", {Label = "Instantly dissolve corpse?", Command = "vj_stalker_inst_corpse_dissolve"}) -- Inst diss crpse
			panel:ControlHelp("Allows certain specific NPCs to be instantly dissolved when killed.")

			-- Weapon SEG
			panel:AddControl( "Label", {Text = "\nNotice: SNPC [Weapon] Specific ConVars. \n"})

			panel:AddControl("Checkbox", {Label = "SNPC weapon fire type adaption?", Command = "vj_stalker_wep_fire_adapt"}) 
			panel:ControlHelp("The SNPCs will automatically adjust their automatic weapons firing method in accordance to their enemies range, altering their firing speed, spread, and time until fire.")  

			panel:AddControl("Checkbox", {Label = "Enable switching to secondary weapon?", Command = "vj_stalker_weapon_switching"}) -- Weapon switching
			panel:ControlHelp("This allows the SNPCs to be able to switch to a secondary weapon under certain conditions.")

			panel:AddControl("Checkbox", {Label = "Enable corpse weapon dissolving?", Command = "vj_stalker_corpse_dissolve_wep"}) -- Diss crpse wep
			panel:ControlHelp("This makes it so during the corpse dissolve sequence, the NPCs weapon is also dissolved.")

			panel:AddControl("Checkbox", {Label = "Enable alternative muzzle flash (Custom Weapons)?", Command = "vj_stalker_cus_wep_muz_flash"}) -- Custom weapons (Mine)
			panel:ControlHelp("This changes the default muzzle flash particles to a different one. This convar only affects custom VJ Base weapons made by me.")

			panel:AddControl("Checkbox", {Label = "Override all default VJ bullet tracers (Yellow)?", Command = "vj_stalker_override_all_wep_tracers_yel"}) -- All tracers
			panel:ControlHelp("Any VJ Base weapon equiped by my SNPCs will use the custom tracer effects made by me.")

			panel:AddControl("Checkbox", {Label = "Override all default VJ bullet tracers (White)?", Command = "vj_stalker_override_all_wep_tracers_whi"}) -- All tracers
			panel:ControlHelp("Any VJ Base weapon equiped by my SNPCs will use the custom tracer effects made by me.")

			panel:AddControl("Checkbox", {Label = "Enable custom tracer impact dynamic light?", Command = "vj_stalker_tracer_imp_light"}) -- Imp light
			panel:ControlHelp("Allows short impact light to appear from where the tracers impact.")

			panel:AddControl("Checkbox", {Label = "Override custom weapon bullet tracers?", Command = "vj_stalker_cus_wep_tracer"}) -- Specific tracers 
			panel:ControlHelp("Overrides the default bullet tracer effects with custom ones made by me, but only affects my custom VJ NPC weapons.")

			panel:AddControl("Checkbox", {Label = "Enable subtle tracer glow?", Command = "vj_stalker_tracer_glow"}) -- Glow light
			panel:ControlHelp("Dynamic light that follows tracer.")

			panel:AddControl("Checkbox", {Label = "Enable custom weapon fire smoke?", Command = "vj_stalker_fire_smoke"}) -- Smoke
			panel:ControlHelp("This adds more weapon smoke when firing. This is for cinematic purposes. This only affects my custom weapons.")

			panel:AddControl("Checkbox", {Label = "Enable tracer bullet crack?", Command = "vj_stalker_tracer_crack"}) -- Crack
			panel:ControlHelp("This adds bullet crack sound to the tracers.")

			panel:AddControl("Checkbox", {Label = "Enable bullet tracer tip glow?", Command = "vj_stalker_tracer_tip_light"}) -- Tip light
			panel:ControlHelp("Adds a small glowing point to the tip of the custom bullet tracers.")

			panel:AddControl("Checkbox", {Label = "Enable secondary weapons dropping on death?", Command = "vj_stalker_drop_seq_wep"}) -- Drop seq weapon
			panel:ControlHelp("When killed, the SNPC will also drop their secondary weapon they had saved in their inventory.")

			panel:AddControl("Checkbox", {Label = "Enable dynamic firing?", Command = "vj_stalker_dynamic_firing"}) 
			panel:ControlHelp("This allows the SNPCs to fire in semi-automatic when the enemy they are engaging is far away.") 

			panel:AddControl( "Label", {Text = "\nNotice: Armored Helmet Convars:\n"})
			panel:AddControl("Checkbox", {Label = "Enable armored helmets?", Command = "vj_stalker_armored_helmet"}) -- Arm helmets
			panel:ControlHelp("This allows certain SNPCs to have special traits when equipped with certain helmets.")

			panel:AddControl("Checkbox", {Label = "Enable armored helmets negating damage?", Command = "vj_stalker_helm_prev_dmg"}) -- helm prev dmg
			panel:ControlHelp("This makes it so armored helmets negate all damage that impacts them.")

			panel:AddControl("Checkbox", {Label = "Enable breakable armored helmets?", Command = "vj_stalker_breakable_helmet"}) -- Breakable helm 
			panel:ControlHelp("After 'x' amount of shots done to the helmet, they lose their ability to prevent headshots.")
		end)
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function RagdollBloodEffects(ent, corpse)
	local vjConv = GetConVar("vj_npc_blood"):GetInt() 
	local stalkConv = GetConVar("vj_stalker_cus_ragdoll_blood"):GetInt() 
    if stalkConv ~= 1 or vjConv == 0 then return end
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
			local rngSnd = math.random(80, 100)
            sound.Play("physics/flesh/flesh_impact_bullet" .. math.random(1, 3) .. ".wav", dmginfo:GetDamagePosition(), 60, rngSnd)

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
				local delT = math.Rand(0.05, 0.25)
                if math.random(1, 3) == 1 then 
                    timer.Simple(delT, function()
                        if IsValid(target) then
                            SpawnParticle()
                        end
                    end)
                end
            end

            local decal = VJ.PICK(target.BleedDecal)
			local rngVec = math.random(-45, 45)
            if decal then
                local tr = util.TraceLine({
                    start = pos,
                    endpos = pos + dmgForce:GetNormal() * math.Clamp(dmgForce:Length() * 10, 100, 150),
                    filter = target
                })
                util.Decal(decal, tr.HitPos + tr.HitNormal + Vector(rngVec, rngVec, 0), tr.HitPos - tr.HitNormal, target)
            end
        end
    end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------