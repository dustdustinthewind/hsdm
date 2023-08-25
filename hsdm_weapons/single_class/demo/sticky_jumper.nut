characterTraitsClasses.push(class extends hsdm_trait
{
	sticky_jumper = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_DEMOMAN)
			&& (sticky_jumper = find_wep_in_slot(player, "sticky_jumper", 1))
	}

	function OnApply()
	{
		base_sticky_launcher(sticky_jumper)
		change_weapon_reserve(sticky_jumper, TF_AMMO.SECONDARY, 12, 24.0, true)
		sticky_jumper.AddAttribute("maxammo secondary increased", 1.0, -1)
	}
})
demoknight_secondaries.push("sticky_jumper")
overfill_weapons.push("sticky_jumper")

