characterTraitsClasses.push(class extends hsdm_trait
{
	dalokohs_bar = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_HEAVYWEAPONS)
			&& (dalokohs_bar = find_weps_in_slot(player, ["dalokohs_bar", "fishcake"], 1))
	}

	fed_once = false
	fed_twice = false

	// gain 400 max hp on eating dalokohs bar
	// goes back to 350 max hp when the lunchbox regens
	//  clever hack but what about when a player picks up a med pack at max hp, then it regens the lunchbox
	//  /shrug
	//  timers aren't too hard to make
	//  also this wont work if you're standing on a health pack when you eat right? xd
	//  just dont eat over health packs on ground duh
	//  k
	function OnFrameTickAlive()
	{
		local charge = GetPropFloatArray(player, "m_Shared.m_flItemChargeMeter", 1)

		if (!fed_twice
			&& player.GetActiveWeapon() == dalokohs_bar)
		{
			local charge_floor = floor(charge)
			if (charge_floor == 10)
			{
				dalokohs_bar.AddAttribute("max health additive bonus", 25, -1)
				fed_once = true
			}
			else if (charge_floor == 20)
			{
				dalokohs_bar.AddAttribute("max health additive bonus", 50, -1)
				fed_twice = true
			}
		}
		else if (fed_once && fed_twice && charge == 100)
		{
			fed_once = false
			fed_twice = false
			dalokohs_bar.RemoveAttribute("max health additive bonus")
		}
	}
})
non_crit_weapons.push("dalokohs_bar")