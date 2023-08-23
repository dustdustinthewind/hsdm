characterTraitsClasses.push(class extends hsdm_trait
{
	family_business = null

	function CanApply()
	{
		return player.GetPlayerClass() == TF_CLASS_HEAVYWEAPONS
			&& (family_business = has_wep_in_slot(player, "family_business", 1))
	}

	function OnApply()
	{
		change_weapon_damage(family_business, 126.0 / 180.0)
		change_weapon_clip(family_business, 3.0 / 8.0)
		change_weapon_reserve(family_business, TF_AMMO.SECONDARY, 2.0 / 32.0)
	}
})