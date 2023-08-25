// todo: make this effect grapple speeds maybe :3
characterTraitsClasses.push(class extends hsdm_trait
{
	gru = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_HEAVYWEAPONS)
			&& (gru = find_wep_in_slot(player, "gru", 2))
	}

	velocity_on_swing = 0
	time_grabbed_velocity = 0
	swung = false

	function OnFrameTickAlive()
	{
		local velocity = player.GetVelocity().Length()
		// if we start a melee swing
		if (!swung && GetPropInt(player, "m_nButtons") & IN_ATTACK)
		{
			swung = true
			velocity_on_swing = velocity
		}
		// grab the highest velocity during the swing
		else if (Time() + 0.8 <= time_grabbed_velocity && velocity > velocity_on_swing)
			velocity_on_swing = velocity
		// and when its over reset our counter (cant i use fire time? xD)
		else
			swung = false
	}

	function OnDamageDealt(victim, params)
	{
		if (params.weapon != gru || !IsValidPlayerOrBuilding(victim)) return

		if (player.GetVelocity().Length() > velocity_on_swing)
			velocity_on_swing = player.GetVelocity().Length()

		params.damage *= velocity_on_swing / 230.0
		if (params.damage < 65) params.damage = 65

		velocity_on_swing = 0
	}
})
non_crit_weapons.push("gru")