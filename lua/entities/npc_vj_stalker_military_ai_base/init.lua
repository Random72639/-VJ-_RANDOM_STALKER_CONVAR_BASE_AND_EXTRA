include('vj_base/extensions/stalker_npc_ai_brain.lua')
AddCSLuaFile("shared.lua")
include('shared.lua')

//ENT.Model = {"models/military_beril/male_berill1.mdl","models/military_soldier/stalker_referencegrunt2.mdl","models/military_soldier/stalker_referencegrunt.mdl","models/military_grunts/soldierbandana.mdl","models/military_grunts/soldier_bandana_0.mdl","models/military_grunts/soldier_bandana_1.mdl","models/military_grunts/soldier_bandana_2.mdl"}
ENT.StartHealth = 90

ENT.VJ_NPC_Class = {"CLASS_RUSSIAN","CLASS_UKRAINE","CLASS_MILITARY","CLASS_UKRAINIAN_MILITARY"} -- NPCs with the same class with be allied to each other

ENT.HasAccessToRadio = true 
ENT.FriendlyConvar = "vj_stalker_mil_faction_friendly"
ENT.FriendlyNPC_Class = {"CLASS_PLAYER_ALLY","CLASS_UKRAINE_FRIENDLY","CLASS_ECOLOGIST_FRIENDLY","CLASS_MILITARY_FRIENDLY","CLASS_UKRAINIAN_MILITARY_FRIENDLY"}