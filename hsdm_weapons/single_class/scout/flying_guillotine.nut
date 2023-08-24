characterTraitsClasses.push(class extends hsdm_trait
	{
		cleaver = null

		function CanApply()
		{
			return player_class_is(TF_CLASS_SCOUT)
				&& (cleaver = find_wep_in_slot(player, "cleaver", 1))
		}

		function OnDamageDealt(victim, params)
		{
			if (params.weapon != find_wep_in_slot(player, "cleaver", 1)
			|| params.damage_custom == TF_DMG_CUSTOM_BLEEDING)
				return

			params.damage = 40
		}
	})
