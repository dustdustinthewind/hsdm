// consider falloff on panic?
characterTraitsClasses.push(class extends hsdm_trait
{
	panic_attack = null

	function CanApply()
	{
		return panic_attack = find_wep_in_slots(player, "panic_attack", 0, 1)
	}

	function OnApply()
	{
		change_weapon_damage(panic_attack, 173 / 15.0 / 18.0 / (player_class_is(TF_CLASS_SOLDIER) ? 3.0 : 1.0)) // 15 pellets, tf2 stock shotty crit damage per pellet is 18
		change_weapon_clip(panic_attack, 2, 6.0)
		change_shotgun_reserve(player, panic_attack)
	}
})

overfill_weapons.push("panic_attack")