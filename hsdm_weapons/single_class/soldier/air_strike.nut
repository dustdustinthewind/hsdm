characterTraitsClasses.push(class extends hsdm_trait
{
	air_strike = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SOLDIER)
			&& (air_strike = find_wep_in_slot(player, "air_strike", 0))
	}

	function OnApply()
	{
		base_rocket_launcher(air_strike)
		change_weapon_damage(air_strike, 146 / 270.0)
		change_weapon_reserve(air_strike, TF_AMMO.PRIMARY, 3, 20.0)
	}
})
// todo maybe make it +1 to reserve, not clip
gain_clip_on_hit_weapons.push("air_strike")