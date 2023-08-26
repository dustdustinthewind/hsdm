characterTraitsClasses.push(class extends hsdm_trait
{
	function OnDeath(attacker, params)
	{

		local ammo_or_health = RandomInt(0, 100) < 75 ? "ammopack_" : "healthkit_" // 25% chance for health
		local vel = attacker ? attacker.GetVelocity().Length() : 0
		local size = vel > 900 ? "full" : vel > 600 ? "medium" : "small"
		// ^ todo make these controllable variables

		local ammo_pack = null
		while (ammo_pack = Entities.FindByClassname(ammo_pack, "tf_ammo_pack"))
			if (ammo_pack.GetOwner() == player)
			{
				local new_pack = SpawnEntityFromTable("item_" + ammo_or_health + size,
				{
					Auto_Materialize = "No"
				})
				if(new_pack.KeyValueFromString("Auto-Materialize", "No"))
					printl("fuck yea")
				EntFireByHandle(new_pack, "kill", "", 10, null, null);

				if (new_pack) new_pack.SetAbsOrigin(ammo_pack.GetOrigin())

				ammo_pack.Kill()
				break
			}
	}
})