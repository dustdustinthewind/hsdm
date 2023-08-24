characterTraitsClasses.push(class extends hsdm_trait
{
	reserve_shooter = null

	function CanApply()
	{
		return player_class_is_one_of([TF_CLASS_SOLDIER, TF_CLASS_PYRO])
			&& (reserve_shooter = find_wep_in_slot(player, "reserve_shooter", 1))
	}

	function OnApply()
	{
		change_weapon_damage(reserve_shooter, 175.5 / 180.0) // max crit = 175.5
		change_weapon_clip(reserve_shooter, 1, 6.0)
		change_weapon_reserve(reserve_shooter, TF_AMMO.SECONDARY, 2, 32.0, true)
		reserve_shooter.AddAttribute("minicrits become crits", 1, -1)
	}
})

non_crit_weapons.push("reserve_shooter")
overfill_weapons.push("reserve_shooter")