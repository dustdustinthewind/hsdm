characterTraitsClasses.push(class extends hsdm_trait
{
	degreaser = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_PYRO)
			&& (degreaser = find_wep_in_slot(player, "degreaser", 0))
	}

	function OnApply()
	{
		degreaser.AddAttribute("airblast cost increased", 1, -1)
		base_flamethrower(player, degreaser, 5)
	}
})
non_crit_weapons.push("degreaser")
