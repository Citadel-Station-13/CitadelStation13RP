/obj/item/mining_scanner
	name = "ore detector"
	desc = "A complex device used to locate ore deep underground around you."
	icon = 'icons/obj/device.dmi'
	icon_state = "forensic0-old" //GET A BETTER SPRITE.
	item_state = "electronic"
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 150)
	var/scanrange = 2
	var/maxscanrange = 2
	var/scan_time = 3 SECONDS
	var/scan_exact_ores = FALSE
	var/scan_exact_amounts = FALSE

/obj/item/mining_scanner/examine(mob/user)
	. = ..()
	. += "Current scan range is [scanrange] step(s) from user's current location, including current location. Alt-Click to change scan range."

/obj/item/mining_scanner/AltClick(mob/user)
	var/newscan = text2num(input(usr,"What would you like to set the scan range to? Maximum of [maxscanrange].","New Scan Range",maxscanrange))
	newscan = round(newscan,1)
	if(newscan >= maxscanrange)
		newscan = maxscanrange
	if(newscan < 0)
		newscan = 0
	scanrange = newscan
	to_chat(usr, "New scan range set to [scanrange] step(s) around user, including current location.")
	. = ..()

/obj/item/mining_scanner/attack_self(mob/user)
	to_chat(user, "<span class='notice'>You begin sweeping \the [src] about, scanning for metal deposits.</span>")
	playsound(loc, 'sound/items/goggles_charge.ogg', 50, 1, -6)

	if(!do_after(user, scan_time))
		return

	ScanTurf(get_turf(user), user, scan_exact_amounts, scan_exact_ores)

/obj/item/mining_scanner/proc/ScanTurf(atom/target, mob/user, exact_amount = FALSE, exact_ores = FALSE)
	var/list/metals = list()
	for(var/turf/T in range(scanrange, get_turf(user)))

		if(!T.has_resources)
			continue

		for(var/metal in T.resources)
			var/ore_type

			if(!exact_ores)
				switch(metal)
					if("silicates", "carbon", "hematite", "marble")
						ore_type = "surface minerals"
					if("gold", "silver", "diamond", "lead")
						ore_type = "precious metals"
					if("uranium")
						ore_type = "nuclear fuel"
					if("phoron", "osmium", "hydrogen")
						ore_type = "exotic matter"
					if("verdantium")
						ore_type = "anomalous matter"
			else
				ore_type = metal
			if(ore_type)
				if(metals[ore_type])
					metals[ore_type] += T.resources[metal]
				else
					metals[ore_type] = T.resources[metal]

	to_chat(user, "[icon2html(thing = src, target = user)] <span class='notice'>The scanner beeps and displays a readout.</span>")
	var/list/results = list()
	for(var/ore_type in metals)
		var/result = "no sign"

		if(exact_amount)
			result = "- [metals[ore_type]] of [ore_type]"
		else
			switch(metals[ore_type])
				if(1 to 25)
					result = "trace amounts of [ore_type]"
				if(26 to 75)
					result = "significant amounts of [ore_type]"
				if(76 to INFINITY)
					result = "huge quantities of [ore_type]"
		results += result
	to_chat(user, results.Join("<br>"))


/obj/item/mining_scanner/advanced
	name = "advanced ore detector"
	desc = "A compact, complex device used to quickly locate ore deep underground around you."
	icon_state = "mining-scanner" //thank you eris spriters
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MAGNET = 4, TECH_ENGINEERING = 4)
	matter = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000)
	scanrange = 5
	maxscanrange = 5
	scan_time = 1 SECONDS
	scan_exact_ores = TRUE
	scan_exact_amounts = TRUE
