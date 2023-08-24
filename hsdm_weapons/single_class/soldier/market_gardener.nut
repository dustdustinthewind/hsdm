characterTraitsClasses.push(class extends hsdm_trait
{
	market_gardener = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SOLDIER)
			&& (market_gardener = find_wep_in_slot(player, "market_gardener", 2))
	}

	function OnApply()
	{
		change_weapon_damage(market_gardener, 245 / 195.0, -1)
	}

	function OnFrameTickAlive()
	{
		if (player.GetActiveWeapon() != market_gardener) return

		// visual indicator of crits
		// also gives an extra window to hit the crit
		if (player.InCond(81))
			player.AddCond(56)
		else
			player.RemoveCond(56)


	}
})

non_crit_weapons.push("market_gardener")