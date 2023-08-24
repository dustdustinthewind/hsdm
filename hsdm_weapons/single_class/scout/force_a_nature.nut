characterTraitsClasses.push(class extends hsdm_trait
	{
		force_a_nature = null

		function CanApply()
		{
			return player_class_is(TF_CLASS_SCOUT)
				&& (force_a_nature = find_wep_in_slot(player, "force_a_nature", 0))
		}

		function OnApply()
		{
			change_weapon_clip(force_a_nature, 1, 6.0)
			change_weapon_reserve(force_a_nature, TF_AMMO.PRIMARY, 3, 32.0, true)
			change_weapon_damage(force_a_nature, 215 / 194.4)
		}
	})

overfill_weapons.push("force_a_nature")