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
		params.damage *= victim.GetVelocity().Length() / 500.0
		if (params.damage < 3) params.damage = 3

		victim.SetVelocity(Vector(0,0,0))
		// freezes player for 3 seconds hopefully
		//  works, also freezes all movement. maybe move into third person for comfort?
		victim.AddCondEx(87, 1.0, params.attacker)
		// force taunt cam
		victim.SetForcedTauntCam(1)
		EntFireByHandle(victim, "RunScriptCode", "self.SetForcedTauntCam(0)", 1, victim, null)
		// should remove all grapplings
		// doesnt work
		// todo when have grapple controller
		victim.RemoveCond(98)
		victim.RemoveCond(99)
		victim.RemoveCond(100)
	}
})
scout_stock_melee_list.push("sandman")