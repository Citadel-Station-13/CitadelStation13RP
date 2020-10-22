proc/createRandomZlevel()
	if(awaydestinations.len || UNIT_TEST)	//crude, but it saves another var! //VOREStation Edit - No loading away missions during Travis testing
		return

	var/list/potentialRandomZlevels = list()
	admin_notice("<span class='danger'><B> Searching for away missions...</B></span>", R_DEBUG)
	var/list/Lines = file2list("maps/RandomZLevels/fileList.txt")
	if(!Lines.len)	return
	for (var/t in Lines)
		if (!t)
			continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
	//	var/value = null

		if (pos)
            // No, don't do lowertext here, that breaks paths on linux
			name = copytext(t, 1, pos)
		//	value = copytext(t, pos + 1)
		else
            // No, don't do lowertext here, that breaks paths on linux
			name = t

		if (!name)
			continue

		potentialRandomZlevels.Add(name)


	if(potentialRandomZlevels.len)
		admin_notice("<span class='danger'><B>Loading away mission...</B></span>", R_DEBUG)

		var/map = pick(potentialRandomZlevels)
		log_world("Away mission picked: [map]") //VOREStation Add for debugging
		var/file = file(map)
		if(isfile(file))
			var/datum/map_template/template = new(file, "away mission")
			template.load_new_z()
			log_world("away mission loaded: [map]")
		/* VOREStation Removal - We do this in the special landmark init instead.
		for(var/obj/effect/landmark/L in landmarks_list)
			if (L.name != "awaystart")
				continue
			awaydestinations.Add(L)
		*/ //VOREStation Removal End
		admin_notice("<span class='danger'><B>Away mission loaded.</B></span>", R_DEBUG)

	else
		admin_notice("<span class='danger'><B>No away missions found.</B></span>", R_DEBUG)
		return

//VOREStation Add - This landmark type so it's not so ghetto.
/obj/effect/landmark/gateway_scatter
	name = "uncalibrated gateway destination"
/obj/effect/landmark/gateway_scatter/Initialize()
	. = ..()
	awaydestinations += src

/obj/effect/landmark/event_scatter
	name = "uncalibrated gateway destination"
/obj/effect/landmark/event_scatter/Initialize()
	. = ..()
	eventdestinations += src
//VOREStation Add End
