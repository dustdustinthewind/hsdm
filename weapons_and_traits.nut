weapons_and_traits <- [
	"hsdm_traits/hsdm_trait.nut",
	"hsdm_traits/weapon_crit_manager.nut",
	"hsdm_traits/blast_jumping_debuff_hack.nut"
	"hsdm_traits/regain_ammo_on_hit.nut",

	"hsdm_traits/scout_on_attach_detach.nut",
	"hsdm_traits/sniper_on_attach_detach.nut",
	"hsdm_traits/heavy_on_attach_detach.nut",

	"hsdm_weapons/weapon_helpers.nut",

	"hsdm_weapons/multi_class/grapplehook.nut",
	"hsdm_weapons/multi_class/base_jumper.nut",
	"hsdm_weapons/multi_class/shotgun.nut",
	"hsdm_weapons/multi_class/panic_attack.nut",
	"hsdm_weapons/multi_class/reserve_shooter.nut",
	"hsdm_weapons/multi_class/pistol.nut",

	"hsdm_weapons/single_class/scout/scattergun.nut",

	"hsdm_weapons/single_class/engie/widowmaker.nut",

	"hsdm_weapons/single_class/heavy/family_business.nut",
]

foreach (file in weapons_and_traits)
	Include(file)