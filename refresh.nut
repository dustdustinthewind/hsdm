// run this whenever you need to refresh the script, i.e. code changes
// bugs: melee damage (specifically demoknight) can get stuck at 145 or 195 instead of swapping as required

// settings (change these as you see fit feels)
// TODO?: make an object or function of these variables so we can apply individual hookshot bullshit to individual classes
//        add these to a seperate file at least

GAME_GRAVITY <- 0.65 // perecentage
NORMAL_GRAVITY_FOR_PROJECTILES <- true // set to true so projectiles behave similarly to vanilla tf2's gravity, pills especially effected by gravity

// how much we jerk the player forward towards the grapple on an attach
ON_ATTACH_IMPULSE // <- 650.0
                     <- 600.0
                  // <- 500.0
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

// speed left and right from hook strafing
GRAPPLE_SIDE_VELOCITY // <- 350.0
                         <- 250.0 
                         
// speed forward and back from hook strafing
GRAPPLE_FORWARD_VELOCITY <- 150.0  

// when we stop reeling in and just, sit there
ROPE_SAFETY_RADIUS <- 100.0

// how "tight" the rope is
TENSION_STRENGTH <- 0.9

// these last ones change console commands
// how fast you accelerate while grappling
// maybe we can set this very low now its super phyiscal? (nah i dont like that feel, i think)
GRAPPLE_ACCELERATION     // <- 700 // tf2 default: 3500 (too much ew ew)
                         // <- 650
				            <- 500

// the maximum speed you can achieve while grappling
// NOTE: seems to hard cap even other forms of momentum, as long as you're grappling, this is your max, good to know
MAX_GRAPPLE_SPEED <- 1500.0 // tf2 default: 750

// meh
GRAPPLE_DAMPEN <- 100 // tf2 default: 500 (too high, makes grapple feel like sliding on sandpaper)

// how often you can shoot grapple (effects grapple spam/chains)
GRAPPLE_COOLDOWN <- 0.66 // tf2 default 0.5

// the speeds of jump detaching from a grappl
GRAPPLE_JUMP_DETACH_SPEED <- 375 // tf2 default: 375
HEAVY_JUMP_DETACH_SPEED <- 275 // heavy is fat

// max distance that will allow the grapple to shoot
GRAPPLE_MAX_DISTANCE <- 2000 // tf2 default: 2000

// if you take fall damage after grappling
GRAPPLES_PREVENT_FALL_DAMAGE <- false // tf2 default: false

// how fast the hook projectile moves
GRAPPLE_HOOK_PROJECTILE_SPEED <- 1500 // tf2 default: 1500

// projectiles keep the gravity of game start, even if the gravity changes half way through the match.
//  so that means if we set the gravity *after* the game starts, we can have low grav for players but
//  normal grav for projectiles
//  i love how hacky source is
// NOTE: unsure if changing NORMAL_GRAVITY_FOR_PROJECTILES will work on script refresh
if (NORMAL_GRAVITY_FOR_PROJECTILES)
	SetGravityMultiplier(1.0)
Convars.SetValue("mp_restartgame", 1)
SetGravityMultiplier(GAME_GRAVITY); // default: 0.65

Convars.SetValue("tf_grapplinghook_move_speed", MAX_GRAPPLE_SPEED)
Convars.SetValue("tf_grapplinghook_acceleration", GRAPPLE_ACCELERATION)
Convars.SetValue("tf_grapplinghook_dampening", GRAPPLE_DAMPEN)
Convars.SetValue("tf_grapplinghook_fire_delay", GRAPPLE_COOLDOWN)
Convers.SetValue("tf_grapplinghook_jump_up_speed", GRAPPLE_JUMP_DETACH_SPEED)
Convars.SetValue("tf_grapplinghook_max_distance", GRAPPLE_MAX_DISTANCE)
Convars.Setvalue("tf_grapplinghook_prevent_fall_damage", GRAPPLES_PREVENT_FALL_DAMAGE)
Convars.SetValue("tf_grapplinghook_projectile_speed", GRAPPLE_HOOK_PROJECTILE_SPEED)

// TODO: have more files for organization, i want to put the grapple in its own file for example
// custom weapons for hsdm
IncludeScript("hsdm/hookshotdmWeapons.nut") 

// other code
IncludeScript("hsdm/hookshotdm.nut")