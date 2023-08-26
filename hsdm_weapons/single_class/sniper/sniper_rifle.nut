characterTraitsClasses.push(class extends hsdm_trait
{
	sniper_rifle = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SNIPER)
			&& (sniper_rifle = find_wep_in_slot(player, "sniper_rifle", 0))
	}

	function OnApply()
	{
		base_sniper_rifle(sniper_rifle)
	}
})

function base_sniper_rifle(weapon)
{
	change_weapon_reserve(weapon, 0, 3, 25.0)
	weapon.AddAttribute("sniper fires tracer", 1, -1) // doesn't fire tracer if shot was far away

	// 125 body shots (kill light classes, suboptimal smg + hookshot combo opportunities)
	// 165 head shots (kill up to 150, optimal smg combos (only 2 shots to kill solly from here))
	weapon.AddAttribute("damage penalty on bodyshot", 125 / 150.0, -1)
	weapon.AddAttribute("headshot damage increase", 165 / 150.0, -1) // note: this makes headshot damage ramp up fast
}