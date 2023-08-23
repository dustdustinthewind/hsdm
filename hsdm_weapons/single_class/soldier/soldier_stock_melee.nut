characterTraitsClasses.push(class extends hsdm_trait
{
	shovel = null

	function CanApply()
	{
		if (!player_class_is(TF_CLASS_SOLDIER)) return

		foreach(name in soldier_stock_melee_list)
			if (shovel = find_wep_in_slot(player, name, 2))
				return true
		return false
	}

	function OnApply()
	{
		change_stock_melee_damage(shovel)
	}
})

// todo: have individual weapons add themselves
soldier_stock_melee_list <- [
	"",
	"saxxy", // all class items
	"shovel",
	"pain_train",
	"katana",
	"escape_plan",
]