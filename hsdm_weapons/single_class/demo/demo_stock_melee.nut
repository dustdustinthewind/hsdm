characterTraitsClasses.push(class extends hsdm_trait
{
	function CanApply()
	{
		return player_class_is(TF_CLASS_DEMOMAN)
	}

	function OnApply()
	{
		// if not demoknight, nerf the melees, otherwise, stick with stock melee
		if (!is_demoknight())
			change_stock_melee_damage(player.ReturnWeaponBySlot(2))
	}

	demoknight = null

	function is_demoknight()
	{
		if (demoknight != null) return demoknight

		demoknight = false
		local knight_primary = player.GetPassiveWeaponBySlot(0)
		if (!knight_primary)
			foreach(primary in demoknight_primaries)
				if (find_wep_in_slot(player, primary, 0))
				{
					knight_primary = true
					break
				}
		if (!knight_primary) return false

		local knight_secondary = player.GetPassiveWeaponBySlot(1)
		printl(knight_secondary)
		if (!knight_secondary)
		{
			foreach(secondary in demoknight_secondaries)
				if (find_wep_in_slot(player, secondary, 1, true))
				{
					demoknight = true
					break
				}
		}
		else
			demoknight = true

		return demoknight
	}

	function OnFrameTickAlive()
	{
		if (is_demoknight())
			demoknight_speed_crits()
	}

	last_frame_had_crits = false
	time_lost_crits = 0.0
	extra_time_window = 0.3

	function demoknight_speed_crits()
	{
		local cooldown = true
		local this_frame_has_crits = player.GetVelocity().Length() >= DEMOKNIGHT_CRIT_SPEED_TRIGGER
		//  || Time() < time_lost_crits + EXTRA_TIME_WINDOW
		if (last_frame_had_crits && !this_frame_has_crits)
			time_lost_crits = Time()
		last_frame_had_crits = this_frame_has_crits

		if (this_frame_has_crits || Time() <= time_lost_crits + extra_time_window)
			player.AddCond(56)
		else
			player.RemoveCond(56)
	}
})

demoknight_primaries <- [""]
demoknight_secondaries <- ["","any_shield"]