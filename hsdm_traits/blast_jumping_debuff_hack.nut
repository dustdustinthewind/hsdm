// makes specific classes "rocket jumping" whenever they grapple
// this should fix the direct hit not consistently mini-critting grappling players (i assume it only minicrits if they are currently grappling, who cares)
characterTraitsClasses.push(class extends hsdm_trait
{
	function OnAttach(player)
	{
		// heavy and soldier get resistance to minicrits (soldier so he still has to rocket jump for mg, heavy cause heavy)
		if (!player_class_is_one_of([TF_CLASS_SOLDIER, TF_CLASS_HEAVYWEAPONS]))
			player.AddCond(81) // blast jumping when attach (doesn't seem to work)
	}

	/*
	function OnDamageDealt(victim, params)
	{
        if (!victim.IsPlayer() || !victim.InCond(81)) return

		local player_class = params.attacker.GetPlayerClass()
		// tomini crits become crits
        if ((player_class == TF_CLASS_SOLDIER || player_class == TF_CLASS_PYRO)
		  && (WeaponIs(params.weapon, "direct_hit") || WeaponIs(params.weapon, "reserve_shooter")))
			// todo: deal 3* damage by modifying victim health
			;
	}*/
})