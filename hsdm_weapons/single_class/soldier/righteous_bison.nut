characterTraitsClasses.push(class extends hsdm_trait
{
	bison = null

	function CanApply()
	{
		// check primary/secondary slots for shotgun
		return bison = player_class_is(TF_CLASS_SOLDIER)
			&& find_wep_in_slot(player "bison", 1)
	}

	function OnApply()
	{
		change_weapon_damage(bison, 120 / 60.0)
	}

	function OnDamageDealt(victim, params)
	{
		if (params.weapon != bison) return

		params.damage *= 1.5
	}

	last_frame_energy = 20

	function OnFrameTickAlive()
	{
		local energy = GetPropFloat(bison, "m_flEnergy")

		local reloading = last_frame_energy < energy

		if (reloading)
			if (energy == 5)
				SetPropFloat(bison, "m_flEnergy", 20)
			else ;
		else
			if (energy == 15)
				SetPropFloat(bison, "m_flEnergy", 0)

		last_frame_energy = energy
	}
})