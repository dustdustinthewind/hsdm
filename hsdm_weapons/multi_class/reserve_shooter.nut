characterTraitsClasses.push(class extends hsdm_trait
{
	reserve_shooter = null

	function CanApply()
	{
		return reserve_shooter = has_wep_in_slot(player, "reserve_shooter", 1)
	}

	function OnApply()
	{
		change_weapon_clip(reserve_shooter, 1.0 / 6.0)
		change_weapon_reserve(reserve_shooter, TF_AMMO.SECONDARY, 2.0 / 32.0)
	}
})

non_crit_weapons.push("reserve_shooter")