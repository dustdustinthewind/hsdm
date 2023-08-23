class hsdm_trait extends CharacterTrait
{
	function OnItemPickup(player, params) { }
	function OnSwapWeapon(player, weapon) { }
	function OnDetach(player) { }
	function OnAttach(player) { }
}

AddListener("item_pickup", -1, function(params)
{
	foreach (characterTrait in characterTraits[player])
		try { characterTrait.OnItemPickup.call(characterTrait, player, params) }
		catch(e) { throw e }
})

AddListener("swap_weapon", -1, function(player, weapon)
{
	foreach (characterTrait in characterTraits[player])
		try { characterTrait.OnSwapWeapon.call(characterTrait, player, weapon) }
		catch(e) { throw e }
})

AddListener("on_detach", -1, function(player)
{
	foreach (characterTrait in characterTraits[player])
		try { characterTrait.OnDetach.call(characterTrait, player) }
		catch(e) { throw e }
})

AddListener("on_attach", -1, function(player)
{
	foreach (characterTrait in characterTraits[player])
		try { characterTrait.OnAttach.call(characterTrait, player) }
		catch(e) { throw e }
})