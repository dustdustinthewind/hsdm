characterTraitsClasses.push(class extends hsdm_trait
{
	backburner = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_PYRO)
			&& (backburner = find_wep_in_slot(player, "backburner", 0))
	}

	function OnApply()
	{
		backburner.AddAttribute("airblast cost increased", 1, -1)
		base_flamethrower(player, backburner, 10)
	}
})

non_crit_weapons.push("backburner")