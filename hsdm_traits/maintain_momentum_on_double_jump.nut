characterTraitsClasses.push(class extends hsdm_trait
{
	velocity_after_jump = null
	velocity_before_jump = null
	jump_status_last_frame = 0

	function CanApply()
	{
		return player_class_is(TF_CLASS_SCOUT)
	}

	function OnFrameTickAlive()
	{
		local jump_status_this_frame = GetPropInt(player, "m_Shared.m_iAirDash")
		if (jump_status_this_frame == 0 || jump_status_this_frame == jump_status_last_frame)
		{
			velocity_before_jump = velocity_after_jump
			velocity_after_jump = player.GetAbsVelocity()
			jump_status_last_frame = jump_status_this_frame
			return
		}
		jump_status_last_frame = jump_status_this_frame
		player.Yeet(velocity_before_jump * 0.5)
		// todo make this not as useful on lower velocities, scout can chase real easy now
	}
})