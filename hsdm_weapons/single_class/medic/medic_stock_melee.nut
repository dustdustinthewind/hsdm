characterTraitsClasses.push(class extends hsdm_trait
{
	saw = null

	function CanApply()
	{
		if (!player_class_is(TF_CLASS_MEDIC)) return

		foreach(name in medic_stock_melee_list)
			if (saw = find_wep_in_slot(player, name, 2))
				return true
		return false
	}

	function OnApply()
	{
		change_stock_melee_damage(saw)
	}
})

medic_stock_melee_list <- [""]