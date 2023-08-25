characterTraitsClasses.push(class extends hsdm_trait
{
	quickiebomb_launcher = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_DEMOMAN)
			&& (quickiebomb_launcher = find_wep_in_slot(player, "quickiebomb_launcher", 1))
	}

	function OnApply()
	{
		self_blast_force_boost(quickiebomb_launcher, 1.1)
		change_weapon_damage(quickiebomb_launcher, 201 / 355.0 * 0.85)
		change_weapon_clip(quickiebomb_launcher, 1, 8.0)
		change_weapon_reserve(quickiebomb_launcher, TF_AMMO.SECONDARY, 3, 24.0, true)
		quickiebomb_launcher.AddAttribute("max pipebombs decreased", -7, -1) // Max 2 stickies
		quickiebomb_launcher.AddAttribute("sticky arm time bonus", -0.4, -1)
		quickiebomb_launcher.AddAttribute("Reload time decreased", 0.67, -1)
	}
})
overfill_weapons.push("quickiebomb_launcher")

