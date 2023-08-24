weapons_and_traits <- [
	"hsdm_traits/hsdm_trait.nut",
	"hsdm_traits/weapon_crit_manager.nut",
	"hsdm_traits/blast_jumping_debuff_hack.nut"
	"hsdm_traits/gain_clip_on_hit.nut",
	"hsdm_traits/overfill_on_ammo_pickup.nut"

	"hsdm_traits/scout_on_attach_detach.nut",
	"hsdm_traits/sniper_on_attach_detach.nut",
	"hsdm_traits/heavy_on_attach_detach.nut",

	"hsdm_weapons/weapon_helpers.nut",
	"hsdm_weapons/melee_helpers.nut",

	"hsdm_weapons/multi_class/grapplehook.nut",
	"hsdm_weapons/multi_class/base_jumper.nut",
	"hsdm_weapons/multi_class/shotgun.nut",
	"hsdm_weapons/multi_class/panic_attack.nut",
	"hsdm_weapons/multi_class/reserve_shooter.nut",
	"hsdm_weapons/multi_class/pistol.nut",

	"hsdm_weapons/single_class/scout/scout_stock_melee.nut",
	"hsdm_weapons/single_class/scout/scattergun.nut",
	"hsdm_weapons/single_class/scout/shortstop.nut",
	"hsdm_weapons/single_class/scout/soda_popper.nut"
	"hsdm_weapons/single_class/scout/force_a_nature.nut"
	"hsdm_weapons/single_class/scout/back_scatter.nut"
	"hsdm_weapons/single_class/scout/baby_faces_blaster.nut"
	"hsdm_weapons/single_class/scout/bonk_atomic_punch.nut",
	"hsdm_weapons/single_class/scout/crit_a_cola.nut",
	"hsdm_weapons/single_class/scout/mad_milk.nut",
	"hsdm_weapons/single_class/scout/winger.nut",
	"hsdm_weapons/single_class/scout/pretty_boys_pocket_pistol.nut",
	"hsdm_weapons/single_class/scout/flying_guillotine.nut",
	"hsdm_weapons/single_class/scout/bat.nut",
	"hsdm_weapons/single_class/scout/candy_cane.nut",
	"hsdm_weapons/single_class/scout/boston_basher.nut",
	"hsdm_weapons/single_class/scout/sandman.nut",
	"hsdm_weapons/single_class/scout/sun_on_a_stick.nut",
	"hsdm_weapons/single_class/scout/fan_o_war.nut",
	"hsdm_weapons/single_class/scout/atomizer.nut",

	"hsdm_weapons/single_class/soldier/soldier_stock_melee.nut",

	"hsdm_weapons/single_class/pyro/pyro_stock_melee.nut",

	"hsdm_weapons/single_class/engie/engie_stock_melee.nut",
	"hsdm_weapons/single_class/engie/widowmaker.nut",

	"hsdm_weapons/single_class/demo/demo_stock_melee.nut",

	"hsdm_weapons/single_class/heavy/heavy_stock_melee.nut",
	"hsdm_weapons/single_class/heavy/family_business.nut",

	"hsdm_weapons/single_class/medic/medic_stock_melee.nut",

	"hsdm_weapons/single_class/sniper/sniper_stock_melee.nut",
	"hsdm_weapons/single_class/sniper/shahanshah.nut",

	"hsdm_weapons/single_class/spy/spy_stock_melee.nut",
]

foreach (file in weapons_and_traits)
	Include(file)