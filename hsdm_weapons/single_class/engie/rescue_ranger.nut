// Bb
characterTraitsClasses.push(class extends hsdm_trait
{
	rescue_ranger = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_ENGINEER)
			&& (rescue_ranger = find_wep_in_slot(player, "rescue_ranger", 0))
	}

	function OnApply()
	{
		change_weapon_damage(rescue_ranger, 105 / 120.0)
		change_weapon_clip(rescue_ranger, 2, 6.0)
		change_weapon_reserve(rescue_ranger, TF_AMMO.PRIMARY, 2, 32.0, true)
	}

	function OnTakeDamage(attacker, params)
	{
		if (!player.InCond(30)) return
		params.damage *= 1.35
	}
})
overfill_weapons.push("rescue_ranger")