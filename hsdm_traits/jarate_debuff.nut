characterTraitsClasses.push(class extends hsdm_trait
{
	function OnDamageDealt(victim, params)
	{
		if (IsValidPlayer(victim) && !victim.InCond(24)) return

		params.damage *= 1.35
	}
})