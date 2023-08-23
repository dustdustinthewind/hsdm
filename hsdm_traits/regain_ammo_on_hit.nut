characterTraitsClasses.push(class extends hsdm_trait
{
	weapon = null

	function CanApply()
	{
		foreach (ammo_gainer in regain_ammo_on_hit_weapons)
			if (weapon = find_wep(player, ammo_gainer))
				return true

		return false
	}

	function OnDamageDealt(victim, params)
	{
		if (params.weapon != weapon) return

		// i believe maxclip +1 is a fix for shortstop, but gives it ability to go to 2, if you hit 2 players at once who cares
		if (weapon.Clip1() <= weapon.GetMaxClip1() + 1)
			weapon.SetClip1(weapon.Clip1() + 1)
	}
})

// these weapons regain ammo on hit
regain_ammo_on_hit_weapons <- [""]