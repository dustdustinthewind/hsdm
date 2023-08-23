::GTFW <- { "Version" : "5.3.0" }

//-----------------------------------------------------------------------------
// How to Use this Script in Your Maps
//--> To execute this script, make sure to place these files in directory `/tf/scripts/vscripts/`
//--> Then to execute this script in a map, make an entity with "vscripts" keyvalue, and place `give_tf_weapon/_master.nut` as the parameter
//--> Alternatively, you can test it in any map through console by typing `script_execute give_tf_weapon/_master`
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
/*	-> Required Settings for your map: <-

->	"post_inventory_application" event is sent when a player gets a whole new set of items, aka touches a resupply locker / respawn cabinet or spawns in.
	If you are using this event in your own VScripts, make sure to copy the give_tf_weapon function(s) if you plan on using this script.
	There can only be one OnGameEvent listener total, so the following events must be added:
->	"hPlayer.GTFW_Cleanup" deletes any parented entities on the player made by this script.
->	"hPlayer.LoadLoadout" loads weapons after touching resupply or respawning. */

	ClearGameEventCallbacks()	//Clears any pre-existing OnGameEvent listeners. WARNING: If using other events, probably put this function at the top of your script and disable it here.

function OnGameEvent_post_inventory_application(params)	//Defines post_inventory_application event listener
{
	if ("userid" in params)
	{
	//Defines player handle as hPlayer
		local hPlayer = GetPlayerFromUserID(params.userid)

	// REQUIRED ( Must be at the beginning! )
		hPlayer.GTFW_Cleanup()	// Deletes any parented entities on the player made by this script.
	// OPTIONAL ( Can be placed at beginning )
		EntFireByHandle(hPlayer,"RunScriptCode","self.LoadLoadout()",0.0,hPlayer,hPlayer);	// Allows for weapons to persist between touching the resupply. (as long as the weapon was saved when grabbed!)
	}
}
	__CollectGameEventCallbacks(this)	// Adds all listeners defined to the roottable to make them work!


//-----------------------------------------------------------------------------
//	GiveWeapon() default options
//-----------------------------------------------------------------------------
// This utilizes bits to denote different function in a single number.
// Here are the properties below:
::DeleteAndReplace <-	(1 << 0)	// Deletes weapon that matches the slot of the new weapon, then adds the new weapon. Not compatible with KeepIDX bit. NOTE: Cannot switch to another weapon in the same slot, unless using "hud_fastswitch 0".
::KeepIDX <-			(1 << 1)	// Only updates the Item Definition Index of the given weapon. Not compatible with DeleteAndReplace bit. Added for MvM to allow for custom weapons to be upgradeable.
::AutoSwitch <-			(1 << 2)	// Forcefully switches to the weapon if obtained.
::WipeAttributes <-		(1 << 3)	// Clears original attributes present on the weapon.
::ForceCustom <-		(1 << 4)	// Forces the weapon to be custom (which means netprop "ItemIDHigh" bit 6 set)
::ForceNotCustom <-		(1 << 5)	//  Makes sure to remove flags that make a weapon custom. (Also used by GetItemID() in parameter 2 to remove custom bits)
::AnnounceToChat <- 	(1 << 6)	// Announces the weapon in chat for all to see what you got!
::Save <- 				(1 << 7)	// Saves the weapon, allowing players to retrieve it as long as function "handle.LoadLoadout()" is used.
::AutoRegister <- 		(1 << 8)	// Automatically registers the weapon if it hasn't been already registered. Use with caution!

//Add up the bits that you want to use as your defaults for weapons.
// Whenever you use GiveWeapon(), it'll enforce these defaults.
// Feel free to add the ones above or remove some. I don't care.
//-----------------------------------------------------------------------------
//Defaults: DeleteAndReplace + AutoSwitch + Save
//To remove all, write: 0
::Defaults <- DeleteAndReplace|AutoSwitch|Save


//-----------------------------------------------------------------------------
//	VScript CVars
//-----------------------------------------------------------------------------
Convars.SetValue("tf_dropped_weapon_lifetime", 0)	//disables dropped weapons because they're buggy with this script
::CVAR_GTFW_DEBUG_MODE <- false		// Sends error messages to everyone. False by default.

// If debug mode is on, reset registry for custom weapons
if ( CVAR_GTFW_DEBUG_MODE )
	::TF_CUSTOM_WEAPONS_REGISTRY <- {};

::CVAR_USE_VIEWMODEL_FIX <- true				// Automatically fixes any and all viewmodel arms to match the class you're playing as. True by default.
::CVAR_DELETEWEAPON_AUTO_SWITCH <- true			// Automatically switches weapon to another if deleting a weapon. True by default.
::CVAR_DISABLEWEAPON_AUTO_SWITCH <- true		// Automatically switches weapon to another if disabling a weapon. True by default.
::CVAR_ENABLEWEAPON_AUTO_SWITCH <- false		// Automatically switches weapon to another if re-enabling a weapon. False by default.

//-----------------------------------------------------------------------------
//	Included Scripts
//-----------------------------------------------------------------------------

//IncludeScript("give_tf_weapon/extra/text_listener.nut")		//Optional chat command "!give"
Include("give_tf_weapon/libs/netpropperf.nut")	//according to ficool2, reduces NetProps runtime by some-20%!
Include("give_tf_weapon/code/__exec.nut")			// Executes all functions that this script uses!
Include("give_tf_weapon/custom_weapons/_all.nut")	// Executes all custom weapons written in the file!