// run this to init script, use refresh.nut after making changes

// Init	

Convars.SetValue("tf_grapplinghook_enable", 1)
Convars.SetValue("tf_use_fixed_weaponspreads", 1)
Convars.SetValue("mp_respawnwavetime", -1)
Convars.SetValue("tf_weapon_criticals", 0)
Convars.SetValue("tf_grapplinghook_los_force_detach_time", 9999) // prevents detaching from func_ entities

Convars.SetValue("tf_grapplinghook_use_acceleration", 1)
Convars.SetValue("tf_grapplinghook_move_speed", 1250)
Convars.SetValue("tf_grapplinghook_acceleration", 750)
Convars.SetValue("tf_grapplinghook_dampening", 200)

::CTFPlayer.LastGrappleTarget <- null
::CTFPlayer.LastDemoknightCrits <- false

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