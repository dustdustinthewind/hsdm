characterTraitsClasses.push(class extends hsdm_trait
{
	iron_bomber = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_DEMOMAN)
			&& (iron_bomber = find_wep_in_slot(player, "iron_bomber", 0))
	}

	function OnApply()
	{
		base_grenade_launcher(iron_bomber)
	}
})
overfill_weapons.push("iron_bomber")