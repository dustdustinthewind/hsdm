characterTraitsClasses.push(class extends hsdm_trait
{
	rocket_launcher = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SOLDIER)
			&& (rocket_launcher = find_wep_in_slot(player, "rocket_launcher", 0))
	}

	function OnApply()
	{
		base_rocket_launcher(rocket_launcher)
		change_weapon_damage(rocket_launcher, 170 / 338.0)
		change_weapon_reserve(rocket_launcher, TF_AMMO.PRIMARY, 2, 20.0, true)
	}
})

overfill_weapons.push("rocket_launcher")

function base_rocket_launcher(weapon)
{
	self_blast_force_boost(weapon, 1.25)
	change_weapon_clip(weapon, 2, 4.0)
}