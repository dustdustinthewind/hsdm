characterTraitsClasses.push(class extends hsdm_trait
{
	machina = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SNIPER)
			&& (machina = find_weps_in_slot(player, ["machina", "shooting_star"], 0))
	}

	function OnApply()
	{
		base_sniper_rifle(machina)
	}
})