characterTraitsClasses.push(class extends hsdm_trait
{
	function OnDeath(attacker, params)
	{
		local ammo_or_health = RandomInt(0, 100) < 75 ? "ammopack_" : "healthkit_" // 25% chance for health
		local attack_vel = attacker ? attacker.GetVelocity().Length() : 0
		local victim = GetPlayerFromUserID(params.userid)
		local victim_vel = victim ? victim.GetVelocity().Length() : 0
		local vel = victim_vel + attack_vel
		local size = vel > 900 ? "full" : vel > 600 ? "medium" : "small"
		// ^ todo make these controllable variables
		// todo: test with players, doesn't work well with tr_walkway bots

		local ammo_pack = null
		while (ammo_pack = Entities.FindByClassname(ammo_pack, "tf_ammo_pack"))
			if (ammo_pack.GetOwner() == player)
			{
				local new_pack = SpawnEntityFromTable("item_" + ammo_or_health + size, {})

				// setup
				new_pack.SetAbsOrigin(ammo_pack.GetOrigin())
				local position_last_frame = new_pack.GetOrigin()
                EntFireByHandle(new_pack, "kill", "", 20, null, null)

				// kill thinkscript
				new_pack.ValidateScriptScope()
				local scope = new_pack.GetScriptScope()
				scope["kill_if_reset"] <- function()
				{
					// can't we check if it's enabled or disabled?
					if (abs((new_pack.GetOrigin() - position_last_frame).Length()) > 150) // edge case, if ammo pack is picked up near 0,0,0, it'll still respawn, maybe
					{
						AddThinkToEnt(new_pack, null)
						new_pack.Kill()
						return
					}
					position_last_frame = new_pack.GetOrigin()

					return 0.1
				}
				AddThinkToEnt(new_pack, "kill_if_reset")

				// vote to kill the imposter
				ammo_pack.Kill()
				break
			}
	}
})

AddListener("tick_always", 1, function()
{

})