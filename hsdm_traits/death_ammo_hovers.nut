characterTraitsClasses.push(class extends hsdm_trait
{
	new_pack = null
	time_since_drop = 0

	// https://discord.com/channels/217585440457228290/1039243316920844428/1140973453441257553
	function OnDeath(attacker, params)
	{
		// doesnt work
		if (new_pack != null)
			new_pack.Kill()
		new_pack = null
		local ammo_pack = null
		while (ammo_pack = Entities.FindByClassname(ammo_pack, "tf_ammo_pack"))
			if (ammo_pack.GetOwner() == player)
			{
				new_pack = SpawnEntityFromTable("item_ammopack_medium",
				{
					auto_materialize = false
				})
				new_pack.SetAbsOrigin(ammo_pack.GetOrigin())
				time_since_drop = Time()
				ammo_pack.Kill()
				break
			}
	}
})