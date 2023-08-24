characterTraitsClasses.push(class extends hsdm_trait
{
	axtinguisher = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_PYRO)
			&& (axtinguisher = find_wep_in_slot(player, "axtinguisher", 2))
	}

	function OnApply()
	{
		change_weapon_damage(axtinguisher, 66 / 195.0)
		axtinguisher.AddAttribute("minicrits become crits", 1, -1)
	}
})

non_crit_weapons.push("axtinguisher")