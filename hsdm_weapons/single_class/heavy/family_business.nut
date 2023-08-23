characterTraitsClasses.push(class extends hsdm_trait
{
	family_business = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_HEAVYWEAPONS)
			&& (family_business = find_wep_in_slot(player, "family_business", 1))
	}

	function OnApply()
	{
		change_weapon_damage(family_business, 126.0 / 180.0)
		change_weapon_clip(family_business, 3, 8.0)
		change_weapon_reserve(family_business, TF_AMMO.SECONDARY, 2, 32.0, true)
	}
})
overfill_secondaries.push("family_business")