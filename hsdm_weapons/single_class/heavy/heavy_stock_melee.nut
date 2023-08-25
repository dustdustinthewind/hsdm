characterTraitsClasses.push(class extends hsdm_trait
{
	fists = null

	function CanApply()
	{
		if (!player_class_is(TF_CLASS_HEAVYWEAPONS)) return

		foreach(name in heavy_stock_melee_list)
			if (fists = find_wep_in_slot(player, name, 2))
				return true
		return false
	}

	function OnApply()
	{
		change_stock_melee_damage(fists)
	}
})

heavy_stock_melee_list <- [
	"",
	"holiday_punch",
]