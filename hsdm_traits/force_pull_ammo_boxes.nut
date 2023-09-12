item_origins <- {}
dragged_items <- []

DRAG_DISTANCE <- 200.0

class force_pull_ammo_boxes extends hsdm_trait
{
	function OnFrameTickAlive()
	{
		local nearby_items = search_for_items()
		foreach(pack in nearby_items)
		{
			if (!(pack in item_origins))
				item_origins[pack] <- pack.GetOrigin()

			if (DRAG_DISTANCE > abs(player.GetOrigin().Length() - item_origins[pack].Length()))
				pack.SetAbsOrigin(lerp(pack.GetOrigin(), player.EyePosition(), 0.125))
			dragged_items.push(pack)
		}
	}

	function search_for_items()
	{
		local lol = []
		local item = null
		while(item = Entities.FindByClassnameWithin(item, "item_*", player.GetOrigin(), DRAG_DISTANCE))
			lol.push(item)
		return lol
	}
}

AddListener("tick_frame", 1, function()
{
	local item = null
	while (item = Entities.FindByClassname(item, "item_*"))
		if (item in item_origins)
			item.SetAbsOrigin(lerp(item.GetOrigin(), item_origins[item], 0.075))
})

characterTraitsClasses.push(force_pull_ammo_boxes)