characterTraitsClasses.push(class extends hsdm_trait
{
	reserve_shooter = null

	function CanApply()
	{
		printl("hellloo???")
		printl("")
		printl("")
		return reserve_shooter = has_wep_in_slot(player, "reserve_shooter", 1, true)
	}

	function OnApply()
	{
		base_shotgun(player, shotgun)
	}
})

non_crit_weapons.push("reserve_shooter")
foreach (bs in non_crit_weapons)
	printl(bs)