characterTraitsClasses.push(class extends hsdm_trait
{
	atomizer = null
	function CanApply()
	{
		return player_class_is(TF_CLASS_SCOUT)
			&& (atomizer = find_wep_in_slot(player, "atomizer", 2))
	}

	function OnApply()
	{
		change_weapon_damage(atomizer, 45 / 89.0)
	}
})