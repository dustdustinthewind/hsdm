characterTraitsClasses.push(class extends hsdm_trait
{
	smg = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SNIPER)
			&& (smg = find_wep_in_slot(player, "smg", 1))
	}

	function OnApply()
	{
		change_weapon_clip(smg, 6, 25.0)
		change_weapon_reserve(smg, TF_AMMO.SECONDARY, 8, 75.0)
	}
})
gain_clip_on_hit_weapons.push("smg")