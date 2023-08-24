characterTraitsClasses.push(class extends hsdm_trait
{
	direct_hit = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SOLDIER)
			&& (direct_hit = find_wep_in_slot(player, "direct_hit", 0))
	}

	function OnApply()
	{
		base_rocket_launcher(direct_hit)
		change_weapon_damage(direct_hit, 210 / 270.0)
		direct_hit.AddAttribute("damage bonus", 1.0, -1)
		change_weapon_reserve(direct_hit, TF_AMMO.PRIMARY, 2, 20.0, true)
		direct_hit.AddAttribute("minicrits become crits", 1, -1)

	}
})
non_crit_weapons.push("direct_hit")
overfill_weapons.push("direct_hit")