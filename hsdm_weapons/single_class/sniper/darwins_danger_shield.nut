characterTraitsClasses.push(class extends hsdm_trait
{
	dds = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SNIPER)
		&& (dds = find_wep_in_slot(player, "dds", 0))
	}

	function OnApply()
	{
		player.Kill() // i am not a biased pyro main
	}
})