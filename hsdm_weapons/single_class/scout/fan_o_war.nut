characterTraitsClasses.push(class extends hsdm_trait
{
	fan_o_war = null
	function CanApply()
	{
		return player_class_is(TF_CLASS_SCOUT)
			&& (fan_o_war = find_wep_in_slot(player, "fan_o_war", 2))
	}

	function OnApply()
	{
	}

	function OnDamageDealt(victim, params)
	{
		if (!victim.InCond(30)) return
		if (params.weapon == fan_o_war)
			params.damage *= 4.0
		else
			params.damage *= 1.35
	}
})