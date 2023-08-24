// todo add sounds and maybe visuals to sell the oomph of the double or triple shot
characterTraitsClasses.push(class extends hsdm_trait
{
	soda_popper = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SCOUT)
			&& (soda_popper = find_wep_in_slot(player, "soda_popper", 0))
	}

	function OnApply()
	{
		soda_popper.AddAttribute("hype on damage", 0, -1) // remove hype on damage
		change_weapon_damage(soda_popper, 145 / 180.0)
		change_weapon_reserve(soda_popper, TF_AMMO.PRIMARY, 1, 32.0, true)
	}

	function OnFrameTickAlive()
	{
		if (player.GetActiveWeapon() != soda_popper) return

		// hold right click before firing to fire both shells at once
		if (/*soda_popper.Clip1() == 1 && */GetPropInt(player, "m_nButtons") & IN_ATTACK2)
			SetPropFloat(soda_popper, "LocalActiveWeaponData.m_flNextPrimaryAttack", 0)
	}
})

overfill_weapons.push("soda_popper")