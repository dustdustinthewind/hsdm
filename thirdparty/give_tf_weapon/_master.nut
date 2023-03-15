// How to Use this Script in Your Maps
//--> To execute this script, make sure to place these files in directory `/tf/scripts/vscripts/`
//--> Then to execute this script in a map, make an entity with "vscripts" keyvalue, and place `give_tf_weapon/_master`
//--> Alternatively, you can test it in any map through console by typing `script_execute give_tf_weapon/_master`


//NOTE: Given weapons don't delete themselves on respawn.
// The following event need to be in your game for this to clean the weapons up.
// However, there can only be one event listener stored total, so in order to not conflict with another you need the cleanup function inside it.

//"post_inventory_application" event is sent when a player gets a whole new set of items, aka touches a resupply locker / respawn cabinet or spawns in.
// Add "hPlayer.GTFW_Cleanup" to your script to clean weapons up.
// -> Remember to change the handle.
//function OnGameEvent_post_inventory_application(params)
//{
//	if ("userid" in params)
//	{
//		local hPlayer = GetPlayerFromUserID(params.userid)
//		hPlayer.GTFW_Cleanup()	//<-Add this to your own post_inventory_application event. It must be at the beginning!
//	}
//}
//	__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)	//<-- Must be after ANY OnGameEvent!
	
// The prior event should be deleted so it doesn't conflict with another `post_inventory_application` event. //
// Include the rest of this script! //


//vscript cvars. Adjust how you like, to customize the script easily.
::CVAR_GTFW_USE_GLOBAL_ERROR_MESSAGES <- false		// Sends error messages to everyone. If false, sends it only if a client has `developer` level set. False by default.
::CVAR_GTFW_GIVEWEAPON_REPLACE_WEAPONS <- true		//if true, overwrites current weapon in slot. True by default. NOTE: Cannot use more than two weapons in a slot, unless using "hud_fastswitch 0".
::CVAR_GTFW_USE_VIEWMODEL_FIX <- true				//Automatically fixes any and all viewmodel arms to match the class you're playing as. True by default.
::CVAR_GTFW_GIVEWEAPON_AUTO_SWITCH <- true			// Automatically switches weapon to another if giving a weapon. True by default.
::CVAR_GTFW_DELETEWEAPON_AUTO_SWITCH <- true		// Automatically switches weapon to another if deleting a weapon. True by default.
::CVAR_GTFW_DISABLEWEAPON_AUTO_SWITCH <- true		// Automatically switches weapon to another if disabling a weapon. True by default.
::CVAR_GTFW_ENABLEWEAPON_AUTO_SWITCH <- false		// Automatically switches weapon to another if re-enabling a weapon. False by default.
Convars.SetValue("tf_dropped_weapon_lifetime", 0)	//disables dropped weapons because they're buggy with this script

IncludeScript("hsdm/thirdparty/give_tf_weapon/tables.nut")	// All TF2 weapons listed in tables
IncludeScript("hsdm/thirdparty/give_tf_weapon/code.nut")	// All give_tf_weapon code
//IncludeScript("thirdpargive_tf_weapon/custom_weapons.nut")	// All custom weapons
