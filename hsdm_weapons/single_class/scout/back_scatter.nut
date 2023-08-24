characterTraitsClasses.push(class extends hsdm_trait
	{
		back_scatter = null

		function CanApply()
		{
			return player_class_is(TF_CLASS_SCOUT)
				&& (back_scatter = find_wep_in_slot(player, "back_scatter", 0))
		}

		function OnApply()
		{
			change_weapon_clip(back_scatter, 1, 6.0)
			change_weapon_reserve(back_scatter, TF_AMMO.PRIMARY, 3, 32.0, true)
			change_weapon_damage(back_scatter, 295 / 180.0)
			back_scatter.AddAttribute("minicrits become crits", 1, -1)
		}
	})

overfill_weapons.push("back_scatter")
non_crit_weapons.push("back_scatter")