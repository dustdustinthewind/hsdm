characterTraitsClasses.push(class extends hsdm_trait
{
	shotgun = null

	function CanApply()
	{
		// check primary/secondary slots for shotgun
		return shotgun = find_wep_in_slots(player, "shotgun", 0, 1)
	}

	function OnApply()
	{
		base_shotgun(player, shotgun)
	}
})

function base_shotgun(player, weapon, change_reserve = true)
{
	change_weapon_damage(weapon, 144.0 / 180.0)
	change_weapon_clip(weapon, 2, 6.0)
	if (change_reserve)
		change_shotgun_reserve(player, weapon)
}

function change_shotgun_reserve(player, weapon)
{
	change_weapon_reserve(
		weapon,
		// if engie, modify primary ammo, if anyone else, secondary
		player.GetPlayerClass() == TF_CLASS_ENGINEER ? TF_AMMO.PRIMARY : TF_AMMO.SECONDARY,
		2, 32.0, true)
}

overfill_primaries.push("shotgun")
overfill_secondaries.push("shotgun")