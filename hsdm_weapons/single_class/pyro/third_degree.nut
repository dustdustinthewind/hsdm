characterTraitsClasses.push(class extends hsdm_trait
{
	third_degree = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_PYRO)
			&& (third_degree = find_wep_in_slot(player, "third_degree", 2))
	}

	velocity_on_swing = 0
	time_grabbed_velocity = 0
	swung = false

	function OnFrameTickAlive()
	{
		local velocity = player.GetVelocity().Length()
		// if we start a melee swing
		if (!swung && player.GetActiveWeapon() == third_degree && GetPropInt(player, "m_nButtons") & IN_ATTACK)
		{
			swung = true
			velocity_on_swing = velocity
		}
		// grab the highest velocity during the swing
		// note: this 0.8 window may allow players to store fast velocities as they swap to this weapon, oh well
		//        iirc melee swing happens 0.3 seconds after you left click, then that 0.5 seconds would be the recovery, i may be wrong tho idfk
		else if (Time() + 0.8 <= time_grabbed_velocity && velocity > velocity_on_swing)
			velocity_on_swing = velocity
		// and when its over reset our counter (cant i use fire time? xD)
		else
			swung = false
	}

	function OnDamageDealt(victim, params)
	{
		if (params.weapon != third_degree || !IsValidPlayerOrBuilding(victim)) return

		if (player.GetVelocity().Length() > velocity_on_swing)
			velocity_on_swing = player.GetVelocity().Length()

		params.damage *= velocity_on_swing / 300.0
		if (params.damage < 45) params.damage = 45

		velocity_on_swing = 0
	}
})

non_crit_weapons.push("third_degree")