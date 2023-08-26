// todo don't push these immediately to character traits, make revolver inherit from overfill_on_ammo_pickup maybe
characterTraitsClasses.push(class extends hsdm_trait
{
	revolver = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_SPY)
			&& (revolver = find_wep_in_slot(player, "revolver", 0))
	}

	function OnApply()
	{
		base_revolver(revolver)
	}
})
overfill_weapons.push("any_revolver")

function base_revolver(weapon)
{
	change_weapon_clip(weapon, 1, 6.0)
	change_weapon_reserve(weapon, TF_AMMO.SECONDARY, 2, 24.0, true)
}