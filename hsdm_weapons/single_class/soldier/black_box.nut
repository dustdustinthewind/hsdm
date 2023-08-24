characterTraitsClasses.push(class extends hsdm_trait
{
	black_box = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SOLDIER)
			&& (black_box = find_weps_in_slot(player, ["black_box", "black_box_xmas"], 0))
	}

	function OnApply()
	{
		self_blast_force_boost(black_box, 1.25)
		change_weapon_damage(black_box, 170 / 270.0)
		change_weapon_clip(black_box, 1, 4.0)
		change_weapon_reserve(black_box, TF_AMMO.PRIMARY, 3, 20.0, true)
		black_box.AddAttribute("health on radius damage", 35, -1) // too much?
	}
})

overfill_primaries.push("black_box")
overfill_primaries.push("black_box_xmas")