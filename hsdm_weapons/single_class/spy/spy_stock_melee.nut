characterTraitsClasses.push(class extends hsdm_trait
{
	knife = null

	function CanApply()
	{
		if (!player_class_is(TF_CLASS_SPY)) return

		foreach(name in spy_stock_melee_list)
			if (knife = find_wep_in_slot(player, name, 2))
				return true
		return false
	}

	function OnApply()
	{
		change_spy_melee_damage(knife)
	}
})

// todo: have individual weapon.nuts add themselves
spy_stock_melee_list <- [
	"",
	"saxxy", // all class items
	"knife", // all knife skins
	"your_eternal_reward",
	"wanga_prick", // need both yer and wanga with current methods
	"kunai",
	"big_earner",
	"spycicle",
]