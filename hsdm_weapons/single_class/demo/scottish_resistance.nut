characterTraitsClasses.push(class extends hsdm_trait
{
	scottish_resistance = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_DEMOMAN)
			&& (scottish_resistance = find_wep_in_slot(player, "scottish_resistance", 1))
	}

	function OnApply()
	{
		change_weapon_damage(scottish_resistance, 201 / 355.0)
		self_blast_force_boost(scottish_resistance, 1.1)
		change_weapon_clip(scottish_resistance, 3, 8.0)
		change_weapon_reserve(scottish_resistance, TF_AMMO.SECONDARY, 6, 24.0)
		scottish_resistance.AddAttribute("max pipebombs increased", 0, -1)
		scottish_resistance.AddAttribute("maxammo secondary increased", 1, -1)
		scottish_resistance.AddAttribute("sticky arm time penalty", 0.6, -1)
	}
})
overfill_weapons.push("scottish_resistance")
