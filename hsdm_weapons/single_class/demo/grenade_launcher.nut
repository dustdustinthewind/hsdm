characterTraitsClasses.push(class extends hsdm_trait
{
	grenade_launcher = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_DEMOMAN)
			&& (grenade_launcher = find_wep_in_slot(player, "grenade_launcher", 0))
	}

	function OnApply()
	{
		base_grenade_launcher(grenade_launcher)
	}
})
overfill_weapons.push("grenade_launcher")

function base_grenade_launcher(weapon)
{
	change_weapon_damage(weapon, 185 / 300.0)
	self_blast_force_boost(weapon, 1.1)
	change_weapon_clip(weapon, 2, 4.0)
	change_weapon_reserve(weapon, TF_AMMO.PRIMARY, 2, 16.0, true)
}
