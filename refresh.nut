// run this whenever you need to refresh the script, i.e. code changes
// bugs: melee damage (specifically demoknight) can get stuck at 145 or 195 instead of swapping as required

// projectiles keep the gravity of game start, even if the gravity changes half way through the match.
//  so that means if we set the gravity *after* the game starts, we can have low grav for players but
//  normal grav for projectiles
//  i love how hacky source is
SetGravityMultiplier(1.0)
Convars.SetValue("mp_restartgame", 1)
SetGravityMultiplier(0.6); // default: 0.6

IncludeScript("hsdm/thirdparty/give_tf_weapon/_master.nut") // thanks
IncludeScript("hsdm/hookshotdmWeapons.nut") // custom weapons for hsdm
IncludeScript("hsdm/hookshotdm.nut") // other code