characterTraitsClasses.push(class extends hsdm_trait
{
	rocket_jumper = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SOLDIER)
			&& (rocket_jumper = find_wep_in_slot(player, "rocket_jumper", 0))
	}

	function OnApply()
	{
		base_rocket_launcher(rocket_jumper)
		change_weapon_clip(rocket_jumper, 3, 4.0)
		change_weapon_reserve(rocket_jumper, TF_AMMO.PRIMARY, 10, 60.0, true)
	}
})
overfill_primaries.push("rocket_jumper")
non_crit_weapons.push("rocket_jumper")