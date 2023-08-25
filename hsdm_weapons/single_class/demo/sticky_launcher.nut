characterTraitsClasses.push(class extends hsdm_trait
{
	sticky_launcher = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_DEMOMAN)
			&& (sticky_launcher = find_wep_in_slot(player, "sticky_launcher", 1))
	}

	function OnApply()
	{
		change_weapon_damage(sticky_launcher, 201 / 355.0)
		base_sticky_launcher(sticky_launcher)
	}
})
overfill_weapons.push("sticky_launcher")

function base_sticky_launcher(weapon)
{
	self_blast_force_boost(weapon, 1.1)
	change_weapon_clip(weapon, 2, 8.0)
	change_weapon_reserve(weapon, TF_AMMO.SECONDARY, 2, 24.0, true)
	weapon.AddAttribute("max pipebombs decreased", -6, -1) // Max 2 stickies
	weapon.AddAttribute("sticky arm time bonus", -0.2, -1) // slightly faster shooty
}
