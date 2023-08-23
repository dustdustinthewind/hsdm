characterTraitsClasses.push(class extends hsdm_trait
{
	axe = null

	function CanApply()
	{
		if (!player_class_is(TF_CLASS_PYRO)) return

		foreach(name in pyro_stock_melee_list)
			if (axe = find_wep_in_slot(player, name, 2))
				return true
		return false
	}

	function OnApply()
	{
		change_stock_melee_damage(axe)
	}
})

// todo: have individual weapons add themselves
pyro_stock_melee_list <- [
	"",
	"saxxy", // all class items
	"fire_axe",
	"lollichop", // have to do both fire_axe and lollichop due to way things set up
	"powerjack",
	"third_degree",
]