characterTraitsClasses.push(class extends hsdm_trait
{
	kgb = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_HEAVYWEAPONS)
			&& (kgb = find_wep_in_slot(player, "kgb", 2))
	}

	// deal 2* more damage when buff-alo'd
	function OnDamageDealt(victim, params)
	{
		if (player.InCond(40))
			params.damage *= 2
	}
})
heavy_stock_melee_list.push("kgb")