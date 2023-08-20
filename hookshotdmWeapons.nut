// Consider:
//  make spy's grapple deal no damage (no sound if possible) (crits do no damage attribute?)
//  allow grapples to disable sentry? hmmmm
//   (how to?, think script prolly, find target, if sentry, disable it, when lose target, reenable sentry?)
//  allow scout to double jump after hookshot for added mobility
//
// NOTES: BASE_WEAPON values pulled from tf2wiki or looking in-game
//        if you see (x + 1) on maxammo attributes,
//         that's to account for the reserve ammo hack that allows players to *always* pick up ammo
//         ignore the + 1, in game reserve value will be x
//
//  NetProps.SetPropInt(GivenWeapon, "m_AttributeManager.m_Item.m_bOnlyIterateItemViewAttributes", 1)	// Removes all pre-existing stats of the weapon.

// Universal damage modifier, fixes sentry damage to be same as vanilla
function ChangeDamageTo(weapon, damage, changeBuildingDamage = true, shotgunMod = 1.0)
{
	local inversePlayerDamage = 1 / damage * shotgunMod
	if (damage < 1.0)
	{
		weapon.AddAttribute("damage penalty", damage, -1)
		if (changeBuildingDamage) weapon.AddAttribute("dmg bonus vs buildings", inversePlayerDamage, -1)
	}
	else
	{
		weapon.AddAttribute("damage bonus", damage, -1)
		if (changeBuildingDamage) weapon.AddAttribute("dmg penalty vs buildings", inversePlayerDamage, -1)
	}
}

function SelfBlastBoost(weapon, force, reduction = 0.75)
{
	weapon.AddAttribute("self dmg push force increased", force, -1)
	weapon.AddAttribute("rocket jump damage reduction", reduction, -1)
	// consider fall damage reduction?
	// ^ noob just use the fucking grapple lol
}

// ==========================================
//                multi class
// ==========================================

// class specific grapples
// TODO: Clean this the fuck up
function CW_Stats_Grappling_Hook_HsDM(weapon, player)
{
	// remove previous scripts
	AddThinkToEnt(weapon, null)

	local onAttach = function() { return null }
	local onDetach = function() { return null }

	local playerClass = player.GetPlayerClass()

	// set on attach/detach functions
	if (playerClass == 1) // scout
		onAttach = function()
		{
			// scout reset double jump
			NetProps.SetPropInt(player, "m_Shared.m_iAirDash", 0)
		}

	if (playerClass == 3) // soldier
		onAttach = function()
		{
			// reset parachute if not deployed
			if (!player.InCond(80))
				player.RemoveCond(122)
		}

	if (playerClass == 4) // demo
		onAttach = function()
		{
			// allow demoknight to retain crits after 650 speed for a little bit
			//NetProps.SetPropInt(player, "m_Shared.m_bJumping", 1)

			// reset parachute if not deployed
			if (!player.InCond(80))
				player.RemoveCond(122)
		}

	if (playerClass == 2) // sniper
		onAttach = function()
		{
			// sniper scope fix
			NetProps.SetPropInt(player, "m_Shared.m_bJumping", 0)
		}
	
	if (playerClass == 6) // heavy
	{
		onDetach = function()
		{
			// heavy jump-detach fix
			// v note: other classes gets 375 jump detach boost
			local heavyJumpBoost = 275
			local jump = NetProps.GetPropInt(player, "m_nButtons") & Constants.FButtons.IN_JUMP ? heavyJumpBoost : 0
			player.SetVelocity(player.GetVelocity() + Vector(0, 0, jump))
				
			// heavy fix getting stuck on hookshot when no ammo
			local ammo = NetProps.GetPropIntArray(player, "m_iAmmo", TF_AMMO.PRIMARY)
			if (player.GetLastWeapon() == player.ReturnWeaponBySlot(0) && ammo <= 0)
				player.Weapon_Switch(player.ReturnWeaponBySlot(2)); // swap to melee
		}

		onAttach = function()
		{
			// fix super jump if heavy jump-detach and ground-jump at same time
			NetProps.SetPropInt(player, "m_Shared.m_bJumping", 1)
		}
	}

	if (weapon.ValidateScriptScope())
	{
		local entityscript = weapon.GetScriptScope()
		entityscript["think_hookshotThinkScript"] <- function()
		{
			local usingGrappleThisTick = NetProps.GetPropBool(player, "m_bUsingActionSlot")
			// shooting grapple
			if (!player.GrappleProjectile && usingGrappleThisTick)
			{
				local grapple = Entities.FindByClassnameNearest("tf_projectile_grapplinghook", player.EyePosition(), 100.0)
				
				if (grapple && grapple.GetOwner() == player)
					player.GrappleProjectile = grapple
			}
			// stopped shooting grapple
			else if (!usingGrappleThisTick && player.UsedGrappleLastTick)
				player.GrappleProjectile = null

			player.UsedGrappleLastTick = usingGrappleThisTick

			if (!player.ReelDinged && Time() >= REEL_IN_COOLDOWN + player.LastTimeReeled)
			{
				player.ReelDinged = true

			}

			local grappleTarget = player.GetGrapplingHookTarget()
			
			// on detach
			if (player.LastGrappleTarget && !grappleTarget)
			{
				// run class specific function for hookshot detach
				onDetach()

				player.LastGrappleTarget = null

				StartReelInCooldown(player)
			}

			// while grappling
			if (grappleTarget)
			{
				local grapplingFunc = grappleTarget.tostring().find("func_") != null

				local grappleTargetCenter = grappleTarget.GetCenter()
				local grappleTargetRotation = grappleTarget.GetAbsAngles()

				local grappleLocation = player.GrappleProjectile.GetOrigin()
				local playerLocation = player.GetOrigin()
				local playerDistanceFromGrapple = (grappleLocation - playerLocation).Length()
				local heading = playerLocation - grappleLocation
				player.OptimalRopeLength = playerDistanceFromGrapple < player.OptimalRopeLength ? playerDistanceFromGrapple : player.OptimalRopeLength

				
				// on attach
				if (!player.LastGrappleTarget)
				{
					// set LastGrappleTarget to what we attached to
					player.LastGrappleTarget = grappleTarget
					player.OptimalRopeLength = playerDistanceFromGrapple

					// run class specific function for hookshot attach
					onAttach()
					
					// a single impulse towards grapple target
					GrappleImpulse(player, heading)

					if (grapplingFunc)
                        player.LastGrappleTargetCenter = grappleTargetCenter
				}

				// attached to func parent code
				if (grappleTarget.tostring().find("func"))
				{
					local centerDifference = player.LastGrappleTargetCenter - grappleTargetCenter
					player.GrappleProjectile.SetAbsOrigin(grappleLocation + (centerDifference * -1))
					player.SetAbsOrigin(playerLocation + (centerDifference * -1)) // change -0.5 based on how close you are to it?
					player.LastGrappleTargetCenter = grappleTargetCenter
				}

				local keys = NetProps.GetPropInt(player, "m_nButtons")

				// already reeling in or reel in using attack 3
				if (player.ReelingIn || (player.LastTimeReeled + REEL_IN_COOLDOWN < Time() && (keys & Constants.FButtons.IN_ATTACK3)))
				{
					if (playerDistanceFromGrapple < MINIMUM_OPTIMAL_ROPE_LENGTH)
						StartReelInCooldown(player)
					else
					{
						player.AddCond(32)
						ReelIn(player, heading)
						player.ReelingIn = true
					}
				}
				else if ((keys & move[1]) || (keys & move[2]) || (keys & move[3]) || (keys & move[4]))
				{
					// strafing left/right, forward/back
					local eyes = player.EyeAngles()
					local upImpulse = keys & move[1] ? eyes.Forward() * GRAPPLE_FORWARD_VELOCITY * 0.5 : Vector(0, 0, 0)
					local downImpulse = keys & move[2] ? eyes.Forward() * -GRAPPLE_FORWARD_VELOCITY : Vector(0, 0, 0)
					local leftImpulse = keys & move[3] ?  eyes.Left() * -GRAPPLE_SIDE_VELOCITY : Vector(0, 0, 0)
					local rightImpulse = keys & move[4] ? eyes.Left() * GRAPPLE_SIDE_VELOCITY : Vector(0, 0, 0)
					
					local impulse = upImpulse + downImpulse + leftImpulse + rightImpulse
					player.ApplyAbsVelocityImpulse(impulse * tickRateInSec)
				}
				// if within x units of grapple, set velocity to 0
				// hopefully to prevent a weird glitch where you go flying when you get near hook 
				// doesn't always work but this does help. maybe make bandaid bigger idk
				else if (heading.Length() < MINIMUM_OPTIMAL_ROPE_LENGTH)
					GrappleImpulse(player, Vector(0,0,0), 1, 0.998)
				
				
				//printl(playerDistanceFromGrapple + " " + player.OptimalRopeLength)
				// else apply tension and shit
				if (playerDistanceFromGrapple > player.OptimalRopeLength)
				{
					//printl(player.OptimalRopeLength)

					local tension = playerDistanceFromGrapple - player.OptimalRopeLength
					tension *= playerDistanceFromGrapple / player.OptimalRopeLength

					GrappleImpulse(player, heading, tension * TENSION_STRENGTH, 1.0)
				}
			}

			return 0.0
		}
		AddThinkToEnt(weapon, "think_hookshotThinkScript")
	}
}
	RegisterCustomWeapon("Grappling Hook HsDM", "Grappling Hook", true, CW_Stats_Grappling_Hook_HsDM, null)

::move <- [
	0,
	Constants.FButtons.IN_FORWARD,
	Constants.FButtons.IN_BACK,
	Constants.FButtons.IN_MOVELEFT,
	Constants.FButtons.IN_MOVERIGHT
]

function StartReelInCooldown(player)
{
	if (player.ReelingIn)
		player.LastTimeReeled = Time();

	player.ReelingIn = false
	player.RemoveCond(32)
}

function GrappleImpulse(player, heading, initialImpulse = ON_ATTACH_IMPULSE, reduceMomentum = MOMENTUM_RETENTION, capSpeed = false)
{
	local impulse = ImpulseInHeading(player, heading, initialImpulse)
	if (!capSpeed || impulse.Length() < initialImpulse) 
	{
		player.SetVelocity(player.GetVelocity() * reduceMomentum) // reduce current velocity to give hook-impulse more impact
		player.ApplyAbsVelocityImpulse(impulse)
	}
}

function ImpulseInHeading(player, heading, impulse)
{
	local distance = -impulse / heading.Length()
	return heading * distance
}

function ReelIn(player, heading)
{
	GrappleImpulse(player, heading, REEL_IN_SPEED, 0.1, true)
}

SHOTGUN_PELLETS <- 10.0
SHOTGUN_CRIT_DAMAGE_PER_PELLET <- 18.0
SHOTGUN_CLIP <- 6.0
SHOTGUN_RESERVE <- 32.0
function CW_Stats_Shotgun_HsDM(weapon, player)
{
	BaseShotgun(weapon, player)
	AdjustShotgunReserve(weapon, player)
}
	RegisterCustomWeapon("Shotgun HsDM", "Shotgun", true, CW_Stats_Shotgun_HsDM, null)
	RegisterCustomWeapon("Soldier Shotgun HsDM", "Shotgun", true, CW_Stats_Shotgun_HsDM, null)
	RegisterCustomWeapon("Pyro Shotgun HsDM", "Shotgun", true, CW_Stats_Shotgun_HsDM, null)
	RegisterCustomWeapon("Heavy Shotgun HsDM", "Shotgun", true, CW_Stats_Shotgun_HsDM, null)
	RegisterCustomWeapon("Engineer Shotgun HsDM", "Shotgun", true, CW_Stats_Shotgun_HsDM, null)
	RegisterCustomWeapon("Shotgun Primary HsDM", "Shotgun", true, CW_Stats_Shotgun_HsDM, null)
	RegisterCustomWeapon("Festive Shotgun HsDM", "Shotgun", true, CW_Stats_Shotgun_HsDM, null)

PANIC_ATTACK_CRIT_DAMAGE_PER_PELLET <- 14.4
PANIC_ATTACK_PELLETS <- 15.0
function CW_Stats_Panic_Attack_HsDM(weapon, player)
{
	local damagePerPellet = 173 / PANIC_ATTACK_PELLETS
	ChangeDamageTo(weapon, damagePerPellet / SHOTGUN_CRIT_DAMAGE_PER_PELLET)

	weapon.AddAttribute("clip size penalty", 2 / SHOTGUN_CLIP, -1)

	AdjustShotgunReserve(weapon, player)
}
	RegisterCustomWeapon("Panic Attack HsDM", "Panic Attack", true, CW_Stats_Panic_Attack_HsDM, null)

function AdjustShotgunReserve(weapon, player)
{
	// if engie? modify primary ammo not secondary
	local slot
	if (player.GetPlayerClass() != 9) slot = "secondary"
	else slot = "primary"
	weapon.AddAttribute("maxammo " + slot + " reduced", (2 + 1) / SHOTGUN_RESERVE, -1)
}

function BaseShotgun(weapon, player)
{
	// damage/spread
	local damagePerPellet = 144 / SHOTGUN_PELLETS // insert max damage
	ChangeDamageTo(weapon, damagePerPellet / SHOTGUN_CRIT_DAMAGE_PER_PELLET)
	//weapon.AddAttribute("bullets per shot bonus", newPelletCount / SHOTGUN_PELLETS, -1) // 5 pellets, cross bullet pattern

	// ammo
	weapon.AddAttribute("clip size penalty", 2 / SHOTGUN_CLIP, -1) // clip of 2

	// faster reload (commented out cause we can refill clip through ammo now)
	//weapon.AddAttribute("Reload time decreased", 0.75, -1) // consider .66 or lower?
}

function BasePistol(weapon, player)
{
	// difference between engie and scout
	if (player.GetPlayerClass() == 9)
		weapon.AddAttribute("maxammo secondary reduced", 40 / PISTOL_ENGIE_RESERVE, -1) // embrace large pool meme, i will not regret this
	else
		weapon.AddAttribute("maxammo secondary reduced", 6 / PISTOL_SCOUT_RESERVE, -1)

	//weapon.AddAttribute("weapon spread bonus", 0.5, -1) // Increased acc

	//weapon.AddAttribute("Reload time increased", 1.2, -1)
}

PISTOL_CRIT_DAMAGE <- 45.0
PISTOL_CLIP <- 12.0
PISTOL_SCOUT_RESERVE <- 36.0
PISTOL_ENGIE_RESERVE <- 200.0
HSDM_PISTOL_DAMAGE <- 38.0
function CW_Stats_Pistol_HsDM(weapon, player)
{
	// damage/spread
	// maybe lower damage now clip size is higher? 
	ChangeDamageTo(weapon, HSDM_PISTOL_DAMAGE / PISTOL_CRIT_DAMAGE)

	// ammo
	weapon.AddAttribute("clip size penalty", 4 / PISTOL_CLIP, -1)

	BasePistol(weapon, player)
	
}
	RegisterCustomWeapon("Pistol HsDM", "Pistol", true, CW_Stats_Pistol_HsDM, null)
	RegisterCustomWeapon("Unique Pistol HsDM", "Pistol", true, CW_Stats_Pistol_HsDM, null)
	// v check (may be "C.A.P.P.E.R")
	RegisterCustomWeapon("CAPPER HsDM", "Pistol", true, CW_Stats_Pistol_HsDM, null)
	RegisterCustomWeapon("Lugermorph HsDM", "Pistol", true, CW_Stats_Pistol_HsDM, null)
	RegisterCustomWeapon("Vintage Lugermorph HsDM", "Pistol", true, CW_Stats_Pistol_HsDM, null)
	// v should engie have different kind of pistol?
	RegisterCustomWeapon("Engineer Pistol HsDM", "Pistol", true, CW_Stats_Pistol_HsDM, null)

MELEE_CRIT_DAMAGE <- 195.0
SCOUT_MELEE_CRIT_DAMAGE <- 105.0
SPY_MELEE_CRIT_DAMAGE <- 120.0 // non backstab
// May be a damage bug with melees that have lower damage keep eye out
function CW_Stats_Stock_Melee(weapon, player)
{
	if (HasNonMeleeWeapon(player))
	{
		local playerDamage = 0

		// scout?
		if (player.GetPlayerClass() == 1)
			playerDamage = 85 / SCOUT_MELEE_CRIT_DAMAGE
		// spy?
		else if (player.GetPlayerClass() == 8)
			playerDamage = 105 / SPY_MELEE_CRIT_DAMAGE // backstab: 525 damage, still good enough
		// everyone else
		else
			playerDamage = 145 / MELEE_CRIT_DAMAGE

		ChangeDamageTo(weapon, playerDamage)
	}
}
// Oh lord the register list is super long (O////O)
	RegisterCustomWeapon("Frying Pan HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Gold Frying Pan HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Saxxy HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Conscientious Objector HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Freedom Staff HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Bat Outta Hell HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Memory Maker HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Ham Shank HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Crossing Guard HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Necro Smasher HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Prinny Machete HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Bat HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Festive Bat HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Unique Bat HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Holy Mackerel HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Festive Holy Mackerel HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Atomizer HsDM", "Atomizer", true, CW_Stats_Stock_Melee, null) // * 72 damage is fine
	RegisterCustomWeapon("Unarmed Combat HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Batsaber HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Bat HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Shovel HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Unique Shovel HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Half-Zatoichi HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null) // * do something for this, with hookshot on demoknight its unfair
	RegisterCustomWeapon("Fire Axe HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Unique Fire Axe HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Lollichop HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Bottle HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Unique Bottle HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Eyelander HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null) // *
	RegisterCustomWeapon("Ullapool Caber HsDM", "Ullapool Caber", true, CW_Stats_Stock_Melee, null) // * may need special ver for demoknight. can't pick up ammo to regen unless you have another wep :(
	RegisterCustomWeapon("Scotsman's Skullcutter HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null) // *
	RegisterCustomWeapon("Claidheamh Mor HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null) // *
	RegisterCustomWeapon("Persian Persuader HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null) // *
	RegisterCustomWeapon("Horseless Headless Horseman's Headtaker HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null) // *
	RegisterCustomWeapon("Nessie's Nine Iron HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null) // *
	RegisterCustomWeapon("Scottish Handshake HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Fists HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Unique Fists HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Gloves of Running Urgently HsDM", "Gloves of Running Urgently", true, CW_Stats_Stock_Melee) // *
	RegisterCustomWeapon("Gloves of Running Urgently MvM HsDM", "Gloves of Running Urgently MvM", true, CW_Stats_Stock_Melee) // *
	RegisterCustomWeapon("Bread Bite HsDM", "Gloves of Running Urgently MvM", true, CW_Stats_Stock_Melee) // *
	RegisterCustomWeapon("Warrior's Spirit HsDM", "Gloves of Running Urgently", true, CW_Stats_Stock_Melee) // *
	RegisterCustomWeapon("Fists of Steel HsDM", "Gloves of Running Urgently", true, CW_Stats_Stock_Melee) // *
	RegisterCustomWeapon("Apoco-Fists HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Wrench HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Festive Wrench HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Unique Wrench HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Golden Wrench HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Gunslinger HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null) // *
	RegisterCustomWeapon("Southern Hospitality HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null) // *
	RegisterCustomWeapon("Eureka Effect HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null) // *
	RegisterCustomWeapon("Bonesaw HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Festive Bonesaw HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Unique Bonesaw HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Ubersaw HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Vita-Saw HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Solemn Vow HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null) // *
	RegisterCustomWeapon("Kukri HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Unique Kukri HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Bushwacka HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null) // * We should do something different with this
	RegisterCustomWeapon("Shahanshah HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null) // * consider lowering minimum damage, max damage is chill, maybe raise to one shot solly
	RegisterCustomWeapon("Knife HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Unique Knife HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Festive Knife HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Your Eternal Reward HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null) // *
	RegisterCustomWeapon("Conniver's Kunai HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null) // *
	RegisterCustomWeapon("Big Earner HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null) // *
	RegisterCustomWeapon("Wanga Prick HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null) // *
	RegisterCustomWeapon("Sharp Dresser HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	RegisterCustomWeapon("Spy-cicle HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null) // *
	RegisterCustomWeapon("Black Rose HsDM", "Frying Pan", true, CW_Stats_Stock_Melee, null)
	// * not stock, but don't need specialized ver

	function CW_Stats_No_Change(weapon, player)
	{ }
	RegisterCustomWeapon("Bonk! Atomic Punch HsDM", "Build PDA", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Crit-a-Cola HsDM", "Build PDA", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Gunboats HsDM", "Gunboats", true, CW_Stats_No_Change) // consider tweaking whenifever we buff rocket jumping in general
	RegisterCustomWeapon("Mantreads HsDM", "Mantreads", true, CW_Stats_No_Change)    // ^?
	RegisterCustomWeapon("Thermal Thruster HsDM", "Thermal Thruster", true, CW_Stats_No_Change) // Consider tweaking swap-to-from speeds
	RegisterCustomWeapon("Ali Baba's Wee Booties HsDM", "Ali Baba's Wee Booties", true, CW_Stats_No_Change)  
	RegisterCustomWeapon("Bootlegger HsDM", "Bootlegger", true, CW_Stats_No_Change)  
	// Consider tweaking shield damage resistances or changing them to flat health increases
	RegisterCustomWeapon("Chargin' Targe HsDM", "Thermal Thruster", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Splendid Screen HsDM", "Thermal Thruster", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Tide Turner HsDM", "Thermal Thruster", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Build PDA HsDM", "Build PDA", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Unique Build PDA HsDM", "Build PDA", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Destruction PDA HsDM", "Destruction PDA", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Engineer Toolbox HsDM", "Engineer Toolbox", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Toolbox HsDM", "Engineer Toolbox", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Medigun HsDM", "Medigun", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Sandvich HsDM", "Medigun", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Dalokohs Bar HsDM", "Medigun", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Buffalo Steak Sandvich HsDM", "Medigun", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Fishcake HsDM", "Medigun", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Robo-Sandvich HsDM", "Medigun", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Second Banana HsDM", "Medigun", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Unique Medigun HsDM", "Medigun", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Kritzkrieg HsDM", "Kritzkrieg", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Quick-Fix HsDM", "Quick-Fix", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Vaccinator HsDM", "Vaccinator", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Disguise Kit PDA HsDM", "Disguise Kit PDA", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Invisibility Watch HsDM", "Invisibility Watch", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Unique Invisibility Watch HsDM", "Invisibility Watch", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Dead Ringer HsDM", "Dead Ringer", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Cloak and Dagger HsDM", "Cloak and Dagger", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Enthusiast's Timepiece HsDM", "Invisibility Watch", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Quackenbirdt HsDM", "Invisibility Watch", true, CW_Stats_No_Change)
	RegisterCustomWeapon("builder_spy HsDM", "builder_spy", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Unique builder_spy HsDM", "builder_spy", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Red-Tape Recorder HsDM", "Red-Tape Recorder", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Genuine Red-Tape Recorder HsDM", "Red-Tape Recorder", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Ap-Sap HsDM", "builder_spy", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Snack Attack HsDM", "builder_spy", true, CW_Stats_No_Change)
	RegisterCustomWeapon("Pomson 6000 HsDM", "Pomson 6000", true, CW_Stats_No_Change, null)
	RegisterCustomWeapon("B.A.S.E. Jumper Soldier HsDM", "B.A.S.E. Jumper Soldier", true, CW_Stats_No_Change)
	RegisterCustomWeapon("B.A.S.E. Jumper Demo HsDM", "B.A.S.E. Jumper Demo", true, CW_Stats_No_Change)

// ==========================================
//                  scout
// ==========================================

SCATTERGUN_PELLETS <- 10.0
SCATTERGUN_CRIT_DAMAGE_PER_PELLET <- 18.0
SCATTERGUN_CLIP <- 6.0
SCATTERGUN_RESERVE <- 32.0
function CW_Stats_Scattergun_HsDM(weapon, player)
{
	// damage/spread
	local damagePerPellet = 180 / SHOTGUN_PELLETS // insert max damage
	ChangeDamageTo(weapon, damagePerPellet / SHOTGUN_CRIT_DAMAGE_PER_PELLET)
	//weapon.AddAttribute("bullets per shot bonus", 5 / SCATTERGUN_PELLETS, -1) // reconsider pellet # (9?) for scout?
	
	// ammo
	weapon.AddAttribute("clip size penalty", 2 / SCATTERGUN_CLIP, -1)
	weapon.AddAttribute("maxammo primary reduced", (2 + 1) / SCATTERGUN_RESERVE, -1)

	// faster reload (commented out cause we can refill clip through ammo now)
	//weapon.AddAttribute("Reload time decreased", 0.75, -1)

	//weapon.AddAttribute("weapon spread bonus", 0.5, -1) // Increased acc
}
	RegisterCustomWeapon("Scattergun HsDM", "Scattergun", true, CW_Stats_Scattergun_HsDM, null)
	RegisterCustomWeapon("Unique Scattergun HsDM", "Scattergun", true, CW_Stats_Scattergun_HsDM, null)
	RegisterCustomWeapon("Festive Scattergun HsDM", "Scattergun", true, CW_Stats_Scattergun_HsDM, null)

SHORTSTOP_CRIT_DAMAGE_PER_PELLET <- 36.0
function CW_Stats_Shortstop_HsDM(weapon, player)
{
	ChangeDamageTo(weapon, 28 / SHORTSTOP_CRIT_DAMAGE_PER_PELLET) // max 112 damage

	weapon.AddAttribute("clip size penalty", 1 / SCATTERGUN_CLIP, -1)
	weapon.AddAttribute("maxammo primary reduced", (2 + 1) / SCATTERGUN_RESERVE, -1)

	weapon.AddAttribute("mult_spread_scales_consecutive", -1, -1) // panic attack spread on each shot, ??? ehhhh
}
	RegisterCustomWeapon("Shortstop HsDM", "Shortstop", true, CW_Stats_Shortstop_HsDM, null)

function CW_Stats_Winger_HsDM(weapon, player)
{
	ChangeDamageTo(weapon, 46 / PISTOL_CRIT_DAMAGE)

	weapon.AddAttribute("clip size penalty", 2 / PISTOL_CLIP, -1)
	BasePistol(weapon, player)
}
	RegisterCustomWeapon("Winger HsDM", "Winger", true, CW_Stats_Winger_HsDM, null)

function CW_Stats_Pretty_Boys_Pocket_Pistol(weapon, player)
{
	ChangeDamageTo(weapon, HSDM_PISTOL_DAMAGE / PISTOL_CRIT_DAMAGE)

	weapon.AddAttribute("clip size penalty", 3 / PISTOL_CLIP, -1)
	BasePistol(weapon, player)
}
	RegisterCustomWeapon("Pretty Boy's Pocket Pistol HsDM", "Pretty Boy's Pocket Pistol", true, CW_Stats_Pretty_Boys_Pocket_Pistol, null)

// ==========================================
//                 soldier
// ==========================================

ROCKET_CRIT_DAMAGE_ON_DIRECT <- 270.0
ROCKET_CLIP <- 4.0
ROCKET_RESERVE <- 20.0
function CW_Stats_Rocket_Launcher_HsDM(weapon, player)
{
	SelfBlastBoost(weapon, 1.1)

	// damage/spread
	ChangeDamageTo(weapon, 170 / ROCKET_CRIT_DAMAGE_ON_DIRECT)

	// ammo
	weapon.AddAttribute("clip size penalty", 2 / ROCKET_CLIP, -1)
	weapon.AddAttribute("maxammo primary reduced", (2 + 1) / ROCKET_RESERVE, -1)

	// faster reload (commented out cause we can refill clip through ammo now)
	//weapon.AddAttribute("Reload time decreased", 0.75, -1)
}
	RegisterCustomWeapon("Rocket Launcher HsDM", "Rocket Launcher", true, CW_Stats_Rocket_Launcher_HsDM, null)
	RegisterCustomWeapon("Unique Rocket Launcher HsDM", "Rocket Launcher", true, CW_Stats_Rocket_Launcher_HsDM, null)
	// v check	
	RegisterCustomWeapon("Festive Rocketlauncher HsDM", "Rocket Launcher", true, CW_Stats_Rocket_Launcher_HsDM, null)
	RegisterCustomWeapon("Original HsDM", "Original", true, CW_Stats_Rocket_Launcher_HsDM, null)

function CW_Stats_Rocket_Jumper_HsDM(weapon, player)
{
	SelfBlastBoost(weapon, 1.1, 0)

	// ammo
	weapon.AddAttribute("clip size penalty", 3 / ROCKET_CLIP, -1)
	weapon.AddAttribute("maxammo primary reduced", (2 + 1) / ROCKET_RESERVE, -1) // 8 reserve
}
	RegisterCustomWeapon("Rocket Jumper HsDM", "Rocket Jumper", true, CW_Stats_Rocket_Jumper_HsDM, null)

LIBERTY_LAUNCHER_CLIP <- 5.0
function CW_Stats_Liberty_Launcher_HsDM(weapon, player)
{
	SelfBlastBoost(weapon, 1.1, 0.5)

	ChangeDamageTo(weapon, 146 / ROCKET_CRIT_DAMAGE_ON_DIRECT)

	weapon.AddAttribute("clip size penalty", 3 / LIBERTY_LAUNCHER_CLIP, -1)
	weapon.AddAttribute("maxammo primary reduced", (2 + 1) / ROCKET_RESERVE, -1)
}
	RegisterCustomWeapon("Liberty Launcher HsDM", "Liberty Launcher", true, CW_Stats_Liberty_Launcher_HsDM, null)

MAX_DIRECT_HIT_MINICRIT_DAMAGE <- 189.0
MAX_ROCKET_MINICRIT_DAMAGE <- 151.0
// todo: lower knockback from direct hit (prolly gotta use OnTakeDamage)
function CW_Stats_Direct_Hit_HsDM(weapon, player)
{
	//addNoCritsWhenActive(weapon, player)

	SelfBlastBoost(weapon, 1.1)

	// non-crits: 67-157 damage
	// minicrits: 171-212 damage
	ChangeDamageTo(weapon, 212 / MAX_ROCKET_MINICRIT_DAMAGE)

	// ammo
	weapon.AddAttribute("clip size penalty", 2 / ROCKET_CLIP, -1)
	weapon.AddAttribute("maxammo primary reduced", (2 + 1) / ROCKET_RESERVE, -1)

	// minicrit airborne (stolen from old reserve shooter)
	//weapon.AddAttribute("mod mini-crit airborne deploy")
}
	RegisterCustomWeapon("Direct Hit HsDM", "Direct Hit", true, CW_Stats_Direct_Hit_HsDM, null)

function CW_Stats_Beggars_Bazooka_HsDM(weapon, player)
{
	SelfBlastBoost(weapon, 1.1)

	ChangeDamageTo(weapon, 170 / ROCKET_CRIT_DAMAGE_ON_DIRECT)

	// ammo
	weapon.AddAttribute("maxammo primary reduced", 5 / ROCKET_RESERVE, -1) // consider 4 ammo?
}
	RegisterCustomWeapon("Beggar's Bazooka HsDM", "Beggar's Bazooka", true, CW_Stats_Beggars_Bazooka_HsDM, null)

function CW_Stats_Air_Strike_HsDM(weapon, player)
{
	SelfBlastBoost(weapon, 1.1, 0.5)
	
	ChangeDamageTo(weapon, 146 / ROCKET_CRIT_DAMAGE_ON_DIRECT)

	weapon.AddAttribute("clip size penalty", 2 / ROCKET_CLIP, -1)
	weapon.AddAttribute("maxammo primary reduced", 3 / ROCKET_RESERVE, -1)
}
	RegisterCustomWeapon("Air Strike HsDM", "Air Strike", true, CW_Stats_Air_Strike_HsDM, null)

function CW_Stats_Black_Box_HsDM(weapon, player)
{
	SelfBlastBoost(weapon, 1.1)

	ChangeDamageTo(weapon, 170 / ROCKET_CRIT_DAMAGE_ON_DIRECT)

	weapon.AddAttribute("clip size penalty", 1 / ROCKET_CLIP, -1)
	weapon.AddAttribute("maxammo primary reduced", (3 + 1) / ROCKET_RESERVE, -1)
	weapon.AddAttribute("health on radius damage", 35, -1) // too much?
}
	RegisterCustomWeapon("Black Box HsDM", "Black Box", true, CW_Stats_Black_Box_HsDM, null)

function CW_Stats_Market_Gardener_HsDM(weapon, player)
{
	//weapon.AddAttribute("dmg penalty vs players", 1, -1)
	ChangeDamageTo(weapon, 245 / MELEE_CRIT_DAMAGE) // 82 non crit damage

	//addNoCritsWhenActive(weapon, player)
}
	RegisterCustomWeapon("Market Gardener HsDM", "Market Gardener", true, CW_Stats_Market_Gardener_HsDM, null)
	RegisterCustomWeapon("Neon Annihilator HsDM", "Neon Annihilator", true, CW_Stats_Market_Gardener_HsDM, null) //shh

// ==========================================
//                  pyro
// ==========================================

function BoostDamageAgainstBurning(weapon, damage)
{
	weapon.AddAttribute("damage bonus vs burning", damage, -1)
	weapon.AddAttribute("weapon burn dmg reduced", 1.0 / damage, -1)
}

FLAMETHROWER_AMMO <- 200.0
FLAMETHROWER_AIRBLAST_COST <- 20.0
FLAMETHROWER_MAX_CRIT_DAMAGE_PER_TICK <- 19.5 // 133-266 dps!!!!
function CW_Stats_Flame_Thrower_HsDM(weapon, player)
{
	// damage
	ChangeDamageTo(weapon, 11 / FLAMETHROWER_MAX_CRIT_DAMAGE_PER_TICK) // 75-150 dps higher than minicrit

	weapon.AddAttribute("maxammo primary reduced", 30 / FLAMETHROWER_AMMO, -1)
	weapon.AddAttribute("airblast cost decreased", 4 / FLAMETHROWER_AIRBLAST_COST, -1) // 5 airblasts max
}
	RegisterCustomWeapon("Flame Thrower HsDM", "Flame Thrower", true, CW_Stats_Flame_Thrower_HsDM, null)
	RegisterCustomWeapon("Unique Flame Thrower HsDM", "Flame Thrower", true, CW_Stats_Flame_Thrower_HsDM, null)
	RegisterCustomWeapon("Festive Flame Thrower HsDM", "Flame Thrower", true, CW_Stats_Flame_Thrower_HsDM, null)
	RegisterCustomWeapon("Rainblower HsDM", "Flame Thrower", true, CW_Stats_Flame_Thrower_HsDM, null)
	RegisterCustomWeapon("Nostromo Napalmer HsDM", "Flame Thrower", true, CW_Stats_Flame_Thrower_HsDM, null)
	RegisterCustomWeapon("Degreaser HsDM", "Degreaser", true, CW_Stats_Flame_Thrower_HsDM, null)

DRAGONS_CRIT_INITIAL_DAMAGE <- 75.0
DRAGONS_AMMO <- 40.0
DRAGONS_AIRBLAST_COST <- 5.0
HSDM_DRAGONS_AMMO <- 3.0
function CW_Stats_Dragons_Fury_HsDM(weapon, player)
{
	// damage
	ChangeDamageTo(weapon, 40 / DRAGONS_CRIT_INITIAL_DAMAGE) // 40 base, 120 direct bonus

	// ammo
	weapon.AddAttribute("maxammo primary reduced", HSDM_DRAGONS_AMMO / DRAGONS_AMMO, -1)
	weapon.AddAttribute("airblast cost decreased", 1 / DRAGONS_AIRBLAST_COST, -1)
}
	RegisterCustomWeaponEx("Dragon's Fury HsDM", "Dragon's Fury", true, CW_Stats_Dragons_Fury_HsDM, GTFW_ARMS.PYRO, null, null, null, null, 5, null)

FLARE_CRIT_DAMAGE <- 90.0
function CW_Stats_Flare_Gun_HsDM(weapon, player)
{
	// damage
	ChangeDamageTo(weapon, 120 / FLARE_CRIT_DAMAGE) // 40 base, 120 crit

	// ammo
	weapon.AddAttribute("hidden secondary max ammo penalty", 3 / SHOTGUN_RESERVE, -1) // flare uses shotgun pool

	//addNoCritsWhenActive(weapon, player)
}
	RegisterCustomWeapon("Flare Gun HsDM", "Flare Gun", true, CW_Stats_Flare_Gun_HsDM, null)
	RegisterCustomWeapon("Festive Flare Gun HsDM", "Flare Gun", true, CW_Stats_Flare_Gun_HsDM, null)

function CW_Stats_Detonator_HsDM(weapon, player)
{
	// ammo
	weapon.AddAttribute("hidden secondary max ammo penalty", 3 / SHOTGUN_RESERVE, -1) // flare uses shotgun pool
	
	SelfBlastBoost(weapon, 1.1)
	weapon.AddAttribute("blast dmg to self increased", 1, -1) // ~27 damage on self blast
	//BoostDamageAgainstBurning(weapon, 1.35) fucky, maybe will try to fix later
	// would like to boost damage but it fucks with afterburn, or turning on crits will give CRITICAL AFTERBURN WHAT

	//addNoCritsWhenActive(weapon, player)
}
	RegisterCustomWeapon("Detonator HsDM", "Detonator", true, CW_Stats_Detonator_HsDM, null)

// actually stupid. change it
function CW_Stats_Backburner_HsDM(weapon, player)
{
	ChangeDamageTo(weapon, 3.0) // uwu

	weapon.AddAttribute("maxammo primary reduced", 20 / FLAMETHROWER_AMMO, -1)
	weapon.AddAttribute("airblast cost decreased", 10 / FLAMETHROWER_AIRBLAST_COST, -1) // 2 airblasts, 10 ammo each

	//addNoCritsWhenActive(weapon, player)
}
	RegisterCustomWeapon("Backburner HsDM", "Backburner", true, CW_Stats_Backburner_HsDM, null)
	RegisterCustomWeapon("Festive Backburner HsDM", "Backburner", true, CW_Stats_Backburner_HsDM, null)

function CW_Stats_Axtinguisher_HsDM(weapon, player)
{
	ChangeDamageTo(weapon, 95 / MELEE_CRIT_DAMAGE)

	// maybe health on kill?
}
	RegisterCustomWeapon("Axtinguisher HsDM", "Axtinguisher", true, CW_Stats_Axtinguisher_HsDM, null)

// ==========================================
//                 demoman
// ==========================================

GRENADE_DIRECT_CRIT_DAMAGE <- 300.0
GRENADE_CLIP <- 4.0
GRENADE_RESERVE <- 16.0
function CW_Stats_Grenade_Launcher_HsDM(weapon, player)
{
	// damage/spread
	ChangeDamageTo(weapon, 185 / GRENADE_DIRECT_CRIT_DAMAGE) // roller max: 102

	SelfBlastBoost(weapon, 1.1)
	
	// ammo
	weapon.AddAttribute("clip size penalty", 2 / GRENADE_CLIP, -1)
	weapon.AddAttribute("maxammo primary reduced", (2 + 1) / GRENADE_RESERVE, -1)
	
	// faster reload (commented out cause we can refill clip through ammo now)
	//weapon.AddAttribute("Reload time decreased", 0.75, -1)
	//weapon.AddAttribute("single wep deploy time decreased", 0.75, -1) meh
}
	RegisterCustomWeapon("Grenade Launcher HsDM", "Grenade Launcher", true, CW_Stats_Grenade_Launcher_HsDM, null)
	RegisterCustomWeapon("Unique Grenade Launcher HsDM", "Grenade Launcher", true, CW_Stats_Grenade_Launcher_HsDM, null)
	RegisterCustomWeapon("Festive Grenade Launcher HsDM", "Grenade Launcher", true, CW_Stats_Grenade_Launcher_HsDM, null)
	RegisterCustomWeapon("Iron Bomber HsDM", "Iron Bomber", true, CW_Stats_Grenade_Launcher_HsDM, null)

function CW_Stats_Loch_N_Load(weapon, player)
{
	// damage/spread
	ChangeDamageTo(weapon, 185 / GRENADE_DIRECT_CRIT_DAMAGE)
	
	// ammo
	weapon.AddAttribute("clip size penalty", 1 / GRENADE_CLIP, -1)
	weapon.AddAttribute("maxammo primary reduced", (3 + 1) / GRENADE_RESERVE, -1)
}
	RegisterCustomWeapon("Loch-n-Load HsDM", "Loch-n-Load", true, CW_Stats_Loch_N_Load, null)

LOOSE_CANNON_CRIT_DIRECT_DAMAGE <- 150.0
LOOSE_CANNON_DOUBLE_DONK_EXPLOSION_DAMAGE <- 81.0 // + 50 for 131 total double donk damage
function CW_Stats_Loose_Cannon(weapon, player)
{
	ChangeDamageTo(weapon, 168 / LOOSE_CANNON_DOUBLE_DONK_EXPLOSION_DAMAGE) // 50 direct, 168 explosion, double donk up to 218 damage

	// ammo
	weapon.AddAttribute("clip size penalty", 2 / GRENADE_CLIP, -1)
	weapon.AddAttribute("maxammo primary reduced", (2 + 1) / GRENADE_RESERVE, -1)
}
	RegisterCustomWeapon("Loose Cannon HsDM", "Loose Cannon", true, CW_Stats_Loose_Cannon, null)

STICKYBOMB_MAX_CRIT_DAMAGE <- 355.0
STICKYBOMB_CLIP <- 8.0
STICKYBOMB_RESERVE <- 24.0
HSDM_STICKYBOMB_DAMAGE <- 201.0
function CW_Stats_Stickybomb_Launcher_HsDM(weapon, player)
{
	// damage/spread
	ChangeDamageTo(weapon, HSDM_STICKYBOMB_DAMAGE / STICKYBOMB_MAX_CRIT_DAMAGE)
	// Max damage recorded: ~198 (should we allow potential 1-shot on soldier?)

	SelfBlastBoost(weapon, 1.1)

	//weapon.AddAttribute("blast radius increased", 1.2, -1) meh
	
	// ammo
	weapon.AddAttribute("clip size penalty", 2 / STICKYBOMB_CLIP, -1)
	weapon.AddAttribute("maxammo secondary reduced", (2 + 1) / STICKYBOMB_RESERVE, -1)
	
	// faster reload (commented out cause we can refill clip through ammo now)
	//weapon.AddAttribute("Reload time decreased", 0.75, -1)
	//weapon.AddAttribute("single wep deploy time decreased", 0.75, -1)

	// misc
	weapon.AddAttribute("max pipebombs decreased", -6, -1) // Max 2 stickies
	// v i like how this feels, gives demo better medium range airshot ability
	weapon.AddAttribute("sticky arm time bonus", -0.2, -1)
	
	// weapon.AddAttribute("stickybomb fizzle time", 5, -1) // ??? unneeded i think (can discourage traps but meh?)
}
	RegisterCustomWeapon("Stickybomb Launcher HsDM", "Stickybomb Launcher", true, CW_Stats_Stickybomb_Launcher_HsDM, null)
	RegisterCustomWeapon("Unique Stickybomb Launcher HsDM", "Stickybomb Launcher", true, CW_Stats_Stickybomb_Launcher_HsDM, null)
	RegisterCustomWeapon("Festive Stickybomb Launcher HsDM", "Stickybomb Launcher", true, CW_Stats_Stickybomb_Launcher_HsDM, null)
	RegisterCustomWeapon("Scottish Resistance HsDM", "Scottish Resistance", true, CW_Stats_Stickybomb_Launcher_HsDM, null)

function CW_Stats_Quickiebomb_Launcher_HsDM(weapon, player)
{
	// damage/spread
	ChangeDamageTo(weapon, (HSDM_STICKYBOMB_DAMAGE * 0.85) / STICKYBOMB_MAX_CRIT_DAMAGE)
	// Max damage recorded: ~220

	SelfBlastBoost(weapon, 1.1)

	// ammo
	weapon.AddAttribute("clip size penalty", 3 / STICKYBOMB_CLIP, -1)
	weapon.AddAttribute("maxammo secondary reduced", 3 / STICKYBOMB_RESERVE, -1) // 8 reserve

	// misc
	weapon.AddAttribute("max pipebombs decreased", -6, -1) // Max 2 stickies
	weapon.AddAttribute("sticky arm time bonus", -0.4, -1)
}
	RegisterCustomWeapon("Quickiebomb Launcher HsDM", "Quickiebomb Launcher", true, CW_Stats_Quickiebomb_Launcher_HsDM, null)

function CW_Stats_Sticky_Jumper(weapon, player)
{
	// for some reason dealing damage???
	ChangeDamageTo(weapon, 0.0)

	SelfBlastBoost(weapon, 1.1)

	// ammo
	weapon.AddAttribute("clip size penalty", 2 / STICKYBOMB_CLIP, -1)
	weapon.AddAttribute("maxammo secondary reduced", (3 + 1) / STICKYBOMB_RESERVE, -1)

	weapon.AddAttribute("sticky arm time bonus", -0.2, -1)
}
	RegisterCustomWeapon("Sticky Jumper HsDM", "Sticky Jumper", true, CW_Stats_Quickiebomb_Launcher_HsDM, null)

// ==========================================
//                  heavy
// ==========================================

MINIGUN_AMMO <- 200.0
MINIGUN_CRIT_DPS_CLOSE_RANGE <- 1026.0
MINIGUN_DAMAGE_PER_BULLET <- 27.0
function CW_Stats_Minigun_HsDM(weapon, player)
{
	ChangeDamageTo(weapon, 17 / MINIGUN_DAMAGE_PER_BULLET)

	weapon.AddAttribute("maxammo primary reduced", 30 / MINIGUN_AMMO, -1)
}
	RegisterCustomWeapon("Minigun HsDM", "Minigun", true, CW_Stats_Minigun_HsDM, null)
	RegisterCustomWeapon("Unique Minigun HsDM", "Minigun", true, CW_Stats_Minigun_HsDM, null)
	RegisterCustomWeapon("Festive Minigun HsDM", "Minigun", true, CW_Stats_Minigun_HsDM, null)
	RegisterCustomWeapon("Tomislav HsDM", "Tomislav", true, CW_Stats_Minigun_HsDM, null)

FAMILY_BUSINESS_CLIP <- 8.0
function CW_Stats_Family_Business(weapon, player)
{
	local damagePerPellet = 126 / SHOTGUN_PELLETS // insert max damage
	ChangeDamageTo(weapon, damagePerPellet / SHOTGUN_CRIT_DAMAGE_PER_PELLET)

	weapon.AddAttribute("clip size penalty", 3 / FAMILY_BUSINESS_CLIP, -1)
	weapon.AddAttribute("maxammo secondary reduced", (2 + 1) / SHOTGUN_RESERVE, -1)
}
	RegisterCustomWeapon("Family Business HsDM", "Family Business", true, CW_Stats_Family_Business, null)

// consider: turning off crits for all weapons, that way the crit buff can apply to those as well (buff em for crit mode)
function CW_Stats_Killing_Gloves_of_Boxing(weapon, player)
{
	ChangeDamageTo(weapon, 120.0 / 65.0) // 120 normal damage, 360 crit damage
}
	RegisterCustomWeapon("Killing Gloves of Boxing HsDM", "Killing Gloves of Boxing", true, CW_Stats_Killing_Gloves_of_Boxing)

function CW_Stats_Evicition_Notice(weapon, player)
{
	ChangeDamageTo(weapon, 87.0 / MELEE_CRIT_DAMAGE)
}
	RegisterCustomWeapon("Eviction Notice HsDM", "Gloves of Running Urgently", true, CW_Stats_Evicition_Notice)

// ==========================================
//                  engie
// ==========================================

ENGIE_METAL <- 200
HSDM_WIDOWMAKER_METAL_MULTI <- 0.2
function CW_Stats_Widowmaker_HsDM(weapon, player)
{
	BaseShotgun(weapon, player)
	weapon.AddAttribute("maxammo metal reduced", HSDM_WIDOWMAKER_METAL_MULTI, -1)
	weapon.AddAttribute("building cost reduction", HSDM_WIDOWMAKER_METAL_MULTI - 0.005, -1) // small adjustment to fix rounding errors
	weapon.AddAttribute("Repair rate increased", 1 + HSDM_WIDOWMAKER_METAL_MULTI, -1)
}
	RegisterCustomWeapon("Widowmaker HsDM", "Widowmaker", true, CW_Stats_Widowmaker_HsDM, null)


/*POMSON_CRIT_DAMAGE <- 180
function CW_Stats_Pomson_HsDM(weapon, player)
{
	ChangeDamageTo(weapon, 280 / POMSON_CRIT_DAMAGE)
}*/

function CW_Stats_Jag_HsDM(weapon, player)
{
	 // technically kills 150s/solly/heavy faster than stock melee
	 // consider: 98 damage instead?
	ChangeDamageTo(weapon, 108 / MELEE_CRIT_DAMAGE, false)
}
	RegisterCustomWeapon("Jag HsDM", "Frying Pan", true, CW_Stats_Jag_HsDM, null)

// ==========================================
//                  medic
// ==========================================

SYRINGE_GUN_CLIP <- 40.0
SYRINGE_GUN_RESERVE <- 150.0
SYRINGE_GUN_CRIT_DAMAGE <- 30.0
function CW_Stats_Syringe_Gun_HsDM(weapon, player)
{
	// is 30 too high?
	//ChangeDamageTo(weapon, 29 / SYRINGE_GUN_CRIT_DAMAGE)

	// feels like a lot of ammo, but i'm expecting you to miss a lot, and you don't get ammo back on hit
	weapon.AddAttribute("clip size penalty", 12 / SYRINGE_GUN_CLIP, -1)
	weapon.AddAttribute("maxammo primary reduced", 16 / SYRINGE_GUN_RESERVE, -1)
}
	RegisterCustomWeapon("Syringe Gun HsDM", "Syringe Gun", false, CW_Stats_Syringe_Gun_HsDM, null)
	RegisterCustomWeapon("Unique Syringe Gun HsDM", "Syringe Gun", false, CW_Stats_Syringe_Gun_HsDM, null)

CROSSBOW_MAX_DAMAGE <- 225.0
function CW_Stats_Crossbow_HsDM(weapon, player)
{
	// damage
	//ChangeDamageTo(weapon, 195 / CROSSBOW_MAX_DAMAGE)

	// ammo
	weapon.AddAttribute("maxammo primary reduced", 4 / SYRINGE_GUN_RESERVE, -1)
}
	RegisterCustomWeapon("Crusader's Crossbow HsDM", "Crusader's Crossbow", false, CW_Stats_Crossbow_HsDM, null)
	RegisterCustomWeapon("Festive Crusader's Crossbow HsDM", "Crusader's Crossbow", false, CW_Stats_Crossbow_HsDM, null)

function CW_Stats_Amputator_HsDM(weapon, player)
{
	ChangeDamageTo(weapon, 118 / MELEE_CRIT_DAMAGE)
}
	RegisterCustomWeapon("Amputator HsDM", "Frying Pan", true, CW_Stats_Amputator_HsDM, null)

// ==========================================
//                 sniper
// ==========================================

function BaseStatsSniper(weapon)
{
	weapon.AddAttribute("sniper fires tracer", -1, -1) // Doesn't fire tracer if shot was far away

	weapon.AddAttribute("maxammo primary reduced", 3 / SNIPER_AMMO, -1) // consider 4 ammo

	// 125 body shots (kill light classes, suboptimal smg + hookshot combo opportunities)
	// 165 head shots (kill up to 150, optimal smg combos (only 2 shots to kill solly from here))
	// experimental
	weapon.AddAttribute("damage penalty on bodyshot", 125 / SNIPER_HEADSHOT_DAMAGE, -1)
	weapon.AddAttribute("headshot damage increase", 165 / SNIPER_HEADSHOT_DAMAGE, -1)
	// no need to fix sentry damage to vanilla, above attributes only effect players
}

SNIPER_AMMO <- 25.0
SNIPER_HEADSHOT_DAMAGE <- 150.0
// BUG: something seems to be easily able to fuck with sniper ammo count
//      try restarting map if things get buggy, but need to fix if it becomes issue
function CW_Stats_Sniper_Rifle_HsDM(weapon, player)
{
	BaseStatsSniper(weapon)
}
	RegisterCustomWeapon("Sniper Rifle HsDM", "Sniper Rifle", true, CW_Stats_Sniper_Rifle_HsDM, null)
	RegisterCustomWeapon("Unique Sniper Rifle HsDM", "Sniper Rifle", true, CW_Stats_Sniper_Rifle_HsDM, null)
	RegisterCustomWeapon("Festive Sniper Rifle HsDM", "Sniper Rifle", true, CW_Stats_Sniper_Rifle_HsDM, null)
	RegisterCustomWeapon("AWPer Hand HsDM", "Sniper Rifle", true, CW_Stats_Sniper_Rifle_HsDM, null)
	RegisterCustomWeapon("Machina HsDM", "Machina", true, CW_Stats_Sniper_Rifle_HsDM, null)
	RegisterCustomWeapon("Shooting Star HsDM", "Shooting Star", true, CW_Stats_Sniper_Rifle_HsDM, null)

// Something is fucky with huntsman ammo, just toy with numbers til you get what you want
// How to change huntsman damage????????
//  Can't seem to change base damage, but can change the upper damage, ok
//  Gotta make a custom projectile maybe?
// Base is fine, but i'd like body shots to be a bit more rewarding
HUNTSMAN_AMMO <- 11.0
HUNTSMAN_BASE_DAMAGE <- 50
HUNTSMAN_BASE_CRIT_DAMAGE <- 150.0
HUNTSMAN_MAX_CRIT_DAMAGE <- 360.0
function CW_Stats_Huntsman_HsDM(weapon, player)
{
	weapon.AddAttribute("maxammo primary reduced", 3 / HUNTSMAN_AMMO, -1)

	//weapon.AddAttribute("damage penalty", 180 / HUNTSMAN_BASE_CRIT_DAMAGE, -1) // 60 base damage

	//addNoCritsWhenActive(weapon, player)
}
	RegisterCustomWeapon("Huntsman HsDM", "Huntsman", true, CW_Stats_Huntsman_HsDM, null)
	RegisterCustomWeapon("Festive Huntsman HsDM", "Huntsman", true, CW_Stats_Huntsman_HsDM, null)
	RegisterCustomWeapon("Fortified Compound HsDM", "Huntsman", true, CW_Stats_Huntsman_HsDM, null)

// I like its current damage at 24, pairs well with sniper
SMG_CLIP <- 25.0
SMG_RESERVE <- 75.0
function CW_Stats_SMG_HsDM(weapon, player)
{
	// encourage combos??
	//weapon.AddAttribute("single wep deploy time decreased", 1.0 - 0.25, -1)

	// ammo
	weapon.AddAttribute("clip size penalty", 6 / SMG_CLIP, -1)
	weapon.SetClip1(6)
	weapon.AddAttribute("maxammo secondary reduced", 8 / SMG_RESERVE, -1)

	weapon.AddAttribute("add onhit addammo", -1, -1)
}
	RegisterCustomWeapon("SMG HsDM", "SMG", true, CW_Stats_SMG_HsDM, null)
	RegisterCustomWeapon("Unique SMG HsDM", "SMG", true, CW_Stats_SMG_HsDM, null)
	RegisterCustomWeapon("Festive SMG HsDM", "SMG", true, CW_Stats_SMG_HsDM, null)

function CW_Tribalman_Shiv_HsDM(weapon, player)
{
	ChangeDamageTo(weapon, 90 / MELEE_CRIT_DAMAGE)
}
	RegisterCustomWeapon("Tribalman's Shiv HsDM", "Tribalman's Shiv", true, CW_Tribalman_Shiv_HsDM, null)

// ==========================================
//                 spy
// ==========================================

function BaseStatsRevolver(weapon, player)
{
	weapon.AddAttribute("clip size penalty", 1 / REVOLVER_CLIP, -1)
	weapon.AddAttribute("maxammo secondary reduced", 2 / REVOLVER_RESERVE, -1)
}

// I like current damage, but not against raising (one shot lights?), or lowering it
REVOLVER_CLIP <- 6.0
REVOLVER_RESERVE <- 24.0
REVOLVER_CRIT_DAMAGE <- 120.0
function CW_Stats_Revolver_HsDM(weapon, player)
{
	BaseStatsRevolver(weapon, player)
}
	RegisterCustomWeapon("Revolver HsDM", "Revolver", true, CW_Stats_Revolver_HsDM, null)
	RegisterCustomWeapon("Unique Revolver HsDM", "Revolver", true, CW_Stats_Revolver_HsDM, null)
	RegisterCustomWeapon("Big Kill HsDM", "Revolver", true, CW_Stats_Revolver_HsDM, null)

HSDM_AMBY_HEADSHOT_DAMAGE <- 156.0
function CW_Stats_Ambassador_HsDM(weapon, player)
{
	// Removes all pre-existing stats of the weapon.
	NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_bOnlyIterateItemViewAttributes", 1)
	//   bug: still a maximum headshot range o// why
	//   bug: may force non-min viewmodels

	ChangeDamageTo(weapon, HSDM_AMBY_HEADSHOT_DAMAGE / REVOLVER_CRIT_DAMAGE / 3.0)
	BaseStatsRevolver(weapon, player)

	weapon.AddAttribute("revolver use hit locations", 1, -1)
	weapon.AddAttribute("headshot damage increase", 21.6, -1) // long range headshot = 198 dmg
	// NOTE: crit headshots still only deal 156 damage because we overrite it in OnTakeDamage
	weapon.AddAttribute("sniper fires tracer", 1, -1)
	weapon.AddAttribute("damage penalty on bodyshot", 1.6, -1)
}
	RegisterCustomWeapon("Ambassador HsDM", "Ambassador", true, CW_Stats_Ambassador_HsDM, null)