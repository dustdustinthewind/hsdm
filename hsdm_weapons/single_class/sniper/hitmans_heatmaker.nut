characterTraitsClasses.push(class extends hsdm_trait
{
	hitmans_heatmaker = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SNIPER)
			&& (hitmans_heatmaker = find_wep_in_slot(player, "hitmans_heatmaker", 0))
	}

	function OnApply()
	{
		base_sniper_rifle(hitmans_heatmaker)
		hitmans_heatmaker.AddAttribute("damage penalty on bodyshot", 75 / 150.0, -1)
		hitmans_heatmaker.AddAttribute("headshot damage increase", 125 / 150.0, -1)
		hitmans_heatmaker.RemoveAttribute("sniper fires tracer")
		// consider removing tracer
		// consider 125/150 damage headshots
		// consider changing focus ability into something new (faster firing rate? ammo regen?)
	}

	function OnDamageDealt(victims, params)
	{
		if (params.weapon != hitmans_heatmaker
		|| params.damage_custom != 51) return

		SetPropIntArray(params.attacker, "m_iAmmo", GetPropIntArray(params.attacker, "m_iAmmo", TF_AMMO.PRIMARY) + 1, TF_AMMO.PRIMARY)
	}
})