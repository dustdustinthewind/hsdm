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
			change_stock_melee_damage(find_wep_in_slot(player, "any", 2))
	}

	function is_demoknight()
	{
		local knight_primary = false
		foreach(primary in demoknight_primaries)
			if (find_wep_in_slot(player, primary, 0))
			{
				knight_primary = true
				break
			}
		if (!knight_primary) return false

		foreach(secondary in demoknight_secondaries)
			if (find_wep_in_slot(player, secondary, 1))
				return true
		return false
	}

	function OnFrameTickAlive()
	{
		if (is_demoknight())
			demoknight_speed_crits()
	}

	last_frame_had_crits = false
	time_lost_crits = 0.0
	extra_time_window = 0.4

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


// todo: have individual weapon.nuts add themselves
demoknight_primaries <- [
	"",
	"booties",
	"base_jumper"
]

// todo: have individual weapon.nuts add themselves
demoknight_secondaries <- [
	"",
	"chargin_targe",
	"splendid_screen",
	"tide_turner",
	"sticky_jumper"
]