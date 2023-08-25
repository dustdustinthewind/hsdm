characterTraitsClasses.push(class extends hsdm_trait
{
	function CanApply()
	{
		return player.GetPlayerClass() == TF_CLASS_HEAVYWEAPONS
	}

	function OnDetach(player)
	{
		// heavy jump-detach fix (allow heavy to jump detach like the rest of the cast)
		local jump = GetPropInt(player, "m_nButtons") & IN_JUMP ? HEAVY_JUMP_DETACH_SPEED : 0
		player.Yeet(Vector(0, 0, jump))

		// heavy fix getting stuck on hookshot when no ammo
		local ammo = GetPropIntArray(player, "m_iAmmo", TF_AMMO.PRIMARY)
		if (player.GetLastWeapon() == player.ReturnWeaponBySlot(0) && ammo <= 0)
			player.Weapon_Switch(player.ReturnWeaponBySlot(2)); // swap to melee
	}
})