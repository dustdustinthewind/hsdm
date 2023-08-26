characterTraitsClasses.push(class extends hsdm_trait
{
	cow_mangler = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SOLDIER)
			&& (cow_mangler = find_wep_in_slot(player, "cow_mangler", 0))
	}

	function OnApply()
	{
		base_rocket_launcher(cow_mangler)
		change_weapon_damage(cow_mangler, 225 / 270.0)

		cow_mangler.AddAttribute("minicrits become crits", 1, -1)
		cow_mangler.AddAttribute("crits_become_minicrits" 0, -1)
	}
	// todo make this a trait
	last_frame_energy = 20

	function OnFrameTickAlive()
	{
		local energy = GetPropFloat(cow_mangler, "m_flEnergy")

		local reloading = last_frame_energy < energy

		if (reloading)
			if (energy == 15)
				SetPropFloat(cow_mangler, "m_flEnergy", 20)
			else if (energy == 5)
				SetPropFloat(cow_mangler, "m_flEnergy", 10)
			else ;
		else
			if (energy == 15)
				SetPropFloat(cow_mangler, "m_flEnergy", 10)
			else if (energy == 5)
				SetPropFloat(cow_mangler, "m_flEnergy", 0)

		last_frame_energy = energy
	}
})

non_crit_weapons.push("cow_mangler")