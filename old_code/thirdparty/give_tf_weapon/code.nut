//--> To execute this script, make sure to place it in directory `/tf/scripts/vscripts/`
//--> Then to execute this script in a map, make an entity with "vscripts" keyvalue, and place `give_tf_weapon/_master`
//--> Alternatively, you can test it in any map through console by typing `script_execute give_tf_weapon/_master`

/*vScript "give_tf_weapon" (originally giveweapon.nut) framework for Team Fortress 2, by Yaki
Special thanks ficool2 for finding the netprops to make the first weapon giving function, AddWeapon().
Special thanks Mr.Burguers (TF2Maps) for being a wealth of knowledge, teaching me how to use vscripts.
Special thanks devs of Super Zombie Fortress + SCP Secret Fortress for releasing their source code. (taught me what netprops were needed for custom viewmodels)
Special thanks for those who sent bug reports (Lizard of Oz, SpookyToad), and the rest!

Notes to Users
 - Set CVAR_GTFW_* for easy tweaking of script.
 - When using GiveWeapon, weapon strings for unlocks don't need "The " in them. (i.e. "The Sandvich" is invalid, but "Sandvich" is acceptable)
 --> Also accepts handles, as well as item index values (from items_game.txt)
 - GiveWeapon also returns the weapon as a handle. So you can add attributes to the weapon!
 - Given/Custom weapons don't delete themselves on respawn. 
 ->Add function `CTFPlayer.GTFW_Cleanup` to your `post_inventory_application` event to delete any unused weapons/viewmodels attached to the player.
 --> Please place at the beginning!
 --> Needs a player handle to clear weapons from.
	
Clarification
		-> CTFPlayer = handle ID for your player's entity (aka player's serial number), called hPlayer all throughout examples.
	The following list are acceptable parameters for searching for weapons:
		-> Handles (aka the weapon ID's serial number)
		-> Classnames of weapons (i.e. "tf_weapon_wrench")
		-> items_game.txt weapon IDs are 0 and above (i.e. 7) (7 is the stock wrench)
		-> Slots, using TF_WEAPONSLOTS with slot type. 
			-> TF_WEAPONSLOTS.PRIMARY, for example, gets all slots in the primary slot.
			Also acceptable:
			TF_WEAPONSLOTS.SECONDARY
			TF_WEAPONSLOTS.MELEE
			TF_WEAPONSLOTS.SLOT3 = Engineer's "Build PDA", Spy's "Disguise Kit PDA"
			TF_WEAPONSLOTS.SLOT4 = Engineer's "Destroy PDA", Spy's watches
			TF_WEAPONSLOTS.SLOT5 = Engineer toolbox, sapper (both stock are "tf_weapon_builder", sapper unlocks are "tf_weapon_sapper")
			TF_WEAPONSLOTS.SLOT6 = spellbook, grappling hook. (PASSTIME gun?)


PUBLIC OPERATIONS
 Made to make giving weapons, easy! Also supports custom weapons!
	CheckItems()
		Checks your current equipment, with item IDs. Spits out a list in chat with active weapon on top.
	CTFPlayer.GiveWeapon(weapon)
		Gives you a weapon. Any weapon, as long as the entity and ID match from items_game.txt.
		Returns `weapon` as handle.
	CTFPlayer.DeleteWeapon(weapon)
		Deletes a weapon from the player.
		Returns true if weapon was deleted, else false.
	CTFPlayer.DisableWeapon(weapon)
		Removes all ammo from a weapon, and sets ammo clip + reserve for that weapon to 0.
		Returns `weapon` as handle.
	CTFPlayer.EnableWeapon(weapon)
		Resets ammo capacity, allowing player to grab ammo again.
		Returns `weapon` as handle.
	CTFPlayer.ReturnWeapon(weapon)
		Searches weapon on player and returns as a handle.
	CTFPlayer.ReturnWeaponTable(weapon)
		Find item on player by string, item ID, classname, slot, or handle. Else null.
		Returns a table with all properties found in `class TF_WEAPONS_BASE` (in `tables.nut`)
	CTFPlayer.ReturnWeaponBySlot
		Finds an equip by slot. 0 = Primary, 1 = Secondary, etc. Up to 6. Returns null if failed.
	RegisterCustomWeapon(item_name, baseitem, use_original_stats, stats_function, custom_arms_model, custom_weapon_model)
		Registers a custom weapon into the database.
		Any parameters unused should be passed as `null`.
	RegisterCustomWeaponEx(item_name, baseitem, use_original_stats, stats_function, custom_arms_model, custom_weapon_worldmodel, custom_weapon_viewmodel, custom_extra_wearable, ammotype, clipsize, ammoreserve)
		Registers a custom weapon into the database, with extra parameters.
		Any parameters unused should be passed as `null`.
	CTFPlayer.SwitchToActive(weapon)
		Finds a weapon to switch to and switches to it. If null, switches to the best valid gun, or if no gun is found, melee, or else, any.
		Note: VScript has a built-in function Weapon_Switch, which this uses.
	CTFPlayer.CreateCustomWearable(weapon, wearable_model)
		Creates a `tf_wearable` and associates it with a weapon (if valid)
		`weapon` accepts arg `null`.
	CTFPlayer.CreateArmsModel(arms_model)
		EXPERIMENTAL: Changes the class' arms model.
		Probably don't use this unless your ent count to skyrocket per player using this. Each weapon VM needs an ent to make this work!
		You need to update it every time the player touches the resupply.
		Returns arms_model as handle.
		
		
PRIVATE OPERATIONS
 Functions used only in this file or debugging. Don't use unless you know what you're doing.
	GetItemID(weapon)
		Returns netprop `m_iItemDefinitionIndex`, if valid.
		If the weapon is custom, sets bit 20 on ItemID.
		Else returns null.
	KillWepAll(weapon)
		Deletes weapon, and all wearables/associated items by that weapon.
	CTFPlayer.HasGunslinger()
		Checks if wearer is using the Gunslinger, but only for Engineer.
	CTFPlayer.AddWeapon(classname, itemindex, slot)
		Use if you want a specific weapon in a specific slot.
	CTFPlayer.UpdateArms()
		Updates all arm models for all equipped weapons. Branches from `GiveWeapon`.
	CTFPlayer.UpdateWeapon(weapon, w_model, v_model)
		Updates a weapon if it is custom or unintended for the class. Branches from `GiveWeapon`.
	CTFPlayer.AddThinkToViewModel()
		Updates the think script on tf_viewmodel. Branches from `GiveWeapon`.
	CTFPlayer.GTFW_CreateCustomWeaponModel(wearabletype, baseitem, weapon_model)
		Multiple functions. Creates tf_wearables and parents them to the player.
			wearabletype = bool, true for making tf_wearable, false for making tf_wearable_vm
			baseitem = your base item's handle. Accepts null or main_viewmodel handle for making class arms only.
			weapon_model = model.mdl
		Returns handle of the entity it creates
	GTFW_WepFix(table, player)
		Updates classnames for shotguns, pistols, saxxy, etc, before creating the weapon.
		Returns param 'table'
	ReturnWeaponBySlotBool(weapon, slot)
		Finds equip if `weapon.GetSlot()` matches `slot` parameter. Returns true if found, false if else.
	GTFW_ReturnWeaponBySlotBool(weapon, slot)
		Same as `ReturnWeaponBySlotBool`, but param `slot` takes negatives instead.
	GTFW_SearchEquipReg(string_or_id)
		Find item by string or item ID. Don't use on its own because it doesn't have PostWepFix. Used by `CTFPlayer.ReturnWeaponTable`

Examples of Uses
	CheckItems()
		USE: In console, type "script CheckItems()" (without quotes)
			Shows slot, classname, and ID of all equipped weapons
	CTFPlayer.GiveWeapon(weapon_id_or_string)
		USE: hPlayer.GiveWeapon("Minigun")
			Gives player the stock minigun.
		USE: hPlayer.GiveWeapon(15)
			Gives player the stock Minigun.
	CTFPlayer.DeleteWeapon(weapon_handle_or_classname_or_id_or_string)
		USE: hPlayer.DeleteWeapon("MySuperCoolCustomWeapon")
			Deletes handle named MySuperCoolCustomWeapon
		USE: hPlayer.DeleteWeapon("tf_weapon_minigun")
			Deletes only miniguns
		USE: hPlayer.DeleteWeapon("Minigun")
			Deletes only stock Minigun
		USE: hPlayer.DeleteWeapon(15)
			Deletes only stock Minigun with this ID
		USE: hPlayer.DeleteWeapon(TF_WEAPONSLOTS.PRIMARY)
			Deletes all primaries
		USE: hPlayer.DeleteWeapon(TF_WEAPONSLOTS.MELEE)	
			Deletes all melees
	CTFPlayer.DisableWeapon(weapon_classname_or_id_or_string)
		USE: hPlayer.DisableWeapon(TF_WEAPONSLOTS.SECONDARY) 
			Removes all ammo from any secondary.
		USE: hPlayer.DisableWeapon("Minigun")
			Removes all ammo from the minigun
	RegisterCustomWeapon()
		--> See examples in `give_tf_weapon/custom_weapons.nut`
	RegisterCustomWeaponEx()
		--> See examples in `give_tf_weapon/custom_weapons.nut`


End instructions */

///-------------------------------------///

::PlayerLoadoutGlobal_BonemergedArms <- {}
::PlayerLoadoutGlobal_CustomWeaponModels_VM <- {}
::PlayerLoadoutGlobal_CustomWeaponModels_TP <- {}
::PlayerLoadoutGlobal_AmmoFix <- {}


PrecacheModel("models/weapons/c_models/c_engineer_gunslinger.mdl")

const GLOBAL_WEAPON_COUNT = 7
::DEVMSG <- " --> "



//-----------------------------------------------------------------------------
// Purpose: Prints error messages
//-----------------------------------------------------------------------------
::GTFW_DevPrint <- function(message)
{
	if ( CVAR_GTFW_USE_GLOBAL_ERROR_MESSAGES )
	{
		printl(message)
	}
}


//-----------------------------------------------------------------------------
// Purpose: Used by events to clean up any unused entities made by this script.
//-----------------------------------------------------------------------------
::CTFPlayer.GTFW_Cleanup <- function()
{
	// Deletes any viewmodels that the script has created
	local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
	AddThinkToEnt(main_viewmodel, null)	//clears script if it was being used
	if ( main_viewmodel && main_viewmodel.FirstMoveChild() )
	{
		main_viewmodel.FirstMoveChild().Kill()
	}
	main_viewmodel.SetModelSimple( GTFW_MODEL_ARMS[this.GetPlayerClass()] )
	for (local i = 0; i < 42; i++)
	{
		local wearable = Entities.FindByNameWithin(this, "tf_wearable_vscript", this.GetLocalOrigin(), 128)

		if ( wearable && wearable.GetOwner() == this )
		{
			GTFW_DevPrint("Deleting wearable... "+wearable+" Model# "+NetProps.GetPropInt(wearable, "m_nModelIndex") )

			wearable.Kill()
		}
		else
		{
			break
		}
	}
//clears all custom weapons
	::PlayerLoadoutGlobal_CustomWeaponModels_VM[this] <- {}
	::PlayerLoadoutGlobal_CustomWeaponModels_TP[this] <- {}
	if ( this in PlayerLoadoutGlobal_BonemergedArms ) {
		delete PlayerLoadoutGlobal_BonemergedArms[this]
	}
	if ( this in PlayerLoadoutGlobal_AmmoFix ) {
		delete PlayerLoadoutGlobal_AmmoFix[this]
	}
	
}


//-----------------------------------------------------------------------------
// Purpose: Deletes weapons and all wearables tied to it.
//-----------------------------------------------------------------------------
::KillWepAll <- function(wep=null)
{
	if ( wep == null ) {
		GTFW_DevPrint("give_tf_weapon ERROR: KillWepAll failed. Parameter is null.")
		return null
	}
	local wearable = NetProps.GetPropEntity(wep, "m_hExtraWearable")
	if ( wearable ) {
		wearable.Kill()
	}
	wearable = NetProps.GetPropEntity(wep, "m_hExtraWearableViewModel")
	if ( wearable ) {
		wearable.Kill()
	}
	wep.Kill()
}


//-----------------------------------------------------------------------------
// Purpose: For testing if weapon is custom or is unintended
// If "bool" set to "true", adds the flag to make the weapon either custom or unintended weapon
//-----------------------------------------------------------------------------
::IS_CUSTOM <- function(weapon=null, bool=false)
{
	if ( weapon == null || type( bool ) != "bool" ) {
		GTFW_DevPrint("give_tf_weapon ERROR: IS_CUSTOM failed. Invalid parameters. Returning null.")
		return null
	}
	
	local CUSTOM_ID = abs(NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemIDHigh"))
	
	if ( bool ) {
		NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemIDHigh", abs(CUSTOM_ID) | (1 << 6) )	//means our weapon is custom
	}
	if ( CUSTOM_ID & (1 << 6) ) {
		return true
	}
	else { return false }
}
::IS_UNINTENDED <- function(weapon=null, bool=false)
{
	if ( weapon == null || type( bool ) != "bool" ) {
		GTFW_DevPrint("give_tf_weapon ERROR: IS_UNINTENDED failed. Invalid parameters. Returning null.")
		return null
	}
	
	local UNINTENDED_ID = abs(NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemIDHigh"))
	
	if ( bool ) {
		NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemIDHigh", abs(UNINTENDED_ID) | (1 << 5) )	//means our weapon is unintended
	}
	if ( UNINTENDED_ID & (1 << 5) ) {
		return true
	}
	else { return false }
}


//-----------------------------------------------------------------------------
// Purpose: Finds a weapon to switch to and switches to it.
//	-> See top of script for more info
//-----------------------------------------------------------------------------
::CTFPlayer.SwitchToActive <- function(NewGun)
{
// Finds a weapon to switch to if:
// The weapon is not on the list of Misc weapons, is not a melee, and weight is greater or equal to 2,
// if not, then checks if the weapon is not in slot5, nor slot6, and is a melee,
// if not, just switches to any weapon available.
	local SwitchTo = NewGun
	local wep = null
	local SearchTimes = 0
	if ( SwitchTo == null ) {
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
			
			if ( SearchTimes == 0 && wep && SearchMiscWeapons.find(wep.GetClassname()) == null && !wep.IsMeleeWeapon() && wep.GetWeight() >= 2 ) {
				SwitchTo = wep
				break
			}
			else if ( SearchTimes == 1 && wep && wep.IsMeleeWeapon() && wep.GetWeight() >= 2 ) {
				SwitchTo = wep
				break
			}
			else if ( SearchTimes == 2 && wep && wep.IsMeleeWeapon() ) {
				SwitchTo = wep
				break
			}
			else if ( SearchTimes == 3 && wep ) {
				SwitchTo = wep
				break
			}
			else if ( i == GLOBAL_WEAPON_COUNT - 1 && SearchTimes < 3 ) {
				i = 0
				SearchTimes++
			}
		}
	}
	
	this.Weapon_Switch(SwitchTo)
	return SwitchTo
}


//-----------------------------------------------------------------------------
// Purpose: Finds Gunslinger on player, but only for Engineer. If found, returns true.
//-----------------------------------------------------------------------------
::CTFPlayer.HasGunslinger <- function()
{
	if ( this.GetPlayerClass() == 9 )
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
			local wepID = GetItemID(wep)
			
			if ( wep && wep.GetClassname() == "tf_weapon_robot_arm" || wepID == 142 )
			{
				return true
			}
		}
	}
	return false
}


//-----------------------------------------------------------------------------
// Purpose: Finds a weapon based on handle, slot, ID, classnames, or string.
//-----------------------------------------------------------------------------
::CTFPlayer.ReturnWeaponTable <- function(weapon=null)
{
	if ( weapon == null ) {
		GTFW_DevPrint("give_tf_weapon ERROR: ReturnWeaponTable failed. Parameter is Null. Returning null.")
		return null
	}
	local ItemID = GetItemID(weapon)
	local baseitem = weapon
	
	if ( NetProps.HasProp(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex") ) { //if a weapon handle
		if ( IS_CUSTOM(weapon, false) ) { //if custom
			ItemID = NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex") | (1 << 20)  //sets bit 20 for searching in ReturnWeaponTable
		}
	}
	
	if ( SearchBySlotsParameters.find(weapon) && weapon != 0 ) {
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
			if ( wep )
			{
				if ( GTFW_ReturnWeaponBySlotBool(wep, weapon) )
				{
					ItemID = GetItemID(wep)
					baseitem = GTFW_SearchEquipReg(ItemID)
					baseitem = this.GTFW_PostWepFix(baseitem)
					return baseitem
				}
			}
		}
	}
	else if ( SearchAllWeapons.find(weapon) ) {
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)

			if ( wep )
			{
				if ( wep.GetClassname() == weapon )
				{
					ItemID = GetItemID(wep)
					baseitem = GTFW_SearchEquipReg(ItemID)
					baseitem = this.GTFW_PostWepFix(baseitem)
					return baseitem
				}
			}
		}
	}
	else {
		if ( baseitem == null ) {
			GTFW_DevPrint("give_tf_weapon ERROR: ReturnWeaponTable failed. Parameter is Null. Returning null.")
			return null
		}
		baseitem = GTFW_SearchEquipReg(weapon)
		
		if ( baseitem ) {
			baseitem = this.GTFW_PostWepFix(baseitem)
			return baseitem
		}
		else {
			baseitem = GTFW_SearchEquipReg(ItemID)
			if ( baseitem ) {
				baseitem = this.GTFW_PostWepFix(baseitem)
				return baseitem
			}
		}
	}
	
	GTFW_DevPrint("give_tf_weapon ERROR: ReturnWeaponTable failed. Could not find weapon. Returning null.")
	return null
}


//-----------------------------------------------------------------------------
// Purpose: Searches all items under tables.nut. Used by ReturnWeaponTable.
//-----------------------------------------------------------------------------
::GTFW_SearchEquipReg <- function(baseitem)
{
	if ( baseitem == null ) {
		return
	}
	local Continue = true
	local ID	= null
	local wepTable = null
	
	foreach (exists in TF_CUSTOM_WEAPONS_REGISTRY)
	{
		if ( exists.itemString == baseitem )
		{
			ID = exists.itemID
			wepTable = GTFW_PreWepFix(exists, ID)
			
			Continue = false
			return wepTable
		}
		else if ( exists.itemID == baseitem )
		{
			ID = exists.itemID
			wepTable = GTFW_PreWepFix(exists, ID)
				
			Continue = false
			return wepTable
		}
	}
	if ( Continue )
	{
		foreach (exists in TF_WEAPONS_ALL)
		{
			if ( exists.itemString == baseitem || exists.itemString2 == baseitem )
			{
				ID = exists.itemID
				wepTable = GTFW_PreWepFix(exists, ID)
				
				Continue = false
				return wepTable
			}
			else if ( exists.itemID == baseitem )
			{
				ID = exists.itemID
				
				wepTable = GTFW_PreWepFix(exists, ID)
				
				Continue = false
				return wepTable
			}
		}
		if ( Continue )
		{
			foreach (exists in TF_WEAPONS_ALL_WARPAINTSnBOTKILLERS)
			{
				if ( exists.itemID == baseitem || exists.itemID2 == baseitem || exists.itemID3 == baseitem
				|| exists.itemID4 == baseitem || exists.itemID5 == baseitem || exists.itemID6 == baseitem
				|| exists.itemID7 == baseitem || exists.itemID8 == baseitem || exists.itemID9 == baseitem
				|| exists.itemID10 == baseitem || exists.itemID11 == baseitem || exists.itemID12 == baseitem
				|| exists.itemID13 == baseitem)
				{
					if ( exists.itemID == baseitem ) {
						ID = exists.itemID
					}
					else if ( exists.itemID2 == baseitem ) {
						ID = exists.itemID2
					}
					else if ( exists.itemID3 == baseitem ) {
						ID = exists.itemID3
					}
					else if ( exists.itemID4 == baseitem ) {
						ID = exists.itemID4
					}
					else if ( exists.itemID5 == baseitem ) {
						ID = exists.itemID5
					}
					else if ( exists.itemID6 == baseitem ) {
						ID = exists.itemID6
					}
					else if ( exists.itemID7 == baseitem ) {
						ID = exists.itemID7
					}
					else if ( exists.itemID8 == baseitem ) {
						ID = exists.itemID8
					}
					else if ( exists.itemID9 == baseitem ) {
						ID = exists.itemID9
					}
					else if ( exists.itemID10 == baseitem ) {
						ID = exists.itemID10
					}
					else if ( exists.itemID11 == baseitem ) {
						ID = exists.itemID11
					}
					else if ( exists.itemID12 == baseitem ) {
						ID = exists.itemID12
					}
					else if ( exists.itemID13 == baseitem ) {
						ID = exists.itemID13
					}
					
					wepTable = GTFW_PreWepFix(exists, ID)
					
					return wepTable
				}
			}
		}
	}
}


//-----------------------------------------------------------------------------
// Purpose: Pre-Fixes up all items when found by GTFW_SearchEquipReg.
// It shoves everything that's needed in a weapon into a table to be accessed by you, the user!
//-----------------------------------------------------------------------------
::GTFW_PreWepFix <- function(exists, ID)
{
	local tf_class	= null
	local func = null
	local clear_stats = null
	local w_model = null
	local v_model = null
	local class_arms = null
	if ( "tf_class" in exists ) {
		tf_class = exists.tf_class
	}
	else { 
		tf_class = 0
	}
	
	if ( "func" in exists ) {
		func = exists.func
		clear_stats = exists.clear_stats
		w_model = exists.w_model
		v_model = exists.v_model
		class_arms = exists.class_arms
	}
	local itemName	= null
	if ( "itemString" in exists ) {
		itemName	= exists.itemString
	}
	local slot		= exists.slot
	local className	= exists.className
	local itemID	= ID & ~(1 << 20)	//removes custom weapon bit
	local ammo_type	= exists.ammo_type
	local clip		= exists.clip
	local reserve	= exists.reserve
	local wearable	= exists.wearable
	
	local baseitem	= TF_WEAPONS_BASE(tf_class, slot, className, itemName, itemID, ammo_type, clip, reserve, w_model, v_model, wearable, clear_stats, func, class_arms)
	
	return baseitem
}


//-----------------------------------------------------------------------------
// Purpose: Post-Fixes up all items found by GTFW_SearchEquipReg.
// Things like what the classname is, what type of shotgun it is, etc.
//-----------------------------------------------------------------------------
::CTFPlayer.GTFW_PostWepFix <- function(baseitem)
{
	if ( baseitem == null) {
		return
	}
	local baseC = baseitem.className
	
	if ( baseC == "demoshield" )
	{
		baseitem.className = "tf_wearable_demoshield"
	}
	else if ( baseC == "razorback" )
	{
		baseitem.className = "tf_wearable_razorback"
	}
	else if ( baseC == "tf_wearable" )
	{
		baseitem.className = baseC
	}
	else if ( baseC == "saxxy" ) {
		baseitem.className = GTFW_Saxxy[this.GetPlayerClass()]
	}
	else if ( baseC == "pistol" ) {
		if ( this.GetPlayerClass() == Constants.ETFClass.TF_CLASS_SCOUT ) {
			baseitem.className = "tf_weapon_pistol_scout"
			baseitem.reserve		= 36
			baseitem.tf_class 	=	Constants.ETFClass.TF_CLASS_SCOUT
		}
		else if ( this.GetPlayerClass() == Constants.ETFClass.TF_CLASS_ENGINEER ) {
			baseitem.className = "tf_weapon_pistol"
			baseitem.reserve		= 200
			baseitem.tf_class 	=	Constants.ETFClass.TF_CLASS_ENGINEER
		}
		else {
			baseitem.className = "tf_weapon_pistol"
			baseitem.reserve		= 36
			baseitem.tf_class 	=	Constants.ETFClass.TF_CLASS_ENGINEER
		}
	}
	else if ( baseC == "shotgun" ) {
		if ( this.GetPlayerClass() == Constants.ETFClass.TF_CLASS_ENGINEER ) {
			baseitem.className	= "tf_weapon_shotgun_primary"
			baseitem.slot = 0
			baseitem.tf_class 	=	Constants.ETFClass.TF_CLASS_ENGINEER
			baseitem.ammo_type	=	TF_AMMO.PRIMARY
		}
		else if ( this.GetPlayerClass() == Constants.ETFClass.TF_CLASS_HEAVYWEAPONS ) {
			baseitem.className	= "tf_weapon_shotgun_hwg"
			baseitem.tf_class 	=	Constants.ETFClass.TF_CLASS_HEAVYWEAPONS
		}
		else if ( this.GetPlayerClass() == Constants.ETFClass.TF_CLASS_SOLDIER ) {
			baseitem.className	= "tf_weapon_shotgun_soldier"
			baseitem.tf_class 	=	Constants.ETFClass.TF_CLASS_SOLDIER
		}
		else if ( this.GetPlayerClass() == Constants.ETFClass.TF_CLASS_PYRO ) {
			baseitem.className	= "tf_weapon_shotgun_pyro"
			baseitem.tf_class 	=	Constants.ETFClass.TF_CLASS_PYRO
		}
		else if ( this.GetPlayerClass() == Constants.ETFClass.TF_CLASS_DEMOMAN ) {
			baseitem.className	= "tf_weapon_shotgun_soldier"
			baseitem.tf_class 	=	Constants.ETFClass.TF_CLASS_SOLDIER
		}
		else if ( this.GetPlayerClass() == Constants.ETFClass.TF_CLASS_MEDIC ) {
			baseitem.className	= "tf_weapon_shotgun_primary"
			baseitem.slot = 0
			baseitem.tf_class 	=	Constants.ETFClass.TF_CLASS_ENGINEER
			baseitem.ammo_type	=	TF_AMMO.PRIMARY
		}
		else if ( this.GetPlayerClass() == Constants.ETFClass.TF_CLASS_SPY ) {
			baseitem.className	= "tf_weapon_shotgun_primary"
			baseitem.slot = 0
			baseitem.tf_class 	=	Constants.ETFClass.TF_CLASS_ENGINEER
			baseitem.ammo_type	=	TF_AMMO.PRIMARY
		}
		else if ( this.GetPlayerClass() == Constants.ETFClass.TF_CLASS_SCOUT ) {
			baseitem.className	= "tf_weapon_shotgun_primary"
			baseitem.slot = 0
			baseitem.tf_class 	=	Constants.ETFClass.TF_CLASS_ENGINEER
			baseitem.ammo_type	=	TF_AMMO.PRIMARY
		}
		else {
			baseitem.className	= "tf_weapon_shotgun_pyro"
			baseitem.tf_class 	=	Constants.ETFClass.TF_CLASS_PYRO
		}
	}
	else if ( baseC == "katana" ) {
		if ( this.GetPlayerClass() == Constants.ETFClass.TF_CLASS_DEMOMAN ) {
			baseitem.className = "tf_weapon_katana"
			baseitem.tf_class 	=	Constants.ETFClass.TF_CLASS_DEMOMAN
		}
	}
	else { baseitem.className = "tf_weapon_"+baseitem.className	}
	
	return baseitem
}


//-----------------------------------------------------------------------------
//Base for making weapons. Netprops compiled by ficool2.
//-----------------------------------------------------------------------------
::CTFPlayer.AddWeapon <- function(classname, itemindex, slot)
{
	if ( itemindex & (1 << 20) ) {
		itemindex = itemindex & ~(1 << 20)
	}
	local weapon = Entities.CreateByClassname(classname)
	
	NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", itemindex)
	NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_iEntityQuality", RandomInt(1,100) )
	NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_iEntityLevel", 0)
	NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_bInitialized", 1)
	//NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_iAccountID", -1)	//Can't find due to security risks set by vscript
	
	NetProps.SetPropInt(weapon, "m_bClientSideAnimation", 1)
	NetProps.SetPropInt(weapon, "m_fEffects", 129)
	//NetProps.SetPropInt(weapon, "m_iState", 2)	//not needed
	NetProps.SetPropInt(weapon, "m_CollisionGroup", 11)
	
	local curTime = Time()
	NetProps.SetPropFloat(weapon, "LocalActiveWeaponData.m_flNextPrimaryAttack", curTime)
	NetProps.SetPropFloat(weapon, "LocalActiveWeaponData.m_flNextSecondaryAttack", curTime)
	NetProps.SetPropFloat(weapon, "LocalActiveWeaponData.m_flTimeWeaponIdle", curTime)
	
	NetProps.SetPropInt(weapon, "m_bValidatedAttachedEntity", 1)
	//NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_bOnlyIterateItemViewAttributes", 1)	// Removes all pre-existing stats of the weapon.
	NetProps.SetPropInt(weapon, "m_AttributeManager.m_iReapplyProvisionParity", 3)
	
	weapon.SetAbsOrigin(Vector(0,0,0))
	weapon.SetAbsAngles(QAngle(0,0,0))
	
	NetProps.SetPropInt(weapon, "m_iTeamNum", this.GetTeam())
	NetProps.SetPropEntity(weapon, "m_hOwnerEntity", this)
	NetProps.SetPropEntity(weapon, "m_hOwner", this)
	weapon.SetOwner(null);
	weapon.SetOwner(this);
	
	Entities.DispatchSpawn(weapon)
	weapon.ReapplyProvision()
	
	local solidFlags = NetProps.GetPropInt(weapon, "m_Collision.m_usSolidFlags");
	NetProps.SetPropInt(weapon, "m_Collision.m_usSolidFlags", solidFlags | Constants.FSolid.FSOLID_NOT_SOLID);
	
	solidFlags = NetProps.GetPropInt(weapon, "m_Collision.m_usSolidFlags");
	NetProps.SetPropInt(weapon, "m_Collision.m_usSolidFlags", solidFlags & ~(Constants.FSolid.FSOLID_TRIGGER));
	
	if ( classname != "tf_wearable_demoshield" || classname != "tf_wearable" || classname != "tf_wearable_razorback" )
	{
		NetProps.SetPropEntityArray(this, "m_hMyWeapons", weapon, slot)
	}
	weapon.SetLocalOrigin(this.GetLocalOrigin())
	weapon.SetLocalAngles(this.GetAbsAngles())
	DoEntFire("!self", "SetParent", "!activator", 0, this, weapon)
	NetProps.SetPropInt(weapon, "m_MoveType", 0)
	

//If added weapon is not intended to be used by player's tfclass, mark it as unintended for the tfclass, to fix VM arms
	local addedWep = this.ReturnWeaponTable(itemindex)
	if ( addedWep == null ) {
		GTFW_DevPrint("give_tf_weapon ERROR: AddWeapon failed at finding item index '"+itemindex+"'. Returning null.")
		return null
	}
	if ( this.GetPlayerClass() != addedWep.tf_class && addedWep.tf_class != 0 )
	{
		IS_UNINTENDED(weapon, true)
	}

	if ( classname == "tf_weapon_builder")	//Engineer toolbox
	{
		NetProps.SetPropInt(weapon, "BuilderLocalData.m_iObjectType", 0)
		NetProps.SetPropInt(weapon, "m_iSubType", 0)
		NetProps.SetPropInt(weapon, "BuilderLocalData.m_aBuildableObjectTypes.000", 1)
		NetProps.SetPropInt(weapon, "BuilderLocalData.m_aBuildableObjectTypes.001", 1)
		NetProps.SetPropInt(weapon, "BuilderLocalData.m_aBuildableObjectTypes.002", 1)
		NetProps.SetPropInt(weapon, "BuilderLocalData.m_aBuildableObjectTypes.003", 0)
	}

	return weapon
}

//-----------------------------------------------------------------------------
// Purpose: Used to update viewmodel arms.
//	-> See top of script for more info
//-----------------------------------------------------------------------------
::CTFPlayer.UpdateArms <- function()
{
	if ( !CVAR_GTFW_USE_VIEWMODEL_FIX ) {
		GTFW_DevPrint("give_tf_weapon: CVAR_GTFW_USE_VIEWMODEL_FIX = false. UpdateArms cancelled.")
		return
	}
	
/* Purpose: This is the special VM fix.
 it creates class arms that bonemerge with VM
*/
		
// Table for bonemerged class arms, per player.
// Adds a class arms model if nothing has parented to the main_viewmodel
	if ( !( this in PlayerLoadoutGlobal_BonemergedArms ) ) {
		local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
		local wearable_handle = this.GTFW_CreateCustomWeaponModel(false, main_viewmodel, GTFW_MODEL_ARMS[this.GetPlayerClass()] )	// creates player class' arms, parents and does all that stuff
	/*	Purpose: Initialize tables if they aren't already made
		So we don't create more arms than necessary
		Puts into a table "player = arms model" for easy tracking
	*/
		::PlayerLoadoutGlobal_BonemergedArms[this] <- wearable_handle
	}
	
// Purpose: Writes to the tables above, which keep the class arms the weapon needs to update to when switched to.
	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
	{
		local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
		
		if ( wep )
		{
			local baseitem = this.ReturnWeaponTable(GetItemID(wep))
			
			if ( baseitem ) {
				if ( baseitem.className == "tf_weapon_pda_spy" ) {
					wep.SetModelSimple( "models/weapons/v_models/v_pda_spy.mdl" )
					wep.SetCustomViewModel( "models/weapons/v_models/v_pda_spy.mdl" )
				}
				else if ( baseitem.className == "tf_weapon_invis" && baseitem.itemID == 30 ) {
					wep.SetModelSimple( "models/weapons/v_models/v_watch_spy.mdl" )
					wep.SetCustomViewModel( "models/weapons/v_models/v_watch_spy.mdl" )
				}
				else if ( baseitem.className == "tf_weapon_invis" && baseitem.itemID == 59 ) {
					wep.SetModelSimple( "models/weapons/v_models/v_watch_pocket_spy.mdl" )
					wep.SetCustomViewModel( "models/weapons/v_models/v_watch_pocket_spy.mdl" )
				}
				else if ( baseitem.className == "tf_weapon_invis" && baseitem.itemID == 60 ) {
					wep.SetModelSimple( "models/weapons/v_models/v_watch_leather_spy.mdl" )
					wep.SetCustomViewModel( "models/weapons/v_models/v_watch_leather_spy.mdl" )
				}
				else if ( baseitem.className == "tf_weapon_invis" && baseitem.itemID == 297 ) {
					wep.SetModelSimple( "models/weapons/v_models/v_ttg_watch_spy.mdl" )
					wep.SetCustomViewModel( "models/weapons/v_models/v_ttg_watch_spy.mdl" )
				}
				else if ( baseitem.className == "tf_weapon_invis" && baseitem.itemID == 947 ) {
					wep.SetModelSimple( "models/workshop_partner/weapons/v_models/v_hm_watch/v_hm_watch.mdl" )
					wep.SetCustomViewModel( "models/workshop_partner/weapons/v_models/v_hm_watch/v_hm_watch.mdl" )
				}
				else if ( this.HasGunslinger() ) {
					wep.SetModelSimple( GTFW_MODEL_ARMS[10] )
					wep.SetCustomViewModel( GTFW_MODEL_ARMS[10] )
				}
				else if ( baseitem.class_arms ) {
					wep.SetModelSimple( baseitem.class_arms )
					wep.SetCustomViewModel( baseitem.class_arms )
				}
				else if ( baseitem.tf_class == 0 || this.GetPlayerClass() == baseitem.tf_class ) {
					wep.SetModelSimple( GTFW_MODEL_ARMS[this.GetPlayerClass()] )
					wep.SetCustomViewModel( GTFW_MODEL_ARMS[this.GetPlayerClass()] )
				}
				else {
					wep.SetModelSimple( GTFW_MODEL_ARMS[baseitem.tf_class] )
					wep.SetCustomViewModel( GTFW_MODEL_ARMS[baseitem.tf_class] )
				}
			}
		}
	}
}


//-----------------------------------------------------------------------------
//	Purpose: Updates all weapon models.
//	-> See top of script for more info
//-----------------------------------------------------------------------------
 
::CTFPlayer.UpdateWeapon <- function(weapon, w_model, v_model)
{
// Only update if the weapon is custom or is unintended for tfclass
	if ( IS_CUSTOM(weapon, false) || IS_UNINTENDED(weapon, false) )
	{
		local wearable_handle = this.GTFW_CreateCustomWeaponModel(false, weapon, v_model)	// creates weapon in viewmodel, parents and does all that stuff

	//Mr. Burguers helped me with this part. Thanks Mr B!
		local wep = weapon.GetClassname()
		if ( !( this in PlayerLoadoutGlobal_CustomWeaponModels_VM ) ) {
			PlayerLoadoutGlobal_CustomWeaponModels_VM[this] <- {}
		}
		if ( wep in PlayerLoadoutGlobal_CustomWeaponModels_VM[this] )
		{
			local wepModel = PlayerLoadoutGlobal_CustomWeaponModels_VM[this][wep]
			if ( wepModel.IsValid() ) {
				KillWepAll(wepModel)
			}
			delete PlayerLoadoutGlobal_CustomWeaponModels_VM[this][wep]
		}
		PlayerLoadoutGlobal_CustomWeaponModels_VM[this][wep] <- wearable_handle
		
		if ( IS_CUSTOM(weapon, false) )	//only make third person model if weapon is custom
		{
			wearable_handle = this.GTFW_CreateCustomWeaponModel(true, weapon, w_model)	// creates thirdperson/world model, parents and does all that stuff
			
			if ( !( this in PlayerLoadoutGlobal_CustomWeaponModels_TP ) ) {
				PlayerLoadoutGlobal_CustomWeaponModels_TP[this] <- {}
			}
			if ( wep in PlayerLoadoutGlobal_CustomWeaponModels_TP[this] )
			{
				local wepModel = PlayerLoadoutGlobal_CustomWeaponModels_TP[this][wep]
				if ( wepModel.IsValid() ) {
					KillWepAll(wepModel)
				}
				delete PlayerLoadoutGlobal_CustomWeaponModels_TP[this][wep]
			}
			
			PlayerLoadoutGlobal_CustomWeaponModels_TP[this][wep] <- wearable_handle
		}
	}
	return weapon
}


//-----------------------------------------------------------------------------
// Purpose: Updates viewmodel think script.
// Clears and updates the viewmodel think script for weapon switching, enabling/disabling visibility of custom weapons.
//-----------------------------------------------------------------------------
::CTFPlayer.AddThinkToViewModel <- function()
{
	if ( !CVAR_GTFW_USE_VIEWMODEL_FIX ) {
		return
	}
	local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
	local wearable_handle = null
	
// Think script itself.
// Reads from several tables to find weapon's class arms.
	if( main_viewmodel.ValidateScriptScope() )
	{
		local wep = null

		local player = this
		
		local entscriptname = "THINK_VM_FIX_"+this.tostring()
		
		local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
		
		local DisableDrawQueue = null
		local asdf = null
		
		local WEP_TAUNT_FIX = false
		
		const THINK_VMFIX_DELAY = 0
		
		local entityscript = main_viewmodel.GetScriptScope()
		entityscript[entscriptname] <- function()
		{
		// Fixes taunts
		// It clears the parent of the original weapon, and makes it invisible.
		// It is reparented inside the DisableDrawQueue section (a few lines down)
			if ( player.InCond(7) && WEP_TAUNT_FIX ) {
				WEP_TAUNT_FIX = false
				wep = player.GetActiveWeapon()
				
				NetProps.SetPropEntity(DisableDrawQueue, "m_hWeaponAssociatedWith", wep)
				NetProps.SetPropInt(wep, "m_fEffects", 161)
				DoEntFire("!self", "Clearparent", "", 0, null, wep)
				DoEntFire("!self", "DisableShadow", "", 0, null, wep)
				wep.EnableDraw()
				NetProps.SetPropInt(wep, "m_iState", 0)
				wep = null
			}
		// updates weapons' visibility based on which one is being used
			else if ( player.GetActiveWeapon() && !player.InCond(7) && player.GetActiveWeapon() != wep )
			{
				wep = player.GetActiveWeapon()
				local wepC = wep.GetClassname()
				
		// This fixes taunts and switching away from custom weapons.
		// It reparents and sets owner back to the player
				if ( DisableDrawQueue )
				{
					NetProps.SetPropInt(wep, "m_iState", 0)
					DoEntFire("!self", "RunScriptCode", "self.DisableDraw()", 0, null, DisableDrawQueue)	//using delay here purposely. Won't update b/c thinks too fast!!
					NetProps.SetPropEntity(DisableDrawQueue, "m_hWeaponAssociatedWith", null)
					
					DoEntFire("!self", "SetParent", "!activator", 0, player, wep)
					wep.SetOwner(player)
					
					DisableDrawQueue = null
				}

			// These are vars are for the next part
				asdf = null
				DisableDrawQueue = null
				
			//Checks for custom weapon and/or weapon unintended for the class.
			//Passing as a custom weapon means it updates the weapon visibility, disables the base weapon,
			// then adds it to the queue to be disabled when switched away
				if ( IS_CUSTOM(wep, false) )
				{
					main_viewmodel.DisableDraw()		//makes firstperson weapon invisible (as well as other's class arms from the other class)
					WEP_TAUNT_FIX = true
					
					NetProps.SetPropInt(wep, "m_iState", 0)
					wep.EnableDraw()	//Have to send EnableDraw() first before DisableDraw(). Thanks Sorse(tm)!
					DoEntFire("!self", "RunScriptCode", "self.DisableDraw()", 0.01, null, wep)	//using delay here purposely. Won't update b/c thinks too fast!!
					
					asdf = PlayerLoadoutGlobal_CustomWeaponModels_TP[player][wepC]	//reads from table
					asdf.EnableDraw()
					DoEntFire("!self", "RunScriptCode", "self.EnableDraw()", 0.01, null, asdf)	//using delay here purposely. Won't update b/c thinks too fast!!
					
					DisableDrawQueue = asdf	//custom weapon disables visibility at beginning of think script.
				}
				else if ( IS_UNINTENDED(wep, false) ) {
					WEP_TAUNT_FIX = true
					main_viewmodel.DisableDraw() //makes firstperson weapon invisible (as well as other's class arms from the other class)
				}
			// this part reads from the bonemerged arms table
			// who ever the class is, and which ever arms they are using, this will put it as a value...

				if ( player in PlayerLoadoutGlobal_BonemergedArms ) {
					local bonemerged = PlayerLoadoutGlobal_BonemergedArms[player]
					
				// if ShortCircuit, disable the class arms' visibility
					if ( wep.GetClassname() == "tf_weapon_mechanical_arm" ) { // Short Circuit
						bonemerged.DisableDraw()
					}
					else if ( IS_CUSTOM(wep, false) || IS_UNINTENDED(wep, false) ) {
						bonemerged.EnableDraw()
					}
				}
			}
			return THINK_VMFIX_DELAY
		}
		AddThinkToEnt(main_viewmodel, entscriptname)	//adds think script
	}
}


//-----------------------------------------------------------------------------
// Purpose: Finds a weapon by slot.
// function ReturnWeaponBySlotBool = slot number must be positive
// function GTFW_ReturnWeaponBySlotBool = Does the same as above but slot must be negative, used by this script 
//-----------------------------------------------------------------------------
::ReturnWeaponBySlotBool <- function(wep=null, slot=0)
{
	if ( type ( slot ) == "integer" ) {
		if ( wep.GetSlot() == slot ) {
			return true
		}
	}
	return false
}
::GTFW_ReturnWeaponBySlotBool <- function(wep=null, slot=-0.0)
{
	if ( type ( slot ) == "integer" || slot == -0.0 ) {
		local asdf = split(slot.tostring()+"a",abs(slot).tostring())[0]
		if ( asdf == "-" )	//if slot checks as negative... test!
		{
			slot = abs(slot)
			if ( wep.GetSlot() == slot )
			{
				return true
			}
		}
	}
	return false
}


//-----------------------------------------------------------------------------
// Purpose: Creates tf_wearable or tf_wearable_vm.
//	-> See top of script for more info
//-----------------------------------------------------------------------------
::CTFPlayer.GTFW_CreateCustomWeaponModel <- function(wearabletype=false, baseitem=null, weapon_model=null)
{
//Error if param wearabletype isn't bool
	if ( type( wearabletype ) != "bool" ) {
		GTFW_DevPrint("give_tf_weapon ERROR: GTFW_CreateCustomWeaponModel failed. Parameter 1 is not a bool. Returning null.")
		return null
	}
	local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")

	if ( type( weapon_model ) == "string" )
	{
		PrecacheModel(weapon_model)
		weapon_model = GetModelIndex(weapon_model)
	}
	if ( this.HasGunslinger() && baseitem == main_viewmodel ) {
		PrecacheModel(GTFW_MODEL_ARMS[10])
		weapon_model = GetModelIndex(GTFW_MODEL_ARMS[10])
	}
	
	local wearable_handle = null
	
// bool. If true, make a tf_wearable. If false, tf_wearable_vm.
	if (wearabletype)
	{
		wearable_handle = Entities.CreateByClassname("tf_wearable")
	}
	else
	{
		wearable_handle = Entities.CreateByClassname("tf_wearable_vm")
	}
	
	
// our properties. Taken from source code for Super Zombie Fortress + SCP Secret Fortress
	wearable_handle.SetAbsOrigin(this.GetLocalOrigin())
	wearable_handle.SetAbsAngles(this.GetLocalAngles())
	NetProps.SetPropInt(wearable_handle, "m_bValidatedAttachedEntity", 1)
	NetProps.SetPropInt(wearable_handle, "m_iTeamNum", this.GetTeam())
	NetProps.SetPropInt(wearable_handle, "m_Collision.m_usSolidFlags", Constants.FSolid.FSOLID_NOT_SOLID)
	NetProps.SetPropInt(wearable_handle, "m_CollisionGroup", 11)
	NetProps.SetPropInt(wearable_handle, "m_fEffects", 129)
	
	NetProps.SetPropInt(wearable_handle, "m_AttributeManager.m_Item.m_iEntityQuality", 0)
	NetProps.SetPropInt(wearable_handle, "m_AttributeManager.m_Item.m_iEntityLevel", 1)
	NetProps.SetPropInt(wearable_handle, "m_AttributeManager.m_Item.m_bInitialized", 1)
	
	NetProps.SetPropEntity(wearable_handle, "m_hOwnerEntity", this)
	wearable_handle.SetOwner(this)
	
	NetProps.SetPropInt(wearable_handle, "m_nModelIndex", weapon_model)
	//NetProps.SetPropInt(wearable_handle, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", itemindex)
	
// for tf_wearable (non-vm)
	if ( baseitem == null)
	{
		Entities.DispatchSpawn(wearable_handle)
		DoEntFire("!self", "SetParent", "!activator", 0, this, wearable_handle)
	}
//for class arms
	else if ( baseitem == main_viewmodel)
	{
		Entities.DispatchSpawn(wearable_handle)
		DoEntFire("!self", "SetParent", "!activator", 0, main_viewmodel, wearable_handle)
		this.EquipWearableViewModel(wearable_handle)
	}
// for viewmodel
	else if ( baseitem && wearable_handle.GetClassname() == "tf_wearable_vm" )
	{
		NetProps.SetPropEntity(wearable_handle, "m_hWeaponAssociatedWith", baseitem)
		NetProps.SetPropEntity(baseitem, "m_hExtraWearableViewModel", wearable_handle)
		Entities.DispatchSpawn(wearable_handle)
		DoEntFire("!self", "SetParent", "!activator", 0, main_viewmodel, wearable_handle)
		this.EquipWearableViewModel(wearable_handle)
	}
//for world model (weapons only)
	else if ( baseitem && wearable_handle.GetClassname() == "tf_wearable" )
	{
	//	NetProps.SetPropEntity(wearable_handle, "m_hWeaponAssociatedWith", baseitem)
		NetProps.SetPropEntity(baseitem, "m_hExtraWearable", wearable_handle)
		Entities.DispatchSpawn(wearable_handle)
		DoEntFire("!self", "SetParent", "!activator", 0, this, wearable_handle)
		wearable_handle.DisableDraw()
		
	//	DoEntFire("!self", "AddOutput", "rendermode 1", 0, this, wearable_handle)
	//	DoEntFire("!self", "Color", "0 0 255", 0, this, wearable_handle)//colored weapons!
	//	DoEntFire("!self", "Clearparent", "", 0, null, baseitem)	//Disables the baseitem from appearing in thirdperson. However, various bugs like weapon appearing while taunting, or firing effecting origin messing up...
	}
// we name this for easy finding+cleanup
	wearable_handle.KeyValueFromString("targetname","tf_wearable_vscript")

	return wearable_handle
}



//-----------------------------------------------------------------------------
// The following are the PUBLIC FUNCTIONS
//-----------------------------------------------------------------------------



//-----------------------------------------------------------------------------
// Purpose: Shows in console all equips on host of listen server.
//	-> See top of script for more info
//-----------------------------------------------------------------------------

::CheckItems <- function()
{
	local ActiveWeapon = GetListenServerHost().GetActiveWeapon()
	local ActiveWeaponID = GetItemID(ActiveWeapon)

	Say(GetListenServerHost(), " ", false)
	Say(GetListenServerHost(), format("Active Slot%i [%s] (ItemID = %i)", ActiveWeapon.GetSlot(), ActiveWeapon.GetClassname(), ActiveWeaponID), false)
	
	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
	{
		local wep = NetProps.GetPropEntityArray(GetListenServerHost(), "m_hMyWeapons", i)
		local wep_itemID = GetItemID(wep)
		ClientPrint(GetListenServerHost(), 2, i+" "+wep+" (ItemID = "+wep_itemID+")" )
		
		if ( wep && wep != ActiveWeapon)
		{
			Say(GetListenServerHost(), format("Slot%i [%s] (ItemID = %i)", wep.GetSlot(), wep.GetClassname(), wep_itemID), false)
		}
	}
}

::CheckAttrWep <- function()
{
	printl(NetProps.GetPropInt(GetListenServerHost().GetActiveWeapon(), "m_AttributeManager.m_Item.m_AttributeList.m_Attributes.lengthproxy.lengthprop20"))
	for (local i = 0; i < 20; i++)
	{
		local z = ""
		i < 10 ? z = 0 : z = "";
		local wep = NetProps.GetPropInt(GetListenServerHost().GetActiveWeapon(), "m_AttributeManager.m_Item.m_AttributeList.m_Attributes.0"+z+i+".m_iAttributeDefinitionIndex")
		local wep_val = NetProps.GetPropInt(GetListenServerHost().GetActiveWeapon(), "m_AttributeManager.m_Item.m_AttributeList.m_Attributes.0"+z+i+".m_iRawValue32")
		local currency = NetProps.GetPropInt(GetListenServerHost().GetActiveWeapon(), "m_AttributeManager.m_Item.m_AttributeList.m_Attributes.0"+z+i+".m_nRefundableCurrency")
		printl(format("%i %i %i %i",i,wep,wep_val,currency) )
	}
}
::CheckAttrPlayer <- function()
{
	printl(NetProps.GetPropInt(GetListenServerHost(), "m_AttributeList.m_Attributes.lengthproxy.lengthprop20"))
	for (local i = 0; i < 20; i++)
	{
		local z = ""
		i < 10 ? z = 0 : z = "";
		local wep = NetProps.GetPropInt(GetListenServerHost(), "m_AttributeList.m_Attributes.00"+i+".m_iAttributeDefinitionIndex")
		local wep_val = NetProps.GetPropInt(GetListenServerHost(), "m_AttributeList.m_Attributes.00"+i+".m_iRawValue32")
		local currency = NetProps.GetPropInt(GetListenServerHost(), "m_AttributeList.m_Attributes.00"+i+".m_nRefundableCurrency")
		printl(format("%i %i %i %i",i,wep,wep_val,currency) )
	}
}


//-----------------------------------------------------------------------------
//Purpose: Finds an empty weapon equipment slot and gives weapon to the player
//	-> See top of script for more info
//-----------------------------------------------------------------------------

::CTFPlayer.GiveWeapon <- function(weapon=null)
{
	if ( weapon == null ) {
		GTFW_DevPrint("give_tf_weapon ERROR: GiveWeapon failed. Parameter is null. Returning null.")
		return null
	}
	
	local GivenWeapon = null
// Searches for the correct item based on parameter 'weapon'...
	local baseitem = this.ReturnWeaponTable(weapon)
	if ( baseitem == null ) {
		GTFW_DevPrint("give_tf_weapon ERROR: GiveWeapon failed at finding item '"+weapon+"'. Returning null.")
		return null
	}
	
	local NewWeapon = baseitem.className
	local ItemID = baseitem.itemID
	local Slot = baseitem.slot
	local AmmoType = baseitem.ammo_type
	local ClipSize = baseitem.clip
	local AmmoReserve = baseitem.reserve
	local Extra_Wearable = baseitem.wearable
	
	local w_model = baseitem.w_model
	local v_model = baseitem.v_model
	local stats_function = baseitem.func
	local class_arms = baseitem.class_arms
	
	if ( Extra_Wearable ) {
		this.CreateCustomWearable(weapon, Extra_Wearable)	// creates a tf_wearable and associates it with a weapon
	}
	
// Purpose: searches inventory, and adds our weapon over m_hMyWeapons slot
// First it finds the old weapon to delete, based on slot.
// If there is no weapon to delete, resets itself to find a `null` slot and places new weapon there.
	local wep_deleted = false
	local SafetyCheck = false
	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++) {
		local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
		
		if ( SafetyCheck == false && i == GLOBAL_WEAPON_COUNT - 1 ) {
			i = 0
			wep_deleted = true
			SafetyCheck = true
		}			
		else if ( CVAR_GTFW_GIVEWEAPON_REPLACE_WEAPONS && wep && wep.GetSlot() == Slot ) {
			KillWepAll(wep)
			wep_deleted = true
		}
		else if ( wep == null && wep_deleted ) {
			GivenWeapon = this.AddWeapon(NewWeapon, ItemID, i)
			break
		}
	}

// Purpose: seems to throw an error only if it didn't create a weapon,
// that can only happen if weps in `m_hMyWeapons` exceeds GLOBAL_WEAPON_COUNT
	if ( GivenWeapon == null ) {
		GTFW_DevPrint("give_tf_weapon ERROR: GiveWeapon failed at giving weapon '"+weapon+"'. Returning null.")
		return null
	}
	
// Purpose: Adds custom model, updates arms, runs custom stats function, if any apply.
// Updates weapon to become custom if model, function or class_arms is found in `baseitem` table.
	if ( w_model || v_model || stats_function || class_arms )
	{
	// Set our weapon to custom
		IS_CUSTOM(GivenWeapon, true)	//marks our weapon as custom
		
	 // Modifies ammo if ammo types don't match
		if ( baseitem.ammo_type != GivenWeapon.GetPrimaryAmmoType() ) {
			NetProps.SetPropInt(GivenWeapon, "LocalWeaponData.m_iPrimaryAmmoType", baseitem.ammo_type)
		}
	// If our weapon does not use original stats (use_original_stats=false), clear them.
		if ( baseitem.clear_stats == false ) {
			NetProps.SetPropInt(GivenWeapon, "m_AttributeManager.m_Item.m_bOnlyIterateItemViewAttributes", 1)	// Removes all pre-existing stats of the weapon.
		}
	// Runs custom weapon function if it exists
		local stats_function = baseitem.func
		if ( stats_function ) {
			stats_function(GivenWeapon, this)
			GivenWeapon.ReapplyProvision()
		}
	}
	
// Purpose: Forcefully changes ammo type to primary if not Spy, and if not custom
	if ( NewWeapon == "tf_weapon_revolver" && this.GetPlayerClass != Constants.ETFClass.TF_CLASS_SPY && !IS_CUSTOM(GivenWeapon, false) )
	{
		NetProps.SetPropInt(GivenWeapon, "LocalWeaponData.m_iPrimaryAmmoType", TF_AMMO.PRIMARY)
	}
	
// Purpose: Fixes ammo.
// There is an invisible tf_wearable that tracks ammo for custom weapons, and DisableWeapon/EnableWeapon
// Same goes for metal ammotype weapons like Widowmaker, Wrenches, PDAs etc
	if ( AmmoType > TF_AMMO.NONE && AmmoReserve >= 0 ) {
	//initializes tf_wearable for AmmoFix
		if ( !( this in PlayerLoadoutGlobal_AmmoFix ) ) {
			::PlayerLoadoutGlobal_AmmoFix[this] <- {}
			local AmmoFix = this.CreateCustomWearable(null, "models/empty.mdl")
			::PlayerLoadoutGlobal_AmmoFix[this] <- AmmoFix
		}
		local aThreshold = 0
		local AmmoFix = PlayerLoadoutGlobal_AmmoFix[this]
	// Purpose: Updates primary ammo reserve
		if ( AmmoType == TF_AMMO.PRIMARY ) {
			aThreshold = TF_AMMO_PER_CLASS_PRIMARY[this.GetPlayerClass()]
			AmmoFix.AddAttribute("hidden primary max ammo bonus", AmmoReserve.tofloat() / aThreshold.tofloat(), -1)
			if ( AmmoReserve > aThreshold ) {
				AmmoFix.RemoveAttribute("hidden primary max ammo bonus")
			}
		}
	// Purpose: Updates secondary ammo reserve
		else if ( AmmoType == TF_AMMO.SECONDARY ) {
			aThreshold = TF_AMMO_PER_CLASS_SECONDARY[this.GetPlayerClass()]
			AmmoFix.AddAttribute("hidden secondary max ammo penalty", AmmoReserve.tofloat() / aThreshold.tofloat(), -1)
			if ( AmmoReserve > aThreshold ) {
				AmmoFix.RemoveAttribute("hidden secondary max ammo penalty")
			}
		}
	// Purpose: Updates GRENADES1 ammo reserve
		else if ( AmmoType == TF_AMMO.GRENADES1 ) {
			aThreshold = 1
			AmmoFix.AddAttribute("maxammo grenades1 increased", (AmmoReserve.tofloat() / aThreshold.tofloat()), -1)
			if ( AmmoReserve > aThreshold ) {
				AmmoFix.RemoveAttribute("maxammo grenades1 increased")
			}
		}
	// Purpose: Updates metal capacity
		else if ( AmmoType == TF_AMMO.METAL ) {
			aThreshold = 200
			AmmoFix.AddAttribute("maxammo metal increased", (AmmoReserve.tofloat() / aThreshold.tofloat()), -1)
		}
	// Purpose: Applies all attributes to player
		AmmoFix.ReapplyProvision()
		
	// Purpose: Sets ammo reserve
		if ( AmmoType == TF_AMMO.PRIMARY && EntityOutputs.HasAction(AmmoFix, "OnUser1") == false )
		{
			NetProps.SetPropIntArray(this, "m_iAmmo", AmmoReserve, AmmoType)
		}
		else if ( AmmoType == TF_AMMO.SECONDARY && EntityOutputs.HasAction(AmmoFix, "OnUser2") == false )
		{
			NetProps.SetPropIntArray(this, "m_iAmmo", AmmoReserve, AmmoType)
		}
		else if ( AmmoType == TF_AMMO.GRENADES1 && EntityOutputs.HasAction(AmmoFix, "OnUser4") == false )
		{
			NetProps.SetPropIntArray(this, "m_iAmmo", AmmoReserve, AmmoType)
		}
		else if ( AmmoType == TF_AMMO.METAL && EntityOutputs.HasAction(AmmoFix, "OnUser3") == false && this.GetPlayerClass() != Constants.ETFClass.TF_CLASS_ENGINEER ) {
			EntityOutputs.AddOutput(AmmoFix, "OnUser3", "", "", "", 0.0, -1)	//used to flag for Metal ammo so we don't update twice
			NetProps.SetPropIntArray(this, "m_iAmmo", AmmoReserve, TF_AMMO.METAL)
		}
	
	// Purpose: Sets ammo clip
// Not wanted for HsDM, we can change our own weapon counts tyvm
	/*
		if ( ClipSize >= 0 ) {
			if ( (ClipSize / GivenWeapon.GetMaxClip1()) != 1 ) {
				GivenWeapon.AddAttribute("clip size upgrade atomic", (ClipSize / GivenWeapon.GetMaxClip1()) - GivenWeapon.GetMaxClip1(), -1)	//We can't use "clip size bonus" because it doesn't work on some weapons.
			}
			GivenWeapon.SetClip1(ClipSize)
		}*/
	}
	
	if ( w_model == null && v_model == null ) {
		w_model = NetProps.GetPropInt(GivenWeapon, "m_iWorldModelIndex")
		v_model = NetProps.GetPropInt(GivenWeapon, "m_iWorldModelIndex")
	}
	else if ( w_model == null && v_model) {
		w_model = v_model
	}
	else if ( w_model && v_model == null) {
		v_model = w_model
	}

// Purpose: Finalize weapon.
// Update arms/viewmodels, updates world weapon models, updates viewmodel's Think script
	this.UpdateArms()
	this.UpdateWeapon(GivenWeapon, w_model, v_model)
	this.AddThinkToViewModel()
	
	
// Purpose: Switches to another weapon if active one was deleted
	if (CVAR_GTFW_GIVEWEAPON_AUTO_SWITCH)
	{
		this.SwitchToActive(GivenWeapon)
	}
	
	GTFW_DevPrint("give_tf_weapon: GiveWeapon gave '"+weapon+"' to "+this+"!")
	return GivenWeapon
}


//-----------------------------------------------------------------------------
//Purpose: Deletes a weapon equipped on player
//	-> See top of script for more info
// Accepts handles, entity classnames, strings, slots (use negatives)
//-----------------------------------------------------------------------------

::CTFPlayer.DeleteWeapon <- function(weapon=null)
{
	if ( weapon == null ) {
		GTFW_DevPrint("give_tf_weapon ERROR: DeleteWeapon failed. Parameter is null. Returning false.")
		return false
	}

//converts our weapon from string/ID to an itemID...
	local baseitem = this.ReturnWeaponTable(weapon)
	if ( baseitem == null ) {
		GTFW_DevPrint("give_tf_weapon ERROR: DeleteWeapon failed. Could not find '"+weapon+"'. Returning null.")
		return false
	}
	local DeleteThis = baseitem.itemID
	local Slot = baseitem.slot
	local wep = null
	
	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
	{
		local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
		
		if ( wep )
		{
			if ( GTFW_ReturnWeaponBySlotBool(wep, weapon) )
			{
				DeleteThis = GetItemID(wep)
			}
			if ( GetItemID(wep) == DeleteThis )
			{
				KillWepAll(wep)
				NetProps.SetPropEntityArray(this, "m_hMyWeapons", null, i)
				break
			}
		}
	}
	
// switches to another weapon if active one was deleted
	if (CVAR_GTFW_DELETEWEAPON_AUTO_SWITCH) {
		if ( wep == null ) {
			this.SwitchToActive(null)
		}
	}
	
	return true
}


//-----------------------------------------------------------------------------
// Purpose: Returns weapon, searched by slot. 
// Requested by Lizard of Oz
//-----------------------------------------------------------------------------
::CTFPlayer.ReturnWeaponBySlot <- function(slot=0)
{
	if ( type( slot ) != "integer" ) {
		GTFW_DevPrint("give_tf_weapon ERROR: ReturnWeaponBySlot not an integer. Returning null.")
		return null
	}
	local GetThis = null
	local YourGunFoundBySaxtonHale = null

	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
	{
		local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
		
		if ( wep )
		{
			if ( ReturnWeaponBySlotBool(wep, slot) )
			{
				GetThis = wep.GetClassname()
			}
			if ( wep.GetClassname() == GetThis )
			{
				YourGunFoundBySaxtonHale = wep
				break
			}
		}
	}
	return YourGunFoundBySaxtonHale
}


//-----------------------------------------------------------------------------
// Purpose: disables being able to switch to a weapon.
//	-> See top of script for more info
//-----------------------------------------------------------------------------

::CTFPlayer.DisableWeapon <- function(weapon=null)
{
//Error if param is null
	if ( weapon == null ) {
		GTFW_DevPrint("give_tf_weapon ERROR: DisableWeapon failed. Parameter is null. Returning null.")
		return null
	}
//searches for the correct item based on parameter 'weapon'...
	local baseitem = this.ReturnWeaponTable(weapon)
	if ( baseitem == null ) {
		GTFW_DevPrint("give_tf_weapon ERROR: DisableWeapon failed. Could not find '"+weapon+"'. Returning null.")
		return null
	}
	
	local DisableThis = baseitem.itemID
	
	local BrokenGun = null
	local wep = null
	
	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
	{
		local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
		
		if ( wep )
		{
			if ( GTFW_ReturnWeaponBySlotBool(wep, weapon) )
			{
				DisableThis = GetItemID(wep)
			}
			if ( GetItemID(wep) == DisableThis )
			{
				if ( !( this in PlayerLoadoutGlobal_AmmoFix ) ) {
					::PlayerLoadoutGlobal_AmmoFix[this] <- {}
					local AmmoFix = this.CreateCustomWearable(null, "models/empty.mdl")
					::PlayerLoadoutGlobal_AmmoFix[this] <- AmmoFix
				}
				if ( this in PlayerLoadoutGlobal_AmmoFix ) {
					local AmmoFix = PlayerLoadoutGlobal_AmmoFix[this]
					
					if ( wep.GetPrimaryAmmoType() == TF_AMMO.PRIMARY ) {
						AmmoFix.AddAttribute("maxammo primary reduced", 0, -1)
						AmmoFix.ReapplyProvision()
						EntityOutputs.AddOutput(AmmoFix, "OnUser1", "", "", "", 0.0, -1)	//used to flag for Primary Ammo
					}
					else if ( wep.GetPrimaryAmmoType() == TF_AMMO.SECONDARY ) {
						AmmoFix.AddAttribute("maxammo secondary reduced", 0, -1)
						AmmoFix.ReapplyProvision()
						EntityOutputs.AddOutput(AmmoFix, "OnUser2", "", "", "", 0.0, -1)	//used to flag for Secondary Ammo
					}
					else if ( wep.GetPrimaryAmmoType() == TF_AMMO.GRENADES1 ) {
						AmmoFix.AddAttribute("maxammo grenades1 increased", 0, -1)
						AmmoFix.ReapplyProvision()
						EntityOutputs.AddOutput(AmmoFix, "OnUser4", "", "", "", 0.0, -1)	//used to flag for GRENADES1 Ammo
					}
					wep.SetClip1(0)
					NetProps.SetPropIntArray(this, "m_iAmmo", 0, wep.GetPrimaryAmmoType())
				}
				BrokenGun = wep
				break
			}
		}
	}
	
// switches to another weapon if active one was disabled
	if (CVAR_GTFW_DISABLEWEAPON_AUTO_SWITCH) {
		this.SwitchToActive(null)
	}
	
	return BrokenGun
}


//-----------------------------------------------------------------------------
//Purpose: Enables weapon if it was disabled.
//	-> See top of script for more info
//-----------------------------------------------------------------------------
::CTFPlayer.EnableWeapon <- function(weapon=null)
{
//Error if param is null
	if ( weapon == null ) {
		GTFW_DevPrint("give_tf_weapon ERROR: EnableWeapon failed. Parameter is null. Returning null.")
		return null
	}
	local FixThis = null
//searches for the correct item based on parameter 'weapon'...
	local baseitem = this.ReturnWeaponTable(weapon)
	if ( baseitem == null ) {
		GTFW_DevPrint("give_tf_weapon ERROR: EnableWeapon failed. Could not find '"+weapon+"'. Returning null.")
		return null
	}
	
	FixThis = baseitem.itemID
	
	local FixedGun = null
	
	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
	{
		local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
		
		if ( wep )
		{
			if ( GTFW_ReturnWeaponBySlotBool(wep, weapon) )
			{
				FixThis = GetItemID(wep)
			}
			if ( GetItemID(wep) == FixThis )
			{
				if ( !( this in PlayerLoadoutGlobal_AmmoFix ) ) {
					::PlayerLoadoutGlobal_AmmoFix[this] <- {}
					local AmmoFix = this.CreateCustomWearable(null, "models/empty.mdl")
					::PlayerLoadoutGlobal_AmmoFix[this] <- AmmoFix
				}
				if ( this in PlayerLoadoutGlobal_AmmoFix ) {
					local AmmoFix = PlayerLoadoutGlobal_AmmoFix[this]
					
					if ( wep.GetPrimaryAmmoType() == TF_AMMO.PRIMARY ) {
						AmmoFix.AddAttribute("maxammo primary reduced", 1, -1)
						AmmoFix.ReapplyProvision()
						EntityOutputs.RemoveOutput(AmmoFix, "OnUser1", "", "", "")	//used to flag for Primary Ammo
					}
					else if ( wep.GetPrimaryAmmoType() == TF_AMMO.SECONDARY ) {
						AmmoFix.AddAttribute("maxammo secondary reduced", 1, -1)
						AmmoFix.ReapplyProvision()
						EntityOutputs.RemoveOutput(AmmoFix, "OnUser2", "", "", "")	//used to flag for Secondary Ammo
					}
					else if ( wep.GetPrimaryAmmoType() == TF_AMMO.GRENADES1 ) {
						AmmoFix.AddAttribute("maxammo grenades1 increased", 1, -1)
						AmmoFix.ReapplyProvision()
						EntityOutputs.RemoveOutput(AmmoFix, "OnUser4", "", "", "")	//used to flag for GRENADES1 Ammo
					}
				}
				FixedGun = wep
				break
			}
		}
	}
	
// switches to another weapon if active one was disabled

	if (CVAR_GTFW_ENABLEWEAPON_AUTO_SWITCH) {
		this.SwitchToActive(FixedGun)
	}
	
	return FixedGun
}


//-----------------------------------------------------------------------------
// Purpose: Returns weapon from player as a hPlayer.
//	-> See top of script for more info
//-----------------------------------------------------------------------------
::CTFPlayer.ReturnWeapon <- function(searched_weapon=null)
{
//Error if param is null
	if ( searched_weapon == null ) {
		GTFW_DevPrint("give_tf_weapon ERROR: ReturnWeapon failed. Parameter is null. Returning null.")
		return null
	}
	local GetThis = null
//searches for the correct item based on parameter 'searched_weapon'...
	local baseitem = this.ReturnWeaponTable(searched_weapon)
	if ( baseitem == null ) {
		GTFW_DevPrint("give_tf_weapon ERROR: ReturnWeapon failed. Could not find '"+searched_weapon+"'. Returning null.")
		return null
	}
	GetThis = baseitem.itemID

	local YourGunFoundBySaxtonHale = null

	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
	{
		local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
		
		if ( wep )
		{
			if ( GTFW_ReturnWeaponBySlotBool(wep, searched_weapon) )
			{
				GetThis = GetItemID(wep)
			}
			if ( GetItemID(wep) == GetThis )
			{
				YourGunFoundBySaxtonHale = wep
				break
			}
		}
	}
	return YourGunFoundBySaxtonHale
}


//-----------------------------------------------------------------------------
// Purpose: Finds item ID of weapon.
//-----------------------------------------------------------------------------
::GetItemID <- function(wep=null)
{
//Error if param is wep is null
	if ( wep == null ) {
		//GTFW_DevPrint("give_tf_weapon ERROR: GetItemID failed. Parameter is null. Returning null.")
		return null
	}
// Finds item ID
	local ItemID = NetProps.GetPropInt(wep, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
	//if ( NetProps.GetPropInt(wep, "m_bValidatedAttachedEntity") ) {
	if ( IS_CUSTOM(wep, false) ) { //if custom
		ItemID = ItemID | (1 << 20) //sets bit 20 for searching in ReturnWeaponTable
		NetProps.SetPropInt(wep, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", ItemID )
	}
	return ItemID
}



//-----------------------------------------------------------------------------
// Purpose: Updates the class arms model to another one.
// EXPERIMENTAL: Probably don't use this unless your ent count to skyrocket.
// Each weapon's viewmodel needs an ent (tf_wearable_vm) to make this work!
// You need to update it every time the player touches the resupply.
//-----------------------------------------------------------------------------
::CTFPlayer.CreateArmsModel <- function(arms_model=null)
{
	if ( arms_model == null || type( arms_model ) != "string" ) {
		GTFW_DevPrint("give_tf_weapon: CreateArmsModel failed. Parameter is invalid.")
		return
	}
	local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
	
// Table for bonemerged class arms, per player.
// If there is already a model, delete it.
	if ( this in PlayerLoadoutGlobal_BonemergedArms ) {
		local arms = PlayerLoadoutGlobal_BonemergedArms[this]
		if ( arms && arms.IsValid() ) {
			arms.Kill()
		}
		delete PlayerLoadoutGlobal_BonemergedArms[this]
	}
	
	local wearable_handle = this.GTFW_CreateCustomWeaponModel(false, main_viewmodel, arms_model)	// creates player class' arms, parents and does all that stuff

// Puts into a table "player = arms model" for easy tracking
	::PlayerLoadoutGlobal_BonemergedArms[this] <- wearable_handle
	
/*	
	if ( !( this in PlayerLoadoutGlobal_AmmoFix ) ) {
		::PlayerLoadoutGlobal_AmmoFix[this] <- {}
		local AmmoFix = this.CreateCustomWearable(null, "models/empty.mdl")
		::PlayerLoadoutGlobal_AmmoFix[this] <- AmmoFix
	}
	if ( EntityOutputs.HasAction(AmmoFix, "OnIgnite") == false ) {
		EntityOutputs.AddOutput(AmmoFix, "OnIgnite", "", "", "", 0.0, -1)
	}*/
	
	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
	{
		local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
		
		if ( wep )
		{
			IS_UNINTENDED(wep, true)
			local wep_mdl = NetProps.GetPropInt(wep, "m_iWorldModelIndex")
			this.UpdateWeapon(wep, wep_mdl, wep_mdl)
		}
	}
	this.UpdateArms()
	this.AddThinkToViewModel()
	return wearable_handle
}

/*Notes for viewmodels (UNFINISHED)
main_viewmodel (tf_viewmodel) needs to be the class arms model for bonemerging with weapon_arms. Cannot be unparented without complication. Cannot arbitrarily set "m_hWeapon" (netprop for current weapon entity seen by player).
weapon_arms (tf_wearable_vm) are the new class' hands that bonemerge with main_viewmodel.
baseitem (the weapon entity) displays the thirdperson model but the model it uses is the class arms.
When baseitem is unparented, it unparents the third person model from the player. However, doing this makes the weapon stay visible with taunts. (A think script fixes this)
baseitem's viewmodel animation sequences are taken from main_viewmodel.
baseitem's modelindex are the /class_arms/. Changing this changes what sequences are read by main_viewmodel.
baseitem netprop "m_iViewModelIndex" is viewmodel index. Cannot change arbitrarily.
baseitem netprop "m_iWorldModelIndex" is thirdperson index. Cannot change arbitrarily.

//How the weapon's VIEWMODEL changes visibility depending on when player is holding the weapon:
new_weapon_viewmodel (tf_wearable_vm) is another entity model parented to the existing viewmodel.
new_weapon_viewmodel links itself to the baseitem (w/ netprop "m_hWeaponAssociatedWith")
baseitem links itself to the new_weapon_viewmodel (w/ netprop "m_hExtraWearableViewModel")

//How the weapon's THIRDPERSON/WORLD MODEL changes visibility depending on when player is holding the weapon:
new_weapon_thirdperson (tf_wearable) is another entity model parented on the player.
new_weapon_thirdperson links itself to the baseitem (w/ netprop "m_hWeaponAssociatedWith")
baseitem links itself to the new_weapon_thirdperson (w/ netprop "m_hExtraWearable")

//viewmodel hierarchy:
main_viewmodel sequences [become]-> baseitem's sequences
main_viewmodel (tf_viewmodel) sequences are used by weapon_arms (tf_wearable_vm) for bonemerging
weapon_arms bonemerge with baseitem to complete the effect that class is holding the baseitem
baseitem's sequences MUST MATCH main_viewmodel's

//If you intend to update the weapon's animation sequences:
Can set Sequence of weapon via main_viewmodel. Example for Scout's Bat:
main_viewmodel.SetSequence(main_viewmodel.LookupSequence("b_draw") )

You can change which sequence list by changing the model itself to a different class arms model.
change the main_viewmodel using main_viewmodel.SetModelSimple() to change to new set of class arms
change the baseitem's modelindex (which are class_arms) to the animations you want to use for the new weapon
However, now that SetCustomViewModel() exists, changing the main_viewmodel isn't necessary anymore.
*/


//-----------------------------------------------------------------------------
// Purpose: Creates a tf_wearable and associates it with a weapon
//-----------------------------------------------------------------------------
::CTFPlayer.CreateCustomWearable <- function(weapon=null, wearable_model=null)
{
//Error if param model isn't a string nor number
	if ( type( wearable_model ) != "string" && type( wearable_model ) != "integer" ) {
		GTFW_DevPrint("give_tf_weapon ERROR: CreateCustomWearable failed. One or more parameters are invalid. Returning null.")
		return null
	}
// Precaches weapon if string
	if ( type( wearable_model ) == "string" )
	{
		PrecacheModel(wearable_model)
		wearable_model = GetModelIndex(wearable_model)
	}
	
// our properties. Taken from source code for Super Zombie Fortress + SCP Secret Fortress
	local wearable = Entities.CreateByClassname("tf_wearable")
	
	wearable.SetAbsOrigin(this.GetLocalOrigin())
	wearable.SetAbsAngles(this.GetLocalAngles())
	NetProps.SetPropInt(wearable, "m_bValidatedAttachedEntity", 1)
	NetProps.SetPropEntity(wearable, "m_hOwnerEntity", this)
	NetProps.SetPropInt(wearable, "m_iTeamNum", this.GetTeam())
	NetProps.SetPropInt(wearable, "m_Collision.m_usSolidFlags", Constants.FSolid.FSOLID_NOT_SOLID)
	NetProps.SetPropInt(wearable, "m_CollisionGroup", 11)
	NetProps.SetPropInt(wearable, "m_fEffects", 129)
	
	NetProps.SetPropInt(wearable, "m_AttributeManager.m_Item.m_iEntityQuality", 0)
	NetProps.SetPropInt(wearable, "m_AttributeManager.m_Item.m_iEntityLevel", 1)
	NetProps.SetPropInt(wearable, "m_AttributeManager.m_Item.m_bInitialized", 1)
	
	NetProps.SetPropInt(wearable, "m_nModelIndex", wearable_model)

	if ( weapon )
	{
		NetProps.SetPropEntity(wearable, "m_hWeaponAssociatedWith", weapon)
		NetProps.SetPropEntity(weapon, "m_hExtraWearable", wearable)
	}
	
	Entities.DispatchSpawn(wearable)
	DoEntFire("!self", "SetParent", "!activator", 0, this, wearable)
	wearable.KeyValueFromString("targetname", "tf_wearable_vscript")
	
	return wearable
}


//-----------------------------------------------------------------------------
//	Purpose: Handles registering custom weapons.
//-----------------------------------------------------------------------------
::RegisterCustomWeapon <- function(item_name, weapon, use_original_stats=false, stats_function=null, custom_arms_model=null, custom_weapon_model=null)
{
//Error if params are invalid
	if ( type( item_name ) != "string" || type( weapon ) != "string" ) {
		GTFW_DevPrint("give_tf_weapon ERROR: RegisterCustomWeapon failed. MUST use strings for custom item name and base item. Returning null.")
		return null
	}
	
//searches for the correct item based on parameter 'weapon'...
//'weapon' can be a handle, string name (ex "Brass Beast"), weapon ID (from items_game.txt), or slot (negative value)
	local baseitem = GTFW_SearchEquipReg(weapon)
	if ( baseitem == null ) {
		GTFW_DevPrint("give_tf_weapon ERROR: RegisterCustomWeapon failed. Returning null.")
		return null
	}
	local CW_ID = baseitem.itemID | (1 << 20)
	
	GTFW_DevPrint("give_tf_weapon: Registering... "+item_name)
	::TF_CUSTOM_WEAPONS_REGISTRY[item_name] <- TF_CUSTOM_WEPS(item_name, baseitem.className, baseitem.tf_class, baseitem.slot, CW_ID, use_original_stats, stats_function, custom_arms_model, baseitem.ammo_type, baseitem.clip, baseitem.reserve, custom_weapon_model, custom_weapon_model, baseitem.wearable)
	
	GTFW_DevPrint("give_tf_weapon: Register Success!")
}


//-----------------------------------------------------------------------------
//	Purpose: Handles registering custom weapons.
//	Ex version gets rid of pesky ammo setting bugs by overwriting the ammo here instead of in the stats_function
//-----------------------------------------------------------------------------
::RegisterCustomWeaponEx <- function(item_name, weapon,  use_original_stats=false, stats_function=null, custom_arms_model=null, custom_world_model=null, custom_view_model=null, custom_extra_wearable=null, ammotype=null, clipsize=null, ammoreserve=null)
{
//Error if params are invalid
	if ( type( item_name ) != "string" ) {
		GTFW_DevPrint("give_tf_weapon ERROR: RegisterCustomWeapon failed. MUST use strings for custom item name. Returning null.")
		return null
	}
	else if ( type( use_original_stats ) != "bool" ) {
		GTFW_DevPrint("give_tf_weapon ERROR: RegisterCustomWeapon failed. MUST use bool for use_original_stats. Returning null.")
		return null
	}
//searches for the correct item based on parameter 'weapon'...
//'weapon' can be a handle, string name (ex "Brass Beast"), weapon ID (from items_game.txt), or slot (negative value)
	local baseitem = GTFW_SearchEquipReg(weapon)
	if ( baseitem == null ) {
		GTFW_DevPrint("give_tf_weapon ERROR: RegisterCustomWeapon failed. Returning null.")
		return null
	}
	if ( use_original_stats == false ) {
		ammoreserve = baseitem.reserve
	}
	if ( ammotype == null ) {
		ammotype = baseitem.ammo_type
	}
	if ( clipsize == null ) {
		clipsize = baseitem.clip
	}
	if ( ammoreserve == null ) {
		ammoreserve = baseitem.reserve
	}
	local CW_ID = baseitem.itemID | (1 << 20)
	
	::TF_CUSTOM_WEAPONS_REGISTRY[item_name] <- TF_CUSTOM_WEPS(item_name, baseitem.className, baseitem.tf_class, baseitem.slot, CW_ID, use_original_stats, stats_function, custom_arms_model, ammotype, clipsize, ammoreserve, custom_world_model, custom_view_model, custom_extra_wearable)
}


//-----------------------------------------------------------------------------
//	Purpose: Fixes bots using this script
//-----------------------------------------------------------------------------
::CTFBot.GTFW_Cleanup <- CTFPlayer.GTFW_Cleanup
::CTFBot.SwitchToActive <- CTFPlayer.SwitchToActive
::CTFBot.HasGunslinger <- CTFPlayer.HasGunslinger
::CTFBot.ReturnWeaponTable <- CTFPlayer.ReturnWeaponTable
::CTFBot.GTFW_PostWepFix <- CTFPlayer.GTFW_PostWepFix
::CTFBot.AddWeapon <- CTFPlayer.AddWeapon
::CTFBot.UpdateArms <- CTFPlayer.UpdateArms
::CTFBot.UpdateWeapon <- CTFPlayer.UpdateWeapon
::CTFBot.GTFW_CreateCustomWeaponModel <- CTFPlayer.GTFW_CreateCustomWeaponModel
::CTFBot.AddThinkToViewModel <- CTFPlayer.AddThinkToViewModel
::CTFBot.GiveWeapon <- CTFPlayer.GiveWeapon
::CTFBot.DeleteWeapon <- CTFPlayer.DeleteWeapon
::CTFBot.ReturnWeaponBySlot <- CTFPlayer.ReturnWeaponBySlot
::CTFBot.DisableWeapon <- CTFPlayer.DisableWeapon
::CTFBot.EnableWeapon <- CTFPlayer.EnableWeapon
::CTFBot.ReturnWeapon <- CTFPlayer.ReturnWeapon
::CTFBot.CreateArmsModel <- CTFPlayer.CreateArmsModel
::CTFBot.CreateCustomWearable <- CTFPlayer.CreateCustomWearable