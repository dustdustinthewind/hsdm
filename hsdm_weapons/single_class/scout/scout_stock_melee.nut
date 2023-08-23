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
scout_stock_melee_list <- [
	"",
	"saxxy", // all class items
	"bat", // all bat skins (including mackerel)
	"sandman",
	"candy_cane",
	"boston_basher",
	"three_rune_blade", // need both boston and three rune with current methods
	// these will need to have their own damage set
	/*"sun_on_a_stick",
	"atomizer",
	"wrap_assassin",
	"fan_o_war"*/
]