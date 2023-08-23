characterTraitsClasses.push(class extends hsdm_trait
{
	widowmaker = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_ENGINEER)
			&& (widowmaker = find_wep_in_slot(player, "widowmaker", 0))
	}

	// todo make reparing/upgarding possible with widow engie, or dont maybe this is fine
	function OnApply()
	{
		base_shotgun(player, widowmaker, false)
		widowmaker.AddAttribute("maxammo metal reduced", 0.2, -1)
		widowmaker.AddAttribute("building cost reduction", 0.2 - 0.005, -1) // small adjustment to fix rounding errors
		//widowmaker.AddAttribute("Repair rate increased", 1.2, -1) // don't think it works? (maybe apply shit to the wrench?)
	}
})