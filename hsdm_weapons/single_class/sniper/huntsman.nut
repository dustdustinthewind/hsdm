characterTraitsClasses.push(class extends hsdm_trait
{
	huntsman = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SNIPER)
			&& (huntsman = find_wep_in_slot(player, "huntsman", 0))
	}

	function OnApply()
	{
		change_weapon_reserve(huntsman, TF_AMMO.PRIMARY, 3, 11.0)
	}
})