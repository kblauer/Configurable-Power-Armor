Scriptname CPA_PowerArmorPerkEffectScript extends activemagiceffect

Actor Property PlayerRef auto

ActorValue Property Health auto
ActorValue Property ActionPoints auto
ActorValue Property CarryWeight auto
ActorValue Property JumpHeightMult auto
ActorValue Property SpeedMult auto

GlobalVariable Property CPA_PAJumpHeightGlobal auto
GlobalVariable Property CPA_PASpeedMultGlobal auto
GlobalVariable Property CPA_PACarryWeightGlobal auto
GlobalVariable Property CPA_PAHealthGlobal auto
GlobalVariable Property CPA_PAActionPoints auto

GlobalVariable Property CPA_PrevJumpHeightGlobal auto
GlobalVariable Property CPA_PrevSpeedMultGlobal auto
GlobalVariable Property CPA_PrevCarryWeightGlobal auto
GlobalVariable Property CPA_PrevHealthGlobal auto
GlobalVariable Property CPA_PrevActionPoints auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	; Apply user configured values while in power armor after setting prev globals
	; this way any user changes just get re-applied outside of power armor
	if (CPA_PAHealthGlobal.GetValue() > 0)
		debug.trace("[CPA_PowerArmorPerkEffectScript] PA Health increased by - " + CPA_PAHealthGlobal.GetValue())
		float maxHealth = PlayerRef.GetValue(Health) / PlayerRef.GetValuePercentage(Health)
		float healthValToSet = maxHealth + CPA_PAHealthGlobal.GetValue()
		CPA_PrevHealthGlobal.SetValue(maxHealth)
		PlayerRef.SetValue(Health, healthValToSet)
	endif
	
	if (CPA_PAActionPoints.GetValue() > 0)
		debug.trace("[CPA_PowerArmorPerkEffectScript] PA AP increased by - " + CPA_PAActionPoints.GetValue())
		float maxAP = PlayerRef.GetValue(ActionPoints) / PlayerRef.GetValuePercentage(ActionPoints)
		float apValToSet = maxAP + CPA_PAActionPoints.GetValue()
		CPA_PrevActionPoints.SetValue(maxAP)
		PlayerRef.SetValue(ActionPoints, apValToSet)
	endif
	
	if (CPA_PACarryWeightGlobal.GetValue() > 0)
		debug.trace("[CPA_PowerArmorPerkEffectScript] PA Carry weight increased by - " + CPA_PACarryWeightGlobal.GetValue())
		CPA_PrevCarryWeightGlobal.SetValue(PlayerRef.GetValue(CarryWeight))
		PlayerRef.ModValue(CarryWeight, CPA_PACarryWeightGlobal.GetValue())
	endif
	
	debug.trace("[CPA_PowerArmorPerkEffectScript] PA SpeedMult changed to - " + CPA_PASpeedMultGlobal.GetValue())
	CPA_PrevSpeedMultGlobal.SetValue(PlayerRef.GetValue(SpeedMult))
	PlayerRef.SetValue(SpeedMult, CPA_PASpeedMultGlobal.GetValue())
	
	debug.trace("[CPA_PowerArmorPerkEffectScript] PA Jump height changed to - " + CPA_PAJumpHeightGlobal.GetValue())
	CPA_PrevJumpHeightGlobal.SetValue(PlayerRef.GetValue(JumpHeightMult))
	PlayerRef.SetValue(JumpHeightMult, CPA_PAJumpHeightGlobal.GetValue())
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	; Set av's back to their previous values
	if (CPA_PAHealthGlobal.GetValue() > 0)
		debug.trace("[CPA_PowerArmorPerkEffectScript] PA Health reduced by - " + CPA_PAHealthGlobal.GetValue())
		float maxHealth = PlayerRef.GetValue(Health) / PlayerRef.GetValuePercentage(Health)
		float healthToSet = maxHealth - CPA_PAHealthGlobal.GetValue()
		PlayerRef.SetValue(Health, healthToSet)
	endif
	
	if (CPA_PAActionPoints.GetValue() > 0)
		debug.trace("[CPA_PowerArmorPerkEffectScript] PA AP reduced by - " + CPA_PAActionPoints.GetValue())
		float maxAP = PlayerRef.GetValue(ActionPoints) / PlayerRef.GetValuePercentage(ActionPoints)
		float apToSet = maxAP - CPA_PAActionPoints.GetValue()
		PlayerRef.SetValue(ActionPoints, apToSet)
	endif
	
	if (CPA_PACarryWeightGlobal.GetValue() > 0)
		debug.trace("[CPA_PowerArmorPerkEffectScript] PA Carry weight reduced by - " + CPA_PACarryWeightGlobal.GetValue())
		PlayerRef.ModValue(CarryWeight, -CPA_PACarryWeightGlobal.GetValue())
	endif
	
	debug.trace("[CPA_PowerArmorPerkEffectScript] PA SpeedMult reverted to - " + CPA_PrevSpeedMultGlobal.GetValue())
	PlayerRef.SetValue(SpeedMult, CPA_PrevSpeedMultGlobal.GetValue())
	
	debug.trace("[CPA_PowerArmorPerkEffectScript] PA Jump height reverted to - " + CPA_PrevJumpHeightGlobal.GetValue())
	PlayerRef.SetValue(JumpHeightMult, CPA_PrevJumpHeightGlobal.GetValue())
EndEvent
