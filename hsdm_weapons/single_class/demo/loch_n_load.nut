characterTraitsClasses.push(class extends hsdm_trait
{
	loch_n_load = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_DEMOMAN)
			&& (loch_n_load = find_wep_in_slot(player, "loch_n_load", 0))
	}

	function OnApply()
	{
		base_grenade_launcher(loch_n_load)
		change_weapon_clip(loch_n_load, 1, 4.0)
		change_weapon_reserve(loch_n_load, TF_AMMO.PRIMARY, 3, 16.0, true)
	}
})

overfill_weapons.push("loch_n_load")