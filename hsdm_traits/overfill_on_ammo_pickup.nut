characterTraitsClasses.push(class extends hsdm_trait
{
	bonus = 1

	function CanApply()
	{
		if (find_weps(player, overfill_weapons))
			return true

		return false
	}

	initial_lower = false

	function OnApply()
	{
		initial_lower = false
	}

	function OnFrameTickAlive()
	{
		if (!initial_lower)
		{
			initial_lower = true
			lower_both_reserves(player)
		}
	}

	function OnItemPickup(player, params)
	{
		if (params.item.find("ammo") == null) return

		foreach (weapon in overfill_weapons)
		{
			local wep
			if (wep = find_wep_in_slots(player, weapon, 0, 1))
			{
				local revolver = weapon == "any_revolver"
				if (revolver) bonus = 3 // dumb fucking hack
				else bonus = 1
				increase_clip(wep, params.item == "ammopack_large" || revolver)
			}
		}

		lower_both_reserves(player)
	}

	function increase_clip(weapon, overfill)
	{
		if (weapon && weapon.Clip1() < weapon.GetMaxClip1() + (overfill ? bonus : 0))
			weapon.SetClip1(weapon.Clip1() + 1)
	}
})

function lower_both_reserves(player)
{
	if (find_weps_in_slot(player, overfill_weapons, 0))
		lower_reserve_by_one(player, TF_AMMO.PRIMARY)
	if (find_weps_in_slot(player, overfill_weapons, 1) || find_wep_in_slot(player, "any_revolver", 0))
		lower_reserve_by_one(player, TF_AMMO.SECONDARY)
}

function lower_reserve_by_one(player, ammo)
{
	SetPropIntArray(player, "m_iAmmo", GetPropIntArray(player, "m_iAmmo", ammo) - 1, ammo)
}

overfill_weapons <- [""]
overfill_melee_hack <- [""]