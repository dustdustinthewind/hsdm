characterTraitsClasses.push(class extends hsdm_trait
{
	minigun = null

	function CanApply()
	{
		return player_class_is(TF_CLASS_HEAVYWEAPONS)
			&& (minigun = find_wep_in_slot(player, "minigun", 0))
	}

	function OnApply()
	{
		base_minigun(minigun)
	}
})
// give minigun gain reserve on hit?
function base_minigun(weapon)
{
	change_weapon_damage(weapon, 17 / 27.0) // dmg per bullet
	change_weapon_reserve(weapon, TF_AMMO.PRIMARY, 30, 200.0)
}