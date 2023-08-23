// makes specific classes "rocket jumping" whenever they grapple
// this should fix the direct hit not consistently mini-critting grappling players (i assume it only minicrits if they are currently grappling, who cares)
characterTraitsClasses.push(class extends hsdm_trait
{
	function CanApply()
	{
		// heavy and soldier get resistance to minicrits (soldier so he still has to rocket jump for mg, heavy cause heavy)
		return player.GetPlayerClass() != TF_CLASS_SOLDIER && player.GetPlayerClass() != TF_CLASS_HEAVYWEAPONS
	}

	function OnAttach(player)
	{
		player.AddCond(81) // blast jumping when attach
	}
})