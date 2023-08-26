characterTraitsClasses.push(class extends hsdm_trait
{
	letranger = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SPY)
			&& (letranger = find_wep_in_slot(player, "letranger", 0))
	}

	function OnApply()
	{
		base_revolver(letranger)
	}
})