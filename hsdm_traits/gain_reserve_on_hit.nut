// specifically built for heavy miniguns, not a universal solution (yet?)

characterTraitsClasses.push(class extends hsdm_trait
{
	weapons = [""]

	function CanApply()
	{
		local toreturn = false
		foreach (ammo_gainer in gain_reserve_on_hit_primaries)
			if (weapons.push(find_wep(player, ammo_gainer)))
				toreturn = true

		return toreturn
	}

	function OnDamageDealt(victim, params)
	{
		if (!IsValidPlayerOrBuilding(victim) || !weapons.find(params.weapon)) return

		local primary_ammo = GetPropIntArray(params.attacker, "m_iAmmo", TF_AMMO.PRIMARY)

		// i think maxclip +1 is a fix for shortstop, but gives it ability to go to 2 clip if you hit 2 players at once who cares
		if (params.weapon && primary_ammo < 20)
			SetPropIntArray(params.attacker, "m_iAmmo", primary_ammo + 1.5, TF_AMMO.PRIMARY)
	}
})

gain_reserve_on_hit_primaries <- [""]