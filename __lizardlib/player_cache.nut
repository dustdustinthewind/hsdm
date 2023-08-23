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
// removed all references to mercs

::validClients <- [];
::validPlayers <- [];
::alivePlayers <- [];

::RecachePlayers <- function()
{
    local validClientsL = [];
    local validPlayersL = [];
    local alivePlayersL = [];
    for (local i = 1; i <= MAX_PLAYERS; i++)
    {
        local player = PlayerInstanceFromIndex(i);
        if (IsValidClient(player))
        {
            validClientsL.push(player);
            if (player.GetTeam() > TF_TEAM_SPECTATOR)
            {
                validPlayersL.push(player);

                local isAlive = IsPlayerAlive(player);

                if (isAlive)
                    alivePlayersL.push(player);
            }
        }
    }
    validClients = validClientsL;
    validPlayers = validPlayersL;
    alivePlayers = alivePlayersL;
};
AddListener("tick_frame", -9999, RecachePlayers);
AddListener("tick_always", -9999, function(tickDelta)
{
    RecachePlayers();
});
AddListener("disconnect", -9999, function(player, params)
{
    RecachePlayers();
});

::GetValidClients <- function()
{
    return validClients;
}

::GetValidPlayers <- function()
{
    return validPlayers;
}

::GetValidPlayerCount <- function()
{
    return validPlayers.len();
}

::GetAlivePlayers <- function()
{
    return alivePlayers;
}