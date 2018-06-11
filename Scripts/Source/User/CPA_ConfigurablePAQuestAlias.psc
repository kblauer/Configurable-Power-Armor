Scriptname CPA_ConfigurablePAQuestAlias extends ReferenceAlias

GlobalVariable Property CPA_JetpackDrainInitial auto
GlobalVariable Property CPA_JetpackDrainSustained auto
GlobalVariable Property CPA_JetpackThrustInitial auto
GlobalVariable Property CPA_JetpackThrustSustained auto
GlobalVariable Property CPA_JetpackTimeToSustained auto

Event OnPlayerLoadGame()
	debug.trace("[CPA_ConfigurablePAQuestAlias] OnPlayerLoadGame event called - loading jetpack drain values")
	Game.SetGameSettingFloat("fJetpackDrainInital", CPA_JetpackDrainInitial.GetValue())
	Game.SetGameSettingFloat("fJetpackDrainSustained", CPA_JetpackDrainSustained.GetValue())
	Game.SetGameSettingFloat("fJetpackThrustInitial", CPA_JetpackThrustInitial.GetValue())
	Game.SetGameSettingFloat("fJetpackTimeToSustained", CPA_JetpackTimeToSustained.GetValue())
	Game.SetGameSettingFloat("fJetpackThrustSustained", CPA_JetpackThrustSustained.GetValue())
EndEvent
