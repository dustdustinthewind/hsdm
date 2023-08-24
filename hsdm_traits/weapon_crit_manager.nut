characterTraitsClasses.push(class extends hsdm_trait
{
	last_active_weapon = null

	function OnFrameTickAlive()
	{
		local active_weapon = player.GetActiveWeapon()

		if (active_weapon != last_active_weapon)
		{
			FireListeners("swap_weapon", player, active_weapon)
		}

		last_active_weapon = active_weapon
	}

	function OnSwapWeapon(player, weapon)
	{
		if (!weapon) return

		local non_crit = false
		foreach (name in non_crit_weapons)
			if (WeaponIs(weapon, name))
			{
				non_crit = true
				break
			}

		if (non_crit)
			player.RemoveCond(56)
		else
			player.AddCond(56)
	}
})

// these weapons never crit
non_crit_weapons <- [""]