characterTraitsClasses.push(class extends hsdm_trait
{
	function CanApply()
	{
		// check primary and secondary slots for the chute
		return find_wep_in_slots(player, "base_jumper", 0, 1)
	}

	function OnAttach(player)
	{
		if (!player.InCond(TF_COND_PARACHUTE_ACTIVE))
			player.RemoveCond(TF_COND_PARACHUTE_DEPLOYED)
	}
})
demoknight_primaries.push("base_jumper")