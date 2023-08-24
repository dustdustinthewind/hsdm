characterTraitsClasses.push(class extends hsdm_trait
{
	escape_plan = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SOLDIER)
			&& (escape_plan = find_wep_in_slot(player, "escape_plan", 2))
	}

	// check this works
	function OnDamageTaken(attacker, params)
	{
		if (!params.victim.InCond(30)) return
		params.damage *= 1.35
	}
})

soldier_stock_melee_list.push("escape_plan")