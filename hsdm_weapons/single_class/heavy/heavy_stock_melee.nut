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

// todo: have individual weapons add themselves
heavy_stock_melee_list <- [
	"",
	"saxxy", // all class items
	"fireaxe", // frying pan, sign, all classes xd
	"fists",
	"kgb",
	"gru",
	"gru_xmas",
	"bread_bite",
	"fists_of_steel",
	"holiday_punch",
]