characterTraitsClasses.push(class extends hsdm_trait
{
	bazaar_bargain = null

	function CanApply()
	{
		printl(player.GetWeaponBySlot(0))
		return player_class_is(TF_CLASS_SNIPER)
			&& (bazaar_bargain = find_wep_in_slot(player, "bazaar_bargain", 0))
	}

	function OnApply()
	{
		base_sniper_rifle(bazaar_bargain)
	}
})