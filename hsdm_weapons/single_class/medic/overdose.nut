// todo: make this effect grappling
characterTraitsClasses.push(class extends hsdm_trait
{
	overdose = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_MEDIC)
			&& (overdose = find_wep_in_slot(player, "overdose", 0))
	}

	function OnApply()
	{
		base_syringe_gun(overdose)
		// will still keep damage penalty
	}
})