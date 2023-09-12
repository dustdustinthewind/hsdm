item_origins <- {}

DRAG_DISTANCE <- 200.0

class force_pull_ammo_boxes extends hsdm_trait
{
	dragged_items = []
	function OnFrameTickAlive()
	{
		dragged_items = []
		local nearby_items = search_for_items()
		foreach(item in nearby_items)
		{
			SetPersistentVar(item, false) // hack

			if (!(item in item_origins))
				item_origins[item] <- item.GetOrigin()

			if (DRAG_DISTANCE > abs((player.GetOrigin() - item_origins[item]).Length()))
			{
				item.SetAbsOrigin(lerp(item.GetOrigin(), player.EyePosition(), 0.15))
				SetPersistentVar(item, true)

				dragged_items.push(item)
			}
		}
	}

	function OnDeath(attacker, params)
	{
		foreach(item in dragged_items)
			SetPersistentVar(item, false)
	}

	function search_for_items()
	{
		local lol = []
		local item = null
		while(item = Entities.FindByClassnameWithin(item, "item_*", player.GetOrigin(), DRAG_DISTANCE + 25))
			lol.push(item)
		return lol
	}
}

AddListener("tick_frame", 1, function()
{
	local item = null
	while (item = Entities.FindByClassname(item, "item_*"))
		if (item in item_origins &&	!GetPersistentVar(item))
			item.SetAbsOrigin(lerp(item.GetOrigin(), item_origins[item], 0.075))
})

characterTraitsClasses.push(force_pull_ammo_boxes)