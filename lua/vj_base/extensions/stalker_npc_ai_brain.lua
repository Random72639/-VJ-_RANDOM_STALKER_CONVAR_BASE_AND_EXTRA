/*      ╔════༺†༻✝️༺†༻════╗
    👑  JESUS CHRIST IS LORD  👑
        ╚════༺†༻✝️༺†༻════╝ */

//TO DO

//BIG FLAw, IF USING SHOTGUN OR SHORT RANGE WEAPON, AND IS ALONE, THE SNPC MAY STAND OUT IN THE OPEN AND STARE AT AN ENEMY

//BACKSTAB? MELEE ATTACKS DO MORE DMG IF ENE HAS BACK TURNED? 
//MOVE WEAPON BURST FIRE LOGIC TO SNPC INSTEAD OF WEAPONS. (MUST IGNORE NON-AUTOMATICS)

//MAKE MOST CUSTOM IDLE ANIMATIONS SUPPORT GESTURE LAYERING
//ADD WAY TO FORCE IDLE GESTURE FIDGET ANIM TO STOP WHEN WE DETECT AN ENEMY.

//ADD CONVAR TP LOWER SIGHT DISTANCE

local VectorRand    = VectorRand
local Vector        = Vector
local print         = print 
local CreateSound   = CreateSound
local EmitSound     = EmitSound 
local CurTime       = CurTime
local IsValid       = IsValid
local GetConVar     = GetConVar
local isnumber      = isnumber
local tonumber      = tonumber
local tostring      = tostring
local isstring      = isstring
local ipairs        = ipairs
local pairs         = pairs
local GetConVar     = GetConVar
local GetInt        = GetInt
local GetBool       = GetBool
local math_floor    = math.floor
local math_ceil     = math.ceil
local math_Clamp    = math.Clamp
local math_abs      = math.abs
local mRng          = math.random
local mRand         = math.Rand

local VJ_STATE_NONE						= VJ_STATE_NONE
local VJ_STATE_FREEZE					= VJ_STATE_FREEZE
local VJ_STATE_ONLY_ANIMATION			= VJ_STATE_ONLY_ANIMATION
local VJ_STATE_ONLY_ANIMATION_CONSTANT	= VJ_STATE_ONLY_ANIMATION_CONSTANT
local VJ_STATE_ONLY_ANIMATION_NOATTACK	= VJ_STATE_ONLY_ANIMATION_NOATTACK

local VJ_BEHAVIOR_PASSIVE           = VJ_BEHAVIOR_PASSIVE
local VJ_BEHAVIOR_PASSIVE_NATURE    = VJ_BEHAVIOR_PASSIVE_NATURE
local VJ_MOVETYPE_GROUND            = VJ_MOVETYPE_GROUND
local VJ_MOVETYPE_AERIAL            = VJ_MOVETYPE_AERIAL
local VJ_MOVETYPE_AQUATIC           = VJ_MOVETYPE_AQUATIC
local VJ_MOVETYPE_STATIONARY        = VJ_MOVETYPE_STATIONARY
local VJ_MOVETYPE_PHYSICS           = VJ_MOVETYPE_PHYSICS
-----------------------------------------------------------------------------------------------------------------------------------------------
ENT.Is_RandomsNPC = true 

ENT.StartHealth = 90
ENT.HullType = HULL_HUMAN

ENT.ControllerParams = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "ValveBiped.Bip01_Head1", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(0, 0, 5), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = true, -- Should the bone shrink? Useful if the bone is obscuring the player's view
	FirstP_CameraBoneAng = 0, -- Should the camera's angle be affected by the bone's angle? | 0 = No, 1 = Pitch, 2 = Yaw, 3 = Roll
	FirstP_CameraBoneAng_Offset = 0, -- How much should the camera's angle be rotated by? | Useful for weird bone angles
}

ENT.CanDetectDangers = true -- Should the NPC detect dangers? | This includes grenades!
ENT.DangerDetectionDistance = mRng(1000, 1525) -- Max danger detection distance | WARNING: Most of the non-grenade dangers ignore this max value
ENT.CanRedirectGrenades = true -- Can it pick up detected grenades and throw it away or to the enemy?

ENT.AlertTimeout  = VJ.SET(5, 25)

ENT.ConstantlyFaceEnemy_MinDistance  = mRand(1000,2500) -- How close does it have to be until it starts to face the enemy?
ENT.InvestigateSoundDistance = mRng(15,30)

ENT.FootstepSoundTimerRun  = mRand(0.258,0.35) -- Next foot step sound when it is running
ENT.FootstepSoundTimerWalk  = mRand(0.45,0.55) -- Next foot step sound when it is walking

ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle, etc.)
-----------------------------------------------------------------------------------------------------------------------------------------------
ENT.HealthRegenParams = {
	Enabled = true, -- Can it regenerate its health?
	Amount = mRand(2,8), -- How much should the health increase after every delay?
	Delay = VJ.SET(1, 6), -- How much time until the health increases
	ResetOnDmg = true, -- Should the delay reset when it receives damage?
}
-----------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasAllies = true -- Put to false if you want it not to have any allies
ENT.OnPlayerSightDispositionLevel = 1 -- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
ENT.OnPlayerSightOnlyOnce = false -- If true, it will only run the code once | Sets self.HasOnPlayerSight to false once it runs!
ENT.OnPlayerSightNextTime = VJ.SET(100, 300) -- How much time should it pass until it runs the code again?

ENT.SightDistance = 8000 -- How far it can see
ENT.SightAngle = 177 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.CanOpenDoors = true -- Can it open doors?

ENT.CanReceiveOrders = true
ENT.NextProcessTime = 1 -- Time until it runs the essential part of the AI, which can be performance heavy!
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanInvestigate = true -- Can it detect and investigate disturbances? | EX: Sounds, movement, flashlight, bullet hits
ENT.InvestigateSoundMultiplier = mRng(5, 15) -- Max sound hearing distance multiplier | This multiplies the calculated volume of the sound
-----------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanUseSecondaryOnWeaponAttack = true -- Can the NPC use a secondary fire if it's available?
ENT.AnimTbl_WeaponAttackSecondary = {"vjseq_shootAR2alt","vjseq_shoot_ar2grenade_cmb_b"} -- Animations played when the SNPC fires a secondary weapon attack
ENT.WeaponAttackSecondaryTimeUntilFire = mRand(0.7,1.2) -- The weapon uses this integer to set the time until the firing code is ran
-----------------------------------------------------------------------------------------------------------------------------------------------
ENT.Weapon_OcclusionDelayMinDist = mRand(200,550) -- If it's this close to the enemy, it won't do it
ENT.Weapon_MinDistance = mRand(5,15) -- How close until it stops shooting
ENT.Weapon_MaxDistance = mRand(7500,9000) -- How far away it can shoot

ENT.AnimTbl_WeaponAttack = ACT_RANGE_ATTACK1 -- Animations to play while firing a weapon
ENT.AnimTbl_WeaponAttackGesture = ACT_GESTURE_RANGE_ATTACK1 -- Gesture animations to play while firing a weapon | false = Don't play an animation
ENT.Weapon_CanCrouchAttack = true -- Can it crouch while firing a weapon?
ENT.Weapon_CrouchAttackChance = mRng(2,3) -- How much chance of crouching? | 1 = Crouch every time
ENT.AnimTbl_WeaponAttackCrouch = ACT_RANGE_ATTACK1_LOW -- Animations to play while firing a weapon in crouched position

ENT.AllowWeaponReloading = true -- If false, the SNPC will no longer reload
ENT.Weapon_UnarmedBehavior = true -- Should it flee from enemies when it's unarmed?
ENT.Weapon_Accuracy = mRand(0.05, 0.65) -- Its accuracy with weapons, affects bullet spread! | x < 1 = Better accuracy | x > 1 = Worse accuracy

ENT.WeaponReloadAnimationDecreaseLengthAmount = mRand(0.05,0.105) -- This will decrease the time until it starts moving or attack again. Use it to fix animation pauses until it chases the enemy.
ENT.WeaponReloadAnimationDelay = mRand(0,0.1) -- It will wait certain amount of time before playing the animation
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AnimTbl_AlertFriendsOnDeath = {"vjges_gesture_signal_takecover","vjges_gesture_signal_right","vjges_gesture_signal_left","vjges_gesture_signal_halt","vjges_gesture_signal_advance","vjges_gesture_signal_forward","vjges_gesture_signal_group","vjseq_signal_advance", "vjseq_signal_forward", "vjseq_signal_group", "vjseq_signal_takecover", "vjseq_signal_halt", "vjseq_signal_left", "vjseq_signal_right"} -- Animations it plays when an ally dies that also has AlertFriendsOnDeath set to true
ENT.DeathAllyResponse = false -- How should allies response when it dies?
ENT.DeathAllyResponse_Range = mRand(1500, 2500) -- Max distance allies respond to its death
ENT.DeathAllyResponse_MoveLimit = mRng(5, 20) -- Max number of allies that can move to its location when responding to its death
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.DisableWandering = false -- Disables wandering when the SNPC is idle
ENT.HasWeaponBackAway = true -- Should the SNPC back away if the enemy is close?
ENT.Weapon_RetreatDistance = mRand(350,675) -- When the enemy is this close, the SNPC will back away | 0 = Never back away
---------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Drops On Death ====== --
ENT.DropDeathLoot  = true -- Should it drop items on death?
ENT.DeathLootChance  = mRng(1, 5) -- If set to 1, it will always drop it
ENT.DeathLoot = {"item_ammo_ar2_altfire","item_ammo_smg1","item_healthkit","weapon_frag","item_healthvial","item_ammo_357","item_ammo_357_large","item_ammo_ar2_large","item_ammo_smg1_large","item_battery","item_ammo_smg1_grenade","item_rpg_round","item_box_buckshot"} -- List of items it will randomly pick from | Leave it empty to drop nothing or to make your own dropping code (Using CustomOn...)
ENT.DropWeaponOnDeath = true -- Should it drop its weapon on death?
ENT.DropWeaponOnDeathAttachment = "anim_attachment_RH" -- Which attachment should it use for the weapon's position
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Passive_RunOnTouch = true -- Should it run away and make a alert sound when something collides with it?
ENT.Passive_NextRunOnTouchTime = VJ.SET(2,6) -- How much until it can run away again when something collides with it?
ENT.Passive_RunOnDamage = true -- Should it run when it's damaged? | This doesn't impact how self.Passive_AlliesRunOnDamage works
ENT.Passive_AlliesRunOnDamage = true -- Should its allies (other passive SNPCs) also run when it's damaged?
ENT.Passive_AlliesRunOnDamageDistance = mRand(2000,3500) -- Any allies within this distance will run when it's damaged
ENT.Passive_NextRunOnDamageTime = VJ.SET(2,5) -- How much until it can run the code again?

ENT.RunAwayOnUnknownDamage = true -- Should run away on damage
ENT.HasLostWeaponSightAnimation = true

ENT.HasDeathRagdoll = true -- If set to false, it will not spawn the regular ragdoll of the SNPC
 ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.JumpParams  = {
	Enabled = true, -- Can the NPC do movements jumps?
	MaxRise = mRng(70,100), -- How high it can jump up ((S -> A) AND (S -> E))
	MaxDrop = mRng(200,250), -- How low it can jump down (E -> S)
	MaxDistance = mRng(260,300), -- Maximum distance between Start and End
}
ENT.Weapon_AimTurnDiff = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AnimTbl_TakingCover = {ACT_COVER_LOW} -- The animation it plays when hiding in a covered position
ENT.AnimTbl_MoveToCover = {ACT_RUN_CROUCH} -- The animation it plays when moving to a covered position
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = mRng(5,17)
ENT.MeleeAttackDamageType = bit.bor(DMG_CLUB, DMG_SLASH)
ENT.HasMeleeAttackKnockBack = true -- Should knockback be applied on melee hit? | Use "MeleeAttackKnockbackVelocity" function to edit the velocity
ENT.DisableDefaultMeleeAttackDamageCode = false -- Disables the default melee attack damage code
	-- ====== Animation ====== --
ENT.MeleeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the melee attack animation?
ENT.AnimTbl_MeleeAttack = nil -- Melee Attack Animations
ENT.MeleeAttackAnimationDecreaseLengthAmount = mRand(0,0.325)
	-- ====== Distance ====== --
ENT.MeleeAttackDistance = false -- How close does it have to be until it attacks?
ENT.MeleeAttackAngleRadius = 110 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.MeleeAttackDamageDistance = mRng(75,100)
ENT.MeleeAttackDamageAngleRadius = 110 -- What is the damage angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
	-- ====== Timer ====== --
ENT.TimeUntilMeleeAttackDamage = 0.5 -- How much time until it executes the damage? | false = Make the attack event-based
ENT.NextMeleeAttackTime = VJ.SET(0.75,2.25) -- How much time until it can use a melee attack?ENT.NextAnyAttackTime_Melee = false -- How much time until it can do any attack again? | false = Base auto calculates the duration | number = Specific time | VJ.SET = Randomized between the 2 numbers
ENT.MeleeAttackReps = 1 -- How many times does it run the melee attack code?
ENT.MeleeAttackExtraTimers = false -- Extra melee attack timers | EX: {1, 1.4}
ENT.MeleeAttackStopOnHit = false -- Should it stop executing the melee attack after it hits an enemy?
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanGib = true -- Can the NPC gib? | Makes "CreateGibEntity" fail and overrides "CanGibOnDeath" to false
ENT.CanGibOnDeath = true -- Is it allowed to gib on death?
ENT.GibOnDeathFilter = true -- Should it only gib and call "self:HandleGibOnDeath" when it's killed by a specific damage types? | false = Call "self:HandleGibOnDeath" from any damage type
ENT.HasGibOnDeathSounds = true -- Does it have gib sounds? | Mostly used for the settings menu
ENT.HasGibOnDeathEffects = true -- Does it spawn particles on death or when it gibs? | Mostly used for the settings menu
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasDeathAnimation = false -- Should it play death animations?
ENT.AnimTbl_Death = false
ENT.DeathAnimationTime = false -- How long should the death animation play? | false = Base auto calculates the duration
ENT.DeathAnimationChance = mRng(2,5) -- Put 1 if you want it to play the animation all the time
ENT.DeathAnimationDecreaseLengthAmount = mRand(0, 0.500) -- This will decrease the time until it turns into a corpse
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.GodMode = false -- Immune to everything
ENT.Immune_Toxic = false -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = false -- Immune to bullet type damages
ENT.Immune_Blast = false -- Immune to explosive-type damages
ENT.Immune_Dissolve = false -- Immune to dissolving | Example: Combine Ball
ENT.Immune_Electricity = false -- Immune to electrical-type damages | Example: shock or laser
ENT.Immune_Fire = false -- Immune to fire-type damages
ENT.Immune_Melee = false -- Immune to melee-type damage | Example: Crowbar, slash damages
ENT.Immune_Physics = false -- Immune to physics impacts, won't take damage from props
ENT.Immune_Sonic = false -- Immune to sonic-type damages
ENT.ImmuneDamagesTable = {} -- Makes the SNPC immune to specific type of damages | Takes DMG_ enumerations
ENT.GetDamageFromIsHugeMonster = false -- Should it get damaged no matter what by SNPCs that are tagged as VJ_ID_Boss?
ENT.AllowIgnition = true -- Can this SNPC be set on fire?
---------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Call For Help ====== --
ENT.CallForHelp = true -- Does the SNPC call for help?
ENT.CallForHelpDistance = 4500 -- How far away the SNPC's call for help goes | Counted in World Units
ENT.CallForHelpCooldown = 5 -- Time until it calls for help again
ENT.AnimTbl_CallForHelp = {"vjges_gesture_signal_takecover","vjges_gesture_signal_right","vjges_gesture_signal_left","vjges_gesture_signal_halt","vjges_gesture_signal_advance","vjges_gesture_signal_forward","vjges_gesture_signal_group","vjseq_signal_advance", "vjseq_signal_forward", "vjseq_signal_group", "vjseq_signal_takecover", "vjseq_signal_halt", "vjseq_signal_left", "vjseq_signal_right"} -- Call For Help Animations
ENT.CallForHelpAnimFaceEnemy = false -- Should it face the enemy while playing the animation?
ENT.CallForHelpAnimCooldown = mRand(5, 10) -- How much time until it can play an animation again?
---------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Grenade Attack ====== --
ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.HasLimitedGrenadeCount = false 

ENT.GrenadeAttackEntity = "obj_vj_grenade"
ENT.GrenadeAttackBone = "ValveBiped.Bip01_L_Finger1"

ENT.GrenadeAttackModel = false
ENT.ThrowGrenadeChance = mRng(3,5) -- Chance that it will throw the grenade | Set to 1 to throw all the time

ENT.GrenadeAttackMinDistance = 500 -- Min distance it can throw a grenade
ENT.GrenadeAttackMaxDistance = mRng(2000,3500) 

ENT.GrenadeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.GrenadeAttackAnimationStopAttacks = true -- Should it stop attacks for a certain amount of time?

ENT.NextGrenadeAttackTime = VJ.SET(5, 20) -- Time until it can do a grenade attack again
ENT.NextAnyAttackTime_Grenade = VJ.SET(0.01, 0.1)
ENT.GrenadeAttackFuseTime = mRand(2.5,8)
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.IsMedic = false -- Is this SNPC a medic? Does it heal other friendly friendly SNPCs, and players(If friendly)
ENT.AnimTbl_Medic_GiveHealth = false -- Animations to play when it heals an ally | false = Don't play an animation
ENT.Medic_TimeUntilHeal = mRand(0.05,0.25) -- Time until the ally receives health | Set to false to let the base decide the time
ENT.Medic_CheckDistance = 2500 -- How far does it check for allies that are hurt? | World units
ENT.Medic_HealDistance = mRand(70,135) -- How close does it have to be until it stops moving and heals its ally?
ENT.Medic_HealAmount  = mRng(15,45) -- How health does it give?
ENT.Medic_NextHealTime = VJ.SET(1,10) -- How much time until it can give health to an ally again
ENT.Medic_SpawnPropOnHeal = true -- Should it spawn a prop, such as small health vial at a attachment when healing an ally?
ENT.Medic_SpawnPropOnHealModel = "models/healthvial.mdl" -- The model that it spawns
ENT.Medic_SpawnPropOnHealAttachment = "anim_attachment_LH" -- The attachment it spawns on
---------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Non-Combat Damage Response Behaviors ====== --
	-- If it's a passive behavior NPC, these responses will run regardless if it has an active enemy or not
ENT.DamageResponse = true -- Should it respond to damages while it has no enemy?
	-- true = Search for enemies or run to a covered position | "OnlyMove" = Will only run to a covered position | "OnlySearch" = Will only search for enemies
ENT.DamageAllyResponse = false -- Should allies respond when it's damaged while it has no enemy?
ENT.AnimTbl_DamageAllyResponse = {"vjges_gesture_signal_takecover","vjges_gesture_signal_right","vjges_gesture_signal_left","vjges_gesture_signal_halt","vjges_gesture_signal_advance","vjges_gesture_signal_forward","vjges_gesture_signal_group","vjseq_signal_advance", "vjseq_signal_forward", "vjseq_signal_group", "vjseq_signal_takecover", "vjseq_signal_halt", "vjseq_signal_left", "vjseq_signal_right"} -- Animations to play when it calls allies to respond | false = Don't play an animation
ENT.DamageAllyResponse_Cooldown = VJ.SET(1, 10) -- How long until it can call allies again?
	-- ====== Combat Damage Response Behaviors ====== --
	-- Hiding behind objects uses "self.AnimTbl_TakingCover"
ENT.CombatDamageResponse = true -- Should it respond to damages while it has an active enemy? | true = Hide behind an object if possible otherwise run to a covered position
ENT.CombatDamageResponse_CoverTime = VJ.SET(5, 15) -- How long until it can do any combat damage response?
---------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Flinching ====== --
ENT.FlinchHitGroupPlayDefault = true
ENT.FlinchHitGroupMap = {
    {HitGroup = {HITGROUP_HEAD}, Animation = {"vjges_flinchheadgest","vjseq_Flinchhead","vjseq_Flinchbig","vjseq_Pd2_Heavydamage_Head1","vjseq_Pd2_Heavydamage_Head2"}}, 
    {HitGroup = {HITGROUP_STOMACH}, Animation = {"vjges_flinchgutgest","vjseq_Flinchgut","vjseq_Flinchsmall","vjseq_Pd2_Heavydamage_Body1","vjseq_Pd2_Heavydamage_Body2"}}, 
    {HitGroup = {HITGROUP_CHEST}, Animation = {"vjges_flinchgutgest","vjseq_Flinchchest","vjseq_Pd2_Heavydamage_Body1","vjseq_Pd2_Heavydamage_Body2"}}, 
    {HitGroup = {HITGROUP_LEFTARM}, Animation = {"vjseq_Flinchleft","vjges_flinchlarmgest"}}, 
    {HitGroup = {HITGROUP_RIGHTARM}, Animation = {"vjseq_Flinchright","vjges_flinchrarmgest"}}, 
    {HitGroup = {HITGROUP_LEFTLEG}, Animation = {"vjseq_Flinchleft","vjseq_zmb_flinch_leftleg"}}, 
    {HitGroup = {HITGROUP_RIGHTLEG}, Animation = {"vjseq_Flinchright","vjseq_zmb_flinch_rightleg"}}}

ENT.CanFlinch = true -- Can it flinch? | false = Don't flinch | true = Always flinch | "DamageTypes" = Flinch only from certain damages types
ENT.FlinchChance = mRng(1,5) -- Chance of it flinching from 1 to x | 1 will make it always flinch
ENT.AnimTbl_Flinch = {"vjseq_flinchsmall","vjseq_flinchbig","vjseq_physflinch1","vjseq_physflinch2"} -- If it uses normal based animation, use this
ENT.NextFlinchTime = mRand(0.5,8.5)
ENT.FlinchAnimationDecreaseLengthAmount = 0.01
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Weapon_CanMoveFire = false -- Can it shoot while moving?
ENT.Weapon_Strafe = false -- Should it move randomly while firing a weapon?
	-- ====== Item Drops On Death Variables ====== --
ENT.HasItemDropsOnDeath = true -- Should it drop items on death?
ENT.ItemDropsOnDeathChance = mRng(2,4) -- If set to 1, it will always drop it
ENT.DropWeaponOnDeath = true -- Should it drop its weapon on death?
ENT.DropWeaponOnDeathAttachment = "anim_attachment_RH" -- Which attachment should it use for the weapon's position
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.FootSteps = {
    [MAT_ANTLION] = {"physics/flesh/flesh_impact_hard1.wav","physics/flesh/flesh_impact_hard2.wav","physics/flesh/flesh_impact_hard3.wav","physics/flesh/flesh_impact_hard4.wav","physics/flesh/flesh_impact_hard5.wav","physics/flesh/flesh_impact_hard6.wav"},
    [MAT_BLOODYFLESH] = {"physics/flesh/flesh_impact_hard1.wav","physics/flesh/flesh_impact_hard2.wav","physics/flesh/flesh_impact_hard3.wav","physics/flesh/flesh_impact_hard4.wav","physics/flesh/flesh_impact_hard5.wav","physics/flesh/flesh_impact_hard6.wav"},
    [MAT_CONCRETE] = {"npc/footsteps/hardboot_generic1.wav","npc/footsteps/hardboot_generic2.wav","npc/footsteps/hardboot_generic3.wav","npc/footsteps/hardboot_generic4.wav","npc/footsteps/hardboot_generic5.wav","npc/footsteps/hardboot_generic6.wav"},
    [MAT_DIRT] = {"general_sds/eft_footsteps/soil_run_01.ogg","general_sds/eft_footsteps/soil_run_02.ogg","general_sds/eft_footsteps/soil_run_03.ogg","general_sds/eft_footsteps/soil_run_04.ogg","general_sds/eft_footsteps/soil_run_05.ogg","general_sds/eft_footsteps/soil_run_06.ogg","general_sds/eft_footsteps/soil_run_07.ogg","general_sds/eft_footsteps/soil_run_08.ogg"},
    [MAT_FLESH] = {"physics/flesh/flesh_impact_hard1.wav","physics/flesh/flesh_impact_hard2.wav","physics/flesh/flesh_impact_hard3.wav","physics/flesh/flesh_impact_hard4.wav","physics/flesh/flesh_impact_hard5.wav","physics/flesh/flesh_impact_hard6.wav"},
    [MAT_GRATE] = {"general_sds/eft_footsteps/walk_proflist_01.ogg","general_sds/eft_footsteps/walk_proflist_02.ogg","general_sds/eft_footsteps/walk_proflist_03.ogg","general_sds/eft_footsteps/walk_proflist_04.ogg","general_sds/eft_footsteps/walk_proflist_05.ogg","general_sds/eft_footsteps/walk_proflist_06.ogg","general_sds/eft_footsteps/walk_proflist_07.ogg","general_sds/eft_footsteps/walk_proflist_08.ogg","general_sds/eft_footsteps/walk_proflist_09.ogg","general_sds/eft_footsteps/walk_proflist_10.ogg"},
    [MAT_ALIENFLESH] = {"physics/flesh/flesh_impact_hard1.wav","physics/flesh/flesh_impact_hard2.wav","physics/flesh/flesh_impact_hard3.wav","physics/flesh/flesh_impact_hard4.wav","physics/flesh/flesh_impact_hard5.wav","physics/flesh/flesh_impact_hard6.wav"},
    [74] = {"player/footsteps/sand1.wav","player/footsteps/sand2.wav","player/footsteps/sand3.wav","player/footsteps/sand4.wav"}, -- This is snow.
    [MAT_PLASTIC] = {"physics/plaster/drywall_footstep1.wav","physics/plaster/drywall_footstep2.wav","physics/plaster/drywall_footstep3.wav","physics/plaster/drywall_footstep4.wav"},
    [MAT_METAL] = {"general_sds/eft_footsteps/sprint_metal1.ogg","general_sds/eft_footsteps/sprint_metal2.ogg","general_sds/eft_footsteps/sprint_metal3.ogg","general_sds/eft_footsteps/sprint_metal4.ogg","general_sds/eft_footsteps/sprint_metal5.ogg","general_sds/eft_footsteps/sprint_metal6.ogg"},
    [MAT_SAND] = {"player/footsteps/sand1.wav","player/footsteps/sand2.wav","player/footsteps/sand3.wav","player/footsteps/sand4.wav"},
    [MAT_FOLIAGE] = {"general_sds/eft_footsteps/sprint2_grasslow_01.ogg","general_sds/eft_footsteps/sprint2_grasslow_02.ogg","general_sds/eft_footsteps/sprint2_grasslow_03.ogg","general_sds/eft_footsteps/sprint2_grasslow_04.ogg","general_sds/eft_footsteps/sprint2_grasslow_05.ogg","general_sds/eft_footsteps/sprint2_grasslow_06.ogg","general_sds/eft_footsteps/sprint2_grasslow_07.ogg","general_sds/eft_footsteps/sprint2_grasslow_08.ogg"},
    [MAT_COMPUTER] = {"physics/plaster/drywall_footstep1.wav","physics/plaster/drywall_footstep2.wav","physics/plaster/drywall_footstep3.wav","physics/plaster/drywall_footstep4.wav"},
    [MAT_SLOSH] = {"general_sds/eft_footsteps/walk_puddle_01.ogg","general_sds/eft_footsteps/walk_puddle_02.ogg","general_sds/eft_footsteps/walk_puddle_03.ogg","general_sds/eft_footsteps/walk_puddle_04.ogg","general_sds/eft_footsteps/walk_puddle_05.ogg","general_sds/eft_footsteps/walk_puddle_06.ogg","general_sds/eft_footsteps/walk_puddle_07.ogg","general_sds/eft_footsteps/walk_puddle_08.ogg","general_sds/eft_footsteps/walk_puddle_09.ogg"},
    [MAT_TILE] = {"general_sds/eft_footsteps/tile1.wav","general_sds/eft_footsteps/tile2.wav","general_sds/eft_footsteps/tile3.wav","general_sds/eft_footsteps/tile4.wav","general_sds/eft_footsteps/tile5.wav","general_sds/eft_footsteps/tile6.wav","general_sds/eft_footsteps/tile7.wav","general_sds/eft_footsteps/tile8.wav","general_sds/eft_footsteps/tile9.wav","general_sds/eft_footsteps/tile10.wav","general_sds/eft_footsteps/tile11.wav"},
    [85] = {"general_sds/eft_footsteps/sprint2_grasslow_01.ogg","general_sds/eft_footsteps/sprint2_grasslow_02.ogg","general_sds/eft_footsteps/sprint2_grasslow_03.ogg","general_sds/eft_footsteps/sprint2_grasslow_04.ogg","general_sds/eft_footsteps/sprint2_grasslow_05.ogg","general_sds/eft_footsteps/sprint2_grasslow_06.ogg","general_sds/eft_footsteps/sprint2_grasslow_07.ogg","general_sds/eft_footsteps/sprint2_grasslow_08.ogg"}, -- Grass.
    [MAT_VENT] = {"general_sds/eft_footsteps/walk_proflist_01.ogg","general_sds/eft_footsteps/walk_proflist_02.ogg","general_sds/eft_footsteps/walk_proflist_03.ogg","general_sds/eft_footsteps/walk_proflist_04.ogg","general_sds/eft_footsteps/walk_proflist_05.ogg","general_sds/eft_footsteps/walk_proflist_06.ogg","general_sds/eft_footsteps/walk_proflist_07.ogg","general_sds/eft_footsteps/walk_proflist_08.ogg","general_sds/eft_footsteps/walk_proflist_09.ogg","general_sds/eft_footsteps/walk_proflist_10.ogg"},
    [MAT_WOOD] = {"general_sds/eft_footsteps/sprint_wood_01.ogg","general_sds/eft_footsteps/sprint_wood_02.ogg","general_sds/eft_footsteps/sprint_wood_03.ogg","general_sds/eft_footsteps/sprint_wood_04.ogg","general_sds/eft_footsteps/sprint_wood_05.ogg","general_sds/eft_footsteps/sprint_wood_06.ogg","general_sds/eft_footsteps/sprint_wood_07.ogg","general_sds/eft_footsteps/sprint_wood_08.ogg","general_sds/eft_footsteps/sprint_wood_09.ogg","general_sds/eft_footsteps/sprint_wood_10.ogg","general_sds/eft_footsteps/sprint_wood_11.ogg","general_sds/eft_footsteps/sprint_wood_12.ogg","general_sds/eft_footsteps/sprint_wood_13.ogg"},
    [MAT_GLASS] = {"general_sds/eft_footsteps/sprint_glass_01.ogg","general_sds/eft_footsteps/sprint_glass_02.ogg","general_sds/eft_footsteps/sprint_glass_03.ogg","general_sds/eft_footsteps/sprint_glass_04.ogg","general_sds/eft_footsteps/sprint_glass_05.ogg","general_sds/eft_footsteps/sprint_glass_06.ogg","general_sds/eft_footsteps/sprint_glass_07.ogg","general_sds/eft_footsteps/sprint_glass_08.ogg","general_sds/eft_footsteps/sprint_glass_09.ogg","general_sds/eft_footsteps/sprint_glass_10.ogg"}
}
---------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.OnFirePain = {"st_brutal_deaths/brutal_scream/rus_screams_fire/scream_157.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/scream_158.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/scream_159.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/scream_160.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/scream_161.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/scream_162.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/scream_163.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/506.wav"}

//General universal sounds
ENT.GoreOrGibSounds                  = {"general_sds/gibs_gore/gutexplosion-1.wav", "general_sds/gibs_gore/gutexplosion-2.wav", "general_sds/gibs_gore/gutexplosion-3.wav", "general_sds/gibs_gore/fullbodygib-1.wav", "general_sds/gibs_gore/fullbodygib-2.wav", "general_sds/gibs_gore/fullbodygib-3.wav"} -- need to change path soon 
ENT.SoundTbl_MeleeAttackExtra        = {"npc/zombie/claw_strike1.wav","npc/zombie/claw_strike2.wav","npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss         = {"npc/zombie/claw_miss1.wav","npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_MeleeAttack             = {"npc/zombie/claw_strike1.wav","npc/zombie/claw_strike2.wav","npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_SNPCRoll                = {"general_sds/evade_roll/roll_2.wav","general_sds/evade_roll/roll_1.mp3"}
ENT.SoundTbl_GibDeath                = {"snpc/npc/hgrunt_young/hg_gibdeath01.wav","snpc/npc/hgrunt_young/hg_gibdeath02.wav","snpc/npc/hgrunt_young/hg_gibdeath03.wav","snpc/npc/hgrunt_young/hg_gibdeath04.wav","snpc/npc/hgrunt_young/hg_gibdeath05.wav","snpc/npc/hgrunt_young/hg_gibdeath06.wav","snpc/npc/hgrunt_young/hg_gibdeath07.wav","snpc/npc/hgrunt_young/hg_gibdeath08.wav","snpc/npc/hgrunt_young/hg_gibdeath09.wav","snpc/npc/hgrunt_young/hg_gibdeath10.wav","snpc/npc/hgrunt_young/hg_gibdeath11.wav","snpc/npc/hgrunt/hg_gibdeath01.wav","snpc/npc/hgrunt/hg_gibdeath02.wav","snpc/npc/hgrunt/hg_gibdeath03.wav","snpc/npc/hgrunt/hg_gibdeath04.wav","snpc/npc/hgrunt/hg_gibdeath05.wav","snpc/npc/hgrunt/hg_gibdeath06.wav","snpc/npc/hgrunt/hg_gibdeath07.wav","snpc/npc/hgrunt/hg_gibdeath08.wav","snpc/npc/hgrunt/hg_gibdeath09.wav","snpc/npc/hgrunt/hg_gibdeath10.wav","snpc/npc/hgrunt/hg_gibdeath11.wav"}
ENT.SoundTbl_Impact                  = {"snpc/wrhf/impact/flesh_impact_bullet1.wav","snpc/wrhf/impact/flesh_impact_bullet2.wav","snpc/wrhf/impact/flesh_impact_bullet3.wav","snpc/wrhf/impact/flesh_impact_bullet4.wav","snpc/wrhf/impact/flesh_impact_bullet5.wav"}
ENT.SoundTbl_ExtraArmorImpacts       = {"general_sds/hit_or_impact/helm_hs_impact/headshot_helmet_" .. mRng(1, 16) .. ".wav","general_sds/hit_or_impact/helm_hs_impact/headshot_helmet_style1_" .. mRng(1, 14) .. ".wav","general_sds/hit_or_impact/kevlar_armor/armor_hit.wav","general_sds/hit_or_impact/kevlar_armor/kevlar_hit1.wav","general_sds/hit_or_impact/kevlar_armor/kevlar_hit2.wav"}
ENT.SoundTbl_OnHeadshot              = {"general_sds/hit_or_impact/headshot/ex_headshots/headshot_flesh_" .. mRng(1, 38) .. ".wav", "general_sds/hit_or_impact/headshot/headshot_1.wav","general_sds/hit_or_impact/headshot/headshot_2.wav","general_sds/hit_or_impact/headshot/headshot_3.wav","snpc/general_sds/hit_or_impact/headshot/headshot_4.wav","general_sds/hit_or_impact/headshot/headshot_5.wav","general_sds/hit_or_impact/headshot/headshot_6.wav","general_sds/hit_or_impact/headshot/headshot_7.wav","general_sds/hit_or_impact/headshot/headshot_8.wav","general_sds/hit_or_impact/headshot/headshot_9.wav","general_sds/hit_or_impact/headshot/headshot_10.wav","general_sds/hit_or_impact/headshot/headshot_11.wav","general_sds/hit_or_impact/headshot/headshot_12.wav","general_sds/hit_or_impact/headshot/headshot_13.wav","general_sds/hit_or_impact/headshot/headshot_14.wav","general_sds/hit_or_impact/headshot/headshot_15.wav"}
ENT.DrawNewWeaponSound               = {"vj_base/weapons/draw_rifle.wav","vj_base/weapons/draw_pistol.wav"}
ENT.WaterSplashSounds                = {"player/footsteps/wade1.wav", "player/footsteps/wade2.wav","player/footsteps/wade3.wav", "player/footsteps/wade4.wav", "player/footsteps/wade5.wav", "player/footsteps/wade6.wav","player/footsteps/wade7.wav", "player/footsteps/wade8.wav", "ambient/water/water_splash1.wav", "ambient/water/water_splash2.wav", "ambient/water/water_splash3.wav"}
ENT.JumpGruntTbl                     = {"general_sds/jump_land_grunts/jump_01.wav","general_sds/jump_land_grunts/jump_02.wav","general_sds/jump_land_grunts/jump_03.wav","general_sds/jump_land_grunts/jump_04.wav","general_sds/jump_land_grunts/jump_05.wav","general_sds/jump_land_grunts/jump_06.wav"}
ENT.JumpLandGruntTbl                 = {"general_sds/jump_land_grunts/land_01.wav","general_sds/jump_land_grunts/land_02.wav","general_sds/jump_land_grunts/land_03.wav","general_sds/jump_land_grunts/land_04.wav"}
ENT.EquipmentClanging_Tbl            = {"general_sds/toolbelt_sounds/toolbelt_01.wav","general_sds/toolbelt_sounds/toolbelt_02.wav","general_sds/toolbelt_sounds/toolbelt_03.wav","general_sds/toolbelt_sounds/toolbelt_04.wav","general_sds/toolbelt_sounds/toolbelt_05.wav","general_sds/toolbelt_sounds/toolbelt_06.wav"}
ENT.ClothingRustling_Tbl             = {"general_sds/eft_gear_rustling/tac_gear_" .. mRng(1, 40) .. ".ogg"}
ENT.SoundTbl_BeforeMeleeAttack       = {"general_sds/melee/melee1.wav","general_sds/melee/melee2.wav","general_sds/melee/melee3.wav","general_sds/melee/melee4.wav","general_sds/melee/melee5.wav","general_sds/melee/melee6.wav","general_sds/melee/melee7wav","general_sds/melee/melee8.wav","general_sds/melee/melee9.wav","general_sds/melee/melee10.wav","general_sds/melee/melee11.wav","general_sds/melee/melee12.wav","general_sds/melee/melee13.wav","general_sds/melee/melee4.wav","general_sds/melee/melee15.wav","general_sds/melee/melee16.wav"}
ENT.Rein_Armor_Richochet_Tbl         = {"general_sds/richochet/ric1.wav","general_sds/richochet/ric2.wav","general_sds/richochet/ric3.wav","general_sds/richochet/ric4.wav","general_sds/richochet/ric5.wav"}
ENT.SoundTbl_BackgroundRadioDialogue = {"st_faction_sounds/mil_fac_radio_chat/mil_rnd_radio_1.ogg","st_faction_sounds/mil_fac_radio_chat/mil_rnd_radio_2.ogg","st_faction_sounds/mil_fac_radio_chat/mil_rnd_radio_3.ogg","st_faction_sounds/mil_fac_radio_chat/mil_rnd_radio_4.ogg","st_faction_sounds/mil_fac_radio_chat/mil_rnd_radio_5.ogg","st_faction_sounds/mil_fac_radio_chat/mil_rnd_radio_6.ogg","st_faction_sounds/mil_fac_radio_chat/mil_rnd_radio_7.ogg","st_faction_sounds/mil_fac_radio_chat/mil_rnd_radio_8.ogg","st_faction_sounds/mil_fac_radio_chat/radio1.wav","st_faction_sounds/mil_fac_radio_chat/radio2.wav","st_faction_sounds/mil_fac_radio_chat/radio3.wav","st_faction_sounds/mil_fac_radio_chat/radio4.wav","st_faction_sounds/mil_fac_radio_chat/radio5.wav","st_faction_sounds/mil_fac_radio_chat/radio6.wav","st_faction_sounds/mil_fac_radio_chat/radio7.wav","st_faction_sounds/mil_fac_radio_chat/radio8.wav","st_faction_sounds/mil_fac_radio_chat/radio9.wav"}
ENT.Footstep_Sneaking                = {"npc/zombie/foot1.wav","npc/zombie/foot2.wav","npc/zombie/foot3.wav"}
ENT.Flatline_DeathTbl                = {"general_sds/flatline/flatline1.wav", "general_sds/flatline/flatline2.wav", "general_sds/flatline/flatline3.wav", "general_sds/flatline/flatline4.wav", "general_sds/flatline/flatline5.wav", "general_sds/flatline/flatline6.wav", "general_sds/flatline/flatline7.wav", "general_sds/flatline/flatline8.wav"}
ENT.HazardSuit_DeathDeflate          = {"general_sds/deflate_suit_sound/ceda_suit_deflate_01.wav","general_sds/deflate_suit_sound/ceda_suit_deflate_02.wav","general_sds/deflate_suit_sound/ceda_suit_deflate_03.wav"}
ENT.RandomRadioSound                 = {"general_sds/radio_snds/radio_random1.wav", "general_sds/radio_snds/radio_random2.wav", "general_sds/radio_snds/radio_random3.wav", "general_sds/radio_snds/radio_random4.wav", "general_sds/radio_snds/radio_random5.wav", "general_sds/radio_snds/radio_random6.wav", "general_sds/radio_snds/radio_random7.wav", "general_sds/radio_snds/radio_random8.wav", "general_sds/radio_snds/radio_random9.wav", "general_sds/radio_snds/radio_random10.wav", "general_sds/radio_snds/radio_random11.wav", "general_sds/radio_snds/radio_random12.wav", "general_sds/radio_snds/radio_random13.wav", "general_sds/radio_snds/radio_random14.wav", "general_sds/radio_snds/radio_random15.wav"}
ENT.EnergyZap_Tbl                    = {"ambient/energy/zap1.wav", "ambient/energy/zap2.wav", "ambient/energy/zap3.wav", "ambient/energy/zap4.wav", "ambient/energy/zap5.wav", "ambient/energy/zap6.wav", "ambient/energy/zap7.wav", "ambient/energy/zap8.wav", "ambient/energy/zap9.wav"}

//Faction specific dialogue, will improve soon.
ENT.SoundTbl_Investigate = {"st_faction_sounds/stalker_vo/general_base_dialogue/hear_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_9.ogg"}

ENT.SoundTbl_DangerSight = {"general_sds/ext_reactions/hide_1.mp3", "general_sds/ext_reactions/hide_2.mp3", "general_sds/ext_reactions/hide_3.mp3", "general_sds/ext_reactions/hide_4.mp3", "general_sds/ext_reactions/hide_5.mp3", "general_sds/ext_reactions/hide_6.mp3", "general_sds/ext_reactions/hide_7.mp3", "general_sds/ext_reactions/hide_8.mp3"}

ENT.SoundTbl_MedicReceiveHeal = {"general_sds/ext_reactions/thanks_1.mp3", "general_sds/ext_reactions/thanks_2.mp3", "general_sds/ext_reactions/thanks_3.mp3", "general_sds/ext_reactions/thanks_4.mp3", "general_sds/ext_reactions/thanks_5.mp3", "general_sds/ext_reactions/thanks_6.mp3", "st_faction_sounds/stalker_vo/general_base_dialogue/thanx_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/thanx_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/thanx_3.ogg","general_spetsnaz_snds/gotmedic1.mp3","general_spetsnaz_snds/gotmedic2.mp3","general_spetsnaz_snds/gotmedic3.mp3","general_spetsnaz_snds/gotmedic4.mp3","general_spetsnaz_snds/gotmedic5.mp3","general_spetsnaz_snds/gotmedic6.mp3","general_spetsnaz_snds/gotmedic7.mp3"}

ENT.SoundTbl_MedicBeforeHeal = {"st_faction_sounds/stalker_vo/general_base_dialogue/medkit_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/medkit_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/medkit_3.ogg","general_spetsnaz_snds/health01.wav","general_spetsnaz_snds/health02.wav","general_spetsnaz_snds/health03.wav","general_spetsnaz_snds/health04.wav","general_spetsnaz_snds/health05.wav","general_spetsnaz_snds/heal1.mp3","general_spetsnaz_snds/heal2.mp3","general_spetsnaz_snds/heal3.mp3","general_spetsnaz_snds/heal4.mp3","general_spetsnaz_snds/heal5.mp3","general_spetsnaz_snds/heal6.mp3","general_spetsnaz_snds/heal7.mp3","general_spetsnaz_snds/heal8.mp3","general_spetsnaz_snds/heal9.mp3","general_spetsnaz_snds/heal10.mp3"}

ENT.SoundTbl_Breath = {"st_faction_sounds/stalker_vo/general_base_dialogue/breath_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/breath_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/breath_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/breath_4.ogg"}

ENT.SoundTbl_Idle = {"st_faction_sounds/stalker_vo/general_base_dialogue/idle_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_14.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_15.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_16.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_17.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_18.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_19.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_20.ogg","general_spetsnaz_snds/free1.wav","general_spetsnaz_snds/free2.wav","general_spetsnaz_snds/free3.wav","general_spetsnaz_snds/free4.wav","general_spetsnaz_snds/free5.wav","general_spetsnaz_snds/free6.wav","general_spetsnaz_snds/free7.wav","general_spetsnaz_snds/free8.wav","general_spetsnaz_snds/free9.wav","general_spetsnaz_snds/free10.wav","general_spetsnaz_snds/free11.wav","general_spetsnaz_snds/free12.wav","general_spetsnaz_snds/free13.wav","general_spetsnaz_snds/free14.wav","general_spetsnaz_snds/free15.wav","general_spetsnaz_snds/free16.wav","general_spetsnaz_snds/free17.wav","general_spetsnaz_snds/free18.wav","general_spetsnaz_snds/free19.wav","general_spetsnaz_snds/free20.wav","general_spetsnaz_snds/free21.wav","general_spetsnaz_snds/free22.wav","general_spetsnaz_snds/free23.wav","general_spetsnaz_snds/free24.wav","general_spetsnaz_snds/free25.wav","general_spetsnaz_snds/free26.wav","general_spetsnaz_snds/free27.wav","general_spetsnaz_snds/free28.wav","general_spetsnaz_snds/free29.wav","general_spetsnaz_snds/free30.wav","general_spetsnaz_snds/idledraft1.wav","general_spetsnaz_snds/idledraft2.wav","general_spetsnaz_snds/idledraft3.wav","general_spetsnaz_snds/idledraft4.wav","general_spetsnaz_snds/idledraft5.wav","general_spetsnaz_snds/idleburp.wav","general_spetsnaz_snds/idlewhistle.wav","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_1.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_2.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_3.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_4.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_5.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_6.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_7.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_8.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_9.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_10.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_11.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_12.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_13.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_14.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_15.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_16.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_17.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_18.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_19.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_20.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_21.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_22.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_23.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_24.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_25.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_26.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_27.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_28.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_29.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_30.ogg","general_spetsnaz_snds/chat1.mp3","general_spetsnaz_snds/chat2.mp3","general_spetsnaz_snds/chat3.mp3","general_spetsnaz_snds/chat4.mp3","general_spetsnaz_snds/chat5.mp3","general_spetsnaz_snds/chat6.mp3","general_spetsnaz_snds/chat7.mp3","general_spetsnaz_snds/chat8.mp3","general_spetsnaz_snds/chat9.mp3","general_spetsnaz_snds/chat10.mp3","general_spetsnaz_snds/chat11.mp3","general_spetsnaz_snds/chat12.mp3","general_spetsnaz_snds/chat13.mp3","general_spetsnaz_snds/chat14.mp3","general_spetsnaz_snds/chat15.mp3","general_spetsnaz_snds/chat16.mp3","general_spetsnaz_snds/chat17.mp3","general_spetsnaz_snds/chat18.mp3","general_spetsnaz_snds/chat19.mp3"}

ENT.SoundTbl_Alert = {"st_faction_sounds/stalker_vo/general_base_dialogue/detour_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/detour_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/detour_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/detour_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/detour_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/detour_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_6.ogg","general_spetsnaz_snds/alert1.wav","general_spetsnaz_snds/alert2.wav","general_spetsnaz_snds/alert3.wav","general_spetsnaz_snds/alert4.wav","general_spetsnaz_snds/alert5.wav","general_spetsnaz_snds/alert6.wav","general_spetsnaz_snds/alert7.wav","general_spetsnaz_snds/alert8.wav","general_spetsnaz_snds/alert9.wav","general_spetsnaz_snds/alert1.wav","general_spetsnaz_snds/alert2.wav","general_spetsnaz_snds/alert3.wav","general_spetsnaz_snds/alert4.wav","general_spetsnaz_snds/alert5.wav","general_spetsnaz_snds/alert6.wav","general_spetsnaz_snds/alert7.wav","general_spetsnaz_snds/alert8.wav","general_spetsnaz_snds/alert9.wav","general_spetsnaz_snds/alert10.wav","general_spetsnaz_snds/alert11.wav","st_faction_sounds/stalker_vo/general_base_dialogue/panic_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/panic_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/panic_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/panic_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/panic_5.ogg","general_spetsnaz_snds/VO_RU_Grunt_ContactCall_01A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_ContactCall_02A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_ContactCall_03A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_ContactCall_04A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_ContactCall_05A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_ContactCall_06A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_ContactCall_07A_DimitryRozental.ogg"}

ENT.SoundTbl_CombatIdle = {"st_faction_sounds/stalker_vo/general_base_dialogue/attack_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_14.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_7.ogg","general_spetsnaz_snds/attack1.wav","general_spetsnaz_snds/attack2.wav","general_spetsnaz_snds/attack3.wav","general_spetsnaz_snds/attack4.wav","general_spetsnaz_snds/attack5.wav","general_spetsnaz_snds/attack6.wav","general_spetsnaz_snds/attack7.wav","general_spetsnaz_snds/attack8.wav","general_spetsnaz_snds/attack9.wav","general_spetsnaz_snds/attack10.wav","general_spetsnaz_snds/attack11.wav","general_spetsnaz_snds/attack12.wav","general_spetsnaz_snds/attack13.wav","general_spetsnaz_snds/attack14.wav","general_spetsnaz_snds/attack15.wav","general_spetsnaz_snds/attack16.wav","general_spetsnaz_snds/attack1.wav","general_spetsnaz_snds/attack2.wav","general_spetsnaz_snds/attack3.wav","general_spetsnaz_snds/attack4.wav","general_spetsnaz_snds/attack5.wav","general_spetsnaz_snds/attack6.wav","general_spetsnaz_snds/attack7.wav","russian/attack1.wav","russian/attack2.wav","russian/attack3.wav","russian/attack4.wav","russian/attack5.wav","russian/attack6.wav","russian/attack7.wav","russian/attack8.wav","russian/attack9.wav","russian/attack10.wav","russian/attack11.wav","russian/attack12.wav","general_spetsnaz_snds/combat1.mp3","general_spetsnaz_snds/combat2.mp3","general_spetsnaz_snds/combat3.mp3","general_spetsnaz_snds/combat4.mp3","general_spetsnaz_snds/combat5.mp3","general_spetsnaz_snds/combat6.mp3","general_spetsnaz_snds/combat7.mp3","general_spetsnaz_snds/combat8.mp3","general_spetsnaz_snds/combat9.mp3","general_spetsnaz_snds/combat10.mp3","general_spetsnaz_snds/combat11.mp3","general_spetsnaz_snds/combat12.mp3","general_spetsnaz_snds/combat13.mp3","general_spetsnaz_snds/combat14.mp3","general_spetsnaz_snds/combat15.mp3","general_spetsnaz_snds/combat16.mp3","general_spetsnaz_snds/combat17.mp3","general_spetsnaz_snds/combat18.mp3","general_spetsnaz_snds/combat19.mp3","general_spetsnaz_snds/combat20.mp3"}

ENT.SoundTbl_Suppressing = {"st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_14.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_7.ogg","general_spetsnaz_snds/pursuing1.wav","general_spetsnaz_snds/pursuing2.wav","general_spetsnaz_snds/pursuing3.wav","general_spetsnaz_snds/pursuing4.wav","general_spetsnaz_snds/pursuing5.wav","general_spetsnaz_snds/pursuing6.wav", "general_spetsnaz_snds/suppressing1.wav","general_spetsnaz_snds/suppressing2.wav","general_spetsnaz_snds/suppressing3.wav","general_spetsnaz_snds/suppressing4.wav","general_spetsnaz_snds/suppressing5.wav","general_spetsnaz_snds/suppressing6.wav","general_spetsnaz_snds/suppressing7.wav","general_spetsnaz_snds/suppressing8.wav","general_spetsnaz_snds/suppressing9.wav","general_spetsnaz_snds/suppressing10.wav","general_spetsnaz_snds/suppressing11.wav","general_spetsnaz_snds/suppressing12.wav","general_spetsnaz_snds/suppressing1.wav","general_spetsnaz_snds/suppressing2.wav","general_spetsnaz_snds/suppressing3.wav","general_spetsnaz_snds/suppressing4.wav","general_spetsnaz_snds/suppressing5.wav","general_spetsnaz_snds/suppressing6.wav","general_spetsnaz_snds/suppressing7.wav","general_spetsnaz_snds/suppressing8.wav","general_spetsnaz_snds/suppressing9.wav","general_spetsnaz_snds/suppressing10.wav","general_spetsnaz_snds/suppressing11.wav","general_spetsnaz_snds/suppressing12.wav","general_spetsnaz_snds/suppressing13.wav","general_spetsnaz_snds/suppressing14.wav","general_spetsnaz_snds/suppressing15.wav","general_spetsnaz_snds/suppressing16.wav","general_spetsnaz_snds/suppressing17.wav","general_spetsnaz_snds/suppressing18.wav","general_spetsnaz_snds/suppressing19.wav","general_spetsnaz_snds/suppressing20.wav"}

ENT.SoundTbl_WeaponReload = {"general_spetsnaz_snds/reloading1.wav","general_spetsnaz_snds/reloading2.wav","general_spetsnaz_snds/reloading3.wav","general_spetsnaz_snds/reloading4.wav","general_spetsnaz_snds/reloading5.wav","general_spetsnaz_snds/reloading6.wav","general_spetsnaz_snds/reloading7.wav","general_spetsnaz_snds/reloading8.wav","general_spetsnaz_snds/reloading9.wav","general_spetsnaz_snds/reloading10.wav","general_spetsnaz_snds/reloading11.wav","general_spetsnaz_snds/reloading12.wav","general_spetsnaz_snds/reloading13.wav","general_spetsnaz_snds/reloading14.wav","general_spetsnaz_snds/reloading15.wav","general_spetsnaz_snds/reloading16.wav","general_spetsnaz_snds/reloading17.wav","general_spetsnaz_snds/reloading18.wav","general_spetsnaz_snds/reloading19.wav","general_spetsnaz_snds/reloading20.wav","general_spetsnaz_snds/reloading21.wav","general_spetsnaz_snds/reloading22.wav","general_spetsnaz_snds/reloading23.wav","general_spetsnaz_snds/reloading24.wav","general_spetsnaz_snds/reloading25.wav","general_spetsnaz_snds/reloading26.wav","general_spetsnaz_snds/reloading27.wav","general_spetsnaz_snds/reloading28wav","general_spetsnaz_snds/reloading29.wav","general_spetsnaz_snds/reloading1.wav","general_spetsnaz_snds/reloading2.wav","general_spetsnaz_snds/reloading3.wav","general_spetsnaz_snds/reloading4.wav","general_spetsnaz_snds/reloading5.wav","general_spetsnaz_snds/reloading6.wav","general_spetsnaz_snds/reloading7.wav","general_spetsnaz_snds/reloading8.wav"}

ENT.SoundTbl_GrenadeAttack = {"general_spetsnaz_snds/fragout1.wav","general_spetsnaz_snds/fragout2.wav","general_spetsnaz_snds/fragout3.wav","general_spetsnaz_snds/fragout4.wav","general_spetsnaz_snds/fragout5.wav","general_spetsnaz_snds/fragout6.wav","general_spetsnaz_snds/fragout7.wav","general_spetsnaz_snds/fragout8.wav","general_spetsnaz_snds/fragout9.wav","general_spetsnaz_snds/fragout10.wav","general_spetsnaz_snds/fragout11.wav","general_spetsnaz_snds/fragout12.wav","general_spetsnaz_snds/fragout13.wav","general_spetsnaz_snds/fragout14.wav","general_spetsnaz_snds/fragout1.wav","general_spetsnaz_snds/fragout2.wav","general_spetsnaz_snds/fragout3.wav","general_spetsnaz_snds/fragout4.wav","general_spetsnaz_snds/fragout5.wav","general_spetsnaz_snds/fragout6.wav","general_spetsnaz_snds/fragout7.wav","general_spetsnaz_snds/fragout8.wav","general_spetsnaz_snds/fragout9.wav","general_spetsnaz_snds/fragout10.wav","general_spetsnaz_snds/fragout11.wav","general_spetsnaz_snds/fragout12.wav","general_spetsnaz_snds/fragout13.wav","general_spetsnaz_snds/fragout14.wav","general_spetsnaz_snds/fragout15.wav","general_spetsnaz_snds/fragout16.wav","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready7_.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/ready_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/ready_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/ready_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/ready_4.ogg","general_spetsnaz_snds/VO_RU_SL_FragOut_01A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_FragOut_02A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_FragOut_03A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_FragOut_04A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_FragOut_05A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_FragOut_06A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_FragOut_07A_AleksandrJuriev.ogg"}

ENT.SoundTbl_OnGrenadeSight = {"general_spetsnaz_snds/grenade1.wav","general_spetsnaz_snds/grenade2.wav","general_spetsnaz_snds/grenade3.wav","general_spetsnaz_snds/grenade4.wav","general_spetsnaz_snds/grenade5.wav","general_spetsnaz_snds/grenade6.wav","general_spetsnaz_snds/grenade7.wav","general_spetsnaz_snds/grenade8.wav","general_spetsnaz_snds/grenade9.wav","general_spetsnaz_snds/grenade10.wav","general_spetsnaz_snds/grenade11.wav","general_spetsnaz_snds/grenade12.wav","general_spetsnaz_snds/grenade13.wav","general_spetsnaz_snds/grenade14.wav","general_spetsnaz_snds/grenade15.wav","general_spetsnaz_snds/grenade16.wav","general_spetsnaz_snds/grenade17.wav","general_spetsnaz_snds/grenade18.wav","general_spetsnaz_snds/grenade19.wav","general_spetsnaz_snds/grenade20.wav","general_spetsnaz_snds/grenade21.wav","general_spetsnaz_snds/grenade22.wav","general_spetsnaz_snds/grenade23.wav","general_spetsnaz_snds/grenade24.wav","general_spetsnaz_snds/grenade25.wav","general_spetsnaz_snds/grenade26.wav","general_spetsnaz_snds/grenade27.wav","general_spetsnaz_snds/grenade28.wav","general_spetsnaz_snds/grenade29.wav","general_spetsnaz_snds/grenade30.wav","general_spetsnaz_snds/grenade31.wav","general_spetsnaz_snds/grenade32.wav","general_spetsnaz_snds/grenade33.wav","general_spetsnaz_snds/grenade34.wav"}

ENT.SoundTbl_OnKilledEnemy = {"st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_8.ogg","general_spetsnaz_snds/kill1.wav","general_spetsnaz_snds/kill2.wav","general_spetsnaz_snds/kill3.wav","general_spetsnaz_snds/kill4.wav","general_spetsnaz_snds/kill5.wav","general_spetsnaz_snds/kill6.wav","general_spetsnaz_snds/kill7.wav","general_spetsnaz_snds/kill8.wav","general_spetsnaz_snds/kill9.wav","general_spetsnaz_snds/kill10.wav","general_spetsnaz_snds/kill1.wav","general_spetsnaz_snds/kill2.wav","general_spetsnaz_snds/kill3.wav","general_spetsnaz_snds/kill4.wav","general_spetsnaz_snds/kill5.wav","general_spetsnaz_snds/kill6.wav","general_spetsnaz_snds/kill7.wav","general_spetsnaz_snds/kill8.wav","general_spetsnaz_snds/kill9.wav","general_spetsnaz_snds/kill10.wav","st_faction_sounds/stalker_vo/general_base_dialogue/dead_enemy_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/dead_enemy_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/dead_enemy_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/dead_enemy_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/dead_enemy_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/dead_enemy_6.ogg"}

ENT.SoundTbl_AllyDeath = {"general_spetsnaz_snds/casualty1.wav","general_spetsnaz_snds/casualty2.wav","general_spetsnaz_snds/casualty3.wav","general_spetsnaz_snds/casualty4.wav","general_spetsnaz_snds/casualty5.wav","general_spetsnaz_snds/casualty6.wav","general_spetsnaz_snds/casualty7.wav","general_spetsnaz_snds/casualty8.wav","general_spetsnaz_snds/casualty9.wav","general_spetsnaz_snds/casualty10.wav","general_spetsnaz_snds/casualty11.wav","general_spetsnaz_snds/casualty12.wav","general_spetsnaz_snds/casualty13.wav","general_spetsnaz_snds/casualty14.wav","general_spetsnaz_snds/casualty15.wav","general_spetsnaz_snds/casualty16.wav","general_spetsnaz_snds/casualty17.wav","general_spetsnaz_snds/casualty18.wav","general_spetsnaz_snds/casualty19.wav","general_spetsnaz_snds/casualty20.wav","general_spetsnaz_snds/casualty21.wav","general_spetsnaz_snds/casualty22.wav","general_spetsnaz_snds/casualty23.wav","general_spetsnaz_snds/casualty24.wav","general_spetsnaz_snds/casualty25.wav","general_spetsnaz_snds/casualty2.wav","general_spetsnaz_snds/casualty27.wav","general_spetsnaz_snds/casualty28.wav","general_spetsnaz_snds/casualty29.wav","general_spetsnaz_snds/casualty30.wav","general_spetsnaz_snds/casualty31.wav","general_spetsnaz_snds/casualty32.wav","general_spetsnaz_snds/casualty33.wav","general_spetsnaz_snds/casualty34.wav"}

ENT.SoundTbl_CombatIdle = {"st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_14.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/fire_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/fire_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/fire_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/fire_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/fire_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_1stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_2stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_3stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_4stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_5stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_6stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_1stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_2stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_3stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_4stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_5stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_14.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_15.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_1stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_2stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_3stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_4stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_5stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_6stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_7stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_8stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_9stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_10stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_11stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_12stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_13stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_14stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_15stalker.ogg"}

ENT.SoundTbl_LostEnemy = {"st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_1stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_2stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_3stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_4stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_5stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_6stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_7stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_8stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_9stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_10stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_1stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_2stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_3stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_4stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_5stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_6stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_7stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_8stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_9stalker.ogg"}

ENT.SoundTbl_IdleDialogue = {"general_spetsnaz_snds/dia_1.wav","general_spetsnaz_snds/dia_2.wav","general_spetsnaz_snds/idled.mp3","general_spetsnaz_snds/idled.mp3","general_spetsnaz_snds/idled2.mp3","general_spetsnaz_snds/idled3.mp3","general_spetsnaz_snds/idled4.mp3","general_spetsnaz_snds/idled5.mp3"}

ENT.SoundTbl_IdleDialogueAnswer = {"general_spetsnaz_snds/VO_RU_SL_Negative_01A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Negative_02A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Negative_03A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Negative_04A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Negative_05A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Negative_06A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Negative_07A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Negative_08A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_Grunt_Negative_01A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Negative_02A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Negative_03A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Negative_04A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Negative_05A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Negative_06A_DimitryRozental.ogg","general_spetsnaz_snds/dia_1_response.wav","general_spetsnaz_snds/dia_2_response.wav","general_spetsnaz_snds/VO_RU_Grunt_Affirmative_01A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Affirmative_02A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Affirmative_03A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Affirmative_04A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Affirmative_05A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Affirmative_06A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Affirmative_07A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Affirmative_08A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_SL_Affirmative_01A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Affirmative_02A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Affirmative_03A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Affirmative_04A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Affirmative_05A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Affirmative_06A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Affirmative_07A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Affirmative_08A_AleksandrJuriev.ogg"}

ENT.SoundTbl_CallForHelp = {"st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_14.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_01A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_02A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_03A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_04A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_05A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_06A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_07A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_08A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_09A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_10A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_11A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_12A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_13A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_14A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_15A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_16A_DimitryRozental.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_14.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_15.ogg"}

ENT.SoundTbl_OnReceiveOrder = {"general_spetsnaz_snds/VO_RU_Grunt_Affirmative_01A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Affirmative_02A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Affirmative_03A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Affirmative_04A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Affirmative_05A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Affirmative_06A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Affirmative_07A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Affirmative_08A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_SL_Affirmative_01A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Affirmative_02A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Affirmative_03A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Affirmative_04A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Affirmative_05A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Affirmative_06A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Affirmative_07A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Affirmative_08A_AleksandrJuriev.ogg"}

ENT.SoundTbl_BecomeEnemyToPlayer = {"st_faction_sounds/stalker_vo/general_base_dialogue/friendly_fire_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/friendly_fire_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/friendly_fire_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/friendly_fire_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/friendly_fire_5.ogg","general_spetsnaz_snds/wetrustedyou01.wav","general_spetsnaz_snds/wetrustedyou02.wav","general_spetsnaz_snds/becomehos1.mp3","general_spetsnaz_snds/becomehos2.mp3","general_spetsnaz_snds/becomehos3.mp3","general_spetsnaz_snds/becomehos4.mp3"}

ENT.SoundTbl_DamageByPlayer = {"general_sds/ext_reactions/fr_fire_" .. mRng(1, 18) .. ".mp3","general_spetsnaz_snds/eft_bear_friendlyfire1.wav","general_spetsnaz_snds/eft_bear_friendlyfire2.wav","general_spetsnaz_snds/eft_bear_friendlyfire3.wav","general_spetsnaz_snds/eft_bear_friendlyfire4.wav","general_spetsnaz_snds/eft_bear_friendlyfire5.wav","general_spetsnaz_snds/eft_bear_friendlyfire6.wav","general_spetsnaz_snds/eft_bear_friendlyfire7.wav","general_spetsnaz_snds/eft_bear_friendlyfire8.wav","general_spetsnaz_snds/eft_bear_friendlyfire9.wav","general_spetsnaz_snds/eft_bear_friendlyfire10.wav","general_spetsnaz_snds/eft_bear_friendlyfire11.wav","general_spetsnaz_snds/eft_bear_friendlyfire12.wav","general_spetsnaz_snds/eft_bear_friendlyfire13.wav","general_spetsnaz_snds/eft_bear_friendlyfire14.wav","general_spetsnaz_snds/eft_bear_friendlyfire15.wav","general_spetsnaz_snds/eft_bear_friendlyfire16.wav","general_spetsnaz_snds/eft_bear_friendlyfire1.wav","general_spetsnaz_snds/playerdamage1.mp3","general_spetsnaz_snds/playerdamage2.mp3","general_spetsnaz_snds/playerdamage3.mp3","general_spetsnaz_snds/playerdamage4.mp3","general_spetsnaz_snds/playerdamage5.mp3","general_spetsnaz_snds/playerdamage6.mp3"}

ENT.SoundTbl_FollowPlayer = {"general_spetsnaz_snds/leadtheway01.wav","general_spetsnaz_snds/leadtheway02.wav","general_spetsnaz_snds/okimready01.wav","general_spetsnaz_snds/okimready02.wav","general_spetsnaz_snds/okimready03.wav","general_spetsnaz_snds/follow1.mp3","general_spetsnaz_snds/follow2.mp3","general_spetsnaz_snds/follow3.mp3","general_spetsnaz_snds/follow4.mp3","general_spetsnaz_snds/follow5.mp3","general_spetsnaz_snds/follow6.mp3","general_spetsnaz_snds/follow7.mp3","general_spetsnaz_snds/follow8.mp3","general_spetsnaz_snds/follow9.mp3","general_spetsnaz_snds/follow10.mp3","general_spetsnaz_snds/follow11.mp3","general_spetsnaz_snds/follow12.mp3","general_spetsnaz_snds/follow13.mp3"}

ENT.SoundTbl_UnFollowPlayer = {"general_spetsnaz_snds/illstayhere01.wav","general_spetsnaz_snds/holddownspot01.wav","general_spetsnaz_snds/holddownspot02.wav","general_spetsnaz_snds/nofollow1.mp3","general_spetsnaz_snds/nofollow2.mp3","general_spetsnaz_snds/nofollow3.mp3","general_spetsnaz_snds/nofollow4.mp3","general_spetsnaz_snds/nofollow5.mp3","general_spetsnaz_snds/nofollow6.mp3","general_spetsnaz_snds/nofollow7.mp3","general_spetsnaz_snds/nofollow8.mp3"}

ENT.SoundTbl_YieldToPlayer = {"general_sds/ext_reactions/sorry_1.mp3","general_sds/ext_reactions/sorry_2.mp3","general_sds/ext_reactions/sorry_3.mp3","general_sds/ext_reactions/sorry_4.mp3","general_sds/ext_reactions/sorry_5.mp3","general_sds/ext_reactions/sorry_6.mp3","general_spetsnaz_snds/sorry01.wav","general_spetsnaz_snds/sorry02.wav","general_spetsnaz_snds/excuseme01.wav","general_spetsnaz_snds/excuseme02.wav","general_spetsnaz_snds/pardonme02.wav","general_spetsnaz_snds/pardonme01.wav","general_spetsnaz_snds/bump1.mp3","general_spetsnaz_snds/bump2.mp3","general_spetsnaz_snds/bump3.mp3","general_spetsnaz_snds/bump4.mp3","general_spetsnaz_snds/bump5.mp3","general_spetsnaz_snds/bump6.mp3"}
---------------------------------------------------------------------------------------------------------------------------------------------
   -- [Custom Code] -- 

   -- [Custom Debug]
ENT.RANDOMS_DEBUG = false 

    -- [Drop grenade when interacted with and incapacitated] --
ENT.CanDropNadeOnIncap = false  
ENT.LastGrenadeSpawnTime = 0 
ENT.ChanceDropNade  = mRng(2,3)

    -- [On player use/interact with friendly SNPC] -- 
ENT.CanReactToUse = true -- Controls the reaction (flinch) mechanic
ENT.ReactToUseDelay = mRand(0.05, 0.25) -- Delay before reaction animation
ENT.ReactToUseCooldown = mRand(1, 15) -- Base cooldown before another reaction
ENT.LastReactToUseTime = 0 -- Tracks the last time a reaction happened
ENT.ReactToPlyUseAnim = {"flinch_stomach_small_01", "flinch_stomach_small_02", "flinch_gesture", "flinch_gen_small_01", "flinch_gen_small_02", "flinch_gen_small_03"}
ENT.ReactToPlyIntChance = 3 -- 1 out of x chance to play the react anim

    -- [NPC Presets] -- 
ENT.IsHeavilyArmored = false

ENT.IsOfficer = false

ENT.IsScientific = false 
ENT.SevaSuitDeflateChance = mRng(1,3) -- Chance for deflate sound to play on death

    -- [Super heavy movement] -- 
ENT.HeavyUnitHasSlowMoveChance = true 
ENT.HeavySlowMoveChance = 3 
ENT.HasSlowHeavyMovement = false  
ENT.HasSlowHeavyFootsteps = false 

    -- [Mng friendly state] -- 
ENT.FriendlyConvar = false -- Convar name used to set NPC factoin friendly to player 
ENT.FriendlyNPC_Class = false -- Friendly faction tbl 

    -- [Rng behaviors] -- 
ENT.RngPickMoveAndShoot = true
ENT.CanBackAwayWithWeapon = false
ENT.HasStrafeFire = false 
ENT.HasMoveAndShoot = false 

    -- [Extra footstep sounds] --
ENT.HasEquipmentRustle = true 
ENT.HasClothingRustle = true 

    -- [Retreat after melee attack] -- 
ENT.Flee_AfterMelee = true 
ENT.Flee_AfterMeleeChance = 2
ENT.Flee_AfterMeleeT = 0

    -- [Panic on ally killed] --
ENT.Flee_OnAllyDeath = true
ENT.IsPanicked = false
ENT.Flee_CombatChance = 6 
ENT.Flee_IdleChance = 3 
ENT.PanicCooldownT = 0

    -- [Taunt on kill enemy] -- 
ENT.TauntKill_OnEne = true
ENT.TauntKill_Chance = 1
ENT.TauntKill_SeqAnimTbl = {"cheer1", "cheer2", "wave_smg1"}
ENT.TauntKill_GesAnimTbl = {"g_pumpleft_rpgdown", "g_pumpleft_rpgright"}
ENT.TauntKill_Conv = "vj_stalker_taunt"
ENT.TauntKill_NextT = 0
ENT.TauntKill_MinDist = 1500
ENT.TauntKill_MaxDist = 2500 

    -- [Landing mechanic] --
ENT.Detect_LandAnim = true
ENT.Landing_Effects = true 
ENT.LargeLandFx = false 
ENT.IsLanding = false 
ENT.Jump_GruntSounds = true 
ENT.Jump_LandGruntSounds = true 
ENT.Landing_FxScale = 75
ENT.NextLandAnimCheckT = 0

    -- [Radio chatter sounds] -- 
ENT.HasAccessToRadio = false -- Main controller [Only mil & peacekeepers have access!] -- 
ENT.HasRadioChatDialogue = false 
ENT.HasRadioSpawnChance = 4
ENT.BackGround_RadioLevel = 70
ENT.BackGround_RadioPitch1 = 85
ENT.BackGround_RadioPitch2 = 105
ENT.NextRadioDialogueT = 0
ENT.NextSoundTime_RadioDialogue1 = 15
ENT.NextSoundTime_RadioDialogue2 = 45
ENT.RadioDialogieChance = mRng(1,4)

    -- [Manage weapon fire strafing] --
ENT.FireModeChangeOnDist = true
ENT.MaxDistStopStrafeFire = mRand(4500, 5000) -- Max distance where M & Sh + M & St
ENT.MoveFireToggleCooldown = 1 

    -- [Manage extra variable timers] -- 

     -- [Damage type scales] -- 
ENT.HasRngDmgScale = true  
ENT.HasBulletDmgScale = true

    -- [Danger detection] --
ENT.IsDetectingDanger = false
ENT.IsPanickedStateT = 5
ENT.HasDetectDangerAnim = true 
ENT.DetectDangerReactAnim = {"gesture_signal_takecover","gesture_signal_right","gesture_signal_left","gesture_signal_forward","gesture_signal_group"}
ENT.DetectDangerAnimChance = 3 

    -- [Incapacitation cry for help sounds] -- 
ENT.HasCryForAidSounds = true
ENT.NextCryForAidSoundT = 0
ENT.CryForAid_NextT1 = 10
ENT.CryForAid_NextT2 = 25
ENT.CryForAidSoundChance = 3
ENT.CryForAidSoundPitch1 = 85
ENT.CryForAidSoundPitch2 = 125
ENT.CryForAidSoundLevel = mRng(90, 125)

    -- [Heal self] -- 
ENT.CanHumanHealSelf = false
ENT.CurrentlyHealSelf = false
ENT.HealSelf_AnimTbl = "heal_self"
ENT.SelfHeal_HandAtt = {"grenade_attachment", "anim_attachment_LH"}
ENT.HealSelf_NextT = 0
ENT.HealSelfDelay = mRand(0.5, 4.5)
ENT.Medic_PrioritizeAlly = true
ENT.Medic_AllyHpPrior = 0.65
ENT.SelfHeal_Fail = true
ENT.SelfHeal_FailChance = 15
ENT.FindCov_PriorSH = true 

    -- [Follow player reaction] -- 


    -- [Seek out medic] --
ENT.CanSeekOutMedic = true
ENT.MedicSeekCoolT = 5 
ENT.MedicSeekRange = 1500
ENT.MedicApprStopDist = 350
ENT.MedicNoAprDist = 250  
ENT.NextMedicSeekT = 0
ENT.CurrentMedicTarget = nil

    -- [Limited gren count] --
ENT.LimitedGrenades = true 
ENT.LimitedGrenCount_Min = 1
ENT.LimitedGrenCount_Max = 10 
ENT.HumanGrenadeCount = 0

    -- [Pickup anim tbl] -- 
ENT.PlyPickUpAnim = {"pickup","civil_proc_pickup"}

    -- [React to fire] --
ENT.ReactToFireDance = true
ENT.CurrentlyBurning = false
ENT.HasFireSpecPain = true 
ENT.HasPlayedBurnDeathSound = false
ENT.BurnAnim_NextT = 0
ENT.OnFireIdle_Anim = {"DANCE_01","bugbait_hit"}

    -- [Gibbing] -- 
ENT.ChanceToGib = 3 -- Picks random number from 1 to this value

    -- [Dodge/evade ability] --
ENT.CombatEvade = false -- Controls mechanic
ENT.CombatRoll = true -- Allows combat roll anims
ENT.IsHumanDodging = false 

ENT.Dodge_EneMin_Dist = 650
ENT.Dodge_EneMax_Dist = 5000 
ENT.Dodge_RollF_MxDist = 1250
ENT.Has_CmbDodgeChance = 3
ENT.Dodge_NextT = 0

    // -- Incapacitation feature -- \\ 
ENT.NextIdleLoopT = 0
ENT.CanBecomeIncapicitated = true 
ENT.NowIdleIncap = false -- Indicates that IncapicitatedIdleAnim is playing --
ENT.PlatingIncapAnim = false -- Indicates that BecomeIncappedAnim is playing --
ENT.IsCurrentlyIncapacitated = false -- Tracks if the SNPC is currently incapacitated --
ENT.NeverBecomeIncappedAgain = false -- Set to true after incap counter recahes their max amount to stop further incapacitation --
ENT.PlayingRecoverAnim = false -- Indicated that RecoverFromIncapAnim is playing --
ENT.SpawnGrenadeWhenIncap = true -- Allows SNPC to spawn grenade ent when interected with hostile player -- 
ENT.DropLiveGrenadeWhenDowned = false -- When interected with, they'll drop a live grenade if player is hostile --
ENT.IncapAnimsInitialized = false -- Track when anim params are completely set up -- 
ENT.IncapAmount = mRng(1,3)  -- How many times an SNPC can be downed before they just die -- 
ENT.IncapCounter = 0 -- Tracks the number of times the SNPC has been downed -- 
ENT.AllowAutoRevive = true -- Flag to control if auto revival system is enabled --
ENT.AutoReviveTimer = nil -- Stores the timer for auto revival check --
ENT.AutoReviveDelay = mRand(30,90) -- Time in seconds before auto revival check -- 

ENT.BecomeIncappedAnim = nil
ENT.IncapicitatedIdleAnim = nil
ENT.RecoverFromIncapAnim = nil

    -- [Door kicking] -- 
ENT.AllowedToKickDownDoors = true
ENT.DoorBreakPlyVisFx = true 
ENT.DoorBreakPlyVisMaxDist = 80
ENT.NextBreakDownDoorT = 0
ENT.KickDownDoorAnims = {"kick_door", "civil_proc_kickdoorbaton"}

    -- [Placing cmb flares] -- 
ENT.CanDeployFlareInCombat = true 
ENT.IsCurrentlyDeployingAFlare = false
ENT.FlareDeployAttemptCheck = false  
ENT.RequireAllyToDepFlare = true 
ENT.RetreatAfterDeployFlare = true 
ENT.CombatFlareDeployT = 0
ENT.DeployCombatFlareChance = 10 
ENT.DepFlareAllyCheckDist = 5000 

    -- [Is alone behavior] -- 
ENT.HasAloneAiBehaviour = true 
ENT.FindAllyDistance = 3500
ENT.IsCurrentlyAlone = false 

    -- [Min dmg cap] -- 
ENT.MinDmg_CapAbility = true
ENT.MinDmg_Cap_Feedback_Sfx = true 
ENT.MinDmg_Cap_Feedback_Sfx_Chance = 2
ENT.MinDmg_Cap_Chance = 6
ENT.MinDmg_Cap_NextT = 0 
ENT.MinDmg_Cap = mRng(5, 9) -- Dmg threshold

    -- [Armor] -- 
ENT.ArmorSparking = true 
ENT.ArmorSparking_Chance = mRng(1, 12)
ENT.Armor_SparkMag_Min = 0.5
ENT.Armor_SparkMag_Max = 1.25
ENT.Armor_SparkLeg_Min = 0.5
ENT.Armor_SparkLeg_Max = 3.5
ENT.Armor_SparkNextT = 0 
ENT.Armor_SparkColor = "255 255 255"

ENT.HasBulletRichocheting = true 
ENT.Arm_BulRichocheting = false
ENT.Arm_BulRichocheting_Chance = 10 

    -- [Tracking tags] -- 
ENT.SNPCMedicTag = false
ENT.DoesNotHaveCoverReload = false -- tracks variable "Weapon_FindCoverOnReload" status. 
ENT.HasGrenadeAttackMechRng = true 
ENT.Grenade_PermBlocked = false 

    -- [Unique brutal sounds] -- 
ENT.HasBrutalDeathSounds = true 
ENT.HasBrutalPainSounds = true 
ENT.HasBrutalCFASounds = true 
ENT.RON_DeahtSounds = true 

    -- [Wep flashlight] --
ENT.AllowedToHaveWepFlashLight = true -- Main variable --
ENT.WeaponFlashLightChance = 5 -- Rng chance to spawn with flashlight --
ENT.HumanWepHasWepFlashLight = false -- Track if NPC has weapon/owner --
ENT.WeaponFlashlightFlag = false -- Track the weapon -- 
ENT.HasWeaponFlashGlowOrb = true -- Control glowing sprite -- 
ENT.FlashLightGlowOrbChance = 2 -- Control chance of the orb appearing --
ENT.HasWepFlashlightSpotlight = true -- Controls spotlight 
ENT.FlashlightSpotlightChance = 2 -- Controls the chance of the spotlight effect
ENT.HasWeaponFlashAmbGlow = true -- Control ambiet flashlight glow -- 
ENT.FlashLightAmbGlowChance = 2 -- Control chance of the ambient glow -- 
ENT.WeaponMuzzleAttachments = {"muzzle","muzzle_flash"} -- Weapon att's -- 
ENT.WepFlashEntTbl = {}

    -- [Weapon switch mechanic] -- 
ENT.CanHumanSwitchWeapons = true 
ENT.CanPickSecondaryWeapon = true
ENT.IsHoldingPrimaryWeapon = false -- For when the SNPC is currently holding out their primary weapon -- 
ENT.IsHoldingSecondaryWeapon = false -- For when the SNPC is currently holding out their secondary weapon -- 
ENT.SecondaryWeaponInvTbl = {"weapon_vj_357","weapon_vj_9mmpistol","weapon_vj_glock17"} -- Valid secondary weapons the SNPC can choose
ENT.HumanPrimaryWeapon = "" -- Empty by default, as init func will store the weapon the SNPC is spawned with
ENT.HumanSecondaryWeapon = ""
ENT.WeaponSwitchT = 0
ENT.CurrentWeapon = 0 -- 0 for primary, 1 for secondary -- 

    -- [Drop sec wep on death] -- 
ENT.Weapon_DropSecondary = true 
ENT.Weapon_DropSecondary_Chance = 4

    -- [Unused wsm stuff] -- 
ENT.CurrentDoesNotHaveOrLostPrimary = false -- For when the SNPC has primary weapon removed or dropped --
ENT.CurrentDoesNotHaveOrLostSecondary = false -- For when the SNPC has secondary weapon removed or dropped -- 

    -- [Find medical ent]
ENT.Find_MedEnts = true 
ENT.Find_MedEnts_Dist = 3500 
ENT.Find_MedEntsNextT = 0 

    -- [Extra gren stuff] -- 
ENT.GrenadeAttackEntity = "obj_vj_grenade" -- Normal Grenade
ENT.SNPCGrenadeHandAttachment = {"grenade_attachment","anim_attachment_LH"} -- For fake prop grenade
ENT.GrenadeAttackModel = "models/vj_base/weapons/w_grenade.mdl"
ENT.HasRightHandedGrenThrowAnim = true 
ENT.ForceMoveOnGesGrenThrow = true
ENT.HasAltGrenThrowAnims = true 
ENT.CurrentGrenadeThrow_IsCloseRange = false
ENT.CurrentGrenadeThrow_IsGesture = false 
ENT.HasDynamicThrowArc = true 
ENT.AllowedToHaveGrenTrail = true 
ENT.FrcMoveGesGrenThrwChance = 3
ENT.FindCoverChanceAfter_Grenade = 3 
ENT.NPC_GrenadeCloseProxDist = 1300

    -- [Repositioning while reloading] -- 
ENT.Repos_GesReload = true 
ENT.Repos_GesReloadChance = 3 
ENT.Repos_GesReloadNextT = 0 

    -- [React to flashlight] --
ENT.CanBeBlindedByPlyLight = true  
ENT.NextFlashlightCheckT = 0 

    -- [Panic on close prox to ene] -- (Sort of second version of weapon back away)
ENT.Panic_FleeEneProx = true
ENT.Panic_FleeEneChance = 4
ENT.CloseProxPanicDist = 700
ENT.Panic_DetectAllyRange = 1200
ENT.Panic_AllySuppressCount = 5
ENT.NextPanicOnCloseProxT = 0

    -- [Spot ply reaction] -- 
ENT.SpotFr_PlyAnim = true
ENT.SpotFr_PlyAnim_SeqTbl = {"cheer2", "wave", "wave_close", "wave_SMG1", "salute"}
ENT.SpotFr_PlyAnim_Chance = 8
ENT.SpotFr_PlyAnimNextT = 0

    -- [Idle fidget anims] -- 
ENT.PlayFidgetAnims = true 
ENT.PlayingFidgetAnim = false
ENT.IdleFidgetChance = 3 
ENT.FidgetAnimNextT = 0

    -- [Dialogue anims] -- 
ENT.Dialogue_Anim = true 
ENT.Dialogue_AnimTbl = {"g_ar2_down","bg_accent_left","bg_accentfwd","bg_accentup","bg_down","bg_left","bg_right","bg_up_l","bg_up_r","hg_turnr", "hg_turnl", "hg_turn_r", "hg_turn_l", "hg_nod_yes", "hg_nod_right", "hg_nod_no", "hg_nod_left", "hg_headshake", "g_palm_up_l", "g_palm_up_l_high", "g_point_swing", "g_point_swing_across", "g_fist", "g_fist_l"}
ENT.Dialogue_Anim_Chance = 3
ENT.Dialogue_AnimNextT = 0 

    -- [Investigate reaction] --
ENT.Investigate_HasAnimReact = true 
ENT.Investigate_AnimReactChance = 3 
ENT.Investigare_AnimReactTbl = {"gesture_signal_forward", "gesture_signal_halt", "hg_turnr", "hg_turnl", "hg_turn_r", "hg_turn_l"}
ENT.Investigate_NextAnimT = 0

    -- [Loot items mechanic] -- 
ENT.AllowedToLoot = true
ENT.LootableEntities = {"arc9_ammo","arc9_ammo_big","item_rpg_round","item_ammo_pistol","item_ammo_pistol_large","item_ammo_smg1","item_ammo_smg1_grenade","item_ammo_smg1_large","item_ammo_ar2","item_ammo_ar2_altfire","item_ammo_ar2_large","item_ammo_357","item_ammo_357_large","item_ammo_crossbow","item_box_buckshot","item_battery","weapon_frag",}
ENT.NextFindLootT = 0
ENT.FindLootChance = 4 -- 1 in 'x' chance to even bother running the code, where if not landing on 1, we return early and add extra delay before the next chance the SNPC can search for loot.
ENT.FindLootDistance = 2250 

    -- [Dmg by shock fx] -- 
ENT.HasShockDmgFx = true
ENT.HasExtraShockDmgFx = true -- Cball and sound effects 
ENT.ShockDmgFxChance = 3

    -- [Main access to any flare abilities] --
ENT.NPC_HasAccessToFlares_General = true 

    -- [Fire quick flare/fire flare at enemy] -- 
ENT.HasAccessToQuickFlares = true -- To restrict from certain factions. 
ENT.AllowedToLaunchQuickFlare = false  
ENT.IsFiringQuickFlare = false
ENT.FireQuickFlareAttemptChecked = false 
ENT.FireQuickFlareAtLastEnePos = false 
ENT.NextFireQuickFlareT = 0
ENT.FireFlareFromGunChance = 5
ENT.FireQuickFlareMin = 1250
ENT.FireQuickFlareMax = 5250

    -- [Throw flare at enemy] -- 
ENT.ThrowFlareDirectAtEneMech = true
ENT.AllowedToThrowFlare = true 
ENT.ThrowingFlareDirectlyEne = false
ENT.ThrowFlareAtEneNextT = 0
ENT.ThrowFlareMaxUpTrace = 500 
ENT.ThrowFlareDirectAtEneChance = 5

    -- [Corpse stuff] -- 
ENT.DeathFingerBoneManipuation = true 
ENT.ManipulateFingBoneChance = 3

    -- [Fire death Fx] -- 
ENT.SpecialFireDeathFx = true 
ENT.FireDeathFxChance = 2

    -- [Fire death sounds] -- 
ENT.HasBurnToDeathSounds = true 
ENT.BurnToDeathSoundChance = 1
ENT.AutoDecideBtdSoundTbl = true 
ENT.BurnToDeathSound_Tbl = {}

    -- [Ex timer vars] -- 
ENT.RngCombatTimers = true 

    -- [Call for help ally response] -- 
ENT.Ally_RespondCallForHelp = true 
ENT.Ally_ResponseCallForHelpAnimChance = 2 
ENT.Ally_CfhResponseAnim = {"hg_nod_yes", "hg_nod_right" ,"gesture_signal_forward","gesture_signal_group"}
   
    -- [FOV] -- 
ENT.Alterable_ViewCone = true 

    -- [Armored helmet (Headshot)] -- 
ENT.ArmoredHelmet = false 
ENT.ArmoredHelmet_AffectFov = false 
ENT.ArmoredHelmet_Break = false 
ENT.ArmoredHelmet_ImpSound = true 
ENT.ArmoredHelmet_BlockDamaged = false -- Should headshots with helmet negate all damaged.
ENT.ArmoredHelmet_ImpSparkFx = true 
ENT.ArmoredHelmet_DamageCap = true 

ENT.ArmoredHelmet_MaxDamageCap = 75
ENT.ArmoredHelmet_ImpSoundChance = 2 
ENT.ArmoredHelmet_CusFov = 90
ENT.ArmoredHelmet_BreakLimit = mRng(3, 8) -- break after this many hits/allow headshots
ENT.ArmoredHelmet_SparkFxChance = 2
ENT.ArmoredHelmet_HitsTaken = 0

    -- [Headshot] -- 
ENT.CanHaveHeadshotFx = true
ENT.HeadshotDeathAttTbl = {"forward", "eyes"} 
ENT.ApplyHeadshotDeathPhys = true 
ENT.CanPlayHeadshotDeahtAnim = false 

ENT.Headshot_Death = false -- Set to true when killed by headshot
ENT.Headshot_Death_Sfx = true 
ENT.HeadShot_Death_StopDthSnd = true 

ENT.IsImmuneToHeadShots = false 
ENT.HeadshotSoundSfxChance = mRng(2, 3)
ENT.HeadshotInstaKillChance = 0
ENT.Headshot_FxChance = mRng(2, 3)
ENT.Headshot_HaveGibs = true 
ENT.Headshot_GibMaxAm = 3 
ENT.Headshot_DoubleDmg = false 

ENT.Headshot_ImpactFlinching = true 
ENT.Headshot_NextFlinchT = 0 
ENT.Headshot_ImpFlinchAnim = {"flinch_head_small_01", "flinch_head_small_02", "flinchheadgest"} 
ENT.Headshot_FlinchChance = 2 

    -- [Custom melee attacks] --
ENT.Melee_HasRandomsCusAttacks = true 
ENT.Melee_CanHeadbutt = true 
ENT.Melee_CanKick = true 

    -- [On death radio sound] -- 
ENT.Random_RadioSoundPlay = true 
ENT.Random_RadioSoundChance = 2 

    -- [Anim translation] --
ENT.Custom_WeaponTranslation = true 

    -- [Idle incap spwn gren] -- 
ENT.Incap_SpawnGren_DngClose = true 
ENT.Incap_SpawnGren_AllyDist = 1000 -- If ally in range, don't do
ENT.Incap_SpawnGren_EneDist  = 700  -- Do if enemy in range
ENT.Incap_SpawnGrenChance = 3
ENT.Incap_SpawnGrenNextT = 0 
ENT.Incap_SpawnGrenDelay = mRand(5, 25) 
ENT.IncapGrenTimerID = nil

    -- [Roll/Writhing] -- 
ENT.DC_Writhe = true 
ENT.DC_Writh_Decay = true
ENT.DC_Writhe_AFC = true -- Apply force center 
ENT.DC_Writhing = false
ENT.DC_Writhe_UseAllBones = true   
ENT.DC_Writh_Decay_Thresh = 0.15 -- starts decaying when x % time left
ENT.DC_Writhe_TraceDist = 5
ENT.DC_Writhe_Chance = 10
ENT.DC_Writhe_MinT = 1
ENT.DC_Writhe_MaxT = 20

    -- [Shoved back] -- 
ENT.Shoved_Back = true
ENT.Shoved_Back_Now = false -- Tracks if we are currently being shoved back

ENT.Shoved_Com_Active = true -- Common damage types trigger shove filter
ENT.Shoved_Explosive_Active = true -- Explosvie daamges trigger shove filter

ENT.CollideWall = true
ENT.CollideWall_Frc = 2500

ENT.ShovedBackChance = 10
ENT.Shoved_Back_NextT = 0

ENT.PlayingWallHitAnim = false 
ENT.StaggerOverride = false 

ENT.Shoved_Back_Anims = {"shove_backward_weapon_01","shove_backward_weapon_02","shove_backward_01", "shove_backward_02", "shove_backward_03", "shove_Backward_04", "shove_backward_05", "shove_backward_06", "shove_backward_07", "shove_backward_08", "shove_backward_09", "shove_backward_10"}
ENT.Shoved_Front_Anims = {"shove_forward_01","shove_forward_weapon_01","shove_forward_weapon_02"}
ENT.Shoved_Left_Anims = {"shove_leftward_01","shove_leftward_weapon_01","shove_leftward_weapon_02"}
ENT.Shoved_Right_Anims = {"shove_rightward_01","shove_rightward_weapon_01","shove_rightward_weapon_02"}

ENT.CollideWall_Back_Anim = {"shove_backward_intowall_01","shove_backward_intowall_02","shove_backward_intowall_03","shove_backward_intowall_04"}
ENT.CollideWall_Front_Anim = {"shove_forward_intowall_01"}
ENT.CollideWall_L_Anim = {"shove_leftward_intowall_02"}
ENT.CollideWall_R_Anim = {"shove_rightward_intowall_01"}

    -- [Ex flinch ges] --
ENT.ExFlinch_Feedback_Ges = true -- Extra flinching, works on top of it. 
ENT.ExFlinch_GesTbl = {"flinch_stomach_small_01","flinch_stomach_small_02","flinch_gen_heavy_01","flinch_gen_heavy_02","flinch_gen_small_01","flinch_gen_small_02","flinch_gen_small_03","flinch_gesture"}
ENT.ExFlinch_Ges_Chance = 6
ENT.ExFlinch_HpThresh = true 
ENT.ExFlinch_HpThresh_Min = 0.50 -- equal or below 50% of HP
ENT.ExFlinch_Ges_NextT = 0 

    -- [ToxDmg cough reaction] -- 
ENT.ToxDmg_React = true 
ENT.ToxDmg_NextT = 0 
ENT.ToxDmg_Chance = 2
ENT.ToxDmg_CoughTbl = {"general_sds/cough/cough".. mRng(1, 24) ..".wav"}

    -- [Armor imp effects] -- 
ENT.Ele_SparkImpFx = false
ENT.Ele_SparkImpFx_Chance = 15

ENT.Has_DynamicFootsteps = true 
/*function ENT:ContextToThrowFlareAtEnemy()
    if not IsValid(self) or not IsValid(self:GetEnemy()) or self:IsBusy("Activities") or self.VJ_IsBeingControlled or GetConVar("vj_stalker_throw_flares"):GetInt()  ~= 1 then return false end 

    local ene = self:GetEnemy()
    local distToEnemy = self:GetPos():Distance(ene:GetPos())

    if distToEnemy > mRand(4500, 5000) then return false end

    -- Roof
    local traceDataRoof = {
        start = self:GetPos() + Vector(0, 0, 50),
        endpos = self:GetPos() + Vector(0, 0, mRand(350, 450)),
        filter = self
    }

    local traceRoof = util.TraceLine(traceDataRoof)
    if traceRoof.Hit then return false end 

    -- F
    local forward = self:GetForward()
    local traceDataWall = {
        start = self:GetPos() + Vector(0, 0, 35),
        endpos = self:GetPos() + forward * 100 + Vector(0, 0, 175), 
        filter = self
    }

    local traceWall = util.TraceLine(traceDataWall)
    if traceWall.Hit and traceWall.HitPos.z <= self:GetPos().z + 100 then return false
    end 

    if CurTime() > self.ThrowFlareAtEneNextT and IsValid(ene) and 
       distToEnemy > mRand(600, 825) and 
       self:Visible(ene) and 
       not (self:IsBusy("Activities") or self:IsBusy()) and 
       not self.vACT_StopAttacks and 
       CurTime() > self.TakingCoverT and 
       self:IsOnGround() and
       not self:IsMoving() and 
       not self.IsReloading then 
        
        self:ThrowFlareAtEnemy(distToEnemy)
    end 
end

ENT.ThrowFlareAtEnemyCheck = false 
function ENT:ThrowFlareAtEnemy(distToEnemy)
    if not self.CanThrowFlareAtEnemy or self:IsBusy("Activities") then return end

    if CurTime() < self.ThrowFlareAtEneNextT then 
        self.ThrowFlareAtEnemyCheck = false 
        return 
    end

    if not self.ThrowFlareAtEnemyCheck then
        self.ThrowFlareAtEnemyCheck = true
        if mRng(1, 4) ~= 1 then 
            self.ThrowFlareAtEneNextT = CurTime() + mRand(100, 300)  
            return 
        end
    end

    if mRng(1, 3) ~= 1 then return false end 

    self.CanThrowFlareAtEnemy = false 
    self.IsThrowingFlareAtEne = true
    self:VJ_ACT_PLAYACTIVITY("vjseq_grenthrow", true, VJ.AnimDuration(self, "grenthrow"), true)
    timer.Simple(0.75, function() 
        if not IsValid(self) or not IsValid(self:GetEnemy()) then return end 
        local ene = self:GetEnemy()
        local flareEnt = ents.Create("obj_vj_flareround")
        if not IsValid(flareEnt) then return end
        
        local throwPos = self:GetPos() + self:GetUp() * 50 + self:GetForward() * 20
        local aimPos = ene:GetPos() + Vector(mRand(-30, 30), mRand(-30, 30), 0)
        local throwDirection = (aimPos - throwPos):GetNormalized()
        
        local baseForce = 5500
        local additionalForwardForce = (distToEnemy / 850) * mRand(100, 155)
        local totalForwardForce = baseForce + additionalForwardForce

        local baseUpwardForce = 600
        local additionalUpwardForce = (distToEnemy / 850) * mRand(490, 550)
        local totalUpwardForce = baseUpwardForce + additionalUpwardForce

        local horizontalForce = throwDirection * totalForwardForce
        local throwForce = horizontalForce + Vector(0, 0, totalUpwardForce)
        
        flareEnt:SetPos(throwPos)
        flareEnt:SetAngles((aimPos - throwPos):Angle())
        flareEnt:Spawn()
        flareEnt:Activate()
        
        local phys = flareEnt:GetPhysicsObject()
        if IsValid(phys) then
            phys:ApplyForceCenter(throwForce)
            phys:EnableDrag(false)
            phys:EnableGravity(true)
            phys:SetMass(10)
        end
        
        local forceTimerName = "FlareForceTimer_" .. flareEnt:EntIndex()
        local forceCount = 0
        timer.Create(forceTimerName, 0.1, 5, function()
            if IsValid(flareEnt) and IsValid(phys) then
                forceCount = forceCount + 1
                local continuousForce = throwForce * (1 - (forceCount * 0.15))
                phys:ApplyForceCenter(continuousForce * 0.2)
            else
                timer.Remove(forceTimerName)
            end
        end)
        
        self.ThrowFlareAtEneNextT = CurTime() + mRand(75, 180) 
        self.IsThrowingFlareAtEne = false
        self.CanThrowFlareAtEnemy = true
    end)
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
end

function ENT:Custom_PreInit()
end 

function ENT:PreInit() 
    timer.Simple(0.1, function()
        if IsValid(self) then 
            self:Custom_PreInit()

            if self.IsHeavilyArmored then 
                self:SetHeavyStats()
            end 

            if self.IsScientific then 
                self:SetScientific()
            end

            if self.IsOfficer then 
                self:SetOfficerStats()
            end 

            self:RANDOM_CON_DEBUG()
            self:CacheHeadData()
            self:HandleSniperWepLogic() 
            self:InitializeAutoRevival()
            self:WeaponFlashlight()
            self:ManageFriendlyVars()
            self:SaveCurrentWeapon()
            self:PickSecondaryWeapon()
            self:TrackHeldWeapon()
            self:TrackWeaponBackAway()
            self:TrackWeaponCapabilities()
            if self.CanBecomeIncapicitated then 
                self:SetIncapAnims()
            end 
            self:ManageBrutalSounds()
            self:ManageCryForAidSounds()
            self:ManageStepSd()
            self:ManageRandomVars()
            self:MngeExVarTimes()
            if self.HasBurnToDeathSounds then 
                self:MngBurnToDeathVO()
            end 
        end
    end)
end

ENT.Universal_RandomsDebug_Conv = "vj_stalker_randoms_console_debug"
function ENT:RANDOM_CON_DEBUG()
    if not self.Universal_RandomsDebug_Conv then return false end 
    local conv = self.Universal_RandomsDebug_Conv
    if not self.RANDOMS_DEBUG then 
        if GetConVar(conv):GetInt() == 1 then 
            self.RANDOMS_DEBUG = true 
        end
    end
end

function ENT:ValidBreakableMats(pos)

    local vec = Vector(0, 0, 40)
    local tr_water = util.TraceLine({
        start = pos,
        endpos = pos - vec,
        mask = MASK_WATER
    })

    if tr_water.Hit then return false end  -- Water 

    local tr = util.TraceLine({
        start = pos,
        endpos = pos - vec,
        filter = self,
        mask = MASK_NPCWORLDSTATIC
    })

    local valMats = {
        [MAT_SAND] = true,
        [MAT_DIRT] = true,
        [MAT_FOLIAGE] = true,
        [MAT_SLOSH] = true,
        [85] = true
    }

    return tr.Hit and tr.HitWorld and valMats[tr.MatType] or false
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Alternate_GrenAtt = "grenade_attachment" 
function ENT:CertainAttCharacteristics() 
    if not self.Alternate_GrenAtt then return false end 
    local grenAtt = tostring(self.Alternate_GrenAtt) or ""

    self.CanFireFlareGunSeq = false
    self.SNPCGrenadeHandAttachment = grenAtt
    self.GrenadeAttackAttachment = grenAtt
    self.Medic_SpawnPropOnHealAttachment = grenAtt
    self.DropWeaponOnDeathAttachment = grenAtt
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ManageFriendlyVars()
    if not self.FriendlyConvar then return end 
    local conv = tostring(self.FriendlyConvar)
    if GetConVar(conv):GetInt() == 1  then
        self.VJ_NPC_Class = self.FriendlyNPC_Class 
        self.HasOnPlayerSight = true
        self.AlliedWithPlayerAllies = true
        self.YieldToAlliedPlayers  = true 
        self.BecomeEnemyToPlayer = mRng(3,5)
        self.FollowPlayer = true
        self.FollowMinDistance = mRand(90, 200)
    end
end 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSniperWepLogic() 
    local wep = self:GetActiveWeapon()
    if IsValid(self) and IsValid(wep) and wep.IsMarkedSnpcSniperWep then 
        self.RngPickMoveAndShoot = false 
    end 
end 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanFormSquads = false 
ENT.CanJoinSquads = false 
ENT.HasSquadLeader = false
ENT.SL_NoFollowFilter = 350 -- If leader is this close, no need to move again. 
ENT.SL_MoveInDist = 750 -- If leader is over this range, then we move in to follow
ENT.NextMoveTo_LeadT = 0 
ENT.Max_SquadCap = 5
ENT.Min_SquadCap = 2 
ENT.SquaddieMembers = {}

//Larger call for help distance?
//Specifically fire flare or place one? As in, if we are a leader, our chances to do so are more common!
function ENT:SetOfficerStats()
    if not self.IsOfficer then return false end
end 

function ENT:SetScientific()
    if not self.IsScientific then return false end
    timer.Simple(0.1, function()
        if not IsValid(self) then return end
        self.Immune_Toxic       = true 
        self.Immune_Electricity = true
        self.Immune_Sonic       = true  
    end)
end

function ENT:SetHeavyStats()
    if not self.IsHeavilyArmored then return end

    timer.Simple(0.15, function()
        if not IsValid(self) then return end
        
        self.HasAloneAiBehaviour = false 
        self.Shoved_Com_Active   = false 
        self.CombatRoll          = false 
        self.Evade_IncDanger     = false
        self.Panic_DmgEne        = false 
        self.Panic_FleeEneProx   = false 
        self.IsImmuneToHeadShots = true 

        self.FlinchChance                  = (self.FlinchChance or 3) * mRng(2,4)
        self.ArmorSparking_Chance          = (self.ArmorSparking_Chance or 5) / mRng(2,4)
        self.RetreatAfterMeleeAttackChance = (self.RetreatAfterMeleeAttackChance or 3) * mRng(2,4)

        local chance = self.HeavySlowMoveChance or 3 
        local debugging = self.RANDOMS_DEBUG 
        if self.HeavyUnitHasSlowMoveChance then 
            if mRng(1, chance) == 1 then 
                if debugging then print("Heavy unit has slow movement.") end 
                self.Rng_FootStepSet = false 
                self.HasSlowHeavyMovement = true 
                self.HasSlowHeavyFootsteps = true 
            end
        end 

        if debugging then 
            print("Retreat chance == " .. self.RetreatAfterMeleeAttackChance) 
            print("Armor spark impact == " .. self.ArmorSparking_Chance)
            print("Flinch chance == " .. self.FlinchChance)
        end 
    end)
end 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MngBurnToDeathVO()
    if not self.HasBurnToDeathSounds then return end 
    timer.Simple(0.1, function()
        if IsValid(self) and self.AutoDecideBtdSoundTbl then 
            self.BurnToDeathSound_Tbl = {}
            local soundSets = {
                {path = "english", count = 5},
                {path = "scottish", count = 5},
                {path = "german_01", count = 5},
                {path = "german_02", count = 5},
                {path = "australian", count = 4},
                {path = "canadian", count = 5},
                {path = "american_01", count = 5}}

            local selectedSet = VJ.PICK(soundSets)
            print(selectedSet.path)
            local soundFile = "st_brutal_deaths/burning_to_death/" .. selectedSet.path .. "/burnttodeath" .. mRng(1, selectedSet.count) .. ".ogg"
            table.insert(self.BurnToDeathSound_Tbl, soundFile)
        end 
    end)
end

ENT.Rng_FootStepSet = true
ENT.FootstepSet_Heavy = {"general_sds/heavy_footsteps/step_1.mp3", "general_sds/heavy_footsteps/step_2.mp3", "general_sds/heavy_footsteps/step_3.mp3", "general_sds/heavy_footsteps/step_4.mp3", "general_sds/heavy_footsteps/step_5.mp3", "general_sds/heavy_footsteps/step_6.mp3"}

ENT.FootstepSet_MetroPolice = {"npc/metropolice/gear1.wav","npc/metropolice/gear2.wav","npc/metropolice/gear3.wav", "npc/metropolice/gear4.wav","npc/metropolice/gear5.wav","npc/metropolice/gear6.wav"}
ENT.FootstepSet_ExtraGear = {"general_sds/ex_footsteps/gear1.wav","general_sds/ex_footsteps/gear2.wav", "general_sds/ex_footsteps/gear3.wav","general_sds/ex_footsteps/gear4.wav", "general_sds/ex_footsteps/gear5.wav","general_sds/ex_footsteps/gear6.wav"}
ENT.FootstepSet_Hardboot = {"npc/footsteps/hardboot_generic1.wav","npc/footsteps/hardboot_generic2.wav", "npc/footsteps/hardboot_generic3.wav","npc/footsteps/hardboot_generic4.wav", "npc/footsteps/hardboot_generic5.wav","npc/footsteps/hardboot_generic6.wav", "npc/footsteps/hardboot_generic8.wav"}
ENT.FootstepSet_Extra = {"general_sds/ex_footsteps/footstep1.wav","general_sds/ex_footsteps/footstep2.wav", "general_sds/ex_footsteps/footstep3.wav","general_sds/ex_footsteps/footstep4.wav", "general_sds/ex_footsteps/footstep5.wav","general_sds/ex_footsteps/footstep6.wav", "general_sds/ex_footsteps/footstep7.wav","general_sds/ex_footsteps/footstep8.wav"} 
ENT.FootstepSet_Generic = {"general_sds/ex_footsteps/hardboot_generic1.wav","general_sds/ex_footsteps/hardboot_generic2.wav", "general_sds/ex_footsteps/hardboot_generic3.wav","general_sds/ex_footsteps/hardboot_generic4.wav", "general_sds/ex_footsteps/hardboot_generic5.wav","general_sds/ex_footsteps/hardboot_generic6.wav", "general_sds/ex_footsteps/hardboot_generic7.wav","general_sds/ex_footsteps/hardboot_generic8.wav"}
ENT.FootstepSet_GenVariety = {"general_sds/ex_footsteps/concrete1.wav","general_sds/ex_footsteps/concrete2.wav", "general_sds/ex_footsteps/concrete3.wav","general_sds/ex_footsteps/concrete4.wav", "general_sds/ex_footsteps/tile1.wav","general_sds/ex_footsteps/tile2.wav", "general_sds/ex_footsteps/tile3.wav","general_sds/ex_footsteps/tile4.wav"} 
function ENT:ManageStepSd(force)
    if self._FootstepSetManaged and not force then return end
    self._FootstepSetManaged = true
    timer.Simple(0.1, function()
        if not IsValid(self) then return end

        /*local function ValidateSndTbl(tbl)
            local sndTbl = tbl
        end*/

        local heavySteps = self.FootstepSet_Heavy
        local sets = {self.FootstepSet_MetroPolice, self.FootstepSet_ExtraGear, self.FootstepSet_Hardboot, self.FootstepSet_Extra, self.FootstepSet_Generic, self.FootstepSet_GenVariety}

        local stepSet = self.SoundTbl_FootStep 
        if self.IsHeavilyArmored and self.HasSlowHeavyMovement then
            stepSet = heavySteps
            self.SoundTbl_FootStep = stepSet
            return
        end

        if self.Rng_FootStepSet then
            local idx = mRng(1, #sets)
            stepSet = sets[idx]
            self.SoundTbl_FootStep = stepSet
        end
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.SoundTbl_Death = {"st_faction_sounds/stalker_vo/general_base_dialogue/death_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/death_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/death_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/death_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/death_10.ogg","general_spetsnaz_snds/death1.wav","general_spetsnaz_snds/death2.wav","general_spetsnaz_snds/death3.wav","general_spetsnaz_snds/death4.wav","general_spetsnaz_snds/death5.wav","general_spetsnaz_snds/death6.wav","general_spetsnaz_snds/death7.wav","general_spetsnaz_snds/death8.wav","general_spetsnaz_snds/death9.wav","general_spetsnaz_snds/death10.wav","general_spetsnaz_snds/death11.wav","general_spetsnaz_snds/death1.wav","general_spetsnaz_snds/death2.wav","general_spetsnaz_snds/death3.wav","general_spetsnaz_snds/death4.wav","general_spetsnaz_snds/death5.wav","general_spetsnaz_snds/death6.wav","general_spetsnaz_snds/death7.wav","general_spetsnaz_snds/death8.wav","general_spetsnaz_snds/death9.wav","general_spetsnaz_snds/death10.wav","general_spetsnaz_snds/death11.wav","general_spetsnaz_snds/death12.wav","general_spetsnaz_snds/death13.wav","general_spetsnaz_snds/death14.wav","general_spetsnaz_snds/death15.mp3","general_spetsnaz_snds/death16.mp3","general_spetsnaz_snds/death17.mp3","general_spetsnaz_snds/death18.mp3","general_spetsnaz_snds/death19.mp3","general_spetsnaz_snds/death20.mp3","general_spetsnaz_snds/death21.mp3","general_spetsnaz_snds/death22.mp3","general_spetsnaz_snds/death23.mp3","general_spetsnaz_snds/death24.mp3","general_spetsnaz_snds/death25.mp3","general_spetsnaz_snds/death26.mp3","st_faction_sounds/stalker_vo/general_base_dialogue/death_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/death_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/death_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/death_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/death_5.ogg"}
ENT.SoundTbl_Pain = {"st_faction_sounds/stalker_vo/general_base_dialogue/hit_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hit_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hit_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hit_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hit_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hit_14.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_10A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_12A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_13A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_14A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_15A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_16A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_17A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_01A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_02A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_03A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_04A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_05A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_06A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_07A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_08A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_09A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_01A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_02A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_03A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_04A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_05A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_06A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_07A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_08A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_09A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_10A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_11A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_12A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_13A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_14A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_15A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_16A_DimitryRozental.ogg","general_spetsnaz_snds/pain1.wav","general_spetsnaz_snds/pain2.wav","general_spetsnaz_snds/pain3.wav","general_spetsnaz_snds/pain4.wav","general_spetsnaz_snds/pain5.wav","general_spetsnaz_snds/pain6.wav","general_spetsnaz_snds/pain7.wav","general_spetsnaz_snds/pain8.wav","general_spetsnaz_snds/pain9.wav","general_spetsnaz_snds/pain10.wav","general_spetsnaz_snds/pain11.wav","general_spetsnaz_snds/pain1.wav","general_spetsnaz_snds/pain2.wav","general_spetsnaz_snds/pain3.wav","general_spetsnaz_snds/pain4.wav","general_spetsnaz_snds/pain5.wav","general_spetsnaz_snds/pain6.wav","general_spetsnaz_snds/pain7.wav","general_spetsnaz_snds/pain8.wav","general_spetsnaz_snds/pain9.wav","general_spetsnaz_snds/pain10.wav","general_spetsnaz_snds/pain11.wav","st_faction_sounds/stalker_vo/general_base_dialogue/hit_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hit_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hit_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hit_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hit_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hit_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hit_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hit_8.ogg"}
ENT.SoundTbl_CryForAid = {"general_spetsnaz_snds/VO_RU_SL_Medic_10A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_12A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_13A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_14A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_15A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_16A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_17A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_01A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_02A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_03A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_04A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_05A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_06A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_07A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_08A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Medic_09A_AleksandrJuriev.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_1s.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_2s.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_3s.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_4s.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_5s.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_1wh.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_2wh.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_3wh.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_4wh.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_5wh.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_1stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_2stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_3stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_4stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_5stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_6stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_7stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_8stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help9stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/help_10stalker.ogg"}

local function CopyTable(tbl)
    local t = {}
    for i, v in ipairs(tbl) do
        t[i] = v
    end
    return t
end

ENT.StalkerMain_BrutalDeath_Conv = "vj_stalker_brutal_death_vo"
ENT.StalkerMain_BrutalPain_Conv = "vj_stalker_brutal_pain_vo"
ENT.StalkerMain_RonDeath_Conv = "vj_stalker_ron_death_sounds"
function ENT:ManageBrutalSounds()
    if not self.HasBrutalDeathSounds then return end 
    if not IsValid(self) then return end
    self.DefaultDeathSounds = self.DefaultDeathSounds or CopyTable(self.SoundTbl_Death or {})
    self.DefaultPainSounds  = self.DefaultPainSounds  or CopyTable(self.SoundTbl_Pain or {})

    local deathConv = tostring(self.StalkerMain_BrutalDeath_Conv) 
    local painConv = tostring(self.StalkerMain_BrutalPain_Conv)
    local ronConv = tostring(self.StalkerMain_RonDeath_Conv)
    local brutalDeathEnabled = GetConVar(deathConv):GetInt() == 1
    local brutalPainEnabled  = GetConVar(painConv):GetInt() == 1
    local ronDeathEnabled    = GetConVar(ronConv):GetInt() == 1

    if brutalDeathEnabled then
        local t = {}
        for i = 1, 100 do
            t[#t+1] = "st_brutal_deaths/Die_" .. i .. ".wav"
        end

        if mRng(2) == 1 then
            for i = 1, 117 do
                t[#t+1] = "st_brutal_deaths/death" .. i .. ".wav"
            end
        end
        if mRng(2) == 1 then
            for i = 1, 38 do
                t[#t+1] = "st_brutal_deaths/ins/death" .. i .. ".mp3"
            end
        end
        if mRng(2) == 1 then
            for i = 6, 50 do
                t[#t+1] = "st_brutal_deaths/ex_st_death/death_" .. i .. ".ogg"
            end
        end
        if self.RON_DeathSounds and ronDeathEnabled then
            for i = 1, 182 do
                t[#t+1] = "st_brutal_deaths/ron/m/deathagony (" .. i .. ").ogg"
            end
            if mRng(2) == 1 then
                for i = 1, 2987 do
                    t[#t+1] = "st_brutal_deaths/ron/m/deathcry (" .. i .. ").ogg"
                end
            end
            if mRng(2) == 1 then
                for i = 1, 320 do
                    t[#t+1] = "st_brutal_deaths/ron/m/ealthdeath (" .. i .. ").ogg"
                end
            end
        end
        self.SoundTbl_Death = t
        print("Total death sounds: " .. #t)
    else
        self.SoundTbl_Death = CopyTable(self.DefaultDeathSounds or {})
    end

    if brutalPainEnabled and self.HasBrutalPainSounds then
        local t = {}
        for i = 1, 20 do
            t[#t+1] = "st_brutal_deaths/ouch_" .. i .. ".wav"
        end

        if mRng(2) == 1 then
            for i = 1, 334 do
                t[#t+1] = "st_brutal_pain/hit_(" .. i .. ").ogg"
            end
        end
        if mRng(2) == 1 then
            for i = 1, 331 do
                t[#t+1] = "st_brutal_pain/pain_(" .. i .. ").ogg"
            end
        end
        self.SoundTbl_Pain = t
        if self.RANDOMS_DEBUG then 
            print("Total brutal pain sounds: " .. #t)
        end 
    else
        self.SoundTbl_Pain = CopyTable(self.DefaultPainSounds or {})
    end
end

function ENT:ManageCryForAidSounds()
    if not self.HasBrutalCFASounds then return false end  
    if not IsValid(self) then return false end
    
    if not self.DefaultCryForAidSounds then
        self.DefaultCryForAidSounds = CopyTable(self.SoundTbl_CryForAid or {})
    end

    if GetConVar("vj_stalker_brutal_cry_vo"):GetInt() == 1 then
        self.SoundTbl_CryForAid = {}
        for i = 1, 15 do
            table.insert(self.SoundTbl_CryForAid, "st_brutal_deaths/brutal_rus_cryforaid/help_" .. i .. ".ogg")
        end
        if self.RANDOMS_DEBUG then
            print("Total brutal cry-for-aid sounds: " .. #self.SoundTbl_CryForAid)
        end 
    else
        self.SoundTbl_CryForAid = CopyTable(self.DefaultCryForAidSounds or {})
        if self.RANDOMS_DEBUG then 
            print("Default cry-for-aid: " .. #self.SoundTbl_CryForAid)
        end 
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TrackWeaponBackAway()
    self.CanBackAwayWithWeapon = IsValid(self) and self.HasWeaponBackAway
end

ENT.BackAway_VisReqNextT = 0
function ENT:ManageWeaponBackAway()
    if not self.CanUseWeaponBackAway then return end

    if not GetConVar("vj_stalker_backaway_enevis"):GetBool() then return end

    local cT = CurTime()
    if cT < self.BackAway_VisReqNextT then return end
    self.BackAway_VisReqNextT = cT + 0.2

    local enemy = self:GetEnemy()
    if not IsValid(enemy) then
        self.HasWeaponBackAway = false
        return
    end

    if self:Visible(enemy) then
        self.HasWeaponBackAway = true
    else
        self.HasWeaponBackAway = false
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Helper function to track weapon capabilities (Strafe and Move-Fire)
function ENT:TrackWeaponCapabilities()
    timer.Simple(1, function()
        if not IsValid(self) then return end
        self.HasStrafeFire = self.Weapon_Strafe or false
        self.HasMoveAndShoot = self.Weapon_CanMoveFire or false
        if self.RANDOMS_DEBUG then
            if self.HasStrafeFire then
                print(self:GetName() .. ": Has strafe fire behaviour!")
            end
            if self.HasMoveAndShoot then
                print(self:GetName() .. ": Has shoot while moving behaviour.")
            end
        end
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
//Move and strafe 
function ENT:ManageStrafeShoot()
    if not self.FireModeChangeOnDist or self.VJ_IsBeingControlled then return false end
    local curT = CurTime()
    local ene = self:GetEnemy()
    if not IsValid(ene) then return end

    local distance = self:GetPos():Distance(ene:GetPos())
    local hasStrafeFire = self.HasStrafeFire or false
    local canStrafe = self.Weapon_Strafe or false
    local maxDist = self.MaxDistStopStrafeFire or 5000

    self.NextStrafeFireToggleT = self.NextStrafeFireToggleT or 0
    if curT < self.NextStrafeFireToggleT then return end

    self.NextStrafeFireToggleT = curT + (self.MoveFireToggleCooldown or 1)

    if hasStrafeFire then
        if distance >= maxDist and canStrafe then
            self.Weapon_Strafe = false
        elseif distance <= maxDist and not canStrafe then
            self.Weapon_Strafe = true
        end
    end
end

//Move and shoot
function ENT:ManageMoveAndShoot()
    if not self.FireModeChangeOnDist then return end 
    if self.VJ_IsBeingControlled then return end
    local curT = CurTime()
    local ene = self:GetEnemy()
    if not IsValid(ene) then return end

    local distance = self:GetPos():Distance(ene:GetPos())
    local hasMoveShoot = self.HasMoveAndShoot or false
    local canMoveShoot = self.Weapon_CanMoveFire or false
    local maxDist = self.MaxDistStopStrafeFire or 5000

    self.NextMoveFireToggleT = self.NextMoveFireToggleT or 0
    if curT < (self.NextMoveFireToggleT or 0) then return end

    self.NextMoveFireToggleT = curT + self.MoveFireToggleCooldown

    if hasMoveShoot then
        if distance >= maxDist and canMoveShoot then
            self.Weapon_CanMoveFire = false
        elseif distance <= maxDist and not canMoveShoot then
            self.Weapon_CanMoveFire = true
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Randomization and hanlding of internal variables
function ENT:ManageRandomVars()
    timer.Simple(0.1, function()
        if IsValid(self) then 

            local preDebug           = self.RANDOMS_DEBUG
            local curT               = CurTime()
            local defaultFov         = self.SightAngle
            local cvar_viewangle     = GetConVar("vj_stalker_snpc_view_angle"):GetInt()
            local cvar_radio         = GetConVar("vj_stalker_radio_chatter"):GetInt()
            local cvar_deathanims    = GetConVar("vj_stalker_death_anims"):GetInt()
            local cvar_dodging       = GetConVar("vj_stalker_dodging"):GetInt()
            local cvar_neverforget   = GetConVar("vj_stalker_never_forget"):GetInt()
            local cvar_limitednades  = GetConVar("vj_stalker_limited_grenades"):GetInt()
            local cvar_healself      = GetConVar("vj_stalker_heal_self"):GetInt()

            local infT  = curT + 9999999999999
            local defT  = curT + mRand(10, 20)
            local defTurn = self.TurningSpeed or 10

            self.NextPeekUpT = curT + mRand(3, 10)
            self.Danger_DetectSiganlT = curT + mRand(1, 5)
            self.WeaponSwitchT = curT + mRand(20,50) 
            self.EvadeDanger_NextT = curT + mRand(1, 10)
            self.NextPanicOnCloseProxT = curT + mRand(5, 15)
            self.NextFindLootT = curT + mRand(5, 25)
            self.DeathAnimationChance = mRng(2,5)
            self.Avoid_C_HairNextT = curT + mRand(4.25, 8.45)
            self.BloodDecalDistance = mRand(100,320)
            self.IdleDialogueDistance = mRng(350,650)
            self.FidgetAnimNextT = curT + mRand(1, 15)
            self.NextFireQuickFlareT = curT + mRand(5, 20)
            self.CombatFlareDeployT = curT + mRand(5, 25)
            self.Corpse_DissolveDelayT = curT + mRand(2.5, 7.75)
            self.Dodge_NextT = curT + mRand(1, 5)
            self.Suppression_Time = mRand(2.5, 10)
            self.BloodDecalDistance = mRand(100, 320)
            self.IdleDialogueDistance = mRand(350, 650)

            if self.Alterable_ViewCone then
                if self.ArmoredHelmet_AffectFov then
                    self.SightAngle = self.ArmoredHelmet_CusFov
                else
                    self.SightAngle = cvar_viewangle
                end
                if preDebug then print("[Sight Angle]: My current sight angle value is " .. self.SightAngle) end 
            else
                self.SightAngle = defaultFov
            end

            if not self.DeathAllyResponse then 
                self.DeathAllyResponse = table.Random({"OnlyAlert", true})  
            end 

            local choice = table.Random({"Both", "Moving", "Standing"})
            self.ConstantlyFaceEnemy_Postures = choice

            if mRng(1,3) == 1 then 
                self.IsMedic = true 
                self.SNPCMedicTag = true  
            end

            if mRng(1,2) == 1 and self.HasAccessToQuickFlares then 
                self.AllowedToLaunchQuickFlare = true 
            end

            if cvar_healself == 1 and (mRng(1, 2) == 1 or self.IsMedic) then 
                self.CanHumanHealSelf = true 
            end

            local tbl = {true, false}
            local pckTbl = tbl[mRng(1, #tbl)]
            if self.RngPickMoveAndShoot then 
                self.Weapon_CanMoveFire = pckTbl
                if self.Weapon_CanMoveFire then
                    self.Weapon_Strafe = pckTbl
                else 
                    self.Weapon_Strafe = false 
                end 
            end 

            if not self.Weapon_FindCoverOnReload and not self.DoesNotHaveCoverReload then
                self.DoesNotHaveCoverReload = true

                if preDebug then
                    print("Doesn't have find cover reload.")
                end
            else
                if preDebug then
                    print("Has find cover reload.")
                end
            end

            if self.HasGrenadeAttackMechRng and not self.Grenade_PermBlocked then 
                self.HasGrenadeAttack = mRng(1, 3) ~= 1
            end 

            if self.HasGrenadeAttack and not self.Grenade_PermBlocked then 
                if cvar_limitednades == 1 and self.LimitedGrenades then

                    local min = self.LimitedGrenCount_Min or 1 
                    local max = self.LimitedGrenCount_Max or 10
                    local grenCount = mRng(min, max) or 3 

                    self.HasLimitedGrenadeCount = true 
                    self.HumanGrenadeCount = grenCount or 2 
                   if preDebug then print("[Limited Grenades]: My total grenade count is " .. grenCount) end 
                end 
            end 

            if self.IsHeavilyArmored then 
                self.TurningSpeed = 5
            else 
                self.TurningSpeed = defTurn + mRng(1, 5)
            end 

            if cvar_radio == 1 then 
                local chanceForRadio = self.HasRadioSpawnChance or 5 
                if self.HasAccessToRadio and mRng(1, chanceForRadio) == 1 then
                    self.HasRadioChatDialogue = true 
                    self.NextRadioDialogueT = curT + mRand(5, 15)
                end 
            end

            if cvar_deathanims == 1 then
                self.HasDeathAnimation = true 
            end

            if mRng(1, self.Has_CmbDodgeChance) == 1 and cvar_dodging == 1 then
                self.CombatEvade = true
            end

            if cvar_neverforget == 1 then
                if preDebug then 
                    print(infT .. " and " .. defT)
                end 
                self.EnemyTimeout = infT
            else
                self.EnemyTimeout = defT
            end 

            local tblAlResp = {"OnlyMove", "OnlySearch", true}
            self.DamageAllyResponse = tblAlResp[mRng(1, #tblAlResp)]

            if mRng(1, 2) == 1 then self.HasFireInBurstAbility = true end 
            if mRng(1, 2) == 1 then self.CanDropWeaponWhenOnFire = true end
            if mRng(1, 4) == 1 then self.CombatDamageResponse = false end
            if mRng(1, 3) == 1 then self.Weapon_CanCrouchAttack = false end
            if mRng(1, 4) == 1 then self.Weapon_WaitOnOcclusion = false end
            if mRng(1, 3) == 1 then self.ConstantlyFaceEnemy = true end
            if mRng(1, 2) == 1 then self.ConstantlyFaceEnemy_IfVisible = false end
            if mRng(1, 2) == 1 then self.ConstantlyFaceEnemy_IfAttacking = true end
            if mRng(1, 3) == 1 then self.CallForHelpAnimFaceEnemy = true end
            if mRng(1, 3) == 1 then self.BloodDecalUseGMod = true end
            if mRng(1, 3) == 1 then self.IdleDialogueCanTurn = false end
            if mRng(1, 3) == 1 then self.CanRedirectGrenades = false end
            if mRng(1, 3) == 1 then self.DisableWandering = true end  
            if mRng(1, 3) == 1 then self.Weapon_FindCoverOnReload = false end

            if mRng(1,2) == 1 and not self.IsHeavilyArmored then self.CanBecomeDefensiveAtLowHP = true end    
            if mRng(1,4) == 1 and not self.IsHeavilyArmored then self.HasWeaponBackAway = false end 
        end 
    end)
end

ENT.Rng_MoveHideTime = true
ENT.Rng_SrafeTime = true
ENT.Rng_WaitForEneTime = true
ENT.CombatDamageResponse_Cooldown = VJ.SET(3, 3.5) 
ENT.Weapon_StrafeCooldown = VJ.SET(3, 6) 
ENT.Weapon_OcclusionDelayTime = VJ.SET(3, 7)
function ENT:MngeExVarTimes()
    if not self.RngCombatTimers then return end

    local cv = GetConVar("vj_stalker_rng_combat_var_times")
    if not cv or cv:GetInt() ~= 1 then return end

    local moveOrHideOnDamage = mRng(1, 6)
    local moveWhileShooting = mRng(1, 4)
    local waitForEnemyPick  = mRng(1, 6)

    local moveHideTimers = {
        {1, 5}, {2, 5}, {5, 10},
        {1, 10}, {10, 15}, {1, 15}
    }

    if self.Rng_MoveHideTime and self.CombatDamageResponse then
        local t = moveHideTimers[moveOrHideOnDamage]
        self.CombatDamageResponse_Cooldown = VJ.SET(mRand(t[1], t[2]), mRand(t[2], t[2] + 5))
    else
        self.CombatDamageResponse_Cooldown = VJ.SET(3, 5)
    end

    local strafeTimers = {
        {0.5, 2.5},
        {1, 5.5},
        {5, 10},
        {5, 15},
    }

    if self.Rng_SrafeTime and self.Weapon_Strafe then
        local t = strafeTimers[moveWhileShooting]
        self.Weapon_StrafeCooldown = VJ.SET(mRand(t[1], t[2]),mRand(t[2], t[2] + 5))
    else
        self.Weapon_StrafeCooldown = VJ.SET(3, 6)
    end

    local waitForEnemyTimers = {
        {1, 5}, {4, 9}, {1, 15}, {2, 5},
        {10, 15}, {3, 7}, {1, 10}, {5, 20}
    }

    if self.Rng_WaitForEneTime and self.Weapon_OcclusionDelay then
        local t = waitForEnemyTimers[waitForEnemyPick]
        self.Weapon_OcclusionDelayTime = VJ.SET(mRand(t[1], t[2]),mRand(t[2], t[2] + 5))
    else
        self.Weapon_OcclusionDelayTime = VJ.SET(2, 7)
    end

    timer.Simple(0.1, function()
        if not IsValid(self) then return end
        if not self.RANDOMS_DEBUG then return end 
        if self.CombatDamageResponse_Cooldown then 
            print("Combat Response:", self.CombatDamageResponse_Cooldown.a, self.CombatDamageResponse_Cooldown.b)
        end 

        if self.Weapon_StrafeCooldown then
            print("StrafeCooldown:",self.Weapon_StrafeCooldown.a,self.Weapon_StrafeCooldown.b)
        end

        if self.Weapon_OcclusionDelayTime then
            print("OcclusionDelay:",self.Weapon_OcclusionDelayTime.a,self.Weapon_OcclusionDelayTime.b)
        end
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.StalkerMain_FlashLight_Conv = "vj_stalker_wep_flashlight" 

local function SafeCreate(class)
    local ent = ents.Create(class)
    if not IsValid(ent) then return nil end
    return ent
end

function ENT:WeaponFlashlight()
    if self.HumanWepHasWepFlashLight then return end
    if IsValid(self.WeaponFlashlightSpotLight) then return end

    if not self.AllowedToHaveWepFlashLight then return end
    local cv_flashlight = GetConVar(self.StalkerMain_FlashLight_Conv)
    if not cv_flashlight or not cv_flashlight:GetBool() then return end

    self.WepFlashEntTbl = self.WepFlashEntTbl or {}

    local wep = self:GetActiveWeapon()

    if not IsValid(wep) then
        timer.Simple(0, function()
            if IsValid(self) then
                self:WeaponFlashlight()
            end
        end)
        return
    end

    local weaponLightChance = self.WeaponFlashLightChance or 10
    if mRng(1, weaponLightChance) ~= 1 then return end
    
    local holdType = wep.HoldType
    if holdType == "pistol" or holdType == "revolver" or holdType == "rpg" then return end

    self._CachedMuzzleAtt = self._CachedMuzzleAtt or {}
    local wepClass = wep:GetClass()

    local muzzleAttachmentIndex, muzzleAttachmentName
    local cached = self._CachedMuzzleAtt[wepClass]

    if cached then
        muzzleAttachmentIndex = cached[1]
        muzzleAttachmentName = cached[2]
    else
        for _, attName in ipairs(self.WeaponMuzzleAttachments) do
            local id = wep:LookupAttachment(attName)
            if id and id > 0 then
                muzzleAttachmentIndex = id
                muzzleAttachmentName = attName
                self._CachedMuzzleAtt[wepClass] = {id, attName}
                break
            end
        end
    end

    if not muzzleAttachmentIndex then
        if self.RANDOMS_DEBUG then
            print("No valid muzzle att for: " .. tostring(wep:GetClass()))
        end
        return
    end

    local attData = wep:GetAttachment(muzzleAttachmentIndex)
    if not attData then return end

    local attForward = attData.Ang:Forward()
    local wepForward = wep:GetForward()
    local dot = attForward:Dot(wepForward)

    /*if self.RANDOMS_DEBUG then
        print("---- FLASHLIGHT VALIDATION ----")
        print("Weapon:", wep:GetClass())
        print("Dot:", dot)
        print("-------------------------------")
    end*/

    if dot < 0.30 then
        if self.RANDOMS_DEBUG then
            print("Rejected flashlight: bad attachment alignment")
        end
        self.NextFlashlightRetryT = CurTime() + math.Rand(10, 30)
        return
    end

    self._FlashlightWeapon = wep
    wep.WeaponFlashlightFlag = true 
    self.HumanWepHasWepFlashLight = true

    local rngNearz = mRand(10, 15)
    local rngFarz = mRand(600, 1000)
    local rngFOV = mRand(40, 60)

    -- PROJECTED LIGHT
    self.WeaponFlashlightSpotLight = SafeCreate("env_projectedtexture")
    if not self.WeaponFlashlightSpotLight then return end

    local light = self.WeaponFlashlightSpotLight
    light:SetParent(wep)
    light:SetPos(attData.Pos)
    light:SetAngles(attData.Ang)
    light:SetKeyValue("enableshadows", "1")
    light:SetKeyValue("shadowquality", "1")
    light:SetKeyValue("SetNearZ", rngNearz)
    light:SetKeyValue("SetFarZ", rngFarz)
    light:SetKeyValue("SetFOV", rngFOV)
    light:Input("SpotlightTexture", NULL, NULL, "effects/flashlight001")
    light:SetOwner(self)
    light:Spawn()

    if muzzleAttachmentName then
        light:Fire("SetParentAttachment", muzzleAttachmentName)
    end

    table.insert(self.WepFlashEntTbl, light)
    self:DeleteOnRemove(light)

    -- BEAM SPOTLIGHT
    if self.HasWepFlashlightSpotlight then 
        local chance = self.FlashlightSpotlightChance or 2 
        if mRng(1, chance) == 1 then 
            local spot = SafeCreate("beam_spotlight")
            if spot then
                spot:SetPos(attData.Pos)
                spot:SetAngles(attData.Ang)
                spot:SetKeyValue("spotlightlength", mRng(500, 950))
                spot:SetKeyValue("spotlightwidth", mRng(15, 35))
                spot:SetKeyValue("spawnflags","2")
                spot:Fire("Color","255 255 255")
                spot:SetParent(wep, muzzleAttachmentIndex)
                spot:Spawn()
                spot:Activate()
                spot:Fire("lighton")
                spot:AddEffects(EF_PARENT_ANIMATES)

                if muzzleAttachmentName then
                    spot:Fire("SetParentAttachment", muzzleAttachmentName)
                end

                table.insert(self.WepFlashEntTbl, spot)
                self:DeleteOnRemove(spot)
            end
        end 
    end 

    --GLOW ORB
    if self.HasWeaponFlashGlowOrb then 
        local chance = self.FlashLightGlowOrbChance or 2 
        if mRng(1, chance) == 1 then 
            local orb = SafeCreate("env_sprite")
            if orb then
                orb:SetKeyValue("model", "sprites/light_glow03.vmt")
                orb:SetPos(attData.Pos)
                orb:SetKeyValue("scale", mRand(0.1, 0.35))
                orb:SetKeyValue("rendercolor", "255 255 255 255")
                orb:SetParent(wep, muzzleAttachmentIndex)
                orb:SetKeyValue("rendermode", "9")
                orb:SetKeyValue("spawnflags", "0")
                orb:SetAngles(attData.Ang)
                orb:Spawn()
                orb:Activate()

                if muzzleAttachmentName then
                    orb:Fire("SetParentAttachment", muzzleAttachmentName)
                end

                table.insert(self.WepFlashEntTbl, orb)
                self:DeleteOnRemove(orb)
            end
        end 
    end 

    -- AMBIENT LIGHT
    if self.HasWeaponFlashAmbGlow and IsValid(light) then 
        local chance = self.FlashLightAmbGlowChance or 2 
        if mRng(1, chance) == 1 then 
            local amb = SafeCreate("light_dynamic")
            if amb then
                amb:SetParent(light)
                amb:SetPos(light:GetPos())
                amb:SetAngles(self:GetAngles())
                amb:SetKeyValue("brightness", mRand(1, 8))
                amb:SetKeyValue("distance", mRand(25, 50))
                amb:SetKeyValue("rendercolor", "255 255 255")
                amb:Spawn()
                amb:Activate()

                table.insert(self.WepFlashEntTbl, amb)
                self:DeleteOnRemove(amb)
            end
        end 
    end 
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsVJAnimationLockState()
    if not IsValid(self) then return end 
    if not self.IsVJBaseSNPC then return end 
    if not self:Alive() then return end 

    local state = self:GetState()
    local badState = (state == VJ_STATE_ONLY_ANIMATION_CONSTANT or state == VJ_STATE_ONLY_ANIMATION or state == VJ_STATE_ONLY_ANIMATION_NOATTACK or state == VJ_STATE_FREEZE)
    
    //if self.RANDOMS_DEBUG then
        //print("AnimState:", state, "Blocked:", badState)
    //end

    return badState
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCallForHelp(ally, isFirst)
    self:Ally_CallForHelpReaction(ally) 
end

function ENT:Ally_CallForHelpReaction(ally)
    if not IsValid(ally) then return end 
    if not ally.Ally_RespondCallForHelp then return end 
    if not ally.IsVJBaseSNPC or not ally.IsVJBaseSNPC_Human then return end 
    if ally.VJ_IsBeingControlled then return end 
    if not ally:Alive() then return end 
    if (ally:GetClass() == self:GetClass() or ally.VJ_NPC_Class == self.VJ_NPC_Class) and not ally:IsBusy("Activities") and mRng(1, ally.Ally_ResponseCallForHelpAnimChance or 1) == 1 then
    
        local cfhTbl = ally:GetRandomValidValue(ally.Ally_CfhResponseAnim)
        local baseCallHelpTbl = self:GetRandomValidValue(self.AnimTbl_CallForHelp) 
        local responseAnim = nil
        local isGes = false
        
        if cfhTbl then -- local to my SNPC, assumes input is gesture
            isGes = true 
            responseAnim = cfhTbl

        elseif baseCallHelpTbl then -- Other allies
            responseAnim = baseCallHelpTbl
        end

        if not responseAnim then return end 

        local seq = self:LookupSequence(responseAnim)
        if not seq or seq < 0  then return end 

        local animT = ally:SequenceDuration(ally:LookupSequence(seq))

        if isGes then 
            local responseAnim = "vjges_" .. responseAnim
        end 

        ally:PlayAnim(responseAnim, true, animT, ally.CallForHelpAnimFaceEnemy)
        ally.CallForHelpAnimCooldown = CurTime() + (ally.CallForHelpAnimCooldown or 0)
    end
end 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.NextFireFlareT = 0
ENT.FlareGunAttachment = {"anim_attachment_RH","grenade_attachment"} 
ENT.CanFireFlareGunSeq = true
ENT.AlertSignalChance = false
ENT.PerformingAlertBehavior = false 

ENT.FireFlareSeq_OnAlert = true 
ENT.FireFlareSeq_Chance = 6
ENT.FireFlareSeq_MaxDist = 7000
function ENT:OnAlert(ent)
    VJ.STOPSOUND(self.CurrentIdleSound)
    if self.VJ_IsBeingControlled then return end 
    if self:IsBusy() then return end 
    if self.PerformingAlertBehavior then return end

    self:ReactiveCoverBehavior()

    local enemy = self:GetEnemy()

    if IsValid(enemy) then
        local behavior = mRng(1, 3)
        self.PerformingAlertBehavior = true

        if behavior == 1 then
            self:PerformAlertSignal(enemy)
        elseif behavior == 2 and self.FireFlareSeq_OnAlert then
            self:FireFlareGun(enemy)
        elseif behavior == 3 then
            self:TakeCover(enemy)
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
    // -- [Helper Functions!] -- \\ 
function ENT:IsAbleToMoveNow()
    local moveType = self.MovementType

    if moveType == VJ_MOVETYPE_AERIAL
    or moveType == VJ_MOVETYPE_AQUATIC
    or moveType == VJ_MOVETYPE_STATIONARY
    or self.IsGuard then
        return false
    end

    return self:GetNavType() == NAV_GROUND
end

function ENT:GetRandomValidValue(var)
    if not var then return false end
    if not IsValid(self) then return false end 

    if istable(var) then
        local count = #var
        if count > 0 then
            return var[mRng(1, count)]
        end

    elseif isstring(var) and var ~= "" then
        return var
    end

    return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
//I gotta just merge these two functions below since they are practically the same bloody thing. 
ENT.ReactiveCover_ArmedEne = true 
ENT.ReactiveCoverChance = 3 
ENT.ReactiveCoverNextT = 10   
ENT.NextReactiveCoverT = 0        

function ENT:ReactiveCoverBehavior()
    if not self.ReactiveCover_ArmedEne then return end 
    if self.PerformingAlertBehavior then return end 
    if self.VJ_IsBeingControlled then return end

    if not self:IsAbleToMoveNow() then return end
    local busy = self:IsVJAnimationLockState() or self:IsBusy() or self.Flinching 
    if self.CurrentlyHealSelf or busy or not self:IsOnGround() then return end
    
    local cT = CurTime()
    if cT < self.TakingCoverT or cT < self.NextReactiveCoverT then return end

    local enemy = self:GetEnemy()
    if not IsValid(enemy) then return end

    local wep = enemy:GetActiveWeapon()
    if not IsValid(wep) then return end
    
    local chance = self.ReactiveCoverChance or 3 
    if mRng(1, chance) ~= 1 then return end
    local exDelay = mRand(5, 20) or 20
    self.NextReactiveCoverT = cT + self.ReactiveCoverNextT + exDelay
    self:Handle_ScheduledForceMove(false, "Both", "Both", "Run", "Rng")

    if self.RANDOMS_DEBUG then
        print("Taken cover cuz ene is armed!!!!")
    end 
end

ENT.OnAlert_Cover = true 
ENT.AlertCover_DistCheck = 1500

ENT.Valid_CoverClassesTbl = {
    ["prop_physics"] = true,
    ["func_brush"] = true,
    ["prop_static"] = true,
    ["prop_dynamic"] = true
}


function ENT:TakeCover(enemy)
    if not self.OnAlert_Cover then return end 
    if self.VJ_IsBeingControlled then return end 

    if not self:IsAbleToMoveNow() then return end
    if not IsValid(enemy) or not self.PerformingAlertBehavior then return end

    local curTime = CurTime()
    if curTime < self.TakingCoverT then return end 

    local myPosCent = self:GetPos() + self:OBBCenter()
    local eyePos = self:EyePos()
    local inCover = self:DoCoverTrace(myPosCent, eyePos, false, {SetLastHiddenTime = true})
    if inCover then return end 

    local dist = tonumber(self.AlertCover_DistCheck) or 1500
    local selfPos = self:GetPos()
    local isBusy = self:IsBusy()
    local coverPos;

    for _, prop in ipairs(ents.FindInSphere(selfPos, dist)) do
        if self.Valid_CoverClassesTbl[prop:GetClass()] and not isBusy then
            coverPos = prop:GetPos()
            break
        end
    end

    local delT = mRand(0.1, 0.5)
    timer.Simple(delT, function()
        if not IsValid(self) then return end
        self:Handle_ScheduledForceMove(false, "Both", "Both", "Run", "Rng")
        if self.PerformingAlertBehavior then
            local flagResetT = mRng(1, 3)
            timer.Simple(flagResetT, function()
                if IsValid(self) then
                    self.PerformingAlertBehavior = false
                end
            end)
        end
    end)
end

ENT.AlertGesSignal = true 
ENT.GestureSignal_AnimTbl = {"gesture_signal_takecover","gesture_signal_right","gesture_signal_left","gesture_signal_halt","gesture_signal_advance","gesture_signal_forward","gesture_signal_group"}
ENT.PlayGesAlert_MaxDist = 2000 
function ENT:PerformAlertSignal(enemy)
    if not self.AlertGesSignal then return end 
    if not self.PerformingAlertBehavior then return end 
    if self:IsBusy() or self.Flinching or self:IsVJAnimationLockState() then return end 
    if not IsValid(enemy) then return end
    if enemy:Visible(self) then
        
        local distanceToEnemy = self:GetPos():Distance(enemy:GetPos())
        local dist = self.PlayGesAlert_MaxDist or 1500

        if distanceToEnemy > dist then 
            local signalAnims = self:GetRandomValidValue(self.GestureSignal_AnimTbl)
            if not signalAnims then return end 
            
            self:PlayAnim("vjges_" .. signalAnims) 
            self.AlertSignalChance = true

            if mRng(1, 3) == 1 and self:IsAbleToMoveNow() then
                self:Handle_ScheduledForceMove(false, "Both", "Both", "Run", "Rng")
            end 

            timer.Simple(mRand(2, 4), function()
                if IsValid(self) then
                    self.AlertSignalChance = false
                    self.PerformingAlertBehavior = false
                end
            end)
        else
            self.PerformingAlertBehavior = false
        end
    else
        self.PerformingAlertBehavior = false
    end
end

ENT.FireFlareGun_Anim = "shootflare"
ENT.HolsterWeapon_Anim = false
ENT.FireFlareGun_MaxHeight = 6250
function ENT:FireFlareGun(enemy)
    if not self.CanFireFlareGunSeq then return end 
    if not self.PerformingAlertBehavior then return end 
    if not IsValid(enemy) then return end

    local conv = GetConVar("vj_stalker_fire_flares"):GetInt()
    if conv ~= 1 then return end 

    local state = self:GetNPCState()
    if state ~= NPC_STATE_ALERT or state ~= NPC_STATE_COMBAT then return end 

    local mDist = self.FireFlareSeq_MaxDist or 5000
    local busy = self:IsVJAnimationLockState() or self:IsBusy() or self.Flinching
    if self:GetPos():Distance(enemy:GetPos()) < mDist or busy then 
        self.PerformingAlertBehavior = false
        return false
    end

    local pos = self:GetPos()
    local zH = self.FireFlareGun_MaxHeight or 6000
    local vec = Vector(0, 0, zH)
    local traceResult = util.TraceLine({
        start = pos,
        endpos = pos + vec, 
        filter = self
    })

    if traceResult.Hit then
        self.PerformingAlertBehavior = false
        return
    end

    local attachmentName;
    local gunAtt = self.FlareGunAttachment
    if gunAtt then 
        for _, attName in ipairs(gunAtt) do
            local attachmentIndex = self:LookupAttachment(attName)
            if attachmentIndex and attachmentIndex > 0 then
                attachmentName = attName
                break 
            end
        end
    end 

    if not attachmentName then
        self.PerformingAlertBehavior = false
        return false
    end

    local activeWeapon = self:GetActiveWeapon()

    local fireFlareChance = self.FireFlareSeq_Chance or 6 
    if IsValid(activeWeapon) and mRng(1, fireFlareChance) == 1 then
        if self.NextFireFlareT <= CurTime() then 

            local anim = self:GetRandomValidValue(self.FireFlareGun_Anim)
            if not anim then return end 

            local seq = self:LookupSequence(anim)
            if not seq or seq < 0 then return end 

            local aT = self:SequenceDuration(seq) or 1 

            activeWeapon:SetNoDraw(true)

            local drawWepSnd = self:GetRandomValidValue(self.DrawNewWeaponSound)
            if drawWepSnd then 
                VJ.EmitSound(self, drawWepSnd, rngVol, rngSnd)
            end 
            
            self:RemoveAllGestures()
            self:PlayAnim("vjseq_" .. anim, true, aT, true)

            local RHand = self:GetAttachment(self:LookupAttachment(attachmentName))
            self.PropFlareGun = ents.Create("prop_vj_animatable")
            if not IsValid(self.PropFlareGun) then return end 
            self.PropFlareGun:SetModel("models/vj_base/weapons/w_flaregun.mdl")
            self.PropFlareGun:SetPos(RHand.Pos)
            self.PropFlareGun:SetAngles(RHand.Ang)
            self.PropFlareGun:SetParent(self)
            self.PropFlareGun:Fire("SetParentAttachment", attachmentName)
            self.PropFlareGun:Spawn()
            self.PropFlareGun:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

            local rngSnd = mRng(80, 110)
            local rngVol = mRng(60, 75)
            local initDelayT = mRand(0.4, 0.55)

            timer.Simple(initDelayT, function()
                if IsValid(self) then
                    VJ.EmitSound(self, "vj_base/weapons/flaregun/single.wav", rngVol, rngSnd)
                    local flareround = ents.Create("obj_vj_flareround")
                    local y = mRand(-50,50)
                    local z = mRand(10000, 15000)
                    if IsValid(flareround) then
                        flareround:SetPos(RHand.Pos + Vector(0, 0, 10)) 
                        flareround:SetAngles(RHand.Ang)
                        flareround:SetOwner(self)
                        flareround:Spawn()
                        flareround:GetPhysicsObject():ApplyForceCenter(Vector(0, y, z))
                    end
                end
            end)

            timer.Simple(aT + 0.08, function()
                SafeRemoveEntity(self.PropFlareGun)
                if IsValid(self) then

                    local drawAnim = self:GetRandomValidValue(self.HolsterWeapon_Anim)
                    if not drawAnim then return end 

                    local seq = self:LookupSequence(drawAnim) 
                    if not seq or seq < 0 then return end 
                    local time = self:SequenceDuration(seq) or 1 

                    self:PlayAnim("vjseq_" .. drawAnim, true, time, false)

                    local snd = self:GetRandomValidValue(self.DrawNewWeaponSound)
                    if snd then 
                        VJ.EmitSound(self, snd, rngVol, rngSnd)
                    end 

                    activeWeapon:SetNoDraw(false)
                    self.PerformingAlertBehavior = false
                end
            end)

            local cur = CurTime()
            self.CombatFlareDeployT = cur + mRand(15, 35)
            self.NextFireFlareT = cur + mRand(45, 125)
            self.NextFireQuickFlareT = cur + mRand(5, 25)
        else
            self.PerformingAlertBehavior = false
        end
    else
        self.PerformingAlertBehavior = false
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SaveCurrentWeapon()
    if not IsValid(self:GetActiveWeapon()) then return end
    timer.Simple(0.1, function()
    if IsValid(self) then
        local wep = self:GetActiveWeapon()
        if IsValid(wep) and wep.IsVJBaseWeapon then
            self.HumanPrimaryWeapon = wep:GetClass()
            print("Weapon added to ENT.HumanPrimaryWeapon table:", wep:GetClass())
            end
        else
            print("No active weapon found, or the weapon is not a VJ base weapon")
        end
    end)

    if not IsValid(self:GetActiveWeapon()) then return end
    timer.Simple(1, function() 
        if IsValid(self) then 
            if IsValid(wep) then
            
            local wep = self:GetActiveWeapon()
                print("Current weapon saved in ENT.HumanPrimaryWeapon table:", self.HumanPrimaryWeapon)
            else
                print("Failed to save the current weapon in ENT.HumanPrimaryWeapon table.")
            end
        end
    end)
end

function ENT:PickSecondaryWeapon()
    if not self.CanPickSecondaryWeapon then return end
    if not IsValid(self) then return end 
    
    local debugC = self.RANDOMS_DEBUG 
    local chosenWeapon = self:GetRandomValidValue(self.SecondaryWeaponInvTbl)
    if not chosenWeapon then return end 

    if chosenWeapon then
        self.HumanSecondaryWeapon = chosenWeapon
        if debugC then  
            print(self:GetName() .. " picked secondary: " .. chosenWeapon)
        end
    else
        if debugC then
            print("Warning: " .. self:GetName() .. " failed to pick a secondary weapon!")
        end
    end 
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Sts_SeqWepAnim = {"drawpistol"}
ENT.Sts_GesWepAnim = {"unholster_pistol","unholster_pistol2"}
ENT.Stp_SeqWepAnim = {"smgdraw"} 
ENT.Stp_GesWepAnim = {"weapon_draw_gesture","unholster_heavy","unholster_heavy2","unholster_light"}
ENT.WepSwitchRange_Max = 2500 -- If an enemy over this distance, don't switch weapons. 
ENT.PrimaryWepIdleSwitchDelay = {25, 90} 
ENT.NextIdleWeaponSwitchT = 0 
ENT.Wep_InvSwithcSound = true 

function ENT:WeaponSwitchMechanic()
    if not self.CanHumanSwitchWeapons then return end 
    if not IsValid(self) then return end 

    local wepSwitchConv = GetConVar("vj_stalker_weapon_switching"):GetInt() 
    if not wepSwitchConv or wepSwitchConv ~= 1 then return end 

    local debugging = self.RANDOMS_DEBUG

    if self.VJ_IsBeingControlled then
        return 
    end

    local ct = CurTime()

    local ene = self:GetEnemy()
    local curWep = self:GetActiveWeapon()
    local maxDistSqr = self.WepSwitchRange_Max * self.WepSwitchRange_Max

    if not isstring(self.HumanPrimaryWeapon) or self.HumanPrimaryWeapon == "" or not weapons.GetStored(self.HumanPrimaryWeapon) or
       not isstring(self.HumanSecondaryWeapon) or self.HumanSecondaryWeapon == "" or not weapons.GetStored(self.HumanSecondaryWeapon) then
        return 
    end

    if not IsValid(self.SecondaryWeaponEntity) then
        self.SecondaryWeaponEntity = self:Give(self.HumanSecondaryWeapon)
        if IsValid(self.SecondaryWeaponEntity) then
            self:SelectWeapon(self.HumanPrimaryWeapon) 
        end
    end

    if IsValid(ene) then 
        local badEne = (ene.VJ_ID_Boss or ene.IsVJBaseSNPC_Tank)
        local busy = self:IsVJAnimationLockState() or self:IsBusy()
        if busy then return end 
        if self:GetWeaponState() == VJ.WEP_STATE_RELOADING then return end 
        if not badEne and self:GetPos():DistToSqr(ene:GetPos()) < maxDistSqr and ct > self.WeaponSwitchT and IsValid(curWep) and not curWep.IsMeleeWeapon and not self:IsMoving() then

            VJ.EmitSound(self, self.DrawNewWeaponSound, 85, 100)
            if self.CurrentWeapon == 0 and curWep:Clip1() > 1 then
                self:RemoveAllGestures()
                local anim = VJ.PICK({"vjseq_" .. VJ.PICK(self.Sts_SeqWepAnim),"vjges_" .. VJ.PICK(self.Sts_GesWepAnim)})

                if anim then 
                    self:PlayAnim(anim, true, VJ.AnimDuration(self, anim), false)
                end 

                self:DoChangeWeapon(self.SecondaryWeaponEntity, true)
                self.CurrentWeapon = 1
                self.WeaponSwitchT = ct + mRand(15, 20)
                if debugging then
                    print("I've switched to my secondary")
                end 

            elseif self.CurrentWeapon == 1 then
                self:RemoveAllGestures()
                local anim = VJ.PICK({"vjseq_" .. VJ.PICK(self.Stp_SeqWepAnim),"vjges_" .. VJ.PICK(self.Stp_GesWepAnim)})

                if anim then 
                    self:PlayAnim(anim, true, VJ.AnimDuration(self, anim), false)
                end 

                self:DoChangeWeapon(self.WeaponInventory.Primary, true)
                self.CurrentWeapon = 0
                self.WeaponSwitchT = ct + mRand(5, 45)
                if debugging then 
                    print("I've switched to my primary")
                end 
            else
                self.WeaponSwitchT = ct + mRand(5, 25)
            end

            //If idle, reset our weapon to primary.
            local npcStat = self:GetNPCState()
        elseif not IsValid(ene) and self.CurrentWeapon == 1 and ct > self.NextIdleWeaponSwitchT and npcStat == NPC_STATE_IDLE and npcStat ~= NPC_STATE_ALERT and npcStat ~= NPC_STATE_COMBAT then
            if IsValid(self.WeaponInventory.Primary) and isstring(self.HumanPrimaryWeapon) and self.HumanPrimaryWeapon ~= "" and weapons.GetStored(self.HumanPrimaryWeapon) then 
                self:RemoveAllGestures()

                local anim = VJ.PICK({"vjseq_" .. VJ.PICK(self.Stp_SeqWepAnim),"vjges_" .. VJ.PICK(self.Stp_GesWepAnim)})
                if anim then 
                    self:PlayAnim(anim, true, VJ.AnimDuration(self, anim), false)
                end 

                self:DoChangeWeapon(self.WeaponInventory.Primary, true)

                self.CurrentWeapon = 0
                self.NextIdleWeaponSwitchT = ct + mRand(5, 15)
                if debugging then 
                    print("Switched back to primary weapon while idle.")
                else
                    print("Idle switch failed: Invalid or missing primary weapon entity!")
                end
            end 

        elseif self.Alerted and ct > self.WeaponSwitchT then
            self.WeaponSwitchT = ct + mRand(5, 25)
        end
    end
end 

function ENT:OnWeaponChange(newWeapon, oldWeapon, invSwitch)
    if invSwitch then 
        self:InventorySwithc_SoundHandle()
    end 
end

function ENT:InventorySwithc_SoundHandle()
    if not self.Wep_InvSwithcSound then return end 
    local delay = mRand(0.05, 0.25)

    local snd = self:GetRandomValidValue(self.DrawNewWeaponSound)
    if not snd then return end 

    timer.Simple(delay, function()
        if IsValid(self) then
            VJ.EmitSound(self, snd, 70, mRng(85, 115)) 
        end
    end) 
end 
---------------------------------------------------------------------------------------------------------------------------------------------
// -- Just to track which weapon is being used \\ -- 
function ENT:TrackHeldWeapon()
    local debug = self.RANDOMS_DEBUG
    if not debug then return end 
    local wep = self:GetActiveWeapon()
    local alive = self:Alive()

    local holdPrim = self.IsHoldingPrimaryWeapon
    local holdSec  = self.IsHoldingSecondaryWeapon

    local primClass = self.HumanPrimaryWeapon
    local secClass  = self.HumanSecondaryWeapon

    local meleeTbl  = self.WeaponInventory_MeleeList or {}
    local antiTbl   = self.WeaponInventory_AntiArmorList or {}

    local wepClass
    if IsValid(wep) and alive then
        wepClass = wep:GetClass()
        local isMelee = false
        local isAnti  = false

        for _, v in ipairs(meleeTbl) do
            if v == wepClass then
                isMelee = true
                break
            end
        end

        if not isMelee then
            for _, v in ipairs(antiTbl) do
                if v == wepClass then
                    isAnti = true
                    break
                end
            end
        end
        if wepClass == primClass then
            if not holdPrim then
                print("Now holding primary weapon.")
            end

            holdPrim = true
            holdSec  = false
        elseif wepClass == secClass then
            if not holdSec then
                print("Now holding secondary weapon.")
            end

            holdPrim = false
            holdSec  = true
        else
            if (holdPrim or holdSec) then
                if isMelee then
                    print("Now holding melee weapon.")
                elseif isAnti then
                    print("Now holding anti-armor weapon.")
                else
                    print("No longer holding a recognized weapon.")
                end
            end

            holdPrim = false
            holdSec  = false
        end

    else
        if (holdPrim or holdSec) then
            print("No weapon is being held.")
        end

        holdPrim = false
        holdSec  = false
    end
    self.IsHoldingPrimaryWeapon   = holdPrim
    self.IsHoldingSecondaryWeapon = holdSec
end


function ENT:TrackLosingWeapon()
    if not self.RANDOMS_DEBUG then return end 
    local wep = self:GetActiveWeapon()
    local hasWep = IsValid(wep)
    local melee = self.WeaponInventory_MeleeList
    local antiArm = self.WeaponInventory_AntiArmorList

    if hasWep then
        local class = wep:GetClass()

        for _, v in ipairs(meleeTbl) do
            if v == class then
                hasWep = false
                break
            end
        end

        if hasWep then
            for _, v in ipairs(antiArmTbl) do
                if v == class then
                    hasWep = false
                    break
                end
            end
        end
    end

    if validWhasWepeapon and not wep.IsVJBaseWeapon then return end 
    
    if self._LastWeaponValid == nil then
        self._LastWeaponValid = hasWep
        return
    end

    if self._LastWeaponValid == hasWep then return end

    if not hasWep then
        if self.IsHoldingPrimaryWeapon then
            print("Lost primary weapon!")
            self.IsHoldingPrimaryWeapon = false
            self.CurrentDoesNotHaveOrLostPrimary = true

        elseif self.IsHoldingSecondaryWeapon then
            print("Lost secondary weapon!")
            self.IsHoldingSecondaryWeapon = false
            self.CurrentDoesNotHaveOrLostSecondary = true
        end
    else
        print("Weapon equipped again!")
    end
    self._LastWeaponValid = hasWep
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanThrowGrenadeFromAttachment(attName)
    if not attName then return false end

    local attID = self:LookupAttachment(attName)
    if not attID or attID <= 0 then return true end 

    local attData = self:GetAttachment(attID)
    if not attData then return true end

    local startPos = attData.Pos
    local shootDir = self:GetForward()

    local tr = util.TraceLine({
        start = startPos,
        endpos = startPos + shootDir * 100,
        filter = self
    })

    if tr.Hit then
        if self.RANDOMS_DEBUG then
            print("Grenade Trace BLOCKED at:", attName)
        end
        return false
    end

    return true
end

ENT.GrenThrow_L = {"grenthrow", "throwitem", "grenthrow_hecu"}
ENT.GrenThrow_Gesture = {"grenthrow_gesture"}
ENT.GrenThrow_R = {"righthand_grendrop_cmb_b", "righthand_grenthrow_cmb_b"}
ENT.GrenThrow_Close = {"grendrop", "grenplace"}
ENT.GrenThro_EneTooClose = 1000

function ENT:OnGrenadeAttack(status, overrideEnt, landDir)
    local forceGesGrenMoveChance = self.FrcMoveGesGrenThrwChance or 3 
    self.CurrentGrenadeThrow_IsCloseRange = false
    self.CurrentGrenadeThrow_IsGesture = false 

    if status == "Init" then
        self:RemoveAllGestures()

        local ene = self:GetEnemy()
        local distToEnemy = (IsValid(ene) and self:GetPos():DistToSqr(ene:GetPos())) or (self.GrenThro_EneTooClose or 1250)
        local debugging = self.RANDOMS_DEBUG

        if not self.VJ_IsBeingControlled and self.HasAltGrenThrowAnims then

            -- CLOSE RANGE THROW
            if distToEnemy <= self.NPC_GrenadeCloseProxDist and mRng(1, 3) ~= 1 then
                if debugging then print("Close-range gren throw") end 

                if self:CanThrowGrenadeFromAttachment("anim_attachment_LH") then
                    local throwAnim = self:GetRandomValidValue(self.GrenThrow_Close)
                    if throwAnim then 
                        self.AnimTbl_GrenadeAttack = "vjseq_" .. throwAnim
                        self.GrenadeAttackAttachment = "anim_attachment_LH"
                        self.CurrentGrenadeThrow_IsCloseRange = true
                        return
                    end 
                end
            end

            local validThrows = {}

            -- LEFT
            if self:CanThrowGrenadeFromAttachment("anim_attachment_LH") then
                table.insert(validThrows, 1)
            else
                if debugging then print("LEFT blocked") end
            end

            if self:IsAbleToMoveNow() then
                if self:CanThrowGrenadeFromAttachment("anim_attachment_LH") then
                    table.insert(validThrows, 2)
                else
                    if debugging then print("GESTURE blocked") end
                end
            end

            if self.HasRightHandedGrenThrowAnim then
                if self:CanThrowGrenadeFromAttachment("anim_attachment_RH") then
                    table.insert(validThrows, 3)
                else
                    if debugging then print("RIGHT blocked") end
                end
            end

            if #validThrows <= 0 then
                if debugging then print("No valid grenade throw paths") end
                return true
            end

            local throwType = table.Random(validThrows)

            -- LEFT HAND THROW
            if throwType == 1 then
                if debugging then print("L-Handed grenade throw") end 

                local throwAnim = self:GetRandomValidValue(self.GrenThrow_L)
                if throwAnim then  
                    self.AnimTbl_GrenadeAttack = "vjseq_" .. throwAnim
                    self.GrenadeAttackAttachment = "anim_attachment_LH"
                end 

            -- GESTURE THROW
            elseif throwType == 2 then
                if debugging then print("Ges-gren throw") end 

                local throwAnim = self:GetRandomValidValue(self.GrenThrow_Gesture)
                if throwAnim then 
                    self.CurrentGrenadeThrow_IsGesture = true 
                    self.AnimTbl_GrenadeAttack = "vjges_" .. throwAnim
                    self.GrenadeAttackAttachment = "anim_attachment_LH"

                    timer.Simple(mRand(0.1, 0.25), function()
                        if not IsValid(self) then return end
                        if self.ForceMoveOnGesGrenThrow and mRng(1, forceGesGrenMoveChance) == 1 then
                            if self:IsMoving() then self:StopMoving() end 

                            self:Handle_ScheduledForceMove(false, "Both", "Both", "Run", "Rng")
                        end
                    end)
                end 

            local myPosCent = self:GetPos() + self:OBBCenter()
            local eyePos = self:EyePos()
            local inCover = self:DoCoverTrace(myPosCent, eyePos, false, {SetLastHiddenTime = true})
            if inCover then 
                if debugging then print("GRENADE THROW RIGHT, WE ARE SKIPPING AS WE ARE IN COVER RIGHT NOW") end 
                return 
            end -- Since it is an underhand throw, the grenade usually bounces off the walls
            elseif throwType == 3 then
                if debugging then print("R-Handed grenade throw") end 

                local throwAnim = self:GetRandomValidValue(self.GrenThrow_R)
                if throwAnim then 
                    self.AnimTbl_GrenadeAttack = "vjseq_" .. throwAnim
                    self.GrenadeAttackAttachment = "anim_attachment_RH"
                end 
            end
        end
    end
end

function ENT:OnGrenadeAttackExecute(status, grenade, overrideEnt, landDir, landingPos)
    if self.HasLimitedGrenadeCount and self.HumanGrenadeCount > 0 then
        self.HumanGrenadeCount = self.HumanGrenadeCount - 1
        print(self.HumanGrenadeCount)
    end
    local plainGrenTrailCv  = GetConVar("vj_stalker_gren_trail")
    local redGrenTrainCv    = GetConVar("vj_stalker_red_grenade_trail")
    local enemy = self:GetEnemy()
    if status == "PostSpawn" then
        if not IsValid(overrideEnt) then
            if self.AllowedToHaveGrenTrail then
                local rngC = mRand(100, 150)
                local c = Color(rngC, rngC, rngC)
                if plainGrenTrailCv:GetInt()  == 1 then
                    util.SpriteTrail(grenade, mRng(5, 10), c, true, mRand(2.5, 3.5), 3, 0.35, 1 / (6 + 6) * mRng(0.4, 0.7), "trails/smoke")
                end
                if redGrenTrainCv:GetInt()  == 1 then
                    local redTrail = util.SpriteTrail(grenade, 1, Color(255, 0, 0), true, mRng(9, 15), mRng(1, 3), 0.5, 0.0555, "sprites/bluelaser1.vmt")
                    if IsValid(redTrail) then
                        redTrail:SetKeyValue("rendermode", "5")
                        redTrail:SetKeyValue("renderfx", "0")
                    end
                end
            end

            if not self.CurrentGrenadeThrow_IsGesture and mRng(1, self.FindCoverChanceAfter_Grenade) == 1 and self:IsAbleToMoveNow() then 
                self:Handle_ScheduledForceMove(false, "Both", "Both", "Run", "Rng")
            end 
        end
        
        local up      = self:GetUp()
        local right   = self:GetRight()
        local forward = self:GetForward()
        if self.HasDynamicThrowArc then
            if not IsValid(enemy) then
                local fallbackVel = forward * mRand(500, 750) + up * mRand(150, 225)
                fallbackVel = fallbackVel + right * mRand(-30, 30)
                return fallbackVel
            end
            
            local posTrVal = Vector(0, 0, mRng(500, 1000))
            local enePos = enemy:GetPos()
            local trEnemyTarget = util.TraceLine({
                start = enePos,
                endpos = enePos + posTrVal,
                filter = enemy
            })

            local myPos = self:GetPos()
            local trSelfPosition = util.TraceLine({
                start = myPos,
                endpos = myPos + posTrVal,
                filter = self
            })

            if trSelfPosition.Hit or (trEnemyTarget.Hit and IsValid(enemy)) then
                return (landingPos - grenade:GetPos()) + (up * mRand(100, 225) + forward * mRand(350, 550) + right * mRand(-35, 45))
            end

            local distanceToTarget = grenade:GetPos():Distance(landingPos)
            local scaleFactor = math_Clamp(distanceToTarget / 2925, 1, 3)
            local upDir, forwardDir, leftOrRightDir

            if self.CurrentGrenadeThrow_IsCloseRange then
                upDir = up * mRand(75, 100) * scaleFactor
                forwardDir = forward * mRand(50, 100) * scaleFactor
                leftOrRightDir = right * mRand(-35, 45) * scaleFactor
                print("Reduced Close-Range Throw")
            elseif distanceToTarget > 2925 then
                upDir = up * mRand(1200, 1525) * scaleFactor
                forwardDir = forward * mRand(1525, 1855) * scaleFactor
                leftOrRightDir = right * mRand(-60, 80) * scaleFactor
                print("Arc-Throw")
            else
                upDir = up * mRand(235, 275) * scaleFactor
                forwardDir = forward * mRand(775, 1255) * scaleFactor
                leftOrRightDir = right * mRand(-30, 30) * scaleFactor
                print("Regular-Throw")
            end

            self.CurrentGrenadeThrow_IsCloseRange = false
            self.CurrentGrenadeThrow_IsGesture = false

            local throwVelocity = (landingPos - grenade:GetPos()) + upDir + forwardDir + leftOrRightDir
            return throwVelocity
        end
    end
end

function ENT:MngGrenadeAttackCount() 
    if not self.HasGrenadeAttack then return end 
    if not IsValid(self) then return end 
    if self.HasLimitedGrenadeCount then 
        self.HasGrenadeAttack = self.HumanGrenadeCount > 0
    end 
end 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanISurrender = false
ENT.SupplyTakeT = 0
ENT.SupplyTook = false

function ENT:OnInput(key, activator, caller, data)
    if not (IsValid(activator) and activator:IsPlayer() and activator:KeyDown(IN_USE)) then return end
    if VJ_CVAR_IGNOREPLAYERS or self.VJ_IsBeingControlled then return end

    local curTime = CurTime()
    local disp = self:Disposition(activator)

    local busy = self:IsVJAnimationLockState() or self:IsBusy()
    if busy then return end 

    local npcState = self:GetNPCState()
    if npcStat ~= NPC_STATE_ALERT and npcStat ~= NPC_STATE_COMBAT  then 
        if (disp == D_LI or disp == D_NU) and self.CanReactToUse and curTime > self.LastReactToUseTime and self:Visible(activator) then

            local chance = self.ReactToPlyIntChance or 3 
            if mRng(1, chance) == 1 then
                local chosenFlinch = self:GetRandomValidValue(self.ReactToPlyUseAnim)
                if chosenFlinch then 
                    timer.Simple(self.ReactToUseDelay, function()
                        if IsValid(self) then
                            self:RemoveAllGestures()
                            self:PlayAnim("vjges_" .. chosenFlinch, false)
                        end
                    end)
                end 
                self.LastReactToUseTime = curTime + self.ReactToUseCooldown
            else
                self.LastReactToUseTime = curTime + mRand(1, 2)
            end
        end

        timer.Simple(mRand(0.5, 2.5), function()
            if not IsValid(self) then return end
            if self.IsCurrentlyIncapacitated and self.SpawnGrenadeWhenIncap then
                if self.HasLimitedGrenadeCount and not (self.HumanGrenadeCount <= 0) then
                    if curTime < (self.Incap_SpawnGrenNextT or 0) then return end
                    if (disp == D_HT or disp == D_FR) and curTime > (self.LastGrenadeSpawnTime or 0) then
                        if mRng(1, self.ChanceDropNade or 2) == 1 then
                            self:LastStand_GrenSpwn()
                        else
                            self.LastGrenadeSpawnTime = curTime + mRand(1, 2)
                        end
                    end
                end
            end
        end)
    end 
end

function ENT:LastStand_GrenSpwn()
    if self.HasLimitedGrenadeCount then
        if self.HumanGrenadeCount <= 0 then return end
        self.HumanGrenadeCount = self.HumanGrenadeCount - 1
    end

    local rngSnd = mRng(85, 105)
    local grenade = ents.Create("obj_vj_grenade")
    local grenPin = "general_sds/ex_thrw_snd/m67_pin.wav"
    local cT = CurTime()

    if not IsValid(grenade) then return end
    local frontPos = self:GetPos() + self:GetForward() * mRand(1, 5) +self:GetUp() * mRand(1, 5) + self:GetRight() * mRand(-5, 5)

    grenade:SetPos(frontPos)
    grenade:Spawn()

    if grenPin then 
        VJ.EmitSound(grenade, grenPin, 70, rngSnd)
    end 

    self.LastGrenadeSpawnTime = cT + 100

    local flinchAnim = self:GetRandomValidValue(self.ReactToPlyUseAnim)
    if not flinchAnim then return end 
    local seq self:LookupSequence(flinchAnim)
    if not seq or seq == -1 then return end 

    if mRng(1, 2) == 1 then
        self:RemoveAllGestures()
        self:PlayAnim("vjges_" .. flinchAnim, false)
    end

    if mRng(1, 2) == 1 then 
        self:PlaySoundSystem("Pain")
    end
end

function ENT:ManageIncapGrenadeTimer(startDelay)
    if self.IncapGrenTimerID then
        timer.Remove(self.IncapGrenTimerID)
        self.IncapGrenTimerID = nil
    end

    if startDelay then
        self.IncapGrenTimerID = "GrenadeDelay_" .. self:EntIndex()

        timer.Create(self.IncapGrenTimerID, startDelay, 1, function()
            if not IsValid(self) or not self:Alive() then return end
            if not self.IsCurrentlyIncapacitated then return end

            local ene = self:GetEnemy()
            if not IsValid(ene) then return end

            local ally = self:Allies_Check(self.Incap_SpawnGren_AllyDist)
            if ally then return end

            local eneDist = self:GetPos():Distance(ene:GetPos())
            if not self:Visible(ene) or eneDist > self.Incap_SpawnGren_EneDist then return end
            if self.HasLimitedGrenadeCount and not (self.HumanGrenadeCount <= 0) then 
                self:LastStand_GrenSpwn()
            end 
        end)
    end
end

function ENT:IdleIncap_LastChanceGren()
    if self.VJ_IsBeingControlled or not IsValid(self) or not self.IsCurrentlyIncapacitated then return end 
    local cT = CurTime()
    local ene = self:GetEnemy()
    if not IsValid(ene) then return end 

    local ally = self:Allies_Check(self.Incap_SpawnGren_AllyDist)
    if ally then 
        self:ManageIncapGrenadeTimer(false) 
        return
    end 

    local eneDist = self:GetPos():Distance(ene:GetPos())
    if cT < (self.LastGrenadeSpawnTime or 0) then return end 

    if mRng(1, self.Incap_SpawnGrenChance) ~= 1 then
        self.Incap_SpawnGrenNextT = cT + mRand(1, 5)
        return
    end
    local tooClose = tonumber(self.Incap_SpawnGren_DngClose) or 1250 -- Ally too close 
    local closeEneDist = tonumber(self.Incap_SpawnGren_EneDist) or 900
    local del = mRand(15, 25)
    if cT > (self.Incap_SpawnGrenNextT or 0) and tooClose and self:Visible(ene) and eneDist <= closeEneDist then
        self:ManageIncapGrenadeTimer(self.Incap_SpawnGrenDelay)
        self.Incap_SpawnGrenNextT = cT + del
        self.LastGrenadeSpawnTime = cT + del
    else
        self:ManageIncapGrenadeTimer(false) 
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RetreatAfterMeleeAttack()
    if not self.Flee_AfterMelee then return end 
    if self.VJ_IsBeingControlled or not IsValid(self) then return end 
    if self:IsBusy("Activities") then return end 
    if not self:IsAbleToMoveNow() then return end 

    local ene = self:GetEnemy()
    local curT = CurTime()
    local chance = self.Flee_AfterMeleeChance or 3

    timer.Simple(0, function()
        if IsValid(self) then
            if IsValid(ene) and self:Visible(ene) and curT > (self.Flee_AfterMeleeT or 0)  and mRng(1, chance) == 1 and curT > self.TakingCoverT and self:GetWeaponState() ~= VJ.WEP_STATE_RELOADING then
                self:StopAttacks(true)
                print("Fleeing after melee attack")
                
                local rngDelay = mRand(0.1, 0.5)
                timer.Simple(rngDelay, function()   
                    if IsValid(self) then
                        self:Handle_ScheduledForceMove(false, "Enemy", "Both", "Run", "Rng")
                    end
                end)
                local tAdd = mRand(5, 15)  
                self.NextMeleeAttackTime = curT + tAdd / mRng(1, 3)
                self.Flee_AfterMeleeT = curT + tAdd
            end
        end
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.RagdollForce_BaseMult = 1 
ENT.RagdollForce_UseRandomMult = true 
ENT.RagdollForce_RandomMultMin = 0.65 
ENT.RagdollForce_RandomMultMax = 1.45
ENT.RagdollForce_HeavyArmorMultMin = 1.5 
ENT.RagdollForce_HeavyArmorMultMax = 3.5 

function ENT:MeleeAttackKnockbackVelocity(ent)
    local def = self:GetForward() * mRng(100, 140) + self:GetUp() * 10
    if not IsValid(ent) then
        return def
    end
    local vec = self:Custom_AttackKnockback(ent)
    if not vec or not vec.IsVector or not vec:IsValid() then
        return def
    end
    return vec
end

function ENT:Custom_AttackKnockback(Hittarget)
    local forwardStrength = mRand(50, 100)
    local upStrength = mRand(15, 65)
    local sideStrength = mRand(-75, 75)
    local finalMult = self.RagdollForce_BaseMult or 1

    if self.RagdollForce_UseRandomMult then
        local rndMin = self.RagdollForce_RandomMultMin or 0.75
        local rndMax = self.RagdollForce_RandomMultMax or 1.25
        local randomMult = mRand(rndMin, rndMax)
        finalMult = finalMult * randomMult
    end

    forwardStrength = forwardStrength * finalMult
    upStrength = upStrength * finalMult
    sideStrength = sideStrength * finalMult

    if self.IsHeavilyArmored then
        local armorMult = mRand(self.RagdollForce_HeavyArmorMultMin, self.RagdollForce_HeavyArmorMultMax) or 2.5
        forwardStrength = forwardStrength * armorMult
        upStrength = upStrength * armorMult
    end
    return self:GetForward() * forwardStrength + self:GetUp() * upStrength + self:GetRight() * sideStrength
end 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeDmgBuffToAliens = true 
ENT.CanBreakPlyAmror = true 
ENT.BreakPlyArmorChance = 6 
ENT.BreakPlyArmorThresh = 50 -- 50% 

ENT.ScreenFadeActive = false 
ENT.RetreatAfterMeleeAttackChance = 4
ENT.CanKnckPlyWepOutHand = true 
ENT.PlyWeaponKnockOutChance = 6
ENT.FrcPlyHolsterWeaponChance = 3 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleMeleeRetreat(ent, status)
    if (status == "Miss" or status == "PreDamage") then 
        local chance = self.RetreatAfterMeleeAttackChance or 3 
        if mRng(1, chance) == 1 and not ent.isProp and ent:Alive() then
            self:RetreatAfterMeleeAttack()
        end
    end 
end

function ENT:ApplyMeleeDamageBuffs(ent)
    if not self.HasMeleeDmgBuffToAliens or not ent:Alive() then return end

    if ent.IsVJBaseSNPC and ent.IsVJBaseSNPC_Creature then
        local buff = mRng(2, 3)
        local melDB = self.RANDOMS_DEBUG
        if self.IsHeavilyArmored then
            local armorBuff = mRng(3, 5)
            self.MeleeAttackDamage = self.MeleeAttackDamage * buff * armorBuff
            if melDB then print("Stacked creature + heavy armor buff:", self.MeleeAttackDamage) end 
        else
            self.MeleeAttackDamage = self.MeleeAttackDamage * buff
            if melDB then print("Melee creature dmg buff:", self.MeleeAttackDamage) end 
        end
    elseif self.IsHeavilyArmored then
        local armorBuff = mRng(3, 5)
        self.MeleeAttackDamage = self.MeleeAttackDamage * armorBuff
        if melDB then print("Heavy armored melee buff:", self.MeleeAttackDamage) end 
    end
end

function ENT:HandleWeaponKnockout(ply)
    if not self.CanKnckPlyWepOutHand then return end

    local wep = ply:GetActiveWeapon()
    if IsValid(wep) then
        local knockChance = self.PlyWeaponKnockOutChance or 6 
        local inactChance = self.FrcPlyHolsterWeaponChance or 3 

        if mRng(1, knockChance) == 1 then
            ply:DropWeapon(wep)
        elseif mRng(1, inactChance) == 1 then
            ply:SetActiveWeapon(NULL)
        end
    end
end

function ENT:HandleArmorBreaking(ply)
    if not self.CanBreakPlyAmror then return end

    local breakChance = self.BreakPlyArmorChance or 6 
    if self.IsHeavilyArmored then 
        breakChance = math.max(1, breakChance / 3) 
    end 

    if mRng(1, breakChance) == 1 then
        local currentArmor = ply:Armor() or 0
        local maxArmor = ply:GetMaxArmor() or 100
        if currentArmor > (maxArmor * (self.BreakPlyArmorThresh / 100)) then
            ply:SetArmor(0)
            
            local armBrkSnd = self:GetRandomValidValue(self.SoundTbl_ExtraArmorImpacts)
            if armBrkSnd then 
                VJ.EmitSound(ply, armBrkSnd, mRng(75, 105))
            end
        end
    end
end

function ENT:ApplyMeleeVisualEffects(ply)
    
    local pitch = mRng(-125, 125)
    local yaw = mRng(-125, 125)
    local roll = mRng(-125, 125)

    if mRng(1, 3) == 1 then
        local mult = mRng(3, 4)
        pitch, yaw, roll = pitch * mult, yaw * mult, roll * mult
    end

    local shakeT = mRand(0.55, 6.5)
    local shakeDist = mRng(200, 450)
    local shakeFreq = mRng(100, 250)
    local shakeAmp = mRng(10, 45)

    if mRng(1, 3) == 1 then
        local sMult = mRng(3, 4)
        shakeT, shakeDist, shakeFreq, shakeAmp = shakeT * sMult, shakeDist * sMult, shakeFreq * sMult, shakeAmp * sMult
    end

    ply:ViewPunch(Angle(pitch, yaw, roll))
    ply:ScreenFade(SCREENFADE.IN, Color(mRng(60, 130), 0, 0, 200), mRand(3, 5), mRand(1, 5))
    util.ScreenShake(ply:GetPos(), shakeAmp, shakeFreq, shakeT, shakeDist)
end

ENT.KnockDown_Ply = true
ENT.KnockDown_Ply_Chance = 3
ENT.KnockDown_PlyNextT = 0
function ENT:Handle_KnockDownPlayer(ply)
    if not self.KnockDown_Ply then return end
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if not ply:Alive() then return end

    local chance = self.KnockDown_Ply_Chance or 3
    if mRng(1, chance) ~= 1 then return end

    local c = CurTime()
    if c < self.KnockDown_PlyNextT then return end

    self.KnockDown_PlyNextT = c + mRand(1, 3)

    if ply.VJ_Stalker_KnockDown then return end
    ply.VJ_Stalker_KnockDown = true

    ply.VJ_StoredJumpPower = ply:GetJumpPower()

    ply:ConCommand("+duck")
    ply:SetJumpPower(0)

    local getUpT = mRand(0.5, 3.5)

    timer.Simple(getUpT, function()
        if not IsValid(ply) then return end
        ply:ConCommand("-duck")
        if ply.VJ_StoredJumpPower then
            ply:SetJumpPower(ply.VJ_StoredJumpPower)
        end
        ply.VJ_Stalker_KnockDown = false
        ply.VJ_StoredJumpPower = nil
    end)
end

ENT.OnHit_DisPlyLight = true
ENT.OnHit_DisPlyLight_Chance = 1
ENT.OnHit_DisPlyLightNextT = 0

ENT.OnHit_DisPlyLight_SoundChance = 2 
ENT.OnHit_DisPlyLight_Sounds = {
    "ambient/energy/spark1.wav",
    "ambient/energy/spark2.wav",
    "ambient/energy/spark3.wav",
    "ambient/energy/spark4.wav",
    "ambient/energy/spark5.wav",
    "ambient/energy/zap1.wav",
    "ambient/energy/zap2.wav",
    "ambient/energy/zap3.wav",
    "ambient/energy/zap4.wav",
    "ambient/energy/zap5.wav",
    "ambient/energy/zap6.wav",
    "ambient/energy/zap7.wav",
    "ambient/energy/zap8.wav",
    "ambient/energy/zap9.wav",
    "buttons/button10.wav",
    "buttons/button19.wav",
    "physics/metal/metal_box_impact_bullet1.wav",
}

function ENT:Sabotage_Flashlight(ply)
    if not self.OnHit_DisPlyLight then return end
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if not ply:Alive() then return end

    local c = CurTime()
    if c < self.OnHit_DisPlyLightNextT then return end

    local chance = self.OnHit_DisPlyLight_Chance or 3
    if mRng(1, chance) ~= 1 then return end

    self.OnHit_DisPlyLightNextT = c + mRand(1, 5)

    if ply:FlashlightIsOn() then
        ply:Flashlight(false)
        local cnce = self.OnHit_DisPlyLight_SoundChance or 3 
        if mRng(1, cnce) == 1 then 
            local snd = self:GetRandomValidValue(self.OnHit_DisPlyLight_Sounds)
            if snd then
                ply:EmitSound(snd, mRng(55, 75), mRng(75, 105))
            end
        end 
    end
end

ENT.HitPly_AffectDsp = true
ENT.HitPly_AffectDspChance = 3
ENT.HitPly_AffectDspNextT = 0
ENT.HitPly_AffectDspDuration = 3
ENT.HitPly_AffectDspTbl = {30, 31, 32, 33, 34, 35, 36}
function ENT:ApplyDeafness(ply)
    if not self.HitPly_AffectDsp then return end
    if not IsValid(ply) or not ply:IsPlayer() then return end

    local chance = self.HitPly_AffectDspChance or 3
    if mRng(1, chance) ~= 1 then return end

    local c = CurTime()
    if c < self.HitPly_AffectDspNextT then return end
    self.HitPly_AffectDspNextT = c + mRand(2, 5)

    if ply.VJ_Stalker_DSPActive then return end
    ply.VJ_Stalker_DSPActive = true

    local picked = self:GetRandomValidValue(self.HitPly_AffectDspTbl)
    if not picked then
        ply.VJ_Stalker_DSPActive = nil
        return
    end

    ply:EmitSound("ambient/levels/canals/headcrab_canals_rt_05.wav", 80, mRng(90, 120), 0.5)
    ply:SetDSP(picked)

    local resetTime = self.HitPly_AffectDspDuration or 3

    timer.Simple(resetTime, function()
        if IsValid(ply) then
            ply:SetDSP(0)
            ply.VJ_Stalker_DSPActive = nil
        end
    end)
end

ENT.SabtagePly_Wep = true 
ENT.SabtagePly_WepAmmoSteal = true 
ENT.SabtagePly_WepDisable = true 
ENT.SabtagePly_WepNextT = 0 
function ENT:HandleWeaponSabotage(ply)
    if not self.SabtagePly_Wep then return end
    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) then return end
    if wep:IsWeapon() ~= true then return end
    if wep:IsScripted() ~= true then return end

    local c = CurTime()
    if c < self.SabtagePly_WepNextT then return end 

    self.SabtagePly_WepNextT = c + mRand(1, 5)
    local effectRng = mRng(1, 2)

    if self.SabtagePly_WepAmmoSteal and effectRng == 1 then 
        if wep:Clip1() > 0 and wep:HasAmmo() then
            wep:SetClip1(0)
            ply:EmitSound("weapons/clipempty_rifle.wav", 75, 100)
        end
    elseif self.SabtagePly_WepDisable and effectRng == 2 then 
        local jam = mRand(1, 5)
        local delay = CurTime() + jam
        wep:SetNextPrimaryFire(delay)
        wep:SetNextSecondaryFire(delay)
        ply:EmitSound("physics/metal/metal_box_impact_hard1.wav", 70, 150)
    end
end

function ENT:OnMeleeAttackExecute(status, ent, isProp)
    if not IsValid(ent) then return end
    local isPlayer = ent:IsPlayer()

    self:HandleMeleeRetreat(ent, status)

    if status == "PreDamage" then 
        self:ApplyMeleeDamageBuffs(ent)
        self:OnFire_IgniteHitTar(ent) 

        -- Player specific debuffs!
        if isPlayer and ent:Alive() then
            self:HandleWeaponKnockout(ent)
            self:HandleArmorBreaking(ent)
            self:ApplyMeleeVisualEffects(ent)
            //self:Sabotage_ConcussionTilt(ent) -- I'll merge this later with other one. 
            self:Sabotage_Flashlight(ent)
            self:Handle_KnockDownPlayer(ent)
            self:ApplyDeafness(ent)
            //self:ApplyConcussionJitter(ent) -- And this one tooo
            self:HandleWeaponSabotage(ent)
        end
    end
end

ENT.OnFire_CanIgniteHitTarget = true 
ENT.OnFire_IgniteHitTarChance = 2 
ENT.OnFire_IgniteHitTarNextT = 0 
function ENT:OnFire_IgniteHitTar(target)
    if not self.OnFire_CanIgniteHitTarget then return end 
    if not self:IsOnFire() then return end 
    if not IsValid(target) then return end 
    if self:WaterLevel() > 0 or target:WaterLevel() > 0 then return end  
    if not target:Alive() then return end 
    if target:IsOnFire() then return end 
    if not (target:IsPlayer() or target:IsNPC() or target:IsNextBot()) then return end
    if target.IsVJBaseSNPC and (target.Immune_Fire or not target.AllowIgnition) then return end 

    if CurTime() < self.OnFire_IgniteHitTarNextT then return end 

    local fireDurT = mRand(1, 10)

    local chance = self.OnFire_IgniteHitTarChance or 2 
    if mRng(1, chance) ~= 1 then return end 

    target:Ignite(fireDurT) 
    self.OnFire_IgniteHitTarNextT = CurTime() + mRand(1, 5)
end 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttack(status, enemy)
    if status == "Init" then 
        self:Rng_MeleeAttHandle()
    end 
end

function ENT:Rng_MeleeAttHandle()
    if not self.Melee_HasRandomsCusAttacks then return end
    local canKick = self.Melee_CanKick
    local canHeadbutt = self.Melee_CanHeadbutt

    local meleeData = {
        [1]  = canKick and {anim={"vjseq_kick_door"}, next={0.5,2}, untilDmg={0.45,0.55}},
        [2]  = canKick and {anim={"vjseq_kick_cmb_b"}, next={0.25,2.5}, untilDmg={0.45,0.55}},
        [3]  = canKick and {anim={"vjseq_civil_proc_kickdoorbaton"}, next={0.65,3.25}, untilDmg={0.65,0.75}},
        [4]  = {anim={"vjseq_gunhit1_cmb_b"}, next={0.95,2.55}, untilDmg={0.65,0.7}},
        [5]  = {anim={"vjseq_gunhit2_cmb_b"}, next={0.35,1.25}, untilDmg={0.1,0.2}},
        [6]  = {anim={"vjseq_meleeattack01"}, next={1.25,2}, untilDmg={0.45,0.55}},
        [7]  = {anim={"vjseq_melee_slice"}, next={1.5,3.5}, untilDmg={0.65,0.7}},
        [8]  = {anim={"vjseq_melee_gunhit"}, next={0.75,2.25}, untilDmg={0.45,0.55}},
        [9]  = {anim={"vjseq_melee_gunhit1"}, next={1,2.55}, untilDmg={0.45,0.55}},
        [10] = {anim={"vjseq_melee_gunhit2"}, next={0.35,1.25}, untilDmg={0.35,0.4}},
        [11] = canHeadbutt and {anim={"vjseq_melee_headbutt"}, next={1,4.5}, untilDmg={0.6,0.65}},
        [12] = {anim={"vjseq_melee_gunslap"}, next={0.25,1}, untilDmg={0.25,0.3}},
        [13] = {anim={"vjseq_melee_gun_butt"}, next={0.25,1}, untilDmg={0.25,0.3}},
        [14] = {anim={"vjseq_melee_weapon_01"}, next={0.75,2.25}, untilDmg={0.45,0.55}},
        [15] = canKick and {anim={"vjseq_melee_weapon_02"}, next={2,5}, untilDmg={0.6,0.65}},
        [16] = {anim={"vjseq_melee_weapon_03"}, next={2,5}, untilDmg={0.6,0.65}},
        [17] = {anim={"vjseq_melee_weapon_04"}, next={0.75,2.25}, untilDmg={0.45,0.55}},
    }

    local randKey = mRng(1, 17)
    local selected = meleeData[randKey]
    if not selected then return end
    local rngDmg = mRand(10, 30) or 10
    if mRng(1, 3) == 1 then 
        rngDmg = math_ceil(rngDmg * mRand(0.8, 1.25))
    end 

    self.AnimTbl_MeleeAttack = selected.anim
    self.NextMeleeAttackTime = mRand(selected.next[1], selected.next[2])
    self.TimeUntilMeleeAttackDamage = mRand(selected.untilDmg[1], selected.untilDmg[2])
    self.MeleeAttackDamage = rngDmg

    if self.RANDOMS_DEBUG then
        print("Melee attack type = " .. randKey .. " | Damage = " .. self.MeleeAttackDamage .. " | TimeUntilDamage = " .. self.TimeUntilMeleeAttackDamage)
    end
end 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AnimReact_OnHeal = true
ENT.HealerEntReact_Anim = {"hg_nod_yes"}
ENT.HealedEntReact_Anim = {"hg_nod_yes", "g_fist", "g_fist_l"}
ENT.Extra_HealAnimms = {"heal", "grendrop", "grenplace"}
function ENT:OnMedicBehavior(status, statusData)
    local healAnims = self:GetRandomValidValue(self.Extra_HealAnimms)
    if healAnims then 
        self.AnimTbl_Medic_GiveHealth = "vjseq_" .. healAnims
    end 

    if status == "BeforeHeal" then
        self:RemoveAllGestures()
    end
    
    if status == "OnHeal" then
        self:Human_HealedReaction(statusData)
    end 
end

function ENT:Human_HealedReaction(data)
    if not self.AnimReact_OnHeal then return end

    local busy = self:IsVJAnimationLockState() or self:IsBusy()
    local npcState = self:GetNPCState()

    if npcState ~= NPC_STATE_ALERT and npcState ~= NPC_STATE_COMBAT then
        local healerResponse = self:GetRandomValidValue(self.HealerEntReact_Anim)

        if self.PlyAnimInRepOHeal then
            if busy or self.VJ_IsBeingControlled then return false end

            self:StopMoving()
            self:RemoveAllGestures()

            local delay = mRand(0.1, 1.5)

            timer.Simple(delay, function()
                if not IsValid(self) then return end
                if not IsValid(data) then return end
                if mRng(1, 2) == 1 and data.IsVJBaseSNPC_Human and not data:IsBusy() then
                    local healedEntResp = self:GetRandomValidValue(self.HealedEntReact_Anim)
                    if healedEntResp then
                        data:PlayAnim("vjges_" .. healedEntResp, false)

                        if self.RANDOMS_DEBUG then
                            print("HealedEntAnim: " .. healedEntResp)
                        end
                    end
                end

                if not healerResponse then return end
                if mRng(1, 2) == 1 and not busy then
                    self:PlayAnim("vjges_" .. healerResponse, false)
                    if self.RANDOMS_DEBUG then
                        print("Healer resp anim: " .. tostring(healerResponse))
                    end
                end
            end)
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Water_ExtinguishFire = true 
function ENT:WaterExtinguishSelFire()
    if not self.Water_ExtinguishFire then return end 
    if not IsValid(self) then return end 
    if not self:Alive() then return end 
    if not self:IsOnFire() then return end 
    local extinguishSnd = table.Random(self.WaterSplashSounds)
    local rngSnd = mRng(80, 105)
    if self:WaterLevel() > 0 then
        self:Extinguish()
        if extinguishSnd then
            VJ.EmitSound(self, extinguishSnd, 75, rngSnd)
        end 
        if not self.Immune_Fire then 
            if mRng(1, 2) == 1 then 
                self:PlaySoundSystem("Pain")
            end 
        end
    end
end 

ENT.React_ToOnFireConv = "vj_stalker_fire_react"
function ENT:ReactToFire()
    if not self.ReactToFireDance then return end 

    if self.React_ToOnFireConv then
        local convVar = GetConVar(self.React_ToOnFireConv)
        if convVar and convVar:GetInt() == 0 then
            return
        end
    end

    if self.VJ_IsBeingControlled then return end 
    if not IsValid(self) then return end

    local onFire = self:IsOnFire()
    local hp = self:Health()

    if not self:Alive() or hp <= 0 then 
        return  
    end 

    local busy = self:IsVJAnimationLockState() or self:IsBusy()

    if busy or self.Immune_Fire then 
        return 
    end

    if not onFire then
        self.CurrentlyBurning = false
        self:ResetAfterFire()
        return
    end

    local curT = CurTime()
    if curT < (self.BurnAnim_NextT or 0) then return end
    local anim = nil
    if self.OnFireIdle_Anim then
        if isstring(self.OnFireIdle_Anim) then
            anim = self.OnFireIdle_Anim
        elseif istable(self.OnFireIdle_Anim) and #self.OnFireIdle_Anim > 0 then
            anim = table.Random(self.OnFireIdle_Anim)
        end
    end

    if not anim then return end 

    local seq = self:LookupSequence(anim)
    if seq <= 0 then return end

    local dur = self:SequenceDuration(seq)
    if dur <= 0 then dur = 1 end

    if onFire and not self.Immune_Fire then
        self.CurrentlyBurning = true
        self:PlayAnim("vjseq_" .. anim, true, dur, false)
        self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, dur)
        self.BurnAnim_NextT = curT + dur - mRand(0.01,0.3)

        self.SavedDmgInfo = {type = DMG_BURN, force = Vector(0, 0, 0), inflictor = self } -- To avoid an error 
        if self.CanDropWeaponWhenOnFire then
            self:DeathWeaponDrop(self.SavedDmgInfo, HITGROUP_GENERIC)

            local activeWep = self:GetActiveWeapon()
            if IsValid(activeWep) then
                activeWep:Remove()
            end
        end
    end
end

function ENT:SetReactToFireVars()
    if not self.ReactToFireDance then return end 
    if not IsValid(self) then return end 
    if self:IsOnFire() and self.CurrentlyBurning then
        self._OriginalHealableTag = self.VJ_ID_Healable
        self.VJ_ID_Healable = false

        self.IsCurrentlyPlayingBurnAnim = true
        self.HasIdleSounds = false
        self.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
        self.CanShoot = false
        self.CanISurrender = false
        self.CallForHelp = false
        self.CanTurnWhileStationary = false
        self.MovementType = VJ_MOVETYPE_STATIONARY
        self.Medic_CanBeHealed = false
        self.HealthRegenParams.Enabled = false  
        self.CanFlinch = false
        self.HasInvestigateSounds = false
        self.HasLostEnemySounds = false
        self.HasAlertSounds = false
        self.HasCallForHelpSounds = false 
        self.CanDetectDangers = false
    end
end

function ENT:ResetAfterFire()
    self.HasIdleSounds = true
    self.CanShoot = true
    self.CanISurrender = true
    self.CallForHelp = true
    self.CanTurnWhileStationary = true
    self.MovementType = VJ_MOVETYPE_GROUND
    self.Medic_CanBeHealed = true
    self.HealthRegenParams.Enabled  = true 
    self.CanFlinch = true
    self.HasInvestigateSounds = true
    self.HasLostEnemySounds = true
    self.HasAlertSounds = true
    self.HasCallForHelpSounds = true
    self.IsCurrentlyPlayingBurnAnim = false
    self.CanDetectDangers = true
    self.Behavior = VJ_BEHAVIOR_AGGRESSIVE
    
    if self._OriginalHealableTag ~= nil then
        self.VJ_ID_Healable = self._OriginalHealableTag
        self._OriginalHealableTag = nil 
    end


    if GetConVar(tostring(self.FriendlyConvar)):GetInt()  == 1 then
        self:ManageFriendlyVars()
    end
end

function ENT:OnFireBehavior()
    if self:IsOnFire() and self:Alive() then
        self.CurrentlyBurning = true
        self.VJ_ID_Danger = true
    else
        self.CurrentlyBurning = false
        self.VJ_ID_Danger = false
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Intercept_DeathSnd()
    if not self.HasSounds or not self.HasDeathSounds then return end
    if not IsValid(self) then return end
    self.HasDeathSounds = false
end

function ENT:Handle_RngRadioBlip()
    if not self.Random_RadioSoundPlay then return end 
    local chance = self.Random_RadioSoundChance or 4 
    if mRng(1, chance) ~= 1 then return end 
    local snd = self.RandomRadioSound 
    if not snd then return end 
    local picked = istable(snd) and snd[mRng(1, #snd)] or snd 
    if isstring(picked) and picked ~= 1 then 
        VJ.EmitSound(self, picked, mRng(55, 75), mRng(65, 105))
    end 
end 

function ENT:OnDeath(dmginfo, hitgroup, status)
    local rngSnd = mRng(75, 105)

    local isHeadshot = self.Headshot_Death 
    local deflateChance = self.SevaSuitDeflateChance or 2 
    local atId = 0

    if status == "Init" then 
        if self.Headshot_Death and self.HeadShot_Death_StopDthSnd then 
            self:Intercept_DeathSnd()
        end 
        self:Handle_DropSecondaryWep(dmginfo)
        self:Handle_RngRadioBlip()

        if self.IsScientific and mRng(1, deflateChance) == 1 then 
            local snd = self.HazardSuit_DeathDeflate
            if not snd then return end 
            local sndPick = istable(snd) and snd[mRng(1, #snd)] or snd
            if isstring(sndPick) and sndPick ~= "" then 
                VJ.EmitSound(self, sndPick, 70, rngSnd)
            end 
        end

        local dmgType = dmginfo:GetDamageType()
        local isFireDeath = self:IsOnFire() and bit.band(dmgType, bit.bor(DMG_BURN, DMG_SLOWBURN)) ~= 0 and not self.Immune_Fire    
        if isFireDeath then 
            self.HasBeenBurntToDeath = true 
            if self.HasBurnToDeathSounds and not self.HasPlayedBurnDeathSound and mRng(1, self.BurnToDeathSoundChance) == 1 then    
                self:Intercept_DeathSnd()
                self.HasPlayedBurnDeathSound = true
                self.BurnToDeathSoundObj = VJ.CreateSound(self, self.BurnToDeathSound_Tbl, rngSnd, self:GetSoundPitch(self.DeathSoundPitch))
                if self.BurnToDeathSoundObj then
                    self.BurnToDeathSoundObj:Play()
                end
            end
        end 

        if isHeadshot then 
            self.CanPlayHeadshotDeahtAnim = true
            self:HeadshotDeathEffects()
        end
    end 
    
    if status == "DeathAnim" then
        self:DeahtAnimation_Handle(dmginfo, hitgroup)

        if mRng(1, 3) == 1 then
            self:DeathWeaponDrop()
            local activeWep = self:GetActiveWeapon()
            if IsValid(activeWep) then 
                activeWep:Remove() 
            end
        end
    end
end

function ENT:Handle_DropSecondaryWep(dmginfo)
    if not self.Weapon_DropSecondary then return end 
    if not dmginfo then return end

    local conv = GetConVar("vj_stalker_drop_seq_wep"):GetInt()
    if not conv or conv ~= 1 then return end 

    local wep = self:GetActiveWeapon()
    if IsValid(wep) then 
        local wepClass = wep:GetClass()
        local dropWeaponClass;
        local dropChance = tonumber(self.Weapon_DropSecondary_Chance) or 3 
        if wepClass == self.HumanPrimaryWeapon and mRng(1, dropChance) == 1 then
            dropWeaponClass = self.HumanSecondaryWeapon
        elseif wepClass == self.HumanSecondaryWeapon then
            dropWeaponClass = self.HumanPrimaryWeapon
        else
            return;
        end

        if not dropWeaponClass then return end

        local dropEnt = ents.Create(dropWeaponClass)
        local rngVel = mRand(-25,25)
        local safeRemEntConv = GetConVar("vj_stalker_drop_seq_wep_safe_rem"):GetInt()
        if IsValid(dropEnt) then
            dropEnt:SetPos(self:GetPos() + Vector(mRand(-10, 35), mRand(-10, 35), mRand(25, 55)))
            dropEnt:SetAngles(self:GetAngles())
            dropEnt:SetOwner(self)
            dropEnt:Spawn()
            dropEnt:Activate()
            self:DeleteOnRemove(dropEnt)
            local phys = dropEnt:GetPhysicsObject()
            if IsValid(phys) then
                local fwd, right = self:GetForward(), self:GetRight()
                phys:SetVelocity(fwd * rngVel + right * rngVel + Vector(0, 0, rngVel))
            end

            local inflict = dmginfo:GetInflictor()
            local dmgT = dmginfo:GetDamageType()

            if (bit.band(dmgT, DMG_DISSOLVE) ~= 0)
            or (IsValid(inflict) and inflict:GetClass() == "prop_combine_ball") then

                local dissolver = self:GetOrCreateDissolver()
                if IsValid(dissolver) then
                    local targetName = "vj_dissolve_" .. dropEnt:EntIndex()
                    dropEnt:SetName(targetName)

                    dissolver:SetKeyValue("target", targetName)
                    dissolver:SetKeyValue("dissolvetype", 0) 
                    dissolver:Fire("Dissolve", targetName, 0)
                end
                return;
            end
            if safeRemEntConv and safeRemEntConv == 1 then
                SafeRemoveEntityDelayed(dropEnt, mRand(20, 45))
            end 
        end
    end 
end 

ENT.HasBeenBurntToDeath = false 
ENT.Death_FireIgniteSndTbl = {"ambient/fire/gascan_ignite1.wav","ambient/fire/ignite.wav"}

ENT.DeathAnim_Running = {"deathrunning_01","deathrunning_03","deathrunning_04","deathrunning_05","deathrunning_06","deathrunning_07","deathrunning_08","deathrunning_09","deathrunning_10","deathrunning_11a","deathrunning_11b","deathrunning_11c","deathrunning_11d","deathrunning_11e","deathrunning_11f","deathrunning_11g"}
ENT.DeathAnim_Headshot = {"DIE_Headshot_FBack_01","DIE_Headshot_FBack_02","DIE_Headshot_FBack_03","DIE_Headshot_FFront_01","DIE_Headshot_FFront_02","DIE_Headshot_FFront_03","DIE_Headshot_FFront_04","DIE_Headshot_FFront_05"}
ENT.DeathAnim_Explosion = {"death_explosion_1","death_explosion_2","death_explosion_3","death_explosion_4","death_explosion_5","death_explosion_6"}
ENT.DeathAnim_Shock = {"electro_15","electrocuted_1","electrocuted_2","electrocuted_3","electrocuted_4","electrocuted_5"}
ENT.DeathAnim_Fire = {"fire_03","fire_04","fire_01","fire_02","pd2_death_fire_1_new","pd2_death_fire_2_new","pd2_death_fire_3_new"}
ENT.DeathAnim_BuckBack = {"die_shotgun_fback_01","die_shotgun_fback_02"}
ENT.DeathAnim_BuckFront = {"DIE_Shotgun_FFront_01","DIE_Shotgun_FFront_02","DIE_Shotgun_FFront_03","DIE_Shotgun_FFront_04","DIE_Shotgun_FFront_05","DIE_Shotgun_FFront_06","DIE_Shotgun_FFront_07","DIE_Shotgun_FFront_08","DIE_Shotgun_FFront_09"}
ENT.DeathAnim_BuckLeft = {"die_shotgun_fleft_01","die_shotgun_fleft_02","die_shotgun_fleft_03"}
ENT.DeathAnim_BuckRight = {"die_shotgun_fright_01"}
ENT.DeathAnim_Simple = {"die_simple_01","die_simple_02","die_simple_03","die_simple_04","die_simple_05","die_simple_06","die_simple_07","die_simple_08","die_simple_09","die_simple_10","die_simple_11","die_simple_12","die_simple_13","die_simple_14","die_simple_15","die_simple_16","die_simple_17","die_simple_18","die_simple_19","die_simple_20","die_simple_21","die_simple_22"}
ENT.DeathAnim_BurnedFireFx = {"embers_small_01","env_fire_small_base","fire_medium_heatwave","smoke_medium_01","smoke_medium_02"}

local function GetValDeathAnim(anim)
    if not anim or anim == "" or anim == false then return nil end 

    local selected;
    if istable(anim) then 
        local count = #anim
        if count == 0 then return nil end 
        selected = anim[mRng(count)]
    elseif isstring(anim) then 
        selected = anim 
    end
    if not isstring(selected) or selected == "" then return nil end

    if not string.StartWith(selected, "vjseq_") then
        selected = "vjseq_" .. selected
    end

    return selected
end

function ENT:DeahtAnimation_Handle(dmginfo, hitgroup)
    if not self.HasDeathAnimation or self.Head_HasBeenDecapitated or self.Shoved_Back_Now then return end 

    local deathConv = GetConVar("vj_stalker_death_anim")
    if not deathConv or deathConv:GetInt() ~= 1 then return end 

    local rngSnd = mRng(75, 105)
    local pcfxPoint = PATTACH_POINT_FOLLOW

    if not self:IsOnGround() or self:GetActivity() == ACT_COVER or (not self.HasBeenBurntToDeath and (self:IsVJAnimationLockState() or self:IsBusy())) then
        return
    end

    local atId = 0

    local myPos = self:GetPos()
    local moveDir = (self:GetCurWaypointPos() or myPos) - myPos
    moveDir:Normalize()
    local forwardDot = self:GetForward():Dot(moveDir)
    local isMovingForward = forwardDot > 0.5

    local headshotConv = GetConVar("vj_stalker_disable_headshot_death_anim")  
    local isHeadshot = self.Headshot_Death or (hitgroup == HITGROUP_HEAD)

    if self:IsMoving() and isMovingForward then
        if self:GetActivity() == ACT_RUN then
            self.AnimTbl_Death = GetValDeathAnim(self.DeathAnim_Running)
            self.DeathAnimationChance = 2

            if self.RANDOMS_DEBUG then print("Running Death Animation") end
            return;
        end
     
    elseif headshotConv:GetInt() ~= 1 and (self.CanPlayHeadshotDeahtAnim or isHeadshot) then
        self.AnimTbl_Death = GetValDeathAnim(self.DeathAnim_Headshot)
        if self.RANDOMS_DEBUG then print("Headshot Death Animation") end 
        return;

    elseif dmginfo:IsExplosionDamage() or dmginfo:IsDamageType(DMG_BLAST) then
        self.AnimTbl_Death = GetValDeathAnim(self.DeathAnim_Explosion)
        self.DeathAnimationChance = 2
        if self.RANDOMS_DEBUG then print("Explosion Death Animation") end 
        return;

    elseif dmginfo:IsDamageType(DMG_SHOCK) then
        self.AnimTbl_Death = GetValDeathAnim(self.DeathAnim_Shock)
        self.DeathAnimationChance = 2

        local firePartEf = "smoke_gib_01"
        local elePartEf = "electrical_arc_01_parent"
        for i = 1, mRng(2, 3) do 
            ParticleEffectAttach(firePartEf, pcfxPoint, self, atId)
        end 
        if self.RANDOMS_DEBUG then print("Shocked Death Animation") end 
        return;

    elseif self.HasBeenBurntToDeath then
        if self.RANDOMS_DEBUG then print("Burn to Death Animation") end 
        self.AnimTbl_Death = GetValDeathAnim(self.DeathAnim_Fire)

        local snd = self.Death_FireIgniteSndTbl
        local fireIgnite; 

        if snd and istable(snd) then 
            fireIgnite = table.Random(self.Death_FireIgniteSndTbl)
        end 

        local fireChance = tonumber(self.FireDeathFxChance) or 2
        if self.SpecialFireDeathFx and mRng(1, fireChance) == 1 and not isHeadshot then
            if snd and istable(snd) and #snd > 0 then 
                local fireIgnite = table.Random(snd)
                if fireIgnite then
                    VJ.EmitSound(self, fireIgnite, 70, rngSnd)
                end
            end
            local pcfxTbl = self.DeathAnim_BurnedFireFx
            if pcfxTbl and istable(pcfxTbl) and #pcfxTbl > 0 then
                for _, effect in ipairs(pcfxTbl) do 
                    if isstring(effect) and effect ~= "" then
                        ParticleEffectAttach(effect, pcfxPoint, self, atId) 
                    end
                end 
            end

            local function GetValAtt(ent)
                local commonAttachments = {"chest","forward","center","zipline","muzzle","beam_damage","trinket_lowerback"}
                for _, name in ipairs(commonAttachments) do local id = ent:LookupAttachment(name) if id and id > 0 then return name end end
                for i = 1, ent:GetNumAttachments() do local attach = ent:GetAttachment(i) if attach and attach.name then return attach.name end end
                return nil
            end

            local rngBright = mRng(1, 5)
            local rngDist = mRand(35, 80)
            local red = mRng(180, 255)
            local green = mRng(160, 200)

            self.FireLight = ents.Create("light_dynamic")
            if IsValid(self.FireLight) then
                self.FireLight:SetKeyValue("brightness", mRng(1, 5))
                self.FireLight:SetKeyValue("distance", mRand(35, 80))
                self.FireLight:SetLocalPos(self:GetPos())
                self.FireLight:SetLocalAngles(self:GetAngles())
                self.FireLight:Fire("Color", red .. " " .. green .. " 0")
                self.FireLight:SetParent(self)
                self.FireLight:Spawn()
                self.FireLight:Activate()
                
                local attachName = GetValAtt(self)
                if attachName then 
                    self.FireLight:Fire("SetParentAttachment", attachName) 
                end
                
                self.FireLight:Fire("TurnOn", "", 0)
                self:DeleteOnRemove(self.FireLight)
            end
        end
        return;

    elseif dmginfo:IsDamageType(DMG_BUCKSHOT) then

        local attacker = dmginfo:GetAttacker()
        if not IsValid(attacker) then attacker = dmginfo:GetInflictor() end

        if IsValid(attacker) and attacker:IsPlayer() then

            local playerAim = attacker:GetAimVector():GetNormalized()
            local snpcForward = self:GetForward()
            local snpcRight = self:GetRight()

            local dotForward = playerAim:Dot(snpcForward)
            local dotRight = playerAim:Dot(snpcRight)

            if dotForward > 0.5 then
                self.AnimTbl_Death = GetValDeathAnim(self.DeathAnim_BuckBack)
                self.DeathAnimationChance = 2
                if self.RANDOMS_DEBUG then print("Shotgun Death from Back") end 
                return;

            elseif dotForward < -0.5 then
                self.AnimTbl_Death = GetValDeathAnim(self.DeathAnim_BuckFront)
                self.DeathAnimationChance = 2
                if self.RANDOMS_DEBUG then print("Shotgun Death from Front") end
                return;

            elseif dotRight > 0.5 then
                self.AnimTbl_Death = GetValDeathAnim(self.DeathAnim_BuckLeft)
                self.DeathAnimationChance = 2
                if self.RANDOMS_DEBUG then print("Shotgun Death from Left") end
                return;

            elseif dotRight < -0.5 then
                self.AnimTbl_Death = GetValDeathAnim(self.DeathAnim_BuckRight)
                self.DeathAnimationChance = 2
                if self.RANDOMS_DEBUG then print("Shotgun Death from Right") end
                return;
            end
        end
    end
    self.DeathAnimationChance = 5
    self.AnimTbl_Death = GetValDeathAnim(self.DeathAnim_Simple) 
    if self.RANDOMS_DEBUG then print("Using fallback death animation") end
    return;
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ShovedBack(dmginfo)
    if not IsValid(self) then return end
    if not self.Shoved_Back then return end 

    local conv = GetConVar("vj_stalker_shovedback"):GetInt() 
    if not conv or conv ~= 1 then return end

    if self.VJ_IsBeingControlled then return end
    if self.StaggerOverride then return end

    local isDead = self:Health() <= 0 or not self:Alive()
    if isDead then return end

    local getAct = self:GetActivity()
    local badAacts = (getAct == ACT_FLINCH or getAct == ACT_SMALL_FLINCH or getAct == ACT_BIG_FLINCH or getAct == ACT_JUMP or getAct == ACT_LAND or getAct == ACT_GLIDE)
    local busy = self:IsBusy("Activities") or badAacts or self:IsVJAnimationLockState() or self:GetWeaponState() == VJ.WEP_STATE_RELOADING

    if self.Shoved_Back_Now or self:IsOnFire() or busy then return end
    if not self:IsOnGround() or isDead or self.PlayingWallHitAnim then return end

    local nextT = tonumber(self.Shoved_Back_NextT) or 0

    local cT = CurTime()
    if cT < nextT then return end

    local damageThreshold = mRng(5, 35)
    local damageForceThreshold = mRng(400, 1200)

    local dmgType = dmginfo:GetDamageType()
    local isExplosion = dmginfo:IsExplosionDamage()
    local isCommonDmg = dmginfo:IsBulletDamage() or dmgType == DMG_SLASH or dmgType == DMG_CLUB or dmgType == DMG_BUCKSHOT or dmgType == DMG_BULLET
    local allowExplosive = self.Shoved_Explosive_Active and isExplosion
    local allowCommon = self.Shoved_Com_Active and isCommonDmg

    local adjustedChance = self.ShovedBackChance

    local attacker = dmginfo:GetAttacker()
    if IsValid(attacker) and (attacker:IsNPC() or attacker:IsNextBot()) then
        adjustedChance = adjustedChance * 2 -- Allow the SNPCs to have a more fair fight with other enemy NPCs!
    end

    if self:Health() <= (self:GetMaxHealth() * 0.5) then
        adjustedChance = math.max(1, math_ceil(adjustedChance / 2))
    end

    adjustedChance = math.max(1, adjustedChance)

    if self.RANDOMS_DEBUG then 
        print("The chance for the SNPC to be shoved back = " .. adjustedChance)
    end 

    if mRng(1, adjustedChance) ~= 1 then return end

    local damageAmount = dmginfo:GetDamage()
    local damageForce = dmginfo:GetDamageForce():Length()

    if (damageAmount <= damageThreshold and damageForce <= damageForceThreshold) or not (allowExplosive or allowCommon) then return end

    local attacker = dmginfo:GetAttacker()
    if not IsValid(attacker) then return false end

    local myPos = self:GetPos()
    local attackerPos = attacker:GetPos()
    local dirToAttacker = (attackerPos - myPos):GetNormalized()
    local forward = self:GetForward()
    local right = self:GetRight()

    local dotF = dirToAttacker:Dot(forward)
    local dotR = dirToAttacker:Dot(right)

    local shoveAnimTbl = self.Shoved_Back_Anims
    local shoveDirection = "Back"

    if dotF > 0.5 then
        shoveAnimTbl = self.Shoved_Back_Anims
        shoveDirection = "Back"
    elseif dotF < -0.5 then
        shoveAnimTbl = self.Shoved_Front_Anims
        shoveDirection = "Front"
    elseif dotR > 0.5 then
        shoveAnimTbl = self.Shoved_Left_Anims
        shoveDirection = "Left"
    elseif dotR < -0.5 then
        shoveAnimTbl = self.Shoved_Right_Anims
        shoveDirection = "Right"
    end

    local selectedAnim = VJ.PICK(shoveAnimTbl)
    local seq = self:LookupSequence(selectedAnim)

    if not seq or seq == -1 then return end
    local shovedDur = self:SequenceDuration(seq)

    self.ShovedDir = shoveDirection 
    self.Shoved_Back_Now = true
    local tDel = mRand(0.1, 0.35)
    timer.Simple(tDel, function()
        if not IsValid(self) then return end

        local isNowDead = self:Health() <= 0 or not self:Alive()
        if isNowDead then 
            self.Shoved_Back_Now = false
            self.ShovedDir = nil
            return 
        end

        self:StopMoving()
        self:RemoveAllGestures()
        self.NextFlinchT = cT + mRand(5, 10)
        self:PlayAnim({ "vjseq_" .. selectedAnim }, true, shovedDur, false)
        self:SetState(VJ_STATE_ONLY_ANIMATION, shovedDur)
        self:StopAttacks(true)

        timer.Simple(shovedDur + 0.1, function()
            if IsValid(self) then
                self.Shoved_Back_Now = false
                self.Shoved_Back_NextT = cT + mRand(5, 15)
                self:SetState()
                self.ShovedDir = nil
            end
        end)
    end)
end

function ENT:HitWallWhenShoved()
    if not self.ShovedDir then return end 
    local conv = GetConVar("vj_stalker_shove_wall_collide")
    if not conv or conv:GetInt() ~= 1 then return end

    local isDead = self:Health() <= 0 or not self:Alive()
    local frwrd = self:GetForward()
    local right = self:GetRight()
    if self.CollideWall and not isDead then 

        local traceDir
        if self.ShovedDir == "Back" then traceDir = -frwrd
        elseif self.ShovedDir == "Front" then traceDir = frwrd
        elseif self.ShovedDir == "Left" then traceDir = -right
        elseif self.ShovedDir == "Right" then traceDir = right
        else return end

        local startPos = self:GetPos() + self:OBBCenter() - traceDir * 10
        local traceDist = 20

        local obbMin = self:OBBMins()
        local obbMax = self:OBBMaxs()
        local tr = util.TraceHull({
            start = startPos,
            endpos = startPos + traceDir * traceDist,
            mins = obbMin,
            maxs = obbMax,
            filter = self
        })

        if not tr.Hit then
            tr = util.TraceHull({
            start = startPos,
            endpos = startPos + traceDir * 6,
            mins = obbMin,
            maxs = obbMax,
            filter = self
            })
        end

        if tr.Hit and not self.PlayingWallHitAnim and not isDead then
            self.PlayingWallHitAnim = true
            self.StaggerOverride = true
            self.Shoved_Back_Now = false
            local ent = tr.Entity
            local isNpc = ent:IsNPC()
            local isNext = ent:IsNextBot()
            local isPly = ent:IsPlayer()
            local tre = isNpc or isNext or isPly
            if IsValid(ent) and ent:GetClass() == "prop_physics" then
                local phys = ent:GetPhysicsObject()
                if IsValid(phys) and phys:IsMoveable() and not ent:IsConstraint() then
                    local forceAmount = self.CollideWall_Frc or 2500 
                    if mRng(1, 2) == 1 then 
                        forceAmount = forceAmount * mRand(0.25, 2.5)
                    else
                        forceAmount = forceAmount 
                    end    
                    phys:ApplyForceOffset(traceDir * forceAmount, tr.HitPos)
                end
            end

            if tr.HitWorld or (IsValid(ent) and (tre or ent:GetClass() == "prop_physics")) then
                self.PlayingWallHitAnim = true
                self.StaggerOverride = true
                self.Shoved_Back_Now = false
                local wallAnimTbl = self.CollideWall_Back_Anim
                if self.ShovedDir == "Front" then wallAnimTbl = self.CollideWall_Front_Anim
                elseif self.ShovedDir == "Left" then wallAnimTbl = self.CollideWall_L_Anim
                elseif self.ShovedDir == "Right" then wallAnimTbl = self.CollideWall_R_Anim end

                local wallAnim = VJ.PICK(wallAnimTbl)
                local seq = self:LookupSequence(wallAnim)
                if not seq or seq == -1 then return end

                local dur = self:SequenceDuration(seq)
                self:StopMoving()
                self:RemoveAllGestures()
                self:PlayAnim({"vjseq_" .. wallAnim}, true, dur, false)
                self:SetState(VJ_STATE_ONLY_ANIMATION, dur)

                if mRng(1, 2) == 1 then 
                    self:PlaySoundSystem("Pain")
                end

                timer.Simple(dur + 0.01, function()
                    if IsValid(self) then
                        self.Shoved_Back_Now = false
                        self.Shoved_Back_NextT = CurTime() + mRand(5, 15)
                        self.PlayingWallHitAnim = false
                        self.ShovedDir = nil
                        self.StaggerOverride = false 
                    end
                end)
            end
        end
    end
end 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.React_FriFire = true 
ENT.React_FrIFire_AnimTbl = {"g_noway_big", "hg_nod_no", "g_fistshake"} -- shuold be gesutre
ENT.React_FrIFire_Chance = 3
ENT.React_FrIFire_NextT = 0 
function ENT:React_DmgFrPly(attacker, dmginfo)
    if not self.React_FriFire then return end
    if not IsValid(attacker) or not attacker:IsPlayer() then return end
    if self:IsVJAnimationLockState() then return end 
    if self.VJ_IsBeingControlled then return end
    if not self:Alive() then return end 
    local disps = (relation == D_LI or relation == D_NU)
    if IsValid(attacker) and attacker:IsPlayer() and not VJ_CVAR_IGNOREPLAYERS and disps then
            
        local cT = CurTime()
        if cT < (self.React_FrIFire_NextT or 0) then return end
        if self:IsBusy() then return end

        local ene = self:GetEnemy()
        if IsValid(ene) and self:Visible(ene) then return end

        if self._ReactFrFirePending then return end

        local chance = tonumber(self.React_FrIFire_Chance) or 5
        if mRng(1, chance) ~= 1 then return end 

        self._ReactFrFirePending = true
    
        if self:IsMoving() then self:StopMoving() end 
        self:RemoveAllGestures()

        local annoyedAnim = table.Random(self.React_FrIFire_AnimTbl)
        if not annoyedAnim then return end
        
        local delT = mRand(0.15, 0.95)
        timer.Simple(delT, function()
            if not IsValid(self) then return end 
            self._ReactFrFirePending = false
            local seqName = "vjges_" .. annoyedAnim
            self:PlayAnim(seqName, false)
            self:SetTurnTarget(attacker)
            self:SCHEDULE_FACE("TASK_FACE_TARGET")
            self.React_FrIFire_NextT = CurTime() + mRand(2, 10)
        end)
    end
end 
---------------------------------------------------------------------------------------------------------------------------------------------
    -- [Corpse wound graabbing] --
ENT.CorpseWndGrabbing = true 
ENT.CorpseWndGrab_MinT = 1
ENT.CorpseWndGrab_MaxT = 12 
ENT.CorpseWndGrabChance = mRng(5, 10)
ENT.CorpseWndGrabFrc = 100
ENT.CorpseWndGrabDelay = 0.1

    -- [Ex corpse phys] -- 
ENT.Ex_Crp_Phys = true 
ENT.Ex_Crp_Phys_Trq = true 
ENT.Ex_Crp_Phys_Trq_Chance = 3

    -- [Headshot corpse physics] --
ENT.HeadShot_PhysDownFrc = 400
ENT.HeadShot_PhysForwardFrc = 1000

    -- [Post mortem twitching] --
ENT.HasPostMortemTwitching = true 
ENT.CorpseTwitchChance = 10
ENT.CorpseTwitchReps = mRng(1, 15)
ENT.CorpseTwitchMinDelay = 0.05
ENT.CorpseTwitchMaxDelay = 1.5
ENT.CorpseTwitchForceMin = 50
ENT.CorpseTwitchForceMax = 250 
ENT.CorpseTwitchLifeMinT = 1
ENT.CorpseTwitchLifeMaxT = 15 

    -- [Death flatline] -- 
ENT.Flatline_DeathSnd = false  
ENT.Flatline_DeathChance = 2

    -- [RE5 corpse dissolving] --
ENT.Corpse_Dissolve = false
ENT.Corpse_DissolvePrt = {"blood_impact_red_01", "blood_impact_red_01_chunk"}
ENT.Corpse_DissolveSnd = {}
ENT.Corpse_DissolveMinT = 2.5
ENT.Corpse_DissolveMaxT = 10.5
ENT.Corpse_DissolveChance = 3
ENT.Corpse_DissolveMinRep = 15
ENT.Corpse_DissolvePrtRep = 25
ENT.Corpse_DissolvePrtMinT = 0.05
ENT.Corpse_DissolvePrtMaxT = 0.45 

    -- [Corpse dissolve inst] --
ENT.Inst_DissolveCorpse = false    
ENT.Inst_DissolveCorpseChance = 8
ENT.Corpse_DissolveType = false -- false = randomize, or set to 0–3 to choose a specific type

    -- [Corpse ele effects] --
ENT.Corpse_EleDeathEffects = false 
ENT.Corpse_EleDeathEffects_Chance = 8

ENT.Corpse_RngEyePos = true 
ENT.Corpse_RngEyePos_Chance = 2 

ENT.Corpse_RngEyeLids = true 
ENT.Corpse_RngEyeLids_Chance = 3

ENT.Corpse_RngFaceFlex = true 
ENT.Corpse_RngFaceFlex_Chance = 2
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Instant_DissolveCorpse(corpse)
    local dissolveChance = self.Inst_DissolveCorpseChance
    if mRng(1, dissolveChance) == 1 and self.Inst_DissolveCorpse and IsValid(corpse) then
        self:Dissolve_Crpseinst(corpse)
    end 
end 

function ENT:Delayed_DissolveAfterCorpse(corpse)
    local dissolveConv = GetConVar("vj_stalker_corpse_dissolve"):GetInt() 
    local dissChance = self.Corpse_DissolveChance or 4
    if dissolveConv ~= 1 then return end 
    if not self.Corpse_Dissolve then return end
    if not IsValid(corpse) then return end 
    if mRng(1, dissChance) != 1 then return end
    local delay = mRand(self.Corpse_DissolveMinT, self.Corpse_DissolveMaxT) or 5 
    
    local weaponEnt = IsValid(self.WeaponEntity) and self.WeaponEntity or nil
    local particleTable = self.Corpse_DissolvePrt or {}
    local minRep = self.Corpse_DissolveMinRep or 5
    local maxRep = self.Corpse_DissolvePrtRep or 15
    local prtMinT = self.Corpse_DissolvePrtMinT or 0.25
    local prtMaxT = self.Corpse_DissolvePrtMaxT or 0.95
    local particleDelay = delay * 0.5
    
    timer.Simple(particleDelay, function()
        if IsValid(corpse) and #particleTable > 0 then
            local validAttachments = {}
            for i = 1, 50 do 
                local attachment = corpse:GetAttachment(i)
                if attachment then
                    table.insert(validAttachments, i)
                end
            end
            
            if #validAttachments == 0 then 
                return 
            end
            
            local repetitions = mRng(minRep, maxRep)
            local function CreateParticleEffect(repCount)
                if not IsValid(corpse) or repCount <= 0 then return end
                for _, attachmentId in ipairs(validAttachments) do
                    local particleName = particleTable[mRng(1, #particleTable)]
                    local attachment = corpse:GetAttachment(attachmentId)
                    
                    if attachment then
                        ParticleEffect(particleName, attachment.Pos, attachment.Ang, corpse)
                    end
                end
                timer.Simple(mRand(prtMinT, prtMaxT), function()
                    CreateParticleEffect(repCount - 1)
                end)
            end
    
            CreateParticleEffect(repetitions)
        end
    end)
    
    timer.Simple(delay, function()
        if IsValid(corpse) then
            corpse:SetName("vj_dissolve_corpse")
            local dissolver = ents.Create("env_entity_dissolver")
            if IsValid(dissolver) then
                dissolver:Spawn()
                dissolver:Activate()
                dissolver:SetKeyValue("magnitude", mRng(25,125))
                dissolver:SetKeyValue("dissolvetype", mRng(0, 3))
                dissolver:Fire("Dissolve", "vj_dissolve_corpse")
                
                if IsValid(weaponEnt) then
                    weaponEnt:Dissolve(0, 1)
                end
                
                dissolver:Fire("Kill", "", 0.1)
            end
        end
    end)
end

function ENT:PlyFlatlineOnDeath(corpse)
    if not self.Flatline_DeathSnd then return end 

    local conv = GetConVar("vj_stalker_flatline"):GetInt()
    if conv ~= 1 then return end 
    if not IsValid(corpse) then return end

    local chance = tonumber(self.Flatline_DeathChance) or 3 
    if mRng(1, chance) ~= 1 then return end

    local flatSnd = self.Flatline_DeathTbl

    if flatSnd and #flatSnd > 0 then
        local flat;

        if istable(flatSnd) then
            flat = table.Random(flatSnd)
        else
            flat = flatSnd
        end

        local delay = mRand(0.01, 0.05)
        local volume = mRand(0.75, 0.9)
        local pitch = mRng(75, 115)

        timer.Simple(delay, function()
            if not IsValid(corpse) then return end
            if corpse.FlatlinePlaying then return end

            corpse.FlatlinePlaying = true

            local snd = CreateSound(corpse, flatlineSnd)
            if snd then
                snd:PlayEx(volume, pitch)

                local id = "StopFlatlineSnd_" .. corpse:EntIndex()
                corpse:CallOnRemove(id, function()
                    if snd then snd:Stop() end
                    corpse.FlatlinePlaying = nil
                end)
            end
        end)
    end 
end

function ENT:Instant_DissolveCorpse(corpse)
    local dissolveChance = tonumber(self.Inst_DissolveCorpseChance) or 10 
    if mRng(1, dissolveChance) == 1 and self.Inst_DissolveCorpse and IsValid(corpse) then
        self:Dissolve_Crpseinst(corpse)
    end 
end 

function ENT:Dissolve_Crpseinst(corpse)
    if not IsValid(corpse) then return end
    corpse:SetName("vj_dissolve_corpse_" .. corpse:EntIndex())
    local dissolver = self:GetOrCreateDissolver()
    local magnitude = mRand(50, 150)
    if not IsValid(dissolver) then return end
    dissolver:SetKeyValue("magnitude", magnitude)
    local dissolveType
    if self.Corpse_DissolveType ~= false and isnumber(self.Corpse_DissolveType) then
        dissolveType = math_Clamp(self.Corpse_DissolveType, 0, 3)
    else
        dissolveType = mRng(0, 3)
    end
    dissolver:SetKeyValue("dissolvetype", dissolveType)
    dissolver:Fire("Dissolve", corpse:GetName())
    if IsValid(self.WeaponEntity) then
        self.WeaponEntity:Dissolve(0, 1)
    end
end

function ENT:GetOrCreateDissolver()
    if not IsValid(self._CachedDissolver) then
        local dissolver = ents.Create("env_entity_dissolver")
        if IsValid(dissolver) then
            dissolver:Spawn()
            dissolver:Activate()
            dissolver:Fire("Kill", "", 10) 
            self._CachedDissolver = dissolver
        end
    end
    return self._CachedDissolver
end

function ENT:Ele_CorpseDeathEffects(corpse)
    if not IsValid(corpse) then return end 
    if not self.Corpse_EleDeathEffects then return end 
    if self:WaterLevel() > 3 then return end  

    local conv = GetConVar("vj_stalker_ele_death_fx")
    if conv:GetInt() ~= 1 then return end 

    local sparkChance = self.Corpse_EleDeathEffects_Chance or 8 
    local snd = self:GetRandomValidValue(self.EnergyZap_Tbl) 
    if mRng(1, sparkChance) == 1 then
        local duration = mRand(1, 15) or 10 
        local interval = mRand(0.05, 0.95) or 0.5
        local repetitions = duration / interval 
        local timerName = "ElectricityEffects_" .. corpse:EntIndex() .. "_" .. CurTime()
        timer.Create(timerName, interval, repetitions, function()
            if not IsValid(corpse) then timer.Remove(timerName) return end

            if snd then  
                corpse:EmitSound(snd, mRng(65, 85), mRng(75, 105)) 
            end 

            local pos = corpse:GetPos()
            local start = corpse:GetPos()

            local DeathSparkeffect2 = EffectData()
            DeathSparkeffect2:SetOrigin(pos)
            DeathSparkeffect2:SetStart(start)
            DeathSparkeffect2:SetMagnitude(mRand(50, 90)) 
            DeathSparkeffect2:SetEntity(corpse)

            local DeathSparkeffect1 = EffectData()
            DeathSparkeffect1:SetOrigin(pos)
            DeathSparkeffect1:SetStart(start)
            DeathSparkeffect1:SetMagnitude(mRng(5, 15)) 
            DeathSparkeffect1:SetEntity(corpse)

            local DeathSparkeffect = ents.Create("spark_shower")
            DeathSparkeffect:SetAngles(Angle(0, mRng(-180, 180), 0))
            DeathSparkeffect:SetPos(start)
            DeathSparkeffect:Spawn()
            DeathSparkeffect:Activate()

            local eleDeathFx = EffectData()
            eleDeathFx:SetOrigin(pos)
            eleDeathFx:SetStart(start)
            eleDeathFx:SetEntity(corpse)

            util.Effect("cball_explode", eleDeathFx)
            util.Effect("ManhackSparks", eleDeathFx)
            util.Effect("teslaHitBoxes", DeathSparkeffect2)
            util.Effect("StunstickImpact", DeathSparkeffect1)
        end)
    end
end

function ENT:ManipulateCorpseFingers(corpse)
    if not self.DeathFingerBoneManipuation then return end
    local conv = GetConVar("vj_stalker_death_finger_manip"):GetInt() 
    if not conv or conv ~= 1 then return end 
    local manChance = self.ManipulateFingBoneChance or 4 
    if mRng(1, manChance) == 1 then return end

    local fingerPrefix = {"ValveBiped.Bip01_L_Finger", "ValveBiped.Bip01_R_Finger"}
    for _, prefix in ipairs(fingerPrefix) do
        for i = 0, 4 do
            local isThumb = (i == 0)
            local curlAmount = isThumb and mRand(0.1, 0.4) or mRand(0.15, 1.1)

            for j = 0, 2 do
                local boneName = prefix .. i .. (j > 0 and tostring(j) or "")
                local boneID = corpse:LookupBone(boneName)
                if boneID and boneID >= 0 then
                    local ang
                    if isThumb then
                        ang = Angle(
                            mRand(-5, -30) * curlAmount,
                            mRand(5, 30) * curlAmount * (mRng(0,1) == 1 and 1 or -1),
                            mRand(-15, 30)
                        )
                    else
                        ang = Angle(
                            mRand(-25, 25),
                            mRand(-5, -50) * curlAmount + mRand(-5, 5),
                            mRand(-15, 35)
                        )
                    end
                    corpse:ManipulateBoneAngles(boneID, ang)
                end
            end
        end
    end
end

function ENT:ApplyCorpseTwitching(corpse)
    if not self.HasPostMortemTwitching then return end 

    local twitchConv = GetConVar("vj_stalker_body_twitching"):GetInt()
    if twitchConv ~= 1 then return end 
    if self.DC_Writhing then return end 
    if corpse:IsOnFire() then return end 

    local twChance   = tonumber(self.CorpseTwitchChance) or 5 
    local twitchReps = tonumber(self.CorpseTwitchReps) or 3 
    local minDelay   = tonumber(self.CorpseTwitchMinDelay) or 0.2
    local maxDelay   = tonumber(self.CorpseTwitchMaxDelay) or 0.6
    local forceMin   = tonumber(self.CorpseTwitchForceMin) or 150
    local forceMax   = tonumber(self.CorpseTwitchForceMax) or 600
    local minLife    = tonumber(self.CorpseTwitchLifeMinT) or 1
    local maxLife    = tonumber(self.CorpseTwitchLifeMaxT) or 10

    local vecRand    = VectorRand()
    local twitchType = mRng(1, 2)
    local totalLife  = mRand(minLife, maxLife)

    if mRng(1, twChance) ~= 1 then return end

    timer.Simple(totalLife, function()
        if not IsValid(corpse) then return end

        local physCount = corpse:GetPhysicsObjectCount()
        if physCount <= 0 then return end

        local obbCenter = corpse:OBBCenter()
        local timerName = "Twitch_" .. corpse:EntIndex()

        timer.Create(timerName, mRand(minDelay, maxDelay), twitchReps, function()
            if not IsValid(corpse) then 
                timer.Remove(timerName)
                return 
            end

            if twitchType == 1 then
                local phys = corpse:GetPhysicsObjectNum(mRng(0, physCount - 1))
                if IsValid(phys) then
                    local randVec = vecRand
                    local twitchForce = randVec * mRand(forceMin, forceMax)
                    phys:ApplyForceOffset(twitchForce, corpse:GetPos())
                end

            elseif twitchType == 2 then
                local limited = (mRng(1, 4) == 1)
                local boneCount

                if limited then
                    boneCount = math.Clamp(math_floor(physCount / 5), 1, physCount)
                else
                    boneCount = mRng(2, physCount)
                end

                local fullTwitch = (mRng(1, 10) == 1)

                if self.LastDamageType and bit.band(self.LastDamageType, DMG_SHOCK) ~= 0 then
                    boneCount = physCount
                elseif fullTwitch then
                    boneCount = physCount
                else
                    boneCount = math.min(boneCount, 8)
                end

                local used = {}
                local offRng = mRand(1, 20)

                for i = 1, boneCount do
                    local id = mRng(0, physCount - 1)
                    if not used[id] then
                        used[id] = true

                        local phys = corpse:GetPhysicsObjectNum(id)
                        if IsValid(phys) then
                            local randVec = vecRand
                            local randOffset = vecRand
                            local forceScale = mRand(0.2, 0.7)

                            if boneCount == physCount then
                                forceScale = forceScale * 1.5
                            end

                            local twitchForce = randVec * mRand(forceMin * forceScale, forceMax)
                            local offset = corpse:LocalToWorld(obbCenter + randOffset * offRng)
                            phys:ApplyForceOffset(twitchForce, offset)
                        end
                    end
                end
            end

            if self.RANDOMS_DEBUG then 
                print("(Corpse Twitching) Twitch type == : " .. twitchType)
            end
        end)
    end)
end

function ENT:ApplyCorpseRoll(corpse, duration, interval)
    if not self.DC_Writhe then return end 
    if not IsValid(corpse) then return end

    local conv = GetConVar("vj_stalker_body_writhe"):GetInt()
    if not conv or conv ~= 1 then return end

    local isHeadshot = self.Headshot_Death or (hitgroup == HITGROUP_HEAD)
    if self.Headshot_Death or isHeadshot then return end

    if self:WaterLevel() > 3 then return end 

    local chance = tonumber(self.DC_Writhe_Chance) or 10 
    if corpse:IsOnFire() then chance = chance / 2 end 
    
    local minT = tonumber(self.DC_Writhe_MinT) or 5 
    local maxT = tonumber(self.DC_Writhe_MaxT) or 15 
    local decThresh = tonumber(self.DC_Writh_Decay_Thresh) or 0.20
    local trDist = tonumber(self.DC_Writhe_TraceDist) or 40 
    local useAllBones = self.DC_Writhe_UseAllBones or false 
        local spineBones = {
            "ValveBiped.Bip01_Spine","ValveBiped.Bip01_Spine1",
            "ValveBiped.Bip01_Spine2","ValveBiped.Bip01_Spine4",
            "ValveBiped.Bip01_Pelvis","ValveBiped.Bip01_L_Calf",
            "ValveBiped.Bip01_R_Calf","ValveBiped.Bip01_Neck1",
            "ValveBiped.Bip01_R_Head1"
        }

    local decayConv = GetConVar("vj_stalker_body_writhe_decay")
    local allBoneConv = GetConVar("vj_stalker_body_writhe_useallbones")

    if not self.DC_Writhing then  
        if mRng(1, chance) == 1 then 
            self.DC_Writhing = true 
            duration = duration or mRand(minT, maxT)
            interval = interval or 0.01
            local repeats = math_floor(duration / interval)
            local timerName = "CorpseRoll_" .. corpse:EntIndex()
            local i = 0
            local nextFlip = 0 
            local rollDirection = 1 

            local function CheckObstructions()
                if not IsValid(corpse) then return false, false end

                local startPos = corpse:GetPos() + Vector(0, 0, 10)
                local rightDir = corpse:GetRight()

                local filterTbl = {corpse}

                local function doTrace(dir)
                    return util.TraceHull({
                        start = startPos,
                        endpos = startPos + dir * trDist,
                        mins = Vector(-8, -8, -8),
                        maxs = Vector(8, 8, 8),
                        filter = filterTbl
                    })
                end

                local trRight = doTrace(rightDir)
                local trLeft = doTrace(-rightDir)

                return trLeft.Hit, trRight.Hit
            end

            timer.Create(timerName, interval, repeats, function()
                if not IsValid(corpse) then 
                    if IsValid(self) then self.DC_Writhing = false end
                    timer.Remove(timerName) 
                    return 
                end

                i = i + 1
                local curTime = CurTime()
        
                if curTime > nextFlip then
                    local leftBlocked, rightBlocked = CheckObstructions()
                    if leftBlocked and rightBlocked then
                        self.DC_Writhing = false
                        timer.Remove(timerName)
                        return
                    elseif (rollDirection == -1 and leftBlocked) or (rollDirection == 1 and rightBlocked) then
                        rollDirection = rollDirection * -1
                        nextFlip = curTime + 0.5 
                    elseif mRng() < 0.01 then 
                        rollDirection = rollDirection * -1
                        nextFlip = curTime + 0.3
                    end
                end

                local decayFactor = 1
                if self.DC_Writh_Decay and (decayConv and decayConv:GetInt() == 1) then
                    local progress = i / repeats 
                    if progress >= (1 - decThresh) then
                        local decayProgress = (progress - (1 - decThresh)) / decThresh
                        decayFactor = 1 - math_Clamp(decayProgress, 0, 1)
                    end 
                end

                local rollForce = corpse:GetRight() * mRand(10, 55) * rollDirection * decayFactor
                local forwardForce = corpse:GetForward() * mRand(1, 25) * decayFactor
                local angVel = corpse:GetForward() * mRand(10, 85) * rollDirection * decayFactor
                local maxVel = mRand(30, 90)
                local afcConv = GetConVar("vj_stalker_body_writhe_afc")

                if useAllBones and (allBoneConv and allBoneConv:GetInt() == 1) then
                    for boneID = 0, (corpse:GetBoneCount() - 1) do
                        local bName = corpse:GetBoneName(boneID)
                        if string.find(bName, "Arm") or string.find(bName, "Hand") or string.find(bName, "Finger") then
                            continue 
                        end
                        local physID = corpse:TranslateBoneToPhysBone(boneID)
                        if physID and physID >= 0 then
                            local phys = corpse:GetPhysicsObjectNum(physID)
                            if IsValid(phys) then

                                local vel = phys:GetVelocity()
                                if vel:Length() > maxVel then
                                    phys:SetVelocity(vel:GetNormalized() * maxVel)
                                end

                                local angDiv = mRng(3, 5)
                                local torqueDiv = mRng(3, 5)
                                    
                                phys:AddAngleVelocity(angVel / angDiv)
                                phys:ApplyTorqueCenter((rollForce * mRand(0.85, 1.25)) / torqueDiv)
                                    
                                if self.DC_Writhe_AFC and (afcConv and afcConv:GetInt() == 1) then
                                    local combinedForce = (rollForce + forwardForce)
                                    phys:ApplyForceCenter(Vector(math_ceil(combinedForce.x), math_ceil(combinedForce.y), math_ceil(combinedForce.z))) 
                                end
                            end
                        end
                    end 
                else
                    for _, boneName in ipairs(spineBones) do
                        local boneID = corpse:LookupBone(boneName)
                        if boneID then
                            local physID = corpse:TranslateBoneToPhysBone(boneID)
                            local phys = corpse:GetPhysicsObjectNum(physID)
                            if IsValid(phys) then

                                local vel = phys:GetVelocity()
                                if vel:Length() > maxVel then
                                    phys:SetVelocity(vel:GetNormalized() * maxVel)
                                end

                                local angDiv = mRng(1, 3) 
                                phys:AddAngleVelocity(Vector(math_ceil(angVel.x / angDiv), math_ceil(angVel.y / angDiv), math_ceil(angVel.z / angDiv)))
                                phys:ApplyTorqueCenter(rollForce * mRand(0.85, 1.25))
                                
                                if self.DC_Writhe_AFC and (afcConv and afcConv:GetInt() == 1) then                            
                                    local combinedForce = (rollForce + forwardForce)
                                    phys:ApplyForceCenter(Vector(math_floor(combinedForce.x), math_floor(combinedForce.y), math_floor(combinedForce.z)))
                                end
                            end
                        end
                    end
                end

                if i >= repeats then
                    self.DC_Writhing = false
                end
            end)
        end
    end
end

function ENT:RngDeathEyePos(body)
    if not self.Corpse_RngEyePos then return end 
    local eyePosConv = GetConVar("vj_stalker_corpse_rng_eyepos"):GetInt()
    if eyePosConv ~= 1 then return end 
    if not IsValid(body) then return end
    local chance = tonumber(self.Corpse_RngEyePos_Chance) or 3
    if mRng(1, chance) ~= 1 then return end
    local side = mRand(-0.65, 0.65)
    local upDown = mRand(-1.2, 1.2) 
    local dist = mRand(12, 28)
    local offset = Vector(side * dist,mRand(-0.5, 0.5) * dist,upDown * dist)
    body:SetEyeTarget(body:GetPos() + offset)
end

function ENT:RngDeathEyelids(body)
    if not self.Corpse_RngEyeLids then return end 
    local eyeLidConv = GetConVar("vj_stalker_corpse_rng_eyelids"):GetInt()
    if eyeLidConv ~= 1 then return end 
    if not IsValid(body) then return end
    local chance = tonumber(self.Corpse_RngEyeLids_Chance) or 2
    if mRng(1, chance) ~= 1 then return end
    local flexCount = body:GetFlexNum()
    if not flexCount or flexCount <= 0 then return end
    local closeAmount = mRand(0.55, 1.2)
    if mRng(1, 33) == 1 then
        closeAmount = mRand(0.25, 0.6)
    end
    for i = 0, flexCount - 1 do
        local name = string.lower(body:GetFlexName(i) or "")
        if name:find("lid") or name:find("blink") or name:find("eyeclose") then
            body:SetFlexWeight(i, closeAmount)
        end
    end
end

function ENT:RngFaceFlexPos(body)
    local faceFlexConv = GetConVar("vj_stalker_corpse_rng_faceflex"):GetInt()
    if faceFlexConv ~= 1 then return end 
    if not IsValid(body) or not self.Corpse_RngFaceFlex then return end
    local chance = tonumber(self.Corpse_RngFaceFlex_Chance) or 3
    if mRng(1, chance) ~= 1 then return end
    local flexCount = body:GetFlexNum()
    if not flexCount or flexCount <= 0 then return end
    local affectCount = math.max(1, math_floor(flexCount * mRand(0.15, 0.35)))
    for _ = 1, affectCount do
        local i = mRng(0, flexCount - 1)
        local weight = mRand(0.05, 0.45)
        if mRng(1, 3) == 1 then
            weight = mRand(0.3, 0.6)
        end
        body:SetFlexWeight(i, weight)
    end
end

function ENT:Corpse_GrabRngWound(corpse)
    if not self.CorpseWndGrabbing then return end 

    local conv = GetConVar("vj_stalker_death_wound_grabbing"):GetInt()
    if conv ~= 1 then return end 
    if self.Headshot_Death then return end 
    if not IsValid(corpse) then return end 

    if corpse:IsOnFire() then return end 
    if self:WaterLevel() > 3 then return end 

    local delayT = tonumber(self.CorpseWndGrabDelay) or 0.25
    local grabChance = tonumber(self.CorpseWndGrabChance) or 10 

    if mRng(1, grabChance) ~= 1 then return end

    timer.Simple(delayT, function()
        if not IsValid(corpse) then return end

        local woundTargets = {
            "ValveBiped.Bip01_Spine4",
            "ValveBiped.Bip01_Spine2",
            "ValveBiped.Bip01_Spine1",
            "ValveBiped.Bip01_Spine",
            "ValveBiped.Bip01_Head1",
            "ValveBiped.Bip01_L_Calf",
            "ValveBiped.Bip01_R_Calf",
            "ValveBiped.Bip01_Pelvis",
        }

        local offsetLookup = {
            ["ValveBiped.Bip01_Spine"]   = Vector(0, 0, mRand(15, 20)),
            ["ValveBiped.Bip01_Spine1"]  = Vector(0, 0, mRand(15, 20)),
            ["ValveBiped.Bip01_Spine2"]  = Vector(0, 0, mRand(15, 20)),
            ["ValveBiped.Bip01_Spine4"]  = Vector(0, 0, mRand(15, 20)),
            ["ValveBiped.Bip01_Head1"]   = Vector(0, 0, mRand(1, 5)),
            ["ValveBiped.Bip01_Pelvis"]  = Vector(0, 0, mRand(10, 15)),
            ["ValveBiped.Bip01_L_Calf"]  = Vector(0, 0, mRand(5, 7)),
            ["ValveBiped.Bip01_R_Calf"]  = Vector(0, 0, mRand(5, 7)),
        }

        local boneName = table.Random(woundTargets)
        local targetBone = corpse:LookupBone(boneName)
        if not targetBone then return end

        local grabOffset = offsetLookup[boneName] or Vector(0, 0, 6)

        local handMode = mRng(1, 3)
        local hands = {}

        if handMode ~= 2 then
            table.insert(hands, corpse:LookupBone("ValveBiped.Bip01_L_Hand"))
        end
        if handMode ~= 1 then
            table.insert(hands, corpse:LookupBone("ValveBiped.Bip01_R_Hand"))
        end

        local minT = tonumber(self.CorpseWndGrab_MinT) or 1 
        local maxT = tonumber(self.CorpseWndGrab_MaxT) or 10 
        local timerName = "CorpseWoundGrab_" .. corpse:EntIndex()
        local totalDuration = mRand(minT, maxT) or 5 
        local interval = 0.02
        local repeats = math_floor(totalDuration / interval)

        local forceBase = self.CorpseWndGrabFrc or 120
        local smoothedTarget = corpse:GetBonePosition(targetBone)

        timer.Create(timerName, interval, repeats, function()
            if not IsValid(corpse) then timer.Remove(timerName) return end

            local bonePos = corpse:GetBonePosition(targetBone)
            
            local center = corpse:WorldSpaceCenter()
            local outwardDir = (bonePos - center):GetNormalized()
            local outwardOffset = outwardDir * mRand(6, 12)
            local rawTarget = bonePos + outwardOffset + Vector(mRand(-1.5, 1.5), mRand(-1.5, 1.5), mRand(0, 2))

            smoothedTarget = LerpVector(0.15, smoothedTarget, rawTarget)

            for _, handBone in ipairs(hands) do
                if not handBone then continue end

                local physID = corpse:TranslateBoneToPhysBone(handBone)
                local phys = corpse:GetPhysicsObjectNum(physID or 0)
                if not IsValid(phys) then continue end

                phys:Wake()

                local handPos = corpse:GetBonePosition(handBone)
                local dist = handPos:Distance(smoothedTarget)
                local forceMul = math_Clamp(dist / 30, 0, 1)
                local force = forceBase * forceMul
                if dist < 6 then force = 0 end
                local dir = (smoothedTarget - handPos):GetNormalized()
                local vel = phys:GetVelocity()
                phys:SetVelocity(vel * 0.6)
                phys:AddVelocity(dir * force)
            end
        end)
    end)
end

function ENT:Corpse_ExtraPhysics(dmginfo, hitgroup, corpse)
    if not self.ApplyHeadshotDeathPhys then return end 
    if not IsValid(corpse) then return end 
    
    local exPhysConv = GetConVar("vj_stalker_death_ex_crpse_phys"):GetInt()
    if exPhysConv ~= 1 then return end 

    if self.IsCurrentlyIncapacitated then return end 
    if self.HasBeenBurntToDeath then return end 
    if self:WaterLevel() > 3 then return end 
    
    local appliedCustomPhysics = false

    local dmgForce = vector_origin
    local dmgType = 0

    if dmginfo ~= nil then
        local okForce, force = pcall(function() return dmginfo:GetDamageForce() end)
        if okForce and force then
            dmgForce = force
        end

        local okType, dtype = pcall(function() return dmginfo:GetDamageType() end)
        if okType and dtype then
            dmgType = dtype
        end
    end

    local function ManipulateCorpseMass(phys)
        if not IsValid(phys) then return end
        local baseMass = phys:GetMass()

        if baseMass < 100 then
            phys:SetMass(100)
            baseMass = 100
        end

        local mult = mRand(0.5, 1.95)
        local bonus = mRng(75, 150)
        if mRng(1, 2) == 1 and bonus then 
            bonus = math_ceil(bonus * 2 / mRng(1, 3))  
        end 

        if self.IsHeavilyArmored then 
            bonus = bonus + mRng(150, 250)
        end 

        local newMass = math_floor(baseMass * mult + bonus)
        phys:SetMass(newMass)
    end

    local isBlastDamage = bit.band(dmgType, DMG_BLAST) ~= 0

    if isBlastDamage then
        appliedCustomPhysics = true

        local blastMultiplier = 1.5

        if mRng(1, 3) == 1 then
            blastMultiplier = mRng(3, 6)
        end

        local blastForce = dmgForce
        if blastForce == vector_origin then
            blastForce = VectorRand() * mRand(500, 2500)
        end

        blastForce = blastForce * blastMultiplier

        local upwardForce = Vector(0, 0, mRand(150, 900))

        for i = 0, corpse:GetPhysicsObjectCount() - 1 do
            local phys = corpse:GetPhysicsObjectNum(i)
            if IsValid(phys) then
                ManipulateCorpseMass(phys)
                phys:Wake()
                local damp = mRand(0.01, 0.08)
                phys:SetDamping(damp, damp)
                if mRng(1, 2) == 1 then
                    phys:SetVelocity(vector_origin)
                end
                local finalForce = blastForce + upwardForce + (VectorRand() * mRand(25, 300))
                phys:ApplyForceCenter(finalForce)
                if mRng(1, 2) == 1 then
                    phys:AddAngleVelocity(VectorRand() * mRng(250, 1800))
                end
                if mRng(1, 3) == 1 then
                    phys:ApplyTorqueCenter(VectorRand() * mRand(150, 650))
                end
            end
        end 
    end

    if not appliedCustomPhysics and self.Headshot_Death then
        local downForce = Vector(0, 0, self.HeadShot_PhysDownFrc or 200)
        local rngForBackForce = mRng(self.HeadShot_PhysForwardFrc, 1000) or mRand(-50, 300) 

        local dir = self:GetForward()

        if mRng(1, 2) == 1 then
            dir = -dir
        end

        if mRng(1, 2) == 1 then 
            downForce.z = math.min(350, math_floor(downForce.z * mRng(1.5, 5.5))) or 600

            if self.RANDOMS_DEBUG then
                print("[Headshot Ext-Physics] Altered Z down force is " .. downForce.z .. " compared to " .. tonumber(-self.HeadShot_PhysDownFrc))
            end 
        end

        downForce = -downForce

        local strength = rngForBackForce
        local pullForce = dir * strength

        local rngDir = VectorRand():GetNormalized()
        local rngSpeed = Vector(0, 0, mRand(250, 450))
        local rngAngVel = rngDir * rngSpeed

        local defLinDamp = 0.01
        local defAngDamp = defLinDamp 
        
        if mRng(1, 3) == 1 then 
            pullForce = pullForce + Vector(0, 0, mRand(-150, -750))
        end 
        if self.RANDOMS_DEBUG then
            print("[Headshot Ext-Physics] Force phys speed is " .. tonumber(rngSpeed.z))
        end 

        for i = 0, corpse:GetPhysicsObjectCount() - 1 do
            local phys = corpse:GetPhysicsObjectNum(i)
            if IsValid(phys) then
                ManipulateCorpseMass(phys)
                if mRng(1, 2) == 1 then
                    phys:ApplyForceCenter(pullForce)
                end 
                phys:ApplyForceCenter(downForce)
                phys:SetDamping(defLinDamp, defAngDamp)
                phys:Wake()
                if mRng(1, 2) == 1 then
                    phys:AddAngleVelocity(rngAngVel)
                end 
            end
        end

        if mRng(1, 2) == 1 then 
            local headBone = corpse:LookupBone("ValveBiped.Bip01_Head1")
            local neckBone = corpse:LookupBone("ValveBiped.Bip01_Neck1")

            local function ApplyBoneForce(boneID)
                if not boneID then return end
                local physID = corpse:TranslateBoneToPhysBone(boneID)
                if physID and physID >= 0 then
                    local phys = corpse:GetPhysicsObjectNum(physID)
                    if IsValid(phys) then
                        if self.RANDOMS_DEBUG then
                            print("Force has been applied to head bones")
                        end 
                        local headForce = dmgForce * mRand(0.25, 1.05)
                        phys:ApplyForceCenter(headForce + VectorRand() * mRand(5, 10)) 
                        phys:AddAngleVelocity(VectorRand() * mRng(5, 15))
                        phys:Wake()
                    end
                end
            end
            ApplyBoneForce(headBone)
            ApplyBoneForce(neckBone)
        end 
        appliedCustomPhysics = true
    end
    
    if not appliedCustomPhysics then
        if self.Ex_Crp_Phys and not self.IsCurrentlyIncapacitated then
            local useDirectional = mRng(1, 4) == 1
            for i = 0, corpse:GetPhysicsObjectCount() - 1 do
                local phys = corpse:GetPhysicsObjectNum(i)

                local dampVal 
                local choices = mRng(1, 5)

                if choices == 1 then 
                    dampVal = mRand(0.01, 0.1)
                elseif choices == 2 then 
                    dampVal = 0.05
                elseif choices == 3 then 
                    dampVal = 0.01
                elseif choices == 4 then 
                    dampVal = mRng(1, 4)
                else 
                    dampVal = mRand(0.15, 0.7)
                end 

                local hsLinDamp = dampVal
                local hsAngDamp = hsLinDamp
                local vR = VectorRand()

                if IsValid(phys) then
                    ManipulateCorpseMass(phys)
                    phys:Wake()
                    phys:SetDamping(hsLinDamp, hsAngDamp)
                    if mRng(1, 2) == 1 then
                        phys:SetVelocity(vector_origin)
                    end 

                    local vel;
                    if useDirectional and dmgForce ~= vector_origin then
                        vel = dmgForce:GetNormalized() * mRand(150, 1059)
                    else
                        vel = vR * math_ceil(mRand(100, 1500) * mRng(0.25, 1.25))
                    end
                    if mRng(1, 2) == 1 then
                        phys:ApplyForceCenter(vel)
                    end 

                    local rngVelEnhance = mRand(0.5, 2)
                    local rngAng = vR * mRng(1, 2753)
                    local rngTrq = vR * mRand(50, 250)
            
                    if mRng(1, 3) == 1 then
                        phys:AddAngleVelocity(rngAng * rngVelEnhance)
                    end 
                    local chance = tonumber(self.Ex_Crp_Phys_Trq_Chance) or 2 
                    if self.Ex_Crp_Phys_Trq and mRng(1, chance) == 1 then 
                        local final = rngTrq * mRand(0.25, 1.15)
                        phys:ApplyTorqueCenter(final) 
                    end 
                end
            end 
        end
    end
end

function ENT:Handle_HeadDecapitation(dmginfo, corpse)
    if not self.Head_HasBeenDecapitated then return end 
    if not IsValid(corpse) then return end 
    local hBone = self:LookupBone(tostring(self.Head_DecapBones["Head"]))
    if hBone then 
        corpse:ManipulateBoneScale(hBone, Vector(0, 0, 0)) 
                
        local nBone = self:LookupBone(tostring(self.Head_DecapBones["Neck"]))
        if nBone then
            corpse:ManipulateBonePosition(nBone, Vector(-0.3, 0, 0))
        end
    end
end 

function ENT:Handle_ExpensiveDecapPcfx(dmginfo, corpse)
    local target = IsValid(corpse) and corpse or self
    if not IsValid(target) then return end
    if not self.Head_HasBeenDecapitated then return end

    local cheap = GetConVar("vj_stalker_headshot_low_effects"):GetInt()
    if cheap and cheap == 1 then return end 


    local attName = "head" -- Fallback
    local attTbl = self.HeadshotDeathAttTbl or {"head", "mouth", "neck"}
    local attIndex = -1
    
    for _, name in ipairs(attTbl) do
        local idx = target:LookupAttachment(name)
        if idx > 0 then 
            attIndex = idx 
            break 
        end
    end

    local neckBoneID = target:LookupBone(self.Head_DecapBones and self.Head_DecapBones.Neck or "ValveBiped.Bip01_Neck1")
    local startPos = attIndex > 0 and target:GetAttachment(attIndex).Pos or target:GetWorldSpaceCenter()
    local bloodCol = self:Determine_BloodColor()

    local ed = EffectData()
    local posi, angl = self:GetBonePosition(neckBoneID)
    ed:SetOrigin(posi)
    ed:SetAngles(angl)
    ed:SetColor(bloodCol)
    ed:SetScale(mRand(25, 55))
    util.Effect("VJ_Blood1", ed, true, true)

    if attIndex > 0 then
        if mRand(1, 2) == 1 then
            ParticleEffectAttach("blood_advisor_puncture_withdraw", PATTACH_POINT_FOLLOW, target, attIndex)
        end 
        ParticleEffectAttach("blood_impact_red_01", PATTACH_POINT_FOLLOW, target, attIndex)
    end

    local timerName = "Decap_Blood_" .. target:EntIndex()
    local i = 0
    
    timer.Create(timerName, mRand(0.05, 0.15), mRand(25, 120), function()
        if not IsValid(target) then 
            timer.Remove(timerName) 
            return 
        end

        local pos
        if attIndex > 0 then
            local att = target:GetAttachment(attIndex)
            pos = att and att.Pos
        elseif neckBoneID then
            pos = target:GetBonePosition(neckBoneID)
        end

        if not pos then return end

        if attIndex then 
            ParticleEffectAttach("blood_impact_red_01", PATTACH_POINT_FOLLOW, target, attIndex)
        end

        if i % 3 == 0 and target:WaterLevel() == 0 then
            util.Decal("Blood", pos, pos - Vector(0, 0, 80), target)
        end
        i = i + 1
    end)
end

function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpse)
    if not IsValid(corpse) then return end
    self:Handle_ExpensiveDecapPcfx(dmginfo, corpse)
    self:Delayed_DissolveAfterCorpse(corpse)
    self:Instant_DissolveCorpse(corpse)
    self:PlyFlatlineOnDeath(corpse) 
    self:Ele_CorpseDeathEffects(corpse)
    self:ManipulateCorpseFingers(corpse)
    self:ApplyCorpseTwitching(corpse)
    self:ApplyCorpseRoll(corpse, duration, interval)
    self:RngDeathEyePos(corpse) 
    self:RngFaceFlexPos(corpse)
    self:RngDeathEyelids(corpse)
    self:Corpse_GrabRngWound(corpse)
    self:Corpse_ExtraPhysics(dmginfo, hitgroup, corpse)
    self:Handle_HeadDecapitation(dmginfo, corpse)
    RagdollBloodEffects(self, corpse)
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Idle_TellJoke = true 
ENT.Idle_TellJokeRange = 500 -- An ally must be within this range to tell a joke
ENT.Idle_TellJokeChance = 3
ENT.Idle_TellJokeAllyReq = 2 -- Max amount of idle allies nearby to tell joke to them.
ENT.Idle_JokerState = false -- false == not active, "Intro" == before tell joke, "TellingJoke" == saying the joke
ENT.Idle_JokePlayAnim = true 
ENT.Idle_JokeNextT = 0 

ENT.Idle_CanListenToJoke = true 
ENT.Idle_ListenToJoke = false
ENT.Idle_ListenJokeState = false -- false == not active, "Listen" == do nothing as we listen until end, "React" play anim and laugh or say it bad,
ENT.Idle_ListenJokeAnim = true 
/*function ENT:Handle_IdleTellJoke()
    if self:GetNPCState ~= NPC_STATE_IDLE then return end 
end*/ 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleHeadshot(dmginfo, hitgroup)
    local imnBullet = self.Immune_Bullet
    if imnBullet then return end 

    local killConv = GetConVar("vj_stalker_headshot_kill_chance"):GetInt()
    self.HeadshotInstaKillChance = killConv

    local dT = dmginfo:GetDamageType()
    local isHeadshot = false 
    local minDmgHd = mRand(5, 10)
    local headHitGroup = HITGROUP_HEAD
    local DMG_HEADSHOT_TYPES = bit.bor(DMG_BULLET, DMG_AIRBOAT, DMG_BUCKSHOT, DMG_SNIPER)
    local bulDmg = (dmginfo:IsBulletDamage() or bit.band(dT, DMG_HEADSHOT_TYPES) ~= 0)
    local rngSnd = mRng(75, 105)

    local stopDmgConv     = GetConVar("vj_stalker_helm_prev_dmg"):GetInt()
    local armoredHelmConv = GetConVar("vj_stalker_armored_helmet"):GetInt()
    local helmBreakConv   = GetConVar("vj_stalker_breakable_helmet"):GetInt()
    local instKillConv    = GetConVar("vj_stalker_headshot_insa_kill"):GetInt()
    local mindDmgConv     = GetConVar("vj_stalker_headshot_min_dmg_check"):GetInt()
    local manBoneLook     = tostring(self.Head_DecapBones["Head"])
    local decapitHeadConv = GetConVar("vj_stalker_headshot_decapitation"):GetInt()

    if hitgroup == headHitGroup and bulDmg then
        isHeadshot = true
    else
        if manBoneLook then 
            local headBone = self:LookupBone(manBoneLook)
            if headBone and bulDmg then
                local hitPos = dmginfo:GetDamagePosition()
                local headBonePos, _ = self:GetBonePosition(headBone)
                if headBonePos /*and headBonePos > 0*/ and hitPos:Distance(headBonePos) <= mRand(10, 13) then
                    isHeadshot = true
                end
            end
        end
    end

    local setDmgCap = tonumber(self.ArmoredHelmet_MaxDamageCap) or 100
    local dmgAmount = dmginfo:GetDamage() or 0
    local ignoreHelmet = dmgAmount > (setDmgCap) and self.ArmoredHelmet_DamageCap 
    local hasValidHelm = self.ArmoredHelmet and armoredHelmConv ~= 1 and not ignoreHelmet
    local decapHpThreshConv = GetConVar("vj_stalker_headshot_decap_hp_thrsh"):GetInt()

    local hpThresh = tonumber(self.Head_DecapHpThresh) or 0.75
    local hpPercent = self:Health() / self:GetMaxHealth()
    local allowHpCheck = (decapHpThreshConv == 1)

    local passedHpCheck = (not allowHpCheck) or (hpPercent <= hpThresh)

    if isHeadshot and (decapitHeadConv and decapitHeadConv == 1) then
        local decapChance = self.Head_DecapChance or 2
        local decapCap = self.Head_DecapCap or 110

        if hasValidHelm or self.IsHeavilyArmored then 
            decapChance = math.max(1, math_ceil(decapChance * 3)) 
            if self.RANDOMS_DEBUG then print("(Headshot decapcitation) chance multiplied = " .. decapChance) end 
        end 

        if self.Head_Decap and dmgAmount >= decapCap and not self.IsImmuneToHeadShots and passedHpCheck then
            if mRng(1, decapChance) == 1 then 
                if self.RANDOMS_DEBUG then print("(Headshot decapcitation) damage take to trigger = " .. dmgAmount) end 
                self.Head_HasBeenDecapitated = true
                self.Headshot_Death = true
                dmginfo:SetDamage(self:GetMaxHealth() * 5)
                self:Handle_DecapitationEffects()
            end 
        end
    end 

    local curT = CurTime()
    local flinchGes = self.Headshot_FlinchChance or 2
    if self.Headshot_ImpactFlinching and curT >= (self.Headshot_NextFlinchT or 0) and mRng(1, flinchGes) == 1 then
        local animations = self:GetRandomValidValue(self.Headshot_ImpFlinchAnim)
        if animations then 
            self:PlayAnim("vjges_" .. animations, false)
        end 
        self.Headshot_NextFlinchT = curT + mRand(0.5, 1.5)
    end

    local sndChance = tonumber(self.ArmoredHelmet_ImpSoundChance) or 3  
    local exImpSnd = self:GetRandomValidValue(self.SoundTbl_ExtraArmorImpacts)   
    if isHeadshot and hasValidHelm and not ignoreHelmet then
        if self.ArmoredHelmet_ImpSound and mRng(1, sndChance) == 1 then 
            if exImpSnd then 
                self:PlaySoundSystem("Impact", exImpSnd)
            end 
        end 

        local sparkChance = self.ArmoredHelmet_SparkFxChance or 3
        if self.ArmoredHelmet_ImpSparkFx and mRng(1, sparkChance) == 1 then 
            local dmgPos = dmginfo:GetDamagePosition()
            local rngOff = mRand(-3, 3)
            local offset = Vector(rngOff, rngOff, rngOff)
            local spawnPos = dmgPos + offset
            local effectData = EffectData()
            effectData:SetOrigin(spawnPos)
            effectData:SetMagnitude(mRand(0.25, 1.5))
            effectData:SetScale(mRand(0.25, 1.5))
            effectData:SetRadius(mRand(1, 3)) 
            util.Effect("StunstickImpact", effectData, true, true)
        end

        local breakLimit = tonumber(self.ArmoredHelmet_BreakLimit) or mRng(3,5)
        local hitsTaken = (self.ArmoredHelmet_HitsTaken or 0) + 1

        if self.ArmoredHelmet_BlockDamaged and stopDmgConv == 1 then
            dmginfo:SetDamage(0)
            isHeadshot = false
        end

        if self.ArmoredHelmet_Break and  hitsTaken >= breakLimit and helmBreakConv == 1  then
            self.IsImmuneToHeadShots = false 
            self.ArmoredHelmet = false
            self.ArmoredHelmet_AffectFov = false
            self.ArmoredHelmet_BlockDamaged = false
            self.ArmoredHelmet_HitsTaken = 0
            if exImpSnd then 
                self:PlaySoundSystem("Impact", exImpSnd)
            end 
        end
    end
    
    if isHeadshot or self.Head_HasBeenDecapitated then
        self:HeadshotSoundEffect(isHeadshot)
    end

    if instKillConv == 1 and isHeadshot and not self.IsImmuneToHeadShots then
        local skipMinDmgCheck = mindDmgConv ~= 1
        local passedMinDmg = dmginfo:GetDamage() > minDmgHd
        local instaKillChance = tonumber(self.HeadshotInstaKillChance) or 2 
        
        local attacker = dmginfo:GetAttacker()
        if IsValid(attacker) and (attacker:IsNPC() or attacker:IsNextBot()) then -- Make combat with other npcs more fair.
            instaKillChance = (math_ceil(instaKillChance + 2 * instaKillChance)) or 3
        end 

        if mRng(1, instaKillChance) == 1 and (skipMinDmgCheck or passedMinDmg) then
            if self.Headshot_DoubleDmg then
                local newDmg = dmginfo:GetDamage() * 2
                dmginfo:SetDamage(newDmg)
            else
                self.Headshot_Death = true
                dmginfo:SetDamage(self:GetMaxHealth() * 3)
            end
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Head_Decap = true 
ENT.Head_DecapCap = 110 -- Required damage to destroy the NPCs head. 
ENT.Head_DecapChance = 2 
ENT.Head_DecapHpThresh = 0.75
ENT.Head_HasBeenDecapitated = false 
ENT.Head_DecapBones = {
    ["Head"] = "ValveBiped.Bip01_Head1",
    ["Neck"] = "ValveBiped.Bip01_Neck1"
}

function ENT:CacheHeadData()
    self.CachedHeadBone = self:LookupBone(self.Head_DecapBones["Head"])
    self.CachedNeckBone = self:LookupBone(self.Head_DecapBones["Neck"])
    
    self.CachedHeadAtts = {}
    local attTbl = self.HeadshotDeathAttTbl or {"mouth", "head", "eyes"}
    for _, attName in ipairs(attTbl) do
        local idx = self:LookupAttachment(attName)
        if idx > 0 then
            table.insert(self.CachedHeadAtts, {id = idx, name = attName})
        end
    end
end

function ENT:Handle_DecapitationEffects()
    if not self.Head_HasBeenDecapitated then return end

    local cheap = GetConVar("vj_stalker_headshot_low_effects"):GetInt() == 1
    if not cheap or cheap ~= 1 then return end 

    local headBone = self.CachedHeadBone or self:LookupBone(self.Head_DecapBones["Head"])
    if not headBone then return end

    local headPos, headAng = self:GetBonePosition(headBone)
    if not headPos then return end

    local bloodCol = self:Determine_BloodColor()
    local basePos = headPos

    local ed = EffectData()
    ed:SetOrigin(headPos)
    ed:SetColor(bloodCol)
    ed:SetScale(mRand(25, 55))
    util.Effect("VJ_Blood1", ed, true, true)

    ed:SetOrigin(headPos)
    ed:SetAngles(headAng)
    ed:SetScale(mRand(3, 10))
    ed:SetFlags(3)
    ed:SetColor(0)
    util.Effect("bloodspray", ed, true, true)

    self:Handle_HeadGoreGibs(headPos)
end

function ENT:Handle_HeadGoreGibs(position)
    if not self.Headshot_HaveGibs then return false end 

    local gibType = self:DetermineGibType()
    if not gibType then return false end 
    
    local basePos = position
    if not basePos then return false end 

    local gibAmount = self.Headshot_GibMaxAm or 3
    local count = gibAmount
    for i = 1, count do
        self:CreateGibEntity("obj_vj_gib", gibType .. "Small", {Pos = basePos + VectorRand() * 6})
    end
end 

function ENT:HeadshotDeathEffects()
    if not self.Headshot_Death or self.Head_HasBeenDecapitated then return end 

    local headConv = GetConVar("vj_stalker_headshot_fx")
    if headConv:GetInt() ~= 1 then return end

    if not IsValid(self) then return end
    
    local attData = self.CachedHeadAtts and self.CachedHeadAtts[1]
    if not attData then return end

    local headAttachment = self:GetAttachment(attData.id)
    if not headAttachment then return end

    local goreSnd = GetConVar("vj_stalker_headshot_gore_sound"):GetInt()
    if goreSnd == 1 then
        local hsGore = self:GetRandomValidValue(self.GoreOrGibSounds)
        local rngSnd = mRng(65, 95)
        if hsGore then
            VJ.EmitSound(self, hsGore, 70, rngSnd)
        end 
    end

    local effectChance = tonumber(self.Headshot_FxChance) or 2
    if mRng(1, effectChance) == 1 then

        local gibPos = headAttachment.Pos + self:GetUp() * mRng(5, 25) + self:GetRight() * mRng(-15, 15)
        local bloodT = mRand(1, 3.5)

        local bloodeffect = ents.Create("info_particle_system")
        bloodeffect:SetKeyValue("effect_name", "blood_advisor_puncture_withdraw")
        bloodeffect:SetPos(gibPos)
        bloodeffect:SetAngles(headAttachment.Ang)
        bloodeffect:SetParent(self)
        bloodeffect:Fire("SetParentAttachment", attData.name, 0)
        bloodeffect:Spawn()
        bloodeffect:Activate()
        bloodeffect:Fire("Start", "", 0)
        bloodeffect:Fire("Kill", "", bloodT)

        ParticleEffectAttach("blood_impact_red_01", PATTACH_POINT_FOLLOW, self, attData.id)
        self:Handle_HeadGoreGibs(gibPos)
    end
    return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HeadshotSoundEffect(hasBeenHeadshot)
    if not self.Headshot_Death_Sfx then return end 
    if not hasBeenHeadshot then return end  
    if not IsValid(self) then return end

    local conv = GetConVar("vj_stalker_headshot_sfx"):GetInt()
    if not conv or conv ~= 1 then return end 

    local hS = self:GetRandomValidValue(self.SoundTbl_OnHeadshot)
    if not hs then return end 

    local hsSfxChance = self.HeadshotSoundSfxChance or 3
    local rngSnd = mRng(75, 105)
    if mRng(1, hsSfxChance) == 1 then
        self:EmitSound(hS, mRng(65, 85), rngSnd)
    end 
end
---------------------------------------------------------------------------------------------------------------------------------------------

-- [useDefAi] (boolean or "Both")
-- Controls which scheduling system is used:
--    true  = Use default GLua schedules (SetSchedule)
--    false = Use VJ Base schedules (SCHEDULE_*)
--    "Both" = Randomly choose between GLua or VJ each call
-- ------------------------------------------------------
-- [coverType] (string or "Both")
-- Determines the type of movement/cover behavior:
--    "LastPos"  = Move to last saved position.
--    "Enemy"  = Move relative to the enemy 
--    "Origin" = Move relative to current/original position
--    "Both"   = Randomly pick between "Enemy" or "Origin" (Not including last position)
--
-- NOTE:
-- "Enemy" requires a valid enemy, otherwise it will fallback safely.
-- ------------------------------------------------------
-- [canShoot] (boolean or "Both")
-- Controls whether the SNPC can shoot while moving:
--    true  = Always shoot while moving
--    false = Never shoot while moving
--    "Both" = Randomly decide per execution
-- ------------------------------------------------------
-- [moveType] (string or "Both")
-- Controls movement speed/type:
--    "Walk" = Uses walking schedules/tasks
--    "Run"  = Uses running schedules/tasks
--    "Both" = Randomly choose between Walk or Run
-- NOTE:
-- Automatically maps to correct equivalents:
--    VJ   → TASK_WALK_PATH / TASK_RUN_PATH
--    GLua → SCHED_FORCED_GO / SCHED_FORCED_GO_RUN (LastPos Exclusive)
-- ------------------------------------------------------
-- [delayCmbBehavior] (boolean or "Rng")
-- Controls delay before next combat/chase behavior:
--    false/nil = No delay applied
--    true      = Applies a randomized delay (1–5 seconds)
--    "Rng"    = 1 in 2 chance to activate
-- Affects:
--    self.NextChaseTime
--    self.TakingCoverT
------------------------------------------------------

ENT.ForbiddenSchedules = {
    [SCHED_FORCED_GO] = true,
    [SCHED_TAKE_COVER_FROM_ENEMY] = true,
    [SCHED_FORCED_GO_RUN] = true,
    [SCHED_TAKE_COVER_FROM_ORIGIN] = true, 
    [SCHED_HIDE_AND_RELOAD] = true, 
    [SCHED_RELOAD] = true, 
}


function ENT:Handle_ScheduledForceMove(useDefAi, coverType, canShoot, moveType, delayCmbBehavior)
    if not self:Alive() then return end
    if not self:IsOnGround() then return end
    if not self:IsAbleToMoveNow() then return end

    local curSched = self:GetCurrentSchedule()
    if self.ForbiddenSchedules[curSched] then
        if self.RANDOMS_DEBUG then 
            print("Skipping forced schedule due to active schedule ID: " .. curSched) 
        end 
        return
    end

    local enemy = self:GetEnemy()

    local function ResolveBool(val)
        if val == "Both" then
            return mRng(1, 2) == 1
        end
        return val == true
    end

    local function ResolveChoice(val, choices)
        if val == "Both" then
            return choices[mRng(1, #choices)]
        end
        return val
    end

    local function ApplyShootSettings(task, shouldShoot)
        if shouldShoot then
            task.CanShootWhenMoving = true
            task.TurnData = {Type = VJ.FACE_ENEMY}
        else
            task.CanShootWhenMoving = false
            task.TurnData = {Type = VJ.FACE_ENEMY, Target = nil}
        end
    end

    local MOVE_MAP = {
        VJ = {
            Walk = "TASK_WALK_PATH",
            Run  = "TASK_RUN_PATH"
        },
        GLUA = { 
            Walk = SCHED_FORCED_GO,
            Run  = SCHED_FORCED_GO_RUN
        }
    }

    local useSystem;
    if useDefAi == "Both" then
        useSystem = (mRng(1, 2) == 1) and "GLUA" or "VJ"
    else
        useSystem = useDefAi and "GLUA" or "VJ"
    end

    local finalMoveType = ResolveChoice(moveType or "Run", {"Walk", "Run"})
    local finalCover    = ResolveChoice(coverType or "Origin", {"Origin", "Enemy", "LastPos"})
    local shouldShoot   = ResolveBool(canShoot)

    local pickedMove = MOVE_MAP[useSystem][finalMoveType]
    if not pickedMove then return end
    
    self:ClearSchedule()
    self:StopMoving()

    if useSystem == "VJ" then
        if finalCover == "Enemy" and IsValid(enemy) then
            self:SCHEDULE_COVER_ENEMY(pickedMove, function(task)
                task.DisableChasingEnemy = true
                ApplyShootSettings(task, shouldShoot)
            end)
        elseif finalCover == "Origin" then
            self:SCHEDULE_COVER_ORIGIN(pickedMove, function(task)
                task.DisableChasingEnemy = true
                ApplyShootSettings(task, shouldShoot)
            end)
        elseif finalCover == "LastPos" then 
            self:SCHEDULE_GOTO_POSITION(pickedMove, function(task)
                task.DisableChasingEnemy = true
                ApplyShootSettings(task, shouldShoot)
            end) 
        end 
    else
        local sched;
        if finalCover == "Enemy" and IsValid(enemy) then
            sched = SCHED_TAKE_COVER_FROM_ENEMY
        elseif finalCover == "Origin" then
            sched = SCHED_TAKE_COVER_FROM_ORIGIN
        elseif finalCover == "LastPos" then 
            sched = pickedMove 
        end
        if sched then
            self:SetSchedule(sched)
        end
    end

    local delay = delayCmbBehavior
    local shouldDelay = false 

    if delay then 
        shouldDelay = true 

    elseif delay == "Rng" then 
        if mRng(1, 2) == 1 then 
            shouldDelay = true 
        else 
            shouldDelay = false 
        end 
    end 

    if shouldDelay then
        local cT = CurTime()
        local delay = mRand(1, 5)

        self.NextChaseTime = cT + delay
        self.TakingCoverT  = cT + delay
    end

    if self.RANDOMS_DEBUG then
        print("[ForceMove]")
        print(" System:", useSystem)
        print(" Move:", finalMoveType)
        print(" Cover:", finalCover)
        print(" Shoot:", shouldShoot)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Inst_AlrtTo_Dmg = true 
ENT.Inst_AlrtTo_Dmg_Dist = 3500
ENT.Inst_AlrtTo_Dmg_Chance = 6
function ENT:InstantAlert_ToDmg(dmginfo)
    if not self.Inst_AlrtTo_Dmg then return end 
    if not self:Alive() then return end 
    if self:IsBusy() or self:IsVJAnimationLockState() then return end 

    local conv = GetConVar("ai_ignoreplayers")
    local npcState = self:GetNPCState()
    local stateCmb = NPC_STATE_COMBAT
    
    if npcState == stateCmb then return end 

    local dgmAtt = dmginfo:GetAttacker()
    local ene = self:GetEnemy()

    if not IsValid(dgmAtt) or dgmAtt == self or IsValid(ene) then return end  

    local isPlayer = dgmAtt:IsPlayer()
    local isNPC = dgmAtt:IsNPC()
    local isNextBot = dgmAtt:IsNextBot()

    if not (isPlayer or isNPC or isNextBot) then return end

    local disp = self:Disposition(dgmAtt)
    if disp == D_LI or disp == D_NU then return end  

    if isPlayer then
        if conv:GetBool() or dgmAtt:GetFlags() == FL_NOTARGET then return end
         if self.RANDOMS_DEBUG then print("(InstantAlert_ToDmg) Damage attacker (player): " .. tostring(dgmAtt)) end 
    end

    local chance = tonumber(self.Inst_AlrtTo_Dmg_Chance) or 3 
    if mRng(1, chance) ~= 1 then return end 

    local dist = self.Inst_AlrtTo_Dmg_Dist or 3500
    local distSqr = self:GetPos():DistToSqr(dgmAtt:GetPos())
    local maxDistSqr = dist * dist
    
    if distSqr > maxDistSqr then return end
    local chance = tonumber(self.Inst_AlrtTo_Dmg_Chance) or 6
    local halfDistSqr = (dist * 0.5) * (dist * 0.5)
    if distSqr <= halfDistSqr then
        chance = math.max(1, math_floor(chance * 0.2)) 
        if self.RANDOMS_DEBUG then 
            print("(InstantAlert_ToDmg) Attacker close! Chance buffed to 1 in " .. chance) 
        end
    end

    timer.Simple(0.25, function()
        if not IsValid(self) or not IsValid(dgmAtt) or IsValid(ene) then return end

        local currentEne = self:GetEnemy()
        if IsValid(currentEne) then return end

        self:StopMoving()
        self:ForceSetEnemy(dgmAtt, false)
        self:UpdateEnemyMemory(dgmAtt, dgmAtt:GetPos())
        self:PointAtEntity(dgmAtt)
        self:SetCondition(COND_SEE_ENEMY) 
        if npcState ~= stateCmb then 
            self:SetNPCState(NPC_STATE_ALERT)
        end
        if self.RANDOMS_DEBUG then print("(InstantAlert_ToDmg) we have been alerted to the enemy who hurt us!") end
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Dmg_Cancel_IdleDial = true 
ENT.Reinforced_Armor = true 

ENT.BlastType_Flinch = true 
ENT.BlastType_FlinchChance = 3
ENT.BlastType_FlinchNextT = 0 
function ENT:Blast_FlinchGesture(dmginfo)
    if self.BlastType_Flinch then 
        if self.IsCurrentlyIncapacitated then return end 
        if self:IsOnFire() then return end 
        if self:Health() <= 0 then return end
        if not self:IsOnGround() then return end 

        if self:IsVJAnimationLockState() then return end 

        if badStaes then return end 
        local delay = mRand(0.5, 5)

        local dmgType = dmginfo:GetDamageType()
        if bit.band(dmgType, DMG_BLAST) == 0 then return end

        local curT = CurTime()
        if curT <= (self.BlastType_FlinchNextT or 0) then return end

        local chance = self.BlastType_FlinchChance or 3

        if self.IsHeavilyArmored then 
            chance = math.min(3, math_floor(chance * 3))
        end 

        if mRng(1, chance) ~= 1 then 
            self.BlastType_FlinchNextT = curT + mRand(1, 3)
            return 
        end

        if self:IsPlayingGesture(146) then return end -- 146 is ACT_GESTURE_FLINCH_BLAST

        if mRng(1, 2) == 1 then 
            self:RemoveAllGestures()
        end 

        local animTbl = {"flinch_blast", "fear_reaction_gesture"}
        if #animTbl == 0 then return end

        local anim = animTbl[mRng(1, #animTbl)]
        local seq = self:LookupSequence(anim)
        if not seq or seq <= 0 then return end
        local rngSped = mRand(0.7, 0.8)
        local layer = self:AddGestureSequence(seq, true)
        if layer then
            self:SetLayerPlaybackRate(layer, rngSped)
        end
        if self:IsMoving() and mRng(1, 2) == 1 then 
            self:StopMoving()
        end 
        self.BlastType_FlinchNextT = curT + delay  
    end 
end 

function ENT:Extra_LayeredGesFlinching(dmginfo)
    if not dmginfo then return end
    if not self.ExFlinch_Feedback_Ges then return end 

    local gesFlinchConv = GetConVar("vj_stalker_ges_flinch"):GetInt()
    if not gesFlinchConv or gesFlinchConv ~= 1 then return end 

    if not self:Alive() then return end 
    if self:IsVJAnimationLockState() then return end 

    local curT = CurTime()
    if curT <= (self.ExFlinch_Ges_NextT or 0) then return end 

    local flinChance = self.ExFlinch_Ges_Chance or 6
    local tDel = mRand(0.01, 0.25)

    if self.IsHeavilyArmored then 
        flinChance = math.min(3, math_floor(flinChance * 3))
    end 

    local maxHp = self:GetMaxHealth()
    if self.ExFlinch_HpThresh and maxHp > 0 and (self:Health() / maxHp) <= self.ExFlinch_HpThresh_Min then
        flinChance = math.max(1, math_floor(flinChance / 2))
    end

    if mRng(1, flinChance) == 1 then
        timer.Simple(tDel, function()
            if not IsValid(self) or not self:Alive() then return end
            if self:IsBusy() then return end

            local anim = self.ExFlinch_GesTbl
            if not anim then return end

            local flinchAnim
            if anim ~= false and anim ~= "" then 
                if istable(anim) then 
                    flinchAnim = table.Random(anim)
                elseif isstring(anim) then 
                    flinchAnim = anim 
                end 
            end 

            if not flinchAnim then return end

            local blockedGestures = {144, 145, 146, 150, 152, 153, 154}

            for _, act in ipairs(blockedGestures) do
                if self:IsPlayingGesture(act) then return end
            end

            local seq = self:LookupSequence(flinchAnim)
            if not seq or seq <= 0 then return end

            local layer = self:AddGestureSequence(seq, true)
            local plyRate =  mRand(0.5, 1.75) or 1 
            if layer then
                self:SetLayerPlaybackRate(layer, plyRate)
            end
            self.ExFlinch_Ges_NextT = CurTime() + mRand(0.5, 2.5)
        end)
    end
end

ENT.No_FriendlyFire = true
function ENT:Handle_FriendlyFire(dmginfo)
    if not self.No_FriendlyFire then return end 
    if not self:Alive() then return end 

    local conv = GetConVar("vj_stalker_friendly_fire")
    if not conv or conv:GetInt() ~= 1 then return end 

    local att = dmginfo:GetAttacker() 
    if not IsValid(att) then return end 
    if att == self then return end 

    if IsValid(self) and ((not VJ_CVAR_IGNOREPLAYERS and att:IsPlayer()) or att:IsNextBot() or att:IsNPC()) then
        if self:Disposition(att) == D_LI then 
            if dmginfo:GetDamage() > 0 then 
                dmginfo:SetDamage(0)
            end 
        end
    end
end

function ENT:Handle_ToxCoughReact(dmginfo)
    if not self.ToxDmg_React or not self:Alive() or self.Immune_Toxic then return end 

    local coughConv = GetConVar("vj_stalker_coughing"):GetInt()
    if coughConv ~= 1 then return end

    local curT = CurTime()
    if curT < self.ToxDmg_NextT then return end 
    local isToxic = dmginfo:IsDamageType(DMG_RADIATION + DMG_POISON + DMG_NERVEGAS + DMG_PARALYZE + DMG_ACID)
    
    if isToxic then 
        if mRng(1, self.ToxDmg_Chance or 3) == 1 then 
            local sndTbl = self.ToxDmg_CoughTbl
            if sndTbl and #sndTbl > 0 then 
                local snd = table.Random(sndTbl)
                if snd then 
                    self:PlaySoundSystem("IdleDialogue", snd)
                end 
                self.ToxDmg_NextT = curT + mRand(2.5, 5)
            end 
        else
            self.ToxDmg_NextT = curT + 0.5
        end 
    end 
end

ENT.Impact_ElectircalEffects = {"ambient/energy/spark".. mRng(1, 6) .. ".wav"}
ENT.Impact_ElectricalNextT = 0 
function ENT:Electric_DmgSpark(dmginfo)
    if not self.Ele_SparkImpFx then return end 
    if not self:Alive() then return end
    local c = CurTime()
    
    if c < self.Impact_ElectricalNextT then return end 
    
    local chance = self.Ele_SparkImpFx_Chance or 20
    if mRng(1, chance) == 1  then
        local snd = self.Impact_ElectircalEffects or ""
        local rngSnd = mRng(75, 105)
        local rngAng = mRng(-360, 360)
        local randAng = Angle(rngAng, rngAng, rngAng)
        local dmgPos = dmginfo:GetDamagePosition()
        local vecRand = VectorRand(-15, 15)
        ParticleEffect("electrical_arc_01_parent", dmgPos + vecRand, randAng, nil)

        if snd and #snd > 0 then 
            local picked = table.Random(snd)
            VJ.EmitSound(self, picked, 70, rngSnd)
        end 
        self.Impact_ElectricalNextT = c + mRand(1, 5)
    end
end 

function ENT:Handle_DmgCancelDialogue(dmginfo)
    if not self.Dmg_Cancel_IdleDial or not self.HasSounds or not self:Alive() then return end

    if self.IsPlayingFirePain then return end -- To prevent 

    local cancelDial = GetConVar("vj_stalker_dmg_cancel_dial"):GetInt()
    if not cancelDial or cancelDial ~= 1 then return end 

    local wasTalking = false 
    if self.CurrentIdleSound then
        self.CurrentIdleSound:Stop() 
        wasTalking = true
    end 
    if self.CurrentSpeechSound then 
        self.CurrentSpeechSound:Stop()
        wasTalking = true
    end
    if self.CurrentExtraSpeechSound then 
        self.CurrentExtraSpeechSound:Stop()
        wasTalking = true
    end 
    if wasTalking then
        self.IdleSoundBlockTime = CurTime() + mRand(2.5, 5)
    end
end

function ENT:OnDamaged(dmginfo, hitgroup, status) 
    if status == "PreDamage" then
        self:GibWhenDamaged(dmginfo)
        self:Handle_FriendlyFire(dmginfo)
        self:Extra_LayeredGesFlinching(dmginfo)
        self:Blast_FlinchGesture(dmginfo)
        self:HandleReinforcedArmorImpact(dmginfo)
        self:PanicOnDamageByEne(dmginfo)
        self:MngDmgTypeScales(dmginfo)
        self:InstantAlert_ToDmg(dmginfo)
        self:ShovedBack(dmginfo)
        self:Handle_OnFirePain(dmginfo)
        self:Handle_ToxCoughReact(dmginfo)
        self:React_DmgFrPly(attacker, dmginfo)
        self:Electric_DmgSpark(dmginfo)
        self:Handle_DmgCancelDialogue(dmginfo)
        self:DamagedByShockFx(dmginfo) 

        if self.CanHaveHeadshotFx then
            self:HandleHeadshot(dmginfo, hitgroup)
        end
    end 

    if status == "Init" then
        self:Handle_MinDmgCap(dmginfo)
    end 
    if status == "PostDamage" then
        self:Armored_Richochet(dmginfo)
        self:Armor_DmgSparking(dmginfo)
    end
end

function ENT:Handle_MinDmgCap(dmginfo)
    if not self.MinDmg_CapAbility then return end 
    local minDmgConv = GetConVar("vj_stalker_min_dmg_cap")
    if minDmgConv:GetInt() ~= 1  then return end 
    if not dmginfo then return end
    local heavy = self.IsHeavilyArmored
    local minCapChnce = tonumber(self.MinDmg_Cap_Chance) or 3 

    if heavy then 
        minCapChnce = math.max(1, math_floor(minCapChnce / 2))
    end 

    if mRng(1, minCapChnce) ~= 1 then return end 
    local damage = dmginfo:GetDamage()
    local minDmg = self.MinDmg_Cap or 5 

    if heavy then 
        minDmg = minDmg * 2
    end 

    local dmgType = dmginfo:GetDamageType()
    local curT    = CurTime()

    if damage <= minDmg and bit.band(dmgType, bit.bor(DMG_BURN, DMG_SLOWBURN)) == 0 and curT > (self.MinDmg_Cap_NextT or 0) then
        self.MinDmg_Cap_NextT = curT + 0.05 
        dmginfo:SetDamage(0)

        local imp; 
        local snd = self.MinDmg_CapImpTbl 
        local imp = istable(snd) and snd[mRng(1, #snd)] or snd
        if not imp then return end
        local minDmgSfxConv = GetConVar("vj_stalker_min_dmg_cap_sfx"):GetInt()
        local minImpChnce = tonumber(self.MinDmg_Cap_Feedback_Sfx_Chance) or 2
         
        if minDmgSfxConv == 1 and self.MinDmg_Cap_Feedback_Sfx and mRng(1, minImpChnce) == 1 then 
            self:PlaySoundSystem("Impact", imp)
        end
    end
end 

function ENT:Handle_OnFirePain(dmginfo)
    if not self.HasFireSpecPain then return end 
    if not IsValid(self) then return end
    if not self:Alive() then return end 

    local cv = GetConVar("vj_stalker_fire_dmg_vo")
    if cv:GetInt() ~= 1 then return end

    if self.Immune_Fire or not self.HasSounds then return end
    local dmgType = dmginfo:GetDamageType()
    if bit.band(dmgType, bit.bor(DMG_BURN, DMG_SLOWBURN)) ~= 0 or self:IsOnFire() then
        if self.OnFirePain == false or self.OnFirePain == nil then return end

        local firePain = self.OnFirePain
        if not firePain or firePain == false then return end

        local burnSnd;

        if istable(firePain) and #firePain > 0 then
            burnSnd = table.Random(firePain)
        elseif isstring(firePain) then
            burnSnd = firePain
        end

        if not burnSnd or burnSnd == "" then return end
        self.IsPlayingFirePain = true
        self:PlaySoundSystem("Pain", burnSnd)
        timer.Simple(0.1, function()
            if IsValid(self) then
                self.IsPlayingFirePain = false
            end
        end)
    end 
end

function ENT:Armor_DmgSparking(dmginfo)
    if not self.ArmorSparking then return end 
    local armorConv = GetConVar("vj_stalker_armor_spark"):GetInt()
    if armorConv ~= 1 then return end

    local cT = CurTime()
    if cT < (self.Armor_SparkNextT or 0) then return end

    local dmgType = dmginfo:GetDamageType()
    local armorSparkChance = self.ArmorSparking_Chance or 12
    local dmgPos = dmginfo:GetDamagePosition()
    local ang = self:GetAngles()
    local dT = dmginfo:GetDamageType()

    local magMin = self.Armor_SparkMag_Min or 0.05
    local magMax = self.Armor_SparkMag_Max or 1
    local legMin = self.Armor_SparkLeg_Min or 0.05
    local legMax = self.Armor_SparkLeg_Max or 3 

    local bulDmg = bit.bor(DMG_BULLET, DMG_BUCKSHOT, DMG_SNIPER, DMG_AIRBOAT)
    if dmginfo:IsDamageType(bulDmg) or dmginfo:IsBulletDamage() then 
        local dmg = dmginfo:GetDamage()
        if dmg < 0 then return end 
        if mRng(1, armorSparkChance) == 1 then
            self.Armor_SparkNextT = cT + mRand(0.1, 0.5)
            local damageSpark = ents.Create("env_spark")
            local color = self.Armor_SparkColor or "255 255 255"
            local stopT = mRand(0.05,0.225) or 0.1
            local sparkMagnitude = mRand(magMin, magMax) 
            local sparkTrailLength = mRand(legMin, legMax)
            if IsValid(damageSpark) then
                damageSpark:SetKeyValue("Magnitude", sparkMagnitude)
                damageSpark:SetKeyValue("Spark Trail Length", sparkTrailLength)
                damageSpark:SetPos(dmgPos)
                damageSpark:SetAngles(ang)
                damageSpark:Fire("LightColor", tostring(color))
                damageSpark:SetParent(self)
                damageSpark:Spawn()
                damageSpark:Activate()
                damageSpark:Fire("StartSpark", "", 0)
                damageSpark:Fire("StopSpark", "", stopT)
                self:DeleteOnRemove(damageSpark)
            end
        end
    end 
end 

ENT.Reinforced_Armor_ImpSnds = true 
ENT.Reinforced_Armor_ImpSnds_Chance = 10 
function ENT:HandleReinforcedArmorImpact(dmginfo)
    if not self.HasSounds or not self.HasImpactSounds then return end
    if not (self.Reinforced_Armor and self.Reinforced_Armor_ImpSnds) then return end

    local dmgType = dmginfo:GetDamageType()
    if bit.band(dmgType, bit.bor(DMG_BURN, DMG_SLOWBURN)) ~= 0 or self:IsOnFire() then return end

    local chance = tonumber(self.Reinforced_Armor_ImpSnds_Chance) or 15
    if mRng(1, chance) ~= 1 then return end

    local snd1 = self.MinDmg_CapImpTbl
    local snd2 = self.SoundTbl_ExtraArmorImpacts
    local candidates = {}

    if istable(snd1) and #snd1 > 0 then
        table.insert(candidates, snd1[mRng(1, #snd1)])
    elseif isstring(snd1) and snd1 ~= "" then
        table.insert(candidates, snd1)
    end

    if istable(snd2) and #snd2 > 0 then
        table.insert(candidates, snd2[mRng(1, #snd2)])
    elseif isstring(snd2) and snd2 ~= "" then
        table.insert(candidates, snd2)
    end

    if #candidates == 0 then return end 
    local soundToPlay = candidates[mRng(1, #candidates)]
    if soundToPlay then
        self:EmitSound(soundToPlay,mRng(75, 80), mRng(95, 105), 1, CHAN_BODY)
    end 
end

ENT.Reinforced_Armor_Richochet = true 
ENT.Reinforced_Armor_RichochetChance = 30
ENT.Reinforced_Armor_IsRichocheting = false 
ENT.Reinforced_Armor_RichochetNextT = 0 

ENT.Reinforced_Armor_ImpFx = true
ENT.Reinforced_Armor_ImpFxChance = 2
ENT.Reinforced_Armor_ImpFxNextT = 0 
ENT.Reinforced_Armor_ImpFxTrue = false
function ENT:Handle_StunstickImpFx(dmginfo, forcedActive)
    if self.Reinforced_Armor_ImpFx then 

        local always = forcedActive
        local chance = self.Reinforced_Armor_ImpFxChance or 2 

        if always then 
            chance = 1 
        end 
        
        if mRng(1, chance) ~= 1 then return end 

        self.Reinforced_Armor_ImpFxTrue = false 
        if not self.Reinforced_Armor_ImpFxTrue then 
            local c = CurTime()
             if c > (self.Reinforced_Armor_ImpFxNextT or 0) then 
                self.Reinforced_Armor_ImpFxTrue = true 
                self.Reinforced_Armor_ImpFxNextT = c + mRand(1, 3)

                local spark = EffectData()
                local scle = mRand(0.05, 0.5)
                local hitPos = dmginfo:GetDamagePosition()
                local surfaceNormal = (self:GetPos() - hitPos):GetNormalized()

                spark:SetOrigin(hitPos)
                spark:SetNormal(surfaceNormal)
                spark:SetScale(scle)
                util.Effect("StunstickImpact", spark)
            end
        end 
    end 
end 

function ENT:Armored_Richochet(dmginfo)
    if not self.Reinforced_Armor_Richochet then return end 

    local armorRichConv = GetConVar("vj_stalker_armor_ricochet"):GetInt()
    if armorRichConv == 1 and self.Reinforced_Armor then

        local heavyFilterConv = GetConVar("vj_stalker_heavyarm_richo_filter")
        if heavyFilterConv:GetInt() == 1 then 
            if not self.IsHeavilyArmored then 
                return 
            end 
        end 

        if CurTime() < self.Reinforced_Armor_RichochetNextT then return end 
        local dmgType = dmginfo:GetDamageType()
        local chance = self.Reinforced_Armor_RichochetChance or 20 
        local rngSnd = mRng(85, 105)
        local mask = bit.bor(DMG_BULLET, DMG_BUCKSHOT, DMG_SNIPER, DMG_AIRBOAT)
        if bit.band(dmginfo:GetDamageType(), mask) == 0 then return end
        if mRng(1, chance) == 1 then 
            self.Reinforced_Armor_IsRichocheting = true
            local attacker = dmginfo:GetAttacker()
            if not IsValid(attacker) then attacker = self end
            if IsValid(attacker) and IsValid(self) then
                local hitPos = dmginfo:GetDamagePosition()
                
                local ricoSndTbl = self.Rein_Armor_Richochet_Tbl
                if ricoSndTbl and #ricoSndTbl > 0 then
                    local snd = table.Random(ricoSndTbl)
                    VJ.EmitSound(self, snd, mRng(65, 85), mRng(90, 110))
                end

                if hitPos == Vector(0, 0, 0) or not hitPos then
                    hitPos = self:GetPos() + self:OBBCenter()
                end

                local bulletDir = (hitPos - attacker:GetPos()):GetNormalized()
                local surfaceNormal = (self:GetPos() - hitPos):GetNormalized()
                local dotProduct = bulletDir:Dot(surfaceNormal)
                local reflection = bulletDir - (surfaceNormal * 2 * dotProduct)
                reflection:Normalize()
                local angle = reflection:Angle()
                angle:RotateAroundAxis(angle:Right(), mRand(-270, 270))  
                angle:RotateAroundAxis(angle:Up(), mRand(-45, 45))   
                reflection = angle:Forward()
                local startPos = hitPos + reflection * 5
                local effectData = EffectData()
                local rngScle = mRng(2500, 5000) or 5000
                effectData:SetStart(startPos)
                effectData:SetOrigin(startPos + reflection * 2000)
                effectData:SetScale(rngScle)
                util.Effect("Tracer", effectData)

                self:Handle_StunstickImpFx(dmginfo, false)
                
                local bullet = {}
                bullet.Src = startPos
                bullet.Dir = reflection
                bullet.Spread = Vector(0.01, 0.01, 0.01)
                bullet.Num = 1
                bullet.Attacker = attacker
                bullet.Inflictor = dmginfo:GetInflictor()
                bullet.Damage = mRng(5, 15)
                bullet.Force = 5
                bullet.Tracer = 1
                bullet.TracerName = "Tracer"
                bullet.IgnoreEntity = self
                self:FireBullets(bullet)
                self.Reinforced_Armor_RichochetNextT = CurTime() + mRand(1, 3)
                self.Reinforced_Armor_IsRichocheting = false
            end
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
    -- [Panic after dmg] --
ENT.Panic_DmgEne = true
ENT.Panic_DmgEne_Hp = true 
ENT.Panic_DmgEne_NextT = 0
ENT.Panic_DmgEne_Chance = 12

function ENT:PanicOnDamageByEne(dmginfo)
    if not self.Panic_DmgEne then return end 

    local conv = GetConVar("vj_stalker_panic_after_dmg")
    if not conv or conv:GetInt() ~= 1 then return end

    if self.VJ_IsBeingControlled then return end
    if not self:Alive() then return end 

    if self:IsBusy() or self:IsVJAnimationLockState() then return end

    local curTime = CurTime()
    if curTime < (self.Panic_DmgEne_NextT or 0) then return end

    local attacker = dmginfo and dmginfo:GetAttacker()
    local enemy = self:GetEnemy()

    if not IsValid(attacker) and not IsValid(enemy) then return end

    local disp = IsValid(attacker) and self:Disposition(attacker)
    if disp == D_LI or disp == D_NU then return end 

    local sched = self:GetCurrentSchedule()
    if sched == 30 or sched == 27 then return end

    local wep = self:GetActiveWeapon()
    local hasNonMeleeWeapon = not IsValid(wep) or (IsValid(wep) and not wep.IsMeleeWeapon)

    local panicChance = tonumber(self.Panic_DmgEne_Chance) or 10

    if self.IsHeavilyArmored then 
        panicChance = panicChance * 2
    end 

    if self:Health() <= (self:GetMaxHealth() * 0.5) then
        panicChance = math.max(1, math_floor(panicChance / 2))
    end

    if not hasNonMeleeWeapon then return end
    if mRng(1, panicChance) ~= 1 then return end

    local coverMap = {
        [1] = "Origin",
        [2] = "Enemy",
        [3] = "Origin" 
    }

    local coverType = coverMap[mRng(1,3)] or "Both"
    local aiType
    local aiPick = mRng(1,3)
    if aiPick == 1 then
        aiType = false -- VJ
    elseif aiPick == 2 then
        aiType = true -- Default
    else
        aiType = "Both"
    end
    local delay = mRand(0.05, 0.45)

    timer.Simple(delay, function()
        if not IsValid(self) then return end

        if self.RANDOMS_DEBUG then
            print("[PANIC IN DMGA - Helper Triggered]")
        end

        self:Handle_ScheduledForceMove(
            aiType,         -- useDefAi
            coverType,      -- coverType
            "Both",         -- canShoot
            "Run",          -- moveType (panic = always run)
            true           
        )

        self.Panic_DmgEne_NextT = CurTime() + mRand(1, 5)
    end)

    return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
local dmgScales = {
    [DMG_SLASH] = {0.75, 0.95},
    [DMG_DIRECT] = {0.75, 0.95},
    [DMG_CLUB] = {0.75, 0.95},
    [DMG_ACID] = {0.85, 0.9},
    [DMG_DISSOLVE] = {0.85, 0.9},
    [DMG_CRUSH] = {1.55, 1.85},
    [DMG_VEHICLE] = {1.5, 1.95},
    [DMG_BURN] = {0.9, 1.25},
    [DMG_SLOWBURN] = {0.9, 1.25},
    [DMG_ALWAYSGIB] = {0.9, 1.25},
    [DMG_BLAST] = {1.65, 2.55},
    [DMG_BUCKSHOT] = {0.75, 0.95},
    [DMG_BULLET] = {0.75, 0.95}
}

local LIMB_HITGROUPS = {
    [HITGROUP_STOMACH]  = true,
    [HITGROUP_RIGHTLEG] = true,
    [HITGROUP_LEFTLEG]  = true,
    [HITGROUP_RIGHTARM] = true,
    [HITGROUP_LEFTARM]  = true,
    [HITGROUP_CHEST]    = true,
    [HITGROUP_GEAR]     = true,
}

function ENT:MngDmgTypeScales(dmginfo, hitgroup)
    if not self.HasRngDmgScale or not self:Alive() or self.IsCurrentlyIncapacitated then return end

    local dmgType = dmginfo:GetDamageType()
    local pr = self.RANDOMS_DEBUG
    local initial = dmginfo:GetDamage()
    local cv_heavyIgnoreMelee = GetConVar("vj_stalker_heavy_ign_melee")

    local function dbg(msg)
        if pr then print(msg) end
    end

    if self.IsScientific then
        if bit.band(dmgType, bit.bor(DMG_BURN, DMG_SLOWBURN)) ~= 0 then
            dmginfo:ScaleDamage(0.2)
            dbg(("Fire (Scientific): %.2f -> %.2f"):format(initial, dmginfo:GetDamage()))
            return
        elseif bit.band(dmgType, bit.bor(DMG_SHOCK, DMG_DISSOLVE)) ~= 0 then
            dmginfo:ScaleDamage(0.1)
            dbg(("Shock (Scientific): %.2f -> %.2f"):format(initial, dmginfo:GetDamage()))
            return
        elseif bit.band(dmgType, DMG_BLAST) ~= 0 then
            dmginfo:ScaleDamage(0.5)
            dbg(("Blast (Scientific): %.2f -> %.2f"):format(initial, dmginfo:GetDamage()))
            return
        end
    end

    if self.IsHeavilyArmored then
        if bit.band(dmgType, bit.bor(DMG_BURN, DMG_SLOWBURN)) ~= 0 then
            dmginfo:ScaleDamage(0.5)
            dbg(("Fire (Heavy): %.2f -> %.2f"):format(initial, dmginfo:GetDamage()))
            return
        elseif bit.band(dmgType, DMG_BLAST) ~= 0 then
            dmginfo:ScaleDamage(0.2)
            dbg(("Blast (Heavy): %.2f -> %.2f"):format(initial, dmginfo:GetDamage()))
            return
        elseif bit.band(dmgType, bit.bor(DMG_SLASH, DMG_CLUB)) ~= 0 then
            if cv_heavyIgnoreMelee and cv_heavyIgnoreMelee:GetBool() then
                dmginfo:SetDamage(0)
                return true
            end
            dmginfo:ScaleDamage(0.45)
            dbg(("Melee (Heavy): %.2f -> %.2f"):format(initial, dmginfo:GetDamage()))
            return
        elseif bit.band(dmgType, bit.bor(DMG_ACID, DMG_RADIATION, DMG_POISON, DMG_NERVEGAS, DMG_PARALYZE)) ~= 0 then
            dmginfo:ScaleDamage(0.8)
            dbg(("Toxic (Heavy): %.2f -> %.2f"):format(initial, dmginfo:GetDamage()))
            return
        end
    end

    if self.HasBulletDmgScale and dmginfo:IsBulletDamage() then
        local scale;
        if LIMB_HITGROUPS[hitgroup] and mRng(1, 3) == 1 then
            scale = mRand(0.2, 0.3)
            dbg(("Bullet Limb Reduce: %.2f -> %.2f (%.2fx)"):format(initial, initial * scale, scale))
        else
            scale = mRand(0.75, 0.95)
            dbg(("Bullet Scale: %.2f -> %.2f (%.2fx)"):format(initial, initial * scale, scale))
        end

        dmginfo:ScaleDamage(scale)
        return
    end

    for dtype, range in pairs(dmgScales) do
        if bit.band(dmgType, dtype) ~= 0 then
            local scale = mRand(range[1], range[2])
            dmginfo:ScaleDamage(scale)
            dbg(("Fallback %s: %.2f -> %.2f"):format(dtype, initial, dmginfo:GetDamage()))
            return
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DamagedByShockFx(dmginfo)
    if not self.HasShockDmgFx then return end 
    
    local conv = GetConVar("vj_stalker_shock_dmg_fx")
    if not conv or conv:GetInt() ~= 1 then return end 

    if not dmginfo:IsDamageType(DMG_SHOCK) then return end 

    local curT = CurTime()
    if curT < (self.NextShockFxT or 0) then return end

    local shockChance = tonumber(self.ShockDmgFxChance) or 2 
    if mRng(1, shockChance) ~= 1 then return end 

    local stunDuration = mRand(0.5, 6.5) 
    self.NextShockFxT = curT + stunDuration + 1 

    local entIndex = self:EntIndex()
    local endTime = curT + stunDuration

    local sharedRng = mRng(1, 5)
    local tesla = EffectData()
    tesla:SetEntity(self)
    tesla:SetMagnitude(sharedRng)
    tesla:SetScale(sharedRng)
    tesla:SetRadius(sharedRng)

    local function PlayShockLogic()
        if not IsValid(self) or not self:Alive() or CurTime() > endTime then 
            timer.Remove("ShockEffect_" .. entIndex)
            return 
        end

        local snd = self:GetRandomValidValue(self.EnergyZap_Tbl)
        if snd then 
            VJ.EmitSound(self, snd, 75, mRng(85, 110))
        end 
        self:AddGesture(ACT_GESTURE_FLINCH_HEAD)
        util.Effect("TeslaHitBoxes", tesla, true, true)

        local conv = GetConVar("vj_stalker_shock_dmg_fx_cheap")
        if not conv or conv:GetInt() ~= 1 then return end 

        local sparkOrigin = self:GetPos() + self:GetUp() * mRng(5, 75) + VectorRand() * 55
        local rngScle = mRng(0.05, 0.5)
        local cball = EffectData()
        cball:SetOrigin(sparkOrigin)
        cball:SetScale(rngScle) 
        util.Effect("cball_explode", cball)
    end

    timer.Create("ShockEffect_" .. entIndex, mRand(0.05, 0.55), 0, function()
        PlayShockLogic()
        if IsValid(self) then
            timer.Adjust("ShockEffect_" .. entIndex, mRand(0.05, 0.55))
        end
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LandingOnGround_Anim = "jump_holding_land"
ENT.LandOnGround_SoundTbl = {"general_sds/land_sound/jumplanding.wav","general_sds/land_sound/jumplanding2.wav","general_sds/land_sound/jumplanding3.wav","general_sds/land_sound/jumplanding4.wav","general_sds/land_sound/landing.mp3"}


function ENT:DetectLanding()
    if not self.Detect_LandAnim then return end 
    if self.IsLanding then return end 

    local cT = CurTime()
    if not IsValid(self) or cT < (self.NextLandAnimCheckT) then
        return
    end

    local landAnim = self:GetRandomValidValue(self.LandingOnGround_Anim)
    if not landAnim then return end 
    
    local seq = self:GetSequence()
    local currentSequence = seq and self:GetSequenceName(seq) or ""
    local landDuration = self:SequenceDuration(self:LookupSequence(landAnim))  or 1 

    if currentSequence == landAnim or self:GetActivity() == ACT_LAND then
        self.IsLanding = true  

        local rngSnd = mRng(75, 115)
        local rngVol = mRng(65, 80)
        
        local landSnds = self:GetRandomValidValue(self.LandOnGround_SoundTbl)
        if landSnds then 
            VJ.EmitSound(self, landSnds, rngVol, rngSnd)
        end 

        local gruntSnd = self:GetRandomValidValue(self.JumpLandGruntTbl)
        if gruntSnd and mRng(1, 2) == 1 then 
            VJ.EmitSound(self, gruntSnd, rngVol, rngSnd)
        end 

        local myPos = self:GetPos()
        local isInWater = bit.band(util.PointContents(myPos), CONTENTS_WATER) == CONTENTS_WATER
        local conv = GetConVar("vj_stalker_jump_land_particles"):GetInt() 
        local pcfxScale = tonumber(self.Landing_FxScale) or 60 

        if conv == 1 then 
            if not self:ValidBreakableMats(self:GetPos()) then return end 
            if self.Landing_Effects and self.IsLanding and not isInWater then
                local ed = EffectData()
                if self.LargeLandFx then 
                    ed:SetOrigin(myPos)
                    ed:SetScale(pcfxScale)
                    util.Effect("ThumperDust", ed) 
                else 
                    ed:SetOrigin(myPos)
                    util.Effect("vj_randoms_dust_land_small", ed)  
                end      
            end  
        end 
        timer.Simple(landDuration, function()
            if IsValid(self) then
                self.IsLanding = false
            end
        end)
    end
    self.NextLandAnimCheckT = CurTime() + mRand(0.1, 0.2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasExtraForceStrafeFire = false  
ENT.ExForceStrafeFireChance = 5
ENT.NextForceFireStrafeT = 0 
ENT.IsCrouchFiring = false

function ENT:OnWeaponStrafe()
    if self.VJ_IsBeingControlled or not IsValid(self) then return end 

    if mRng(1,2) == 1 and not self.IsCrouchFiring then
        self.IsCrouchFiring = true
    else
        self.IsCrouchFiring = false
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Danger_DetectSiganlT = 0
function ENT:OnDangerDetected(dangerType, data)
    self:Handle_IsPanickingState()
end

function ENT:Handle_IsPanickingState()
    if not self.CanDetectDangers then return end 

    local shareDel = mRand(1, 5) or 3 
    local curT = CurTime()

    if self.HasDetectDangerAnim then 
        local animChance = self.DetectDangerAnimChance or 3
        if curT > self.Danger_DetectSiganlT and  mRng(1, animChance) == 1 then
            local gestureSignal = self:GetRandomValidValue(self.DetectDangerReactAnim)
            if gestureSignal then 
                self:PlayAnim("vjges_" .. gestureSignal, false) 
                self.Danger_DetectSiganlT = curT + mRand(1, 10)
            end 
        end 
    end 

    if self.IsDetectingDanger or mRng(1, 2) ~= 1 then return end
    self.IsDetectingDanger = true

    local panicDuration = self.IsPanickedStateT + mRand(3, 6)
    timer.Simple(panicDuration, function()
        if not IsValid(self) then return end
        self.IsDetectingDanger = false
        self.NextDangerDetectionT = curT + mRand(1, 2)
        self.NextChaseTime = curT + shareDel * 2 
        self.TakingCoverT = curT + shareDel
    end)
end 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanTakeCovSigAnim = true
ENT.SignalTakeCover_FlwPlyChance = 4 
ENT.NextTakeCovSigCrouchT = 0
function ENT:OnChangeActivity(newAct)
    if newAct == ACT_IDLE then
        local allyCheckDist = self.FindAllyDistance / 3
        local getAllies = self:Allies_Check(allyCheckDist)
        local curT = CurTime() 
        local chance = tonumber(self.SignalTakeCover_FlwPlyChance) or 4 
        if self.CanTakeCovSigAnim and self.Copy_IsCrouching and getAllies and
            mRng(1, chance) == 1 and
            not self:IsBusy("Activities") and curT > self.NextTakeCovSigCrouchT then
            
            self:RemoveAllGestures()
            timer.Simple(mRand(0.25, 0.5), function()
                if IsValid(self) then
                    self:PlayAnim("vjges_gesture_signal_takecover")
                end
            end)
            self.NextTakeCovSigCrouchT = curT + mRand(5, 10) 
        else
            self.NextTakeCovSigCrouchT = curT + mRand(1, 5)
        end
    end 

    local jumpGrnt = VJ.PICK(self.JumpGruntTbl)
    local landGrnt = VJ.PICK(self.JumpLandGruntTbl)
    if newAct == ACT_JUMP then
        if mRng(1, 2) == 1 and self.Jump_GruntSounds and jumpGrnt then 
            timer.Simple(mRand(0.15, 0.25), function()
                if IsValid(self) then
                    self:PlaySoundSystem("Speech", jumpGrnt)
                end
            end)
        end 
    end

    if newAct == ACT_LAND then
        if mRng(1, 2) == 1 and self.Jump_LandGruntSounds and landGrnt then 
            timer.Simple(mRand(0.25, 0.5), function()
                if IsValid(self) then
                    self:PlaySoundSystem("Speech", landGrnt)
                end
            end)
        end 
    end

    return self.BaseClass.OnChangeActivity(newAct)
end

ENT.Copy_PlyCrouchStance = true 
ENT.Copy_IsCrouching = false
ENT.Copy_NextShiftT = 0  

function ENT:CopyPlayerStance() 
    if not self.Copy_PlyCrouchStance then return end
    if not self.IsFollowing then return end 

    local followData = self.FollowData
    if not followData then return end
    local followEnt = followData.Target
    local disp = self:Disposition(followEnt)

    if not IsValid(followEnt) or not followEnt:IsPlayer() or not followEnt:Alive() then return end
    if not followEnt:IsOnGround() or disp ~= D_LI or self:IsBusy("Activities") then return end

    local canSeePly = self:Visible(followEnt)
    local plyIsCrouching = followEnt:Crouching()  
    local canCrouch = self:IsOnGround() and not self:IsUnreachable(followEnt)
    self.Copy_IsCrouching = plyIsCrouching and canSeePly and canCrouch
end

ENT.CrouchActs = {
    [ACT_WALK_CROUCH] = true,
    [ACT_RUN_CROUCH] = true,
    [ACT_COVER] = true,
    [ACT_WALK_CROUCH_RIFLE] = true,
    [ACT_RUN_CROUCH_RIFLE] = true,
    [ACT_RUN_CROUCH_AIM] = true,
    [ACT_RUN_CROUCH_AIM_RIFLE] = true,
    [ACT_WALK_CROUCH_AIM] = true,
    [ACT_WALK_CROUCH_RPG] = true,
}

function ENT:OnFootstepSound(moveType, sdFile)
    if moveType == "Walk" or moveType == "Run" or moveType == "Event" then 
        
        if self._OrigSoundTbl_FootStep == nil and self.SoundTbl_FootStep then
            self._OrigFootstepSoundState = self.SoundTbl_FootStep
        end

        if self.CrouchMovement and self.SoundTbl_FootStep ~= self.Footstep_Sneaking then
            if self.RANDOMS_DEBUG then print("Now wea are using sneak specific footstep sounds!!") end 
            self.SoundTbl_FootStep = self.Footstep_Sneaking 
            return true 
        else
            self.SoundTbl_FootStep = self._OrigFootstepSoundState
        end

        self:Dynamic_FeetSteps()
    end 
end

function ENT:StealthMovement()
    if not IsValid(self) then return end
    local act = self:GetActivity()
    local seq = self:GetSequence()
    local isCrouching = false

    if act and self.CrouchActs[act] then
        isCrouching = true
    else
        if seq then
            local seqInfo = self:GetSequenceActivity(seq)
            if seqInfo and self.CrouchActs[seqInfo] then
                isCrouching = true
            end
        end
    end

    -- update only when changed
    if self.CrouchMovement ~= isCrouching then
        self.CrouchMovement = isCrouching
        if self.RANDOMS_DEBUG then 
            print(self, "CrouchMovement =>", tostring(isCrouching))
        end 
    end
end

//ENT.UseCrouchIdleAnim = true 
//Ill fix this later.
ENT.Play_PeekupAnim = true 
ENT.Play_PeekupAnimChance = 4
ENT.PeekUpAnim = "crouch_peek_up_cmb_b"
ENT.NextPeekUpT = 0
ENT.Idle_CoverActs = {[ACT_COVER] = true, [ACT_COVER_LOW] = true, [ACT_HL2MP_IDLE_CROUCH_PASSIVE] = true, [ACT_COVER_LOW_RPG] = true, [ACT_COVER_SMG1_LOW] = true}

function ENT:Idle_CoverPeekUp()
    if not self.Play_PeekupAnim then return end
    if self.VJ_IsBeingControlled then return end
    if not self:IsOnGround() then return end
    if self:IsMoving() then return end
    if self:IsBusy() or self:IsVJAnimationLockState() or self.Flinching then return end
    if self:GetNPCState() ~= NPC_STATE_IDLE then return end
    if CurTime() < self.NextPeekUpT then return end

    local delayT = mRand(5, 30)

    local anim = self.PeekUpAnim
    if not anim or anim == "" then
        self.NextPeekUpT = CurTime() + delayT
        return
    end

    local seqPeek = self:LookupSequence(anim)
    if not seqPeek or seqPeek < 0 then 
        self.NextPeekUpT = CurTime() + delayT
        return 
    end

    local seq = self:GetSequence()
    if not seq or seq < 0 then
        self.NextPeekUpT = CurTime() + delayT
        return
    end

    local activity = self:GetSequenceActivity(seq)
    if not activity or activity < 0 then
        self.NextPeekUpT = CurTime() + delayT
        return
    end

    if not self.Idle_CoverActs[activity] then
        self._PeekEnteredCoverT = 0
        return
    end

    if self._PeekEnteredCoverT == 0 then
        self._PeekEnteredCoverT = CurTime()
        if self.RANDOMS_DEBUG then
            print("[PeekUp] Entered cover, starting delay...")
        end
        return
    end

    if CurTime() < (self._PeekEnteredCoverT + (self.PeekUpDelay or 1)) then
        return
    end

    if mRng(1, self.Play_PeekupAnimChance or 3) ~= 1 then
        self.NextPeekUpT = CurTime() + delayT
        return
    end

    local dur = self:SequenceDuration(seqPeek)
    if not dur or dur <= 0 then
        self.NextPeekUpT = CurTime() + delayT
        return
    end

    self.NextPeekUpT = CurTime() + dur + delayT
    self:RemoveAllGestures()
    self:StopMoving()
    self:PlayAnim(anim, true, dur, false, {OnFinish = function(interrupted, animName)end})
end


function ENT:TranslateActivity(act)
    local ene = self:GetEnemy() 
    local moveFireConv = GetConVar("vj_stalker_crouch_move_firing"):GetInt()
    if self.IsCrouchFiring and self.Weapon_CanMoveFire and IsValid(ene) then
        if (moveFireConv and moveFireConv == 1) and self.Weapon_CanMoveFire and IsValid(ene) and (self.EnemyData.Visible or (self.EnemyData.VisibleTime + 5) > CurTime()) and self.CurrentSchedule and self.CurrentSchedule.CanShootWhenMoving and self:CanFireWeapon(true, false) then
            self.WeaponAttackState = VJ.WEP_ATTACK_STATE_FIRE
            if act == ACT_WALK then
                return self:TranslateActivity(act == ACT_WALK and ACT_WALK_CROUCH_AIM)
            elseif act == ACT_RUN then
                return self:TranslateActivity(act == ACT_RUN and ACT_RUN_CROUCH_AIM)
            end
        end
    end

    if self.Copy_PlyCrouchStance then 
        if act == ACT_IDLE and act ~= ACT_COVER then
            if self.Copy_IsCrouching then 
                return ACT_COVER
            end 
        elseif act == ACT_RUN and (act ~= ACT_RUN_CROUCH or act ~= ACT_WALK_CROUCH_AIM) then
            if self.Copy_IsCrouching then 
                return ACT_RUN_CROUCH or ACT_WALK_CROUCH_AIM  
            end 
        elseif act == ACT_WALK and act ~= ACT_WALK_CROUCH then
            if self.Copy_IsCrouching then 
                return ACT_WALK_CROUCH 
            end 
        end 
    end
      

	if self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) then
		return ACT_BARNACLE_PULL 
    end 

    if self.IsHeavilyArmored and self.HasSlowHeavyMovement then 
        if act == ACT_WALK then 
            return self:TranslateActivity(act == ACT_WALK and act == ACT_WALK_AIM)
        elseif act == ACT_RUN then 
            self.FootstepSoundTimerRun = self.FootstepSoundTimerWalk 
            return ACT_WALK
        end 
    end 

    if self.IsDetectingDanger then 
        if act == ACT_RUN then
            return self:TranslateActivity(act == ACT_RUN and ACT_RUN_PROTECTED or ACT_RUN_CROUCH)
        end
    end 

    if act == ACT_IDLE and not self:OnGround() and not self:IsMoving() then
        return self:TranslateActivity(act == ACT_IDLE and ACT_GLIDE)
    end

    -- // [Yoinked from human base] \\ --
    //VJ.DEBUG_Print(self, "TranslateActivity", act)
	local selfData = self:GetTable()
	-- Handle idle scared and angry animations
	if act == ACT_IDLE then
		if selfData.Weapon_UnarmedBehavior_Active then
			//return PICK(selfData.AnimTbl_ScaredBehaviorStand)
			return ACT_COWER
		elseif selfData.Alerted && self:GetWeaponState() != VJ.WEP_STATE_HOLSTERED && IsValid(self:GetActiveWeapon()) then
			//return PICK(selfData.AnimTbl_WeaponAim)
			return ACT_IDLE_ANGRY
		end
	-- Handle running while scared animation
	elseif act == ACT_RUN && selfData.Weapon_UnarmedBehavior_Active && !selfData.VJ_IsBeingControlled then
		// PICK(selfData.AnimTbl_ScaredBehaviorMovement)
		return ACT_RUN_PROTECTED
	elseif (act == ACT_RUN or act == ACT_WALK) && selfData.Alerted then
		-- Handle aiming while moving animations
		local eneData = selfData.EnemyData
		if selfData.Weapon_CanMoveFire && IsValid(eneData.Target) && (eneData.Visible or (eneData.VisibleTime + 5) > CurTime()) && selfData.CurrentSchedule && selfData.CurrentSchedule.CanShootWhenMoving && self:CanFireWeapon(true, false) then
			local anim = self:TranslateActivity(act == ACT_RUN and ACT_RUN_AIM or ACT_WALK_AIM)
			if VJ.AnimExists(self, anim) then
				if eneData.Visible then
					selfData.WeaponAttackState = VJ.WEP_ATTACK_STATE_FIRE
				else -- Not visible but keep aiming
					selfData.WeaponAttackState = VJ.WEP_ATTACK_STATE_AIM_MOVE
				end
				return anim
			end
		end
		-- Handle walk/run angry animations
		local anim = self:TranslateActivity(act == ACT_RUN and ACT_RUN_AGITATED or ACT_WALK_AGITATED)
		if VJ.AnimExists(self, anim) then
			return anim
		end
	end

    	-- Handle translations table
	local translation = selfData.AnimationTranslations[act]
	if translation then
		if istable(translation) then
			if act == ACT_IDLE then
				return self:ResolveAnimation(translation)
			end
			return translation[mRng(1, #translation)] or act -- "or act" = To make sure it doesn't return nil when the table is empty!
		end
		return translation
	end
    return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AtVeryLowHealth = false
ENT.CanBecomeDefensiveAtLowHP = false
function ENT:DefensiveWhenLowHealth()
    if not self.CanBecomeDefensiveAtLowHP then return end 
    if not self:Alive() then return end 
    if not IsValid(self) or self.CombatChaseSateGreen then return end

    local defRetDist = self.Weapon_RetreatDistance
    local defChaseEne = self.DisableChasingEnemy
    local defOcDelay = self.Weapon_OcclusionDelayMinDist
    local health = self:Health()
    local maxHealth = self:GetMaxHealth()
    local lowHealthThreshold = maxHealth * mRand(0.3, 0.45)

    if health <= lowHealthThreshold then
        self.Weapon_OcclusionDelayMinDist = 1
        self.AtVeryLowHealth = true
        self.Weapon_RetreatDistance = defRetDist * mRand(1.5, 2.5)
        if not defChaseEne then 
            self.DisableChasingEnemy = true 
        end 
    else
        self.AtVeryLowHealth = false
        self.Weapon_RetreatDistance = defRetDist
        self.Weapon_OcclusionDelayMinDist = defOcDelay
        if defChaseEne then 
            self.DisableChasingEnemy = false 
        end 
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Avoid_C_Hair = true 
ENT.AvoidingC_Hair = false 
ENT.Avoid_C_HairNextT = 0
ENT.Avoid_C_HairMinDist = 850
ENT.Avoid_C_HairGesAnim = true 
ENT.Avoid_C_HairGesTbl = {"gesture_signal_takecover","gesture_signal_right","gesture_signal_left","gesture_signal_forward"}
ENT.Avoid_C_HairGesChance = 3
function ENT:Avoid_PlyCrosshair()
    if not self.Avoid_C_Hair then return end 
    if self.AvoidingC_Hair then return end 

    local crossConv = GetConVar("vj_stalker_avoid_ply_crosshair"):GetInt()
    if not crossConv or crossConv ~= 1 then return end

    local ai_Conv = GetConVar("ai_ignoreplayers"):GetBool()
    if ai_Conv == 1 or VJ_CVAR_IGNOREPLAYERS then return end 

    if self.VJ_IsBeingControlled then return end 

    local busy = self:IsVJAnimationLockState() or self:IsBusy("Activities") or self.CurrentlyHealSelf or self.IsHumanDodging or self.Flinching
    local curT = CurTime()
    
    if not self:IsOnGround() then return end 
    if not self:IsAbleToMoveNow() then return end 

    if busy or 
        self:GetNPCState() == NPC_STATE_IDLE or   
        self:GetWeaponState() == VJ.WEP_STATE_RELOADING or
        (self.Avoid_C_HairNextT and self.Avoid_C_HairNextT > curT) then
        return  
    end

    for _, ply in ipairs(player.GetAll()) do

        local ene = self:GetEnemy()
        local dis = self:Disposition(ply)

        if IsValid(ene) and ene ~= ply then return end

        if ply:Alive() and IsValid(ply) and (dis == D_HT or dis == D_FR) and not self:IsMoving() and not self.CurrentSchedule then

            local minDist = tonumber(self.Avoid_C_HairMinDist) or 1500
            local dist = self:GetPos():Distance(ply:GetPos())
            local trace = ply:GetEyeTrace()

            local tr = util.TraceLine({
            start = ply:EyePos(),
            endpos = self:WorldSpaceCenter(),
            filter = {ply, self}
            })

            if tr.Hit and tr.Entity ~= self then 
                return false
            end

            if trace.Entity == self and dist >= minDist then
                self:ClearSchedule()
                self:RemoveAllGestures()

                if self.RANDOMS_DEBUG then 
                    print("I'm moving to avoid the players crosshari!")
                end 

                self.AvoidingC_Hair = true
                self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH", function(x)
                    x.DisableChasingEnemy = false
                    if mRng(1,2) == 1 then
                        x.CanShootWhenMoving = true   
                        x.TurnData = {Type = VJ.FACE_ENEMY}
                    else
                        x.CanShootWhenMoving = false  
                        x.TurnData = {Type = VJ.FACE_NONE, Target = nil}
                    end
                    x.RunCode_OnFail = function()
                        self.NextDoAnyAttackT = 0
                    end
                    self:GestureSignalAnimHelper()
                end)
                self.TakingCoverT = curT + mRand(1, 5)
                self.NextChaseTime = curT + mRand(1, 5)
                self.Avoid_C_HairNextT = curT + mRand(1.25, 10.25) 
                break
            end
        end
    end
    self.AvoidingC_Hair = false
end

function ENT:GestureSignalAnimHelper()
    if not self.Avoid_C_HairGesAnim then return end 
    if self:IsBusy("Activities") then return end 

    local gesChance = self.Avoid_C_HairGesChance or 3 


    local gesAnim = self:GetRandomValidValue(self.Avoid_C_HairGesTbl)
    if not gesAnim then return end

    local sigAnims = {2146, 2147, 2148, 2149, 2150, 2151, 2152}
    for _, act in ipairs(sigAnims) do
        if self:IsPlayingGesture(act) then return end
    end

    if mRng(1, gesChance) ~= 1 then return end 
    self:PlayAnim("vjges_" .. gesAnim, false) 
end 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanFireQuickFlare() 
    if not self.AllowedToLaunchQuickFlare then return false end 

    local conv = GetConVar("vj_stalker_fire_quick_flares")
    if conv:GetInt() ~= 1 then return false end

    if self.IsFiringQuickFlare then return false end 
    if self:IsBusy() or self.VJ_IsBeingControlled or self:IsVJAnimationLockState() or self.Flinching or self.PauseAttacks then return false end
    if self:GetWeaponState() == VJ.WEP_STATE_RELOADING then return false end 
    
    local enemy = self:GetEnemy()
    if not IsValid(enemy) then return false end

    local pos = self:GetPos() + self:OBBCenter()
    local enePos_Eye = enemy:EyePos()
    local wep = self:GetActiveWeapon()
    if not IsValid(wep) then return false end

    local wepInCover = self:DoCoverTrace(wep:GetBulletPos(), enePos_Eye, false)
    if wepInCover then 
        return false 
    end

    if self.IsHoldingSecondaryWeapon then return false end
    if self.WeaponAttackState == VJ.WEP_ATTACK_STATE_FIRE_STAND or self.DoingWeaponAttack then return false end
    
    if wep.IsMeleeWeapon or wep.HoldType == "pistol" or wep.HoldType == "revolver" or wep.HoldType == "rpg" then return false end

    local distanceToEnemy = self:GetPos():Distance(enemy:GetPos())
    if distanceToEnemy < self.FireQuickFlareMin or distanceToEnemy >= self.FireQuickFlareMax then return false end

    local cT = CurTime()
    if cT < (self.NextFireQuickFlareT or 0) then
        self.FireQuickFlareAttemptChecked = false
        return false
    end

    if not self.FireQuickFlareAttemptChecked then
        self.FireQuickFlareAttemptChecked = true
        if mRng(1, self.FireFlareFromGunChance) ~= 1 then
            self.NextFireQuickFlareT = cT + mRand(50, 300) 
            return false
        end
    end

    if self.AttackType or cT < self.TakingCoverT then return false end

    return true, enemy, distanceToEnemy
end


function ENT:FireQuickFlare()
    local canFire, enemy, distToEnemy = self:CanFireQuickFlare()
    if not canFire then return end

    local aimPos
    local eneData = self.EnemyData or {}
    local cT = CurTime()
    local vec = Vector(mRand(-30, 30), mRand(-30, 30), 0)
    
    if self:Visible(enemy) then
        aimPos = enemy:GetPos() + vec
    elseif self:VisibleVec(eneData.VisiblePos) and enemy:GetPos():Distance(eneData.VisiblePos) <= self.FireQuickFlareMax and self.FireQuickFlareAtLastEnePos then
        aimPos = eneData.VisiblePos + vec
    else
        self.NextFireQuickFlareT = cT + mRand(5, 15)
        return
    end

    self.IsFiringQuickFlare = true
    local fireAnim = self:GetRandomValidValue(self.AnimTbl_WeaponAttackSecondary)
    if not fireAnim then return end 

    local seq = self:LookupSequence(fireAnim)
    if not seq or seq < 0 then return end 

    local fireT = self:SequenceDuration(seq) or 1 
    self:PlayAnim(fireAnim, true, fireT, true)
    self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, fireT)

    timer.Simple(mRand(0.855, 0.975), function()
        if not IsValid(self) or not IsValid(enemy) then
            self.IsFiringQuickFlare = false
            return
        end

        local flareEnt = ents.Create("obj_vj_flareround")
        if not IsValid(flareEnt) then
            self.IsFiringQuickFlare = false
            return
        end

        local throwPos = self:GetPos() + self:GetUp() * 50 + self:GetForward() * 20
        local throwDirection = (aimPos - throwPos):GetNormalized()

        local baseForce = 5000
        local additionalForwardForce = (distToEnemy / 850) * mRand(100, 155)
        local totalForwardForce = baseForce + additionalForwardForce

        local baseUpwardForce = 50
        local additionalUpwardForce = (distToEnemy / 850) * mRand(100, 250)
        local totalUpwardForce = baseUpwardForce + additionalUpwardForce

        local throwForce = throwDirection * totalForwardForce + Vector(0, 0, totalUpwardForce)

        flareEnt:SetPos(throwPos)
        flareEnt:SetAngles((aimPos - throwPos):Angle())
        flareEnt:Spawn()
        flareEnt:Activate()

        local phys = flareEnt:GetPhysicsObject()
        if IsValid(phys) then
            phys:ApplyForceCenter(throwForce)
            phys:EnableDrag(false)
            phys:EnableGravity(true)
            phys:SetMass(10)

            local forceTimerName = "FlareForceTimer_" .. flareEnt:EntIndex()
            local forceCount = 0
            timer.Create(forceTimerName, 0.1, 5, function()
                if IsValid(flareEnt) and IsValid(phys) then
                    forceCount = forceCount + 1
                    local continuousForce = throwForce * (1 - (forceCount * 0.15))
                    phys:ApplyForceCenter(continuousForce * 0.2)
                else
                    timer.Remove(forceTimerName)
                end
            end)
        end
        self.IsFiringQuickFlare = false
        self.NextFireQuickFlareT = cT + mRand(90, 175)
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayerSight(ent)
    self:Handle_PlySpotAnim(ent)
end 

function ENT:Handle_PlySpotAnim(ent)
        if self.SpotFr_PlyAnim then 
        if VJ_CVAR_IGNOREPLAYERS then return end
        local friendlyConVar = GetConVar(tostring(self.FriendlyConvar)):GetInt()
        if not friendlyConVar or friendlyConVar ~= 1 then return end

        if self.IsFollowing or self.FollowingPlayer then return end 
        if self.VJ_IsBeingControlled then return end 

        if self:GetNPCState() ~= NPC_STATE_IDLE then return end 

        local cT = CurTime()
        if cT < (self.SpotFr_PlyAnimNextT or 0) then return end

        local ene = self:GetEnemy()
        local busy = self:IsBusy() or self:IsVJAnimationLockState() or self.Flinching
        local disp = self:Disposition(ent)

        if ent:IsPlayer() and disp == D_LI and self:Visible(ent) then 
            if self:GetWeaponState() == VJ.WEP_STATE_RELOADING or self.WeaponAttackState == VJ.WEP_ATTACK_STATE_FIRE_STAND or self.Medic_Status or IsValid(ene) or busy or not self:IsOnGround() then
                return 
            end
            
            local playedAnim = false
            local eneIdleCheck = not IsValid(ene) and (not ent:IsNPC() or not IsValid(ent:GetEnemy()))
            local rngDel = mRand(0.15, 0.65)

            local state = self:GetNPCState()
            if state == NPC_STATE_COMBAT or state == NPC_STATE_ALERT then return end 

            local animChance = tonumber(self.SpotFr_PlyAnim_Chance) or 10 
            if mRng(1, animChance) == 1 then
                self:RemoveAllGestures()
                timer.Simple(rngDel, function()
                    if IsValid(self) then
                        if busy then return end 

                        local seq = self:GetSequence()
                        local activity = self:GetSequenceActivity(seq)
                        if self.Idle_CoverActs[activity] then return end -- Stop annoying bug where if idly crouched, we stand up to greet player and snap back to crouching.
 
                        local seqSpotAnim = self:GetRandomValidValue(self.SpotFr_PlyAnim_SeqTbl)
                        local aT = self:SequenceDuration(self:LookupSequence(seqSpotAnim)) or 1 

                        if seqSpotAnim then
                            self:StopMoving()
                            self:SetTarget(ent)
                            self:SCHEDULE_FACE("TASK_FACE_TARGET")
                            self:PlayAnim("vjseq_" .. seqSpotAnim, true, aT, false) 
                            if self.RANDOMS_DEBUG then 
                                print("On spot player, we are playing a sequence animation!")
                            end 
                            playedAnim = true 
                        end
                    end
                end)
            else
                if mRng(1, animChance / 2) == 1 then
                    self:RemoveAllGestures()
                    timer.Simple(rngDel, function()
                        if IsValid(self) then
                            if busy then return end 
                            local gesPlySpotAnim = {"vjges_g_wave"}
                            if gesPlySpotAnim then
                                self:SetTarget(ent)
                                self:SCHEDULE_FACE("TASK_FACE_TARGET")
                                self:PlayAnim(gesPlySpotAnim, false)
                                playedAnim = true 
                                if self.RANDOMS_DEBUG then 
                                    print("Spotted player, we are playing a gesture animation!")
                                end 
                            end
                        end
                    end)
                end
            end

            if playedAnim then
                self.SpotFr_PlyAnimNextT = cT + mRng(150, 200)
            end
        end
    end
end 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.FollowPly_Reaction = true 
ENT.FollowPly_ReactChance = 3 
ENT.FollowPly_ReactTbl = {"hg_nod_yes", "hg_nod_right", "hg_nod_no", "hg_nod_left", "hg_headshake","g_palm_up_l", "g_palm_up_l_high", "g_present", "g_point_swing", "g_point_swing_across","g_palm_out_high_l", "g_palm_out_l", "g_palm_up_high_l", "g_palm_up_l","g_plead_01_l", "g_fist_l"}
ENT.FollowPly_ReactNextT = 0 

function ENT:OnFollow(status, ent)
    self:React_ToPlyFollow(status, ent)
end

function ENT:React_ToPlyFollow(state, entity)
    if not self.FollowPly_Reaction then return end
    if self:Health() <= 0 or not self:Alive() then return end
    if self.VJ_IsBeingControlled then return end 
    if not (state == "Start" or state == "Stop") then return end    
    local busy = self.Flinching or self:IsBusy() or self:IsVJAnimationLockState() 
    local ene = self:GetEnemy()
    
    if IsValid(ene) or self:GetNPCState() ~= NPC_STATE_IDLE then 
        return  
    end

    if not IsValid(self) or not IsValid(entity) or not self:Visible(entity) or 
       (entity:IsPlayer() and self:Disposition(entity) ~= D_LI) then
        return 
    end

    local reactAnim = self:GetRandomValidValue(self.FollowPly_ReactTbl)
    if not reactAnim then return end 

    local curT = CurTime()
    local chance = self.FollowPly_ReactChance or 2 
    if mRng(1, chance) == 1 and curT > (self.FollowPly_ReactNextT or 0) then
        self:RemoveAllGestures()
        local delay = mRand(0.65, 3)
        timer.Simple(delay, function()
            if not IsValid(self) or busy then return false end 
            self:PlayAnim("vjges_" .. reactAnim, false)
            if self.RANDOMS_DEBUG then 
                print("Playing " .. state .. " response anim!")
            end 
            self.FollowPly_ReactNextT = CurTime() + mRand(1, 5)
        end) 
    end 
end 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Fidget_AnimTbl = {"fidget_scratch_face","fidget_wipe_hand","fidget_wipe_face","fidget_stretch_neck","fidget_stretch_back","fidget_roll_shoulders","hg_turnr","hg_turnl","hg_turn_r","hg_turn_l"}
function ENT:Idle_FidgetAnim()
    if self.PlayFidgetAnims then
        if self.VJ_IsBeingControlled or IsValid(self:GetEnemy()) then return end

        local npcState = self:GetNPCState()
        if npcState ~= NPC_STATE_IDLE then return end

        if self:IsVJAnimationLockState() or self:IsBusy() or not self:IsOnGround() or self.CurrentSchedule or self.PlayingFidgetAnim or self.Flinching then
            return
        end

        local cT = CurTime()
        local chance = tonumber(self.IdleFidgetChance) or 3

        if cT > (self.FidgetAnimNextT or 0) then
            if mRng(1, chance) ~= 1 then
                self.FidgetAnimNextT = cT + mRand(5, 45)
                return
            end

            self:RemoveAllGestures()
            
            self.PlayingFidgetAnim = true
            timer.Simple(mRand(0.25, 1), function()
                if not IsValid(self) or self:IsBusy() then
                    self.PlayingFidgetAnim = false
                    return
                end

                local ene = self:GetEnemy() 
                if IsValid(ene) or not self:IsOnGround() then
                    self.PlayingFidgetAnim = false
                    return
                end

                local animSelected = self:GetRandomValidValue(self.Fidget_AnimTbl)
                if not animSelected then return end 

                local seq = self:LookupSequence(animSelected)
                local fidgetTime = self:SequenceDuration(seq)

                if seq and seq > 0 then 
                    self:PlayAnim("vjges_" .. animSelected, false)
                    local c = CurTime()
                    self.FidgetAnimNextT = c + mRand(5, 35) + fidgetTime
                    self.Dialogue_AnimNextT = c + mRand(5, 10)

                    timer.Simple(fidgetTime + 0.1, function()
                        if not IsValid(self) then return end
                        self.PlayingFidgetAnim = false
                        if IsValid(self:GetEnemy()) or (npcState == NPC_STATE_ALERT or npcState == NPC_STATE_COMBAT) then
                            self:RemoveAllGestures()
                        end
                    end)
                else
                    self.PlayingFidgetAnim = false 
                end
            end)
        end
    end
end 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnIdleDialogue(ent, status, statusData)
    self:Idle_TalkAnims(ent, status)
end 

function ENT:Idle_TalkAnims(npc, state)
    if not self.Dialogue_Anim then return end 
    if not (state == "Speak" or state == "Answer") then return end 
    if self.VJ_IsBeingControlled then return end 
    local nSt = self:GetNPCState()
    if nSt ~= NPC_STATE_IDLE then return end 
    
    if self:IsVJAnimationLockState() or self:IsBusy("Activities") or not IsValid(self) or not IsValid(npc) then 
        return 
    end

    local dialogueAnim = self:GetRandomValidValue(self.Dialogue_AnimTbl)
    if not dialogueAnim then return end 

    local curT = CurTime()
    local chance = tonumber(self.Dialogue_Anim_Chance) or 2 
    if mRng(1, chance) == 1 and curT > (self.Dialogue_AnimNextT or 0) then 
        if dialogueAnim then 
            local delay = mRand(0.15, 1.25)
            self:RemoveAllGestures()
            timer.Simple(delay, function()
                if IsValid(self) then 
                    self:PlayAnim("vjges_" .. dialogueAnim)
                    if self.RANDOMS_DEBUG then print("[Idle Dialogue]: We are playing the gesture animation - " .. tostring(dialogueAnim)) end
                    local dT = mRand(5, 10)
                    self.FidgetAnimNextT = curT + dT + 2
                    self.Dialogue_AnimNextT = curT + dT
                end
            end)
        end 
    end 
end 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInvestigate(ent)
    self:GestureAnimOnInvest()
end

function ENT:GestureAnimOnInvest()
    if not self.Investigate_HasAnimReact then return end 
    if self.VJ_IsBeingControlled or self:GetNPCState() ~= NPC_STATE_IDLE or not self:IsOnGround() then 
        return  
    end

    local busy = self:IsBusy() or self:IsVJAnimationLockState() or self.Flinching
    if busy then return end 

    local ene = self:GetEnemy()
    if IsValid(ene) then return end 

    local curT = CurTime()
    local chance = self.Investigate_AnimReactChance or 3

    if curT > self.Investigate_NextAnimT and mRng(1, chance) == 1 then
        self:RemoveAllGestures()
        timer.Simple(mRand(0.2,1), function()
            if IsValid(self) then
                local investAnim = self:GetRandomValidValue(self.Investigare_AnimReactTbl)
                if not investAnim then return end 
                self:PlayAnim("vjges_" .. investAnim, false)
                print("Investigate Anim")
                self.Investigate_NextAnimT = curT + mRand(5, 10)
            end
        end)
    end
end 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Idle_FindLoot()
    if not self.AllowedToLoot then return end
    
    local cvar = GetConVar("vj_stalker_looting")
    if not cvar or cvar:GetInt() ~= 1 then return end
    if not IsValid(self) or self.VJ_IsBeingControlled then return end
    if self:GetNPCState() ~= NPC_STATE_IDLE then return end
    if not self:IsAbleToMoveNow() then return end
    if not IsValid(self:GetActiveWeapon()) then return end
    
    local curTime = CurTime()
    if self.NextFindLootT == nil then
        self.NextFindLootT = curTime + mRand(5, 30) 
        return
    end
    
    if curTime < self.NextFindLootT then return end
    
    if not IsValid(self.LootTarget) then 
        if mRng(1, self.FindLootChance or 3) ~= 1 then 
            self.NextFindLootT = curTime + mRand(10, 25) 
            return 
        end
    end

    if self:IsOnFire() or self.IsFollowing or self.FollowingPlayer or self:IsVJAnimationLockState() then 
        if IsValid(self.LootTarget) then self.LootTarget.VJ_Looter = nil end 
        self.LootTarget = nil 
        return 
    end

    local enemy = self:GetEnemy()
    if IsValid(enemy) and self:Visible(enemy) then 
        if IsValid(self.LootTarget) then self.LootTarget.VJ_Looter = nil end 
        self.LootTarget = nil 
        return 
    end

    self.FailedLoot = self.FailedLoot or {}
    self.LootInventory = self.LootInventory or {}
    self.LootableLookup = self.LootableLookup or {}

    if table.IsEmpty(self.LootableLookup) and istable(self.LootableEntities) then
        for _, class in ipairs(self.LootableEntities) do
            self.LootableLookup[class] = true
        end
    end

    if IsValid(self.LootTarget) then
        if self.LootTarget.VJ_Looter ~= self then
            self.LootTarget = nil
            return
        end

        local lootPos = self.LootTarget:GetPos() + self.LootTarget:OBBCenter()
        local dist = self:GetPos():Distance(lootPos)

        if dist <= mRng(20, 50) then
            local pickUpAnim =  self:GetRandomValidValue(self.PlyPickUpAnim)
            if not pickUpAnim then return end 

            local seq = self:LookupSequence(pickUpAnim)
            if seq < 0 then return end 

            local animDur = self:SequenceDuration(seq) or 1 
            self:RemoveAllGestures()

            self:PlayAnim("vjseq_" .. pickUpAnim, true, animDur, false)
            self:SetState(VJ_STATE_ONLY_ANIMATION_CONSTANT, animDur)

            VJ.EmitSound(self, "items/itempickup.wav", 70, mRng(85, 105))
            table.insert(self.LootInventory, {class = self.LootTarget:GetClass(), pos = self.LootTarget:GetPos(), time = curTime})
            
            self.LootTarget:Remove()
            self.LootTarget = nil
            self.NextFindLootT = curTime + mRand(10, 20) 
            return true
        else
            if not self:IsMoving() then
                self:SetLastPosition(lootPos)
                self:Handle_ScheduledForceMove("Both", "LastPos", "Both", "Both", false)
            end
            
            self.LootStuckTimer = self.LootStuckTimer or curTime + 15
            if curTime > self.LootStuckTimer and not self:IsMoving() then
                self.FailedLoot[self.LootTarget] = curTime + 20
                if IsValid(self.LootTarget) then self.LootTarget.VJ_Looter = nil end -- Release dibs
                self.LootTarget = nil
                self.LootStuckTimer = nil
            end
            return
        end
    end


    local selfPos = self:GetPos()
    local nearestLoot = nil
    local nearestDist = self.FindLootDistance or 1000

    for _, v in ipairs(ents.FindInSphere(selfPos, nearestDist)) do
        if not IsValid(v) then continue end
        if not self.LootableLookup[v:GetClass()] then continue end
        
        -- DIBS CHECK
        if IsValid(v.VJ_Looter) and v.VJ_Looter ~= self then continue end
        
        if not self:Visible(v) then continue end
        if self.FailedLoot[v] and curTime < self.FailedLoot[v] then continue end

        local dist = selfPos:Distance(v:GetPos())
        if dist < nearestDist then
            nearestDist = dist
            nearestLoot = v
        end
    end

    if IsValid(nearestLoot) then
        self.LootTarget = nearestLoot
        nearestLoot.VJ_Looter = self 
        self.LootStuckTimer = curTime + mRand(10, 25)
        self:SetLastPosition(nearestLoot:GetPos())
        self:SCHEDULE_GOTO_POSITION(VJ.PICK({"TASK_RUN_PATH", "TASK_WALK_PATH"}))
        return true
    end

    return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Find_MedEnts = true
ENT.Find_MedEnts_Dist = 3500
ENT.Find_MedEntsNextT = 0

function ENT:HumanFindMedicalEnt()
    if not self.Find_MedEnts then return end 
    if not IsValid(self) or self.VJ_IsBeingControlled then return false end

    local curTime = CurTime()
    if curTime < (self.Find_MedEntsNextT or 0) or curTime < (self.TakingCoverT or 0) then return false end
    if not self:IsAbleToMoveNow() then return false end 
    if self:IsOnFire() then return false end
    if self.CurrentlyHealSelf or self.FollowingPlayer or not self:IsOnGround() then return false end

    local busy = self:IsVJAnimationLockState() or self.IsFollowing or self.Medic_Status or self.Flinching or self:IsBusy()
    if busy then return false end

    local enemy = self:GetEnemy()
    local enemyDist = IsValid(enemy) and self:GetPos():Distance(enemy:GetPos()) or math.huge
    local enemyVisible = IsValid(enemy) and self:Visible(enemy)
    if enemyDist < 1500 and enemyVisible then return false end

    local myHealth = self:Health()
    local maxHealth = self:GetMaxHealth()
    if myHealth >= maxHealth * 0.99 then return false end

    local function IsMedicalItem(ent)
        local class = ent:GetClass()
        return class:find("kit") or class:find("vial")
    end

    local searchDist = tonumber(self.Find_MedEnts_Dist) or 2500
    local pos = self:GetPos()
    local rngSnd = mRng(85, 105)
    local medEnt = IsValid(self.MedicalPickupTarget) and self.MedicalPickupTarget or nil

    if not IsValid(medEnt) then
        for _, v in ipairs(ents.FindInSphere(pos, searchDist)) do
            if not IsValid(v) then continue end
            if not IsMedicalItem(v) then continue end
            if not self:Visible(v) or self:IsUnreachable(v) then continue end
            medEnt = v
            self.MedicalPickupTarget = v
            self:StopMoving()
            self:ClearSchedule()
            self:SetLastPosition(select(2, VJ.GetNearestPositions(self, v)))
            self:SetTarget(v)
            self:Handle_ScheduledForceMove("Both", "LastPos", "Both", "Both", false)
            break
        end
    end

    if not IsValid(medEnt) then return false end

    local dist = VJ.GetNearestDistance(self, medEnt, true)
    if dist > mRand(20, 60) then return false end
    if self:IsBusy("Activities") or busy then return false end
    self:StopMoving()
    self:ClearSchedule()
    self:RemoveAllGestures()

    local anim = self:GetRandomValidValue(self.PlyPickUpAnim)
    if not anim then return end 

    local seq = self:LookupSequence(anim)
    if not seq or seq < 0 then return end 

    local animT = self:SequenceDuration(seq) or 1 
    self:PlayAnim("vjseq_" .. anim, true, animT, false)
    self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, animT)

    VJ.EmitSound(self, "items/smallmedkit1.wav", rngSnd, rngSnd)
    VJ.EmitSound(self, "items/itempickup.wav", rngSnd, rngSnd)

    self:SetHealth(math_Clamp(myHealth + mRng(15, 50), 0, maxHealth))
    
    if IsValid(medEnt) then
        medEnt:Remove()
    end

    self.MedicalPickupTarget = nil
    self.Find_MedEntsNextT = curTime + mRand(3, 5)
    return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Find_WepEnt = true
ENT.Find_WepEne_Close = 850
ENT.Find_WepSearch_Rad = 3250
ENT.Find_WepEntNextT = 0
ENT.PickupWeapon_Timeout = 4 

function ENT:CanPickUpWeapon()
    if not self.Find_WepEnt then return end 
    if self.VJ_IsBeingControlled then return end
    if not self:IsAbleToMoveNow() then return end 
    if not self:IsOnGround() then return end 

    local cT = CurTime()
    if cT <= (self.Find_WepEntNextT or 0) then return end

    local currentWep = self:GetActiveWeapon()
    if IsValid(currentWep) then return end 

    local ene = self:GetEnemy()
    if IsValid(ene) then
        local closeDist = tonumber(self.Find_WepEne_Close) or 1000
        if self:GetPos():Distance(ene:GetPos()) <= closeDist then return end
    end

    local busy = self.IsFollowing or self.Medic_Status or self.Flinching or self:IsBusy() or self:IsVJAnimationLockState() 

    if self.CurrentlyHealSelf or self:IsOnFire() or busy then
        return
    end

    local pos = self:GetPos()
    local searchRad = tonumber(self.Find_WepSearch_Rad) or 2500
    local targetWep = IsValid(self.PickupWeaponTarget) and self.PickupWeaponTarget or nil
    if IsValid(targetWep) then
        if not self.PickupWeapon_StartT then self.PickupWeapon_StartT = cT end
        if (cT - self.PickupWeapon_StartT) > (self.PickupWeapon_Timeout or 4)
           or self:IsUnreachable(targetWep) then
            self.PickupWeaponTarget = nil
            self.PickupWeapon_StartT = nil
            self.Find_WepEntNextT = cT + mRand(1,5)
            return false
        end
    end

    local move = "TASK_RUN_PATH" or "TASK_WALK_PATH"
    if not IsValid(targetWep) then
        for _, v in ipairs(ents.FindInSphere(pos, searchRad)) do
            if not IsValid(v) then continue end
            if not v:GetClass():find("^weapon_vj_") then continue end
            if IsValid(v:GetOwner()) then continue end
            if not self:Visible(v) or self:IsUnreachable(v) then continue end

            local phys = v:GetPhysicsObject()
            if IsValid(phys) and not phys:IsMotionEnabled() then continue end

            targetWep = v
            self.PickupWeaponTarget = v
            self.PickupWeapon_StartT = cT

            self:StopMoving()
            self:ClearSchedule()
            self:SetLastPosition(select(2, VJ.GetNearestPositions(self, v)))
            self:SCHEDULE_FACE("TASK_FACE_LASTPOSITION")
            self:SCHEDULE_GOTO_POSITION(move, function(x)
				x.CanBeInterrupted = true
			    x.CanShootWhenMoving = true
			    x.TurnData = {Type = VJ.FACE_ENEMY}
            end) 
            break
        end
    end

    if not IsValid(targetWep) then return end
    if VJ.GetNearestDistance(self, targetWep, true) > mRand(10,50) then return end
    if self:IsBusy("Activities") then return end

    local anim = self:GetRandomValidValue(self.PlyPickUpAnim)
    if not anim then return end 

    local seq = self:LookupSequence(anim)
    if not seq or seq < 0 then return end 

    local animT = self:SequenceDuration(seq) or 1 

    local rngSnd = mRng(85,105)
    local newWepClass = targetWep:GetClass()

    self.PendingPickupWeapon = targetWep
    self:RemoveAllGestures()
    self:PlayAnim("vjseq_" .. anim, true, animT, false)
    self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, animT)

    self:Give(newWepClass)
    self:SelectWeapon(newWepClass)
    if IsValid(self.PendingPickupWeapon) and self.HumanPrimaryWeapon ~= newWepClass then
        self.PendingPickupWeapon:Remove()
    end

    self.PendingPickupWeapon = nil
    self.PickupWeaponTarget = nil
    self.PickupWeapon_StartT = nil
    self.Find_WepEntNextT = cT + mRand(1,5)

    local snd = self:GetRandomValidValue(self.DrawNewWeaponSound)
    if snd then 
        VJ.EmitSound(self, snd, 70, rngSnd) 
    end
    return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Add acknowledgement for duo doors, where kicking one open will apply to both. 
-- Add kicking doors OPEN instead of just breaking them? 
-- Ignore doors already opened? 

ENT.PostBreakDoor_Reaction = true
ENT.PostBreakDoor_Anim = {"gesture_signal_takecover","gesture_signal_forward","gesture_signal_group","gesture_signal_halt"}
ENT.PostBreakDoor_Chance = 2
ENT.PostBreakDoor_NextT = 0 
ENT.AlliesReact_Breach = true 
ENT.AlliesReact_BreachNextT = 0
ENT.Break_DoorDistance = 70

ENT.DoorBreak_HitSoundTbl = {"general_sds/doorbreak/doorbust1.wav", "general_sds/doorbreak/doorbust2.wav","ambient/materials/door_hit1.wav"}
ENT.DoorBreak_WoodSoundTbl = {"physics/wood/wood_crate_break1.wav","physics/wood/wood_crate_break2.wav","physics/wood/wood_crate_break3.wav","physics/wood/wood_crate_break4.wav","physics/wood/wood_crate_break5.wav", "physics/wood/wood_furniture_break1.wav","physics/wood/wood_furniture_break2.wav"}
function ENT:KickDoorDown()
    if not self.AllowedToKickDownDoors then return end 

    local conv = GetConVar("vj_stalker_kickdoor"):GetInt()
    if conv ~= 1 or self.VJ_IsBeingControlled then return end

    if not self:IsOnGround() then return end 

    local busy = self:IsBusy() or  self:IsVJAnimationLockState() 

    if busy then return end 

    local enemy = self:GetEnemy() 
    local curT = CurTime()
    local pos = self:GetPos()
    local eneVisAlert = (IsValid(enemy) and not self:Visible(enemy) and self:GetNPCState() == NPC_STATE_COMBAT)

    if self:IsMoving() or self.IsFollowing or self:GetWeaponState() == VJ.WEP_STATE_RELOADING or self.WeaponAttackState == VJ.WEP_ATTACK_STATE_FIRE_STAND or self.Flinching then
        return 
    end

    local allyConv = GetConVar("vj_stalker_kickdoor_req_allies")
    if allyConv and allyConv:GetInt() == 1 then
        if not self:Allies_Check(1500) then return end
    end
    
    if curT > self.NextBreakDownDoorT then
        if not IsValid(self.BreakDoor) then

            local maxDistance = self.Break_DoorDistance or 100

            local startPos = self:WorldSpaceCenter()
            local endPos = startPos + self:GetForward() * maxDistance

            local trace = util.TraceHull({
                start = startPos,
                endpos = endPos,
                mins = Vector(-8, -8, -8),
                maxs = Vector(8, 8, 8),
                filter = self
            })

            local hitEnt = trace.Entity
            local ignoreLockedConv = GetConVar("vj_stalker_kickdoor_ignlocked") 
            if IsValid(hitEnt) and self:Visible(hitEnt) then
                local cls = hitEnt:GetClass()
                if cls == "prop_door_rotating" or cls == "func_door_rotating" then
                    local dir = (hitEnt:GetPos() - self:GetPos()):GetNormalized()
                    local dot = self:GetForward():Dot(dir)

                    if dot >= 0.65 then
                        local isLocked = hitEnt:GetInternalVariable("m_bLocked")
                        local allowIdleLocked = ignoreLockedConv and ignoreLockedConv:GetInt() == 1
                        if cls == "func_door_rotating" then
                            if eneVisAlert then
                                self.BreakDoor = hitEnt
                            elseif isLocked and allowIdleLocked then
                                self.BreakDoor = hitEnt
                            end
                        elseif cls == "prop_door_rotating" then
                            local anim = string.lower(hitEnt:GetSequenceName(hitEnt:GetSequence()))
                            local validAnim = string.find(anim, "idle") or string.find(anim, "locked")

                            if validAnim then
                                if eneVisAlert then
                                    self.BreakDoor = hitEnt
                                elseif isLocked and allowIdleLocked then
                                    self.BreakDoor = hitEnt
                                end
                            end
                        end
                    end
                end
            end
        else
            if self:IsBusy() or not IsValid(self.BreakDoor) or not self.BreakDoor:Visible(self) then
                local door = self.BreakDoor
                door.IsBeingKicked = nil
                self.BreakDoor = NULL
                return
            end

            local door = self.BreakDoor
            if not IsValid(door) then return end

            if door.IsBeingKicked then
                self.BreakDoor = NULL
                return
            end

            door.IsBeingKicked = true

            if self:GetActivity() ~= ACT_MELEE_ATTACK1 and not self:IsBusy("Activites") then 
                local ang = self:GetAngles()

                self:RemoveAllGestures()
                self:ClearSchedule()
                self:SetTurnTarget(self.BreakDoor)
                VJ.STOPSOUND(self.CurrentIdleSound)

                timer.Simple(mRand(0.65, 0.95), function()
                    if not IsValid(self) or not IsValid(self.BreakDoor) then 
                        door.IsBeingKicked = nil
                        self.BreakDoor = NULL
                        return 
                    end
                
                    local enemy = self:GetEnemy()
                    if IsValid(enemy) and self:Visible(enemy) and self:GetPos():DistToSqr(enemy:GetPos()) <= (150 * 150) then
                        door.IsBeingKicked = nil
                        self.BreakDoor = NULL
                        return
                    end
                
                    local desiredYaw = (self.BreakDoor:GetPos() - self:GetPos()):Angle().y
                    local currentYaw = self:GetAngles().y
                    local yawDiff = math_abs(math.AngleDifference(currentYaw, desiredYaw))

                    if yawDiff > 15 then
                        door.IsBeingKicked = nil
                        self.BreakDoor = NULL
                        return
                    end
                    
                    local kickAnim = self:GetRandomValidValue(self.KickDownDoorAnims)
                    if not kickAnim then return end 

                    local seq = self:LookupSequence(kickAnim)
                    local kickT = self:SequenceDuration(seq) or 1 

                    local teleSnd = self:GetRandomValidValue(self.SoundTbl_BeforeMeleeAttack)
                    self:PlayAnim("vjseq_" .. kickAnim, true, kickT, false)
                    self:SetState(VJ_STATE_ONLY_ANIMATION, kickT)

                    if teleSnd and mRng(1, 2) == 1 then 
                        VJ.EmitSound(self, teleSnd, rngVol, rngSnd)
                    end 

                    local rngSnd = mRng(85, 105)
                    local rngVol = mRng(75, 85)

                    local metroGear = self:GetRandomValidValue(self.FootstepSet_MetroPolice)
                    
                    if metroGear then
                        VJ.EmitSound(self, metroGear, rngVol, rngSnd)
                    end 

                    local door = self.BreakDoor                
                    if IsValid(door) and door:GetClass() == "prop_door_rotating" then

                        door.HasBeenDestroyed = true

                        local dAng = door:GetAngles()
                        local dPos = door:GetPos() 

                        ParticleEffect("door_explosion_chunks", dPos, dAng, nil)
                        ParticleEffect("door_pound_core", dPos, dAng, nil)
                        door:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
                        door:SetSolid(SOLID_NONE)
                
                        if self.DoorBreakPlyVisFx then 
                            local visMaxDist = self.DoorBreakPlyVisMaxDist or 500
                            for _,ply in ipairs(player.GetAll()) do 
                                if ply:GetPos():Distance(door:NearestPoint(ply:GetPos())) <= visMaxDist and not VJ_CVAR_IGNOREPLAYERS then
                                    ply:ViewPunch(Angle(mRand(-360, 360), mRand(-360, 360), mRand(-360, 360)))
                                end
                            end
                        end 
                        
                        local brokenDoorProp = ents.Create("prop_physics")
                        if not IsValid(brokenDoorProp) then return end 
						brokenDoorProp:PhysicsInit(SOLID_VPHYSICS)
						brokenDoorProp:SetMoveType(MOVETYPE_VPHYSICS)
                        brokenDoorProp:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
                        brokenDoorProp:SetSolid(SOLID_NONE)
                        brokenDoorProp:SetModel(door:GetModel())
                        brokenDoorProp:SetPos(door:GetPos())
                        brokenDoorProp:SetAngles(door:GetAngles())
                        brokenDoorProp:SetModelScale(0.95)
                        brokenDoorProp:Spawn()
                        brokenDoorProp:Activate()
                        brokenDoorProp:SetSkin(door:GetSkin())
                        brokenDoorProp:GetPhysicsObject():ApplyForceCenter(self:GetForward() * mRng(10000, 20000))

                        local doorHit = self:GetRandomValidValue(self.DoorBreak_HitSoundTbl)
                        local woodBreak = self:GetRandomValidValue(self.DoorBreak_WoodSoundTbl)
                        if doorHit then 
                            VJ.EmitSound(door, doorHit, rngVol, rngSnd)
                        end 
                        if woodBreak and mRng(1, 2) == 1 then 
                            VJ.EmitSound(door, woodBreak, rngVol, rngSnd)
                        end 

                        self.NextBreakDownDoorT = curT + mRand(4.5, 10)
                        door:Remove()
                        SafeRemoveEntityDelayed(brokenDoorProp, mRand(10, 25))

                        self:Allies_ReactToDoorBreaching()
                        self:DoorBreacher_PostReaction()
                    end
                end)
            end
        end
    end
    if not IsValid(self.BreakDoor) then
        self:SetState()
    end
end

function ENT:DoorBreacher_PostReaction()
    if self.PostBreakDoor_Reaction then
        local chance = self.PostBreakDoor_Chance or 2  
        if mRng(1,  chance) == 1 then
            timer.Simple(mRand(1.5, 2), function()
                if not IsValid(self) then return end

                local busy = self:IsBusy() or self:IsVJAnimationLockState()
                if busy or self:IsMoving() or not self:IsOnGround() then
                    return
                end

                if CurTime() <= self.PostBreakDoor_NextT then
                    return
                end

                local enemy = self:GetEnemy()
                if IsValid(enemy) and self:Visible(enemy) then
                    return
                end

                local allyConv = GetConVar("vj_stalker_kickdoor_req_allies")
                if allyConv and allyConv:GetInt() == 1 then
                    if not self:Allies_Check(1500) then
                        return
                    end
                end

                local curAct = self:GetActivity()
                if curAct == ACT_IDLE_AIM_AGITATED or curAct == ACT_RANGE_ATTACK1 or curAct == ACT_MELEE_ATTACK1 then
                    return
                end

                local flinchAnim = self:GetRandomValidValue(self.PostBreakDoor_Anim)
                if not flinchAnim then return end

                local blockedGestures = { 2152, 2147, 2148, 2149}

                for _, act in ipairs(blockedGestures) do
                    if self:IsPlayingGesture(act) then
                        return
                    end
                end

                local seq = self:LookupSequence(flinchAnim)
                if not seq or seq <= 0 then
                    return
                end

                local layer = self:AddGestureSequence(seq, true)
                if layer then
                    self:SetLayerPlaybackRate(layer, mRand(0.65, 1))
                end

                self.PostBreakDoor_NextT = CurTime() + mRand(1, 10)
            end)
        end
    end
end

function ENT:Allies_ReactToDoorBreaching()
    if self.AlliesReact_Breach then
        if self.RANDOMS_DEBUG then print("[DoorBreach] ally reaction block entered") end

        local curT = CurTime()
        local selfPos = self:GetPos()

        for _, ally in ipairs(ents.FindInSphere(selfPos, 1000)) do
            if selfPos:DistToSqr(ally:GetPos()) > 1000000 then continue end
            if not ally.IsVJBaseSNPC then continue end
            if not IsValid(ally) then continue end
            if ally == self then continue end
            if not ally:IsNPC() then continue end
            if curT < self.AlliesReact_BreachNextT then continue end

            local disp = ally:Disposition(self)
            if disp ~= D_LI and disp ~= D_NU then
                continue
            end

            if mRng(1, 2) ~= 1 then
                continue
            end

            if not ally:IsAbleToMoveNow() then
                continue
            end

            if ally:IsBusy() or ally:IsMoving() or not ally:Alive() or ally:IsVJAnimationLockState() then
                continue
            end

            local allyEnemy = ally:GetEnemy()
            if IsValid(allyEnemy) and mRng(1, 2) == 1 then
                continue
            end

            ally:Handle_ScheduledForceMove(true, "Origin", true, "Run", "Rng")
            ally.AlliesReact_BreachNextT = curT + mRand(1, 10)
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.IncapAnimSets = {
    {
        incAnim = "ranen2_idle1",
        incIdle = "ranen2_idle2",
        incEx   = "ranen2_idle3",
    },
    {
        incAnim = "ranen3_idle1",
        incIdle = "ranen3_idle2",
        incEx   = "ranen3_idle3",
    },
    {
        incAnim = "ranen_idle1",
        incIdle = "vjseq_ranen_idle2",
        incEx   = "ranen_idle3",
    },
    {
        incAnim = "wounded_in_legs",
        incIdle = "wounded_in_legs_loop",
        incEx   = "getup_05",
    }
}

function ENT:SetIncapAnims()
    if not self.CanBecomeIncapicitated then return end 
    if self.IncapAnimsInitialized then return end

    timer.Simple(0.1, function()
        if not IsValid(self) or self.IncapAnimsInitialized then return end

        local animSet = self.IncapAnimSets[mRng(1, #self.IncapAnimSets)] //self:GetRandomValidValue(self.IncapAnimSets)
        if not animSet then return end
        self.BecomeIncappedAnim       = animSet.incAnim
        self.IncapicitatedIdleAnim   = animSet.incIdle 
        self.RecoverFromIncapAnim    = animSet.incEx
        self.IncapAnimsInitialized = true

        if self.RANDOMS_DEBUG then
            print("Incap animation set:", self.BecomeIncappedAnim, self.IncapicitatedIdleAnim)
        end
    end)
end

function ENT:CheckToBecomeIncapacitated()
    if not self.CanBecomeIncapicitated then return end 

    local conv = GetConVar("vj_stalker_incapacitated"):GetInt()
    if not conv or conv ~= 1 then return end 

    if not IsValid(self) or self.VJ_IsBeingControlled then 
        return  
    end 

    local busy =  self:IsVJAnimationLockState() or self:IsBusy() or self.Flinching 
    if self.IncapCounter >= self.IncapAmount or self.NeverBecomeIncappedAgain then
        if self.RANDOMS_DEBUG then print("Cannot be incapacitated anymore.") end 
        return 
    end

    if busy or self.Medic_Status or not self:IsOnGround() or self:IsOnFire() or self.PlayingAttackAnimation or self:IsMoving() or self:GetWeaponState() == VJ.WEP_STATE_RELOADING then 
        return  
    end 

    local lowHp = mRand(0.2,0.33)
    local hp = self:Health()

    if hp < (self:GetMaxHealth() * lowHp) and not busy then
        self:StopMoving()
        self:ClearSchedule()
        self:PlayIncapAnimIntro()
        self:StopAttacks(true)
        self:SetState()
    end
end

function ENT:PlayIncapAnimIntro()
    if self.PlayingIncapAnim or self.NowIdleIncap then return end 

    if not self.IncapAnimsInitialized or not self.BecomeIncappedAnim then
        if self.RANDOMS_DEBUG then print("Incap animations not yet initialized, deferring incapacitation.") end 
        timer.Simple(0.1, function()
            if IsValid(self) then
                self:PlayIncapAnimIntro()
            end
        end)
        return
    end

    self:ClearSchedule()
    self:StopAllSounds()
    self.IsCurrentlyIncapacitated = true

    self.IncapCounter = self.IncapCounter + 1 
    if self.RANDOMS_DEBUG then print("Incapacitation count: " .. self.IncapCounter) end 

    if self.IncapCounter >= self.IncapAmount then
        self.NeverBecomeIncappedAgain = true
        if self.RANDOMS_DEBUG then print("Reached maximum incap limit. Cannot become incapacitated again.") end 
    end
    
    local busy =  self:IsVJAnimationLockState()  or self:IsBusy()
    if busy then return end 

    local anim = self:GetRandomValidValue(self.BecomeIncappedAnim)
    if not anim then return end 

    local becomeIncapSeq = self:LookupSequence(anim)
    if becomeIncapSeq == -1 then
        if self.RANDOMS_DEBUG then print("Invalid BecomeIncappedAnim sequence: " .. self.BecomeIncappedAnim) end 
        self.IsCurrentlyIncapacitated = false
        self.NowIdleIncap = false
        return
    end

    local animT = self:SequenceDuration(becomeIncapSeq)
    local playedAnim = self:PlayAnim("vjseq_" .. anim, true, animT, false)

    if playedAnim then
        self:SetState(VJ_STATE_ONLY_ANIMATION_CONSTANT, animT + 0.01)
        self.PlayingIncapAnim = true 
        if self.RANDOMS_DEBUG then print("Playing animation for " .. animT .. " seconds.") end 
        self:RemoveAllGestures()

        local pain = self:GetRandomValidValue(self.SoundTbl_Pain)
        if pain then
            self:PlaySoundSystem("Speech", pain)
            self.NextCryForAidSoundT = CurTime() + mRand(2, 6)
        end 

        timer.Simple(animT, function()
            if IsValid(self) then
                self.PlayingIncapAnim = false 
                if self.RANDOMS_DEBUG then print("Animation finished. Now entering incapacitated idle state.") end 
                self.NowIdleIncap = true
                local incapIdleSeq = self:LookupSequence(self.IncapicitatedIdleAnim)
                local incapIdleDur = self:SequenceDuration(incapIdleSeq)
                self:LoopIncapIdleAnim(incapIdleDur)
            end
        end)
    else
        print("Failed to play BecomeIncappedAnim.")
        self.IsCurrentlyIncapacitated = false
        self.NowIdleIncap = false
    end
end

function ENT:LoopIncapIdleAnim(incapIdleDur)
    if not IsValid(self) or not self.NowIdleIncap or self.PlayingIncapAnim or not self.IsCurrentlyIncapacitated then return end
    
    local anim = self:GetRandomValidValue(self.IncapicitatedIdleAnim)
    if not anim then return end

    local seq = self:LookupSequence(anim)
    if not seq or seq < 0 then return end 

    local dur = self:SequenceDuration(seq) or 1 
    self:SetIncapVars()
    self:PlayAnim("vjseq_" .. anim, true, dur, false)
    self:SetState(VJ_STATE_ONLY_ANIMATION_CONSTANT, dur)

    timer.Simple(dur, function()
        if IsValid(self) then
            self:LoopIncapIdleAnim(dur) 
        end
    end) 
end

function ENT:CheckToRecoverFromIncap()
    if not self.IsCurrentlyIncapacitated then return end 
    local hp = self:Health()
    local maxHp = self:GetMaxHealth()
    if self.NowIdleIncap and hp > (maxHp* 0.5) then
        self.NowIdleIncap = false
        timer.Remove("IdleLoopTimer_" .. self:EntIndex())
        self:PlayRecoverFromIncapAnim()
    end
end

function ENT:PlayRecoverFromIncapAnim()
    if not self.IsCurrentlyIncapacitated or self.PlayingRecoverAnim then return end

    local recoverAnim = self:GetRandomValidValue(self.RecoverFromIncapAnim)
    if not recoverAnim then return false end 

    local recoverSeq = self:LookupSequence(recoverAnim)
    if recoverSeq == -1 then
        if self.RANDOMS_DEBUG then print("Invalid RecoverFromIncapAnim sequence: " .. self.RecoverFromIncapAnim) end 
        return
    end
    
    local recoverDur = self:SequenceDuration(recoverSeq) or 1 
    local playedAnim = self:PlayAnim("vjseq_" .. recoverAnim, true, recoverDur, false)

    if playedAnim then
        self.PlayingRecoverAnim = true
        self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, recoverDur)
        if self.CurrentHasCryForAidSound then 
            self.CurrentHasCryForAidSound:Stop() 
        end

        self:RemoveAllGestures()

        local thanks = self:GetRandomValidValue(self.SoundTbl_MedicReceiveHeal)
        if thanks then
            self:PlaySoundSystem("Speech", thanks)
        end 

        self.IsCurrentlyIncapacitated = false
        timer.Simple(recoverDur - 0.1, function()
            if IsValid(self) then
                self:SetState()
                self:ResetIncapVars()
                self.PlayingRecoverAnim = false
                if self.RANDOMS_DEBUG then print("Recover animation finished. SNPC is now back to active state.") end 
            end
        end)
    else
        if self.RANDOMS_DEBUG then print("Failed to play RecoverFromIncapAnim.") end 
    end
end

function ENT:InitializeAutoRevival()
    if self.AutoReviveTimer then
        timer.Remove(self.AutoReviveTimer)
    end
    self.AutoReviveTimer = "AutoReviveTimer_" .. self:EntIndex()
end

function ENT:StartAutoRevivalTimer()
    if not self.AllowAutoRevive or not IsValid(self) then return end
    
    if timer.Exists(self.AutoReviveTimer) then
        timer.Remove(self.AutoReviveTimer)
    end
    
    timer.Create(self.AutoReviveTimer, self.AutoReviveDelay, 1, function()
        if IsValid(self) and self.IsCurrentlyIncapacitated then
            self:AttemptAutoRevival()
        end
    end)
end

function ENT:ControIfAllowedToAutoRevive()
    if self.IsCurrentlyIncapacitated and not timer.Exists(self.AutoReviveTimer) then
        self:StartAutoRevivalTimer()
    end
end

function ENT:AttemptAutoRevival()
    if not IsValid(self) or not self.IsCurrentlyIncapacitated then return end
    
    if mRng(1, 2) == 1 then
        self:SetHealth(self:GetMaxHealth())
        self.NowIdleIncap = false
        timer.Remove("IdleLoopTimer_" .. self:EntIndex())
        self:PlayRecoverFromIncapAnim()
    else
        self:TakeDamage(self:GetMaxHealth() * 2.5) 
    end
    timer.Remove(self.AutoReviveTimer)
end

function ENT:SetIncapVars()
    if IsValid(self) and self.IsCurrentlyIncapacitated then
        self.MovementType = VJ_MOVETYPE_STATIONARY
        self.HasMedicSounds_AfterHeal = false 
        self.HasMedicSounds_ReceiveHeal = false
        self.CanInvestigate = false 
        self.CallForHelp = false
        self.CanTurnWhileStationary = false
        self.CanFlinch = false
        self.CanDetectDangers = false
        self.SightDistance = 1
        self.Find_WepEnt = false 
        self.AvoidIncomingDanger = false
        self.HullType = HULL_SMALL_CENTERED
        self.IsMedic = false
    end
end

function ENT:ResetIncapVars() -- New stats applied when recover anim finishes specifically.
    if IsValid(self) and not self.IsCurrentlyIncapacitated then
        timer.Remove("IdleLoopTimer_" .. self:EntIndex())
        self.MovementType = VJ_MOVETYPE_GROUND
        self.HasMedicSounds_AfterHeal = false 
        self.HasMedicSounds_ReceiveHeal = false
        self.CanInvestigate = true  
        self.CallForHelp = true
        self.CanTurnWhileStationary = true
        self.CanFlinch = true
        self.CanDetectDangers = true 
        self.SightDistance = 8000
        self.Find_WepEnt = true 
        self.AvoidIncomingDanger = true
        self.HullType = HULL_HUMAN
        local c = CurTime()
        self.Find_WepEntNextT = c + mRand(3,5)
            
        if self.SNPCMedicTag then 
            self.IsMedic = true 
            self.Medic_NextHealT = c + mRand(self.Medic_NextHealTime.a, self.Medic_NextHealTime.b)
        end
        if GetConVar(self.FriendlyConvar):GetInt()  == 1 then
            self:ManageFriendlyVars()
        else 
            self.Behavior = VJ_BEHAVIOR_AGGRESSIVE 
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------

ENT.PlaceFlareAnimation = "grenplace"
function ENT:PlaceCombatFlare()
    if not self.CanDeployFlareInCombat then return end 

    local cT = CurTime()
    if not IsValid(self) or self.VJ_IsBeingControlled then 
        return  
    end 
    
    if self.IsCurrentlyDeployingAFlare then 
        return 
    end

    if cT < (self.CombatFlareDeployT or 0) then 
        return 
    end

    if self:IsVJAnimationLockState() or self:IsBusy() or self.Flinching then 
        return 
    end 

    local enemy = self:GetEnemy()
    if not IsValid(enemy) or not self:IsOnGround() or self:WaterLevel() > 0 or self:IsMoving() or self:GetWeaponState() == VJ.WEP_STATE_RELOADING then
        self.CombatFlareDeployT = cT + mRand(1, 5)
        return 
    end 

    if not self.EnemyData.VisibleTime then
        self.CombatFlareDeployT = cT + mRand(1, 5)
        return 
    end

    if self.RequireAllyToDepFlare then
        local requireAllies = GetConVar("vj_stalker_place_flares_ally_check"):GetInt() == 1
        local requireVisibleAllies = GetConVar("vj_stalker_place_flares_ally_vis_check"):GetInt() == 1
        local alyDist = tonumber(self.DepFlareAllyCheckDist) or 5500 
        if requireAllies then
            local allies = self:Allies_Check(alyDist)

            if not allies or #allies == 0 then
                self.CombatFlareDeployT = cT + mRand(1, 5)
                return false
            end

            if requireVisibleAllies then
                local foundVisibleAlly = false
                for _, ally in ipairs(allies) do
                    if IsValid(ally) and self:Visible(ally) then
                        foundVisibleAlly = true
                        break
                    end
                end

                if not foundVisibleAlly then
                    self.CombatFlareDeployT = cT + mRand(1, 5)
                    return false
                end
            end
        end
    end
    //Just to prevent multiple SNPCs in a vicinity from placing flares
    local nearbyAllies = self:Allies_Check(3500)
    if nearbyAllies and #nearbyAllies > 0 then
        for _, ally in ipairs(nearbyAllies) do
            if IsValid(ally) and ally ~= self then
                if ally.IsCurrentlyDeployingAFlare then
                    if self.RANDOMS_DEBUG then print("Skipping flare placement - ally already deploying flare:", tostring(ally)) end
                    self.CombatFlareDeployT = CurTime() + mRand(60, 120)
                    return
                end
            end
        end
    end

    local distanceToEnemy = self:GetPos():Distance(enemy:GetPos())
    if (distanceToEnemy < 2500 and enemy:Visible(self)) or self:IsBusy() then 
        self.CombatFlareDeployT = cT + mRand(1, 5)
        return 
    end

    local deployChance = self.DeployCombatFlareChance
    if not self.FlareDeployAttemptCheck then
        self.FlareDeployAttemptCheck = true
        if mRng(1, deployChance) ~= 1 then 
            self.CombatFlareDeployT = cT + mRand(150, 300)  
            return 
        end
    end

    self.IsCurrentlyDeployingAFlare = true

    local anim = self:GetRandomValidValue(self.PlaceFlareAnimation)
    if not anim then return end 
    
    local seq = self:LookupSequence(anim)
    if not seq or seq < 0 then return end 

    local aT = self:SequenceDuration(seq) or 1 
    local spwnDel = mRand(0.45, 0.65)
    self:PlayAnim("vjseq_" .. anim, true, aT, false)

    timer.Simple(spwnDel, function()
        if not IsValid(self) then return end

        local flare = ents.Create("env_flare")
        if not IsValid(flare) then 
            self.IsCurrentlyDeployingAFlare = false
            return 
        end

        local flareSpawnFlagRNG = table.Random({"4","8"})
        local flareScaleRNG = mRng(5,10)
        flare:SetPos(self:GetPos() + self:GetUp() * 5)
        flare:SetAngles(Angle(0, self:GetAngles().y, 0))
        flare:SetKeyValue("scale", tostring(flareScaleRNG))
        flare:SetKeyValue("spawnflags", tostring(flareSpawnFlagRNG))
        flare:Spawn()
        flare:Activate()
        flare:Fire("Start")
        flare:Fire("Launch", "1")
    end)
    
    self.NextFireQuickFlareT = cT + mRand(25, 45)
    self.CombatFlareDeployT = cT + mRand(350, 650)
    self.IsCurrentlyDeployingAFlare = false

    if not self.RetreatAfterDeployFlare then return end 
    local delT = mRand(1, 5)
    if self:IsAbleToMoveNow() then 
        timer.Simple(aT, function()
            if not IsValid(self) then return false end 
            self:Handle_ScheduledForceMove(false, "Enemy", "Both", "Run", true)
        end)
    end 
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- SHould  come back to this one later. 
ENT.Distress_SigAnim = true 
ENT.Distress_Sig_Chance = 2 
ENT.Distress_SigNextT = 0 
ENT.Distress_SigRange = 2000
function ENT:DistressOnCloseProximity()
    if not self.Panic_FleeEneProx then return end 
    if self.VJ_IsBeingControlled then return end
    if not self:IsOnGround() then return end 
    if self:IsOnFire() then return end 
    if not self:IsAbleToMoveNow() then return end

    local ene = self:GetEnemy()
    local curT1 = CurTime()

    if not IsValid(ene) or not self:Visible(ene) or self:IsUnreachable(ene) then return end
    if self:IsBusy() or curT1 < self.NextPanicOnCloseProxT then return end

    local distToEnemy = self:GetPos():Distance(ene:GetPos())
    if distToEnemy >= self.CloseProxPanicDist then return end

    local allyDetectRange = self.Panic_DetectAllyRange or 1500
    local nearbyAllies = self:Allies_Check(allyDetectRange) or {}
    local allyCount = #nearbyAllies

    local isAlone = self.IsCurrentlyAlone or false
    local signalRange = tonumber(self.Distress_SigRange) or 2500
    local nearbySignalAllies = self:Allies_Check(signalRange) or {}
    local chance = self.Panic_FleeEneChance or 3 

    print("Enemy too close! Distance: " .. distToEnemy)
    print("Nearby allies detected: " .. allyCount)
    print("Is currently alone? " .. tostring(isAlone))

    local shouldPanic = true
    local panicCooldown = mRand(5, 35) -- Default

    if allyCount >= self.Panic_AllySuppressCount then
        print("Too many allies nearby (" .. allyCount .. " >= " .. self.Panic_AllySuppressCount .. "). Suppressing panic.")
        shouldPanic = false
    elseif allyCount == 1 or allyCount == 2 then
        if mRng(1, 100) > 60 then
            print("Some allies nearby. Panic suppressed this time.")
            shouldPanic = false
        else
            print("Some allies nearby. Allowing panic (randomized).")
            panicCooldown = mRand(10, 25)
        end
    elseif isAlone then
        print("SNPC is alone. Panic is likely.")
        chance = math.max(1, math_floor(chance / 2))
        panicCooldown = mRand(3, 10)
    end

    if mRng(1, chance) ~= 1 then 
        self.NextPanicOnCloseProxT = curT1 + mRand(5, 15)
        return 
    end

    if not shouldPanic then return false end

    local curT = CurTime()
    self.NextChaseTime = curT + mRand(1, 10)
    self.TakingCoverT = curT + mRand(1, 5)
    self.NextPanicOnCloseProxT = curT + panicCooldown
    
    if mRng(1, 2) == 1 then 
        self:PlaySoundSystem("CallForHelp")
    end 

    if self.Distress_SigAnim then 
        local gesAnim = self:GetRandomValidValue(self.DetectDangerReactAnim)
        if gesAnim then 
            if #nearbySignalAllies > 0 and curT > (self.Distress_SigNextT or 0) then
                local sigChance = self.Distress_Sig_Chance or 3
                if mRng(1, sigChance) == 1 then
                    self:PlayAnim("vjges_" .. gesAnim, true)
                    self.Distress_SigNextT = curT + mRand(10, 20) 
                    print("Playing distress signal animation due to nearby allies.")
                end
            end
        end 
    end 

    self:Handle_ScheduledForceMove(false, "Both", "Both", "Run", true)
    print("Panic behavior activated! Next panic delay: " .. panicCooldown .. " seconds")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CheckFlashlightReaction()
    if not IsValid(self) or self.VJ_IsBeingControlled then return false end 
    if self:IsVJAnimationLockState() then return end 
    local cT = CurTime()
    if self.NextFlashlightCheckT and cT < (self.NextFlashlightCheckT or 0) then return end

    local flashBlindEne = GetConVar("vj_stalker_flash_blind_ene"):GetInt() == 1
    local flashBlindFri = GetConVar("vj_stalker_flash_blind_fri"):GetInt() == 1

    for _, ply in ipairs(player.GetAll()) do
        if not IsValid(ply) or not ply:Alive() then continue end

        local ene = self:GetEnemy()
        local blindDist = mRand(150,195)
        local disp = self:Disposition(ply)
        local distance = self:GetPos():Distance(ply:GetPos())
        local snpcForward = self:GetForward()
        local dirToPlayer = (ply:GetPos() - self:GetPos()):GetNormalized()
        local dotProduct = snpcForward:Dot(dirToPlayer)
        local shouldReact = false
        local npcState = self:GetNPCState()
        local inCombat = npcState == NPC_STATE_ALERT or npcState == NPC_STATE_COMBAT

        -- Should SNPC react based on disposition 
        if disp == D_LI and flashBlindFri and not (IsValid(ene) or inCombat) then
            shouldReact = true
        elseif disp == D_HT and flashBlindEne then
            shouldReact = true
        end

        if ply:FlashlightIsOn() and shouldReact and not VJ_CVAR_IGNOREPLAYERS and 
           self.CanBeBlindedByPlyLight and distance < blindDist and dotProduct > 0.5 then

            local snpcPos = self:GetPos() + Vector(0, 0, mRand(60,75)) 
            local plyEyePos = ply:GetShootPos() or ply:EyePos()
            local plyAimVector = ply:GetAimVector()

            local traceData = {start = plyEyePos, endpos = plyEyePos + (plyAimVector * 800), filter = ply}
            local trace = util.TraceLine(traceData)

            if trace.Entity == self then
                self:PlayFlashlightReaction()
                return
            end
        end
    end
end

-- Come back to this one later as well
function ENT:PlayFlashlightReaction()
    if not self:IsOnGround() or self:IsMoving() then return end
    local mini = mRand(0.025, 1.125)
    local seqAnim = "vjseq_" .. table.Random({"blinded_01", "photo_react_blind"})
    local gesAnim = "vjges_" .. table.Random({"flinch_head_small_01", "flinch_head_small_02", "flinchheadgest"})
    local seqAnimDur = math.max(VJ.AnimDuration(self, seqAnim) - mini, 0) or 1
    local gesAnimDur = VJ.AnimDuration(self, gesAnim) or 1
    local delay = mRand(0.01, 0.2)
    local curT = CurTime()
    local busy = self:IsBusy() or  self:IsVJAnimationLockState() 
    
    timer.Simple(delay, function()
        if not IsValid(self) then return end

        local canDoFullAnim = not busy and not self.Copy_IsCrouching and not self:IsMoving()
        self:StopMoving()
        self:RemoveAllGestures() 
        if canDoFullAnim and seqAnim then
            self:PlayAnim(seqAnim, true, seqAnimDur)
            self.NextFlashlightCheckT = curT + mRand(5, 15)
        elseif gesAnim then 
            self:PlayAnim(gesAnim, false, gesAnimDur)
            self.NextFlashlightCheckT = curT + mRand(2.5, 7.5)
        end

        if mRng(1, 3) == 1 then
            local snd = VJ.PICK({"Pain", "CallForHelp"})
            if snd then 
                self:PlaySoundSystem(snd)
            end 
        end
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
//Possibly add trigger if SNPC is at low health?
ENT.IsAlone_VJEneConv = "vj_stalker_lm_tr_vj_creature"
function ENT:IfSelfIsLoneMember()
    if not self.HasAloneAiBehaviour or self.VJ_IsBeingControlled then return end
    if not self.CanAlly then return end 
    local allyCheckDist = self.FindAllyDistance or 3000
    local allies = self:Allies_Check(allyCheckDist)
    local ene = self:GetEnemy()
    if not IsValid(ene) then return end

    if self.IsAlone_VJEneConv then
        local convVar = GetConVar(tostring(self.IsAlone_VJEneConv))
        if convVar then
            local conv = convVar:GetInt()
            if IsValid(ene) and ene.IsVJBaseSNPC_Creature and conv ~= 1 then
                return
            end
        end
    end

    //To filter out my SNPCs when they're incapacitated!
    local validAllies = 0
    if istable(allies) then
        for _, ally in ipairs(allies) do
            if IsValid(ally) and not ally.IsCurrentlyIncapacitated then
                validAllies = validAllies + 1
            end
        end
    end

    local isAlone = (not istable(allies) or #allies == 0)
    if self._DisableChasing_EnemyStatus == nil then
        self._DisableChasing_EnemyStatus = self.DisableChasingEnemy or false
    end

    if self._CoverReloadBaseline == nil then
        if self.DoesNotHaveCoverReload ~= nil then
            self._CoverReloadBaseline = not self.DoesNotHaveCoverReload
        else
            self._CoverReloadBaseline = self.Weapon_FindCoverOnReload or false
        end
    end

    -- ENTER 
    if isAlone and not self.IsCurrentlyAlone then
        self.IsCurrentlyAlone = true
        if not self.DisableChasingEnemy then
            self.DisableChasingEnemy = true
        end
        if not self.Weapon_FindCoverOnReload then
            self.Weapon_FindCoverOnReload = true
        end
        return
    end

    -- EXIT 
    if not isAlone and self.IsCurrentlyAlone then
        self.IsCurrentlyAlone = false
        self.DisableChasingEnemy = self._DisableChasing_EnemyStatus
        self.Weapon_FindCoverOnReload = self._CoverReloadBaseline
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanWeLean            = true
ENT.CurrentlyLeaning     = false
ENT.NextLeanTime         = 0
ENT.LeanTransitionSpeed  = 0.15
ENT.StateChangeDelay     = 0.25
ENT.LastStateChange      = 0
ENT.TargetLeanAngle      = Angle(0,0,0)
ENT.CurrentLeanAngle     = Angle(0,0,0)
ENT.LeanCooldownUntil    = 0
ENT.LeanOriginPos        = nil

ENT.LeanMaxAdjustment    = 12      
ENT.LeanBoostExtra       = 5       
ENT.LeanCheckDist        = 50     
ENT.Lean_MinDist         = 240     
ENT.Lean_MaxDist         = 3500    

local ZERO_ANGLE = Angle(0,0,0)
local BONE_PELVIS = "ValveBiped.Bip01_Pelvis"
local BONE_SPINE  = "ValveBiped.Bip01_Spine"
local BONE_SPINE1 = "ValveBiped.Bip01_Spine1"

function ENT:ForceBoneReset()
    local pelvis = self:LookupBone(BONE_PELVIS)
    local spine  = self:LookupBone(BONE_SPINE)
    local spine1 = self:LookupBone(BONE_SPINE1)

    if pelvis then self:ManipulateBoneAngles(pelvis, ZERO_ANGLE) end
    if spine  then self:ManipulateBoneAngles(spine, ZERO_ANGLE) end
    if spine1 then self:ManipulateBoneAngles(spine1, ZERO_ANGLE) end
end

function ENT:ResetLean()
    local cT = CurTime()
    self.CurrentlyLeaning   = false
    self.TargetLeanAngle    = ZERO_ANGLE
    self.CurrentLeanAngle   = ZERO_ANGLE
    self.LeanOriginPos      = nil
    self.LastStateChange    = cT
    self.LeanCooldownUntil  = cT + mRand(2.5, 6.5)

    self:ForceBoneReset()
    for i = 1, 3 do
        timer.Simple(i * 0.05, function()
            if IsValid(self) then self:ForceBoneReset() end
        end)
    end
    print("[Lean Reset] Lean reset called.")
end

function ENT:CheckLeanReset()
    if not self.CurrentlyLeaning then return end

    local enemy = self:GetEnemy()
    local pos   = self:GetPos()

    if not IsValid(enemy) then
        self:ResetLean()
        return
    end
    if self:IsMoving() then
        self:ResetLean()
        return
    end
    if not self:IsOnGround() then
        self:ResetLean()
        return
    end
    if self:GetWeaponState() == VJ.WEP_STATE_RELOADING then
        self:ResetLean()
        return
    end
    local act = self:GetActivity()
    if act == ACT_RUN or act == ACT_WALK then
        self:ResetLean()
        return
    end
    if self.LeanOriginPos and pos:DistToSqr(self.LeanOriginPos) > (25 * 25) then
        self:ResetLean()
        return
    end
    if math.abs(enemy:GetPos().z - pos.z) > 120 then
        self:ResetLean()
        return
    end
end

function ENT:ContextToLean()
    if not self.CanWeLean then
        return
    end

    local conv = GetConVar("vj_stalker_can_lean")
    if not conv or conv:GetInt() ~= 1 then
        return
    end

    local cT = CurTime()
    if self.CurrentlyLeaning and not IsValid(self:GetEnemy()) then
        self:ResetLean()
        return
    end
    if self:IsMoving() then
        if self.CurrentlyLeaning then self:ResetLean() end
        return
    end

    self:CheckLeanReset()
    if self.VJ_IsBeingControlled then
        return
    end
    if self.LeanCooldownUntil > cT then
        return
    end

    local wep = self:GetActiveWeapon()
    if not IsValid(wep) then
        return
    end

    if wep.IsMeleeWeapon then 
        return 
    end 

    if not self.CurrentlyLeaning and cT > self.NextLeanTime and cT > (self.TakingCoverT or 0) then
        self:CustomLean()
    end

    self.CurrentLeanAngle = LerpAngle(self.LeanTransitionSpeed,self.CurrentLeanAngle,self.TargetLeanAngle)
    self.CurrentLeanAngle.p = math.Clamp(self.CurrentLeanAngle.p, -18, 18)
    self.CurrentLeanAngle.y = math.Clamp(self.CurrentLeanAngle.y, -22 - self.LeanBoostExtra, 22 + self.LeanBoostExtra)
    self.CurrentLeanAngle.r = math.Clamp(self.CurrentLeanAngle.r, -12, 12)

    local pelvis = self:LookupBone(BONE_PELVIS)
    local spine  = self:LookupBone(BONE_SPINE)
    local spine1 = self:LookupBone(BONE_SPINE1)
    local a = self.CurrentLeanAngle

    if pelvis then self:ManipulateBoneAngles(pelvis, Angle(0, -a.y * 0.25, -a.r * 0.25)) end
    if spine then self:ManipulateBoneAngles(spine, Angle(a.p * 0.6, a.y * 0.6, a.r * 0.6)) end
    if spine1 then self:ManipulateBoneAngles(spine1, Angle(a.p * 0.4, a.y * 0.4, a.r * 0.4)) end
end

function ENT:CustomLean()
    local enemy = self:GetEnemy()
    if not IsValid(enemy) then return end
    if self:IsMoving() then return end
    if self.CurrentlyLeaning then return end

    local pos = self:GetPos()
    local traceStart = pos + self:OBBCenter()
    local distSqr = pos:DistToSqr(enemy:GetPos())
    if distSqr > (self.Lean_MaxDist * self.Lean_MaxDist) or distSqr < (self.Lean_MinDist * self.Lean_MinDist) then
        return
    end
    if math.abs(enemy:GetPos().z - pos.z) > 120 then
        return
    end

    local forwardVec = self:GetForward()
    local tr = util.TraceLine({
        start  = traceStart,
        endpos = traceStart + forwardVec * self.LeanCheckDist,
        filter = {self},
        mask = MASK_SOLID
    })
    if not tr.Hit then
        return
    end

    local localDir = self:WorldToLocal(enemy:GetPos())
    local newAngle = ZERO_ANGLE
    local leanSide = "none"
    if localDir.y > 0 then
        newAngle = Angle(12, 22 + self.LeanBoostExtra, 6) 
        leanSide = "right"
    else
        newAngle = Angle(-12, -22 - self.LeanBoostExtra, -6)
        leanSide = "left"
    end

    local wep = self:GetActiveWeapon()
    local enePos_Eye = enemy:EyePos()
    if IsValid(wep) then
        local weaponBlocked = self:DoCoverTrace(wep:GetBulletPos(), enePos_Eye, false)
        if weaponBlocked then
            return
        end
    end

    local cT = CurTime()
    if cT - self.LastStateChange > self.StateChangeDelay then
        self.CurrentlyLeaning = true
        self.TargetLeanAngle  = newAngle
        self.LeanOriginPos    = Vector(pos.x, pos.y, pos.z)
        self.LastStateChange  = cT
        self.NextLeanTime     = cT + mRand(2, 6)

        self:SetTurnTarget("Enemy")
        self:StopMoving()
        print("[Lean Success] SNPC is leaning", leanSide, "Target angle:", newAngle)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
    // -- [Custom VJ Weapon manipulation] -- \\

ENT.Replace_CurWepPcfx = true
ENT.General_PcfxTbl = {"doi_muzzleflash_smoke_small_variant_2", "doi_muzzleflash_smoke_small_variant_3", "doi_muzzleflash_mg34_1p_splits","doi_muzzleflash_mg42_3p_splits","doi_muzzleflash_stg44_3p","doi_muzzleflash_k98_3p_flame","doi_muzzleflash_stg44_1p_core"}
ENT.Pistol_PcfxTbl = {"doi_muzzleflash_tracer", "doi_weapon_muzzle_smoke", "doi_muzzleflash_mg42_3p_splits","doi_muzzleflash_stg44_3p","doi_muzzleflash_k98_3p_flame","doi_muzzleflash_stg44_1p_core"}
ENT.Shotgun_PcfxTbl = {"doi_muzzleflash_smoke_small_variant_2", "doi_muzzleflash_smoke_small_variant_3", "doi_muzzleflash_tracer", "doi_muzzleflash_k98_3p_flame", "doi_weapon_muzzle_smoke", "doi_muzzleflash_mg42_1p_spark_trail", "doi_muzzleflash_mg42_1p_splits", "doi_muzzleflash_sparks_variant_6",  "doi_muzzleflash_ithica_1p_spark_trail", "doi_muzzleflash_ithica_1p_core", "doi_muzzleflash_ithica_1p_core_b", "doi_muzzleflash_ithica_1p_b", "doi_muzzleflash_ithica_1p_flame", "doi_muzzleflash_ithica_3p"}
ENT.Suppressed_PcfxTbl = {"doi_muzzleflash_smoke_small_variant_2", "doi_muzzleflash_smoke_small_variant_3"} 
function ENT:Override_DefWepPcfx()
    if not file.Exists("autorun/rscpck_pcf_precache.lua", "LUA") then return end 
    if not self.Replace_CurWepPcfx then return end 
    if not self:Alive() then return end 

    local wep = self:GetActiveWeapon()

    local conv = GetConVar("vj_stalker_override_wep_pcfx")
    if not conv or conv:GetInt() ~= 1 then
        if IsValid(wep) and wep._OrigMuzzleParticles then
            if self.RANDOMS_DEBUG then
                print("(Weapon PCFX) Reverting to original particles")
            end

            wep.PrimaryEffects_MuzzleParticles = wep._OrigMuzzleParticles
            wep.PrimaryEffects_MuzzleParticlesAsOne = wep._OrigMuzzleAsOne

            if wep._OrigMuzzleFlash ~= nil then
                wep.PrimaryEffects_MuzzleFlash = wep._OrigMuzzleFlash
            end
        end
        return 
    end

    if not IsValid(wep) then return end 
    if not wep.IsVJBaseWeapon then return end 
    if wep.IsMeleeWeapon then return end 
    if wep.Primary.DisableBulletCode then return end 
    if not wep.PrimaryEffects_MuzzleAttachment then return end 

    if not wep._OrigMuzzleParticles then
        wep._OrigMuzzleParticles = table.Copy(wep.PrimaryEffects_MuzzleParticles or {})
        wep._OrigMuzzleAsOne = wep.PrimaryEffects_MuzzleParticlesAsOne
        wep._OrigMuzzleFlash = wep.PrimaryEffects_MuzzleFlash 

        if self.RANDOMS_DEBUG then 
            print("(Weapon PCFX) Cached original particles + muzzle flash")
        end 
    end

    local hT = wep.HoldType or ""
    local ammo = wep.Primary.Ammo or ""
    local shell = wep.PrimaryEffects_ShellType or ""

    local isShotGun = (hT == "shotgun" or ammo == "Buckshot" or shell == "ShotgunShellEject")
    local isPistol = ((hT == "pistol" or hT == "revolver") and (ammo == "pistol" or ammo == "357"))
    local isGeneral = ((hT == "smg" or hT == "ar2") or (ammo == "SMG1" or ammo == "AR2"))

    local isSuppressed = wep.IsSuppressed_Weapon
    local desiredTbl = wep._OrigMuzzleParticles

    if isSuppressed then
        desiredTbl = self.Suppressed_PcfxTbl
        if wep.PrimaryEffects_MuzzleFlash ~= true then
            wep.PrimaryEffects_MuzzleFlash = true
            if self.RANDOMS_DEBUG then
                print("(Weapon PCFX) Suppressed → forcing muzzle flash ON")
            end
        end

    else
        if wep._OrigMuzzleFlash ~= nil and wep.PrimaryEffects_MuzzleFlash ~= wep._OrigMuzzleFlash then
            wep.PrimaryEffects_MuzzleFlash = wep._OrigMuzzleFlash
            if self.RANDOMS_DEBUG then
                print("(Weapon PCFX) Restoring original muzzle flash state")
            end
        end

        if isShotGun then
            desiredTbl = self.Shotgun_PcfxTbl
        elseif isPistol then
            desiredTbl = self.Pistol_PcfxTbl
        elseif isGeneral then
            desiredTbl = self.General_PcfxTbl
        end
    end

    if not desiredTbl then return end

    local curTbl = wep.PrimaryEffects_MuzzleParticles or {}

    local isSame = (#curTbl == #desiredTbl)
    if isSame then
        for i = 1, #curTbl do
            if curTbl[i] ~= desiredTbl[i] then
                isSame = false
                break
            end
        end
    end

    if not isSame then
        if self.RANDOMS_DEBUG then 
            print("(Weapon PCFX) Applying new particle table")
        end 

        wep.PrimaryEffects_MuzzleParticles = table.Copy(desiredTbl)
        wep.PrimaryEffects_MuzzleParticlesAsOne = true
    end
end

ENT.Manipulate_WeaponTracer = true 
function ENT:Handle_WeaponTracerConv()
    if not self.Manipulate_WeaponTracer then return end 
    if not self:Alive() then return end 
    if self:GetNPCState() ~= NPC_STATE_COMBAT then return end 

    local aiDisabled = GetConVar("ai_disabled")
    if aiDisabled and aiDisabled:GetBool() then return end 

    local wep = self:GetActiveWeapon()
    
    if not IsValid(wep) then return end 
    if not wep.IsVJBaseWeapon then return end 
    if wep.IsMeleeWeapon then return end 
    if wep.Primary.DisableBulletCode then return end 
    if wep.Primary.Tracer == 0 then return end 
    local tracer = wep.Primary.TracerType

    local isDefault = (tracer == "SMG1" or tracer == "Tracer")
    local isCustom  = (tracer == "vj_randoms_cus_bul_tracer_l" or tracer == "vj_randoms_cus_bul_tracer_white")

    if not isDefault and not isCustom then return end

    if not wep._OrigTracerType then
        wep._OrigTracerType = wep.Primary.TracerType
        if self.RANDOMS_DEBUG then 
            print("Cached original tracer:", wep._OrigTracerType)
        end 
    end

    yelConv = GetConVar("vj_stalker_override_all_wep_tracers_yel")
    whiConv = GetConVar("vj_stalker_override_all_wep_tracers_whi")

    local desiredTracer = wep._OrigTracerType

    if yelConv and yelConv:GetInt() == 1 then 
        desiredTracer = "vj_randoms_cus_bul_tracer_l" -- Yellow
    elseif whiConv and whiConv:GetInt() == 1 then 
        desiredTracer = "vj_randoms_cus_bul_tracer_white"
    end

    if wep.Primary.TracerType ~= desiredTracer then
        if self.RANDOMS_DEBUG then 
            print("Applying tracer:", desiredTracer)
        end 
        wep.Primary.TracerType = desiredTracer
    end
end

ENT.HasFireInBurstAbility = false 

ENT.Adapt_WepFireDist = true
ENT.Adapt_WepDistSwitchMax = 5555
ENT.Adapt_WepDistSwitchMin = 3000
ENT.Adapt_WepDistNextT = 0 
function ENT:Alter_WeaponFireStats()
    if not IsValid(self) then return end 
    if not self.Adapt_WepFireDist then return end
    
    local conv = GetConVar("vj_stalker_wep_fire_adapt")
    if not conv or conv:GetInt() ~= 1 then return end 
    
    if self.VJ_IsBeingControlled then return end 
    if not self:Alive() then return end 
    if self:GetNPCState() ~= NPC_STATE_COMBAT then return end 

    local wep = self:GetActiveWeapon()
    if not IsValid(wep) then return end 
    if not wep.IsVJBaseWeapon then return end 
    if wep.Internal_BlockFireTypeChange then return end 
    if wep.IsMarkedSnpcSniperWep then return end 
    if wep.IsMarkedSnpcSniperWep then return end 
    if wep._OrigAutomatic == nil then
    if wep.IsMeleeWeapon then return end 
    wep._OrigAutomatic = wep.Primary.Automatic

    if self.RANDOMS_DEBUG then
            print("(Adaptive Firing): Cached original automatic =", wep._OrigAutomatic)
        end
    end

    if wep._OrigAutomatic == false then
        if self.RANDOMS_DEBUG then
            print("(Adaptive Firing): Skipping - weapon is inherently semi")
        end
        return
    end

    
    local hType = wep.HoldType
    if hType == "pistol" or hType == "revolver" or hType == "rpg" then return end

    local ammo = wep.Primary.Ammo or ""
    local shell = wep.PrimaryEffects_ShellType or ""

    local isShotGun = (hType == "shotgun" or ammo == "Buckshot" or shell == "ShotgunShellEject")
    if isShotGun then return end 

    local ene = self:GetEnemy()
    if not IsValid(ene) then return end 

    if CurTime() < (self.Adapt_WepDistNextT or 0) then return end 

    local dist = self:GetPos():DistToSqr(ene:GetPos())
    local max  = (self.Adapt_WepDistSwitchMax or 6000)^2
    local min  = (self.Adapt_WepDistSwitchMin or 1500)^2

    local newMode

    if dist > max then
        newMode = "semi"
    elseif dist > min then
        newMode = "auto"
    else
        newMode = "close"
    end

    if self.Adapt_CurrentMode == newMode then return end
    self.Adapt_CurrentMode = newMode

    local automatic = true
    local nextFire = 0.1
    local spread = 0.1
    local timeUntil = 0.1

    if newMode == "semi" then
        automatic = false
        timeUntil = mRand(0.1, 0.45)
        nextFire = mRand(0.1, 1)
        spread = mRand(0.05, 0.1)
        print("(Adaptive Firing): Switching to semi | Base Delay:", timeUntil)

    elseif newMode == "auto" then 
        automatic = true
        timeUntil = mRand(0.065, 0.15)
        nextFire = mRand(0.09, 0.12)
        spread = mRand(0.065, 0.135)
        print("(Adaptive Firing): Switching to auto | Base Delay:", timeUntil)

    else -- close
        automatic = true
        timeUntil = mRand(0.085, 0.15)
        nextFire = 0.1
        spread = mRand(0.05, 0.1)
        print("(Adaptive Firing): Switching to fallback | Base Delay:", timeUntil)
    end

    local cvExtDelay = GetConVar("vj_stalker_extended_delay")
    local cvNoDelay  = GetConVar("vj_stalker_no_fire_delay")

    local extDelay = cvExtDelay and cvExtDelay:GetInt() == 1
    local noDelay  = cvNoDelay  and cvNoDelay:GetInt() == 1

    if noDelay then
        if self.RANDOMS_DEBUG then
            print("(Adaptive Firing): NO DELAY ENABLED")
        end
        timeUntil = 0

    elseif extDelay then
        local bonus = 0

        if newMode == "semi" then
            bonus = mRand(1, 3.5)

        elseif newMode == "auto" then
            bonus = mRand(0.9, 2)

        else -- close
            bonus = mRand(0.5, 1.5)
        end

        timeUntil = timeUntil + bonus

        if self.RANDOMS_DEBUG then
            print("(Adaptive Firing): Ext Del is : Bonus:", bonus, ": Final:", timeUntil)
        end
    end

    wep.Primary.Automatic = automatic
    wep.NPC_NextPrimaryFire = nextFire
    wep.NPC_CustomSpread = spread
    wep.NPC_TimeUntilFire = timeUntil

    self.Adapt_WepDistNextT = CurTime() + mRand(0.75, 2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SeekOutMedic()
    if not self.CanSeekOutMedic then return end 
    if not self:IsAbleToMoveNow() then return end 
    if self.IsMedic then return end 
    if not self:IsOnGround() then return end 
    if not self:Alive() then return end 
    if self:IsVJAnimationLockState() or self:IsBusy("Activities") or self.Flinching then return end 
    if self.VJ_IsBeingControlled or self:IsOnFire() then
        return 
    end

    local cT = CurTime()
    local ene = self:GetEnemy()

    if IsValid(ene) or cT < (self.NextMedicSeekT or 0) then
        return 
    end

    if self:Health() >= (self:GetMaxHealth() * 0.65) then
        return 
    end

    local myPos = self:GetPos()
    local seekRng = tonumber(self.MedicSeekRange) or 1500
    local nearestMedic = nil
    local nearestDistSqr = math.huge

    for _, ent in ipairs(ents.FindInSphere(myPos, seekRng)) do
        if ent ~= self and IsValid(ent) and ent.IsVJBaseSNPC and ent.IsMedic and ent:Alive() then
            local disp = self:Disposition(ent)
            if disp == D_LI and (not self:IsUnreachable(ent)) and not ent:IsBusy() then
                local dSqr = myPos:DistToSqr(ent:GetPos())
                
                if nearestDistSqr > (seekRng * seekRng) then
                    return
                end

                if dSqr < nearestDistSqr then
                    nearestMedic = ent
                    nearestDistSqr = dSqr
                end
            end
        end
    end

    local cool = tonumber(self.MedicSeekCoolT) or 10
    local stopDist = tonumber(self.MedicApprStopDist) or 500
    local stopDistSqr = stopDist * stopDist
    local noMoveDist = tonumber(self.MedicNoAprDist) or 600
    local noMoveDistSqr = noMoveDist * noMoveDist

    if IsValid(nearestMedic) then
        if not nearestMedic:Alive() or nearestMedic:IsBusy() or not nearestMedic.IsMedic then
            self.CurrentMedicTarget = nil
            return
        end
        
        self.CurrentMedicTarget = nearestMedic
        self.NextMedicSeekT = cT + cool

        if nearestDistSqr > noMoveDistSqr and nearestDistSqr > stopDistSqr and self:IsAbleToMoveNow()  then
            self:SetTurnTarget(nearestMedic)
            
            local randFnInt = mRng or mRng
            local offsetX = (randFnInt(-60, 60))
            local offsetY = (randFnInt(-60, 60))
            local targetPos = nearestMedic:GetPos() + nearestMedic:GetForward() * offsetX + nearestMedic:GetRight() * offsetY
            self:SetLastPosition(targetPos)
            self:Handle_ScheduledForceMove("Both", "LastPos", "Both", "Both", "Rng")
        end
    else
        self.CurrentMedicTarget = nil
    end
    return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.PlyFlash_Aware = true
ENT.PlyFlash_CntctDist = 650 
ENT.PlyFlash_CheckInterval = 0.35
ENT.PlyFlash_NextCheck = 0
ENT.PlyFlash_HpDetect_Range = 850
ENT.PlyFlash_NextMoveT = 0 
function ENT:PlyFlash_AlertHostile(ply)
    if not IsValid(ply) then return end
    local disp = self:Disposition(ply)
    if disp == D_LI then 
        if self.RANDOMS_DEBUG then print("Flashlight hit, but ply is Friendly. Ignoring.") end
        return 
    end

    local plyPos = ply:GetPos()
    local grenDelay = math.Rand(0.5, 2)
    if self.RANDOMS_DEBUG then print("Flashlight Direct Hit! Engaging: ", ply:GetName()) end 
    self.NextDoAnyAttackT = CurTime() + grenDelay 
    self.PlyFlash_AlrAlerted = true
    if self:GetNPCState() ~= NPC_STATE_COMBAT then
        self:SetNPCState(NPC_STATE_ALERT)
    end
    self:ClearSchedule()
    self:SetEnemy(ply, true)
    self:UpdateEnemyMemory(ply, plyPos)
    self:ForceSetEnemy(ply, plyPos)
    timer.Simple(5, function() 
        if IsValid(self) then self.PlyFlash_AlrAlerted = false end 
    end)
end

function ENT:PlyFlash_IdleAlert()
    if not self.PlyFlash_Aware then return end
    local conv = GetConVar("vj_stalker_ply_flashlight_alert"):GetInt()
    if conv ~= 1 then return end 
    if VJ_CVAR_IGNOREPLAYERS then return end 
    if self.VJ_IsBeingControlled then return end 

    local curT = CurTime()
    if curT < (self.PlyFlash_NextCheck or 0) then return end
    self.PlyFlash_NextCheck = curT + (self.PlyFlash_CheckInterval or 0.25) 

    local enemy = self:GetEnemy()
    if IsValid(enemy) or self:GetNPCState() == NPC_STATE_COMBAT or self:IsBusy() then return end

    local plyAll = player.GetAll()
    local maxDist = tonumber(self.PlyFlash_CntctDist) or 1000
    local plyFlshDistSqr = maxDist ^ 2 
    local targetPos = self:WorldSpaceCenter()

    for _, ply in ipairs(plyAll) do
        if IsValid(ply) and ply:Alive() and ply:FlashlightIsOn() then
            local plyEyePos = ply:GetShootPos()
            if plyEyePos:DistToSqr(targetPos) > plyFlshDistSqr then continue end

            local plyAimVec = ply:GetAimVector()
            local dirToNPC = (targetPos - plyEyePos):GetNormalized()
            local dot = plyAimVec:Dot(dirToNPC)

            local disp = self:Disposition(ply)
            if self.RANDOMS_DEBUG then
                debugoverlay.Line(plyEyePos, targetPos, 0.3, Color(255, 255, 0), true)
                debugoverlay.Text(targetPos, "Dot: " .. math.Round(dot, 2) .. " Disp: " .. disp, 0.3)
            end

            if dot > 0.86 then 
                local tr = util.TraceHull({
                    start = plyEyePos,
                    endpos = targetPos,
                    mins = Vector(-10, -10, -10),
                    maxs = Vector(10, 10, 10),
                    filter = {self, ply},
                    mask = MASK_VISIBLE
                })
             
                if tr.Entity == self or (not tr.Hit and tr.Fraction > 0.9) then
                    if self.RANDOMS_DEBUG then debugoverlay.Sphere(targetPos, 15, 0.3, Color(255, 0, 0), true) end
                    self:PlyFlash_AlertHostile(ply)
                    return true
                end 
            end

            local trPly = ply:GetEyeTrace()
            local hitPos = trPly.HitPos
            if hitPos:DistToSqr(targetPos) < (self.PlyFlash_HpDetect_Range or 700 ^ 2) then 
                local trSee = util.TraceLine({
                    start = self:GetShootPos(),
                    endpos = hitPos,
                    filter = self
                })
                if trSee.Fraction > 0.9 then
                    self:SetNPCState(NPC_STATE_ALERT)
                    if curT > self.PlyFlash_NextMoveT and self:IsAbleToMoveNow() then
                        local moveGoal = hitPos
                        if math.random(1, 2) == 1 then
                            moveGoal = plyEyePos
                        end
                        if self.RANDOMS_DEBUG then 
                            debugoverlay.Sphere(hitPos, 10, 0.3, Color(0, 255, 255), true)
                        end
                        self:SetLastPosition(moveGoal)
                        self:Handle_ScheduledForceMove("Both", "LastPos", "Both", "Both", "Rng")
                        self.PlyFlash_NextMoveT = curT + 5
                    end
                    if disp == D_HT or disp == D_FR then
                        self:UpdateEnemyMemory(ply, plyEyePos)
                    end
                    return true
                end
            end
        end
    end 
    return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
//playing aruond with someone else code, most likely will remove later.
ENT.LegAngle_GesMoving = true
ENT.Leg_45DegAng = true 
ENT.Leg_90DegAng = true 
ENT.Leg_180DegAng = true 
ENT.Leg_ShuffleSnd = true 
ENT.Leg_ShuffleNextT = 0 
ENT._TurnGestureLayer = -1

function ENT:Marine_DoTurnGesture(deltaYaw)
    if not IsValid(self) then return end
    
    local absDelta = math.abs(deltaYaw)
    local isLeft = deltaYaw > 0
    local seqName
    local targetAngle = 0

    if absDelta > 180 and self.Leg_180DegAng then
        seqName = isLeft and "gesture_turn_left_180" or "gesture_turn_right_180"
        targetAngle = 180
    elseif absDelta > 70 and self.Leg_90DegAng then
        seqName = isLeft and "gesture_turn_left_90" or "gesture_turn_right_90"
        targetAngle = 90
    elseif absDelta > 25 and self.Leg_45DegAng then
        seqName = isLeft and "gesture_turn_left_45" or "gesture_turn_right_45"
        targetAngle = 45
    end
    
    if seqName then
        local seq = self:LookupSequence(seqName)
        if seq <= 0 then return end
        if self._TurnGestureLayer != -1 and self:IsValidLayer(self._TurnGestureLayer) then
            if self:GetLayerCycle(self._TurnGestureLayer) < 0.6 then
                return 
            end
        end
        if self.RANDOMS_DEBUG then
            print("Turn Type: " .. targetAngle .. " | Delta: " .. math.Round(deltaYaw, 2))
        end

        local layer = self:AddGestureSequence(seq, true)
        self._TurnGestureLayer = layer
        local speedMult = math.Clamp(absDelta / targetAngle, 0.8, 1.6)
        self:SetLayerPlaybackRate(layer, speedMult)
        local c  = CurTime()
        if c <= (self.Leg_ShuffleNextT or 0) then return end 

        local snd = table.Random({"npc/zombie/foot_slide" .. mRng(1, 3) .. ".wav"})
         if self.Leg_ShuffleSnd and mRng(1, 2) == 1 then 
            if snd then 
                self.Leg_ShuffleNextT = c + 2
                VJ.EmitSound(self, snd, 75, 100) 
            end 
        end 
    end
end

function ENT:Marine_TurnGestures()
    if not IsValid(self) then return end
    if not self.LegAngle_GesMoving then return end
    if not self:IsOnGround() then return end
    
    if self:IsMoving() then
        self._wasTurning = false
        self._lastYaw = self:GetAngles().y
        return
    end

    local currentYaw = self:GetAngles().y
    self._lastYaw = self._lastYaw or currentYaw
    
    local delta = math.AngleDifference(self._lastYaw, currentYaw)
    local absDelta = math.abs(delta)

    if not self._wasTurning then
        if absDelta > 3 then
            self._wasTurning = true
            self:Marine_DoTurnGesture(delta)
        end
    else
        local gestureFinished = true
        if self._TurnGestureLayer != -1 and self:IsValidLayer(self._TurnGestureLayer) then
            local cycle = self:GetLayerCycle(self._TurnGestureLayer)
            local weight = 1
            if cycle < 0.1 then
                weight = cycle / 0.1
            elseif cycle > 0.8 then
                weight = 1 - ((cycle - 0.8) / 0.2)
            end
            self:SetLayerWeight(self._TurnGestureLayer, weight)
            
            gestureFinished = cycle >= 0.98
        end
        if absDelta < 0.1 or gestureFinished then
            self._wasTurning = false
        end
    end
    self._lastYaw = currentYaw
end
---------------------------------------------------------------------------------------------------------------------------------------------

/*EO.StateFunctions.ASSAULT = function(ent, enemy)

    local dist = ent:GetPos():Distance(enemy:GetPos())

    ent:SetSchedule(
        dist > 600
        and SCHED_CHASE_ENEMY
        or SCHED_ESTABLISH_LINE_OF_FIRE
    )

    ent.NextSched = CurTime() + 3
end*/

//function ENT:Find_LOF()

    //fix snappy angles
ENT.Suppress_EnePos = true
ENT.Suppression_Time = 0
ENT.Suppression_NextT = 0
ENT.Suppression_StopDist = 100
ENT.Suppression_Chance = 1
ENT.Suppression_DelayT = 0
ENT.Suppression_ReadyToRoll = false

ENT.SuppressBurst_Min = 0.5
ENT.SuppressBurst_Max = 1.5
ENT.SuppressBurstPause_Min = 0.15
ENT.SuppressBurstPause_Max = 0.7
ENT.SuppressBurst_EndT = 0
ENT.SuppressBurst_PauseT = 0

function ENT:SuppressEnemyPosition()
    if not self.Suppress_EnePos then return end

    local curT = CurTime()

    local function ResetSuppression(applyDelay)
        self.LastKnownEnemyPos = nil
        self.Suppression_ReadyToRoll = false
        self.SuppressionEndTime = 0 

        -- Haven't properly tested out if this fixes snappiness. 
        if IsValid(self:GetEnemy()) then 
            self:SetTurnTarget("Enemy")
        else 
            self:SetTurnTarget(nil)
        end 

        if applyDelay then
            self.Suppression_DelayT = curT + mRng(2, 5)
        end
    end

    if self.VJ_IsBeingControlled then return end
    if self:IsVJAnimationLockState() or self.Flinching then return end
    if self:WaterLevel() > 2 then return end
    if self.PauseAttacks then return end
    if not self:CanFireWeapon(true, false) then return end
    if self:GetWeaponState() == VJ.WEP_STATE_RELOADING then return end
    if curT < (self.AnimLockTime or 0) then return end

    local supDebug = self.RANDOMS_DEBUG
    local enemy = self:GetEnemy()
    local canSeeEnemy = false

    if not IsValid(enemy) or (enemy:Health() <= 0 and not enemy.IsVJBaseBullseye) then
        if self.LastKnownEnemyPos then
            ResetSuppression(false)
        end
        return 
    end

    if IsValid(enemy) then
        local disp = self:Disposition(enemy)

        local isBullseye = enemy.IsVJBaseBullseye

        local isAlive =
            (enemy:IsPlayer() and enemy:Alive()) or
            ((enemy:IsNPC() or enemy:IsNextBot()) and (enemy:Health() > 0 or enemy:Alive() or not enemy.Dead)) or 
            isBullseye

        if isAlive and (disp == D_HT or disp == D_FR) then
            canSeeEnemy = self:Visible(enemy)
        else
            ResetSuppression(false)
            return
        end
    end

    if canSeeEnemy then
        local offset = VectorRand() * math.random(-75, 100)
        self.LastKnownEnemyPos = enemy:GetPos() + enemy:OBBCenter() + offset
        self.SuppressionEndTime = curT + (self.Suppression_Time or 3)
        self.Suppression_ReadyToRoll = true
        return
    end

    local suppressionActive = self.LastKnownEnemyPos and curT < (self.SuppressionEndTime or 0)
    if suppressionActive then
        if IsValid(enemy) and self:Visible(enemy) then
            ResetSuppression(true)
            return
        end

        if self.Suppression_ReadyToRoll then
            self.Suppression_ReadyToRoll = false
            local chance = self.Suppression_Chance or 3
            if curT < (self.Suppression_DelayT or 0)
            or mRng(1, chance) ~= 1 then
                if supDebug then
                    print("Suppression roll failed or on cooldown.")
                end
                ResetSuppression(true)
                return
            end
            self.SuppressBurst_EndT = curT + mRand(self.SuppressBurst_Min or 0.3, self.SuppressBurst_Max or 1.2)
        end

        local dist = self:GetPos():DistToSqr(self.LastKnownEnemyPos)
        if self:IsMoving() and dist > 40000 then
            return
        end

        local shootPos = self:GetShootPos()
        local tr = util.TraceLine({
            start = shootPos,
            endpos = self.LastKnownEnemyPos,
            filter = {self, self:GetActiveWeapon()}
        })

        if tr.HitWorld then
            if supDebug then
                print("World blocking suppression point.")
            end
            ResetSuppression(false)
            return
        end

        local stopDist = self.Suppression_StopDist or 100
        if self:GetPos():DistToSqr(self.LastKnownEnemyPos) < (stopDist * stopDist) then
            ResetSuppression(false)
            return
        end

        local wep = self:GetActiveWeapon()
        if not IsValid(wep) then return end
        if wep.IsMeleeWeapon then return end
        if wep:Clip1() <= 0 then return end

        if self:GetWeaponState() == VJ.WEP_STATE_RELOADING then
            return
        end

        local holdType = wep.HoldType or ""

        if holdType == "pistol" or holdType == "revolver" or holdType == "rpg" then return end

        local dir = (self.LastKnownEnemyPos - shootPos):GetNormalized()
        local targetAng = dir:Angle()

        self:SetIdealYawAndUpdate(targetAng.y)
        local localAng = self:WorldToLocalAngles(targetAng)
        if self:LookupPoseParameter("aim_yaw") ~= -1 then
            self:SetPoseParameter("aim_yaw", localAng.y)
            self:SetPoseParameter("aim_pitch", localAng.p)
        end
        
        if curT > (self.SuppressBurst_EndT or 0) then
            if curT > (self.SuppressBurst_PauseT or 0) then

                self.SuppressBurst_EndT = curT + mRand(self.SuppressBurst_Min or 0.3, self.SuppressBurst_Max or 1.2)
                self.SuppressBurst_PauseT = curT + mRand(self.SuppressBurstPause_Min or 0.2, self.SuppressBurstPause_Max or 0.8)
            end
            return
        end

        if curT > (self.Suppression_NextT or 0) then
            if wep.NPC_PrimaryAttack then
                wep:NPC_PrimaryAttack()
            else
                wep:PrimaryAttack()
            end
            self.Suppression_NextT = curT + (wep.NPC_NextPrimaryFire or 0.1)
        end
    else
        ResetSuppression(false)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
    self:Marine_TurnGestures()
end

function ENT:OnThinkActive()
    self:SuppressEnemyPosition()
    self:Idle_CoverPeekUp()
    self:Override_DefWepPcfx()
    self:Handle_WeaponTracerConv()
    self:Alter_WeaponFireStats()
    self:PlyFlash_IdleAlert()
    self:CheckFlashlightReaction()
    self:StealthMovement()
    self:CopyPlayerStance()
    self:IdleIncap_LastChanceGren()
    self:SeekOutMedic()
    self:HitWallWhenShoved()
    self:ContextToLean()
    self:IfSelfIsLoneMember()
    self:DistressOnCloseProximity()
    self:Idle_FindLoot()
    self:ControIfAllowedToAutoRevive()
    self:PlaceCombatFlare()
    self:RadioChatterSoundCode()
    self:OnFireBehavior()
    self:ReactToFire()
    self:SetReactToFireVars()
    self:ManageMoveAndShoot()
    self:ManageStrafeShoot()
    self:TrackHeldWeapon()
    self:WeaponSwitchMechanic()
    self:DefensiveWhenLowHealth()
    self:CanFireQuickFlare()
    self:FireQuickFlare()
    self:Idle_FidgetAnim()
    self:Avoid_PlyCrosshair()
    self:ManageWeaponBackAway()
    self:HumanFindMedicalEnt()
    self:CanPickUpWeapon()
    self:KickDoorDown()
    self:Disable_HpRegen()
    self:EnableCryForAid()
    self:Dodge_DangerousEnt()
    self:HumanEvadeAbility()
    //self:CombatChaseBehavior()
    self:CheckToBecomeIncapacitated()
    self:SetIncapVars()
    self:CheckToRecoverFromIncap()
    self:DetectLanding()
    self:HumanCanHealSelf()
    self:MngGrenadeAttackCount()
    self:WaterExtinguishSelFire()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HumanCanHealSelf()
    if not self.CanHumanHealSelf then return end 
    if self.CurrentlyHealSelf then return end

    local healConv = GetConVar("vj_stalker_heal_self"):GetInt()
    if healConv ~= 1 then return end 

    if self.IsCurrentlyIncapacitated then return end 
    if self.VJ_IsBeingControlled then return end

    local curT = CurTime()
    if curT <= self.HealSelf_NextT then return end 

    local maxHp = self:GetMaxHealth()
    local ground = self:IsOnGround()
    local moving = self:IsMoving()
    local busy =  self:IsVJAnimationLockState() or self:IsBusy()

    if busy then return false end

    local enemy = self:GetEnemy()
    local enemyValid = IsValid(enemy)
    local enemyVisible = enemyValid and self:Visible(enemy)
    local enemyDist = enemyValid and self:GetPos():DistToSqr(enemy:GetPos()) or math.huge
    if enemyVisible and enemyDist <= (1520 * 1520) then return end

    if self:InEneLineOfSight(enemy, 0.7) then
        return false
    end

    if self.Medic_PrioritizeAlly and self.IsMedic and self.Medic_CheckDistance <= 1 then
        local checkDist = tonumber(self.Medic_CheckDistance) or 2500
        local allies = self:Allies_Check(checkDist)
        local alHpPrior = self.Medic_AllyHpPrior

        if istable(allies) then
            for _, ally in ipairs(allies) do
                if IsValid(ally) and ally ~= self and ally:Health() < ally:GetMaxHealth() * alHpPrior then
                    return false
                end
            end
        end
    end

    if busy or moving or not ground or
       self:IsOnFire() or self.Medic_Status or self:Health() >= maxHp * 0.99 then
        return false
    end

    if self.FindCov_PriorSH then 
        if self:IsAbleToMoveNow() then 
            self:Handle_ScheduledForceMove(true , "Origin", true, "Run", "Rng")
        end 
    end 

    self.CurrentlyHealSelf = true
    if not self:Alive() then return end
    local initiateDelay = (self.HealSelfDelay or mRand(1, 5))  
    timer.Simple(initiateDelay, function()
        if not IsValid(self) then return end

        local curT2 = CurTime()
        local ground2 = self:IsOnGround()
        local moving2 = self:IsMoving()
        local busy2 =  self:IsVJAnimationLockState() or self:IsBusy() or self:GetWeaponState() == VJ.WEP_STATE_RELOADING
        local enemy2 = self:GetEnemy()
        local enemyVisible2 = IsValid(enemy2) and self:Visible(enemy2)
        local enemyTooClose = enemyVisible2 and self:GetPos():DistToSqr(enemy2:GetPos()) <= (1520 * 1520)

        if busy2 or moving2 or not ground2 or enemyTooClose or self:Health() >= maxHp * 0.99 then
            self.CurrentlyHealSelf = false
            return
        end

        self:BeforeHumanCanHealSelf()
        self:StopMoving()
        self:RemoveAllGestures()
        VJ.STOPSOUND(self.CurrentIdleSound)

        local anim = self:GetRandomValidValue(self.HealSelf_AnimTbl)
        if not anim then return end

        local seq = self:LookupSequence(anim)
        if seq <= 0 then return end

        local animT = self:SequenceDuration(seq) + 0.1  or 1
        self:PlayAnim("vjseq_" .. anim, true, animT, false)
        self:SetState(VJ_STATE_ONLY_ANIMATION_CONSTANT, animT) 

        timer.Simple(animT, function()
            if not IsValid(self) then return end
            if not moving2 and ground2 then
                local healAmount = self.Medic_HealAmount or 30
                if self.SelfHeal_Fail then 
                    local chance = self.SelfHeal_FailChance or 15
                    if mRng(1, chance) == 1 then
                        healAmount = maxHp * 0.25
                    end
                end 
                local newHealth = math_Clamp(self:Health() + healAmount, 0, maxHp)
                self:SetHealth(newHealth)
                self:OnMedicBehavior("OnHeal")
                local rngSnd = mRng(75, 105)
                VJ.EmitSound(self, "items/smallmedkit1.wav", 75, rngSnd)
                self:RemoveAllDecals()

                if mRng(1, 2) == 1 then
                    self:PlaySoundSystem("Speech", self.SoundTbl_Pain)
                end
            end
            self.CurrentlyHealSelf = false
            self.HealSelf_NextT = curT2 + mRand(5, 15)
            self:SetState()
        end)
    end)
end

function ENT:BeforeHumanCanHealSelf()
    if not self.CurrentlyHealSelf then return end

    local validAttachmentName = nil
    local attachmentData = nil

    for _, attName in ipairs(self.SelfHeal_HandAtt) do
        local attachmentIndex = self:LookupAttachment(attName)
        if attachmentIndex and attachmentIndex > 0 then
            validAttachmentName = attName
            attachmentData = self:GetAttachment(attachmentIndex)
            break 
        end
    end

    if not validAttachmentName then
        local fallbackAtt = self.Medic_SpawnPropOnHealAttachment
        if isstring(fallbackAtt) and fallbackAtt ~= "" then
            local id = self:LookupAttachment(fallbackAtt)
            if self.RANDOMS_DEBUG then
                print("Checking fallback attachment:", fallbackAtt, "Index:", id)
            end
            if id and id > 0 then
                validAttachmentName = fallbackAtt
                attachmentData = self:GetAttachment(id)
            end
        end
    end

    if not validAttachmentName or not attachmentData then
        return
    end

    local propRemoveT = 0.85 
    local healItem = ents.Create("prop_dynamic")
    if not IsValid(healItem) then return end 
    healItem:SetModel("models/healthvial.mdl") 
    healItem:SetPos(attachmentData.Pos) 
    healItem:SetAngles(attachmentData.Ang) 
    healItem:SetParent(self) 
    healItem:Spawn()
    healItem:Activate()
    healItem:Fire("SetParentAttachment", validAttachmentName)
    healItem:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE) 
    healItem:SetSolid(SOLID_NONE) 
    healItem:SetRenderMode(RENDERMODE_TRANSALPHA) 
    SafeRemoveEntityDelayed(healItem, propRemoveT) 
    self:DeleteOnRemove(healItem)

    timer.Simple(propRemoveT, function()
        if IsValid(self) then
            local dropVial = ents.Create("prop_physics")
            dropVial:SetModel("models/healthvial.mdl")
            dropVial:SetPos(attachmentData.Pos + Vector(0, 0, 10))
            dropVial:SetAngles(attachmentData.Ang)
            dropVial:Spawn()
            dropVial:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
            SafeRemoveEntityDelayed(dropVial, 5)
        end
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
//MIGHT RE-ADD IN FURURE
/*ENT.DisableChasingAmidstCombat = false 
ENT.NextStateChangeTime = mRand(2,5) 
ENT.ChaseDisabledUntil = 0  
ENT.CombatChaseSateGreen = false 
function ENT:CombatChaseBehavior()
    local ene = self:GetEnemy()
    if not self.DisableChasingAmidstCombat or not IsValid(ene) or self.Dead or self.VJ_IsBeingControlled or self.AtVeryLowHealth then return end 
    if CurTime() > self.NextStateChangeTime and VJ.GetNearestDistance(self, ene, true) <= 2200 and self.Alerted then
        if self.DisableChasingEnemy == false then
            self.DisableChasingEnemy = true
            self.CombatChaseSateGreen = true
            self.WaitingForEnemyToComeOut = true
            //self:SetColor(Color(0, 255, 0))
            local disableTime = mRand(5, 25) 
            self.ChaseDisabledUntil = CurTime() + disableTime
        else

            if CurTime() > self.ChaseDisabledUntil then
                -- Re-enable chasing (red phase)
                self.DisableChasingEnemy = false
                self.CombatChaseSateGreen = false
                self.WaitingForEnemyToComeOut = false
                //self:SetColor(Color(255, 0, 0)) 
                local enableTime = mRand(15, 35) 
                self.NextStateChangeTime = CurTime() + enableTime
            end
        end
    end
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:InEneLineOfSight(ene, viewDotThreshold)
    if not IsValid(ene) then return false end

    viewDotThreshold = viewDotThreshold or 0.7 -- ~45

    local eneEyePos
    if ene.IsPlayer and ene:IsPlayer() then
        eneEyePos = ene:EyePos()
    else
        eneEyePos = (ene.EyePos and ene:EyePos()) or (ene.GetPos and (ene:GetPos() + ( ne:OBBCenter() or Vector(0,0,48)))) or ene:GetPos()
    end

    local eneForward = (ene.IsPlayer and ene:IsPlayer()) and (ene:EyeAngles():Forward()) or ((ene:GetForward()) or Vector(0,0,1))
    local myEyePos = (self.EyePos and self:EyePos()) or (self.GetPos and (self:GetPos() + (self:OBBCenter() or Vector(0,0,36)))) or self:GetPos()
    local toSelf = (myEyePos - eneEyePos)

    if toSelf:IsZero() then
        toSelf = (self:GetPos() - eneEyePos)
    end
    toSelf:Normalize()

    local viewDot = eneForward:Dot(toSelf)
    local enemyLookingAtSelf = (viewDot >= viewDotThreshold)

    /*if self.RANDOMS_DEBUG then
        print(("LOS viewDot=%.3f | threshold=%.2f | enemyLooking=%s"):format(viewDot, viewDotThreshold, tostring(enemyLookingAtSelf)))
    end*/

    return enemyLookingAtSelf
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HumanEvadeAbility()
    if not self.CombatEvade then return end
    local conv = GetConVar("vj_stalker_dodging"):GetInt()
    if not conv or conv ~= 1 then return end 
    if self.VJ_IsBeingControlled then return end 
    if self.IsEvadingDanger or self.IsHumanDodging then return end 

    local right, forward, up = self:GetRight(), self:GetForward(), self:GetUp()

    local rngSnd = mRng(85, 105)

     local ene = self:GetEnemy()
    if not IsValid(ene) then return false end 

    local busy = self:IsBusy() or  self:IsVJAnimationLockState() 
    if busy then return false end 


    if self.IsGuard or self:Health() < (self:GetMaxHealth() * mRand(0.2,0.33)) or self.CurrentlyLeaning then
        return false
    end
    
    if not self:InEneLineOfSight(enemy, 0.7) then
        //if self.RANDOMS_DEBUG then print("Not in ene sight, no need to dodge") end
        return false
    end

    local minEneDist = self.Dodge_EneMin_Dist or 700
    local maxEneDist = self.Dodge_EneMax_Dist or 6000 
    local distToEnemy = self:GetPos():Distance(ene:GetPos())
    if distToEnemy <= minEneDist or distToEnemy >= maxEneDist then return end

    local pos = self:GetPos() + self:OBBCenter()
    local inCover = self:DoCoverTrace(pos, eneEyePos, false, {SetLastHiddenTime = true})
    if inCover then return end
    local cT = CurTime()
    if IsValid(ene) and not cT < self.TakingCoverT and self:Visible(ene) and not self.Flinching and self.WeaponAttackState == VJ.WEP_ATTACK_STATE_FIRE_STAND and cT > self.Dodge_NextT and not self:IsMoving() and self:IsOnGround() and not busy then
        self:StopAttacks(true)
        self.IsHumanDodging = true
        self.Dodge_NextT = cT + mRand(5, 35)

        local DodgeDirection2 = self.CombatRoll and mRng(1, 3) or mRng(4, 7)
        if self.RANDOMS_DEBUG then print("Dodge type chosen: " .. DodgeDirection2 .. " | CombatRoll: " .. tostring(self.CombatRoll)) end 

        local DodgeAnim, DodgeVel = "", Vector(0,0,0)
        local DupDodgeAnim = "leanwall_Left_B_exit" 
        local dodgeAnimDuration = 0 
        local wep = self:GetActiveWeapon()
        local meleeWeapon = wep.IsMeleeWeapon

        local dir
        if DodgeDirection2 == 1 then dir = forward
        elseif DodgeDirection2 == 2 then dir = right
        elseif DodgeDirection2 == 3 then dir = -right
        elseif DodgeDirection2 == 4 then dir = -right
        elseif DodgeDirection2 == 5 then dir = -forward
        elseif DodgeDirection2 == 6 then dir = -right
        elseif DodgeDirection2 == 7 then dir = -forward end

        local posi = self:GetPos()
        local tr = util.TraceHull({
            start = posi,
            endpos = posi + dir * mRng(200, 300),
            mins = self:OBBMins(),
            maxs = self:OBBMaxs(),
            filter = self
        })

        local rngUp = mRand(60, 95)
        if not tr.Hit then
            -- Unique combat rolls
            local sharedFrce = mRand(700, 1050)
            local rollFrwdMax = self.Dodge_RollF_MxDist or 1250
            if DodgeDirection2 == 1 and distToEnemy > rollFrwdMax then
                DodgeAnim = "roll_forward"
                DodgeVel = (forward * sharedFrce) + up * rngUp
            elseif DodgeDirection2 == 2 then
                DodgeAnim = "roll_right"
                DodgeVel = (right * sharedFrce) + up * rngUp
            elseif DodgeDirection2 == 3 then
                DodgeAnim = "roll_left"
                DodgeVel = (right * -sharedFrce) + up * rngUp

            -- Default dodge anims 
            local sharedFrce2 = mRand(-350, -1000)
            elseif DodgeDirection2 == 4 and not meleeWeapon then
                DodgeAnim = DupDodgeAnim
                DodgeVel = (right * dodge) + up * rngUp
            elseif DodgeDirection2 == 5 and not meleeWeapon then
                DodgeAnim = DupDodgeAnim
                DodgeVel = (forward * dodge) + up * rngUp
            elseif DodgeDirection2 == 6 and not meleeWeapon then
                DodgeAnim = DupDodgeAnim
                DodgeVel = (right * dodge) + up * rngUp
            elseif DodgeDirection2 == 7 and not meleeWeapon then
                DodgeAnim = DupDodgeAnim
                DodgeVel = (forward * (math_floor(dodge / 2))) + up * rngUp + right * mRand(-500, 500)
            end

            local seq = self:LookupSequence(DodgeAnim)
            if not seq or seq < 0 then return end 

            dodgeAnimDuration = self:SequenceDuration(seq) or 2

            self:PlayAnim("vjseq_" .. DodgeAnim, true, dodgeAnimDuration, false)
            self:SetVelocity(DodgeVel)

            local rollSound = self.SoundTbl_SNPCRoll

            if rollSound and #rollSound > 0 then
                local snd;

                if istable(rollSound) then
                    snd = table.Random(rollSound)
                else
                    snd = rollSound
                end

                if snd then
                    VJ.EmitSound(self, snd, 70, rngSnd)
                end
            end
        else
            self.IsHumanDodging = false
            self.Dodge_NextT = cT
            return
        end

        timer.Simple(dodgeAnimDuration + 0.1, function()
            if IsValid(self) then
                self.IsHumanDodging = false
            end
        end)
    end
end

//BUG: SNPCS RARELY EVER DODGE OR DON'T USE THE ELSE BLOCK. 
ENT.Evade_IncDanger  = true 
ENT.IsEvadingDanger = false 
ENT.DangerousEnt_Tbl = {
        "obj_vj_grenade_rifle", "obj_gonome_electric_bolt", "obj_vj_corrosive_proj", 
        "prop_combine_ball", "grenade_ar2", "rpg_missile", "apc_missile", 
        "grenade_helicopter", "obj_vj_gonome_spit", "obj_vj_flesh_projectile_human", 
        "obj_vj_floater_projectile_human", "obj_vj_floater_projectile_nest", 
        "obj_vj_humanimal_spit", "obj_vj_humanimal_rock_debri", "obj_vj_humanimal_flesh_projectile",
        "obj_vj_rocket", "obj_vj_combineball", "obj_vj_crossbowbolt", "crossbow_bolt"}

ENT.DodgeAnim_Right = "Roll_Right"
ENT.DodgeAnim_Left = "Roll_Left"
ENT.EvadeDanger_NextT = 0 
ENT.EvadeDanger_Chance = 2 
ENT.EvadeDanger_MaxDist = 1000 
ENT.EvadeDanger_MinDist = 250
function ENT:Dodge_DangerousEnt()
    if not self.Evade_IncDanger then return end 
    if not IsValid(self) then return end

    local cvar = GetConVar("vj_stalker_passively_dodge_incom_danger")
    if not cvar or cvar:GetInt() ~= 1 then return end

    if self.VJ_IsBeingControlled then return end
    if not self:IsOnGround() then return end

    if self.IsHumanDodging or self.IsCurrentlyPlayingBurnAnim then
        return
    end

    local busy = self:IsBusy() or  self:IsVJAnimationLockState() or self.Flinching
    if busy then return end 

    local cT = CurTime()
    if cT < (self.EvadeDanger_NextT or 0) then return end

    local requiresVis = GetConVar("vj_stalker_dent_dodge_requires_visibility"):GetInt() == 1

    local function IsInFieldOfView(ent)
        local dir = (ent:GetPos() - self:GetPos()):GetNormalized()
        return self:GetForward():Dot(dir) > -0.5
    end

    if mRng(1, self.EvadeDanger_Chance or 2) ~= 1 then 
        self.EvadeDanger_NextT = CurTime() + mRand(3, 9)
        return 
    end 

    local function ResolveDodgeAnim(animVar)
        if animVar == false then return nil end
        if isstring(animVar) then return animVar end
        if istable(animVar) and #animVar > 0 then
            return animVar[mRng(1, #animVar)]
        end
        return nil
    end

    local max = self.EvadeDanger_MaxDist or 1200 
    local min = self.EvadeDanger_MinDist or 300 
    local dodgeRange = math.min(min, mRng(min, max))
    local findPos = self:GetPos() + self:OBBCenter()

    for _, dangerEnt in ipairs(ents.FindInSphere(findPos, dodgeRange)) do
        if not IsValid(dangerEnt) then continue end
        if dangerEnt:GetOwner() == self then continue end
        if not table.HasValue(self.DangerousEnt_Tbl, dangerEnt:GetClass()) then continue end

        if requiresVis then
            if not self:Visible(dangerEnt) or not IsInFieldOfView(dangerEnt) then
                continue
            end
        end

        self.IsEvadingDanger = true
        self:ClearSchedule()
        self:StopAttacks(true)

        local leftAnim  = ResolveDodgeAnim(self.DodgeAnim_Left)
        local rightAnim = ResolveDodgeAnim(self.DodgeAnim_Right)

        local rollDirection, dodgeAnim = nil, nil

        if leftAnim and rightAnim then
            if mRand(1, 2) == 1 then
                rollDirection, dodgeAnim = "Left", leftAnim
            else
                rollDirection, dodgeAnim = "Right", rightAnim
            end
        elseif leftAnim then
            rollDirection, dodgeAnim = "Left", leftAnim
        elseif rightAnim then
            rollDirection, dodgeAnim = "Right", rightAnim
        end

        if rollDirection and dodgeAnim then
            local seq = self:LookupSequence(dodgeAnim)
            if not seq or seq < 0 then return end 
            local animDur = self:SequenceDuration(seq) or 1.25

            self:RemoveAllGestures()
            self:PlayAnim("vjseq_" .. dodgeAnim, true, animDur, false)

            local right = self:GetRight()
            local up = self:GetUp()
            local rngVel = mRand(850, 1000)
            local vel = (rollDirection == "Left" and right * -rngVel or right * rngVel) + up * mRand(50, 125)

            self:SetVelocity(vel)

            self.EvadeDanger_NextT = cT + mRand(1.5, 5.25)

            timer.Simple(animDur + 0.1, function()
                if IsValid(self) then
                    self.IsEvadingDanger = false
                end
            end)

        else
            if not self:IsAbleToMoveNow() then return end 
            self:Handle_ScheduledForceMove(true , "Origin", true, "Run", "Rng")
            self.EvadeDanger_NextT = cT + mRand(2, 4)
            self.IsEvadingDanger = false
        end
        break
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Disable_HpRegen()
    local regenParams = self.HealthRegenParams
    if not regenParams or not regenParams.Enabled then return end
    if self._CacheDefault_RegenStat == nil then
        self._CacheDefault_RegenStat = regenParams.Enabled
    end

    if self:IsOnFire() or self.IsCurrentlyIncapacitated then
        regenParams.Enabled = false
    else
        regenParams.Enabled = self._CacheDefault_RegenStat
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilledEnemy(ent, inflictor, wasLast)
    self:Taunt_AnimHandle(ent, inflictor, wasLast)
end

function ENT:Taunt_AnimHandle(ent, inflictor, wasLast)
    if not self.TauntKill_OnEne then return end 
    if self.VJ_IsBeingControlled then return end 
    
    local cvTauntKill = tostring(self.TauntKill_Conv)
    local conv = GetConVar(cvTauntKill)
    if conv and conv:GetInt() ~= 1 then return end

    local selfWep = self:GetActiveWeapon()
    if not IsValid(selfWep) then return end 

    if not IsValid(inflictor) or inflictor ~= self then return end 
    if not self:IsOnGround() or self:IsMoving() then return end 
    if self:IsBusy("Activities") or self.Flinching or self:IsVJAnimationLockState() then return end

    local cT = CurTime()
    if cT < self.TauntKill_NextT then return end

    local enemy = self:GetEnemy()
    if IsValid(enemy) then
        if enemy:Health() <= 0 or not enemy:Alive() then
            enemy = nil
        end
    end

    //No taunting if we got an enemy
    if IsValid(enemy) then
        local canSeeEnemy = self:Visible(enemy)
        local distSqr = self:GetPos():DistToSqr(enemy:GetPos())
        local hasEnemyWeapon = IsValid(enemy:GetActiveWeapon())

        if canSeeEnemy and hasEnemyWeapon then return end

        local max = self.TauntKill_MaxDist or 2500 
        if not canSeeEnemy and distSqr >= (max * max) then return end

        local min = self.TauntKill_MinDist or 1500
        if distSqr < (min * min) then return end
    end

    local chance = self.TauntKill_Chance or 3
    if mRng(1, chance) ~= 1 then return end

    local delay = mRand(0.25, 1)

    local seqTbl = self:GetRandomValidValue(self.TauntKill_SeqAnimTbl)
    local gesTbl = self:GetRandomValidValue(self.TauntKill_GesAnimTbl)

    local doSequence = false
    local at = 0

    local doSequence = seqTbl and gesTbl and mRng(1,2) == 1
    if seqTbl and not gesTbl then
        doSequence = true
    elseif gesTbl and not seqTbl then
        doSequence = false
    end

    local seq = seqTbl and self:LookupSequence(seqTbl) or -1
    if seq and seq > 0 then 
        at = self:SequenceDuration(seq) or 1 
    end 

    timer.Simple(delay, function()
        if not IsValid(self) then return end
        if self:IsBusy() then return end
        self:RemoveAllGestures()

        local c = CurTime()
        if doSequence and seqTbl then
            self:PlayAnim("vjseq_" .. seqTbl, true, at, false)
            self.TauntKill_NextT = c + at + mRand(2, 4)
        else
            if gesTbl then 
                self:PlayAnim("vjges_" .. gesTbl)
                self.TauntKill_NextT = c + mRand(5, 10)
            end
        end 
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RadioChatterSoundCode(CustomTbl)
    if not self.HasSounds or not self.HasRadioChatDialogue then return end
    if not self:Alive() then
        if GetConVar("vj_stalker_radio_death_cancel"):GetInt() == 1 then
            if self.CurrentRadioChatSound then 
                self.CurrentRadioChatSound:Stop() 
                self.CurrentRadioChatSound = nil 
            end
        end
        return 
    end

    local cT = CurTime()
    if cT > self.NextRadioDialogueT then
        local randsound = mRng(1, self.RadioDialogieChance)
        local soundtbl = self.SoundTbl_BackgroundRadioDialogue
        if CustomTbl != nil and #CustomTbl != 0 then soundtbl = CustomTbl end
        if randsound == 1 and VJ.PICK(soundtbl) != false then
            if self.CurrentRadioChatSound then self.CurrentRadioChatSound:Stop() end
            self.IdleSoundBlockTime = cT + mRand(1, 5) 
            self.CurrentRadioChatSound = VJ.CreateSound(self, soundtbl, self.BackGround_RadioLevel or 70, self:GetSoundPitch(self.BackGround_RadioPitch1 or 75, self.BackGround_RadioPitch2 or 100))
        end
        self.NextRadioDialogueT = cT + mRand(self.NextSoundTime_RadioDialogue1 or 15, self.NextSoundTime_RadioDialogue2 or 25)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EnableCryForAid()
    if not self.HasCryForAidSounds then return end 
    if IsValid(self) and self.IsCurrentlyIncapacitated then
        self:CryForAidSoundCode()
    end
end

function ENT:CryForAidSoundCode(CustomTbl)
    if not self.HasSounds or not self.HasCryForAidSounds then return end
    local curT = CurTime()
    if curT > self.NextCryForAidSoundT then
        local randsound = mRng(1, self.CryForAidSoundChance)
        local soundtbl = self.SoundTbl_CryForAid
        if CustomTbl and #CustomTbl ~= 0 then soundtbl = CustomTbl end
        
        if randsound == 1 and VJ.PICK(soundtbl) != false then
            if self.CurrentHasCryForAidSound then 
                self.CurrentHasCryForAidSound:Stop() 
            end
            
            VJ.STOPSOUND(self.CurrentIdleSound)
            self.IdleSoundBlockTime = curT + mRand(1, 3)
            self.CurrentHasCryForAidSound = VJ.CreateSound(self, soundtbl, self.CryForAidSoundLevel or 70, self:GetSoundPitch(self.CryForAidSoundPitch1 or 75, self.CryForAidSoundPitch2 or 100))
            
            self.NextCryForAidSoundT = curT + mRand(self.CryForAid_NextT1 or 5, self.CryForAid_NextT2 or 10)
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSightDirection()
    local EyesAttachmentIndex = self:LookupAttachment("eyes")
    if EyesAttachmentIndex > 0 then
        local EyesAttachment = self:GetAttachment(EyesAttachmentIndex)
        if EyesAttachment then
            return EyesAttachment.Ang:Forward()
        end
    end
    return self:GetForward()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAllyKilled(ent)
    self:FleeOnAllyDeath_Context()
    self:AllyDieNearbyDebuff(ent)
end

ENT.Ally_DieDb = true 
ENT.Ally_DieDb_MxDist = 2500 
ENT.Ally_DieDbChance = 4
ENT.Ally_DieDbNextT = 0 
ENT.Ally_DieDb_DelAtt = true 
ENT.Ally_DieDb_DelAttChance = 3 
function ENT:AllyDieNearbyDebuff(ally)
    if not self.Ally_DieDb then return end 

    local conv = GetConVar("vj_stalker_ally_death_debuff"):GetInt()
    if not conv or conv ~= 1 then return end 

    if not IsValid(ally) then return end 

    local dist = self:GetPos():Distance(ally:GetPos())
    local maxDist = self.Ally_DieDb_MxDist or 2000
    
    if dist > maxDist then return end 
    if self.RANDOMS_DEBUG then print("[Ally killed Debuff] our friendly who died was " .. ally:GetClass()) end 

    local chance = self.Ally_DieDbChance or 3 
    if not IsValid(self:GetEnemy()) then 
        chance = math.min(1, math_floor(chance / 2))
    end 

    if mRng(1, chance) ~= 1 then return end 

    if CurTime() < self.Ally_DieDbNextT then return end 
    
    local cmnDel = mRand(2, 6)
    local c = CurTime()

    self.TakingCoverT = c + math.min(1, math_floor(cmnDel / 2))
    self.NextChaseTime = c + cmnDel
    self.Ally_DieDbNextT = c + cmnDel

    local delayConv = GetConVar("vj_stalker_ally_death_delay_attack"):GetInt()
    if not self.Ally_DieDb_DelAtt then return end 
    if not delayConv or delayConv ~= 1 then return end 
    if mRng(1, self.Ally_DieDb_DelAttChance or 3) ~= 1 then return end 
    self.NextDoAnyAttackT = c + mRand(0.25, 2)
end

function ENT:FleeOnAllyDeath_Context()
    if not self.Flee_OnAllyDeath then return end 

    local conv = GetConVar("vj_stalker_ally_death_flee"):GetInt()
    if not conv or conv ~= 1 then return end 

    if self.VJ_IsBeingControlled then return end 
    if not self:IsAbleToMoveNow() then return end 
    if not self:IsOnGround() then return end 

    local deFlg = self.RANDOMS_DEBUG
    local curT = CurTime()
    if (self.NextDoAnyAttackT + 2) > curT then
        return
    end
    
    local cmbChance = tonumber(self.Flee_CombatChance) or 10 
    local idleChance = tonumber(self.Flee_IdleChance) or 5 
    local panicVoice = table.Random({"Alert", "CallForHelp"})
    local nSt = self:GetNPCState()
    local isAlertedOrHasEnemy = IsValid(self:GetEnemy()) or nSt == NPC_STATE_ALERT or nSt == NPC_STATE_COMBAT
    local panicChance;

    if isAlertedOrHasEnemy then
        panicChance = cmbChance
        if deFlg then print("Alert/Combat panic chance: 1 in " .. cmbChance) end 
    else
        panicChance = idleChance
        if deFlg then print("Idle panic chance: 1 in " .. idleChance) end 
    end
    
    if mRng(1, panicChance) == 1 and not self.IsPanicked and curT > (self.PanicCooldownT or 0) then 
        if deFlg then print("Panic triggered! (Chance was 1 in " .. panicChance .. ")") end 
        self.IsPanicked = true
        if mRng(1, 2) == 1 then 
            self:PlaySoundSystem(panicVoice)
        end 
        self:StartFlee(isAlertedOrHasEnemy)
        self.PanicCooldownT = curT + mRand(5, 15)
    else
        if deFlg then  print("Panic not triggered. (Chance was 1 in " .. panicChance .. ")") end 
    end
end 

function ENT:StartFlee(inCombat)
    if self.VJ_IsBeingControlled then return end 
    if not self.Flee_OnAllyDeath then return end 
    if not self.IsPanicked then return end 

    local curT = CurTime()
    local checkDist = mRand(250, 925)
    local move = "TASK_RUN_PATH"
    if self.IsPanicked and not self:IsBusy("Activities") then

        self.IsPanicked = false
        self:ClearSchedule()
        self:StopMoving()
        timer.Simple(0, function()
            if IsValid(self) then 
                if inCombat then
                    self:SCHEDULE_COVER_ENEMY(move, function(x)
                        x.DisableChasingEnemy = true
                        x.CanBeInterrupted = true
                        if mRng(1, 2) == 1 then 
                            x.CanShootWhenMoving = true
                            x.TurnData = {Type = VJ.FACE_ENEMY}
                        else
                            x.CanShootWhenMoving = false  
                            x.TurnData = {Type = VJ.FACE_ENEMY, Target = nil}
                        end 
                        x.RunCode_OnFail = function()
                            self.NextDoAnyAttackT = 0
                        end
                    end)
                else
                    local moveCheck = VJ.PICK(VJ.TraceDirections(self, "Quick", checkDist, true, false, 8, true))
                    if moveCheck then
                        self:SetLastPosition(moveCheck)
                        self:SCHEDULE_GOTO_POSITION(move, function(x)
                            x.DisableChasingEnemy = true
                            x.CanBeInterrupted = true
                            if mRng(1, 2) == 1 then 
                                x.CanShootWhenMoving = true
                                x.TurnData = {Type = VJ.FACE_ENEMY}
                            else
                                x.CanShootWhenMoving = false  
                                x.TurnData = {Type = VJ.FACE_ENEMY, Target = nil}
                            end 

                            x.RunCode_OnFail = function()
                                self.NextDoAnyAttackT = 0
                            end
                        end)
                    end
                end
                local delayConv = GetConVar("vj_stalker_ally_death_delay_attack"):GetInt()
                if delayConv and delayConv == 1 then 
                    self.NextDoAnyAttackT = curT + mRand(0.5, 2.5)
                end 
            end
        end)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Slightly Modified version of Darkborn's Dynamic Footstep code -- \
function ENT:Dynamic_FeetSteps()
    if not self.HasSounds or not self.HasFootstepSounds or not self.Has_DynamicFootsteps then return end 
    if self.CrouchMovement then return end 

    local waterLvl = self:WaterLevel()
    local onGround = self:IsOnGround()

    if waterLvl > 0 and waterLvl < 3 then
        if self.WaterSplashSounds and #self.WaterSplashSounds > 0 then
            local waterStep = table.Random(self.WaterSplashSounds)
            local rngP = mRng(75, 105)
            VJ.EmitSound(self, waterStep, 75, rngP)
        end
    end

    if not onGround then return end
    local pos = self:GetPos()
    local rngP = mRng(75, 105)
    local chance = 3

    if self.HasEquipmentRustle and mRng(1, chance) == 1 then 
        local tbl = self.EquipmentClanging_Tbl
        if tbl and #tbl > 0 then
            VJ.EmitSound(self, table.Random(tbl), 70, rngP)
        end
    end 

    if self.HasClothingRustle and mRng(1, chance) == 1 then 
        local tbl = self.ClothingRustling_Tbl
        if tbl and #tbl > 0 then
            VJ.EmitSound(self, table.Random(tbl), 65, rngP)
        end
    end 

    local tr = util.TraceLine({
        start = pos + Vector(0, 0, 10), 
        endpos = pos + Vector(0, 0, -20),
        filter = self
    })

    if tr.Hit then
        local mat = tr.MatType
        local sounds = self.FootSteps and self.FootSteps[mat]
        if sounds and #sounds > 0 then
            VJ.EmitSound(self, table.Random(sounds), 75, rngP)
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnWeaponReload()
    self:Reload_Reposition()
end

function ENT:Reload_Reposition()
    if not self.Repos_GesReload then return end

    local conv = GetConVar("vj_stalker_reposition_while_reloading")
    if not conv or conv:GetInt() ~= 1 then return end

    if self.VJ_IsBeingControlled then return end
    if not self:IsAbleToMoveNow() then return end 
    if not self.Weapon_CanReload then return end 

    local ene = self:GetEnemy()
    local traceDist = (mRand and mRand(550, 1250)) or mRng(550,1250)
    local reposChance = tonumber(self.Repos_GesReloadChance) or 3
    local c = CurTime()

    if c > self.Repos_GesReloadNextT then 
        if self:IsBusy("Activities") or self:IsVJAnimationLockState() then return end 
                                        
        local sched = self:GetCurrentSchedule() or nil
        if sched == SCHED_TAKE_COVER_FROM_ENEMY or sched == SCHED_HIDE_AND_RELOAD or sched == SCHED_TAKE_COVER_FROM_ORIGIN then
            return
        end

        if (not IsValid(ene)) or (mRng and mRng(1,3) == 1 and self.Weapon_FindCoverOnReload) or (self:DoCoverTrace(self:GetPos() + self:OBBCenter(), ene and ene:EyePos() or vector_origin, false, {SetLastHiddenTime = true})) then
            return
        end

        local reloadAnimTbl = (self.AnimationTranslations and self.AnimationTranslations[ACT_GESTURE_RELOAD]) or nil
        local reloadAnim = nil
        if istable(reloadAnimTbl) then
            reloadAnim = table.Random(reloadAnimTbl) or reloadAnimTbl[mRng(#reloadAnimTbl) ]
        elseif isstring(reloadAnimTbl) then
            reloadAnim = reloadAnimTbl
        end

        local moveRun = "TASK_RUN_PATH"
        local mix = table.Random({moveRun, "TASK_WALK_PATH"}) or moveRun
        local delT = mRand(1, 10)

        local function HandleSchedStuff(task)
            task:EngTask("TASK_FACE_ENEMY", 0)
            task.CanBeInterrupted = true
            task.CanShootWhenMoving = true
            task.TurnData = {Type = VJ.FACE_ENEMY}
        end 

        if reloadAnim then
            local gestureReloadAnim = reloadAnim
            self.AnimTbl_WeaponReload = {gestureReloadAnim}
            self:ClearSchedule()

            if mRng(1, reposChance) == 1 then
                timer.Simple(0, function()
                    if not IsValid(self) then return end
                    if (mRng and mRng(1,2) == 1) or (not mRng and mRng(1,2) == 1) then
                        if self.SCHEDULE_COVER_ORIGIN then
                            self:SCHEDULE_COVER_ORIGIN(moveRun, function(x)
                                HandleSchedStuff(x)
                            end)
                        end
                    else
                        local directions = {}
                        if VJ.TraceDirections then
                            directions = VJ.TraceDirections(self, "Quick", traceDist, true, false, 8, true) or {}
                        end
                        
                        local moveCheck = nil
                        if istable(directions) and #directions > 0 then
                            moveCheck = VJ.PICK(directions) or directions[ mRng(#directions) ]
                        end

                        if moveCheck and self.SetLastPosition and self.SCHEDULE_GOTO_POSITION then
                            self:SetLastPosition(moveCheck)
                            self:SCHEDULE_GOTO_POSITION(mix, function(x)
                                HandleSchedStuff(x)
                            end)
                        end

                        local c2 = CurTime()
                        self.TakingCoverT = c2 + delT
                        self.Repos_GesReloadNextT = c2 + delT 
                    end
                end)
            end
        end
        return true
    end 
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetAnimationTranslations(wepHoldType)
    local SequenceToActivity = SequenceToActivity
    if self.Custom_WeaponTranslation then 
        local coverLow = VJ.PICK({ACT_COVER_LOW, "Leanwall_CrouchLeft_A_idle", "Leanwall_CrouchLeft_B_idle", "Leanwall_CrouchLeft_C_idle", "Leanwall_CrouchLeft_D_idle"})
        
        self.AnimationTranslations[ACT_RANGE_ATTACK2] 				    = VJ.SequenceToActivity(self, "shoot_ar2_alt")
        self.AnimationTranslations[ACT_COVER_LOW] 					    = coverLow

        if wepHoldType == "smg" then 
            local cover = VJ.PICK({ACT_COVER, VJ.SequenceToActivity(self, "vjseq_crouch_idled"), VJ.SequenceToActivity(self, "vjseq_pd2_cidle"), VJ.SequenceToActivity(self, "vjseq_crouch_idle_rpg")})
            local rangeAttack = VJ.PICK({ACT_RANGE_ATTACK_SMG1, ACT_RANGE_ATTACK_AR2})
            local gesRangeAttack = VJ.PICK({ACT_GESTURE_RANGE_ATTACK_AR2,ACT_GESTURE_RANGE_ATTACK_AR1,ACT_GESTURE_RANGE_ATTACK_SMG1,ACT_GESTURE_RANGE_ATTACK_SMG2})
            local reload = VJ.PICK({VJ.SequenceToActivity(self, "Reload"), VJ.SequenceToActivity(self, "reload_smg1"), VJ.SequenceToActivity(self, "reload_ar2")})
            local gesRelaod =  VJ.PICK({VJ.SequenceToActivity(self, "gesture_reload"), VJ.SequenceToActivity(self, "gesture_reload_smg1"),VJ.SequenceToActivity(self, "gesture_reload_ar2")})	
            local rangeAttackLow = VJ.PICK({ACT_RANGE_ATTACK_AR2_LOW, ACT_RANGE_ATTACK_SMG1_LOW})
            local reloadLow = ACT_RELOAD_SMG1_LOW
            local idle = VJ.PICK({ACT_IDLE_SMG1, ACT_IDLE_SMG1_RELAXED, ACT_IDLE_SMG1_STIMULATED, VJ.SequenceToActivity(self, "Idle_RPG_Relaxed"), VJ.SequenceToActivity(self, "ShGun_Idle"), VJ.SequenceToActivity(self, "Idle1_SMG1") , VJ.SequenceToActivity(self, "Idle_SMG1_Relaxed"), VJ.SequenceToActivity(self, "idle_hold_confident"), VJ.SequenceToActivity(self, "idle1_hecu"), VJ.SequenceToActivity(self, "idle1_hecu_sg"), VJ.SequenceToActivity(self, "idle1_smg1_hecu"), VJ.SequenceToActivity(self, "idle1_smg1_hecu_sg"), VJ.SequenceToActivity(self, "idle_alert_ar2_1"), VJ.SequenceToActivity(self, "idle_alert_ar2_2"), VJ.SequenceToActivity(self, "idle_alert_ar2_3"), VJ.SequenceToActivity(self, "idle_alert_ar2_4"), VJ.SequenceToActivity(self, "idle_alert_ar2_5"), VJ.SequenceToActivity(self, "idle_alert_ar2_6"), VJ.SequenceToActivity(self, "idle_alert_ar2_7"), VJ.SequenceToActivity(self, "idle_alert_ar2_8"), VJ.SequenceToActivity(self, "idle_alert_ar2_9"),  VJ.SequenceToActivity(self, "Idle_RPG_Relaxed"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_1"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_1"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_2"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_3"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_4"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_5"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_6"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_7"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_8"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_9"), VJ.SequenceToActivity(self, "Idle_Alert_1"), VJ.SequenceToActivity(self, "idle_alert_2"), VJ.SequenceToActivity(self, "idle_alert_smg1_1"), VJ.SequenceToActivity(self, "idle_angry_rpg"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_1"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_2"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_3"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_4"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_5"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_6"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_7"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_8"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_9"), VJ.SequenceToActivity(self, "idle_alert_shotgun_1"), VJ.SequenceToActivity(self, "idle_alert_shotgun_2"), VJ.SequenceToActivity(self, "idle_alert_shotgun_3"), VJ.SequenceToActivity(self, "idle_alert_shotgun_4"), VJ.SequenceToActivity(self, "idle_alert_shotgun_5"), VJ.SequenceToActivity(self, "idle_alert_shotgun_6") , VJ.SequenceToActivity(self, "idle_alert_shotgun_7") , VJ.SequenceToActivity(self, "idle_alert_shotgun_8") , VJ.SequenceToActivity(self, "idle_alert_shotgun_9"), VJ.SequenceToActivity(self, "idle_alert_smg1_1")  , VJ.SequenceToActivity(self, "idle_alert_smg1_2")  , VJ.SequenceToActivity(self, "idle_alert_smg1_3")  , VJ.SequenceToActivity(self, "idle_alert_smg1_4")  , VJ.SequenceToActivity(self, "idle_alert_smg1_5")  , VJ.SequenceToActivity(self, "idle_alert_smg1_6")  , VJ.SequenceToActivity(self, "idle_alert_smg1_7")  , VJ.SequenceToActivity(self, "idle_alert_smg1_8")  , VJ.SequenceToActivity(self, "idle_alert_smg1_9"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_1"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_2"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_3"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_4"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_5"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_6"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_7"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_8"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_9"),  VJ.SequenceToActivity(self, "Idle_RPG_Relaxed"), VJ.SequenceToActivity(self, "Idle1_SMG1") , VJ.SequenceToActivity(self, "Idle_SMG1_Relaxed"), VJ.SequenceToActivity(self, "Bandit_Idle1"),VJ.SequenceToActivity(self, "Bandit_Idle2")})
            local idleAngry = VJ.PICK({ACT_IDLE_ANGRY_SMG1, VJ.SequenceToActivity(self, "idle_ar2_aim")})
            local walkAgitated = ACT_WALK_RIFLE
            local walk =  VJ.PICK({VJ.SequenceToActivity(self, "WalkMarch_All"), VJ.SequenceToActivity(self, "WalkHOLDALL1_Ar2"), VJ.SequenceToActivity(self, "WalkHOLDALL1"), VJ.SequenceToActivity(self, "WalkEasy_All"), VJ.SequenceToActivity(self, "WalkAlertHOLDALL1"), VJ.SequenceToActivity(self, "WalkAlertHOLD_AR2_ALL1"), VJ.SequenceToActivity(self, "WalkAlertAimAll1"), VJ.SequenceToActivity(self, "WalkAIMALL1"), VJ.SequenceToActivity(self, "Walk_SMG1_Relaxed_All"), VJ.SequenceToActivity(self, "Walk_RPG_Relaxed_All"), VJ.SequenceToActivity(self, "Walk_Holding_RPG_All"), VJ.SequenceToActivity(self, "Walk_AR2_Relaxed_All"), VJ.SequenceToActivity(self, "Walk_All"), VJ.SequenceToActivity(self, "Walk_Aiming_All_SG"), VJ.SequenceToActivity(self, "Walk_Aiming_All"), VJ.SequenceToActivity(self, "Crouch_WalkALL"), VJ.SequenceToActivity(self, "Crouch_Walk_Holding_RPG_All"), VJ.SequenceToActivity(self, "Crouch_Walk_Holding_All"), VJ.SequenceToActivity(self, "Crouch_Walk_All"), VJ.SequenceToActivity(self, "Crouch_Walk_Aiming_All")})
            local walkAim = VJ.PICK({ACT_WALK_AIM_RIFLE, VJ.SequenceToActivity(self, "walkaimall1_ar2"), VJ.SequenceToActivity(self, "walkalertaim_ar2_all1")})
            local walkCrouch = VJ.PICK({ACT_WALK_CROUCH_RPG,ACT_WALK_CROUCH_RIFLE})
            local walkCrouchAim = VJ.PICK({ACT_WALK_CROUCH_AIM_RIFLE, VJ.SequenceToActivity(self, "crouch_walk_aiming_all")})	
            local run = VJ.PICK({ACT_RUN_CROUCH,VJ.SequenceToActivity(self, "RunAll"), VJ.SequenceToActivity(self, "RunAIMALL1_SG"), VJ.SequenceToActivity(self, "RunAIMALL1"), VJ.SequenceToActivity(self, "Run_SMG1_Relaxed_All"), VJ.SequenceToActivity(self, "Run_RPG_Relaxed_All"), VJ.SequenceToActivity(self, "Run_Holding_RPG_All"), VJ.SequenceToActivity(self, "Run_Holding_Ar2_All"), VJ.SequenceToActivity(self, "Run_Holding_All"), VJ.SequenceToActivity(self, "Run_AR2_Relaxed_All"), VJ.SequenceToActivity(self, "Run_All"), VJ.SequenceToActivity(self, "Run_Alert_Holding_AR2_All"), VJ.SequenceToActivity(self, "Run_Alert_Holding_All"), VJ.SequenceToActivity(self, "Run_Alert_Aiming_Ar2_All"), VJ.SequenceToActivity(self, "Run_Aiming_Ar2_All"), VJ.SequenceToActivity(self, "Run_Aiming_All"), VJ.SequenceToActivity(self, "CrouchRUNAIMINGALL1"), VJ.SequenceToActivity(self, "CrouchRUNHOLDINGALL1"), VJ.SequenceToActivity(self, "Crouch_Run_Holding_RPG_All")})
            local runProtected = VJ.PICK({ACT_RUN_CROUCH_RIFLE,ACT_RUN_CROUCH,VJ.SequenceToActivity(self, "run_protected_all")})
            local runAgitated = ACT_RUN_RIFLE
            local runAim = VJ.PICK({ACT_RUN_AIM_RIFLE, VJ.SequenceToActivity(self, "run_alert_aiming_ar2_all"), VJ.SequenceToActivity(self, "runaimall1"), VJ.SequenceToActivity(self, "run_alert_aiming_all")})
            local runCrouch = VJ.PICK({ACT_RUN_CROUCH, VJ.SequenceToActivity(self, "CrouchRUNAIMINGALL1"), VJ.SequenceToActivity(self, "CrouchRUNHOLDINGALL1"), VJ.SequenceToActivity(self, "CrouchRUNALL1"), VJ.SequenceToActivity(self, "Crouch_Run_Holding_RPG_All")})
            local runCrouchAim = VJ.PICK({ACT_RUN_CROUCH_AIM_RIFLE, VJ.SequenceToActivity(self, "crouchrunaimingall1")})

            self.AnimationTranslations[ACT_COVER]                       = cover
            self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= rangeAttack
            self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 	    = gesRangeAttack
            self.AnimationTranslations[ACT_RELOAD] 					    = reload
            self.AnimationTranslations[ACT_GESTURE_RELOAD]              = "vjges_" .. gesRelaod
            self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 		    = rangeAttackLow
            self.AnimationTranslations[ACT_RELOAD_LOW] 					= reloadLow
            self.AnimationTranslations[ACT_IDLE] 				        = idle
            self.AnimationTranslations[ACT_IDLE_ANGRY] 					= idleAngry
            self.AnimationTranslations[ACT_IDLE_AIM_AGITATED] 			= idleAngry
            self.AnimationTranslations[ACT_WALK_AGITATED] 				= walkAgitated
            self.AnimationTranslations[ACT_WALK] 						= walk
            self.AnimationTranslations[ACT_WALK_AIM] 					= walkAim
            self.AnimationTranslations[ACT_WALK_CROUCH] 				= walkCrouch
            self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= walkCrouchAim
            self.AnimationTranslations[ACT_RUN] 					    = run
            self.AnimationTranslations[ACT_RUN_PROTECTED] 				= runProtected
            self.AnimationTranslations[ACT_RUN_AGITATED] 				= runAgitated
            self.AnimationTranslations[ACT_RUN_AIM] 					= runAim
            self.AnimationTranslations[ACT_RUN_CROUCH] 					= runCrouch
            self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= runCrouchAim

        elseif wepHoldType == "ar2" or wepHoldType == "crossbow" then                        
            local cover = VJ.PICK({ACT_COVER, VJ.SequenceToActivity(self, "crouch_idled"), VJ.SequenceToActivity(self, "pd2_cidle"), VJ.SequenceToActivity(self, "crouch_idle_rpg")})
            local rangeAttack = VJ.PICK({ACT_RANGE_ATTACK_SMG1, ACT_RANGE_ATTACK_AR2})
            local gesRangeAttack = VJ.PICK({ACT_GESTURE_RANGE_ATTACK_AR2,ACT_GESTURE_RANGE_ATTACK_AR1,ACT_GESTURE_RANGE_ATTACK_SMG1,ACT_GESTURE_RANGE_ATTACK_SMG2})
            local reload = VJ.PICK({VJ.SequenceToActivity(self, "Reload"), VJ.SequenceToActivity(self, "reload_smg1"), VJ.SequenceToActivity(self, "reload_ar2")})
            local gesRelaod =  VJ.PICK({VJ.SequenceToActivity(self, "gesture_reload"), VJ.SequenceToActivity(self, "gesture_reload_smg1"),VJ.SequenceToActivity(self, "gesture_reload_ar2")})	
            local rangeAttackLow = VJ.PICK({ACT_RANGE_ATTACK_AR2_LOW, ACT_RANGE_ATTACK_SMG1_LOW})
            local reloadLow = ACT_RELOAD_SMG1_LOW
            local idle = VJ.PICK({ACT_IDLE_SMG1, ACT_IDLE_SMG1_RELAXED, ACT_IDLE_SMG1_STIMULATED, VJ.SequenceToActivity(self, "Idle_RPG_Relaxed"), VJ.SequenceToActivity(self, "ShGun_Idle"), VJ.SequenceToActivity(self, "Idle1_SMG1") , VJ.SequenceToActivity(self, "Idle_SMG1_Relaxed"), VJ.SequenceToActivity(self, "idle1_hecu"), VJ.SequenceToActivity(self, "idle1_hecu_sg"), VJ.SequenceToActivity(self, "idle1_smg1_hecu"), VJ.SequenceToActivity(self, "idle1_smg1_hecu_sg"), VJ.SequenceToActivity(self, "idle_alert_ar2_1"), VJ.SequenceToActivity(self, "idle_alert_ar2_2"), VJ.SequenceToActivity(self, "idle_alert_ar2_3"), VJ.SequenceToActivity(self, "idle_alert_ar2_4"), VJ.SequenceToActivity(self, "idle_alert_ar2_5"), VJ.SequenceToActivity(self, "idle_alert_ar2_6"), VJ.SequenceToActivity(self, "idle_alert_ar2_7"), VJ.SequenceToActivity(self, "idle_alert_ar2_8"), VJ.SequenceToActivity(self, "idle_alert_ar2_9"),  VJ.SequenceToActivity(self, "Idle_RPG_Relaxed"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_1"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_1"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_2"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_3"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_4"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_5"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_6"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_7"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_8"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_9"), VJ.SequenceToActivity(self, "Idle_Alert_1"), VJ.SequenceToActivity(self, "idle_alert_2"), VJ.SequenceToActivity(self, "idle_alert_smg1_1"), VJ.SequenceToActivity(self, "idle_angry_rpg"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_1"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_2"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_3"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_4"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_5"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_6"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_7"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_8"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_9"), VJ.SequenceToActivity(self, "idle_alert_shotgun_1"), VJ.SequenceToActivity(self, "idle_alert_shotgun_2"), VJ.SequenceToActivity(self, "idle_alert_shotgun_3"), VJ.SequenceToActivity(self, "idle_alert_shotgun_4"), VJ.SequenceToActivity(self, "idle_alert_shotgun_5"), VJ.SequenceToActivity(self, "idle_alert_shotgun_6") , VJ.SequenceToActivity(self, "idle_alert_shotgun_7") , VJ.SequenceToActivity(self, "idle_alert_shotgun_8") , VJ.SequenceToActivity(self, "idle_alert_shotgun_9"), VJ.SequenceToActivity(self, "idle_alert_smg1_1")  , VJ.SequenceToActivity(self, "idle_alert_smg1_2")  , VJ.SequenceToActivity(self, "idle_alert_smg1_3")  , VJ.SequenceToActivity(self, "idle_alert_smg1_4")  , VJ.SequenceToActivity(self, "idle_alert_smg1_5")  , VJ.SequenceToActivity(self, "idle_alert_smg1_6")  , VJ.SequenceToActivity(self, "idle_alert_smg1_7")  , VJ.SequenceToActivity(self, "idle_alert_smg1_8")  , VJ.SequenceToActivity(self, "idle_alert_smg1_9"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_1"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_2"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_3"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_4"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_5"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_6"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_7"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_8"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_9")})
            local idleAngry = VJ.PICK({ACT_IDLE_ANGRY_SMG1, VJ.SequenceToActivity(self, "idle_ar2_aim")})
            local walkAgitated = ACT_WALK_RIFLE
            local walk =  VJ.PICK({VJ.SequenceToActivity(self, "WalkMarch_All"), VJ.SequenceToActivity(self, "WalkHOLDALL1_Ar2"), VJ.SequenceToActivity(self, "WalkHOLDALL1"), VJ.SequenceToActivity(self, "WalkEasy_All"), VJ.SequenceToActivity(self, "WalkAlertHOLDALL1"), VJ.SequenceToActivity(self, "WalkAlertHOLD_AR2_ALL1"), VJ.SequenceToActivity(self, "WalkAlertAimAll1"), VJ.SequenceToActivity(self, "WalkAIMALL1"), VJ.SequenceToActivity(self, "Walk_SMG1_Relaxed_All"), VJ.SequenceToActivity(self, "Walk_RPG_Relaxed_All"), VJ.SequenceToActivity(self, "Walk_Holding_RPG_All"), VJ.SequenceToActivity(self, "Walk_AR2_Relaxed_All"), VJ.SequenceToActivity(self, "Walk_All"), VJ.SequenceToActivity(self, "Walk_Aiming_All_SG"), VJ.SequenceToActivity(self, "Walk_Aiming_All"), VJ.SequenceToActivity(self, "Crouch_WalkALL"), VJ.SequenceToActivity(self, "Crouch_Walk_Holding_RPG_All"), VJ.SequenceToActivity(self, "Crouch_Walk_Holding_All"), VJ.SequenceToActivity(self, "Crouch_Walk_All"), VJ.SequenceToActivity(self, "Crouch_Walk_Aiming_All")})
            local walkAim = VJ.PICK({ACT_WALK_AIM_RIFLE, VJ.SequenceToActivity(self, "walkaimall1_ar2"), VJ.SequenceToActivity(self, "walkalertaim_ar2_all1")})
            local walkCrouch = VJ.PICK({ACT_WALK_CROUCH_RPG,ACT_WALK_CROUCH_RIFLE})
            local walkCrouchAim = VJ.PICK({ACT_WALK_CROUCH_AIM_RIFLE, VJ.SequenceToActivity(self, "crouch_walk_aiming_all")})	
            local run = VJ.PICK({ACT_RUN_CROUCH,VJ.SequenceToActivity(self, "RunAll"), VJ.SequenceToActivity(self, "RunAIMALL1_SG"), VJ.SequenceToActivity(self, "RunAIMALL1"), VJ.SequenceToActivity(self, "Run_SMG1_Relaxed_All"), VJ.SequenceToActivity(self, "Run_RPG_Relaxed_All"), VJ.SequenceToActivity(self, "Run_Holding_RPG_All"), VJ.SequenceToActivity(self, "Run_Holding_Ar2_All"), VJ.SequenceToActivity(self, "Run_Holding_All"), VJ.SequenceToActivity(self, "Run_AR2_Relaxed_All"), VJ.SequenceToActivity(self, "Run_All"), VJ.SequenceToActivity(self, "Run_Alert_Holding_AR2_All"), VJ.SequenceToActivity(self, "Run_Alert_Holding_All"), VJ.SequenceToActivity(self, "Run_Alert_Aiming_Ar2_All"), VJ.SequenceToActivity(self, "Run_Aiming_Ar2_All"), VJ.SequenceToActivity(self, "Run_Aiming_All"), VJ.SequenceToActivity(self, "CrouchRUNAIMINGALL1"), VJ.SequenceToActivity(self, "CrouchRUNHOLDINGALL1"), VJ.SequenceToActivity(self, "Crouch_Run_Holding_RPG_All")})
            local runProtected = VJ.PICK({ACT_RUN_CROUCH_RIFLE,ACT_RUN_CROUCH,VJ.SequenceToActivity(self, "run_protected_all")})
            local runAgitated = ACT_RUN_RIFLE
            local runAim = VJ.PICK({ACT_RUN_AIM_RIFLE, VJ.SequenceToActivity(self, "run_alert_aiming_ar2_all"), VJ.SequenceToActivity(self, "runaimall1"), VJ.SequenceToActivity(self, "run_alert_aiming_all")})
            local runCrouch = VJ.PICK({ACT_RUN_CROUCH, VJ.SequenceToActivity(self, "CrouchRUNAIMINGALL1"), VJ.SequenceToActivity(self, "CrouchRUNHOLDINGALL1"), VJ.SequenceToActivity(self, "CrouchRUNALL1"), VJ.SequenceToActivity(self, "Crouch_Run_Holding_RPG_All")})
            local runCrouchAim = VJ.PICK({ACT_RUN_CROUCH_AIM_RIFLE, VJ.SequenceToActivity(self, "crouchrunaimingall1")})

            self.AnimationTranslations[ACT_COVER]                       = cover
            self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= rangeAttack
            self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 	    = gesRangeAttack
            self.AnimationTranslations[ACT_RELOAD] 					    = reload
            self.AnimationTranslations[ACT_GESTURE_RELOAD]              = "vjges_" .. gesRelaod
            self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 		    = rangeAttackLow
            self.AnimationTranslations[ACT_RELOAD_LOW] 					= reloadLow
            self.AnimationTranslations[ACT_IDLE] 				        = idle
            self.AnimationTranslations[ACT_IDLE_ANGRY] 					= idleAngry
            self.AnimationTranslations[ACT_IDLE_AIM_AGITATED] 			= idleAngry
            self.AnimationTranslations[ACT_WALK_AGITATED] 				= walkAgitated
            self.AnimationTranslations[ACT_WALK] 						= walk
            self.AnimationTranslations[ACT_WALK_AIM] 					= walkAim
            self.AnimationTranslations[ACT_WALK_CROUCH] 				= walkCrouch
            self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= walkCrouchAim
            self.AnimationTranslations[ACT_RUN] 					    = run
            self.AnimationTranslations[ACT_RUN_PROTECTED] 				= runProtected
            self.AnimationTranslations[ACT_RUN_AGITATED] 				= runAgitated
            self.AnimationTranslations[ACT_RUN_AIM] 					= runAim
            self.AnimationTranslations[ACT_RUN_CROUCH] 					= runCrouch
            self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= runCrouchAim

        elseif wepHoldType == "shotgun" then 
            local cover = VJ.PICK({ACT_COVER,  VJ.SequenceToActivity(self, "crouch_idled"), VJ.SequenceToActivity(self, "pd2_cidle"), VJ.SequenceToActivity(self, "crouch_idle_rpg")})
            local rangeAttack = VJ.SequenceToActivity(self, "ShootSGs")
            local gesRangeAttack = VJ.PICK({ACT_GESTURE_RANGE_ATTACK_AR2,ACT_GESTURE_RANGE_ATTACK_SHOTGUN})
            local reload = VJ.SequenceToActivity(self, "Reload_Shotgun1")
            local gesReload = "gesture_reload_shotgun"
            local reloadLow = ACT_RELOAD_SG_LOW 
            local rangeAttackLow = VJ.PICK({ACT_RANGE_ATTACK_AR2_LOW, ACT_RANGE_ATTACK_SG_LOW, VJ.SequenceToActivity(self, "Crouch_Aim_Smg1")})
            local idle = VJ.PICK({VJ.SequenceToActivity(self, "Idle_RPG_Relaxed"), VJ.SequenceToActivity(self, "ShGun_Idle"), VJ.SequenceToActivity(self, "ShGun_Idle") , VJ.SequenceToActivity(self, "Idle1_SMG1") , VJ.SequenceToActivity(self, "Idle_SMG1_Relaxed"), VJ.SequenceToActivity(self, "idle_hold_confident")})
            local idleAngry = VJ.PICK({ACT_IDLE_ANGRY_AR2, VJ.SequenceToActivity(self, "combatidle1_sg")})
            local walk = VJ.PICK({VJ.SequenceToActivity(self, "WalkMarch_All"), VJ.SequenceToActivity(self, "WalkHOLDALL1_Ar2"), VJ.SequenceToActivity(self, "WalkHOLDALL1"), VJ.SequenceToActivity(self, "WalkEasy_All"), VJ.SequenceToActivity(self, "WalkAlertHOLDALL1"), VJ.SequenceToActivity(self, "WalkAlertHOLD_AR2_ALL1"), VJ.SequenceToActivity(self, "WalkAlertAimAll1"), VJ.SequenceToActivity(self, "WalkAIMALL1"), VJ.SequenceToActivity(self, "Walk_SMG1_Relaxed_All"), VJ.SequenceToActivity(self, "Walk_RPG_Relaxed_All"), VJ.SequenceToActivity(self, "Walk_Holding_RPG_All"), VJ.SequenceToActivity(self, "Walk_AR2_Relaxed_All"), VJ.SequenceToActivity(self, "Walk_All"), VJ.SequenceToActivity(self, "Walk_Aiming_All_SG"), VJ.SequenceToActivity(self, "Walk_Aiming_All"), VJ.SequenceToActivity(self, "Crouch_WalkALL"), VJ.SequenceToActivity(self, "Crouch_Walk_Holding_RPG_All"), VJ.SequenceToActivity(self, "Crouch_Walk_Holding_All"), VJ.SequenceToActivity(self, "Crouch_Walk_All"), VJ.SequenceToActivity(self, "Crouch_Walk_Aiming_All"), VJ.SequenceToActivity(self, "walk_aiming_all_sg")})
            local walkAgitated = ACT_WALK_RIFLE
            local walkAim = VJ.PICK({ACT_WALK_AIM_RIFLE, ACT_WALK_AIM_SHOTGUN, VJ.SequenceToActivity(self, "walkaimall1_ar2"), VJ.SequenceToActivity(self, "walkalertaim_ar2_all1"), VJ.SequenceToActivity(self, "walk_aiming_all_sg")})
            local walkCrouch = VJ.PICK({ACT_WALK_CROUCH_RPG,ACT_WALK_CROUCH_RIFLE})
            local walkCrouchAim = VJ.PICK({ACT_WALK_CROUCH_AIM_RIFLE, VJ.SequenceToActivity(self, "crouch_walk_aiming_all")})
            local run = VJ.PICK({ACT_RUN_CROUCH, VJ.SequenceToActivity(self, "RunAll"), VJ.SequenceToActivity(self, "RunAIMALL1_SG"), VJ.SequenceToActivity(self, "RunAIMALL1"), VJ.SequenceToActivity(self, "Run_SMG1_Relaxed_All"), VJ.SequenceToActivity(self, "Run_RPG_Relaxed_All"), VJ.SequenceToActivity(self, "Run_Holding_RPG_All"), VJ.SequenceToActivity(self, "Run_Holding_Ar2_All"), VJ.SequenceToActivity(self, "Run_Holding_All"), VJ.SequenceToActivity(self, "Run_AR2_Relaxed_All"), VJ.SequenceToActivity(self, "Run_All"), VJ.SequenceToActivity(self, "Run_Alert_Holding_AR2_All"), VJ.SequenceToActivity(self, "Run_Alert_Holding_All"), VJ.SequenceToActivity(self, "Run_Alert_Aiming_Ar2_All"), VJ.SequenceToActivity(self, "Run_Aiming_Ar2_All"), VJ.SequenceToActivity(self, "Run_Aiming_All"), VJ.SequenceToActivity(self, "CrouchRUNAIMINGALL1"), VJ.SequenceToActivity(self, "CrouchRUNHOLDINGALL1"), VJ.SequenceToActivity(self, "Crouch_Run_Holding_RPG_All"), VJ.SequenceToActivity(self, "runaimall1_sg")})
            local runProtected = VJ.PICK({ACT_RUN_CROUCH_RIFLE,ACT_RUN_CROUCH,VJ.SequenceToActivity(self, "run_protected_all")})
            local runAgitated = ACT_RUN_RIFLE
            local runAim = VJ.PICK({ACT_RUN_AIM_RIFLE, VJ.SequenceToActivity(self, "run_alert_aiming_ar2_all"), VJ.SequenceToActivity(self, "runaimall1"), VJ.SequenceToActivity(self, "run_alert_aiming_all"), VJ.SequenceToActivity(self, "runaimall1_sg")})
            local runCrouch = VJ.PICK({ACT_RUN_CROUCH, VJ.SequenceToActivity(self, "CrouchRUNAIMINGALL1"), VJ.SequenceToActivity(self, "CrouchRUNHOLDINGALL1"), VJ.SequenceToActivity(self, "CrouchRUNALL1"), VJ.SequenceToActivity(self, "Crouch_Run_Holding_RPG_All")})
            local runCrouchAim = VJ.PICK({ACT_RUN_CROUCH_AIM_RIFLE, VJ.SequenceToActivity(self, "crouchrunaimingall1")})

            self.AnimationTranslations[ACT_COVER]                       = cover
            self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= rangeAttack
            self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 	    = gesRangeAttack
            self.AnimationTranslations[ACT_RELOAD] 					    = reload	
            self.AnimationTranslations[ACT_GESTURE_RELOAD]              = "vjges_" .. gesReload
            self.AnimationTranslations[ACT_RELOAD_LOW] 					= reloadLow
            self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= rangeAttackLow		
            self.AnimationTranslations[ACT_IDLE] 						= idle
            self.AnimationTranslations[ACT_IDLE_ANGRY] 					= idleAngry
            self.AnimationTranslations[ACT_IDLE_AIM_AGITATED] 			= idleAngry
            self.AnimationTranslations[ACT_WALK] 						= walk
            self.AnimationTranslations[ACT_WALK_AGITATED] 				= walkAgitated
            self.AnimationTranslations[ACT_WALK_AIM] 					= walkAim
            self.AnimationTranslations[ACT_WALK_CROUCH] 				= walkCrouch
            self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= walkCrouchAim
            self.AnimationTranslations[ACT_RUN] 						= run
            self.AnimationTranslations[ACT_RUN_PROTECTED] 				= runProtected
            self.AnimationTranslations[ACT_RUN_AGITATED] 				= runAgitated
            self.AnimationTranslations[ACT_RUN_AIM] 					= runAim
            self.AnimationTranslations[ACT_RUN_CROUCH] 					= runCrouch
            self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= runCrouchAim

        elseif wepHoldType == "rpg" then 
            local cover = VJ.PICK({ACT_COVER,  VJ.SequenceToActivity(self, "crouch_idled"), VJ.SequenceToActivity(self, "pd2_cidle"), VJ.SequenceToActivity(self, "crouch_idle_rpg")})
            local rangeAttack = VJ.SequenceToActivity(self, "shoot_rpg")
            local gesRangeAttack = VJ.SequenceToActivity(self, "gesture_shoot_rpg")
            local reload = VJ.PICK({VJ.SequenceToActivity(self, "Reload"), VJ.SequenceToActivity(self, "reload_smg1"), VJ.SequenceToActivity(self, "reload_ar2")})
            local gesReload = VJ.PICK({VJ.SequenceToActivity(self, "gesture_reload"), VJ.SequenceToActivity(self, "gesture_reload_smg1"),VJ.SequenceToActivity(self, "gesture_reload_ar2")})
            local rangeAttackLow = VJ.PICK({ACT_RANGE_ATTACK_AR2_LOW, ACT_RANGE_ATTACK_SMG1_LOW})
            local idle = VJ.PICK({VJ.SequenceToActivity(self, "Idle_RPG_Relaxed"), VJ.SequenceToActivity(self, "ShGun_Idle"), VJ.SequenceToActivity(self, "ShGun_Idle") , VJ.SequenceToActivity(self, "Idle1_SMG1") , VJ.SequenceToActivity(self, "Idle_SMG1_Relaxed"), VJ.SequenceToActivity(self, "idle1_hecu"), VJ.SequenceToActivity(self, "idle1_hecu_sg"), VJ.SequenceToActivity(self, "idle1_smg1_hecu"), VJ.SequenceToActivity(self, "idle1_smg1_hecu_sg"), VJ.SequenceToActivity(self, "idle_alert_ar2_1"), VJ.SequenceToActivity(self, "idle_alert_ar2_2"), VJ.SequenceToActivity(self, "idle_alert_ar2_3"), VJ.SequenceToActivity(self, "idle_alert_ar2_4"), VJ.SequenceToActivity(self, "idle_alert_ar2_5"), VJ.SequenceToActivity(self, "idle_alert_ar2_6"), VJ.SequenceToActivity(self, "idle_alert_ar2_7"), VJ.SequenceToActivity(self, "idle_alert_ar2_8"), VJ.SequenceToActivity(self, "idle_alert_ar2_9"),  VJ.SequenceToActivity(self, "Idle_RPG_Relaxed"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_1"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_1"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_2"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_3"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_4"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_5"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_6"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_7"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_8"), VJ.SequenceToActivity(self, "Idle_Relaxed_Shotgun_9"), VJ.SequenceToActivity(self, "Idle_Alert_1"), VJ.SequenceToActivity(self, "idle_alert_2"), VJ.SequenceToActivity(self, "idle_alert_smg1_1"), VJ.SequenceToActivity(self, "idle_angry_rpg"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_1"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_2"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_3"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_4"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_5"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_6"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_7"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_8"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_9"), VJ.SequenceToActivity(self, "idle_alert_shotgun_1"), VJ.SequenceToActivity(self, "idle_alert_shotgun_2"), VJ.SequenceToActivity(self, "idle_alert_shotgun_3"), VJ.SequenceToActivity(self, "idle_alert_shotgun_4"), VJ.SequenceToActivity(self, "idle_alert_shotgun_5"), VJ.SequenceToActivity(self, "idle_alert_shotgun_6") , VJ.SequenceToActivity(self, "idle_alert_shotgun_7") , VJ.SequenceToActivity(self, "idle_alert_shotgun_8") , VJ.SequenceToActivity(self, "idle_alert_shotgun_9"), VJ.SequenceToActivity(self, "idle_alert_smg1_1")  , VJ.SequenceToActivity(self, "idle_alert_smg1_2")  , VJ.SequenceToActivity(self, "idle_alert_smg1_3")  , VJ.SequenceToActivity(self, "idle_alert_smg1_4")  , VJ.SequenceToActivity(self, "idle_alert_smg1_5")  , VJ.SequenceToActivity(self, "idle_alert_smg1_6")  , VJ.SequenceToActivity(self, "idle_alert_smg1_7")  , VJ.SequenceToActivity(self, "idle_alert_smg1_8")  , VJ.SequenceToActivity(self, "idle_alert_smg1_9"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_1"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_2"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_3"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_4"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_5"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_6"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_7"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_8"), VJ.SequenceToActivity(self, "idle_relaxed_smg1_9")})
            local idleAngry = VJ.PICK({VJ.SequenceToActivity(self, "idle_rpg_aim")})
            local walk = VJ.PICK({VJ.SequenceToActivity(self, "WalkMarch_All"), VJ.SequenceToActivity(self, "WalkHOLDALL1_Ar2"), VJ.SequenceToActivity(self, "WalkHOLDALL1"), VJ.SequenceToActivity(self, "WalkEasy_All"), VJ.SequenceToActivity(self, "WalkAlertHOLDALL1"), VJ.SequenceToActivity(self, "WalkAlertHOLD_AR2_ALL1"), VJ.SequenceToActivity(self, "WalkAlertAimAll1"), VJ.SequenceToActivity(self, "WalkAIMALL1"), VJ.SequenceToActivity(self, "Walk_SMG1_Relaxed_All"), VJ.SequenceToActivity(self, "Walk_RPG_Relaxed_All"), VJ.SequenceToActivity(self, "Walk_Holding_RPG_All"), VJ.SequenceToActivity(self, "Walk_AR2_Relaxed_All"), VJ.SequenceToActivity(self, "Walk_All"), VJ.SequenceToActivity(self, "Walk_Aiming_All_SG"), VJ.SequenceToActivity(self, "Walk_Aiming_All"), VJ.SequenceToActivity(self, "Crouch_WalkALL"), VJ.SequenceToActivity(self, "Crouch_Walk_Holding_RPG_All"), VJ.SequenceToActivity(self, "Crouch_Walk_Holding_All"), VJ.SequenceToActivity(self, "Crouch_Walk_All"), VJ.SequenceToActivity(self, "Crouch_Walk_Aiming_All")})
            local walkAgitated = ACT_WALK_RIFLE
            local walkAim = VJ.PICK({VJ.SequenceToActivity(self, "walkaimall1_ar2"), VJ.SequenceToActivity(self, "walkalertaim_ar2_all1")})
            local walkCrouch = VJ.PICK({ACT_WALK_CROUCH_RPG,ACT_WALK_CROUCH_RIFLE})
            local walkCrouchAim = ACT_WALK_CROUCH_AIM_RIFLE	
            local run = VJ.PICK({ACT_RUN_CROUCH, VJ.SequenceToActivity(self, "RunAll"), VJ.SequenceToActivity(self, "RunAIMALL1_SG"), VJ.SequenceToActivity(self, "RunAIMALL1"), VJ.SequenceToActivity(self, "Run_SMG1_Relaxed_All"), VJ.SequenceToActivity(self, "Run_RPG_Relaxed_All"), VJ.SequenceToActivity(self, "Run_Holding_RPG_All"), VJ.SequenceToActivity(self, "Run_Holding_Ar2_All"), VJ.SequenceToActivity(self, "Run_Holding_All"), VJ.SequenceToActivity(self, "Run_AR2_Relaxed_All"), VJ.SequenceToActivity(self, "Run_All"), VJ.SequenceToActivity(self, "Run_Alert_Holding_AR2_All"), VJ.SequenceToActivity(self, "Run_Alert_Holding_All"), VJ.SequenceToActivity(self, "Run_Alert_Aiming_Ar2_All"), VJ.SequenceToActivity(self, "Run_Aiming_Ar2_All"), VJ.SequenceToActivity(self, "Run_Aiming_All"), VJ.SequenceToActivity(self, "CrouchRUNAIMINGALL1"), VJ.SequenceToActivity(self, "CrouchRUNHOLDINGALL1"), VJ.SequenceToActivity(self, "Crouch_Run_Holding_RPG_All")})
            local runProtected = VJ.PICK({ACT_RUN_CROUCH_RIFLE,ACT_RUN_CROUCH,VJ.SequenceToActivity(self, "run_protected_all")})
            local runAgitated = ACT_RUN_RIFLE
            local runAim = VJ.PICK({ACT_RUN_AIM_RIFLE, VJ.SequenceToActivity(self, "run_alert_aiming_ar2_all"), VJ.SequenceToActivity(self, "runaimall1"), VJ.SequenceToActivity(self, "run_alert_aiming_all")})
            local runCrouch = VJ.PICK({ACT_RUN_CROUCH, VJ.SequenceToActivity(self, "CrouchRUNAIMINGALL1"), VJ.SequenceToActivity(self, "CrouchRUNHOLDINGALL1"), VJ.SequenceToActivity(self, "CrouchRUNALL1"), VJ.SequenceToActivity(self, "Crouch_Run_Holding_RPG_All")})
            local runCrouchAim = VJ.PICK({ACT_RUN_CROUCH_AIM_RIFLE, VJ.SequenceToActivity(self, "crouchrunaimingall1")})

            self.AnimationTranslations[ACT_COVER]                       = cover
            self.AnimationTranslations[ACT_RANGE_ATTACK1] 	            = rangeAttack
            self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 	    = gesRangeAttack
            self.AnimationTranslations[ACT_RELOAD] 					    = reload
            self.AnimationTranslations[ACT_GESTURE_RELOAD]              = "vjges_" .. gesReload
            self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= rangeAttackLow
            self.AnimationTranslations[ACT_IDLE] 				        = idle
            self.AnimationTranslations[ACT_IDLE_ANGRY] 					= idleAngry	
            self.AnimationTranslations[ACT_IDLE_AIM_AGITATED] 			= idleAngry		
            self.AnimationTranslations[ACT_WALK] 						= walk
            self.AnimationTranslations[ACT_WALK_AGITATED] 				= walkAgitated
            self.AnimationTranslations[ACT_WALK_AIM] 				    = walkAim
            self.AnimationTranslations[ACT_WALK_CROUCH] 				= walkCrouch
            self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= walkCrouchAim
            self.AnimationTranslations[ACT_RUN] 					    = run
            self.AnimationTranslations[ACT_RUN_PROTECTED] 				= runProtected
            self.AnimationTranslations[ACT_RUN_AGITATED] 				= runAgitated
            self.AnimationTranslations[ACT_RUN_AIM] 					= runAim
            self.AnimationTranslations[ACT_RUN_CROUCH] 					= runCrouch
            self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= runCrouchAim

        elseif wepHoldType == "pistol" or wepHoldType == "revolver" then
            local cover = VJ.PICK({ACT_COVER, VJ.SequenceToActivity(self, "crouchidlehide"), VJ.SequenceToActivity(self, "crouchidle_panicked4"), VJ.SequenceToActivity(self, "crouch_idle_pistol")})
            local idle = VJ.PICK({VJ.SequenceToActivity(self, "Idle_Subtle"), VJ.SequenceToActivity(self, "Idle_Unarmed"), VJ.SequenceToActivity(self, "idle_relaxed_pistol_1"), VJ.SequenceToActivity(self, "idle_relaxed_pistol_2"), VJ.SequenceToActivity(self, "idle_relaxed_pistol_3"), VJ.SequenceToActivity(self, "idle_relaxed_pistol_4"), VJ.SequenceToActivity(self, "idle_relaxed_pistol_5"), VJ.SequenceToActivity(self, "idle_relaxed_pistol_6"), VJ.SequenceToActivity(self, "idle_relaxed_pistol_7"), VJ.SequenceToActivity(self, "idle_relaxed_pistol_8"), VJ.SequenceToActivity(self, "idle_relaxed_pistol_9"), VJ.SequenceToActivity(self, "idle_alert_pistol_1"), VJ.SequenceToActivity(self, "idle_alert_pistol_2"), VJ.SequenceToActivity(self, "idle_alert_pistol_3"), VJ.SequenceToActivity(self, "idle_alert_pistol_4"), VJ.SequenceToActivity(self, "idle_alert_pistol_5"), VJ.SequenceToActivity(self, "idle_alert_pistol_6"), VJ.SequenceToActivity(self, "idle_alert_pistol_7"), VJ.SequenceToActivity(self, "idle_alert_pistol_8"), VJ.SequenceToActivity(self, "idle_alert_pistol_9"), VJ.SequenceToActivity(self, "idle_hold_confident")})
            local idleAngry = ACT_IDLE_ANGRY_PISTOL
            local rangeAttack = ACT_RANGE_ATTACK_PISTOL
            local gestRangeAttack = ACT_GESTURE_RANGE_ATTACK_PISTOL
            local rangeAttackLow = ACT_RANGE_ATTACK_PISTOL_LOW   
            local gesReload = "reload_pistol"
            local reload = ACT_RELOAD_PISTOL
            local reloadLow = VJ.SequenceToActivity(self, "Crouch_Reload_Pistol")	
            local walk = ACT_WALK_PISTOL
            local walkAim = ACT_WALK_AIM_PISTOL
            local run = ACT_RUN_PISTOL
            local runAim = ACT_RUN_AIM_PISTOL
            local walkCrouchAim = ACT_HL2MP_WALK_CROUCH_PISTOL
            local runCrouchAim = ACT_HL2MP_WALK_CROUCH_PISTOL

            self.AnimationTranslations[ACT_COVER]                       = cover
            self.AnimationTranslations[ACT_IDLE]                        = idle
            self.AnimationTranslations[ACT_IDLE_ANGRY] 					= idleAngry
            self.AnimationTranslations[ACT_IDLE_AIM_AGITATED] 			= idleAngry
            self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= rangeAttack
            self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= gestRangeAttack
            self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= rangeAttackLow
            self.AnimationTranslations[ACT_GESTURE_RELOAD]              = "vjges_" ..  gesReload
            self.AnimationTranslations[ACT_RELOAD] 					    = reload
            self.AnimationTranslations[ACT_RELOAD_LOW] 					= reloadLow			
            self.AnimationTranslations[ACT_WALK] 						= walk
            self.AnimationTranslations[ACT_WALK_AIM] 					= walkAim
            self.AnimationTranslations[ACT_RUN]                         = run
            self.AnimationTranslations[ACT_RUN_AIM]                     = runAim
            self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 	        = walkCrouchAim	
            self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 	            = runCrouchAim

        //Needs to be improved vastly 
        elseif wepHoldType == "melee" or wepHoldType == "melee2" or wepHoldType == "knife" then
            local cover = VJ.PICK({VJ.SequenceToActivity(self, "crouchidlehide"), VJ.SequenceToActivity(self, "crouchidle_panicked4")})
            local idle = VJ.PICK({VJ.SequenceToActivity(self, "Idle_unarmed"),VJ.SequenceToActivity(self, "LineIdle02"),VJ.SequenceToActivity(self, "Idle_Subtle"),VJ.SequenceToActivity(self, "batonidle1"),VJ.SequenceToActivity(self, "batonidle2")})
            local idleAngry = VJ.PICK({VJ.SequenceToActivity(self, "crouchidle_panicked4"),VJ.SequenceToActivity(self, "crouchidlehide"),VJ.SequenceToActivity(self, "Idle_Angry_Melee")})
            local attack = ACT_MELEE_ATTACK_SWING
            local walk = VJ.SequenceToActivity(self, "walkunarmed_all")
            local run = VJ.SequenceToActivity(self, "run_all_panicked")
            local gestAttack = ACT_MELEE_ATTACK_SWING
    
            self.AnimationTranslations[ACT_COVER]                       = cover
            self.AnimationTranslations[ACT_IDLE]                        = idle
            self.AnimationTranslations[ACT_IDLE_ANGRY] 					= idleAngry
            self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= attack
            self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= false -- Don't play anything for melee!
            self.AnimationTranslations[ACT_WALK] 						= walk
            self.AnimationTranslations[ACT_RUN] 						= run
            self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_WALK_AIM_RIFLE
            self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_RUN_AIM_RIFLE

        end		
        return true
    end 
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasExtraGibVariants = true -- Allows spawning of bones and other organs when gibbed. 
ENT.Gibs_UniquePcfx = true -- Should gibs have a pcfx attached?
ENT.MaxSmallGibs = 15 
ENT.MaxLargeGibs = 15 
ENT.Gib_ParticleChance = 3 
ENT.Gib_ParticleTbl = {"blood_impact_red_01","blood_advisor_pierce_spray","blood_impact_red_01_goop","blood_impact_red_01_chunk"}
ENT.Gib_BloodColor = "Red" -- can either be "Yellow" or "Red"
ENT.Gib_Type = "Human" -- "Human" or "Alien"

ENT.SpawnGib_OnDmg = true 
ENT.SpawnGib_OnDmgChance = 5
ENT.SpawnGib_OnDmgNextT = 0 
ENT.SpawnGib_OnDmgThresh = 30
ENT.SpawnGib_OnDmgSound = true 
ENT.SpawnGib_OnDmgSoundChance = 3
function ENT:GibWhenDamaged(dmginfo)
    if not self.SpawnGib_OnDmg then return end 

    local conv = GetConVar("vj_stalker_damage_gibs")
    if not conv or conv:GetInt() ~= 1 then return end 

    if not self:Alive() then return end 
    if CurTime() < self.SpawnGib_OnDmgNextT then return end 

    local attacker = dmginfo:GetAttacker()
    if not IsValid(attacker) then return end 

    local dmgT = dmginfo:GetDamageType()

    local function HasDmgType(t)
        return bit.band(dmgT, t) ~= 0
    end

    if HasDmgType(DMG_FALL) or HasDmgType(DMG_RADIATION) or HasDmgType(DMG_REMOVENORAGDOLL) or HasDmgType(DMG_NEVERGIB) or HasDmgType(DMG_SONIC) or HasDmgType(DMG_NERVEGAS) or HasDmgType(DMG_POISON) or HasDmgType(DMG_DISSOLVE) or HasDmgType(DMG_BURN) or HasDmgType(DMG_SLOWBURN) or HasDmgType(DMG_MISSILEDEFENSE) or HasDmgType(DMG_PHYSGUN) or HasDmgType(DMG_SHOCK) or HasDmgType(DMG_DROWN) or HasDmgType(DMG_VEHICLE) then return end 

    local dmg = dmginfo:GetDamage()
    if dmg < (self.SpawnGib_OnDmgThresh or 30) then return end 

    if mRng(1, self.SpawnGib_OnDmgChance or 20) ~= 1 then return end 

    local gibType = self:DetermineGibType()
    if not gibType then return end 

    local pos = dmginfo:GetDamagePosition()
    if not pos or not isvector(pos) or pos == vector_origin then
        pos = self:WorldSpaceCenter()
    end

    if self.SpawnGib_OnDmgSound then
        if mRng(1, self.SpawnGib_OnDmgSoundChance or 3) == 1 then
            local tbl = self.GoreOrGibSounds
            if tbl then 
                if istable(tbl) and #tbl > 0 then
                    VJ.EmitSound(self, tbl[mRng(1, #tbl)], 70, 100) 
                elseif isstring(tbl) then
                    VJ.EmitSound(self, tbl, 70, 100)
                end
            end 
        end
    end 

    local particle = table.Random({"blood_impact_red_01", "blood_impact_red_01_goop", "blood_impact_red_01_chunk"})
    if particle then
        ParticleEffect(particle, pos, Angle(0,0,0), self)
    end 

    for i = 1, mRng(1, 2) do  
        self:CreateGibEntity("obj_vj_gib", gibType .. "Small", {Pos = pos})
    end 

    self.SpawnGib_OnDamageNextT = CurTime() + mRand(1, 5)
end

function ENT:DetermineGibType()
    if not self.Gib_Type then return end 
    return (self.Gib_Type == "Alien" and "UseAlien_") or "UseHuman_"
end 

function ENT:Determine_BloodColor()
    local gibCloudYellow = VJ.Color2Byte(Color(mRand(180, 255), mRand(170, 220), mRand(10, 65)))
    local gibCloudRed    = VJ.Color2Byte(Color(mRng(50, 255), mRng(1, 65), mRng(1, 65)))
    local selectCol      = gibCloudRed

    if self.Gib_BloodColor ~= false and self.Gib_BloodColor ~= nil then 
        if self.Gib_BloodColor == "Red" then 
            selectCol = gibCloudRed 
        elseif self.Gib_BloodColor == "Yellow" then 
            selectCol = gibCloudYellow
        end
    end 
    return selectCol
end

function ENT:Spawn_Gibs(dmginfo, isDissolving)
    local minimalGibs = GetConVar("vj_stalker_minimal_gib"):GetBool()
    local maxSmallG = minimalGibs and math.ceil(self.MaxSmallGibs / 2) or self.MaxSmallGibs
    local maxLargeG = minimalGibs and math.ceil(self.MaxLargeGibs / 2) or self.MaxLargeGibs

    local gibType  = self:DetermineGibType()
    
    -- If dissolving, force blood color to black (0), otherwise determine normally
    local bloodCol = isDissolving and VJ.Color2Byte(Color(0, 0, 0)) or self:Determine_BloodColor()

    local obbCenter = self:OBBCenter()
    local basePos = self:GetPos() + obbCenter

    local pcfxTbl = self.Gib_ParticleTbl
    local hasPcfx = istable(pcfxTbl) and #pcfxTbl > 0
    local bloodParticle = hasPcfx and table.Random(pcfxTbl) or nil

    local sndTbl = self.GoreOrGibSounds
    local gibSound = nil
    if sndTbl then
        gibSound = istable(sndTbl) and table.Random(sndTbl) or sndTbl
    end

    if self.HasGibOnDeathEffects then
        local randOffset = Vector(mRand(-25, 25), mRand(-25, 25), mRand(5, 35))
        local randAng = Angle(mRand(-25, 25), mRand(-25, 25), mRand(-25, 25))
        local rngSnd = mRng(75, 105)
        if hasPcfx and not isDissolving then
            local fx = bloodParticle or table.Random(pcfxTbl)
            if isstring(fx) and fx ~= "" then
                ParticleEffect(fx, basePos + randOffset, randAng)
            end
        end

        if gibSound then
            VJ.EmitSound(self, gibSound, rngSnd, rngSnd)
        end

        -- Blood cloud 
        local bloodeffect = EffectData()
        bloodeffect:SetOrigin(basePos)
        bloodeffect:SetColor(bloodCol)
        bloodeffect:SetScale(mRng(75, 225))
        util.Effect("VJ_Blood1", bloodeffect)

        -- Blood spray
        local bloodspray = EffectData()
        bloodspray:SetOrigin(basePos)
        bloodspray:SetScale(mRng(3, 10))
        bloodspray:SetFlags(3)
        bloodspray:SetColor(isDissolving and 1 or 0) 
        util.Effect("bloodspray", bloodspray)

        util.ScreenShake(basePos, 20, 8, 1.5, 1500)
        VJ.ApplyRadiusDamage(self, self, basePos, mRand(125, 355), mRng(5, 15), bit.bor(DMG_SLASH, DMG_CLUB), true, true)
    end

    local gibs = {}
    
    for i = 1, mRng(5, maxSmallG) do
        gibs[#gibs + 1] = gibType .. "Small"
    end
    for i = 1, mRng(5, maxLargeG) do
        gibs[#gibs + 1] = gibType .. "Big"
    end

    if self.HasExtraGibVariants and self.Gib_Type == "Human" and not minimalGibs then
        gibs[#gibs + 1] = "models/vj_base/gibs/human/heart.mdl"
        local organCount = mRng(1, 2)
        for i = 1, organCount do
            table.insert(gibs, "models/vj_base/gibs/human/liver.mdl")
            table.insert(gibs, "models/vj_base/gibs/human/lung.mdl")
        end
        if mRng(1, 2) == 1 then gibs[#gibs + 1] = "models/vj_base/gibs/human/brain.mdl" end
        for i = 1, mRng(1, 2) do gibs[#gibs + 1] = "models/vj_base/gibs/human/eye.mdl" end
        for i = 1, mRng(3, 24) do gibs[#gibs + 1] = "models/gibs/hgibs_rib.mdl" end

        table.Add(gibs, {"models/gibs/hgibs.mdl", "models/gibs/hgibs_scapula.mdl", "models/gibs/hgibs_spine.mdl"})

        if not isDissolving then
            local intestineAmount = mRng(1, 8)
            for i = 1, intestineAmount do
                local intGib = self:CreateGibEntity("intestine_gib", intestineAmount, {BloodType = bloodCol, Pos = basePos})
            end 
        end 
    end 

    local maxParticles = math.floor(#gibs / 2)
    local particlesSpawned = 0
    local pcfxChance = tonumber(self.Gib_ParticleChance) or 5

    for _, gibModel in ipairs(gibs) do
        local gibPos = self:LocalToWorld(obbCenter + Vector(mRng(-45, 45), mRng(-45, 45), mRng(10, 45)))
        local gibAng = Angle(mRand(-55, 55), mRand(-55, 55), mRand(-55, 55))
        local gibEnt = self:CreateGibEntity("obj_vj_gib", gibModel, { BloodType = bloodCol, Pos = gibPos, Ang = gibAng})

        if IsValid(gibEnt) then
            if isDissolving then
                local dissolver = self:GetOrCreateDissolver()
                if IsValid(dissolver) then
                    local targetName = "vj_dissolve_" .. gibEnt:EntIndex()
                    gibEnt:SetName(targetName)
                    dissolver:Fire("Dissolve", targetName, 0)
                end
            elseif not minimalGibs and self.Gibs_UniquePcfx then
                if particlesSpawned < maxParticles and bloodParticle and mRng(1, pcfxChance) == 1 then
                    ParticleEffectAttach(bloodParticle, PATTACH_POINT_FOLLOW, gibEnt, 0)
                    particlesSpawned = particlesSpawned + 1
                end
            end
        end
    end
end

ENT.StalkerMain_Gib_Conv = "vj_stalker_gib"
ENT.StalkerMain_GibDis_Conv = "vj_stalker_gibs_dissolved"
ENT.StalkerMain_GibSnd_Conv = "vj_stalker_gib_death_sounds"
function ENT:Custom_GibEffects(dmginfo)
    if not IsValid(self) then return end 

    local convStr = self.StalkerMain_Gib_Conv
    local conv = GetConVar(convStr):GetInt()
    if not conv or conv ~= 1 then return end

    local gibChance = tonumber(self.ChanceToGib) or 3  
    if self.IsHeavilyArmored then 
        gibChance = math_floor(gibChance * 3)
    end 

    local dmgT = dmginfo:GetDamageType()
    local inflict = dmginfo:GetInflictor()
    local dissConvStr = self.StalkerMain_GibDis_Conv
    local convar = GetConVar(dissConvStr):GetInt()
    local isDissolve = convar and convar == 1 and (bit.band(dmgT, DMG_DISSOLVE) ~= 0) or (IsValid(inflict) and inflict:GetClass() == "prop_combine_ball")

    if mRng(1, gibChance) == 1 then
        self.HasDeathSounds = false 
        self.HasDeathRagdoll = false
        self.HasPainSounds = false
        self.HasDeathAnimation = false
        self.GibbedOnDeath = true

        self:Spawn_Gibs(dmginfo, isDissolve)
        local sndConv = self.StalkerMain_GibSnd_Conv
        local gibDthConv = GetConVar(sndConv):GetInt() 
        if not gibDthConv or gibDthConv ~= 1 then return end 
        
        local tbl = self.SoundTbl_GibDeath
        if not tbl then return end 
        local gibDeathSound = table.Random(tbl)
        VJ.EmitSound(self, gibDeathSound, mRng(60, 75), mRng(85, 115)) 
    end 
end

function ENT:HandleGibOnDeath(dmginfo, hitgroup)
    self:Custom_GibEffects(dmginfo)
    return false 
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RandomsCustomRemove()
    if self.CurrentRadioChatSound then 
        self.CurrentRadioChatSound:Stop() 
    end
    
    if self.CurrentHasCryForAidSound then 
        self.CurrentHasCryForAidSound:Stop() 
    end
    
    if self.CoughingSound then 
        self.CoughingSound:Stop() 
    end

    local painConv = GetConVar("vj_stalker_pain_vo_cancel"):GetInt()
    if painConv == 1 and self.CurrentSpeechSound then 
        self.CurrentSpeechSound:Stop()
    end 
end

function ENT:CustomOnRemove()
    self:RandomsCustomRemove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasSounds = true -- Put to false to disable ALL sounds!
ENT.OnKilledEnemy_OnlyLast = true -- Should it only play the "OnKilledEnemy" sounds if there is no enemies left?
ENT.DamageByPlayerDispositionLevel = 1 -- At which disposition levels it should play the damage by player sounds | 0 = Always | 1 = ONLY when friendly to player | 2 = ONLY when enemy to player
	-- ====== Footstep Sound ====== --
ENT.HasFootStepSound = true -- Can the NPC play footstep sounds?
ENT.DisableFootStepSoundTimer = false -- Disables the timer system for footstep sounds, allowing to utilize model events
	-- ====== Idle Sound ====== --
ENT.HasIdleSounds = true -- Can it play idle sounds? | Controls "self.SoundTbl_Idle", "self.SoundTbl_IdleDialogue", ad "self.SoundTbl_CombatIdle"
ENT.IdleSoundsWhileAttacking = false -- Can it play idle sounds while performing an attack?
ENT.IdleSoundsRegWhileAlert = false -- Should it disable playing regular idle sounds when combat idle sound is empty?	-- ====== Idle Dialogue Sound ====== --
	-- When an allied NPC or player is within range, it will play these sounds rather than regular idle sounds
	-- If the ally is a VJ NPC and has dialogue answer sounds, it will respond back
ENT.HasIdleDialogueSounds = true -- If set to false, it won't play the idle dialogue sounds
ENT.HasIdleDialogueAnswerSounds = true -- If set to false, it won't play the idle dialogue answer sounds
ENT.IdleDialogueDistance = 400 -- How close should an ally be for it to initiate a dialogue
ENT.IdleDialogueCanTurn = true -- Should it turn to to face its dialogue target?
	-- ====== On Killed Enemy ====== --
ENT.HasKilledEnemySounds = true -- Can it play sounds when it kills an enemy?
ENT.KilledEnemySoundLast = true -- Should it only play "self.SoundTbl_KilledEnemy" if there is no enemies left?
	-- ====== Sound Track ====== --
ENT.HasSoundTrack = false -- Does the NPC have a sound track?
ENT.SoundTrackVolume = 1 -- Volume of the sound track | 1 = Normal | 2 = 200% | 0.5 = 50%
ENT.SoundTrackPlaybackRate = 1 -- How fast the sound should play | 1 = Normal | 2 = Twice the speed | 0.5 = Half the speed
	-- ====== Other Sound Controls ====== --
ENT.HasBreathSound = true -- Should it make a breathing sound?
ENT.HasReceiveOrderSounds = true -- Can it play sounds when it receives an order?aw
ENT.HasFollowPlayerSounds = true -- Can it play follow and unfollow player sounds?
ENT.HasYieldToAlliedPlayerSounds = true -- If set to false, it won't play any sounds when it moves out of the player's way
ENT.HasMedicSounds_BeforeHeal = true -- If set to false, it won't play any sounds before it gives a med kit to an ally
ENT.HasMedicSounds_AfterHeal = true -- If set to false, it won't play any sounds after it gives a med kit to an ally
ENT.HasMedicSounds_ReceiveHeal = true -- If set to false, it won't play any sounds when it receives a medkit
ENT.HasOnPlayerSightSounds = true -- If set to false, it won't play the saw player sounds
ENT.HasInvestigateSounds = true -- If set to false, it won't play any sounds when it's investigating something
ENT.HasLostEnemySounds = true -- If set to false, it won't play any sounds when it looses it enemy
ENT.HasAlertSounds = true -- If set to false, it won't play the alert sounds
ENT.HasCallForHelpSounds = true -- If set to false, it won't play any sounds when it calls for help
ENT.HasBecomeEnemyToPlayerSounds = true -- If set to false, it won't play the become enemy to player sounds
ENT.HasSuppressingSounds = true -- If set to false, it won't play any sounds when firing a weapon
ENT.HasWeaponReloadSounds = true -- If set to false, it won't play any sound when reloading
ENT.HasMeleeAttackSounds = true -- Can it play melee attack sounds? | Controls "self.SoundTbl_BeforeMeleeAttack", "self.SoundTbl_MeleeAttack", and "self.SoundTbl_MeleeAttackExtra"
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.HasMeleeAttackMissSounds = true -- If set to false, it won't play the melee attack miss sound
ENT.HasGrenadeAttackSounds = true -- If set to false, it won't play any sound when doing grenade attack
ENT.HasOnGrenadeSightSounds = true -- If set to false, it won't play any sounds when it sees a grenade
ENT.HasOnDangerSightSounds = true -- If set to false, it won't play any sounds when it detects a danger
ENT.HasOnKilledEnemySounds = true -- Should it play a sound when it kills an enemy?
ENT.HasAllyDeathSounds = true -- Should it paly a sound when an ally dies?
ENT.HasPainSounds = true -- If set to false, it won't play the pain sounds
ENT.HasImpactSounds = true -- If set to false, it won't play the impact sounds
ENT.HasDamageByPlayerSounds = true -- If set to false, it won't play the damage by player sounds
ENT.HasDeathSounds = true -- If set to false, it won't play the death sounds
-- ====== Sound Chance ====== --
-- Higher number = less chance of playing | 1 = Always play
ENT.IdleSoundChance = 3
ENT.IdleDialogueAnswerSoundChance = 1
ENT.CombatIdleSoundChance = mRng(1,2)
ENT.ReceiveOrderSoundChance = 1
ENT.FollowPlayerSoundChance = 1 -- Controls "self.SoundTbl_FollowPlayer", "self.SoundTbl_UnFollowPlayer"
ENT.YieldToPlayerSoundChance = 2
ENT.MedicBeforeHealSoundChance = 1
ENT.MedicOnHealSoundChance = 1
ENT.MedicReceiveHealSoundChance = 1
ENT.OnPlayerSightSoundChance = 1
ENT.InvestigateSoundChance = mRng(1,2)
ENT.LostEnemySoundChance = mRng(1,2)
ENT.AlertSoundChance = 1
ENT.CallForHelpSoundChance = 1
ENT.BecomeEnemyToPlayerChance = mRng(1,2)
ENT.BeforeMeleeAttackSoundChance = 1
ENT.MeleeAttackSoundChance = 1
ENT.ExtraMeleeSoundChance = 1
ENT.MeleeAttackMissSoundChance = 1
ENT.GrenadeAttackSoundChance = 1
ENT.DangerSightSoundChance = 1 -- Controls "self.SoundTbl_DangerSight", "self.SoundTbl_GrenadeSight"
ENT.SuppressingSoundChance = 2
ENT.WeaponReloadSoundChance = 1
ENT.KilledEnemySoundChance = mRng(1, 2)
ENT.AllyDeathSoundChance = mRng(1, 3)
ENT.PainSoundChance = 2
ENT.ImpactSoundChance = 1
ENT.DamageByPlayerSoundChance = 1
ENT.DeathSoundChance = 2
ENT.SoundTrackChance = 1
-- ====== Timer ====== --
-- Randomized time between the two variables, x amount of time has to pass for the sound to play again | Counted in seconds
-- false = Base will decide the time
ENT.NextSoundTime_Breath = VJ.SET(1, 5)
ENT.NextSoundTime_Idle = VJ.SET(10, 25)
ENT.NextSoundTime_Investigate = VJ.SET(5, 10)
ENT.NextSoundTime_LostEnemy = VJ.SET(5, 7)
ENT.NextSoundTime_Alert = VJ.SET(2, 3)
ENT.NextSoundTime_Suppressing = VJ.SET(7, 15)
ENT.NextSoundTime_KilledEnemy = VJ.SET(3, 5)
ENT.NextSoundTime_AllyDeath = VJ.SET(3, 5)
-- ====== Sound Level ====== --
-- The proper number are usually range from 0 to 180, though it can go as high as 511
-- More Information: https://developer.valvesoftware.com/wiki/Soundscripts#SoundLevel_Flags
local rngSoundLevel = mRng(60, 75)
ENT.FootstepSoundLevel = 70
ENT.BreathSoundLevel = math.Round(rngSoundLevel / 2, 0) 
ENT.IdleSoundLevel = rngSoundLevel
ENT.IdleDialogueSoundLevel = rngSoundLevel -- Controls "self.SoundTbl_IdleDialogue", "self.SoundTbl_IdleDialogueAnswer"
ENT.CombatIdleSoundLevel = rngSoundLevel
ENT.ReceiveOrderSoundLevel = rngSoundLevel
ENT.FollowPlayerSoundLevel = rngSoundLevel -- Controls "self.SoundTbl_FollowPlayer", "self.SoundTbl_UnFollowPlayer"
ENT.YieldToPlayerSoundLevel = rngSoundLevel
ENT.MedicBeforeHealSoundLevel = rngSoundLevel
ENT.MedicOnHealSoundLevel = rngSoundLevel
ENT.MedicReceiveHealSoundLevel = rngSoundLevel
ENT.OnPlayerSightSoundLevel = rngSoundLevel
ENT.InvestigateSoundLevel = rngSoundLevel
ENT.LostEnemySoundLevel = rngSoundLevel
ENT.AlertSoundLevel = rngSoundLevel
ENT.CallForHelpSoundLevel = rngSoundLevel
ENT.BecomeEnemyToPlayerSoundLevel = rngSoundLevel
ENT.BeforeMeleeAttackSoundLevel = rngSoundLevel
ENT.MeleeAttackSoundLevel = rngSoundLevel
ENT.ExtraMeleeAttackSoundLevel = rngSoundLevel
ENT.MeleeAttackMissSoundLevel = rngSoundLevel
ENT.SuppressingSoundLevel = rngSoundLevel
ENT.WeaponReloadSoundLevel = rngSoundLevel
ENT.GrenadeAttackSoundLevel = rngSoundLevel
ENT.DangerSightSoundLevel = rngSoundLevel -- Controls "self.SoundTbl_DangerSight", "self.SoundTbl_GrenadeSight"
ENT.KilledEnemySoundLevel = rngSoundLevel
ENT.AllyDeathSoundLevel = rngSoundLevel
ENT.PainSoundLevel = rngSoundLevel
ENT.ImpactSoundLevel = rngSoundLevel
ENT.DamageByPlayerSoundLevel = rngSoundLevel
ENT.DeathSoundLevel = rngSoundLevel
-- ====== Sound Pitch ====== --
-- Range: 0 - 255 | Lower pitch < x > Higher pitch
ENT.MainSoundPitch = VJ.SET(75, 115) -- Can be a number or VJ.SET
ENT.MainSoundPitchStatic = true -- Should it decide a number on spawn and use it as the main pitch?
-- false = Use main pitch | number = Use a specific pitch | VJ.SET = Pick randomly between numbers every time it plays
ENT.FootStepPitch = VJ.SET(70, 90)
ENT.BreathSoundPitch = VJ.SET(65, 105)
ENT.IdleSoundPitch = false
ENT.IdleDialogueSoundPitch = VJ.SET(65, 105)
ENT.IdleDialogueAnswerSoundPitch = VJ.SET(76, 105)
ENT.CombatIdleSoundPitch = false
ENT.ReceiveOrderSoundPitch = false
ENT.FollowPlayerPitch = VJ.SET(85, 105) -- Controls both "self.SoundTbl_FollowPlayer" and "self.SoundTbl_UnFollowPlayer"
ENT.YieldToPlayerSoundPitch = VJ.SET(85, 105)
ENT.MedicBeforeHealSoundPitch = VJ.SET(85, 105)
ENT.MedicOnHealSoundPitch = VJ.SET(75, 100)
ENT.MedicReceiveHealSoundPitch = false
ENT.OnPlayerSightSoundPitch = false
ENT.InvestigateSoundPitch = false
ENT.LostEnemySoundPitch = false
ENT.AlertSoundPitch = false
ENT.CallForHelpSoundPitch = false
ENT.BecomeEnemyToPlayerPitch = VJ.SET(85, 105)
ENT.BeforeMeleeAttackSoundPitch = VJ.SET(85, 105)
ENT.MeleeAttackSoundPitch = VJ.SET(95, 100)
ENT.ExtraMeleeSoundPitch = VJ.SET(80, 100)
ENT.MeleeAttackMissSoundPitch = VJ.SET(90, 100)
ENT.SuppressingPitch = false
ENT.WeaponReloadSoundPitch = false
ENT.GrenadeAttackSoundPitch = false
ENT.OnGrenadeSightSoundPitch = false
ENT.DangerSightSoundPitch = false -- Controls "self.SoundTbl_DangerSight", "self.SoundTbl_GrenadeSight"
ENT.KilledEnemySoundPitch = false
ENT.AllyDeathSoundPitch = false
ENT.PainSoundPitch = false
ENT.ImpactSoundPitch = VJ.SET(80, 100)
ENT.DamageByPlayerPitch = VJ.SET(70, 100)
ENT.DeathSoundPitch = false 
