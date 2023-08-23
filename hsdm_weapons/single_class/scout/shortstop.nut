characterTraitsClasses.push(class extends hsdm_trait
{
	shortstop = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SCOUT)
			&& (shortstop = find_wep_in_slot(player, "shortstop", 0))
	}

	function OnApply()
	{
		change_weapon_damage(shortstop, 28.0 / 36.0) // max 112 damage, 28 dmg per pellet
		change_weapon_clip(shortstop, 1, 6.0)
		change_weapon_reserve(shortstop, TF_AMMO.PRIMARY, 0, 32.0, true)

		shortstop.AddAttribute("mult_spread_scales_consecutive", -1, -1) // spreads out like panic todo: test

		fix_shortstop(player, shortstop)
	}

	// bandaid solution for now
	function OnFrameTickAlive()
	{
		fix_shortstop(player, shortstop)
	}
})

gain_clip_on_hit_weapons.push("shortstop")
overfill_primaries.push("shortstop")

function fix_shortstop(player, shortstop)
{
	if (GetPropIntArray(player, "m_iAmmo", TF_AMMO.PRIMARY) > 0)
		SetPropIntArray(player, "m_iAmmo", 0, TF_AMMO.PRIMARY)

	if (shortstop.Clip1() > 2)
		shortstop.SetClip1(1)
}