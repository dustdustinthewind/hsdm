characterTraitsClasses.push(class extends hsdm_trait
{
	liberty_launcher = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SOLDIER)
			&& (liberty_launcher = find_wep_in_slot(player, "liberty_launcher", 0))
	}

	function OnApply()
	{
		liberty_launcher.AddAttribute("clip size bonus", 1, -1)
		self_blast_force_boost(liberty_launcher, 1.25)
		change_weapon_damage(liberty_launcher, 146 / 270.0)
		change_weapon_clip(liberty_launcher, 3, 4.0)
		change_weapon_reserve(liberty_launcher, TF_AMMO.PRIMARY, 2, 20.0, true)
	}
})
overfill_weapons.push("liberty_launcher")