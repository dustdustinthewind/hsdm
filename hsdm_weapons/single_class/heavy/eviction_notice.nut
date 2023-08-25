characterTraitsClasses.push(class extends hsdm_trait
{
	eviction_notice = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_HEAVYWEAPONS)
			&& (eviction_notice = find_wep_in_slot(player, "eviction_notice", 2))
	}

	function OnApply()
	{
		change_weapon_damage(eviction_notice, 58 / 65.0)
		eviction_notice.AddAttribute("fire rate bonus", 0.4, -1)
	}
})
non_crit_weapons.push("eviction_notice")