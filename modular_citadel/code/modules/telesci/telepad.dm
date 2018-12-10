/obj/machinery/telepad
	name = "telepad"
	desc = "A bluespace telepad used for teleporting objects to and from a location."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "pad-idle"
	anchored = 1
	use_power = 1
	idle_power_usage = 200
	active_power_usage = 5000
	var/efficiency

/obj/machinery/telepad/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/telesci_pad(null)
	component_parts += new /obj/item/weapon/ore/bluespace_crystal(null, 2)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(null)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
	component_parts += new /obj/item/stack/cable_coil(null, 1)
	RefreshParts()

/obj/machinery/telepad/upgraded/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/telesci_pad(null)
	component_parts += new /obj/item/weapon/ore/bluespace_crystal(null, 2)
	component_parts += new /obj/item/weapon/stock_parts/capacitor/super(null)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
	component_parts += new /obj/item/stack/cable_coil(null, 1)
	RefreshParts()

/obj/machinery/telepad/RefreshParts()
	var/E
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		E += C.rating
	efficiency = E

/obj/machinery/telepad/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)

	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return
	if(panel_open)
		if(istype(W, /obj/item/device/multitool))
			var/obj/item/device/multitool/M = W
			M.connectable = src
			user << "<span class='caution'>You save the data in the [M.name]'s buffer.</span>"
			return 1

	return ..()