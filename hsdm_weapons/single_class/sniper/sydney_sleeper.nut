characterTraitsClasses.push(class extends hsdm_trait
{
	sydney_sleeper = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SNIPER)
			&& (sydney_sleeper = find_wep_in_slot(player, "sydney_sleeper", 0))
	}

	function OnApply()
	{
		sydney_sleeper.AddAttribute("damage penalty on bodyshot", 100 / 150.0, -1)
		sydney_sleeper.AddAttribute("headshot damage increase", 125 / 150.0, -1)
		sydney_sleeper.AddAttribute("maxammo primary reduced", 3 / 25.0, -1)
	}
})