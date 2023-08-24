characterTraitsClasses.push(class extends hsdm_trait
{
	pretty_boys_pocket_pistol = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SCOUT)
			&& (pretty_boys_pocket_pistol = find_wep_in_slot(player, "pretty_boys_pocket_pistol", 1))
	}

	function OnApply()
	{
		change_weapon_damage(pretty_boys_pocket_pistol, 38.0 / 45.0)
		change_weapon_clip(pretty_boys_pocket_pistol, 3, 12.0)
		base_pistol(pretty_boys_pocket_pistol)
	}
})

gain_clip_on_hit_weapons.push("pretty_boys_pocket_pistol")