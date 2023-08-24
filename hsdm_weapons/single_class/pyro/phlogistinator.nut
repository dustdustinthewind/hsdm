characterTraitsClasses.push(class extends hsdm_trait
{
	phlogistinator = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_PYRO)
			&& (phlogistinator = find_wep_in_slot(player, "phlogistinator", 0))
	}

	function OnApply()
	{
		base_flamethrower(player, phlogistinator, 666)
	}
})

non_crit_weapons.push("phlogistinator")