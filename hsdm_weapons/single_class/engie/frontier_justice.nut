// Bb
characterTraitsClasses.push(class extends hsdm_trait
{
	frontier_justice = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_ENGINEER)
			&& (frontier_justice = find_wep_in_slot(player, "frontier_justice", 0))
	}

	function OnApply()
	{
		change_weapon_damage(frontier_justice, 174 / 180.0)
		change_weapon_clip(frontier_justice, 1, 6.0)
		change_weapon_reserve(frontier_justice, TF_AMMO.PRIMARY, 2, 32.0, true)
	}
})
overfill_weapons.push("frontier_justice")
non_crit_weapons.push("frontier_justice")