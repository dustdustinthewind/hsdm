characterTraitsClasses.push(class extends hsdm_trait
{
	dragons_fury = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_PYRO)
			&& (dragons_fury = find_wep_in_slot(player, "dragons_fury", 0))
	}

	function OnApply()
	{
		change_weapon_damage(dragons_fury, 35 / 25.0)
		change_weapon_reserve(dragons_fury, TF_AMMO.PRIMARY, 3, 40.0)
		dragons_fury.AddAttribute("airblast cost decreased", 1 / 5.0, -1)
	}

	function OnDamageDealt(victim, params)
	{
		local ammo_count
		if (!IsValidPlayerOrBuilding(victim) // player
		|| dragons_fury != params.weapon // using dragons
		|| params.damage_custom != TF_DMG_CUSTOM_DRAGONS_FURY_BONUS_BURNING // on bonus hit
		|| (ammo_count = GetPropIntArray(params.attacker, "m_iAmmo", TF_AMMO.PRIMARY)) > 3) // we aren't already at max (remove?)
			return

		SetPropIntArray(dragons_fury.GetOwner(), "m_iAmmo", ammo_count + 1, TF_AMMO.PRIMARY)

		// don't swap off dragons if we run out of ammo while hitting
		// glitchy if player wants to swap to secondary? maybe we only swap back to dragons if the victim is still alive?
		if (ammo_count == 0)
			params.attacker.Weapon_Switch(dragons_fury)
	}
})

non_crit_weapons.push("dragons_fury")