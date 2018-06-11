Scriptname CPA_ReducePABatteryEffectScript extends activemagiceffect

Actor Property PlayerRef auto

Spell Property AbBobbleheadRepair auto

Perk Property NuclearPhysicist01 auto
Perk Property NuclearPhysicist02 auto

ActorValue Property PABatteryDamageRate auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if (akTarget == PlayerRef)
		debug.trace("[CPA_ReducePABatteryEffect] OnEffectStart called for player target")
		; First apply Nuclear Physicist perks
		float newBatteryRate = PlayerRef.GetValue(PABatteryDamageRate) as float
		if (PlayerRef.HasPerk(NuclearPhysicist02))
			debug.trace("[CPA_ReducePABatteryEffect] player has NuclearPhysicist02")
			; need to revert nuclear phys 1 via reverse percentage
			newBatteryRate = (newBatteryRate * 100) / 75
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
	endif
EndEvent
