// joke
characterTraitsClasses.push(class extends hsdm_trait
{
	scorch_shit = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_PYRO)
			&& (scorch_shit = find_wep_in_slot(player, "scorch_shot", 1))
	}

	function OnApply()
	{
		scorch_shit.AddAttribute("self dmg push force increased", 1.1, -1)
		scorch_shit.AddAttribute("hidden secondary max ammo penalty", 2 / 32.0, -1) // we use this attribute to override flare guns attribute, its actually using the shotgun ammo pool * .5
		scorch_shit.AddAttribute("blast dmg to self increased", 1.5, -1)
	}
})