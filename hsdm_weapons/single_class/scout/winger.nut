characterTraitsClasses.push(class extends hsdm_trait
{
	winger = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SCOUT)
			&& (winger = find_wep_in_slot(player, "winger", 1))
	}

	function OnApply()
	{
		change_weapon_damage(winger, 46 / 45.0)
		change_weapon_clip(winger, 2, 12.0)
		base_pistol(winger)
	}
})

gain_clip_on_hit_weapons.push("winger")