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
				local new_pack = SpawnEntityFromTable("item_" + ammo_or_health + size, {})

				// setup
                EntFireByHandle(new_pack, "kill", "", 20, null, null)
				new_pack.SetAbsOrigin(ammo_pack.GetOrigin())
				local position_last_frame = new_pack.GetOrigin()

				// kill thinkscript
				new_pack.ValidateScriptScope()
				local scope = new_pack.GetScriptScope()
				scope["kill_if_reset"] <- function()
				{
					if (abs(new_pack.GetOrigin().Length() - position_last_frame.Length()) > 100) // edge case, if ammo pack is picked up near 0,0,0, it'll still respawn
					{
						AddThinkToEnt(new_pack, null)
						new_pack.Kill()
						return
					}
					position_last_frame = new_pack.GetOrigin()

					return 0.1
				}
				AddThinkToEnt(new_pack, "kill_if_reset")

				// kill the imposter
				ammo_pack.Kill()
				break
			}
	}
})

AddListener("tick_always", 1, function()
{

})