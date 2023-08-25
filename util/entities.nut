::hsdm_vscript <- this

::team_round_timer <- null

function SpawnEntities()
{
	// timer that calls tick every frame i think
	team_round_timer = SpawnEntityFromTable("team_round_timer", {
		StartDisabled = 0
	}) // todo mess with values?
	team_round_timer.ValidateScriptScope()
	team_round_timer.GetScriptScope().Tick <- function()
	{
		hsdm_vscript.FireListeners("tick_frame")
		return 0
	}
	AddThinkToEnt(team_round_timer, "Tick")
}
SpawnEntities()