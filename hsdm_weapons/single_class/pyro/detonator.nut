characterTraitsClasses.push(class extends hsdm_trait
{
	detonator = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_PYRO)
			&& (detonator = find_wep_in_slot(player, "detonator", 1))
	}

	function OnApply()
	{
		change_weapon_damage(detonator, 120 / 90.0)
		detonator.AddAttribute("self dmg push force increased", 1.25, -1)
		detonator.AddAttribute("hidden secondary max ammo penalty", 3 / 32.0, -1) // we use this attribute to override flare guns attribute, its actually using the shotgun ammo pool * .5
		detonator.AddAttribute("blast dmg to self increased", 1, -1) // ~27 damage on self blast
	}
})
non_crit_weapons.push("detonator")