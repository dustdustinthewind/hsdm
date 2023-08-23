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
		change_weapon_damage(reserve_shooter, 130.5 / 90.0) // max minicrit = 175.5
		change_weapon_clip(reserve_shooter, 1, 6.0)
		change_weapon_reserve(reserve_shooter, TF_AMMO.SECONDARY, 2, 32.0, true)
	}
})

non_crit_weapons.push("reserve_shooter")
overfill_secondaries.push("reserve_shooter")