characterTraitsClasses.push(class extends hsdm_trait
{
	sun_on_a_stick = null
	function CanApply()
	{
		return player_class_is(TF_CLASS_SCOUT)
			&& (sun_on_a_stick = find_wep_in_slot(player, "sun_on_a_stick", 2))
	}

	function OnApply()
	{
		change_weapon_damage(sun_on_a_stick, 85 / 79.0)
	}

	function OnDamageDealt(victim, params)
	{
		// i think this works
		sun_on_a_stick.RemoveAttribute("bleeding duration")
		if (!victim.InCond(22) || params.weapon != sun_on_a_stick) return
		sun_on_a_stick.AddAttribute("bleeding duration", 8.0, -1)
		//victim.AddCondEx(25, 8, params.attacker)
	}
})
non_crit_weapons.push("sun_on_a_stick")