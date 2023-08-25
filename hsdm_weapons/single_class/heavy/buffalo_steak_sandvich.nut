characterTraitsClasses.push(class extends hsdm_trait
{
	buffalo_steak_sandvich = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_HEAVYWEAPONS)
			&& (buffalo_steak_sandvich = find_wep_in_slot(player, "buffalo_steak_sandvich", 1))
	}

	// deal 2* more damage when buff-alo'd
	function OnDamageDealt(victim, params)
	{
		if (player.InCond(41))
			params.damage *= 1.35
	}
})
non_crit_weapons.push("buffalo_steak_sandvich")