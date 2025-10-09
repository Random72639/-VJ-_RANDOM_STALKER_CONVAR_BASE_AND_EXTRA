/*      ╔════༺†༻✝️༺†༻════╗
    👑  JESUS CHRIST IS LORD  👑
        ╚════༺†༻✝️༺†༻════╝ */
local mRng = math.random 
local mRand = math.Rand

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

ENT.SightDistance = 10000 -- How far it can see
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
ENT.Weapon_Accuracy = mRand(0.15, 0.95) -- Its accuracy with weapons, affects bullet spread! | x < 1 = Better accuracy | x > 1 = Worse accuracy

ENT.WeaponReloadAnimationDecreaseLengthAmount = mRand(0.05,0.105) -- This will decrease the time until it starts moving or attack again. Use it to fix animation pauses until it chases the enemy.
ENT.WeaponReloadAnimationDelay = mRand(0,0.1) -- It will wait certain amount of time before playing the animation
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AnimTbl_AlertFriendsOnDeath = {"vjges_gesture_signal_takecover","vjges_gesture_signal_right","vjges_gesture_signal_left","vjges_gesture_signal_halt","vjges_gesture_signal_advance","vjges_gesture_signal_forward","vjges_gesture_signal_group","vjseq_signal_advance", "vjseq_signal_forward", "vjseq_signal_group", "vjseq_signal_takecover", "vjseq_signal_halt", "vjseq_signal_left", "vjseq_signal_right"} -- Animations it plays when an ally dies that also has AlertFriendsOnDeath set to true
ENT.DeathAllyResponse = false -- How should allies response when it dies?
ENT.DeathAllyResponse_Range = mRand(1500,2500) -- Max distance allies respond to its death
ENT.DeathAllyResponse_MoveLimit = mRng(5, 20) -- Max number of allies that can move to its location when responding to its death
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.DisableWandering = false -- Disables wandering when the SNPC is idle
ENT.HasWeaponBackAway = true -- Should the SNPC back away if the enemy is close?
ENT.Weapon_RetreatDistance = mRand(350,675) -- When the enemy is this close, the SNPC will back away | 0 = Never back away
---------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Drops On Death ====== --
ENT.DropDeathLoot  = true -- Should it drop items on death?
ENT.DeathLootChance  = mRng(2,4) -- If set to 1, it will always drop it
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
ENT.PanicCooldownT = 0

    -- [Taunt on kill enemy] -- 
ENT.Taunt_OnKillEne = true
ENT.Taunt_OnKillEneChance = 3

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
ENT.BackGround_RadioLevel = 100
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
ENT.CombatDamageResponse_Cooldown = VJ.SET(ENT.MOHT1, ENT.MOHT2)
ENT.Weapon_StrafeCooldown = VJ.SET(ENT.NextFireStrafeT1, ENT.NextFireStrafeT2)
ENT.NextWaitForEnemyT1 = 0 
ENT.NextWaitForEnemyT2 = 0 
ENT.NextFireStrafeT1 = 0 
ENT.NextFireStrafeT2 = 0 
ENT.MOHT1 = 0
ENT.MOHT2 = 0

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
ENT.NextSoundTime_CryForAid1 = mRand(1,5)
ENT.NextSoundTime_CryForAid2 = mRand(6, 15)
ENT.CallForCryForAidSoundChance = 2
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
ENT.HasReactionToFollowCmd = true 
ENT.OnFollowAnimRespChance = 3 

    -- [Seek out medic] --
ENT.CanSeekOutMedic = true
ENT.MedicSeekCooldownTime = 5 
ENT.MedicSeekRange = 1250
ENT.MedicApproachStopRange = 350
ENT.NextMedicSeekT = 0
ENT.CurrentMedicTarget = nil

    -- [Limited gren count] --
ENT.CanHaveLimitedGrenades = true 
ENT.LimitedGrenCount = mRng(3, 8) -- randomly picks from 1 to this value
ENT.HumanGrenadeCount = 0

    -- [Pickup anim tbl] -- 
ENT.PlyPickUpAnim = {"pickup","civil_proc_pickup"}

    -- [React to fire] --
ENT.CanPlayBurningAnimations = true
ENT.CurrentlyBurning = false
ENT.HasFireSpecPain = true 
ENT.HasPlayedBurnDeathSound = false
ENT.NextBurnAnimationT = 0
ENT.OnFireIdle_Anim = {"DANCE_01","bugbait_hit"}

    -- [Gibbing] -- 
ENT.ChanceToGib = 3 -- Picks random number from 1 to this value

    -- [Dodge/evade ability] --
ENT.AllowedToCombatEvade = false -- Controls mechanic
ENT.HasCombatRollDodge = true -- Allows combat roll anims
ENT.IsHumanDodging = false 

ENT.Dodge_EneMin_Dist = 650
ENT.Dodge_EneMax_Dist = 5000 
ENT.Dodge_RollF_MxDist = 1250
ENT.Has_CmbDodgeChance = 3
ENT.Dodge_NextT = 0
ENT.Debug_InEneLOS = false -- Prints outcome whether an ene is looking at the SNPC or not. 

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
ENT.ArmorSparking_Chance = mRng(1, 10)

ENT.HasBulletRichocheting = true 
ENT.Arm_BulRichocheting = false
ENT.Arm_BulRichocheting_Chance = 10 

    -- [Tracking tags] -- 
ENT.SNPCMedicTag = false
ENT.DoesNotHaveCoverReload = false 
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
ENT.DrawNewWeaponSound = {"vj_base/weapons/draw_rifle.wav","vj_base/weapons/draw_pistol.wav"}

    -- [Drop sec wep on death] -- 
ENT.Weapon_DropSecondary = true 
ENT.Weapon_DropSecondary_Chance = 2 


    -- [Unused wsm stuff] -- 
ENT.CurrentDoesNotHaveOrLostPrimary = false -- For when the SNPC has primary weapon removed or dropped --
ENT.CurrentDoesNotHaveOrLostSecondary = false -- For when the SNPC has secondary weapon removed or dropped -- 

    -- [Find medical ent]
ENT.AllowedToFindMedEnt = true 
ENT.NextPickUpMedkitT = 0 

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
ENT.CanRepositionWhileReloading = true 
ENT.RepositionWhileReloadChance = 3 

    -- [React to flashlight] --
ENT.CanBeBlindedByPlyLight = true  
ENT.NextFlashlightCheckT = 0 

    -- [Panic on close prox to ene] -- (Sort of second version of weapon back away)
ENT.AllowedToPanicAtCloseProx = true
ENT.CloseProxPanicDist = 700
ENT.Panic_DetectAllyRange = 1200
ENT.Panic_AllySuppressCount = 5
ENT.NextPanicOnCloseProxT = 0

    -- [Spot ply reaction] -- 
ENT.PlayAnimWhenSpotFrPly = true
ENT.PlaySpotPlyAnimChance = 8
ENT.NextGreetPlyAnimT = 0

    -- [Idle fidget anims] -- 
ENT.HasIdleFidgetGestureAnims = true 
ENT.IsPlayingFidgetAnim = false
ENT.IdleFidgetChance = 3 
ENT.NextIdleFidgetGestureAnimT = 0

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

ENT.HeadshotSoundSfxChance = mRng(2,3)
ENT.HeadshotInstaKillChance = 0
ENT.HeadshotEffectsChance = mRng(2,3)

ENT.Headshot_ImpactFlinching = true 
ENT.Headshot_NextFlinchT = 0 
ENT.Headshot_ImpFlinchTbl = {"flinch_head_small_01", "flinch_head_small_02", "flinchheadgest"} 
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
ENT.DC_Writh_Decay_Thresh = 0.25 -- starts decaying when 25% time left
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

ENT.ShovedBackChance = 8
ENT.Shoved_Back_NextT = 0

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
ENT.ToxDmg_CoughTbl = {"general_sds/cough/cough".. mRng(1, 7) ..".wav"}

    -- [Armor imp effects] -- 
ENT.Ele_SparkImpFx = false
ENT.Ele_SparkImpFx_Chance = 15

ENT.ImpMetal_SparkArmor = false 
ENT.ImpMetal_SparkArmorChance = 3

local crouchActs = {
    [ACT_WALK_CROUCH] = true,
    [ACT_RUN_CROUCH] = true,
    [ACT_WALK_CROUCH_RIFLE] = true,
    [ACT_RUN_CROUCH_RIFLE] = true,
    [ACT_RUN_CROUCH_AIM] = true,
    [ACT_RUN_CROUCH_AIM_RIFLE] = true,
    [ACT_WALK_CROUCH_AIM] = true,
    [ACT_WALK_CROUCH_RPG] = true
}

ENT.Valid_CoverClassesTbl = {
    ["prop_physics"] = true,
    ["func_brush"] = true,
    ["prop_static"] = true,
    ["prop_dynamic"] = true
}

ENT.OnAlert_Cover = true 
ENT.AlertCover_DistCheck = 1500


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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ManageFriendlyVars()
    if GetConVar(self.FriendlyConvar):GetInt()  == 1  then
        self.VJ_NPC_Class = self.FriendlyNPC_Class 
        self.HasOnPlayerSight = true
        self.AlliedWithPlayerAllies = true
        self.YieldToAlliedPlayers  = true 
        self.BecomeEnemyToPlayer =  mRng(3,5)
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

    timer.Simple(0.25, function()
        if not IsValid(self) then return end
        
        self.HasAloneAiBehaviour = false 
        self.Shoved_Com_Active = false 
        self.HasCombatRollDodge = false 
        self.CanAvoidIncomingDanger = false
        self.Panic_DmgEne = false 
        self.AllowedToPanicAtCloseProx = false 
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
    timer.Simple(0.1, function()
        if IsValid(self) and self.HasBurnToDeathSounds and self.AutoDecideBtdSoundTbl then 
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
function ENT:ManageStepSd()
    timer.Simple(0.1, function()
        if IsValid(self) then 
            local stepSet = self.SoundTbl_FootStep
            if self.IsHeavilyArmored and self.HasSlowHeavyMovement then 
                stepSet = {"general_sds/heavy_footsteps/step_1.mp3","general_sds/heavy_footsteps/step_2.mp3","general_sds/heavy_footsteps/step_3.mp3","general_sds/heavy_footsteps/step_4.mp3","general_sds/heavy_footsteps/step_5.mp3","general_sds/heavy_footsteps/step_6.mp3"}
                return 
            end 

            if self.Rng_FootStepSet then 
                local set = mRng(1, 6)
                if set == 1 then 
                    stepSet = {"general_sds/ex_footsteps/gear1.wav","general_sds/ex_footsteps/gear2.wav","general_sds/ex_footsteps/gear3.wav","general_sds/ex_footsteps/gear4.wav","general_sds/ex_footsteps/gear5.wav","general_sds/ex_footsteps/gear6.wav",}
                elseif set == 2 then 
                    stepSet = {"npc/metropolice/gear1.wav","npc/metropolice/gear2.wav","npc/metropolice/gear3.wav","npc/metropolice/gear4.wav","npc/metropolice/gear5.wav","npc/metropolice/gear6.wav"}
                elseif set == 3 then 
                    stepSet = {"npc/footsteps/hardboot_generic1.wav","npc/footsteps/hardboot_generic2.wav","npc/footsteps/hardboot_generic3.wav","npc/footsteps/hardboot_generic4.wav","npc/footsteps/hardboot_generic5.wav","npc/footsteps/hardboot_generic6.wav","npc/footsteps/hardboot_generic8.wav"} 
                elseif set == 4 then 
                    stepSet = {"general_sds/ex_footsteps/footstep1.wav","general_sds/ex_footsteps/footstep2.wav","general_sds/ex_footsteps/footstep3.wav","general_sds/ex_footsteps/footstep4.wav","general_sds/ex_footsteps/footstep5.wav","general_sds/ex_footsteps/footstep6.wav","general_sds/ex_footsteps/footstep7.wav","general_sds/ex_footsteps/footstep8.wav",}
                elseif set == 5 then 
                    stepSet = {"general_sds/ex_footsteps/hardboot_generic1.wav","general_sds/ex_footsteps/hardboot_generic2.wav","general_sds/ex_footsteps/hardboot_generic3.wav","general_sds/ex_footsteps/hardboot_generic4.wav","general_sds/ex_footsteps/hardboot_generic5.wav","general_sds/ex_footsteps/hardboot_generic6.wav","general_sds/ex_footsteps/hardboot_generic7.wav","general_sds/ex_footsteps/hardboot_generic8.wav"}
                elseif set == 6 then 
                    stepSet = {"general_sds/ex_footsteps/concrete1.wav","general_sds/ex_footsteps/concrete2.wav","general_sds/ex_footsteps/concrete3.wav","general_sds/ex_footsteps/concrete4.wav","general_sds/ex_footsteps/tile1.wav","general_sds/ex_footsteps/tile2.wav","general_sds/ex_footsteps/tile3.wav","general_sds/ex_footsteps/tile4.wav"}
                end
            end 
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


function ENT:ManageBrutalSounds()
    if not IsValid(self) then return end
    self.DefaultDeathSounds = self.DefaultDeathSounds or CopyTable(self.SoundTbl_Death or {})
    self.DefaultPainSounds  = self.DefaultPainSounds  or CopyTable(self.SoundTbl_Pain or {})
    local brutalDeathEnabled = GetConVar("vj_stalker_brutal_death_vo"):GetInt() == 1
    local brutalPainEnabled  = GetConVar("vj_stalker_brutal_pain_vo"):GetInt() == 1
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
        print("Total brutal pain sounds: " .. #t)
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
        print("Total brutal cry-for-aid sounds: " .. #self.SoundTbl_CryForAid)
    else
        self.SoundTbl_CryForAid = CopyTable(self.DefaultCryForAidSounds or {})
        print("Default cry-for-aid: " .. #self.SoundTbl_CryForAid)
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
                print("Has shoot while moving behaviour.")
            else
                self.HasMoveAndShoot = false
                print("Does not have shoot while moving behaviour.")
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
    if curT < self.NextMoveFireToggleT then return end

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
            local defaultFov         = self.SightAngle
            local curT               = CurTime()
            local cvar_viewangle     = GetConVar("vj_stalker_snpc_view_angle"):GetInt()
            local cvar_radio         = GetConVar("vj_stalker_radio_chatter"):GetInt()
            local cvar_deathanims    = GetConVar("vj_stalker_death_anims"):GetInt()
            local cvar_dodging       = GetConVar("vj_stalker_dodging"):GetInt()
            local cvar_neverforget   = GetConVar("vj_stalker_never_forget"):GetInt()
            local cvar_extdelay      = GetConVar("vj_stalker_extended_delay"):GetInt()
            local cvar_limitednades  = GetConVar("vj_stalker_limited_grenades"):GetInt()

            self.Danger_DetectSiganlT = curT + mRand(1, 5)
            self.WeaponSwitchT = curT + mRand(20,50) 
            self.NextEvDngEntT = curT + mRand(1, 10)
            self.NextPanicOnCloseProxT = curT + mRand(5, 15)
            self.NextFindLootT = curT + mRand(5, 25)
            self.DeathAnimationChance = mRng(2,5)
            self.Avoid_C_HairNextT = curT + mRand(4.25, 8.45)
            self.BloodDecalDistance = mRand(100,320)
            self.IdleDialogueDistance = mRng(350,650)
            self.NextIdleFidgetGestureAnimT = curT + mRand(1, 15)
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

            if mRng(1, 2) == 1 or self.IsMedic then 
                self.CanHumanHealSelf = true 
            end

            if self.RngPickMoveAndShoot then 
                if mRng(1,2) == 1 then 
                    self.Weapon_Strafe = true 
                else 
                    self.Weapon_Strafe = false 
                end
            end
            
            if self.RngPickMoveAndShoot then 
                if mRng(1,2) == 1 then 
                    self.Weapon_CanMoveFire = true 
                else 
                    self.Weapon_CanMoveFire = false 
                end
            end

            if not self.Weapon_FindCoverOnReload then 
                print("Doesn't have find cover reload.")
                self.DoesNotHaveCoverReload = true 
            else 
                print("Has find cover reload.")
            end 

            if self.HasGrenadeAttackMechRng then 
                if mRng(1,3) == 1 then 
                    self.HasGrenadeAttack = false 
                else 
                    self.HasGrenadeAttack = true 
                end 
            end 

            if self.HasGrenadeAttack then 
                if cvar_limitednades == 1 and self.CanHaveLimitedGrenades then
                    local grenCount = mRng(1, self.LimitedGrenCount)
                    self.HasLimitedGrenadeCount = true 
                    self.HumanGrenadeCount = grenCount
                end 
            end 

            if self.IsHeavilyArmored then 
                self.TurningSpeed = 10
            else 
                self.TurningSpeed = mRng(15,25)
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
                self.AllowedToCombatEvade = true
            end

            if cvar_neverforget == 1 then
                local infT = curT + 9999999999999
                local defT = curT + mRand(10, 20)
                print(infT .. " and " .. defT)
                self.EnemyTimeout = infT
            else
                self.EnemyTimeout = defT
            end 

            if cvar_extdelay == 1 then 
                local wep = self:GetActiveWeapon()
                local defWait = wep.NPC_TimeUntilFire
                local delay = mRand(0.5, 2.55)
                if IsValid(wep) and IsValid(self) then 
                    wep.NPC_TimeUntilFire = defWait + delay
                end 
            end 

            self.DamageAllyResponse = VJ.PICK({"OnlyMove","OnlySearch",true})

            if mRng(1,2) == 1 then self.HasFireInBurstAbility = true end 
            if mRng(1,2) == 1 then self.AllowedToChangeFireOnDist = true end  
            if mRng(1,2) == 1 then self.CanDropWeaponWhenOnFire = true end
            if mRng(1,4) == 1 then self.CombatDamageResponse = false end
            if mRng(1,3) == 1 then self.Weapon_CanCrouchAttack = false end
            if mRng(1,4) == 1 then self.Weapon_WaitOnOcclusion = false end
            if mRng(1,3) == 1 then self.ConstantlyFaceEnemy = true end
            if mRng(1,2) == 1 then self.ConstantlyFaceEnemy_IfVisible = false end
            if mRng(1,2) == 1 then self.ConstantlyFaceEnemy_IfAttacking = true end
            if mRng(1,3) == 1 then self.DamageByPlayerDispositionLevel = 0 end  
            if mRng(1,3) == 1 then self.CallForHelpAnimFaceEnemy = true end
            if mRng(1,3) == 1 then self.BloodDecalUseGMod = true end
            if mRng(1,3) == 1 then self.IdleDialogueCanTurn = false end
            if mRng(1,3) == 1 then self.CanRedirectGrenades = false end
            if mRng(1,4) == 1 and not self.IsHeavilyArmored then self.HasWeaponBackAway = false end 
            if mRng(1,3) == 1 then self.DisableWandering = true end 
            if mRng(1,2) == 1 and not self.IsHeavilyArmored then self.CanBecomeDefensiveAtLowHP = true end     
            if mRng(1,3) == 1 then self.Weapon_FindCoverOnReload = false end
            if mRng(1,3) == 1 then self.DropDeathLoot = false end  
        end 
    end)
end

ENT.Rng_MoveHideTime = true 
ENT.Rng_SrafeTime = true 
ENT.Rng_WaitForEneTime = true

ENT.CombatDamageResponse_Cooldown = VJ.SET(ENT.MOHT1, ENT.MOHT2)
ENT.Weapon_StrafeCooldown = VJ.SET(ENT.NextFireStrafeT1, ENT.NextFireStrafeT2)
ENT.NextWaitForEnemyT1 = 0 
ENT.NextWaitForEnemyT2 = 0 
ENT.NextFireStrafeT1 = 0 
ENT.NextFireStrafeT2 = 0 
ENT.MOHT1 = 0
ENT.MOHT2 = 0
function ENT:MngeExVarTimes()
    if not self.RngCombatTimers or GetConVar("vj_stalker_rng_combat_var_times"):GetInt() ~= 1 then return end 

    local passiveOrAggressive = mRng(1, 6)  
    local moveWhileShooting   = mRng(1, 4)
    local moveOrHideOnDamage  = mRng(1, 6)

    local moveHideTimers = {
        {mRand(1, 5), mRand(5, 10)},  
        {mRand(2, 5), mRand(4, 9)},  
        {mRand(5, 10), mRand(5, 15)},  
        {mRand(1, 10), mRand(1, 15)},  
        {mRand(10, 15), mRand(15, 20)},
        {mRand(1, 15), mRand(1, 20)}
    }

    if self.Rng_MoveHideTime and self.CombatDamageResponse then 
        self.MOHT1, self.MOHT2 = unpack(moveHideTimers[moveOrHideOnDamage])
    else
        self.MOHT1 = 0
        self.MOHT2 = 0
        self.CombatDamageResponse_Cooldown = VJ.SET(3, 5) 
    end 

    local shootingTimers = {
        {mRand(1, 2), mRand(2, 4.25)},      
        {mRand(3, 5), mRand(6, 8)},       
        {mRand(3, 8), mRand(9, 10)},      
        {mRand(2, 7), mRand(8, 10)},       
        {mRand(10, 11), mRand(10, 12)},     
        {mRand(13, 14), mRand(14, 15)},   
        {mRand(10, 15), mRand(16, 18)}    
    }

    local nextStrafeWhileShootTimers = {
        {mRand(0.5, 2.5), mRand(2, 5)},
        {mRand(1, 5.5), mRand(5, 10.5)},
        {mRand(5, 10), mRand(6.5, 15)},
        {mRand(5, 15), mRand(10, 20)},
    }

    if self.Rng_SrafeTime and self.Weapon_Strafe then
        local strafeTimers = nextStrafeWhileShootTimers[moveWhileShooting] or {0,0}
        self.NextFireStrafeT1, self.NextFireStrafeT2 = unpack(strafeTimers)
    else
        self.Weapon_StrafeCooldown = VJ.SET(3, 6)
        self.NextFireStrafeT1 = 0 
        self.NextFireStrafeT2 = 0 
    end
 
    local waitForEnemyTimers = {
        VJ.SET(1, 5),
        VJ.SET(5, 10),
        VJ.SET(5, 15),
        VJ.SET(10, 15),
        VJ.SET(10, 20),
        VJ.SET(5, 25)
    }

    if self.Rng_WaitForEneTime and self.Weapon_OcclusionDelay then 
        self.Weapon_OcclusionDelayTime = waitForEnemyTimers[passiveOrAggressive]
    else 
        self.Weapon_OcclusionDelayTime = VJ.SET(3, 5)
    end

    print("MOHT1:", self.MOHT1)
    print("MOHT2:", self.MOHT2)
    print("NextFireStrafeT1 - 2:", self.NextFireStrafeT1 and  self.NextFireStrafeT2)
    print("Weapon_OcclusionDelayTime:", self.Weapon_OcclusionDelayTime)
end

---------------------------------------------------------------------------------------------------------------------------------------------
//Fix parenting for amb glow 
function ENT:WeaponFlashlight()
    if GetConVar("vj_stalker_wep_flashlight"):GetInt()  ~= 1 then return false end 
    local weaponLightChance = self.WeaponFlashLightChance
    
    timer.Simple(0.1, function()
        if not IsValid(self) or not IsValid(self:GetActiveWeapon()) or mRng(1, weaponLightChance) ~= 1 or not self.AllowedToHaveWepFlashLight then return end

        if self:GetActiveWeapon().HoldType == "pistol" or self:GetActiveWeapon().HoldType == "revolver" or self:GetActiveWeapon().HoldType == "rpg" then 
            return 
        end 

        local wep = self:GetActiveWeapon()
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
        self.WeaponFlashlightSpotLight:SetKeyValue("SetNearZ", tostring(rngNearz))
        self.WeaponFlashlightSpotLight:SetKeyValue("SetFarZ", tostring(rngFarz))
        self.WeaponFlashlightSpotLight:SetKeyValue("SetFOV", tostring(rngFOV))
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
        if self.HasWeaponFlashAmbGlow and mRng(1, ambLightRngChance) == 1 then 
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

        if responseAnim then
            ally:PlayAnim(responseAnim, true, VJ.AnimDuration(ally, responseAnim), ally.CallForHelpAnimFaceEnemy)
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
    local busy = self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK or self:IsBusy()
    if self.PerformingAlertBehavior or self.IsGuard or self.CurrentlyHealSelf or busy or not self:IsOnGround() then return end
    if CurTime() < self.NextReactiveCoverT then return end

    local enemy = self:GetEnemy()
    if not IsValid(enemy) then return end
    local exDelay = mRand(5, 20) or 20
    local wep = enemy:GetActiveWeapon()
    local chance = self.ReactiveCoverChance or 3 

    if not IsValid(wep) then return end 
    if mRng(1, chance) ~= 1 then return end

    if self:IsCurrentSchedule(SCHED_TAKE_COVER_FROM_ORIGIN) or self:IsCurrentSchedule(SCHED_TAKE_COVER_FROM_ENEMY) then return end

    self.NextReactiveCoverT = CurTime() + self.ReactiveCoverNextT + exDelay
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
        coverDelay = math.Rand(1.5, 3.5)
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
        coverDelay = math.Rand(1, 5)
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

    timer.Simple(0.1, function()
        if not IsValid(self) then return end
        if choice == 1 and IsValid(enemy) then
            self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH", function(x)
            if mRng(1, 2) == 1 then 
                x.CanShootWhenMoving = true
                x.TurnData = {Type = VJ.FACE_ENEMY}
            else
                x.CanShootWhenMoving = false  
                x.TurnData = {Type = VJ.FACE_ENEMY, Target = nil}
            end 
        end)
            coverDelay = mRand(1.5, 3.5)
        elseif choice == 2 or (choice == 3 and mRng(1, 2) == 1) then
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
            coverDelay = mRand(1, 5)
        elseif choice == 3 and coverPos then
            self:SetLastPosition(coverPos)
            self:SCHEDULE_GOTO_POSITION("TASK_RUN_PATH", function(x)
            x.DisableChasingEnemy = true
            if mRng(1, 2) == 1 then 
                x.CanShootWhenMoving = true
                x.TurnData = {Type = VJ.FACE_ENEMY}
            else
                x.CanShootWhenMoving = false  
                x.TurnData = {Type = VJ.FACE_ENEMY, Target = nil}
            end 
        end)
            coverDelay = mRand(1, 5)
        elseif choice == 3 and not coverPos then
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
    if not IsValid(enemy) or not self.PerformingAlertBehavior then return end
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

function ENT:FireFlareGun(enemy)
    if not IsValid(enemy) or not self.PerformingAlertBehavior then return end
    local conv = GetConVar("vj_stalker_fire_flares"):GetInt()
    local mDist = self.FireFlareSeq_MaxDist or 5000
    local busy = self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK or self:IsBusy()
    if conv ~= 1 or self:GetPos():Distance(enemy:GetPos()) < mDist or not self.Alerted or busy then 
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
    if IsValid(activeWeapon) and self.CanFireFlareGunSeq and not self:IsBusy() and mRng(1, fireFlareChance) == 1 then
        if self.NextFireFlareT <= CurTime() then 
            local shootFlare = "shootflare" or ""
            local sFAnimT = VJ.AnimDuration(self, shootFlare) or 3 
            activeWeapon:SetNoDraw(true)
            VJ.EmitSound(self, drawWepSnd, rngSnd, rngSnd)
            self:RemoveAllGestures()
            self:PlayAnim("vjseq_" .. shootFlare, true, sFAnimT, true)

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
                    VJ.EmitSound(self, "vj_base/weapons/flaregun/single.wav", rngSnd, rngSnd)
                    local flareround = ents.Create("obj_vj_flareround")
                    local y = mRand(-50,50)
                    local z = mRand(10000,15000)
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
                    VJ.EmitSound(self, self.DrawNewWeaponSound, rngSnd, rngSnd)
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
    timer.Simple(mRand(1, 2.5), function() 
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
    if not self.CanPickSecondaryWeapon or not IsValid(self) or GetConVar("vj_stalker_weapon_switching"):GetInt() == 0 then return end
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

function ENT:WeaponSwitchMechanic()
    if GetConVar("vj_stalker_weapon_switching"):GetInt() ~= 1 or self:IsBusy("Activities") or self.VJ_IsBeingControlled or not IsValid(self) then
        return false
    end

    local ene = self:GetEnemy()
    local curWep = self:GetActiveWeapon()

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

    if IsValid(ene) and self.CanHumanSwitchWeapons and not ene.VJ_ID_Boss and not ene.IsVJBaseSNPC_Tank and self:GetWeaponState() != VJ.WEP_STATE_RELOADING and self:GetPos():Distance(ene:GetPos()) < self.WepSwitchRange_Max and not self:IsBusy() and CurTime() > self.WeaponSwitchT and IsValid(curWep) and not curWep.IsMeleeWeapon and not self:IsMoving() then
        VJ.EmitSound(self, self.DrawNewWeaponSound, 85, 115)
        -- Switch to secondary
        if self.CurrentWeapon == 0 and curWep:Clip1() > 1 then
            self:RemoveAllGestures()
            local anim = VJ.PICK({"vjseq_" .. VJ.PICK(self.Sts_SeqWepAnim), "vjges_" .. VJ.PICK(self.Sts_GesWepAnim)})
            self:PlayAnim(anim, true, VJ.AnimDuration(self, anim), false)
            self:DoChangeWeapon(self.SecondaryWeaponEntity, true)
            self.CurrentWeapon = 1
            self.WeaponSwitchT = CurTime() + mRand(15, 20)
            print("I've switched to my secondary")

        -- Switch back to primary
        elseif self.CurrentWeapon == 1 then
            self:RemoveAllGestures()
            local anim = VJ.PICK({"vjseq_" .. VJ.PICK(self.Stp_SeqWepAnim), "vjges_" .. VJ.PICK(self.Stp_GesWepAnim)})
            self:PlayAnim(anim, true, VJ.AnimDuration(self, anim), false)
            self:DoChangeWeapon(self.WeaponInventory.Primary, true)
            self.CurrentWeapon = 0
            self.WeaponSwitchT = CurTime() + mRand(5, 45)
            print("I've switched to my primary")
        else
            self.WeaponSwitchT = CurTime() + mRand(5, 25)
        end

    elseif not IsValid(ene) and self.CurrentWeapon == 1 and CurTime() > self.NextIdleWeaponSwitchT and self:GetNPCState() == NPC_STATE_IDLE and not self.Alerted then
        if IsValid(self.WeaponInventory.Primary) and isstring(self.HumanPrimaryWeapon) and self.HumanPrimaryWeapon ~= "" and weapons.GetStored(self.HumanPrimaryWeapon) then 
            self:RemoveAllGestures()
            local anim = VJ.PICK({"vjseq_" .. VJ.PICK(self.Stp_SeqWepAnim), "vjges_" .. VJ.PICK(self.Stp_GesWepAnim)})
            self:PlayAnim(anim, true, VJ.AnimDuration(self, anim), false)
            self:DoChangeWeapon(self.WeaponInventory.Primary, true)
            self.CurrentWeapon = 0
            self.NextIdleWeaponSwitchT = CurTime() + mRand(5, 15)
            print("Switched back to primary weapon while idle.")
        else
            print("Idle switch failed: Invalid or missing primary weapon entity!")
        end

    elseif self.Alerted and CurTime() > self.WeaponSwitchT then
        self.WeaponSwitchT = CurTime() + mRand(5, 25)
    end
end

function ENT:OnWeaponChange(newWeapon, oldWeapon, invSwitch)
    if invSwitch then 
        timer.Simple(mRand(0.05, 0.1), function()
            if IsValid(self) then
                VJ.EmitSound(self, VJ.PICK(self.DrawNewWeaponSound), mRng(90, 115), mRng(85, 125))
            end
        end)
    end 
end
---------------------------------------------------------------------------------------------------------------------------------------------
// -- Just to track which weapon is being used \\ -- 
function ENT:TrackHeldWeapon()
    local wep = self:GetActiveWeapon()
    local holdPrim = self.IsHoldingPrimaryWeapon
    local holdSec = self.IsHoldingSecondaryWeapon
    if IsValid(wep) and self:Alive() then
        if wep:GetClass() == self.HumanPrimaryWeapon then
            if not holdPrim then
                print("Now holding primary weapon.")
            end
            holdPrim = true
            holdSec = false
        elseif wep:GetClass() == self.HumanSecondaryWeapon then
            if not holdSec then
                print("Now holding secondary weapon.")
            end
            holdPrim= false
            holdSec = true
        else
            if holdPrim or holdSec then
                print("No longer holding a recognized weapon.")
            end
            holdPrim = false
            holdSec = false
        end
    else
        if holdPrim or holdSec then
            print("No weapon is being held.")
        end
        holdPrim = false
        holdSec = false
    end
end

function ENT:TrackLosingWeapon()
    local wep = self:GetActiveWeapon()
    if not IsValid(wep) then
        if self.IsHoldingPrimaryWeapon then
            print("Lost primary weapon!")
            self.IsHoldingPrimaryWeapon = false
            self.CurrentDoesNotHaveOrLostPrimary = true
        elseif self.IsHoldingSecondaryWeapon then
            print("Lost secondary weapon!")
            self.IsHoldingSecondaryWeapon = false
            self.CurrentDoesNotHaveOrLostSecondary = true
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnGrenadeAttack(status, overrideEnt, landDir)
    local forceGesGrenMoveChance = self.FrcMoveGesGrenThrwChance
    self.CurrentGrenadeThrow_IsCloseRange = false
    self.CurrentGrenadeThrow_IsGesture = false 

    if status == "Init" then
        self:RemoveAllGestures()
        local ene = self:GetEnemy()
        local distToEnemy = (IsValid(ene) and self:GetPos():Distance(ene:GetPos())) or 1250

        if not self.VJ_IsBeingControlled and self.HasAltGrenThrowAnims then
            if distToEnemy <= self.NPC_GrenadeCloseProxDist and mRng(1, 3) ~= 1 then
                print("Close-range gren throw")
                local closeThrow = VJ.PICK({"grendrop", "grenplace"})
                self.AnimTbl_GrenadeAttack = "vjseq_" .. closeThrow
                self.GrenadeAttackAttachment = "anim_attachment_LH"
                self.CurrentGrenadeThrow_IsCloseRange = true
                return
            end

            local throwType = mRng(1, 3)
            if throwType == 1 then
                print("L-Handed grenade throw")
                local throwAnim = VJ.PICK({"grenthrow", "throwitem", "grenthrow_hecu"})
                self.AnimTbl_GrenadeAttack = "vjseq_" .. throwAnim
                self.GrenadeAttackAttachment = "anim_attachment_LH"

            elseif throwType == 2 and not self.IsGuard and not self:IsMoving() then
                print("Ges-gren throw")
                local throwAnim = VJ.PICK({"vjges_grenthrow_gesture"})
                self.CurrentGrenadeThrow_IsGesture = true 
                self.AnimTbl_GrenadeAttack = throwAnim
                self.GrenadeAttackAttachment = "anim_attachment_LH"

                if self.ForceMoveOnGesGrenThrow and mRng(1, forceGesGrenMoveChance) == 1 and IsValid(self) then
                    self:StopMoving()
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
                else
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
                end

            elseif throwType == 3 and self.HasRightHandedGrenThrowAnim then
                print("R-Handed greb throw")
                local throwAnim = VJ.PICK({"righthand_grendrop_cmb_b", "righthand_grenthrow_cmb_b"})
                self.AnimTbl_GrenadeAttack = "vjseq_" .. throwAnim
                self.GrenadeAttackAttachment = "anim_attachment_RH"
            end
        end
    end
end

function ENT:OnGrenadeAttackExecute(status, grenade, overrideEnt, landDir, landingPos)
    if self.HasLimitedGrenadeCount and self.HumanGrenadeCount > 0 then
        self.HumanGrenadeCount = self.HumanGrenadeCount - 1
        print(self.HumanGrenadeCount)
    end

    local enemy = self:GetEnemy()
    if status == "PostSpawn" then
        if not IsValid(overrideEnt) then
            if self.AllowedToHaveGrenTrail then
                if GetConVar("vj_stalker_gren_trail"):GetInt()  == 1 then
                    util.SpriteTrail(grenade, mRng(5, 10), Color(mRand(100, 150), mRand(100, 150), mRand(100, 150)), true, mRand(2.5, 3.5), 3, 0.35, 1 / (6 + 6) * mRng(0.4, 0.7), "trails/smoke")
                end
                if GetConVar("vj_stalker_red_grenade_trail"):GetInt()  == 1 then
                    local redTrail = util.SpriteTrail(grenade, 1, Color(255, 0, 0), true, mRng(9, 15), mRng(1, 3), 0.5, 0.0555, "sprites/bluelaser1.vmt")
                    if IsValid(redTrail) then
                        redTrail:SetKeyValue("rendermode", "5")
                        redTrail:SetKeyValue("renderfx", "0")
                    end
                end
            end

            if not self.CurrentGrenadeThrow_IsGesture and mRng(1, self.FindCoverChanceAfter_Grenade) == 1 and not self.IsGuard then 
                self:StopMoving()
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
                else
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
                end
            end 
        end

        if self.HasDynamicThrowArc then

            if not IsValid(enemy) then
                local fallbackVel = self:GetForward() * mRand(500, 750) + self:GetUp() * mRand(150, 225)
                fallbackVel = fallbackVel + self:GetRight() * mRand(-30, 30)
                return fallbackVel
            end
            
            local trEnemyTarget = util.TraceLine({
                start = enemy:GetPos(),
                endpos = enemy:GetPos() + Vector(0, 0, mRng(650, 900)),
                filter = enemy
            })

            local trSelfPosition = util.TraceLine({
                start = self:GetPos(),
                endpos = self:GetPos() + Vector(0, 0, mRng(650, 900)),
                filter = self
            })

            if trSelfPosition.Hit or (trEnemyTarget.Hit and IsValid(enemy)) then
                return (landingPos - grenade:GetPos()) + (self:GetUp() * mRand(100, 225) + self:GetForward() * mRand(350, 550) + self:GetRight() * mRand(-35, 45))
            end

            local distanceToTarget = grenade:GetPos():Distance(landingPos)
            local scaleFactor = math.Clamp(distanceToTarget / 2925, 1, 3)
            local upDir, forwardDir, leftOrRightDir

            if self.CurrentGrenadeThrow_IsCloseRange then
                upDir = self:GetUp() * mRand(50, 150) * scaleFactor
                forwardDir = self:GetForward() * mRand(100, 150) * scaleFactor
                leftOrRightDir = self:GetRight() * mRand(-35, 45) * scaleFactor
                print("Reduced Close-Range Throw")
            elseif distanceToTarget > 2925 then
                upDir = self:GetUp() * mRand(1200, 1525) * scaleFactor
                forwardDir = self:GetForward() * mRand(1525, 1855) * scaleFactor
                leftOrRightDir = self:GetRight() * mRand(-60, 80) * scaleFactor
                print("Arc-Throw")
            else
                upDir = self:GetUp() * mRand(235, 275) * scaleFactor
                forwardDir = self:GetForward() * mRand(775, 1255) * scaleFactor
                leftOrRightDir = self:GetRight() * mRand(-30, 30) * scaleFactor
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
    if not IsValid(self) or not self.HasGrenadeAttack then return false end 
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
    local disp = self:CheckRelationship(activator)
    if (disp == D_LI or disp == D_NU) and self.CanReactToUse and curTime > self.LastReactToUseTime and not self.Alerted and not self:IsBusy() and self:Visible(activator) then

        if mRng(1, self.ReactToPlyIntChance) == 1 then
            local chosenFlinch = VJ.PICK(self.ReactToPlyUseAnim)
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
    if not IsValid(grenade) then return end
    local frontPos = self:GetPos() + self:GetForward() * mRand(1, 5) +self:GetUp() * mRand(1, 5) +self:GetRight() * mRand(-5, 5)

    grenade:SetPos(frontPos)
    grenade:Spawn()

    VJ.EmitSound(grenade, "general_sds/ex_thrw_snd/m67_pin.wav", rngSnd, rngSnd)
    self.LastGrenadeSpawnTime = CurTime() + 100

    if mRng(1, 2) == 1 then
        local flinchAnim = VJ.PICK({"flinch_rarm_small_01","flinch_larm_small_01","flinch_gen_small_01"})
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
            if not IsValid(self) or self.Dead then return end
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

    local ene = self:GetEnemy()
    if not IsValid(ene) then return end 

    local ally = self:Allies_Check(self.Incap_SpawnGren_AllyDist)
    if ally then 
        self:ManageIncapGrenadeTimer(false) 
        return
    end 

    local eneDist = self:GetPos():Distance(ene:GetPos())
    if CurTime() < (self.LastGrenadeSpawnTime or 0) then return end 

    if mRng(1, self.Incap_SpawnGrenChance) ~= 1 then
        self.Incap_SpawnGrenNextT = CurTime() + mRand(1, 5)
        return
    end

    if CurTime() > (self.Incap_SpawnGrenNextT or 0) and self.Incap_SpawnGren_DngClose and self:Visible(ene) and eneDist <= self.Incap_SpawnGren_EneDist then
        self:ManageIncapGrenadeTimer(self.Incap_SpawnGrenDelay)
        self.Incap_SpawnGrenNextT = CurTime() + mRand(15, 25)
        self.LastGrenadeSpawnTime = CurTime() + mRand(15, 25)
    else
        self:ManageIncapGrenadeTimer(false) 
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------


/*

    if !self.CanISurrender and !self.PlayerFriendly and !self.Surrendered then  return false end
        if CurTime() > self.SupplyTakeT and self.CanISurrender == true and self.Surrendered == true and self:IsOnGround() then

        print("You stole from this poor man")
        self.SupplyTook = true
        self.SupplyTakeT = CurTime() + 30

        plyUse:GiveAmmo(mRng(15,30), "Pistol")
        plyUse:GiveAmmo(mRng(20,40), "SMG1")
        plyUse:GiveAmmo(mRng(20,40), "AR2")
        plyUse:GiveAmmo(mRng(5,10), "Buckshot")
        plyUse:GiveAmmo(mRng(0,2), "grenade")
        plyUse:GiveAmmo(mRng(0,2), "AR2AltFire")
        plyUse:SetHealth(plyUse:Health() + mRng(10,30))
        plyUse:SetArmor(plyUse:Armor() + mRng(10,20))

        if self.CanISurrender == true and self.PlayerFriendly == false and self:GetActiveWeapon() ~= NULL then
            self:GetActiveWeapon():Remove()
        end
    end
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RetreatAfterMeleeAttack()
    if self.VJ_IsBeingControlled or not IsValid(self) then return false end 

    local curT = CurTime()
    if IsValid(self:GetEnemy()) and self:Visible(self:GetEnemy()) and curT > self.Flee_AfterMeleeT and self.Flee_AfterMelee and mRng(1, self.Flee_AfterMeleeChance) == 1 then
        self:StopMoving()
        self:StopAttacks(true)
        print("Fleeing after melee attack")
        
        timer.Simple(mRand(0.15, 0.35), function()   
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
        self.NextMeleeAttackTime = curT + mRand(2.5, 5)
        self.Flee_AfterMeleeT = curT + mRand(5, 15)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackKnockbackVelocity(ent)
    local forwardStrength = mRng(50, 100)
    local upStrength = mRng(15, 65)
    local sideStrength = mRng(-75, 75)
    local mul = mRng(2,3)
    
    if self.IsHeavilyArmored then
        forwardStrength = forwardStrength * mul
        upStrength = upStrength * mul
    end

    return self:GetForward() * forwardStrength + self:GetUp() * upStrength + self:GetRight() * sideStrength
end

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
    if not IsValid(ent) then return false end

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
                local breakChance = self.BreakPlyArmorChance or 6 
            
                if self.IsHeavilyArmored then 
                    breakChance = math.max(1, breakChance / 3) 
                end 
            
                if mRng(1, breakChance) == 1 then
                    local currentArmor = ent:Armor() or 0
                    local maxArmor = ent:GetMaxArmor() or 100
                    if currentArmor > (maxArmor * (self.BreakPlyArmorThresh / 100)) then
                        local amrorBreak = VJ.PICK(self.SoundTbl_ExtraArmorImpacts)
                        ent:SetArmor(0)
                        VJ.EmitSound(ent, amrorBreak ,rngSnd, rngSnd)
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
        if self.Melee_HasRandomsCusAttacks then 
            local mAnim = mRng(1, 17) 
            local canKick = self.Melee_CanKick
            local meleeAnim = self.AnimTbl_MeleeAttack
            local nextMeleeT = self.NextMeleeAttackTime
            local timeUntilDmg = self.TimeUntilMeleeAttackDamage

            if mAnim == 1 and canKick then 
                meleeAnim = {"vjseq_kick_door"}
                nextMeleeT = mRand(0.5, 2)
                timeUntilDmg = mRand(0.45, 0.55)

            elseif mAnim == 2 and canKick then 
                meleeAnim = {"vjseq_kick_cmb_b"}
                nextMeleeT = mRand(0.25, 2.5) 
                timeUntilDmg = mRand(0.45, 0.55)

            elseif mAnim == 3 and canKick then 
                meleeAnim = {"vjseq_civil_proc_kickdoorbaton"}
                nextMeleeT = mRand(0.65, 3.25) 
                timeUntilDmg = mRand(0.65, 0.75)

            elseif mAnim == 4 then 
                meleeAnim = {"vjseq_gunhit1_cmb_b"}
                nextMeleeT = mRand(0.95, 2.55) 
                timeUntilDmg = mRand(0.65, 0.7)

            elseif mAnim == 5 then 
                meleeAnim = {"vjseq_gunhit2_cmb_b"}
                nextMeleeT = mRand(0.35, 1.25) 
                timeUntilDmg = mRand(0.1, 0.2)

            elseif mAnim == 6 then 
                meleeAnim = {"vjseq_meleeattack01"}
                nextMeleeT = mRand(1.25, 2) 
                timeUntilDmg = mRand(0.45, 0.55)

            elseif mAnim == 7 then 
                meleeAnim = {"vjseq_melee_slice"}
                nextMeleeT = mRand(1.5, 3.5) 
                timeUntilDmg = mRand(0.65, 0.7)

            elseif mAnim == 8 then 
                meleeAnim = {"vjseq_melee_gunhit"}
                nextMeleeT = mRand(0.75, 2.25) 
                timeUntilDmg = mRand(0.45, 0.55)

            elseif mAnim == 9 then 
                meleeAnim = {"vjseq_melee_gunhit1"}
                nextMeleeT = mRand(1, 2.55) 
                timeUntilDmg = mRand(0.45, 0.55)

            elseif mAnim == 10 then 
                meleeAnim = {"vjseq_melee_gunhit2"}
                nextMeleeT = mRand(0.35, 1.25) 
                timeUntilDmg = mRand(0.35, 0.4)

            elseif mAnim == 11 and self.Melee_CanHeadbutt then 
                meleeAnim = {"vjseq_melee_headbutt"}
                nextMeleeT = mRand(1, 4.5) 
                timeUntilDmg = mRand(0.6, 0.65)

            elseif mAnim == 12 then 
                meleeAnim = {"vjseq_melee_gunslap"}
                nextMeleeT = mRand(0.25, 1) 
                timeUntilDmg = mRand(0.25, 0.3)

            elseif mAnim == 13 then 
                meleeAnim = {"vjseq_melee_gun_butt"}
                nextMeleeT = mRand(0.25, 1) 
                timeUntilDmg = mRand(0.25, 0.3)

            elseif mAnim == 14 then 
                meleeAnim = {"vjseq_melee_weapon_01"}
                nextMeleeT = mRand(0.75, 2.25) 
                timeUntilDmg = mRand(0.45, 0.55)

            elseif mAnim == 15 and canKick then 
                meleeAnim = {"vjseq_melee_weapon_02"}
                nextMeleeT = mRand(2, 5) 
                timeUntilDmg = mRand(0.6, 0.65)

            elseif mAnim == 16 then 
                meleeAnim = {"vjseq_melee_weapon_03"}
                nextMeleeT = mRand(2, 5) 
                timeUntilDmg = mRand(0.6, 0.65)

            elseif mAnim == 17 then 
                meleeAnim = {"vjseq_melee_weapon_04"}
                nextMeleeT = mRand(0.75, 2.25) 
                timeUntilDmg = mRand(0.45, 0.55)
            end  
        end
    end 
end  
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.PlyAnimInRepOnHeal = true
ENT.HealerEntReact_Anim = {"hg_nod_yes"}
ENT.HealedEntReact_Anim = {"hg_nod_yes", "g_fist", "g_fist_l"}

function ENT:OnMedicBehavior(status, statusData)
    local heaAnims = VJ.PICK({"heal", "grendrop", "grenplace"})
    self.AnimTbl_Medic_GiveHealth = "vjseq_" .. heaAnims

    if status == "BeforeHeal" then
        self:RemoveAllGestures()
    end

    if status == "OnHeal" and self.PlyAnimInRepOnHeal and not (self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK) and not self.Alerted then
        local healerResponse = VJ.PICK({"vjges_" .. VJ.PICK(self.HealerEntReact_Anim)})
        self:StopMoving()
        self:RemoveAllGestures()

        timer.Simple(mRand(0.2, 0.5), function()
            if not (IsValid(self) and IsValid(statusData)) then return end
            if mRng(1, 2) == 1 and statusData.IsVJBaseSNPC_Human and statusData.IsBusy and not statusData:IsBusy() then
            
                if istable(statusData.HealedEntReact_Anim) then
                    local validAnims = {}
                    for _, animName in ipairs(statusData.HealedEntReact_Anim) do
                        local gestureName = "vjges_" .. animName
                        local seqID = statusData:LookupSequence(gestureName)
                        if seqID and seqID ~= -1 then
                            table.insert(validAnims, gestureName)
                        end
                    end
                    
                    if #validAnims > 0 then
                        local chosen = VJ.PICK(validAnims)
                        statusData:PlayAnim(chosen, false)
                        print("HealedEntAnim: " .. chosen)
                    end
                end
            end
            if mRng(1, 2) == 1 and not self:IsBusy() then
                self:PlayAnim(healerResponse, false)
                print("Healer resp anim: " .. healerResponse)
            end
        end)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WaterExtinguishSelFire()
    if not IsValid(self) then return false end 
    if self:WaterLevel() > 0 and self:IsOnFire() and self:Alive() then
        self:Extinguish()
        VJ.EmitSound(self, {"player/footsteps/wade1.wav","player/footsteps/wade2.wav","player/footsteps/wade3.wav","player/footsteps/wade4.wav","ambient/water/water_splash2.wav"}, 85, 115)

        if not self.Immune_Fire then 
            self:PlaySoundSystem("Pain")
        end
    end
end 

function ENT:ReactToFire()
    if GetConVar("vj_stalker_fire_react"):GetInt()  ~= 1 or self.Dead or self:Health() <= 0 or self.VJ_IsBeingControlled or not IsValid(self) then
        return false
    end

    if self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or 
        self:GetState() == VJ_STATE_ONLY_ANIMATION or 
        self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK or 
        self:IsBusy() or 
        not self.CanPlayBurningAnimations or
        self.Immune_Fire then 
        return false 
    end

    if not self:IsOnFire() then
        self.CurrentlyBurning = false
        self:ResetAfterFire()
        return
    end

    local anim = VJ.PICK(self.OnFireIdle_Anim)
    local animDuration = VJ.AnimDuration(self, anim)
    if self:IsOnFire() and CurTime() > self.NextBurnAnimationT and self.CanPlayBurningAnimations and not self.Immune_Fire then
        self.CurrentlyBurning = true
        self:PlayAnim("vjseq_" .. anim, true, VJ.AnimDuration(self, anim), false)
        self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, animDuration)
        self.NextBurnAnimationT = CurTime() + animDuration - mRand(0.01,0.3)
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
if self:IsOnFire() and IsValid(self) and self.CurrentlyBurning then
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


    if GetConVar(self.FriendlyConvar):GetInt()  == 1 then
        self:ManageFriendlyVars()
    end
end

function ENT:OnFireBehavior()
    if self:IsOnFire() and IsValid(self) and not self.Dead then
        self.CurrentlyBurning = true
        self.VJ_ID_Danger = true
    else
        self.CurrentlyBurning = false
        self.VJ_ID_Danger = false
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RadioChatterSoundCode(CustomTbl)
	if not self.HasSounds or not self.HasRadioChatDialogue then return end
	if CurTime() > self.NextRadioDialogueT then
		local randsound = mRng(1,self.RadioDialogieChance)
		local soundtbl = self.SoundTbl_BackgroundRadioDialogue
		if CustomTbl != nil and #CustomTbl != 0 then soundtbl = CustomTbl end
		if randsound == 1 and VJ.PICK(soundtbl) != false then
			self.NextIdleSoundT_Reg = CurTime() + mRand(1, 5) -- self.IdleSoundBlockTime 
			self.CurrentHasCombineRadioChatterSound = VJ.CreateSound(self, soundtbl, self.BackGround_RadioLevel, self:GetSoundPitch(self.BackGround_RadioPitch1, self.BackGround_RadioPitch2))
		end
		self.NextRadioDialogueT = CurTime() +  mRand(self.NextSoundTime_RadioDialogue1,self.NextSoundTime_RadioDialogue2)
	end
end

function ENT:PlayBackgroundRadioChatter()
    if IsValid(self) and self.HasRadioChatDialogue then 
        self:RadioChatterSoundCode()
    end
end 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
    if not IsValid(self) then return false end 

    if self.HasDeathSounds and self.Headshot_Death and self.HeadShot_Death_StopDthSnd then 
        VJ.STOPSOUND(self.CurrentDeathSound)
    end 

    local isFireDeath = self:IsOnFire() and (dmginfo:IsDamageType(DMG_BURN) or dmginfo:IsDamageType(DMG_SLOWBURN)) and not self.Immune_Fire
    local isHeadshot = self.Headshot_Death or hitgroup == HITGROUP_HEAD
    local deflateChance = self.SevaSuitDeflateChance
    local lastRadTrans = self.Radio_DeathSoundChance 
    local atId = 0
    if status == "Init" then 

        local wep = self:GetActiveWeapon()
        if IsValid(wep) then 
            local wepClass = wep:GetClass()
            local dropWeaponClass
            if wepClass == self.HumanPrimaryWeapon and mRng(1, self.Weapon_DropSecondary_Chance) == 1 and self.Weapon_DropSecondary and GetConVar("vj_stalker_drop_seq_wep"):GetInt() == 1 then
                dropWeaponClass = self.HumanSecondaryWeapon
            elseif wepClass == self.HumanSecondaryWeapon then
                dropWeaponClass = self.HumanPrimaryWeapon
            else
                return
            end

            local dropEnt = ents.Create(dropWeaponClass)
            if IsValid(dropEnt) then
                dropEnt:SetPos(self:GetPos() + Vector(mRand(-10, 10), mRand(-10, 10), mRand(25, 40)))
                dropEnt:SetAngles(self:GetAngles())
                dropEnt:Spawn()
                dropEnt:SetOwner(NULL)
                local phys = dropEnt:GetPhysicsObject()
                if IsValid(phys) then
                    phys:SetVelocity(self:GetForward() * mRand(-25,25) + self:GetRight() * mRand(-25,25) + Vector(0, 0, mRand(-25, 25)))
                end
            end
        end 

        if self.Radio_RandomDeathSound and mRng(1, lastRadTrans) == 1 then 
            local radDeath = {"general_sds/radio_snds/radio_random" .. mRng(1, 15) .. ".wav"}
            VJ.EmitSound(self, radDeath, mRng(95, 115), mRng(85, 105))
        end 

        if self.IsScientific and mRng(1, deflateChance) == 1 then 
            local deflateSound = VJ.PICK({"general_sds/deflate_suit_sound/ceda_suit_deflate_01.wav","general_sds/deflate_suit_sound/ceda_suit_deflate_02.wav","general_sds/deflate_suit_sound/ceda_suit_deflate_03.wav"})
            VJ.EmitSound(self, deflateSound, mRng(85, 125), mRng(85, 125))
        end 

        if isFireDeath and self.HasBurnToDeathSounds and not self.HasPlayedBurnDeathSound and mRng(1, self.BurnToDeathSoundChance) == 1 then
            self.HasPlayedBurnDeathSound = true
            VJ.STOPSOUND(self.CurrentDeathSound)
            self.BurnToDeathSoundObj = VJ.CreateSound(self, self.BurnToDeathSound_Tbl, mRng(80, 125), self:GetSoundPitch(self.DeathSoundPitch))
            if self.BurnToDeathSoundObj then
                self.BurnToDeathSoundObj:Play()
            end
        end
        if isHeadshot then 
            self.CanPlayHeadshotDeahtAnim = true
            self:HeadshotDeathEffects()
        end
    end 

    if GetConVar("vj_stalker_death_anim"):GetInt() ~= 1 or not self:IsOnGround() or not self.HasDeathAnimation or (not isFireDeath and (self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK or self:IsBusy())) then
        return false
    end

    if status == "DeathAnim" then
        if self:IsMoving() and self:GetActivity() == ACT_RUN then
            self.AnimTbl_Death = {"vjseq_deathrunning_01", "vjseq_deathrunning_03", "vjseq_deathrunning_04", "vjseq_deathrunning_05","vjseq_deathrunning_06", "vjseq_deathrunning_07", "vjseq_deathrunning_08", "vjseq_deathrunning_09","vjseq_deathrunning_10", "vjseq_deathrunning_11a", "vjseq_deathrunning_11b", "vjseq_deathrunning_11c","vjseq_deathrunning_11d", "vjseq_deathrunning_11e", "vjseq_deathrunning_11f", "vjseq_deathrunning_11g"}
            self.DeathAnimationChance = 2
            print("Running (Forward)")

        elseif (self.CanPlayHeadshotDeahtAnim or isHeadshot) and GetConVar("vj_stalker_disable_headshot_death_anim"):GetInt()  ~= 1 then
            self.AnimTbl_Death = {"vjseq_DIE_Headshot_FBack_01", "vjseq_DIE_Headshot_FBack_02", "vjseq_DIE_Headshot_FBack_03","vjseq_DIE_Headshot_FFront_01", "vjseq_DIE_Headshot_FFront_02", "vjseq_DIE_Headshot_FFront_03","vjseq_DIE_Headshot_FFront_04", "vjseq_DIE_Headshot_FFront_05"}
            print("HEADSHOT")

        elseif dmginfo:IsExplosionDamage() then
            self.AnimTbl_Death = {"vjseq_death_explosion_1", "vjseq_death_explosion_2", "vjseq_death_explosion_3","vjseq_death_explosion_4", "vjseq_death_explosion_5", "vjseq_death_explosion_6"}
            self.DeathAnimationChance = 2
            print("Explosion")

        elseif dmginfo:IsDamageType(DMG_SHOCK) then
            self.AnimTbl_Death = {"vjseq_electro_15", "vjseq_electrocuted_1", "vjseq_electrocuted_2","vjseq_electrocuted_3", "vjseq_electrocuted_4", "vjseq_electrocuted_5"}
            self.DeathAnimationChance = 2
            local firePartEf = "smoke_gib_01"
            local elePartEf = "electrical_arc_01_parent" 
            ParticleEffectAttach(firePartEf, PATTACH_POINT_FOLLOW, self, atId)
            ParticleEffectAttach(firePartEf, PATTACH_POINT_FOLLOW, self, atId)
            ParticleEffectAttach(elePartEf, PATTACH_POINT_FOLLOW, self, atId)
            ParticleEffectAttach(elePartEf, PATTACH_POINT_FOLLOW, self, atId)
            print("Shocked")

        elseif isFireDeath then
            print("Fire")
            self.AnimTbl_Death = {"vjseq_fire_03", "vjseq_fire_04", "vjseq_fire_01", "vjseq_fire_02","vjseq_pd2_death_fire_1_new", "vjseq_pd2_death_fire_2_new", "vjseq_pd2_death_fire_3_new"}
            if self.SpecialFireDeathFx and mRng(1, self.FireDeathFxChance) == 1 and not isHeadshot then 
                VJ.EmitSound(self, {"ambient/fire/gascan_ignite1.wav", "ambient/fire/ignite.wav"}, mRng(85, 125), mRng(85, 125))
                local fireEffects = {"embers_small_01", "env_fire_small_base", "fire_medium_heatwave", "smoke_medium_01", "smoke_medium_02"}
                for _, effect in ipairs(fireEffects) do
                    ParticleEffectAttach(effect, PATTACH_POINT_FOLLOW, self, atId)
                end

                local function GetValAtt(ent)
                    local commonAttachments = {"chest", "forward", "center", "zipline", "muzzle", "beam_damage", "trinket_lowerback"}
                    for _, name in ipairs(commonAttachments) do
                        local id = ent:LookupAttachment(name)
                        if id and id > 0 then return name end
                    end
                    local numAttachments = ent:GetNumAttachments()
                    for i = 1, numAttachments do
                        local attach = ent:GetAttachment(i)
                        if attach and attach.name then return attach.name end
                    end
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
                if attachName then
                    self.FireLight:Fire("SetParentAttachment", attachName)
                end

                self.FireLight:Fire("TurnOn", "", 0)
                self:DeleteOnRemove(self.FireLight)
            end

        elseif dmginfo:IsDamageType(DMG_BUCKSHOT) then
            local attacker = dmginfo:GetAttacker()
            if not IsValid(attacker) then
                attacker = dmginfo:GetInflictor()
            end
        
            if IsValid(attacker) and attacker:IsPlayer() then
                local playerAim = attacker:GetAimVector():GetNormalized()
                local snpcForward = self:GetForward()
                local snpcRight = self:GetRight()

                local dotForward = playerAim:Dot(snpcForward)
                local dotRight = playerAim:Dot(snpcRight)

                if dotForward > 0.5 then
                    self.AnimTbl_Death = {"vjseq_die_shotgun_fback_01", "vjseq_die_shotgun_fback_02"}
                    self.DeathAnimationChance = 2
                    print("Shotgun Death from Back")
                elseif dotForward < -0.5 then
                    self.AnimTbl_Death = {"vjseq_DIE_Shotgun_FFront_01", "vjseq_DIE_Shotgun_FFront_02", "vjseq_DIE_Shotgun_FFront_03","vjseq_DIE_Shotgun_FFront_04", "vjseq_DIE_Shotgun_FFront_05", "vjseq_DIE_Shotgun_FFront_06","vjseq_DIE_Shotgun_FFront_07", "vjseq_DIE_Shotgun_FFront_08", "vjseq_DIE_Shotgun_FFront_09"}
                    self.DeathAnimationChance = 2
                    print("Shotgun Death from Front")
                elseif dotRight > 0.5 then
                    self.AnimTbl_Death = {"vjseq_die_shotgun_fleft_01", "vjseq_die_shotgun_fleft_02", "vjseq_die_shotgun_fleft_03"}
                    self.DeathAnimationChance = 2
                    print("Shotgun Death from Left")
                elseif dotRight < -0.5 then
                    self.AnimTbl_Death = {"vjseq_die_shotgun_fright_01"}
                    self.DeathAnimationChance = 2
                    print("Shotgun Death from Right")
                end
            end
        end
    else 
        self.AnimTbl_Death = {"vjseq_die_simple_01", "vjseq_die_simple_02", "vjseq_die_simple_03", "vjseq_die_simple_04", "vjseq_die_simple_05","vjseq_die_simple_06", "vjseq_die_simple_07", "vjseq_die_simple_08", "vjseq_die_simple_09", "vjseq_die_simple_10","vjseq_die_simple_11", "vjseq_die_simple_12", "vjseq_die_simple_13", "vjseq_die_simple_14", "vjseq_die_simple_15","vjseq_die_simple_16", "vjseq_die_simple_17", "vjseq_die_simple_18", "vjseq_die_simple_19", "vjseq_die_simple_20","vjseq_die_simple_21", "vjseq_die_simple_22"}
        if mRng(1, 3) == 1 then
            self:DeathWeaponDrop()
            local activeWep = self:GetActiveWeapon()
            if IsValid(activeWep) then activeWep:Remove() end
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ShovedBack(dmginfo)
    if GetConVar("vj_stalker_shovedback"):GetInt() ~= 1 or self.VJ_IsBeingControlled or not IsValid(self) then return end
    local isDead = self:Health() <= 0 or self.Dead or not self:Alive()

    if not self.Shoved_Back or self.Shoved_Back_Now or self:IsOnFire() or self:GetActivity() == ACT_FLINCH or
       self:IsBusy("Activities") or self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or
       self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK then return false end
    if not self:IsOnGround() or isDead or self.PlayingWallHitAnim then return false end
    if (CurTime() - self.Shoved_Back_NextT) < 1 then return false end

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

    if (damageAmount <= damageThreshold and damageForce <= damageForceThreshold) or not (allowExplosive or allowCommon) or self.Dead then return false end

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

    timer.Simple(mRand(0.1, 0.35), function()
        if not IsValid(self) then return end

        local isNowDead = self:Health() <= 0 or self.Dead or not self:Alive()
        if isNowDead then 
            self.Shoved_Back_Now = false
            self.ShovedDir = nil
            return 
        end

        self:StopMoving()
        self:RemoveAllGestures()
        self.NextFlinchT = CurTime() + mRand(5, 10)
        self:PlayAnim({ "vjseq_" .. selectedAnim }, true, shovedDur, false)
        self:SetState(VJ_STATE_ONLY_ANIMATION, shovedDur)
        self:StopAttacks(true)

        timer.Simple(shovedDur + 0.1, function()
            if IsValid(self) then
                self.Shoved_Back_Now = false
                self.Shoved_Back_NextT = CurTime() + mRand(5, 15)
                self:SetState()
                self.ShovedDir = nil
            end
        end)
    end)
end

function ENT:HitWallWhenShoved()
    if not self.ShovedDir or GetConVar("vj_stalker_shove_wall_collide"):GetInt() ~= 1 then return end
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

        local startPos = self:GetPos() + self:OBBCenter()
        local traceDist = 20
        local tr = util.TraceHull({
            start = startPos,
            endpos = startPos + traceDir * traceDist,
            mins = self:OBBMins(),
            maxs = self:OBBMaxs(),
            filter = self
        })

        if tr.Hit and not self.PlayingWallHitAnim and not isDead then
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
                    end
                end)
            end
        end
    end
end 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.React_FriFire = true 
ENT.React_FrIFire_AnimTbl = {"g_noway_big", "hg_nod_no", "g_fistshake"}
function ENT:React_DmgFrPly(attacker)
    if self.VJ_IsBeingControlled or not IsValid(self) then return end 

    if self:IsBusy() or self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK then 
        return false 
    end

    local annoyedAnim = VJ.PICK(self.React_FrIFire_AnimTbl)
    local delay = mRand(0.15, 0.95)
    if IsValid(attacker) and attacker:IsPlayer() then
        if mRng(1, 2) == 1 then
            self:StopMoving()
            self:RemoveAllGestures()
            timer.Simple(delay, function()
                if IsValid(self) and not self:IsBusy() then
                    self:PlayAnim("vjges_" .. annoyedAnim, false)
                end
            end) 
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
    -- [Corpse wound graabbing] --
ENT.CorpseWndGrabChance = 3
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
ENT.CorpseTwitchChance = 6
ENT.CorpseTwitchReps = mRng(1, 15)
ENT.CorpseTwitchMinDelay = 0.1
ENT.CorpseTwitchMaxDelay = 1.5
ENT.CorpseTwitchForceMin = 500
ENT.CorpseTwitchForceMax = 2500 

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

    -- [Corpse ele effects] --
ENT.Corpse_EleDeathEffects = false 
ENT.Corpse_EleDeathEffects_Chance = 8

ENT.Corpse_RngEyePos = true 
ENT.Corpse_RngEyePos_Chance = 2 

ENT.Corpse_RngFaceFlex = true 
ENT.Corpse_RngFaceFlex_Chance = 2
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Instant_DissolveCorpse(corpse)
    local dissolveChance = self.Inst_DissolveCorpseChance
    if mRng(1, dissolveChance) == 1 and self.Inst_DissolveCorpse and IsValid(corpse) then
        self:Dissolve_corpseity(corpse)
    end 
end 

function ENT:Delayed_DissolveAfterCorpse(corpse)
    if not self.Corpse_Dissolve or not IsValid(corpse) or GetConVar("vj_stalker_corpse_dissolve"):GetInt() ~= 1 then return end
    if mRng(1, self.Corpse_DissolveChance) != 1 then return end
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
    if self.Flatline_DeathSnd and mRng(1, self.Flatline_DeathChance) == 1 and GetConVar("vj_stalker_flatline"):GetInt() == 1 then
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

function ENT:Dissolve_corpseity(corpse)
    if IsValid(corpse) then
        corpse:SetName("vj_dissolve_corpse_" .. corpse:EntIndex())
        local dissolver = self:GetOrCreateDissolver()
        if IsValid(dissolver) then
            dissolver:SetKeyValue("magnitude", mRng(25, 125))
            dissolver:SetKeyValue("dissolvetype", mRng(0, 3))
            dissolver:Fire("Dissolve", corpse:GetName())

            if IsValid(self.WeaponEntity) then
                self.WeaponEntity:Dissolve(0, 1)
            end
        end
    end
end

function ENT:Ele_CorpseDeathEffects(corpse)
    if GetConVar("vj_stalker_ele_death_fx"):GetInt() ~= 1 then return false end 
    local sparkChance = self.Corpse_EleDeathEffects_Chance
    if self.Corpse_EleDeathEffects and mRng(1, sparkChance) == 1 then
        local duration = mRand(1, 15)
        local interval = mRand(0.05,0.95) 
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
    if mRng(1, self.ManipulateFingBoneChance) == 1 then return end
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
    if GetConVar("vj_stalker_body_twitching"):GetInt() ~= 1 then return end 
    if self.HasPostMortemTwitching and mRng(1, self.CorpseTwitchChance) == 1 then
        local twitchReps = self.CorpseTwitchReps or 3 
        local minDelay = self.CorpseTwitchMinDelay or 0.2
        local maxDelay = self.CorpseTwitchMaxDelay or 0.6
        local forceMin = self.CorpseTwitchForceMin or 1500
        local forceMax = self.CorpseTwitchForceMax or 3550

        timer.Simple(mRand(1, 15.5), function()
            if not IsValid(corpse) then return end
            local twitchType = mRng(1, 2)
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
                    local numBones = mRng(1, math.min(3, physCount)) 
                    for i = 1, numBones do
                        local phys = corpse:GetPhysicsObjectNum(mRng(0, physCount - 1))
                        if IsValid(phys) then
                            local twitchForce = VectorRand() * mRand(forceMin * 0.6, forceMax) 
                            local offset = corpse:LocalToWorld(corpse:OBBCenter() + VectorRand() * 10)
                            phys:ApplyForceOffset(twitchForce, offset)
                        end
                    end
                end
                timer.Simple(mRand(minDelay, maxDelay), function()
                    TwitchRep(count - 1)
                end)
            end

            TwitchRep(twitchReps)
        end)
    end
end 

function ENT:ApplyCorpseRoll(corpse, duration, interval)
    if not IsValid(corpse) or self.Headshot_Death then return end
    local conv = GetConVar("vj_stalker_body_writhe"):GetInt()
    local chance = self.DC_Writhe_Chance or 10 
    local minT = self.DC_Writhe_MinT or 5 
    local maxT = self.DC_Writhe_MaxT or 15 
    local decThresh = self.DC_Writh_Decay_Thresh or 0.20
    local trDist = self.DC_Writhe_TraceDist or 250 
    local useAllBones = self.DC_Writhe_UseAllBones or false 

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
                        decayFactor = 1 - math.Clamp(decayProgress, 0, 1)
                    end
                end

                local rollForce = corpse:GetRight() * mRand(25, 125) * rollDirection * decayFactor
                local forwardForce = corpse:GetForward() * mRand(25, 45) * rollDirection * decayFactor
                local liftForce = Vector(0, 0, mRand(25, 45)) * rollDirection * decayFactor
                local angVel = corpse:GetForward() * mRand(200, 350) * rollDirection * decayFactor

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
    if IsValid(body) then 
        if self.Corpse_RngEyePos and mRng(1, self.Corpse_RngEyePos_Chance) == 1 then 
            local eyeX, eyeY = mRand(-1, 1), mRand(-1, 1)
            local rng = mRand(-55, 55)
            body:SetEyeTarget(body:GetPos() + Vector(eyeX * rng, eyeY * rng, mRand(-55, 55)))
        end
    end 
end 

function ENT:RngFaceFlexPos(body)
    if IsValid(body) then 
        if self.Corpse_RngFaceFlex and mRng(1, self.Corpse_RngFaceFlex_Chance) == 1 then 
            local flexCount = body:GetFlexNum()
            for i = 0, flexCount - 1 do
                body:SetFlexWeight(i, mRand(0, 1)) 
            end
        end
    end
end 

function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpse)
    if not IsValid(corpse) then return false end
    self:Delayed_DissolveAfterCorpse(corpse)
    self:Instant_DissolveCorpse(corpse)
    self:PlyFlatlineOnDeath(corpse) 
    self:Ele_CorpseDeathEffects(corpse)
    self:ManipulateCorpseFingers(corpse)
    self:ApplyCorpseTwitching(corpse)
    self:ApplyCorpseRoll(corpse, duration, interval)
    self:RngDeathEyePos(corpse) 
    self:RngFaceFlexPos(corpse)
    RagdollBloodEffects(self, corpse)

    local appliedCustomPhysics = false
    if self.Headshot_Death and self.ApplyHeadshotDeathPhys and not self.IsCurrentlyIncapacitated then
        local downForce = -self.HeadShot_PhysDownFrc
        local rngForBackForce = self.HeadShot_PhysForwardFrc

        local pullForce = self:GetForward() * rngForBackForce + Vector(0,0,downForce)

        local mass = mRand(120, 185)

        local rngDir = VectorRand():GetNormalized()
        local rngSpeed = Vector(0, 0, mRand(255, 550))
        local rngAngVel = rngDir * rngSpeed

        local defLinDamp = mRand(0.01, 0.025)
        local defAngDamp = defLinDamp
        
        for i = 0, corpse:GetPhysicsObjectCount() - 1 do
            local phys = corpse:GetPhysicsObjectNum(i)
            if IsValid(phys) then
                phys:ApplyForceCenter(pullForce)
                phys:SetMass(mass)
                phys:SetDamping(defLinDamp, defAngDamp)
                phys:AddAngleVelocity(rngAngVel)
            end
        end
        print("headshot phys applied")
        appliedCustomPhysics = true
    end

    if not appliedCustomPhysics and GetConVar("vj_stalker_death_ex_crpse_phys"):GetInt()  == 1 and self:IsOnGround() then
        if self.Ex_Crp_Phys and not self.IsCurrentlyIncapacitated then

            local hitSideBias = Vector(0, 0, 0)
            local attacker = self:GetEnemy()

            if IsValid(attacker) then
                local dmgDir = (self:GetPos() - attacker:GetPos()):GetNormalized()
                hitSideBias = self:GetRight():Dot(dmgDir) > 0 and Vector(0, 1, 0) or Vector(0, -1, 0) 
            end

            for i = 0, corpse:GetPhysicsObjectCount() - 1 do
                local phys = corpse:GetPhysicsObjectNum(i)
                local mass = mRand(115, 155)

                local dampVal 
                if mRng(1, 2) == 1 then 
                    dampVal = mRand(0.01, 0.1) -- Heavy 
                else 
                    dampVal = mRand(0.25, 0.55) -- Lighter 
                end 

                local hsLinDamp = dampVal
                local hsAngDamp = hsLinDamp
                
                if IsValid(phys) then
                    phys:SetDamping(hsLinDamp, hsAngDamp)
                    phys:SetMass(mass)

                    local vel = VectorRand() * mRand(25, 225)
                    if vel.z > 0 then
                        vel.z = vel.z * mRand(0.1, 0.4)
                    elseif vel.z < 0 then
                        vel.z = vel.z * mRand(0.4, 0.8)
                    end
                    phys:ApplyForceCenter(vel)

                    local rngVelEnhance = mRand(1, 5.25)
                    local angVel = hitSideBias + VectorRand() * mRand(0.15, 0.25) 
                    local rngDir = VectorRand():GetNormalized()
                    local rngTrq = VectorRand() * mRand(2500, 5000)

                    angVel:Normalize()
                    angVel = angVel * Vector(0, 0, mRand(1000, 2500))
                    phys:AddAngleVelocity(angVel * rngDir * rngVelEnhance)

                    if self.Ex_Crp_Phys_Trq and mRng(1, self.Ex_Crp_Phys_Trq_Chance) == 1 then 
                        phys:ApplyTorqueCenter(rngTrq * mRand(0.85, 1.25))
                    end 
                end
            end 
        end
    end

    if mRng(1, 8) == 1 and IsValid(self) and not self.Headshot_Death then
        timer.Simple(self.CorpseWndGrabDelay, function()
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
                ["ValveBiped.Bip01_Spine"]  = Vector(0, 0, mRand(5, 10)),
                ["ValveBiped.Bip01_Spine1"] = Vector(0, 0, mRand(5, 10)),
                ["ValveBiped.Bip01_Spine2"] = Vector(0, 0, mRand(5, 10)),
                ["ValveBiped.Bip01_Spine4"] = Vector(0, 0, mRand(5, 10)),
                ["ValveBiped.Bip01_Head1"]  = Vector(0, 0, mRand(1, 5)),
                ["ValveBiped.Bip01_Pelvis"]  = Vector(0, 0, mRand(10, 15)),
                ["ValveBiped.Bip01_L_Calf"]  = Vector(0, 0, mRand(5, 7.5)),
                ["ValveBiped.Bip01_R_Calf"]  = Vector(0, 0, mRand(5, 7.5)),
            }

            local boneName = table.Random(woundTargets)
            local targetBone = corpse:LookupBone(boneName)
            if not targetBone then print("[DEBUG] Target wound bone not found:", boneName) return end

            local grabOffset = offsetLookup[boneName] or Vector(0, 0, 6)
            local randomOffset = Vector(mRand(-2, 2), mRand(-2, 2), mRand(0, 3))
            local dynamicTargetPos = corpse:GetBonePosition(targetBone) + (corpse:GetForward() * 5) + grabOffset + randomOffset
            print("[DEBUG] Wound target:", boneName, "Position:", dynamicTargetPos)

            local handMode = mRng(1,3) -- 1 = left only, 2 = right only, 3 = both
            local useLeft = handMode == 1 or handMode == 3
            local useRight = handMode == 2 or handMode == 3

            local hands = {}
            if useLeft then table.insert(hands, corpse:LookupBone("ValveBiped.Bip01_L_Hand")) end
            if useRight then table.insert(hands, corpse:LookupBone("ValveBiped.Bip01_R_Hand")) end

            print("[DEBUG] Hands used for wound grab:", useLeft and "LEFT" or "", useRight and "RIGHT" or "")

            local timerName = "CorpseWoundGrab_" .. corpse:EntIndex()
            local totalDuration = mRand(1.5, 10.5)
            local interval = 0.01
            local repeats = math.floor(totalDuration / interval)
            local force = self.CorpseWndGrabFrc or 150
            local weldedHands = {}
            local i = 0
            timer.Create(timerName, interval, repeats, function()
                if not IsValid(corpse) then timer.Remove(timerName) return end
                i = i + 1
                dynamicTargetPos = corpse:GetBonePosition(targetBone) + (corpse:GetForward() * 5) + grabOffset + Vector(mRand(-2,2), mRand(-2,2), mRand(0,3))
                for _, hand in ipairs(hands) do
                    if hand and not weldedHands[hand] then
                        local physID = corpse:TranslateBoneToPhysBone(hand)
                        local phys = corpse:GetPhysicsObjectNum(physID or 0)
                        if IsValid(phys) then
                            local handPos = corpse:GetBonePosition(hand)
                            local dist = handPos:Distance(dynamicTargetPos)
                            local weldDist = 14 
                            if dist <= weldDist then
                                local targetPhysID = corpse:TranslateBoneToPhysBone(targetBone)
                                local targetPhys = corpse:GetPhysicsObjectNum(targetPhysID or 0)
                                if IsValid(targetPhys) then
                                    local weld = constraint.Weld(corpse, corpse, physID, targetPhysID, 0, true, false)
                                    if IsValid(weld) then
                                        print("[DEBUG] Weld created between hand and wound:", hand, "->", boneName)
                                        weldedHands[hand] = true

                                        local weldTime = mRand(5, 10)
                                        timer.Simple(weldTime, function()
                                            if IsValid(weld) then
                                                weld:Remove()
                                                print("[DEBUG] Weld removed after", weldTime, "seconds")
                                            end
                                            weldedHands[hand] = nil
                                        end)
                                    end
                                end
                            else
                                local appliedForce = force
                                if dist < 15 then appliedForce = force * 0.05 end
                                if dist < 5 then appliedForce = 0 end
                                local dir = (dynamicTargetPos - handPos):GetNormalized()
                                phys:AddVelocity(dir * appliedForce)
                            end
                        end
                    end
                end
            end)
        end)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleHeadshot(dmginfo, hitgroup)
    self.HeadshotInstaKillChance = GetConVar("vj_stalker_headshot_kill_chance"):GetInt()

    local dT = dmginfo:GetDamageType()
    local isHeadshot = false 
    local minDmgHd = mRand(5, 10)
    local instalKillChance = self.HeadshotInstaKillChance 
    local headHitGroup = HITGROUP_HEAD
    local bulDmg = (dmginfo:IsBulletDamage() or dT == DMG_BULLET or dT == DMG_AIRBOAT or dT == DMG_BUCKSHOT or dT == DMG_SNIPER)

    if hitgroup == headHitGroup and bulDmg and not self.Immune_Bullet then
        isHeadshot = true
    else
        local headBone = self:LookupBone("ValveBiped.Bip01_Head1")
        if headBone and bulDmg and not self.Immune_Bullet then
            local hitPos = dmginfo:GetDamagePosition()
            local headBonePos, _ = self:GetBonePosition(headBone)
            if headBonePos and hitPos:Distance(headBonePos) <= mRand(10, 13) then
                isHeadshot = true
            end
        end
    end

    if self.Headshot_ImpactFlinching and CurTime() >= (self.Headshot_NextFlinchT or 0) and mRng(1, self.Headshot_FlinchChance) == 1 then
        local flinchAnim = VJ.PICK(self.Headshot_ImpFlinchTbl)
        self:PlayAnim("vjges_" .. flinchAnim)
        self.Headshot_NextFlinchT = CurTime() + mRand(0.5, 1.5)
    end

    local dmgAmount = dmginfo:GetDamage() or 0
    local ignoreHelmet = dmgAmount > (self.ArmoredHelmet_MaxDamageCap or 100) and self.ArmoredHelmet_DamageCap 
    if self.ArmoredHelmet and isHeadshot and GetConVar("vj_stalker_armored_helmet"):GetInt() == 1 and not ignoreHelmet then
        if self.ArmoredHelmet_ImpSound and mRng(1, self.ArmoredHelmet_ImpSoundChance) == 1 then 
            self:PlaySoundSystem("Impact", self.SoundTbl_ExtraArmorImpacts)
        end 

        if self.ArmoredHelmet_ImpSparkFx and mRng(1, self.ArmoredHelmet_SparkFxChance) == 1 then 
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

        self.ArmoredHelmet_BreakLimit = self.ArmoredHelmet_BreakLimit or mRng(3,5)
        self.ArmoredHelmet_HitsTaken = (self.ArmoredHelmet_HitsTaken or 0) + 1

        if self.ArmoredHelmet_BlockDamaged and GetConVar("vj_stalker_helm_prev_dmg"):GetInt() == 1 then
            dmginfo:SetDamage(0)
            isHeadshot = false
        end

        if self.ArmoredHelmet_Break and self.ArmoredHelmet_HitsTaken >= self.ArmoredHelmet_BreakLimit and GetConVar("vj_stalker_breakable_helmet"):GetInt() == 1  then
            self.IsImmuneToHeadShots = false 
            self.ArmoredHelmet = false
            self.ArmoredHelmet_AffectFov = false
            self.ArmoredHelmet_BlockDamaged = false
            self.ArmoredHelmet_HitsTaken = 0
            VJ.EmitSound(self, self.SoundTbl_ExtraArmorImpacts, mRng(85, 105), mRng(70, 125))
        end
    end
    
    if isHeadshot then
        print(instalKillChance)
        self:HeadshotSoundEffect(isHeadshot)
    end

    if GetConVar("vj_stalker_headshot_insa_kill"):GetInt() == 1 then 
        if not self.IsImmuneToHeadShots then 
            local skipMinDmgCheck = GetConVar("vj_stalker_headshot_min_dmg_check"):GetInt() ~= 1
            local passedMinDmg = dmginfo:GetDamage() > minDmgHd
            if isHeadshot and mRng(1, instalKillChance) == 1 and (skipMinDmgCheck or passedMinDmg) then
                self.Headshot_Death = true 
                dmginfo:SetDamage(self:GetMaxHealth() * 3)
            end
        end 
    end 
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HeadshotDeathEffects()
    if GetConVar("vj_stalker_headshot_fx"):GetInt()  ~= 1 then return false end 
    if not self.Headshot_Death then return false end
    if not IsValid(self) then return false end 

    local hsGore = VJ.PICK(self.GoreOrGibSounds)
    local effectChance = self.HeadshotEffectsChance
    local headAttachment = nil
    local headAttachmentName = nil

    for _, attName in ipairs(self.HeadshotDeathAttTbl) do
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

    if mRng(1, effectChance) == 1 then

        if IsValid(self) and GetConVar("vj_stalker_headshot_gore_sound"):GetInt()  == 1 then 
            VJ.EmitSound(self, hsGore, mRng(65, 125), 115)
        end 

        local gibPos = headAttachment.Pos + self:GetUp() * mRng(5, 25) + self:GetRight() * mRng(-15, 15)
        local bloodT = mRand(1, 3.25)

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

        if self:LookupAttachment(headAttachmentName) > 0 then
            ParticleEffectAttach("blood_impact_red_01", PATTACH_POINT_FOLLOW, self, self:LookupAttachment(headAttachmentName))
        end

        for _ = 1, mRng(1, 3) do
            self:CreateGibEntity("obj_vj_gib", "UseHuman_Small", {Pos = gibPos})
        end
    end
    return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HeadshotSoundEffect(hasBeenHeadshot) 
    local hsSfxChance = self.HeadshotSoundSfxChance
    if not IsValid(self) or GetConVar("vj_stalker_headshot_sfx"):GetInt() ~= 1 then return end 
    if self.Headshot_Death_Sfx and hasBeenHeadshot and mRng(1, hsSfxChance) == 1 and IsValid(self) then
        self:PlaySoundSystem("Impact", self.SoundTbl_OnHeadshot)
    end 
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Inst_AlrtTo_Dmg = true 
ENT.Inst_AlrtTo_Dmg_Dist = 3500
ENT.Inst_AlrtTo_Dmg_Chance = 3 
function ENT:ReactToDmg(dmginfo)
    local dgmAtt = dmginfo:GetAttacker()
    local ene = self:GetEnemy()
    local dist = self.Inst_AlrtTo_Dmg_Dist or 3500
    local chance = self.Inst_AlrtTo_Dmg_Chance or 3 
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
        if not IsValid(self) or not IsValid(dgmAtt) or IsValid(ene) or not self:Alive() or self.Dead then return end

        local distSqr = self:GetPos():DistToSqr(dgmAtt:GetPos())
        if distSqr <= (dist * dist) and mRng(1, chance) == 1 then
            self:ForceSetEnemy(dgmAtt, false)
            self:UpdateEnemyMemory(dgmAtt, dgmAtt:GetPos())
        end
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Dmg_Cancel_IdleDial = true 
ENT.Has_BodyArmor = true 
function ENT:OnDamaged(dmginfo, hitgroup, status)    
    local dmgType = dmginfo:GetDamageType()
    local rngSnd = mRng(75, 105)
    local curT = CurTime()
    local coughConv = GetConVar("vj_stalker_coughing"):GetInt()
    local gesFlinchConv = GetConVar("vj_stalker_ges_flinch"):GetInt()
    local armorConv = GetConVar("vj_stalker_armor_spark"):GetInt()
    local firePainConv = GetConVar("vj_stalker_fire_dmg_vo"):GetInt()
    local minDmgConv = GetConVar("vj_stalker_min_dmg_cap"):GetInt()
    local minDmgSfxConv = GetConVar("vj_stalker_min_dmg_cap_sfx"):GetInt()
    local armorRichConv = GetConVar("vj_stalker_armor_ricochet"):GetInt()
    local cancelDial = GetConVar("vj_stalker_dmg_cancel_dial"):GetInt()
    if status == "PreDamage" then
        if cancelDial == 1 and self.Dmg_Cancel_IdleDial and not self.Dead then
            self.NextIdleSoundT_Reg = curT + mRand(0.25, 0.5)
            VJ.STOPSOUND(self.CurrentIdleSound)
        end 

        self:PanicOnDamageByEne(dmginfo)
        self:MngDmgTypeScales(dmginfo)
        self:ReactToDmg(dmginfo)
        self:ShovedBack(dmginfo)

        if mRng(1, self.Ele_SparkImpFx_Chance) == 1 and self.Ele_SparkImpFx then
            local snd = VJ.PICK({"ambient/energy/spark".. mRng(1, 6) .. ".wav"})
            local rngAng = mRng(-360, 360)
            local randAng = Angle(rngAng, rngAng, rngAng)
            VJ.EmitSound(self, snd, rngSnd, rngSnd)
            ParticleEffect("electrical_arc_01_parent", dmginfo:GetDamagePosition() + VectorRand(-5, 5), randAng, nil)
        end

        if self.ImpMetal_SparkArmor and mRng(1, self.ImpMetal_SparkArmorChance) == 1 then
            local effectData = EffectData()
            effectData:SetOrigin(dmginfo:GetDamagePosition())
            util.Effect("StunstickImpact", effectData)
        end

        if coughConv == 1 and self.ToxDmg_React and curT > self.ToxDmg_NextT and (self:Alive() or not self.Dead) and not self.Immune_Toxic then 
            if dmgType == DMG_RADIATION or dmgType == DMG_POISON or dmgType == DMG_NERVEGAS or dmgType == DMG_PARALYZE or dmgType == DMG_ACID  then 
                if mRng(1, self.ToxDmg_Chance) == 1 and IsValid(self) then 
                    local snd = VJ.PICK(self.ToxDmg_CoughTbl)
                    self.CoughingSound = VJ.CreateSound(self, snd, rngSnd, rngSnd)
                    self.ToxDmg_NextT = curT + mRand(2.5, 5)
                end 
            end 
        end 

        if gesFlinchConv == 1 and curT > self.ExFlinch_Ges_NextT and self.ExFlinch_Feedback_Ges then
            local flinChance = self.ExFlinch_Ges_Chance
            local tDel = mRand(0.01, 0.25)

            if self.ExFlinch_HpThresh and (self:Health() / self:GetMaxHealth()) <= self.ExFlinch_HpThresh_Min then
                flinChance = math.max(1, math.floor(flinChance / 2))
            end

            if mRng(1, flinChance) == 1 then
                timer.Simple(tDel , function()
                    if IsValid(self) and self:Alive() then 
                        local flinchAnim = VJ.PICK(self.ExFlinch_GesTbl)
                        self:PlayAnim("vjges_" .. flinchAnim)
                        self.ExFlinch_Ges_NextT = curT + mRand(0.5, 2.5)
                    end 
                end)
            end
        end
    
        if self.Has_BodyArmor and self.HasSounds and self.HasImpactSounds and mRng(3) == 1 and not (dmgType == DMG_BURN or dmgType == DMG_SLOWBURN) then
            local soundToPlay = mRng(2) == 1 and "vj_base/impact/armor" .. mRng(1, 10) .. ".wav" or VJ.PICK(self.SoundTbl_ExtraArmorImpacts)
            print("Armor impact sound")
            self:PlaySoundSystem("Impact", soundToPlay)
        end

        if self.CanHaveHeadshotFx then
            self:HandleHeadshot(dmginfo, hitgroup)
        end

        if dmgType == DMG_SHOCK and mRng(1, self.ShockDmgFxChance) == 1 then
            self:DamagedByShockFx() 
        end  

        if firePainConv == 1 and self.HasFireSpecPain and self.HasSounds then 
            if not self.Immune_Fire and (dmgType == DMG_BURN or dmgType == DMG_SLOWBURN or self:IsOnFire()) then 
                self:PlaySoundSystem("Pain", self.OnFirePain)
            end
        end 

        local attacker = dmginfo:GetAttacker()
        if IsValid(attacker) and attacker:IsPlayer() and not VJ_CVAR_IGNOREPLAYERS and (self:CheckRelationship(attacker) == D_LI or self:CheckRelationship(attacker) == D_NU) and self.React_FriFire then
            print("The attacker is a friendly player:", attacker:GetName())
            self:SetTurnTarget(attacker)
            self:SCHEDULE_FACE("TASK_FACE_TARGET")
            self:React_DmgFrPly()
        end
    end

    if status == "Init" then
        local damage = dmginfo:GetDamage()
        local imp = {"vj_base/impact/armor" .. mRng(1, 10) .. ".wav"}
        if minDmgConv == 1 and damage <= self.MinDmg_Cap and self.MinDmg_CapAbility and mRng(1, self.MinDmg_Cap_Chance) == 1 and not (dmgType == DMG_BURN or dmgType ==  DMG_SLOWBURN) and curT > (self.MinDmg_Cap_NextT or 0)  then
            self.MinDmg_Cap_NextT = curT + 0.25
            dmginfo:SetDamage(0)
            self.MinDmg_Cap_Active = true

            if minDmgSfxConv == 1 and self.MinDmg_Cap_Feedback_Sfx and mRng(1, self.MinDmg_Cap_Feedback_Sfx_Chance) == 1 then 
                self:PlaySoundSystem("Impact", imp)
            end 

            timer.Simple(0.01, function()
                if IsValid(self) then 
                    self.MinDmg_Cap_Active = false
                end
            end)
        end
    end

    if status == "PostDamage" then
        local armorSparkChance = self.ArmorSparking_Chance or 12
        local dT = dmginfo:GetDamageType()
        if armorConv == 1 and self.Has_BodyArmor and self.ArmorSparking and mRng(1, armorSparkChance) == 1 and (dmginfo:IsBulletDamage() or dmgType == DMG_BULLET or dmgType == DMG_AIRBOAT or dmgType == DMG_BUCKSHOT or dmgType == DMG_SNIPER) then
            local sparkMagnitude = mRand(0.1, 1.1) 
            local sparkTrailLength = mRand(0.1, 3.25)
            local damageSpark = ents.Create("env_spark")
            if IsValid(damageSpark) then
                damageSpark:SetKeyValue("Magnitude", tostring(sparkMagnitude))
                damageSpark:SetKeyValue("Spark Trail Length", tostring(sparkTrailLength))
                damageSpark:SetPos(dmginfo:GetDamagePosition())
                damageSpark:SetAngles(self:GetAngles())
                damageSpark:Fire("LightColor", "255 255 255")
                damageSpark:SetParent(self)
                damageSpark:Spawn()
                damageSpark:Activate()
                damageSpark:Fire("StartSpark", "", 0)
                damageSpark:Fire("StopSpark", "", mRand(0.001,0.225))
                self:DeleteOnRemove(damageSpark)
            end
        end
    
        if armorRichConv == 1 and self.Has_BodyArmor then
            local chance = self.Arm_BulRichocheting_Chance
            if self.HasBulletRichocheting and mRng(1, chance) == 1 and (dmginfo:IsBulletDamage() or dmgType == DMG_BULLET or dmgType == DMG_AIRBOAT or dmgType == DMG_BUCKSHOT or dmgType == DMG_SNIPER) then
                self.Arm_BulRichocheting = true

                local attacker = dmginfo:GetAttacker()
                if not IsValid(attacker) then attacker = self end

                if IsValid(attacker) and IsValid(self) then
                    local hitPos = dmginfo:GetDamagePosition()
                    local bulletDir = (hitPos - attacker:GetPos()):GetNormalized()

                    local angle = bulletDir:Angle()
                    angle:RotateAroundAxis(angle:Right(), mRand(-33, 33))
                    angle:RotateAroundAxis(angle:Up(), mRand(-33, 33))
                    local reflection = angle:Forward()

                    local bulletRicochet = ents.Create("base_gmodentity")
                    if IsValid(bulletRicochet) then
                        bulletRicochet:SetPos(hitPos)
                        bulletRicochet:Spawn()
                        bulletRicochet:FireBullets({
                            Src = hitPos,
                            Dir = reflection,
                            Spread = Vector(0.03, 0.03, 0.03),
                            Num = 1,
                            Attacker = attacker,
                            Inflictor = dmginfo:GetInflictor(),
                            Damage = mRng(1, 6),
                            IgnoreEntity = self,
                        })
                        bulletRicochet:Remove()
                        self.Arm_BulRichocheting = false
                    end
                    return true
                end
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
    local conv = GetConVar("vj_stalker_panic_after_dmg"):GetInt() 
    if not IsValid(self) or conv ~= 1 then return end
    if self.VJ_IsBeingControlled or self.Dead or not self.Panic_DmgEne then return false end
    if self:IsBusy() or self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or 
       self:GetState() == VJ_STATE_ONLY_ANIMATION or 
       self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK then return false end

    local panicChance = self.Panic_DmgEne_Chance
    local curTime = CurTime()
    local attacker = dmginfo:GetAttacker()
    local enemy = self:GetEnemy()
    local coverType = mRng(1, 3)

    if not IsValid(attacker) and not IsValid(enemy) then return false end

    local wep = self:GetActiveWeapon()
    local hasNonMeleeWeapon = not IsValid(wep) or (IsValid(wep) and not wep.IsMeleeWeapon)

    if self.IsHeavilyArmored then 
        panicChance = panicChance * 2
    end 

    if self:Health() <= (self:GetMaxHealth() * 0.5) then
        panicChance = math.max(1, math.floor(panicChance / 2))
    end

    if hasNonMeleeWeapon and curTime >= self.Panic_DmgEne_NextT and mRng(1, panicChance) == 1 then
        self:ClearSchedule()
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
                self.Panic_DmgEne_NextT = CurTime() + mRand(1, 5)
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

    local dmg = dmginfo:GetDamageType()
    local initialDamage = dmginfo:GetDamage()

    -- Scientific stats
    if self.IsScientific then
        if bit.band(dmg, DMG_BURN + DMG_SLOWBURN) ~= 0 then
            dmginfo:ScaleDamage(0.2)
            print(string.format("Fire Dmg (Scientific) Scaled: Initial = %.2f | Scaled = %.2f", initialDamage, dmginfo:GetDamage()))
            return
        elseif bit.band(dmg, DMG_SHOCK + DMG_DISSOLVE) ~= 0 then
            dmginfo:ScaleDamage(0.1)
            print(string.format("Shock/Dissolve Dmg (Scientific) Scaled: Initial = %.2f | Scaled = %.2f", initialDamage, dmginfo:GetDamage()))
            return
        elseif bit.band(dmg, DMG_BLAST) ~= 0 then
            dmginfo:ScaleDamage(0.5)
            print(string.format("Blast Dmg (Scientific) Scaled: Initial = %.2f | Scaled = %.2f", initialDamage, dmginfo:GetDamage()))
            return
        end
    end

    -- Exo/Heavy unit stats
    if self.IsHeavilyArmored then
        if bit.band(dmg, DMG_BURN + DMG_SLOWBURN) ~= 0 then
            dmginfo:ScaleDamage(0.5)
            print(string.format("Fire Dmg (Heavy) Scaled: Initial = %.2f | Scaled = %.2f", initialDamage, dmginfo:GetDamage()))
            return
        elseif bit.band(dmg, DMG_BLAST) ~= 0 then
            dmginfo:ScaleDamage(0.2)
            print(string.format("Blast Dmg (Heavy) Scaled: Initial = %.2f | Scaled = %.2f", initialDamage, dmginfo:GetDamage()))
            return
        elseif bit.band(dmg, DMG_SLASH) ~= 0 then
            dmginfo:ScaleDamage(0.45)
            print(string.format("Blast Dmg (Slash) Scaled: Initial = %.2f | Scaled = %.2f", initialDamage, dmginfo:GetDamage()))
            return
        elseif bit.band(dmg, DMG_ACID + DMG_RADIATION + DMG_POISON + DMG_NERVEGAS + DMG_PARALYZE) ~= 0 then
            dmginfo:ScaleDamage(0.8)
            print(string.format("Toxic Dmg (Heavy) Scaled: Initial = %.2f | Scaled = %.2f", initialDamage, dmginfo:GetDamage()))
            return
        end
    end

    -- Bullet dmg
    if dmginfo:IsBulletDamage() and self.HasBulletDmgScale then
        local hitHitgroup = hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_RIGHTLEG or hitgroup == HITGROUP_RIGHTARM or hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_GEAR
        if hitHitgroup and mRng(1, 3) == 1 then
            local reducedScale = mRand(0.2, 0.3)
            dmginfo:ScaleDamage(reducedScale)
            print(string.format("Severe Bullet Dmg Reduction (Limb/Torso): Initial = %.2f | Scaled = %.2f (Scale: %.2fx)",
                initialDamage, dmginfo:GetDamage(), reducedScale))
            return
        else
            local scale = mRand(0.75, 0.95)
            dmginfo:ScaleDamage(scale)
            print(string.format("Bullet Dmg Scaled: Initial = %.2f | Scaled = %.2f (Scale: %.2fx)", 
                initialDamage, dmginfo:GetDamage(), scale))
            return
        end
    end

    -- Fallback dmg scales
    for dtype, scaleRange in pairs(dmgScales) do
        if bit.band(dmg, dtype) ~= 0 then
            local scale = mRand(scaleRange[1], scaleRange[2])
            dmginfo:ScaleDamage(scale)
            print(string.format("%s Dmg Scaled (Fallback): Initial = %.2f | Scaled = %.2f (Scale: %.2fx)", 
                tostring(dtype), initialDamage, dmginfo:GetDamage(), scale))
            return
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DamagedByShockFx()
    if not IsValid(self) or self.Dead or not self.HasShockDmgFx then return false end

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
        if IsValid(self) and (self:Alive() or not self.Dead) then
            util.Effect("TeslaHitBoxes", teslaEffectData, true, true)
        end
    end)

    local function EmitShockSoundAndEffect()
        if not IsValid(self) or not self:Alive() or self.Dead then return end
        if CurTime() > endTime then return end
        local sndRng = mRng(85, 105)
        local sounds = VJ.PICK({"ambient/energy/zap" .. mRng(1, 9) .. ".wav"})
        VJ.EmitSound(self, sounds, sndRng, sndRng)

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
    local landAnim = "jump_holding_land"

    if not IsValid(self) or CurTime() < self.NextLandAnimCheckT or self.IsLanding or not self.Detect_LandAnim then
        return
    end

    local seq = self:GetSequence()
    local currentSequence = seq and self:GetSequenceName(seq) or ""
    
    if currentSequence == landAnim or self:GetActivity() == ACT_LAND then
        self.IsLanding = true  

        local LandingSounds = {"general_sds/land_sound/jumplanding.wav","general_sds/land_sound/jumplanding2.wav","general_sds/land_sound/jumplanding3.wav","general_sds/land_sound/jumplanding4.wav","general_sds/land_sound/landing.mp3"}
        VJ.EmitSound(self, VJ.PICK(LandingSounds), mRng(75, 115), mRng(75, 115))
        VJ.EmitSound(self, VJ.PICK(self.JumpLandGruntTbl), mRng(75, 115), mRng(75, 115))
        
        local landDuration = self:SequenceDuration(self:LookupSequence(landAnim)) or VJ.AnimDuration(self, landAnim) or 1 
        local myPos = self:GetPos()
        local isInWater = bit.band(util.PointContents(myPos), CONTENTS_WATER) == CONTENTS_WATER

        if GetConVar("vj_stalker_jump_land_particles"):GetInt()  == 1 then 
            if self.Landing_Effects and self.IsLanding and not isInWater then
                if self.LargeLandFx then 
                    local effectData = EffectData()
                    effectData:SetOrigin(myPos)
                    effectData:SetScale(self.Landing_FxScale)
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

        if self.CanTakeCovSigAnim and self.Copy_IsCrouching and getAllies and
            mRng(1, self.SignalTakeCover_FlwPlyChance) == 1 and
            not self:IsBusy("Activities") and CurTime() > self.NextTakeCovSigCrouchT then
            
            self:RemoveAllGestures()
            timer.Simple(mRand(0.25, 0.5), function()
                if IsValid(self) then
                    self:PlayAnim("vjges_gesture_signal_takecover")
                end
            end)
            self.NextTakeCovSigCrouchT = CurTime() + mRand(5, 10) 
        else
            self.NextTakeCovSigCrouchT = CurTime() + mRand(1, 5)
        end
    end 

    if newAct == ACT_JUMP then
        if mRng(1, 2) == 1 and self.Jump_GruntSounds then 
            timer.Simple(mRand(0.15, 0.25), function()
                if IsValid(self) then
                    self:PlaySoundSystem("Speech", self.JumpGruntTbl)
                end
            end)
        end 
    end

    if newAct == ACT_LAND then
        if mRng(1, 2) == 1 and self.Jump_LandGruntSounds then 
            timer.Simple(mRand(0.25, 0.5), function()
                if IsValid(self) then
                    self:PlaySoundSystem("Speech", self.JumpLandGruntTbl)
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
    if not self.Copy_PlyCrouchStance or not self.IsFollowing then return end

    local followData = self.FollowData
    if not followData then return end
    local followEnt = followData.Target
    if not IsValid(followEnt) or not followEnt:IsPlayer() or not followEnt:Alive() then return end
    if not followEnt:IsOnGround() or self:Disposition(followEnt) ~= D_LI or self:IsBusy() then return end

    local canSeePly = self:Visible(followEnt)
    local plyIsCrouching = followEnt:Crouching()
    local canCrouch = self:IsOnGround() and not self:IsUnreachable(followEnt)
    self.Copy_IsCrouching = plyIsCrouching and canSeePly and canCrouch
end

function ENT:TranslateActivity(act)
    if self.IsCrouchFiring and self.Weapon_CanMoveFire and IsValid(self:GetEnemy()) then
        if self.Weapon_CanMoveFire and IsValid(self:GetEnemy()) and (self.EnemyData.Visible or (self.EnemyData.VisibleTime + 5) > CurTime()) and self.CurrentSchedule and self.CurrentSchedule.CanShootWhenMoving and self:CanFireWeapon(true, false) then
            self.WeaponAttackState = VJ.WEP_ATTACK_STATE_FIRE
            if act == ACT_WALK then
                return self:TranslateActivity(act == ACT_WALK and ACT_WALK_CROUCH_AIM)
            elseif act == ACT_RUN then
                return self:TranslateActivity(act == ACT_RUN and ACT_RUN_CROUCH_AIM)
            end
        end
    end

    if self.Copy_IsCrouching then
        if act == ACT_RUN then return ACT_RUN_CROUCH or ACT_WALK_CROUCH_AIM end
        if act == ACT_IDLE then return ACT_COVER end 
        if act == ACT_WALK then return ACT_WALK_CROUCH end
    end


	if self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) then
		return ACT_BARNACLE_PULL 
    end 

    if crouchActs[act] then -- WHY DOES IT ONLY WORK WHEN THEY FOLLOW THE PLY???
        if not self.IsCurCrouchWalking then
            self.IsCurCrouchWalking = true
            print("USING CROUCH ACT:", act)
        end
    else
        if self.IsCurCrouchWalking then
            self.IsCurCrouchWalking = false
            print("NOT-U CROUCH ACT:", act)
        end
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
function ENT:SNPCMoveAwayFromCrosshair()
    local crossConv = GetConVar("vj_stalker_avoid_ply_crosshair"):GetInt()
    local ai_Conv = GetConVar("ai_ignoreplayers"):GetBool()
    if crossConv ~= 1 or not IsValid(self) or self.VJ_IsBeingControlled or (ai_Conv == 1 or VJ_CVAR_IGNOREPLAYERS) then
        return false 
    end
    local busy = self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK or self:IsBusy("Activities") or self.CurrentlyHealSelf or self.IsHumanDodging or self.Flinching
    local curT = CurTime()
    local bScheds = self:GetCurrentSchedule() == 30 or self:GetCurrentSchedule() == 27 
    if self.AvoidingC_Hair or
        busy or 
        bScheds or 
        self.MovementType == VJ_MOVETYPE_STATIONARY or   
        self:GetNPCState() == NPC_STATE_IDLE or  
        not self.Alerted or 
        self.IsGuard or
        self:GetWeaponState() == VJ.WEP_STATE_RELOADING or
        (self.Avoid_C_HairNextT and self.Avoid_C_HairNextT > curT) then
        return false 
    end
    for _, ply in ipairs(player.GetAll()) do
        local ene = self:GetEnemy()
        if IsValid(ene) and ene ~= ply then return end
        if ply:Alive() and IsValid(ply) and (self:Disposition(ply) == D_HT or self:Disposition(ply) == D_FR) and self.Avoid_C_Hair and not self:IsMoving() and not self.CurrentSchedule and self:IsOnGround() then
            local minDist = self.Avoid_C_HairMinDist or 1500
            local dist = self:GetPos():Distance(ply:GetPos())
            local trace = ply:GetEyeTrace()
            local gesChance = self.Avoid_C_HairGesChance or 3 
            local gesAnim = VJ.PICK(self.Avoid_C_HairGesTbl) 

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
                print("IM MIVUNG")
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
                    if self.Avoid_C_HairGesAnim and mRng(1, gesChance) == 1 then
                    self:PlayAnim("vjges_" .. gesAnim, false) 
                end
            end)
                local curT2 = CurTime()
                self.TakingCoverT = curT2 + mRand(1, 5)
                self.NextChaseTime = curT2 + mRand(1, 5)
                self.Avoid_C_HairNextT = curT2 + mRand(1.25, 10.25) 
                break
            end
        end
    end
    self.AvoidingC_Hair = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanFireQuickFlare() 
    if GetConVar("vj_stalker_fire_quick_flares"):GetInt()  ~= 1 then return false end
    if not IsValid(self) or self:IsBusy() or self.VJ_IsBeingControlled or not self.AllowedToLaunchQuickFlare then return false end

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

    if CurTime() < self.NextFireQuickFlareT then
        self.FireQuickFlareAttemptChecked = false
        return false
    end

    if not self.FireQuickFlareAttemptChecked then
        self.FireQuickFlareAttemptChecked = true
        if mRng(1, self.FireFlareFromGunChance) ~= 1 then
            self.NextFireQuickFlareT = CurTime() + mRand(50, 300) 
            return false
        end
    end

    if self:IsBusy("Activities") or self:GetWeaponState() == VJ.WEP_STATE_RELOADING then return false end

    return true, enemy, distanceToEnemy
end


function ENT:FireQuickFlare()
    local canFire, enemy, distToEnemy = self:CanFireQuickFlare()
    if not canFire then return end

    local aimPos
    local eneData = self.EnemyData or {}
    if self:Visible(enemy) then
        aimPos = enemy:GetPos() + Vector(mRand(-30, 30), mRand(-30, 30), 0)
    elseif self:VisibleVec(eneData.VisiblePos) and enemy:GetPos():Distance(eneData.VisiblePos) <= self.FireQuickFlareMax and self.FireQuickFlareAtLastEnePos then
        aimPos = eneData.VisiblePos + Vector(mRand(-30, 30), mRand(-30, 30), 0)
    else
        self.NextFireQuickFlareT = CurTime() + mRand(5, 15)
        return
    end

    self.IsFiringQuickFlare = true
    local fireAnim = VJ.PICK(self.AnimTbl_WeaponAttackSecondary)
    local fireT = VJ.AnimDuration(self, fireAnim) or 1
    self:PlayAnim(fireAnim, true, fireT, true)
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
        self.NextFireQuickFlareT = CurTime() + mRand(90, 175)
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayerSight(ent)
    local friendlyConVar = GetConVar(self.FriendlyConvar)
    if not friendlyConVar or friendlyConVar:GetInt() ~= 1 then return false end

    if CurTime() < self.NextGreetPlyAnimT then return false end
    
    if ent:IsPlayer() and not VJ_CVAR_IGNOREPLAYERS and self:CheckRelationship(ent) == D_LI and self.PlayAnimWhenSpotFrPly and self:Visible(ent) then
        
        if not IsValid(self) or
            self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or
            self:GetState() == VJ_STATE_ONLY_ANIMATION or
            self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK or
            self.VJ_IsBeingControlled or
            self.IsFollowing or
            self.FollowingPlayer or
            self:GetWeaponState() == VJ.WEP_STATE_RELOADING or
            self.WeaponAttackState == VJ.WEP_ATTACK_STATE_FIRE_STAND or
            self:GetNPCState() ~= NPC_STATE_IDLE or 
            self.Medic_Status or
            IsValid(self:GetEnemy()) or
            self:IsBusy() or
            not self:IsOnGround() or 
            self.Alerted then
            return false
        end
        
        local animChance = self.PlaySpotPlyAnimChance
        local seqSpotAnim = {"cheer2", "wave", "wave_close", "wave_SMG1", "salute"}
        local playedAnim = false
        local eneIdleCheck = not IsValid(self:GetEnemy()) and self:GetNPCState() == NPC_STATE_IDLE and (not ent:IsNPC() or not IsValid(ent:GetEnemy()))
        
        if mRng(1, animChance) == 1  then
            self:RemoveAllGestures()
            timer.Simple(mRand(0.15, 0.65), function()
                if IsValid(self) and not self:IsBusy() then
                    local selectedPlySpotAnim = VJ.PICK(seqSpotAnim)
                    local animDur = VJ.AnimDuration(self, selectedPlySpotAnim)
                    if selectedPlySpotAnim then
                        self:StopMoving()
                        self:SetTarget(ent)
                        self:SCHEDULE_FACE("TASK_FACE_TARGET")
                        self:PlayAnim("vjseq_" .. selectedPlySpotAnim, true, animDur, false)
                        playedAnim = true 
                    end
                end
            end)
        else
            if mRng(1, animChance / 2) == 1 then
                self:RemoveAllGestures()
                timer.Simple(mRand(0.15, 0.65), function()
                    if IsValid(self) and not self:IsBusy() then
                        local gesPlySpotAnim = {"vjges_g_wave"}
                        if gesPlySpotAnim then
                            self:SetTarget(ent)
                            self:SCHEDULE_FACE("TASK_FACE_TARGET")
                            self:PlayAnim(gesPlySpotAnim, false)
                            playedAnim = true 
                        end
                    end
                end)
            end
        end

        if playedAnim then
            self.NextGreetPlyAnimT = CurTime() + mRng(150, 200)
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFollow(status, ent)
    if not self.HasCustomFollowReaction then return false end

    if self.VJ_IsBeingControlled or self:IsBusy() or self.Flinching or 
       self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or 
       self:GetState() == VJ_STATE_ONLY_ANIMATION or 
       self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK or 
       IsValid(self:GetEnemy()) or self.Alerted then 
        return false 
    end

    if not IsValid(self) or not IsValid(ent) or not ent:Visible(self) or 
       (ent:IsPlayer() and self:Disposition(ent) ~= D_LI) then
        return false
    end

    local plyInteractResponseAnim = VJ.PICK({
        "hg_nod_yes", "hg_nod_right", "hg_nod_no", "hg_nod_left", "hg_headshake",
        "g_palm_up_l", "g_palm_up_l_high", "g_present", "g_point_swing", "g_point_swing_across",
        "g_palm_out_high_l", "g_palm_out_l", "g_palm_up_high_l", "g_palm_up_l",
        "g_plead_01_l", "g_fist_l"
    })

    if mRng(1, self.OnFollowAnimRespChance) == 1 then
        if status == "Start" or status == "Stop" then
            if plyInteractResponseAnim then     
                self:RemoveAllGestures()
                timer.Simple(mRand(1.25, 2), function()
                    if IsValid(self) then
                        self:PlayAnim("vjges_" .. plyInteractResponseAnim, false)
                        print("Playing " .. status .. " response anim!")
                    end
                end)
            end 
        end
    end 
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlyIdleFidgetAnim()
    if self.VJ_IsBeingControlled or not IsValid(self) or IsValid(self:GetEnemy()) or self:GetNPCState() ~= NPC_STATE_IDLE then return false end 

    if self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or
        self:GetState() == VJ_STATE_ONLY_ANIMATION or
        self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK or 
        self:IsBusy() or 
        not self:IsOnGround() or 
        self.Dead or
        self.PlayingAttackAnimation or
        self.CurrentSchedule or
        self.Alerted or 
        self.IsPlayingFidgetAnim then
        return false 
    end

    if CurTime() > self.NextIdleFidgetGestureAnimT and self.HasIdleFidgetGestureAnims then
        if mRng(1, self.IdleFidgetChance) ~= 1 then
            self.NextIdleFidgetGestureAnimT = CurTime() + mRand(5, 45)
            return
        end

        self:RemoveAllGestures()
        local fidgetAnim = VJ.PICK({"fidget_scratch_face","fidget_wipe_hand","fidget_wipe_face","fidget_stretch_neck","fidget_stretch_back","fidget_roll_shoulders","hg_turnr","hg_turnl","hg_turn_r","hg_turn_l"})

        self.IsPlayingFidgetAnim = true

        timer.Simple(mRand(0.25, 1), function()
            if not IsValid(self) or self:IsBusy() or IsValid(self:GetEnemy()) or self.Alerted then 
                self.IsPlayingFidgetAnim = false
                return 
            end 

            self:PlayAnim("vjges_" .. fidgetAnim, false)

            local fidgetTime = self:SequenceDuration(self:LookupSequence(fidgetAnim))
            self.NextIdleFidgetGestureAnimT = CurTime() + mRand(5, 35) + fidgetTime

            timer.Simple(fidgetTime, function()
                if IsValid(self) then
                    self.IsPlayingFidgetAnim = false
                    if IsValid(self:GetEnemy()) then
                        self:StopMoving() 
                        self:RemoveAllGestures()
                    end
                end
            end)
        end)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnIdleDialogue(ent, status, statusData)
    if self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or
        self:GetState() == VJ_STATE_ONLY_ANIMATION or
        self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK or 
        self:IsBusy() or
        not IsValid(self) or 
        not IsValid(ent) or 
        self.VJ_IsBeingControlled then 
        return false
    end

    local curT = CurTime()
    local chance = self.Dialogue_Anim_Chance or 2 
    local dialogueAnim = VJ.PICK(self.Dialogue_AnimTbl)
    if (status == "Speak" or status == "Answer") and mRng(1, chance) == 1 and self.Dialogue_Anim and curT > self.Dialogue_AnimNextT then 
        self:RemoveAllGestures()
        timer.Simple(mRand(0.15, 1.25), function()
            if IsValid(self) then 
                self:PlayAnim("vjges_" .. dialogueAnim)
            end
        end)
        self.Dialogue_AnimNextT = curT + mRand(5, 10)
    end 
end 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInvestigate(ent)
    if not IsValid(self) or IsValid(self:GetEnemy()) or self.VJ_IsBeingControlled or self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK or self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT then 
        return  
    end

    local curT = CurTime()
    local ene = self:GetEnemy()
    local chance = self.Investigate_AnimReactChance or 3
    local busy = self:IsBusy()
    if curT > self.Investigate_NextAnimT and mRng(1, chance) == 1 and not busy and self.Investigate_HasAnimReact and not IsValid(ene) then
        self:RemoveAllGestures()
        timer.Simple(mRand(0.2,1), function()
            if IsValid(self) then
                local investAnim = VJ.PICK(self.Investigare_AnimReactTbl)
                if investAnim then
                    self:PlayAnim("vjges_" .. investAnim, false)
                    print("Investigate Anim")
                end
                self.Investigate_NextAnimT = curT + mRand(5,10)
            end
        end)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Idle_FindLoot()
    if GetConVar("vj_stalker_looting"):GetInt() ~= 1 or not IsValid(self) or self.VJ_IsBeingControlled or self.IsGuard or not IsValid(self:GetActiveWeapon()) then
        return false
    end

    local busy = self:IsBusy() or self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK
    if busy or self:IsOnFire() or not self.AllowedToLoot or 
       self.MovementType == VJ_MOVETYPE_STATIONARY or 
       self.IsFollowing or self.FollowingPlayer or self.Alerted or self:GetNPCState() ~= NPC_STATE_IDLE then
        return false
    end

    local ene = self:GetEnemy()
    if IsValid(ene) and self:Visible(ene) then
        return false
    end

    if self:IsMoving() then return false end

    if CurTime() < self.NextFindLootT then return false end

    local function IsLootableEntity(entClass)
        for _, class in ipairs(self.LootableEntities) do
            if entClass == class then
                return true
            end
        end
        return false
    end

    self.FailedLoot = self.FailedLoot or {}

    local nearbyEntities = ents.FindInSphere(self:GetPos(), self.FindLootDistance)
    for _, v in ipairs(nearbyEntities) do
        if not IsValid(v) then continue end
        if not IsLootableEntity(v:GetClass()) then continue end
        if not self:Visible(v) then continue end

        if self.FailedLoot[v] and CurTime() < self.FailedLoot[v] then continue end

        self:SetLastPosition(select(2, VJ.GetNearestPositions(self, v, true)))
        local lootDist = VJ.GetNearestDistance(self, v, true)
        self:StopMoving()
        self:SCHEDULE_GOTO_POSITION(VJ.PICK({"TASK_RUN_PATH", "TASK_WALK_PATH"}), function(x)  
            x.CanShootWhenMoving = true 
            x.TurnData = {Type = VJ.FACE_ENEMY} 
        end)

        local pickUpAnim = VJ.PICK(self.PlyPickUpAnim)
        local plyPickUpItemAnim = self:SequenceDuration(pickUpAnim)

        self:SetTurnTarget(v)
        if lootDist < mRand(15, 45) then
            self:RemoveAllGestures()
            self:StopMoving()
            self:PlayAnim("vjseq_" .. pickUpAnim, true, VJ.AnimDuration(self, pickUpAnim), false)
            self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, plyPickUpItemAnim)
            VJ.EmitSound(self, "items/itempickup.wav")
            v:Remove()
            self.NextFindLootT = CurTime() + mRand(5, 15)
            return
        else
            self.FailedLoot[v] = CurTime() + mRand(5, 10)
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HumanFindMedicalEnt()
    if not self.AllowedToFindMedEnt or not IsValid(self) or self.VJ_IsBeingControlled or self.IsGuard or CurTime() > self.TakingCoverT then
        return false 
    end 

    if CurTime() < self.NextPickUpMedkitT then return end 

    local enemy = self:GetEnemy()
    local enemyDist = IsValid(enemy) and self:GetPos():Distance(enemy:GetPos()) or math.huge
    local enemyVisible = IsValid(enemy) and self:Visible(enemy)

    local dangerClose = enemyDist < 1500 and enemyVisible 
    if self.CurrentlyHealSelf or self:IsBusy() or self:IsOnFire() or 
        self:GetState() == VJ_STATE_ONLY_ANIMATION or 
        self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK or
        self.MovementType == VJ_MOVETYPE_STATIONARY or self.Medic_Status or self.Flinching or 
        self.IsFollowing or self.FollowingPlayer or dangerClose then
        return false
    end
    
    local function IsMedicalItem(ent)
        local class = ent:GetClass()
        return class:find("kit") or class:find("vial")
    end

    local myHealth = self:Health()
    local maxHealth = self:GetMaxHealth()
    if myHealth >= maxHealth * 0.99 then return end
    if IsValid(enemy) and dangerClose then return end 

    local nearbyEntities = ents.FindInSphere(self:GetPos(), 3525)
    for _, v in ipairs(nearbyEntities) do
        if IsValid(v) and IsMedicalItem(v) and not self:IsMoving() and not self:IsBusy("Activities") then
            self:SetLastPosition(select(2, VJ.GetNearestPositions(self, v)))
            local medicalItemDist = VJ.GetNearestDistance(self, v, true)
            self:StopMoving()
            self:SCHEDULE_GOTO_POSITION(VJ.PICK({"TASK_RUN_PATH", "TASK_WALK_PATH"}), function(x)  
                x.CanShootWhenMoving = true 
                x.TurnData = {Type = VJ.FACE_ENEMY} 
            end)

            self:SetTurnTarget(v)
            local pickUpAnim = VJ.PICK(self.PlyPickUpAnim)
            local plyPickUpItemAnim = self:SequenceDuration(pickUpAnim)

            if medicalItemDist < mRand(15,65) then
                local pickupAnim = VJ.PICK(self)
                self:RemoveAllGestures()
                self:SCHEDULE_FACE("TASK_FACE_LASTPOSITION")
                self:PlayAnim("vjseq_" .. pickUpAnim, true, VJ.AnimDuration(self, pickUpAnim), false)
                self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, plyPickUpItemAnim)
                VJ.EmitSound(self, "items/smallmedkit1.wav")
                VJ.EmitSound(self, "items/itempickup.wav")
                self:SetHealth(math.Clamp(myHealth + mRng(15, 50), 0, maxHealth))
                v:Remove()
                self.NextPickUpMedkitT = CurTime() + mRand(3, 5)
                return 
            end
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.NextWeaponPickUpT = mRand(1, 5)
ENT.AllowedToFindWeapon = true 
-- Need to fix SNPCs original dropped weapon from disappearing from existance if the SNPC picks up some other weapon that wasn't orignally theirs. 
function ENT:CanPickUpWeapon()
    if not IsValid(self) or not self.AllowedToFindWeapon or self.VJ_IsBeingControlled then return false end 

    local hasWeapon = IsValid(self:GetActiveWeapon())

    if (hasWeapon and self.IsGuard) or self.CurrentlyHealSelf or self:IsOnFire() or 
        self.MovementType == VJ_MOVETYPE_STATIONARY or self.Medic_Status or 
        self.IsFollowing or self.FollowingPlayer or self:IsBusy() or 
        self:GetState() == VJ_STATE_ONLY_ANIMATION or 
        self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or 
        self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK then
        return false
    end

    if not hasWeapon and CurTime() > self.NextWeaponPickUpT then
        if not IsValid(self:GetEnemy()) or (IsValid(self:GetEnemy()) and self:GetPos():Distance(self:GetEnemy():GetPos()) > 550) then
            for _, v in ipairs(ents.FindInSphere(self:GetPos(), 3500)) do
                if IsValid(v) and self:Visible(v) and v:GetClass():find("weapon_vj_") and not IsValid(v:GetOwner()) and not self:IsMoving() and not self:IsBusy() then
                    self:SetLastPosition(select(2, VJ.GetNearestPositions(self, v)))
                    self:StopMoving()
                    self:SCHEDULE_GOTO_POSITION(VJ.PICK({"TASK_RUN_PATH", "TASK_WALK_PATH"}), function(x) end)
                    self:SetTarget(v)
                    self:SCHEDULE_FACE("TASK_FACE_TARGET")

                    if VJ.GetNearestDistance(self, v, true) < mRand(10, 50) then
                        local pickUpAnim = VJ.PICK(self.PlyPickUpAnim)
                        self:StopMoving()
                        self:RemoveAllGestures()
                        self:PlayAnim("vjseq_" .. pickUpAnim, true, VJ.AnimDuration(self, pickUpAnim), false)
                        self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK, self:SequenceDuration(pickUpAnim))
                        VJ.EmitSound(self, self.DrawNewWeaponSound, mRng(80, 125), mRng(90, 105))
                        self:Give(v:GetClass())
                        self:SelectWeapon(v:GetClass())
                        self.NextWeaponPickUpT = CurTime() + mRand(1, 5)
                        v:Remove()
                    end 
                end
            end
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Add tolerance or smthing for 45 degeess
function ENT:KickDoorDown()
    local busy = self:IsBusy() or self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK
    local conv = GetConVar("vj_stalker_kickdoor"):GetInt()
    if conv ~= 1 or not IsValid(self) or self.VJ_IsBeingControlled or busy then
        return false
    end
    
    local enemy = self:GetEnemy() 
    local curT = CurTime()
    local pos = self:GetPos()
    local eneVisAlert = IsValid(enemy) and self.Alerted and not self:Visible(enemy)
    if busy or self:IsMoving() or self.IsFollowing or 
       self:GetWeaponState() == VJ.WEP_STATE_RELOADING or self.WeaponAttackState == VJ.WEP_ATTACK_STATE_FIRE_STAND or self.Flinching or not self.AllowedToKickDownDoors then
        return false
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
                    local yawDiff = math.abs(math.AngleDifference(currentYaw, desiredYaw))
                    if yawDiff > 15 then
                        self.BreakDoor = NULL
                        return
                    end

                    local rngSnd = mRng(85, 105)
                    VJ.EmitSound(self, "npc/metropolice/gear" .. mRng(1, 6) .. ".wav", rngSnd, rngSnd)

                    local kickAnim = VJ.PICK(self.KickDownDoorAnims)
                    local kickT = VJ.AnimDuration(self, kickAnim)
                    self:PlayAnim("vjseq_" .. kickAnim, true, kickT, false)
                    self:SetState(VJ_STATE_ONLY_ANIMATION, kickT)
                    if mRng(1, 2) == 1 then 
                        VJ.EmitSound(self, self.SoundTbl_Suppressing, rngSnd, rngSnd)
                    end 
                
                    local doorBreak = VJ.PICK({"general_sds/doorbreak/doorbust1", "general_sds/doorbreak/doorbust2","ambient/materials/door_hit1.wav"})
                    local woodBreak = VJ.PICK({"physics/wood/wood_crate_break" .. mRng(1, 5) .. ".wav"})
                    local furnBreak = VJ.PICK({"physics/wood/wood_furniture_break" .. mRng(1, 2) .. ".wav"})
                    local door = self.BreakDoor
                
                    if IsValid(door) and door:GetClass() == "prop_door_rotating" then
                        VJ.EmitSound(self, doorBreak .. ".wav", rngSnd, rngSnd)
                        VJ.EmitSound(door, woodBreak, rngSnd, rngSnd)
                        if mRng(1, 2) == 1 and IsValid(self) then 
                            VJ.EmitSound(door, furnBreak, rngSnd, rngSnd)
                        end
                        
                        local dAng = door:GetAngles()
                        ParticleEffect("door_explosion_chunks", door:GetPos(), dAng, nil)
                        ParticleEffect("door_pound_core", door:GetPos(), dAng, nil)
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
                        brokenDoorProp:SetPos(door:GetPos() + VectorRand(-15, 15)* Vector(1, 1, 0)+Vector(0, 0, mRand(5, 10)))
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
function ENT:SetIncapAnims()
    timer.Simple(0.1, function()
        if IsValid(self) then
            local InCapAnimSet = mRng(1, 4)
            if InCapAnimSet == 1 then
                self.BecomeIncappedAnim = "ranen2_idle1"
                self.IncapicitatedIdleAnim = "vjseq_ranen2_idle2"
                self.RecoverFromIncapAnim = "ranen2_idle3"
            elseif InCapAnimSet == 2 then
                self.BecomeIncappedAnim = "ranen3_idle1"
                self.IncapicitatedIdleAnim = "vjseq_ranen3_idle2"
                self.RecoverFromIncapAnim = "ranen3_idle3"
            elseif InCapAnimSet == 3 then
                self.BecomeIncappedAnim = "ranen_idle1"
                self.IncapicitatedIdleAnim = "vjseq_ranen_idle2"
                self.RecoverFromIncapAnim = "ranen_idle3"
            elseif InCapAnimSet == 4 then 
                self.BecomeIncappedAnim = "wounded_in_legs"
                self.IncapicitatedIdleAnim = "wounded_in_legs_loop"
                self.RecoverFromIncapAnim = "getup_05"
            end
            self.IncapAnimsInitialized = true 
            print("Incap animation set: " .. self.BecomeIncappedAnim .. ", Idle animation: " .. self.IncapicitatedIdleAnim)
        end
    end)
end

function ENT:CheckToBecomeIncapacitated()
    local conv = GetConVar("vj_stalker_incapacitated"):GetInt()
    if conv ~= 1 or self.VJ_IsBeingControlled or not IsValid(self) then 
        return false 
    end 
    local busy = self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK or self:IsBusy() or self:IsBusy("Activities")
    if self.IncapCounter >= self.IncapAmount or self.NeverBecomeIncappedAgain then
        print("Cannot be incapacitated anymore.")
        return false
    end

    if busy or self.Flinching or self.Medic_Status or not self:IsOnGround() or not IsValid(self) or self:IsOnFire() or not self.CanBecomeIncapicitated or self.PlayingAttackAnimation or self:IsMoving() or self:GetWeaponState() == VJ.WEP_STATE_RELOADING or self.PlayingAttackAnimation then 
        return false 
    end 

    local lowHp = mRand(0.2,0.33)
    if self:Health() < (self:GetMaxHealth() * lowHp) and IsValid(self) and not busy then
        self:StopMoving()
        self:ClearSchedule()
        self:PlayIncapAnimIntro()
        self:StopAttacks(true)
        self:SetState()
    end
end

function ENT:PlayIncapAnimIntro()
    local busy = self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK or self:IsBusy() or self:IsBusy("Activities")
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
                local incapIdleDuration = self:SequenceDuration(incapIdleSeq)
                self:LoopIncapIdleAnim(incapIdleDuration)
            end
        end)
    else
        print("Failed to play BecomeIncappedAnim.")
        self.IsCurrentlyIncapacitated = false
        self.NowIdleIncap = false
    end
end

function ENT:LoopIncapIdleAnim(incapIdleDuration)
    if not IsValid(self) or not self.NowIdleIncap or self.PlayingIncapAnim or not self.IsCurrentlyIncapacitated then return end

    self:SetIncapVars()
    self:PlayAnim("vjseq_" .. self.IncapicitatedIdleAnim, true,  VJ.AnimDuration(self, self.IncapicitatedIdleAnim), false)
    self:SetState(VJ_STATE_ONLY_ANIMATION, incapIdleDuration)
    timer.Simple(incapIdleDuration, function()
        if IsValid(self) then
            self:LoopIncapIdleAnim(incapIdleDuration) 
        end
    end)
end

function ENT:CheckToRecoverFromIncap()
    if self.IsCurrentlyIncapacitated and self.NowIdleIncap and self:Health() > (self:GetMaxHealth() * 0.5) then
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
        self.AllowedToFindWeapon = false 
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
        self.AllowedToFindWeapon = true 
        self.AvoidIncomingDanger = true
        self.HullType = HULL_HUMAN

        self.NextWeaponPickUpT = CurTime() + mRand(3,5)
        if self.SNPCMedicTag then 
            self.IsMedic = true 
            self.Medic_NextHealT = CurTime() + mRand(self.Medic_NextHealTime.a, self.Medic_NextHealTime.b)
        end
        if GetConVar(self.FriendlyConvar):GetInt()  == 1 then
            self:ManageFriendlyVars()
        else 
            self.Behavior = VJ_BEHAVIOR_AGGRESSIVE 
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlaceCombatFlare()
    if not IsValid(self) or not self.CanDeployFlareInCombat or self.VJ_IsBeingControlled or self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK then 
        return false 
    end 
    
    if self.IsCurrentlyDeployingAFlare then 
        return 
    end
    
    if CurTime() < self.CombatFlareDeployT then 
        return 
    end

    local enemy = self:GetEnemy()
    if not IsValid(enemy) or not self:IsOnGround() or self:WaterLevel() > 0 or self:IsMoving() or self:IsBusy() or self:GetWeaponState() == VJ.WEP_STATE_RELOADING then
        self.CombatFlareDeployT = CurTime() + mRand(1, 5)
        return false
    end 

    if not self.EnemyData.VisibleTime then
        self.CombatFlareDeployT = CurTime() + mRand(1, 5)
        return false
    end

    if self.RequireAllyToDepFlare then
        local requireAllies = GetConVar("vj_stalker_place_flares_ally_check"):GetInt() == 1
        local requireVisibleAllies = GetConVar("vj_stalker_place_flares_ally_vis_check"):GetInt() == 1

        if requireAllies then
            local allies = self:Allies_Check(self.DepFlareAllyCheckDist)

            if not allies or #allies == 0 then
                self.CombatFlareDeployT = CurTime() + mRand(1, 5)
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
                    self.CombatFlareDeployT = CurTime() + mRand(1, 5)
                    return false
                end
            end
        end
    end

    local deployChance = self.DeployCombatFlareChance
    local distanceToEnemy = self:GetPos():Distance(enemy:GetPos())
    if (distanceToEnemy < 2500 and enemy:Visible(self)) or self:IsBusy() then 
        self.CombatFlareDeployT = CurTime() + mRand(1, 5)
        return 
    end

    if not self.FlareDeployAttemptCheck then
        self.FlareDeployAttemptCheck = true
        if mRng(1, deployChance) ~= 1 then 
            self.CombatFlareDeployT = CurTime() + mRand(150, 300)  
            return 
        end
    end

    self.IsCurrentlyDeployingAFlare = true
    local animDuration = VJ.AnimDuration(self, "grenplace")

    self:PlayAnim("vjseq_grenplace", true, animDuration, true)
    timer.Simple(mRand(0.45, 0.65), function()
        if not IsValid(self) then return end

        local flare = ents.Create("env_flare")
        if not IsValid(flare) then 
            self.IsCurrentlyDeployingAFlare = false
            return 
        end

        local flareSpawnFlagRNG = VJ.PICK({"4","8"})
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
    
    timer.Simple(animDuration, function()
        if IsValid(self) then
            self.IsCurrentlyDeployingAFlare = false
            if mRng(1, 2) == 1 then
                timer.Simple(mRand(0.5, 1.25), function()
                    if IsValid(self) and IsValid(self:GetEnemy()) and self.RetreatAfterDeployFlare then
                        self:StopMoving()
                        self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH", function(x)
                            x.CanShootWhenMoving = true
                            x.TurnData = {Type = VJ.FACE_ENEMY}
                        end)
                        self.NextDoAnyAttackT = CurTime() + mRand(1.25,5.25)
                    end
                end)
            end
        end
    end)

    self.NextFireQuickFlareT = CurTime() + mRand(25, 45)
    self.CombatFlareDeployT = CurTime() + mRand(350, 650)
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Distress_SigAnim = true 
ENT.Distress_Sig_Chance = 2 
ENT.Distress_SigNextT = 0 
ENT.Distress_SigRange = 2000
function ENT:DistressOnCloseProximity()
    if not IsValid(self) or self.VJ_IsBeingControlled or not self.AllowedToPanicAtCloseProx then return false end
    local ene = self:GetEnemy()
    local curT1 = CurTime()
    if not IsValid(ene) or not self:Visible(ene) or self:IsUnreachable(ene) then return false end
    if self:IsBusy() or curT1 < self.NextPanicOnCloseProxT or self.IsGuard then return false end

    local distToEnemy = self:GetPos():Distance(ene:GetPos())
    if distToEnemy >= self.CloseProxPanicDist then return false end

    local allyDetectRange = self.Panic_DetectAllyRange or 1500
    local nearbyAllies = self:Allies_Check(allyDetectRange) or {}
    local allyCount = #nearbyAllies
    local isAlone = self.IsCurrentlyAlone or false
    local gesAnim = "vjges_" .. VJ.PICK(self.DetectDangerReactAnim)
    local sigChance = self.Distress_Sig_Chance or 3
    local signalRange = self.Distress_SigRange or 2500
    local nearbySignalAllies = self:Allies_Check(signalRange) or {}

    print("[Distress] Enemy too close! Distance: " .. distToEnemy)
    print("[Distress] Nearby allies detected: " .. allyCount)
    print("[Distress] Is currently alone? " .. tostring(isAlone))

    local shouldPanic = true
    local panicCooldown = mRand(5, 35) -- Default

    if allyCount >= self.Panic_AllySuppressCount then
        print("[Distress] Too many allies nearby (" .. allyCount .. " >= " .. self.Panic_AllySuppressCount .. "). Suppressing panic.")
        shouldPanic = false
    elseif allyCount == 1 or allyCount == 2 then
        if mRng(1, 100) > 60 then
            print("[Distress] Some allies nearby. Panic suppressed this time.")
            shouldPanic = false
        else
            print("[Distress] Some allies nearby. Allowing panic (randomized).")
            panicCooldown = mRand(10, 25)
        end
    elseif isAlone then
        print("[Distress] SNPC is alone. Panic is likely.")
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
            self:PlayAnim(gesAnim, true)
            self.Distress_SigNextT = curT + mRand(10, 20) 
            print("[Distress] Playing distress signal animation due to nearby allies.")
        end
    end

    self:ClearSchedule()
    self:StopMoving()

    self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH", function(x)
        x.CanShootWhenMoving = true
        x.TurnData = {Type = VJ.FACE_ENEMY}
    end)

    print("[Distress] Panic behavior activated! Next panic delay: " .. panicCooldown .. " seconds")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CheckFlashlightReaction()
    if not IsValid(self) or self.VJ_IsBeingControlled then return false end 
    if self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK then return end 
    if self.NextFlashlightCheckT and CurTime() < self.NextFlashlightCheckT then return end

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

        -- Should SNPC react based on disposition 
        if disp == D_LI and flashBlindFri and not (self.Alerted or IsValid(ene)) then
            shouldReact = true
        elseif disp == D_HT and flashBlindEne then
            shouldReact = true
        end

        if ply:FlashlightIsOn() and shouldReact and not VJ_CVAR_IGNOREPLAYERS and 
           self.CanBeBlindedByPlyLight and distance < blindDist and dotProduct > 0.5 then

            local snpcPos = self:GetPos() + Vector(0, 0, mRand(60,75)) 
            local plyEyePos = ply:GetShootPos()
            local plyAimVector = ply:GetAimVector()

            local traceData = {start = plyEyePos, endpos = plyEyePos + (plyAimVector * 800), filter = ply}
            local trace = util.TraceLine(traceData)

            if trace.Entity == self then
                self:StopMoving()
                self:PlayFlashlightReaction()
                return
            end
        end
    end
end

function ENT:PlayFlashlightReaction()
    if not self:IsOnGround() or self:IsMoving() then return end
    local mini = mRand(0.025, 1.125)
    local seqAnim = "vjseq_" .. VJ.PICK({"blinded_01", "photo_react_blind"})
    local gesAnim = "vjges_" .. VJ.PICK({"flinch_head_small_01", "flinch_head_small_02", "flinchheadgest"})
    local seqAnimDur = math.max(VJ.AnimDuration(self, seqAnim) - mini, 0) or 1
    local gesAnimDur = VJ.AnimDuration(self, gesAnim) or 1
    local delay = mRand(0.01, 0.2)

    timer.Simple(delay, function()
        if not IsValid(self) then return end

        local canDoFullAnim = not self:IsBusy("Activities") and not self:IsBusy() and not self.Copy_IsCrouching and not self:IsMoving()

        self:RemoveAllGestures() 

        if canDoFullAnim then
            self:PlayAnim(seqAnim, true, seqAnimDur, false)
            self.NextFlashlightCheckT = CurTime() + mRand(5, 15)
        else
            self:PlayAnim(gesAnim, false, gesAnimDur, false)
            self.NextFlashlightCheckT = CurTime() + mRand(2.5, 7.5)
        end

        if mRng(1, 3) == 1 then
            local snd = VJ.PICK({"Pain", "CallForHelp"})
            self:PlaySoundSystem(snd)
        end
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IfSelfIsLoneMember()
    if not IsValid(self) or not self.HasAloneAiBehaviour or self.VJ_IsBeingControlled then return false end 

    local allyCheckDist = self.FindAllyDistance or 3000
    local getAllies = self:Allies_Check(allyCheckDist)
    local ene = self:GetEnemy()
    local conv = GetConVar("vj_stalker_lm_tr_vj_creature"):GetInt()
    if IsValid(ene) and ene.IsVJBaseSNPC_Creature and conv ~= 1 then
        return 
    end

    if getAllies == false or #getAllies == 0 then
        if IsValid(ene) and not self.IsCurrentlyAlone then
            self.IsCurrentlyAlone = true
            self.DisableChasingEnemy = true
            self.Weapon_FindCoverOnReload = true
        end
    else
        if self.IsCurrentlyAlone then
            self.IsCurrentlyAlone = false
            self.DisableChasingEnemy = false
        end

        if self.DoesNotHaveCoverReload then
            self.Weapon_FindCoverOnReload = false 
        end 
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
 -- [Current bugs] -- 
 // SNPC's bone's resetting can be delayed
 // SNPCS stay leaning, despite them moving around/not resetting properly sometimes. 
ENT.CanWeLean = true
ENT.CurrentlyLeaning = false
ENT.NextLeanTime = 1
ENT.LeanTransitionSpeed = 0.5
ENT.StateChangeDelay = 0
ENT.LastStateChange = 0
ENT.TargetLeanAngle = Angle(0,0,0)
ENT.CurrentLeanAngle = Angle(0,0,0)
ENT.LeanCooldownUntil = 0

function ENT:ResetLean()
    self.CurrentlyLeaning = false
    self.TargetLeanAngle = Angle(0, 0, 0)
    self.CurrentLeanAngle = Angle(0, 0, 0)
    self.LastStateChange = CurTime()
    self.LeanCooldownUntil = CurTime() + mRand(3.5, 7.5)
end

function ENT:CheckLeanReset()
    if not self.CurrentlyLeaning then return end

    local enemy = self:GetEnemy()
    local shouldReset =
        not IsValid(enemy) or
        self:IsMoving() or
        self:GetActivity() == ACT_RUN or
        self:GetActivity() == ACT_WALK or
        self:GetWeaponState() == VJ.WEP_STATE_RELOADING or
        (IsValid(enemy) and (self:GetPos():Distance(enemy:GetPos()) < 300 or self:Visible(enemy)))

    if not shouldReset and self.CurrentlyLeaning then
        local attackAnim = self:GetTable().WeaponAttackAnim
        shouldReset = not (attackAnim == self:TranslateActivity(VJ.PICK(self.AnimTbl_WeaponAttack)) or attackAnim == self:TranslateActivity(VJ.PICK(self.AnimTbl_WeaponAttackCrouch)))
    end

    if shouldReset then
        self:ResetLean()
    end
end

function ENT:ContextToLean()
    self:CheckLeanReset()
    if GetConVar("vj_stalker_can_lean"):GetInt() ~= 1 then return false end 
    if self:IsMoving() or self.VJ_IsBeingControlled or not IsValid(self) then return false end
    if self.LeanCooldownUntil > CurTime() then return false end

    if self.NextLeanTime < CurTime() and CurTime() > self.TakingCoverT and self.CanWeLean and IsValid(self:GetActiveWeapon()) and not self.CurrentlyLeaning then
        self:CustomLean()
    end
    

    local spinebone = self:LookupBone("ValveBiped.Bip01_Spine")
    if spinebone then
        self.CurrentLeanAngle = LerpAngle(self.LeanTransitionSpeed, self.CurrentLeanAngle, self.TargetLeanAngle)
        self:ManipulateBoneAngles(spinebone, self.CurrentLeanAngle)
    end

    if not IsValid(self:GetEnemy()) and self.NextLeanTime < CurTime() then
        self.TargetLeanAngle = Angle(0, 0, 0)
    end
end

function ENT:CustomLean()
    //self.NextLeanTime = CurTime() + mRand(0.1, 0.35)
    
    if not IsValid(self:GetEnemy()) or self:IsMoving() or self:GetActivity() == ACT_RUN or self:GetActivity() == ACT_WALK  then
        if CurTime() - self.LastStateChange > self.StateChangeDelay then
            self:ResetLean()
        end
        return
    end

    if IsValid(self:GetEnemy()) and self:GetPos():Distance(self:GetEnemy():GetPos()) < 300 and self:Visible(self:GetEnemy()) then
        if self.CurrentlyLeaning then
            self:ResetLean()
        end
        return
    end

    local traceStart = GetConVar("vj_stalker_lp_wep"):GetInt()  == 1 and IsValid(self:GetActiveWeapon()) and self:GetActiveWeapon():GetPos() or (self:GetPos() + self:OBBCenter() * mRand(1.5, 1.8))
    
    local tracedataAD = {
        start = traceStart,
        endpos = self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter() * mRand(1.5, 1.8),
        filter = {self:GetEnemy(), self}
    }
    local trAD = util.TraceLine(tracedataAD)

    local spinebone = self:LookupBone("ValveBiped.Bip01_Spine")
    if not spinebone then return end

    local right = mRand(15, 25)
    if trAD.HitWorld or (IsValid(trAD.Entity) and (
        trAD.Entity:GetClass():match("prop_") or
        trAD.Entity:GetClass():match("func_") or
        trAD.Entity:IsNPC() or trAD.Entity:IsPlayer() or trAD.Entity:IsNextBot())) then

        if trAD.Entity:IsNPC() or trAD.Entity:IsNextBot() or trAD.Entity:IsPlayer() then
            if self:Disposition(trAD.Entity) ~= D_LI and self:Disposition(trAD.Entity) ~= D_NU then return end
        end

        local traceStartEx = GetConVar("vj_stalker_lp_wep"):GetInt()  == 1 and IsValid(self:GetActiveWeapon()) and self:GetActiveWeapon():GetPos() or self:GetPos()

        local tracedataRight = {
            start = traceStartEx + self:GetRight() * right + self:GetUp() * 45,
            endpos = self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter() * mRand(1.5, 1.8),
            filter = {self}
        }

        local tracedataLeft = {
            start = traceStartEx + self:GetRight() * -right + self:GetUp() * 45,
            endpos = self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter() * mRand(1.5, 1.8),
            filter = {self}
        }

        local trR = util.TraceLine(tracedataRight)
        local trL = util.TraceLine(tracedataLeft)

        local newState = false
        local newTargetAngle = Angle(0, 0, 0)

        local atkAnim = self:GetTable().WeaponAttackAnim

        if trR.Entity == self:GetEnemy() then
            if atkAnim == self:TranslateActivity(VJ.PICK(self.AnimTbl_WeaponAttackCrouch)) then
                self:StopMoving()
                newTargetAngle = Angle(30, 25, 15)
                newState = true
            elseif atkAnim == self:TranslateActivity(VJ.PICK(self.AnimTbl_WeaponAttack)) then
                self:StopMoving()
                newTargetAngle = Angle(30, 30, 15)
                newState = true
            end
        elseif trL.Entity == self:GetEnemy() then
            if atkAnim == self:TranslateActivity(VJ.PICK(self.AnimTbl_WeaponAttackCrouch)) then
                self:StopMoving()
                newTargetAngle = Angle(-30, -10, 5)
                newState = true
            elseif atkAnim == self:TranslateActivity(VJ.PICK(self.AnimTbl_WeaponAttack)) then
                self:StopMoving()
                newTargetAngle = Angle(-15, -55, 0)
                newState = true
            end
        end

        if (newState ~= self.CurrentlyLeaning or (newState and self.TargetLeanAngle ~= newTargetAngle)) and CurTime() - self.LastStateChange > self.StateChangeDelay then
            if newState then
                self.TargetLeanAngle = newTargetAngle
                self:SetTurnTarget("Enemy")
            else
                self.TargetLeanAngle = Angle(0, 0, 0)
            end

            self.CurrentlyLeaning = newState
            self.LastStateChange = CurTime()
        end
    elseif self.CurrentlyLeaning and CurTime() - self.LastStateChange > self.StateChangeDelay then
        self:ResetLean()
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SeekOutMedic()
    if not IsValid(self) or self.VJ_IsBeingControlled or self.IsGuard or self.Dead or self.IsMedic or self:IsOnFire() then return false end
    if not self.CanSeekOutMedic or IsValid(self:GetEnemy()) or self:IsBusy() or CurTime() < self.NextMedicSeekT then return false end
    if self:Health() >= self:GetMaxHealth() * 0.65 then return false end

    local nearestMedic, nearestDist = nil, math.huge
    for _, ent in pairs(ents.FindInSphere(self:GetPos(), self.MedicSeekRange)) do
        if ent != self and IsValid(ent) and ent.IsVJBaseSNPC and self:CheckRelationship(ent) == D_LI and not ent:IsBusy() and ent.IsMedic and (not self.Dead or ent:Alive()) and not self:IsUnreachable(ent) then
            local dist = self:GetPos():DistToSqr(ent:GetPos())
            if dist < nearestDist then
                nearestMedic = ent
                nearestDist = dist
            end
        end
    end

    if IsValid(nearestMedic) then
        local actualDist = math.sqrt(nearestDist)
        self.CurrentMedicTarget = nearestMedic
        self.NextMedicSeekT = CurTime() + self.MedicSeekCooldownTime

        if actualDist > self.MedicApproachStopRange then
            self:SetTurnTarget(nearestMedic)
            self:ClearSchedule()
            self:StopMoving()
            self:SetLastPosition(nearestMedic:GetPos() + nearestMedic:GetForward() * mRng(-60, 60) + nearestMedic:GetRight() * mRng(-60, 60))
            self:SCHEDULE_GOTO_POSITION(VJ.PICK({"TASK_RUN_PATH","TASK_WALK_PATH"}), function(x)
                x.CanShootWhenMoving = true
                x.TurnData = {Type = VJ.FACE_ENEMY}
            end)
        end
    else
        self.CurrentMedicTarget = nil
    end
end

ENT.HasSilentCrouchFootSteps = true
ENT.OriginalHasFootstepSounds = true
ENT.IsCurCrouchWalking = false
function ENT:StealthMovement()
    if not self.HasSilentCrouchFootSteps or not self.OriginalHasFootstepSounds then return end
    if not IsValid(self) then return end

    local crouching = self.IsCurCrouchWalking
    local hasFootsteps = self.HasFootstepSounds

    if crouching and hasFootsteps then
        self.HasFootstepSounds = false
        print("🕶 Silent crouch: footsteps disabled")
    elseif not crouching and not hasFootsteps then
        self.HasFootstepSounds = true
        print("🚶 Normal movement: footsteps re-enabled")
    end
end


ENT.PlyFlash_Aware = true

function ENT:PlyFlash_IdleAlert()
    if not self.PlyFlash_Aware or self.VJ_IsBeingControlled or not IsValid(self) then return end
    if IsValid(self:GetEnemy()) or self:GetNPCState() ~= NPC_STATE_IDLE then return end
    //if VJ_CVAR_IGNOREPLAYERS then return end

    local closestPly
    local closestDist = 1000

    for _, ply in ipairs(player.GetAll()) do
        if IsValid(ply) and ply:Alive() and ply:FlashlightIsOn() then
            if self:Disposition(ply) == D_HT then
                local plyEyePos = ply:EyePos()
                local plyAimVec = ply:GetAimVector()
                local dirToNPC = (self:EyePos() - plyEyePos):GetNormalized()

                -- Check if NPC is within player's flashlight cone (dot product)
                local dot = plyAimVec:Dot(dirToNPC)
                if dot > 0.85 then -- 1 = dead center, 0 = perpendicular; 0.85 ≈ ~30° cone
                    -- Trace to ensure no obstruction
                    local tr = util.TraceLine({
                        start = plyEyePos,
                        endpos = self:EyePos(),
                        filter = ply,
                        mask = MASK_VISIBLE
                    })

                    if tr.Entity == self then
                        local dist = self:GetPos():DistToSqr(ply:GetPos())
                        if dist < closestDist then
                            closestDist = dist
                            closestPly = ply
                        end
                    end
                end
            end
        end
    end

    if IsValid(closestPly) then
        print(self, "has detected player flashlight via cone + trace:", closestPly)
        self:SetTurnTarget(closestPly)
        self:SetEnemy(closestPly)
        self:UpdateEnemyMemory(closestPly, closestPly:GetPos())
    end
end

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
end

function ENT:OnThinkActive()
    if not IsValid(self) then
        return false
    end
    self:PlyFlash_IdleAlert()
    self:StealthMovement()
    self:CopyPlayerStance()
    self:IdleIncap_LastChanceGren()
    self:SeekOutMedic()
    self:ContextToLean()
    self:HitWallWhenShoved()
    //self:CustomLean()
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
    self:PlyIdleFidgetAnim()
    self:SNPCMoveAwayFromCrosshair()
    self:ManageWeaponBackAway()
    self:HumanFindMedicalEnt()
    self:CanPickUpWeapon()
    self:KickDoorDown()
    self:DisableRHealthRegen()
    self:EnableCryForAid()
    self:HumanEvadeDangerousEntities()
    self:HumanEvadeAbility()
    //self:CombatChaseBehavior()
    self:CheckToBecomeIncapacitated()
    self:SetIncapVars()
    self:CheckToRecoverFromIncap()
    self:DetectLanding()
    self:HumanCanHealSelf()
    self:CheckFlashlightReaction()
    self:MngGrenadeAttackCount()
    self:WaterExtinguishSelFire()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HumanCanHealSelf()
    if not IsValid(self) or self.VJ_IsBeingControlled then return false end

    local curT = CurTime()
    local maxHp = self:GetMaxHealth()
    local ground = self:IsOnGround()
    local moving = self:IsMoving()
    local busy = self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK or self:IsBusy()

    if busy then return false end

    local enemy = self:GetEnemy()
    local enemyValid = IsValid(enemy)
    local enemyVisible = enemyValid and self:Visible(enemy)
    local enemyDist = enemyValid and self:GetPos():DistToSqr(enemy:GetPos()) or math.huge
    if enemyVisible and enemyDist <= (1520 * 1520) then return false end

    if self:InEneLineOfSight(enemy, 0.7) then
        if self.Debug_InEneLOS then print("Enemy is looking at me! Cancelling self-heal.") end
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

    if not self.CanHumanHealSelf or self.CurrentlyHealSelf or busy or self.Flinching or moving or not ground or
       self:IsOnFire() or self.Medic_Status or curT <= self.HealSelf_NextT or self:Health() >= maxHp * 0.99 then
        return false
    end

    local coverDelay = 0
    if enemyValid and self.FindCov_PriorSH then
        self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH", function(x)
            x.CanShootWhenMoving = true
            x.TurnData = {Type = VJ.FACE_ENEMY}
        end)
        coverDelay = mRand(1.5, 3.5) 
    elseif mRng(1, 2) == 1 then
        self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH", function(x)
            x.CanShootWhenMoving = true
            x.TurnData = {Type = VJ.FACE_ENEMY}
        end)
        coverDelay = mRand(1, 2.5)
    end

    self.CurrentlyHealSelf = true
    local initiateDelay = (self.HealSelfDelay or mRand(1, 5)) + coverDelay

    timer.Simple(initiateDelay, function()
        if not IsValid(self) or self.Dead then return end

        local curT2 = CurTime()
        local ground2 = self:IsOnGround()
        local moving2 = self:IsMoving()
        local busy2 = self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK or self:IsBusy()
        local enemy2 = self:GetEnemy()
        local enemyVisible2 = IsValid(enemy2) and self:Visible(enemy2)
        local enemyTooClose = enemyVisible2 and self:GetPos():DistToSqr(enemy2:GetPos()) <= (1520 * 1520)

        if busy2 or self.Dead or moving2 or not ground2 or enemyTooClose or self:Health() >= maxHp * 0.99 then
            self.CurrentlyHealSelf = false
            return
        end

        self:BeforeHumanCanHealSelf()
        self:StopMoving()
        self:RemoveAllGestures()
        VJ.STOPSOUND(self.CurrentIdleSound)

        local anim = self.HealSelf_AnimTbl or ""
        local animT = VJ.AnimDuration(self, anim)
        local rngSnd = mRng(75, 105)
        local halfAnim = animT / 2

        self:PlayAnim("vjseq_" .. anim, true, animT, false)
        self:SetState(VJ_STATE_ONLY_ANIMATION_CONSTANT, animT)

        timer.Simple(halfAnim, function()
            if not IsValid(self) then return end
            if not moving2 and ground2 then
                local healAmount = self.Medic_HealAmount or 30
                local chance = self.SelfHeal_FailChance or 15
                if mRng(1, chance) == 1 and self.SelfHeal_Fail then
                    healAmount = maxHp * 0.25
                end
                local newHealth = math.Clamp(self:Health() + healAmount, 0, maxHp)
                self:SetHealth(newHealth)
                self:OnMedicBehavior("OnHeal")
                VJ.EmitSound(self, "items/smallmedkit1.wav", rngSnd, rngSnd)
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

    viewDotThreshold = viewDotThreshold or 0.7 -- ~45°

    local eneEyePos
    if ene.IsPlayer and ene:IsPlayer() then
        eneEyePos = ene:EyePos()
    else
        eneEyePos = (ene.EyePos and ene:EyePos()) or 
                    (ene.GetPos and (ene:GetPos() + (ene.OBBCenter and ene:OBBCenter() or Vector(0,0,48)))) or 
                    ene:GetPos()
    end

    local eneForward = (ene.IsPlayer and ene:IsPlayer()) and (ene:EyeAngles():Forward()) or 
                       ((ene.GetForward and ene:GetForward()) or Vector(0,0,1))

    local myEyePos = (self.EyePos and self:EyePos()) or 
                     (self.GetPos and (self:GetPos() + (self.OBBCenter and self:OBBCenter() or Vector(0,0,36)))) or 
                     self:GetPos()

    local toSelf = (myEyePos - eneEyePos)
    if toSelf:IsZero() then
        toSelf = (self:GetPos() - eneEyePos)
    end
    toSelf:Normalize()

    local viewDot = eneForward:Dot(toSelf)
    local enemyLookingAtSelf = (viewDot >= viewDotThreshold)

    if self.Debug_InEneLOS then
        print(("[DEBUG] viewDot=%.3f | threshold=%.2f | enemyLooking=%s"):format(viewDot, viewDotThreshold, tostring(enemyLookingAtSelf)))
    end

    return enemyLookingAtSelf
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HumanEvadeAbility()
    local conv = GetConVar("vj_stalker_dodging"):GetInt()
    if not self.AllowedToCombatEvade or conv ~= 1 or not IsValid(self) or self.VJ_IsBeingControlled then 
        return false 
    end 

    local minEneDist = self.Dodge_EneMin_Dist or 700
    local maxEneDist = self.Dodge_EneMax_Dist or 6000 
    local busy = self:IsBusy() or self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK
    local ene = self:GetEnemy()
    local right, forward, up = self:GetRight(), self:GetForward(), self:GetUp()
    local rollFrwdMax = self.Dodge_RollF_MxDist or 1250
    local rngSnd = mRng(85, 105)
    

    if busy or self.IsGuard or self:Health() < (self:GetMaxHealth() * mRand(0.2,0.33)) or not IsValid(ene) or self.CurrentlyLeaning then
        return false
    end
    
    if not self:InEneLineOfSight(enemy, 0.7) then
        if self.Debug_InEneLOS then print("Enemy is looking at me! Cancelling dodge.") end
            return false
        end
     

    local distToEnemy = self:GetPos():Distance(ene:GetPos())
    if distToEnemy <= minEneDist or distToEnemy >= maxEneDist then return false end

    local pos = self:GetPos() + self:OBBCenter()
    local inCover = self:DoCoverTrace(pos, eneEyePos, false, {SetLastHiddenTime = true})
    if inCover then return false end

    if IsValid(ene) and self:Visible(ene) and not self.Flinching and self.WeaponAttackState == VJ.WEP_ATTACK_STATE_FIRE_STAND and CurTime() > self.Dodge_NextT and not self:IsMoving() and self:IsOnGround() and not self.IsHumanDodging and not self.IsEvadingDngEnt and not busy then
        self:StopAttacks(true)
        self.IsHumanDodging = true
        self.Dodge_NextT = CurTime() + mRand(5, 35)

        local DodgeDirection2 = self.HasCombatRollDodge and mRng(1, 3) or mRng(4, 7)
        print("Dodge type chosen: " .. DodgeDirection2 .. " | HasCombatRollDodge: " .. tostring(self.HasCombatRollDodge))

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
            dodgeAnimDuration = VJ.AnimDuration(self, DodgeAnim) or 2

            self:PlayAnim("vjseq_" .. DodgeAnim, true, dodgeAnimDuration, false)
            self:SetVelocity(DodgeVel)
            VJ.EmitSound(self, self.SoundTbl_SNPCRoll, rngSnd, rngSnd)
        else
            self.IsHumanDodging = false
            self.Dodge_NextT = CurTime() 
            return
        end

        timer.Simple(dodgeAnimDuration + 0.1, function()
            if IsValid(self) then
                self.IsHumanDodging = false
            end
        end)
    end
end


function ENT:HumanEvadeDangerousEntities()
    if GetConVar("vj_stalker_passively_dodge_incom_danger"):GetInt()  ~= 1 or self.VJ_IsBeingControlled or not IsValid(self) then 
        return false 
    end 

    if not self.CanAvoidIncomingDanger or self.IsHumanDodging or self.IsCurrentlyPlayingBurnAnim or self:IsBusy() or self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK then
        return
    end

    local dodgeEntities = {
        "obj_vj_grenade_rifle", "obj_gonome_electric_bolt", "obj_vj_corrosive_proj", 
        "prop_combine_ball", "grenade_ar2", "rpg_missile", "apc_missile", 
        "grenade_helicopter", "obj_vj_gonome_spit", "obj_vj_flesh_projectile_human", 
        "obj_vj_floater_projectile_human", "obj_vj_floater_projectile_nest", 
        "obj_vj_humanimal_spit", "obj_vj_humanimal_rock_debri", "obj_vj_humanimal_flesh_projectile",
        "obj_vj_rocket", "obj_vj_combineball", "obj_vj_crossbowbolt", "crossbow_bolt"
    }

    local dodgeRange = mRng(825, 1245)
    local requiresVis = GetConVar("vj_stalker_dent_dodge_requires_visibility"):GetInt()  == 1

    local function IsInFieldOfView(ent)
        local myPos = self:GetPos()
        local myForward = self:GetForward()
        local targetPos = ent:GetPos()
        local dirToTarget = (targetPos - myPos):GetNormalized()
        local dotProduct = myForward:Dot(dirToTarget)
        
        local fovThreshold = -0.5         
        return dotProduct > fovThreshold
    end

    if CurTime() > self.NextEvDngEntT and self:IsOnGround() then
        for _, enemyTarget in pairs(ents.FindInSphere(self:GetPos() + self:OBBCenter(), dodgeRange)) do
            if table.HasValue(dodgeEntities, enemyTarget:GetClass()) then
                
                if requiresVis then
                    if not self:Visible(enemyTarget) or not IsInFieldOfView(enemyTarget) then
                        continue 
                    end
                end

                local dodgeChance = mRng(1, 3)
                self.IsEvadingDngEnt = true
                self:StopAttacks(true)

                if dodgeChance == 3 then
                    local leftDir = -self:GetRight()
                    local rightDir = self:GetRight()
                    local leftClear, rightClear = true, true

                    local trLeft = util.TraceHull({
                        start = self:GetPos(),
                        endpos = self:GetPos() + leftDir * mRng(350, 500),
                        mins = self:OBBMins(),
                        maxs = self:OBBMaxs(),
                        filter = self
                    })

                    local trRight = util.TraceHull({
                        start = self:GetPos(),
                        endpos = self:GetPos() + rightDir * mRng(350, 500),
                        mins = self:OBBMins(),
                        maxs = self:OBBMaxs(),
                        filter = self
                    })

                    if trLeft.Hit then leftClear = false end
                    if trRight.Hit then rightClear = false end

                    local rollDirection = nil
                    if leftClear and not rightClear then
                        rollDirection = "Left"
                    elseif rightClear and not leftClear then
                        rollDirection = "Right"
                    elseif leftClear and rightClear then
                        rollDirection = (mRng(1, 2) == 1) and "Left" or "Right"
                    end

                    if rollDirection then
                        local dodgeAnim = (rollDirection == "Left") and "Roll_Left" or "Roll_Right"
                        VJ.EmitSound(self, self.SoundTbl_SNPCRoll)
                        self:PlayAnim("vjseq_" .. dodgeAnim, true, VJ.AnimDuration(self, dodgeAnim), false)

                        local dodgeVelocity = (rollDirection == "Left") 
                            and (self:GetRight() * mRand(-900, -1200)) + self:GetUp() * mRand(60, 100) 
                            or (self:GetRight() * mRand(900, 1200)) + self:GetUp() * mRand(60, 100)

                        self:SetVelocity(dodgeVelocity)

                        local dodgeAnimDurationT = self:SequenceDuration(self:LookupSequence(dodgeAnim))
                        self.NextEvDngEntT = CurTime() + mRand(1.5, 5.25)

                        timer.Simple(dodgeAnimDurationT + 0.1, function()
                            if IsValid(self) then
                                self.IsEvadingDngEnt = false
                            end
                        end)
                    else
                        self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH", function(x)
                            x.CanShootWhenMoving = true
                            x.TurnData = {Type = VJ.FACE_ENEMY}
                        end)
                        self.NextEvDngEntT = CurTime() + mRand(2, 4)
                        self.IsEvadingDngEnt = false
                    end
                end
            end
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DisableRHealthRegen()
    if not IsValid(self) then return false end
    local def = self.HealthRegenParams.Enabled
    if self:IsOnFire() or self.IsCurrentlyIncapacitated then
        self.HealthRegenParams.Enabled  = false 
    else
        self.HealthRegenParams.Enabled  = def 
    end
end

function ENT:EnableCryForAid()
    if IsValid(self) and self.IsCurrentlyIncapacitated then
        self:CryForAidSoundCode()
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilledEnemy(ent, inflictor, wasLast)
    if GetConVar("vj_stalker_taunt"):GetInt() == 0 then return end
    if self.VJ_IsBeingControlled or not self.Taunt_OnKillEne or self:IsBusy("Activities") then return false end

    local enemy = self:GetEnemy()
    local tauntChance = self.Taunt_OnKillEneChance
    local gestureAnim = VJ.PICK({"g_pumpleft_rpgdown", "g_pumpleft_rpgright"})
    local sequenceAnim = VJ.PICK({"cheer1", "cheer2", "wave_smg1"})
    local delay = mRand(0.25, 0.55)

    local canSeeEnemy = IsValid(enemy) and self:Visible(enemy)
    local hasEnemyWeapon = IsValid(enemy) and IsValid(enemy:GetActiveWeapon())
    local distToEnemy = (IsValid(enemy) and self:GetPos():Distance(enemy:GetPos())) or 2500

    if IsValid(enemy) then
        if canSeeEnemy and hasEnemyWeapon then return end
        if not canSeeEnemy and distToEnemy >= 1500 then return end
        if distToEnemy < 1250  then return end
    end

    local function ExecuteTaunt(animType, anim, isSequence)
        if not IsValid(self) or self:IsBusy() then return end
        self:RemoveAllGestures()
        if isSequence then
            self:PlayAnim("vjseq_" .. anim, true, VJ.AnimDuration(self, anim), false)
            print("Seq-taunt")
        else
            self:PlayAnim("vjges_" .. anim)
            print("Ges-taunt")
        end
    end

    -- Gesture Taunt
    timer.Simple(delay, function()
        if IsValid(self) and not self:IsBusy() and mRng(1, tauntChance) == 1 then
            ExecuteTaunt("gesture", gestureAnim, false)
        end
    end)

    -- Sequence Taunt
    timer.Simple(delay, function()
        if IsValid(self) and wasLast and not self:IsBusy() and mRng(1, tauntChance ) == 1 then
            ExecuteTaunt("sequence", sequenceAnim, true, VJ.AnimDuration(self, sequenceAnim))
        end
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CryForAidSoundCode(CustomTbl)
	if not self.HasSounds or not self.HasCryForAidSounds then return end
	if CurTime() > self.NextCryForAidSoundT then
		local randsound = mRng(1, self.CallForCryForAidSoundChance)
		local soundtbl = self.SoundTbl_CryForAid
		if CustomTbl != nil and #CustomTbl != 0 then soundtbl = CustomTbl end

		if randsound == 1 then
			local pickedSound = VJ.PICK(soundtbl)
			if pickedSound then

				VJ.STOPSOUND(self.CurrentIdleSound)
				self.NextIdleSoundT_Reg = CurTime() + mRand(1, 3) -- self.IdleSoundBlockTime 

				self.CurrentHasCryForAidSound = VJ.CreateSound(self, pickedSound, self.CryForAidSoundLevel, self:GetSoundPitch(self.CryForAidSoundPitch1, self.CryForAidSoundPitch2))

				local dur = SoundDuration(pickedSound)
				if dur and dur > 0 then
					self.NextCryForAidSoundT = CurTime() + dur + mRand(self.NextSoundTime_CryForAid1, self.NextSoundTime_CryForAid2)
				else
					self.NextCryForAidSoundT = CurTime() + mRand(self.NextSoundTime_CryForAid1, self.NextSoundTime_CryForAid2)
				end
			end
		else
			self.NextCryForAidSoundT = CurTime() + mRand(self.NextSoundTime_CryForAid1, self.NextSoundTime_CryForAid2)
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

    if self.VJ_IsBeingControlled or self.IsGuard or (self.NextDoAnyAttackT + 2) > CurTime() or not IsValid(self) then
        return
    end
    
    local isAlertedOrHasEnemy = IsValid(self:GetEnemy())
    local panicChance
    if isAlertedOrHasEnemy then
        panicChance = 6
        print("Alert/Combat panic chance: 1 in 6")
    else
        panicChance = 3
        print("Idle panic chance: 1 in 3")
    end
    
    if mRng(1, panicChance) == 1 and not self.IsPanicked and CurTime() > self.PanicCooldownT and self.Flee_OnAllyDeath then
        print("Panic triggered! (Chance was 1 in " .. panicChance .. ")")
        self.IsPanicked = true
        self:StartFlee(isAlertedOrHasEnemy)
        self:PlaySoundSystem("CallForHelp")
        self.PanicCooldownT = CurTime() + mRand(5, 15)
    else
        print("Panic not triggered. (Chance was 1 in " .. panicChance .. ")")
    end
end

function ENT:StartFlee(inCombat)
    if self.IsPanicked and not self:IsBusy("Activities") and not self.VJ_IsBeingControlled then
        self.IsPanicked = false
        self:ClearSchedule()
        timer.Simple(0, function()
            if IsValid(self) then 
                if inCombat then
                    self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH", function(x)
                        x.DisableChasingEnemy = true
                        x.RunCode_OnFail = function()
                            self.NextDoAnyAttackT = 0
                        end
                    end)
                else
                    local moveCheck = VJ.PICK(VJ.TraceDirections(self, "Quick", mRand(250, 925), true, false, 8, true))
                    if moveCheck then
                        self:StopMoving()
                        self:SetLastPosition(moveCheck)
                        self:SCHEDULE_GOTO_POSITION("TASK_RUN_PATH", function(x)
                            x.DisableChasingEnemy = true
                            x.RunCode_OnFail = function()
                                self.NextDoAnyAttackT = 0
                            end
                        end)
                    end
                end
                
                self.NextDoAnyAttackT = CurTime() + mRand(1, 2.5)
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

ENT.NextSoundTime_Breath = VJ.SET(6, 12) 

ENT.OnFirePain = {"st_brutal_deaths/brutal_scream/rus_screams_fire/scream_157.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/scream_158.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/scream_159.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/scream_160.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/scream_161.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/scream_162.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/scream_163.wav","st_brutal_deaths/brutal_scream/rus_screams_fire/506.wav"}

//General universal sounds
ENT.GoreOrGibSounds = {"wrhf/gibs/fullbodygib-1.wav", "wrhf/gibs/fullbodygib-2.wav", "wrhf/gibs/fullbodygib-3.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"npc/zombie/claw_strike1.wav","npc/zombie/claw_strike2.wav","npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"npc/zombie/claw_miss1.wav","npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_MeleeAttack= {"npc/zombie/claw_strike1.wav","npc/zombie/claw_strike2.wav","npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_SNPCRoll = {"general_sds/evade_roll/roll_2.wav","general_sds/evade_roll/roll_1.mp3"}
ENT.SoundTbl_GibDeath = {"snpc/npc/hgrunt_young/hg_gibdeath01.wav","snpc/npc/hgrunt_young/hg_gibdeath02.wav","snpc/npc/hgrunt_young/hg_gibdeath03.wav","snpc/npc/hgrunt_young/hg_gibdeath04.wav","snpc/npc/hgrunt_young/hg_gibdeath05.wav","snpc/npc/hgrunt_young/hg_gibdeath06.wav","snpc/npc/hgrunt_young/hg_gibdeath07.wav","snpc/npc/hgrunt_young/hg_gibdeath08.wav","snpc/npc/hgrunt_young/hg_gibdeath09.wav","snpc/npc/hgrunt_young/hg_gibdeath10.wav","snpc/npc/hgrunt_young/hg_gibdeath11.wav","snpc/npc/hgrunt/hg_gibdeath01.wav","snpc/npc/hgrunt/hg_gibdeath02.wav","snpc/npc/hgrunt/hg_gibdeath03.wav","snpc/npc/hgrunt/hg_gibdeath04.wav","snpc/npc/hgrunt/hg_gibdeath05.wav","snpc/npc/hgrunt/hg_gibdeath06.wav","snpc/npc/hgrunt/hg_gibdeath07.wav","snpc/npc/hgrunt/hg_gibdeath08.wav","snpc/npc/hgrunt/hg_gibdeath09.wav","snpc/npc/hgrunt/hg_gibdeath10.wav","snpc/npc/hgrunt/hg_gibdeath11.wav"}
ENT.SoundTbl_Impact = {"snpc/wrhf/impact/flesh_impact_bullet1.wav","snpc/wrhf/impact/flesh_impact_bullet2.wav","snpc/wrhf/impact/flesh_impact_bullet3.wav","snpc/wrhf/impact/flesh_impact_bullet4.wav","snpc/wrhf/impact/flesh_impact_bullet5.wav"}
ENT.SoundTbl_ExtraArmorImpacts = {"general_sds/hit_or_impact/helm_hs_impact/headshot_helmet_" .. mRng(1, 16) .. ".wav","general_sds/hit_or_impact/helm_hs_impact/headshot_helmet_style1_" .. mRng(1, 14) .. ".wav","general_sds/hit_or_impact/kevlar_armor/armor_hit.wav","general_sds/hit_or_impact/kevlar_armor/kevlar_hit1.wav","general_sds/hit_or_impact/kevlar_armor/kevlar_hit2.wav"}
ENT.SoundTbl_OnHeadshot = {"general_sds/hit_or_impact/headshot/ex_headshots/headshot_flesh_" .. mRng(1, 38) .. ".wav", "general_sds/hit_or_impact/headshot/headshot_1.wav","general_sds/hit_or_impact/headshot/headshot_2.wav","general_sds/hit_or_impact/headshot/headshot_3.wav","snpc/general_sds/hit_or_impact/headshot/headshot_4.wav","general_sds/hit_or_impact/headshot/headshot_5.wav","general_sds/hit_or_impact/headshot/headshot_6.wav","general_sds/hit_or_impact/headshot/headshot_7.wav","general_sds/hit_or_impact/headshot/headshot_8.wav","general_sds/hit_or_impact/headshot/headshot_9.wav","general_sds/hit_or_impact/headshot/headshot_10.wav","general_sds/hit_or_impact/headshot/headshot_11.wav","general_sds/hit_or_impact/headshot/headshot_12.wav","general_sds/hit_or_impact/headshot/headshot_13.wav","general_sds/hit_or_impact/headshot/headshot_14.wav","general_sds/hit_or_impact/headshot/headshot_15.wav"}
ENT.DrawNewWeaponSound = {"vj_base/weapons/draw_rifle.wav","vj_base/weapons/draw_pistol.wav"}
ENT.WaterSplashSounds = {"player/footsteps/wade1.wav", "player/footsteps/wade2.wav","player/footsteps/wade3.wav", "player/footsteps/wade4.wav","ambient/water/water_splash2.wav"}
ENT.JumpGruntTbl = {"general_sds/jump_land_grunts/jump_01.wav","general_sds/jump_land_grunts/jump_02.wav","general_sds/jump_land_grunts/jump_03.wav","general_sds/jump_land_grunts/jump_04.wav","general_sds/jump_land_grunts/jump_05.wav","general_sds/jump_land_grunts/jump_06.wav"}
ENT.JumpLandGruntTbl = {"general_sds/jump_land_grunts/land_01.wav","general_sds/jump_land_grunts/land_02.wav","general_sds/jump_land_grunts/land_03.wav","general_sds/jump_land_grunts/land_04.wav"}
ENT.EquipmentClanging_Tbl  = {"general_sds/toolbelt_sounds/toolbelt_01.wav","general_sds/toolbelt_sounds/toolbelt_02.wav","general_sds/toolbelt_sounds/toolbelt_03.wav","general_sds/toolbelt_sounds/toolbelt_04.wav","general_sds/toolbelt_sounds/toolbelt_05.wav","general_sds/toolbelt_sounds/toolbelt_06.wav"}
ENT.ClothingRustling_Tbl = {"general_sds/eft_gear_rustling/tac_gear_" .. mRng(1, 40) .. ".ogg"}

ENT.SoundTbl_BackgroundRadioDialogue = {"st_faction_sounds/mil_fac_radio_chat/mil_rnd_radio_1.ogg","st_faction_sounds/mil_fac_radio_chat/mil_rnd_radio_2.ogg","st_faction_sounds/mil_fac_radio_chat/mil_rnd_radio_3.ogg","st_faction_sounds/mil_fac_radio_chat/mil_rnd_radio_4.ogg","st_faction_sounds/mil_fac_radio_chat/mil_rnd_radio_5.ogg","st_faction_sounds/mil_fac_radio_chat/mil_rnd_radio_6.ogg","st_faction_sounds/mil_fac_radio_chat/mil_rnd_radio_7.ogg","st_faction_sounds/mil_fac_radio_chat/mil_rnd_radio_8.ogg","st_faction_sounds/mil_fac_radio_chat/radio1.wav","st_faction_sounds/mil_fac_radio_chat/radio2.wav","st_faction_sounds/mil_fac_radio_chat/radio3.wav","st_faction_sounds/mil_fac_radio_chat/radio4.wav","st_faction_sounds/mil_fac_radio_chat/radio5.wav","st_faction_sounds/mil_fac_radio_chat/radio6.wav","st_faction_sounds/mil_fac_radio_chat/radio7.wav","st_faction_sounds/mil_fac_radio_chat/radio8.wav","st_faction_sounds/mil_fac_radio_chat/radio9.wav"}

//Faction specific dialogue, will improve soon.
ENT.SoundTbl_Investigate = {"st_faction_sounds/stalker_vo/general_base_dialogue/hear_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/hear_9.ogg"}

ENT.SoundTbl_DangerSight = {"general_sds/ext_reactions/hide_" .. mRng(1, 8) .. ".mp3"}

ENT.SoundTbl_MedicReceiveHeal = {"general_sds/ext_reactions/thanks_" .. mRng(1, 6) .. ".mp3","st_faction_sounds/stalker_vo/general_base_dialogue/thanx_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/thanx_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/thanx_3.ogg","general_spetsnaz_snds/gotmedic1.mp3","general_spetsnaz_snds/gotmedic2.mp3","general_spetsnaz_snds/gotmedic3.mp3","general_spetsnaz_snds/gotmedic4.mp3","general_spetsnaz_snds/gotmedic5.mp3","general_spetsnaz_snds/gotmedic6.mp3","general_spetsnaz_snds/gotmedic7.mp3"}

ENT.SoundTbl_MedicBeforeHeal = {"st_faction_sounds/stalker_vo/general_base_dialogue/medkit_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/medkit_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/medkit_3.ogg","general_spetsnaz_snds/health01.wav","general_spetsnaz_snds/health02.wav","general_spetsnaz_snds/health03.wav","general_spetsnaz_snds/health04.wav","general_spetsnaz_snds/health05.wav","general_spetsnaz_snds/heal1.mp3","general_spetsnaz_snds/heal2.mp3","general_spetsnaz_snds/heal3.mp3","general_spetsnaz_snds/heal4.mp3","general_spetsnaz_snds/heal5.mp3","general_spetsnaz_snds/heal6.mp3","general_spetsnaz_snds/heal7.mp3","general_spetsnaz_snds/heal8.mp3","general_spetsnaz_snds/heal9.mp3","general_spetsnaz_snds/heal10.mp3"}

ENT.SoundTbl_Breath = {"st_faction_sounds/stalker_vo/general_base_dialogue/breath_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/breath_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/breath_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/breath_4.ogg"}

ENT.SoundTbl_Idle = {"st_faction_sounds/stalker_vo/general_base_dialogue/idle_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_14.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_15.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_16.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_17.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_18.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_19.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/idle_20.ogg","general_spetsnaz_snds/free1.wav","general_spetsnaz_snds/free2.wav","general_spetsnaz_snds/free3.wav","general_spetsnaz_snds/free4.wav","general_spetsnaz_snds/free5.wav","general_spetsnaz_snds/free6.wav","general_spetsnaz_snds/free7.wav","general_spetsnaz_snds/free8.wav","general_spetsnaz_snds/free9.wav","general_spetsnaz_snds/free10.wav","general_spetsnaz_snds/free11.wav","general_spetsnaz_snds/free12.wav","general_spetsnaz_snds/free13.wav","general_spetsnaz_snds/free14.wav","general_spetsnaz_snds/free15.wav","general_spetsnaz_snds/free16.wav","general_spetsnaz_snds/free17.wav","general_spetsnaz_snds/free18.wav","general_spetsnaz_snds/free19.wav","general_spetsnaz_snds/free20.wav","general_spetsnaz_snds/free21.wav","general_spetsnaz_snds/free22.wav","general_spetsnaz_snds/free23.wav","general_spetsnaz_snds/free24.wav","general_spetsnaz_snds/free25.wav","general_spetsnaz_snds/free26.wav","general_spetsnaz_snds/free27.wav","general_spetsnaz_snds/free28.wav","general_spetsnaz_snds/free29.wav","general_spetsnaz_snds/free30.wav","general_spetsnaz_snds/idledraft1.wav","general_spetsnaz_snds/idledraft2.wav","general_spetsnaz_snds/idledraft3.wav","general_spetsnaz_snds/idledraft4.wav","general_spetsnaz_snds/idledraft5.wav","general_spetsnaz_snds/idleburp.wav","general_spetsnaz_snds/idlewhistle.wav","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_1.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_2.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_3.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_4.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_5.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_6.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_7.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_8.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_9.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_10.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_11.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_12.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_13.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_14.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_15.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_16.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_17.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_18.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_19.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_20.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_21.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_22.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_23.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_24.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_25.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_26.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_27.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_28.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_29.ogg","st_faction_sounds/stalker_vo/mil_specific_dialogue/idle_30.ogg","general_spetsnaz_snds/chat1.mp3","general_spetsnaz_snds/chat2.mp3","general_spetsnaz_snds/chat3.mp3","general_spetsnaz_snds/chat4.mp3","general_spetsnaz_snds/chat5.mp3","general_spetsnaz_snds/chat6.mp3","general_spetsnaz_snds/chat7.mp3","general_spetsnaz_snds/chat8.mp3","general_spetsnaz_snds/chat9.mp3","general_spetsnaz_snds/chat10.mp3","general_spetsnaz_snds/chat11.mp3","general_spetsnaz_snds/chat12.mp3","general_spetsnaz_snds/chat13.mp3","general_spetsnaz_snds/chat14.mp3","general_spetsnaz_snds/chat15.mp3","general_spetsnaz_snds/chat16.mp3","general_spetsnaz_snds/chat17.mp3","general_spetsnaz_snds/chat18.mp3","general_spetsnaz_snds/chat19.mp3"}

ENT.SoundTbl_Alert = {"st_faction_sounds/stalker_vo/general_base_dialogue/detour_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/detour_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/detour_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/detour_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/detour_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/detour_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_6.ogg","general_spetsnaz_snds/alert1.wav","general_spetsnaz_snds/alert2.wav","general_spetsnaz_snds/alert3.wav","general_spetsnaz_snds/alert4.wav","general_spetsnaz_snds/alert5.wav","general_spetsnaz_snds/alert6.wav","general_spetsnaz_snds/alert7.wav","general_spetsnaz_snds/alert8.wav","general_spetsnaz_snds/alert9.wav","general_spetsnaz_snds/alert1.wav","general_spetsnaz_snds/alert2.wav","general_spetsnaz_snds/alert3.wav","general_spetsnaz_snds/alert4.wav","general_spetsnaz_snds/alert5.wav","general_spetsnaz_snds/alert6.wav","general_spetsnaz_snds/alert7.wav","general_spetsnaz_snds/alert8.wav","general_spetsnaz_snds/alert9.wav","general_spetsnaz_snds/alert10.wav","general_spetsnaz_snds/alert11.wav","st_faction_sounds/stalker_vo/general_base_dialogue/panic_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/panic_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/panic_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/panic_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/panic_5.ogg","badcompany_squad/VO_RU_Grunt_ContactCall_01A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_ContactCall_02A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_ContactCall_03A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_ContactCall_04A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_ContactCall_05A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_ContactCall_06A_DimitryRozental.ogg","badcompany_squad/VO_RU_Grunt_ContactCall_07A_DimitryRozental.ogg"}

ENT.SoundTbl_CombatIdle = {"st_faction_sounds/stalker_vo/general_base_dialogue/attack_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_14.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_7.ogg","general_spetsnaz_snds/attack1.wav","general_spetsnaz_snds/attack2.wav","general_spetsnaz_snds/attack3.wav","general_spetsnaz_snds/attack4.wav","general_spetsnaz_snds/attack5.wav","general_spetsnaz_snds/attack6.wav","general_spetsnaz_snds/attack7.wav","general_spetsnaz_snds/attack8.wav","general_spetsnaz_snds/attack9.wav","general_spetsnaz_snds/attack10.wav","general_spetsnaz_snds/attack11.wav","general_spetsnaz_snds/attack12.wav","general_spetsnaz_snds/attack13.wav","general_spetsnaz_snds/attack14.wav","general_spetsnaz_snds/attack15.wav","general_spetsnaz_snds/attack16.wav","general_spetsnaz_snds/attack1.wav","general_spetsnaz_snds/attack2.wav","general_spetsnaz_snds/attack3.wav","general_spetsnaz_snds/attack4.wav","general_spetsnaz_snds/attack5.wav","general_spetsnaz_snds/attack6.wav","general_spetsnaz_snds/attack7.wav","russian/attack1.wav","russian/attack2.wav","russian/attack3.wav","russian/attack4.wav","russian/attack5.wav","russian/attack6.wav","russian/attack7.wav","russian/attack8.wav","russian/attack9.wav","russian/attack10.wav","russian/attack11.wav","russian/attack12.wav","general_spetsnaz_snds/combat1.mp3","general_spetsnaz_snds/combat2.mp3","general_spetsnaz_snds/combat3.mp3","general_spetsnaz_snds/combat4.mp3","general_spetsnaz_snds/combat5.mp3","general_spetsnaz_snds/combat6.mp3","general_spetsnaz_snds/combat7.mp3","general_spetsnaz_snds/combat8.mp3","general_spetsnaz_snds/combat9.mp3","general_spetsnaz_snds/combat10.mp3","general_spetsnaz_snds/combat11.mp3","general_spetsnaz_snds/combat12.mp3","general_spetsnaz_snds/combat13.mp3","general_spetsnaz_snds/combat14.mp3","general_spetsnaz_snds/combat15.mp3","general_spetsnaz_snds/combat16.mp3","general_spetsnaz_snds/combat17.mp3","general_spetsnaz_snds/combat18.mp3","general_spetsnaz_snds/combat19.mp3","general_spetsnaz_snds/combat20.mp3"}

ENT.SoundTbl_Suppressing = {"general_spetsnaz_snds/suppressing1.wav","general_spetsnaz_snds/suppressing2.wav","general_spetsnaz_snds/suppressing3.wav","general_spetsnaz_snds/suppressing4.wav","general_spetsnaz_snds/suppressing5.wav","general_spetsnaz_snds/suppressing6.wav","general_spetsnaz_snds/suppressing7.wav","general_spetsnaz_snds/suppressing8.wav","general_spetsnaz_snds/suppressing9.wav","general_spetsnaz_snds/suppressing10.wav","general_spetsnaz_snds/suppressing11.wav","general_spetsnaz_snds/suppressing12.wav","general_spetsnaz_snds/suppressing1.wav","general_spetsnaz_snds/suppressing2.wav","general_spetsnaz_snds/suppressing3.wav","general_spetsnaz_snds/suppressing4.wav","general_spetsnaz_snds/suppressing5.wav","general_spetsnaz_snds/suppressing6.wav","general_spetsnaz_snds/suppressing7.wav","general_spetsnaz_snds/suppressing8.wav","general_spetsnaz_snds/suppressing9.wav","general_spetsnaz_snds/suppressing10.wav","general_spetsnaz_snds/suppressing11.wav","general_spetsnaz_snds/suppressing12.wav","general_spetsnaz_snds/suppressing13.wav","general_spetsnaz_snds/suppressing14.wav","general_spetsnaz_snds/suppressing15.wav","general_spetsnaz_snds/suppressing16.wav","general_spetsnaz_snds/suppressing17.wav","general_spetsnaz_snds/suppressing18.wav","general_spetsnaz_snds/suppressing19.wav","general_spetsnaz_snds/suppressing20.wav"}

ENT.SoundTbl_WeaponReload = {"general_spetsnaz_snds/reloading1.wav","general_spetsnaz_snds/reloading2.wav","general_spetsnaz_snds/reloading3.wav","general_spetsnaz_snds/reloading4.wav","general_spetsnaz_snds/reloading5.wav","general_spetsnaz_snds/reloading6.wav","general_spetsnaz_snds/reloading7.wav","general_spetsnaz_snds/reloading8.wav","general_spetsnaz_snds/reloading9.wav","general_spetsnaz_snds/reloading10.wav","general_spetsnaz_snds/reloading11.wav","general_spetsnaz_snds/reloading12.wav","general_spetsnaz_snds/reloading13.wav","general_spetsnaz_snds/reloading14.wav","general_spetsnaz_snds/reloading15.wav","general_spetsnaz_snds/reloading16.wav","general_spetsnaz_snds/reloading17.wav","general_spetsnaz_snds/reloading18.wav","general_spetsnaz_snds/reloading19.wav","general_spetsnaz_snds/reloading20.wav","general_spetsnaz_snds/reloading21.wav","general_spetsnaz_snds/reloading22.wav","general_spetsnaz_snds/reloading23.wav","general_spetsnaz_snds/reloading24.wav","general_spetsnaz_snds/reloading25.wav","general_spetsnaz_snds/reloading26.wav","general_spetsnaz_snds/reloading27.wav","general_spetsnaz_snds/reloading28wav","general_spetsnaz_snds/reloading29.wav","general_spetsnaz_snds/reloading1.wav","general_spetsnaz_snds/reloading2.wav","general_spetsnaz_snds/reloading3.wav","general_spetsnaz_snds/reloading4.wav","general_spetsnaz_snds/reloading5.wav","general_spetsnaz_snds/reloading6.wav","general_spetsnaz_snds/reloading7.wav","general_spetsnaz_snds/reloading8.wav"}

ENT.SoundTbl_GrenadeAttack = {"general_spetsnaz_snds/fragout1.wav","general_spetsnaz_snds/fragout2.wav","general_spetsnaz_snds/fragout3.wav","general_spetsnaz_snds/fragout4.wav","general_spetsnaz_snds/fragout5.wav","general_spetsnaz_snds/fragout6.wav","general_spetsnaz_snds/fragout7.wav","general_spetsnaz_snds/fragout8.wav","general_spetsnaz_snds/fragout9.wav","general_spetsnaz_snds/fragout10.wav","general_spetsnaz_snds/fragout11.wav","general_spetsnaz_snds/fragout12.wav","general_spetsnaz_snds/fragout13.wav","general_spetsnaz_snds/fragout14.wav","general_spetsnaz_snds/fragout1.wav","general_spetsnaz_snds/fragout2.wav","general_spetsnaz_snds/fragout3.wav","general_spetsnaz_snds/fragout4.wav","general_spetsnaz_snds/fragout5.wav","general_spetsnaz_snds/fragout6.wav","general_spetsnaz_snds/fragout7.wav","general_spetsnaz_snds/fragout8.wav","general_spetsnaz_snds/fragout9.wav","general_spetsnaz_snds/fragout10.wav","general_spetsnaz_snds/fragout11.wav","general_spetsnaz_snds/fragout12.wav","general_spetsnaz_snds/fragout13.wav","general_spetsnaz_snds/fragout14.wav","general_spetsnaz_snds/fragout15.wav","general_spetsnaz_snds/fragout16.wav","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/grenade_ready7_.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/ready_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/ready_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/ready_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/ready_4.ogg","badcompany_squad/VO_RU_SL_FragOut_01A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_FragOut_02A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_FragOut_03A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_FragOut_04A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_FragOut_05A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_FragOut_06A_AleksandrJuriev.ogg","badcompany_squad/VO_RU_SL_FragOut_07A_AleksandrJuriev.ogg"}

ENT.SoundTbl_OnGrenadeSight = {"general_spetsnaz_snds/grenade1.wav","general_spetsnaz_snds/grenade2.wav","general_spetsnaz_snds/grenade3.wav","general_spetsnaz_snds/grenade4.wav","general_spetsnaz_snds/grenade5.wav","general_spetsnaz_snds/grenade6.wav","general_spetsnaz_snds/grenade7.wav","general_spetsnaz_snds/grenade8.wav","general_spetsnaz_snds/grenade9.wav","general_spetsnaz_snds/grenade10.wav","general_spetsnaz_snds/grenade11.wav","general_spetsnaz_snds/grenade12.wav","general_spetsnaz_snds/grenade13.wav","general_spetsnaz_snds/grenade14.wav","general_spetsnaz_snds/grenade15.wav","general_spetsnaz_snds/grenade16.wav","general_spetsnaz_snds/grenade17.wav","general_spetsnaz_snds/grenade18.wav","general_spetsnaz_snds/grenade19.wav","general_spetsnaz_snds/grenade20.wav","general_spetsnaz_snds/grenade21.wav","general_spetsnaz_snds/grenade22.wav","general_spetsnaz_snds/grenade23.wav","general_spetsnaz_snds/grenade24.wav","general_spetsnaz_snds/grenade25.wav","general_spetsnaz_snds/grenade26.wav","general_spetsnaz_snds/grenade27.wav","general_spetsnaz_snds/grenade28.wav","general_spetsnaz_snds/grenade29.wav","general_spetsnaz_snds/grenade30.wav","general_spetsnaz_snds/grenade31.wav","general_spetsnaz_snds/grenade32.wav","general_spetsnaz_snds/grenade33.wav","general_spetsnaz_snds/grenade34.wav"}

ENT.SoundTbl_OnKilledEnemy = {"st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/enemy_down_8.ogg","general_spetsnaz_snds/kill1.wav","general_spetsnaz_snds/kill2.wav","general_spetsnaz_snds/kill3.wav","general_spetsnaz_snds/kill4.wav","general_spetsnaz_snds/kill5.wav","general_spetsnaz_snds/kill6.wav","general_spetsnaz_snds/kill7.wav","general_spetsnaz_snds/kill8.wav","general_spetsnaz_snds/kill9.wav","general_spetsnaz_snds/kill10.wav","general_spetsnaz_snds/kill1.wav","general_spetsnaz_snds/kill2.wav","general_spetsnaz_snds/kill3.wav","general_spetsnaz_snds/kill4.wav","general_spetsnaz_snds/kill5.wav","general_spetsnaz_snds/kill6.wav","general_spetsnaz_snds/kill7.wav","general_spetsnaz_snds/kill8.wav","general_spetsnaz_snds/kill9.wav","general_spetsnaz_snds/kill10.wav","st_faction_sounds/stalker_vo/general_base_dialogue/dead_enemy_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/dead_enemy_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/dead_enemy_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/dead_enemy_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/dead_enemy_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/dead_enemy_6.ogg"}

ENT.SoundTbl_AllyDeath = {"general_spetsnaz_snds/casualty1.wav","general_spetsnaz_snds/casualty2.wav","general_spetsnaz_snds/casualty3.wav","general_spetsnaz_snds/casualty4.wav","general_spetsnaz_snds/casualty5.wav","general_spetsnaz_snds/casualty6.wav","general_spetsnaz_snds/casualty7.wav","general_spetsnaz_snds/casualty8.wav","general_spetsnaz_snds/casualty9.wav","general_spetsnaz_snds/casualty10.wav","general_spetsnaz_snds/casualty11.wav","general_spetsnaz_snds/casualty12.wav","general_spetsnaz_snds/casualty13.wav","general_spetsnaz_snds/casualty14.wav","general_spetsnaz_snds/casualty15.wav","general_spetsnaz_snds/casualty16.wav","general_spetsnaz_snds/casualty17.wav","general_spetsnaz_snds/casualty18.wav","general_spetsnaz_snds/casualty19.wav","general_spetsnaz_snds/casualty20.wav","general_spetsnaz_snds/casualty21.wav","general_spetsnaz_snds/casualty22.wav","general_spetsnaz_snds/casualty23.wav","general_spetsnaz_snds/casualty24.wav","general_spetsnaz_snds/casualty25.wav","general_spetsnaz_snds/casualty2.wav","general_spetsnaz_snds/casualty27.wav","general_spetsnaz_snds/casualty28.wav","general_spetsnaz_snds/casualty29.wav","general_spetsnaz_snds/casualty30.wav","general_spetsnaz_snds/casualty31.wav","general_spetsnaz_snds/casualty32.wav","general_spetsnaz_snds/casualty33.wav","general_spetsnaz_snds/casualty34.wav"}

ENT.SoundTbl_CombatIdle = {"st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_14.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/fire_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/fire_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/fire_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/fire_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/fire_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/backup_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_1stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_2stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_3stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_4stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_5stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_6stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_1stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_2stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_3stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_4stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/attack_one_5stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_7.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_14.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_15.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_1stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_2stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_3stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_4stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_5stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_6stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_7stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_8stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_9stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_10stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_11stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_12stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_13stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_14stalker.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/script_attack_15stalker.ogg"}

ENT.SoundTbl_Suppressing = {"st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_8.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_9.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_10.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_11.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_12.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_13.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_14.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_1.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_2.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_3.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_4.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_5.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_6.ogg","st_faction_sounds/stalker_vo/general_base_dialogue/cover_fire_7.ogg","badcompany_squad/pursuing1.wav","badcompany_squad/pursuing2.wav","badcompany_squad/pursuing3.wav","badcompany_squad/pursuing4.wav","badcompany_squad/pursuing5.wav","badcompany_squad/pursuing6.wav"}

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
function ENT:OnFootstepSound()
    local equipmentRustle = VJ.PICK(self.EquipmentClanging_Tbl)
    local clothingRustle = VJ.PICK(self.ClothingRustling_Tbl)
    local rngPS = mRng(75, 105)
    local chance = 3
    if not self:IsOnGround() or not self.HasSounds or not self.HasFootstepSounds then return end

    if mRng(1, chance) == 1 and self.HasEquipmentRustle then 
        VJ.EmitSound(self, equipmentRustle, rngP, rngP)
    end

    if mRng(1, chance) == 1 and self.HasClothingRustle then 
        VJ.EmitSound(self, clothingRustle, rngP, rngP)
    end


    local tr = util.TraceLine({
        start = self:GetPos(),
        endpos = self:GetPos() + Vector(0,0, -150),
        filter = {self}
    })

    if tr.Hit and self.FootSteps[tr.MatType] then
        VJ.EmitSound(self,VJ.PICK(self.FootSteps[tr.MatType]), rngP ,rngP)
    end

    if self:WaterLevel() > 0 and self:WaterLevel() < 3 then
        VJ.EmitSound(self,"player/footsteps/wade" .. mRng(1, 8) .. ".wav", rngP, rngP)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnWeaponReload()
    local conv = GetConVar("vj_stalker_reposition_while_reloading"):GetInt()
    if self.VJ_IsBeingControlled or not IsValid(self) or conv ~= 1 or self.IsGuard then return end 
    local ene = self:GetEnemy()
    local traceDist = mRand(550, 1250)
    local reposChance = self.RepositionWhileReloadChance or 3 
    if not self.CanRepositionWhileReloading or not IsValid(ene) or (mRng(1,3) == 1 and self.Weapon_FindCoverOnReload) or self:DoCoverTrace(self:GetPos() + self:OBBCenter(), ene:EyePos(), false, {SetLastHiddenTime=true}) and not self:IsBusy("Activities") then
        return
    end

    local reloadAnim = VJ.PICK(self.AnimationTranslations[ACT_GESTURE_RELOAD])
    if reloadAnim then
        local gestureReloadAnim = reloadAnim
        self.AnimTbl_WeaponReload = {gestureReloadAnim}
    end
    
    if mRng(1, reposChance)  == 1 then
        timer.Simple(0, function()
            if not IsValid(self) then return end
            if mRng(1, 2) == 1 then 
                self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH", function(x)
                    x:EngTask("TASK_FACE_ENEMY", 0)
                    x.CanShootWhenMoving = true
                    x.TurnData = {Type = VJ.FACE_ENEMY}
                end)
            else 
                local moveCheck = VJ.PICK(VJ.TraceDirections(self, "Quick", traceDist, true, false, 8, true))
                if moveCheck then
                    self:SetLastPosition(moveCheck)
                    self:SCHEDULE_GOTO_POSITION(VJ.PICK({"TASK_RUN_PATH", "TASK_WALK_PATH"}), function(x)
                        x:EngTask("TASK_FACE_ENEMY", 0)
                        x.CanShootWhenMoving = true
                        x.TurnData = {Type = VJ.FACE_ENEMY}
                    end)
                end
            end 
        end)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetAnimationTranslations(wepHoldType)
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
function ENT:Spawn_Gibs()
    local maxSmallG = self.MaxSmallGibs
    local maxLargeG = self.MaxLargeGibs
    if self.HasGibOnDeathEffects then
        local gibOrigin = self:GetPos() + self:OBBCenter()
        local randOffset = Vector(mRand(-25, 25), mRand(-25, 25), mRand(5, 35))
        local randAng = Angle(mRand(-25, 25), mRand(-25, 25), mRand(-25, 25))
        local rngSnd =mRng(75, 105)
        local gibSounds = VJ.PICK(self.GoreOrGibSounds)
        local pcfx = self.Gib_ParticleTbl or {}
        
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

        VJ.EmitSound(self, gibSounds, rngSnd, rngSnd)
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
    for i = 1,mRng(5, maxSmallG) do gibs[#gibs+1] = "UseHuman_Small" end
    for i = 1,mRng(5, maxLargeG) do gibs[#gibs+1] = "UseHuman_Big" end

    if self.HasExtraGibVariants then
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
        local intestineAmount = mRng(3,8)
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

        self:CreateGibEntity("obj_vj_gib", gibModel, {BloodType = "Red", Pos = gibPos, Ang = gibAng}, function(gibEnt)
            if particlesSpawned < maxParticles and mRng(1, self.Gib_ParticleChance) == 1 and bloodParticle ~= "" then
                ParticleEffectAttach(bloodParticle, PATTACH_POINT_FOLLOW, gibEnt, gibEnt:EntIndex())
                particlesSpawned = particlesSpawned + 1
            end
        end)
    end
end

ENT.HasExtraGibVariants = true -- Allows spawning of bones and other organs when gibbed. 
ENT.MaxSmallGibs = 15 
ENT.MaxLargeGibs = 15 
ENT.Gib_ParticleChance = 3 
ENT.Gib_ParticleTbl = {"blood_impact_red_01","blood_advisor_pierce_spray","blood_impact_red_01_goop","blood_impact_red_01_chunk"}
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
    if GetConVar("vj_stalker_gib"):GetInt()  ~= 1 or not IsValid(self) then return end
    local gibChance = self.ChanceToGib 
    local gibDthConv = GetConVar("vj_stalker_gib_death_sounds"):GetInt() 
    if mRng(1, gibChance) == 1 then

        self.HasDeathSounds = false 
        self.HasDeathRagdoll = false
        self.HasPainSounds = false
        self.HasDeathAnimation = false
        self.GibbedOnDeath = true

        if gibDthConv == 1 then 
            local gibDeathSound = VJ.PICK(self.SoundTbl_GibDeath)
            VJ.EmitSound(self, gibDeathSound, mRng(90, 125), mRng(85, 125))
        end 
        self:Spawn_Gibs()
    end 
 end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
    VJ.STOPSOUND(self.CurrentHasCombineRadioChatterSound)
    VJ.STOPSOUND(self.CurrentHasCryForAidSound)
    VJ.STOPSOUND(self.CoughingSound)
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
ENT.NextSoundTime_Breath = false
ENT.NextSoundTime_Idle = VJ.SET(8, 25)
ENT.NextSoundTime_Investigate = VJ.SET(5, 5)
ENT.NextSoundTime_LostEnemy = VJ.SET(5, 6)
ENT.NextSoundTime_Alert = VJ.SET(2, 3)
ENT.NextSoundTime_Suppressing = VJ.SET(7, 15)
ENT.NextSoundTime_KilledEnemy = VJ.SET(3, 5)
ENT.NextSoundTime_AllyDeath = VJ.SET(3, 5)
-- ====== Sound Level ====== --
-- The proper number are usually range from 0 to 180, though it can go as high as 511
-- More Information: https://developer.valvesoftware.com/wiki/Soundscripts#SoundLevel_Flags
local rngLvl = mRng(75, 100)
ENT.FootstepSoundLevel = rngLvl
ENT.BreathSoundLevel = rngLvl
ENT.IdleSoundLevel = rngLvl
ENT.IdleDialogueSoundLevel = rngLvl -- Controls "self.SoundTbl_IdleDialogue", "self.SoundTbl_IdleDialogueAnswer"
ENT.CombatIdleSoundLevel = rngLvl
ENT.ReceiveOrderSoundLevel = rngLvl
ENT.FollowPlayerSoundLevel = rngLvl -- Controls "self.SoundTbl_FollowPlayer", "self.SoundTbl_UnFollowPlayer"
ENT.YieldToPlayerSoundLevel = rngLvl
ENT.MedicBeforeHealSoundLevel = rngLvl
ENT.MedicOnHealSoundLevel = rngLvl
ENT.MedicReceiveHealSoundLevel = rngLvl
ENT.OnPlayerSightSoundLevel = rngLvl
ENT.InvestigateSoundLevel = rngLvl
ENT.LostEnemySoundLevel = rngLvl
ENT.AlertSoundLevel = rngLvl
ENT.CallForHelpSoundLevel = rngLvl
ENT.BecomeEnemyToPlayerSoundLevel = rngLvl
ENT.BeforeMeleeAttackSoundLevel = rngLvl
ENT.MeleeAttackSoundLevel = rngLvl
ENT.ExtraMeleeAttackSoundLevel = rngLvl
ENT.MeleeAttackMissSoundLevel = rngLvl
ENT.SuppressingSoundLevel = rngLvl
ENT.WeaponReloadSoundLevel = rngLvl
ENT.GrenadeAttackSoundLevel = rngLvl
ENT.DangerSightSoundLevel = rngLvl -- Controls "self.SoundTbl_DangerSight", "self.SoundTbl_GrenadeSight"
ENT.KilledEnemySoundLevel = rngLvl
ENT.AllyDeathSoundLevel = rngLvl
ENT.PainSoundLevel = rngLvl
ENT.ImpactSoundLevel = rngLvl
ENT.DamageByPlayerSoundLevel = rngLvl
ENT.DeathSoundLevel = rngLvl
-- ====== Sound Pitch ====== --
-- Range: 0 - 255 | Lower pitch < x > Higher pitch
ENT.MainSoundPitch = VJ.SET(75, 115) -- Can be a number or VJ.SET
ENT.MainSoundPitchStatic = true -- Should it decide a number on spawn and use it as the main pitch?
-- false = Use main pitch | number = Use a specific pitch | VJ.SET = Pick randomly between numbers every time it plays
ENT.FootStepPitch = VJ.SET(70, 105)
ENT.BreathSoundPitch = VJ.SET(65, 105)
ENT.IdleSoundPitch = VJ.SET(75, 105)
ENT.IdleDialogueSoundPitch = VJ.SET(65, 105)
ENT.IdleDialogueAnswerSoundPitch = VJ.SET(76, 105)
ENT.CombatIdleSoundPitch = VJ.SET(75, 105)
ENT.ReceiveOrderSoundPitch = VJ.SET(75, 105)
ENT.FollowPlayerPitch = VJ.SET(85, 105) -- Controls both "self.SoundTbl_FollowPlayer" and "self.SoundTbl_UnFollowPlayer"
ENT.YieldToPlayerSoundPitch = VJ.SET(85, 105)
ENT.MedicBeforeHealSoundPitch = VJ.SET(85, 105)
ENT.MedicOnHealSoundPitch = VJ.SET(75, 100)
ENT.MedicReceiveHealSoundPitch = VJ.SET(75, 105)
ENT.OnPlayerSightSoundPitch = VJ.SET(75, 105)
ENT.InvestigateSoundPitch = VJ.SET(75, 105)
ENT.LostEnemySoundPitch = VJ.SET(86, 105)
ENT.AlertSoundPitch = VJ.SET(86, 105)
ENT.CallForHelpSoundPitch = VJ.SET(75, 105)
ENT.BecomeEnemyToPlayerPitch = VJ.SET(85, 105)
ENT.BeforeMeleeAttackSoundPitch = VJ.SET(85, 105)
ENT.MeleeAttackSoundPitch = VJ.SET(95, 100)
ENT.ExtraMeleeSoundPitch = VJ.SET(80, 100)
ENT.MeleeAttackMissSoundPitch = VJ.SET(90, 100)
ENT.SuppressingPitch = VJ.SET(70, 105)
ENT.WeaponReloadSoundPitch = VJ.SET(70, 105)
ENT.GrenadeAttackSoundPitch = VJ.SET(70, 105)
ENT.OnGrenadeSightSoundPitch = VJ.SET(70, 105)
ENT.DangerSightSoundPitch = VJ.SET(70, 105) -- Controls "self.SoundTbl_DangerSight", "self.SoundTbl_GrenadeSight"
ENT.KilledEnemySoundPitch = VJ.SET(70, 105)
ENT.AllyDeathSoundPitch = VJ.SET(70, 105)
ENT.PainSoundPitch = VJ.SET(70, 105)
ENT.ImpactSoundPitch = VJ.SET(80, 100)
ENT.DamageByPlayerPitch = VJ.SET(70, 100)
ENT.DeathSoundPitch = VJ.SET(75, 105) 