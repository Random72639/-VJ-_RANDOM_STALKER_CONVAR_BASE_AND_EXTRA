/*      ╔════༺†༻✝️༺†༻════╗
    👑  JESUS CHRIST IS LORD  👑
        ╚════༺†༻✝️༺†༻════╝ */

//TO DO

//BIG FLAw, IF USING SHOTGUN OR SHORT RANGE WEAPON, AND IS ALONE, THE SNPC MAY STAND OUT IN THE OPEN AND STARE AT AN ENEMY
//ADD COVER CHECKS FOR CERTIAN MECHANICS
//BACKSTAB? MELEE ATTACKS DO MORE DMG IF ENE HAS BACK TURNED? 
//MOVE WEAPON BURST FIRE LOGIC TO SNPC INSTEAD OF WEAPONS. (MUST IGNORE NON-AUTOMATICS)
//MAKE SNPCS STRONG LIKE SENTRY'S IF ALL CONVS ARE DISABLES
//IF ALERTED, E.G. SHOT, AND NEAR A DOOR, THE SNPCS WILL BREAK IT DOWN, LIKE WTF IS WRONG WITH YOU RANDOM.
//MAKE MOST CUSTOM IDLE ANIMATIONS SUPPORT GESTURE LAYERING

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
local math_Clamp    = math.Clamp
local math_abs      = math.abs
local mRng          = math.random
local mRand         = math.Rand

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
ENT.DeathAnimationDecreaseLengthAmount = mRand(0, 0.325) -- This will decrease the time until it turns into a corpse
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

ENT.AllowedToChangeFireOnDist = false 
ENT.HasFireInBurstAbility = false 
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
ENT.NextRadioDialogueT = mRand(5,10)
ENT.NextSoundTime_RadioDialogue1 = mRand(5,10)
ENT.NextSoundTime_RadioDialogue2 = mRand(20,35)
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
ENT.CryForAid_NextT1 = mRand(1, 5)
ENT.CryForAid_NextT2 = mRand(6, 15)
ENT.CryForAidSoundChance = 2
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
ENT.LimitedGrenCount = mRng(3, 10) -- randomly picks from 1 to this value
ENT.HumanGrenadeCount = 0

    -- [Pickup anim tbl] -- 
ENT.PlyPickUpAnim = {"pickup","civil_proc_pickup"}

    -- [React to fire] --
ENT.CanPlayBurningAnimations = true
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
ENT.MinDmg_Cap_Active = false
ENT.MinDmg_Cap_Feedback_Sfx = true 
ENT.MinDmg_Cap_Feedback_Sfx_Chance = 2
ENT.MinDmg_Cap_Chance = 3 
ENT.MinDmg_Cap_NextT = 0 
ENT.MinDmg_Cap = mRand(3, 8) -- Dmg threshold

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
ENT.HumanPrimaryWeapon = ""
ENT.HumanSecondaryWeapon = ""
ENT.WeaponSwitchT = 0
ENT.CurrentWeapon = 0 -- 0 for primary, 1 for secondary -- 
ENT.CanHumanSwitchWeapons = true 
ENT.CanPickSecondaryWeapon = true
ENT.IsHoldingPrimaryWeapon = false -- For when the SNPC is currently holding out their primary weapon -- 
ENT.IsHoldingSecondaryWeapon = false -- For when the SNPC is currently holding out their secondary weapon -- 
ENT.SecondaryWeaponInvTbl = {"weapon_vj_357","weapon_vj_9mmpistol","weapon_vj_glock17"} -- Valid secondary weapons the SNPC can choose

    -- [Drop sec wep on death] -- 
ENT.Weapon_DropSecondary = true 
ENT.Weapon_DropSecondary_Chance = 2 

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
ENT.Panic_FleeEneChance = 3 
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
ENT.NextFindLootT = 1
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
ENT.Headshot_SearchBone = "ValveBiped.Bip01_Head1"
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
ENT.Radio_RandomDeathSound = true 
ENT.Radio_DeathSoundChance = 2 

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
ENT.DC_Writhe_AFC = false -- Apply force center 
ENT.DC_Writhing = false
ENT.DC_Writhe_UseAllBones = false 
ENT.DC_Writh_Decay_Thresh = 0.15 -- starts decaying when x % time left
ENT.DC_Writhe_TraceDist = 250
ENT.DC_Writhe_Chance = 10
ENT.DC_Writhe_MinT = 3
ENT.DC_Writhe_MaxT = 15

ENT.Shoved_Back = true
ENT.Shoved_Back_Now = false

ENT.Shoved_Com_Active = true 
ENT.Shoved_Explosive_Active = true

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

ENT.ImpMetal_SparkArmor = false 
ENT.ImpMetal_SparkArmorChance = 3

ENT.Valid_CoverClassesTbl = {
    ["prop_physics"] = true,
    ["func_brush"] = true,
    ["prop_static"] = true,
    ["prop_dynamic"] = true
}

ENT.OnAlert_Cover = true 
ENT.AlertCover_DistCheck = 1500

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
            self:RANDOM_CON_DEBUG()
            self:HandleSniperWepLogic() 
            self:InitializeAutoRevival()
            self:WeaponFlashlight()
            self:ManageFriendlyVars()
            self:SaveCurrentWeapon()
            self:PickSecondaryWeapon()
            self:TrackHeldWeapon()
            self:TrackMoveWhileShoot()
            self:TrackStrafeFire()
            self:TrackWeaponBackAway()
            self:SetIncapAnims()
            self:ManageBrutalSounds()
            self:ManageCryForAidSounds()
            self:ManageStepSd()
            self:ManageRandomVars()
            self:MngeExVarTimes()
            self:MngBurnToDeathVO()
            self:Handle_WepFireDelay()
        end
    end)
end

function ENT:CertainAttCharacteristics() 
    self.CanFireFlareGunSeq = false
    self.SNPCGrenadeHandAttachment = "grenade_attachment" 
    self.GrenadeAttackAttachment = "grenade_attachment"
    self.Medic_SpawnPropOnHealAttachment = "grenade_attachment"
    self.DropWeaponOnDeathAttachment = "grenade_attachment"
end

function ENT:RANDOM_CON_DEBUG()
    local conv = "vj_stalker_randoms_console_debug"
    if not self.RANDOMS_DEBUG then 
        if GetConVar(conv):GetInt() == 1 then 
            self.RANDOMS_DEBUG = true 
        end
    end
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
        self.FollowMinDistance = mRand(90,200)
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
function ENT:SetScientific()
    if not self.IsScientific then return false end
    timer.Simple(0.1, function()
        if not IsValid(self) then return end
        self.Immune_Toxic = true 
        self.Immune_Electricity = true
        self.Immune_Sonic = true  
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetHeavyStats()
    if not self.IsHeavilyArmored then return end

    timer.Simple(0.15, function()
        if not IsValid(self) then return end
        
        self.HasAloneAiBehaviour = false 
        self.Shoved_Com_Active = false 
        self.CombatRoll = false 
        self.Evade_IncDanger  = false
        self.Panic_DmgEne = false 
        self.Panic_FleeEneProx = false 
        self.IsImmuneToHeadShots = true 

        self.FlinchChance = self.FlinchChance * mRng(2,4)
        self.ArmorSparking_Chance = self.ArmorSparking_Chance / mRng(2,4)
        self.RetreatAfterMeleeAttackChance = self.RetreatAfterMeleeAttackChance * mRng(2,4)
        local chance = self.HeavySlowMoveChance or 3 
        if self.HeavyUnitHasSlowMoveChance then 
            if mRng(1, chance) == 1 then 
                print("Heavy unit has slow movement.")
                self.Rng_FootStepSet = false 
                self.HasSlowHeavyMovement = true 
                self.HasSlowHeavyFootsteps = true 
            end
        end 

        print("Retreat chance == " .. self.RetreatAfterMeleeAttackChance) 
        print("Armor spark impact == " .. self.ArmorSparking_Chance)
        print("Flinch chance == " .. self.FlinchChance)
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
function ENT:ManageStepSd(force)
    if self._FootstepSetManaged and not force then return end
    self._FootstepSetManaged = true
    timer.Simple(0.1, function()
        if not IsValid(self) then return end
        local heavySteps = {
            "general_sds/heavy_footsteps/step_1.mp3",
            "general_sds/heavy_footsteps/step_2.mp3",
            "general_sds/heavy_footsteps/step_3.mp3",
            "general_sds/heavy_footsteps/step_4.mp3",
            "general_sds/heavy_footsteps/step_5.mp3",
            "general_sds/heavy_footsteps/step_6.mp3"
        }

        local sets = {
            {
                "general_sds/ex_footsteps/gear1.wav","general_sds/ex_footsteps/gear2.wav",
                "general_sds/ex_footsteps/gear3.wav","general_sds/ex_footsteps/gear4.wav",
                "general_sds/ex_footsteps/gear5.wav","general_sds/ex_footsteps/gear6.wav"
            },
            {
                "npc/metropolice/gear1.wav","npc/metropolice/gear2.wav","npc/metropolice/gear3.wav",
                "npc/metropolice/gear4.wav","npc/metropolice/gear5.wav","npc/metropolice/gear6.wav"
            },
            {
                "npc/footsteps/hardboot_generic1.wav","npc/footsteps/hardboot_generic2.wav",
                "npc/footsteps/hardboot_generic3.wav","npc/footsteps/hardboot_generic4.wav",
                "npc/footsteps/hardboot_generic5.wav","npc/footsteps/hardboot_generic6.wav",
                "npc/footsteps/hardboot_generic8.wav"
            },
            {
                "general_sds/ex_footsteps/footstep1.wav","general_sds/ex_footsteps/footstep2.wav",
                "general_sds/ex_footsteps/footstep3.wav","general_sds/ex_footsteps/footstep4.wav",
                "general_sds/ex_footsteps/footstep5.wav","general_sds/ex_footsteps/footstep6.wav",
                "general_sds/ex_footsteps/footstep7.wav","general_sds/ex_footsteps/footstep8.wav"
            },
            {
                "general_sds/ex_footsteps/hardboot_generic1.wav","general_sds/ex_footsteps/hardboot_generic2.wav",
                "general_sds/ex_footsteps/hardboot_generic3.wav","general_sds/ex_footsteps/hardboot_generic4.wav",
                "general_sds/ex_footsteps/hardboot_generic5.wav","general_sds/ex_footsteps/hardboot_generic6.wav",
                "general_sds/ex_footsteps/hardboot_generic7.wav","general_sds/ex_footsteps/hardboot_generic8.wav"
            },
            {
                "general_sds/ex_footsteps/concrete1.wav","general_sds/ex_footsteps/concrete2.wav",
                "general_sds/ex_footsteps/concrete3.wav","general_sds/ex_footsteps/concrete4.wav",
                "general_sds/ex_footsteps/tile1.wav","general_sds/ex_footsteps/tile2.wav",
                "general_sds/ex_footsteps/tile3.wav","general_sds/ex_footsteps/tile4.wav"
            }
        }

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

ENT.BrutalDeathSound_Convar = "vj_stalker_brutal_death_vo"
ENT.BrutalPainSound_Convar = "vj_stalker_brutal_pain_vo"
function ENT:ManageBrutalSounds()
    if not IsValid(self) then return end
    self.DefaultDeathSounds = self.DefaultDeathSounds or CopyTable(self.SoundTbl_Death or {})
    self.DefaultPainSounds  = self.DefaultPainSounds  or CopyTable(self.SoundTbl_Pain or {})
    local deathConv = tostring(self.BrutalDeathSound_Convar) 
    local painConv = tostring(self.BrutalPainSound_Convar)
    local brutalDeathEnabled = GetConVar(deathConv):GetInt() == 1
    local brutalPainEnabled  = GetConVar(painConv):GetInt() == 1
    local ronDeathEnabled    = GetConVar("vj_stalker_ron_death_sounds"):GetInt() == 1

    if brutalDeathEnabled and self.HasBrutalDeathSounds then
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
    if not IsValid(self) then return false end
    
    if not self.DefaultCryForAidSounds then
        self.DefaultCryForAidSounds = CopyTable(self.SoundTbl_CryForAid or {})
    end

    if GetConVar("vj_stalker_brutal_cry_vo"):GetInt() == 1 and self.HasBrutalCFASounds then
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

function ENT:ManageWeaponBackAway()
    local enemy = self:GetEnemy()
    if IsValid(enemy) and self:Visible(enemy) then
        if self.CanBackAwayWithWeapon then
            self.HasWeaponBackAway = true
        else
            self.HasWeaponBackAway = false
        end
    else
        self.HasWeaponBackAway = false
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Helper functions to track "Weapon_CanMoveFire" and "Weapon_Strafe" -- 
function ENT:TrackStrafeFire()
    timer.Simple(1, function()
        if IsValid(self) then 
            if self.Weapon_Strafe then
                self.HasStrafeFire = true 
                print("Has strafe fire behaviour!")
            else
                self.HasStrafeFire = false 
                print("Does not have strafe fire behaviour!")
            end 
        end 
    end)
end 

function ENT:TrackMoveWhileShoot()
    timer.Simple(1, function()
        if IsValid(self) then 
            if self.Weapon_CanMoveFire then 
                self.HasMoveAndShoot = true
                if self.RANDOMS_DEBUG then 
                    print("Has shoot while moving behaviour.")
                else
                    self.HasMoveAndShoot = false
                    print("Does not have shoot while moving behaviour.")
                end
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
    if not self.FireModeChangeOnDist or self.VJ_IsBeingControlled then return false end
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
function ENT:ManageRandomVars()
    -- An attempt to make SNPCs behavior a bit more random --
    timer.Simple(0.1, function()
        if IsValid(self) then 
            local curT               = CurTime()
            local defaultFov         = self.SightAngle
            local cvar_viewangle     = GetConVar("vj_stalker_snpc_view_angle"):GetInt()
            local cvar_radio         = GetConVar("vj_stalker_radio_chatter"):GetInt()
            local cvar_deathanims    = GetConVar("vj_stalker_death_anims"):GetInt()
            local cvar_dodging       = GetConVar("vj_stalker_dodging"):GetInt()
            local cvar_neverforget   = GetConVar("vj_stalker_never_forget"):GetInt()
            local cvar_limitednades  = GetConVar("vj_stalker_limited_grenades"):GetInt()
            local cvar_healself      = GetConVar("vj_stalker_heal_self"):GetInt()

            local tblAlResp = {"OnlyMove", "OnlySearch", true}
            local infT  = curT + 9999999999999
            local defT  = curT + mRand(10, 20)
            local defTurn = self.TurningSpeed or 10
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

            self.BloodDecalDistance = mRand(100, 320)
            self.IdleDialogueDistance = mRand(350, 650)

            if self.Alterable_ViewCone then
                if self.ArmoredHelmet_AffectFov then
                    self.SightAngle = self.ArmoredHelmet_CusFov
                else
                    self.SightAngle = cvar_viewangle
                end
                print(self.SightAngle)
            else
                self.SightAngle = defaultFov
            end

            if not self.DeathAllyResponse then 
                self.DeathAllyResponse = VJ.PICK({"OnlyAlert", true})  
            end 

            local choice = VJ.PICK({"Both", "Moving", "Standing"})
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
            if self.RngPickMoveAndShoot then 
                self.Weapon_CanMoveFire = table.Random(tbl) 
                if self.Weapon_CanMoveFire then
                    self.Weapon_Strafe = table.Random(tbl)  
                else 
                    self.Weapon_Strafe = false 
                end 
            end 

            if not self.Weapon_FindCoverOnReload and not self.DoesNotHaveCoverReload then 
                self.DoesNotHaveCoverReload = true 
                if self.RANDOMS_DEBUG then 
                    print("Doesn't have find cover reload.")
                else 
                    print("Has find cover reload.")
                end 
            end 

            if self.HasGrenadeAttackMechRng then 
                self.HasGrenadeAttack = mRng(1, 3) ~= 1
            end 

            if self.HasGrenadeAttack then 
                if cvar_limitednades == 1 and self.LimitedGrenades then
                    local grenCount = mRng(1, self.LimitedGrenCount)
                    self.HasLimitedGrenadeCount = true 
                    self.HumanGrenadeCount = grenCount or 2 
                end 
            end 

            if self.IsHeavilyArmored then 
                self.TurningSpeed = 5
            else 
                self.TurningSpeed = defTurn + mRng(1, 5)
            end 

            if cvar_radio == 1 then 
                local chanceForRadio = self.HasRadioSpawnChance
                if self.HasAccessToRadio and mRng(1, chanceForRadio) == 1 then
                    self.HasRadioChatDialogue = true 
                end 
            end

            if cvar_deathanims == 1 then
                self.HasDeathAnimation = true 
            end

            if mRng(1, self.Has_CmbDodgeChance) == 1 and cvar_dodging == 1 then
                self.CombatEvade = true
            end

            if cvar_neverforget == 1 then
                if self.RANDOMS_DEBUG then 
                    print(infT .. " and " .. defT)
                end 
                self.EnemyTimeout = infT
            else
                self.EnemyTimeout = defT
            end 

            self.DamageAllyResponse = mRng(#tblAlResp)
            if mRng(1, 2) == 1 then self.HasFireInBurstAbility = true end 
            if mRng(1, 2) == 1 then self.AllowedToChangeFireOnDist = true end  
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

function ENT:Handle_WepFireDelay()
    local cvExtDelay = GetConVar("vj_stalker_ext_fire_delay")
    local cvNoDelay  = GetConVar("vj_stalker_no_fire_delay")
    local wep = self:GetActiveWeapon()
    if not IsValid(wep) then return end
    if wep.NPC_TimeUntilFire == nil then return end
    wep._VJ_Def_NPC_TimeUntilFire = wep._VJ_Def_NPC_TimeUntilFire or wep.NPC_TimeUntilFire

    local extDelay = cvExtDelay and cvExtDelay:GetInt() == 1
    local noDelay  = cvNoDelay  and cvNoDelay:GetInt() == 1
    if noDelay then
        wep.NPC_TimeUntilFire = 0
        print("Weapon time until fire = " .. wep.NPC_TimeUntilFire)
        return
    end
    if extDelay then
        local delay = mRand(0.5, 2.55)
        print("Weapon time until fire = " .. wep.NPC_TimeUntilFire)
        wep.NPC_TimeUntilFire = wep._VJ_Def_NPC_TimeUntilFire + delay
    else 
        print("Weapon time until fire = " .. wep.NPC_TimeUntilFire)
        wep.NPC_TimeUntilFire = wep._VJ_Def_NPC_TimeUntilFire
    end
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
        {1, 5}, {4, 10}, {5, 15},
        {10, 15}, {1, 10}, {5, 20}
    }

    if self.Rng_WaitForEneTime and self.Weapon_OcclusionDelay then
        local t = waitForEnemyTimers[waitForEnemyPick]
        self.Weapon_OcclusionDelayTime = VJ.SET(mRand(t[1], t[2]),mRand(t[2], t[2] + 5))
    else
        self.Weapon_OcclusionDelayTime = VJ.SET(2, 7)
    end

    timer.Simple(0.1, function()
        if not IsValid(self) then return end
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
//Fix parenting for amb glow 
function ENT:WeaponFlashlight()
    if GetConVar("vj_stalker_wep_flashlight"):GetInt() ~= 1 then return false end 
    local weaponLightChance = self.WeaponFlashLightChance
    
    timer.Simple(0.1, function()
        if not IsValid(self) then return end

        local wep = self:GetActiveWeapon()
        if not IsValid(wep) then return end
        if not self.AllowedToHaveWepFlashLight then return end
        if mRng(1, weaponLightChance) ~= 1 then return end

        local holdType = wep.HoldType
        if holdType == "pistol" or holdType == "revolver" or holdType == "rpg" then
            return
        end

        local muzzleAttachmentIndex = nil
        local muzzleAttachment = nil
        local muzzleAttachmentName = nil

        for _, attName in ipairs(self.WeaponMuzzleAttachments) do
            local attachmentIndex = wep:LookupAttachment(attName)
            if attachmentIndex and attachmentIndex > 0 then
                muzzleAttachment = wep:GetAttachment(attachmentIndex)
                muzzleAttachmentIndex = attachmentIndex
                muzzleAttachmentName = attName
                break
            end
        end

        if not muzzleAttachment then
            print("No valid muzzle att's was found for the weapon: " .. tostring(wep:GetClass()))
            return false
        end

        wep.WeaponFlashlightFlag = true 
        self.HumanWepHasWepFlashLight = true

        local rngFlashTextureColor = nil
        local rngFlashSpriteColor = nil
        local rngAmbientSurColor = nil

        local rngNearz = mRand(10, 15)
        local rngFarz = mRand(600, 850)
        local rngFOV = mRand(40, 60)

        self.WeaponFlashlightSpotLight = ents.Create("env_projectedtexture")
        self.WeaponFlashlightSpotLight:SetParent(wep) 
        self.WeaponFlashlightSpotLight:SetPos(muzzleAttachment.Pos)
        self.WeaponFlashlightSpotLight:SetAngles(muzzleAttachment.Ang)
        self.WeaponFlashlightSpotLight:SetKeyValue("enableshadows", "1")
        self.WeaponFlashlightSpotLight:SetKeyValue("shadowquality", "1")
        self.WeaponFlashlightSpotLight:SetKeyValue("SetNearZ", rngNearz)
        self.WeaponFlashlightSpotLight:SetKeyValue("SetFarZ", rngFarz)
        self.WeaponFlashlightSpotLight:SetKeyValue("SetFOV", rngFOV)
        self.WeaponFlashlightSpotLight:Input("SpotlightTexture", NULL, NULL, "effects/flashlight001")
        self.WeaponFlashlightSpotLight:SetOwner(self)
        self.WeaponFlashlightSpotLight:Spawn()

        if muzzleAttachmentName then
            self.WeaponFlashlightSpotLight:Fire("SetParentAttachment", muzzleAttachmentName)
        end
        table.insert(self.WepFlashEntTbl, self.WeaponFlashlightSpotLight)
        self:DeleteOnRemove(self.WeaponFlashlightSpotLight)

        local spotLightChance = self.FlashlightSpotlightChance 
        if self.HasWepFlashlightSpotlight and mRng(1, spotLightChance) == 1 then 
            local spotLength = mRng(500, 950)
            local spotWidth = mRng(15,35)

            self.Spotlight = ents.Create("beam_spotlight")
            self.Spotlight:SetPos(muzzleAttachment.Pos)
            self.Spotlight:SetAngles(muzzleAttachment.Ang)
            self.Spotlight:SetKeyValue("spotlightlength", spotLength)
            self.Spotlight:SetKeyValue("spotlightwidth", spotWidth)
            self.Spotlight:SetKeyValue("spawnflags","2")
            self.Spotlight:Fire("Color","255 255 255")
            self.Spotlight:SetParent(wep, muzzleAttachmentIndex)
            self.Spotlight:Spawn()
            self.Spotlight:Activate()
            self.Spotlight:Fire("lighton")
            self.Spotlight:AddEffects(EF_PARENT_ANIMATES)
            self:DeleteOnRemove(self.Spotlight)

            if muzzleAttachmentName then
                self.Spotlight:Fire("SetParentAttachment", muzzleAttachmentName)
            end
            table.insert(self.WepFlashEntTbl, self.Spotlight)
            self:DeleteOnRemove(self.Spotlight)
        end 

        -- Light glow orb
        local orbRngChance = self.FlashLightGlowOrbChance
        if self.HasWeaponFlashGlowOrb and mRng(1, orbRngChance) == 1 then 
            self.WeaponGlowOrb = ents.Create("env_sprite")
            local rngOrbScale = mRand(0.1, 0.35)
            self.WeaponGlowOrb:SetKeyValue("model", "sprites/light_glow03.vmt")
            self.WeaponGlowOrb:SetPos(muzzleAttachment.Pos)
            self.WeaponGlowOrb:SetKeyValue("scale", tostring(rngOrbScale))
            self.WeaponGlowOrb:SetKeyValue("rendercolor", "255 255 255 255")
            self.WeaponGlowOrb:SetParent(wep, muzzleAttachmentIndex)
            self.WeaponGlowOrb:SetKeyValue("rendermode", "9")
            self.WeaponGlowOrb:SetKeyValue("spawnflags", "0")
            self.WeaponGlowOrb:SetAngles(muzzleAttachment.Ang)
            self.WeaponGlowOrb:Spawn()
            self.WeaponGlowOrb:Activate()

            if muzzleAttachmentName then
                self.WeaponGlowOrb:Fire("SetParentAttachment", muzzleAttachmentName)
            end
            table.insert(self.WepFlashEntTbl, self.WeaponGlowOrb)
            self:DeleteOnRemove(self.WeaponGlowOrb)
        end 

        -- Ambient Surrounding Glow
        local ambLightRngChance = self.FlashLightAmbGlowChance
        if IsValid(self.WeaponFlashlightSpotLight) and self.HasWeaponFlashAmbGlow and mRng(1, ambLightRngChance) == 1 then 
            self.FlashlightGlow = ents.Create("light_dynamic")
            self.FlashlightGlow:SetParent(self.WeaponFlashlightSpotLight)
            self.FlashlightGlow:SetPos(self.WeaponFlashlightSpotLight:GetPos())
            self.FlashlightGlow:SetAngles(self:GetAngles())
            self.FlashlightGlow:SetKeyValue("brightness", tostring(mRand(1, 8)))
            self.FlashlightGlow:SetKeyValue("distance", tostring(mRand(25, 50)))
            self.FlashlightGlow:SetKeyValue("rendercolor", "255 255 255")
            self.FlashlightGlow:Spawn()
            self.FlashlightGlow:Activate()
            table.insert(self.WepFlashEntTbl, self.FlashlightGlow)
            self:DeleteOnRemove(self.FlashlightGlow)
        end 
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsVJAnimationLockState()
    if not IsValid(self) then return end 
    if not self.IsVJBaseSNPC then return end 
    if not self:Alive() then return end 

    local state = self:GetState()
    local badState = (state == VJ_STATE_ONLY_ANIMATION_CONSTANT or state == VJ_STATE_ONLY_ANIMATION or state == VJ_STATE_ONLY_ANIMATION_NOATTACK or state == VJ_STATE_FREEZE)
    
    if self.RANDOMS_DEBUG then
        print("AnimState:", state, "Blocked:", badState)
    end

    return badState
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCallForHelp(ally, isFirst)
    if not IsValid(ally) or ally.VJ_IsBeingControlled or not ally.Ally_RespondCallForHelp then return false end 
    if ally:GetClass() == self:GetClass() and not ally:IsBusy("Activities") and mRng(1, ally.Ally_ResponseCallForHelpAnimChance or 1) == 1 and ally.IsVJBaseSNPC and ally.IsVJBaseSNPC_Human then
    
        local cfhTbl = istable(ally.Ally_CfhResponseAnim) and #ally.Ally_CfhResponseAnim > 0 and VJ.PICK(ally.Ally_CfhResponseAnim)
        local baseCallHelpTbl = istable(ally.AnimTbl_CallForHelp) and #ally.AnimTbl_CallForHelp > 0 and VJ.PICK(ally.AnimTbl_CallForHelp)
        local responseAnim = nil
        if cfhTbl then
            responseAnim = "vjges_" .. cfhTbl
        elseif baseCallHelpTbl then
            responseAnim = baseCallHelpTbl
        end
        local animT = ally:SequenceDuration(ally:LookupSequence(responseAnim))
        if responseAnim then
            ally:PlayAnim(responseAnim, true, animT, ally.CallForHelpAnimFaceEnemy)
            ally.CallForHelpAnimCooldown = CurTime() + (ally.CallForHelpAnimCooldown or 0)

            if mRng(1, 2) == 1 then 
                ally:PlaySoundSystem("CallForHelp")
            end 
        end
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
    if self.VJ_IsBeingControlled or self:IsBusy() then return end 
    VJ.STOPSOUND(self.CurrentIdleSound)
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
ENT.ReactiveCover_ArmedEne = true 
ENT.ReactiveCoverChance = 3 
ENT.ReactiveCoverNextT = 10   
ENT.NextReactiveCoverT = 0        

function ENT:ReactiveCoverBehavior()
    if not self.ReactiveCover_ArmedEne or self.VJ_IsBeingControlled then return false end
    local busy = self:IsVJAnimationLockState() or self:IsBusy()
    if self.PerformingAlertBehavior or self.IsGuard or self.CurrentlyHealSelf or busy or not self:IsOnGround() then return end
    local cT = CurTime()
    if cT < self.TakingCoverT then return end 
    if cT < self.NextReactiveCoverT then return end

    local enemy = self:GetEnemy()
    if not IsValid(enemy) then return end
    local exDelay = mRand(5, 20) or 20
    local wep = enemy:GetActiveWeapon()
    local chance = self.ReactiveCoverChance or 3 

    if not IsValid(wep) then return end 
    if mRng(1, chance) ~= 1 then return end

    if self:IsCurrentSchedule(30) or self:IsCurrentSchedule(27) then return end

    self.NextReactiveCoverT = cT + self.ReactiveCoverNextT + exDelay
    self:StopMoving()
    self:ClearSchedule()
    local choice = mRng(1, 2)
    local coverDelay = 0
    local coverPos = nil
    local dist = tonumber(self.AlertCover_DistCheck) or 1250

    if choice == 1 and IsValid(enemy) and mRng(1, 2) == 1 then
        self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH", function(x)
            x.DisableChasingEnemy = true
            if mRng(1, 2) == 1 then 
                x.CanShootWhenMoving = true
                x.TurnData = {Type = VJ.FACE_ENEMY}
            else
                x.CanShootWhenMoving = false  
                x.TurnData = {Type = VJ.FACE_ENEMY, Target = nil}
            end 
        end)
        coverDelay = mRand(1.5, 3.5)
    else
        if mRng(1, 2) == 1 then
            self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH", function(x)
                x.DisableChasingEnemy = true
                if mRng(1, 2) == 1 then 
                    x.CanShootWhenMoving = true
                    x.TurnData = {Type = VJ.FACE_ENEMY}
                else
                    x.CanShootWhenMoving = false  
                    x.TurnData = {Type = VJ.FACE_ENEMY, Target = nil}
                end 
            end)
        end
        coverDelay = mRand(1, 5)
    end
    print("Taken cover cuz ene is armed!!!!")
    self.TakingCoverT = CurTime() + coverDelay
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TakeCover(enemy)
    if not self.OnAlert_Cover or self.VJ_IsBeingControlled then return false end 
    if not IsValid(enemy) or not self.PerformingAlertBehavior or self.IsGuard then return false end
    local curTime = CurTime()
    local selfPos = self:GetPos()
    local isBusy = self:IsBusy()
    local coverPos
    local flagResetT = mRng(1, 5)
    local dist = tonumber(self.AlertCover_DistCheck) or 1500

    if curTime < self.TakingCoverT then return end 
    local myPosCent = self:GetPos() + self:OBBCenter()
    local eyePos = self:EyePos()
    local inCover = self:DoCoverTrace(myPosCent, eyePos, false, {SetLastHiddenTime = true})
    if inCover then return end 
    if self:IsCurrentSchedule(30) or self:IsCurrentSchedule(27) then return end

    for _, prop in ipairs(ents.FindInSphere(selfPos, dist)) do
        if self.Valid_CoverClassesTbl[prop:GetClass()] and not isBusy then
            coverPos = prop:GetPos()
            break
        end
    end

    self:StopMoving()
    self:ClearSchedule()

    local choice = mRng(1, 3)
    local coverDelay = 0
    local fcEne = VJ.FACE_ENEMY
    timer.Simple(0.1, function()
        if not IsValid(self) then return end
        if choice == 1 and IsValid(enemy) then
            self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH", function(x)
            if mRng(1, 2) == 1 then 
                x.CanShootWhenMoving = true
                x.TurnData = {Type = fcEne}
            else
                x.CanShootWhenMoving = false  
                x.TurnData = {Type = fcEne, Target = nil}
            end 
        end)
            coverDelay = mRand(1.5, 3.5)
        elseif choice == 2 or (choice == 3 and mRng(1, 2) == 1) then
            self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH", function(x)
                x.DisableChasingEnemy = true
            if mRng(1, 2) == 1 then 
                x.CanShootWhenMoving = true
                x.TurnData = {Type = fcEne}
            else
                x.CanShootWhenMoving = false  
                x.TurnData = {Type = fcEne, Target = nil}
            end 
        end)
            coverDelay = mRand(1, 5)
        elseif choice == 3 and coverPos then
            self:SetLastPosition(coverPos)
            self:SCHEDULE_GOTO_POSITION("TASK_RUN_PATH", function(x)
            x.DisableChasingEnemy = true
            if mRng(1, 2) == 1 then 
                x.CanShootWhenMoving = true
                x.TurnData = {Type = fcEne}
            else
                x.CanShootWhenMoving = false  
                x.TurnData = {Type = fcEne, Target = nil}
            end 
        end)
            coverDelay = mRand(1, 5)
        elseif choice == 3 and not coverPos then
            self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH", function(x)
            x.DisableChasingEnemy = true
            if mRng(1, 2) == 1 then 
                x.CanShootWhenMoving = true
                x.TurnData = {Type = VfcEne}
            else
                x.CanShootWhenMoving = false  
                x.TurnData = {Type = fcEne, Target = nil}
            end 
        end)
            coverDelay = mRand(1, 5)
        else
            self.PerformingAlertBehavior = false
            return
        end

        self.TakingCoverT = curTime + coverDelay

        if self.PerformingAlertBehavior then
            timer.Simple(flagResetT, function()
                if IsValid(self) then
                    self.PerformingAlertBehavior = false
                end
            end)
        end
    end)
end

function ENT:PerformAlertSignal(enemy)
    if not self.PerformingAlertBehavior then return end 
    if not IsValid(enemy) then return end
    if not self:IsBusy() and enemy:Visible(self) then
        local distanceToEnemy = self:GetPos():Distance(enemy:GetPos())
        if distanceToEnemy > mRand(1200, 1525) then 
            local signalAnims = VJ.PICK({"gesture_signal_takecover","gesture_signal_right","gesture_signal_left","gesture_signal_halt","gesture_signal_advance","gesture_signal_forward","gesture_signal_group"})
            self:PlayAnim("vjges_" .. signalAnims)
            self.AlertSignalChance = true
            self.TakingCoverT = CurTime() + mRand(1, 4)

            if mRng(1, 3) == 1 and not self.IsGuard then 
                self:StopMoving()
                self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH", function(x) 
                    x.DisableChasingEnemy = false
                    x:EngTask("TASK_FACE_ENEMY", 0) 
                    x.CanShootWhenMoving = true 
                    x.TurnData = {Type = VJ.FACE_ENEMY} 
                end)
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
function ENT:FireFlareGun(enemy)
    if not self.CanFireFlareGunSeq then return end 
    if not self.PerformingAlertBehavior then return end 

    if not IsValid(enemy) then return end

    local conv = GetConVar("vj_stalker_fire_flares"):GetInt()
    if conv ~= 1 then return end 

    local mDist = self.FireFlareSeq_MaxDist or 5000
    local busy = self:IsVJAnimationLockState() or self:IsBusy()
    
    if self:GetPos():Distance(enemy:GetPos()) < mDist or not self.Alerted or busy then 
        self.PerformingAlertBehavior = false
        return false
    end

    local fireFlareChance = self.FireFlareSeq_Chance or 6 
    local initDelayT = mRand(0.4, 0.55)
    local rngSnd = mRng(80, 110)
    local drawWepSnd = VJ.PICK(self.DrawNewWeaponSound)

    local traceResult = util.TraceLine({
        start = self:GetPos(),
        endpos = self:GetPos() + Vector(0, 0, mRand(5725, 6500)), 
        filter = self
    })

    if traceResult.Hit then
        self.PerformingAlertBehavior = false
        return
    end

    local attachmentName = nil
    for _, attName in ipairs(self.FlareGunAttachment) do
        local attachmentIndex = self:LookupAttachment(attName)
        if attachmentIndex and attachmentIndex > 0 then
            attachmentName = attName
            break 
        end
    end

    if not attachmentName then
        self.PerformingAlertBehavior = false
        return
    end

    local activeWeapon = self:GetActiveWeapon()
    local rngVol = mRng(60, 75)

    if IsValid(activeWeapon) and mRng(1, fireFlareChance) == 1 then
        if self.NextFireFlareT <= CurTime() then 

            local shootFlare = self.FireFlareGun_Anim 
            local anim;

            if shootFlare and shootFlare ~= false then 
                if istable(self.FireFlareGun_Anim) then 
                    anim = table.Random(self.FireFlareGun_Anim)
                elseif isstring(self.FireFlareGun_Anim) then 
                    anim = self.FireFlareGun_Anim 
                end
            end 

            if not anim then return end 

            local seq = self:LookupSequence(anim)
            if not seq or seq < 0 then return end 

            local aT = self:SequenceDuration(seq) or 1 

            activeWeapon:SetNoDraw(true)

            if drawWepSnd then 
                VJ.EmitSound(self, drawWepSnd, rngVol, rngSnd)
            end 
            
            self:RemoveAllGestures()
            self:PlayAnim("vjseq_" .. anim, true, aT, true)

            local RHand = self:GetAttachment(self:LookupAttachment(attachmentName))
            self.PropFlareGun = ents.Create("prop_vj_animatable")
            self.PropFlareGun:SetModel("models/vj_base/weapons/w_flaregun.mdl")
            self.PropFlareGun:SetPos(RHand.Pos)
            self.PropFlareGun:SetAngles(RHand.Ang)
            self.PropFlareGun:SetParent(self)
            self.PropFlareGun:Fire("SetParentAttachment", attachmentName)
            self.PropFlareGun:Spawn()
            self.PropFlareGun:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

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

            timer.Simple(sFAnimT + 0.08, function()
                SafeRemoveEntity(self.PropFlareGun)
                if IsValid(self) then
                    local smgAnim = smgdraw
                    local smgAT = VJ.AnimDuration(self, smgAnim) or 2 
                    self:PlayAnim("vjseq_" .. smgAnim, true, smgAT, false)
                    VJ.EmitSound(self, self.DrawNewWeaponSound, rngVol, rngSnd)
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
    if not IsValid(self) and not IsValid(self:GetActiveWeapon()) then return end
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

    if not IsValid(self) or not IsValid(self:GetActiveWeapon()) then return end
    timer.Simple(1, function() 
       if IsValid(self) then 
        if IsValid(wep) then
        end
        local wep = self:GetActiveWeapon()
            print("Current weapon saved in ENT.HumanPrimaryWeapon table:", self.HumanPrimaryWeapon)
        else
            print("Failed to save the current weapon in ENT.HumanPrimaryWeapon table.")
        end
    end)
end

function ENT:PickSecondaryWeapon()
    if not IsValid(self) or GetConVar("vj_stalker_weapon_switching"):GetInt() ~= 1 then return end 
    if not self.CanPickSecondaryWeapon then return end
    local chosenWeapon = VJ.PICK(self.SecondaryWeaponInvTbl)
    if chosenWeapon then
        self.HumanSecondaryWeapon = chosenWeapon
        print("Secondary wep picked:", chosenWeapon)
    else
        print("No secondary wep chosen!")
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Sts_SeqWepAnim = {"drawpistol"}
ENT.Sts_GesWepAnim = {"unholster_pistol","unholster_pistol2"}
ENT.Stp_SeqWepAnim = {"smgdraw"} 
ENT.Stp_GesWepAnim = {"weapon_draw_gesture","unholster_heavy","unholster_heavy2","unholster_light"}
ENT.WepSwitchRange_Max = 2500 -- If over this value, don't switch to weapon 
ENT.PrimaryWepIdleSwitchDelay = {25, 90} 
ENT.NextIdleWeaponSwitchT = 0 
ENT.Wep_InvSwithcSound = true 

function ENT:WeaponSwitchMechanic()
    local wepSwitchConv = GetConVar("vj_stalker_weapon_switching"):GetInt() 
    local debugging = self.RANDOMS_DEBUG
    if wepSwitchConv ~= 1 then return end 
    if self:IsBusy("Activities") or self.VJ_IsBeingControlled or not IsValid(self) then
        return 
    end

    local ct = CurTime()

    local ene = self:GetEnemy()
    local curWep = self:GetActiveWeapon()
    local maxDistSqr = self.WepSwitchRange_Max * self.WepSwitchRange_Max
    if not isstring(self.HumanPrimaryWeapon) or self.HumanPrimaryWeapon == "" or not weapons.GetStored(self.HumanPrimaryWeapon) or
       not isstring(self.HumanSecondaryWeapon) or self.HumanSecondaryWeapon == "" or not weapons.GetStored(self.HumanSecondaryWeapon) then
        return false
    end

    if not IsValid(self.SecondaryWeaponEntity) then
        self.SecondaryWeaponEntity = self:Give(self.HumanSecondaryWeapon)
        if IsValid(self.SecondaryWeaponEntity) then
            self:SelectWeapon(self.HumanPrimaryWeapon) 
        end
    end
    if IsValid(ene) then 
        local badEne = (ene.VJ_ID_Boss or ene.IsVJBaseSNPC_Tank)
        if self.CanHumanSwitchWeapons and not badEne and self:GetWeaponState() ~= VJ.WEP_STATE_RELOADING and self:GetPos():DistToSqr(ene:GetPos()) < maxDistSqr and not self:IsBusy() and ct > self.WeaponSwitchT and IsValid(curWep) and not curWep.IsMeleeWeapon and not self:IsMoving() then

            VJ.EmitSound(self, self.DrawNewWeaponSound, 85, 115)
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

        elseif not IsValid(ene) and self.CurrentWeapon == 1 and ct > self.NextIdleWeaponSwitchT and self:GetNPCState() == NPC_STATE_IDLE and not self.Alerted then

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
    local switchSnd = mRng(1, #self.DrawNewWeaponSound)
    timer.Simple(delay, function()
        if IsValid(self) then
            if switchSnd then
                VJ.EmitSound(self, switchSnd, 70, mRng(85, 115))
            end 
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
ENT.GrenThrow_L = {"grenthrow", "throwitem", "grenthrow_hecu"}
ENT.GrenThrow_Gesture = {"grenthrow_gesture"}
ENT.GrenThrow_R = {"righthand_grendrop_cmb_b", "righthand_grenthrow_cmb_b"}
ENT.GrenThrow_Close = {"grendrop", "grenplace"}
ENT.GrenThro_EneTooClose = 1000

function ENT:VJ_Schedule_TaskStuff(task)
    task.DisableChasingEnemy = true
    if mRng(1, 2) == 1 then
        task.CanShootWhenMoving = true
        task.TurnData = {Type = VJ.FACE_ENEMY}
    else
        task.CanShootWhenMoving = false
        task.TurnData = {Type = VJ.FACE_ENEMY, Target = nil}
    end
end 

function ENT:OnGrenadeAttack(status, overrideEnt, landDir)
    local forceGesGrenMoveChance = self.FrcMoveGesGrenThrwChance or 3 
    self.CurrentGrenadeThrow_IsCloseRange = false
    self.CurrentGrenadeThrow_IsGesture = false 

    if status == "Init" then
        self:RemoveAllGestures()
        local ene = self:GetEnemy()
        local distToEnemy = (IsValid(ene) and self:GetPos():DistToSqr(ene:GetPos())) or (self.GrenThro_EneTooClose or 1250)

        if not self.VJ_IsBeingControlled and self.HasAltGrenThrowAnims then
            if distToEnemy <= self.NPC_GrenadeCloseProxDist and mRng(1, 3) ~= 1 then
                print("Close-range gren throw")
                local throwAnim = table.Random(self.GrenThrow_Close)
                if throwAnim then 
                    self.AnimTbl_GrenadeAttack = "vjseq_" .. throwAnim
                    self.GrenadeAttackAttachment = "anim_attachment_LH"
                    self.CurrentGrenadeThrow_IsCloseRange = true
                    return
                end 
            end

            local throwType  = mRng(1, 3)

            if throwType == 1 then
                print("L-Handed grenade throw")
                local throwAnim = table.Random(self.GrenThrow_L)
                if throwAnim then 
                    self.AnimTbl_GrenadeAttack = "vjseq_" .. throwAnim
                    self.GrenadeAttackAttachment = "anim_attachment_LH"
                end 

            elseif throwType == 2 and not self.IsGuard and not self:IsMoving() then
                print("Ges-gren throw")
                local throwAnim = table.Random(self.GrenThrow_Gesture)
                if throwAnim then 
                    self.CurrentGrenadeThrow_IsGesture = true 
                    self.AnimTbl_GrenadeAttack = "vjges_" .. throwAnim
                    self.GrenadeAttackAttachment = "anim_attachment_LH"
                    local moveTy = "TASK_RUN_PATH"
                    if self.ForceMoveOnGesGrenThrow and mRng(1, forceGesGrenMoveChance) == 1 then
                        self:StopMoving()
                        if mRng(1,2) == 1 then
                            self:SCHEDULE_COVER_ORIGIN(moveTy, function(x)
                                self:VJ_Schedule_TaskStuff(x)
                            end)
                        else
                            self:SCHEDULE_COVER_ENEMY(moveTy, function(x)
                                self:VJ_Schedule_TaskStuff(x)
                            end)
                        end
                    end
                end 

            elseif throwType == 3 and self.HasRightHandedGrenThrowAnim then
                print("R-Handed greb throw")
                local throwAnim = table.Random(self.GrenThrow_R)
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

            local moveTy = "TASK_RUN_PATH"
            if not self.CurrentGrenadeThrow_IsGesture and mRng(1, self.FindCoverChanceAfter_Grenade) == 1 and not self.IsGuard then 
                self:StopMoving()
                if mRng(1, 2) == 1 then
                    self:SCHEDULE_COVER_ORIGIN(moveTy, function(x)
                        self:VJ_Schedule_TaskStuff(x)
                    end)
                else
                    self:SCHEDULE_COVER_ENEMY(moveTy, function(x)
                        self:VJ_Schedule_TaskStuff(x)
                    end)
                end 
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
            local trEnemyTarget = util.TraceLine({
                start = enemy:GetPos(),
                endpos = enemy:GetPos() + posTrVal,
                filter = enemy
            })

            local trSelfPosition = util.TraceLine({
                start = self:GetPos(),
                endpos = self:GetPos() + posTrVal,
                filter = self
            })

            if trSelfPosition.Hit or (trEnemyTarget.Hit and IsValid(enemy)) then
                return (landingPos - grenade:GetPos()) + (up * mRand(100, 225) + forward * mRand(350, 550) + right * mRand(-35, 45))
            end

            local distanceToTarget = grenade:GetPos():Distance(landingPos)
            local scaleFactor = math_Clamp(distanceToTarget / 2925, 1, 3)
            local upDir, forwardDir, leftOrRightDir

            if self.CurrentGrenadeThrow_IsCloseRange then
                upDir = up * mRand(50, 150) * scaleFactor
                forwardDir = forward * mRand(100, 150) * scaleFactor
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
    if (disp == D_LI or disp == D_NU) and self.CanReactToUse and curTime > self.LastReactToUseTime and not self.Alerted and not self:IsBusy() and self:Visible(activator) then

        if mRng(1, self.ReactToPlyIntChance) == 1 then
            local chosenFlinch = table.Random(self.ReactToPlyUseAnim)
            timer.Simple(self.ReactToUseDelay, function()
                if IsValid(self) then
                    self:RemoveAllGestures()
                    self:PlayAnim("vjges_" .. chosenFlinch, false)
                end
            end)
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
    local frontPos = self:GetPos() + self:GetForward() * mRand(1, 5) +self:GetUp() * mRand(1, 5) +self:GetRight() * mRand(-5, 5)

    grenade:SetPos(frontPos)
    grenade:Spawn()
    if grenPin then 
        VJ.EmitSound(grenade, grenPin, 70, rngSnd)
    end 
    self.LastGrenadeSpawnTime = cT + 100
    local flinchAnim = table.Random(self.ReactToPlyUseAnim)
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
    if self.VJ_IsBeingControlled or not IsValid(self) then return end 
    if not self.Flee_AfterMelee then return end 
    if self:IsBusy("Activities") then return end 
    if self.IsGuard then return end 
    if self.MovementType == VJ_MOVETYPE_STATIONARY then return end 

    local ene = self:GetEnemy()
    local curT = CurTime()
    local chance = self.Flee_AfterMeleeChance or 3
    local rngDelay = mRand(0.1, 0.5)
    local tAdd = mRand(5, 15)

    timer.Simple(0, function()
        if IsValid(self) then
            if IsValid(ene) and self:Visible(ene) and curT > (self.Flee_AfterMeleeT or 0)  and mRng(1, chance) == 1 and curT > self.TakingCoverT and self:GetWeaponState() ~= VJ.WEP_STATE_RELOADING then
                self:ClearSchedule()
                self:StopMoving()
                self:StopAttacks(true)
                print("Fleeing after melee attack")
                
                timer.Simple(rngDelay, function()   
                    if IsValid(self) then
                        self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH", function(x)
                            if mRng(1, 2) == 1 then 
                                x:EngTask("TASK_FACE_ENEMY", 0)
                                x.CanShootWhenMoving = true
                                x.TurnData = {Type = VJ.FACE_ENEMY}
                            else
                                x.CanShootWhenMoving = false  
                                x.TurnData = {Type = VJ.FACE_ENEMY, Target = nil}
                            end 
                        end)
                    end
                end)
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

function ENT:OnMeleeAttackExecute(status, ent, isProp)
    if not IsValid(ent) then return end

    local ply = ent:IsPlayer()
    local fireDur = mRand(1, 15)
    local rngSnd = mRng(75, 105)
    if status == "Miss" or status == "PreDamage" then 
        if mRng(1, self.RetreatAfterMeleeAttackChance) == 1 and not ent.isProp and ent:Alive() and not self:IsMoving() then
            self:RetreatAfterMeleeAttack()
        end
    end 

    if status == "PreDamage"  then 
        if ent:Alive() and IsValid(ent) then 
            if self.HasMeleeDmgBuffToAliens then
                if ent.IsVJBaseSNPC and ent.IsVJBaseSNPC_Creature then
                    local buff = mRng(2, 3)
                    if self.IsHeavilyArmored then
                        local armorBuff = mRng(3, 5)
                        self.MeleeAttackDamage = self.MeleeAttackDamage * buff * armorBuff
                        print("Stacked creature + heavy armor buff:", self.MeleeAttackDamage)
                    else
                        self.MeleeAttackDamage = self.MeleeAttackDamage * buff
                        print("Melee creature dmg buff:", self.MeleeAttackDamage)
                    end
                elseif self.IsHeavilyArmored then
                    local armorBuff = mRng(3, 5)
                    self.MeleeAttackDamage = self.MeleeAttackDamage * armorBuff
                    print("Heavy armored melee buff:", self.MeleeAttackDamage)
                else
                    print("Regular melee dmg:", self.MeleeAttackDamage)
                end
            end
        end 

        if self:IsOnFire() and not ent:IsOnFire() and (not ent.Immune_Fire or not ent.AllowIgnition) then
            ent:Ignite(fireDur)
        end

        if IsValid(ent) and ply and ent:Alive() then
            local wep = ent:GetActiveWeapon()

            if self.CanKnckPlyWepOutHand and IsValid(wep) then
                if mRng(1, self.PlyWeaponKnockOutChance) == 1 then
                    ent:DropWeapon(wep)
                elseif mRng(1, self.FrcPlyHolsterWeaponChance) == 1 then
                    ent:SetActiveWeapon(NULL)
                end
            end

            if self.CanBreakPlyAmror then
                local breakChance = tonumber(self.BreakPlyArmorChance) or 6 
            
                if self.IsHeavilyArmored then 
                    breakChance = math.max(1, breakChance / 3) 
                end 
            
                if mRng(1, breakChance) == 1 then
                    local currentArmor = ent:Armor() or 0
                    local maxArmor = ent:GetMaxArmor() or 100
                    if currentArmor > (maxArmor * (self.BreakPlyArmorThresh / 100)) then
                        local armBrkSnd = VJ.PICK(self.SoundTbl_ExtraArmorImpacts)
                        ent:SetArmor(0)
                        if armBrkSnd then 
                            VJ.EmitSound(ent, armBrkSnd, rngSnd, rngSnd)
                        end
                    end
                end
            end

            local pitch = mRng(-125, 125)
            local yaw = mRng(-125, 125)
            local roll = mRng(-125, 125)

            if mRng(1, 3) == 1 then
                local multiplier = mRng(3, 4)
                pitch = pitch * multiplier
                yaw = yaw * multiplier
                roll = roll * multiplier
            end

            local screenShakeT = mRand(0.55, 6.5)
            local screenShakeDist = mRng(200, 450)
            local screenShakeFreq = mRng(100, 250)
            local screenShakeAmp = mRng(10, 45)

            if mRng(1, 3) == 1 then
                local shakeMultiplier = mRng(3, 4)
                screenShakeT = screenShakeT * shakeMultiplier
                screenShakeDist = screenShakeDist * shakeMultiplier
                screenShakeFreq = screenShakeFreq * shakeMultiplier
                screenShakeAmp = screenShakeAmp * shakeMultiplier
            end

            ent:ViewPunch(Angle(pitch, yaw, roll))
            ent:ScreenFade(SCREENFADE.IN, Color(mRng(60, 130), 0, 0, 200), mRand(3, 5), mRand(1, 5))
            util.ScreenShake(ent:GetPos(), screenShakeAmp, screenShakeFreq, screenShakeT, screenShakeDist)
        end 
    end
end

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
        rngDmg = math.ceil(rngDmg * mRand(0.8, 1.25))
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
    local healAnims = table.Random(self.Extra_HealAnimms)
    if healAnims and healAnims ~= "" then 
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
    local busy = self:IsVJAnimationLockState() or self.Alerted or self:IsBusy()
    local healerResponse = table.Random({"vjges_" .. table.Random(self.HealerEntReact_Anim)})
    local delay = mRand(0.1, 1.5)
    if self.PlyAnimInRepOHeal then 
        if busy or self.VJ_IsBeingControlled then return false end 
        self:StopMoving()
        self:RemoveAllGestures()

        timer.Simple(delay, function()
            if not (IsValid(self) and IsValid(data)) then return end
            if mRng(1, 2) == 1 and data.IsVJBaseSNPC_Human and not data:IsBusy() then
                if istable(data.HealedEntReact_Anim) then
                    local validAnims = {}
                    for _, animName in ipairs(data.HealedEntReact_Anim) do
                        local gestureName = "vjges_" .. animName
                        local seqID = data:LookupSequence(gestureName)
                        if seqID and seqID ~= -1 then
                            table.insert(validAnims, gestureName)
                        end
                    end
                    if #validAnims > 0 then
                        local chosen = table.Random(validAnims)
                        data:PlayAnim(chosen, false)
                        print("HealedEntAnim: " .. chosen)
                    end
                end
            end
            if not healerResponse or healerResponse == "" then return end 
            if mRng(1, 2) == 1 and not busy and healerResponse then
                self:PlayAnim(healerResponse, false)
                print("Healer resp anim: " .. healerResponse)
            end
        end)
    end 
end 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Water_ExtinguishFire = true 
function ENT:WaterExtinguishSelFire()
    if not self.Water_ExtinguishFire then return end 
    if not IsValid(self) then return end 
    local extinguishSnd = table.Random(self.WaterSplashSounds)
    local rngSnd = mRng(80, 105)
    if self:WaterLevel() > 0 and self:IsOnFire() and (self:Alive() or not self.Dead) then
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
    if not IsValid(self) or self.VJ_IsBeingControlled then return end
    if not self.CanPlayBurningAnimations then return end 
    if self.React_ToOnFireConv then
        local convVar = GetConVar(self.React_ToOnFireConv)
        if convVar and convVar:GetInt() == 0 then
            return 
        end
    end

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
    if not IsValid(self) then return end 
    if not self.CanPlayBurningAnimations then return end 
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
function ENT:OnDeath(dmginfo, hitgroup, status)
    if not IsValid(self) then return false end 

    if self.HasDeathSounds and self.Headshot_Death and self.HeadShot_Death_StopDthSnd then 
        VJ.STOPSOUND(self.CurrentDeathSound)
    end 

    local rngSnd = mRng(75, 105)
    local isFireDeath = self:IsOnFire() and (dmginfo:IsDamageType(DMG_BURN) or dmginfo:IsDamageType(DMG_SLOWBURN)) and not self.Immune_Fire
    local isHeadshot = self.Headshot_Death or hitgroup == HITGROUP_HEAD
    local deflateChance = self.SevaSuitDeflateChance or 2 
    local lastRadTrans = self.Radio_DeathSoundChance or 4 
    local atId = 0

    if status == "Init" then 
        local wep = self:GetActiveWeapon()
        if IsValid(wep) then 
            local conv = GetConVar("vj_stalker_drop_seq_wep"):GetInt()
            local wepClass = wep:GetClass()
            local dropWeaponClass
            local dropChance = tonumber(self.Weapon_DropSecondary_Chance) or 3 
            if wepClass == self.HumanPrimaryWeapon and mRng(1, dropChance) == 1 and self.Weapon_DropSecondary and conv == 1 then
                dropWeaponClass = self.HumanSecondaryWeapon
            elseif wepClass == self.HumanSecondaryWeapon then
                dropWeaponClass = self.HumanPrimaryWeapon
            else
                return
            end

            local dropEnt = ents.Create(dropWeaponClass)
            local rngVel = mRand(-25,25)
            if IsValid(dropEnt) then
                dropEnt:SetPos(self:GetPos() + Vector(mRand(-10, 10), mRand(-10, 10), mRand(25, 40)))
                dropEnt:SetAngles(self:GetAngles())
                dropEnt:Spawn()
                dropEnt:SetOwner(NULL)
                local phys = dropEnt:GetPhysicsObject()
                if IsValid(phys) then
                    phys:SetVelocity(self:GetForward() * rngVel + self:GetRight() * rngVel + Vector(0, 0, rngVel))
                end
            end
        end 

        if self.Radio_RandomDeathSound and mRng(1, lastRadTrans) == 1 then 
            local radDeath = table.Random({"general_sds/radio_snds/radio_random" .. mRng(1, 15) .. ".wav"})
            if radDeath then 
                VJ.EmitSound(self, radDeath, 65, rngSnd)
            end 
        end 

        if self.IsScientific and mRng(1, deflateChance) == 1 then 
            local deflateSound = VJ.PICK({"general_sds/deflate_suit_sound/ceda_suit_deflate_01.wav","general_sds/deflate_suit_sound/ceda_suit_deflate_02.wav","general_sds/deflate_suit_sound/ceda_suit_deflate_03.wav"})
            if deflateSound then 
                VJ.EmitSound(self, deflateSound, 70, rngSnd)
            end 
        end 

        if isFireDeath and self.HasBurnToDeathSounds and not self.HasPlayedBurnDeathSound and mRng(1, self.BurnToDeathSoundChance) == 1 then
            self.HasPlayedBurnDeathSound = true
            VJ.STOPSOUND(self.CurrentDeathSound)
            self.BurnToDeathSoundObj = VJ.CreateSound(self, self.BurnToDeathSound_Tbl, rngSnd, self:GetSoundPitch(self.DeathSoundPitch))
            if self.BurnToDeathSoundObj then
                self.BurnToDeathSoundObj:Play()
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

function ENT:DeahtAnimation_Handle(dmginfo, hitgroup)

    local deathConv = GetConVar("vj_stalker_death_anim"):GetInt()
    local headshotConv = GetConVar("vj_stalker_disable_headshot_death_anim"):GetInt()

    local rngSnd = mRng(75, 105)
    local isFireDeath = self:IsOnFire() and (dmginfo:IsDamageType(DMG_BURN) or dmginfo:IsDamageType(DMG_SLOWBURN)) and not self.Immune_Fire
    local pcfxPoint = PATTACH_POINT_FOLLOW

    local RUNNING = {"vjseq_deathrunning_01","vjseq_deathrunning_03","vjseq_deathrunning_04","vjseq_deathrunning_05","vjseq_deathrunning_06","vjseq_deathrunning_07","vjseq_deathrunning_08","vjseq_deathrunning_09","vjseq_deathrunning_10","vjseq_deathrunning_11a","vjseq_deathrunning_11b","vjseq_deathrunning_11c","vjseq_deathrunning_11d","vjseq_deathrunning_11e","vjseq_deathrunning_11f","vjseq_deathrunning_11g"}
    local HEADSHOT = {"vjseq_DIE_Headshot_FBack_01","vjseq_DIE_Headshot_FBack_02","vjseq_DIE_Headshot_FBack_03","vjseq_DIE_Headshot_FFront_01","vjseq_DIE_Headshot_FFront_02","vjseq_DIE_Headshot_FFront_03","vjseq_DIE_Headshot_FFront_04","vjseq_DIE_Headshot_FFront_05"}
    local EXPLOSION = {"vjseq_death_explosion_1","vjseq_death_explosion_2","vjseq_death_explosion_3","vjseq_death_explosion_4","vjseq_death_explosion_5","vjseq_death_explosion_6"}
    local SHOCK = {"vjseq_electro_15","vjseq_electrocuted_1","vjseq_electrocuted_2","vjseq_electrocuted_3","vjseq_electrocuted_4","vjseq_electrocuted_5"}
    local FIRE = {"vjseq_fire_03","vjseq_fire_04","vjseq_fire_01","vjseq_fire_02","vjseq_pd2_death_fire_1_new","vjseq_pd2_death_fire_2_new","vjseq_pd2_death_fire_3_new"}
    local BUCK_BACK = {"vjseq_die_shotgun_fback_01","vjseq_die_shotgun_fback_02"}
    local BUCK_FRONT = {"vjseq_DIE_Shotgun_FFront_01","vjseq_DIE_Shotgun_FFront_02","vjseq_DIE_Shotgun_FFront_03","vjseq_DIE_Shotgun_FFront_04","vjseq_DIE_Shotgun_FFront_05","vjseq_DIE_Shotgun_FFront_06","vjseq_DIE_Shotgun_FFront_07","vjseq_DIE_Shotgun_FFront_08","vjseq_DIE_Shotgun_FFront_09"}
    local BUCK_LEFT = {"vjseq_die_shotgun_fleft_01","vjseq_die_shotgun_fleft_02","vjseq_die_shotgun_fleft_03"}
    local BUCK_RIGHT = {"vjseq_die_shotgun_fright_01"}
    local SIMPLE = {"vjseq_die_simple_01","vjseq_die_simple_02","vjseq_die_simple_03","vjseq_die_simple_04","vjseq_die_simple_05","vjseq_die_simple_06","vjseq_die_simple_07","vjseq_die_simple_08","vjseq_die_simple_09","vjseq_die_simple_10","vjseq_die_simple_11","vjseq_die_simple_12","vjseq_die_simple_13","vjseq_die_simple_14","vjseq_die_simple_15","vjseq_die_simple_16","vjseq_die_simple_17","vjseq_die_simple_18","vjseq_die_simple_19","vjseq_die_simple_20","vjseq_die_simple_21","vjseq_die_simple_22"}

    if deathConv ~= 1 or not self:IsOnGround() or not self.HasDeathAnimation or (not isFireDeath and (self:IsVJAnimationLockState() or self:IsBusy())) then
        return
    end

    if self:IsMoving() and self:GetActivity() == ACT_RUN and self:IsOnGround() then
        self.AnimTbl_Death = RUNNING
        self.DeathAnimationChance = 2
        print("Running (Forward)")
        return

    elseif (self.CanPlayHeadshotDeahtAnim or isHeadshot) and headshotConv ~= 1 and not self:GetActivity() == ACT_COVER then
        self.AnimTbl_Death = HEADSHOT
        print("HEADSHOT")
        return

    elseif dmginfo:IsExplosionDamage() then
        self.AnimTbl_Death = EXPLOSION
        self.DeathAnimationChance = 2
        print("Explosion")
        return

    elseif dmginfo:IsDamageType(DMG_SHOCK) then
        self.AnimTbl_Death = SHOCK
        self.DeathAnimationChance = 2

        local firePartEf = "smoke_gib_01"
        local elePartEf = "electrical_arc_01_parent"
        ParticleEffectAttach(firePartEf, pcfxPoint, self, atId)
        ParticleEffectAttach(firePartEf, pcfxPoint, self, atId)
        ParticleEffectAttach(elePartEf, pcfxPoint, self, atId)
        ParticleEffectAttach(elePartEf, pcfxPoint, self, atId)
        print("Shocked")
        return

    elseif isFireDeath then
        print("Fire")
        self.AnimTbl_Death = FIRE

        local fireIgnite = table.Random({"ambient/fire/gascan_ignite1.wav","ambient/fire/ignite.wav"})
        local fireChance = tonumber(self.FireDeathFxChance) or 2

        if self.SpecialFireDeathFx and mRng(1, fireChance) == 1 and not isHeadshot then

            if fireIgnite then
                VJ.EmitSound(self, fireIgnite, rngSnd, rngSnd)
            end

            local fireEffects = {"embers_small_01","env_fire_small_base","fire_medium_heatwave","smoke_medium_01","smoke_medium_02"}
            for _, effect in ipairs(fireEffects) do ParticleEffectAttach(effect, pcfxPoint, self, atId) end

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
            self.FireLight:SetKeyValue("brightness", rngBright)
            self.FireLight:SetKeyValue("distance", rngDist)
            self.FireLight:SetLocalPos(self:GetPos())
            self.FireLight:SetLocalAngles(self:GetAngles())
            self.FireLight:Fire("Color", red .. " " .. green .. " 0")
            self.FireLight:SetParent(self)
            self.FireLight:Spawn()
            self.FireLight:Activate()
            local attachName = GetValAtt(self)
            if attachName then self.FireLight:Fire("SetParentAttachment", attachName) end
            self.FireLight:Fire("TurnOn", "", 0)
            self:DeleteOnRemove(self.FireLight)
        end
        return

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
                self.AnimTbl_Death = BUCK_BACK
                self.DeathAnimationChance = 2
                print("Shotgun Death from Back")
                return

            elseif dotForward < -0.5 then
                self.AnimTbl_Death = BUCK_FRONT
                self.DeathAnimationChance = 2
                print("Shotgun Death from Front")
                return

            elseif dotRight > 0.5 then
                self.AnimTbl_Death = BUCK_LEFT
                self.DeathAnimationChance = 2
                print("Shotgun Death from Left")
                return

            elseif dotRight < -0.5 then
                self.AnimTbl_Death = BUCK_RIGHT
                self.DeathAnimationChance = 2
                print("Shotgun Death from Right")
                return
            end
        end
    end
    self.DeathAnimationChance = 5
    self.AnimTbl_Death = SIMPLE
    return
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ShovedBack(dmginfo)
    if not IsValid(self) then return end
    local cT = CurTime()
    local conv = GetConVar("vj_stalker_shovedback"):GetInt() 
    if not conv or conv~= 1 then return end
    if self.VJ_IsBeingControlled then return end
    if self.StaggerOverride then return end
    local isDead = self:Health() <= 0 or self.Dead or not self:Alive()
    if isDead then return end

    local getAct = self:GetActivity()
    local badAacts = (getAct == ACT_FLINCH or getAct == ACT_SMALL_FLINCH or getAct == ACT_BIG_FLINCH or getAct == ACT_JUMP or getAct == ACT_LAND or getAct == ACT_GLIDE)
    local busy = self:IsBusy("Activities") or badAacts or self:IsVJAnimationLockState() or self:GetWeaponState() == VJ.WEP_STATE_RELOADING

    if not self.Shoved_Back or self.Shoved_Back_Now or self:IsOnFire() or busy then return false end
    if not self:IsOnGround() or isDead or self.PlayingWallHitAnim then return false end

    local nextT = tonumber(self.Shoved_Back_NextT) or 0
    if cT < nextT then return false end

    local damageThreshold = mRng(5, 35)
    local damageForceThreshold = mRng(400, 1200)

    local dmgType = dmginfo:GetDamageType()
    local isExplosion = dmginfo:IsExplosionDamage()
    local isCommonDmg = dmginfo:IsBulletDamage() or dmgType == DMG_SLASH or dmgType == DMG_CLUB or dmgType == DMG_BUCKSHOT or dmgType == DMG_BULLET
    local allowExplosive = self.Shoved_Explosive_Active and isExplosion
    local allowCommon = self.Shoved_Com_Active and isCommonDmg

    local adjustedChance = self.ShovedBackChance
    if self:Health() <= (self:GetMaxHealth() * 0.5) then
        adjustedChance = math.max(1, math.ceil(adjustedChance / 2))
    end

    if mRng(1, adjustedChance) ~= 1 then return false end

    local damageAmount = dmginfo:GetDamage()
    local damageForce = dmginfo:GetDamageForce():Length()

    if (damageAmount <= damageThreshold and damageForce <= damageForceThreshold) or not (allowExplosive or allowCommon) or self.Dead then return end

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

        local isNowDead = self:Health() <= 0 or self.Dead or not self:Alive()
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
    local conv = GetConVar("vj_stalker_shove_wall_collide")
    if not self.ShovedDir or conv:GetInt() ~= 1 then return end
    local isDead = self:Health() <= 0 or self.Dead or not self:Alive()
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
        local tr = util.TraceHull({
            start = startPos,
            endpos = startPos + traceDir * traceDist,
            mins = self:OBBMins(),
            maxs = self:OBBMaxs(),
            filter = self
        })

        if not tr.Hit then
            tr = util.TraceHull({
            start = startPos,
            endpos = startPos + traceDir * 6,
            mins = self:OBBMins(),
            maxs = self:OBBMaxs(),
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
    if not IsValid(self) or self.VJ_IsBeingControlled then return end
    if not self.React_FriFire then return end

    local cT = CurTime()
    if cT < (self.React_FrIFire_NextT or 0) then return end
    if self:IsBusy() then return end

    local ene = self:GetEnemy()
    if IsValid(ene) and self:Visible(ene) then return end
    if not IsValid(attacker) or not attacker:IsPlayer() then return end

    if self._ReactFrFirePending then return end
    self._ReactFrFirePending = true
    local chance = tonumber(self.React_FrIFire_Chance) or 5
    if mRng(1, chance) ~= 1 then
        self._ReactFrFirePending = false
        return
    end

    local annoyedAnim = table.Random(self.React_FrIFire_AnimTbl)
    if not annoyedAnim then
        self._ReactFrFirePending = false
        return
    end

    self:StopMoving()
    self:RemoveAllGestures()
    timer.Simple(mRand(0.15, 0.95), function()
        if IsValid(self) then
            self:PlayAnim("vjges_" .. annoyedAnim, false)
            self.React_FrIFire_NextT = CurTime() + mRand(2, 10)
        end
        if IsValid(self) then
            self._ReactFrFirePending = false
        end
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
    -- [Corpse wound graabbing] --
ENT.CorpseWndGrabbing = true 
ENT.CorpseWndGrab_MinT = 1
ENT.CorpseWndGrab_MaxT = 12 
ENT.CorpseWndGrabChance = 10
ENT.CorpseWndGrabFrc = 100
ENT.CorpseWndGrabDelay = 0.1

    -- [Ex corpse phys] -- 
ENT.Ex_Crp_Phys = true 
ENT.Ex_Crp_Phys_Trq = true 
ENT.Ex_Crp_Phys_Trq_Chance = 2 

    -- [Headshot corpse physics] --
ENT.HeadShot_PhysDownFrc = mRand(35, 85) 
ENT.HeadShot_PhysForwardFrc = mRand(-150, 150) 

    -- [Post mortem twitching] --
ENT.HasPostMortemTwitching = true 
ENT.CorpseTwitchChance = 10
ENT.CorpseTwitchReps = mRng(1, 15)
ENT.CorpseTwitchMinDelay = 0.1
ENT.CorpseTwitchMaxDelay = 1.5
ENT.CorpseTwitchForceMin = 150
ENT.CorpseTwitchForceMax = 600 
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
    if not IsValid(corpse) then return end
    local conv = GetConVar("vj_stalker_flatline"):GetInt()
    local chance = tonumber(self.Flatline_DeathChance) or 3 
    if self.Flatline_DeathSnd and mRng(1, chance) == 1 and conv == 1 then
        timer.Simple(mRand(0.01, 0.05), function()
            if IsValid(corpse) then
                local flatlineSnd = "general_sds/flatline/flatline" .. mRng(1, 8) .. ".wav"
                local snd = CreateSound(corpse, flatlineSnd)
                if snd then
                    snd:PlayEx(mRand(0.75, 0.9), mRng(75, 115)) 
                    corpse:CallOnRemove("StopFlatlineSnd", function()
                        if snd then snd:Stop() end
                    end)
                end
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
    if GetConVar("vj_stalker_ele_death_fx"):GetInt() ~= 1 then return false end 
    local sparkChance = self.Corpse_EleDeathEffects_Chance
    if self.Corpse_EleDeathEffects and mRng(1, sparkChance) == 1 then
        local duration = mRand(1, 15) or 10 
        local interval = mRand(0.05, 0.95) or 0.5
        local repetitions = duration / interval 
        local timerName = "ElectricityEffects_" .. corpse:EntIndex() .. "_" .. CurTime()

        timer.Create(timerName, interval, repetitions, function()
            if not IsValid(corpse) then timer.Remove(timerName) return end
            local DeathSparkeffect2 = EffectData()
            DeathSparkeffect2:SetOrigin(corpse:GetPos())
            DeathSparkeffect2:SetStart(corpse:GetPos())
            DeathSparkeffect2:SetMagnitude(mRand(50, 90)) 
            DeathSparkeffect2:SetEntity(corpse)

            local DeathSparkeffect1 = EffectData()
            DeathSparkeffect1:SetOrigin(corpse:GetPos())
            DeathSparkeffect1:SetStart(corpse:GetPos())
            DeathSparkeffect1:SetMagnitude(mRng(5, 15)) 
            DeathSparkeffect1:SetEntity(corpse)

            local DeathSparkeffect = ents.Create("spark_shower")
            DeathSparkeffect:SetAngles(Angle(0, mRng(-180, 180), 0))
            DeathSparkeffect:SetPos(corpse:GetPos())
            DeathSparkeffect:Spawn()
            DeathSparkeffect:Activate()

            local eleDeathFx = EffectData()
            eleDeathFx:SetOrigin(corpse:GetPos())
            eleDeathFx:SetStart(corpse:GetPos())
            eleDeathFx:SetEntity(corpse)
            util.Effect("cball_explode", eleDeathFx)
            util.Effect("ManhackSparks", eleDeathFx)
            
            util.Effect("teslaHitBoxes", DeathSparkeffect2)
            util.Effect("StunstickImpact", DeathSparkeffect1)
            corpse:EmitSound("ambient/energy/zap" .. mRng(1, 9) .. ".wav") 
        end)
    end
end

function ENT:ManipulateCorpseFingers(corpse)
    local manChance = self.ManipulateFingBoneChance or 4 
    if mRng(1, manChance) == 1 then return end
    if not (self.DeathFingerBoneManipuation and GetConVar("vj_stalker_death_finger_manip"):GetInt() == 1) then return end

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
    local twitchConv =  GetConVar("vj_stalker_body_twitching"):GetInt()
    if twitchConv ~= 1 then return end 

    local twChance      = tonumber(self.CorpseTwitchChance) or 5 
    local twitchReps    = tonumber(self.CorpseTwitchReps) or 3 
    local minDelay      = tonumber(self.CorpseTwitchMinDelay) or 0.2
    local maxDelay      = tonumber(self.CorpseTwitchMaxDelay) or 0.6
    local forceMin      = tonumber(self.CorpseTwitchForceMin) or 150
    local forceMax      = tonumber(self.CorpseTwitchForceMax) or 600
    local minLife       = tonumber(self.CorpseTwitchLifeMinT) or 1
    local maxLife       = tonumber(self.CorpseTwitchLifeMaxT) or 10
    local twitchType    = mRng(1, 2)
    local totalLife     = tonumber(mRand(minLife, maxLife)) 

    if self.HasPostMortemTwitching and mRng(1, twChance) == 1 then
        timer.Simple(totalLife, function()
            if not IsValid(corpse) then return end
            local function TwitchRep(count)
                if not IsValid(corpse) or not count or count <= 0 then return end
                local physCount = corpse:GetPhysicsObjectCount()
                if physCount <= 0 then return end

                if twitchType == 1 then
                    local phys = corpse:GetPhysicsObjectNum(mRng(0, physCount - 1))
                    if IsValid(phys) then
                        local twitchForce = VectorRand() * mRand(forceMin, forceMax)
                        phys:ApplyForceOffset(twitchForce, corpse:GetPos())
                    end

                elseif twitchType == 2 then
                    local limited = mRng(1, 4) == 1
                    local boneCount

                    if limited then
                        boneCount = math.Clamp(math.floor(physCount / 5), 1, physCount)
                    else
                        boneCount = mRng(2, physCount)
                    end
                    local used = {}

                    for i = 1, boneCount do
                        local id = mRng(0, physCount - 1)
                        if not used[id] then
                            used[id] = true
                            local phys = corpse:GetPhysicsObjectNum(id)
                            if IsValid(phys) then
                                local twitchForce = VectorRand() * mRand(forceMin * mRand(0.2, 0.7), forceMax)
                                local offset = corpse:LocalToWorld(corpse:OBBCenter() + VectorRand() * mRand(5, 20))
                                phys:ApplyForceOffset(twitchForce, offset)
                            end
                        end
                    end
                end
                if self.RANDOMS_DEBUG then 
                    print("(Corpse Twitching) Twitch type == : " .. tonumber(twitchType))
                end 
                timer.Simple(mRand(minDelay, maxDelay), function()
                    TwitchRep(count - 1)
                end)
            end
            TwitchRep(twitchReps)
        end)
    end
end 
//TODO 
-- MAYBE ADD DIFFERENT STAT SETS BASED ON CERTAIN DMG? SHOCK OR FIRE CAUSE MORE ERATIC WRITHING?
function ENT:ApplyCorpseRoll(corpse, duration, interval)
    if not IsValid(corpse) or self.Headshot_Death then return end
    local isHeadshot = self.Headshot_Death or hitgroup == HITGROUP_HEAD
    local conv = GetConVar("vj_stalker_body_writhe"):GetInt()
    local chance = tonumber(self.DC_Writhe_Chance) or 10 
    local minT = tonumber(self.DC_Writhe_MinT) or 5 
    local maxT = tonumber(self.DC_Writhe_MaxT) or 15 
    local decThresh = tonumber(self.DC_Writh_Decay_Thresh) or 0.20
    local trDist = tonumber(self.DC_Writhe_TraceDist) or 250 
    local useAllBones = self.DC_Writhe_UseAllBones or false 

    if isHeadshot then return false end 
    if not conv or conv ~= 1 then return end
    if self.DC_Writhe and not self.DC_Writhing then  
        if mRng(1, chance) == 1 then 
            self.DC_Writhing = true 
            duration = duration or mRand(minT, maxT)
            interval = interval or 0.01
            local repeats = math.floor(duration / interval)
            local timerName = "CorpseRoll_" .. corpse:EntIndex()
            local i = 0

            local spineBones = {
                "ValveBiped.Bip01_Spine","ValveBiped.Bip01_Spine1",
                "ValveBiped.Bip01_Spine2","ValveBiped.Bip01_Spine4",
                "ValveBiped.Bip01_Pelvis","ValveBiped.Bip01_L_Calf",
                "ValveBiped.Bip01_R_Calf",
            }

            local rollDirection = 1 -- 1 = right, -1 = left

            local function CheckObstructions()
                if not IsValid(corpse) then return false,false end
                local startPos = corpse:GetPos() + Vector(0,0,10)
                local rightDir = corpse:GetRight()
                local leftDir = -rightDir
                local traceData = {
                    start = startPos,
                    endpos = startPos + rightDir * trDist,
                    filter = corpse,
                }
                local trRight = util.TraceHull(traceData)
                traceData.endpos = startPos + leftDir * trDist
                local trLeft = util.TraceHull(traceData)
                return trLeft.Hit, trRight.Hit
            end

            timer.Create(timerName, interval, repeats, function()
                if not IsValid(corpse) then 
                    self.DC_Writhing = false
                    timer.Remove(timerName) 
                    return 
                end

                i = i + 1
                local leftBlocked, rightBlocked = CheckObstructions()
                if leftBlocked and rightBlocked then
                    self.DC_Writhing = false
                    timer.Remove(timerName)
                    return
                elseif rollDirection == -1 and leftBlocked then
                    rollDirection = 1
                elseif rollDirection == 1 and rightBlocked then
                    rollDirection = -1
                elseif mRng() < 0.02 then
                    rollDirection = rollDirection * -1
                end

                local decayFactor = 1
                if self.DC_Writh_Decay then
                    local progress = i / repeats 
                    if progress >= (1 - decThresh) then
                        local decayProgress = (progress - (1 - decThresh)) / decThresh
                        decayFactor = 1 - math_Clamp(decayProgress, 0, 1)
                    end
                end

                local rollForce = corpse:GetRight() * mRand(100, 2255) * rollDirection * decayFactor
                local forwardForce = corpse:GetForward() * mRand(5, 55) * rollDirection * decayFactor
                local liftForce = Vector(0, 0, mRand(5, 10)) * rollDirection * decayFactor
                local angVel = corpse:GetForward() * mRand(250, 425) * rollDirection * decayFactor

                if useAllBones then
                    for boneID = 0, (corpse:GetBoneCount() - 1) do
                        local physID = corpse:TranslateBoneToPhysBone(boneID)
                        if physID and physID >= 0 then
                            local phys = corpse:GetPhysicsObjectNum(physID)
                            if IsValid(phys) then
                                local angDiv = mRng(3, 5)
                                local torqueDiv = mRng(3, 5)
                                phys:AddAngleVelocity(Vector(math.floor(angVel.x / angDiv),math.floor(angVel.y / angDiv),math.floor(angVel.z / angDiv)))
                                phys:ApplyTorqueCenter((rollForce * mRand(0.85, 1.25)) / torqueDiv)
                                if self.DC_Writhe_AFC then
                                    phys:ApplyForceCenter(Vector(math.ceil((rollForce.x + forwardForce.x)),math.ceil((rollForce.y + forwardForce.y)),math.ceil((rollForce.z + forwardForce.z))))
                                end
                            end
                        end
                    end
                else -- Default
                    for _, boneName in ipairs(spineBones) do
                        local boneID = corpse:LookupBone(boneName)
                        if boneID then
                            local physID = corpse:TranslateBoneToPhysBone(boneID)
                            local phys = corpse:GetPhysicsObjectNum(physID)
                            if IsValid(phys) then
                                local angDiv = mRng(1, 3) 
                                phys:AddAngleVelocity(Vector(math.ceil(angVel.x / angDiv),math.ceil(angVel.y / angDiv),math.ceil(angVel.z / angDiv)))
                                phys:ApplyTorqueCenter(rollForce * mRand(0.85, 1.25))
                                if self.DC_Writhe_AFC then
                                    phys:ApplyForceCenter(Vector(math.floor((rollForce.x + forwardForce.x)),math.floor((rollForce.y + forwardForce.y)),math.floor((rollForce.z + forwardForce.z))))
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
    local eyePosConv = GetConVar("vj_stalker_corpse_rng_eyepos"):GetInt()
    if eyePosConv ~= 1 then return end 
    if not IsValid(body) or not self.Corpse_RngEyePos then return end
    local chance = tonumber(self.Corpse_RngEyePos_Chance) or 3
    if mRng(1, chance) ~= 1 then return end
    local side = mRand(-0.65, 0.65)
    local upDown = mRand(-1.2, 1.2) 
    local dist = mRand(12, 28)
    local offset = Vector(side * dist,mRand(-0.5, 0.5) * dist,upDown * dist)
    body:SetEyeTarget(body:GetPos() + offset)
end

function ENT:RngDeathEyelids(body)
    local eyeLidConv = GetConVar("vj_stalker_corpse_rng_eyelids"):GetInt()
    if eyeLidConv ~= 1 then return end 
    if not IsValid(body) or not self.Corpse_RngEyeLids then return end
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
    local affectCount = math.max(1, math.floor(flexCount * mRand(0.15, 0.35)))
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
    local conv = GetConVar("vj_stalker_death_wound_grabbing"):GetInt()
    if conv ~= 1 then return end 
    if not IsValid(corpse) or self.Headshot_Death then return end 
    if not self.CorpseWndGrabbing then return end 

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
        local repeats = math.floor(totalDuration / interval)

        local forceBase = self.CorpseWndGrabFrc or 120
        local smoothedTarget = corpse:GetBonePosition(targetBone)

        timer.Create(timerName, interval, repeats, function()
            if not IsValid(corpse) then timer.Remove(timerName) return end

            local rawTarget =
                corpse:GetBonePosition(targetBone) +
                grabOffset +
                Vector(mRand(-1.5, 1.5), mRand(-1.5, 1.5), mRand(0, 2))

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

function ENT:Corpse_ExtraPhysics(corpse)
    if not IsValid(corpse) then return end 
    local appliedCustomPhysics = false
    if self.Headshot_Death and self.ApplyHeadshotDeathPhys and not self.IsCurrentlyIncapacitated then
        local downForce = -self.HeadShot_PhysDownFrc or 200 
        local rngForBackForce = self.HeadShot_PhysForwardFrc or mRand(-200, 200) 
        local pullForce = VectorRand() * rngForBackForce + Vector(0, 0, mRand(-300, -650))

        local rngDir = VectorRand():GetNormalized()
        local rngSpeed = Vector(0, 0, mRand(255, 550))
        local rngAngVel = rngDir * rngSpeed

        local defLinDamp = mRand(0.05, 0.05)
        local defAngDamp = defLinDamp
        
        for i = 0, corpse:GetPhysicsObjectCount() - 1 do
            local phys = corpse:GetPhysicsObjectNum(i)
            local rngFrce = mRng(3, 6) or 5
            local mass = 200
            if IsValid(phys) then
                phys:ApplyForceCenter(pullForce)
                phys:SetMass(math.min(phys:GetMass() * 2, phys:GetMass() + mass))
                phys:SetDamping(defLinDamp, defAngDamp)
                phys:AddAngleVelocity(rngAngVel)
            end
        end
        print("headshot phys applied")
        appliedCustomPhysics = true
    end

    local exPhysConv = GetConVar("vj_stalker_death_ex_crpse_phys"):GetInt()
    if not appliedCustomPhysics and exPhysConv == 1 and self:IsOnGround() then
        if self.Ex_Crp_Phys and not self.IsCurrentlyIncapacitated then

            for i = 0, corpse:GetPhysicsObjectCount() - 1 do
                local phys = corpse:GetPhysicsObjectNum(i)
                local addMass = mRand(100, 200)
                if mRng(1, 2) == 1 and addMass then 
                    addMass = math.ceil(addMass * 2 / mRng(1, 3))  
                end 
                local dampVal 
                local choices = mRng(1, 3)
                if choices == 1 then 
                    dampVal = mRand(0.01, 0.1) -- Heavy 
                elseif choices == 2 then 
                    dampVal = 0.05
                else 
                    dampVal = mRand(0.25, 0.55) -- Lighter 
                end 

                local hsLinDamp = dampVal
                local hsAngDamp = hsLinDamp
                local vR = VectorRand()
                if IsValid(phys) then
                    phys:SetDamping(hsLinDamp, hsAngDamp)
                    phys:SetMass(math.min(phys:GetMass() * 2, phys:GetMass() + addMass))

                    local vel = vR * math.ceil(mRand(200, 600) * mRng(0.5, 1.25))
                    phys:ApplyForceCenter(vel)

                    local rngVelEnhance = mRand(0.5, 2)
                    local rngAng =  vR * math.random(100, 800)
                    local rngTrq = vR * mRand(100, 250)
                    
                    phys:AddAngleVelocity(rngAng * rngVelEnhance)
                    local chance = tonumber(self.Ex_Crp_Phys_Trq_Chance) or 2 
                    if self.Ex_Crp_Phys_Trq and mRng(1, chance) == 1 then 
                        local final = rngTrq * mRand(0.5, 1.2)
                        phys:ApplyTorqueCenter(final) 
                    end 
                end
            end 
        end
    end
end 
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpse)
    if not IsValid(corpse) then return end
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
    self:Corpse_ExtraPhysics(corpse)
    RagdollBloodEffects(self, corpse)
end
---------------------------------------------------------------------------------------------------------------------------------------------

//todo, more brain gib optimizations
function ENT:HandleHeadshot(dmginfo, hitgroup)
    local killConv = GetConVar("vj_stalker_headshot_kill_chance"):GetInt()
    self.HeadshotInstaKillChance = killConv

    local dT = dmginfo:GetDamageType()
    local isHeadshot = false 
    local minDmgHd = mRand(5, 10)
    local instaKillChance = tonumber(self.HeadshotInstaKillChance) or 2 
    local headHitGroup = HITGROUP_HEAD
    local bulDmg = (dmginfo:IsBulletDamage() or dT == DMG_BULLET or dT == DMG_AIRBOAT or dT == DMG_BUCKSHOT or dT == DMG_SNIPER)
    local rngSnd = mRng(75, 105)

    local stopDmgConv     = GetConVar("vj_stalker_helm_prev_dmg"):GetInt()
    local armoredHelmConv = GetConVar("vj_stalker_armored_helmet"):GetInt()
    local helmBreakConv   = GetConVar("vj_stalker_breakable_helmet"):GetInt()
    local instKillConv    = GetConVar("vj_stalker_headshot_insa_kill"):GetInt()
    local mindDmgConv     = GetConVar("vj_stalker_headshot_min_dmg_check"):GetInt()
    local manBoneLook     = tostring(self.Headshot_SearchBone)
    local imnBullet       = self.Immune_Bullet
    if hitgroup == headHitGroup and bulDmg and not imnBullet then
        isHeadshot = true
    else
        if manBoneLook then 
            local headBone = self:LookupBone(manBoneLook)
            if headBone and bulDmg and not imnBullet then
                local hitPos = dmginfo:GetDamagePosition()
                local headBonePos, _ = self:GetBonePosition(headBone)
                if headBonePos /*and headBonePos > 0*/ and hitPos:Distance(headBonePos) <= mRand(10, 13) then
                    isHeadshot = true
                end
            end
        end
    end

    local curT = CurTime()
    local flinchGes = self.Headshot_FlinchChance or 2
    if self.Headshot_ImpactFlinching and curT >= (self.Headshot_NextFlinchT or 0) and mRng(1, flinchGes) == 1 then
        if self.Headshot_ImpFlinchAnim and self.Headshot_ImpFlinchAnim ~= false then
            if istable(self.Headshot_ImpFlinchAnim) then
                selLandAnim = "vjges_" .. VJ.PICK(self.Headshot_ImpFlinchAnim)
            elseif isstring(self.Headshot_ImpFlinchAnim) then
                selLandAnim = "vjges_" .. self.Headshot_ImpFlinchAnim
            end
        end
        if selLandAnim then 
            self:PlayAnim(selLandAnim, false)
        end 
        self.Headshot_NextFlinchT = curT + mRand(0.5, 1.5)
    end

    local dmgAmount = dmginfo:GetDamage() or 0
    local setDmgCap = tonumber(self.ArmoredHelmet_MaxDamageCap) or 100
    local sndChance = tonumber(self.ArmoredHelmet_ImpSoundChance) or 3 
    local exImpSnd = self.SoundTbl_ExtraArmorImpacts
    local ignoreHelmet = dmgAmount > (setDmgCap) and self.ArmoredHelmet_DamageCap 
    if self.ArmoredHelmet and isHeadshot and armoredHelmConv == 1 and not ignoreHelmet then
        if self.ArmoredHelmet_ImpSound and mRng(1, sndChance) == 1 then 
            if exImpSnd then 
                self:PlaySoundSystem("Impact", exImpSnd)
            end 
        end 
        local sparkChance = self.ArmoredHelmet_SparkFxChance or 3
        if self.ArmoredHelmet_ImpSparkFx and mRng(1, sparkChance) == 1 then 
            local dmgPos = dmginfo:GetDamagePosition()
            local offset = Vector(mRand(-3, 3),mRand(-3, 3),mRand(-3, 3))
            local spawnPos = dmgPos + offset
            local effectData = EffectData()
            effectData:SetOrigin(spawnPos)
            effectData:SetMagnitude(mRand(0.25, 1.5))
            effectData:SetScale(mRand(0.25, 1.5))
            effectData:SetRadius(mRand(1, 3)) 
            util.Effect("StunstickImpact", effectData, true, true)
        end

        //self.ArmoredHelmet_BreakLimit = self.ArmoredHelmet_BreakLimit or mRng(3,5)
        //self.ArmoredHelmet_HitsTaken = (self.ArmoredHelmet_HitsTaken or 0) + 1
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
    
    if isHeadshot then
        print(instaKillChance) 
        self:HeadshotSoundEffect(isHeadshot)
    end

    if instKillConv == 1 and isHeadshot and not self.IsImmuneToHeadShots then
        local skipMinDmgCheck = mindDmgConv ~= 1
        local passedMinDmg = dmginfo:GetDamage() > minDmgHd

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
function ENT:HeadshotDeathEffects()
    local headConv = GetConVar("vj_stalker_headshot_fx")
    if headConv:GetInt() ~= 1 then return end 
    if not self.Headshot_Death then return end
    if not IsValid(self) then return end 

    local hsGore = VJ.PICK(self.GoreOrGibSounds)
    local effectChance = tonumber(self.Headshot_FxChance) or 2 
    local headAttachment = nil
    local headAttachmentName = nil
    local attTbl = self.HeadshotDeathAttTbl or {}
    for _, attName in ipairs(attTbl) do
        local attachmentIndex = self:LookupAttachment(attName)
        if attachmentIndex and attachmentIndex > 0 then
            headAttachment = self:GetAttachment(attachmentIndex)
            headAttachmentName = attName 
            break
        end
    end

    if not headAttachment or not headAttachmentName then
        return false
    end
    local goreSnd = GetConVar("vj_stalker_headshot_gore_sound"):GetInt() 
    local rngSnd = mRng(65, 95)
    if mRng(1, effectChance) == 1 then

        if goreSnd == 1 then 
            VJ.EmitSound(self, hsGore, 70, rngSnd)
        end 

        local gibPos = headAttachment.Pos + self:GetUp() * mRng(5, 25) + self:GetRight() * mRng(-15, 15)
        local bloodT = mRand(1, 3.25)
        local gibAmount = tonumber(self.Headshot_GibMaxAm) or 3 
        local bloodeffect = ents.Create("info_particle_system")
        bloodeffect:SetKeyValue("effect_name", "blood_advisor_puncture_withdraw")
        bloodeffect:SetPos(gibPos)
        bloodeffect:SetAngles(headAttachment.Ang)
        bloodeffect:SetParent(self) 
        bloodeffect:Fire("SetParentAttachment", headAttachmentName, 0)  
        bloodeffect:Spawn()
        bloodeffect:Activate()
        bloodeffect:Fire("Start", "", 0)
        bloodeffect:Fire("Kill", "", bloodT)

        local headAtt = self:LookupAttachment(headAttachmentName)
        if headAtt > 0 then
            ParticleEffectAttach("blood_impact_red_01", PATTACH_POINT_FOLLOW, self, headAtt)
        end
        if self.Headshot_HaveGibs then
            for _ = 1, mRng(1, gibAmount) do
                self:CreateGibEntity("obj_vj_gib", "UseHuman_Small", {Pos = gibPos})
            end
        end 
    end
    return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HeadshotSoundEffect(hasBeenHeadshot) 
    local hsSfxChance = self.HeadshotSoundSfxChance
    local conv = GetConVar("vj_stalker_headshot_sfx"):GetInt()
    local hS = table.Random(self.SoundTbl_OnHeadshot)
    local rngSnd = math.random(85, 105)
    if hS == false or hS == nil then return end
    if not IsValid(self) or conv ~= 1 then return end 
    if self.Headshot_Death_Sfx and hasBeenHeadshot and mRng(1, hsSfxChance) == 1 then
        self:EmitSound(hS, 65, rngSnd)
    end 
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Inst_AlrtTo_Dmg = true 
ENT.Inst_AlrtTo_Dmg_Dist = 3500
ENT.Inst_AlrtTo_Dmg_Chance = 3 
function ENT:ReactToDmg(dmginfo)

    local dgmAtt = dmginfo:GetAttacker()
    local ene = self:GetEnemy()
    local dist = tonumber(self.Inst_AlrtTo_Dmg_Dist) or 3500
    local chance = tonumber(self.Inst_AlrtTo_Dmg_Chance) or 3 

    if not IsValid(dgmAtt) or dgmAtt == self or self.Alerted or IsValid(ene) then return end  

    if dgmAtt:IsPlayer() and self.Inst_AlrtTo_Dmg then
        if GetConVar("ai_ignoreplayers"):GetBool() then return end
        
        local playerDisposition = self:Disposition(dgmAtt)
        if playerDisposition == D_LI or playerDisposition == D_NU then return end

        print("Damage attacker (player): " .. tostring(dgmAtt))

    elseif (dgmAtt:IsNPC() or dgmAtt:IsNextBot()) then
        local disposition = dgmAtt:Disposition(self)
        if disposition == D_LI or disposition == D_NU then return end  
    end

    timer.Simple(0.1, function()
        if not IsValid(self) or not IsValid(dgmAtt) or IsValid(ene) or not self:Alive() then return end

        local distSqr = self:GetPos():DistToSqr(dgmAtt:GetPos())
        if distSqr <= (dist * dist) and mRng(1, chance) == 1 then
            self:ForceSetEnemy(dgmAtt, false)
            self:UpdateEnemyMemory(dgmAtt, dgmAtt:GetPos())
        end
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
        if mRng(1, self.BlastType_FlinchChance or 3) ~= 1 then 
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
    if not self.ExFlinch_Feedback_Ges then return end 
    if not self:Alive() then return end 
    if not self:IsOnGround() then return end 
    if self:IsVJAnimationLockState() then return end 
    if not dmginfo then return end

    local gesFlinchConv = GetConVar("vj_stalker_ges_flinch"):GetInt()
    if gesFlinchConv ~= 1 then return end 

    local curT = CurTime()
    if curT <= (self.ExFlinch_Ges_NextT or 0) then return end 

    local flinChance = self.ExFlinch_Ges_Chance or 6
    local tDel = mRand(0.01, 0.25)

    local maxHp = self:GetMaxHealth()
    if self.ExFlinch_HpThresh and maxHp > 0 and (self:Health() / maxHp) <= self.ExFlinch_HpThresh_Min then
        flinChance = math.max(1, math.floor(flinChance / 2))
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
            if layer then
                self:SetLayerPlaybackRate(layer, mRand(0.65, 1))
            end
            self.ExFlinch_Ges_NextT = CurTime() + mRand(0.5, 2.5)
        end)
    end
end

function ENT:OnDamaged(dmginfo, hitgroup, status)   

    local dmgType = dmginfo:GetDamageType()
    local rngSnd = mRng(75, 105)
    local curT = CurTime()
    local coughConv = GetConVar("vj_stalker_coughing"):GetInt()
    local minDmgConv = GetConVar("vj_stalker_min_dmg_cap"):GetInt()
    local minDmgSfxConv = GetConVar("vj_stalker_min_dmg_cap_sfx"):GetInt()
    local cancelDial = GetConVar("vj_stalker_dmg_cancel_dial"):GetInt()

    if status == "PreDamage" then

        self:Extra_LayeredGesFlinching(dmginfo)
        self:Blast_FlinchGesture(dmginfo)
        self:HandleReinforcedArmorImpact(dmginfo)
        self:PanicOnDamageByEne(dmginfo)
        self:MngDmgTypeScales(dmginfo)
        self:ReactToDmg(dmginfo)
        self:ShovedBack(dmginfo)
        self:Handle_OnFirePain(dmginfo)

        self.Medical_LastDamagedT = cutT

        local badSnd = self.CurrentIdleSound
        if cancelDial == 1 and self.Dmg_Cancel_IdleDial and self:Alive() and badSnd then
                self.IdleSoundBlockTime= curT + mRand(0.25, 0.5)
                if badSnd then
                    VJ.STOPSOUND(self.CurrentIdleSound)
                end 
            end 

        if mRng(1, self.Ele_SparkImpFx_Chance) == 1 and self.Ele_SparkImpFx then
            local snd = {"ambient/energy/spark".. mRng(1, 6) .. ".wav"}
            local sndPick = table.Random(snd)
            local rngAng = mRng(-360, 360)
            local randAng = Angle(rngAng, rngAng, rngAng)
            if snd and snd ~= "" then 
                VJ.EmitSound(self, sndPick, rngSnd, rngSnd)
            end 
            ParticleEffect("electrical_arc_01_parent", dmginfo:GetDamagePosition() + VectorRand(-5, 5), randAng, nil)
        end

        if self.ImpMetal_SparkArmor and mRng(1, self.ImpMetal_SparkArmorChance) == 1 then
            local effectData = EffectData()
            effectData:SetOrigin(dmginfo:GetDamagePosition())
            util.Effect("StunstickImpact", effectData)
        end

        if coughConv == 1 and self.ToxDmg_React and curT > (self.ToxDmg_NextT or 0) and (self:Alive() or not self.Dead) and not self.Immune_Toxic then 
            local dmgDetect = dmgType == DMG_RADIATION or dmgType == DMG_POISON or dmgType == DMG_NERVEGAS or dmgType == DMG_PARALYZE or dmgType == DMG_ACID 
            if dmgDetect then 
                if mRng(1, self.ToxDmg_Chance) == 1 and IsValid(self) then 
                    local snd = VJ.PICK(self.ToxDmg_CoughTbl) or {}
                    //self.CoughingSound = VJ.CreateSound(self, snd, rngSnd, rngSnd)
                    if snd then 
                        self:PlaySoundSystem("IdleDialogue", snd)
                        self.ToxDmg_NextT = curT + mRand(2.5, 5)
                    end 
                end 
            end 
        end 
    
        if self.CanHaveHeadshotFx then
            self:HandleHeadshot(dmginfo, hitgroup)
        end

        local shockChance = tonumber(self.ShockDmgFxChance) or 2 
        if dmgType == DMG_SHOCK and mRng(1, shockChance) == 1 then
            self:DamagedByShockFx() 
        end  

        local attacker = dmginfo:GetAttacker()
        local relation = self:Disposition(attacker)
        local disps = (relation == D_LI or relation == D_NU)
        if self.React_FriFire then 
            if IsValid(attacker) and attacker:IsPlayer() and not VJ_CVAR_IGNOREPLAYERS and disps then
                print("The attacker is a friendly player:", attacker:GetName())
                self:SetTurnTarget(attacker)
                self:SCHEDULE_FACE("TASK_FACE_TARGET")
                self:React_DmgFrPly(attacker, dmginfo)
            end
        end 
    end

    if status == "Init" then
        local damage = dmginfo:GetDamage()
        local imp = {"vj_base/impact/armor" .. mRng(1, 10) .. ".wav"}
        local minCapChnce = tonumber(self.MinDmg_Cap_Chance) or 3 
        local minImpChnce = tonumber(self.MinDmg_Cap_Feedback_Sfx_Chance) or 2
        if minDmgConv == 1 and damage <= self.MinDmg_Cap and self.MinDmg_CapAbility and mRng(1, minCapChnce) == 1 and not (dmgType == DMG_BURN or dmgType ==  DMG_SLOWBURN) and curT > (self.MinDmg_Cap_NextT or 0)  then
            self.MinDmg_Cap_NextT = curT + 0.25
            dmginfo:SetDamage(0)
            self.MinDmg_Cap_Active = true

            if minDmgSfxConv == 1 and self.MinDmg_Cap_Feedback_Sfx and mRng(1, minImpChnce) == 1 then 
                if imp then 
                    self:PlaySoundSystem("Impact", imp)
                end 
            end 

            timer.Simple(0.05, function()
                if IsValid(self) then 
                    self.MinDmg_Cap_Active = false
                end
            end)
        end
    end

    if status == "PostDamage" then
        self:Armored_Richochet(dmginfo)
        self:Armor_DmgSparking(dmginfo)
    end
end


function ENT:Handle_OnFirePain(dmginfo)
    if not IsValid(self) then return end
    if not dmginfo or not dmginfo.GetDamageType then return end
    local firePainConv = 1
    local cv = GetConVar("vj_stalker_fire_dmg_vo")
    if cv then firePainConv = cv:GetInt() end

    if firePainConv ~= 1 then return end
    if not self.HasFireSpecPain or not self.HasSounds then return end
    local dmgType = dmginfo:GetDamageType()
    if self.Immune_Fire then return end
    if not (dmgType == DMG_BURN or dmgType == DMG_SLOWBURN or self:IsOnFire()) then return end
    if self.OnFirePain == false or self.OnFirePain == nil then return end

    local burnSnd = nil
    if istable(self.OnFirePain) and next(self.OnFirePain) then
        if table.Random then
            burnSnd = table.Random(self.OnFirePain)
        else
            burnSnd = self.OnFirePain[mRng(1, #self.OnFirePain)]
        end
    elseif isstring(self.OnFirePain) then
        burnSnd = tostring(self.OnFirePain)
    end

    if not burnSnd or burnSnd == "" then return end
    local soundSysType = "Pain"
    if self.PlaySoundSystem then
        self:PlaySoundSystem(soundSysType, burnSnd)
    else
        self:EmitSound(burnSnd)
    end
end

function ENT:Armor_DmgSparking(dmginfo)
    local armorConv = GetConVar("vj_stalker_armor_spark"):GetInt()
    if armorConv ~= 1 or not IsValid(self) then return end

    local cT = CurTime()
    if cT < (self.Armor_SparkNextT or 0) then return end
    local dmgType = dmginfo:GetDamageType()
    local armorSparkChance = tonumber(self.ArmorSparking_Chance) or 12
    local dmgPos = dmginfo:GetDamagePosition()
    local ang = self:GetAngles()
    local dT = dmginfo:GetDamageType()
    local magMin = tonumber(self.Armor_SparkMag_Min) or 0.05
    local magMax = tonumber(self.Armor_SparkMag_Max) or 1
    local legMin = tonumber(self.Armor_SparkLeg_Min) or 0.05
    local legMax = tonumber(self.Armor_SparkLeg_Max) or 3 
    local sparkMagnitude = mRand(magMin, magMax) 
    local sparkTrailLength = mRand(legMin, legMax)
    local isBullet = dmginfo:IsBulletDamage() or dmgType == DMG_BULLET or dmgType == DMG_AIRBOAT or dmgType == DMG_BUCKSHOT or dmgType == DMG_SNIPER
    if isBullet then 
        if self.Reinforced_Armor and self.ArmorSparking and mRng(1, armorSparkChance) == 1 then
            self.Armor_SparkNextT = cT + mRand(0.1, 0.5)
            local damageSpark = ents.Create("env_spark")
            local color = self.Armor_SparkColor or "255 255 255"
            local stopT = mRand(0.05,0.225) or 0.1
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
    if not IsValid(self) then return false end 
    local dmgType = dmginfo:GetDamageType()
    local burnDmg = (dmgType == DMG_BURN or dmgType == DMG_SLOWBURN) and self:IsOnFire()
    local chance = self.Reinforced_Armor_ImpSnds_Chance or 15 
    if burnDmg then return false end 
    if self.Reinforced_Armor and self.Reinforced_Armor_ImpSnds and self.HasSounds and self.HasImpactSounds and mRng(chance) == 1 then
        local soundToPlay = mRng(2) == 1 and "vj_base/impact/armor" .. mRng(1, 10) .. ".wav" or VJ.PICK(self.SoundTbl_ExtraArmorImpacts)
        if soundToPlay then
            self:PlaySoundSystem("Impact", soundToPlay)
        else
            self:EmitSound(soundToPlay)
        end
    end
end 

ENT.Reinforced_Armor_Richochet = true 
ENT.Reinforced_Armor_RichochetChance = 20
ENT.Reinforced_Armor_IsRichocheting = false 
function ENT:Armored_Richochet(dmginfo)
    local armorRichConv = GetConVar("vj_stalker_armor_ricochet"):GetInt()
    if armorRichConv == 1 and self.Reinforced_Armor then
        local dmgType = dmginfo:GetDamageType()
        local chance = self.Reinforced_Armor_RichochetChance or 20 
        local rngSnd = mRng(85, 105)
        local ricoSnd = VJ.PICK(self.Rein_Armor_Richochet_Tbl)
        if self.Reinforced_Armor_Richochet and mRng(1, chance) == 1 and 
           (dmginfo:IsBulletDamage() or dmgType == DMG_BULLET or dmgType == DMG_AIRBOAT or 
            dmgType == DMG_BUCKSHOT or dmgType == DMG_SNIPER) then
            self.Reinforced_Armor_IsRichocheting = true
            local attacker = dmginfo:GetAttacker()
            if not IsValid(attacker) then attacker = self end
            if IsValid(attacker) and IsValid(self) then
                local hitPos = dmginfo:GetDamagePosition()
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
                effectData:SetStart(startPos)
                effectData:SetOrigin(startPos + reflection * 2000)
                effectData:SetScale(5000)
                util.Effect("Tracer", effectData)
                if ricoSnd and mRng(1, 2) == 1 then 
                    VJ.EmitSound(self, ricoSnd, rngSnd, rngSnd)
                end 
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
    local conv = GetConVar("vj_stalker_panic_after_dmg"):GetInt() 
    if conv ~= 1 then return end
    if self.VJ_IsBeingControlled then return end
    if not self:Alive() then return end 

    local busy = self:IsBusy() or self:IsVJAnimationLockState() 

    if busy then return end

    local panicChance = tonumber(self.Panic_DmgEne_Chance)
    local curTime = CurTime()
    local attacker = dmginfo:GetAttacker()
    local enemy = self:GetEnemy()
    local coverType = mRng(1, 3)
    local bScheds = self:GetCurrentSchedule() == 30 or self:GetCurrentSchedule() == 27 
    local disp = self:Disposition(attacker)
    if disp == D_LI or disp == D_NU then return end 
    if bScheds then return false end 
    if not IsValid(attacker) and not IsValid(enemy) then return end

    local wep = self:GetActiveWeapon()
    local hasNonMeleeWeapon = not IsValid(wep) or (IsValid(wep) and not wep.IsMeleeWeapon)

    if self.IsHeavilyArmored then 
        panicChance = panicChance * 2
    end 

    if self:Health() <= (self:GetMaxHealth() * 0.5) then
        panicChance = math.max(1, math.floor(panicChance / 2))
    end

    if hasNonMeleeWeapon and curTime >= (self.Panic_DmgEne_NextT or 0) and mRng(1, panicChance) == 1 then
        self:ClearSchedule()
        self:StopMoving()
        timer.Simple(mRand(0.05, 0.45), function()
            if not IsValid(self) then return end
            print("[PANIC IN DMGA]")
            local pickedCover = false 
            if coverType == 1 then
                self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH", function(x)
                    x.DisableChasingEnemy = true
                    if mRng(1, 2) == 1 then
                        x.CanShootWhenMoving = true
                        x.TurnData = {Type = VJ.FACE_ENEMY}
                    else
                        x.CanShootWhenMoving = false  
                        x.TurnData = {Type = VJ.FACE_ENEMY, Target = nil}
                    end
                end)
                pickedCover = true
            elseif coverType == 2 and IsValid(enemy) then
                self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH", function(x)
                    x.DisableChasingEnemy = true
                    if mRng(1, 2) == 1 then
                        x.CanShootWhenMoving = true
                        x.TurnData = {Type = VJ.FACE_ENEMY}
                    else
                        x.CanShootWhenMoving = false  
                        x.TurnData = {Type = VJ.FACE_ENEMY, Target = nil}
                    end
                end)
                pickedCover = true
            elseif coverType == 3 then
                self:SetSchedule(SCHED_TAKE_COVER_FROM_ORIGIN)
                pickedCover = true
            end
            if pickedCover then
                self.Panic_DmgEne_NextT = curTime + mRand(1, 5)
            end
        end)
        return true
    end
    return false
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

function ENT:MngDmgTypeScales(dmginfo, hitgroup)
    if not IsValid(self) or not self.HasRngDmgScale or self.Dead or self.IsCurrentlyIncapacitated then return end
    local pr = self.RANDOMS_DEBUG
    local dmg = dmginfo:GetDamageType()
    local initialDamage = dmginfo:GetDamage()

    -- Scientific stats
    if self.IsScientific then
        if bit.band(dmg, DMG_BURN + DMG_SLOWBURN) ~= 0 then
            dmginfo:ScaleDamage(0.2)
            if pr then
                print(string.format("Fire Dmg (Scientific) Scaled: Initial = %.2f | Scaled = %.2f", initialDamage, dmginfo:GetDamage()))
            end 
            return
        elseif bit.band(dmg, DMG_SHOCK + DMG_DISSOLVE) ~= 0 then
            dmginfo:ScaleDamage(0.1)
            if pr then
                print(string.format("Shock/Dissolve Dmg (Scientific) Scaled: Initial = %.2f | Scaled = %.2f", initialDamage, dmginfo:GetDamage()))
            end 
            return
        elseif bit.band(dmg, DMG_BLAST) ~= 0 then
            dmginfo:ScaleDamage(0.5)
            if pr then
                print(string.format("Blast Dmg (Scientific) Scaled: Initial = %.2f | Scaled = %.2f", initialDamage, dmginfo:GetDamage()))
            end
            return
        end
    end

    -- Exo/Heavy unit stats
    if self.IsHeavilyArmored then
        if bit.band(dmg, DMG_BURN + DMG_SLOWBURN) ~= 0 then
            dmginfo:ScaleDamage(0.5)
            if pr then
                print(string.format("Fire Dmg (Heavy) Scaled: Initial = %.2f | Scaled = %.2f", initialDamage, dmginfo:GetDamage()))
            end 
            return
        elseif bit.band(dmg, DMG_BLAST) ~= 0 then
            dmginfo:ScaleDamage(0.2)
            if pr then 
                print(string.format("Blast Dmg (Heavy) Scaled: Initial = %.2f | Scaled = %.2f", initialDamage, dmginfo:GetDamage()))
            end 
            return
        elseif bit.band(dmg, DMG_SLASH) ~= 0 then
            dmginfo:ScaleDamage(0.45)
            if pr then
                print(string.format("Blast Dmg (Slash) Scaled: Initial = %.2f | Scaled = %.2f", initialDamage, dmginfo:GetDamage()))
            end
            return
        elseif bit.band(dmg, DMG_ACID + DMG_RADIATION + DMG_POISON + DMG_NERVEGAS + DMG_PARALYZE) ~= 0 then
            dmginfo:ScaleDamage(0.8)
            if pr then
                print(string.format("Toxic Dmg (Heavy) Scaled: Initial = %.2f | Scaled = %.2f", initialDamage, dmginfo:GetDamage()))
            end 
            return
        end
    end

    -- Bullet dmg
    if dmginfo:IsBulletDamage() and self.HasBulletDmgScale then
        local hitHitgroup = hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_RIGHTLEG or hitgroup == HITGROUP_RIGHTARM or hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_GEAR
        if hitHitgroup and mRng(1, 3) == 1 then
            local reducedScale = mRand(0.2, 0.3)
            dmginfo:ScaleDamage(reducedScale)
            if pr then
                print(string.format("Severe Bullet Dmg Reduction (Limb/Torso): Initial = %.2f | Scaled = %.2f (Scale: %.2fx)",
                initialDamage, dmginfo:GetDamage(), reducedScale))
            end 
            return
        else
            local scale = mRand(0.75, 0.95)
            dmginfo:ScaleDamage(scale)
            if pr then
                print(string.format("Bullet Dmg Scaled: Initial = %.2f | Scaled = %.2f (Scale: %.2fx)", 
                initialDamage, dmginfo:GetDamage(), scale))
            end 
            return
        end
    end

    -- Fallback dmg scales
    for dtype, scaleRange in pairs(dmgScales) do
        if bit.band(dmg, dtype) ~= 0 then
            local scale = mRand(scaleRange[1], scaleRange[2])
            dmginfo:ScaleDamage(scale)
            if pr then
            print(string.format("%s Dmg Scaled (Fallback): Initial = %.2f | Scaled = %.2f (Scale: %.2fx)", 
                tostring(dtype), initialDamage, dmginfo:GetDamage(), scale))
            end 
            return
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DamagedByShockFx()
    if not self.HasShockDmgFx then return end 
    if not IsValid(self) then return end

    local origin = self:GetPos()
    local magnitude = mRng(1, 3)
    local scale = mRng(1, 3)
    local radius = mRng(1, 3)
    local curT = CurTime()

    local teslaEffectData = EffectData()
    teslaEffectData:SetEntity(self)
    teslaEffectData:SetMagnitude(magnitude)
    teslaEffectData:SetScale(scale)
    teslaEffectData:SetRadius(radius)
    teslaEffectData:SetStart(origin)
    teslaEffectData:SetOrigin(origin)

    util.Effect("TeslaHitBoxes", teslaEffectData, true, true)

    local stunDuration = mRand(0.925, 10.25)
    local entIndex = self:EntIndex()
    local endTime = curT + stunDuration

    timer.Create("TeslaEffectTimer_" .. entIndex, 0.1, math.ceil(stunDuration / 0.1), function()
        if IsValid(self) and self:Alive() then
            util.Effect("TeslaHitBoxes", teslaEffectData, true, true)
        end
    end)

    local function EmitShockSoundAndEffect()
        if not IsValid(self) or not self:Alive() then return end
        if CurTime() > endTime then return end
        local sndRng = mRng(85, 105)
        local sndTbl = {"ambient/energy/zap" .. mRng(1, 9) .. ".wav"}
        local sounds = table.Random(sndTbl)
        if sounds then 
            VJ.EmitSound(self, sounds, sndRng, sndRng)
        end 

        local cballEffect = EffectData()
        local sparkOrigin = self:GetPos() + self:GetUp() * mRng(10, 35)
        local mag = mRng(5,25)
        cballEffect:SetOrigin(sparkOrigin)
        cballEffect:SetStart(sparkOrigin)
        cballEffect:SetMagnitude(mag)
        cballEffect:SetEntity(self)
        util.Effect("cball_explode", cballEffect)

        timer.Simple(mRand(0.325, 1.255), EmitShockSoundAndEffect)
    end

    timer.Simple(mRand(0.1, 0.35), EmitShockSoundAndEffect)

    timer.Simple(stunDuration, function()
        if IsValid(self) then
            timer.Remove("TeslaEffectTimer_" .. entIndex)
        end
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DetectLanding()
    if not self.Detect_LandAnim then return end 
    if self.IsLanding then return end 
    local cT = CurTime()
    if not IsValid(self) or cT < (self.NextLandAnimCheckT) then
        return
    end

    local rngSnd = mRng(75, 115)
    local rngVol = mRng(65, 80)

    local landAnim = "jump_holding_land"

    local seq = self:GetSequence()
    local currentSequence = seq and self:GetSequenceName(seq) or ""
    
    if currentSequence == landAnim or self:GetActivity() == ACT_LAND then
        self.IsLanding = true  

        local landSnds = table.Random({"general_sds/land_sound/jumplanding.wav","general_sds/land_sound/jumplanding2.wav","general_sds/land_sound/jumplanding3.wav","general_sds/land_sound/jumplanding4.wav","general_sds/land_sound/landing.mp3"})
        local gruntSnd = self.JumpLandGruntTbl 
        local selectLand = mRng(1, #landSnds) or ""
        local selectGrunt = mRng(1, #gruntSnd) or ""

        if selectLand then 
            VJ.EmitSound(self, selectLand, rngVol, rngSnd)
        end 
        if selectGrunt and mRng(1, 2) == 1 then 
            VJ.EmitSound(self, selectGrunt, rngVol, rngSnd)
        end 
        
        local landDuration = self:SequenceDuration(self:LookupSequence(landAnim)) or VJ.AnimDuration(self, landAnim) or 1 
        local myPos = self:GetPos()
        local isInWater = bit.band(util.PointContents(myPos), CONTENTS_WATER) == CONTENTS_WATER
        local conv = GetConVar("vj_stalker_jump_land_particles"):GetInt() 
        local pcfxScale = tonumber(self.Landing_FxScale)
        if conv == 1 then 
            if self.Landing_Effects and self.IsLanding and not isInWater then
                if self.LargeLandFx then 
                    local effectData = EffectData()
                    effectData:SetOrigin(myPos)
                    effectData:SetScale(pcfxScale)
                    util.Effect("ThumperDust", effectData) 
                else 
                    local effectData = EffectData()
                    effectData:SetOrigin(myPos)
                    util.Effect("vj_randoms_dust_land_small", effectData)  
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

ENT.Danger_DetectSiganlT = 0
function ENT:OnDangerDetected(dangerType, data)
    if not self.CanDetectDangers then return end 
    local curT = CurTime()
    local gestureSignal = VJ.PICK(self.DetectDangerReactAnim)
    local animChance = self.DetectDangerAnimChance

    if curT > self.Danger_DetectSiganlT and  mRng(1, animChance) == 1 and self.HasDetectDangerAnim then
        self:PlayAnim("vjges_" .. gestureSignal, false) 
        self.Danger_DetectSiganlT = curT + mRand(1, 10)
    end 

    if not IsValid(self) or self.IsDetectingDanger or mRng(1, 2) ~= 1 then return end
    self.IsDetectingDanger = true

    local panicDuration = self.IsPanickedStateT + mRand(5, 10)
    timer.Simple(panicDuration, function()
        if not IsValid(self) then return end
        self.IsDetectingDanger = false

        self.NextDangerDetectionT = curT + mRand(1, 2)
        self.TakingCoverT = curT + mRand(1, 5)
    end)
end

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

function ENT:CopyPlayerStance() -- ran in on think
    if not self.Copy_PlyCrouchStance or not self.IsFollowing then return end

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
        if not self:IsOnGround() or self.MovementType == VJ_MOVETYPE_STATIONARY then 
            return 
        end 

        self:Dynamic_FeetSteps()
        if self._OrigSoundTbl_FootStep == nil and self.FootstepSoundLevel then
            self._OrigFootstepSoundLevel = tonumber(self.FootstepSoundLevel) or 75 
        end
        if self.CrouchMovement then
            self.FootstepSoundLevel = 0 -- somehow, this variable cannot be changed.
        else
            if self.FootstepSoundLevel ~= self._OrigFootstepSoundLevel then
                self.FootstepSoundLevel = self._OrigFootstepSoundLevel or 75 
            end
        end
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


function ENT:TranslateActivity(act)
    local ene = self:GetEnemy()
    if self.IsCrouchFiring and self.Weapon_CanMoveFire and IsValid(ene) then
        if self.Weapon_CanMoveFire and IsValid(ene) and (self.EnemyData.Visible or (self.EnemyData.VisibleTime + 5) > CurTime()) and self.CurrentSchedule and self.CurrentSchedule.CanShootWhenMoving and self:CanFireWeapon(true, false) then
            self.WeaponAttackState = VJ.WEP_ATTACK_STATE_FIRE
            if act == ACT_WALK then
                return self:TranslateActivity(act == ACT_WALK and ACT_WALK_CROUCH_AIM)
            elseif act == ACT_RUN then
                return self:TranslateActivity(act == ACT_RUN and ACT_RUN_CROUCH_AIM)
            end
        end
    end

    if self.Copy_PlyCrouchStance then 
        if self.Copy_IsCrouching then 
            if act == ACT_RUN then
                return ACT_RUN_CROUCH or ACT_WALK_CROUCH_AIM  
            end
            if act == ACT_IDLE then
                return ACT_COVER
            end
            if act == ACT_WALK then
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

    if act == ACT_RUN and self.IsDetectingDanger then
        return self:TranslateActivity(act == ACT_RUN and ACT_RUN_PROTECTED)
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
    if not IsValid(self) or self:Health() <= 0 or not self.CanBecomeDefensiveAtLowHP or self.CombatChaseSateGreen then return end

    local defRetDist = self.Weapon_RetreatDistance
    local defChaseEne = self.DisableChasingEnemy
    local defOcDelay = self.Weapon_OcclusionDelayMinDist
    local health = self:Health()
    local maxHealth = self:GetMaxHealth()
    local lowHealthThreshold = maxHealth * 0.25

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

    if crossConv ~= 1 then
        return  
    end

    local ai_Conv = GetConVar("ai_ignoreplayers"):GetBool()
    if ai_Conv == 1 or VJ_CVAR_IGNOREPLAYERS then return end 

    if self.VJ_IsBeingControlled then return end 

    local busy = self:IsVJAnimationLockState() or self:IsBusy("Activities") or self.CurrentlyHealSelf or self.IsHumanDodging or self.Flinching
    local curT = CurTime()
    local bScheds = self:IsCurrentSchedule(30) or self:IsCurrentSchedule(27)
    
    if not self:IsOnGround() then return end 
    if self.IsGuard or self.MovementType == VJ_MOVETYPE_STATIONARY then return end 

    if busy or 
        bScheds or    
        self:GetNPCState() == NPC_STATE_IDLE or  
        not self.Alerted or 
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
                self:StopMoving()
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

    animTbl = self.Avoid_C_HairGesTbl
    if not animTbl or #animTbl == 0 then return end  

    local gesAnim; 
    
    if anim ~= false and anim ~= "" then 
        if istable(anim) then 
            gesAnim = table.Random(anim)
        elseif isstring(anim) then 
            gesAnim = anim 
        end 
    end 

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
    if GetConVar("vj_stalker_fire_quick_flares"):GetInt() ~= 1 then return false end
    if not self.AllowedToLaunchQuickFlare then return false end 
    if self:IsBusy() or self.VJ_IsBeingControlled then return false end

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

    if self.Flinching or self.IsFiringQuickFlare or self.IsHoldingSecondaryWeapon then return false end
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

    if self:IsBusy("Activities") or self:GetWeaponState() == VJ.WEP_STATE_RELOADING or self.AttackType or cT < self.TakingCoverT then return end

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
    local fireAnim;
    if self.AnimTbl_WeaponAttackSecondary and self.AnimTbl_WeaponAttackSecondary ~= false then
        if istable(self.AnimTbl_WeaponAttackSecondary) then 
            fireAnim = table.Random(self.AnimTbl_WeaponAttackSecondary)
        elseif isstring(self.AnimTbl_WeaponAttackSecondary) and self.AnimTbl_WeaponAttackSecondary ~= "" then 
            fireAnim = self.AnimTbl_WeaponAttackSecondary
        end 
    end 
    
    if not fireAnim then return end 

    local fireT = self:SequenceDuration(self:LookupSequence(fireAnim)) or 1 
    self:PlayAnim(fireAnim, true, fireT, true)
    self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, fireT)
    self:SetTurnTarget("Enemy")

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
    if self.SpotFr_PlyAnim then 
        if VJ_CVAR_IGNOREPLAYERS then return end
        if self.VJ_IsBeingControlled then return end 
        local friendlyConVar = GetConVar(tostring(self.FriendlyConvar)):GetInt()
        if not friendlyConVar or friendlyConVar ~= 1 then return end
        if self:GetNPCState() ~= NPC_STATE_IDLE then return end 

        local cT = CurTime()
        if cT < (self.SpotFr_PlyAnimNextT or 0) then return end

        local ene = self:GetEnemy()
        local busy = self:IsBusy() or self:IsVJAnimationLockState() 
        local disp = self:Disposition(ent)

        local tbl = self.SpotFr_PlyAnim_SeqTbl
        if not istable(tbl) or #tbl == 0 then return end

        if ent:IsPlayer() and disp == D_LI and self:Visible(ent) then
            if self.IsFollowing or
                self.FollowingPlayer or
                self:GetWeaponState() == VJ.WEP_STATE_RELOADING or
                self.WeaponAttackState == VJ.WEP_ATTACK_STATE_FIRE_STAND or
                self.Medic_Status or
                IsValid(ene) or
                busy or
                not self:IsOnGround() or 
                self.Alerted then
                return 
            end
            
            local animChance = tonumber(self.SpotFr_PlyAnim_Chance) or 10 
            local seqSpotAnim = self.SpotFr_PlyAnim_SeqTbl[mRng(1, #self.SpotFr_PlyAnim_SeqTbl)]
            local playedAnim = false
            local eneIdleCheck = not IsValid(ene) and self:GetNPCState() == NPC_STATE_IDLE and (not ent:IsNPC() or not IsValid(ent:GetEnemy()))
            local rngDel = mRand(0.15, 0.65)

            if mRng(1, animChance) == 1  then
                self:RemoveAllGestures()
                timer.Simple(rngDel, function()
                    if IsValid(self) then
                        if busy then return end 
                        local aT = self:SequenceDuration(self:LookupSequence(seqSpotAnim)) or 1 
                        if seqSpotAnim then
                            self:StopMoving()
                            self:SetTarget(ent)
                            self:SCHEDULE_FACE("TASK_FACE_TARGET")
                            self:PlayAnim("vjseq_" .. seqSpotAnim, true, aT, false) -- Dunno why, but anims are totall screwed lol
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
                                    print("On spot player, we are playing a sequence animation!")
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
    if self:Health() <= 0 then return end

    local busy = self.Flinching or self:IsBusy() or self:IsVJAnimationLockState() 
    local ene = self:GetEnemy()
    
    if self.VJ_IsBeingControlled or IsValid(ene) or self.Alerted then 
        return  
    end

    local tbl = self.FollowPly_ReactTbl
    if not istable(tbl) or #tbl == 0 then return end

    if not IsValid(self) or not IsValid(entity) or not self:Visible(entity) or 
       (entity:IsPlayer() and self:Disposition(entity) ~= D_LI) then
        return 
    end

    local reactAnim = self.FollowPly_ReactTbl[mRng(1, #self.FollowPly_ReactTbl)]
    local delay = mRand(0.65, 3)
    local curT = CurTime()
    local chance = self.FollowPly_ReactChance or 2 

    if mRng(1, chance) == 1 and curT > (self.FollowPly_ReactNextT or 0) then
        if state == "Start" or state == "Stop" then
            if reactAnim then     
                self:RemoveAllGestures()
                timer.Simple(delay, function()
                    if IsValid(self) then
                        if busy then return end 
                        self:PlayAnim("vjges_" .. reactAnim, false)
                        if self.RANDOMS_DEBUG then 
                            print("Playing " .. state .. " response anim!")
                        end 
                        self.FollowPly_ReactNextT = CurTime() + mRand(1, 5)
                    end
                end)
            end 
        end
    end 
end 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Fidget_AnimTbl = {"fidget_scratch_face","fidget_wipe_hand","fidget_wipe_face","fidget_stretch_neck","fidget_stretch_back","fidget_roll_shoulders","hg_turnr","hg_turnl","hg_turn_r","hg_turn_l"}

function ENT:Idle_FidgetAnim()
    if self.PlayFidgetAnims then
        if self.VJ_IsBeingControlled or IsValid(self:GetEnemy()) then return end
        if self:GetNPCState() ~= NPC_STATE_IDLE then return end 

        if self:IsVJAnimationLockState()  or self:IsBusy() or not self:IsOnGround() or self.Dead or self.CurrentSchedule or self.Alerted or self.PlayingFidgetAnim then
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

            local animSelected = nil
            if self.Fidget_AnimTbl and self.Fidget_AnimTbl ~= false then
                if istable(self.Fidget_AnimTbl) then
                    animSelected = table.Random(self.Fidget_AnimTbl)
                elseif isstring(self.Fidget_AnimTbl) and self.Fidget_AnimTbl ~= "" then
                    animSelected = self.Fidget_AnimTbl
                end
            end
            if not animSelected then return end 
            self.PlayingFidgetAnim = true
            timer.Simple(mRand(0.25, 1), function()
                if not IsValid(self) or self:IsBusy() or self.Alerted then
                    self.PlayingFidgetAnim = false
                    return
                end

                local ene = self:GetEnemy() 
                if IsValid(ene) or not self:IsOnGround() then
                    self.PlayingFidgetAnim = false
                    return
                end

                if animSelected then 
                    local seq = self:LookupSequence(animSelected)
                    if seq and seq > 0 then 
                        self:PlayAnim("vjges_" .. animSelected, false)
                        local fidgetTime = self:SequenceDuration(seq)
                        self.FidgetAnimNextT = CurTime() + mRand(5, 35) + fidgetTime

                        timer.Simple(fidgetTime + 0.1, function()
                            if not IsValid(self) then return end
                            self.PlayingFidgetAnim = false
                            if IsValid(self:GetEnemy()) then
                                self:RemoveAllGestures()
                            end
                        end)
                    else
                        self.PlayingFidgetAnim = false 
                    end
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
    if self.VJ_IsBeingControlled then return end 
    local nSt = self:GetNPCState()
    if nSt ~= NPC_STATE_IDLE then return end 
    
    if self:IsVJAnimationLockState()  or
        self:IsBusy() or
        not IsValid(self) or 
        not IsValid(npc) then 
        return 
    end

    local curT = CurTime()
    local chance = tonumber(self.Dialogue_Anim_Chance) or 2 
    local delay = mRand(0.15, 1.25)
    local dialogueAnim = nil
    if self.Dialogue_AnimTbl and self.Dialogue_AnimTbl ~= false then
        if istable(self.Dialogue_AnimTbl) then
            dialogueAnim = table.Random(self.Dialogue_AnimTbl)
        elseif isstring(self.Dialogue_AnimTbl) and self.Dialogue_AnimTbl ~= "" then
            dialogueAnim = self.Dialogue_AnimTbl
        end
    end
    if not dialogueAnim then return end 
    if (state == "Speak" or state == "Answer") and mRng(1, chance) == 1 and self.Dialogue_Anim and curT > (self.Dialogue_AnimNextT or 0) then 
        if dialogueAnim then 
            self:RemoveAllGestures()
            timer.Simple(delay, function()
                if IsValid(self) then 
                    self:PlayAnim("vjges_" .. dialogueAnim)
                end
            end)
            self.Dialogue_AnimNextT = curT + mRand(5, 10)
        end 
    end 
end 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInvestigate(ent)
    self:GestureAnimOnInvest()
end

function ENT:GestureAnimOnInvest()
    if not IsValid(self) or IsValid(self:GetEnemy()) or self.VJ_IsBeingControlled or self:GetNPCState() ~= NPC_STATE_IDLE then 
        return  
    end

    local curT = CurTime()
    local ene = self:GetEnemy()
    local chance = self.Investigate_AnimReactChance or 3
    local busy = self:IsBusy() or self:IsVJAnimationLockState() 
    if curT > self.Investigate_NextAnimT and mRng(1, chance) == 1 and not busy and self.Investigate_HasAnimReact and not IsValid(ene) then
        self:RemoveAllGestures()
        timer.Simple(mRand(0.2,1), function()
            if IsValid(self) then
                local investAnim = VJ.PICK(self.Investigare_AnimReactTbl)
                if investAnim then
                    self:PlayAnim("vjges_" .. investAnim, false)
                    print("Investigate Anim")
                end
                self.Investigate_NextAnimT = curT + mRand(5, 10)
            end
        end)
    end
end 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Idle_FindLoot()
    local cvar = GetConVar("vj_stalker_looting")
    if not cvar or cvar:GetInt() ~= 1 then return false end
    if not IsValid(self) or self.VJ_IsBeingControlled or self.IsGuard then return false end
    if not IsValid(self:GetActiveWeapon()) then return false end

    if CurTime() - (self.SpawnedAt or 0) < 2 then return false end

    if self:IsBusy() or self:IsVJAnimationLockState()  or self:IsOnFire() or not self.AllowedToLoot or self.MovementType == VJ_MOVETYPE_STATIONARY or self.IsFollowing or self.FollowingPlayer or self.Alerted or self:GetNPCState() ~= NPC_STATE_IDLE or self:IsMoving() then
        return false
    end

    local curTime = CurTime()
    if curTime < (self.NextFindLootT or 0) then return false end

    local enemy = self:GetEnemy()
    if IsValid(enemy) and self:Visible(enemy) then return false end

    self.FailedLoot = self.FailedLoot or {}
    self.LootInventory = self.LootInventory or {}
    self.LootableLookup = self.LootableLookup or {}

    if table.IsEmpty(self.LootableLookup) and istable(self.LootableEntities) then
        for _, class in ipairs(self.LootableEntities) do
            self.LootableLookup[class] = true
        end
    end

    local selfPos = self:GetPos()
    local rngSnd = mRng(85, 105)

    for _, v in ipairs(ents.FindInSphere(selfPos, self.FindLootDistance)) do
        if not IsValid(v) then continue end
        if not self.LootableLookup[v:GetClass()] then continue end
        if not self:Visible(v) then continue end
        if self.FailedLoot[v] and curTime < self.FailedLoot[v] then continue end

        local lootPos = v:GetPos() + v:OBBCenter()
        local myNear = self:NearestPoint(lootPos)
        myNear.x = selfPos.x
        myNear.y = selfPos.y
        local lootNear = v:NearestPoint(myNear)
        local lootDist = lootNear:Distance(myNear)

        self:SetLastPosition(select(2, VJ.GetNearestPositions(self, v, true)))
        self:StopMoving()
        self:SCHEDULE_GOTO_POSITION(VJ.PICK({"TASK_RUN_PATH", "TASK_WALK_PATH"}))
        if self:IsBusy() then return end 
        if not IsValid(v) then return false end
        if lootDist <= mRng(15, 45) then
            local pickUpAnim = VJ.PICK(self.PlyPickUpAnim)
            if pickUpAnim then
                local animDur = self:SequenceDuration(pickUpAnim)
                self:RemoveAllGestures()
                self:PlayAnim("vjseq_" .. pickUpAnim, true, animDur, false)
                self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, animDur)
            end

            VJ.EmitSound(self, "items/itempickup.wav", rngSnd, rngSnd)
            table.insert(self.LootInventory, {class = v:GetClass(), pos = v:GetPos(), time = curTime})
            v:Remove()
            self.NextFindLootT = curTime + mRand(2.5, 10)
            return true
        else
            self.FailedLoot[v] = curTime + mRand(2.5, 10)
        end
    end
    return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Find_MedEnts = true
ENT.Find_MedEnts_Dist = 3500
ENT.Find_MedEntsNextT = 0

function ENT:HumanFindMedicalEnt()
    if not IsValid(self) or not self.Find_MedEnts or self.VJ_IsBeingControlled then return false end

    local curTime = CurTime()
    if curTime < (self.Find_MedEntsNextT or 0) or curTime < (self.TakingCoverT or 0) then return false end
    if self.IsGuard or self:IsOnFire() or self.MovementType == VJ_MOVETYPE_STATIONARY then return false end
    if self.CurrentlyHealSelf or self.FollowingPlayer or not self:IsOnGround() then return false end
    if self:IsVJAnimationLockState() then return end 
    local busy = self.IsFollowing or self.Medic_Status or self.Flinching or self:IsBusy()

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
            self:SCHEDULE_GOTO_POSITION(VJ.PICK({"TASK_RUN_PATH", "TASK_WALK_PATH"}), function(x)
                x.CanShootWhenMoving = true
            end)
            break
        end
    end

    if not IsValid(medEnt) then return false end

    local dist = VJ.GetNearestDistance(self, medEnt, true)
    if dist > mRand(20, 60) then return false end
    if self:IsBusy("Activities") then return false end
    self:StopMoving()
    self:ClearSchedule()

    if istable(self.PlyPickUpAnim) then
        local pickUpAnim = table.Random(self.PlyPickUpAnim)
        local seq = self:LookupSequence(pickUpAnim)
        local animT = self:SequenceDuration(seq)

        if animT and animT > 0 then
            self:RemoveAllGestures()
            self:PlayAnim("vjseq_" .. pickUpAnim, true, animT, false)
            self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, animT)
        end
    end
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
    if self.IsGuard or self.MovementType == VJ_MOVETYPE_STATIONARY then return end 
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

    local anim;
    if self.PlyPickUpAnim and self.PlyPickUpAnim ~= "" then
        if istable(self.PlyPickUpAnim) then 
            anim = table.Random(self.PlyPickUpAnim)
        elseif isstring(self.PlyPickUpAnim) then
            anim = self.PlyPickUpAnim
        end
    end

    local seq = self:LookupSequence(anim)
    if not seq or seq < 0 then return end 

    local animT = self:SequenceDuration(seq) or 1 

    local rngSnd = mRng(85,105)
    local snd = table.Random(self.DrawNewWeaponSound)

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

    if snd then VJ.EmitSound(self, snd, 70, rngSnd) end
    return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- DOOR STACKING? MAYBE HAVE IT SO THEY ONLY DO BREAK DOOR IF ALLY IS WITHIN X RANGE?
-- Add tolerance or smthing for 45 degeess
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

    if busy or self:IsMoving() or self.IsFollowing or 
       self:GetWeaponState() == VJ.WEP_STATE_RELOADING or self.WeaponAttackState == VJ.WEP_ATTACK_STATE_FIRE_STAND or self.Flinching then
        return 
    end
    
    if curT > self.NextBreakDownDoorT then
        if not IsValid(self.BreakDoor) then
            for _, v in pairs(ents.FindInSphere(self:GetPos(), 100)) do
                if v:GetClass() == "func_door_rotating" and v:Visible(self) then
                    if v:GetInternalVariable("m_bLocked") or (eneVisAlert) then
                        self.BreakDoor = v
                    end
                elseif v:GetClass() == "prop_door_rotating" and v:Visible(self) then
                    local anim = string.lower(v:GetSequenceName(v:GetSequence()))
                    if (string.find(anim, "idle") or string.find(anim, "locked")) and 
                       (v:GetInternalVariable("m_bLocked") or (eneVisAlert)) then
                        self.BreakDoor = v
                        break
                    end
                end
            end
        else
            if self:IsBusy() or not IsValid(self.BreakDoor) or not self.BreakDoor:Visible(self) then
                self.BreakDoor = NULL
                return
            end
            
            if self:GetActivity() ~= ACT_MELEE_ATTACK1 and not self:IsBusy("Activites") then 
                local ang = self:GetAngles()

                self:RemoveAllGestures()
                self:ClearSchedule()
                self:SetTurnTarget(self.BreakDoor)
                VJ.STOPSOUND(self.CurrentIdleSound)

                timer.Simple(mRand(0.65, 0.95), function()
                    if not IsValid(self) or not IsValid(self.BreakDoor) or self.Dead then 
                        self.BreakDoor = NULL
                        return 
                    end
                
                    local enemy = self:GetEnemy()
                    if IsValid(enemy) and self:Visible(enemy) and self:GetPos():DistToSqr(enemy:GetPos()) <= (800 * 800) then
                        self.BreakDoor = NULL
                        return
                    end
                
                    local desiredYaw = (self.BreakDoor:GetPos() - self:GetPos()):Angle().y
                    local currentYaw = self:GetAngles().y
                    local yawDiff = math_abs(math.AngleDifference(currentYaw, desiredYaw))
                    if yawDiff > 15 then
                        self.BreakDoor = NULL
                        return
                    end

                    local rngSnd = mRng(85, 105)
                    local rngVol = mRng(60, 75)
                    VJ.EmitSound(self, table.Random({"npc/metropolice/gear" .. mRng(1, 6) .. ".wav"}), rngVol, rngSnd)

                    local kickAnim = table.Random(self.KickDownDoorAnims)
                    local seq = self:LookupSequence(kickAnim)

                    if seq and seq > 0 then
                        local kickT = self:SequenceDuration(seq) or 1 
                    end 

                    local teleSnd = table.Random({self.SoundTbl_Suppressing, self.SoundTbl_BeforeMeleeAttack})
                    if kickAnim then 
                        self:PlayAnim("vjseq_" .. kickAnim, true, kickT, false)
                        self:SetState(VJ_STATE_ONLY_ANIMATION, kickT)
                        if teleSnd and mRng(1, 2) == 1 then 
                            VJ.EmitSound(self, teleSnd, rngVol, rngSnd)
                        end 
                    end 
                    
                    local doorBreak = table.Random({"general_sds/doorbreak/doorbust1", "general_sds/doorbreak/doorbust2","ambient/materials/door_hit1.wav"})
                    local woodBreak = table.Random({"physics/wood/wood_crate_break" .. mRng(1, 5) .. ".wav"})
                    local furnBreak = table.Random({"physics/wood/wood_furniture_break" .. mRng(1, 2) .. ".wav"})
                    local door = self.BreakDoor
                
                    if IsValid(door) and door:GetClass() == "prop_door_rotating" then
                        VJ.EmitSound(self, doorBreak .. ".wav", rngVol, rngSnd)
                        VJ.EmitSound(door, woodBreak, rngVol, rngSnd)
                        if mRng(1, 2) == 1 and IsValid(self) then 
                            VJ.EmitSound(door, furnBreak, rngVol, rngSnd)
                        end
                        
                        local dAng = door:GetAngles()
                        local dPos = door:GetPos() 

                        ParticleEffect("door_explosion_chunks", dPos, dAng, nil)
                        ParticleEffect("door_pound_core", dPos, dAng, nil)
                        door:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
                        door:SetSolid(SOLID_NONE)
                
                        local visMaxDist = self.DoorBreakPlyVisMaxDist or 500
						for _,ply in ipairs(player.GetAll()) do 
							if ply:GetPos():Distance(door:NearestPoint(ply:GetPos())) <= visMaxDist and not VJ_CVAR_IGNOREPLAYERS and self.DoorBreakPlyVisFx then
								ply:ViewPunch(Angle(mRand(-360, 360), mRand(-360, 360), mRand(-360, 360)))
							end
                        end
                        
                        local brokenDoorProp = ents.Create("prop_physics")
						brokenDoorProp:PhysicsInit(SOLID_VPHYSICS)
						brokenDoorProp:SetMoveType(MOVETYPE_VPHYSICS)
						brokenDoorProp:SetCollisionGroup(COLLISION_GROUP_WEAPON)

                        brokenDoorProp:SetModel(door:GetModel())
                        brokenDoorProp:SetPos(dPos + VectorRand(-15, 15) * Vector(1, 1, 0) + Vector(0, 0, mRand(5, 10)))
                        brokenDoorProp:SetAngles(door:GetAngles())
                        brokenDoorProp:SetModelScale(0.95)
                        brokenDoorProp:Spawn()
                        brokenDoorProp:Activate()
                        brokenDoorProp:SetSkin(door:GetSkin())
                
                        local phys = brokenDoorProp:GetPhysicsObject()
                        if IsValid(phys) then
                            local dir = (door:GetPos() - self:GetPos()):GetNormalized()
                            local force = dir * 15000 + Vector(0, 0, 250)
                            timer.Simple(0.05, function()
                                if IsValid(phys) then
                                    phys:ApplyForceCenter(force)
                                end
                            end)
                        end
                        self.NextBreakDownDoorT = curT + mRand(4.5, 10)
                        door:Remove()
                    else
                    end
                end)
            end
        end
    end
    if not IsValid(self.BreakDoor) then
        self:SetState()
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
    if self.IncapAnimsInitialized then return end

    timer.Simple(0.1, function()
        if not IsValid(self) or self.IncapAnimsInitialized then return end

        local animSet = self.IncapAnimSets[mRng(1, #self.IncapAnimSets)]
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
    local conv = GetConVar("vj_stalker_incapacitated"):GetInt()
    if not IsValid(self) or conv ~= 1 or self.VJ_IsBeingControlled then 
        return false 
    end 
    local busy =  self:IsVJAnimationLockState()  or self:IsBusy()
    if self.IncapCounter >= self.IncapAmount or self.NeverBecomeIncappedAgain then
        print("Cannot be incapacitated anymore.")
        return false
    end

    if busy or self.Flinching or self.Medic_Status or not self:IsOnGround() or not IsValid(self) or self:IsOnFire() or not self.CanBecomeIncapicitated or self.PlayingAttackAnimation or self:IsMoving() or self:GetWeaponState() == VJ.WEP_STATE_RELOADING then 
        return  
    end 

    local lowHp = mRand(0.2,0.33)
    local hp = self:Health()
    if hp < (self:GetMaxHealth() * lowHp) and IsValid(self) and not busy then
        self:StopMoving()
        self:ClearSchedule()
        self:PlayIncapAnimIntro()
        self:StopAttacks(true)
        self:SetState()
    end
end

function ENT:PlayIncapAnimIntro()
    local busy =  self:IsVJAnimationLockState()  or self:IsBusy() or self:IsBusy("Activities")
    if self.PlayingIncapAnim or self.NowIdleIncap then return end 

    if not self.IncapAnimsInitialized or not self.BecomeIncappedAnim then
        print("Incap animations not yet initialized, deferring incapacitation...")
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
    print("Incapacitation count: " .. self.IncapCounter)

    if self.IncapCounter >= self.IncapAmount then
        self.NeverBecomeIncappedAgain = true
        print("Reached maximum incap limit. Cannot become incapacitated again.")
    end
    
    local becomeIncapSeq = self:LookupSequence(self.BecomeIncappedAnim)
    if becomeIncapSeq == -1 then
        print("Invalid BecomeIncappedAnim sequence: " .. self.BecomeIncappedAnim)
        self.IsCurrentlyIncapacitated = false
        self.NowIdleIncap = false
        return
    end

    if busy then return false end 
    local anim = self.BecomeIncappedAnim or ""
    local animT = VJ.AnimDuration(self, anim) or 2 
    local playedAnim = self:PlayAnim("vjseq_" .. anim, true, animT, false)
    if playedAnim then
        self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, animT + 0.01)
        self.PlayingIncapAnim = true 
        print("Playing animation for " .. animT .. " seconds.")
        self:RemoveAllGestures()
        self:PlaySoundSystem("Speech", self.SoundTbl_Pain)

        timer.Simple(VJ.AnimDuration(self, self.BecomeIncappedAnim), function()
            if IsValid(self) then
                self.PlayingIncapAnim = false 
                print("Animation finished. Now entering incapacitated idle state.")
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
    local anim = self.IncapicitatedIdleAnim
    if anim then 
        self:SetIncapVars()
        self:PlayAnim("vjseq_" .. self.IncapicitatedIdleAnim, true,  VJ.AnimDuration(self, self.IncapicitatedIdleAnim), false)
        self:SetState(VJ_STATE_ONLY_ANIMATION, incapIdleDur)
        timer.Simple(incapIdleDur, function()
            if IsValid(self) then
                self:LoopIncapIdleAnim(incapIdleDur) 
            end
        end)
    end 
end

function ENT:CheckToRecoverFromIncap()
    local hp = self:Health()
    local maxHp = self:GetMaxHealth()
    if self.IsCurrentlyIncapacitated and self.NowIdleIncap and hp > (maxHp* 0.5) then
        self.NowIdleIncap = false
        timer.Remove("IdleLoopTimer_" .. self:EntIndex())
        self:PlayRecoverFromIncapAnim()
    end
end

function ENT:PlayRecoverFromIncapAnim()
    if not self.IsCurrentlyIncapacitated or self.PlayingRecoverAnim then return end

    local recoverSeq = self:LookupSequence(self.RecoverFromIncapAnim)
    if recoverSeq == -1 then
        print("Invalid RecoverFromIncapAnim sequence: " .. self.RecoverFromIncapAnim)
        return
    end
    local recoverAnim = self.RecoverFromIncapAnim
    local recoverDur = VJ.AnimDuration(self, recoverAnim) or 1 
    local playedAnim = self:PlayAnim("vjseq_" .. recoverAnim, true, recoverDur, false)
    if playedAnim then
        self.IsCurrentlyIncapacitated = false
        self.PlayingRecoverAnim = true
        self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, recoverDur)
        self:RemoveAllGestures()
        self:PlaySoundSystem("Speech", self.SoundTbl_MedicReceiveHeal)

        timer.Simple(recoverDur, function()
            if IsValid(self) then
                self:SetState()
                self:ResetIncapVars()
                self.PlayingRecoverAnim = false
                print("Recover animation finished. SNPC is now back to active state.")
            end
        end)
    else
        print("Failed to play RecoverFromIncapAnim.")
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
        //self.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
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

function ENT:ResetIncapVars()
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
    if not IsValid(self) or self.VJ_IsBeingControlled or  self:IsVJAnimationLockState()  then 
        return  
    end 
    
    if self.IsCurrentlyDeployingAFlare then 
        return 
    end

    if cT < (self.CombatFlareDeployT or 0) then 
        return 
    end

    local enemy = self:GetEnemy()
    if not IsValid(enemy) or not self:IsOnGround() or self:WaterLevel() > 0 or self:IsMoving() or self:IsBusy() or self:GetWeaponState() == VJ.WEP_STATE_RELOADING then
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

    local deployChance = self.DeployCombatFlareChance
    local distanceToEnemy = self:GetPos():Distance(enemy:GetPos())
    if (distanceToEnemy < 2500 and enemy:Visible(self)) or self:IsBusy() then 
        self.CombatFlareDeployT = cT + mRand(1, 5)
        return 
    end

    if not self.FlareDeployAttemptCheck then
        self.FlareDeployAttemptCheck = true
        if mRng(1, deployChance) ~= 1 then 
            self.CombatFlareDeployT = cT + mRand(150, 300)  
            return 
        end
    end

    self.IsCurrentlyDeployingAFlare = true

    local anim;
    if self.PlaceFlareAnimation and self.PlaceFlareAnimation ~= "" then 
        if istable(self.PlaceFlareAnimation) then 
            anim = table.Random(self.PlaceFlareAnimation) 
        elseif isstring(self.PlaceFlareAnimation) then 
            anim = self.PlaceFlareAnimation 
        end 
    end 

    local seq = self:LookUpSequence(anim)
    if not seq or seq < 0 then return end 

    local aT = self:SequenceDuration(seq) or 1 
    local spwnDel =mRand(0.45, 0.65)
    self:PlayAnim("vjseq_" .. seq, true, aT, false)
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
    
    local move = "TASK_RUN_PATH"
    local delT = mRand(1, 5)
    timer.Simple(aT, function()
        if IsValid(self) then
            self.IsCurrentlyDeployingAFlare = false
            if mRng(1, 2) == 1 then
                timer.Simple(mRand(0.5, 1.25), function()
                    if IsValid(self) and IsValid(self:GetEnemy()) and self.RetreatAfterDeployFlare then
                        self:StopMoving()
                        self:SCHEDULE_COVER_ENEMY(move, function(x)
                            x.CanShootWhenMoving = true
                            x.TurnData = {Type = VJ.FACE_ENEMY}
                        end)
                        self.NextDoAnyAttackT = cT + delT
                    end
                end)
            end
        end
    end)

    self.NextFireQuickFlareT = cT + mRand(25, 45)
    self.CombatFlareDeployT = cT + mRand(350, 650)
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Distress_SigAnim = true 
ENT.Distress_Sig_Chance = 2 
ENT.Distress_SigNextT = 0 
ENT.Distress_SigRange = 2000
function ENT:DistressOnCloseProximity()
    if not self.Panic_FleeEneProx then return end 
    if self.VJ_IsBeingControlled then return end
    if not self:IsOnGround() then return end 
    if self:IsOnFire() then return end 
    local ene = self:GetEnemy()
    local curT1 = CurTime()

    if not IsValid(ene) or not self:Visible(ene) or self:IsUnreachable(ene) then return end
    if self:IsBusy() or curT1 < self.NextPanicOnCloseProxT or self.IsGuard then return end

    local distToEnemy = self:GetPos():Distance(ene:GetPos())
    if distToEnemy >= self.CloseProxPanicDist then return end

    local allyDetectRange = self.Panic_DetectAllyRange or 1500
    local nearbyAllies = self:Allies_Check(allyDetectRange) or {}
    local allyCount = #nearbyAllies
    local isAlone = self.IsCurrentlyAlone or false
    local gesAnim = "vjges_" .. VJ.PICK(self.DetectDangerReactAnim)
    local sigChance = self.Distress_Sig_Chance or 3
    local signalRange = tonumber(self.Distress_SigRange) or 2500
    local nearbySignalAllies = self:Allies_Check(signalRange) or {}
    local chance = self.Panic_FleeEneChance or 3 

    print("Enemy too close! Distance: " .. distToEnemy)
    print("Nearby allies detected: " .. allyCount)
    print("Is currently alone? " .. tostring(isAlone))

    local shouldPanic = true
    local panicCooldown = mRand(5, 35) -- Default

    if mRng(1, chance) ~= 1 then 
        self.NextPanicOnCloseProxT = curT1 + mRand(5, 15)
        return 
    end

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
        panicCooldown = mRand(5, 10)
    end

    if not shouldPanic then return false end

    local curT = CurTime()
    self.NextChaseTime = curT + mRand(1, 10)
    self.TakingCoverT = curT + mRand(1, 5)
    self.NextPanicOnCloseProxT = curT + panicCooldown
    
    if mRng(1, 2) == 1 then 
        self:PlaySoundSystem("CallForHelp")
    end 

    if self.Distress_SigAnim and #nearbySignalAllies > 0 and curT > (self.Distress_SigNextT or 0) then
        if mRng(1, sigChance) == 1 then
            if gesAnim then 
                self:PlayAnim(gesAnim, true)
            end 
            self.Distress_SigNextT = curT + mRand(10, 20) 
            print("Playing distress signal animation due to nearby allies.")
        end
    end

    self:ClearSchedule()
    self:StopMoving()
    local move = "TASK_RUN_PATH"
    self:SCHEDULE_COVER_ORIGIN(move, function(x)
        x.CanShootWhenMoving = true
        x.TurnData = {Type = VJ.FACE_ENEMY}
    end)

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
        if disp == D_LI and flashBlindFri and not (self.Alerted or IsValid(ene) or inCombat) then
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
ENT.IsAlone_VJEneConv = "vj_stalker_lm_tr_vj_creature"
function ENT:IfSelfIsLoneMember()
    if not self.HasAloneAiBehaviour or self.VJ_IsBeingControlled then return end
    if not self.CanAlly then return end 
    local allyCheckDist = self.FindAllyDistance or 3000
    local allies = self:Allies_Check(allyCheckDist)
    local ene = self:GetEnemy()

    if self.IsAlone_VJEneConv then
        local convVar = GetConVar(tostring(self.IsAlone_VJEneConv))
        if convVar then
            local conv = convVar:GetInt()
            if IsValid(ene) and ene.IsVJBaseSNPC_Creature and conv ~= 1 then
                return
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
 -- [Current bugs] -- 
 // SNPC's bone's resetting can be delayed
 // SNPCS stay leaning, despite them moving around/not resetting properly sometimes. 
 // Leaning can stack??? Uncommon cases of SNPCs sometimes leaning, but would lean again, with their bone manipulation getting worse?
 // SNPCs can leave the spot they were leaning from with their bones still manipulated and not resetted.
 // SNPCs lean for no reason. E.g, snpc is far away or on a high surface. 

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

local ZERO_ANGLE = Angle(0,0,0)

local BONE_PELVIS = "ValveBiped.Bip01_Pelvis"
local BONE_SPINE  = "ValveBiped.Bip01_Spine"
local BONE_SPINE1 = "ValveBiped.Bip01_Spine1"

function ENT:ResetLean()
    local cT = CurTime()
    self.CurrentlyLeaning   = false
    self.TargetLeanAngle    = ZERO_ANGLE
    self.CurrentLeanAngle   = ZERO_ANGLE
    self.LeanOriginPos      = nil
    self.LastStateChange    = cT
    self.LeanCooldownUntil  = cT + mRand(2.5, 6.5)

    local pelvis = self:LookupBone(BONE_PELVIS)
    local spine  = self:LookupBone(BONE_SPINE)
    local spine1 = self:LookupBone(BONE_SPINE1)

    if pelvis then self:ManipulateBoneAngles(pelvis, ZERO_ANGLE) end
    if spine  then self:ManipulateBoneAngles(spine,  ZERO_ANGLE) end
    if spine1 then self:ManipulateBoneAngles(spine1, ZERO_ANGLE) end
end

function ENT:CheckLeanReset()
    if not self.CurrentlyLeaning then return end

    local enemy = self:GetEnemy()
    local pos   = self:GetPos()

    if not IsValid(enemy)
    or self:IsMoving()
    or not self:IsOnGround()
    or self:GetWeaponState() == VJ.WEP_STATE_RELOADING
    or self:GetActivity() == ACT_RUN
    or self:GetActivity() == ACT_WALK then
        self:ResetLean()
        return
    end

    if self.LeanOriginPos and pos:DistToSqr(self.LeanOriginPos) > 25^2 then
        self:ResetLean()
        return
    end

    if math_abs(enemy:GetPos().z - pos.z) > 120 then
        self:ResetLean()
        return
    end

    if pos:Distance(enemy:GetPos()) < 300 and self:Visible(enemy) then
        self:ResetLean()
        return
    end
end

function ENT:ContextToLean()
    self:CheckLeanReset()
    local cT = CurTime()
    if GetConVar("vj_stalker_can_lean"):GetInt() ~= 1 then return end
    if self.VJ_IsBeingControlled or not self.CanWeLean then return end
    if self.LeanCooldownUntil > cT then return end
    if self:IsMoving() then return end

    local wep = self:GetActiveWeapon()
    if not IsValid(wep) then return end

    if not self.CurrentlyLeaning
    and cT > self.NextLeanTime
    and cT > self.TakingCoverT then
        self:CustomLean()
    end

    self.CurrentLeanAngle = LerpAngle(
        self.LeanTransitionSpeed,
        self.CurrentLeanAngle,
        self.TargetLeanAngle
    )

    self.CurrentLeanAngle.p = math_Clamp(self.CurrentLeanAngle.p, -18, 18)
    self.CurrentLeanAngle.y = math_Clamp(self.CurrentLeanAngle.y, -22, 22)
    self.CurrentLeanAngle.r = math_Clamp(self.CurrentLeanAngle.r, -12, 12)

    local pelvis = self:LookupBone(BONE_PELVIS)
    local spine  = self:LookupBone(BONE_SPINE)
    local spine1 = self:LookupBone(BONE_SPINE1)

    local a = self.CurrentLeanAngle

    if pelvis then
        self:ManipulateBoneAngles(
            pelvis,
            Angle(0, -a.y * 0.25, -a.r * 0.25)
        )
    end

    if spine then
        self:ManipulateBoneAngles(
            spine,
            Angle(a.p * 0.6, a.y * 0.6, a.r * 0.6)
        )
    end

    if spine1 then
        self:ManipulateBoneAngles(
            spine1,
            Angle(a.p * 0.4, a.y * 0.4, a.r * 0.4)
        )
    end
end

function ENT:CustomLean()
    local enemy = self:GetEnemy()
    if not IsValid(enemy) then return end
    if self:IsMoving() then return end

    local pos = self:GetPos()
    local traceStart = pos + self:OBBCenter()

    local tr = util.TraceLine({
        start  = traceStart,
        endpos = enemy:GetPos() + enemy:OBBCenter(),
        filter = { self }
    })

    if not tr.HitWorld and not IsValid(tr.Entity) then
        if self.CurrentlyLeaning then
            self:ResetLean()
        end
        return
    end

    local right = mRand(18, 28)
    local up    = 45

    local trR = util.TraceLine({
        start  = traceStart + self:GetRight() * right + self:GetUp() * up,
        endpos = enemy:GetPos() + enemy:OBBCenter(),
        filter = { self }
    })

    local trL = util.TraceLine({
        start  = traceStart + self:GetRight() * -right + self:GetUp() * up,
        endpos = enemy:GetPos() + enemy:OBBCenter(),
        filter = { self }
    })

    local newAngle = ZERO_ANGLE
    local newState = false

    if trR.Entity == enemy then
        newAngle = Angle(12, 20, 6)
        newState = true
    elseif trL.Entity == enemy then
        newAngle = Angle(-12, -20, -6)
        newState = true
    end
    local cT = CurTime()
    if newState and cT - self.LastStateChange > self.StateChangeDelay then
        self.CurrentlyLeaning = true
        self.TargetLeanAngle  = newAngle
        self.LeanOriginPos    = pos
        self.LastStateChange  = cT
        self.NextLeanTime     = cT + mRand(2, 6)
        self:SetTurnTarget("Enemy")
        self:StopMoving()
    elseif self.CurrentlyLeaning and not newState then
        self:ResetLean()
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SeekOutMedic()
    if not IsValid(self) then return end
    if self.VJ_IsBeingControlled or self.IsGuard or self.Dead or self.IsMedic or self:IsOnFire() then
        return 
    end

    local cT = CurTime()
    local ene = self:GetEnemy()

    if not self.CanSeekOutMedic or IsValid(ene) or self:IsBusy() or cT < (self.NextMedicSeekT or 0) then
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
        self.CurrentMedicTarget = nearestMedic
        self.NextMedicSeekT = cT + cool

        if nearestDistSqr > noMoveDistSqr and nearestDistSqr > stopDistSqr then
            self:SetTurnTarget(nearestMedic)
            self:ClearSchedule()
            self:StopMoving()
            local randFnInt = mRng or mRng
            local offsetX = (randFnInt(-60, 60))
            local offsetY = (randFnInt(-60, 60))
            local targetPos = nearestMedic:GetPos() + nearestMedic:GetForward() * offsetX + nearestMedic:GetRight() * offsetY
            self:SetLastPosition(targetPos)
            self:SCHEDULE_GOTO_POSITION(VJ.PICK({"TASK_RUN_PATH", "TASK_WALK_PATH"}), function(x)
                x.CanShootWhenMoving = true
                x.TurnData = {Type = VJ.FACE_ENEMY}
            end)
        end
    else
        self.CurrentMedicTarget = nil
    end
    return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.PlyFlash_Aware = true
ENT.PlyFlash_CntctDist = 500
ENT.PlyFlash_AlrAlerted = false 
ENT.PlyFlash_CheckInterval = 0.35
ENT.PlyFlash_NextCheck = 0
function ENT:PlyFlash_IdleAlert()
    local conv = GetConVar("vj_stalker_ply_flashlight_alert"):GetInt()
    if not self.PlyFlash_Aware or not IsValid(self) then return end
    if conv ~= 1 then return false end 
    local curT = CurTime()
    if self.PlyFlash_NextCheck and curT < (self.PlyFlash_NextCheck or 0) then return false end
    self.PlyFlash_NextCheck = curT + (self.PlyFlash_CheckInterval or 0.35)
    local ene = self:GetEnemy()
    if not IsValid(self) or IsValid(ene) or self.Alerted or self:IsBusy("Activities") or (self:GetNPCState() ~= NPC_STATE_IDLE and not self.PlyFlash_AlrAlerted) then
        return
    end
    if self.VJ_IsBeingControlled or VJ_CVAR_IGNOREPLAYERS then return false end 
    local plyAll = player.GetAll()
    local plyFlshDist = tonumber(self.PlyFlash_CntctDist) or 800 
    local traceFunc = util.TraceLine
    for _, ply in ipairs(plyAll) do
        if IsValid(ply) and ply:Alive() and ply:FlashlightIsOn() then
            local plyEyePos = ply:GetShootPos() or ply:EyePos()
            local plyAimVec = ply:GetAimVector()
            local targetPos = self:WorldSpaceCenter()
            local dirToNPC = (targetPos - plyEyePos):GetNormalized()

            local dist = plyEyePos:Distance(targetPos)
            if dist > plyFlshDist then continue end

            local dirToNPC = (targetPos - plyEyePos):GetNormalized()
            local dot = plyAimVec:Dot(dirToNPC)

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
                    if self.PlyFlash_Aware then
                        local disp = self:Disposition(ply) 
                        if (disp ~= D_LI and disp ~= D_NU and disp ~= D_FR) and IsValid(ply) then 
                            local grenDelay = 2
                            if self:GetEnemy() ~= ply then 
                                print("Player flashlight detected!, ply hostile: ", ply:GetName())
                                self:ClearSchedule()
                                self:SetEnemy(ply, true)
                                self:UpdateEnemyMemory(ply, ply:GetPos())
                                self:ForceSetEnemy(ply, ply:GetPos())
                                if self:GetNPCState() ~= NPC_STATE_COMBAT then
                                    self:SetNPCState(NPC_STATE_ALERT)
                                end
                                self.EnemyData.Target = ply 
                                self:StopMoving()
                                self.PlyFlash_AlrAlerted = true
                                self.self.NextDoAnyAttackT = CurTime() + grenDelay 
                                timer.Simple(10, function() 
                                    if IsValid(self) then 
                                        self.PlyFlash_AlrAlerted = false 
                                    end 
                                end)
                                return true
                            end
                        end
                    end
                end 
            end
        end
    end 
    return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
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
        local snd = table.Random({self, "npc/zombie/foot_slide" .. mRng(1, 3) .. ".wav"})
         if self.Leg_ShuffleSnd and  mRng(1, 2) == 1 then 
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
function ENT:OnThink()
    self:Marine_TurnGestures()
end

function ENT:OnThinkActive()
    self:PlyFlash_IdleAlert()
    self:CheckFlashlightReaction()
    self:StealthMovement()
    self:CopyPlayerStance()
    self:IdleIncap_LastChanceGren()
    self:SeekOutMedic()
    self:HitWallWhenShoved()
    //self:CustomLean()
    self:ContextToLean()
    self:CheckLeanReset()
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
        if self.RANDOMS_DEBUG then print("Ene is looking at me! Cancelling s-heal.") end
        return false
    end

    if self.IsMedic and self.Medic_CheckDistance <= 1 and self.Medic_PrioritizeAlly then
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

    if busy or self.Flinching or moving or not ground or
       self:IsOnFire() or self.Medic_Status or self:Health() >= maxHp * 0.99 then
        return false
    end

    local coverDelay = 0
    local move = "TASK_RUN_PATH"
    if enemyValid and self.FindCov_PriorSH then
        self:SCHEDULE_COVER_ENEMY(move, function(x)
            x.CanShootWhenMoving = true
            x.TurnData = {Type = VJ.FACE_ENEMY}
        end)
        coverDelay = mRand(1.5, 3.5) 
    elseif mRng(1, 2) == 1 then
        self:SCHEDULE_COVER_ORIGIN(move, function(x)
            x.CanShootWhenMoving = true
            x.TurnData = {Type = VJ.FACE_ENEMY}
        end)
        coverDelay = mRand(1, 2.5)
    end

    self.CurrentlyHealSelf = true
    local initiateDelay = (self.HealSelfDelay or mRand(1, 5)) + coverDelay

    if not self:Alive() then return end 
    timer.Simple(initiateDelay, function()
        if not IsValid(self) then return end

        local curT2 = CurTime()
        local ground2 = self:IsOnGround()
        local moving2 = self:IsMoving()
        local busy2 =  self:IsVJAnimationLockState()  or self:IsBusy() or self:GetWeaponState() == VJ.WEP_STATE_RELOADING
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

        local anim 

        if self.HealSelf_AnimTbl then
            if isstring(self.HealSelf_AnimTbl) then
                anim = self.HealSelf_AnimTbl
            elseif istable(self.HealSelf_AnimTbl) and #self.HealSelf_AnimTbl > 0 then
                anim = table.Random(self.HealSelf_AnimTbl)
            end
        end

        if not anim then return end
        local seq = self:LookupSequence(anim)
        if seq <= 0 then return end

        local animT = self:SequenceDuration(seq) or 1
        local rngSnd = mRng(75, 105)
        local halfAnim = animT / 2

        if anim then 
            self:PlayAnim("vjseq_" .. anim, true, animT, false)
            self:SetState(VJ_STATE_ONLY_ANIMATION_CONSTANT, animT)
        end 

        timer.Simple(halfAnim, function()
            if not IsValid(self) then return end
            if not moving2 and ground2 then
                local healAmount = self.Medic_HealAmount or 30
                local chance = self.SelfHeal_FailChance or 15
                if mRng(1, chance) == 1 and self.SelfHeal_Fail then
                    healAmount = maxHp * 0.25
                end
                local newHealth = math_Clamp(self:Health() + healAmount, 0, maxHp)
                self:SetHealth(newHealth)
                self:OnMedicBehavior("OnHeal")
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
    local propRemoveT = 0.85
    if not IsValid(self) or not self.CurrentlyHealSelf then return end

    local validAttachmentName = nil
    local attachmentData = nil

    for _, attName in ipairs(self.SelfHeal_HandAtt) do
        local attachmentIndex = self:LookupAttachment(attName)
        print("Checking:", attName, "Index:", attachmentIndex) 
        if attachmentIndex and attachmentIndex > 0 then
            validAttachmentName = attName
            attachmentData = self:GetAttachment(attachmentIndex)
            break 
        end
    end

    if not validAttachmentName and isstring(self.Medic_SpawnPropOnHealAttachment) and self.Medic_SpawnPropOnHealAttachment ~= "" then
        local medAttIndex = self:LookupAttachment(self.Medic_SpawnPropOnHealAttachment)
        print("Checking Medic_SpawnPropOnHealAttachment:", self.Medic_SpawnPropOnHealAttachment, "Index:", medAttIndex) 
        if medAttIndex and medAttIndex > 0 then
            validAttachmentName = self.Medic_SpawnPropOnHealAttachment
            attachmentData = self:GetAttachment(medAttIndex)
        end
    end

    if not validAttachmentName or not attachmentData then
        return
    end

    if not self.CurrentlyHealSelf then
        return
    end

    local healItem = ents.Create("prop_vj_animatable")
    healItem:SetModel("models/healthvial.mdl")
    healItem:SetPos(attachmentData.Pos)
    healItem:SetAngles(attachmentData.Ang)
    healItem:SetParent(self)
    healItem:Fire("SetParentAttachment", validAttachmentName)
    healItem:Spawn()
    healItem:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    healItem:SetSolid(SOLID_NONE)
    healItem:SetRenderMode(RENDERMODE_TRANSALPHA)
    self:DeleteOnRemove(healItem)
    SafeRemoveEntityDelayed(healItem, propRemoveT)

    timer.Simple(propRemoveT, function()
        if IsValid(self) then
            local dropVial = ents.Create("prop_physics")
            dropVial:SetModel("models/healthvial.mdl")
            dropVial:SetPos(attachmentData.Pos + Vector(0, 0, 10))
            dropVial:SetAngles(attachmentData.Ang)
            dropVial:Spawn()
            dropVial:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
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
        eneEyePos = (ene.EyePos and ene:EyePos()) or (ene.GetPos and (ene:GetPos() + (ene.OBBCenter and ene:OBBCenter() or Vector(0,0,48)))) or ene:GetPos()
    end

    local eneForward = (ene.IsPlayer and ene:IsPlayer()) and (ene:EyeAngles():Forward()) or ((ene.GetForward and ene:GetForward()) or Vector(0,0,1))
    local myEyePos = (self.EyePos and self:EyePos()) or (self.GetPos and (self:GetPos() + (self.OBBCenter and self:OBBCenter() or Vector(0,0,36)))) or self:GetPos()
    local toSelf = (myEyePos - eneEyePos)

    if toSelf:IsZero() then
        toSelf = (self:GetPos() - eneEyePos)
    end
    toSelf:Normalize()

    local viewDot = eneForward:Dot(toSelf)
    local enemyLookingAtSelf = (viewDot >= viewDotThreshold)

    if self.RANDOMS_DEBUG then
        print(("LOS viewDot=%.3f | threshold=%.2f | enemyLooking=%s"):format(viewDot, viewDotThreshold, tostring(enemyLookingAtSelf)))
    end

    return enemyLookingAtSelf
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HumanEvadeAbility()
    if not self.CombatEvade then return end
    local conv = GetConVar("vj_stalker_dodging"):GetInt()
    if conv ~= 1 or not IsValid(self) or self.VJ_IsBeingControlled then 
        return  
    end 

    local minEneDist = self.Dodge_EneMin_Dist or 700
    local maxEneDist = self.Dodge_EneMax_Dist or 6000 
    local busy = self:IsBusy() or  self:IsVJAnimationLockState() 
    local ene = self:GetEnemy()
    local right, forward, up = self:GetRight(), self:GetForward(), self:GetUp()
    local rollFrwdMax = self.Dodge_RollF_MxDist or 1250
    local rngSnd = mRng(85, 105)

    if busy or self.IsGuard or self:Health() < (self:GetMaxHealth() * mRand(0.2,0.33)) or not IsValid(ene) or self.CurrentlyLeaning then
        return false
    end
    
    if not self:InEneLineOfSight(enemy, 0.7) then
        if self.RANDOMS_DEBUG then print("Not in ene sight, no need to dodge") end
        return false
    end

    local distToEnemy = self:GetPos():Distance(ene:GetPos())
    if distToEnemy <= minEneDist or distToEnemy >= maxEneDist then return end

    local pos = self:GetPos() + self:OBBCenter()
    local inCover = self:DoCoverTrace(pos, eneEyePos, false, {SetLastHiddenTime = true})
    if inCover then return end
    local cT = CurTime()
    if IsValid(ene) and not cT < self.TakingCoverT and self:Visible(ene) and not self.Flinching and self.WeaponAttackState == VJ.WEP_ATTACK_STATE_FIRE_STAND and cT > self.Dodge_NextT and not self:IsMoving() and self:IsOnGround() and not self.IsHumanDodging and not self.IsEvadingDanger and not busy then
        self:StopAttacks(true)
        self.IsHumanDodging = true
        self.Dodge_NextT = cT + mRand(5, 35)

        local DodgeDirection2 = self.CombatRoll and mRng(1, 3) or mRng(4, 7)
        print("Dodge type chosen: " .. DodgeDirection2 .. " | CombatRoll: " .. tostring(self.CombatRoll))

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

        local tr = util.TraceHull({
            start = self:GetPos(),
            endpos = self:GetPos() + dir * mRng(200, 300),
            mins = self:OBBMins(),
            maxs = self:OBBMaxs(),
            filter = self
        })

        if not tr.Hit then
            -- Unique combat rolls
            if DodgeDirection2 == 1 and distToEnemy > rollFrwdMax then
                DodgeAnim = "roll_forward"
                DodgeVel = (forward * mRand(700, 1050)) + up * mRand(60, 80)
            elseif DodgeDirection2 == 2 then
                DodgeAnim = "roll_right"
                DodgeVel = (right * mRand(700, 1050)) + up * mRand(60, 80)
            elseif DodgeDirection2 == 3 then
                DodgeAnim = "roll_left"
                DodgeVel = (right * mRand(-700, -1050)) + up * mRand(60, 80)

            -- Default dodge anims 
            elseif DodgeDirection2 == 4 and not meleeWeapon then
                DodgeAnim = DupDodgeAnim
                DodgeVel = (right * mRand(-500, -900)) + up * mRand(60, 80)
            elseif DodgeDirection2 == 5 and not meleeWeapon then
                DodgeAnim = DupDodgeAnim
                DodgeVel = (forward * mRand(-500, -900)) + up * mRand(80, 70)
            elseif DodgeDirection2 == 6 and not meleeWeapon then
                DodgeAnim = DupDodgeAnim
                DodgeVel = (right * mRand(-500, -800)) + up * mRand(80, 70)
            elseif DodgeDirection2 == 7 and not meleeWeapon then
                DodgeAnim = DupDodgeAnim
                DodgeVel = (forward * mRand(-300, -650)) + up * mRand(80, 70) + right * mRand(-500, 500)
            end

            local seq = self:LookupSequence(DodgeAnim)
            if not seq or seq < 0 then return end 

            dodgeAnimDuration = self:SequenceDuration(seq) or 2

            self:PlayAnim("vjseq_" .. DodgeAnim, true, dodgeAnimDuration, false)
            self:SetVelocity(DodgeVel)
            VJ.EmitSound(self, self.SoundTbl_SNPCRoll, 70, rngSnd)
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
function ENT:Dodge_DangerousEnt()
    if not IsValid(self) then return end
    if not self.Evade_IncDanger then return end 

    local cvar = GetConVar("vj_stalker_passively_dodge_incom_danger")
    if not cvar or cvar:GetInt() ~= 1 then return end
    if self.VJ_IsBeingControlled then return end

    local state = self:GetState()
    if self:IsBusy() or  self:IsVJAnimationLockState()  then
        return
    end

    if self.IsHumanDodging or self.IsCurrentlyPlayingBurnAnim then
        return
    end

    local cT = CurTime()
    if cT < (self.EvadeDanger_NextT or 0) then return end

    if not self:IsOnGround() or self:IsBusy("Activities") then return end

    local dodgeRange = mRng(825, 1245)
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
            return animVar[mRand(1, #animVar)]
        end
        return nil
    end

    for _, dangerEnt in ipairs(ents.FindInSphere(self:GetPos() + self:OBBCenter(), dodgeRange)) do
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
            local sched = self:GetCurrentSchedule()
            if sched ~= SCHED_RUN_FROM_ENEMY and sched ~= SCHED_TAKE_COVER_FROM_ENEMY then
                self:SetSchedule(SCHED_RUN_FROM_ENEMY)
            end
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
    if not self.TauntKill_Conv then return end 

    local selfWep = self:GetActiveWeapon()
    if not selfWep then return end 

    local cvTauntKill = tostring(self.TauntKill_Conv)
    local conv = GetConVar(cvTauntKill)
    if conv and conv:GetInt() == 0 then return end

    if not IsValid(inflictor) or inflictor ~= self then return end 
    if not self:IsOnGround() then return end 
    if self:IsMoving() then return end 
    if self:IsBusy("Activities") then return end

    local cT = CurTime()
    if cT < self.TauntKill_NextT then return end

    local enemy = self:GetEnemy()
    if IsValid(enemy) then
        local distSqr = self:GetPos():DistToSqr(enemy:GetPos())
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
        if not canSeeEnemy and distSqr >= (1500 * 1500) then return end
        if distSqr < (1250 * 1250) then return end
    end

    if mRng(1, self.TauntKill_Chance or 3) ~= 1 then return end

    local delay = mRand(0.25, 1)

    local seqTbl = self.TauntKill_SeqAnimTbl
    local gesTbl = self.TauntKill_GesAnimTbl
    if not istable(seqTbl) or #seqTbl == 0 then return end
    if not istable(gesTbl) or #gesTbl == 0 then return end

    local anim = seqTbl[mRng(1, #seqTbl)]
    local seq = self:LookupSequence(anim)

    local doSequence = false
    local at = 0

    if seq and seq > 0 then 
        doSequence = mRng(1, 2) == 1
        at = self:SequenceDuration(seq)
    end 

    timer.Simple(delay, function()
        if not IsValid(self) then return end
        if self:IsBusy() then return end
        self:RemoveAllGestures()
        if doSequence then
            self:PlayAnim("vjseq_" .. anim, true, at, false)
            self.TauntKill_NextT = CurTime() + at + mRand(2, 4)
        else
            local anim2 = gesTbl[mRng(1, #gesTbl)]
            if not anim2 then return end 
            self:PlayAnim("vjges_" .. anim2)
            self.TauntKill_NextT = CurTime() + mRand(5, 10)
        end
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RadioChatterSoundCode(CustomTbl)
    if not self.HasSounds or not self.HasRadioChatDialogue then return end
    if self.Dead then
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
            self.CurrentRadioChatSound = VJ.CreateSound(self, soundtbl, self.BackGround_RadioLevel, self:GetSoundPitch(self.BackGround_RadioPitch1, self.BackGround_RadioPitch2))
        end
        self.NextRadioDialogueT = cT + mRand(self.NextSoundTime_RadioDialogue1, self.NextSoundTime_RadioDialogue2)
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
            self.CurrentHasCryForAidSound = VJ.CreateSound(self, soundtbl, self.CryForAidSoundLevel, self:GetSoundPitch(self.CryForAidSoundPitch1, self.CryForAidSoundPitch2))
            
            self.NextCryForAidSoundT = curT + mRand(self.CryForAid_NextT1, self.CryForAid_NextT2)
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
end

function ENT:FleeOnAllyDeath_Context()
    if not self.Flee_OnAllyDeath then return end 
    if self.VJ_IsBeingControlled then return end 
    if self.IsGuard or self.MovementType == VJ_MOVETYPE_STATIONARY then return end 
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
        if deFlg then 
            print("Alert/Combat panic chance: 1 in " .. cmbChance)
        end 
    else
        panicChance = idleChance
        if deFlg then 
            print("Idle panic chance: 1 in " .. idleChance)
        end 
    end
    
    if mRng(1, panicChance) == 1 and not self.IsPanicked and curT > (self.PanicCooldownT or 0) then 
        if deFlg then 
            print("Panic triggered! (Chance was 1 in " .. panicChance .. ")")
        end 
        self.IsPanicked = true
        if mRng(1, 2) == 1 then 
            self:PlaySoundSystem(panicVoice)
        end 
        self:StartFlee(isAlertedOrHasEnemy)
        self.PanicCooldownT = curT + mRand(5, 15)
    else
        if deFlg then 
            print("Panic not triggered. (Chance was 1 in " .. panicChance .. ")")
        end 
    end
end 

function ENT:StartFlee(inCombat)
    if self.VJ_IsBeingControlled then return end 
    if not self.Flee_OnAllyDeath then return end 
    if not self.IsPanicked then return end 

    local curT = CurTime()
    local checkDist = mRand(250, 925)
    local move = "TASK_RUN_PATH" or "TASK_WALK_PATH"
    if self.IsPanicked and not self:IsBusy("Activities") then
        self.IsPanicked = false
        self:ClearSchedule()
        self:StopMoving()
        timer.Simple(0, function()
            if IsValid(self) then 
                if inCombat then
                    self:SCHEDULE_COVER_ENEMY(move, function(x)
                        x.DisableChasingEnemy = true
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
                self.NextDoAnyAttackT = curT + mRand(0.5, 2.5)
            end
        end)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.FootSteps = {
    [MAT_ANTLION] = {"physics/flesh/flesh_impact_hard1.wav","physics/flesh/flesh_impact_hard2.wav","physics/flesh/flesh_impact_hard3.wav","physics/flesh/flesh_impact_hard4.wav","physics/flesh/flesh_impact_hard5.wav","physics/flesh/flesh_impact_hard6.wav"},
    [MAT_BLOODYFLESH] = {"physics/flesh/flesh_impact_hard1.wav","physics/flesh/flesh_impact_hard2.wav","physics/flesh/flesh_impact_hard3.wav","physics/flesh/flesh_impact_hard4.wav","physics/flesh/flesh_impact_hard5.wav","physics/flesh/flesh_impact_hard6.wav"},
    [MAT_CONCRETE] = {"npc/footsteps/hardboot_generic1.wav","npc/footsteps/hardboot_generic2.wav","npc/footsteps/hardboot_generic3.wav","npc/footsteps/hardboot_generic4.wav","npc/footsteps/hardboot_generic5.wav","npc/footsteps/hardboot_generic6.wav"},
    [MAT_DIRT] = {"npc_foot_steps_sfx/soil_run_01.ogg","npc_foot_steps_sfx/soil_run_02.ogg","npc_foot_steps_sfx/soil_run_03.ogg","npc_foot_steps_sfx/soil_run_04.ogg","npc_foot_steps_sfx/soil_run_05.ogg","npc_foot_steps_sfx/soil_run_06.ogg","npc_foot_steps_sfx/soil_run_07.ogg","npc_foot_steps_sfx/soil_run_08.ogg"},
    [MAT_FLESH] = {"physics/flesh/flesh_impact_hard1.wav","physics/flesh/flesh_impact_hard2.wav","physics/flesh/flesh_impact_hard3.wav","physics/flesh/flesh_impact_hard4.wav","physics/flesh/flesh_impact_hard5.wav","physics/flesh/flesh_impact_hard6.wav"},
    [MAT_GRATE] = {"npc_foot_steps_sfx/walk_proflist_01.ogg","npc_foot_steps_sfx/walk_proflist_02.ogg","npc_foot_steps_sfx/walk_proflist_03.ogg","npc_foot_steps_sfx/walk_proflist_04.ogg","npc_foot_steps_sfx/walk_proflist_05.ogg","npc_foot_steps_sfx/walk_proflist_06.ogg","npc_foot_steps_sfx/walk_proflist_07.ogg","npc_foot_steps_sfx/walk_proflist_08.ogg","npc_foot_steps_sfx/walk_proflist_09.ogg","npc_foot_steps_sfx/walk_proflist_10.ogg"},
    [MAT_ALIENFLESH] = {"physics/flesh/flesh_impact_hard1.wav","physics/flesh/flesh_impact_hard2.wav","physics/flesh/flesh_impact_hard3.wav","physics/flesh/flesh_impact_hard4.wav","physics/flesh/flesh_impact_hard5.wav","physics/flesh/flesh_impact_hard6.wav"},
    [74] = {"player/footsteps/sand1.wav","player/footsteps/sand2.wav","player/footsteps/sand3.wav","player/footsteps/sand4.wav"}, -- This is snow.
    [MAT_PLASTIC] = {"physics/plaster/drywall_footstep1.wav","physics/plaster/drywall_footstep2.wav","physics/plaster/drywall_footstep3.wav","physics/plaster/drywall_footstep4.wav"},
    [MAT_METAL] = {"npc_foot_steps_sfx/sprint_metal1.ogg","npc_foot_steps_sfx/sprint_metal2.ogg","npc_foot_steps_sfx/sprint_metal3.ogg","npc_foot_steps_sfx/sprint_metal4.ogg","npc_foot_steps_sfx/sprint_metal5.ogg","npc_foot_steps_sfx/sprint_metal6.ogg"},
    [MAT_SAND] = {"player/footsteps/sand1.wav","player/footsteps/sand2.wav","player/footsteps/sand3.wav","player/footsteps/sand4.wav"},
    [MAT_FOLIAGE] = {"npc_foot_steps_sfx/sprint2_grasslow_01.ogg","npc_foot_steps_sfx/sprint2_grasslow_02.ogg","npc_foot_steps_sfx/sprint2_grasslow_03.ogg","npc_foot_steps_sfx/sprint2_grasslow_04.ogg","npc_foot_steps_sfx/sprint2_grasslow_05.ogg","npc_foot_steps_sfx/sprint2_grasslow_06.ogg","npc_foot_steps_sfx/sprint2_grasslow_07.ogg","npc_foot_steps_sfx/sprint2_grasslow_08.ogg"},
    [MAT_COMPUTER] = {"physics/plaster/drywall_footstep1.wav","physics/plaster/drywall_footstep2.wav","physics/plaster/drywall_footstep3.wav","physics/plaster/drywall_footstep4.wav"},
    [MAT_SLOSH] = {"npc_foot_steps_sfx/walk_puddle_01.ogg","npc_foot_steps_sfx/walk_puddle_02.ogg","npc_foot_steps_sfx/walk_puddle_03.ogg","npc_foot_steps_sfx/walk_puddle_04.ogg","npc_foot_steps_sfx/walk_puddle_05.ogg","npc_foot_steps_sfx/walk_puddle_06.ogg","npc_foot_steps_sfx/walk_puddle_07.ogg","npc_foot_steps_sfx/walk_puddle_08.ogg","npc_foot_steps_sfx/walk_puddle_09.ogg"},
    [MAT_TILE] = {"npc_foot_steps_sfx/tile1.wav","npc_foot_steps_sfx/tile2.wav","npc_foot_steps_sfx/tile3.wav","npc_foot_steps_sfx/tile4.wav","npc_foot_steps_sfx/tile5.wav","npc_foot_steps_sfx/tile6.wav","npc_foot_steps_sfx/tile7.wav","npc_foot_steps_sfx/tile8.wav","npc_foot_steps_sfx/tile9.wav","npc_foot_steps_sfx/tile10.wav","npc_foot_steps_sfx/tile11.wav"},
    [85] = {"npc_foot_steps_sfx/sprint2_grasslow_01.ogg","npc_foot_steps_sfx/sprint2_grasslow_02.ogg","npc_foot_steps_sfx/sprint2_grasslow_03.ogg","npc_foot_steps_sfx/sprint2_grasslow_04.ogg","npc_foot_steps_sfx/sprint2_grasslow_05.ogg","npc_foot_steps_sfx/sprint2_grasslow_06.ogg","npc_foot_steps_sfx/sprint2_grasslow_07.ogg","npc_foot_steps_sfx/sprint2_grasslow_08.ogg"}, -- Grass.
    [MAT_VENT] = {"npc_foot_steps_sfx/walk_proflist_01.ogg","npc_foot_steps_sfx/walk_proflist_02.ogg","npc_foot_steps_sfx/walk_proflist_03.ogg","npc_foot_steps_sfx/walk_proflist_04.ogg","npc_foot_steps_sfx/walk_proflist_05.ogg","npc_foot_steps_sfx/walk_proflist_06.ogg","npc_foot_steps_sfx/walk_proflist_07.ogg","npc_foot_steps_sfx/walk_proflist_08.ogg","npc_foot_steps_sfx/walk_proflist_09.ogg","npc_foot_steps_sfx/walk_proflist_10.ogg"},
    [MAT_WOOD] = {"npc_foot_steps_sfx/sprint_wood_01.ogg","npc_foot_steps_sfx/sprint_wood_02.ogg","npc_foot_steps_sfx/sprint_wood_03.ogg","npc_foot_steps_sfx/sprint_wood_04.ogg","npc_foot_steps_sfx/sprint_wood_05.ogg","npc_foot_steps_sfx/sprint_wood_06.ogg","npc_foot_steps_sfx/sprint_wood_07.ogg","npc_foot_steps_sfx/sprint_wood_08.ogg","npc_foot_steps_sfx/sprint_wood_09.ogg","npc_foot_steps_sfx/sprint_wood_10.ogg","npc_foot_steps_sfx/sprint_wood_11.ogg","npc_foot_steps_sfx/sprint_wood_12.ogg","npc_foot_steps_sfx/sprint_wood_13.ogg"},
    [MAT_GLASS] = {"npc_foot_steps_sfx/sprint_glass_01.ogg","npc_foot_steps_sfx/sprint_glass_02.ogg","npc_foot_steps_sfx/sprint_glass_03.ogg","npc_foot_steps_sfx/sprint_glass_04.ogg","npc_foot_steps_sfx/sprint_glass_05.ogg","npc_foot_steps_sfx/sprint_glass_06.ogg","npc_foot_steps_sfx/sprint_glass_07.ogg","npc_foot_steps_sfx/sprint_glass_08.ogg","npc_foot_steps_sfx/sprint_glass_09.ogg","npc_foot_steps_sfx/sprint_glass_10.ogg"}
}
---------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.OnFirePain = {"st_brutal_deaths/brutal_scream/rus_screams_fire/scream_157.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/scream_158.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/scream_159.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/scream_160.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/scream_161.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/scream_162.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/scream_163.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/506.wav"}

//General universal sounds
ENT.GoreOrGibSounds                  = {"wrhf/gibs/fullbodygib-1.wav", "wrhf/gibs/fullbodygib-2.wav", "wrhf/gibs/fullbodygib-3.wav"} -- need to change path soon 
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


//Faction specific dialogue, will improve soon.
ENT.SoundTbl_Investigate = {"st_faction_sounds/stalker_vo/general_base_dialogue/hear_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_9.ogg"}

ENT.SoundTbl_DangerSight = {"general_sds/ext_reactions/hide_" .. mRng(1, 8) .. ".mp3"}

ENT.SoundTbl_MedicReceiveHeal = {"general_sds/ext_reactions/thanks_" .. mRng(1, 6) .. ".mp3","st_faction_sounds/stalker_vo/general_base_dialogue/thanx_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/thanx_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/thanx_3.ogg","general_spetsnaz_snds/gotmedic1.mp3","general_spetsnaz_snds/gotmedic2.mp3","general_spetsnaz_snds/gotmedic3.mp3","general_spetsnaz_snds/gotmedic4.mp3","general_spetsnaz_snds/gotmedic5.mp3","general_spetsnaz_snds/gotmedic6.mp3","general_spetsnaz_snds/gotmedic7.mp3"}

ENT.SoundTbl_MedicBeforeHeal = {"st_faction_sounds/stalker_vo/general_base_dialogue/medkit_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/medkit_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/medkit_3.ogg","general_spetsnaz_snds/health01.wav","general_spetsnaz_snds/health02.wav","general_spetsnaz_snds/health03.wav","general_spetsnaz_snds/health04.wav","general_spetsnaz_snds/health05.wav","general_spetsnaz_snds/heal1.mp3","general_spetsnaz_snds/heal2.mp3","general_spetsnaz_snds/heal3.mp3","general_spetsnaz_snds/heal4.mp3","general_spetsnaz_snds/heal5.mp3","general_spetsnaz_snds/heal6.mp3","general_spetsnaz_snds/heal7.mp3","general_spetsnaz_snds/heal8.mp3","general_spetsnaz_snds/heal9.mp3","general_spetsnaz_snds/heal10.mp3"}

ENT.SoundTbl_Breath = {"st_faction_sounds/stalker_vo/general_base_dialogue/breath_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/breath_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/breath_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/breath_4.ogg"}

ENT.SoundTbl_Idle = {"st_faction_sounds/stalker_vo/general_base_dialogue/idle_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_14.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_15.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_16.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_17.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_18.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_19.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_20.ogg","general_spetsnaz_snds/free1.wav","general_spetsnaz_snds/free2.wav","general_spetsnaz_snds/free3.wav","general_spetsnaz_snds/free4.wav","general_spetsnaz_snds/free5.wav","general_spetsnaz_snds/free6.wav","general_spetsnaz_snds/free7.wav","general_spetsnaz_snds/free8.wav","general_spetsnaz_snds/free9.wav","general_spetsnaz_snds/free10.wav","general_spetsnaz_snds/free11.wav","general_spetsnaz_snds/free12.wav","general_spetsnaz_snds/free13.wav","general_spetsnaz_snds/free14.wav","general_spetsnaz_snds/free15.wav","general_spetsnaz_snds/free16.wav","general_spetsnaz_snds/free17.wav","general_spetsnaz_snds/free18.wav","general_spetsnaz_snds/free19.wav","general_spetsnaz_snds/free20.wav","general_spetsnaz_snds/free21.wav","general_spetsnaz_snds/free22.wav","general_spetsnaz_snds/free23.wav","general_spetsnaz_snds/free24.wav","general_spetsnaz_snds/free25.wav","general_spetsnaz_snds/free26.wav","general_spetsnaz_snds/free27.wav","general_spetsnaz_snds/free28.wav","general_spetsnaz_snds/free29.wav","general_spetsnaz_snds/free30.wav","general_spetsnaz_snds/idledraft1.wav","general_spetsnaz_snds/idledraft2.wav","general_spetsnaz_snds/idledraft3.wav","general_spetsnaz_snds/idledraft4.wav","general_spetsnaz_snds/idledraft5.wav","general_spetsnaz_snds/idleburp.wav","general_spetsnaz_snds/idlewhistle.wav","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_1.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_2.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_3.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_4.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_5.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_6.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_7.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_8.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_9.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_10.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_11.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_12.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_13.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_14.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_15.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_16.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_17.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_18.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_19.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_20.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_21.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_22.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_23.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_24.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_25.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_26.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_27.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_28.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_29.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_30.ogg","general_spetsnaz_snds/chat1.mp3","general_spetsnaz_snds/chat2.mp3","general_spetsnaz_snds/chat3.mp3","general_spetsnaz_snds/chat4.mp3","general_spetsnaz_snds/chat5.mp3","general_spetsnaz_snds/chat6.mp3","general_spetsnaz_snds/chat7.mp3","general_spetsnaz_snds/chat8.mp3","general_spetsnaz_snds/chat9.mp3","general_spetsnaz_snds/chat10.mp3","general_spetsnaz_snds/chat11.mp3","general_spetsnaz_snds/chat12.mp3","general_spetsnaz_snds/chat13.mp3","general_spetsnaz_snds/chat14.mp3","general_spetsnaz_snds/chat15.mp3","general_spetsnaz_snds/chat16.mp3","general_spetsnaz_snds/chat17.mp3","general_spetsnaz_snds/chat18.mp3","general_spetsnaz_snds/chat19.mp3"}

ENT.SoundTbl_Alert = {"st_faction_sounds/stalker_vo/general_base_dialogue/detour_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/detour_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/detour_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/detour_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/detour_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/detour_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_6.ogg","general_spetsnaz_snds/alert1.wav","general_spetsnaz_snds/alert2.wav","general_spetsnaz_snds/alert3.wav","general_spetsnaz_snds/alert4.wav","general_spetsnaz_snds/alert5.wav","general_spetsnaz_snds/alert6.wav","general_spetsnaz_snds/alert7.wav","general_spetsnaz_snds/alert8.wav","general_spetsnaz_snds/alert9.wav","general_spetsnaz_snds/alert1.wav","general_spetsnaz_snds/alert2.wav","general_spetsnaz_snds/alert3.wav","general_spetsnaz_snds/alert4.wav","general_spetsnaz_snds/alert5.wav","general_spetsnaz_snds/alert6.wav","general_spetsnaz_snds/alert7.wav","general_spetsnaz_snds/alert8.wav","general_spetsnaz_snds/alert9.wav","general_spetsnaz_snds/alert10.wav","general_spetsnaz_snds/alert11.wav","st_faction_sounds/stalker_vo/general_base_dialogue/panic_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/panic_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/panic_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/panic_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/panic_5.ogg","badcompany_squad/VO_RU_Grunt_ContactCall_01A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_ContactCall_02A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_ContactCall_03A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_ContactCall_04A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_ContactCall_05A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_ContactCall_06A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_ContactCall_07A_DimitryRozental.ogg"}

ENT.SoundTbl_CombatIdle = {"st_faction_sounds/stalker_vo/general_base_dialogue/attack_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_14.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_7.ogg","general_spetsnaz_snds/attack1.wav","general_spetsnaz_snds/attack2.wav","general_spetsnaz_snds/attack3.wav","general_spetsnaz_snds/attack4.wav","general_spetsnaz_snds/attack5.wav","general_spetsnaz_snds/attack6.wav","general_spetsnaz_snds/attack7.wav","general_spetsnaz_snds/attack8.wav","general_spetsnaz_snds/attack9.wav","general_spetsnaz_snds/attack10.wav","general_spetsnaz_snds/attack11.wav","general_spetsnaz_snds/attack12.wav","general_spetsnaz_snds/attack13.wav","general_spetsnaz_snds/attack14.wav","general_spetsnaz_snds/attack15.wav","general_spetsnaz_snds/attack16.wav","general_spetsnaz_snds/attack1.wav","general_spetsnaz_snds/attack2.wav","general_spetsnaz_snds/attack3.wav","general_spetsnaz_snds/attack4.wav","general_spetsnaz_snds/attack5.wav","general_spetsnaz_snds/attack6.wav","general_spetsnaz_snds/attack7.wav","russian/attack1.wav","russian/attack2.wav","russian/attack3.wav","russian/attack4.wav","russian/attack5.wav","russian/attack6.wav","russian/attack7.wav","russian/attack8.wav","russian/attack9.wav","russian/attack10.wav","russian/attack11.wav","russian/attack12.wav","general_spetsnaz_snds/combat1.mp3","general_spetsnaz_snds/combat2.mp3","general_spetsnaz_snds/combat3.mp3","general_spetsnaz_snds/combat4.mp3","general_spetsnaz_snds/combat5.mp3","general_spetsnaz_snds/combat6.mp3","general_spetsnaz_snds/combat7.mp3","general_spetsnaz_snds/combat8.mp3","general_spetsnaz_snds/combat9.mp3","general_spetsnaz_snds/combat10.mp3","general_spetsnaz_snds/combat11.mp3","general_spetsnaz_snds/combat12.mp3","general_spetsnaz_snds/combat13.mp3","general_spetsnaz_snds/combat14.mp3","general_spetsnaz_snds/combat15.mp3","general_spetsnaz_snds/combat16.mp3","general_spetsnaz_snds/combat17.mp3","general_spetsnaz_snds/combat18.mp3","general_spetsnaz_snds/combat19.mp3","general_spetsnaz_snds/combat20.mp3"}

ENT.SoundTbl_Suppressing = {"st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_14.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_7.ogg","badcompany_squad/pursuing1.wav","badcompany_squad/pursuing2.wav","badcompany_squad/pursuing3.wav","badcompany_squad/pursuing4.wav","badcompany_squad/pursuing5.wav","badcompany_squad/pursuing6.wav", "general_spetsnaz_snds/suppressing1.wav","general_spetsnaz_snds/suppressing2.wav","general_spetsnaz_snds/suppressing3.wav","general_spetsnaz_snds/suppressing4.wav","general_spetsnaz_snds/suppressing5.wav","general_spetsnaz_snds/suppressing6.wav","general_spetsnaz_snds/suppressing7.wav","general_spetsnaz_snds/suppressing8.wav","general_spetsnaz_snds/suppressing9.wav","general_spetsnaz_snds/suppressing10.wav","general_spetsnaz_snds/suppressing11.wav","general_spetsnaz_snds/suppressing12.wav","general_spetsnaz_snds/suppressing1.wav","general_spetsnaz_snds/suppressing2.wav","general_spetsnaz_snds/suppressing3.wav","general_spetsnaz_snds/suppressing4.wav","general_spetsnaz_snds/suppressing5.wav","general_spetsnaz_snds/suppressing6.wav","general_spetsnaz_snds/suppressing7.wav","general_spetsnaz_snds/suppressing8.wav","general_spetsnaz_snds/suppressing9.wav","general_spetsnaz_snds/suppressing10.wav","general_spetsnaz_snds/suppressing11.wav","general_spetsnaz_snds/suppressing12.wav","general_spetsnaz_snds/suppressing13.wav","general_spetsnaz_snds/suppressing14.wav","general_spetsnaz_snds/suppressing15.wav","general_spetsnaz_snds/suppressing16.wav","general_spetsnaz_snds/suppressing17.wav","general_spetsnaz_snds/suppressing18.wav","general_spetsnaz_snds/suppressing19.wav","general_spetsnaz_snds/suppressing20.wav"}

ENT.SoundTbl_WeaponReload = {"general_spetsnaz_snds/reloading1.wav","general_spetsnaz_snds/reloading2.wav","general_spetsnaz_snds/reloading3.wav","general_spetsnaz_snds/reloading4.wav","general_spetsnaz_snds/reloading5.wav","general_spetsnaz_snds/reloading6.wav","general_spetsnaz_snds/reloading7.wav","general_spetsnaz_snds/reloading8.wav","general_spetsnaz_snds/reloading9.wav","general_spetsnaz_snds/reloading10.wav","general_spetsnaz_snds/reloading11.wav","general_spetsnaz_snds/reloading12.wav","general_spetsnaz_snds/reloading13.wav","general_spetsnaz_snds/reloading14.wav","general_spetsnaz_snds/reloading15.wav","general_spetsnaz_snds/reloading16.wav","general_spetsnaz_snds/reloading17.wav","general_spetsnaz_snds/reloading18.wav","general_spetsnaz_snds/reloading19.wav","general_spetsnaz_snds/reloading20.wav","general_spetsnaz_snds/reloading21.wav","general_spetsnaz_snds/reloading22.wav","general_spetsnaz_snds/reloading23.wav","general_spetsnaz_snds/reloading24.wav","general_spetsnaz_snds/reloading25.wav","general_spetsnaz_snds/reloading26.wav","general_spetsnaz_snds/reloading27.wav","general_spetsnaz_snds/reloading28wav","general_spetsnaz_snds/reloading29.wav","general_spetsnaz_snds/reloading1.wav","general_spetsnaz_snds/reloading2.wav","general_spetsnaz_snds/reloading3.wav","general_spetsnaz_snds/reloading4.wav","general_spetsnaz_snds/reloading5.wav","general_spetsnaz_snds/reloading6.wav","general_spetsnaz_snds/reloading7.wav","general_spetsnaz_snds/reloading8.wav"}

ENT.SoundTbl_GrenadeAttack = {"general_spetsnaz_snds/fragout1.wav","general_spetsnaz_snds/fragout2.wav","general_spetsnaz_snds/fragout3.wav","general_spetsnaz_snds/fragout4.wav","general_spetsnaz_snds/fragout5.wav","general_spetsnaz_snds/fragout6.wav","general_spetsnaz_snds/fragout7.wav","general_spetsnaz_snds/fragout8.wav","general_spetsnaz_snds/fragout9.wav","general_spetsnaz_snds/fragout10.wav","general_spetsnaz_snds/fragout11.wav","general_spetsnaz_snds/fragout12.wav","general_spetsnaz_snds/fragout13.wav","general_spetsnaz_snds/fragout14.wav","general_spetsnaz_snds/fragout1.wav","general_spetsnaz_snds/fragout2.wav","general_spetsnaz_snds/fragout3.wav","general_spetsnaz_snds/fragout4.wav","general_spetsnaz_snds/fragout5.wav","general_spetsnaz_snds/fragout6.wav","general_spetsnaz_snds/fragout7.wav","general_spetsnaz_snds/fragout8.wav","general_spetsnaz_snds/fragout9.wav","general_spetsnaz_snds/fragout10.wav","general_spetsnaz_snds/fragout11.wav","general_spetsnaz_snds/fragout12.wav","general_spetsnaz_snds/fragout13.wav","general_spetsnaz_snds/fragout14.wav","general_spetsnaz_snds/fragout15.wav","general_spetsnaz_snds/fragout16.wav","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready7_.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/ready_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/ready_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/ready_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/ready_4.ogg","badcompany_squad/VO_RU_SL_FragOut_01A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_FragOut_02A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_FragOut_03A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_FragOut_04A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_FragOut_05A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_FragOut_06A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_FragOut_07A_AleksandrJuriev.ogg"}

ENT.SoundTbl_OnGrenadeSight = {"general_spetsnaz_snds/grenade1.wav","general_spetsnaz_snds/grenade2.wav","general_spetsnaz_snds/grenade3.wav","general_spetsnaz_snds/grenade4.wav","general_spetsnaz_snds/grenade5.wav","general_spetsnaz_snds/grenade6.wav","general_spetsnaz_snds/grenade7.wav","general_spetsnaz_snds/grenade8.wav","general_spetsnaz_snds/grenade9.wav","general_spetsnaz_snds/grenade10.wav","general_spetsnaz_snds/grenade11.wav","general_spetsnaz_snds/grenade12.wav","general_spetsnaz_snds/grenade13.wav","general_spetsnaz_snds/grenade14.wav","general_spetsnaz_snds/grenade15.wav","general_spetsnaz_snds/grenade16.wav","general_spetsnaz_snds/grenade17.wav","general_spetsnaz_snds/grenade18.wav","general_spetsnaz_snds/grenade19.wav","general_spetsnaz_snds/grenade20.wav","general_spetsnaz_snds/grenade21.wav","general_spetsnaz_snds/grenade22.wav","general_spetsnaz_snds/grenade23.wav","general_spetsnaz_snds/grenade24.wav","general_spetsnaz_snds/grenade25.wav","general_spetsnaz_snds/grenade26.wav","general_spetsnaz_snds/grenade27.wav","general_spetsnaz_snds/grenade28.wav","general_spetsnaz_snds/grenade29.wav","general_spetsnaz_snds/grenade30.wav","general_spetsnaz_snds/grenade31.wav","general_spetsnaz_snds/grenade32.wav","general_spetsnaz_snds/grenade33.wav","general_spetsnaz_snds/grenade34.wav"}

ENT.SoundTbl_OnKilledEnemy = {"st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_8.ogg","general_spetsnaz_snds/kill1.wav","general_spetsnaz_snds/kill2.wav","general_spetsnaz_snds/kill3.wav","general_spetsnaz_snds/kill4.wav","general_spetsnaz_snds/kill5.wav","general_spetsnaz_snds/kill6.wav","general_spetsnaz_snds/kill7.wav","general_spetsnaz_snds/kill8.wav","general_spetsnaz_snds/kill9.wav","general_spetsnaz_snds/kill10.wav","general_spetsnaz_snds/kill1.wav","general_spetsnaz_snds/kill2.wav","general_spetsnaz_snds/kill3.wav","general_spetsnaz_snds/kill4.wav","general_spetsnaz_snds/kill5.wav","general_spetsnaz_snds/kill6.wav","general_spetsnaz_snds/kill7.wav","general_spetsnaz_snds/kill8.wav","general_spetsnaz_snds/kill9.wav","general_spetsnaz_snds/kill10.wav","st_faction_sounds/stalker_vo/general_base_dialogue/dead_enemy_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/dead_enemy_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/dead_enemy_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/dead_enemy_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/dead_enemy_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/dead_enemy_6.ogg"}

ENT.SoundTbl_AllyDeath = {"general_spetsnaz_snds/casualty1.wav","general_spetsnaz_snds/casualty2.wav","general_spetsnaz_snds/casualty3.wav","general_spetsnaz_snds/casualty4.wav","general_spetsnaz_snds/casualty5.wav","general_spetsnaz_snds/casualty6.wav","general_spetsnaz_snds/casualty7.wav","general_spetsnaz_snds/casualty8.wav","general_spetsnaz_snds/casualty9.wav","general_spetsnaz_snds/casualty10.wav","general_spetsnaz_snds/casualty11.wav","general_spetsnaz_snds/casualty12.wav","general_spetsnaz_snds/casualty13.wav","general_spetsnaz_snds/casualty14.wav","general_spetsnaz_snds/casualty15.wav","general_spetsnaz_snds/casualty16.wav","general_spetsnaz_snds/casualty17.wav","general_spetsnaz_snds/casualty18.wav","general_spetsnaz_snds/casualty19.wav","general_spetsnaz_snds/casualty20.wav","general_spetsnaz_snds/casualty21.wav","general_spetsnaz_snds/casualty22.wav","general_spetsnaz_snds/casualty23.wav","general_spetsnaz_snds/casualty24.wav","general_spetsnaz_snds/casualty25.wav","general_spetsnaz_snds/casualty2.wav","general_spetsnaz_snds/casualty27.wav","general_spetsnaz_snds/casualty28.wav","general_spetsnaz_snds/casualty29.wav","general_spetsnaz_snds/casualty30.wav","general_spetsnaz_snds/casualty31.wav","general_spetsnaz_snds/casualty32.wav","general_spetsnaz_snds/casualty33.wav","general_spetsnaz_snds/casualty34.wav"}

ENT.SoundTbl_CombatIdle = {"st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_14.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/fire_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/fire_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/fire_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/fire_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/fire_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_1stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_2stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_3stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_4stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_5stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_6stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_1stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_2stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_3stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_4stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_5stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_14.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_15.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_1stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_2stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_3stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_4stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_5stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_6stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_7stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_8stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_9stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_10stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_11stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_12stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_13stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_14stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_15stalker.ogg"}

ENT.SoundTbl_LostEnemy = {"st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_1stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_2stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_3stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_4stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_5stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_6stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_7stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_8stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_9stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_lost_10stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_1stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_2stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_3stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_4stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_5stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_6stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_7stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_8stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/search_9stalker.ogg"}

ENT.SoundTbl_IdleDialogue = {"general_spetsnaz_snds/dia_1.wav","general_spetsnaz_snds/dia_2.wav","general_spetsnaz_snds/idled.mp3","general_spetsnaz_snds/idled.mp3","general_spetsnaz_snds/idled2.mp3","general_spetsnaz_snds/idled3.mp3","general_spetsnaz_snds/idled4.mp3","general_spetsnaz_snds/idled5.mp3"}

ENT.SoundTbl_IdleDialogueAnswer = {"general_spetsnaz_snds/VO_RU_SL_Negative_01A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Negative_02A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Negative_03A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Negative_04A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Negative_05A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Negative_06A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Negative_07A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_SL_Negative_08A_AleksandrJuriev.ogg","general_spetsnaz_snds/VO_RU_Grunt_Negative_01A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Negative_02A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Negative_03A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Negative_04A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Negative_05A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_Negative_06A_DimitryRozental.ogg","general_spetsnaz_snds/dia_1_response.wav","general_spetsnaz_snds/dia_2_response.wav","badcompany_squad/VO_RU_Grunt_Affirmative_01A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_Affirmative_02A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_Affirmative_03A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_Affirmative_04A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_Affirmative_05A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_Affirmative_06A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_Affirmative_07A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_Affirmative_08A_DimitryRozental.ogg","badcompany_squad/VO_RU_SL_Affirmative_01A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_Affirmative_02A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_Affirmative_03A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_Affirmative_04A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_Affirmative_05A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_Affirmative_06A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_Affirmative_07A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_Affirmative_08A_AleksandrJuriev.ogg"}

ENT.SoundTbl_CallForHelp = {"st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_14.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_01A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_02A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_03A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_04A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_05A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_06A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_07A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_08A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_09A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_10A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_11A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_12A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_13A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_14A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_15A_DimitryRozental.ogg","general_spetsnaz_snds/VO_RU_Grunt_MedicCall_16A_DimitryRozental.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_14.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_15.ogg"}

ENT.SoundTbl_OnReceiveOrder = {"badcompany_squad/VO_RU_Grunt_Affirmative_01A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_Affirmative_02A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_Affirmative_03A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_Affirmative_04A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_Affirmative_05A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_Affirmative_06A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_Affirmative_07A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_Affirmative_08A_DimitryRozental.ogg","badcompany_squad/VO_RU_SL_Affirmative_01A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_Affirmative_02A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_Affirmative_03A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_Affirmative_04A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_Affirmative_05A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_Affirmative_06A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_Affirmative_07A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_Affirmative_08A_AleksandrJuriev.ogg"}

ENT.SoundTbl_BecomeEnemyToPlayer = {"st_faction_sounds/stalker_vo/general_base_dialogue/friendly_fire_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/friendly_fire_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/friendly_fire_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/friendly_fire_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/friendly_fire_5.ogg","general_spetsnaz_snds/wetrustedyou01.wav","general_spetsnaz_snds/wetrustedyou02.wav","general_spetsnaz_snds/becomehos1.mp3","general_spetsnaz_snds/becomehos2.mp3","general_spetsnaz_snds/becomehos3.mp3","general_spetsnaz_snds/becomehos4.mp3"}

ENT.SoundTbl_DamageByPlayer = {"general_sds/ext_reactions/fr_fire_" .. mRng(1, 18) .. ".mp3","general_spetsnaz_snds/eft_bear_friendlyfire1.wav","general_spetsnaz_snds/eft_bear_friendlyfire2.wav","general_spetsnaz_snds/eft_bear_friendlyfire3.wav","general_spetsnaz_snds/eft_bear_friendlyfire4.wav","general_spetsnaz_snds/eft_bear_friendlyfire5.wav","general_spetsnaz_snds/eft_bear_friendlyfire6.wav","general_spetsnaz_snds/eft_bear_friendlyfire7.wav","general_spetsnaz_snds/eft_bear_friendlyfire8.wav","general_spetsnaz_snds/eft_bear_friendlyfire9.wav","general_spetsnaz_snds/eft_bear_friendlyfire10.wav","general_spetsnaz_snds/eft_bear_friendlyfire11.wav","general_spetsnaz_snds/eft_bear_friendlyfire12.wav","general_spetsnaz_snds/eft_bear_friendlyfire13.wav","general_spetsnaz_snds/eft_bear_friendlyfire14.wav","general_spetsnaz_snds/eft_bear_friendlyfire15.wav","general_spetsnaz_snds/eft_bear_friendlyfire16.wav","general_spetsnaz_snds/eft_bear_friendlyfire1.wav","general_spetsnaz_snds/playerdamage1.mp3","general_spetsnaz_snds/playerdamage2.mp3","general_spetsnaz_snds/playerdamage3.mp3","general_spetsnaz_snds/playerdamage4.mp3","general_spetsnaz_snds/playerdamage5.mp3","general_spetsnaz_snds/playerdamage6.mp3"}

ENT.SoundTbl_FollowPlayer = {"general_spetsnaz_snds/leadtheway01.wav","general_spetsnaz_snds/leadtheway02.wav","general_spetsnaz_snds/okimready01.wav","general_spetsnaz_snds/okimready02.wav","general_spetsnaz_snds/okimready03.wav","general_spetsnaz_snds/follow1.mp3","general_spetsnaz_snds/follow2.mp3","general_spetsnaz_snds/follow3.mp3","general_spetsnaz_snds/follow4.mp3","general_spetsnaz_snds/follow5.mp3","general_spetsnaz_snds/follow6.mp3","general_spetsnaz_snds/follow7.mp3","general_spetsnaz_snds/follow8.mp3","general_spetsnaz_snds/follow9.mp3","general_spetsnaz_snds/follow10.mp3","general_spetsnaz_snds/follow11.mp3","general_spetsnaz_snds/follow12.mp3","general_spetsnaz_snds/follow13.mp3"}

ENT.SoundTbl_UnFollowPlayer = {"general_spetsnaz_snds/illstayhere01.wav","general_spetsnaz_snds/holddownspot01.wav","general_spetsnaz_snds/holddownspot02.wav","general_spetsnaz_snds/nofollow1.mp3","general_spetsnaz_snds/nofollow2.mp3","general_spetsnaz_snds/nofollow3.mp3","general_spetsnaz_snds/nofollow4.mp3","general_spetsnaz_snds/nofollow5.mp3","general_spetsnaz_snds/nofollow6.mp3","general_spetsnaz_snds/nofollow7.mp3","general_spetsnaz_snds/nofollow8.mp3"}

ENT.SoundTbl_YieldToPlayer = {"general_sds/ext_reactions/sorry_" .. mRng(1, 6) .. ".mp3","general_spetsnaz_snds/sorry01.wav","general_spetsnaz_snds/sorry02.wav","general_spetsnaz_snds/excuseme01.wav","general_spetsnaz_snds/excuseme02.wav","general_spetsnaz_snds/pardonme02.wav","general_spetsnaz_snds/pardonme01.wav","general_spetsnaz_snds/bump1.mp3","general_spetsnaz_snds/bump2.mp3","general_spetsnaz_snds/bump3.mp3","general_spetsnaz_snds/bump4.mp3","general_spetsnaz_snds/bump5.mp3","general_spetsnaz_snds/bump6.mp3"}
---------------------------------------------------------------------------------------------------------------------------------------------
-- Slightly Modified version of Darkborn's Dynamic Footstep code -- \
function ENT:Dynamic_FeetSteps()
    if not self.Has_DynamicFootsteps then return end 
    local equipmentRustle = table.Random(self.EquipmentClanging_Tbl)
    local clothingRustle = table.Random(self.ClothingRustling_Tbl)
    local rngP = mRng(75, 105)
    local chance = 3
    local pos = self:GetPos()
    local waterLvl = self:WaterLevel()
    local waterStep = table.Random(self.WaterSplashSounds)
    if not self:IsOnGround() or not self.HasSounds or not self.HasFootstepSounds then return end

    if self.HasEquipmentRustle then 
        if mRng(1, chance) == 1 and equipmentRustle then 
            VJ.EmitSound(self, equipmentRustle, 75, rngP)
        end
    end 

    if self.HasClothingRustle then 
        if mRng(1, chance) == 1 and clothingRustle then 
            VJ.EmitSound(self, clothingRustle, 75 * 2, rngP)
        end
    end 

    local tr = util.TraceLine({
        start = pos,
        endpos = pos + Vector(0,0, -150),
        filter = {self}
    })

    if tr.Hit and self.FootSteps[tr.MatType] then
        VJ.EmitSound(self, VJ.PICK(self.FootSteps[tr.MatType]), rngP ,rngP)
    end

    if waterLvl > 0 and waterLvl < 3 then
        VJ.EmitSound(self, waterStep, rngP, rngP)
    end
end 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnWeaponReload()
    self:Reload_Reposition()
end

function ENT:Reload_Reposition()
    if not IsValid(self) then return end
    local conv = GetConVar("vj_stalker_reposition_while_reloading")
    if not conv or conv:GetInt() ~= 1 then return end
    if self.VJ_IsBeingControlled or self.IsGuard then return end
    if not self.Weapon_CanReload then return end 
    if not self.Repos_GesReload then return end

    local ene = self:GetEnemy()
    local traceDist = (mRand and mRand(550, 1250)) or mRng(550,1250)
    local reposChance = tonumber(self.Repos_GesReloadChance) or 3
    local c = CurTime()
    if c > self.Repos_GesReloadNextT then 
        if (not IsValid(ene)) or (mRng and mRng(1,3) == 1 and self.Weapon_FindCoverOnReload) or (self:DoCoverTrace(self:GetPos() + self:OBBCenter(), ene and ene:EyePos() or vector_origin, false, {SetLastHiddenTime=true}) and not self:IsBusy("Activities")) then
            return
        end
        local reloadAnimTbl = (self.AnimationTranslations and self.AnimationTranslations[ACT_GESTURE_RELOAD]) or nil
        local reloadAnim = nil
        if istable(reloadAnimTbl) then
            reloadAnim = VJ.PICK(reloadAnimTbl) or reloadAnimTbl[ mRng(#reloadAnimTbl) ]
        elseif isstring(reloadAnimTbl) then
            reloadAnim = reloadAnimTbl
        end

        local moveRun = "TASK_RUN_PATH"
        local mix = table.Random({moveRun, "TASK_WALK_PATH"}) or moveRun
        local delT = mRand(1, 10)
        if reloadAnim then
            local gestureReloadAnim = reloadAnim
            self.AnimTbl_WeaponReload = {gestureReloadAnim}
            self:ClearSchedule()
            if (mRng and mRng(1, reposChance) == 1) or (not mRng and mRng(1, reposChance) == 1) then
                timer.Simple(0, function()
                    if not IsValid(self) then return end
                    if (mRng and mRng(1,2) == 1) or (not mRng and mRng(1,2) == 1) then
                        if self.SCHEDULE_COVER_ORIGIN then
                            self:SCHEDULE_COVER_ORIGIN(moveRun, function(x)
                                x:EngTask("TASK_FACE_ENEMY", 0)
                                x.CanShootWhenMoving = true
                                x.TurnData = {Type = VJ.FACE_ENEMY}
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
                                x:EngTask("TASK_FACE_ENEMY", 0)
                                x.CanShootWhenMoving = true
                                x.TurnData = {Type = VJ.FACE_ENEMY}
                            end)
                        end
                        self.TakingCoverT = c + delT
                        self.Repos_GesReloadNextT = c + delT 
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

function ENT:Spawn_Gibs()
    local minimalGibs = GetConVar("vj_stalker_minimal_gib"):GetBool()
    local maxSmallG = minimalGibs and math.ceil(self.MaxSmallGibs / 2) or self.MaxSmallGibs
    local maxLargeG = minimalGibs and math.ceil(self.MaxLargeGibs / 2) or self.MaxLargeGibs
    
    if self.HasGibOnDeathEffects then
        local gibOrigin = self:GetPos() + self:OBBCenter()
        local randOffset = Vector(mRand(-25, 25), mRand(-25, 25), mRand(5, 35))
        local randAng = Angle(mRand(-25, 25), mRand(-25, 25), mRand(-25, 25))
        local rngSnd = mRng(75, 105)
        local gibSounds = nil
        local pcfx = self.Gib_ParticleTbl or {}
        
        local snd = self.GoreOrGibSounds
        if snd and snd ~= false then
            if istable(snd) then
                gibSounds = table.Random(snd) 
            elseif isstring(snd) then
                gibSounds = snd  
            end
        end

        if istable(pcfx) and #pcfx > 0 then
            local played = false
            for _, fx in ipairs(pcfx) do
                if isstring(fx) and fx ~= "" and mRng(1, 2) == 1 then
                    ParticleEffect(fx, gibOrigin + randOffset, randAng, nil)
                    played = true
                end
            end
            if not played then
                local fx = table.Random(pcfx)
                if isstring(fx) and fx ~= "" then
                    ParticleEffect(fx, gibOrigin + randOffset, randAng, nil)
                end
            end
        end
        if gibSounds and gibSounds ~= false then 
            VJ.EmitSound(self, gibSounds, rngSnd, rngSnd)
        end 
        local bloodeffect = EffectData()
        bloodeffect:SetOrigin(gibOrigin)
        bloodeffect:SetColor(VJ_Color2Byte(Color(mRng(65, 155),mRng(5, 35),mRng(5, 35))))
        bloodeffect:SetScale(mRng(100, 205))
        util.Effect("VJ_Blood1", bloodeffect)

        local bloodspray = EffectData()
        bloodspray:SetOrigin(gibOrigin)
        bloodspray:SetScale(mRng(3, 10))
        bloodspray:SetFlags(3)
        bloodspray:SetColor(0)
        util.Effect("bloodspray", bloodspray)
        util.Effect("bloodspray", bloodspray)

        util.ScreenShake(gibOrigin, 20, 8, 1.5, 1500)
        VJ.ApplyRadiusDamage(self, self, gibOrigin, mRand(125, 355),mRng(5, 15), bit.bor(DMG_SLASH, DMG_CLUB), true, true)
    end 

    local gibs = {}
    for i = 1, mRng(5, maxSmallG) do gibs[#gibs+1] = "UseHuman_Small" end
    for i = 1, mRng(5, maxLargeG) do gibs[#gibs+1] = "UseHuman_Big" end
    if self.HasExtraGibVariants and not minimalGibs then
        gibs[#gibs+1] = "models/vj_base/gibs/human/heart.mdl"
        for i = 1,mRng(1, 2) do
            gibs[#gibs+1] = "models/vj_base/gibs/human/liver.mdl"
            gibs[#gibs+1] = "models/vj_base/gibs/human/lung.mdl"
        end
        if mRng(1, 2) == 1 then
            gibs[#gibs+1] = "models/vj_base/gibs/human/brain.mdl"
        end
        for i = 1,mRng(1, 2) do
            gibs[#gibs+1] = "models/vj_base/gibs/human/eye.mdl"
        end
        for i = 1,mRng(3, 24) do
            gibs[#gibs+1] = "models/gibs/hgibs_rib.mdl"
        end
        table.Add(gibs, {"models/gibs/hgibs.mdl","models/gibs/hgibs_scapula.mdl","models/gibs/hgibs_spine.mdl"})
        local intestineAmount = mRng(1, 8)
        for i = 1, intestineAmount do
            self:CreateGibEntity("intestine_gib", intestineAmount, {BloodType = "Red", Pos = gibOrigin})
        end
    end

    local maxParticles = math.floor(#gibs / 2)
    local particlesSpawned = 0

    for _, gibModel in ipairs(gibs) do
        local gibPos = self:LocalToWorld(self:OBBCenter() + Vector(mRng(-45, 45),mRng(-45, 45),mRng(10, 45)))
        local gibAng = Angle(mRand(-55, 55), mRand(-55, 55), mRand(-55, 55))
        local bloodParticle = VJ.PICK(self.Gib_ParticleTbl) or {}
        local pcfxP = PATTACH_POINT_FOLLOW
        local pcfxChance = tonumber(self.Gib_ParticleChance) or 5 
        self:CreateGibEntity("obj_vj_gib", gibModel, {BloodType = "Red", Pos = gibPos, Ang = gibAng}, function(gibEnt)
            if minimalGibs or not self.Gibs_UniquePcfx then return end 
            if particlesSpawned < maxParticles and mRng(1, pcfxChance) == 1 and bloodParticle ~= "" then
                ParticleEffectAttach(bloodParticle, pcfxP, gibEnt, 0)
                particlesSpawned = particlesSpawned + 1
            end
        end)
    end
end

function ENT:Custom_GibEffects()
    local conv = GetConVar("vj_stalker_gib"):GetInt()
    if not IsValid(self) or conv ~= 1 then return end
    local gibChance = tonumber(self.ChanceToGib) or 3  
    local gibDthConv = GetConVar("vj_stalker_gib_death_sounds"):GetInt() 
    if mRng(1, 3) == 1 then

        self.HasDeathSounds = false 
        self.HasDeathRagdoll = false
        self.HasPainSounds = false
        self.HasDeathAnimation = false
        self.GibbedOnDeath = true

        if gibDthConv == 1 then 
            local gibDeathSound = VJ.PICK(self.SoundTbl_GibDeath)
            VJ.EmitSound(self, gibDeathSound, mRng(60, 75), mRng(85, 115))
        end 
        self:Spawn_Gibs()
    end 
end

function ENT:HandleGibOnDeath(dmginfo, hitgroup)
    self:Custom_GibEffects()
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
ENT.KilledEnemySoundChance = mRng(1,2)
ENT.AllyDeathSoundChance = mRng(1,3)
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