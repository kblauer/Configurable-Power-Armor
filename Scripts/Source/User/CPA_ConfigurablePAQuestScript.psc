Scriptname CPA_ConfigurablePAQuestScript extends Quest

Actor Property PlayerRef auto

Spell Property AbBobbleheadRepair auto

Perk Property NuclearPhysicist01 auto
Perk Property NuclearPhysicist02 auto
Perk Property PowerArmorPerk auto

ActorValue Property Health auto
ActorValue Property ActionPoints auto
ActorValue Property CarryWeight auto
ActorValue Property JumpHeightMult auto
ActorValue Property SpeedMult auto
ActorValue Property PABatteryDamageRate auto
ActorValue Property PADamageMult auto

GlobalVariable Property CPA_PABatteryDamageGlobal auto
GlobalVariable Property CPA_PADrainPerImpactLand auto
GlobalVariable Property CPA_PACarryWeightGlobal auto
GlobalVariable Property CPA_LastCarryWeightSelection auto
GlobalVariable Property CPA_PADamageMultGlobal auto
GlobalVariable Property CPA_PAJumpHeightGlobal auto
GlobalVariable Property CPA_PASpeedMultGlobal auto
GlobalVariable Property CPA_JetpackDrainInitial auto
GlobalVariable Property CPA_JetpackDrainSustained auto
GlobalVariable Property CPA_JetpackThrustInitial auto
GlobalVariable Property CPA_JetpackThrustSustained auto
GlobalVariable Property CPA_JetpackTimeToSustained auto
GlobalVariable Property CPA_PAHealthGlobal auto
GlobalVariable Property CPA_LastHealthSelection auto
GlobalVariable Property CPA_PAActionPoints auto
GlobalVariable Property CPA_LastActionPointsSelection auto

Event OnInit()
	debug.trace("[CPA_ConfigurablePAQuestScript] OnInit event called")
	RegisterForExternalEvent("OnMCMSettingChange|ConfigurablePowerArmor", "OnMCMSettingChange")
EndEvent

Function OnMCMSettingChange(string modName, string id)
	debug.trace("[CPA_ConfigurablePAQuestScript] OnMCMSettingChange event called for id - " + id)
	if (id == "fCPACoreDrainEvent:Events")
		; First apply nuclear perks
		float newBatteryRate = CPA_PABatteryDamageGlobal.GetValue() as float
		if (PlayerRef.HasPerk(NuclearPhysicist02))
			debug.trace("[CPA_ReducePABatteryEffect] player has NuclearPhysicist02")
			newBatteryRate *= 0.5
		elseif (PlayerRef.HasPerk(NuclearPhysicist01))
			debug.trace("[CPA_ReducePABatteryEffect] player has NuclearPhysicist01")
			newBatteryRate *= 0.75
		endif
		; Then apply repair bobblehead
		if (PlayerRef.HasSpell(AbBobbleheadRepair))
			debug.trace("[CPA_ReducePABatteryEffect] player has repair bobblehead")
			newBatteryRate *= 0.9
		endif
		PlayerRef.SetValue(PABatteryDamageRate, newBatteryRate)
		debug.trace("[CPA_ConfigurablePAQuestScript] Overall core drain changed to - " + newBatteryRate)
	elseif (id == "fCPADrainPerImpactEvent:Events")
		debug.trace("[CPA_ConfigurablePAQuestScript] PA drain per impact changed to - " + CPA_PADrainPerImpactLand.GetValue())
		Game.SetGameSettingFloat("fPowerArmorPowerDrainPerImpactLand", CPA_PADrainPerImpactLand.GetValue())
	elseif (id == "fCPADamageMultEvent:Events")
		debug.trace("[CPA_ConfigurablePAQuestScript] PA Damage mult changed to - " + CPA_PADamageMultGlobal.GetValue())
		PlayerRef.SetValue(PADamageMult, CPA_PADamageMultGlobal.GetValue())
	elseif (id == "fCPAHealthEvent:Events")
		debug.trace("[CPA_ConfigurablePAQuestScript] PA health changed to - " + CPA_PAHealthGlobal.GetValue())
		if (PlayerRef.HasPerk(PowerArmorPerk))
			; Since we mod this value, have to account for calling it several times while in power armor
			float newPAHealth = CPA_PAHealthGlobal.GetValue()
			float diffToMod = newPAHealth - CPA_LastHealthSelection.GetValue()
			float maxHealth = PlayerRef.GetValue(Health) / PlayerRef.GetValuePercentage(Health)
			float valueToSet = diffToMod + maxHealth
			PlayerRef.SetValue(Health, valueToSet)
		endif
		CPA_LastHealthSelection.SetValue(CPA_PAHealthGlobal.GetValue())
	elseif (id == "fCPAAPEvent:Events")
		debug.trace("[CPA_ConfigurablePAQuestScript] PA AP changed to - " + CPA_PAActionPoints.GetValue())
		if (PlayerRef.HasPerk(PowerArmorPerk))
			; Since we mod this value, have to account for calling it several times while in power armor
			float newPAAP = CPA_PAActionPoints.GetValue()
			float diffToMod = newPAAP - CPA_LastActionPointsSelection.GetValue()
			debug.trace("Chaning action points by - " + diffToMod)
			float maxAP = PlayerRef.GetValue(ActionPoints) / PlayerRef.GetValuePercentage(ActionPoints)
			float valueToSet = diffToMod + maxAP
			debug.trace("Setting AP Value to - " + valueToSet)
			float tempBatteryDamageRate = PlayerRef.GetValue(PABatteryDamageRate)
			PlayerRef.SetValue(PABatteryDamageRate, 0.0)
			PlayerRef.SetValue(ActionPoints, valueToSet)
			PlayerRef.SetValue(PABatteryDamageRate, tempBatteryDamageRate)
		endif
		CPA_LastActionPointsSelection.SetValue(CPA_PAActionPoints.GetValue())
	elseif (id == "fCPACarryWeightEvent:Events")
		debug.trace("[CPA_ConfigurablePAQuestScript] PA Carry weight changed to - " + CPA_PACarryWeightGlobal.GetValue())
		if (PlayerRef.HasPerk(PowerArmorPerk))
			; Since we mod this value, have to account for calling it several times while in power armor
			float newCarryWeight = PlayerRef.GetValue(CarryWeight)
			newCarryWeight = (newCarryWeight - CPA_LastCarryWeightSelection.GetValue()) + CPA_PACarryWeightGlobal.GetValue()
			float diffToMod = newCarryWeight - PlayerRef.GetValue(CarryWeight)
			PlayerRef.ModValue(CarryWeight, diffToMod)
		endif
		CPA_LastCarryWeightSelection.SetValue(CPA_PACarryWeightGlobal.GetValue())
	elseif (id == "fCPASpeedMultEvent:Events")
		debug.trace("[CPA_ConfigurablePAQuestScript] PA SpeedMult changed to - " + CPA_PASpeedMultGlobal.GetValue())
		if (PlayerRef.HasPerk(PowerArmorPerk))
			PlayerRef.SetValue(SpeedMult, CPA_PASpeedMultGlobal.GetValue())
		endif
	elseif (id == "fCPAJumpHeightEvent:Events")
		debug.trace("[CPA_ConfigurablePAQuestScript] PA Jump height changed to - " + CPA_PAJumpHeightGlobal.GetValue())
		if (PlayerRef.HasPerk(PowerArmorPerk))
			PlayerRef.SetValue(JumpHeightMult, CPA_PAJumpHeightGlobal.GetValue())
		endif
	elseif (id == "fCPAJetpackDrainInitialEvent:Events")
		debug.trace("[CPA_ConfigurablePAQuestScript] PA initial drain changed to - " + CPA_JetpackDrainInitial.GetValue())
		Game.SetGameSettingFloat("fJetpackDrainInital", CPA_JetpackDrainInitial.GetValue())
	elseif (id == "fCPAJetpackDrainSustained:Events")
		debug.trace("[CPA_ConfigurablePAQuestScript] PA sustained drain changed to - " + CPA_JetpackDrainSustained.GetValue())
		Game.SetGameSettingFloat("fJetpackDrainSustained", CPA_JetpackDrainSustained.GetValue())
	elseif (id == "fCPAJetpackThrustInitialEvent:Events")
		debug.trace("[CPA_ConfigurablePAQuestScript] PA initial thrust changed to - " + CPA_JetpackThrustInitial.GetValue())
		Game.SetGameSettingFloat("fJetpackThrustInitial", CPA_JetpackThrustInitial.GetValue())
	elseif (id == "fCPAJetpackTimeToSustainedEvent:Events")
		debug.trace("[CPA_ConfigurablePAQuestScript] PA jetpack time to sustained changed to - " + CPA_JetpackTimeToSustained.GetValue())
		Game.SetGameSettingFloat("fJetpackTimeToSustained", CPA_JetpackTimeToSustained.GetValue())
	elseif (id == "fCPAJetpackThrustSustainedEvent:Events")
		debug.trace("[CPA_ConfigurablePAQuestScript] PA sustained thrust changed to - " + CPA_JetpackThrustSustained.GetValue())
		Game.SetGameSettingFloat("fJetpackThrustSustained", CPA_JetpackThrustSustained.GetValue())
	endif
EndFunction
