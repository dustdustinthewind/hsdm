characterTraitsClasses.push(class extends hsdm_trait
{
	function CanApply()
	{
		return player.GetPlayerClass() == TF_CLASS_SNIPER
	}

	function OnAttach(player)
	{
		// on attach turn off jumping
		// allows us to scope in after grappling
		SetPropInt(player, "m_Shared.m_bJumping", 0)
	}
})