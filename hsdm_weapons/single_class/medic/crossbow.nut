// todo: make this effect grappling
characterTraitsClasses.push(class extends hsdm_trait
{
	crossbow = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_MEDIC)
			&& (crossbow = find_wep_in_slot(player, "crossbow", 0))
	}

	function OnApply()
	{
		change_weapon_reserve(crossbow, TF_AMMO.PRIMARY, 4, 150.0)
	}
})