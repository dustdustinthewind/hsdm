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
		change_weapon_damage(cow_mangler, 245 / 270.0)
		cow_mangler.AddAttribute("minicrits become crits", 1, -1)
		cow_mangler.AddAttribute("crits_become_minicrits" 0, -1)
	}

	/*
	function OnFrameTickAlive()
	{
		if (GetPropInt(player, "m_nButtons") & IN_RELOAD)
		{
			if (cow_mangler.Clip1() == 5)
				cow_mangler.SetClip1(10)
			if (cow_mangler.Clip1() == 15)
				cow_mangler.SetClip1(20)
		}
		if (cow_mangler.Clip1() == 15)
			cow_mangler.SetClip1(10)
		if (cow_mangler.Clip1() == 5)
			cow_mangler.SetClip1(0)

		printl(player.GetRageMeter())
		cow_mangler.SetClip1(10)
	}*/
})

non_crit_weapons.push("cow_mangler")