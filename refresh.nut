// run this whenever you need to refresh the script, i.e. code changes
// bugs: melee damage (specifically demoknight) can get stuck at 145 or 195 instead of swapping as required

// projectiles keep the gravity of game start, even if the gravity changes half way through the match.
//  so that means if we set the gravity *after* the game starts, we can have low grav for players but
//  normal grav for projectiles
//  i love how hacky source is
SetGravityMultiplier(1.0)
Convars.SetValue("mp_restartgame", 1)
SetGravityMultiplier(0.65); // default: 0.65

// grapple settings (change these to change how grapple feels)
// TODO?: Make a class of these variables so we can apply individual hookshot bullshit to individual classes
ON_ATTACH_IMPULSE        // <- 650.0  // how much we jerk the player forward towards the grapple on an attach
                            <- 500.0
				         // <- 400.0
MOMENTUM_RETENTION       // <- 0.3    // how much momentum is retained between grapples (the lower the number, the more influence ON_ATTACH_IMPULSE has)
                            <- 0.4
				         // <- 0.5
REEL_IN_SPEED            // <- 900.0  // how fast does the player move during reel-in
                            <- 800.0
					     // <- 600.0
REEL_IN_COOLDOWN         // <- 8.0    // how often the reel in powerup recharges (after detaching from current reel-in)
                            <- 4.5
					     // <- 3.0
GRAPPLE_ACCELERATION     // <- 700    // how fast you accelerate while grappling
                            <- 650
				         // <- 600
MAX_GRAPPLE_SPEED           <- 1250.0 // the maximum speed you can achieve while grappling
GRAPPLE_DAMPEN              <- 100    // meh
SWING_STRENGTH              <- 1      // how much player gets pulled/pushed around by swinging on func objects
STRAFE_BOOST                <- 0.005  // how much forward boost the player gets while strafing (% of on_attach_impulse)
GRAPPLE_SIDE_VELOCITY    // <- 350.0  // speed left and right from hook strafing
                            <- 200.0 
GRAPPLE_FORWARD_VELOCITY    <- 50.0  // speed forward and back from hook strafing

Convars.SetValue("tf_grapplinghook_use_acceleration", 1)
Convars.SetValue("tf_grapplinghook_move_speed", MAX_GRAPPLE_SPEED)
Convars.SetValue("tf_grapplinghook_acceleration", GRAPPLE_ACCELERATION)
Convars.SetValue("tf_grapplinghook_dampening", GRAPPLE_DAMPEN)

IncludeScript("hsdm/thirdparty/give_tf_weapon/_master.nut") // https://tf2maps.net/downloads/vscript-give_tf_weapon.14897/
IncludeScript("hsdm/hookshotdmWeapons.nut") // custom weapons for hsdm
IncludeScript("hsdm/hookshotdm.nut") // other code