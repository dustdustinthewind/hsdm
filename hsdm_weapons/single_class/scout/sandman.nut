characterTraitsClasses.push(class extends hsdm_trait
{
	sandman = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SCOUT)
			&& (sandman = find_wep_in_slot(player, "sandman", 2))
	}

	// considering increasing damage of ball
	function OnDamageDealt(victim, params)
	{
		if (params.damage_custom != TF_DMG_CUSTOM_BASEBALL) return

		// increased damage for higher speed victim is going
		// todo: tweak
		params.damage *= victim.GetVelocity().Length() / 250.0
		if (params.damage < 10) params.damage = 10

		victim.SetVelocity(Vector(0,0,0))
		// freezes player for 3 seconds hopefully
		// todo: test works
		victim.AddCondEx(87, 3.0, params.attacker)
		// should remove all grapplings
		// todo: test this works
		victim.RemoveCond(98)
		victim.RemoveCond(99)
		victim.RemoveCond(100)
	}
})
scout_stock_melee_list.push("sandman")