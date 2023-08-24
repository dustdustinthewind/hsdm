characterTraitsClasses.push(class extends hsdm_trait
{
	manmelter = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_PYRO)
			&& (manmelter = find_wep_in_slot(player, "manmelter", 1))
	}

	function OnApply()
	{
		change_weapon_damage(manmelter, 120 / 90.0)
	}

	function OnFrameTickAlive()
	{
		if (GetPropInt(player, "m_Shared.m_iRevengeCrits") == 0)
			SetPropFloat(manmelter, "LocalActiveWeaponData.m_flNextPrimaryAttack", Time() + 1)
	}

	function OnKill(victim, params)
	{
		if (params.weapon != "manmelter")
			AddPropInt(player, "m_Shared.m_iRevengeCrits", 1);
	}
})
non_crit_weapons.push("manmelter")