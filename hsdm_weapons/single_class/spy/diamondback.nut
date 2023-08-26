characterTraitsClasses.push(class extends hsdm_trait
{
	diamondback = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SPY)
			&& (diamondback = find_wep_in_slot(player, "diamondback", 0))
	}

	function OnApply()
	{
		base_revolver(diamondback)
		change_weapon_damage(diamondback, 156 / 102.0)
	}
})
non_crit_weapons.push("diamondback")