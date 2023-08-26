characterTraitsClasses.push(class extends hsdm_trait
{
	neon_annihilator = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_PYRO)
			&& (neon_annihilator = find_wep_in_slot(player, "neon_annihilator", 2))
	}

	function OnApply()
	{
		change_weapon_damage(neon_annihilator, 75 / 52.0)
	}

	function OnDamageDealt(victim, params)
	{
		if (!victim.InCond(TF_COND_GAS)) return

		victim.SetWaterLevel(1)
	}
})

non_crit_weapons.push("neon_annihilator")