characterTraitsClasses.push(class extends hsdm_trait
{
	kukri = null

	function CanApply()
	{
		if (!player_class_is(TF_CLASS_SNIPER)) return

		foreach(name in sniper_stock_melee_list)
			if (kukri = find_wep_in_slot(player, name, 2))
				return true
		return false
	}

	function OnApply()
	{
		change_stock_melee_damage(kukri)
	}
})

// todo: have individual weapons add themselves
sniper_stock_melee_list <- [
	"",
	"saxxy", // all class items
	"kukri",
	"bushwacka",
]