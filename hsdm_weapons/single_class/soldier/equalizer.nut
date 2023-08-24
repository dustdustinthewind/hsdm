characterTraitsClasses.push(class extends hsdm_trait
{
	equalizer = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SOLDIER)
			&& (equalizer = find_wep_in_slot(player, "equalizer", 2))
	}

	function OnApply()
	{
		equalizer.AddAttribute("dmg bonus while half dead", 195 / 145.0, -1)
		equalizer.AddAttribute("dmg penalty while half alive", 85 / 145.0, -1)
		equalizer.AddAttribute("mod shovel damage boost", 0, -1)
	}
})

soldier_stock_melee_list.push("equalizer")