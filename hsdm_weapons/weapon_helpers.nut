// for OnApply()
function change_weapon_clip(weapon, hsdm_clip, tf2_clip)
{
	local clip = hsdm_clip / tf2_clip
	local attr = "clip size " + (clip > 1.0 ? "bonus" : "penalty")

	weapon.AddAttribute(attr, clip, -1)
	weapon.SetClip1(hsdm_clip)
}

// for OnApply()
function change_weapon_reserve(weapon, slot, hsdm_reserve, tf2_reserve, overfill = false)
{
	local prim_sec_met = ""
	switch (slot)
	{
		case 0:
		case TF_AMMO.PRIMARY:
			prim_sec_met = "primary"
			break;
		case 1:
		case TF_AMMO.SECONDARY:
			prim_sec_met = "secondary"
			break;
		case TF_AMMO.METAL:
			prim_sec_met = "metal"
			break;
	}

	local reserve = (hsdm_reserve + (overfill ? 1 : 0)) / tf2_reserve

	local attr = "maxammo " + prim_sec_met + (reserve > 1 ? " increased" : " reduced")
	weapon.AddAttribute(attr, reserve, -1)
	SetPropIntArray(weapon.GetOwner(), "m_iAmmo", hsdm_reserve, slot)
}

// for OnApply()
function change_weapon_damage(weapon, damage, shotgunMod = 1.0, changeBuildingDamage = true)
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

// for OnApply()
function self_blast_force_boost(weapon, force, dmg_reduction = 0.75)
{
	weapon.AddAttribute("self dmg push force increased", force, -1)
	weapon.AddAttribute("rocket jump damage reduction", dmg_reduction, -1)
}

/*function fix_wep(player, weapon)
{
	SetPropEntity(weapon, "m_hOwnerEntity", player)
	SetPropEntity(weapon, "m_hOwner", player)
	weapon.SetOwner(null)
	weapon.SetOwner(player)
	weapon.ReapplyProvision()
}*/
// unsure if needed ^

// for finding a weapon out of a player's loadout through IsWeapon
function find_wep_in_slots(player, name, min, max, debugging = debug)
{
	for (local i = min; i <= max; i++)
	{
		local out = player.ReturnWeaponBySlot(i)
		if (out == null)
			out = player.GetPassiveWeaponBySlot(i)

		// when we run into our first null, just break we dont need to search more (what about grappling hook?)
		if (!out) break
		else if (WeaponIs(out, name, debugging))
		{
			if (debugging)
				printl("found " + name + ": " + out + " in slot " + i)
			return out
		}
	}

	if (debugging)
		printl("did not find " + name + " in slots " + min + "-" + max)
	return null
}

function find_weps_in_slots(player, classnames, min, max, debugging = debug)
{
	local to_return = null
	foreach (name in classnames)
		if (to_return = find_wep_in_slots(player, name, min, max, debugging))
			break
	return to_return
}

function find_wep_in_slot(player, classname, slot, debugging = debug)
{
	return find_wep_in_slots(player, classname, slot, slot, debugging)
}

function find_weps_in_slot(player, classnames, slot, debugging = debug)
{
	return find_weps_in_slots(player, classnames, slot, slot, debugging)
}

function find_wep(player, classname, debugging = debug)
{
	return find_wep_in_slots(player, classname, 0, GLOBAL_WEAPON_COUNT, debugging)
}

function find_weps(player, classnames, debugging = debug)
{
	return find_weps_in_slots(player, classnames, 0, GLOBAL_WEAPON_COUNT, debugging)
}