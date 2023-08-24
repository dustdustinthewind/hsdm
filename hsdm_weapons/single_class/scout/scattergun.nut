characterTraitsClasses.push(class extends hsdm_trait
{
	scattergun = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SCOUT)
			&& (scattergun = find_wep_in_slot(player, "scattergun", 0))
	}

	function OnApply()
	{
		//change_weapon_damage(scattergun, 180.0 / 180.0) //same as stock for now
		change_weapon_clip(scattergun, 2, 6.0)
		change_weapon_reserve(scattergun, TF_AMMO.PRIMARY, 2, 32.0, true)
	}
})

overfill_weapons.push("scattergun")