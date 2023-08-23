characterTraitsClasses.push(class extends hsdm_trait
{
	wrench = null

	function CanApply()
	{
		if (!player_class_is(TF_CLASS_ENGINEER)) return

		foreach(name in engie_stock_melee_list)
			if (wrench = find_wep_in_slot(player, name, 2))
				return true
		return false
	}

	function OnApply()
	{
		change_stock_melee_damage(wrench)
	}
})

// todo: have individual weapons add themselves
engie_stock_melee_list <- [
	"",
	"saxxy", // all class items
	"wrench",
	"gunslinger",
	"southern_hospitality",
	"eureka_effect",
	//
	"jag"
]