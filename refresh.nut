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
// TODO?: make an object or function of these variables so we can apply individual hookshot bullshit to individual classes
//        add these to a seperate file at least

// how much we jerk the player forward towards the grapple on an attach
ON_ATTACH_IMPULSE // <- 650.0
                     <- 500.0
				  // <- 400.0

// how much momentum is retained between grapples (the lower the number, the more influence ON_ATTACH_IMPULSE has)
MOMENTUM_RETENTION // <- 0.3
                   // <- 0.4
				      <- 0.5

// how fast does the player move during reel-in
REEL_IN_SPEED // <- 900.0
                 <- 800.0
			  // <- 600.0

// how often the reel in powerup recharges (after detaching from current reel-in)
REEL_IN_COOLDOWN // <- 8.0    
                    <- 4.5
				 // <- 3.0

// how much player gets pulled/pushed around by swinging on func objects
SWING_STRENGTH <- 1

// max and minimum percentage of swing strength
MAX_SWING_STRENGTH <- 1.0 // recommended not higher than 1.0
MIN_SWING_STRENGTH <- 0.1 // recomended not lower than 0.0

// up to how far away can the player be influenced by func_ entity they swinging on
SWING_INFLUENCE_DISTANCE <- 1000

// speed left and right from hook strafing
GRAPPLE_SIDE_VELOCITY // <- 350.0
                         <- 200.0 
                         
// speed forward and back from hook strafing
GRAPPLE_FORWARD_VELOCITY <- 50.0  

// when we stop reeling in and just, sit there
MINIMUM_OPTIMAL_ROPE_LENGTH <- 125.0

OPTIMAL_ROPE_LENGTH_DRAIN <- 50.0

TENSION_STRENGTH <- 0.9

// these last 3 change console commands
// how fast you accelerate while grappling
GRAPPLE_ACCELERATION     // <- 700
                         // <- 650
				            <- 600

// the maximum speed you can achieve while grappling
MAX_GRAPPLE_SPEED <- 1250.0

// meh
GRAPPLE_DAMPEN <- 100

Convars.SetValue("tf_grapplinghook_use_acceleration", 1)
Convars.SetValue("tf_grapplinghook_move_speed", MAX_GRAPPLE_SPEED)
Convars.SetValue("tf_grapplinghook_acceleration", GRAPPLE_ACCELERATION)
Convars.SetValue("tf_grapplinghook_dampening", GRAPPLE_DAMPEN)

// TODO: have more files for organization, i want to put the grapple in its own file for example
// custom weapons for hsdm
IncludeScript("hsdm/hookshotdmWeapons.nut") 

// other code
IncludeScript("hsdm/hookshotdm.nut")