characterTraitsClasses.push(class extends hsdm_trait
{
	panic_attack = null

	function CanApply()
	{
		return panic_attack = find_wep_in_slots(player, "panic_attack", 0, 1)
	}

	function OnApply()
	{
		change_weapon_damage(panic_attack, 173.0 / 216.0)
		change_weapon_clip(panic_attack, 2.0 / 6.0)
		change_shotgun_reserve(player, panic_attack)
	}
})