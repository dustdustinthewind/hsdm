hsdm <- "hsdm/"
debug <- false

// basically llzard lib from vsh
IncludeScript(hsdm + "__lizardlib/util.nut")
// https://tf2maps.net/downloads/vscript-give_tf_weapon.14897/
Include("give_tf_weapon/_master.nut")

Include("/util/entities.nut");
Include("roundsetup.nut")
//Include("tables.nut")
Include("weapons_and_traits.nut")

// TODO
//  fix need to rerun script twice to work
//  fix need to manually swap loadouts, touch resupply, or change character for weapon trait applications to work
//   maybe switch to nother class then back xd
//  fix grappling other players is funky
//  the character trait system is cool but i have a feeling it may be performance heavy in current implementation