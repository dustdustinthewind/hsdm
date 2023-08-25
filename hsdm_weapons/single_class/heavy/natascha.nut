characterTraitsClasses.push(class extends hsdm_trait
{
	natascha = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_HEAVYWEAPONS)
			&& (natascha = find_wep_in_slot(player, "natascha", 0))
	}

	function OnApply()
	{
		base_minigun(natascha)
		change_weapon_damage(natascha, 17 * 0.75 / 27.0) // dmg per bullet with 25% dmg reduction
	}
})