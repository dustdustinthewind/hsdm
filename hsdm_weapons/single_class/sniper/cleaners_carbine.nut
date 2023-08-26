characterTraitsClasses.push(class extends hsdm_trait
{
	cleaners_carbine = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SNIPER)
			&& (cleaners_carbine = find_wep_in_slot(player, "cleaners_carbine", 1))
	}

	function OnApply()
	{
		change_weapon_clip(cleaners_carbine, 4, 25.0)
		change_weapon_reserve(cleaners_carbine, TF_AMMO.SECONDARY, 10, 75.0)
	}

	function OnDamageDealt(victim, params)
	{
		// todo figure this out
		//printl(player.InCond(78))

		if (player.InCond(78))
			params.damage *= 1.35
	}
})
gain_clip_on_hit_weapons.push("cleaners_carbine")