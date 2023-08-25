characterTraitsClasses.push(class extends hsdm_trait
{
	fists_of_steel = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_HEAVYWEAPONS)
			&& (fists_of_steel = find_wep_in_slot(player, "fists_of_steel", 2))
	}

	// deal 2* more damage to players who also have melee out
	// todo: test this works
	function OnDamageDealt(victim, params)
	{
		if (victim.GetActiveWeapon() == victim.ReturnWeaponBySlot(2))
			damage *= 2.0
	}
})
heavy_stock_melee_list.push("fists_of_steel")