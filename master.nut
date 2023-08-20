// run this to init script, use refresh.nut after making changes
// https://tf2maps.net/downloads/vscript-give_tf_weapon.14897/
IncludeScript("hsdm/thirdparty/give_tf_weapon/_master.nut") 

// Init	

Convars.SetValue("tf_grapplinghook_enable", 1)
Convars.SetValue("tf_use_fixed_weaponspreads", 1)
Convars.SetValue("mp_respawnwavetime", -1)
Convars.SetValue("tf_weapon_criticals", 0)
Convars.SetValue("tf_grapplinghook_los_force_detach_time", 9999) // prevents detaching from func_ entities
Convars.SetValue("tf_grapplinghook_use_acceleration", 1) // makes grapple more physical, required for enhanced grapple hook

::CTFPlayer.UsedGrappleLastTick <- false
::CTFPlayer.LastGrappleTarget <- null
::CTFPlayer.LastGrappleTargetCenter <- null
::CTFPlayer.ReelingIn <- false

::CTFPlayer.LastTimeReeled <- 0
::CTFPlayer.ReelDinged <- true

::CTFPlayer.LastDemoknightCrits <- false

::CTFPlayer.OptimalRopeLength <- 0

::CTFPlayer.GrappleProjectile <- null

::tickRateInSec <- 0.01499

// https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/VScript_Examples/en#Getting_the_userid_from_a_player_handle
::PlayerManager <- Entities.FindByClassname(null, "tf_player_manager");
::GetPlayerUserID <- function(player)
{
    return NetProps.GetPropIntArray(PlayerManager, "m_iUserID", player.entindex());
}

IncludeScript("hsdm/refresh.nut")

// TODO
//  find every reload id and put it into a table somewhere for easy access
//   why? if user is reloading, they will lose one in reserve ammo at end of animation,
//        even if they can't physically load that bullet into the clip. since this is gonna be a much bigger issue
//        if insta-clip-on-ammobox-pickup is enabled, lose one bullet for no reason :(, we want to cancel that loss
//        prolly by adding 1 to the reserve ammo, it can go over max :3
//	 NOTES: changes based on weapon type, i.e. scatterguns have different ids than double barrels like FAN
//          what if player cancels animation themselves? free ammo xd
//			spy's reload breaks the rules of other reloads and will reset his clip back to 1 even if higher fff		