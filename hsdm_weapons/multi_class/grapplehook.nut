class grapplehook extends hsdm_trait
{
	grappling_hook = null

	function CanApply()
	{
		return grappling_hook = player.GetWeapon("Grappling Hook")
	}

	function OnApply() { }

	function OnFrameTickAlive()
	{
		update_grapple_buffs()

		find_grapple_projectile()

		reel_in_cooldown()

		grapplehook_code()
	}

	buff_list = []

	function update_grapple_buffs()
	{
		for(local i = 0; i < buff_list.len(); i++)
			if (Time() >= buff_list[i][1])
				remove_grapple_buff(buff_list.remove(i)[0])
	}

	function apply_grapple_buff(name, params = [], duration = -1)
	{
		buff_list.push([name, duration >= 0 ? Time() + duration : 99999])

		// todo: change grapple variables dependent on what buff name is
	}

	function remove_grapple_buff(buff)
	{
		// todo: reset grapple variables dependent on what buff name is
	}

	grapple_projectile = null
	used_grapple_last_tick = false

	function find_grapple_projectile()
	{
		local grappling_this_tick = GetPropBool(player, "m_bUsingActionSlot")
		// shooting grapple
		// todo make this a listener event or something? on using action?
		if (grappling_this_tick && !grapple_projectile)
		{
			local grapple = Entities.FindByClassnameNearest("tf_projectile_grapplinghook", player.EyePosition(), 50.0)

			if (grapple && grapple.GetOwner() == player)
				grapple_projectile = grapple
		}
		// stopped shooting grapple
		else if (!grappling_this_tick && used_grapple_last_tick)
			grapple_projectile = null

		used_grapple_last_tick = grappling_this_tick
	}

	grapple_target = null

	function grapplehook_code()
	{
		// if we jump detach the frame we attach, this i assume doesn't work
		grapple_target = player.GetGrapplingHookTarget()

		// while grappling and on attach
		while_grappling()

		on_detach_code()
	}

	grapple_target_center = null
	grapple_location = null
	rope_length = 0
	grappling_func = null
	player_distance_from_grapple = 0
	heading = null

	function while_grappling()
	{
		if (!grapple_target) return

		grappling_func = grapple_target.tostring().find("func_") != null

		grapple_target_center = grapple_target.GetCenter()

		grapple_location = grapple_projectile ? grapple_projectile.GetOrigin() : grapple_target.GetOrigin()
		player_distance_from_grapple = (grapple_location - player.GetOrigin()).Length()
		heading = player.GetOrigin() - grapple_location
		rope_length = player_distance_from_grapple < rope_length ? player_distance_from_grapple : rope_length

		if (rope_length < MINIMUM_ROPE_LENGTH)
		{
			rope_length = MINIMUM_ROPE_LENGTH
			// acceleration to 0?
			grapple_impulse(player, heading, 1, 0.998)
		}

		on_attach_code()

		attached_to_func()

		reel_in_code()

		swing_code()

		rope_length_code()
	}

	last_grapple_target = null
	last_grapple_target_center = null

	function on_attach_code()
	{
		// if you jump detach right as you attach this doesn't get called
		if (last_grapple_target) return

		// set LastGrappleTarget to what we attached to
		last_grapple_target = grapple_target
		rope_length = player_distance_from_grapple

		// run class specific function for hookshot attach
		FireListeners("on_attach", player)

		// a single impulse towards grapple target
		// if holding crouch, do crouch things
		local crouch = GetPropInt(player, "m_nButtons") & IN_DUCK
		grapple_impulse(player,
			crouch ? player.EyeAngles().Forward() * -1 : heading, // if holding crouch, jolt the player forward wherever they're looking
			ON_ATTACH_IMPULSE * (crouch ? 0.6 : 1), // if holding crouch, use crouch impulse (todo: make seperate variable)
			crouch ? MOMENTUM_RETENTION : 1.0) // if holding crouch, retain all momentum

		if (grappling_func) last_grapple_target_center = grapple_target_center
	}

	function on_detach_code()
	{
		if (grapple_target || !last_grapple_target) return

		// run class specific function for hookshot detach
		FireListeners("on_detach", player)

		last_grapple_target = null
		grapple_projectile = null

		start_reel_in_cooldown()
	}

	function attached_to_func()
	{
		// attached to func parent code
		if (!grappling_func) return

		// very basic follow func code, does not respect rotations, todo
		translate_position()
	}

	function translate_position()
	{
		local center_difference = last_grapple_target_center - grapple_target_center
		if (center_difference == 0) return

		grapple_projectile.SetAbsOrigin(grapple_location + (center_difference * -1))
		player.SetAbsOrigin(player.GetOrigin() + (center_difference * -1))
		last_grapple_target_center = grapple_target_center
	}

	reeling_in = false

	function reel_in_code()
	{
		// already reeling in or reel in using attack 3
		if (reeling_in || (last_time_reeled + REEL_IN_COOLDOWN < Time() && (GetPropInt(player, "m_nButtons") & IN_ATTACK3)))
		{
			if (player_distance_from_grapple < MINIMUM_ROPE_LENGTH)
				start_reel_in_cooldown()
			else
			{
				player.AddCond(32) // speed up condition (for speed particle effect)
				ReelIn(player, heading)
				reeling_in = true
			}
		}
	}

	last_time_reeled = 0
	reel_cooldown_dinged = false

	function reel_in_cooldown()
	{
		if (reel_cooldown_dinged || Time() < REEL_IN_COOLDOWN + last_time_reeled) return

		reel_cooldown_dinged = true
		//todo ding player
	}

	function start_reel_in_cooldown()
	{
		if (reeling_in)
			last_time_reeled = Time();

		reeling_in = false
		player.RemoveCond(32)
	}

	function swing_code()
	{
		local keys = GetPropInt(player, "m_nButtons")

		if (!keys) return

		// strafing left/right, forward/back
		local eyes = player.EyeAngles()
		local upImpulse = keys & IN_FORWARD ? eyes.Forward() * GRAPPLE_FORWARD_VELOCITY : Vector(0, 0, 0)
		local downImpulse = keys & IN_BACK ? eyes.Forward() * -GRAPPLE_FORWARD_VELOCITY : Vector(0, 0, 0)
		local leftImpulse = keys & IN_MOVELEFT ? eyes.Left() * -GRAPPLE_SIDE_VELOCITY   : Vector(0, 0, 0)
		local rightImpulse = keys & IN_MOVERIGHT ? eyes.Left() * GRAPPLE_SIDE_VELOCITY  : Vector(0, 0, 0)

		player.Yeet((upImpulse + downImpulse + leftImpulse + rightImpulse) * 0.014999)
	}

	function rope_length_code()
	{
		// apply tension and shit
		if (player_distance_from_grapple < rope_length) return

		local tension = player_distance_from_grapple - rope_length
		tension *= player_distance_from_grapple / rope_length

		grapple_impulse(player, heading, tension * TENSION_STRENGTH, 1.0)
	}

	function grapple_impulse(player, heading, initialImpulse = ON_ATTACH_IMPULSE, reduceMomentum = MOMENTUM_RETENTION, capSpeed = false)
	{
		local impulse = ImpulseInHeading(player, heading, initialImpulse)
		if (!capSpeed || impulse.Length() < initialImpulse)
		{
			player.SetVelocity(player.GetVelocity() * reduceMomentum) // reduce current velocity to give hook-impulse more impact
			player.Yeet(impulse)
		}
	}

	function ImpulseInHeading(player, heading, impulse)
	{
		local distance = -impulse / heading.Length()
		return heading * distance
	}

	function ReelIn(player, heading)
	{
		grapple_impulse(player, heading, REEL_IN_SPEED, 0, true)
	}
}

characterTraitsClasses.push(grapplehook)