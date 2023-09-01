characterTraitsClasses.push(class extends hsdm_trait
{
	flamethrower = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_PYRO)
			&& (flamethrower = find_wep_in_slot(player, "flamethrower", 0))
	}

	function OnApply()
	{
		base_flamethrower(player, flamethrower, 5)
	}
})

non_crit_weapons.push("flamethrower")

function base_flamethrower(player, weapon, airblast_cost)
{
	change_weapon_damage(weapon, 11 / 19.5) // 19.5 per crit tick tf2 (133-266 dps), 11 is 75-150 dps
	change_weapon_damage(weapon, 3.0) // don't ask i'll bark
	change_weapon_reserve(weapon, TF_AMMO.PRIMARY, 30, 200.0)
	weapon.AddAttribute("airblast cost decreased", airblast_cost / 20.0, -1)
}