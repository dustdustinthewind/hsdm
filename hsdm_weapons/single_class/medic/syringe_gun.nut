characterTraitsClasses.push(class extends hsdm_trait
{
	syringe_gun = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_MEDIC)
			&& (syringe_gun = find_wep_in_slot(player, "syringe_gun", 0))
	}

	function OnApply()
	{
		base_syringe_gun(syringe_gun)
	}
})

function base_syringe_gun(weapon)
{
	change_weapon_clip(weapon, 12, 40.0)
	change_weapon_reserve(weapon, TF_AMMO.PRIMARY, 16, 150.0)
}
