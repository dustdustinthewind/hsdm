characterTraitsClasses.push(class extends hsdm_trait
{
	primary = null
	secondary = null

	bonus = 1

	function CanApply()
	{
		foreach (overfill_primary in overfill_primaries)
			if (primary = find_wep(player, overfill_primary)) // tried using in_slot but it didn't work
				break
		foreach (overfill_secondary in overfill_secondaries)
			if (secondary = find_wep(player, overfill_secondary))
				break

		return primary || secondary
	}

	picked_up_this_frame = false

	function OnItemPickup(player, params)
	{
		if (picked_up_this_frame || params.item.find("ammo") == null) return

		increase_clip(params.item == "ammopack_large")

		if (primary)
			lower_reserve_by_one(player, TF_AMMO.PRIMARY)
		if (secondary)
			lower_reserve_by_one(player, TF_AMMO.SECONDARY)

		picked_up_this_frame = true
	}

	function OnFrameTickAlive()
	{
		picked_up_this_frame = false
	}

	function increase_clip(overfill)
	{
		if (primary && primary.Clip1() < primary.GetMaxClip1() + (overfill ? bonus : 0))
			primary.SetClip1(primary.Clip1() + 1)

		// primary != secondary consequence of not being able to use in_slot in CanApply()
		if (secondary && primary != secondary && secondary.Clip1() < secondary.GetMaxClip1() + (overfill ? bonus : 0))
			secondary.SetClip1(secondary.Clip1() + 1)
	}
})

function lower_reserve_by_one(player, ammo)
{
	printl("called")
	SetPropIntArray(player, "m_iAmmo", GetPropIntArray(player, "m_iAmmo", ammo) - 1, ammo)
}

overfill_primaries <- [""]
overfill_secondaries <- [""]
overfill_melee_hack <- [""]