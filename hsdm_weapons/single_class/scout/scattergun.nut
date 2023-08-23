characterTraitsClasses.push(class extends hsdm_trait
{
	scattergun = null

	// todo scattergun unique and skins
	function CanApply()
	{
		return player.GetPlayerClass() == TF_CLASS_SCOUT
			&& (scattergun = has_wep_in_slot(player, "scattergun", 0))
	}

	function OnApply()
	{
		//change_weapon_damage(scattergun, 180.0 / 180.0) //same as stock for now
		change_weapon_clip(scattergun, 2.0 / 6.0)
		change_weapon_reserve(scattergun, TF_AMMO.PRIMARY, 2.0 / 32.0)
	}
})