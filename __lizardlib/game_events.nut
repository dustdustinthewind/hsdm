//=========================================================================
//Copyright LizardOfOz.
//
//Credits:
//  LizardOfOz - Programming, game design, promotional material and overall development. The original VSH Plugin from 2010.
//  Maxxy - Saxton Hale's model imitating Jungle Inferno SFM; Custom animations and promotional material.
//  Velly - VFX, animations scripting, technical assistance.
//  JPRAS - Saxton model development assistance and feedback.
//  MegapiemanPHD - Saxton Hale and Gray Mann voice acting.
//  James McGuinn - Mercenaries voice acting for custom lines.
//  Yakibomb - give_tf_weapon script bundle (used for Hale's first-person hands model).
//=========================================================================

// modified for hsdm by dust

//
function IsNotValidRound()
{
	return IsInWaitingForPlayers()
}

//
function IsValidRound()
{
	return !IsNotValidRound()
}

function OnPostSpawn()
{
    RecachePlayers();
    if (IsValidRoundPreStart())
        FireListeners("setup_start");
}

// changed tick from .1 to .014999 (1 / 66.67)
function Tick()
{
    //try { TF_TEAM_MERCS; } catch(e) { return; }

    if (IsValidRound())
        FireListeners("tick_only_valid", 0.014999); // assuming 66 tick server
    FireListeners("tick_always", 0.014999);

    return 0;
}

function OnScriptHook_OnTakeDamage(params)
{
	// removed wall climb code
    FireListeners("damage_hook", params.attacker, params.const_entity, params);
}

function OnGameEvent_player_hurt(params)
{
    if (IsNotValidRound())
        return;
    local victim = GetPlayerFromParams(params);
    if (!IsValidPlayer(victim))
        return;
    local attacker = GetPlayerFromParams(params, "attacker");
    if (!IsValidPlayer(attacker))
        return;
    FireListeners("player_hurt", attacker, victim, params);
}

function OnGameEvent_player_team(params)
{
    if (IsNotValidRound())
        return;
    local player = GetPlayerFromUserID(params["userid"]);
    if (player == null || !player.IsValid() || !player.IsPlayer())
        return;
    FireListeners("team_change", player, params);
}

function OnGameEvent_player_changeclass(params)
{
    if (IsNotValidRound())
        return;
    local player = GetPlayerFromParams(params);
    if (!IsValidPlayer(player))
        return;
    FireListeners("class_change", player, params);
}

function OnGameEvent_player_spawn(params)
{
    if (IsInWaitingForPlayers() || IsNotValidRound())
        return;
    local player = GetPlayerFromParams(params);
    if (!IsValidPlayer(player))
        return;
    FireListeners("spawn", player, params);
}

function OnGameEvent_player_death(params)
{
    if (params.death_flags & TF_DEATHFLAG.DEAD_RINGER || IsNotValidRound())
        return;
    local player = GetPlayerFromParams(params);
    if (!IsValidPlayer(player))
        return;
    local attacker = GetPlayerFromParams(params, "attacker");
    FireListeners("death", attacker, player, params);
}

function OnGameEvent_object_destroyed(params)
{
    if (IsNotValidRound())
        return;
    local attacker = GetPlayerFromParams(params, "attacker");
    if (!IsValidPlayer(attacker))
        return;
    FireListeners("builing_destroyed", attacker, params);
}

function OnGameEvent_rps_taunt_event(params)
{
    local winner = PlayerInstanceFromIndex(params.winner);
    local loser = PlayerInstanceFromIndex(params.loser);
    if (!IsValidBoss(winner) && !IsValidBoss(loser))
        return;
    FireListeners("rps_with_boss", winner, loser, params);
}

function FinishSetup()
{
    //todo Hale-specific check to fix Class-Restricted Duels bug.
    local boss = GetRandomBossPlayer();
    if (boss != null && boss.GetPlayerClass() != TF_CLASS_HEAVY && !IsRoundOver())
    {
        boss.RemoveCond(TF_COND_STUNNED);
        boss.RemoveCond(TF_COND_TAUNTING);
        DiscardTraits(boss);
        characterTraits[boss] <- [];
        hudAbilityInstances[boss] <- [];
        boss.ForceRespawn();
        RefreshBossSetup(boss);
        bosses[boss].TryApply(boss);

        RunWithDelay2(this, 1, function (boss)
        {
            if (boss.GetPlayerClass() == TF_CLASS_HEAVY)
                return;
            boss.TakeDamage(999999, 0, null);
            EndRound(TF_TEAM_UNASSIGNED);
        }, boss)
    }
    FireListeners("setup_end");
    isRoundSetup = false;
}

function OnGameEvent_post_inventory_application(params)
{
    local player = GetPlayerFromParams(params);
    if (!IsValidClient(player))
        return;
    player.GTFW_Cleanup();
    FireListeners("post_inventory", player, params);
}

function OnGameEvent_player_disconnect(params)
{
    local player = GetPlayerFromParams(params);
    if (!IsValidClient(player))
        return;
    FireListeners("disconnect", player, params);
}

//
function OnGameEvent_item_pickup(params)
{
	local player = GetPlayerFromParams(params)
	FireListeners("item_pickup", player, params)
}

//
function OnGameEvent_teamplay_round_start(params)
{
	SpawnEntities()
}