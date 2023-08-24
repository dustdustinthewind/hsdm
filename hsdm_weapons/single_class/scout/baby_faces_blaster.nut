
// todo have boost affect grappling
characterTraitsClasses.push(class extends hsdm_trait
	{
		baby_faces_blaster = null


		function CanApply()
		{
			return player_class_is(TF_CLASS_SCOUT)
				&& (baby_faces_blaster = find_wep_in_slot(player, "baby_faces_blaster", 0))
		}

		function OnApply()
		{
			change_weapon_clip(baby_faces_blaster, 1, 6.0)
			change_weapon_reserve(baby_faces_blaster, TF_AMMO.PRIMARY, 3, 32.0, true)
		}

		function OnDetach(player)
		{
			// remove double jump on detach (to counter act the double jump gain on attach)
			// not working?
			SetPropInt(player, "m_shared.miAirDash", 1)
		}

		function OnAttach(player)
		{
			// remove hype
			player.SetScoutHypeMeter(0.0)
		}
	})

overfill_weapons.push("baby_faces_blaster")