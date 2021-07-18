/**
 *  A vending machine
 */
/obj/machinery/vending
	name = "Vendomat"
	desc = "A generic vending machine."
	icon = 'icons/obj/vending_vr.dmi' //VOREStation Edit - Eris vending machine sprites
	icon_state = "generic"
	anchored = 1
	density = 1

	var/icon_vend //Icon_state when vending
	var/icon_deny //Icon_state when denying access

	// Power
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	var/vend_power_usage = 150 //actuators and stuff

	// Vending-related
	var/active = 1 //No sales pitches if off!
	var/vend_ready = 1 //Are we ready to vend?? Is it time??
	var/vend_delay = 10 //How long does it take to vend?
	var/categories = CAT_NORMAL // Bitmask of cats we're currently showing
	var/datum/stored_item/vending_product/currently_vending = null // What we're requesting payment for right now
	var/status_message = "" // Status screen messages like "insufficient funds", displayed in NanoUI
	var/status_error = 0 // Set to 1 if status_message is an error

	/*
		Variables used to initialize the product list
		These are used for initialization only, and so are optional if
		product_records is specified
	*/
	var/list/products	= list() // For each, use the following pattern:
	var/list/contraband	= list() // list(/type/path = amount,/type/path2 = amount2)
	var/list/premium 	= list() // No specified amount = only one in stock
	var/list/prices     = list() // Prices for each item, list(/type/path = price), items not in the list don't have a price.

	// List of vending_product items available.
	var/list/product_records = list()


	// Variables used to initialize advertising
	var/product_slogans = "" //String of slogans spoken out loud, separated by semicolons
	var/product_ads = "" //String of small ad messages in the vending screen

	var/list/ads_list = list()

	// Stuff relating vocalizations
	var/list/slogan_list = list()
	var/shut_up = 1 //Stop spouting those godawful pitches!
	var/vend_reply //Thank you for shopping!
	var/last_reply = 0
	var/last_slogan = 0 //When did we last pitch?
	var/slogan_delay = 6000 //How long until we can pitch again?

	// Things that can go wrong
	emagged = 0 //Ignores if somebody doesn't have card access to that machine.
	var/seconds_electrified = 0 //Shock customers like an airlock.
	var/shoot_inventory = 0 //Fire items at customers! We're broken!

	var/scan_id = 1
	var/obj/item/coin/coin
	var/datum/wires/vending/wires = null

	var/list/log = list()
	var/req_log_access = access_cargo //default access for checking logs is cargo
	var/has_logs = 0 //defaults to 0, set to anything else for vendor to have logs


/obj/machinery/vending/Initialize(mapload)
	. = ..()
	wires = new(src)
	spawn(4)
		if(product_slogans)
			slogan_list += splittext(product_slogans, ";")

			// So not all machines speak at the exact same time.
			// The first time this machine says something will be at slogantime + this random value,
			// so if slogantime is 10 minutes, it will say it at somewhere between 10 and 20 minutes after the machine is crated.
			last_slogan = world.time + rand(0, slogan_delay)

		if(product_ads)
			ads_list += splittext(product_ads, ";")

		build_inventory()
		power_change()

/**
 *  Build produdct_records from the products lists
 *
 *  products, contraband, premium, and prices allow specifying
 *  products that the vending machine is to carry without manually populating
 *  product_records.
 */
/obj/machinery/vending/proc/build_inventory()
	var/list/all_products = list(
		list(products, CAT_NORMAL),
		list(contraband, CAT_HIDDEN),
		list(premium, CAT_COIN))

	for(var/current_list in all_products)
		var/category = current_list[2]

		for(var/entry in current_list[1])
			var/datum/stored_item/vending_product/product = new/datum/stored_item/vending_product(src, entry)

			product.price = (entry in prices) ? prices[entry] : 0
			product.amount = (current_list[1][entry]) ? current_list[1][entry] : 1
			product.category = category

			product_records.Add(product)

/obj/machinery/vending/Destroy()
	qdel(wires)
	wires = null
	qdel(coin)
	coin = null
	for(var/datum/stored_item/vending_product/R in product_records)
		qdel(R)
	product_records = null
	return ..()

/obj/machinery/vending/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				spawn(0)
					malfunction()
					return
				return
		else
	return

/obj/machinery/vending/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = 1
		to_chat(user, "You short out \the [src]'s product lock.")
		return 1

/obj/machinery/vending/attackby(obj/item/W as obj, mob/user as mob)

	var/obj/item/card/id/I = W.GetID()

	if(currently_vending && vendor_account && !vendor_account.suspended)
		var/paid = 0
		var/handled = 0

		if(I) //for IDs and PDAs and wallets with IDs
			paid = pay_with_card(I,W)
			handled = 1
		else if(istype(W, /obj/item/spacecash/ewallet))
			var/obj/item/spacecash/ewallet/C = W
			paid = pay_with_ewallet(C)
			handled = 1
		else if(istype(W, /obj/item/spacecash))
			var/obj/item/spacecash/C = W
			paid = pay_with_cash(C, user)
			handled = 1

		if(paid)
			vend(currently_vending, usr)
			return
		else if(handled)
			SSnanoui.update_uis(src)
			return // don't smack that machine with your 2 thalers

	if(I || istype(W, /obj/item/spacecash))
		attack_hand(user)
		return
	else if(W.is_screwdriver())
		panel_open = !panel_open
		to_chat(user, "You [panel_open ? "open" : "close"] the maintenance panel.")
		playsound(src, W.usesound, 50, 1)
		overlays.Cut()
		if(panel_open)
			overlays += image(icon, "[initial(icon_state)]-panel")

		SSnanoui.update_uis(src)  // Speaker switch is on the main UI, not wires UI
		return
	else if(istype(W, /obj/item/multitool) || W.is_wirecutter())
		if(panel_open)
			attack_hand(user)
		return
	else if(istype(W, /obj/item/coin) && premium.len > 0)
		user.drop_item()
		W.forceMove(src)
		coin = W
		categories |= CAT_COIN
		to_chat(user, "<span class='notice'>You insert \the [W] into \the [src].</span>")
		SSnanoui.update_uis(src)
		return
	else if(W.is_wrench())
		playsound(src, W.usesound, 100, 1)
		if(anchored)
			user.visible_message("[user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
		else
			user.visible_message("[user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")

		if(do_after(user, 20 * W.toolspeed))
			if(!src) return
			to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>")
			anchored = !anchored
		return
	else

		for(var/datum/stored_item/vending_product/R in product_records)
			if(istype(W, R.item_path) && (W.name == R.item_name))
				stock(W, R, user)
				return
		..()

/**
 *  Receive payment with cashmoney.
 *
 *  usr is the mob who gets the change.
 */
/obj/machinery/vending/proc/pay_with_cash(var/obj/item/spacecash/cashmoney, mob/user)
	if(currently_vending.price > cashmoney.worth)

		// This is not a status display message, since it's something the character
		// themselves is meant to see BEFORE putting the money in
		to_chat(user, "[icon2html(thing = cashmoney, target = user)] <span class='warning'>That is not enough money.</span>")
		return 0

	if(istype(cashmoney, /obj/item/spacecash))

		visible_message("<span class='info'>\The [usr] inserts some cash into \the [src].</span>")
		cashmoney.worth -= currently_vending.price

		if(cashmoney.worth <= 0)
			user.drop_from_inventory(cashmoney)
			qdel(cashmoney)
		else
			cashmoney.update_icon()

	// Vending machines have no idea who paid with cash
	credit_purchase("(cash)")
	return 1

/**
 * Scan a chargecard and deduct payment from it.
 *
 * Takes payment for whatever is the currently_vending item. Returns 1 if
 * successful, 0 if failed.
 */
/obj/machinery/vending/proc/pay_with_ewallet(var/obj/item/spacecash/ewallet/wallet)
	visible_message("<span class='info'>\The [usr] swipes \the [wallet] through \the [src].</span>")
	if(currently_vending.price > wallet.worth)
		status_message = "Insufficient funds on chargecard."
		status_error = 1
		return 0
	else
		wallet.worth -= currently_vending.price
		credit_purchase("[wallet.owner_name] (chargecard)")
		return 1

/**
 * Scan a card and attempt to transfer payment from associated account.
 *
 * Takes payment for whatever is the currently_vending item. Returns 1 if
 * successful, 0 if failed
 */
/obj/machinery/vending/proc/pay_with_card(var/obj/item/card/id/I, var/obj/item/ID_container)
	if(I==ID_container || ID_container == null)
		visible_message("<span class='info'>\The [usr] swipes \the [I] through \the [src].</span>")
	else
		visible_message("<span class='info'>\The [usr] swipes \the [ID_container] through \the [src].</span>")
	var/datum/money_account/customer_account = get_account(I.associated_account_number)
	if(!customer_account)
		status_message = "Error: Unable to access account. Please contact technical support if problem persists."
		status_error = 1
		return 0

	if(customer_account.suspended)
		status_message = "Unable to access account: account suspended."
		status_error = 1
		return 0

	// Have the customer punch in the PIN before checking if there's enough money. Prevents people from figuring out acct is
	// empty at high security levels
	if(customer_account.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
		var/attempt_pin = input("Enter pin code", "Vendor transaction") as num
		customer_account = attempt_account_access(I.associated_account_number, attempt_pin, 2)

		if(!customer_account)
			status_message = "Unable to access account: incorrect credentials."
			status_error = 1
			return 0

	if(currently_vending.price > customer_account.money)
		status_message = "Insufficient funds in account."
		status_error = 1
		return 0
	else
		// Okay to move the money at this point

		// debit money from the purchaser's account
		customer_account.money -= currently_vending.price

		// create entry in the purchaser's account log
		var/datum/transaction/T = new()
		T.target_name = "[vendor_account.owner_name] (via [name])"
		T.purpose = "Purchase of [currently_vending.item_name]"
		if(currently_vending.price > 0)
			T.amount = "([currently_vending.price])"
		else
			T.amount = "[currently_vending.price]"
		T.source_terminal = name
		T.date = current_date_string
		T.time = stationtime2text()
		customer_account.transaction_log.Add(T)

		// Give the vendor the money. We use the account owner name, which means
		// that purchases made with stolen/borrowed card will look like the card
		// owner made them
		credit_purchase(customer_account.owner_name)
		return 1

/**
 *  Add money for current purchase to the vendor account.
 *
 *  Called after the money has already been taken from the customer.
 */
/obj/machinery/vending/proc/credit_purchase(var/target as text)
	vendor_account.money += currently_vending.price

	var/datum/transaction/T = new()
	T.target_name = target
	T.purpose = "Purchase of [currently_vending.item_name]"
	T.amount = "[currently_vending.price]"
	T.source_terminal = name
	T.date = current_date_string
	T.time = stationtime2text()
	vendor_account.transaction_log.Add(T)

/obj/machinery/vending/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/vending/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return

	if(seconds_electrified != 0)
		if(shock(user, 100))
			return

	wires.Interact(user)
	nano_ui_interact(user)

/**
 *  Display the NanoUI window for the vending machine.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/vending/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/list/data = list()
	if(currently_vending)
		data["mode"] = 1
		data["product"] = currently_vending.item_name
		data["price"] = currently_vending.price
		data["message_err"] = 0
		data["message"] = status_message
		data["message_err"] = status_error
	else
		data["mode"] = 0
		var/list/listed_products = list()

		for(var/key = 1 to product_records.len)
			var/datum/stored_item/vending_product/I = product_records[key]

			if(!(I.category & categories))
				continue

			listed_products.Add(list(list(
				"key" = key,
				"name" = I.item_name,
				"price" = I.price,
				"color" = I.display_color,
				"amount" = I.get_amount())))

		data["products"] = listed_products

	if(coin)
		data["coin"] = coin.name

	if(panel_open)
		data["panel"] = 1
		data["speaker"] = shut_up ? 0 : 1
	else
		data["panel"] = 0

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "vending_machine.tmpl", name, 440, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/vending/Topic(href, href_list)
	if(stat & (BROKEN|NOPOWER))
		return
	if(!IsAdminGhost(usr) && (usr.stat || usr.restrained()))
		return

	if(href_list["remove_coin"] && !istype(usr,/mob/living/silicon))
		if(!coin)
			to_chat(usr, "There is no coin in this machine.")
			return

		coin.forceMove(src.loc)
		if(!usr.get_active_hand())
			usr.put_in_hands(coin)
		to_chat(usr, "<span class='notice'>You remove \the [coin] from \the [src]</span>")
		coin = null
		categories &= ~CAT_COIN

	if(IsAdminGhost(usr) || (usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))))
		if((href_list["vend"]) && (vend_ready) && (!currently_vending))
			if((!allowed(usr)) && !emagged && scan_id)	//For SECURE VENDING MACHINES YEAH
				to_chat(usr, "<span class='warning'>Access denied.</span>")	//Unless emagged of course
				flick(icon_deny,src)
				playsound(src.loc, 'sound/machines/deniedbeep.ogg', 50, 0)
				return

			var/key = text2num(href_list["vend"])
			var/datum/stored_item/vending_product/R = product_records[key]

			// This should not happen unless the request from NanoUI was bad
			if(!(R.category & categories))
				return

			if((R.price <= 0) || IsAdminGhost(usr))
				vend(R, usr)
			else if(istype(usr,/mob/living/silicon)) //If the item is not free, provide feedback if a synth is trying to buy something.
				to_chat(usr, "<span class='danger'>Lawed unit recognized.  Lawed units cannot complete this transaction.  Purchase canceled.</span>")
				return
			else
				currently_vending = R
				if(!vendor_account || vendor_account.suspended)
					status_message = "This machine is currently unable to process payments due to issues with the associated account."
					status_error = 1
				else
					status_message = "Please swipe a card or insert cash to pay for the item."
					status_error = 0

		else if(href_list["cancelpurchase"])
			currently_vending = null

		else if((href_list["togglevoice"]) && (panel_open))
			shut_up = !shut_up

		add_fingerprint(usr)
		SSnanoui.update_uis(src)

/obj/machinery/vending/proc/vend(datum/stored_item/vending_product/R, mob/user)
	if((!allowed(usr)) && !emagged && scan_id)	//For SECURE VENDING MACHINES YEAH
		to_chat(usr, "<span class='warning'>Access denied.</span>")	//Unless emagged of course
		flick(icon_deny,src)
		playsound(src.loc, 'sound/machines/deniedbeep.ogg', 50, 0)
		return
	vend_ready = 0 //One thing at a time!!
	status_message = "Vending..."
	status_error = 0
	SSnanoui.update_uis(src)

	if(R.category & CAT_COIN)
		if(!coin)
			to_chat(user, "<span class='notice'>You need to insert a coin to get this item.</span>")
			return
		if(coin.string_attached)
			if(prob(50))
				to_chat(user, "<span class='notice'>You successfully pull the coin out before \the [src] could swallow it.</span>")
			else
				to_chat(user, "<span class='notice'>You weren't able to pull the coin out fast enough, the machine ate it, string and all.</span>")
				qdel(coin)
				coin = null
				categories &= ~CAT_COIN
		else
			qdel(coin)
			coin = null
			categories &= ~CAT_COIN

	if(((last_reply + (vend_delay + 200)) <= world.time) && vend_reply)
		spawn(0)
			speak(vend_reply)
			last_reply = world.time

	use_power(vend_power_usage)	//actuators and stuff
	if(icon_vend) //Show the vending animation if needed
		flick(icon_vend,src)
	spawn(vend_delay)
		R.get_product(get_turf(src))
		if(has_logs)
			do_logging(R, user, 1)
		if(prob(1))
			sleep(3)
			if(R.get_product(get_turf(src)))
				visible_message("<span class='notice'>\The [src] clunks as it vends an additional item.</span>")

		playsound(src, 'sound/items/vending.ogg', 50, 1, 1)

		status_message = ""
		status_error = 0
		vend_ready = 1
		currently_vending = null
		SSnanoui.update_uis(src)

	return 1

/obj/machinery/vending/proc/do_logging(datum/stored_item/vending_product/R, mob/user, var/vending = 0)
	if(user.GetIdCard())
		var/obj/item/card/id/tempid = user.GetIdCard()
		var/list/list_item = list()
		if(vending)
			list_item += "vend"
		else
			list_item += "stock"
		list_item += tempid.registered_name
		list_item += stationtime2text()
		list_item += R.item_name
		log[++log.len] = list_item

/obj/machinery/vending/proc/show_log(mob/user as mob)
	if(user.GetIdCard())
		var/obj/item/card/id/tempid = user.GetIdCard()
		if(req_log_access in tempid.GetAccess())
			var/datum/browser/popup = new(user, "vending_log", "Vending Log", 700, 500)
			var/dat = ""
			dat += "<center><span style='font-size:24pt'><b>[name] Vending Log</b></span></center>"
			dat += "<center><span style='font-size:16pt'>Welcome [user.name]!</span></center><br>"
			dat += "<span style='font-size:8pt'>Below are the recent vending logs for your vending machine.</span><br>"
			for(var/i in log)
				dat += json_encode(i)
				dat += ";<br>"
			popup.set_content(dat)
			popup.open()
	else
		to_chat(user,"<span class='warning'>You do not have the required access to view the vending logs for this machine.</span>")

/obj/machinery/vending/verb/check_logs()
	set name = "Check Vending Logs"
	set category = "Object"
	set src in oview(1)

	show_log(usr)

/**
 * Add item to the machine
 *
 * Checks if item is vendable in this machine should be performed before
 * calling. W is the item being inserted, R is the associated vending_product entry.
 */
/obj/machinery/vending/proc/stock(obj/item/W, var/datum/stored_item/vending_product/R, var/mob/user)
	if(!user.unEquip(W))
		return

	to_chat(user, "<span class='notice'>You insert \the [W] in the product receptor.</span>")
	R.add_product(W)
	if(has_logs)
		do_logging(R, user)

	SSnanoui.update_uis(src)

/obj/machinery/vending/process(delta_time)
	if(stat & (BROKEN|NOPOWER))
		return

	if(!active)
		return

	if(seconds_electrified > 0)
		seconds_electrified--

	//Pitch to the people!  Really sell it!
	if(((last_slogan + slogan_delay) <= world.time) && (slogan_list.len > 0) && (!shut_up) && prob(5))
		var/slogan = pick(slogan_list)
		speak(slogan)
		last_slogan = world.time

	if(shoot_inventory && prob(2))
		throw_item()

	return

/obj/machinery/vending/proc/speak(var/message)
	if(stat & NOPOWER)
		return

	if(!message)
		return

	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='game say'><span class='name'>\The [src]</span> beeps, \"[message]\"</span>",2)
	return

/obj/machinery/vending/power_change()
	..()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else
		if(!(stat & NOPOWER))
			icon_state = initial(icon_state)
		else
			spawn(rand(0, 15))
				icon_state = "[initial(icon_state)]-off"

//Oh no we're malfunctioning!  Dump out some product and break.
/obj/machinery/vending/proc/malfunction()
	for(var/datum/stored_item/vending_product/R in product_records)
		while(R.get_amount()>0)
			R.get_product(loc)
		break

	stat |= BROKEN
	icon_state = "[initial(icon_state)]-broken"
	return

//Somebody cut an important wire and now we're following a new definition of "pitch."
/obj/machinery/vending/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for(var/datum/stored_item/vending_product/R in product_records)
		throw_item = R.get_product(loc)
		if(!throw_item)
			continue
		break
	if(!throw_item)
		return 0
	spawn(0)
		throw_item.throw_at(target, 16, 3, src)
	visible_message("<span class='warning'>\The [src] launches \a [throw_item] at \the [target]!</span>")
	return 1

/*
 * Vending machine types
 */

/*

/obj/machinery/vending/[vendors name here]   // --vending machine template   :)
	name = ""
	desc = ""
	icon = ''
	icon_state = ""
	vend_delay = 15
	products = list()
	contraband = list()
	premium = list()

*/

/*
/obj/machinery/vending/atmospherics //Commenting this out until someone ponies up some actual working, broken, and unpowered sprites - Quarxink
	name = "Tank Vendor"
	desc = "A vendor with a wide variety of masks and gas tanks."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dispenser"
	product_paths = "/obj/item/tank/oxygen;/obj/item/tank/phoron;/obj/item/tank/emergency_oxygen;/obj/item/tank/emergency_oxygen/engi;/obj/item/clothing/mask/breath"
	productamounts = "10;10;10;5;25"
	vend_delay = 0
*/

/obj/machinery/vending/boozeomat
	name = "Booze-O-Mat"
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	icon_state = "boozeomat"
	icon_deny = "boozeomat-deny"
	products = list(/obj/item/reagent_containers/food/drinks/glass2/square = 10,
					/obj/item/reagent_containers/food/drinks/glass2/rocks = 10,
					/obj/item/reagent_containers/food/drinks/glass2/shake = 10,
					/obj/item/reagent_containers/food/drinks/glass2/cocktail = 10,
					/obj/item/reagent_containers/food/drinks/glass2/shot = 10,
					/obj/item/reagent_containers/food/drinks/glass2/pint = 10,
					/obj/item/reagent_containers/food/drinks/glass2/mug = 10,
					/obj/item/reagent_containers/food/drinks/glass2/wine = 10,
					/obj/item/reagent_containers/food/drinks/glass2/pitcher = 10,
					/obj/item/reagent_containers/food/drinks/metaglass = 25,
					/obj/item/reagent_containers/food/drinks/bottle/gin = 5,
					/obj/item/reagent_containers/food/drinks/bottle/absinthe = 5,
					/obj/item/reagent_containers/food/drinks/bottle/bluecuracao = 5,
					/obj/item/reagent_containers/food/drinks/bottle/cognac = 5,
					/obj/item/reagent_containers/food/drinks/bottle/grenadine = 5,
					/obj/item/reagent_containers/food/drinks/bottle/kahlua = 5,
					/obj/item/reagent_containers/food/drinks/bottle/melonliquor = 5,
					/obj/item/reagent_containers/food/drinks/bottle/peppermintschnapps = 5,
					/obj/item/reagent_containers/food/drinks/bottle/peachschnapps = 5,
					/obj/item/reagent_containers/food/drinks/bottle/lemonadeschnapps = 5,
					/obj/item/reagent_containers/food/drinks/bottle/rum = 5,
					/obj/item/reagent_containers/food/drinks/bottle/sake = 5,
					/obj/item/reagent_containers/food/drinks/bottle/specialwhiskey = 5,
					/obj/item/reagent_containers/food/drinks/bottle/tequilla = 5,
					/obj/item/reagent_containers/food/drinks/bottle/vermouth = 5,
					/obj/item/reagent_containers/food/drinks/bottle/vodka = 5,
					/obj/item/reagent_containers/food/drinks/bottle/whiskey = 5,
					/obj/item/reagent_containers/food/drinks/bottle/wine = 5,
          /obj/item/reagent_containers/food/drinks/bottle/whitewine = 5,
					/obj/item/reagent_containers/food/drinks/bottle/bitters = 5,
					/obj/item/reagent_containers/food/drinks/bottle/small/ale = 15,
					/obj/item/reagent_containers/food/drinks/bottle/small/beer = 15,
					/obj/item/reagent_containers/food/drinks/bottle/small/cider = 15,
					/obj/item/reagent_containers/food/drinks/bottle/small/alcsassafras = 15,
					/obj/item/reagent_containers/food/drinks/bottle/orangejuice = 5,
					/obj/item/reagent_containers/food/drinks/bottle/tomatojuice = 5,
					/obj/item/reagent_containers/food/drinks/bottle/limejuice = 5,
					/obj/item/reagent_containers/food/drinks/bottle/lemonjuice = 5,
					/obj/item/reagent_containers/food/drinks/bottle/applejuice = 5,
					/obj/item/reagent_containers/food/drinks/bottle/milk = 5,
					/obj/item/reagent_containers/food/drinks/bottle/cream = 5,
					/obj/item/reagent_containers/food/drinks/bottle/cola = 5,
					/obj/item/reagent_containers/food/drinks/bottle/space_up = 5,
					/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind = 5,
					/obj/item/reagent_containers/food/drinks/bottle/champagne/jericho = 1,
					/obj/item/reagent_containers/food/drinks/bottle/champagne = 3,
					/obj/item/reagent_containers/food/drinks/cans/sodawater = 15,
					/obj/item/reagent_containers/food/drinks/cans/tonic = 15,
					/obj/item/reagent_containers/food/drinks/cans/gingerale = 15,
					/obj/item/reagent_containers/food/drinks/flask/barflask = 5,
					/obj/item/reagent_containers/food/drinks/flask/vacuumflask = 5,
					/obj/item/reagent_containers/food/drinks/ice = 10,
					/obj/item/reagent_containers/food/drinks/tea = 15,
					/obj/item/glass_extra/stick = 30,
					/obj/item/glass_extra/straw = 30)
	contraband = list()
	vend_delay = 15
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	product_slogans = "I hope nobody asks me for a bloody cup o' tea...;Alcohol is humanity's friend. Would you abandon a friend?;Quite delighted to serve you!;Is nobody thirsty on this station?"
	product_ads = "Drink up!;Booze is good for you!;Alcohol is humanity's best friend.;Quite delighted to serve you!;Care for a nice, cold beer?;Nothing cures you like booze!;Have a sip!;Have a drink!;Have a beer!;Beer is good for you!;Only the finest alcohol!;Best quality booze since 2053!;Award-winning wine!;Maximum alcohol!;Man loves beer.;A toast for progress!"
	req_access = list(access_bar)
	req_log_access = access_bar
	has_logs = 1

/obj/machinery/vending/assist
	products = list(	/obj/item/assembly/prox_sensor = 5,/obj/item/assembly/igniter = 3,/obj/item/assembly/signaler = 4,
						/obj/item/tool/wirecutters = 1, /obj/item/cartridge/signal = 4)
	contraband = list(/obj/item/flashlight = 5,/obj/item/assembly/timer = 2)
	product_ads = "Only the finest!;Have some tools.;The most robust equipment.;The finest gear in space!"

/obj/machinery/vending/coffee
	name = "Hot Drinks machine"
	desc = "A vending machine which dispenses hot drinks."
	product_ads = "Have a drink!;Drink up!;It's good for you!;Would you like a hot joe?;I'd kill for some coffee!;The best beans in the galaxy.;Only the finest brew for you.;Mmmm. Nothing like a coffee.;I like coffee, don't you?;Coffee helps you work!;Try some tea.;We hope you like the best!;Try our new chocolate!;Admin conspiracies"
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	vend_delay = 34
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vend_power_usage = 85000 //85 kJ to heat a 250 mL cup of coffee
	products = list(/obj/item/reagent_containers/food/drinks/coffee = 25,/obj/item/reagent_containers/food/drinks/tea = 25,/obj/item/reagent_containers/food/drinks/h_chocolate = 25)
	contraband = list(/obj/item/reagent_containers/food/drinks/ice = 10)
	prices = list(/obj/item/reagent_containers/food/drinks/coffee = 3, /obj/item/reagent_containers/food/drinks/tea = 3, /obj/item/reagent_containers/food/drinks/h_chocolate = 3)

/obj/machinery/vending/snack
	name = "Getmore Chocolate Corp"
	desc = "A snack machine courtesy of the Getmore Chocolate Corporation, based out of Mars."
	product_slogans = "Try our new nougat bar!;Twice the calories for half the price!"
	product_ads = "The healthiest!;Award-winning chocolate bars!;Mmm! So good!;Oh my god it's so juicy!;Have a snack.;Snacks are good for you!;Have some more Getmore!;Best quality snacks straight from mars.;We love chocolate!;Try our new jerky!"
	icon_state = "snack"
	products = list(/obj/item/reagent_containers/food/snacks/candy = 6,/obj/item/reagent_containers/food/drinks/dry_ramen = 6,/obj/item/reagent_containers/food/snacks/chips =6,
					/obj/item/reagent_containers/food/snacks/sosjerky = 6,/obj/item/reagent_containers/food/snacks/no_raisin = 6,/obj/item/reagent_containers/food/snacks/spacetwinkie = 6,
					/obj/item/reagent_containers/food/snacks/cheesiehonkers = 6, /obj/item/reagent_containers/food/snacks/tastybread = 6, /obj/item/reagent_containers/food/snacks/skrellsnacks = 3,
					/obj/item/reagent_containers/food/snacks/baschbeans = 6, /obj/item/reagent_containers/food/snacks/creamcorn = 6)
	contraband = list(/obj/item/reagent_containers/food/snacks/syndicake = 6,/obj/item/reagent_containers/food/snacks/unajerky = 6,)
	prices = list(/obj/item/reagent_containers/food/snacks/candy = 1,/obj/item/reagent_containers/food/drinks/dry_ramen = 5,/obj/item/reagent_containers/food/snacks/chips = 1,
					/obj/item/reagent_containers/food/snacks/sosjerky = 2,/obj/item/reagent_containers/food/snacks/no_raisin = 1,/obj/item/reagent_containers/food/snacks/spacetwinkie = 1,
					/obj/item/reagent_containers/food/snacks/cheesiehonkers = 1, /obj/item/reagent_containers/food/snacks/tastybread = 2, /obj/item/reagent_containers/food/snacks/skrellsnacks = 4,
					/obj/item/reagent_containers/food/snacks/baschbeans = 6, /obj/item/reagent_containers/food/snacks/creamcorn = 6)

/obj/machinery/vending/cola
	name = "Robust Softdrinks"
	desc = "A softdrink vendor provided by Robust Industries, LLC."
	icon_state = "Cola_Machine" //VOREStation Edit
	icon_vend = "Cola_Machine-purchase" //VOREStation Edit
	product_slogans = "Robust Softdrinks: More robust than a toolbox to the head!"
	product_ads = "Refreshing!;Hope you're thirsty!;Over 1 million drinks sold!;Thirsty? Why not cola?;Please, have a drink!;Drink up!;The best drinks in space."
	products = list(/obj/item/reagent_containers/food/drinks/cans/cola = 10,/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 10,
					/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 10,/obj/item/reagent_containers/food/drinks/cans/starkist = 10,
					/obj/item/reagent_containers/food/drinks/cans/waterbottle = 10,/obj/item/reagent_containers/food/drinks/cans/space_up = 10,
					/obj/item/reagent_containers/food/drinks/cans/iced_tea = 10, /obj/item/reagent_containers/food/drinks/cans/grape_juice = 10,
					/obj/item/reagent_containers/food/drinks/cans/gingerale = 10, /obj/item/reagent_containers/food/drinks/bottle/small/sarsaparilla = 10,
					/obj/item/reagent_containers/food/drinks/bottle/small/sassafras = 10)
	contraband = list(/obj/item/reagent_containers/food/drinks/cans/thirteenloko = 5, /obj/item/reagent_containers/food/snacks/liquidfood = 6)
	prices = list(/obj/item/reagent_containers/food/drinks/cans/cola = 1,/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 1,
					/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 1,/obj/item/reagent_containers/food/drinks/cans/starkist = 1,
					/obj/item/reagent_containers/food/drinks/cans/waterbottle = 2,/obj/item/reagent_containers/food/drinks/cans/space_up = 1,
					/obj/item/reagent_containers/food/drinks/cans/iced_tea = 1,/obj/item/reagent_containers/food/drinks/cans/grape_juice = 1,
					/obj/item/reagent_containers/food/drinks/cans/gingerale = 1, /obj/item/reagent_containers/food/drinks/bottle/small/sarsaparilla = 1,
					/obj/item/reagent_containers/food/drinks/bottle/small/sassafras = 1)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/fitness // Added Liquid Protein and slightly adjusted price of liquid food items due to buff.
	name = "SweatMAX"
	desc = "Fueled by your inner inadequacy!"
	icon_state = "fitness"
	products = list(/obj/item/reagent_containers/food/drinks/smallmilk = 8,
					/obj/item/reagent_containers/food/drinks/smallchocmilk = 8,
					/obj/item/reagent_containers/food/drinks/glass2/fitnessflask/proteinshake = 8,
					/obj/item/reagent_containers/food/drinks/glass2/fitnessflask = 8,
					/obj/item/reagent_containers/food/snacks/candy/proteinbar = 8,
					/obj/item/reagent_containers/food/snacks/liquidfood = 10,
					/obj/item/reagent_containers/food/snacks/liquidprotein = 10,
					/obj/item/reagent_containers/pill/diet = 8,
					///obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose = 5,	//VOREStation Removal,
					/obj/item/towel/random = 8)

	prices = list(/obj/item/reagent_containers/food/drinks/smallmilk = 3,
					/obj/item/reagent_containers/food/drinks/smallchocmilk = 3,
					/obj/item/reagent_containers/food/drinks/glass2/fitnessflask/proteinshake = 35,
					/obj/item/reagent_containers/food/drinks/glass2/fitnessflask = 5,
					/obj/item/reagent_containers/food/snacks/candy/proteinbar = 5,
					/obj/item/reagent_containers/food/snacks/liquidfood = 10,
					/obj/item/reagent_containers/food/snacks/liquidprotein = 10,
					/obj/item/reagent_containers/pill/diet = 25,
					///obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose = 5,	//VOREStation Removal,
					/obj/item/towel/random = 40)

	contraband = list(/obj/item/reagent_containers/syringe/steroid = 4)

/obj/machinery/vending/cart
	name = "PTech"
	desc = "Cartridges for PDAs."
	product_slogans = "Carts to go!"
	icon_state = "cart"
	icon_deny = "cart-deny"
	req_access = list(access_hop)
	products = list(/obj/item/cartridge/medical = 10,/obj/item/cartridge/engineering = 10,/obj/item/cartridge/security = 10,
					/obj/item/cartridge/janitor = 10,/obj/item/cartridge/signal/science = 10,/obj/item/pda/heads = 10,
					/obj/item/cartridge/captain = 3,/obj/item/cartridge/quartermaster = 10)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/cigarette
	name = "cigarette machine"
	desc = "If you want to get cancer, might as well do it in style!"
	product_slogans = "Space cigs taste good like a cigarette should.;I'd rather toolbox than switch.;Smoke!;Don't believe the reports - smoke today!"
	product_ads = "Probably not bad for you!;Don't believe the scientists!;It's good for you!;Don't quit, buy more!;Smoke!;Nicotine heaven.;Best cigarettes since 2150.;Award-winning cigs.;Feeling temperamental? Try a Temperamento!;Carcinoma Angels - go fuck yerself!;Don't be so hard on yourself, kid. Smoke a Lucky Star!"
	vend_delay = 34
	icon_state = "cigs"
	products = list(/obj/item/storage/fancy/cigarettes = 5,
					/obj/item/storage/fancy/cigarettes/dromedaryco = 5,
					/obj/item/storage/fancy/cigarettes/killthroat = 5,
					/obj/item/storage/fancy/cigarettes/luckystars = 5,
					/obj/item/storage/fancy/cigarettes/jerichos = 5,
					/obj/item/storage/fancy/cigarettes/menthols = 5,
					/obj/item/storage/rollingpapers = 5,
					/obj/item/storage/box/matches = 10,
					/obj/item/flame/lighter/random = 4)
	contraband = list(/obj/item/flame/lighter/zippo = 4)
	premium = list(/obj/item/storage/fancy/cigar = 5,
					/obj/item/storage/fancy/cigarettes/carcinomas = 5,
					/obj/item/storage/fancy/cigarettes/professionals = 5)
	prices = list(/obj/item/storage/fancy/cigarettes = 12,
					/obj/item/storage/fancy/cigarettes/dromedaryco = 15,
					/obj/item/storage/fancy/cigarettes/killthroat = 17,
					/obj/item/storage/fancy/cigarettes/luckystars = 17,
					/obj/item/storage/fancy/cigarettes/jerichos = 22,
					/obj/item/storage/fancy/cigarettes/menthols = 18,
					/obj/item/storage/rollingpapers = 10,
					/obj/item/storage/box/matches = 1,
					/obj/item/flame/lighter/random = 2)

/obj/machinery/vending/medical
	name = "NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_deny = "med-deny"
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?;Ping!"
	req_access = list(access_medical)
	products = list(/obj/item/reagent_containers/glass/bottle/antitoxin = 4,/obj/item/reagent_containers/glass/bottle/inaprovaline = 4,
					/obj/item/reagent_containers/glass/bottle/stoxin = 4,/obj/item/reagent_containers/glass/bottle/toxin = 4,
					/obj/item/reagent_containers/syringe/antiviral = 4,/obj/item/reagent_containers/syringe = 30,
					/obj/item/healthanalyzer = 5,/obj/item/reagent_containers/glass/beaker = 4, /obj/item/reagent_containers/dropper = 2,
					/obj/item/stack/medical/advanced/bruise_pack = 6, /obj/item/stack/medical/advanced/ointment = 6, /obj/item/stack/medical/splint = 4,
					/obj/item/storage/pill_bottle/carbon = 2, /obj/item/storage/pill_bottle = 3)
	contraband = list(/obj/item/reagent_containers/pill/tox = 3,/obj/item/reagent_containers/pill/stox = 4,/obj/item/reagent_containers/pill/antitox = 6)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	req_log_access = access_cmo
	has_logs = 1

/obj/machinery/vending/phoronresearch
	name = "Toximate 3000"
	desc = "All the fine parts you need in one vending machine!"
	products = list(/obj/item/clothing/under/rank/scientist = 6,/obj/item/clothing/suit/bio_suit = 6,/obj/item/clothing/head/bio_hood = 6,
					/obj/item/transfer_valve = 6,/obj/item/assembly/timer = 6,/obj/item/assembly/signaler = 6,
					/obj/item/assembly/prox_sensor = 6,/obj/item/assembly/igniter = 6)
	req_log_access = access_rd
	has_logs = 1

/obj/machinery/vending/wallmed1
	name = "NanoMed"
	desc = "A wall-mounted version of the NanoMed."
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(/obj/item/stack/medical/bruise_pack = 2,/obj/item/stack/medical/ointment = 2,/obj/item/reagent_containers/hypospray/autoinjector = 4,/obj/item/healthanalyzer = 1)
	contraband = list(/obj/item/reagent_containers/syringe/antitoxin = 4,/obj/item/reagent_containers/syringe/antiviral = 4,/obj/item/reagent_containers/pill/tox = 1)
	req_log_access = access_cmo
	has_logs = 1

/obj/machinery/vending/wallmed2
	name = "NanoMed"
	desc = "A wall-mounted version of the NanoMed, containing only vital first aid equipment."
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(/obj/item/reagent_containers/hypospray/autoinjector = 5,/obj/item/reagent_containers/syringe/antitoxin = 3,/obj/item/stack/medical/bruise_pack = 3,
					/obj/item/stack/medical/ointment =3,/obj/item/healthanalyzer = 3)
	contraband = list(/obj/item/reagent_containers/pill/tox = 3)
	req_log_access = access_cmo
	has_logs = 1

/obj/machinery/vending/security
	name = "SecTech"
	desc = "A security equipment vendor."
	product_ads = "Crack capitalist skulls!;Beat some heads in!;Don't forget - harm is good!;Your weapons are right here.;Handcuffs!;Freeze, scumbag!;Don't tase me bro!;Tase them, bro.;Why not have a donut?"
	icon_state = "sec"
	icon_deny = "sec-deny"
	req_access = list(access_security)
	products = list(/obj/item/handcuffs = 8,/obj/item/grenade/flashbang = 4,/obj/item/flash = 5,
					/obj/item/reagent_containers/food/snacks/donut/normal = 12,/obj/item/storage/box/evidence = 6,
					/obj/item/gun/projectile/sec = 2, /obj/item/ammo_magazine/m45/rubber = 6)
	contraband = list(/obj/item/clothing/glasses/sunglasses = 2,/obj/item/storage/box/donut = 2)
	req_log_access = access_armory
	has_logs = 1

/obj/machinery/vending/hydronutrients
	name = "NutriMax"
	desc = "A plant nutrients vendor."
	product_slogans = "Aren't you glad you don't have to fertilize the natural way?;Now with 50% less stink!;Plants are people too!"
	product_ads = "We like plants!;Don't you want some?;The greenest thumbs ever.;We like big plants.;Soft soil..."
	icon_state = "nutri"
	icon_deny = "nutri-deny"
	products = list(/obj/item/reagent_containers/glass/bottle/eznutrient = 6,/obj/item/reagent_containers/glass/bottle/left4zed = 4,/obj/item/reagent_containers/glass/bottle/robustharvest = 3,/obj/item/plantspray/pests = 20,
					/obj/item/reagent_containers/syringe = 5,/obj/item/reagent_containers/glass/beaker = 4,/obj/item/storage/bag/plants = 5)
	premium = list(/obj/item/reagent_containers/glass/bottle/ammonia = 10,/obj/item/reagent_containers/glass/bottle/diethylamine = 5)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/hydroseeds
	name = "MegaSeed Servitor"
	desc = "When you need seeds fast!"
	product_slogans = "THIS'S WHERE TH' SEEDS LIVE! GIT YOU SOME!;Hands down the best seed selection on the station!;Also certain mushroom varieties available, more for experts! Get certified today!"
	product_ads = "We like plants!;Grow some crops!;Grow, baby, growww!;Aw h'yeah son!"
	icon_state = "seeds"

	products = list(/obj/item/seeds/bananaseed = 3,/obj/item/seeds/berryseed = 3,/obj/item/seeds/carrotseed = 3,/obj/item/seeds/chantermycelium = 3,/obj/item/seeds/chiliseed = 3,
					/obj/item/seeds/cornseed = 3, /obj/item/seeds/eggplantseed = 3, /obj/item/seeds/potatoseed = 3, /obj/item/seeds/replicapod = 3,/obj/item/seeds/soyaseed = 3,
					/obj/item/seeds/sunflowerseed = 3,/obj/item/seeds/tomatoseed = 3,/obj/item/seeds/towermycelium = 3,/obj/item/seeds/wheatseed = 3,/obj/item/seeds/appleseed = 3,
					/obj/item/seeds/poppyseed = 3,/obj/item/seeds/sugarcaneseed = 3,/obj/item/seeds/ambrosiavulgarisseed = 3,/obj/item/seeds/peanutseed = 3,/obj/item/seeds/whitebeetseed = 3,/obj/item/seeds/watermelonseed = 3,/obj/item/seeds/lavenderseed = 3,/obj/item/seeds/limeseed = 3,
					/obj/item/seeds/lemonseed = 3,/obj/item/seeds/orangeseed = 3,/obj/item/seeds/grassseed = 3,/obj/item/seeds/cocoapodseed = 3,/obj/item/seeds/plumpmycelium = 2,
					/obj/item/seeds/cabbageseed = 3,/obj/item/seeds/grapeseed = 3,/obj/item/seeds/pumpkinseed = 3,/obj/item/seeds/cherryseed = 3,/obj/item/seeds/plastiseed = 3,/obj/item/seeds/riceseed = 3)
	contraband = list(/obj/item/seeds/amanitamycelium = 2,/obj/item/seeds/glowshroom = 2,/obj/item/seeds/libertymycelium = 2,/obj/item/seeds/mtearseed = 2,
					  /obj/item/seeds/nettleseed = 2,/obj/item/seeds/reishimycelium = 2,/obj/item/seeds/reishimycelium = 2,/obj/item/seeds/shandseed = 2,)
	premium = list(/obj/item/toy/waterflower = 1)

/**
 *  Populate hydroseeds product_records
 *
 *  This needs to be customized to fetch the actual names of the seeds, otherwise
 *  the machine would simply list "packet of seeds" times 20
 */
/obj/machinery/vending/hydroseeds/build_inventory()
	var/list/all_products = list(
		list(products, CAT_NORMAL),
		list(contraband, CAT_HIDDEN),
		list(premium, CAT_COIN))

	for(var/current_list in all_products)
		var/category = current_list[2]

		for(var/entry in current_list[1])
			var/obj/item/seeds/S = new entry(src)
			var/name = S.name
			var/datum/stored_item/vending_product/product = new/datum/stored_item/vending_product(src, entry, name)

			product.price = (entry in prices) ? prices[entry] : 0
			product.amount = (current_list[1][entry]) ? current_list[1][entry] : 1
			product.category = category

			product_records.Add(product)

/obj/machinery/vending/magivend
	name = "MagiVend"
	desc = "A magic vending machine."
	icon_state = "MagiVend"
	product_slogans = "Sling spells the proper way with MagiVend!;Be your own Houdini! Use MagiVend!"
	vend_delay = 15
	vend_reply = "Have an enchanted evening!"
	product_ads = "FJKLFJSD;AJKFLBJAKL;1234 LOONIES LOL!;>MFW;Kill them fuckers!;GET DAT FUKKEN DISK;HONK!;EI NATH;Destroy the station!;Admin conspiracies since forever!;Space-time bending hardware!"
	products = list(/obj/item/clothing/head/wizard = 1,/obj/item/clothing/suit/wizrobe = 1,/obj/item/clothing/head/wizard/red = 1,/obj/item/clothing/suit/wizrobe/red = 1,/obj/item/clothing/shoes/sandal = 1,/obj/item/staff = 2)

/obj/machinery/vending/dinnerware
	name = "Dinnerware"
	desc = "A kitchen and restaurant equipment vendor."
	product_ads = "Mm, food stuffs!;Food and food accessories.;Get your plates!;You like forks?;I like forks.;Woo, utensils.;You don't really need these..."
	icon_state = "dinnerware"
	products = list(
	/obj/item/tray = 8,
	/obj/item/material/kitchen/utensil/fork = 6,
	/obj/item/material/knife = 6,
	/obj/item/material/kitchen/utensil/spoon = 6,
	/obj/item/material/knife = 3,
	/obj/item/material/kitchen/rollingpin = 2,
	/obj/item/reagent_containers/food/drinks/glass2/square = 8,
	/obj/item/reagent_containers/food/drinks/glass2/shake = 8,
	/obj/item/glass_extra/stick = 15,
	/obj/item/glass_extra/straw = 15,
	/obj/item/clothing/suit/chef/classic = 2,
	/obj/item/storage/bag/food = 2,
	/obj/item/storage/toolbox/lunchbox = 3,
	/obj/item/storage/toolbox/lunchbox/heart = 3,
	/obj/item/storage/toolbox/lunchbox/cat = 3,
	/obj/item/storage/toolbox/lunchbox/nt = 3,
	/obj/item/storage/toolbox/lunchbox/mars = 3,
	/obj/item/storage/toolbox/lunchbox/cti = 3,
	/obj/item/storage/toolbox/lunchbox/nymph = 3,
	/obj/item/storage/toolbox/lunchbox/syndicate = 3,
	/obj/item/storage/toolbox/lunchbox/cyancowgirl = 3)
	contraband = list(/obj/item/material/knife/butch = 2)

/obj/machinery/vending/sovietsoda
	name = "BODA"
	desc = "An old sweet water vending machine,how did this end up here?"
	icon_state = "sovietsoda"
	product_ads = "For Tsar and Country.;Have you fulfilled your nutrition quota today?;Very nice!;We are simple people, for this is all we eat.;If there is a person, there is a problem. If there is no person, then there is no problem."
	products = list(/obj/item/reagent_containers/food/drinks/bottle/space_up = 30) // TODO Russian soda can
	contraband = list(/obj/item/reagent_containers/food/drinks/bottle/cola = 20) // TODO Russian cola can
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/tool
	name = "YouTool"
	desc = "Tools for tools."
	icon_state = "tool"
	icon_deny = "tool-deny"
	//req_access = list(access_maint_tunnels) //Maintenance access
	products = list(/obj/item/stack/cable_coil/random = 10,/obj/item/tool/crowbar = 5,/obj/item/weldingtool = 3,/obj/item/tool/wirecutters = 5,
					/obj/item/tool/wrench = 5,/obj/item/analyzer = 5,/obj/item/t_scanner = 5,/obj/item/tool/screwdriver = 5,
					/obj/item/flashlight/glowstick = 3, /obj/item/flashlight/glowstick/red = 3, /obj/item/flashlight/glowstick/blue = 3,
					/obj/item/flashlight/glowstick/orange =3, /obj/item/flashlight/glowstick/yellow = 3)
	contraband = list(/obj/item/weldingtool/hugetank = 2,/obj/item/clothing/gloves/fyellow = 2,)
	premium = list(/obj/item/clothing/gloves/yellow = 1)
	req_log_access = access_ce
	has_logs = 1

/obj/machinery/vending/engivend
	name = "Engi-Vend"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon_state = "engivend"
	icon_deny = "engivend-deny"
	req_access = list(access_engine_equip)
	products = list(/obj/item/geiger = 4,/obj/item/clothing/glasses/meson = 2,/obj/item/multitool = 4,/obj/item/cell/high = 10,
					/obj/item/airlock_electronics = 10,/obj/item/module/power_control = 10,
					/obj/item/circuitboard/airalarm = 10,/obj/item/circuitboard/firealarm = 10,/obj/item/circuitboard/status_display = 2,
					/obj/item/circuitboard/ai_status_display = 2,/obj/item/circuitboard/newscaster = 2,/obj/item/circuitboard/holopad = 2,
					/obj/item/circuitboard/intercom = 4,/obj/item/circuitboard/security/telescreen/entertainment = 4,
					/obj/item/stock_parts/motor = 2,/obj/item/stock_parts/spring = 2,/obj/item/stock_parts/gear = 2,
					/obj/item/circuitboard/atm,/obj/item/circuitboard/guestpass,/obj/item/circuitboard/keycard_auth,
					/obj/item/circuitboard/photocopier,/obj/item/circuitboard/fax,/obj/item/circuitboard/request,
					/obj/item/circuitboard/microwave,/obj/item/circuitboard/washing,/obj/item/circuitboard/scanner_console,
					/obj/item/circuitboard/sleeper_console,/obj/item/circuitboard/body_scanner,/obj/item/circuitboard/sleeper,
					/obj/item/circuitboard/dna_analyzer)
	contraband = list(/obj/item/cell/potato = 3)
	premium = list(/obj/item/storage/belt/utility = 3)
	product_records = list()
	req_log_access = access_ce
	has_logs = 1

/obj/machinery/vending/engineering
	name = "Robco Tool Maker"
	desc = "Everything you need for do-it-yourself station repair."
	icon_state = "engi"
	icon_deny = "engi-deny"
	req_access = list(access_engine_equip)
	products = list(/obj/item/clothing/under/rank/chief_engineer = 4,/obj/item/clothing/under/rank/engineer = 4,/obj/item/clothing/shoes/orange = 4,/obj/item/clothing/head/hardhat = 4,
					/obj/item/storage/belt/utility = 4,/obj/item/clothing/glasses/meson = 4,/obj/item/clothing/gloves/yellow = 4, /obj/item/tool/screwdriver = 12,
					/obj/item/tool/crowbar = 12,/obj/item/tool/wirecutters = 12,/obj/item/multitool = 12,/obj/item/tool/wrench = 12,/obj/item/t_scanner = 12,
					/obj/item/stack/cable_coil/heavyduty = 8, /obj/item/cell = 8, /obj/item/weldingtool = 8,/obj/item/clothing/head/welding = 8,
					/obj/item/light/tube = 10,/obj/item/clothing/suit/fire = 4, /obj/item/stock_parts/scanning_module = 5,/obj/item/stock_parts/micro_laser = 5,
					/obj/item/stock_parts/matter_bin = 5,/obj/item/stock_parts/manipulator = 5,/obj/item/stock_parts/console_screen = 5)
	// There was an incorrect entry (cablecoil/power).  I improvised to cablecoil/heavyduty.
	// Another invalid entry, /obj/item/circuitry.  I don't even know what that would translate to, removed it.
	// The original products list wasn't finished.  The ones without given quantities became quantity 5.  -Sayu
	req_log_access = access_ce
	has_logs = 1

/obj/machinery/vending/robotics
	name = "Robotech Deluxe"
	desc = "All the tools you need to create your own robot army."
	icon_state = "robotics"
	icon_deny = "robotics-deny"
	req_access = list(access_robotics)
	products = list(/obj/item/clothing/suit/storage/toggle/labcoat = 4,/obj/item/clothing/under/rank/roboticist = 4,/obj/item/stack/cable_coil = 4,/obj/item/flash = 4,
					/obj/item/cell/high = 12, /obj/item/assembly/prox_sensor = 3,/obj/item/assembly/signaler = 3,/obj/item/healthanalyzer = 3,
					/obj/item/surgical/scalpel = 2,/obj/item/surgical/circular_saw = 2,/obj/item/tank/anesthetic = 2,/obj/item/clothing/mask/breath/medical = 5,
					/obj/item/tool/screwdriver = 5,/obj/item/tool/crowbar = 5)
	//everything after the power cell had no amounts, I improvised.  -Sayu
	req_log_access = access_rd
	has_logs = 1

/obj/machinery/vending/giftvendor
	name = "AlliCo Baubles and Confectionaries"
	desc = "For that special someone!"
	icon_state = "giftvendor"
	vend_delay = 15
	products = list(/obj/item/storage/fancy/heartbox = 5,
					/obj/item/toy/bouquet = 5,
					/obj/item/toy/bouquet/fake = 4,
					/obj/item/paper/card/smile = 3,
					/obj/item/paper/card/heart = 3,
					/obj/item/paper/card/cat = 3,
					/obj/item/paper/card/flower = 3,
					/obj/item/clothing/accessory/bracelet/friendship = 5,
					/obj/item/toy/plushie/therapy/red = 2,
					/obj/item/toy/plushie/therapy/purple = 2,
					/obj/item/toy/plushie/therapy/blue = 2,
					/obj/item/toy/plushie/therapy/yellow = 2,
					/obj/item/toy/plushie/therapy/orange = 2,
					/obj/item/toy/plushie/therapy/green = 2,
					/obj/item/toy/plushie/nymph = 2,
					/obj/item/toy/plushie/mouse = 2,
					/obj/item/toy/plushie/kitten = 2,
					/obj/item/toy/plushie/lizard = 2,
					/obj/item/toy/plushie/spider = 2,
					/obj/item/toy/plushie/farwa = 2,
					/obj/item/toy/plushie/corgi = 1,
					/obj/item/toy/plushie/octopus = 1,
					/obj/item/toy/plushie/face_hugger = 1,
					/obj/item/toy/plushie/carp = 1,
					/obj/item/toy/plushie/deer = 1,
					/obj/item/toy/plushie/tabby_cat = 1,
					/obj/item/toy/plushie/cyancowgirl = 1,
					/obj/item/toy/plushie/bear_grizzly = 2,
					/obj/item/toy/plushie/bear_polar = 2,
					/obj/item/toy/plushie/bear_panda = 2,
					/obj/item/toy/plushie/bear_soda = 2,
					/obj/item/toy/plushie/bear_bloody = 2,
					/obj/item/toy/plushie/bear_space = 1)
	premium = list(/obj/item/reagent_containers/food/drinks/bottle/champagne = 1,
					/obj/item/storage/trinketbox = 2)
	prices = list(/obj/item/storage/fancy/heartbox = 15,
					/obj/item/toy/bouquet = 10,
					/obj/item/toy/bouquet/fake = 3,
					/obj/item/paper/card/smile = 1,
					/obj/item/paper/card/heart = 1,
					/obj/item/paper/card/cat = 1,
					/obj/item/paper/card/flower = 1,
					/obj/item/clothing/accessory/bracelet/friendship = 5,
					/obj/item/toy/plushie/therapy/red = 20,
					/obj/item/toy/plushie/therapy/purple = 20,
					/obj/item/toy/plushie/therapy/blue = 20,
					/obj/item/toy/plushie/therapy/yellow = 20,
					/obj/item/toy/plushie/therapy/orange = 20,
					/obj/item/toy/plushie/therapy/green = 20,
					/obj/item/toy/plushie/nymph = 35,
					/obj/item/toy/plushie/mouse = 35,
					/obj/item/toy/plushie/kitten = 35,
					/obj/item/toy/plushie/lizard = 35,
					/obj/item/toy/plushie/spider = 35,
					/obj/item/toy/plushie/farwa = 35,
					/obj/item/toy/plushie/corgi = 50,
					/obj/item/toy/plushie/octopus = 50,
					/obj/item/toy/plushie/face_hugger = 50,
					/obj/item/toy/plushie/carp = 50,
					/obj/item/toy/plushie/deer = 50,
					/obj/item/toy/plushie/tabby_cat = 50,
					/obj/item/toy/plushie/cyancowgirl = 50,
					/obj/item/toy/plushie/bear_grizzly = 20,
					/obj/item/toy/plushie/bear_polar = 20,
					/obj/item/toy/plushie/bear_panda = 20,
					/obj/item/toy/plushie/bear_soda = 35,
					/obj/item/toy/plushie/bear_bloody = 35,
					/obj/item/toy/plushie/bear_space = 50)

/obj/machinery/vending/fishing
	name = "Loot Trawler"
	desc = "A special vendor for fishing equipment."
	product_ads = "Tired of trawling across the ocean floor? Get our loot!;Chum and rods.;Don't get baited into fishing without us!;Baby is your star-sign pisces? We'd make a perfect match.;Do not fear, plenty to catch around here.;Don't get reeled in helplessly, get your own rod today!"
	icon_state = "fishvendor"
	products = list(/obj/item/material/fishing_rod/modern/cheap = 10,
					/obj/item/storage/box/wormcan = 20,
					/obj/item/material/fishing_net = 2,
					/obj/item/stack/cable_coil/random = 10)
	prices = list(/obj/item/material/fishing_rod/modern/cheap = 50,
					/obj/item/storage/box/wormcan = 12,
					/obj/item/material/fishing_net = 40,
					/obj/item/stack/cable_coil/random = 4)

//Port of _vr file
//Tweaked existing vendors
/obj/machinery/vending/hydroseeds/Initialize(mapload)
	. = ..()
	products += list(/obj/item/seeds/shrinkshroom = 3,/obj/item/seeds/megashroom = 3)

/obj/machinery/vending/security/Initialize(mapload)
	. = ..()
	products += list(/obj/item/gun/energy/taser = 8,/obj/item/gun/energy/stunrevolver = 4,
					/obj/item/reagent_containers/spray/pepper = 6,/obj/item/barrier_tape_roll/police = 6,
					/obj/item/clothing/glasses/omnihud/sec = 6)

/obj/machinery/vending/tool/Initialize(mapload)
	. = ..()
	products += list(/obj/item/reagent_containers/spray/windowsealant = 5)

/obj/machinery/vending/engivend/Initialize(mapload)
	. = ..()
	products += list(/obj/item/clothing/glasses/omnihud/eng = 6)

/obj/machinery/vending/medical/Initialize(mapload)
	. = ..()
	products += list(/obj/item/storage/box/vmcrystal = 4,/*/obj/item/backup_implanter = 3,*/
					/obj/item/clothing/glasses/omnihud/med = 4, /obj/item/glasses_kit = 1,  /obj/item/storage/quickdraw/syringe_case = 4)

//Custom vendors
/obj/machinery/vending/dinnerware
	name = "Dinnerware"
	desc = "A kitchen and restaurant equipment vendor."
	product_ads = "Mm, food stuffs!;Food and food accessories.;Get your plates!;You like forks?;I like forks.;Woo, utensils.;You don't really need these..."
	icon_state = "dinnerware"
	products = list(
	/obj/item/tray = 8,
	/obj/item/material/kitchen/utensil/fork = 6,
	/obj/item/material/knife/plastic = 6,
	/obj/item/material/kitchen/utensil/spoon = 6,
	/obj/item/material/knife = 3,
	/obj/item/material/kitchen/rollingpin = 2,
	/obj/item/reagent_containers/food/drinks/glass2/square = 8,
	/obj/item/reagent_containers/food/drinks/glass2/shake = 8,
	/obj/item/glass_extra/stick = 15,
	/obj/item/glass_extra/straw = 15,
	/obj/item/clothing/suit/chef/classic = 2,
	/obj/item/storage/toolbox/lunchbox = 3,
	/obj/item/storage/toolbox/lunchbox/heart = 3,
	/obj/item/storage/toolbox/lunchbox/cat = 3,
	/obj/item/storage/toolbox/lunchbox/nt = 3,
	/obj/item/storage/toolbox/lunchbox/mars = 3,
	/obj/item/storage/toolbox/lunchbox/cti = 3,
	/obj/item/storage/toolbox/lunchbox/nymph = 3,
	/obj/item/storage/toolbox/lunchbox/syndicate = 3,
	/obj/item/storage/toolbox/lunchbox/cyancowgirl = 3,
	/obj/item/trash/bowl = 30)
	contraband = list(/obj/item/material/knife/butch = 2)

//I want this not just as part of the zoo. ;v
/obj/machinery/vending/food
	name = "Food-O-Mat"
	desc = "A technological marvel, supposedly able to cook or mix a large variety of food or drink."
	icon_state = "boozeomat"
	icon_deny = "boozeomat-deny"
	products = list(/obj/item/tray = 8,
					/obj/item/material/kitchen/utensil/fork = 6,
					/obj/item/material/knife/plastic = 6,
					/obj/item/material/kitchen/utensil/spoon = 6,
					/obj/item/reagent_containers/food/snacks/tomatosoup = 8,
					/obj/item/reagent_containers/food/snacks/mushroomsoup = 8,
					/obj/item/reagent_containers/food/snacks/jellysandwich = 8,
					/obj/item/reagent_containers/food/snacks/taco = 8,
					/obj/item/reagent_containers/food/snacks/cheeseburger = 8,
					/obj/item/reagent_containers/food/snacks/grilledcheese = 8,
					/obj/item/reagent_containers/food/snacks/hotdog = 8,
					/obj/item/reagent_containers/food/snacks/loadedbakedpotato = 8,
					/obj/item/reagent_containers/food/snacks/omelette = 8,
					/obj/item/reagent_containers/food/snacks/pastatomato = 8,
					/obj/item/reagent_containers/food/snacks/tofuburger = 8,
					/obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza = 2,
					/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza = 2,
					/obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita = 2,
					/obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza = 2,
					/obj/item/reagent_containers/food/snacks/waffles = 4,
					/obj/item/reagent_containers/food/snacks/muffin = 4,
					/obj/item/reagent_containers/food/snacks/appletart = 4,
					/obj/item/reagent_containers/food/snacks/sliceable/applecake = 2,
					/obj/item/reagent_containers/food/snacks/sliceable/bananabread = 2,
					/obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread = 2
					)
	contraband = list(/obj/item/reagent_containers/food/snacks/mysterysoup = 10)
	vend_delay = 15

/obj/machinery/vending/food/arojoan //Fluff vendor for the lewd houseboat.
	name = "Custom Food-O-Mat"
	desc = "Do you think Joan cooks? Of course not. Lazy squirrel!"
	icon_state = "boozeomat"
	icon_deny = "boozeomat-deny"
	products = list(/obj/item/tray = 6,
					/obj/item/material/kitchen/utensil/fork = 6,
					/obj/item/material/knife/plastic = 6,
					/obj/item/material/kitchen/utensil/spoon = 6,
					/obj/item/reagent_containers/food/snacks/hotandsoursoup = 3,
					/obj/item/reagent_containers/food/snacks/kitsuneudon = 3,
					/obj/item/reagent_containers/food/snacks/generalschicken = 3,
					/obj/item/reagent_containers/food/snacks/sliceable/sushi = 2,
					/obj/item/reagent_containers/food/snacks/jellysandwich = 3,
					/obj/item/reagent_containers/food/snacks/grilledcheese = 3,
					/obj/item/reagent_containers/food/snacks/hotdog = 3,
					/obj/item/storage/box/wings = 2,
					/obj/item/reagent_containers/food/snacks/loadedbakedpotato = 3,
					/obj/item/reagent_containers/food/snacks/omelette = 3,
					/obj/item/reagent_containers/food/snacks/waffles = 3,
					/obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza = 1,
					/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza = 1,
					/obj/item/reagent_containers/food/snacks/appletart = 2,
					/obj/item/reagent_containers/food/snacks/sliceable/applecake = 1,
					/obj/item/reagent_containers/food/snacks/sliceable/bananabread = 2,
					/obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread = 2
					)
	contraband = list(/obj/item/reagent_containers/food/snacks/mysterysoup = 10)
	vend_delay = 15
/* For later, then
/obj/machinery/vending/weapon_machine
	name = "Frozen Star Guns&Ammo"
	desc = "A self-defense equipment vending machine. When you need to take care of that clown."
	product_slogans = "The best defense is good offense!;Buy for your whole family today!;Nobody can outsmart bullet!;God created man - Frozen Star made them EQUAL!;Nobody can outsmart bullet!;Stupidity can be cured! By LEAD.;Dead kids can't bully your children!"
	product_ads = "Stunning!;Take justice in your own hands!;LEADearship!"
	icon_state = "weapon"
	products = list(/obj/item/flash = 6,/obj/item/reagent_containers/spray/pepper = 6, /obj/item/gun/projectile/olivaw = 5, /obj/item/gun/projectile/giskard = 5, /obj/item/ammo_magazine/mg/cl32/rubber = 20)
	contraband = list(/obj/item/reagent_containers/food/snacks/syndicake = 6)
	prices = list(/obj/item/flash = 600,/obj/item/reagent_containers/spray/pepper = 800,  /obj/item/gun/projectile/olivaw = 1600, /obj/item/gun/projectile/giskard = 1200, /obj/item/ammo_magazine/mg/cl32/rubber = 200)
*/

/obj/machinery/vending/blood
	name = "Blood-Onator"
	desc = "Freezer-vendor for storage and quick dispensing of blood packs"
	product_ads = "The true life juice!;Vampire's choice!;Home-grown blood only!;Donate today, be saved tomorrow!;Approved by Zeng-Hu Pharmaceuticals Incorporated!; Curse you, Vey-Med artificial blood!"
	icon_state = "blood"
	idle_power_usage = 211
	req_access = list(access_medical)
	products = list(/obj/item/reagent_containers/blood/prelabeled/APlus = 3,/obj/item/reagent_containers/blood/prelabeled/AMinus = 3,
					/obj/item/reagent_containers/blood/prelabeled/BPlus = 3,/obj/item/reagent_containers/blood/prelabeled/BMinus = 3,
					/obj/item/reagent_containers/blood/prelabeled/ABPlus = 2,/obj/item/reagent_containers/blood/prelabeled/ABMinus = 1,
					/obj/item/reagent_containers/blood/prelabeled/OPlus = 2,/obj/item/reagent_containers/blood/prelabeled/OMinus = 5,
					/obj/item/reagent_containers/blood/empty = 5)
	contraband = list(/obj/item/reagent_containers/glass/bottle/stoxin = 2)
	req_log_access = access_cmo
	has_logs = 1

/obj/machinery/vending/loadout
	name = "Fingers and Toes"
	desc = "A special vendor for gloves and shoes!"
	product_ads = "Do you have fingers and toes? COVER THEM UP!;Show me your toes! Wait. NO DON'T! BUY NEW SHOES!;Don't leave prints, BUY SOME GLOVES!;Remember to check your shoes for micros! You don't have to let them out, but just check for them!;Fingers and Toes is not liable for micro entrapment or abuse under the feet of our patrons.!;This little piggy went WE WE WE all the way down to FINGERS AND TOES to pick up some sweet new gloves and shoes."
	icon_state = "glovesnshoes"
	products = list(/obj/item/clothing/gloves/evening = 5,
					/obj/item/clothing/gloves/fingerless = 5,
					/obj/item/clothing/gloves/black = 5,
					/obj/item/clothing/gloves/blue = 5,
					/obj/item/clothing/gloves/brown = 5,
					/obj/item/clothing/gloves/color = 5,
					/obj/item/clothing/gloves/green = 5,
					/obj/item/clothing/gloves/grey = 5,
					/obj/item/clothing/gloves/sterile/latex = 5,
					/obj/item/clothing/gloves/light_brown = 5,
					/obj/item/clothing/gloves/sterile/nitrile = 5,
					/obj/item/clothing/gloves/orange = 5,
					/obj/item/clothing/gloves/purple = 5,
					/obj/item/clothing/gloves/red = 5,
					/obj/item/clothing/gloves/fluff/siren = 5,
					/obj/item/clothing/gloves/white = 5,
					/obj/item/clothing/gloves/duty = 5,
					/obj/item/clothing/shoes/athletic = 5,
					/obj/item/clothing/shoes/boots/fluff/siren = 5,
					/obj/item/clothing/shoes/slippers = 5,
					/obj/item/clothing/shoes/boots/cowboy/classic = 5,
					/obj/item/clothing/shoes/boots/cowboy = 5,
					/obj/item/clothing/shoes/boots/duty = 5,
					/obj/item/clothing/shoes/flats/white/color = 5,
					/obj/item/clothing/shoes/flipflop = 5,
					/obj/item/clothing/shoes/heels = 5,
					/obj/item/clothing/shoes/hitops/black = 5,
					/obj/item/clothing/shoes/hitops/blue = 5,
					/obj/item/clothing/shoes/hitops/green = 5,
					/obj/item/clothing/shoes/hitops/orange = 5,
					/obj/item/clothing/shoes/hitops/purple = 5,
					/obj/item/clothing/shoes/hitops/red = 5,
					/obj/item/clothing/shoes/flats/white/color = 5,
					/obj/item/clothing/shoes/hitops/yellow = 5,
					/obj/item/clothing/shoes/boots/jackboots = 5,
					/obj/item/clothing/shoes/boots/jungle = 5,
					/obj/item/clothing/shoes/black/cuffs = 5,
					/obj/item/clothing/shoes/black/cuffs/blue = 5,
					/obj/item/clothing/shoes/black/cuffs/red = 5,
					/obj/item/clothing/shoes/sandal = 5,
					/obj/item/clothing/shoes/black = 5,
					/obj/item/clothing/shoes/blue = 5,
					/obj/item/clothing/shoes/brown = 5,
					/obj/item/clothing/shoes/laceup = 5,
					/obj/item/clothing/shoes/green = 5,
					/obj/item/clothing/shoes/laceup/brown = 5,
					/obj/item/clothing/shoes/orange = 5,
					/obj/item/clothing/shoes/purple = 5,
					/obj/item/clothing/shoes/red = 5,
					/obj/item/clothing/shoes/white = 5,
					/obj/item/clothing/shoes/yellow = 5,
					/obj/item/clothing/shoes/skater = 5,
					/obj/item/clothing/shoes/boots/cowboy/snakeskin = 5,
					/obj/item/clothing/shoes/boots/jackboots/toeless = 5,
					/obj/item/clothing/shoes/boots/workboots/toeless = 5,
					/obj/item/clothing/shoes/boots/winter = 5,
					/obj/item/clothing/shoes/boots/workboots = 5,
					/obj/item/clothing/shoes/footwraps = 5)
	prices = list(/obj/item/clothing/gloves/evening = 25,
					/obj/item/clothing/gloves/fingerless = 25,
					/obj/item/clothing/gloves/black = 25,
					/obj/item/clothing/gloves/blue = 25,
					/obj/item/clothing/gloves/brown = 25,
					/obj/item/clothing/gloves/color = 25,
					/obj/item/clothing/gloves/green = 25,
					/obj/item/clothing/gloves/grey = 25,
					/obj/item/clothing/gloves/sterile/latex = 25,
					/obj/item/clothing/gloves/light_brown = 25,
					/obj/item/clothing/gloves/sterile/nitrile = 25,
					/obj/item/clothing/gloves/orange = 25,
					/obj/item/clothing/gloves/purple = 25,
					/obj/item/clothing/gloves/red = 25,
					/obj/item/clothing/gloves/fluff/siren = 25,
					/obj/item/clothing/gloves/white = 25,
					/obj/item/clothing/gloves/duty = 25,
					/obj/item/clothing/shoes/athletic = 25,
					/obj/item/clothing/shoes/boots/fluff/siren = 25,
					/obj/item/clothing/shoes/slippers = 25,
					/obj/item/clothing/shoes/boots/cowboy/classic = 25,
					/obj/item/clothing/shoes/boots/cowboy = 25,
					/obj/item/clothing/shoes/boots/duty = 25,
					/obj/item/clothing/shoes/flats/white/color = 25,
					/obj/item/clothing/shoes/flipflop = 25,
					/obj/item/clothing/shoes/heels = 25,
					/obj/item/clothing/shoes/hitops/black = 25,
					/obj/item/clothing/shoes/hitops/blue = 25,
					/obj/item/clothing/shoes/hitops/green = 25,
					/obj/item/clothing/shoes/hitops/orange = 25,
					/obj/item/clothing/shoes/hitops/purple = 25,
					/obj/item/clothing/shoes/hitops/red = 25,
					/obj/item/clothing/shoes/flats/white/color = 25,
					/obj/item/clothing/shoes/hitops/yellow = 25,
					/obj/item/clothing/shoes/boots/jackboots = 25,
					/obj/item/clothing/shoes/boots/jungle = 25,
					/obj/item/clothing/shoes/black/cuffs = 25,
					/obj/item/clothing/shoes/black/cuffs/blue = 25,
					/obj/item/clothing/shoes/black/cuffs/red = 25,
					/obj/item/clothing/shoes/sandal = 25,
					/obj/item/clothing/shoes/black = 25,
					/obj/item/clothing/shoes/blue = 25,
					/obj/item/clothing/shoes/brown = 25,
					/obj/item/clothing/shoes/laceup = 25,
					/obj/item/clothing/shoes/green = 25,
					/obj/item/clothing/shoes/laceup/brown = 25,
					/obj/item/clothing/shoes/orange = 25,
					/obj/item/clothing/shoes/purple = 25,
					/obj/item/clothing/shoes/red = 25,
					/obj/item/clothing/shoes/white = 25,
					/obj/item/clothing/shoes/yellow = 25,
					/obj/item/clothing/shoes/skater = 25,
					/obj/item/clothing/shoes/boots/cowboy/snakeskin = 25,
					/obj/item/clothing/shoes/boots/jackboots/toeless = 25,
					/obj/item/clothing/shoes/boots/workboots/toeless = 25,
					/obj/item/clothing/shoes/boots/winter = 25,
					/obj/item/clothing/shoes/boots/workboots = 25,
					/obj/item/clothing/shoes/footwraps = 25)
	premium = list(/obj/item/clothing/gloves/rainbow = 1,
					/obj/item/clothing/shoes/rainbow = 1,)
	contraband = list(/obj/item/clothing/shoes/syndigaloshes = 1,
					/obj/item/clothing/shoes/clown_shoes = 1)
/obj/machinery/vending/loadout/uniform
	name = "The Basics"
	desc = "A vendor using compressed matter cartridges to store large amounts of basic station uniforms."
	product_ads = "Don't get caught naked!;Pick up your uniform!;Using compressed matter cartridges and VERY ETHICAL labor practices, we bring you the uniforms you need!;No uniform? No problem!;We've got your covered!;The Basics is not responsible for being crushed under the amount of things inside our machines. DO NOT VEND IN EXCESS!!"
	icon_state = "loadout"
	icon_vend = "loadout-purchase"
	vend_delay = 16
	products = list(/obj/item/pda = 25,
					/obj/item/radio/headset = 25,
					/obj/item/storage/backpack/ = 10,
					/obj/item/storage/backpack/messenger = 10,
					/obj/item/storage/backpack/satchel = 10,
					/obj/item/clothing/under/color = 5,
					/obj/item/clothing/under/color/aqua = 5,
					/obj/item/clothing/under/color/black = 5,
					/obj/item/clothing/under/color/blackjumpskirt = 5,
					/obj/item/clothing/under/color/blue = 5,
					/obj/item/clothing/under/color/brown = 5,
					/obj/item/clothing/under/color/green = 5,
					/obj/item/clothing/under/color/grey = 5,
					/obj/item/clothing/under/color/orange = 5,
					/obj/item/clothing/under/color/pink = 5,
					/obj/item/clothing/under/color/red = 5,
					/obj/item/clothing/under/color/white = 5,
					/obj/item/clothing/under/color/yellow = 5,
					/obj/item/clothing/shoes/black = 20,
					/obj/item/clothing/shoes/white = 20)
/obj/machinery/vending/loadout/accessory
	name = "Looty Inc."
	desc = "A special vendor for accessories."
	product_ads = "Want shinies? We have the shinies.;Need that special something to complete your outfit? We have what you need!;Ditch that old dull dangly something you've got and pick up one of our shinies!;Bracelets, collars, scarfs rings and more! We have the fancy things you need!;Does your pet need a collar? We don't judge! Keep them in line with one of one of ours!;Top of the line materials! 'Hand crafted' goods!"
	icon_state = "accessory"
	icon_vend = "accessory-purchase"
	vend_delay = 6
	products = list(/obj/item/clothing/accessory = 5,
					/obj/item/clothing/accessory/armband/med/color = 10,
					/obj/item/clothing/accessory/asymmetric = 5,
					/obj/item/clothing/accessory/asymmetric/purple = 5,
					/obj/item/clothing/accessory/asymmetric/green = 5,
					/obj/item/clothing/accessory/bracelet = 5,
					/obj/item/clothing/accessory/bracelet/material = 5,
					/obj/item/clothing/accessory/bracelet/friendship = 5,
					/obj/item/clothing/accessory/chaps = 5,
					/obj/item/clothing/accessory/chaps/black = 5,
					/obj/item/storage/briefcase/clutch = 1,
					/obj/item/clothing/accessory/collar = 5,
					/obj/item/clothing/accessory/collar/bell = 5,
					/obj/item/clothing/accessory/collar/spike = 5,
					/obj/item/clothing/accessory/collar/pink = 5,
					/obj/item/clothing/accessory/collar/holo = 5,
					/obj/item/clothing/accessory/collar/shock = 5,
					/obj/item/storage/belt/fannypack = 1,
					/obj/item/storage/belt/fannypack/white = 5,
					/obj/item/clothing/accessory/fullcape = 5,
					/obj/item/clothing/accessory/halfcape = 5,
					/obj/item/clothing/accessory/hawaii = 5,
					/obj/item/clothing/accessory/hawaii/random = 5,
					/obj/item/clothing/accessory/locket = 5,
					/obj/item/storage/backpack/purse = 1,
					/obj/item/clothing/accessory/sash = 5,
					/obj/item/clothing/accessory/scarf = 5,
					/obj/item/clothing/accessory/scarf/red = 5,
					/obj/item/clothing/accessory/scarf/darkblue = 5,
					/obj/item/clothing/accessory/scarf/purple = 5,
					/obj/item/clothing/accessory/scarf/yellow = 5,
					/obj/item/clothing/accessory/scarf/orange = 5,
					/obj/item/clothing/accessory/scarf/lightblue = 5,
					/obj/item/clothing/accessory/scarf/white = 5,
					/obj/item/clothing/accessory/scarf/black = 5,
					/obj/item/clothing/accessory/scarf/zebra = 5,
					/obj/item/clothing/accessory/scarf/christmas = 5,
					/obj/item/clothing/accessory/scarf/stripedred = 5,
					/obj/item/clothing/accessory/scarf/stripedgreen = 5,
					/obj/item/clothing/accessory/scarf/stripedblue = 5,
					/obj/item/clothing/accessory/jacket = 5,
					/obj/item/clothing/accessory/jacket/checkered = 5,
					/obj/item/clothing/accessory/jacket/burgundy = 5,
					/obj/item/clothing/accessory/jacket/navy = 5,
					/obj/item/clothing/accessory/jacket/charcoal = 5,
					/obj/item/clothing/accessory/vest = 5,
					/obj/item/clothing/accessory/sweater = 5,
					/obj/item/clothing/accessory/sweater/pink = 5,
					/obj/item/clothing/accessory/sweater/mint = 5,
					/obj/item/clothing/accessory/sweater/blue = 5,
					/obj/item/clothing/accessory/sweater/heart = 5,
					/obj/item/clothing/accessory/sweater/nt = 5,
					/obj/item/clothing/accessory/sweater/keyhole = 5,
					/obj/item/clothing/accessory/sweater/winterneck = 5,
					/obj/item/clothing/accessory/sweater/uglyxmas = 5,
					/obj/item/clothing/accessory/sweater/flowersweater = 5,
					/obj/item/clothing/accessory/sweater/redneck = 5,
					/obj/item/clothing/accessory/tie = 5,
					/obj/item/clothing/accessory/tie/horrible = 5,
					/obj/item/clothing/accessory/tie/white = 5,
					/obj/item/clothing/accessory/tie/navy = 5,
					/obj/item/clothing/accessory/tie/yellow = 5,
					/obj/item/clothing/accessory/tie/darkgreen = 5,
					/obj/item/clothing/accessory/tie/black = 5,
					/obj/item/clothing/accessory/tie/red_long = 5,
					/obj/item/clothing/accessory/tie/red_clip = 5,
					/obj/item/clothing/accessory/tie/blue_long = 5,
					/obj/item/clothing/accessory/tie/blue_clip = 5,
					/obj/item/clothing/accessory/tie/red = 5,
					/obj/item/clothing/accessory/wcoat = 5,
					/obj/item/clothing/accessory/wcoat/red = 5,
					/obj/item/clothing/accessory/wcoat/grey = 5,
					/obj/item/clothing/accessory/wcoat/brown = 5,
					/obj/item/clothing/accessory/wcoat/gentleman = 5,
					/obj/item/clothing/accessory/wcoat/swvest = 5,
					/obj/item/clothing/accessory/wcoat/swvest/blue = 5,
					/obj/item/clothing/accessory/wcoat/swvest/red = 5,
					/obj/item/storage/wallet = 5,
					/obj/item/storage/wallet/poly = 5,
					/obj/item/storage/wallet/womens = 5,
					/obj/item/lipstick = 5,
					/obj/item/lipstick/purple = 5,
					/obj/item/lipstick/jade = 5,
					/obj/item/lipstick/black = 5,
					/obj/item/clothing/ears/earmuffs = 5,
					/obj/item/clothing/ears/earmuffs/headphones = 5,
					/obj/item/clothing/ears/earring/stud = 5,
					/obj/item/clothing/ears/earring/dangle = 5,
					/obj/item/clothing/gloves/ring/mariner = 5,
					/obj/item/clothing/gloves/ring/engagement = 5,
					/obj/item/clothing/gloves/ring/seal/signet = 5,
					/obj/item/clothing/gloves/ring/seal/mason = 5,
					/obj/item/clothing/gloves/ring/material/plastic = 5,
					/obj/item/clothing/gloves/ring/material/steel = 5,
					/obj/item/clothing/gloves/ring/material/gold = 5,
					/obj/item/clothing/glasses/eyepatch = 5,
					/obj/item/clothing/glasses/gglasses = 5,
					/obj/item/clothing/glasses/regular/hipster = 5,
					/obj/item/clothing/glasses/rimless = 5,
					/obj/item/clothing/glasses/thin = 5,
					/obj/item/clothing/glasses/monocle = 5,
					/obj/item/clothing/glasses/goggles = 5,
					/obj/item/clothing/glasses/fluff/spiffygogs = 5,
					/obj/item/clothing/glasses/fakesunglasses = 5,
					/obj/item/clothing/glasses/fakesunglasses/aviator = 5,
					/obj/item/clothing/mask/bandana/blue = 5,
					/obj/item/clothing/mask/bandana/gold = 5,
					/obj/item/clothing/mask/bandana/green = 5,
					/obj/item/clothing/mask/bandana/red = 5,
					/obj/item/clothing/mask/surgical = 5)
	prices = list(/obj/item/clothing/accessory = 25,
					/obj/item/clothing/accessory/armband/med/color = 25,
					/obj/item/clothing/accessory/asymmetric = 25,
					/obj/item/clothing/accessory/asymmetric/purple = 25,
					/obj/item/clothing/accessory/asymmetric/green = 25,
					/obj/item/clothing/accessory/bracelet = 25,
					/obj/item/clothing/accessory/bracelet/material = 25,
					/obj/item/clothing/accessory/bracelet/friendship = 25,
					/obj/item/clothing/accessory/chaps = 25,
					/obj/item/clothing/accessory/chaps/black = 25,
					/obj/item/storage/briefcase/clutch = 25,
					/obj/item/clothing/accessory/collar = 25,
					/obj/item/clothing/accessory/collar/bell = 25,
					/obj/item/clothing/accessory/collar/spike = 25,
					/obj/item/clothing/accessory/collar/pink = 25,
					/obj/item/clothing/accessory/collar/holo = 25,
					/obj/item/clothing/accessory/collar/shock = 25,
					/obj/item/storage/belt/fannypack = 25,
					/obj/item/storage/belt/fannypack/white = 25,
					/obj/item/clothing/accessory/fullcape = 25,
					/obj/item/clothing/accessory/halfcape = 25,
					/obj/item/clothing/accessory/hawaii = 25,
					/obj/item/clothing/accessory/hawaii/random = 25,
					/obj/item/clothing/accessory/locket = 25,
					/obj/item/storage/backpack/purse = 25,
					/obj/item/clothing/accessory/sash = 25,
					/obj/item/clothing/accessory/scarf = 5,
					/obj/item/clothing/accessory/scarf/red = 25,
					/obj/item/clothing/accessory/scarf/darkblue = 25,
					/obj/item/clothing/accessory/scarf/purple = 25,
					/obj/item/clothing/accessory/scarf/yellow = 25,
					/obj/item/clothing/accessory/scarf/orange = 25,
					/obj/item/clothing/accessory/scarf/lightblue = 25,
					/obj/item/clothing/accessory/scarf/white = 25,
					/obj/item/clothing/accessory/scarf/black = 25,
					/obj/item/clothing/accessory/scarf/zebra = 25,
					/obj/item/clothing/accessory/scarf/christmas = 25,
					/obj/item/clothing/accessory/scarf/stripedred = 25,
					/obj/item/clothing/accessory/scarf/stripedgreen = 25,
					/obj/item/clothing/accessory/scarf/stripedblue = 25,
					/obj/item/clothing/accessory/jacket = 25,
					/obj/item/clothing/accessory/jacket/checkered = 25,
					/obj/item/clothing/accessory/jacket/burgundy = 25,
					/obj/item/clothing/accessory/jacket/navy = 25,
					/obj/item/clothing/accessory/jacket/charcoal = 25,
					/obj/item/clothing/accessory/vest = 25,
					/obj/item/clothing/accessory/sweater = 25,
					/obj/item/clothing/accessory/sweater/pink = 25,
					/obj/item/clothing/accessory/sweater/mint = 25,
					/obj/item/clothing/accessory/sweater/blue = 25,
					/obj/item/clothing/accessory/sweater/heart = 25,
					/obj/item/clothing/accessory/sweater/nt = 5,
					/obj/item/clothing/accessory/sweater/keyhole = 25,
					/obj/item/clothing/accessory/sweater/winterneck = 25,
					/obj/item/clothing/accessory/sweater/uglyxmas = 5,
					/obj/item/clothing/accessory/sweater/flowersweater = 25,
					/obj/item/clothing/accessory/sweater/redneck = 25,
					/obj/item/clothing/accessory/tie = 25,
					/obj/item/clothing/accessory/tie/horrible = 25,
					/obj/item/clothing/accessory/tie/white = 25,
					/obj/item/clothing/accessory/tie/navy = 25,
					/obj/item/clothing/accessory/tie/yellow = 25,
					/obj/item/clothing/accessory/tie/darkgreen = 25,
					/obj/item/clothing/accessory/tie/black = 25,
					/obj/item/clothing/accessory/tie/red_long = 25,
					/obj/item/clothing/accessory/tie/red_clip = 25,
					/obj/item/clothing/accessory/tie/blue_long = 25,
					/obj/item/clothing/accessory/tie/blue_clip = 25,
					/obj/item/clothing/accessory/tie/red = 25,
					/obj/item/clothing/accessory/wcoat = 25,
					/obj/item/clothing/accessory/wcoat/red = 25,
					/obj/item/clothing/accessory/wcoat/grey = 25,
					/obj/item/clothing/accessory/wcoat/brown = 25,
					/obj/item/clothing/accessory/wcoat/gentleman = 25,
					/obj/item/clothing/accessory/wcoat/swvest = 25,
					/obj/item/clothing/accessory/wcoat/swvest/blue = 25,
					/obj/item/clothing/accessory/wcoat/swvest/red = 25,
					/obj/item/storage/wallet = 25,
					/obj/item/storage/wallet/poly = 25,
					/obj/item/storage/wallet/womens = 25,
					/obj/item/lipstick = 25,
					/obj/item/lipstick/purple = 25,
					/obj/item/lipstick/jade = 25,
					/obj/item/lipstick/black = 25,
					/obj/item/clothing/ears/earmuffs = 25,
					/obj/item/clothing/ears/earmuffs/headphones = 25,
					/obj/item/clothing/ears/earring/stud = 25,
					/obj/item/clothing/ears/earring/dangle = 25,
					/obj/item/clothing/gloves/ring/mariner = 25,
					/obj/item/clothing/gloves/ring/engagement = 25,
					/obj/item/clothing/gloves/ring/seal/signet = 25,
					/obj/item/clothing/gloves/ring/seal/mason = 25,
					/obj/item/clothing/gloves/ring/material/plastic = 25,
					/obj/item/clothing/gloves/ring/material/steel = 25,
					/obj/item/clothing/gloves/ring/material/gold = 250,
					/obj/item/clothing/glasses/eyepatch = 25,
					/obj/item/clothing/glasses/gglasses = 25,
					/obj/item/clothing/glasses/regular/hipster = 25,
					/obj/item/clothing/glasses/rimless = 25,
					/obj/item/clothing/glasses/thin = 25,
					/obj/item/clothing/glasses/monocle = 25,
					/obj/item/clothing/glasses/goggles = 25,
					/obj/item/clothing/glasses/fluff/spiffygogs = 25,
					/obj/item/clothing/glasses/fakesunglasses = 25,
					/obj/item/clothing/glasses/fakesunglasses/aviator = 25,
					/obj/item/clothing/mask/bandana/blue = 25,
					/obj/item/clothing/mask/bandana/gold = 25,
					/obj/item/clothing/mask/bandana/green = 25,
					/obj/item/clothing/mask/bandana/red = 25,
					/obj/item/clothing/mask/surgical = 25)
	premium = list(/obj/item/bedsheet/rainbow = 1)
	contraband = list(/obj/item/clothing/mask/gas/clown_hat = 1)
/obj/machinery/vending/loadout/clothing
	name = "General Jump"
	desc = "A special vendor using compressed matter cartridges to store large amounts of clothing."
	product_ads = "Tired of your grey jumpsuit? Spruce yourself up!;We have the outfit for you!;Don't let that grey jumpsuit get you down, get a ROBUST outfit right now!;Using compressed matter catridges and VERY ETHICAL labor practices to bring YOU the clothing you crave!;Are you sure you want to go to work in THAT?;All of our wares have a whole TWO pockets!"
	icon_state = "clothing"
	icon_vend = "clothing-purchase"
	vend_delay = 16
	products = list(/obj/item/clothing/under/bathrobe = 5,
					/obj/item/clothing/under/dress/black_corset = 5,
					/obj/item/clothing/under/blazer = 5,
					/obj/item/clothing/under/blazer/skirt = 5,
					/obj/item/clothing/under/cheongsam = 5,
					/obj/item/clothing/under/cheongsam/red = 5,
					/obj/item/clothing/under/cheongsam/blue = 5,
					/obj/item/clothing/under/cheongsam/black = 5,
					/obj/item/clothing/under/cheongsam/darkred = 5,
					/obj/item/clothing/under/cheongsam/green = 5,
					/obj/item/clothing/under/cheongsam/purple = 5,
					/obj/item/clothing/under/cheongsam/darkblue = 5,
					/obj/item/clothing/under/croptop = 5,
					/obj/item/clothing/under/croptop/red = 5,
					/obj/item/clothing/under/croptop/grey = 5,
					/obj/item/clothing/under/cuttop = 5,
					/obj/item/clothing/under/cuttop/red = 5,
					/obj/item/clothing/under/suit_jacket/female/skirt = 5,
					/obj/item/clothing/under/dress/dress_fire = 5,
					/obj/item/clothing/under/dress/flamenco = 5,
					/obj/item/clothing/under/dress/flower_dress = 5,
					/obj/item/clothing/under/fluff/gnshorts = 5,
					/obj/item/clothing/under/color = 5,
					/obj/item/clothing/under/color/aqua = 5,
					/obj/item/clothing/under/color/black = 5,
					/obj/item/clothing/under/color/blackf = 5,
					/obj/item/clothing/under/color/blackjumpskirt = 5,
					/obj/item/clothing/under/color/blue = 5,
					/obj/item/clothing/under/color/brown = 5,
					/obj/item/clothing/under/color/darkblue = 5,
					/obj/item/clothing/under/color/darkred = 5,
					/obj/item/clothing/under/color/green = 5,
					/obj/item/clothing/under/color/grey = 5,
					/obj/item/clothing/under/color/lightblue = 5,
					/obj/item/clothing/under/color/lightbrown = 5,
					/obj/item/clothing/under/color/lightgreen = 5,
					/obj/item/clothing/under/color/lightpurple = 5,
					/obj/item/clothing/under/color/lightred = 5,
					/obj/item/clothing/under/color/orange = 5,
					/obj/item/clothing/under/color/pink = 5,
					/obj/item/clothing/under/color/prison = 5,
					/obj/item/clothing/under/color/ranger = 5,
					/obj/item/clothing/under/color/red = 5,
					/obj/item/clothing/under/color/white = 5,
					/obj/item/clothing/under/color/yellow = 5,
					/obj/item/clothing/under/color/yellowgreen = 5,
					/obj/item/clothing/under/aether = 5,
					/obj/item/clothing/under/focal = 5,
					/obj/item/clothing/under/hephaestus = 5,
					/obj/item/clothing/under/wardt = 5,
					/obj/item/clothing/under/kilt = 5,
					/obj/item/clothing/under/fluff/latexmaid = 5,
					/obj/item/clothing/under/dress/lilacdress = 5,
					/obj/item/clothing/under/dress/white2 = 5,
					/obj/item/clothing/under/dress/white4 = 5,
					/obj/item/clothing/under/dress/maid = 5,
					/obj/item/clothing/under/dress/maid/sexy = 5,
					/obj/item/clothing/under/dress/maid/janitor = 5,
					/obj/item/clothing/under/kamishimo = 5,
					/obj/item/clothing/under/kimono = 5,
					/obj/item/clothing/under/kimono_black = 5,
					/obj/item/clothing/under/kimono_sakura = 5,
					/obj/item/clothing/under/kimono_fancy = 5,
					/obj/item/clothing/under/kimono/red = 5,
					/obj/item/clothing/under/kimono/orange = 5,
					/obj/item/clothing/under/kimono/yellow = 5,
					/obj/item/clothing/under/kimono/green = 5,
					/obj/item/clothing/under/kimono/blue = 5,
					/obj/item/clothing/under/kimono/purple = 5,
					/obj/item/clothing/under/kimono/violet = 5,
					/obj/item/clothing/under/kimono/pink = 5,
					/obj/item/clothing/under/kimono/earth = 5,
					/obj/item/clothing/under/cheong = 5,
					/obj/item/clothing/under/cheong/white = 5,
					/obj/item/clothing/under/cheong/red = 5,
					/obj/item/clothing/under/qipao = 5,
					/obj/item/clothing/under/qipao/white = 5,
					/obj/item/clothing/under/qipao/red = 5,
					/obj/item/clothing/under/moderncoat = 5,
					/obj/item/clothing/under/permit = 5,
					/obj/item/clothing/under/oldwoman = 5,
					/obj/item/clothing/under/frontier = 5,
					/obj/item/clothing/under/mbill = 5,
					/obj/item/clothing/under/pants/baggy/ = 5,
					/obj/item/clothing/under/pants/baggy/classicjeans = 5,
					/obj/item/clothing/under/pants/baggy/mustangjeans = 5,
					/obj/item/clothing/under/pants/baggy/blackjeans = 5,
					/obj/item/clothing/under/pants/baggy/greyjeans = 5,
					/obj/item/clothing/under/pants/baggy/youngfolksjeans = 5,
					/obj/item/clothing/under/pants/baggy/white = 5,
					/obj/item/clothing/under/pants/baggy/red = 5,
					/obj/item/clothing/under/pants/baggy/black = 5,
					/obj/item/clothing/under/pants/baggy/tan = 5,
					/obj/item/clothing/under/pants/baggy/track = 5,
					/obj/item/clothing/under/pants/baggy/khaki = 5,
					/obj/item/clothing/under/pants/baggy/camo = 5,
					/obj/item/clothing/under/pants/utility/ = 5,
					/obj/item/clothing/under/pants/utility/orange = 5,
					/obj/item/clothing/under/pants/utility/blue = 5,
					/obj/item/clothing/under/pants/utility/white = 5,
					/obj/item/clothing/under/pants/utility/red = 5,
					/obj/item/clothing/under/pants/chaps = 5,
					/obj/item/clothing/under/pants/chaps/black = 5,
					/obj/item/clothing/under/pants/track = 5,
					/obj/item/clothing/under/pants/track/red = 5,
					/obj/item/clothing/under/pants/track/white = 5,
					/obj/item/clothing/under/pants/track/green = 5,
					/obj/item/clothing/under/pants/track/blue = 5,
					/obj/item/clothing/under/pants/yogapants = 5,
					/obj/item/clothing/under/ascetic = 5,
					/obj/item/clothing/under/dress/white3 = 5,
					/obj/item/clothing/under/skirt/pleated = 5,
					/obj/item/clothing/under/dress/darkred = 5,
					/obj/item/clothing/under/dress/redeveninggown = 5,
					/obj/item/clothing/under/dress/red_swept_dress = 5,
					/obj/item/clothing/under/dress/sailordress = 5,
					/obj/item/clothing/under/dress/sari = 5,
					/obj/item/clothing/under/dress/sari/green = 5,
					/obj/item/clothing/under/shorts/red = 5,
					/obj/item/clothing/under/shorts/green = 5,
					/obj/item/clothing/under/shorts/blue = 5,
					/obj/item/clothing/under/shorts/black = 5,
					/obj/item/clothing/under/shorts/grey = 5,
					/obj/item/clothing/under/shorts/white = 5,
					/obj/item/clothing/under/shorts/jeans = 5,
					/obj/item/clothing/under/shorts/jeans/ = 5,
					/obj/item/clothing/under/shorts/jeans/classic = 5,
					/obj/item/clothing/under/shorts/jeans/mustang = 5,
					/obj/item/clothing/under/shorts/jeans/youngfolks = 5,
					/obj/item/clothing/under/shorts/jeans/black = 5,
					/obj/item/clothing/under/shorts/jeans/grey = 5,
					/obj/item/clothing/under/shorts/khaki/ = 5,
					/obj/item/clothing/under/skirt/loincloth = 5,
					/obj/item/clothing/under/skirt/khaki = 5,
					/obj/item/clothing/under/skirt/blue = 5,
					/obj/item/clothing/under/skirt/red = 5,
					/obj/item/clothing/under/skirt/denim = 5,
					/obj/item/clothing/under/skirt/pleated = 5,
					/obj/item/clothing/under/skirt/outfit/plaid_blue = 5,
					/obj/item/clothing/under/skirt/outfit/plaid_red = 5,
					/obj/item/clothing/under/skirt/outfit/plaid_purple = 5,
					/obj/item/clothing/under/skirt/outfit/plaid_green = 5,
					/obj/item/clothing/under/overalls/sleek = 5,
					/obj/item/clothing/under/sl_suit = 5,
					/obj/item/clothing/under/gentlesuit = 5,
					/obj/item/clothing/under/gentlesuit/skirt = 5,
					/obj/item/clothing/under/suit_jacket = 5,
					/obj/item/clothing/under/suit_jacket/really_black/skirt = 5,
					/obj/item/clothing/under/suit_jacket/really_black = 5,
					/obj/item/clothing/under/suit_jacket/female/skirt = 5,
					/obj/item/clothing/under/suit_jacket/female/ = 5,
					/obj/item/clothing/under/suit_jacket/red = 5,
					/obj/item/clothing/under/suit_jacket/red/skirt = 5,
					/obj/item/clothing/under/suit_jacket/charcoal = 5,
					/obj/item/clothing/under/suit_jacket/charcoal/skirt = 5,
					/obj/item/clothing/under/suit_jacket/navy = 5,
					/obj/item/clothing/under/suit_jacket/navy/skirt = 5,
					/obj/item/clothing/under/suit_jacket/burgundy = 5,
					/obj/item/clothing/under/suit_jacket/burgundy/skirt = 5,
					/obj/item/clothing/under/suit_jacket/checkered = 5,
					/obj/item/clothing/under/suit_jacket/checkered/skirt = 5,
					/obj/item/clothing/under/suit_jacket/tan = 5,
					/obj/item/clothing/under/suit_jacket/tan/skirt = 5,
					/obj/item/clothing/under/scratch = 5,
					/obj/item/clothing/under/scratch/skirt = 5,
					/obj/item/clothing/under/sundress = 5,
					/obj/item/clothing/under/sundress_white = 5,
					/obj/item/clothing/under/turtlebaggy = 5,
					/obj/item/clothing/under/turtlebaggy/purple = 5,
					/obj/item/clothing/under/turtlebaggy/red = 5,
					/obj/item/clothing/under/turtlebaggy/blue = 5,
					/obj/item/clothing/under/turtlebaggy/green = 5,
					/obj/item/clothing/under/turtlebaggy/black = 5,
					/obj/item/clothing/under/rank/psych/turtleneck/sweater = 5,
					/obj/item/storage/box/fluff/swimsuit = 5,
					/obj/item/storage/box/fluff/swimsuit/blue = 5,
					/obj/item/storage/box/fluff/swimsuit/purple = 5,
					/obj/item/storage/box/fluff/swimsuit/green = 5,
					/obj/item/storage/box/fluff/swimsuit/red = 5,
					/obj/item/storage/box/fluff/swimsuit/white = 5,
					/obj/item/storage/box/fluff/swimsuit/earth = 5,
					/obj/item/storage/box/fluff/swimsuit/engineering = 5,
					/obj/item/storage/box/fluff/swimsuit/science = 5,
					/obj/item/storage/box/fluff/swimsuit/security = 5,
					/obj/item/storage/box/fluff/swimsuit/medical = 5,
					/obj/item/storage/box/fluff/swimsuit/cowbikini = 5,
					/obj/item/storage/box/fluff/swimsuit/captain = 5,
					/obj/item/clothing/under/utility = 5,
					/obj/item/clothing/under/utility/grey = 5,
					/obj/item/clothing/under/utility/blue = 5,
					/obj/item/clothing/under/fluff/v_nanovest = 5,
					/obj/item/clothing/under/dress/westernbustle = 5,
					/obj/item/clothing/under/wedding/bride_white = 5,
					/obj/item/clothing/under/redcoatformal = 2,
					/obj/item/clothing/under/leotardcolor = 5,
					/obj/item/clothing/under/leotard = 5,
					/obj/item/storage/backpack/ = 5,
					/obj/item/storage/backpack/messenger = 5,
					/obj/item/storage/backpack/satchel = 5)
	prices = list(/obj/item/clothing/under/bathrobe = 25,
					/obj/item/clothing/under/dress/black_corset = 25,
					/obj/item/clothing/under/blazer = 25,
					/obj/item/clothing/under/blazer/skirt = 25,
					/obj/item/clothing/under/cheongsam = 25,
					/obj/item/clothing/under/cheongsam/red = 25,
					/obj/item/clothing/under/cheongsam/blue = 25,
					/obj/item/clothing/under/cheongsam/black = 25,
					/obj/item/clothing/under/cheongsam/darkred = 25,
					/obj/item/clothing/under/cheongsam/green = 25,
					/obj/item/clothing/under/cheongsam/purple = 25,
					/obj/item/clothing/under/cheongsam/darkblue = 25,
					/obj/item/clothing/under/croptop = 25,
					/obj/item/clothing/under/croptop/red = 25,
					/obj/item/clothing/under/croptop/grey = 25,
					/obj/item/clothing/under/cuttop = 25,
					/obj/item/clothing/under/cuttop/red = 25,
					/obj/item/clothing/under/suit_jacket/female/skirt = 25,
					/obj/item/clothing/under/dress/dress_fire = 25,
					/obj/item/clothing/under/dress/flamenco = 25,
					/obj/item/clothing/under/dress/flower_dress = 25,
					/obj/item/clothing/under/fluff/gnshorts = 25,
					/obj/item/clothing/under/color = 25,
					/obj/item/clothing/under/color/aqua = 25,
					/obj/item/clothing/under/color/black = 25,
					/obj/item/clothing/under/color/blackf = 25,
					/obj/item/clothing/under/color/blackjumpskirt = 25,
					/obj/item/clothing/under/color/blue = 25,
					/obj/item/clothing/under/color/brown = 25,
					/obj/item/clothing/under/color/darkblue = 25,
					/obj/item/clothing/under/color/darkred = 25,
					/obj/item/clothing/under/color/green = 25,
					/obj/item/clothing/under/color/grey = 25,
					/obj/item/clothing/under/color/lightblue = 25,
					/obj/item/clothing/under/color/lightbrown = 25,
					/obj/item/clothing/under/color/lightgreen = 25,
					/obj/item/clothing/under/color/lightpurple = 25,
					/obj/item/clothing/under/color/lightred = 25,
					/obj/item/clothing/under/color/orange = 25,
					/obj/item/clothing/under/color/pink = 25,
					/obj/item/clothing/under/color/prison = 25,
					/obj/item/clothing/under/color/ranger = 25,
					/obj/item/clothing/under/color/red = 25,
					/obj/item/clothing/under/color/white = 25,
					/obj/item/clothing/under/color/yellow = 25,
					/obj/item/clothing/under/color/yellowgreen = 25,
					/obj/item/clothing/under/aether = 25,
					/obj/item/clothing/under/focal = 25,
					/obj/item/clothing/under/hephaestus = 25,
					/obj/item/clothing/under/wardt = 25,
					/obj/item/clothing/under/kilt = 25,
					/obj/item/clothing/under/fluff/latexmaid = 25,
					/obj/item/clothing/under/dress/lilacdress = 25,
					/obj/item/clothing/under/dress/white2 = 25,
					/obj/item/clothing/under/dress/white4 = 25,
					/obj/item/clothing/under/dress/maid = 25,
					/obj/item/clothing/under/dress/maid/sexy = 25,
					/obj/item/clothing/under/dress/maid/janitor = 25,
					/obj/item/clothing/under/kamishimo = 25,
					/obj/item/clothing/under/kimono = 25,
					/obj/item/clothing/under/kimono_black = 25,
					/obj/item/clothing/under/kimono_sakura = 25,
					/obj/item/clothing/under/kimono_fancy = 25,
					/obj/item/clothing/under/kimono/red = 25,
					/obj/item/clothing/under/kimono/orange = 25,
					/obj/item/clothing/under/kimono/yellow = 25,
					/obj/item/clothing/under/kimono/green = 25,
					/obj/item/clothing/under/kimono/blue = 25,
					/obj/item/clothing/under/kimono/purple = 25,
					/obj/item/clothing/under/kimono/violet = 25,
					/obj/item/clothing/under/kimono/pink = 25,
					/obj/item/clothing/under/kimono/earth = 25,
					/obj/item/clothing/under/cheong = 25,
					/obj/item/clothing/under/cheong/white = 25,
					/obj/item/clothing/under/cheong/red = 25,
					/obj/item/clothing/under/qipao = 25,
					/obj/item/clothing/under/qipao/white = 25,
					/obj/item/clothing/under/qipao/red = 25,
					/obj/item/clothing/under/moderncoat = 25,
					/obj/item/clothing/under/permit = 25,
					/obj/item/clothing/under/oldwoman = 25,
					/obj/item/clothing/under/frontier = 25,
					/obj/item/clothing/under/mbill = 25,
					/obj/item/clothing/under/pants/baggy/ = 25,
					/obj/item/clothing/under/pants/baggy/classicjeans = 25,
					/obj/item/clothing/under/pants/baggy/mustangjeans = 25,
					/obj/item/clothing/under/pants/baggy/blackjeans = 25,
					/obj/item/clothing/under/pants/baggy/greyjeans = 25,
					/obj/item/clothing/under/pants/baggy/youngfolksjeans = 25,
					/obj/item/clothing/under/pants/baggy/white = 25,
					/obj/item/clothing/under/pants/baggy/red = 25,
					/obj/item/clothing/under/pants/baggy/black = 25,
					/obj/item/clothing/under/pants/baggy/tan = 25,
					/obj/item/clothing/under/pants/baggy/track = 25,
					/obj/item/clothing/under/pants/baggy/khaki = 25,
					/obj/item/clothing/under/pants/baggy/camo = 25,
					/obj/item/clothing/under/pants/utility/ = 25,
					/obj/item/clothing/under/pants/utility/orange = 25,
					/obj/item/clothing/under/pants/utility/blue = 25,
					/obj/item/clothing/under/pants/utility/white = 25,
					/obj/item/clothing/under/pants/utility/red = 25,
					/obj/item/clothing/under/pants/chaps = 25,
					/obj/item/clothing/under/pants/chaps/black = 25,
					/obj/item/clothing/under/pants/track = 25,
					/obj/item/clothing/under/pants/track/red = 25,
					/obj/item/clothing/under/pants/track/white = 25,
					/obj/item/clothing/under/pants/track/green = 25,
					/obj/item/clothing/under/pants/track/blue = 25,
					/obj/item/clothing/under/pants/yogapants = 25,
					/obj/item/clothing/under/ascetic = 25,
					/obj/item/clothing/under/dress/white3 = 25,
					/obj/item/clothing/under/skirt/pleated = 25,
					/obj/item/clothing/under/dress/darkred = 25,
					/obj/item/clothing/under/dress/redeveninggown = 25,
					/obj/item/clothing/under/dress/red_swept_dress = 25,
					/obj/item/clothing/under/dress/sailordress = 25,
					/obj/item/clothing/under/dress/sari = 25,
					/obj/item/clothing/under/dress/sari/green = 25,
					/obj/item/clothing/under/shorts/red = 25,
					/obj/item/clothing/under/shorts/green = 25,
					/obj/item/clothing/under/shorts/blue = 25,
					/obj/item/clothing/under/shorts/black = 25,
					/obj/item/clothing/under/shorts/grey = 25,
					/obj/item/clothing/under/shorts/white = 25,
					/obj/item/clothing/under/shorts/jeans = 25,
					/obj/item/clothing/under/shorts/jeans/ = 25,
					/obj/item/clothing/under/shorts/jeans/classic = 25,
					/obj/item/clothing/under/shorts/jeans/mustang = 25,
					/obj/item/clothing/under/shorts/jeans/youngfolks = 25,
					/obj/item/clothing/under/shorts/jeans/black = 25,
					/obj/item/clothing/under/shorts/jeans/grey = 25,
					/obj/item/clothing/under/shorts/khaki/ = 25,
					/obj/item/clothing/under/skirt/loincloth = 25,
					/obj/item/clothing/under/skirt/khaki = 25,
					/obj/item/clothing/under/skirt/blue = 25,
					/obj/item/clothing/under/skirt/red = 25,
					/obj/item/clothing/under/skirt/denim = 25,
					/obj/item/clothing/under/skirt/pleated = 25,
					/obj/item/clothing/under/skirt/outfit/plaid_blue = 25,
					/obj/item/clothing/under/skirt/outfit/plaid_red = 25,
					/obj/item/clothing/under/skirt/outfit/plaid_purple = 25,
					/obj/item/clothing/under/skirt/outfit/plaid_green = 25,
					/obj/item/clothing/under/overalls/sleek = 25,
					/obj/item/clothing/under/sl_suit = 25,
					/obj/item/clothing/under/gentlesuit = 25,
					/obj/item/clothing/under/gentlesuit/skirt = 25,
					/obj/item/clothing/under/suit_jacket = 25,
					/obj/item/clothing/under/suit_jacket/really_black/skirt = 25,
					/obj/item/clothing/under/suit_jacket/really_black = 25,
					/obj/item/clothing/under/suit_jacket/female/skirt = 25,
					/obj/item/clothing/under/suit_jacket/female/ = 25,
					/obj/item/clothing/under/suit_jacket/red = 25,
					/obj/item/clothing/under/suit_jacket/red/skirt = 25,
					/obj/item/clothing/under/suit_jacket/charcoal = 25,
					/obj/item/clothing/under/suit_jacket/charcoal/skirt = 25,
					/obj/item/clothing/under/suit_jacket/navy = 25,
					/obj/item/clothing/under/suit_jacket/navy/skirt = 25,
					/obj/item/clothing/under/suit_jacket/burgundy = 25,
					/obj/item/clothing/under/suit_jacket/burgundy/skirt = 25,
					/obj/item/clothing/under/suit_jacket/checkered = 25,
					/obj/item/clothing/under/suit_jacket/checkered/skirt = 25,
					/obj/item/clothing/under/suit_jacket/tan = 25,
					/obj/item/clothing/under/suit_jacket/tan/skirt = 25,
					/obj/item/clothing/under/scratch = 25,
					/obj/item/clothing/under/scratch/skirt = 25,
					/obj/item/clothing/under/sundress = 25,
					/obj/item/clothing/under/sundress_white = 25,
					/obj/item/clothing/under/turtlebaggy = 25,
					/obj/item/clothing/under/turtlebaggy/purple = 25,
					/obj/item/clothing/under/turtlebaggy/red = 25,
					/obj/item/clothing/under/turtlebaggy/blue = 25,
					/obj/item/clothing/under/turtlebaggy/green = 25,
					/obj/item/clothing/under/turtlebaggy/black = 25,
					/obj/item/clothing/under/rank/psych/turtleneck/sweater = 25,
					/obj/item/storage/box/fluff/swimsuit = 25,
					/obj/item/storage/box/fluff/swimsuit/blue = 25,
					/obj/item/storage/box/fluff/swimsuit/purple = 25,
					/obj/item/storage/box/fluff/swimsuit/green = 25,
					/obj/item/storage/box/fluff/swimsuit/red = 25,
					/obj/item/storage/box/fluff/swimsuit/white = 25,
					/obj/item/storage/box/fluff/swimsuit/earth = 25,
					/obj/item/storage/box/fluff/swimsuit/engineering = 25,
					/obj/item/storage/box/fluff/swimsuit/science = 25,
					/obj/item/storage/box/fluff/swimsuit/security = 25,
					/obj/item/storage/box/fluff/swimsuit/medical = 25,
					/obj/item/storage/box/fluff/swimsuit/cowbikini = 25,
					/obj/item/storage/box/fluff/swimsuit/captain = 25,
					/obj/item/clothing/under/utility = 25,
					/obj/item/clothing/under/utility/grey = 25,
					/obj/item/clothing/under/utility/blue = 25,
					/obj/item/clothing/under/fluff/v_nanovest = 25,
					/obj/item/clothing/under/dress/westernbustle = 25,
					/obj/item/clothing/under/wedding/bride_white = 25,
					/obj/item/clothing/under/redcoatformal = 75,
					/obj/item/clothing/under/leotardcolor = 25,
					/obj/item/clothing/under/leotard = 25,
					/obj/item/storage/backpack/ = 25,
					/obj/item/storage/backpack/messenger = 25,
					/obj/item/storage/backpack/satchel = 25)
	premium = list(/obj/item/clothing/under/color/rainbow = 1)
	contraband = list(/obj/item/clothing/under/rank/clown = 1)
/obj/machinery/vending/loadout/gadget
	name = "Chips Co."
	desc = "A special vendor for devices and gadgets."
	product_ads = "You can't RESIST our great deals!;Feeling disconnected? We have a gadget for you!;You know you have the capacity to buy our capacitors!;FILL THAT HOLE IN YOUR HEART WITH OUR PLASTIC DISTRACTIONS!!!;Devices for everyone! Chips Co.!;ROBUST INVENTORY, GREAT PRICES! ;DON'T FORGET THE oyPAD 13s PRO! ON SALE NOW, ONLY ONE THOUSAND THALERS!"
	icon_state = "gadgets"
	icon_vend = "gadgets-purchase"
	vend_delay = 11
	products = list(/obj/item/clothing/suit/circuitry = 1,
					/obj/item/clothing/head/circuitry = 1,
					/obj/item/clothing/shoes/circuitry = 1,
					/obj/item/clothing/gloves/circuitry = 1,
					/obj/item/clothing/under/circuitry = 1,
					/obj/item/clothing/glasses/circuitry = 1,
					/obj/item/clothing/ears/circuitry = 1,
					/obj/item/text_to_speech = 5,
					/obj/item/paicard = 5,
					/obj/item/communicator = 10,
					/obj/item/communicator/watch = 10,
					/obj/item/radio = 10,
					/obj/item/camera = 5,
					/obj/item/tape_recorder = 5,
					/obj/item/modular_computer/tablet/preset/custom_loadout/cheap = 5,
					/obj/item/pda = 10,
					/obj/item/radio/headset = 10,
					/obj/item/flashlight = 5,
					/obj/item/laser_pointer = 3,
					/obj/item/clothing/glasses/omnihud = 10)
	prices = list(/obj/item/clothing/suit/circuitry = 100,
					/obj/item/clothing/head/circuitry = 100,
					/obj/item/clothing/shoes/circuitry = 100,
					/obj/item/clothing/gloves/circuitry = 100,
					/obj/item/clothing/under/circuitry = 100,
					/obj/item/clothing/glasses/circuitry = 100,
					/obj/item/clothing/ears/circuitry = 100,
					/obj/item/text_to_speech = 300,
					/obj/item/paicard = 100,
					/obj/item/communicator = 100,
					/obj/item/communicator/watch = 100,
					/obj/item/radio = 100,
					/obj/item/camera = 100,
					/obj/item/tape_recorder = 100,
					/obj/item/modular_computer/tablet/preset/custom_loadout/cheap = 1000,
					/obj/item/pda = 25,
					/obj/item/radio/headset = 25,
					/obj/item/flashlight = 100,
					/obj/item/laser_pointer = 200,
					/obj/item/clothing/glasses/omnihud = 100)
	premium = list(/obj/item/perfect_tele/one_beacon = 1)
	contraband = list(/obj/item/disk/nifsoft/compliance = 1)
/obj/machinery/vending/loadout/loadout_misc
	name = "Bits and Bobs"
	desc = "A special vendor for things and also stuff!"
	product_ads = "You never know when you might need an umbrella.;Hey kid... want some cardemon cards?;Miscellaneous for your miscellaneous heart.;Who's bob? Wouldn't you like to know.;I'm sorry there's no grappling hooks in our umbrellas.;We sell things AND stuff."
	icon_state = "loadout_misc"
	products = list(/obj/item/cane = 5,
					/obj/item/pack/cardemon = 25,
					/obj/item/deck/holder = 5,
					/obj/item/deck/cah = 5,
					/obj/item/deck/cah/black = 5,
					/obj/item/deck/tarot = 5,
					/obj/item/deck/cards = 5,
					/obj/item/pack/spaceball = 10,
					/obj/item/storage/pill_bottle/dice = 5,
					/obj/item/storage/pill_bottle/dice_nerd = 5,
					/obj/item/melee/umbrella/random = 10,
					/obj/item/deck/unus = 5)
	prices = list(/obj/item/cane = 100,
					/obj/item/pack/cardemon = 100,
					/obj/item/deck/holder = 100,
					/obj/item/deck/cah = 100,
					/obj/item/deck/cah/black = 100,
					/obj/item/deck/tarot = 100,
					/obj/item/deck/cards = 100,
					/obj/item/pack/spaceball = 100,
					/obj/item/storage/pill_bottle/dice = 100,
					/obj/item/storage/pill_bottle/dice_nerd = 100,
					/obj/item/melee/umbrella/random = 100,
					/obj/item/deck/unus = 100)
	premium = list(/obj/item/toy/bosunwhistle = 1)
	contraband = list(/obj/item/toy/katana = 1)
/obj/machinery/vending/loadout/overwear
	name = "Big D's Best"
	desc = "A special vendor using compressed matter cartridges to store large amounts of overwear!"
	product_ads = "Dress your best! It's what big D would want.;Overwear for all occasions!;Big D has what you need if what you need is some form of jacket!;Need a new hoodie? Bid D has you covered.;Big D says you need a new suit!;Big D smiles when he sees you in one of his coats!"
	icon_state = "suit"
	icon_vend = "suit-purchase"
	vend_delay = 16
	products = list(/obj/item/clothing/suit/storage/apron = 5,
					/obj/item/clothing/suit/storage/flannel/aqua = 5,
					/obj/item/clothing/suit/storage/toggle/bomber = 5,
					/obj/item/clothing/suit/storage/bomber/alt = 5,
					/obj/item/clothing/suit/storage/flannel/brown = 5,
					/obj/item/clothing/suit/storage/toggle/cardigan = 5,
					/obj/item/clothing/accessory/poncho/roles/cloak/custom = 5,
					/obj/item/clothing/suit/storage/duster = 5,
					/obj/item/clothing/suit/storage/toggle/denim_jacket = 5,
					/obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen = 5,
					/obj/item/clothing/suit/storage/toggle/denim_jacket/sleeveless = 5,
					/obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen/sleeveless = 5,
					/obj/item/clothing/suit/storage/fluff/gntop = 5,
					/obj/item/clothing/suit/greatcoat = 5,
					/obj/item/clothing/suit/storage/flannel = 5,
					/obj/item/clothing/suit/storage/greyjacket = 5,
					/obj/item/clothing/suit/storage/hazardvest = 5,
					/obj/item/clothing/suit/storage/toggle/hoodie/black = 5,
					/obj/item/clothing/suit/storage/toggle/hoodie/red = 5,
					/obj/item/clothing/suit/storage/toggle/hoodie/blue = 5,
					/obj/item/clothing/suit/storage/toggle/hoodie/green = 5,
					/obj/item/clothing/suit/storage/toggle/hoodie/orange = 5,
					/obj/item/clothing/suit/storage/toggle/hoodie/yellow = 5,
					/obj/item/clothing/suit/storage/toggle/hoodie/cti = 5,
					/obj/item/clothing/suit/storage/toggle/hoodie/mu = 5,
					/obj/item/clothing/suit/storage/toggle/hoodie/nt = 5,
					/obj/item/clothing/suit/storage/toggle/hoodie/smw = 5,
					/obj/item/clothing/suit/storage/toggle/hoodie/nrti = 5,
					/obj/item/clothing/suit/storage/fluff/jacket/field = 5,
					/obj/item/clothing/suit/storage/fluff/jacket/air_cavalry = 5,
					/obj/item/clothing/suit/storage/fluff/jacket/air_force = 5,
					/obj/item/clothing/suit/storage/fluff/jacket/navy = 5,
					/obj/item/clothing/suit/storage/fluff/jacket/special_forces = 5,
					/obj/item/clothing/suit/kamishimo = 5,
					/obj/item/clothing/suit/kimono = 5,
					/obj/item/clothing/suit/storage/toggle/labcoat = 5,
					/obj/item/clothing/suit/storage/toggle/labcoat/blue = 5,
					/obj/item/clothing/suit/storage/toggle/labcoat/blue_edge = 5,
					/obj/item/clothing/suit/storage/toggle/labcoat/green = 5,
					/obj/item/clothing/suit/storage/toggle/labcoat/orange = 5,
					/obj/item/clothing/suit/storage/toggle/labcoat/pink = 5,
					/obj/item/clothing/suit/storage/toggle/labcoat/red = 5,
					/obj/item/clothing/suit/storage/toggle/labcoat/yellow = 5,
					/obj/item/clothing/suit/leathercoat = 5,
					/obj/item/clothing/suit/storage/toggle/leather_jacket = 5,
					/obj/item/clothing/suit/storage/leather_jacket_alt = 5,
					/obj/item/clothing/suit/storage/toggle/brown_jacket = 5,
					/obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen = 5,
					/obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen = 5,
					/obj/item/clothing/suit/storage/toggle/leather_jacket/sleeveless = 5,
					/obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless = 5,
					/obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen/sleeveless = 5,
					/obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen/sleeveless = 5,
					/obj/item/clothing/suit/storage/miljacket = 5,
					/obj/item/clothing/suit/storage/miljacket/alt = 5,
					/obj/item/clothing/suit/storage/miljacket/green = 5,
					/obj/item/clothing/suit/storage/apron/overalls = 5,
					/obj/item/clothing/suit/storage/toggle/peacoat = 5,
					/obj/item/clothing/accessory/poncho = 5,
					/obj/item/clothing/accessory/poncho/green = 5,
					/obj/item/clothing/accessory/poncho/red = 5,
					/obj/item/clothing/accessory/poncho/purple = 5,
					/obj/item/clothing/accessory/poncho/blue = 5,
					/obj/item/clothing/suit/jacket/puffer = 5,
					/obj/item/clothing/suit/jacket/puffer/vest = 5,
					/obj/item/clothing/suit/storage/flannel/red = 5,
					/obj/item/clothing/suit/unathi/robe = 5,
					/obj/item/clothing/suit/storage/snowsuit = 5,
					/obj/item/clothing/suit/storage/toggle/internalaffairs = 5,
					/obj/item/clothing/suit/storage/toggle/lawyer/bluejacket = 5,
					/obj/item/clothing/suit/storage/toggle/lawyer/purpjacket = 5,
					/obj/item/clothing/suit/suspenders = 5,
					/obj/item/clothing/suit/storage/toggle/track = 5,
					/obj/item/clothing/suit/storage/toggle/track/blue = 5,
					/obj/item/clothing/suit/storage/toggle/track/green = 5,
					/obj/item/clothing/suit/storage/toggle/track/red = 5,
					/obj/item/clothing/suit/storage/toggle/track/white = 5,
					/obj/item/clothing/suit/storage/trench = 5,
					/obj/item/clothing/suit/storage/trench/grey = 5,
					/obj/item/clothing/suit/varsity = 5,
					/obj/item/clothing/suit/varsity/red = 5,
					/obj/item/clothing/suit/varsity/purple = 5,
					/obj/item/clothing/suit/varsity/green = 5,
					/obj/item/clothing/suit/varsity/blue = 5,
					/obj/item/clothing/suit/varsity/brown = 5,
					/obj/item/clothing/suit/storage/hooded/wintercoat = 5,
					/obj/item/clothing/suit/storage/hooded/wintercoat/aformal = 5,
					/obj/item/clothing/suit/storage/teshari/cloak/standard/white_grey = 5,
					/obj/item/clothing/suit/storage/gothcoat = 3)
	prices = list(/obj/item/clothing/suit/storage/apron = 25,
					/obj/item/clothing/suit/storage/flannel/aqua = 25,
					/obj/item/clothing/suit/storage/toggle/bomber = 25,
					/obj/item/clothing/suit/storage/bomber/alt = 25,
					/obj/item/clothing/suit/storage/flannel/brown = 25,
					/obj/item/clothing/suit/storage/toggle/cardigan = 25,
					/obj/item/clothing/accessory/poncho/roles/cloak/custom = 25,
					/obj/item/clothing/suit/storage/duster = 25,
					/obj/item/clothing/suit/storage/toggle/denim_jacket = 25,
					/obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen = 25,
					/obj/item/clothing/suit/storage/toggle/denim_jacket/sleeveless = 25,
					/obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen/sleeveless = 25,
					/obj/item/clothing/suit/storage/fluff/gntop = 25,
					/obj/item/clothing/suit/greatcoat = 25,
					/obj/item/clothing/suit/storage/flannel = 25,
					/obj/item/clothing/suit/storage/greyjacket = 25,
					/obj/item/clothing/suit/storage/hazardvest = 25,
					/obj/item/clothing/suit/storage/toggle/hoodie/black = 25,
					/obj/item/clothing/suit/storage/toggle/hoodie/red = 25,
					/obj/item/clothing/suit/storage/toggle/hoodie/blue = 25,
					/obj/item/clothing/suit/storage/toggle/hoodie/green = 25,
					/obj/item/clothing/suit/storage/toggle/hoodie/orange = 25,
					/obj/item/clothing/suit/storage/toggle/hoodie/yellow = 25,
					/obj/item/clothing/suit/storage/toggle/hoodie/cti = 25,
					/obj/item/clothing/suit/storage/toggle/hoodie/mu = 25,
					/obj/item/clothing/suit/storage/toggle/hoodie/nt = 25,
					/obj/item/clothing/suit/storage/toggle/hoodie/smw = 25,
					/obj/item/clothing/suit/storage/toggle/hoodie/nrti = 25,
					/obj/item/clothing/suit/storage/fluff/jacket/field = 25,
					/obj/item/clothing/suit/storage/fluff/jacket/air_cavalry = 25,
					/obj/item/clothing/suit/storage/fluff/jacket/air_force = 25,
					/obj/item/clothing/suit/storage/fluff/jacket/navy = 25,
					/obj/item/clothing/suit/storage/fluff/jacket/special_forces = 25,
					/obj/item/clothing/suit/kamishimo = 25,
					/obj/item/clothing/suit/kimono = 25,
					/obj/item/clothing/suit/storage/toggle/labcoat = 25,
					/obj/item/clothing/suit/storage/toggle/labcoat/blue = 25,
					/obj/item/clothing/suit/storage/toggle/labcoat/blue_edge = 25,
					/obj/item/clothing/suit/storage/toggle/labcoat/green = 25,
					/obj/item/clothing/suit/storage/toggle/labcoat/orange = 25,
					/obj/item/clothing/suit/storage/toggle/labcoat/pink = 25,
					/obj/item/clothing/suit/storage/toggle/labcoat/red = 25,
					/obj/item/clothing/suit/storage/toggle/labcoat/yellow = 25,
					/obj/item/clothing/suit/leathercoat = 25,
					/obj/item/clothing/suit/storage/toggle/leather_jacket = 25,
					/obj/item/clothing/suit/storage/leather_jacket_alt = 25,
					/obj/item/clothing/suit/storage/toggle/brown_jacket = 25,
					/obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen = 25,
					/obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen = 25,
					/obj/item/clothing/suit/storage/toggle/leather_jacket/sleeveless = 25,
					/obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless = 25,
					/obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen/sleeveless = 25,
					/obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen/sleeveless = 25,
					/obj/item/clothing/suit/storage/miljacket = 25,
					/obj/item/clothing/suit/storage/miljacket/alt = 25,
					/obj/item/clothing/suit/storage/miljacket/green = 25,
					/obj/item/clothing/suit/storage/apron/overalls = 25,
					/obj/item/clothing/suit/storage/toggle/peacoat = 25,
					/obj/item/clothing/accessory/poncho = 25,
					/obj/item/clothing/accessory/poncho/green = 25,
					/obj/item/clothing/accessory/poncho/red = 25,
					/obj/item/clothing/accessory/poncho/purple = 25,
					/obj/item/clothing/accessory/poncho/blue = 25,
					/obj/item/clothing/suit/jacket/puffer = 25,
					/obj/item/clothing/suit/jacket/puffer/vest = 25,
					/obj/item/clothing/suit/storage/flannel/red = 25,
					/obj/item/clothing/suit/unathi/robe = 25,
					/obj/item/clothing/suit/storage/snowsuit = 25,
					/obj/item/clothing/suit/storage/toggle/internalaffairs = 25,
					/obj/item/clothing/suit/storage/toggle/lawyer/bluejacket = 25,
					/obj/item/clothing/suit/storage/toggle/lawyer/purpjacket = 25,
					/obj/item/clothing/suit/suspenders = 25,
					/obj/item/clothing/suit/storage/toggle/track = 25,
					/obj/item/clothing/suit/storage/toggle/track/blue = 25,
					/obj/item/clothing/suit/storage/toggle/track/green = 25,
					/obj/item/clothing/suit/storage/toggle/track/red = 25,
					/obj/item/clothing/suit/storage/toggle/track/white = 25,
					/obj/item/clothing/suit/storage/trench = 25,
					/obj/item/clothing/suit/storage/trench/grey = 25,
					/obj/item/clothing/suit/varsity = 25,
					/obj/item/clothing/suit/varsity/red = 25,
					/obj/item/clothing/suit/varsity/purple = 25,
					/obj/item/clothing/suit/varsity/green = 25,
					/obj/item/clothing/suit/varsity/blue = 25,
					/obj/item/clothing/suit/varsity/brown = 25,
					/obj/item/clothing/suit/storage/hooded/wintercoat = 25,
					/obj/item/clothing/suit/storage/hooded/wintercoat/aformal = 25,
					/obj/item/clothing/suit/storage/teshari/cloak/standard/white_grey = 25,
					/obj/item/clothing/suit/storage/gothcoat = 25)
	premium = list(/obj/item/clothing/suit/imperium_monk = 3)
	contraband = list(/obj/item/toy/katana = 1)
/obj/machinery/vending/loadout/costume
	name = "Thespian's Delight"
	desc = "Sometimes nerds need costumes!"
	product_ads = "Don't let your art be stifled!;Remember, practice makes perfect!;Break a leg!;Don't make me get the cane!;Thespian's Delight entering stage right!;Costumes for your acting needs!"
	icon_state = "Theater_b"
	products = list(/obj/item/clothing/suit/storage/hooded/carp_costume = 3,
					/obj/item/clothing/suit/storage/hooded/carp_costume = 3,
					/obj/item/clothing/suit/chickensuit = 3,
					/obj/item/clothing/head/chicken = 3,
					/obj/item/clothing/head/helmet/gladiator = 3,
					/obj/item/clothing/under/gladiator = 3,
					/obj/item/clothing/suit/storage/toggle/labcoat/mad = 3,
					/obj/item/clothing/under/gimmick/rank/captain/suit = 3,
					/obj/item/clothing/glasses/gglasses = 3,
					/obj/item/clothing/head/flatcap = 3,
					/obj/item/clothing/shoes/boots/jackboots = 3,
					/obj/item/clothing/shoes/boots/jackboots = 3,
					/obj/item/clothing/shoes/boots/jackboots/knee = 3,
					/obj/item/clothing/shoes/boots/jackboots/thigh = 3,
					/obj/item/clothing/shoes/boots/jackboots/toeless/knee = 3,
					/obj/item/clothing/shoes/boots/jackboots/toeless/thigh = 3,
					/obj/item/clothing/under/schoolgirl = 3,
					/obj/item/clothing/under/schoolgirl/red = 3,
					/obj/item/clothing/under/schoolgirl/green = 3,
					/obj/item/clothing/under/schoolgirl/orange = 3,
					/obj/item/clothing/head/kitty = 3,
					/obj/item/clothing/glasses/sunglasses/blindfold = 3,
					/obj/item/clothing/head/beret = 3,
					/obj/item/clothing/under/skirt = 3,
					/obj/item/clothing/under/suit_jacket = 3,
					/obj/item/clothing/head/that = 3,
					/obj/item/clothing/accessory/wcoat = 3,
					/obj/item/clothing/under/scratch = 3,
					/obj/item/clothing/shoes/white = 3,
					/obj/item/clothing/gloves/white = 3,
					/obj/item/clothing/under/kilt = 3,
					/obj/item/clothing/glasses/monocle = 3,
					/obj/item/clothing/under/sl_suit = 3,
					/obj/item/clothing/mask/fakemoustache = 3,
					/obj/item/cane = 3,
					/obj/item/clothing/head/bowler = 3,
					/obj/item/clothing/head/plaguedoctorhat = 3,
					/obj/item/clothing/suit/bio_suit/plaguedoctorsuit = 3,
					/obj/item/clothing/mask/gas/plaguedoctor = 3,
					/obj/item/clothing/under/owl = 3,
					/obj/item/clothing/mask/gas/owl_mask = 3,
					/obj/item/clothing/under/waiter = 3,
					/obj/item/clothing/suit/storage/apron = 3,
					/obj/item/clothing/under/pirate = 3,
					/obj/item/clothing/head/pirate = 3,
					/obj/item/clothing/suit/pirate = 3,
					/obj/item/clothing/glasses/eyepatch = 3,
					/obj/item/clothing/head/ushanka = 3,
					/obj/item/clothing/under/soviet = 3,
					/obj/item/clothing/suit/imperium_monk = 1,
					/obj/item/clothing/suit/holidaypriest = 3,
					/obj/item/clothing/head/witchwig = 3,
					/obj/item/clothing/head/wizard/marisa/fake = 3,
					/obj/item/clothing/under/sundress = 3,
					/obj/item/staff/broom = 3,
					/obj/item/clothing/suit/wizrobe/fake = 3,
					/obj/item/clothing/head/wizard/fake = 3,
					/obj/item/staff = 3,
					/obj/item/clothing/mask/gas/clown_hat = 3,
					/obj/item/clothing/under/rank/clown = 3,
					/obj/item/clothing/mask/gas/mime = 3,
					/obj/item/clothing/under/mime = 3,
					/obj/item/clothing/mask/gas/sexyclown = 3,
					/obj/item/clothing/under/sexyclown = 3,
					/obj/item/clothing/mask/gas/sexymime = 3,
					/obj/item/clothing/under/sexymime = 3,
					/obj/item/clothing/head/rice = 3,
					/obj/item/clothing/head/lobster = 1,
					/obj/item/clothing/under/lobster = 1,
					/obj/item/clothing/suit/storage/hooded/bee_costume = 1,
					/obj/item/clothing/suit/storage/hooded/flash_costume = 1,
					/obj/item/clothing/head/nemes = 1,
					/obj/item/clothing/head/pharaoh = 1,
					/obj/item/clothing/suit/pharaoh = 2,
					/obj/item/clothing/mask/gas/mummy = 2,
					/obj/item/clothing/under/mummy = 2,
					/obj/item/clothing/head/scarecrow = 2,
					/obj/item/clothing/mask/gas/scarecrow = 2,
					/obj/item/clothing/under/scarecrow = 2,
					/obj/item/clothing/mask/gas/skeleton = 2,
					/obj/item/clothing/under/skeleton = 2,
					/obj/item/clothing/under/drfreeze = 2,
					/obj/item/clothing/suit/drfreeze = 2,
					/obj/item/clothing/under/darkholme = 2,
					/obj/item/clothing/under/geisha = 2,
					/obj/item/clothing/head/telegram = 2,
					/obj/item/clothing/under/telegram = 2,
					/obj/item/clothing/head/widehat_red = 2,
					/obj/item/clothing/mask/gas/bumba = 2,
					/obj/item/clothing/mask/gas/demon = 2,
					/obj/item/clothing/mask/gas/goblin = 2,
					/obj/item/clothing/mask/gas/guy = 3,
					/obj/item/clothing/mask/gas/joy = 2,
					/obj/item/clothing/under/red_mech = 1,
					/obj/item/clothing/under/white_mech = 1,
					/obj/item/clothing/under/blue_mech = 1,
					/obj/item/clothing/head/bunny = 1,
					/obj/item/clothing/suit/bunny = 1,
					/obj/item/clothing/head/santa = 1,
					/obj/item/clothing/head/santa/green = 1,
					/obj/item/clothing/head/reindeer = 2,
					/obj/item/clothing/head/holiday = 2,
					/obj/item/clothing/head/holiday/green = 2,
					/obj/item/clothing/suit/storage/toggle/holiday = 2,
					/obj/item/clothing/suit/storage/toggle/holiday/green = 2,
					/obj/item/clothing/under/christmas = 2,
					/obj/item/clothing/under/christmas/green = 2,
					/obj/item/clothing/under/christmasfem = 2,
					/obj/item/clothing/under/christmasfem/green = 2,
					/obj/item/clothing/shoes/santa = 1,
					/obj/item/clothing/shoes/holiday = 2,
					/obj/item/clothing/shoes/holiday/green = 2,
					/obj/item/clothing/mask/gas/bat = 2,
					/obj/item/clothing/mask/gas/bear = 2,
					/obj/item/clothing/mask/gas/bee = 2,
					/obj/item/clothing/mask/gas/dolphin = 2,
					/obj/item/clothing/mask/gas/fox = 2,
					/obj/item/clothing/mask/gas/frog = 2,
					/obj/item/clothing/mask/gas/horsehead = 2,
					/obj/item/clothing/mask/gas/jackal = 2,
					/obj/item/clothing/mask/gas/monkeymask = 2,
					/obj/item/clothing/mask/gas/pig = 2,
					/obj/item/clothing/mask/gas/rat = 2,
					/obj/item/clothing/mask/gas/raven = 2,
					/obj/item/clothing/mask/gas/shark = 2,
					/obj/item/clothing/under/bsing = 1,
					/obj/item/clothing/shoes/boots/bsing = 1,
					/obj/item/clothing/under/ysing = 1,
					/obj/item/clothing/shoes/boots/ysing = 1)
	prices = list(/obj/item/clothing/suit/storage/hooded/carp_costume = 75,
					/obj/item/clothing/suit/storage/hooded/carp_costume = 75,
					/obj/item/clothing/suit/chickensuit = 75,
					/obj/item/clothing/head/chicken = 75,
					/obj/item/clothing/head/helmet/gladiator = 100,
					/obj/item/clothing/under/gladiator = 125,
					/obj/item/clothing/suit/storage/toggle/labcoat/mad = 75,
					/obj/item/clothing/under/gimmick/rank/captain/suit = 75,
					/obj/item/clothing/glasses/gglasses = 75,
					/obj/item/clothing/head/flatcap = 75,
					/obj/item/clothing/shoes/boots/jackboots = 25,
					/obj/item/clothing/shoes/boots/jackboots/knee = 25,
					/obj/item/clothing/shoes/boots/jackboots/thigh = 25,
					/obj/item/clothing/shoes/boots/jackboots/toeless/knee = 25,
					/obj/item/clothing/shoes/boots/jackboots/toeless/thigh = 25,
					/obj/item/clothing/under/schoolgirl = 75,
					/obj/item/clothing/under/schoolgirl/red = 75,
					/obj/item/clothing/under/schoolgirl/green = 75,
					/obj/item/clothing/under/schoolgirl/orange = 75,
					/obj/item/clothing/head/kitty = 75,
					/obj/item/clothing/glasses/sunglasses/blindfold = 75,
					/obj/item/clothing/head/beret = 75,
					/obj/item/clothing/under/skirt = 75,
					/obj/item/clothing/under/suit_jacket = 75,
					/obj/item/clothing/head/that = 75,
					/obj/item/clothing/accessory/wcoat = 75,
					/obj/item/clothing/under/scratch = 75,
					/obj/item/clothing/shoes/white = 75,
					/obj/item/clothing/gloves/white = 75,
					/obj/item/clothing/under/kilt = 75,
					/obj/item/clothing/glasses/monocle = 400,
					/obj/item/clothing/under/sl_suit = 75,
					/obj/item/clothing/mask/fakemoustache = 75,
					/obj/item/clothing/head/wizard/marisa/fake = 100,
					/obj/item/cane = 100,
					/obj/item/clothing/head/bowler = 75,
					/obj/item/clothing/head/plaguedoctorhat = 100,
					/obj/item/clothing/suit/bio_suit/plaguedoctorsuit = 100,
					/obj/item/clothing/mask/gas/plaguedoctor = 150,
					/obj/item/clothing/under/owl = 175,
					/obj/item/clothing/mask/gas/owl_mask = 175,
					/obj/item/clothing/under/waiter = 75,
					/obj/item/clothing/suit/storage/apron = 75,
					/obj/item/clothing/under/pirate = 100,
					/obj/item/clothing/head/pirate = 175,
					/obj/item/clothing/suit/pirate = 150,
					/obj/item/clothing/glasses/eyepatch = 75,
					/obj/item/clothing/head/ushanka = 75,
					/obj/item/clothing/under/soviet = 75,
					/obj/item/clothing/suit/imperium_monk = 500,
					/obj/item/clothing/suit/holidaypriest = 75,
					/obj/item/clothing/head/witchwig = 75,
					/obj/item/clothing/under/sundress = 75,
					/obj/item/staff/broom = 400,
					/obj/item/clothing/suit/wizrobe/fake = 75,
					/obj/item/clothing/head/wizard/fake = 75,
					/obj/item/staff = 400,
					/obj/item/clothing/mask/gas/clown_hat = 150,
					/obj/item/clothing/under/rank/clown = 75,
					/obj/item/clothing/mask/gas/mime = 150,
					/obj/item/clothing/under/mime = 75,
					/obj/item/clothing/mask/gas/sexyclown = 150,
					/obj/item/clothing/under/sexyclown = 75,
					/obj/item/clothing/mask/gas/sexymime = 150,
					/obj/item/clothing/under/sexymime = 75,
					/obj/item/clothing/head/rice = 75,
					/obj/item/clothing/head/lobster = 150,
					/obj/item/clothing/head/nemes = 200,
					/obj/item/clothing/head/pharaoh = 200,
					/obj/item/clothing/head/bunny = 500,
					/obj/item/clothing/head/rice = 75,
					/obj/item/clothing/head/lobster = 150,
					/obj/item/clothing/under/lobster = 150,
					/obj/item/clothing/suit/storage/hooded/bee_costume = 300,
					/obj/item/clothing/suit/storage/hooded/flash_costume = 300,
					/obj/item/clothing/head/nemes = 150,
					/obj/item/clothing/head/pharaoh = 150,
					/obj/item/clothing/suit/pharaoh = 150,
					/obj/item/clothing/mask/gas/mummy = 100,
					/obj/item/clothing/under/mummy = 100,
					/obj/item/clothing/head/scarecrow = 100,
					/obj/item/clothing/mask/gas/scarecrow = 100,
					/obj/item/clothing/under/scarecrow = 200,
					/obj/item/clothing/mask/gas/skeleton = 100,
					/obj/item/clothing/under/skeleton = 100,
					/obj/item/clothing/under/drfreeze = 100,
					/obj/item/clothing/suit/drfreeze = 100,
					/obj/item/clothing/under/darkholme = 150,
					/obj/item/clothing/under/geisha = 200,
					/obj/item/clothing/head/telegram = 50,
					/obj/item/clothing/under/telegram = 100,
					/obj/item/clothing/head/widehat_red = 2,
					/obj/item/clothing/mask/gas/bumba = 150,
					/obj/item/clothing/mask/gas/demon = 150,
					/obj/item/clothing/mask/gas/goblin = 150,
					/obj/item/clothing/mask/gas/guy = 100,
					/obj/item/clothing/mask/gas/joy = 150,
					/obj/item/clothing/under/red_mech = 500,
					/obj/item/clothing/under/white_mech = 500,
					/obj/item/clothing/under/blue_mech = 500,
					/obj/item/clothing/head/bunny = 500,
					/obj/item/clothing/suit/bunny = 350,
					/obj/item/clothing/head/reindeer = 50,
					/obj/item/clothing/head/holiday = 75,
					/obj/item/clothing/head/holiday/green = 75,
					/obj/item/clothing/suit/storage/toggle/holiday = 100,
					/obj/item/clothing/suit/storage/toggle/holiday/green = 100,
					/obj/item/clothing/under/christmas = 100,
					/obj/item/clothing/under/christmas/green = 100,
					/obj/item/clothing/under/christmasfem = 150,
					/obj/item/clothing/under/christmasfem/green = 150,
					/obj/item/clothing/shoes/santa = 200,
					/obj/item/clothing/head/santa = 150,
					/obj/item/clothing/head/santa/green = 150,
					/obj/item/clothing/shoes/holiday = 75,
					/obj/item/clothing/shoes/holiday/green = 75,
					/obj/item/clothing/mask/gas/bat = 250,
					/obj/item/clothing/mask/gas/bear = 250,
					/obj/item/clothing/mask/gas/bee = 250,
					/obj/item/clothing/mask/gas/dolphin = 250,
					/obj/item/clothing/mask/gas/fox = 250,
					/obj/item/clothing/mask/gas/frog = 250,
					/obj/item/clothing/mask/gas/horsehead = 250,
					/obj/item/clothing/mask/gas/jackal = 250,
					/obj/item/clothing/mask/gas/monkeymask = 250,
					/obj/item/clothing/mask/gas/pig = 250,
					/obj/item/clothing/mask/gas/rat = 250,
					/obj/item/clothing/mask/gas/raven = 250,
					/obj/item/clothing/mask/gas/shark = 250,
					/obj/item/clothing/under/bsing = 500,
					/obj/item/clothing/shoes/boots/bsing = 500,
					/obj/item/clothing/under/ysing = 500,
					/obj/item/clothing/shoes/boots/ysing = 500)
	premium = list(/obj/item/clothing/suit/imperium_monk = 3)
	contraband = list(/obj/item/clothing/head/syndicatefake = 1,
					/obj/item/clothing/suit/syndicatefake = 1)

/obj/machinery/vending/glukoz
	name = "Glukoz Pharmavenda"
	desc = "An illicit injector vendor stocked and maintained by the allegedly defunct pharmaceuticals company Glukoz Ltd."
	icon = 'icons/obj/vending.dmi'
	icon_state = "rxvendor"
	icon_vend = "rxvendor"
	product_slogans = "Glukoz Pharmavenda, voted top street pharmaceuticals vendor, 2519!"
	product_ads = "Back so soon?;The hits keep comin'!;If you can afford it, it's only a habit!;Who's gonna know?;In a pinch? It's just a pinch!;Remove the cap!;You'll be back!"
	products = list(/obj/item/reagent_containers/hypospray/glukoz = 10,
					/obj/item/reagent_containers/hypospray/glukoz/certaphil = 10,
					/obj/item/reagent_containers/hypospray/glukoz/downer = 10,
					/obj/item/reagent_containers/hypospray/glukoz/fuckit = 10,
					/obj/item/reagent_containers/hypospray/glukoz/hangup = 10,
					/obj/item/reagent_containers/hypospray/glukoz/hypnogamma = 10,
					/obj/item/reagent_containers/hypospray/glukoz/medcon = 10,
					/obj/item/reagent_containers/hypospray/glukoz/multibuzz = 10,
					/obj/item/reagent_containers/hypospray/glukoz/numplus = 10,
					/obj/item/reagent_containers/hypospray/glukoz/oxyduo = 10,
					/obj/item/reagent_containers/hypospray/glukoz/pyrholidon = 10,
					/obj/item/reagent_containers/hypospray/glukoz/viraplus = 10)
	prices = list(/obj/item/reagent_containers/hypospray/glukoz = 100,
					/obj/item/reagent_containers/hypospray/glukoz/certaphil = 350,
					/obj/item/reagent_containers/hypospray/glukoz/downer = 200,
					/obj/item/reagent_containers/hypospray/glukoz/fuckit = 500,
					/obj/item/reagent_containers/hypospray/glukoz/hangup = 200,
					/obj/item/reagent_containers/hypospray/glukoz/hypnogamma = 350,
					/obj/item/reagent_containers/hypospray/glukoz/medcon = 1000,
					/obj/item/reagent_containers/hypospray/glukoz/multibuzz = 500,
					/obj/item/reagent_containers/hypospray/glukoz/numplus = 200,
					/obj/item/reagent_containers/hypospray/glukoz/oxyduo = 500,
					/obj/item/reagent_containers/hypospray/glukoz/pyrholidon = 400,
					/obj/item/reagent_containers/hypospray/glukoz/viraplus = 200)
	idle_power_usage = 211
