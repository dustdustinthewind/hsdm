characterTraitsClasses.push(class extends hsdm_trait
{
	beggars_bazooka = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SOLDIER)
			&& (beggars_bazooka = find_wep_in_slot(player, "beggars_bazooka", 0))
	}

	function OnApply()
	{
		self_blast_force_boost(beggars_bazooka, 1.25)
		change_weapon_damage(beggars_bazooka, 170 / 270.0)
		change_weapon_reserve(beggars_bazooka, TF_AMMO.PRIMARY, 5, 20.0)
	}
})