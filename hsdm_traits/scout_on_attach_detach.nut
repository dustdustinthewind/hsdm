// todo make hype effect grapple speed
characterTraitsClasses.push(class extends hsdm_trait
{
	function CanApply()
	{
		// baby's face does not double jump grapple
		return player.GetPlayerClass() == TF_CLASS_SCOUT
			&& (!find_wep_in_slot(player, "baby_faces_blaster", 0))
	}

	function OnAttach(player)
	{
		// reset double jump on attach
		SetPropInt(player, "m_Shared.m_iAirDash", 0)
	}
})