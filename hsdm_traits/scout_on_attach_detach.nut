characterTraitsClasses.push(class extends hsdm_trait
{
	function CanApply()
	{
		return player.GetPlayerClass() == TF_CLASS_SCOUT
	}

	function OnAttach(player)
	{
		// reset double jump on attach
		SetPropInt(player, "m_Shared.m_iAirDash", 0)
	}
})