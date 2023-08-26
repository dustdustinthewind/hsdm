characterTraitsClasses.push(class extends hsdm_trait
{
	ambassador = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SPY)
			&& (ambassador = find_weps_in_slot(player, ["ambassador", "ambassador_xmas"], 0))
	}

	function OnApply()
	{
		base_revolver(ambassador)
		change_weapon_damage(ambassador, 156 / 120.0 / 3.0)
		ambassador.AddAttribute("headshot damage increase", 21.6, -1) // long range headshot = 198 dmg
		// NOTE: crit headshots still only deal 156 damage because we overrite it in OnDamageDealt
		ambassador.AddAttribute("sniper fires tracer", 1, -1)
		ambassador.AddAttribute("damage penalty on bodyshot", 1.6, -1)
		ambassador.AddAttribute("crit_dmg_falloff", 0, -1)
	}

	function OnDamageDealt(victim, params)
	{
		if (params.damage_custom == TF_DMG_CUSTOM_HEADSHOT) // only triggers on crit :3
			params.damage = 156 / 3.0
	}
})
non_crit_weapons.push("ambassador")