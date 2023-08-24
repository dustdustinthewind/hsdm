characterTraitsClasses.push(class extends hsdm_trait
{
	bat = null

	function CanApply()
	{
		if (!player_class_is(TF_CLASS_SCOUT)) return

		foreach(name in scout_stock_melee_list)
			if (bat = find_wep_in_slot(player, name, 2))
				return true
		return false
	}

	function OnApply()
	{
		change_scout_melee_damage(bat)
	}
})

// todo: have individual weapons add themselves
scout_stock_melee_list <- ["",]