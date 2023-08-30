characterTraitsClasses.push(class extends hsdm_trait
{
	function CanApply()
	{
		return player.GetWeapon("Grappling Hook")
	}

	grapple_projectile = null
	used_grapple_last_tick = false

	last_grapple_target = null
	last_grapple_target_center = null

	reel_cooldown_dinged = false
	last_time_reeled = 0
	reeling_in = false

	rope_length = 0

	function OnApply()
	{

	}

	function OnFrameTickAlive()
	{
		// todo can i make these listener/events?

		local grappling_this_tick = NetProps.GetPropBool(player, "m_bUsingActionSlot")
		// shooting grapple
		// todo make this a listener event or something?
		if (!grapple_projectile && grappling_this_tick)
		{
			local grapple = Entities.FindByClassnameNearest("tf_projectile_grapplinghook", player.EyePosition(), 50.0)

			if (grapple && grapple.GetOwner() == player)
				grapple_projectile = grapple
		}
		// stopped shooting grapple
		else if (!grappling_this_tick && used_grapple_last_tick)
		{
			grapple_projectile = null
		}

		used_grapple_last_tick = grappling_this_tick

		if (!reel_cooldown_dinged && Time() >= REEL_IN_COOLDOWN + last_time_reeled)
		{
			reel_cooldown_dinged = true
			//todo ding player
		}

		// if we jump detach the frame we attach, this i assume doesn't work
		local grapple_target = player.GetGrapplingHookTarget()

		// while grappling
		if (grapple_target)
			while_grappling(grapple_target)

		// on detach
		if (last_grapple_target && !grapple_target)
		{
			// run class specific function for hookshot detach
			FireListeners("on_detach", player)

			last_grapple_target = null
			grapple_projectile = null

			StartReelInCooldown()
		}
	}

	function while_grappling(grapple_target)
	{
		local buttons = GetPropInt(player, "m_nButtons")
		if (buttons & IN_ALT1)
			printl("alt1")
		if (buttons & IN_ALT2)
			printl("alt2")
		if (buttons & IN_WEAPON1)
			printl("weapon1")
		if (buttons & IN_WEAPON2)
			printl("weapon2")
		if (buttons & IN_BULLRUSH)
			printl("bullrush")
		if (buttons & IN_GRENADE1)
			printl("grenade1")
		if (buttons & IN_GRENADE2)
			printl("grenade1")

		local grapplingFunc = grapple_target.tostring().find("func_") != null

		local grappleTargetCenter = grapple_target.GetCenter()


		local grappleLocation = grapple_projectile ? grapple_projectile.GetOrigin() : grapple_target.GetOrigin()
		local playerLocation = player.GetOrigin()
		local playerDistanceFromGrapple = (grappleLocation - playerLocation).Length()
		local heading = playerLocation - grappleLocation
		rope_length = playerDistanceFromGrapple < rope_length ? playerDistanceFromGrapple : rope_length


		// on attach
		// if you jump detach right as you attach this doesn't get called
		if (!last_grapple_target)
		{
			// set LastGrappleTarget to what we attached to
			last_grapple_target = grapple_target
			rope_length = playerDistanceFromGrapple

			// run class specific function for hookshot attach
			FireListeners("on_attach", player)

			// a single impulse towards grapple target
			GrappleImpulse(player, heading)

			if (grapplingFunc)
				last_grapple_target_center = grappleTargetCenter
		}

		// attached to func parent code
		if (grapple_target.tostring().find("func"))
		{
			local centerDifference = last_grapple_target_center - grappleTargetCenter
			grapple_projectile.SetAbsOrigin(grappleLocation + (centerDifference * -1))
			player.SetAbsOrigin(playerLocation + (centerDifference * -1)) // change -0.5 based on how close you are to it?
			last_grapple_target_center = grappleTargetCenter
		}

		local keys = NetProps.GetPropInt(player, "m_nButtons")

		// already reeling in or reel in using attack 3
		if (reeling_in || (last_time_reeled + REEL_IN_COOLDOWN < Time() && (keys & Constants.FButtons.IN_ATTACK3)))
		{
			if (playerDistanceFromGrapple < ROPE_SAFETY_RADIUS)
				StartReelInCooldown()
			else
			{
				player.AddCond(32)
				ReelIn(player, heading)
				reeling_in = true
			}
		}
		else if ((keys & move[1]) || (keys & move[2]) || (keys & move[3]) || (keys & move[4]))
		{
			// strafing left/right, forward/back
			local eyes = player.EyeAngles()
			local upImpulse = keys & move[1] ? eyes.Forward() * GRAPPLE_FORWARD_VELOCITY * 0.5 : Vector(0, 0, 0)
			local downImpulse = keys & move[2] ? eyes.Forward() * -GRAPPLE_FORWARD_VELOCITY : Vector(0, 0, 0)
			local leftImpulse = keys & move[3] ?  eyes.Left() * -GRAPPLE_SIDE_VELOCITY : Vector(0, 0, 0)
			local rightImpulse = keys & move[4] ? eyes.Left() * GRAPPLE_SIDE_VELOCITY : Vector(0, 0, 0)

			local impulse = upImpulse + downImpulse + leftImpulse + rightImpulse
			player.ApplyAbsVelocityImpulse(impulse * 0.014999)
		}
		// if within x units of grapple, set velocity to 0
		// hopefully to prevent a weird glitch where you go flying when you get near hook
		// doesn't always work but this does help. maybe make bandaid bigger idk
		else if (heading.Length() < ROPE_SAFETY_RADIUS)
			GrappleImpulse(player, heading, 1, 0.998)


		//printl(playerDistanceFromGrapple + " " + rope_length)
		// else apply tension and shit
		if (playerDistanceFromGrapple > rope_length)
		{
			//printl(rope_length)

			local tension = playerDistanceFromGrapple - rope_length
			tension *= playerDistanceFromGrapple / rope_length

			GrappleImpulse(player, heading, tension * TENSION_STRENGTH, 1.0)
		}
	}

	move = [
		0,
		Constants.FButtons.IN_FORWARD,
		Constants.FButtons.IN_BACK,
		Constants.FButtons.IN_MOVELEFT,
		Constants.FButtons.IN_MOVERIGHT
	]

	function StartReelInCooldown()
	{
		if (reeling_in)
			last_time_reeled = Time();

		reeling_in = false
		player.RemoveCond(32)
	}

	function GrappleImpulse(player, heading, initialImpulse = ON_ATTACH_IMPULSE, reduceMomentum = MOMENTUM_RETENTION, capSpeed = false)
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
		GrappleImpulse(player, heading, REEL_IN_SPEED, 0.1, true)
	}
})