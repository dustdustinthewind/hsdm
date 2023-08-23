characterTraitsClasses.push(class extends hsdm_trait
{
	weapons = [""]

	function CanApply()
	{
		local toreturn = false
		foreach (ammo_gainer in gain_clip_on_hit_weapons)
			if (weapons.push(find_wep(player, ammo_gainer)))
				toreturn = true

		return toreturn
	}

	function OnDamageDealt(victim, params)
	{
		if (!IsValidPlayerOrBuilding(victim) || !weapons.find(params.weapon)) return

		// i think maxclip +1 is a fix for shortstop, but gives it ability to go to 2 clip if you hit 2 players at once who cares
		if (params.weapon.Clip1() <= params.weapon.GetMaxClip1())
			params.weapon.SetClip1(params.weapon.Clip1() + 1)
	}
})

gain_clip_on_hit_weapons <- [""]