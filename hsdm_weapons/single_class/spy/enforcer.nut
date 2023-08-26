// todo maybe remove the 4-ammo overfill and make it 2(+1), maybe give gain clip on hit, maybe remove crits
// maybe only crits when disguised
// maybe don't lose disguise while shooting xd
characterTraitsClasses.push(class extends hsdm_trait
{
	enforcer = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SPY)
			&& (enforcer = find_wep_in_slot(player, "enforcer", 0))
	}

	function OnApply()
	{
		base_revolver(enforcer)
	}
})