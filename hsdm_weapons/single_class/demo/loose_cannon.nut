characterTraitsClasses.push(class extends hsdm_trait
{
	loose_cannon = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_DEMOMAN)
			&& (loose_cannon = find_wep_in_slot(player, "loose_cannon", 0))
	}

	function OnApply()
	{
		change_weapon_clip(loose_cannon, 2, 4.0)
		change_weapon_reserve(loose_cannon, TF_AMMO.PRIMARY, 2, 16.0, true)
		loose_cannon.AddAttribute("minicrits become crits", 1, -1)
	}
})
non_crit_weapons.push("loose_cannon")
overfill_weapons.push("loose_cannon")
