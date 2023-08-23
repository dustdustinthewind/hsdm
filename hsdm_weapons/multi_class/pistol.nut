characterTraitsClasses.push(class extends hsdm_trait
{
	pistol = null

	function CanApply()
	{
		return player_class_is_one_of([TF_CLASS_SCOUT, TF_CLASS_ENGINEER])
			&& (pistol = find_wep_in_slot(player, "pistol", 1))
	}

	function OnApply()
	{
		change_weapon_damage(pistol, 38.0 / 45.0)
		change_weapon_clip(pistol, 4, 12.0)
		base_pistol(pistol)
	}
})

gain_clip_on_hit_weapons.push("pistol")

function base_pistol(weapon)
{
	if (player_class_is(TF_CLASS_ENGINEER))
		change_weapon_reserve(weapon, TF_AMMO.SECONDARY, 40.0, 200.0) // embrace large pool meme, i will not regret this
	else
		change_weapon_reserve(weapon, TF_AMMO.SECONDARY, 6, 36.0)
}