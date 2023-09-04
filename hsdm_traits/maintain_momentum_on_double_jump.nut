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
		local length = velocity_before_jump.Length()
		local slow = length < 600
		player.Yeet(velocity_before_jump * (slow ? 0 : 0.5))
		player.Yeet(Vector(0,0,velocity_before_jump.z * (slow ? 0 : -0.5)))
	}
})