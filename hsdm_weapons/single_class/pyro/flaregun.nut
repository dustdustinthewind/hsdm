characterTraitsClasses.push(class extends hsdm_trait
{
	flaregun = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_PYRO)
			&& (flaregun = find_wep_in_slot(player, "flaregun", 1))
	}

	function OnApply()
	{
		change_weapon_damage(flaregun, 120 / 90.0)
		flaregun.AddAttribute("hidden secondary max ammo penalty", 3 / 32.0, -1) // we use this attribute to override flare guns attribute, its actually using the shotgun ammo pool * .5
	}
})
non_crit_weapons.push("flaregun")