//-----------------------------------------------------------------------------
// This file holds all examples for custom weapons for give_tf_weapon.
// HAS a TUTORIAL! And EXAMPLE CUSTOM WEAPONS!
//-----------------------------------------------------------------------------
/*	RegisterCustomWeapon Notes
		- Watch your map's ent count!
			It spawns 1 entity for the class_arms (tf_wearable_vm) if using a given weapon.
			It spawns 2 additional entities per weapon--one for the thirdperson model (tf_wearable), and another for firstperson (tf_wearable_vm)
			It also spawns 1 ent (tf_wearable) for managing ammo supply for given weapons, disabled weapons, and enabled weapons.
		- The player's viewmodel has a think script to fix the weapon appearing when needed, and being invisible when not
		
	
	Parameters Overview
	The two functions to register your custom weapon are as follows.
	NOTE: Everything is optional except item_name, baseitem, and use_original_stats. Pass `null` if using baseitem's parameters.
	
 ->	RegisterCustomWeapon(item_name, baseitem, use_original_stats, stats_function, custom_arms_model, custom_weapon_model)
 ->	RegisterCustomWeaponEx(item_name, baseitem, use_original_stats, stats_function, custom_arms_model, custom_weapon_worldmodel, custom_weapon_viewmodel, custom_extra_wearable, ammo_type, clip_size, reserve_ammo)
		item_name = Custom item's name. Use this name in GiveWeapon to equip!
		baseitem = Accepts handles, weapon classnames, weapons by slot, or weapon string name. Same parameters as GiveWeapon() and others.
		use_original_stats = If true, uses the baseitem's stats. If false, removes all stats clean (as if stock) before applying new ones.
			If using "RegisterCustomWeaponEx()": Setting "use_original_stats" to "false" will not update the ammo counts in the parameters.
		stats_function = Custom stats to be called by a function. (Examples described later in this file)
		custom_arms_model = Custom arms animations in first person.
		custom_weapon_worldmodel = Your new weapon model over the old one. Appears in third person.
		(Ex only) custom_weapon_viewmodel = Same as above, but for first person. NOTE: If a model is set here and the other is null (and vice-versa), it will use the set model the same for both.
		(Ex only) custom_extra_wearable = Custom wearable cosmetic on wearer.
		(Ex only) ammo_type = Which weapon slot the ammo is used from.
		(Ex only) clip_size = Max clip size
		(Ex only) reserve_ammo = Max reserve ammo
*/
//-----------------------------------------------------------------------------
// Template: How to Write the Stats Function
//-----------------------------------------------------------------------------
// The stats function is executed when the weapon is equipped by the player.
// It holds any stat buffs/nerfs/any code you want to inject into the weapon.
// It has two handles you can use: The weapon, and the player.

function CW_Stats_Example_Function(weapon, player) //The name of your function that calls stats. Must include `function` `(weapon, player)`!!
{
//Our stats on the weapon. A full list of stats found on the Official TF2Wiki.
	weapon.AddAttribute("damage bonus", 1.25, -1)	//increases our damage by 25%.
	weapon.AddAttribute("max health additive penalty", -25, -1)	//reduces our health by 25.
	
//Our stats on the player.	
	player.AddCustomAttribute("move speed penalty", 0.9, -1) //reduces speed by 10%.
	//NOTE: Stats applied to the player are not cleared when the weapon leaves the player. It's best to put it on the weapon in these cases!
}
//-----------------------------------------------------------------------------


//-----------------------------------------------------------------------------
// The following is a tutorial.
// Let's start small.
//-----------------------------------------------------------------------------
// First let's register a weapon.
// Let try... a Stock knife named "Example Knife".
//-----------------------------------------------------------------------------
	
	RegisterCustomWeapon("Example Knife", "Knife", true, null, null, null)

//-----------------------------------------------------------------------------
// Hmm... I want to make this a sword instead. Let's rename the weapon "Basic Sword", and swap the weapon's model with Scout's Boston Basher reskin--the Three-Rune Blade.
//-----------------------------------------------------------------------------

	RegisterCustomWeapon("Basic Sword", "Knife", true, null, null, "models/workshop/weapons/c_models/c_scout_sword/c_scout_sword.mdl")

//-----------------------------------------------------------------------------
// I think other classes should be able to use this, however using Spy's hands for the viewmodel on all classes looks weird.
// Let's say, for this example, we'll use the Soldier's arms instead.
//-----------------------------------------------------------------------------

	RegisterCustomWeapon("Basic Sword", "Knife", true, null, GTFW_ARMS.SOLDIER, "models/workshop/weapons/c_models/c_scout_sword/c_scout_sword.mdl")

//-----------------------------------------------------------------------------
// I've made some changes to the function above (CW_Stats_Example_Function), 
// We'll use it for our example weapon.
//-----------------------------------------------------------------------------

function CW_Stats_Example_Basic_Sword(weapon, player) //The name of your function that calls stats
{
//Our stats on the weapon. A full list of attributes found on the Official TF2Wiki.
	weapon.AddAttribute("damage bonus", 1.09, -1)				//increases our damage by 9%.
	weapon.AddAttribute("max health additive penalty", -17, -1)	//reduces our health by 17.
	weapon.AddAttribute("move speed penalty", 0.96, -1)			//reduces speed by 4%.
}

// ... now let's apply it to the weapon.

	RegisterCustomWeapon("Basic Sword", "Knife", true, CW_Stats_Example_Basic_Sword, GTFW_ARMS.SOLDIER, "models/workshop/weapons/c_models/c_scout_sword/c_scout_sword.mdl")


//-----------------------------------------------------------------------------
// Let's give ourselves the weapon in-game. I've executed the script, so now I can type the following in the console to give myself the weapon:
// script GetListenServerHost().GiveWeapon("Basic Sword")
//-----------------------------------------------------------------------------
// Mm.... After playtesting, having a knife on all classes is broken. Let's change the base stats to another weapon.
// I'll change it to an all-class melee. This way, this will act like a Knife only on Spy, with the rest also working on other classes the same as their stock melee counter-parts!
//-----------------------------------------------------------------------------

	RegisterCustomWeapon("Basic Sword", "Saxxy", true, CW_Stats_Example_Basic_Sword, GTFW_ARMS.SOLDIER, "models/workshop/weapons/c_models/c_scout_sword/c_scout_sword.mdl")


//-----------------------------------------------------------------------------
// "But wait! Saxxy turns people into gold!"
// Good catch! Let's disable that and wipe the stats clean of this weapon, so we may start fresh.
//-----------------------------------------------------------------------------

	RegisterCustomWeapon("Basic Sword", "Saxxy", false, CW_Stats_Example_Basic_Sword, GTFW_ARMS.SOLDIER, "models/workshop/weapons/c_models/c_scout_sword/c_scout_sword.mdl")


//-----------------------------------------------------------------------------
// That's it! You've finished the tutorial!
// You can do what ever you want with this script. However, I know I can't tell you what to do, but I can say please think about balancing your stats for your weapons.
// -> Refer to reddit /r/TF2WeaponIdeas to further understand how to balance your new weapons!
//-----------------------------------------------------------------------------



//-----------------------------------------------------------------------------
// Now that we've got a better ideas on how to make a weapon, let's see more examples.
// This is more of the deep end!
// (You can use these examples fully work in-game, too!)
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Example weapon #1. This one is the Scout's Medieval Crossbow.
// It is based off the Crusader's Crossbow. Main stat thing is it slows the player while reloading.
//-----------------------------------------------------------------------------
function CW_Stats_Example_Scout_Medieval_Crossbow(weapon, player)
{
//Our stats
	weapon.AddAttribute("override projectile type", 8, -1)	//shoots Huntsman arrows (that headshot!)
	weapon.AddAttribute("damage penalty", 0.667, -1)		//reduces damage dealt
	
//This is a think script. What it does is constantly runs in the background, checking for what ever we put in it.
	if( weapon.ValidateScriptScope() )
	{
		const THINK_SCOUTWEAPONRELOAD_DELAY = 0.1	//delay. Place at the end after `return` to change delay time. Default is 0.1.
		
		local entityscript = weapon.GetScriptScope()
		entityscript["think_SlowPlayerDuringReload"] <- function()	//Our script's name.
		{
			if ( NetProps.GetPropInt(weapon, "m_iReloadMode") == 2)	//if we are reloading...
			{
				player.AddCustomAttribute("move speed penalty", 0.67, -1)	//Add attribute that reduces move speed.
			}
			else if ( NetProps.GetPropInt(weapon, "m_iReloadMode") != 2)	//if -not- reloading...
			{
				player.RemoveCustomAttribute("move speed penalty")	//Remove move speed penalty.
			}
			return THINK_SCOUTWEAPONRELOAD_DELAY	//return to top after 0.25 ticks
		}
		AddThinkToEnt(weapon, "think_SlowPlayerDuringReload")	//Adds the think script to handle 'weapon' after it has been validated.
	}
}

//-----------------------------------------------------------------------------
// The following function registers this weapon as "Scout Crossbow".
// Use `hPlayer.GiveWeapon("Medieval Crossbow")` to give yourself this weapon.
//-----------------------------------------------------------------------------
	RegisterCustomWeapon("Medieval Crossbow", "Crusader's Crossbow", false, CW_Stats_Example_Scout_Medieval_Crossbow, GTFW_ARMS.MEDIC, null)



//-----------------------------------------------------------------------------
// Example weapon #2. This one turns you into the Horseless Headless Horsemann.
// It is based off the Demo's Headtaker.
//-----------------------------------------------------------------------------
function CW_Stats_Example_Headless_Hatman(weapon, player)
{
// Setup
	player.SetCustomModelWithClassAnimations("models/player/demo.mdl")	//Needs to be here, else errors.
	NetProps.SetPropInt(player, "m_PlayerClass.m_iClass", 4)			//Forcefully sets tfclass to DEMOMAN
	
//Our stats
	weapon.AddAttribute("hidden maxhealth non buffed", (player.GetMaxHealth()*10) + 75, -1)	//using this attribute because it can't be overhealed
	player.SetHealth(player.GetMaxHealth())				//set health to max after given maxhealth bonus
	weapon.AddAttribute("move speed bonus", 1.25, -1)	//move speed up
	weapon.AddAttribute("damage bonus", 99, -1)			//instant death
	weapon.AddAttribute("melee range multiplier", 2, -1)//longer melee range
	weapon.AddAttribute("melee bounds multiplier", 2, -1)//larger melee range
	
	player.DeleteWeapon(TF_WEAPONSLOTS.PRIMARY)		//deletes primary weapon
	player.DeleteWeapon(TF_WEAPONSLOTS.SECONDARY)		//deletes secondary weapon
	player.DeleteWeapon(player.ReturnWeapon(-3))		//deletes anything not primary, secondary, or melee
	player.DeleteWeapon(player.ReturnWeapon(-4))		//deletes anything not primary, secondary, or melee
	player.DeleteWeapon(player.ReturnWeapon(-5))		//deletes anything not primary, secondary, or melee
	player.DeleteWeapon(player.ReturnWeapon(-6))		//deletes anything not primary, secondary, or melee
	
// Our effects
	player.SetForcedTauntCam(1)										//sets third person mode
	DoEntFire("!self", "SetModelScale", "1.3", 0, null, player)		//sets player scale
	Convars.SetValue("tf_item_based_forced_holiday", 2)				//Forces holiday to Halloween
	player.AddCustomAttribute("SPELL: set Halloween footstep type", 2, -1)	//enables Horseless Horseshoes spell walk flames
	player.AddCustomAttribute("set item tint RGB", 9109759, -1)		//sets tint for Horseless Horseshoes
	
// Deletes all cosmetics from the player
	for (local i = 0; i < 42; i++)
	{
		local wearable = Entities.FindByClassname(null, "tf_*")

		if ( wearable != null && wearable.GetOwner() == player && wearable.GetClassname() != "tf_weapon_sword" && wearable.GetClassname() != "tf_viewmodel" && wearable.Name() != "tf_wearable_vscript" )
		{
			wearable.Kill()
		}
		else
		{
			break
		}
	}
// Think script, used to remove stats from the player if the weapon disappears from loadout.
	if( player.ValidateScriptScope() )
	{
		const DELAY_THINK_STOP = 999
		const DELAY_THINK = 1
		local truefalse = true
		local entityscript = player.GetScriptScope()
		entityscript["think_HHHH_Maker"] <- function()	//Our script's name.
		{
			if ( truefalse ) {
				truefalse = false
				player.Weapon_Switch(weapon)		//vscript built-in function. Forces switch to handle 'weapon'.
				player.AddCond(41)					//locks player in melee
				return DELAY_THINK
			}
			if ( player.GetActiveWeapon() != weapon ) {	//if we unequip this weapon, force us the shapeshift back to Demoman.
				player.SetForcedTauntCam(0)
				DoEntFire("!self", "SetModelScale", "1", 0, null, player)
				player.RemoveCustomAttribute("SPELL: set Halloween footstep type")
				player.RemoveCustomAttribute("set item tint RGB")
				player.Regenerate(false)
				return DELAY_THINK_STOP	//can't stop a think script within a think script, so we delay it until oblivion
			}
			return
		}
		AddThinkToEnt(player, "think_HHHH_Maker")	//Adds the think script to handle 'weapon' after it has been validated.
	}
}

//-----------------------------------------------------------------------------
// Using an enum for define model paths
//-----------------------------------------------------------------------------
/* Tip: You can use an enum like this to create shortcuts for your coding. */
enum GTFW_MODELS_CUSTOM_WEAPONS
{
	HHH_BIGAXE		= "models/weapons/c_models/c_bigaxe/c_bigaxe.mdl",	//Horsemann's REAL Headtaker
	HHH_BIGMALLET		= "models/weapons/c_models/c_big_mallet/c_big_mallet.mdl", //Horsemann's Mallet
}
//-----------------------------------------------------------------------------
// Precaching models
//-----------------------------------------------------------------------------
//PrecacheModel("models/weapons/c_models/c_bigaxe/c_bigaxe.mdl")
//PrecacheModel("models/weapons/c_models/c_big_mallet/c_big_mallet.mdl")

//Use this function to precache models, so the game preloads them and doesn't crash.
//Not needed if using SetModelSimple function (which precaches for you)

//-----------------------------------------------------------------------------
//Registers this weapon as "Horsemann's Hex"...
// Notice we are using "RegisterCustomWeaponEx()" with "Ex" at the end. This has more properties for us to toy with!
//-----------------------------------------------------------------------------
	RegisterCustomWeaponEx("Horsemann's Hex", "HHHH", false, CW_Stats_Example_Headless_Hatman, GTFW_ARMS.DEMO, GTFW_MODELS_CUSTOM_WEAPONS.HHH_BIGAXE, null, "models/bots/headless_hatman.mdl", TF_AMMO.NONE, -1, -1)




//-----------------------------------------------------------------------------
// Example weapon #3. A Hot Hand variant that lets you shoot fireballs by taunting!
// Hadouken!
//-----------------------------------------------------------------------------
function CW_Stats_Example_Hottest_Hand(weapon, player)
{
	weapon.AddAttribute("special taunt", 1, -1) //Makes sure that Halloween holiday can't make us not use the taunt kill+fireball.
	
//Function to create a fireball, but only usable from within CW_Stats_Example_Hottest_Hand
	CTFPlayer.ShootFireball <- function()
	{
		local fireball = Entities.CreateByClassname("tf_projectile_spellfireball")
		
		fireball.SetOwner(this)
		NetProps.SetPropInt(fireball, "m_iTeamNum", this.GetTeam())
		fireball.SetLocalOrigin(this.EyePosition()+(this.EyeAngles().Forward()*32) + Vector(0,0,this.EyeAngles().z-16))
		fireball.SetLocalAngles(this.EyeAngles())
		fireball.SetAbsVelocity(this.EyeAngles().Forward()*800)

		Entities.DispatchSpawn(fireball)
	}
	
//Uses a think script to check for when the Pyro is 1) Has the HotHand and 2) Is taunting
	if( weapon.ValidateScriptScope() )
	{
		local wep = null
		local CAN_TAUNT_WITH_HOTHAND = false
	
		local entityscript = weapon.GetScriptScope()
		entityscript["think_PyroHottestHand"] <- function()	//Our script's name.
		{
			if ( player.InCond(7) && CAN_TAUNT_WITH_HOTHAND ) {	//IF taunting and while CAN_TAUNT_WITH_HOTHAND is True...
				CAN_TAUNT_WITH_HOTHAND = false
				wep = null
				
				DoEntFire("!self", "RunScriptCode", "self.ShootFireball()", 1.9, null, player)
			}
			else if ( player.GetActiveWeapon() != null && !player.InCond(7) && player.GetActiveWeapon() != wep )	// if player switches weapons...
			{
				wep = player.GetActiveWeapon()	//...make it so they don't run this condition again!
				
				if ( player.GetActiveWeapon().GetClassname() == "tf_weapon_slap" ) {	//if player is holding the hothand...
					CAN_TAUNT_WITH_HOTHAND = true	//...set to true for checking taunting with Hot Hand
				}
			}
			if ( player.GetActiveWeapon() != null && player.GetActiveWeapon().GetClassname() == "tf_weapon_slap" ) {
				player.AddCondEx(37, 0.15, player) //First-blood arena crit-boost. Constantly applies so if the weapon is gone the conditions don't stay.
			}
			else	//if not using Hot Hand
			{
				player.RemoveCond(37)
			}
			return	//uses default 0.1 delay
		}
		AddThinkToEnt(weapon, "think_PyroHottestHand")	//Adds the think script to handle 'weapon' after it has been validated.
	}
}
//-----------------------------------------------------------------------------
// Finally, registers the weapon for us to use with GiveWeapon()!
//-----------------------------------------------------------------------------
	RegisterCustomWeapon("Hottest Hand", "Hot Hand", true, CW_Stats_Example_Hottest_Hand, null, null)
	
	
//-----------------------------------------------------------------------------
// End Examples. I hope this helps explain how to use this script better.
// Contact me to tell me if it helped or not!
// And... Have fun making weapons in VScript!
//-----------------------------------------------------------------------------