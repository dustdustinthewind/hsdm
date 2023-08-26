characterTraitsClasses.push(class extends hsdm_trait
{
	classic = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SNIPER)
			&& (classic = find_wep_in_slot(player, "classic", 0))
	}

	function OnApply()
	{
		base_sniper_rifle(classic)
		classic.AddAttribute("damage penalty on bodyshot", 110 / 150.0, -1)
		classic.AddAttribute("headshot damage increase", 135 / 150.0, -1)
	}
})