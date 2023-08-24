characterTraitsClasses.push(class extends hsdm_trait
{
	hot_hand = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_PYRO)
			&& (hot_hand = find_wep_in_slot(player, "hot_hand", 2))
	}

	function OnApply()
	{
		hot_hand.AddAttribute("damage penalty", 0.9, -1) // remove damage penalty haha funny slap
	}
})