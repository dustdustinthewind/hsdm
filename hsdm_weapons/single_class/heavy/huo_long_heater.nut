characterTraitsClasses.push(class extends hsdm_trait
{
	huo_long_heater = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_HEAVYWEAPONS)
			&& (huo_long_heater = find_wep_in_slot(player, "huo_long_heater", 0))
	}

	function OnApply()
	{
		base_minigun(huo_long_heater)
		change_weapon_damage(huo_long_heater, 17 * 0.9 / 27.0) // dmg per bullet with 15% dmg reduction
	}
})