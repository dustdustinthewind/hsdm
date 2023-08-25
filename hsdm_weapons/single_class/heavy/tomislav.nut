characterTraitsClasses.push(class extends hsdm_trait
{
	tomislav = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_HEAVYWEAPONS)
			&& (tomislav = find_wep_in_slot(player, "tomislav", 0))
	}

	function OnApply()
	{
		base_minigun(tomislav)
	}
})