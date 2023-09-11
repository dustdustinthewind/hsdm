characterTraitsClasses.push(class extends hsdm_trait
{
	brass_beast = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_HEAVYWEAPONS)
			&& (brass_beast = find_wep_in_slot(player, "brass_beast", 0))
	}

	function OnApply()
	{
		base_minigun(brass_beast)
		// should still keep damage bonus due to both a damage bonus and a damage penalty at once
	}
})

gain_reserve_on_hit_primaries.push("brass_beast")