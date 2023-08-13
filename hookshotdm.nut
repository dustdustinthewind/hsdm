// TODO: increase pack size
//       check: CTFAmmoPack.m_nModelIndexOverrides.m_flModelScale

// Fuck resupply, all my homies hate resupply
// "*post*_inventory" my fucking ass
/*function OnGameEvent_post_inventory_application(params)
{
	//printl("inventory")
	if ("userid" in params)
	{
		local hPlayer = GetPlayerFromUserID(params.userid)
		hPlayer.GTFW_Cleanup()
		Give_HSDM_Weapon(hPlayer)
		hPlayer.AddCond(56)
	}
}
	__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)	//<-- Must be after ANY OnGameEvent!*/

function OnGameEvent_player_spawn(params)
{
	//printl("spawn")
	if ("userid" in params)
	{
		local hPlayer = GetPlayerFromUserID(params.userid)
		//printl(hPlayer.GetPlayerClass())
		hPlayer.GTFW_Cleanup()
		Give_HSDM_Weapon(hPlayer)
		AddPlayerThinkScript(hPlayer)
		hPlayer.AddCond(56)
	}
}
	__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)	//<-- Must be after ANY OnGameEvent!

::NoCritWeapons <- [
	"",
	"Direct Hit",
	"Market Gardener",
	"Flare Gun",
	"Festive Flare Gun",
	"Detonator",
	"Backburner",
	"Festive Backburner",
	"Ambassador",
	"Loose Cannon",
	"Neon Annihilator",
	"Killing Gloves of Boxing",
	"Sticky Jumper" // i can't believe i have to do this
]

function AddPlayerThinkScript(player)
{
	AddThinkToEnt(player, null)
	if (player.ValidateScriptScope())
	{
		local entityscript = player.GetScriptScope()
		entityscript["think_PlayerThinkScript"] <- function()
		{
			// remove crits for certain weapons
			// with fast swap-to/from speed of the hookshot, you can accidentally get a crit shot, or a non-crit hookshot
			//  it has also been observed to happen between swapping normal weapons xd (just saw it dragons to flare whyyyy)
			// TODO: figure out something better (no weapon swapping event i can hijack darn)
			//       make hookshot 100% crits through an attribute?
			//       mod mini-crit airborne isn't perfect, mini-crit, and only on airborne targets, but could add crits whenever minicrits?
			// CHECK: is this still an issue now we we know we can do 0.0 for think scripts?

			local activeWeapon = player.GetActiveWeapon()      // tf2 weapon
			local wep = player.ReturnWeaponTable(activeWeapon) // give_tf_weapon weapon

			local demoknightGrounded = false
			local demoknightCrits = false
			local marketGardenCrits = false

			local playerClass = player.GetPlayerClass()

			// if gardening and active weapon is market garden
			local gardener = playerClass == 3 && wep && wep.itemName == "Market Gardener"
			// if blast jumping, show crits
			local marketGardenCrits = gardener && player.InCond(81)

			local demoknight = playerClass == 4 && !HasNonMeleeWeapon(player)
			if (demoknight)
			{
				local currentVelocity = player.GetVelocity().Length()
				demoknightCrits = currentVelocity >= 700
				demoknightGrounded = player.LastDemoknightCrits && demoknightCrits
				player.LastDemoknightCrits = demoknightCrits;
			}
				
			local exceptionClasses = demoknight || gardener
			local critException = marketGardenCrits || demoknightCrits

			if (activeWeapon && !demoknightGrounded)
			{
				if (!critException && (NoCritWeapons.find(wep.itemName) || exceptionClasses))
					player.RemoveCond(56)
				else
					player.AddCond(56)
			}

			return demoknightGrounded ? 0.4 : 0.0; // give demoknights a window to hit after losing velocity
		}
		AddThinkToEnt(player, "think_PlayerThinkScript")
	}
}

// Not needed i think anymore, now that we modify current weapons rather than give new ones
/*function OnGameEvent_player_death(params)
{
	if ("userid" in params)
	{
		local hPlayer = GetPlayerFromUserID(params.userid)
		hPlayer.GTFW_Cleanup() // i doubt this does anything but ya know just in case
		// delete the weps
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = hPlayer.ReturnWeaponBySlot(i)
			if (wep)
				wep.Destroy()
		}
	}
}
	__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)*/

::BuildingClassNames <- [
	"",
	"obj_sentrygun",
	"obj_dispenser",
	"obj_teleporter" // not 100% sure yet
]

function OnScriptHook_OnTakeDamage(params)
{
	local weapon = params.weapon
	// what did we damage
	local entityDamaged = params.const_entity 
	// is it player?
	local victim = entityDamaged.IsPlayer() || BuildingClassNames.find(entityDamaged.GetClassname())
	
	// weapon valid and did we attack a valid target?
	if (weapon && victim) 
	{
		local wepClassName = weapon.GetClassname()
		local attacker = weapon.GetOwner()

		// hitscan gain ammo on hit
		if (WeaponsThatGainClipOnHit.find(wepClassName) && weapon.Clip1() <= weapon.GetMaxClip1() + 1) // + 1 for short stop. if you shoot two players at once shortstop will fill to 2. who fucking cares
			weapon.SetClip1(weapon.Clip1() + 1)

		// dragons gain ammo on bonus
		// consider making this work for flares too?
		local ammoCount = NetProps.GetPropIntArray(attacker, "m_iAmmo", TF_AMMO.PRIMARY)

		if (DamageBonusThatGainReserveOnHit.find(params.damage_custom) != null && ammoCount < HSDM_DRAGONS_AMMO)
		{
			NetProps.SetPropIntArray(attacker, "m_iAmmo", ammoCount + 1, TF_AMMO.PRIMARY)
			if (ammoCount == 0) attacker.Weapon_Switch(weapon) // don't swap off dragons if we run out of ammo
			// ^ glitchy, what if player wants to swap to flare? maybe we only swap back to dragons if the victim is still alive?
		}
	}
}
	__CollectGameEventCallbacks(this) // why is this shorter?

::WeaponsThatGainClipOnHit <- [
	"",
	"tf_weapon_smg",
	"tf_weapon_pistol",
	"tf_weapon_pistol_scout",
	"tf_weapon_handgun_scout_secondary", // scout-only pistols
	"tf_weapon_handgun_scout_primary" // shortstop
	//"tf_weapon_syringegun_medic"
]

::DamageBonusThatGainReserveOnHit <- [
	0,
	Constants.ETFDmgCustom.TF_DMG_CUSTOM_DRAGONS_FURY_BONUS_BURNING, // Dragons fury bonus
]

function DoYourThing(weapon, damageBonus)
{
}

// Consider only giving clip to active weapon, or non-active weapon, or only primary, or only secondary
function OnGameEvent_item_pickup(params)
{
	// typical checks and if we picked up an ammo box
	if  ("item" in params && "userid" in params && (params.item.find("ammo") != null))
	{
		local hPlayer = GetPlayerFromUserID(params.userid)

		// only pick up ammo once a tick
		if (!PlayerAlreadyPickedUpAmmoThisTick(hPlayer))
		{
			//printl(params.item)

			// allow Clip1 to reach +1 MaxClip1 if ammopack is large and Clip1 is already max
			local overfillClip = params.item == "ammopack_large"

			// used for excepting weapons that shouldn't use this system (crossbow)
			local validPrimary = true
			local validSecondary = true

			local thereIsRevolver = false
			local thereIsCaber = false
			local thereIsShortstop = false
			local thereIsPrettyBoys = false

			// how the fuck did this turn into an if nest nightmare
			// oh come on its not that bad, kinda pretty actually
			// can shit be inversed? think i started making hard if blocks like this casue an inverse didn't work
			for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
			{
				local wep = hPlayer.ReturnWeaponBySlot(i)
			
				if (wep)
				{
					local wepClassName = wep.GetClassname()

					local isRevolver = wepClassName == "tf_weapon_revolver"
					if (!thereIsRevolver) thereIsRevolver = isRevolver
					local revolverBonus = 0
					if (isRevolver) revolverBonus = 2

					local isCaber = wepClassName == "tf_weapon_stickbomb"
					if (!thereIsCaber) thereIsCaber = isCaber

					local isShortstop = wepClassName == "tf_weapon_handgun_scout_primary"
					if (!thereIsShortstop) thereIsShortstop = isShortstop

					local isPrettyBoys = wepClassName == "tf_weapon_handgun_scout_secondary" // will include winger but fuck you
					if (!thereIsPrettyBoys) thereIsPrettyBoys = isPrettyBoys

					local lowerPrimary = LowerPrimaryAmmoFor(wep, hPlayer)
					local lowerSecondary = LowerSecondaryAmmoFor(wep, hPlayer)
				
					// are we allowed to lower its ammo for hack?
					if (lowerPrimary && lowerSecondary)
					{
						// if reloadable weapon and ready to be filled (owo)
						if (wep.Clip1() != -1 && wep.Clip1() <= wep.GetMaxClip1() + revolverBonus)
						{
							local max = wep.GetMaxClip1()
							if (isRevolver) max = 4      // revolver gets max mfax overfill of 4
							else if (overfillClip) max++ // every other overfill only gets max+1

							// fill or... overfill (OωO)
							local clip = wep.Clip1() + 1 // add 1 to clip1
							if (clip > max) clip = max   // clamp to max
 				
							wep.SetClip1(clip) // * * (-ω-) * * i'm soo full!!
							// ... stop the uwu shit
						}
					}
					// was it secondary or primary that wasn't allowed?
					else
					{
						if (validPrimary) validPrimary = lowerPrimary
						if (validSecondary) validSecondary = lowerSecondary
					}
				}
			}
		
			// bugfix to prevent reserves from going to high
			FixAmmoFor(hPlayer, thereIsShortstop, thereIsPrettyBoys)

			LowerAmmosByOne(hPlayer, validPrimary, validSecondary || thereIsRevolver)

			// caber regen on large ammo pack
			if (thereIsCaber && overfillClip) RegenerateCaber(hPlayer)
		}			
	}
}
	__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)

function FixAmmoFor(hPlayer, shortstop, prettyboys)
{
	// shortstop
	if (shortstop)
		NetProps.SetPropIntArray(hPlayer, "m_iAmmo", 2 + 1, TF_AMMO.PRIMARY)

	// prettyboys
	if (prettyboys)
		NetProps.SetPropIntArray(hPlayer, "m_iAmmo", 6, TF_AMMO.SECONDARY)
}

// Bug: shield insta refills when caber equipped
function RegenerateCaber(hPlayer)
{
	local playerHP = hPlayer.GetHealth()
	local reserveCounts = [
		NetProps.GetPropIntArray(hPlayer, "m_iAmmo", TF_AMMO.PRIMARY),
		NetProps.GetPropIntArray(hPlayer, "m_iAmmo", TF_AMMO.SECONDARY)
	]
	local clipCounts = [-1,-1]
	local shieldCharge = NetProps.GetPropFloat(hPlayer, "m_Shared.m_flChargeMeter")
	printl(shieldCharge)

	for (local i = 0; i < 2; i++)
	{
		local wep = hPlayer.ReturnWeaponBySlot(i)

		if (wep)
		{
			clipCounts[i] = wep.Clip1()
		}
	}
	
	hPlayer.Regenerate(true) // respawn caber, hopefully doesn't break shits
	
	hPlayer.GTFW_Cleanup()
	Give_HSDM_Weapon(hPlayer)
	hPlayer.AddCond(56)

	// Give ammo and health
	hPlayer.SetHealth(playerHP)

	NetProps.SetPropIntArray(hPlayer, "m_iAmmo", reserveCounts[0], TF_AMMO.PRIMARY)
	NetProps.SetPropIntArray(hPlayer, "m_iAmmo", reserveCounts[1], TF_AMMO.SECONDARY)
	
	local primary = hPlayer.ReturnWeaponBySlot(0)
	if (primary) primary.SetClip1(clipCounts[0])
	local secondary = hPlayer.ReturnWeaponBySlot(1)
	if (secondary) secondary.SetClip1(clipCounts[1])

	NetProps.SetPropFloat(hPlayer, "m_Shared.m_flChargeMeter", shieldCharge)
}

// make sure we don't call ammo pickup multiple times same tick
// EDGE CASE: if two players pick up ammo on the same tick, who gets the adjustment and who gets shafted?
::LastTimeAmmoPickUp <- 0
// do i need to :: ?
// TODO: make this a player variable instead a global variable

function PlayerAlreadyPickedUpAmmoThisTick(hPlayer)
{
	local sameTime = Time() == LastTimeAmmoPickUp
	LastTimeAmmoPickUp = Time()
	return sameTime
}

// Exceptions to ammo hack:
//  Crossbow x (maybe allow overfill at 0 reserve) (eh, complicated fuck that shit for now)
//  Pistols x
//  Syringe Guns x
//  Smgs x
//  Beggars / Air Strike x
::DoNotLoadThesePrimariesPlzThankYou <- [
	"", // dummy? plz work plz work plz work plz work
	"Crusader's Crossbow",
	"Syringe Gun", "Unique Syringe Gun",
	"Blutsauger",
	"Overdose",
	"Huntsman", "Fortified Compound",
	"Beggar's Bazooka", "Beggars",
	"Air Strike", "Airstrike",
	//"Shortstop"
]

// maybe shoulda done "load these secondaries thank you" oh well
::DoNotLoadTheseSecondariesPlzThankYou <- [
	"", // why the fuck do i have to do this?????
	"Pistol", "Unique Pistol",
	"C.A.P.P.E.R.", "CAPPER",
	"Lugermorph", "Luger", "Vintage Lugermorph", "Vintage Luger",
	"SMG", "Unique SMG",
	"Winger",
	"Pretty Boy's Pocket Pistol", "PBPP"
	"Cleaner's Carbine", 
]

function LowerPrimaryAmmoFor(weapon, player = null)
{
	return player && !DoNotLoadThesePrimariesPlzThankYou.find(player.ReturnWeaponTable(weapon).itemName)
}

function LowerSecondaryAmmoFor(weapon, player = null)
{
	return player && !DoNotLoadTheseSecondariesPlzThankYou.find(player.ReturnWeaponTable(weapon).itemName)
}

function Give_HSDM_Weapon(hPlayer)
{
	local lowerAmmoForPrimary = true
	local lowerAmmoForSecondary = true

	local isThereShortStop = false
	local isTherePrettyBoys = false

	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
	{
		// find wep
		local realWep = hPlayer.ReturnWeaponBySlot(i) // tf2 weapon
		local wep = hPlayer.ReturnWeaponTable(realWep) // give_tf_weapon weapon

		// if it exists, change it to hsdm ver
		if (wep != null)
		{	
			local wepClassName = realWep.GetClassname()
			printl(wepClassName)	
			local customWeapon = hPlayer.ReturnWeaponTable(wep.itemName + " HsDM") // give_tf_weapon weapon
			if (customWeapon)
			{
				// use the stats function on tf2 weapon
				customWeapon.func(realWep, hPlayer)
				NetProps.SetPropEntity(realWep, "m_hOwnerEntity", hPlayer);
				NetProps.SetPropEntity(realWep, "m_hOwner", hPlayer);
				realWep.SetOwner(null)
				realWep.SetOwner(hPlayer)
				realWep.ReapplyProvision()

				// check ammo (for rare cases where ammo counts are too high)
				if (!isThereShortStop)
					isThereShortStop = wepClassName == "tf_weapon_handgun_scout_primary"
				if (!isTherePrettyBoys)
					isTherePrettyBoys = wepClassName == "tf_weapon_handgun_scout_secondary"

				// lower ammo if needed
				if (!LowerPrimaryAmmoFor(realWep, hPlayer)) lowerAmmoForPrimary = false
				if (!LowerSecondaryAmmoFor(realWep)) lowerAmmoForSecondary = false
			}
			else
			{
				printl(wep.itemName + " was deleted")
				realWep.Destroy()
			}
		}
	}
	
	hPlayer.Regenerate(true)
	FixAmmoFor(hPlayer, isThereShortStop, isTherePrettyBoys)
	LowerAmmosByOne(hPlayer, lowerAmmoForPrimary, lowerAmmoForSecondary)
}

function LowerAmmosByOne(hPlayer, validPrimary, validSecondary)
{
	local primary = hPlayer.ReturnWeaponBySlot(0)
	if (primary && validPrimary && primary.Clip1() != -1)
		NetProps.SetPropIntArray(hPlayer, "m_iAmmo", NetProps.GetPropIntArray(hPlayer, "m_iAmmo", TF_AMMO.PRIMARY) - 1, TF_AMMO.PRIMARY)
	
	local secondary = hPlayer.ReturnWeaponBySlot(1)
	if (secondary && validSecondary && secondary.Clip1() != -1)
		NetProps.SetPropIntArray(hPlayer, "m_iAmmo", NetProps.GetPropIntArray(hPlayer, "m_iAmmo", TF_AMMO.SECONDARY) - 1, TF_AMMO.SECONDARY)
}

function HasNonMeleeWeapon(hPlayer)
{
	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
	{
		local realWep = hPlayer.ReturnWeaponBySlot(i)
		local wep = hPlayer.ReturnWeaponTable(realWep)
		// if wep exists, is not a melee weapon, and does damage, return true, otherwise keep looping
		// Not working with rocket jumper + mantreads + pan ffff
		// maybe just remove this shit?
		if (realWep && !realWep.IsMeleeWeapon() && wep && WeaponDoesDamage(wep.itemName))
			return true
	}
}

// why you including all classes?
// cause i'm not going to fucking have stats for all 160 weapons in the game for a while
// atm, we just deyeet any item that isn't ready for the gamemode
// if you make a loadout that's nothing but a melee, sure go for your 195 damage shits and giggles fuck you
// Doesn't seem to work who fucking cares about all this work lmfao
::WeaponsThatDoNotDoDamage <-
[
	"",
	"Basic Spellbook","Halloween Spellbook","Fancy Spellbook",
	"Spellbook Magazine",
	"Grappling Hook", // technically not but shuddup
	"Bonk","Bonk! Atomic Punch","Festive Bonk!", "Festive Bonk"
	"CAC","Crit-a-Cola",
	"Milk","Mad Milk","Mutated Milk"
	"RJ","Rocket Jumper",
	"Buff Banner", "Buff",
	"Gunboats",
	"Battalion's Backup", "Backup",
	"Concheror", "Conch",
	"Mantreads",
	"B.A.S.E. Jumper Soldier", "Parachute Secondary",
	"Gas Passer",
	"B.A.S.E. Jumper Demo", "Parachute Primary",
	"Sticky Jumper", "SJ",
	"Chargin' Targe", "Targe",
	"Splendid Screen",
	"Tide Turner",
	"Sandvich","Festive Sandvich",
	"Dalokohs Bar", "Dalokohs",
	"Buffalo Steak Sandvich", "Steak",
	"Fishcake",
	"Robo-Sandvich", "Robo Sandvich",
	"Second Banana", "Banana",
	"Wrangler","Festive Wrangler",
	"Short Circuit",
	"Build PDA","Unique Build PDA","Destruction PDA", "Destroy PDA","Engineer Toolbox","Toolbox"
	"Medigun", "Medi Gun","Unique Medigun", "Unique Medi Gun","Festive Medigun", "Festive Medi Gun",
	"Kritzkrieg",
	"Quick-Fix",
	"Vaccinator",
	"Razorback",
	"Jarate","Festive Jarate"
	"Darwin's Danger Shield", "DDS",
	"Cozy Camper",
	"Self-Aware Beauty Mark", "Bread Jarate",
	"builder_spy", "Sapper","Unique builder_spy", "Unique Sapper","Festive Sapper"
	"Red-Tape Recorder", "Red-Tape",
	"Genuine Red-Tape Recorder", "Genuine Red-Tape",
	"Ap-Sap",
	"Snack Attack", "Bread Sapper",
	"Disguise Kit PDA", "Disguise Kit",
	"Invisibility Watch", "Invis Watch","Unique Invisibility Watch", "Unique Invis Watch",
	"Dead Ringer", "DR",
	"Cloak and Dagger", "CAD",
	"Enthusiast's Timepiece", "TTG Watch",
	"Quackenbirdt",
]

function WeaponDoesDamage(wepName)
{
	return !WeaponsThatDoNotDoDamage.find(wepName)
}

// script CheckAttributeFor(GetListenServerHost()) player
// script CheckAttributeFor(GetListenServerHost().GetActiveWeapon()) current weapon
// is this anmvm thing?
function CheckAttributeFor(entity)
{
	// stolen from give_tf_weapon ::CheckAttrWep
	printl(NetProps.GetPropInt(entity, "m_AttributeManager.m_Item.m_AttributeList.m_Attributes.lengthproxy.lengthprop20"))
	for (local i = 0; i < 20; i++)
	{
		local z = ""
		i < 10 ? z = 0 : z = "";
		local wep = NetProps.GetPropInt(entity, "m_AttributeManager.m_Item.m_AttributeList.m_Attributes.0"+z+i+".m_iAttributeDefinitionIndex")
		local wep_val = NetProps.GetPropInt(entity, "m_AttributeManager.m_Item.m_AttributeList.m_Attributes.0"+z+i+".m_iRawValue32")
		local currency = NetProps.GetPropInt(entity, "m_AttributeManager.m_Item.m_AttributeList.m_Attributes.0"+z+i+".m_nRefundableCurrency")
		printl(format("%i %i %i %i",i,wep,wep_val,currency) )
	}
}