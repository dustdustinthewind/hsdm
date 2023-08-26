hsdm <- "hsdm/"
debug <- false

// basically llzard lib from vsh (todo: add url)
IncludeScript(hsdm + "__lizardlib/util.nut")
// https://tf2maps.net/downloads/vscript-give_tf_weapon.14897/
Include("give_tf_weapon/_master.nut")

Include("/util/entities.nut")
Include("game_setup.nut")
//Include("tables.nut")
Include("weapons_and_traits.nut")

// TODO
//  fix need to rerun script twice to work
//  the character trait system is cool but i have a feeling it may be performance heavy in current implementation
//   instead of pushing all our classes we should have a "scout.nut" file where scout picks and chooses what traits to have, based on loadout, and abilities.