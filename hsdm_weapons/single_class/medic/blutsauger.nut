characterTraitsClasses.push(class extends hsdm_trait
{
	blutsauger = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_MEDIC)
			&& (blutsauger = find_wep_in_slot(player, "blutsauger", 0))
	}

	function OnApply()
	{
		base_syringe_gun(blutsauger)
		blutsauger.AddAttribute("heal on hit for rapidfire", 5, -1) // gain 5 hp on hit
	}
})