characterTraitsClasses.push(class extends hsdm_trait
{
	disciplinary_action = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SOLDIER)
			&& (disciplinary_action = find_wep_in_slot(player, "disciplinary_action", 2))
	}

	function OnApply()
	{
		change_weapon_damage(disciplinary_action, 105 / 195.0, -1)
	}
})