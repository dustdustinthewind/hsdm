//  - marks enemies as wet for neon annihilator combo
//  - start with gas passer at spawn
characterTraitsClasses.push(class extends hsdm_trait
{
	gas_passer = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_PYRO)
			&& (gas_passer = find_wep_in_slot(player, "gas_passer", 1, true))
	}

	function OnApply()
	{
		// respawn the gas when you spawn
		// abusable? sure
		// a problem? prolly not who fucking cares we have grapple hooks
		printl(GetPropFloatArray(player, "m_Shared.m_flItemChargeMeter", 1))
		SetPropFloatArray(player, "m_Shared.m_flItemChargeMeter", 99.0, 1)
		SetPropFloatArray(player, "m_Shared.m_flEffectBarRegenTime", 99.0, 1)
	}
})

non_crit_weapons.push("gas_passer")