//=========================================================================
//Copyright LizardOfOz.
//
//Credits:
//  LizardOfOz - Programming, game design, promotional material and overall development. The original VSH Plugin from 2010.
//  Maxxy - Saxton Hale's model imitating Jungle Inferno SFM; Custom animations and promotional material.
//  Velly - VFX, animations scripting, technical assistance.
//  JPRAS - Saxton model development assistance and feedback.
//  MegapiemanPHD - Saxton Hale and Gray Mann voice acting.
//  James McGuinn - Mercenaries voice acting for custom lines.
//  Yakibomb - give_tf_weapon script bundle (used for Hale's first-person hands model).
//=========================================================================

// modifications for hsdm by dust

//Why does this table exist? Because the same weapon can have multiple IDs, namely, pre-JI weapon skins.
// added most every weapon with a conflicting classname  i love inputting data by hand :)
::weaponModels <- {
	// tf_weapon_shotgun
	reserve_shooter
		= GetModelIndex("models/workshop/weapons/c_models/c_reserve_shooter/c_reserve_shooter.mdl"),

	panic_attack
		= GetModelIndex("models/workshop/weapons/c_models/c_trenchgun/c_trenchgun.mdl"),

	family_business
		= 647,

	widowmaker
		= 672,

	// tf_weapon_scattergun
	force_a_nature
		= GetModelIndex("models/weapons/c_models/c_double_barrel.mdl"),
	force_a_nature_xmas
		= GetModelIndex("models/weapons/c_models/c_xms_double_barrel.mdl"),

	back_scatter
		= GetModelIndex("models/workshop/weapons/c_models/c_scatterdrum/c_scatterdrum.mdl"),

	// tf_weapon_lunchbox_drink
	crit_a_cola
		= GetModelIndex("models/weapons/c_models/c_energy_drink/c_energy_drink.mdl"),

	// tf_weapon_handgun_scout_secondary
	pretty_boys_pocket_pistol
		= GetModelIndex("models/workshop/weapons/c_models/c_pep_pistol/c_pep_pistol.mdl"),
	winger
		= GetModelIndex("models/workshop/weapons/c_models/c_winger_pistol/c_winger_pistol.mdl"),

	// tf_weapon_bat
	candy_cane
		= GetModelIndex("models/workshop/weapons/c_models/c_candy_cane/c_candy_cane.mdl"),

	boston_basher
		= 606,
	three_rune_blade
		= 662,

	sun_on_a_stick
		= 615,

    fan_o_war
		= 620,

	atomizer
		= 661,

	// tf_weapon_rocketlauncher
	black_box
		= 583,
	black_box_xmas
		= 784,

    rocket_jumper
		= GetModelIndex("models/weapons/c_models/c_rocketjumper/c_rocketjumper.mdl"),

	liberty_launcher
		= 640,

	beggars_bazooka
		= 703,


	// tf_weapon_buff_item
	battalions_backup
		= GetModelIndex("models/weapons/c_models/c_battalion_bugle/c_battalion_bugle.mdl"),

	concheror
		= GetModelIndex("models/weapons/c_models/c_shogun_warhorn/c_shogun_warhorn.mdl"),

	// tf_weapon_tf_wearable
	// double check classname
	// double check wearables work the same way as weapons :|
	gunboats
		= GetModelIndex("models/weapons/c_models/c_rocketboots_soldier.mdl"),

	mantreads
		= GetModelIndex("models/player/items/soldier/tankerboots.mdl"),

	darwins_danger_shield
		= GetModelIndex("models/player/items/sniper/croc_shield.mdl"),

	cozy_camper
		= GetModelIndex("models/player/items/sniper/xms_sniper_commandobackpack.mdl"),

	// tf_weapon_shovel
	equalizer
		= 534,

	pain_train
		= 544,

	market_gardener
		= GetModelIndex("models/workshop/weapons/c_models/c_market_gardener/c_market_gardener.mdl"),

	disciplinary_action
		= GetModelIndex("models/workshop/weapons/c_models/c_riding_crop/c_riding_crop.mdl"),

	escape_plan
		= GetModelIndex("models/weapons/c_models/c_pickaxe/c_pickaxe.mdl"),

	// tf_weapon_flamethrower
	backburner
		= GetModelIndex("models/weapons/c_models/c_flamethrower/c_backburner.mdl"),
	backbruner_xmas
		= GetModelIndex("models/weapons/c_models/c_flamethrower/c_backburner_xmas.mdl"),

	degreaser
		= GetModelIndex("models/weapons/c_models/c_degreaser/c_degreaser.mdl")

	phlogistinator
		= GetModelIndex("models/weapons/c_models/c_drg_phlogistinator/c_drg_phlogistinator.mdl"),

	// tf_weapon_flaregun
	detonator
		= 616,

	scorch_shot
		= 705,

	// tf_weapon_fireaxe
	axtinguisher
		= GetModelIndex("models/weapons/c_models/c_axtinguisher/c_axtinguisher_pyro.mdl"),
	axtinguisher_xmas
		= GetModelIndex("models/weapons/c_models/c_fireaxe_pyro/c_fireaxe_pyro_xmas.mdl"),
	postal_pummeler
		= 663,

	homewrecker
		= 543,
	maul
		= 666,

	powerjack
		= 569,

	back_scratcher
		= 607,

	sharpened_volcano_fragment
		= 614,

	third_degree
		= 681,

	// tf_weapon_grenadelauncher
	loch_n_load
		= 599,

	iron_bomber
		= 817,

	// tf_weapon_pipebomblauncher
	scottish_resistance
		= GetModelIndex("models/weapons/c_models/c_scottish_resistance/c_scottish_resistance.mdl"),

	sticky_jumper
		= 590,
	/* vsh
    sticky_jumper
		= GetModelIndex("models/weapons/c_models/c_sticky_jumper/c_sticky_jumper.mdl"),*/

	quickiebomb_launcher
		= GetModelIndex("models/workshop/weapons/c_models/c_kingmaker_sticky/c_kingmaker_sticky.mdl"),

	// tf_weapon_demoshield
	splendid_screen
		= GetModelIndex("models/weapons/c_models/c_persian_shield/c_persian_shield.mdl"),
	// ^ there is multiple models, i hope the other models are just the spike and arrow, but i have a feeling they ain't...
	//    we may need a solution for weapons that can use multiple models

	tide_turner
		= GetModelIndex("models/workshop/weapons/c_models/c_wheel_shield/c_wheel_shield.mdl"),

	// tf_weapon_sword
	scotsmans_skullcutter
		= 550,

	claidheamh_mor
		= GetModelIndex("models/weapons/c_models/c_claidheamohmor/c_claidheamohmor.mdl")

	persian_persuader
		= 628

	// tf_weapon_minigun
	natascha
		= GetModelIndex("models/weapons/c_models/c_minigun/c_minigun_natascha.mdl"),

	brass_beast
		= GetModelIndex("models/weapons/c_models/c_gatling_gun/c_gatling_gun.mdl"),

	tomislav
		= GetModelIndex("models/weapons/c_models/c_tomislav/c_tomislav.mdl"),

	huo_long_heater
		= GetModelIndex("models/weapons/c_models/c_canton.c_canton.mdl"),

	// tf_weapon_lunchbox
	dalokohs_bar
		= GetModelIndex("models/weapons/c_models/c_chocolate/c_chocolate.mdl"),

	fishcake
		= GetModelIndex("models/weapons/c_models/c_fishcake/c_fishcake.mdl"),

	buffalo_steak_sandvich
		= GetModelIndex("models/weapons/c_models/c_buffalo_steak/c_buffalo_steak.mdl"),

	second_banana
		= GetModelIndex("models/weapons/c_models/c_banana/c_banana.mdl"),

	// tf_weapon_fists
	kgb
		= GetModelIndex("models/weapons/c_models/c_boxing_gloves/c_boxing_gloves.mdl"),

	gru
		= GetModelIndex("models/weapons/c_models/c_boxing_gloves/c_boxing_gloves.mdl"),
	gru_xmas
		= GetModelIndex("models/weapons/c_models/c_boxing_gloves/c_boxing_gloves_xmas.mdl"),
	bread_bite
		= GetModelIndex("models/weapons/c_models/c_breadmonster_gloves/c_breadmonster_gloves.mdl"),

	warriors_spirit
		= GetModelIndex("models/workshop/weapons/c_models/c_bear_claw/c_bear_claw.mdl"),

	fists_of_steel
		= 613,

    eviction_notice
		= GetModelIndex("models/workshop/weapons/c_models/c_eviction_notice/c_eviction_notice.mdl"),

	holiday_punch
		= GetModelIndex("models/workshop/weapons/c_models/c_xms_gloves/c_xms_gloves.mdl"),

	// tf_weapon_wrench
	jag
		= 611,

	eureka_effect
		= 680,

	southern_hospitality
		= 545,

	// tf_weapon_builder
	toolbox // check if possible, we may not care about this
		= GetModelIndex("models/weapons/w_models/w_toolbox.mdl"),

	// tf_weapon_syringgun_medic
	blutsauger
		= GetModelIndex("models/weapons/c_models/c_leechgun/c_leechgun.mdl"),

	overdose
		= GetModelIndex("models/weapons/c_models/c_proto_syringegun/c_proto_syringegun.mdl"),

	vaccinator
		= GetModelIndex("models/workshop/weapons/c_models/c_medigun_defense/c_medigun_defense.mdl"),
    ubersaw
		= GetModelIndex("models/weapons/c_models/c_ubersaw/c_ubersaw.mdl"),
    ubersaw_xmas
		= GetModelIndex("models/weapons/c_models/c_ubersaw/c_ubersaw_xmas.mdl"),
    quick_fix
		= GetModelIndex("models/weapons/c_models/c_proto_medigun/c_proto_medigun.mdl"),

	// tf_weapon_medigun
	kritzkrieg
		= GetModelIndex("models/weapons/c_models/c_overhealer/c_overhealer.mdl"), // double check

	quick_fix
		= GetModelIndex("models/weapons/c_models/c_proto_medigun/c_proto_medigun.mdl"),

	vaccinator
		= GetModelIndex("models/weapons/c_models/c_medigun_defense/c_medigun_defense.mdl"),

	// tf_weapon_bonesaw
	ubersaw
		= GetModelIndex("models/weapons/c_models/c_ubersaw/c_ubersaw.mdl"),

	ubersaw_xmas
		= GetModelIndex("models/weapons/c_models/c_bonesaw/c_bonesaw_xmas.mdl"),

	vita_saw
		= 552,

	amputator
		= 594,

	solemn_vow
		= GetModelIndex("models/weapons/c_models/c_hippocrates_bust/c_hippocrates_bust.mdl"),

	// tf_weapon_sniperrifle
	sydney_sleeper
		= GetModelIndex("models/workshop/weapons/c_models/c_sydney_sleeper/c_sydney_sleeper.mdl"),

	machina
		= GetModelIndex("models/weapons/c_models/c_dex_sniperrifle/c_dex_sniperrifle.mdl"),
	shooting_star
		= GetModelIndex("models/workshop/weapons/c_models/c_invasion_sniperrifle/c_invasion_sniperrifle.mdl")

	hitmans_heatmaker
		= GetModelIndex("models/weapons/c_models/c_pro_rifle/c_pro_rifle.mdl"),

	// tf_weapon_club
	tribalmans_shiv
		= 549,

	bushwacka
		= 587,

	shahanshah
		= 624,

	// tf_weapon_revolver
	ambassador
		= GetModelIndex("models/weapons/c_models/c_ambassador/c_ambassador.mdl"),
	ambassador_xmas
		= GetModelIndex("models/weapons/c_models/c_ambassador/c_ambassador_xmas.mdl"),

	letranger
		= GetModelIndex("models/weapons/c_models/c_letranger/c_letranger.mdl"),

	enforcer
		= GetModelIndex("models/weapons/c_models/c_snub_nose/c_snub_nose.mdl"),

    diamondback
		= GetModelIndex("models/workshop_partner/weapons/c_models/c_dex_revolver/c_dex_revolver.mdl"),

	// tf_weapon_sapper
	red_tape_recorder // check model
		= GetModelIndex("models/weapons/v_models/v_sd_sapper_spy.mdl"),

	// tf_weapon_knife
	your_eternal_reward
		= GetModelIndex("models/workshop/weapons/c_models/c_eternal_reward/c_eternal_reward.mdl"),
	wanga_prick
		= GetModelIndex("models/workshop/weapons/c_models/c_voodoo_pin/c_voodoo_pin.mdl"),

	kunai
		= GetModelIndex("models/workshop_partner/weapons/c_models/c_shogun_kunai/c_shogun_kunai.mdl"),

    big_earner
		= GetModelIndex("models/workshop/weapons/c_models/c_switchblade/c_switchblade.mdl"),

	spycicle
		= 689

	// tf_weapon_invis
    dead_ringer
		= GetModelIndex("models/weapons/v_models/v_watch_pocket_spy.mdl"),

	cloak_and_dagger
		= GetModelIndex("models/weapons/c_models/c_leather_watch/parts/c_leather_watch.mdl")
}

::SetItemId <- function(item, id)
{
    if (item != null)
        SetPropInt(item, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", id);
}

::ClearPlayerWearables <- function(player)
{
    local item = null;
    local itemsToKill = [];
    while (item = Entities.FindByClassname(item, "tf_we*"))
    {
        if (item.GetOwner() == player)
            itemsToKill.push(item);
    }
    item = null;
    while (item = Entities.FindByClassname(item, "tf_powerup_bottle"))
    {
        if (item.GetOwner() == player)
            itemsToKill.push(item);
    }
    foreach (item in itemsToKill)
        item.Kill();
}

// use this for weapons with conflicting classes (check weapon classes.txt)
// otherwise use weapon.GetClassname() == class in CanApply()
::WeaponIs <- function(weapon, name, debugging = debug)
{
    if (weapon == null) return false

	local find_model = function(weapon, name)
	{
		if (debugging)
		{
			printl(weapon + " index: " + GetPropInt(weapon, "m_iWorldModelIndex"))
			printl("   " + GetPropInt(weapon, "m_iWorldModelIndex"))
		}

		if (debugging && name in weaponModels)
			printl(name + " index: " + weaponModels[name])

		return (name in weaponModels ? weaponModels[name] : null) == GetPropInt(weapon, "m_iWorldModelIndex")
	}

	local find_models = function(weapon, names)
	{
		foreach (name in names)
			if (find_model(weapon, name))
			{
				if (debugging)
					printl("found " + name)
				return true
			}

		return false
	}

	local class_name = weapon.GetClassname()

	// DOOOOOO NOOOOTTTT FORGETTT
	//  to double check all the shit here. check weapon classes.txt for status of each part
	// dust: DO NOT BLINDLY ASSUME VSCRIPT IS BROKEN CHECK HERE AND IN weaponModels FOR SPELLING ERRORS - dust
	switch (name)
	{
		case "any":
		case "any_weapon":
			return true

		// confirmed working
		case "parachute":
		case "base_jumper":
			return class_name == "tf_weapon_parachute"
				|| class_name == "tf_weapon_parachute_secondary"
				|| class_name == "tf_weapon_parachute_primary"

		// confirmed stock/unique shotgun works
		case "shotgun":
			return (class_name == "tf_weapon_shotgun_soldier" && !find_model(weapon, "reserve_shooter"))
				|| (class_name == "tf_weapon_shotgun_pyro" && !find_model(weapon, "reserve_shooter"))
				|| (class_name == "tf_weapon_shotgun_hwg" && !find_model(weapon, "family_business"))
				|| (class_name == "tf_weapon_shotgun_primary" && !find_model(weapon, "widowmaker"))
				|| (class_name == "tf_weapon_shotgun" && !find_models(weapon, ["reserve_shooter", "panic_attack"]))

		case "pistol":
			return class_name == "tf_weapon_pistol"
				|| class_name == "tf_weapon_pistol_scout"

		case "frying_pan":
		case "saxxy": // prolly dont need to list everything, just check for "saxxy" /shrug
		case "conscientious_objector":
		case "freedom staff":
		case "bat_outta_hell":
		case "memory_maker":
		case "ham_shank":
		case "gold_frying_pan":
		case "crossing_guard":
		case "necro_smasher":
		case "prinny_machete":
			return class_name == "tf_weapon_saxxy"

		// for cases like scattergun, we will check to make sure its not the other weapons (f-a-n and back scatter)
		case "scattergun":
			return class_name == "tf_weapon_scattergun"
				&& !find_models(weapon, ["force_a_nature", "force_a_nature_xmas", "back_scatter"])

		case "shortstop":
			return class_name == "tf_weapon_handgun_scout_primary"

		case "soda_popper":
			return class_name == "tf_weapon_soda_popper"

		case "baby_faces_blaster":
			return class_name == "tf_weapon_pep_brawler_blaster"

		case "bonk":
		case "bonk_atomic_punch":
			return class_name == "tf_weapon_lunchbox_drink"
				&& !find_model(weapon, "crit_a_cola")

		case "milk":
		case "mad_milk":
			return class_name == "tf_weapon_jar_milk"

		case "flying_guillotine":
		case "cleaver":
			return class_name == "tf_weapon_cleaver"

		case "bat":
		case "unarmed combat":
		case "batsaber":
			return (class_name == "tf_weapon_bat" || class_name == "tf_weapon_bat_fish")
				&& !find_models(weapon, ["candy_cane", "boston_basher", "three_rune_blade", "sun_on_a_stick", "fan_o_war", "atomizer"])

		case "bat_wood":
		case "sandman":
			return class_name == "tf_weapon_bat_wood"

		case "wrap_assassin":
			return class_name == "tf_weapon_bat_giftwrap"

		case "rocketlauncher":
		case "rocket_launcher":
		case "original":
			return class_name == "tf_weapon_rocketlauncher"
				&& !find_models(weapon, ["black_box", "black_box_xmas", "rocket_jumper", "liberty_launcher", "beggars_bazooka"])


		case "directhit":
		case "direct_hit":
			return class_name == "tf_weapon_rocketlauncher_directhit"

		case "cow_mangler":
		case "cow_mangler_5000":
			return class_name == "tf_weapon_particle_cannon"

		case "airstrike":
		case "air_strike":
			return class_name == "tf_weapon_rocketlauncher_airstrike"

		case "buff_banner":
			return class_name == "tf_weapon_buff_item"
				&& !find_models(weapon, ["battalions_backup", "concheror"])

		case "booties":
		case "ali_babas_wee_booties":
		case "bootlegger":
			return class_name == "tf_weapon_tf_wearable" // double check class name
				&& !find_models(weapon, ["gunboats", "mantreads", "darwins_danger_shield", "cozy_camper"])

		case "bison":
		case "righteous_bison":
			return class_name = "tf_weapon_raygun"

		case "shovel":
			return class_name == "tf_weapon_shovel"
				&& !find_models(weapon, ["equalizer", "pain_train", "market_gardener", "disciplinary_action", "escape_plan"])

		case "katana":
		case "half_zatoichi":
			return class_name == "tf_weapon_katana"

		case "flamethrower":
			return class_name == "tf_weapon_flamethrower"
				&& !find_models(weapon, ["backburner", "backburner_xmas", "degreaser", "phlogistinator"])

		case "dragons_fury":
			return class_name == "tf_weapon_rocketlauncher_fireball"

		case "flare_gun":
		case "flaregun":
			return class_name == "tf_weapon_flaregun"
				&& !find_models(weapon, ["detonator", "scorch_shot"])

		case "manmelter":
			return class_name == "tf_weapon_flaregun_revenge"

		case "jetpack":
		case "thermal_thruster":
			return class_name == "tf_weapon_rocketpack"

		case "gas_passer":
			return class_name == "tf_weapon_jar_gas"

		case "fireaxe":
		case "fire_axe":
			return class_name == "tf_weapon_fireaxe"
				&& !find_models(weapon, ["axtinguisher", "axtinguisher_xmas", "postal_pummeler", "lollichop", "homewrecker", "maul", "powerjack", "back_scratcher", "sharpened_volcano_fragment", "third_degree"])

		case "neon_annihilator":
		case "pyroshark":
			return class_name == "tf_weapon_breakable_sign"

		case "hot_hand":
			return class_name == "tf_weapon_slap"

		case "grenade_launcher":
			return class_name == "tf_weapon_grenadelauncher"
				&& !find_models(weapon, ["loch_n_load", "iron_bomber"])

		case "loose_cannon":
			return class_name == "tf_weapon_cannon"

		case "sticky_launcher":
		case "stickybomb_launcher":
			return class_name == "tf_weapon_pipebomblauncher"
				&& !find_models(weapon, ["scottish_resistance","sticky_jumper","quickiebomb_launcher"])

		case "chargin_targe":
			return class_name == "tf_weapon_demoshield"
				&& !find_models(weapon, ["splendid_screen", "tide_turner"])

		case "bottle":
			return class_name == "tf_weapon_bottle"

		case "eyelander":
			return class_name == "tf_weapon_sword"
				&& !find_models(weapon, ["scotsmans_skullcutter", "claidheamh_mor", "persian_persuader"])

		case "any_sword":
			return class_name == "tf_weapon_sword" || class_name == "tf_weapon_katana"

		case "caber":
		case "ullapool_caber":
			return class_name == "tf_weapon_stickbomb"

		case "minigun":
			return class_name == "tf_weapon_minigun"
				&& !find_models(weapon, ["natascha", "brass_beast", "tomislav", "huo_long_heater"])

		case "sandvich":
			return class_name == "tf_weapon_lunchbox"
				&& !find_models(weapon, ["dalokohs_bar", "fishcake", "buffalo_steak_sandvich", "second_banana"])

		case "fists":
			return class_name == "tf_weapon_fists"
				&& !find_models(weapon, ["kgb", "gru", "gru_xmas", "bread_bite", "warriors_spirit", "fists_of_steel", "eviction_notice", "holiday_punch"])

		case "frontier_justice":
			return class_name == "tf_weapon_sentry_revenge"

		case "pomson":
			return class_name == "tf_weapon_drg_pomson"

		case "rescue_ranger":
			return class_name == "tf_weapon_shotgun_building_rescue"

		case "wrangler":
			return class_name == "tf_weapon_laser_pointer"

		case "short_circuit":
			return class_name == "tf_weapon_mechanic_arm"

		case "wrench":
			return class_name == "tf_weapon_wrench"
				&& !find_models(weapon, ["southern_hospitality", "jag", "eureka_effect"])

		case "gunslinger":
			return class_name == "tf_weapon_robot_arm"

		case "build_pda":
		case "construction_pda":
			return class_name == "tf_weapon_engineer_build"

		case "destroy_pda":
		case "destruction_pda":
			return class_name == "tf_weapon_engineer_destroy"

		case "syringegun_medic":
			return class_name == "tf_weapon_syringegun_medic"
				&& !find_models(weapon, ["blutsauger", "overdose"])

		case "crossbow":
		case "crusaders_crossbow":
			return class_name == "tf_weapon_crossbow"

		case "medigun":
			return class_name == "tf_weapon_medigun"
				&& !find_models(weapon, ["krtizkrieg", "quick_fix", "vaccinator"])

		case "bonesaw":
		case "bone_saw":
			return class_name == "tf_weapon_bonesaw"
				&& !find_models(weapon, ["ubersaw", "ubersaw_xmas", "vita_saw", "amputator", "solemn_vow"])

		case "sniper_rifle":
			return class_name == "tf_weapon_sniperrifle"
				&& !find_models(weapon, ["sydney_sleeper", "machina", "shooting_star", "hitmans_heatmaker"])

		case "huntsman":
		case "foritifed_compound":
			return class_name == "tf_weapon_compound_bow"

		case "bazaar_bargain":
			return class_name == "tf_weapon_sniperrfile_decap"

		case "classic":
			return class_name == "tf_weapon_sniperrfile_classic"

		case "smg":
			return class_name == "tf_weapon_smg"

		case "razorback":
			return class_name == "tf_weapon_razorback"

		case "jarate":
		case "piss":
			return class_Name == "tf_weapon_jar"

		case "cleaners_carbine":
			return class_name == "tf_weapon_charged_smg"

		case "kukri":
			return class_name == "tf_weapon_club"
				&& !find_models(weapon, ["tribalmans_shiv", "bushwacka", "shahanshah"])

		case "revolver":
			return class_name == "tf_weapon_revolver"
				&& !find_models(weapon, ["ambassador", "ambassador_xmas", "letranger", "enforcer", "diamondback"])

		case "sapper":
			return (class_name == "tf_weapon_builder" && !find_model(weapon, "toolbox"))
				|| (class_name == "tf_weapon_sapper" && !find_model(weapon, "red_tape_recorder"))

		case "knife":
			return class_name == "tf_weapon_knife"
				&& !find_models(weapon, ["your_eternal_reward", "wanga_prick", "kunai", "big_earner", "spycicle"])

		case "disguise_kit":
		case "disguise_pda":
		case "spy_pda":
			return class_name == "tf_weapon_pda_spy"

		case "invis_watch":
		case "invis":
			return class_name == "tf_weapon_invis"
				&& !find_models(weapon, ["dead_ringer", "cloak_and_dagger"])

		// in general find_model seems to work :+1:
		default:
			return find_model(weapon, name)
	}
}