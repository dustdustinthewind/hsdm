
//-----------------------------------------------------------------------------
// The following are examples of how to use the functions in "give_tf_weapon/code.nut".
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Purpose: Give a class a weapon
// Gives Pyro the custom weapon "Hottest Hand" on respawn/resupply
//-----------------------------------------------------------------------------
function OnGameEvent_post_inventory_application(params)
{
	if ("userid" in params)
	{
		local hPlayer = GetPlayerFromUserID(params.userid)	//grab player ID...
		
		hPlayer.GTFW_Cleanup()	//clean up function, deletes unused weapon entities from GiveWeapon.
		
		if ( hPlayer.GetPlayerClass() == Constants.ETFClass.TF_CLASS_PYRO )	//If class is Pyro...
		{
			hPlayer.GiveWeapon("Hottest Hand")	//...Give custom weapon "Hottest Hand".
		}
	}
}


//-----------------------------------------------------------------------------
// The following can be places inside of events
// like `OnGameEvent_post_inventory_application`
//-----------------------------------------------------------------------------
// Purpose: Change a weapon into another weapon if they have it equipped
// If the player has a Rocket Jumper equipped, force player to use the Rocket Launcher instead.
//-----------------------------------------------------------------------------
	
	if ( hPlayer.ReturnWeapon("Rocket Jumper") ) {
		hPlayer.GiveWeapon("Rocket Launcher")
	}
	
//-----------------------------------------------------------------------------
// Purpose: Change all weapons that aren't specified weapon into another weapon
// If the player *does not* have a Rocket Jumper equipped, force player to use the Rocket Jumper.
//-----------------------------------------------------------------------------
	
	if ( !hPlayer.ReturnWeapon("Rocket Jumper") ) {
		hPlayer.GiveWeapon("Rocket Jumper")
	}

//-----------------------------------------------------------------------------
// Purpose: Change all Sniper Rifles into the Huntsman
//-----------------------------------------------------------------------------

	if ( !hPlayer.ReturnWeapon("Huntsman") && !hPlayer.ReturnWeapon("Fortified Compound") && !hPlayer.ReturnWeapon("Festive Huntsman") ) {
		local HUNTSMAN = hPlayer.GiveWeapon("Huntsman")
		
	//Huntsman isn't flipped by default. This is a potential fix.
		if ( NetProps.GetPropInt(HUNTSMAN, "m_bFlipViewModel") == 0 ) {
			NetProps.SetPropInt(HUNTSMAN, "m_bFlipViewModel", 1)
		}
	}
	
	
//-----------------------------------------------------------------------------
// Purpose: Force player to switch to specific weapon
// Forces player to switch to melee.
// Note: Weapon_Switch is a function built into vscript, and not a function by give_tf_weapon.
//-----------------------------------------------------------------------------

	hPlayer.Weapon_Switch(player.ReturnWeaponBySlot(2)) // 2 == melee slot

//-----------------------------------------------------------------------------
// Purpose: Find max ammo reserve
// Pull max Revolver ammo reserve number from a pre-defined table.
//-----------------------------------------------------------------------------

	local REVOLVER = hPlayer.ReturnWeaponTable("Revolver")
	//Use this to grab max reserve ammo:
	REVOLVER.reserve
	
	
//-----------------------------------------------------------------------------
// Purpose: Delete a weapon
// Deletes the spellbook from non-Engineer classes
//-----------------------------------------------------------------------------

	if ( player.GetPlayerClass() != Constants.ETFClass.TF_CLASS_ENGINEER )	//If any class but Engineer
	{
		player.DeleteWeapon("tf_weapon_spellbook")	//deletes the spellbook entity
	}
	
//-----------------------------------------------------------------------------
// Purpose: Another way to add functions to your weapons
// Gives you entire Engineer weapon set.
//-----------------------------------------------------------------------------

	RegisterCustomWeapon("Engy Toolbox", "Toolbox", true, function (weapon, player){
	player.GiveWeapon("Build PDA");
	player.GiveWeapon("Destroy PDA");
	}, null, null)
	
//-----------------------------------------------------------------------------
// End file. Signed `Yaki`, 13 December 2022
//-----------------------------------------------------------------------------