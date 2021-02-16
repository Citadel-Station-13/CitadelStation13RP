//Food items that are eaten normally and don't leave anything behind.
/obj/item/reagent_containers/food/snacks
	name = "snack"
	desc = "yummy"
	icon = 'icons/obj/food.dmi'
	icon_state = null
	flags = OPENCONTAINER
	verb_say = "chirps"
	verb_ask = "cheeps"
	verb_exclaim = "cries"
	verb_yell = "shriek"
	var/bitesize = 1
	var/bitecount = 0
	var/trash = null
	var/slice_path
	var/slices_num
	var/dried_type = null
	var/dry = 0
	var/survivalfood = FALSE
	var/nutriment_amt = 0
	var/list/nutriment_desc = list("food" = 1)
	var/datum/reagent/nutriment/coating/coating = null
	var/icon/flat_icon = null //Used to cache a flat icon generated from dipping in batter. This is used again to make the cooked-batter-overlay
	var/do_coating_prefix = 1 //If 0, we wont do "battered thing" or similar prefixes. Mainly for recipes that include batter but have a special name
	var/cooked_icon = null //Used for foods that are "cooked" without being made into a specific recipe or combination.
	//Generally applied during modification cooking with oven/fryer
	//Used to stop deepfried meat from looking like slightly tanned raw meat, and make it actually look cooked
	center_of_mass = list("x"=16, "y"=16)
	w_class = ITEMSIZE_SMALL
	force = 1

/obj/item/reagent_containers/food/snacks/Initialize()
	. = ..()
	if(nutriment_amt)
		reagents.add_reagent("nutriment",nutriment_amt,nutriment_desc)

	//Placeholder for effect that trigger on eating that aren't tied to reagents.
/obj/item/reagent_containers/food/snacks/proc/On_Consume(var/mob/M)
	if(!usr)
		usr = M
	if(!reagents.total_volume)
		M.visible_message("<span class='notice'>[M] finishes eating \the [src].</span>","<span class='notice'>You finish eating \the [src].</span>")
		usr.drop_from_inventory(src)	//so icons update :[

		if(trash)
			if(ispath(trash,/obj/item))
				var/obj/item/TrashItem = new trash(usr)
				usr.put_in_hands(TrashItem)
			else if(istype(trash,/obj/item))
				usr.put_in_hands(trash)
		qdel(src)
	return

/obj/item/reagent_containers/food/snacks/attack_self(mob/user as mob)
	return

/obj/item/reagent_containers/food/snacks/attack(mob/M as mob, mob/user as mob, def_zone)
	if(reagents && !reagents.total_volume)
		to_chat(user, "<span class='danger'>None of [src] left!</span>")
		user.drop_from_inventory(src)
		qdel(src)
		return 0

	if(istype(M, /mob/living/carbon))
		//TODO: replace with standard_feed_mob() call.

		var/fullness = M.nutrition + (M.reagents.get_reagent_amount("nutriment") * 25)
		if(M == user)								//If you're eating it yourself
			if(istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(!H.check_has_mouth())
					to_chat(user, "Where do you intend to put \the [src]? You don't have a mouth!")
					return
				var/obj/item/blocked = null
				if(survivalfood)
					blocked = H.check_mouth_coverage_survival()
				else
					blocked = H.check_mouth_coverage()
				if(blocked)
					to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
					return

			 // Vorestation edits in this section.
			user.setClickCooldown(user.get_attack_speed(src)) //puts a limit on how fast people can eat/drink things
			if (fullness <= 50)
				to_chat(M, "<span class='danger'>You hungrily chew out a piece of [src] and gobble it!</span>")
			if (fullness > 50 && fullness <= 150)
				to_chat(M, "<span class='notice'>You hungrily begin to eat [src].</span>")
			if (fullness > 150 && fullness <= 350)
				to_chat(M, "<span class='notice'>You take a bite of [src].</span>")
			if (fullness > 350 && fullness <= 550)
				to_chat(M, "<span class='notice'>You unwillingly chew a bit of [src].</span>")
			if (fullness > 550 && fullness <= 650)
				to_chat(M, "<span class='notice'>You swallow some more of the [src], causing your belly to swell out a little.</span>")
			if (fullness > 650 && fullness <= 1000)
				to_chat(M, "<span class='notice'>You stuff yourself with the [src]. Your stomach feels very heavy.</span>")
			if (fullness > 1000 && fullness <= 3000)
				to_chat(M, "<span class='notice'>You gluttonously swallow down the hunk of [src]. You're so gorged, it's hard to stand.</span>")
			if (fullness > 3000 && fullness <= 5500)
				to_chat(M, "<span class='danger'>You force the piece of [src] down your throat. You can feel your stomach getting firm as it reaches its limits.</span>")
			if (fullness > 5500 && fullness <= 6000)
				to_chat(M, "<span class='danger'>You barely glug down the bite of [src], causing undigested food to force into your intestines. You can't take much more of this!</span>")
			if (fullness > 6000) // There has to be a limit eventually.
				to_chat(M, "<span class='danger'>Your stomach blorts and aches, prompting you to stop. You literally cannot force any more of [src] to go down your throat.</span>")
				return 0
			/*if (fullness > (550 * (1 + M.overeatduration / 2000)))	// The more you eat - the more you can eat
				to_chat(M, "<span class='danger'>You cannot force any more of [src] to go down your throat.</span>")
				return 0*/

		else
			if(istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(!H.check_has_mouth())
					to_chat(user, "Where do you intend to put \the [src]? \The [H] doesn't have a mouth!")
					return
				var/obj/item/blocked = H.check_mouth_coverage()
				if(blocked)
					to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
					return

			if(!istype(M, /mob/living/carbon/slime))		//If you're feeding it to someone else.

				/*if (fullness <= (550 * (1 + M.overeatduration / 1000))) // Vorestation edit
					user.visible_message("<span class='danger'>[user] attempts to feed [M] [src].</span>")
				else
					user.visible_message("<span class='danger'>[user] cannot force anymore of [src] down [M]'s throat.</span>")
					return 0*/
				user.visible_message("<span class='danger'>[user] attempts to feed [M] [src].</span>") // Vorestation edit

				user.setClickCooldown(user.get_attack_speed(src))
				if(!do_mob(user, M)) return

				//Do we really care about this
				add_attack_logs(user,M,"Fed with [src.name] containing [reagentlist(src)]", admin_notify = FALSE)

				user.visible_message("<span class='danger'>[user] feeds [M] [src].</span>")

			else
				to_chat(user, "This creature does not seem to have a mouth!")
				return

		if(reagents)								//Handle ingestion of the reagent.
			playsound(M.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			if(reagents.total_volume)
				if(reagents.total_volume > bitesize)
					reagents.trans_to_mob(M, bitesize, CHEM_INGEST)
				else
					reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
				bitecount++
				On_Consume(M)
			return 1

	return 0

/obj/item/reagent_containers/food/snacks/examine(mob/user)
	if(!..(user, 1))
		return
	if (coating) // BEGIN CITADEL CHANGE
		to_chat(user, "<span class='notice'>It's coated in [coating.name]!</span>") // END CITADEL CHANGE
	if (bitecount==0)
		return
	else if (bitecount==1)
		to_chat(user, "<font color='blue'>\The [src] was bitten by someone!</font>")
	else if (bitecount<=3)
		to_chat(user, "<font color='blue'>\The [src] was bitten [bitecount] times!</font>")
	else
		to_chat(user, "<font color='blue'>\The [src] was bitten multiple times!</font>")

/obj/item/reagent_containers/food/snacks/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/storage))
		. = ..() // -> item/attackby()
		return

	// Eating with forks
	if(istype(W,/obj/item/material/kitchen/utensil))
		var/obj/item/material/kitchen/utensil/U = W
		if(U.scoop_food)
			if(!U.reagents)
				U.create_reagents(5)

			if (U.reagents.total_volume > 0)
				to_chat(user, "<font color='red'>You already have something on your [U].</font>")
				return

			user.visible_message( \
				"[user] scoops up some [src] with \the [U]!", \
				"<font color='blue'>You scoop up some [src] with \the [U]!</font>" \
			)

			src.bitecount++
			U.overlays.Cut()
			U.loaded = "[src]"
			var/image/I = new(U.icon, "loadedfood")
			I.color = src.filling_color
			U.overlays += I

			reagents.trans_to_obj(U, min(reagents.total_volume,5))

			if (reagents.total_volume <= 0)
				qdel(src)
			return

	if (is_sliceable())
		//these are used to allow hiding edge items in food that is not on a table/tray
		var/can_slice_here = isturf(src.loc) && ((locate(/obj/structure/table) in src.loc) || (locate(/obj/machinery/optable) in src.loc) || (locate(/obj/item/tray) in src.loc))
		var/hide_item = !has_edge(W) || !can_slice_here

		if (hide_item)
			if (W.w_class >= src.w_class || is_robot_module(W))
				return

			to_chat(user, "<span class='warning'>You slip \the [W] inside \the [src].</span>")
			user.drop_from_inventory(W, src)
			add_fingerprint(user)
			contents += W
			return

		if (has_edge(W))
			if (!can_slice_here)
				to_chat(user, "<span class='warning'>You cannot slice \the [src] here! You need a table or at least a tray to do it.</span>")
				return

			var/slices_lost = 0
			if (W.w_class > 3)
				user.visible_message("<span class='notice'>\The [user] crudely slices \the [src] with [W]!</span>", "<span class='notice'>You crudely slice \the [src] with your [W]!</span>")
				slices_lost = rand(1,min(1,round(slices_num/2)))
			else
				user.visible_message("<span class='notice'>\The [user] slices \the [src]!</span>", "<span class='notice'>You slice \the [src]!</span>")

			var/reagents_per_slice = reagents.total_volume/slices_num
			for(var/i=1 to (slices_num-slices_lost))
				var/obj/slice = new slice_path (src.loc)
				reagents.trans_to_obj(slice, reagents_per_slice)
			qdel(src)
			return

/obj/item/reagent_containers/food/snacks/proc/is_sliceable()
	return (slices_num && slice_path && slices_num > 0)

/obj/item/reagent_containers/food/snacks/Destroy()
	if(contents)
		for(var/atom/movable/something in contents)
			something.dropInto(loc)
	. = ..()

////////////////////////////////////////////////////////////////////////////////
/// FOOD END
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/food/snacks/attack_generic(var/mob/living/user)
	if(!isanimal(user) && !isalien(user))
		return
	user.visible_message("<b>[user]</b> nibbles away at \the [src].","You nibble away at \the [src].")
	bitecount++
	if(reagents)
		reagents.trans_to_mob(user, bitesize, CHEM_INGEST)
	spawn(5)
		if(!src && !user.client)
			user.custom_emote(1,"[pick("burps", "cries for more", "burps twice", "looks at the area where the food was")]")
			qdel(src)
	On_Consume(user)

//////////////////////////////////////////////////
////////////////////////////////////////////Snacks
//////////////////////////////////////////////////
//Items in the "Snacks" subcategory are food items that people actually eat. The key points are that they are created
//	already filled with reagents and are destroyed when empty. Additionally, they make a "munching" noise when eaten.

//Notes by Darem: Food in the "snacks" subtype can hold a maximum of 50 units Generally speaking, you don't want to go over 40
//	total for the item because you want to leave space for extra condiments. If you want effect besides healing, add a reagent for
//	it. Try to stick to existing reagents when possible (so if you want a stronger healing effect, just use Tricordrazine). On use
//	effect (such as the old officer eating a donut code) requires a unique reagent (unless you can figure out a better way).

//The nutriment reagent and bitesize variable replace the old heal_amt and amount variables. Each unit of nutriment is equal to
//	2 of the old heal_amt variable. Bitesize is the rate at which the reagents are consumed. So if you have 6 nutriment and a
//	bitesize of 2, then it'll take 3 bites to eat. Unlike the old system, the contained reagents are evenly spread among all
//	the bites. No more contained reagents = no more bites.

//Here is an example of the new formatting for anyone who wants to add more food items.
///obj/item/reagent_containers/food/snacks/xenoburger			//Identification path for the object.
//	name = "Xenoburger"													//Name that displays in the UI.
//	desc = "Smells caustic. Tastes like heresy."						//Duh
//	icon_state = "xburger"												//Refers to an icon in food.dmi
//
//obj/item/reagent_containers/food/snacks/xenoburger/Initialize()//Don't mess with this. We don't relative path here.
//		. = ..()															//Same here.
//		reagents.add_reagent("xenomicrobes", 10)						//This is what is in the food item. you may copy/paste
//		reagents.add_reagent("nutriment", 2)							//	this line of code for all the contents.
//		bitesize = 3													//This is the amount each bite consumes.




/obj/item/reagent_containers/food/snacks/aesirsalad
	name = "Aesir salad"
	desc = "Probably too incredible for mortal men to fully enjoy."
	icon_state = "aesirsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#468C00"
	nutriment_amt = 8
	nutriment_desc = list("apples" = 3,"salad" = 5)

/obj/item/reagent_containers/food/snacks/aesirsalad/Initialize()
	. = ..()
	reagents.add_reagent("doctorsdelight", 8)
	reagents.add_reagent("tricordrazine", 8)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/candy // Buff 4 >> 8
	name = "candy"
	desc = "Nougat, love it or hate it."
	icon_state = "candy"
	trash = /obj/item/trash/candy
	filling_color = "#7D5F46"
	nutriment_amt = 3
	nutriment_desc = list("candy" = 1)

/obj/item/reagent_containers/food/snacks/candy/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 4)
	reagents.add_reagent("protein", 1)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/candy/proteinbar // Buff 17 >> 21
	name = "protein bar"
	desc = "SwoleMAX brand protein bars, guaranteed to get you feeling perfectly overconfident."
	icon_state = "proteinbar"
	trash = /obj/item/trash/candy/proteinbar
	nutriment_amt = 7
	nutriment_desc = list("candy" = 1, "protein" = 8)

/obj/item/reagent_containers/food/snacks/candy/proteinbar/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)
	reagents.add_reagent("sugar", 4)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/candy/donor
	name = "Donor Candy"
	desc = "A little treat for blood donors."
	trash = /obj/item/trash/candy
	nutriment_amt = 9
	nutriment_desc = list("candy" = 10)

/obj/item/reagent_containers/food/snacks/candy/donor/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 3)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/candy_corn
	name = "candy corn"
	desc = "It's a handful of candy corn. Cannot be stored in a detective's hat, alas."
	icon_state = "candy_corn"
	filling_color = "#FFFCB0"
	nutriment_amt = 4
	nutriment_desc = list("candy corn" = 4)

/obj/item/reagent_containers/food/snacks/candy_corn/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 2)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/chips // Buff 3 >> 5
	name = "chips"
	desc = "Commander Riker's What-The-Crisps"
	icon_state = "chips"
	trash = /obj/item/trash/chips
	filling_color = "#E8C31E"
	nutriment_amt = 5
	nutriment_desc = list("salt" = 1, "chips" = 2)

/obj/item/reagent_containers/food/snacks/chips/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cookie
	name = "cookie"
	desc = "COOKIE!!!"
	icon_state = "COOKIE!!!"
	filling_color = "#DBC94F"
	nutriment_amt = 5
	nutriment_desc = list("sweetness" = 3, "cookie" = 2)

/obj/item/reagent_containers/food/snacks/cookie/Initialize()
	. = ..()
	bitesize = 1

/obj/item/reagent_containers/food/snacks/dtreat
	name = "pet treat"
	desc = "TREAT?!!?!"
	icon_state = "TREAT!!!"
	filling_color = "#DBC94F"
	nutriment_amt = 5
	nutriment_desc = list("sugar" = 3, "protein" = 2)
	slot_flags = SLOT_MASK
	sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/species/teshari/masks_vr.dmi', SPECIES_VOX = 'icons/mob/species/vox/masks.dmi', SPECIES_TAJ = 'icons/mob/species/tajaran/mask_vr.dmi', SPECIES_UNATHI = 'icons/mob/species/unathi/mask_vr.dmi', SPECIES_SERGAL = 'icons/mob/species/sergal/mask_vr.dmi', SPECIES_NEVREAN = 'icons/mob/species/nevrean/mask_vr.dmi', SPECIES_ZORREN_HIGH = 'icons/mob/species/fox/mask_vr.dmi', SPECIES_ZORREN_FLAT = 'icons/mob/species/fennec/mask_vr.dmi', SPECIES_AKULA = 'icons/mob/species/akula/mask_vr.dmi', SPECIES_VULPKANIN = 'icons/mob/species/vulpkanin/mask.dmi', SPECIES_XENOCHIMERA = 'icons/mob/species/tajaran/mask_vr.dmi')

/obj/item/reagent_containers/food/snacks/dtreat/Initialize()
	. = ..()
	bitesize = 1

/obj/item/reagent_containers/food/snacks/chocolatebar // Buff 6 >> 8
	name = "Chocolate Bar"
	desc = "Such sweet, fattening food."
	icon_state = "chocolatebar"
	filling_color = "#7D5F46"
	nutriment_amt = 4
	nutriment_desc = list("chocolate" = 5)

/obj/item/reagent_containers/food/snacks/chocolatebar/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 4)
	reagents.add_reagent("coco", 2)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/chocolatepiece
	name = "chocolate piece"
	desc = "A luscious milk chocolate piece filled with gooey caramel."
	icon_state =  "chocolatepiece"
	filling_color = "#7D5F46"
	nutriment_amt = 1
	nutriment_desc = list("chocolate" = 3, "caramel" = 2, "lusciousness" = 1)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/chocolatepiece/white
	name = "white chocolate piece"
	desc = "A creamy white chocolate piece drizzled in milk chocolate."
	icon_state = "chocolatepiece_white"
	filling_color = "#E2DAD3"
	nutriment_desc = list("white chocolate" = 3, "creaminess" = 1)

/obj/item/reagent_containers/food/snacks/chocolatepiece/truffle
	name = "chocolate truffle"
	desc = "A bite-sized milk chocolate truffle that could buy anyone's love."
	icon_state = "chocolatepiece_truffle"
	nutriment_desc = list("chocolate" = 3, "undying devotion" = 3)

/obj/item/reagent_containers/food/snacks/chocolateegg
	name = "Chocolate Egg"
	desc = "How eggcellent."
	icon_state = "chocolateegg"
	filling_color = "#7D5F46"
	nutriment_amt = 3
	nutriment_desc = list("chocolate" = 5)

/obj/item/reagent_containers/food/snacks/chocolateegg/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 2)
	reagents.add_reagent("coco", 2)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/donut
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut1"
	filling_color = "#D9C386"
	var/overlay_state = "box-donut1"
	nutriment_desc = list("sweetness", "donut")

/obj/item/reagent_containers/food/snacks/donut/normal
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut1"
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/donut/normal/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 3)
	reagents.add_reagent("sprinkles", 1)
	src.bitesize = 3
	if(prob(30))
		src.icon_state = "donut2"
		src.overlay_state = "box-donut2"
		src.name = "frosted donut"
		reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_containers/food/snacks/donut/chaos
	name = "Chaos Donut"
	desc = "Like life, it never quite tastes the same."
	icon_state = "donut1"
	filling_color = "#ED11E6"
	nutriment_amt = 2

/obj/item/reagent_containers/food/snacks/donut/chaos/Initialize()
	. = ..()
	reagents.add_reagent("sprinkles", 1)
	bitesize = 10
	var/chaosselect = pick(1,2,3,4,5,6,7,8,9,10)
	switch(chaosselect)
		if(1)
			reagents.add_reagent("nutriment", 3)
		if(2)
			reagents.add_reagent("capsaicin", 3)
		if(3)
			reagents.add_reagent("frostoil", 3)
		if(4)
			reagents.add_reagent("sprinkles", 3)
		if(5)
			reagents.add_reagent("phoron", 3)
		if(6)
			reagents.add_reagent("coco", 3)
		if(7)
			reagents.add_reagent("slimejelly", 3)
		if(8)
			reagents.add_reagent("banana", 3)
		if(9)
			reagents.add_reagent("berryjuice", 3)
		if(10)
			reagents.add_reagent("tricordrazine", 3)
	if(prob(30))
		src.icon_state = "donut2"
		src.overlay_state = "box-donut2"
		src.name = "Frosted Chaos Donut"
		reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_containers/food/snacks/donut/jelly
	name = "Jelly Donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ED1169"
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/donut/jelly/Initialize()
	. = ..()
	reagents.add_reagent("sprinkles", 1)
	reagents.add_reagent("berryjuice", 5)
	bitesize = 5
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.name = "Frosted Jelly Donut"
		reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_containers/food/snacks/donut/slimejelly
	name = "Jelly Donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ED1169"
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/donut/slimejelly/Initialize()
	. = ..()
	reagents.add_reagent("sprinkles", 1)
	reagents.add_reagent("slimejelly", 5)
	bitesize = 5
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.name = "Frosted Jelly Donut"
		reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_containers/food/snacks/donut/cherryjelly
	name = "Jelly Donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ED1169"
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/donut/cherryjelly/Initialize()
	. = ..()
	reagents.add_reagent("sprinkles", 1)
	reagents.add_reagent("cherryjelly", 5)
	bitesize = 5
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.name = "Frosted Jelly Donut"
		reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_containers/food/snacks/egg
	name = "egg"
	desc = "An egg!"
	icon_state = "egg"
	filling_color = "#FDFFD1"
	volume = 10

/obj/item/reagent_containers/food/snacks/egg/Initialize()
	. = ..()
	reagents.add_reagent("egg", 3)

/obj/item/reagent_containers/food/snacks/egg/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(istype(O,/obj/machinery/microwave))
		return ..()
	if(!(proximity && O.is_open_container()))
		return
	to_chat(user, "You crack \the [src] into \the [O].")
	reagents.trans_to(O, reagents.total_volume)
	user.drop_from_inventory(src)
	qdel(src)

/obj/item/reagent_containers/food/snacks/egg/throw_impact(atom/hit_atom)
	. = ..()
	new/obj/effect/decal/cleanable/egg_smudge(src.loc)
	src.reagents.splash(hit_atom, reagents.total_volume)
	src.visible_message("<font color='red'>[src.name] has been squashed.</font>","<font color='red'>You hear a smack.</font>")
	qdel(src)

/obj/item/reagent_containers/food/snacks/egg/attackby(obj/item/W as obj, mob/user as mob)
	if(istype( W, /obj/item/pen/crayon ))
		var/obj/item/pen/crayon/C = W
		var/clr = C.colourName

		if(!(clr in list("blue","green","mime","orange","purple","rainbow","red","yellow")))
			to_chat(usr, "<font color='blue'>The egg refuses to take on this color!</font>")
			return

		to_chat(usr, "<font color='blue'>You color \the [src] [clr]</font>")
		icon_state = "egg-[clr]"
	else
		. = ..()

/obj/item/reagent_containers/food/snacks/egg/blue
	icon_state = "egg-blue"

/obj/item/reagent_containers/food/snacks/egg/green
	icon_state = "egg-green"

/obj/item/reagent_containers/food/snacks/egg/mime
	icon_state = "egg-mime"

/obj/item/reagent_containers/food/snacks/egg/orange
	icon_state = "egg-orange"

/obj/item/reagent_containers/food/snacks/egg/purple
	icon_state = "egg-purple"

/obj/item/reagent_containers/food/snacks/egg/rainbow
	icon_state = "egg-rainbow"

/obj/item/reagent_containers/food/snacks/egg/red
	icon_state = "egg-red"

/obj/item/reagent_containers/food/snacks/egg/yellow
	icon_state = "egg-yellow"

/obj/item/reagent_containers/food/snacks/friedegg // Buff 3 >> 6
	name = "Fried egg"
	desc = "A fried egg, with a touch of salt and pepper."
	icon_state = "friedegg"
	filling_color = "#FFDF78"

/obj/item/reagent_containers/food/snacks/friedegg/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("blackpepper", 1)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/boiledegg // Buff 2 >> 5
	name = "Boiled egg"
	desc = "A hard boiled egg."
	icon_state = "egg"
	filling_color = "#FFFFFF"

/obj/item/reagent_containers/food/snacks/boiledegg/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/organ
	name = "organ"
	desc = "It's good for you."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	filling_color = "#E00D34"

/obj/item/reagent_containers/food/snacks/organ/Initialize()
	. = ..()
	reagents.add_reagent("protein", rand(3,5))
	reagents.add_reagent("toxin", rand(1,3))
	src.bitesize = 3

/obj/item/reagent_containers/food/snacks/tofu // Buff 3 >> 6
	name = "Tofu"
	icon_state = "tofu"
	desc = "We all love tofu."
	filling_color = "#FFFEE0"
	nutriment_amt = 6
	nutriment_desc = list("tofu" = 3, "goeyness" = 3)

/obj/item/reagent_containers/food/snacks/tofu/Initialize()
	. = ..()
	src.bitesize = 3

/obj/item/reagent_containers/food/snacks/tofurkey
	name = "Tofurkey"
	desc = "A fake turkey made from tofu."
	icon_state = "tofurkey"
	filling_color = "#FFFEE0"
	nutriment_amt = 12
	nutriment_desc = list("turkey" = 3, "tofu" = 5, "goeyness" = 4)

/obj/item/reagent_containers/food/snacks/tofurkey/Initialize()
	. = ..()
	reagents.add_reagent("stoxin", 3)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/stuffing // Buff 3 >> 5
	name = "Stuffing"
	desc = "Moist, peppery breadcrumbs for filling the body cavities of dead birds. Dig in!"
	icon_state = "stuffing"
	filling_color = "#C9AC83"
	nutriment_amt = 5
	nutriment_desc = list("dryness" = 2, "bread" = 2)

/obj/item/reagent_containers/food/snacks/stuffing/Initialize()
	. = ..()
	bitesize = 2 // Was 1

/obj/item/reagent_containers/food/snacks/carpmeat
	name = "fillet"
	desc = "A fillet of carp meat"
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
	center_of_mass = list("x"=17, "y"=13)

	var/toxin_type = "carpotoxin"
	var/toxin_amount = 3

/obj/item/reagent_containers/food/snacks/carpmeat/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)
	reagents.add_reagent(toxin_type, toxin_amount)
	src.bitesize = 6

/obj/item/reagent_containers/food/snacks/carpmeat/sif
	desc = "A fillet of sivian fish meat."
	filling_color = "#2c2cff"
	color = "#2c2cff"
	toxin_type = "neurotoxic_protein"
	toxin_amount = 2

/obj/item/reagent_containers/food/snacks/carpmeat/sif/murkfish
	toxin_type = "murk_protein"

/obj/item/reagent_containers/food/snacks/carpmeat/fish // Removed toxin and added a bit more oomph
	desc = "A fillet of fish meat."
	nutriment_amt = 2

/obj/item/reagent_containers/food/snacks/carpmeat/fish/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/fishfingers
	name = "Fish Fingers"
	desc = "A finger of fish."
	icon_state = "fishfingers"
	filling_color = "#FFDEFE"

/obj/item/reagent_containers/food/snacks/fishfingers/Initialize()
	. = ..()
	reagents.add_reagent("protein", 9)
	reagents.add_reagent("carpotoxin", 3)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/hugemushroomslice // Buff 3 >> 5
	name = "huge mushroom slice"
	desc = "A slice from a huge mushroom."
	icon_state = "hugemushroomslice"
	filling_color = "#E0D7C5"
	nutriment_amt = 5
	nutriment_desc = list("raw" = 2, "mushroom" = 2)

/obj/item/reagent_containers/food/snacks/hugemushroomslice/Initialize()
	. = ..()
	reagents.add_reagent("psilocybin", 3)
	src.bitesize = 6

/obj/item/reagent_containers/food/snacks/tomatomeat
	name = "tomato slice"
	desc = "A slice from a huge tomato"
	icon_state = "tomatomeat"
	filling_color = "#DB0000"
	nutriment_amt = 3
	nutriment_desc = list("raw" = 2, "tomato" = 3)

/obj/item/reagent_containers/food/snacks/tomatomeat/Initialize()
	. = ..()
	src.bitesize = 6

/obj/item/reagent_containers/food/snacks/bearmeat // Buff 12 >> 17
	name = "bear meat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	filling_color = "#DB0000"

/obj/item/reagent_containers/food/snacks/bearmeat/Initialize()
	. = ..()
	reagents.add_reagent("protein", 17)
	reagents.add_reagent("hyperzine", 5)
	src.bitesize = 3

/obj/item/reagent_containers/food/snacks/xenomeat // Buff 6 >> 10
	name = "xenomeat"
	desc = "A slab of green meat. Smells like acid."
	icon_state = "xenomeat"
	filling_color = "#43DE18"

/obj/item/reagent_containers/food/snacks/xenomeat/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)
	reagents.add_reagent("pacid",6)
	src.bitesize = 6

/obj/item/reagent_containers/food/snacks/xenomeat/spidermeat // Substitute for recipes requiring xeno meat.
	name = "spider meat"
	desc = "A slab of green meat."
	icon_state = "xenomeat"
	filling_color = "#43DE18"

/obj/item/reagent_containers/food/snacks/xenomeat/spidermeat/Initialize()
	. = ..()
	reagents.add_reagent("spidertoxin",6)
	reagents.remove_reagent("pacid",6)
	src.bitesize = 6

/obj/item/reagent_containers/food/snacks/meatball // Buff 3 >> 4
	name = "meatball"
	desc = "A great meal all round."
	icon_state = "meatball"
	filling_color = "#DB0000"

/obj/item/reagent_containers/food/snacks/meatball/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sausage // Buff 6 >> 9
	name = "Sausage"
	desc = "A piece of mixed, long meat."
	icon_state = "sausage"
	filling_color = "#DB0000"

/obj/item/reagent_containers/food/snacks/sausage/Initialize()
	. = ..()
	reagents.add_reagent("protein", 9)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/donkpocket
	name = "Donk-pocket"
	desc = "The food of choice for the seasoned traitor."
	icon_state = "donkpocket"
	filling_color = "#DEDEAB"
	var/warm
	var/list/heated_reagents

/obj/item/reagent_containers/food/snacks/donkpocket/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 2)
	reagents.add_reagent("protein", 2)

	warm = 0
	heated_reagents = list("tricordrazine" = 5)

/obj/item/reagent_containers/food/snacks/donkpocket/proc/heat()
	warm = 1
	for(var/reagent in heated_reagents)
		reagents.add_reagent(reagent, heated_reagents[reagent])
	bitesize = 6
	name = "Warm " + name
	cooltime()

/obj/item/reagent_containers/food/snacks/donkpocket/proc/cooltime()
	if (src.warm)
		spawn(4200)
			src.warm = 0
			for(var/reagent in heated_reagents)
				src.reagents.del_reagent(reagent)
			src.name = initial(name)
	return

/obj/item/reagent_containers/food/snacks/donkpocket/sinpocket
	name = "\improper Sin-pocket"
	desc = "The food of choice for the veteran. Do <B>NOT</B> overconsume."
	filling_color = "#6D6D00"
	heated_reagents = list("doctorsdelight" = 5, "hyperzine" = 0.75, "synaptizine" = 0.25)
	var/has_been_heated = 0

/obj/item/reagent_containers/food/snacks/donkpocket/sinpocket/attack_self(mob/user)
	if(has_been_heated)
		to_chat(user, "<span class='notice'>The heating chemicals have already been spent.</span>")
		return
	has_been_heated = 1
	user.visible_message("<span class='notice'>[user] crushes \the [src] package.</span>", "You crush \the [src] package and feel a comfortable heat build up.")
	spawn(200)
		to_chat(user, "You think \the [src] is ready to eat about now.")
		heat()

/obj/item/reagent_containers/food/snacks/brainburger
	name = "brainburger"
	desc = "A strange looking burger. It looks almost sentient."
	icon_state = "brainburger"
	filling_color = "#F2B6EA"

/obj/item/reagent_containers/food/snacks/brainburger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("alkysine", 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/ghostburger
	name = "Ghost Burger"
	desc = "Spooky! It doesn't look very filling."
	icon_state = "ghostburger"
	filling_color = "#FFF2FF"
	nutriment_desc = list("buns" = 3, "spookiness" = 3)
	nutriment_amt = 2

/obj/item/reagent_containers/food/snacks/ghostburger/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/human
	var/hname = ""
	var/job = null
	filling_color = "#D63C3C"

/obj/item/reagent_containers/food/snacks/human/burger
	name = "-burger"
	desc = "A bloody burger."
	icon_state = "hburger"

/obj/item/reagent_containers/food/snacks/human/burger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cheeseburger // Buff 4 >> 19
	name = "cheeseburger"
	desc = "The cheese adds a good flavor."
	icon_state = "cheeseburger"
	nutriment_amt = 10
	nutriment_desc = list("cheese" = 2, "bun" = 2)

/obj/item/reagent_containers/food/snacks/cheeseburger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/monkeyburger // Buff 6 >> 15
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon_state = "hburger"
	filling_color = "#D63C3C"
	nutriment_amt = 7
	nutriment_desc = list("bun" = 2)

/obj/item/reagent_containers/food/snacks/monkeyburger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/fishburger // Buff 6 >> 15
	name = "Fillet -o- Carp Sandwich"
	desc = "Almost like a carp is yelling somewhere... Give me back that fillet -o- carp, give me that carp."
	icon_state = "fishburger"
	filling_color = "#FFDEFE"

/obj/item/reagent_containers/food/snacks/fishburger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 15)
	reagents.add_reagent("carpotoxin", 3)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/tofuburger // Buff 6 >> 10
	name = "Tofu Burger"
	desc = "What.. is that meat?"
	icon_state = "tofuburger"
	filling_color = "#FFFEE0"
	nutriment_amt = 10
	nutriment_desc = list("bun" = 2, "pseudo-soy meat" = 3)

/obj/item/reagent_containers/food/snacks/tofuburger/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/roburger
	name = "roburger"
	desc = "The lettuce is the only organic component. Beep."
	icon_state = "roburger"
	filling_color = "#CCCCCC"
	nutriment_amt = 2
	nutriment_desc = list("bun" = 2, "metal" = 3)

/obj/item/reagent_containers/food/snacks/roburger/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/roburgerbig
	name = "roburger"
	desc = "This massive patty looks like poison. Beep."
	icon_state = "roburger"
	filling_color = "#CCCCCC"
	volume = 100

/obj/item/reagent_containers/food/snacks/roburgerbig/Initialize()
	. = ..()
	bitesize = 0.1

/obj/item/reagent_containers/food/snacks/xenoburger
	name = "xenoburger"
	desc = "Smells caustic. Tastes like heresy."
	icon_state = "xburger"
	filling_color = "#43DE18"

/obj/item/reagent_containers/food/snacks/xenoburger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/clownburger
	name = "Clown Burger"
	desc = "This tastes funny..."
	icon_state = "clownburger"
	filling_color = "#FF00FF"
	nutriment_amt = 6
	nutriment_desc = list("bun" = 2, "clown shoe" = 3)

/obj/item/reagent_containers/food/snacks/clownburger/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/mimeburger
	name = "Mime Burger"
	desc = "Its taste defies language."
	icon_state = "mimeburger"
	filling_color = "#FFFFFF"
	nutriment_amt = 6
	nutriment_desc = list("bun" = 2, "face paint" = 3)

/obj/item/reagent_containers/food/snacks/mimeburger/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/omelette // Buff 8 >> 14
	name = "Omelette Du Fromage"
	desc = "That's all you can say!"
	icon_state = "omelette"
	nutriment_amt = 4
	trash = /obj/item/trash/plate
	filling_color = "#FFF9A8"

/obj/item/reagent_containers/food/snacks/omelette/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/muffin
	name = "Muffin"
	desc = "A delicious and spongy little cake"
	icon_state = "muffin"
	filling_color = "#E0CF9B"
	nutriment_amt = 6
	nutriment_desc = list("sweetness" = 3, "muffin" = 3)

/obj/item/reagent_containers/food/snacks/muffin/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/pie // Buff 9 >> 12
	name = "Banana Cream Pie"
	desc = "Just like back home, on clown planet! HONK!"
	icon_state = "pie"
	trash = /obj/item/trash/plate
	filling_color = "#FBFFB8"
	nutriment_amt = 7
	nutriment_desc = list("pie" = 3, "cream" = 2)

/obj/item/reagent_containers/food/snacks/pie/Initialize()
	. = ..()
	reagents.add_reagent("banana",5)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/pie/throw_impact(atom/hit_atom)
	. = ..()
	new/obj/effect/decal/cleanable/pie_smudge(src.loc)
	src.visible_message("<span class='danger'>\The [src.name] splats.</span>","<span class='danger'>You hear a splat.</span>")
	qdel(src)

/obj/item/reagent_containers/food/snacks/berryclafoutis
	name = "Berry Clafoutis"
	desc = "No black birds, this is a good sign."
	icon_state = "berryclafoutis"
	trash = /obj/item/trash/plate
	nutriment_amt = 4
	nutriment_desc = list("sweetness" = 2, "pie" = 3)

/obj/item/reagent_containers/food/snacks/berryclafoutis/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 5)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/waffles // Buff 8 >> 10
	name = "waffles"
	desc = "Mmm, waffles"
	icon_state = "waffles"
	trash = /obj/item/trash/waffles
	filling_color = "#E6DEB5"
	nutriment_amt = 10
	nutriment_desc = list("waffle" = 10)

/obj/item/reagent_containers/food/snacks/waffles/Initialize()
	. = ..()
	bitesize = 3

/obj/item/reagent_containers/food/snacks/eggplantparm // Buff 6 >> 9
	name = "Eggplant Parmigiana"
	desc = "The only good recipe for eggplant."
	icon_state = "eggplantparm"
	trash = /obj/item/trash/plate
	filling_color = "#4D2F5E"
	nutriment_amt = 9
	nutriment_desc = list("cheese" = 3, "eggplant" = 3)

/obj/item/reagent_containers/food/snacks/eggplantparm/Initialize()
	. = ..()
	bitesize = 3

/obj/item/reagent_containers/food/snacks/soylentgreen
	name = "Soylent Green"
	desc = "Not made of people. Honest." //Totally people.
	icon_state = "soylent_green"
	trash = /obj/item/trash/waffles
	filling_color = "#B8E6B5"

/obj/item/reagent_containers/food/snacks/soylentgreen/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/soylenviridians
	name = "Soylen Virdians"
	desc = "Not made of people. Honest." //Actually honest for once.
	icon_state = "soylent_yellow"
	trash = /obj/item/trash/waffles
	filling_color = "#E6FA61"
	nutriment_amt = 10
	nutriment_desc = list("some sort of protein" = 10)  //seasoned VERY well.

/obj/item/reagent_containers/food/snacks/soylenviridians/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatpie // Buff 10 >> 15
	name = "Meat-pie"
	icon_state = "meatpie"
	desc = "An old barber recipe, very delicious!"
	nutriment_amt = 3
	trash = /obj/item/trash/plate
	filling_color = "#948051"

/obj/item/reagent_containers/food/snacks/meatpie/Initialize()
	. = ..()
	reagents.add_reagent("protein", 12)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/tofupie // Buff 10 >> 13
	name = "Tofu-pie"
	icon_state = "meatpie"
	desc = "A delicious tofu pie."
	trash = /obj/item/trash/plate
	filling_color = "#FFFEE0"
	nutriment_amt = 13
	nutriment_desc = list("tofu" = 4, "pie" = 9)

/obj/item/reagent_containers/food/snacks/tofupie/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/amanita_pie
	name = "amanita pie"
	desc = "Sweet and tasty poison pie."
	icon_state = "amanita_pie"
	filling_color = "#FFCCCC"
	nutriment_amt = 5
	nutriment_desc = list("sweetness" = 3, "mushroom" = 3, "pie" = 2)

/obj/item/reagent_containers/food/snacks/amanita_pie/Initialize()
	. = ..()
	reagents.add_reagent("amatoxin", 3)
	reagents.add_reagent("psilocybin", 1)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/plump_pie // Buff 8 >> 12
	name = "plump pie"
	desc = "I bet you love stuff made out of plump helmets!"
	icon_state = "plump_pie"
	filling_color = "#B8279B"
	nutriment_amt = 12
	nutriment_desc = list("heartiness" = 3, "mushroom" = 5, "pie" = 4)

/obj/item/reagent_containers/food/snacks/plump_pie/Initialize()
	. = ..()
	if(prob(10))
		name = "exceptional plump pie"
		desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump pie!"
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("tricordrazine", 5)
		bitesize = 2
	else
		bitesize = 2

/obj/item/reagent_containers/food/snacks/xemeatpie
	name = "Xeno-pie"
	icon_state = "xenomeatpie"
	desc = "A delicious meatpie. Probably heretical."
	trash = /obj/item/trash/plate
	filling_color = "#43DE18"

/obj/item/reagent_containers/food/snacks/xemeatpie/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/wingfangchu
	name = "Wing Fang Chu"
	desc = "A savory dish of alien wing wang in soy."
	icon_state = "wingfangchu"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#43DE18"

/obj/item/reagent_containers/food/snacks/wingfangchu/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/human/kabob
	name = "-kabob"
	icon_state = "kabob"
	desc = "A human meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#A85340"

/obj/item/reagent_containers/food/snacks/human/kabob/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/monkeykabob
	name = "Meat-kabob"
	icon_state = "kabob"
	desc = "Delicious meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#A85340"

/obj/item/reagent_containers/food/snacks/monkeykabob/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/tofukabob
	name = "Tofu-kabob"
	icon_state = "kabob"
	desc = "Vegan meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#FFFEE0"
	nutriment_amt = 8
	nutriment_desc = list("tofu" = 3, "metal" = 1)

/obj/item/reagent_containers/food/snacks/tofukabob/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cubancarp // Buff 6 >> 12
	name = "Cuban Carp"
	desc = "A sandwich that burns your tongue and then leaves it numb!"
	icon_state = "cubancarp"
	trash = /obj/item/trash/plate
	filling_color = "#E9ADFF"
	nutriment_amt = 3
	nutriment_desc = list("toasted bread" = 3)

/obj/item/reagent_containers/food/snacks/cubancarp/Initialize()
	. = ..()
	reagents.add_reagent("protein", 9)
	reagents.add_reagent("carpotoxin", 3)
	reagents.add_reagent("capsaicin", 3)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/popcorn
	name = "Popcorn"
	desc = "Now let's find some cinema."
	icon_state = "popcorn"
	trash = /obj/item/trash/popcorn
	var/unpopped = 0
	filling_color = "#FFFAD4"
	nutriment_amt = 2
	nutriment_desc = list("popcorn" = 3)


/obj/item/reagent_containers/food/snacks/popcorn/Initialize()
	. = ..()
	unpopped = rand(1,10)
	bitesize = 0.1 //this snack is supposed to be eating during looooong time. And this it not dinner food! --rastaf0

/obj/item/reagent_containers/food/snacks/popcorn/On_Consume()
	if(prob(unpopped))	//lol ...what's the point?
		to_chat(usr, "<font color='red'>You bite down on an un-popped kernel!</font>")
		unpopped = max(0, unpopped-1)
	. = ..()

/obj/item/reagent_containers/food/snacks/sosjerky // Buff 4 >> 8
	name = "Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"
	desc = "Beef jerky made from the finest space cows."
	trash = /obj/item/trash/sosjerky
	filling_color = "#631212"

/obj/item/reagent_containers/food/snacks/sosjerky/Initialize()
		. = ..()
		reagents.add_reagent("protein", 8)
		bitesize = 4

/obj/item/reagent_containers/food/snacks/no_raisin // Buff 6 >> 12
	name = "4no Raisins"
	icon_state = "4no_raisins"
	desc = "Best raisins in the universe. Not sure why."
	trash = /obj/item/trash/raisins
	filling_color = "#343834"
	nutriment_amt = 12
	nutriment_desc = list("dried raisins" = 6)

/obj/item/reagent_containers/food/snacks/no_raisin/Initialize()
	. = ..()
	bitesize = 3

/obj/item/reagent_containers/food/snacks/spacetwinkie // Buff 4 >> 6
	name = "Space Twinkie"
	icon_state = "space_twinkie"
	desc = "Guaranteed to survive longer then you will."
	filling_color = "#FFE591"

/obj/item/reagent_containers/food/snacks/spacetwinkie/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cheesiehonkers // Buff 4 >> 6
	name = "Cheesie Honkers"
	icon_state = "cheesie_honkers"
	desc = "Bite sized cheesie snacks that will honk all over your mouth"
	trash = /obj/item/trash/cheesie
	filling_color = "#FFA305"
	nutriment_amt = 6
	nutriment_desc = list("cheese" = 5, "chips" = 2)

/obj/item/reagent_containers/food/snacks/cheesiehonkers/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/syndicake // Buff 4 >> 5 (Contains Dr.'s Delight already
	name = "Syndi-Cakes"
	icon_state = "syndi_cakes"
	desc = "An extremely moist snack cake that tastes just as good after being nuked."
	filling_color = "#FF5D05"
	trash = /obj/item/trash/syndi_cakes
	nutriment_amt = 5
	nutriment_desc = list("sweetness" = 3, "cake" = 1)

/obj/item/reagent_containers/food/snacks/syndicake/Initialize()
	. = ..()
	reagents.add_reagent("doctorsdelight", 5)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/loadedbakedpotato // Buff 6 >> 10
	name = "Loaded Baked Potato"
	desc = "Totally baked."
	icon_state = "loadedbakedpotato"
	filling_color = "#9C7A68"
	nutriment_amt = 4
	nutriment_desc = list("baked potato" = 4)

/obj/item/reagent_containers/food/snacks/loadedbakedpotato/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/fries // Buff 4 >> 6
	name = "Space Fries"
	desc = "AKA: French Fries, Freedom Fries, etc."
	icon_state = "fries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	nutriment_amt = 6
	nutriment_desc = list("fresh fries" = 4)

/obj/item/reagent_containers/food/snacks/fries/Initialize()
	. = ..()
	bitesize = 3

/obj/item/reagent_containers/food/snacks/mashedpotato // Buff 4 >> 7
	name = "Mashed Potato"
	desc = "Pillowy mounds of mashed potato."
	icon_state = "mashedpotato"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	nutriment_amt = 7
	nutriment_desc = list("fluffy mashed potatoes" = 4)

/obj/item/reagent_containers/food/snacks/mashedpotato/Initialize()
	. = ..()
	bitesize = 3

/obj/item/reagent_containers/food/snacks/bangersandmash // Buff 7 >> 12
	name = "Bangers and Mash"
	desc = "An English treat."
	icon_state = "bangersandmash"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 5
	nutriment_desc = list("fluffy potato" = 3, "sausage" = 2)

/obj/item/reagent_containers/food/snacks/bangersandmash/Initialize()
	. = ..()
	reagents.add_reagent("protein", 7)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/cheesymash // Buff 7 >> 12
	name = "Cheesy Mashed Potato"
	desc = "The only thing that could make mash better."
	icon_state = "cheesymash"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 7
	nutriment_desc = list("cheesy potato" = 4)

/obj/item/reagent_containers/food/snacks/cheesymash/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/blackpudding
	name = "Black Pudding"
	desc = "This doesn't seem like a pudding at all."
	icon_state = "blackpudding"
	filling_color = "#FF0000"
	center_of_mass = list("x"=16, "y"=7)

/obj/item/reagent_containers/food/snacks/blackpudding/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)
	reagents.add_reagent("blood", 5)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/soydope
	name = "Soy Dope"
	desc = "Dope from a soy."
	icon_state = "soydope"
	trash = /obj/item/trash/plate
	filling_color = "#C4BF76"
	nutriment_amt = 2
	nutriment_desc = list("slime" = 2, "soy" = 2)

/obj/item/reagent_containers/food/snacks/soydope/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/spagetti // Buff 1 >> 2
	name = "Spaghetti"
	desc = "A bundle of raw spaghetti."
	icon_state = "spagetti"
	filling_color = "#EDDD00"
	nutriment_amt = 2
	nutriment_desc = list("noodles" = 2)

/obj/item/reagent_containers/food/snacks/spagetti/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cheesyfries // Buff 6 >> 8
	name = "Cheesy Fries"
	desc = "Fries. Covered in cheese. Duh."
	icon_state = "cheesyfries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	nutriment_amt = 4
	nutriment_desc = list("fresh fries" = 3, "cheese" = 3)

/obj/item/reagent_containers/food/snacks/cheesyfries/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/fortunecookie
	name = "Fortune cookie"
	desc = "A true prophecy in each cookie!"
	icon_state = "fortune_cookie"
	filling_color = "#E8E79E"
	nutriment_amt = 3
	nutriment_desc = list("fortune cookie" = 2)

/obj/item/reagent_containers/food/snacks/fortunecookie/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/badrecipe
	name = "Burned mess"
	desc = "Someone should be demoted from chef for this."
	icon_state = "badrecipe"
	filling_color = "#211F02"

/obj/item/reagent_containers/food/snacks/badrecipe/Initialize()
	. = ..()
	reagents.add_reagent("toxin", 1)
	reagents.add_reagent("carbon", 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatsteak // Buff 4 >> 9
	name = "Meat steak"
	desc = "A piece of hot spicy meat."
	icon_state = "meatstake"
	trash = /obj/item/trash/plate
	filling_color = "#7A3D11"

/obj/item/reagent_containers/food/snacks/meatsteak/Initialize()
	. = ..()
	reagents.add_reagent("protein", 9)
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("blackpepper", 1)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/spacylibertyduff // Buff 6 >> 8
	name = "Spacy Liberty Duff"
	desc = "Jello gelatin, from Alfred Hubbard's cookbook"
	icon_state = "spacylibertyduff"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#42B873"
	nutriment_amt = 8
	nutriment_desc = list("mushroom" = 6)

/obj/item/reagent_containers/food/snacks/spacylibertyduff/Initialize()
	. = ..()
	reagents.add_reagent("psilocybin", 6)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/amanitajelly
	name = "Amanita Jelly"
	desc = "Looks curiously toxic."
	icon_state = "amanitajelly"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#ED0758"
	nutriment_amt = 6
	nutriment_desc = list("jelly" = 3, "mushroom" = 3)

/obj/item/reagent_containers/food/snacks/amanitajelly/Initialize()
	. = ..()
	reagents.add_reagent("amatoxin", 6)
	reagents.add_reagent("psilocybin", 3)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/poppypretzel // Buff 5 >> 7
	name = "Poppy pretzel"
	desc = "It's all twisted up!"
	icon_state = "poppypretzel"
	filling_color = "#916E36"
	nutriment_amt = 7
	nutriment_desc = list("poppy seeds" = 2, "pretzel" = 3)

/obj/item/reagent_containers/food/snacks/poppypretzel/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatballsoup // Buff 8 >> 10
	name = "Meatball soup"
	desc = "You've got balls kid, BALLS!"
	icon_state = "meatballsoup"
	nutriment_amt = 2
	trash = /obj/item/trash/snack_bowl
	filling_color = "#785210"

/obj/item/reagent_containers/food/snacks/meatballsoup/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)
	reagents.add_reagent("water", 5)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/slimesoup
	name = "slime soup"
	desc = "If no water is available, you may substitute tears."
	icon_state = "slimesoup"
	filling_color = "#C4DBA0"

/obj/item/reagent_containers/food/snacks/slimesoup/Initialize()
	. = ..()
	reagents.add_reagent("slimejelly", 5)
	reagents.add_reagent("water", 10)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/bloodsoup
	name = "Tomato soup"
	desc = "Smells like copper."
	icon_state = "tomatosoup"
	filling_color = "#FF0000"

/obj/item/reagent_containers/food/snacks/bloodsoup/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)
	reagents.add_reagent("blood", 10)
	reagents.add_reagent("water", 5)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/clownstears
	name = "Clown's Tears"
	desc = "Not very funny."
	icon_state = "clownstears"
	filling_color = "#C4FBFF"
	nutriment_amt = 4
	nutriment_desc = list("salt" = 1, "the worst joke" = 3)

/obj/item/reagent_containers/food/snacks/clownstears/Initialize()
	. = ..()
	reagents.add_reagent("banana", 5)
	reagents.add_reagent("water", 10)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/vegetablesoup // Buff 8 >> 10
	name = "Vegetable soup"
	desc = "A true vegan meal." //TODO
	icon_state = "vegetablesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#AFC4B5"
	nutriment_amt = 10
	nutriment_desc = list("carot" = 2, "corn" = 2, "eggplant" = 2, "potato" = 2)

/obj/item/reagent_containers/food/snacks/vegetablesoup/Initialize()
	. = ..()
	reagents.add_reagent("water", 5)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/nettlesoup
	name = "Nettle soup"
	desc = "To think, the botanist would've beat you to death with one of these."
	icon_state = "nettlesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#AFC4B5"
	nutriment_amt = 8
	nutriment_desc = list("salad" = 4, "egg" = 2, "potato" = 2)

/obj/item/reagent_containers/food/snacks/nettlesoup/Initialize()
	. = ..()
	reagents.add_reagent("water", 5)
	reagents.add_reagent("tricordrazine", 5)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/mysterysoup
	name = "Mystery soup"
	desc = "The mystery is, why aren't you eating it?"
	icon_state = "mysterysoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#F082FF"
	nutriment_amt = 1
	nutriment_desc = list("backwash" = 1)

/obj/item/reagent_containers/food/snacks/mysterysoup/Initialize()
	. = ..()
	var/mysteryselect = pick(1,2,3,4,5,6,7,8,9,10)
	switch(mysteryselect)
		if(1)
			reagents.add_reagent("nutriment", 6)
			reagents.add_reagent("capsaicin", 3)
			reagents.add_reagent("tomatojuice", 2)
		if(2)
			reagents.add_reagent("nutriment", 6)
			reagents.add_reagent("frostoil", 3)
			reagents.add_reagent("tomatojuice", 2)
		if(3)
			reagents.add_reagent("nutriment", 5)
			reagents.add_reagent("water", 5)
			reagents.add_reagent("tricordrazine", 5)
		if(4)
			reagents.add_reagent("nutriment", 5)
			reagents.add_reagent("water", 10)
		if(5)
			reagents.add_reagent("nutriment", 2)
			reagents.add_reagent("banana", 10)
		if(6)
			reagents.add_reagent("nutriment", 6)
			reagents.add_reagent("blood", 10)
		if(7)
			reagents.add_reagent("slimejelly", 10)
			reagents.add_reagent("water", 10)
		if(8)
			reagents.add_reagent("carbon", 10)
			reagents.add_reagent("toxin", 10)
		if(9)
			reagents.add_reagent("nutriment", 5)
			reagents.add_reagent("tomatojuice", 10)
		if(10)
			reagents.add_reagent("nutriment", 6)
			reagents.add_reagent("tomatojuice", 5)
			reagents.add_reagent("imidazoline", 5)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/wishsoup
	name = "Wish Soup"
	desc = "I wish this was soup."
	icon_state = "wishsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#D1F4FF"

/obj/item/reagent_containers/food/snacks/wishsoup/Initialize()
	. = ..()
	reagents.add_reagent("water", 10)
	bitesize = 5
	if(prob(25))
		src.desc = "A wish come true!"
		reagents.add_reagent("nutriment", 8, list("something good" = 8))

/obj/item/reagent_containers/food/snacks/hotchili // Buff 6 >> 10
	name = "Hot Chili"
	desc = "A five alarm Texan Chili!"
	icon_state = "hotchili"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FF3C00"
	nutriment_amt = 5
	nutriment_desc = list("chilli peppers" = 5)

/obj/item/reagent_containers/food/snacks/hotchili/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)
	reagents.add_reagent("capsaicin", 3)
	reagents.add_reagent("tomatojuice", 2)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/coldchili
	name = "Cold Chili"
	desc = "This slush is barely a liquid!"
	icon_state = "coldchili"
	filling_color = "#2B00FF"
	trash = /obj/item/trash/snack_bowl
	nutriment_amt = 3
	nutriment_desc = list("ice peppers" = 3)

/obj/item/reagent_containers/food/snacks/coldchili/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)
	reagents.add_reagent("frostoil", 3)
	reagents.add_reagent("tomatojuice", 2)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/monkeycube
	name = "monkey cube"
	desc = "Just add water!"
	flags = OPENCONTAINER
	icon_state = "monkeycube"
	bitesize = 12
	filling_color = "#ADAC7F"

	var/wrapped = 0
	var/monkey_type = "Monkey"

/obj/item/reagent_containers/food/snacks/monkeycube/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)

/obj/item/reagent_containers/food/snacks/monkeycube/attack_self(mob/user as mob)
	if(wrapped)
		Unwrap(user)

/obj/item/reagent_containers/food/snacks/monkeycube/proc/Expand()
	src.visible_message("<span class='notice'>\The [src] expands!</span>")
	var/mob/living/carbon/human/H = new(get_turf(src))
	H.set_species(monkey_type)
	H.real_name = H.species.get_random_name()
	H.name = H.real_name
	if(ismob(loc))
		var/mob/M = loc
		M.unEquip(src)
	qdel(src)
	return 1

/obj/item/reagent_containers/food/snacks/monkeycube/proc/Unwrap(mob/user as mob)
	icon_state = "monkeycube"
	desc = "Just add water!"
	to_chat(user, "You unwrap the cube.")
	wrapped = 0
	flags |= OPENCONTAINER
	return

/obj/item/reagent_containers/food/snacks/monkeycube/On_Consume(var/mob/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.visible_message("<span class='warning'>A screeching creature bursts out of [M]'s chest!</span>")
		var/obj/item/organ/external/organ = H.get_organ(BP_TORSO)
		organ.take_damage(50, 0, 0, "Animal escaping the ribcage")
	Expand()

/obj/item/reagent_containers/food/snacks/monkeycube/on_reagent_change()
	if(reagents.has_reagent("water"))
		Expand()

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped
	desc = "Still wrapped in some paper."
	icon_state = "monkeycubewrap"
	flags = 0
	wrapped = 1

/obj/item/reagent_containers/food/snacks/monkeycube/farwacube
	name = "farwa cube"
	monkey_type = "Farwa"

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/farwacube
	name = "farwa cube"
	monkey_type = "Farwa"

/obj/item/reagent_containers/food/snacks/monkeycube/stokcube
	name = "stok cube"
	monkey_type = "Stok"

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/stokcube
	name = "stok cube"
	monkey_type = "Stok"

/obj/item/reagent_containers/food/snacks/monkeycube/neaeracube
	name = "neaera cube"
	monkey_type = "Neaera"

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube
	name = "neaera cube"
	monkey_type = "Neaera"

/obj/item/reagent_containers/food/snacks/spellburger
	name = "Spell Burger"
	desc = "This is absolutely Ei Nath."
	icon_state = "spellburger"
	filling_color = "#D505FF"
	nutriment_amt = 6
	nutriment_desc = list("magic" = 3, "buns" = 3)

/obj/item/reagent_containers/food/snacks/spellburger/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bigbiteburger // Buff 14 >> 25
	name = "Big Bite Burger"
	desc = "Forget the Big Mac. THIS is the future!"
	icon_state = "bigbiteburger"
	filling_color = "#E3D681"
	nutriment_amt = 6
	nutriment_desc = list("buns" = 4)

/obj/item/reagent_containers/food/snacks/bigbiteburger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 19)
	bitesize = 8

/obj/item/reagent_containers/food/snacks/enchiladas // Buff 8 >> 12
	name = "Enchiladas"
	desc = "Viva La Mexico!"
	icon_state = "enchiladas"
	trash = /obj/item/trash/tray
	filling_color = "#A36A1F"
	nutriment_amt = 4
	nutriment_desc = list("tortilla" = 3, "corn" = 3)

/obj/item/reagent_containers/food/snacks/enchiladas/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)
	reagents.add_reagent("capsaicin", 6)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/monkeysdelight
	name = "monkey's Delight"
	desc = "Eeee Eee!"
	icon_state = "monkeysdelight"
	trash = /obj/item/trash/tray
	filling_color = "#5C3C11"

/obj/item/reagent_containers/food/snacks/monkeysdelight/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)
	reagents.add_reagent("banana", 5)
	reagents.add_reagent("blackpepper", 1)
	reagents.add_reagent("sodiumchloride", 1)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/baguette
	name = "Baguette"
	desc = "Bon appetit!"
	icon_state = "baguette"
	filling_color = "#E3D796"
	nutriment_amt = 6
	nutriment_desc = list("french bread" = 6)

/obj/item/reagent_containers/food/snacks/baguette/Initialize()
	. = ..()
	reagents.add_reagent("blackpepper", 1)
	reagents.add_reagent("sodiumchloride", 1)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/fishandchips // Buff 6 >> 10
	name = "Fish and Chips"
	desc = "I do say so myself chap."
	icon_state = "fishandchips"
	filling_color = "#E3D796"
	nutriment_amt = 5
	nutriment_desc = list("salt" = 1, "chips" = 3)

/obj/item/reagent_containers/food/snacks/fishandchips/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)
	reagents.add_reagent("carpotoxin", 3)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sandwich // Buff 6 >> 11
	name = "Sandwich"
	desc = "A grand creation of meat, cheese, bread, and several leaves of lettuce! Arthur Dent would be proud."
	icon_state = "sandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"
	nutriment_amt = 6
	nutriment_desc = list("bread" = 3, "cheese" = 3)

/obj/item/reagent_containers/food/snacks/sandwich/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/toastedsandwich // Buff 6 >> 11
	name = "Toasted Sandwich"
	desc = "Now if you only had a pepper bar."
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"
	nutriment_amt = 6
	nutriment_desc = list("toasted bread" = 3, "cheese" = 3)

/obj/item/reagent_containers/food/snacks/toastedsandwich/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)
	reagents.add_reagent("carbon", 2)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/grilledcheese // Buff 7 >> 10
	name = "Grilled Cheese Sandwich"
	desc = "Goes great with Tomato soup!"
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"
	nutriment_amt = 5
	nutriment_desc = list("toasted bread" = 3, "cheese" = 3)

/obj/item/reagent_containers/food/snacks/grilledcheese/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/tomatosoup // Buff 5 >> 9
	name = "Tomato Soup"
	desc = "Drinking this feels like being a vampire! A tomato vampire..."
	icon_state = "tomatosoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#D92929"
	nutriment_amt = 9
	nutriment_desc = list("soup" = 5)

/obj/item/reagent_containers/food/snacks/tomatosoup/Initialize()
	. = ..()
	reagents.add_reagent("tomatojuice", 10)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/onionsoup // Buff 5 >> 9
	name = "Onion Soup"
	desc = "A soup with layers."
	icon_state = "onionsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#E0C367"
	nutriment_amt = 9
	nutriment_desc = list("onion" = 2, "soup" = 2)

/obj/item/reagent_containers/food/snacks/onionsoup/Initialize()
	. = ..()
	bitesize = 3

/obj/item/reagent_containers/food/snacks/onionrings
	name = "Onion Rings"
	desc = "Crispy rings."
	icon_state = "onionrings"
	trash = /obj/item/trash/plate
	filling_color = "#E0C367"
	nutriment_amt = 5
	nutriment_desc = list("onion" = 2)

/obj/item/reagent_containers/food/snacks/onionrings/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/rofflewaffles
	name = "Roffle Waffles"
	desc = "Waffles from Roffle. Co."
	icon_state = "rofflewaffles"
	trash = /obj/item/trash/waffles
	filling_color = "#FF00F7"
	nutriment_amt = 8
	nutriment_desc = list("waffle" = 7, "sweetness" = 1)

/obj/item/reagent_containers/food/snacks/rofflewaffles/Initialize()
	. = ..()
	reagents.add_reagent("psilocybin", 8)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/stew // Buff 10 >> 14
	name = "Stew"
	desc = "A nice and warm stew. Healthy and strong."
	icon_state = "stew"
	filling_color = "#9E673A"
	nutriment_amt = 6
	nutriment_desc = list("tomato" = 2, "potato" = 2, "carrot" = 2, "eggplant" = 2, "mushroom" = 2)
	drop_sound = 'sound/items/drop/shovel.ogg'
	pickup_sound = 'sound/items/pickup/shovel.ogg'

/obj/item/reagent_containers/food/snacks/stew/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)
	reagents.add_reagent("tomatojuice", 5)
	reagents.add_reagent("imidazoline", 5)
	reagents.add_reagent("water", 5)
	bitesize = 10

/obj/item/reagent_containers/food/snacks/jelliedtoast
	name = "Jellied Toast"
	desc = "A slice of bread covered with delicious jam."
	icon_state = "jellytoast"
	trash = /obj/item/trash/plate
	filling_color = "#B572AB"
	nutriment_amt = 1
	nutriment_desc = list("toasted bread" = 2)

/obj/item/reagent_containers/food/snacks/jelliedtoast/Initialize()
	. = ..()
	bitesize = 3

/obj/item/reagent_containers/food/snacks/jelliedtoast/cherry/Initialize()
	. = ..()
	reagents.add_reagent("cherryjelly", 5)

/obj/item/reagent_containers/food/snacks/jelliedtoast/slime/Initialize()
	. = ..()
	reagents.add_reagent("slimejelly", 5)

/obj/item/reagent_containers/food/snacks/jellyburger
	name = "Jelly Burger"
	desc = "Culinary delight..?"
	icon_state = "jellyburger"
	filling_color = "#B572AB"
	nutriment_amt = 5
	nutriment_desc = list("buns" = 5)

/obj/item/reagent_containers/food/snacks/jellyburger/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/jellyburger/slime/Initialize()
	. = ..()
	reagents.add_reagent("slimejelly", 5)

/obj/item/reagent_containers/food/snacks/jellyburger/cherry/Initialize()
	. = ..()
	reagents.add_reagent("cherryjelly", 5)

/obj/item/reagent_containers/food/snacks/milosoup // Buff 8 >> 10
	name = "Milosoup"
	desc = "The universes best soup! Yum!!!"
	icon_state = "milosoup"
	trash = /obj/item/trash/snack_bowl
	nutriment_amt = 10
	nutriment_desc = list("soy" = 8)

/obj/item/reagent_containers/food/snacks/milosoup/Initialize()
	. = ..()
	reagents.add_reagent("water", 5)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/stewedsoymeat // Buff 8 >> 11
	name = "Stewed Soy Meat"
	desc = "Even non-vegetarians will LOVE this!"
	icon_state = "stewedsoymeat"
	trash = /obj/item/trash/plate
	nutriment_amt = 11
	nutriment_desc = list("soy" = 4, "tomato" = 4)

/obj/item/reagent_containers/food/snacks/stewedsoymeat/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/boiledspagetti // Buff 2 >> 6
	name = "Boiled Spaghetti"
	desc = "A plain dish of noodles, this sucks."
	icon_state = "spagettiboiled"
	trash = /obj/item/trash/plate
	filling_color = "#FCEE81"
	nutriment_amt = 6
	nutriment_desc = list("noodles" = 2)

/obj/item/reagent_containers/food/snacks/boiledspagetti/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/boiledrice // Buff 2 >> 4
	name = "Boiled Rice"
	desc = "A boring dish of boring rice."
	icon_state = "boiledrice"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	nutriment_amt = 4
	nutriment_desc = list("rice" = 2)

/obj/item/reagent_containers/food/snacks/boiledrice/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/ricepudding // Buff 4 >> 5
	name = "Rice Pudding"
	desc = "Where's the jam?"
	icon_state = "rpudding"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	nutriment_amt = 5
	nutriment_desc = list("rice" = 2)

/obj/item/reagent_containers/food/snacks/ricepudding/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/pastatomato // Buff 6 >> 10
	name = "Spaghetti"
	desc = "Spaghetti and crushed tomatoes. Just like your abusive father used to make!"
	icon_state = "pastatomato"
	trash = /obj/item/trash/plate
	filling_color = "#DE4545"
	nutriment_amt = 10
	nutriment_desc = list("tomato" = 3, "noodles" = 3)

/obj/item/reagent_containers/food/snacks/pastatomato/Initialize()
	. = ..()
	reagents.add_reagent("tomatojuice", 10)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/meatballspagetti // Buff 8 >> 14
	name = "Spaghetti & Meatballs"
	desc = "Now thats a nic'e meatball!"
	icon_state = "meatballspagetti"
	trash = /obj/item/trash/plate
	filling_color = "#DE4545"
	nutriment_amt = 6
	nutriment_desc = list("noodles" = 4)

/obj/item/reagent_containers/food/snacks/meatballspagetti/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/spesslaw // Buff 8 >> 12
	name = "Spesslaw"
	desc = "A lawyers favourite"
	icon_state = "spesslaw"
	filling_color = "#DE4545"
	nutriment_amt = 6
	nutriment_desc = list("noodles" = 4)

/obj/item/reagent_containers/food/snacks/spesslaw/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/carrotfries // Buff 3 >> 5
	name = "Carrot Fries"
	desc = "Tasty fries from fresh Carrots."
	icon_state = "carrotfries"
	trash = /obj/item/trash/plate
	filling_color = "#FAA005"
	nutriment_amt = 5
	nutriment_desc = list("carrot" = 3, "salt" = 1)

/obj/item/reagent_containers/food/snacks/carrotfries/Initialize()
	. = ..()
	reagents.add_reagent("imidazoline", 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/superbiteburger // Balance (25 >> 15 Nutri / 25 >> 35 Protein)
	name = "Super Bite Burger"
	desc = "This is a mountain of a burger. FOOD!"
	icon_state = "superbiteburger"
	filling_color = "#CCA26A"
	nutriment_amt = 15
	nutriment_desc = list("buns" = 25)

/obj/item/reagent_containers/food/snacks/superbiteburger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 35)
	bitesize = 10

/obj/item/reagent_containers/food/snacks/candiedapple
	name = "Candied Apple"
	desc = "An apple coated in sugary sweetness."
	icon_state = "candiedapple"
	filling_color = "#F21873"
	nutriment_amt = 3
	nutriment_desc = list("apple" = 3, "caramel" = 3, "sweetness" = 2)

/obj/item/reagent_containers/food/snacks/candiedapple/Initialize()
	. = ..()
	bitesize = 3

/obj/item/reagent_containers/food/snacks/applepie // Buff 4 >> 9
	name = "Apple Pie"
	desc = "A pie containing sweet sweet love... or apple."
	icon_state = "applepie"
	filling_color = "#E0EDC5"
	nutriment_amt = 5
	nutriment_desc = list("sweetness" = 2, "apple" = 2, "pie" = 2)

/obj/item/reagent_containers/food/snacks/applepie/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 4)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cherrypie // Buff 4 >> 9
	name = "Cherry Pie"
	desc = "Taste so good, make a grown man cry."
	icon_state = "cherrypie"
	filling_color = "#FF525A"
	nutriment_amt = 5
	nutriment_desc = list("sweetness" = 2, "cherry" = 2, "pie" = 2)

/obj/item/reagent_containers/food/snacks/cherrypie/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 4)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/twobread
	name = "Two Bread"
	desc = "It is very bitter and winy."
	icon_state = "twobread"
	filling_color = "#DBCC9A"
	nutriment_amt = 2
	nutriment_desc = list("sourness" = 2, "bread" = 2)

/obj/item/reagent_containers/food/snacks/twobread/Initialize()
	. = ..()
	bitesize = 3

/obj/item/reagent_containers/food/snacks/jellysandwich // Buff 2 >> 6
	name = "Jelly Sandwich"
	desc = "You wish you had some peanut butter to go with this..."
	icon_state = "jellysandwich"
	trash = /obj/item/trash/plate
	filling_color = "#9E3A78"
	nutriment_amt = 3
	nutriment_desc = list("bread" = 2)

/obj/item/reagent_containers/food/snacks/jellysandwich/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 3)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/jellysandwich/slime/Initialize()
	. = ..()
	reagents.add_reagent("slimejelly", 5)

/obj/item/reagent_containers/food/snacks/jellysandwich/cherry/Initialize()
	. = ..()
	reagents.add_reagent("cherryjelly", 5)

/obj/item/reagent_containers/food/snacks/boiledslimecore
	name = "Boiled Slime Core"
	desc = "A boiled red thing."
	icon_state = "boiledslimecore"

/obj/item/reagent_containers/food/snacks/boiledslimecore/Initialize()
	. = ..()
	reagents.add_reagent("slimejelly", 5)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/mint
	name = "mint"
	desc = "it is only wafer thin."
	icon_state = "mint"
	filling_color = "#F2F2F2"

/obj/item/reagent_containers/food/snacks/mint/Initialize()
	. = ..()
	reagents.add_reagent("mint", 1)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/mushroomsoup
	name = "chantrelle soup"
	desc = "A delicious and hearty mushroom soup."
	icon_state = "mushroomsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#E386BF"
	nutriment_amt = 8
	nutriment_desc = list("mushroom" = 8, "milk" = 2)

/obj/item/reagent_containers/food/snacks/mushroomsoup/Initialize()
	. = ..()
	bitesize = 3

/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit
	name = "plump helmet biscuit"
	desc = "This is a finely-prepared plump helmet biscuit. The ingredients are exceptionally minced plump helmet, and well-minced dwarven wheat flour."
	icon_state = "phelmbiscuit"
	filling_color = "#CFB4C4"
	nutriment_amt = 5
	nutriment_desc = list("mushroom" = 4)

/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit/Initialize()
	. = ..()
	if(prob(10))
		name = "exceptional plump helmet biscuit"
		desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump helmet biscuit!"
		reagents.add_reagent("nutriment", 8)
		bitesize = 2
	else
		reagents.add_reagent("nutriment", 5)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/chawanmushi
	name = "chawanmushi"
	desc = "A legendary egg custard that makes friends out of enemies. Probably too hot for a cat to eat."
	icon_state = "chawanmushi"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#F0F2E4"

/obj/item/reagent_containers/food/snacks/chawanmushi/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/beetsoup // Buff 8 >> 10
	name = "beet soup"
	desc = "Wait, how do you spell it again..?"
	icon_state = "beetsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FAC9FF"
	nutriment_amt = 8
	nutriment_desc = list("tomato" = 4, "beet" = 4)

/obj/item/reagent_containers/food/snacks/beetsoup/Initialize()
	. = ..()
	name = pick(list("borsch","bortsch","borstch","borsh","borshch","borscht"))
	reagents.add_reagent("sugar", 2)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/tossedsalad // Buff 8 >> 10
	name = "tossed salad"
	desc = "A proper salad, basic and simple, with little bits of carrot, tomato and apple intermingled. Vegan!"
	icon_state = "herbsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76B87F"
	nutriment_amt = 10
	nutriment_desc = list("salad" = 2, "tomato" = 2, "carrot" = 2, "apple" = 2)

/obj/item/reagent_containers/food/snacks/tossedsalad/Initialize()
	. = ..()
	bitesize = 3

/obj/item/reagent_containers/food/snacks/validsalad // Buff 8 >> 12
	name = "valid salad"
	desc = "It's just a salad of questionable 'herbs' with meatballs and fried potato slices. Nothing suspicious about it."
	icon_state = "validsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76B87F"
	nutriment_amt = 8
	nutriment_desc = list("100% real salad")

/obj/item/reagent_containers/food/snacks/validsalad/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/appletart
	name = "golden apple streusel tart"
	desc = "A tasty dessert that won't make it through a metal detector."
	icon_state = "gappletart"
	trash = /obj/item/trash/plate
	filling_color = "#FFFF00"
	nutriment_amt = 8
	nutriment_desc = list("apple" = 8)

/obj/item/reagent_containers/food/snacks/appletart/Initialize()
	. = ..()
	reagents.add_reagent("gold", 5)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/worm
	name = "worm"
	desc = "It wiggles at the touch, bleh."
	icon_state = "worm"

/obj/item/reagent_containers/food/snacks/worm/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 4)
	bitesize = 4

/////////////////////////////////////////////////Sliceable////////////////////////////////////////
// All the food items that can be sliced into smaller bits like Meatbread and Cheesewheels

// sliceable is just an organization type path, it doesn't have any additional code or variables tied to it.

/obj/item/reagent_containers/food/snacks/sliceable
	w_class = ITEMSIZE_NORMAL //Whole pizzas and cakes shouldn't fit in a pocket, you can slice them if you want to do that.

/**
 *  A food item slice
 *
 *  This path contains some extra code for spawning slices pre-filled with
 *  reagents.
 */
/obj/item/reagent_containers/food/snacks/slice
	name = "slice of... something"
	var/whole_path  // path for the item from which this slice comes
	var/filled = FALSE  // should the slice spawn with any reagents

/**
 *  Spawn a new slice of food
 *
 *  If the slice's filled is TRUE, this will also fill the slice with the
 *  appropriate amount of reagents. Note that this is done by spawning a new
 *  whole item, transferring the reagents and deleting the whole item, which may
 *  have performance implications.
 */
/obj/item/reagent_containers/food/snacks/slice/Initialize()
	. = ..()
	if(filled)
		var/obj/item/reagent_containers/food/snacks/whole = new whole_path()
		if(whole && whole.slices_num)
			var/reagent_amount = whole.reagents.total_volume/whole.slices_num
			whole.reagents.trans_to_obj(src, reagent_amount)

		qdel(whole)

/obj/item/reagent_containers/food/snacks/sliceable/meatbread
	name = "meatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman."
	icon_state = "meatbread"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/meatbread
	slices_num = 5
	filling_color = "#FF7575"
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10

/obj/item/reagent_containers/food/snacks/sliceable/meatbread/Initialize()
	. = ..()
	reagents.add_reagent("protein", 20)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/meatbread
	name = "meatbread slice"
	desc = "A slice of delicious meatbread."
	icon_state = "meatbreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#FF7575"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/meatbread

/obj/item/reagent_containers/food/snacks/slice/meatbread/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread
	name = "xenomeatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman. Extra Heretical."
	icon_state = "xenomeatbread"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/xenomeatbread
	slices_num = 5
	filling_color = "#8AFF75"
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10

/obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread/Initialize()
	. = ..()
	reagents.add_reagent("protein", 20)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/xenomeatbread
	name = "xenomeatbread slice"
	desc = "A slice of delicious meatbread. Extra Heretical."
	icon_state = "xenobreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#8AFF75"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread


/obj/item/reagent_containers/food/snacks/slice/xenomeatbread/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/bananabread
	name = "Banana-nut bread"
	desc = "A heavenly and filling treat."
	icon_state = "bananabread"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/bananabread
	slices_num = 5
	filling_color = "#EDE5AD"
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10

/obj/item/reagent_containers/food/snacks/sliceable/bananabread/Initialize()
	. = ..()
	reagents.add_reagent("banana", 20)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/bananabread
	name = "Banana-nut bread slice"
	desc = "A slice of delicious banana bread."
	icon_state = "bananabreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#EDE5AD"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/bananabread

/obj/item/reagent_containers/food/snacks/slice/bananabread/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/tofubread
	name = "Tofubread"
	icon_state = "Like meatbread but for vegetarians. Not guaranteed to give superpowers."
	icon_state = "tofubread"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/tofubread
	slices_num = 5
	filling_color = "#F7FFE0"
	nutriment_desc = list("tofu" = 10)
	nutriment_amt = 10

/obj/item/reagent_containers/food/snacks/sliceable/tofubread/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/tofubread
	name = "Tofubread slice"
	desc = "A slice of delicious tofubread."
	icon_state = "tofubreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#F7FFE0"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/tofubread

/obj/item/reagent_containers/food/snacks/slice/tofubread/filled
	filled = TRUE


/obj/item/reagent_containers/food/snacks/sliceable/carrotcake
	name = "Carrot Cake"
	desc = "A favorite dessert of a certain wascally wabbit. Not a lie."
	icon_state = "carrotcake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/carrotcake
	slices_num = 5
	filling_color = "#FFD675"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "carrot" = 15)
	nutriment_amt = 25

/obj/item/reagent_containers/food/snacks/sliceable/carrotcake/Initialize()
	. = ..()
	reagents.add_reagent("imidazoline", 10)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/carrotcake
	name = "Carrot Cake slice"
	desc = "Carrotty slice of Carrot Cake, carrots are good for your eyes! Also not a lie."
	icon_state = "carrotcake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FFD675"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/carrotcake

/obj/item/reagent_containers/food/snacks/slice/carrotcake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/braincake
	name = "Brain Cake"
	desc = "A squishy cake-thing."
	icon_state = "braincake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/braincake
	slices_num = 5
	filling_color = "#E6AEDB"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "slime" = 15)
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/sliceable/braincake/Initialize()
	. = ..()
	reagents.add_reagent("protein", 25)
	reagents.add_reagent("alkysine", 10)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/braincake
	name = "Brain Cake slice"
	desc = "Lemme tell you something about prions. THEY'RE DELICIOUS."
	icon_state = "braincakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#E6AEDB"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/braincake

/obj/item/reagent_containers/food/snacks/slice/braincake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/cheesecake
	name = "Cheese Cake"
	desc = "DANGEROUSLY cheesy."
	icon_state = "cheesecake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/cheesecake
	slices_num = 5
	filling_color = "#FAF7AF"
	nutriment_desc = list("cake" = 10, "cream" = 10, "cheese" = 15)
	nutriment_amt = 10

/obj/item/reagent_containers/food/snacks/sliceable/cheesecake/Initialize()
	. = ..()
	reagents.add_reagent("protein", 15)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/cheesecake
	name = "Cheese Cake slice"
	desc = "Slice of pure cheestisfaction."
	icon_state = "cheesecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FAF7AF"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/cheesecake

/obj/item/reagent_containers/food/snacks/slice/cheesecake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/plaincake
	name = "Vanilla Cake"
	desc = "A plain cake, not a lie."
	icon_state = "plaincake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/plaincake
	slices_num = 5
	filling_color = "#F7EDD5"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "vanilla" = 15)
	nutriment_amt = 20

/obj/item/reagent_containers/food/snacks/slice/plaincake
	name = "Vanilla Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "plaincake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#F7EDD5"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/plaincake

/obj/item/reagent_containers/food/snacks/slice/plaincake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/orangecake
	name = "Orange Cake"
	desc = "A cake with added orange."
	icon_state = "orangecake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/orangecake
	slices_num = 5
	filling_color = "#FADA8E"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "orange" = 15)
	nutriment_amt = 20

/obj/item/reagent_containers/food/snacks/slice/orangecake
	name = "Orange Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "orangecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FADA8E"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/orangecake

/obj/item/reagent_containers/food/snacks/slice/orangecake/filled
	filled = TRUE


/obj/item/reagent_containers/food/snacks/sliceable/limecake
	name = "Lime Cake"
	desc = "A cake with added lime."
	icon_state = "limecake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/limecake
	slices_num = 5
	filling_color = "#CBFA8E"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "lime" = 15)
	nutriment_amt = 20


/obj/item/reagent_containers/food/snacks/slice/limecake
	name = "Lime Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "limecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#CBFA8E"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/limecake

/obj/item/reagent_containers/food/snacks/slice/limecake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/lemoncake
	name = "Lemon Cake"
	desc = "A cake with added lemon."
	icon_state = "lemoncake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/lemoncake
	slices_num = 5
	filling_color = "#FAFA8E"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "lemon" = 15)
	nutriment_amt = 20


/obj/item/reagent_containers/food/snacks/slice/lemoncake
	name = "Lemon Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "lemoncake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FAFA8E"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/lemoncake

/obj/item/reagent_containers/food/snacks/slice/lemoncake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/chocolatecake
	name = "Chocolate Cake"
	desc = "A cake with added chocolate."
	icon_state = "chocolatecake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/chocolatecake
	slices_num = 5
	filling_color = "#805930"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "chocolate" = 15)
	nutriment_amt = 20

/obj/item/reagent_containers/food/snacks/slice/chocolatecake
	name = "Chocolate Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "chocolatecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#805930"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/chocolatecake

/obj/item/reagent_containers/food/snacks/slice/chocolatecake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel
	name = "Cheese wheel"
	desc = "A big wheel of delcious Cheddar."
	icon_state = "cheesewheel"
	slice_path = /obj/item/reagent_containers/food/snacks/cheesewedge
	slices_num = 5
	filling_color = "#FFF700"
	nutriment_desc = list("cheese" = 10)
	nutriment_amt = 10

/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cheesewedge
	name = "Cheese wedge"
	desc = "A wedge of delicious Cheddar. The cheese wheel it was cut from can't have gone far."
	icon_state = "cheesewedge"
	filling_color = "#FFF700"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/birthdaycake
	name = "Birthday Cake"
	desc = "Happy Birthday..."
	icon_state = "birthdaycake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/birthdaycake
	slices_num = 5
	filling_color = "#FFD6D6"
	nutriment_desc = list("cake" = 10, "sweetness" = 10)
	nutriment_amt = 20

/obj/item/reagent_containers/food/snacks/sliceable/birthdaycake/Initialize()
	. = ..()
	reagents.add_reagent("sprinkles", 10)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/slice/birthdaycake
	name = "Birthday Cake slice"
	desc = "A slice of your birthday."
	icon_state = "birthdaycakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#FFD6D6"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/birthdaycake

/obj/item/reagent_containers/food/snacks/slice/birthdaycake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/bread
	name = "Bread"
	icon_state = "Some plain old Earthen bread."
	icon_state = "bread"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/bread
	slices_num = 5
	filling_color = "#FFE396"
	nutriment_desc = list("bread" = 6)
	nutriment_amt = 6

/obj/item/reagent_containers/food/snacks/sliceable/bread/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/bread
	name = "Bread slice"
	desc = "A slice of home."
	icon_state = "breadslice"
	trash = /obj/item/trash/plate
	filling_color = "#D27332"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/bread

/obj/item/reagent_containers/food/snacks/slice/bread/filled
	filled = TRUE


/obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread
	name = "Cream Cheese Bread"
	desc = "Yum yum yum!"
	icon_state = "creamcheesebread"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/creamcheesebread
	slices_num = 5
	filling_color = "#FFF896"
	nutriment_desc = list("bread" = 6, "cream" = 3, "cheese" = 3)
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread/Initialize()
	. = ..()
	reagents.add_reagent("protein", 15)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/creamcheesebread
	name = "Cream Cheese Bread slice"
	desc = "A slice of yum!"
	icon_state = "creamcheesebreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#FFF896"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread


/obj/item/reagent_containers/food/snacks/slice/creamcheesebread/filled
	filled = TRUE


/obj/item/reagent_containers/food/snacks/watermelonslice
	name = "Watermelon Slice"
	desc = "A slice of watery goodness."
	icon_state = "watermelonslice"
	filling_color = "#FF3867"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/applecake
	name = "Apple Cake"
	desc = "A cake centred with apples."
	icon_state = "applecake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/applecake
	slices_num = 5
	filling_color = "#EBF5B8"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "apple" = 15)
	nutriment_amt = 15

/obj/item/reagent_containers/food/snacks/slice/applecake
	name = "Apple Cake slice"
	desc = "A slice of heavenly cake."
	icon_state = "applecakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#EBF5B8"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/applecake

/obj/item/reagent_containers/food/snacks/slice/applecake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie
	name = "Pumpkin Pie"
	desc = "A delicious treat for the autumn months."
	icon_state = "pumpkinpie"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/pumpkinpie
	slices_num = 5
	filling_color = "#F5B951"
	nutriment_desc = list("pie" = 5, "cream" = 5, "pumpkin" = 5)
	nutriment_amt = 15

/obj/item/reagent_containers/food/snacks/slice/pumpkinpie
	name = "Pumpkin Pie slice"
	desc = "A slice of pumpkin pie, with whipped cream on top. Perfection."
	icon_state = "pumpkinpieslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie

/obj/item/reagent_containers/food/snacks/slice/pumpkinpie/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/cracker
	name = "Cracker"
	desc = "It's a salted cracker."
	icon_state = "cracker"
	filling_color = "#F5DEB8"
	nutriment_desc = list("salt" = 1, "cracker" = 2)
	nutriment_amt = 1



/////////////////////////////////////////////////PIZZA////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/sliceable/pizza
	slices_num = 6
	filling_color = "#BAA14C"

/obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita
	name = "Margherita"
	desc = "The golden standard of pizzas."
	icon_state = "pizzamargherita"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/margherita
	slices_num = 6
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "cheese" = 15)
	nutriment_amt = 35

/obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)
	reagents.add_reagent("tomatojuice", 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/margherita
	name = "Margherita slice"
	desc = "A slice of the classic pizza."
	icon_state = "pizzamargheritaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita

/obj/item/reagent_containers/food/snacks/slice/margherita/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza
	name = "Meatpizza"
	desc = "A pizza with meat topping."
	icon_state = "meatpizza"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/meatpizza
	slices_num = 6
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "cheese" = 15)
	nutriment_amt = 10

/obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza/Initialize()
	. = ..()
	reagents.add_reagent("protein", 34)
	reagents.add_reagent("tomatojuice", 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/meatpizza
	name = "Meatpizza slice"
	desc = "A slice of a meaty pizza."
	icon_state = "meatpizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza

/obj/item/reagent_containers/food/snacks/slice/meatpizza/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza
	name = "Mushroompizza"
	desc = "Very special pizza."
	icon_state = "mushroompizza"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/mushroompizza
	slices_num = 6
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "cheese" = 5, "mushroom" = 10)
	nutriment_amt = 35

/obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/mushroompizza
	name = "Mushroompizza slice"
	desc = "Maybe it is the last slice of pizza in your life."
	icon_state = "mushroompizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza

/obj/item/reagent_containers/food/snacks/slice/mushroompizza/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza
	name = "Vegetable pizza"
	desc = "No one of Tomato Sapiens were harmed during making this pizza."
	icon_state = "vegetablepizza"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/vegetablepizza
	slices_num = 6
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "cheese" = 5, "eggplant" = 5, "carrot" = 5, "corn" = 5)
	nutriment_amt = 25

/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)
	reagents.add_reagent("tomatojuice", 6)
	reagents.add_reagent("imidazoline", 12)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/vegetablepizza
	name = "Vegetable pizza slice"
	desc = "A slice of the most green pizza of all pizzas not containing green ingredients."
	icon_state = "vegetablepizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza

/obj/item/reagent_containers/food/snacks/slice/vegetablepizza/filled
	filled = TRUE

/obj/item/pizzabox
	name = "pizza box"
	desc = "A box suited for pizzas."
	icon = 'icons/obj/food.dmi'
	icon_state = "pizzabox1"

	var/open = 0 // Is the box open?
	var/ismessy = 0 // Fancy mess on the lid
	var/obj/item/reagent_containers/food/snacks/sliceable/pizza/pizza // Content pizza
	var/list/boxes = list() // If the boxes are stacked, they come here
	var/boxtag = ""

/obj/item/pizzabox/update_icon()

	overlays = list()

	// Set appropriate description
	if( open && pizza )
		desc = "A box suited for pizzas. It appears to have a [pizza.name] inside."
	else if( boxes.len > 0 )
		desc = "A pile of boxes suited for pizzas. There appears to be [boxes.len + 1] boxes in the pile."

		var/obj/item/pizzabox/topbox = boxes[boxes.len]
		var/toptag = topbox.boxtag
		if( toptag != "" )
			desc = "[desc] The box on top has a tag, it reads: '[toptag]'."
	else
		desc = "A box suited for pizzas."

		if( boxtag != "" )
			desc = "[desc] The box has a tag, it reads: '[boxtag]'."

	// Icon states and overlays
	if( open )
		if( ismessy )
			icon_state = "pizzabox_messy"
		else
			icon_state = "pizzabox_open"

		if( pizza )
			var/image/pizzaimg = image(icon = pizza.icon, icon_state = pizza.icon_state)
			pizzaimg.pixel_y = -3
			overlays += pizzaimg

		return
	else
		// Stupid code because byondcode sucks
		var/doimgtag = 0
		if( boxes.len > 0 )
			var/obj/item/pizzabox/topbox = boxes[boxes.len]
			if( topbox.boxtag != "" )
				doimgtag = 1
		else
			if( boxtag != "" )
				doimgtag = 1

		if( doimgtag )
			var/image/tagimg = image("food.dmi", icon_state = "pizzabox_tag")
			tagimg.pixel_y = boxes.len * 3
			overlays += tagimg

	icon_state = "pizzabox[boxes.len+1]"

/obj/item/pizzabox/attack_hand( mob/user as mob )

	if( open && pizza )
		user.put_in_hands( pizza )

		to_chat(user, "<span class='warning'>You take \the [src.pizza] out of \the [src].</span>")
		src.pizza = null
		update_icon()
		return

	if( boxes.len > 0 )
		if( user.get_inactive_hand() != src )
			. = ..()
			return

		var/obj/item/pizzabox/box = boxes[boxes.len]
		boxes -= box

		user.put_in_hands( box )
		to_chat(user, "<span class='warning'>You remove the topmost [src] from your hand.</span>")
		box.update_icon()
		update_icon()
		return
	. = ..()

/obj/item/pizzabox/attack_self( mob/user as mob )

	if( boxes.len > 0 )
		return

	open = !open

	if( open && pizza )
		ismessy = 1

	update_icon()

/obj/item/pizzabox/attackby( obj/item/I as obj, mob/user as mob )
	if( istype(I, /obj/item/pizzabox/) )
		var/obj/item/pizzabox/box = I

		if( !box.open && !src.open )
			// Make a list of all boxes to be added
			var/list/boxestoadd = list()
			boxestoadd += box
			for(var/obj/item/pizzabox/i in box.boxes)
				boxestoadd += i

			if( (boxes.len+1) + boxestoadd.len <= 5 )
				user.drop_item()

				box.loc = src
				box.boxes = list() // Clear the box boxes so we don't have boxes inside boxes. - Xzibit
				src.boxes.Add( boxestoadd )

				box.update_icon()
				update_icon()

				to_chat(user, "<span class='warning'>You put \the [box] ontop of \the [src]!</span>")
			else
				to_chat(user, "<span class='warning'>The stack is too high!</span>")
		else
			to_chat(user, "<span class='warning'>Close \the [box] first!</span>")

		return

	if( istype(I, /obj/item/reagent_containers/food/snacks/sliceable/pizza/) ) // Long ass fucking object name

		if( src.open )
			user.drop_item()
			I.loc = src
			src.pizza = I

			update_icon()

			to_chat(user, "<span class='warning'>You put \the [I] in \the [src]!</span>")
		else
			to_chat(user, "<span class='warning'>You try to push \the [I] through the lid but it doesn't work!</span>")
		return

	if( istype(I, /obj/item/pen/) )

		if( src.open )
			return

		var/t = sanitize(input("Enter what you want to add to the tag:", "Write", null, null) as text, 30)

		var/obj/item/pizzabox/boxtotagto = src
		if( boxes.len > 0 )
			boxtotagto = boxes[boxes.len]

		boxtotagto.boxtag = copytext("[boxtotagto.boxtag][t]", 1, 30)

		update_icon()
		return
	. = ..()

/obj/item/pizzabox/margherita/Initialize()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita(src)
	boxtag = "Margherita Deluxe"

/obj/item/pizzabox/vegetable/Initialize()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza(src)
	boxtag = "Gourmet Vegatable"

/obj/item/pizzabox/mushroom/Initialize()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza(src)
	boxtag = "Mushroom Special"

/obj/item/pizzabox/meat/Initialize()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza(src)
	boxtag = "Meatlover's Supreme"

/obj/item/pizzabox/pineapple/Initialize()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/pineapple(src)
	boxtag = "Hawaiian Sunrise"

/obj/item/reagent_containers/food/snacks/dionaroast
	name = "roast diona"
	desc = "It's like an enormous, leathery carrot. With an eye."
	icon_state = "dionaroast"
	trash = /obj/item/trash/plate
	filling_color = "#75754B"
	nutriment_amt = 6
	nutriment_desc = list("a chorus of flavor" = 6)

/obj/item/reagent_containers/food/snacks/dionaroast/Initialize()
	. = ..()
	reagents.add_reagent("radium", 2)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/teshariroast
	name = "roast teshari"
	desc = "It's almost disturbing how closely this resembles a chicken. Plucking the feathers must have taken forever."
	icon_state = "teshari_roast"
	trash = /obj/item/trash/plate
	filling_color = "#75754B"
	nutriment_amt = 6
	nutriment_desc = list("lemon pepper wet" = 6)

/obj/item/reagent_containers/food/snacks/tehsariroast/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)
	bitesize = 2

///////////////////////////////////////////
// new old food stuff from bs12
///////////////////////////////////////////
/obj/item/reagent_containers/food/snacks/dough
	name = "dough"
	desc = "A piece of dough."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "dough"
	bitesize = 2
	nutriment_amt = 3
	nutriment_desc = list("uncooked dough" = 3)

/obj/item/reagent_containers/food/snacks/dough/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)

// Dough + rolling pin = flat dough
/obj/item/reagent_containers/food/snacks/dough/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/material/kitchen/rollingpin))
		new /obj/item/reagent_containers/food/snacks/sliceable/flatdough(src)
		to_chat(user, "You flatten the dough.")
		qdel(src)
	else
		. = ..()

// slicable into 3xdoughslices
/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	name = "flat dough"
	desc = "A flattened dough."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "flat dough"
	slice_path = /obj/item/reagent_containers/food/snacks/doughslice
	slices_num = 3

/obj/item/reagent_containers/food/snacks/sliceable/flatdough/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)
	reagents.add_reagent("nutriment", 3)

/obj/item/reagent_containers/food/snacks/doughslice
	name = "dough slice"
	desc = "A building block of an impressive dish."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "doughslice"
	slice_path = /obj/item/reagent_containers/food/snacks/spagetti
	slices_num = 1
	bitesize = 2
	nutriment_amt = 1
	nutriment_desc = list("uncooked dough" = 1)

/obj/item/reagent_containers/food/snacks/doughslice/Initialize()
	. = ..()

/obj/item/reagent_containers/food/snacks/bun
	name = "bun"
	desc = "A base for any self-respecting burger."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "bun"
	bitesize = 2
	nutriment_amt = 4
	nutriment_desc = list("bun" = 4)

/obj/item/reagent_containers/food/snacks/bun/Initialize()
	. = ..()

/* BEGIN CITADEL CHANGE - Moved to /modular_citadel/code/modules/food/food/snacks.dm for Aurora kitchen port
/obj/item/reagent_containers/food/snacks/bun/attackby(obj/item/W as obj, mob/user as mob)
	// Bun + meatball = burger
	if(istype(W,/obj/item/reagent_containers/food/snacks/meatball))
		new /obj/item/reagent_containers/food/snacks/monkeyburger(src)
		to_chat(user, "You make a burger.")
		qdel(W)
		qdel(src)

	// Bun + cutlet = hamburger
	else if(istype(W,/obj/item/reagent_containers/food/snacks/cutlet))
		new /obj/item/reagent_containers/food/snacks/monkeyburger(src)
		to_chat(user, "You make a burger.")
		qdel(W)
		qdel(src)

	// Bun + sausage = hotdog
	else if(istype(W,/obj/item/reagent_containers/food/snacks/sausage))
		new /obj/item/reagent_containers/food/snacks/hotdog(src)
		to_chat(user, "You make a hotdog.")
		qdel(W)
		qdel(src)
END CITADEL CHANGE */

// Burger + cheese wedge = cheeseburger
/obj/item/reagent_containers/food/snacks/monkeyburger/attackby(obj/item/reagent_containers/food/snacks/cheesewedge/W as obj, mob/user as mob)
	if(istype(W))// && !istype(src,/obj/item/reagent_containers/food/snacks/cheesewedge))
		new /obj/item/reagent_containers/food/snacks/cheeseburger(src)
		to_chat(user, "You make a cheeseburger.")
		qdel(W)
		qdel(src)
		return
	else
		. = ..()

// Human Burger + cheese wedge = cheeseburger
/obj/item/reagent_containers/food/snacks/human/burger/attackby(obj/item/reagent_containers/food/snacks/cheesewedge/W as obj, mob/user as mob)
	if(istype(W))
		new /obj/item/reagent_containers/food/snacks/cheeseburger(src)
		to_chat(user, "You make a cheeseburger.")
		qdel(W)
		qdel(src)
		return
	else
		. = ..()

/obj/item/reagent_containers/food/snacks/bunbun // Name fix
	name = "Improper Bun Bun"
	desc = "A small bread monkey fashioned from two burger buns."
	icon_state = "bunbun"
	bitesize = 2
	nutriment_amt = 8
	nutriment_desc = list("bun" = 8)

/obj/item/reagent_containers/food/snacks/bunbun/Initialize()
	. = ..()

/obj/item/reagent_containers/food/snacks/taco
	name = "taco"
	desc = "Take a bite!"
	icon_state = "taco"
	bitesize = 3
	nutriment_amt = 4
	nutriment_desc = list("cheese" = 2,"taco shell" = 2)
/obj/item/reagent_containers/food/snacks/taco/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)

/obj/item/reagent_containers/food/snacks/rawcutlet
	name = "raw cutlet"
	desc = "A thin piece of raw meat."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawcutlet"
	bitesize = 1

/obj/item/reagent_containers/food/snacks/rawcutlet/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)

/obj/item/reagent_containers/food/snacks/cutlet
	name = "cutlet"
	desc = "A tasty meat slice."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "cutlet"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cutlet/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)

/obj/item/reagent_containers/food/snacks/rawmeatball
	name = "raw meatball"
	desc = "A raw meatball."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawmeatball"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/rawmeatball/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)

/obj/item/reagent_containers/food/snacks/hotdog
	name = "hotdog"
	desc = "Unrelated to dogs, maybe."
	icon_state = "hotdog"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/hotdog/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)

/obj/item/reagent_containers/food/snacks/flatbread
	name = "flatbread"
	desc = "Bland but filling."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "flatbread"
	bitesize = 2
	nutriment_amt = 3
	nutriment_desc = list("bread" = 3)

/obj/item/reagent_containers/food/snacks/flatbread/Initialize()
	. = ..()

// potato + knife = raw sticks
/obj/item/reagent_containers/food/snacks/grown/attackby(obj/item/W, mob/user)
	if(seed && seed.kitchen_tag && seed.kitchen_tag == "potato" && istype(W,/obj/item/material/knife))
		new /obj/item/reagent_containers/food/snacks/rawsticks(get_turf(src))
		to_chat(user, "You cut the potato.")
		qdel(src)
	else
		. = ..()

/obj/item/reagent_containers/food/snacks/rawsticks
	name = "raw potato sticks"
	desc = "Raw fries, not very tasty."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawsticks"
	bitesize = 2
	nutriment_amt = 3
	nutriment_desc = list("raw potato" = 3)

/obj/item/reagent_containers/food/snacks/rawsticks/Initialize()
	. = ..()

/obj/item/reagent_containers/food/snacks/liquidfood // Buff back to 30 from 20
	name = "\improper LiquidFood Ration"
	desc = "A prepackaged grey slurry of all the essential nutrients for a spacefarer on the go. Should this be crunchy?"
	icon_state = "liquidfood"
	trash = /obj/item/trash/liquidfood
	filling_color = "#A8A8A8"
	survivalfood = TRUE
	center_of_mass = list("x"=16, "y"=15)
	nutriment_amt = 30
	bitesize = 4
	nutriment_desc = list("chalk" = 6)

/obj/item/reagent_containers/food/snacks/liquidfood/Initialize()
	..()
	reagents.add_reagent("iron", 3)

/obj/item/reagent_containers/food/snacks/liquidvitamin
	name = "\improper VitaPaste Ration"
	desc = "A variant of the liquidfood ration, designed for any carbon-based life. Somehow worse than regular liquidfood. Should this be crunchy?"
	icon_state = "liquidvitamin"
	trash = /obj/item/trash/liquidvitamin
	filling_color = "#A8A8A8"
	bitesize = 6
	survivalfood = TRUE
	center_of_mass = list("x"=16, "y"=15)

/obj/item/reagent_containers/food/snacks/liquidvitamin/Initialize()
	..()
	reagents.add_reagent("nutriflour", 20)
	reagents.add_reagent("tricordrazine", 5)
	reagents.add_reagent("paracetamol", 5)
	reagents.add_reagent("enzyme", 1)
	reagents.add_reagent("iron", 3)

/obj/item/reagent_containers/food/snacks/meatcube
	name = "cubed meat"
	desc = "Fried, salted lean meat compressed into a cube. Not very appetizing."
	icon_state = "meatcube"
	filling_color = "#7a3d11"
	center_of_mass = list("x"=16, "y"=16)

/obj/item/reagent_containers/food/snacks/meatcube/Initialize()
	. = ..()
	reagents.add_reagent("protein", 15)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/liquidprotein // Added Protein only version of LiquidFood + added custom sprite for it
    name = "\improper LiquidProtein Ration"
    desc = "A variant of the liquidfood ration, designed for obligate carnivore species. Only barely more appealing than regular liquidfood. Should this be crunchy?"
    icon_state = "liquidprotein"
    trash = /obj/item/trash/liquidprotein
    filling_color = "#A8A8A8"
    bitesize = 4
    center_of_mass = list("x"=16, "y"=15)

/obj/item/reagent_containers/food/snacks/liquidprotein/Initialize()
    ..()
    reagents.add_reagent("protein", 30)
    reagents.add_reagent("iron", 3)

/obj/item/reagent_containers/food/snacks/tastybread
	name = "bread tube"
	desc = "Bread in a tube. Chewy...and surprisingly tasty."
	icon_state = "tastybread"
	trash = /obj/item/trash/tastybread
	filling_color = "#A66829"
	center_of_mass = list("x"=17, "y"=16)
	nutriment_amt = 6
	nutriment_desc = list("bread" = 2, "sweetness" = 3)

/obj/item/reagent_containers/food/snacks/tastybread/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/skrellsnacks // Buff 10 >> 12
	name = "\improper SkrellSnax"
	desc = "Cured fungus shipped all the way from Qerr'balak, almost like jerky! Almost."
	icon_state = "skrellsnacks"
	filling_color = "#A66829"
	nutriment_amt = 12
	nutriment_desc = list("mushroom" = 5, "salt" = 5)

/obj/item/reagent_containers/food/snacks/skrellsnacks/Initialize()
	. = ..()
	bitesize = 3

/obj/item/reagent_containers/food/snacks/unajerky // Buff 8 >> 10
	name = "Moghes Imported Sissalik Jerky"
	icon_state = "unathitinred"
	desc = "An incredibly well made jerky, shipped in all the way from Moghes."
	trash = /obj/item/trash/unajerky
	filling_color = "#631212"

/obj/item/reagent_containers/food/snacks/unajerky/Initialize()
		. = ..()
		reagents.add_reagent("protein", 10)
		reagents.add_reagent("capsaicin", 2)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/croissant
	name = "croissant"
	desc = "True French cuisine."
	filling_color = "#E3D796"
	icon_state = "croissant"
	nutriment_amt = 6
	nutriment_desc = list("french bread" = 6)

/obj/item/reagent_containers/food/snacks/croissant/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatbun // Buff 8 >> 10
	name = "meat bun"
	desc = "Chinese street food, in neither China nor a street."
	filling_color = "#DEDEAB"
	icon_state = "meatbun"
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/meatbun/Initialize()
	. = ..()
	bitesize = 3
	reagents.add_reagent("protein", 5)

/obj/item/reagent_containers/food/snacks/sashimi // Buff 8 >> 10
	name = "carp sashimi"
	desc = "Expertly prepared. Still toxic."
	filling_color = "#FFDEFE"
	icon_state = "sashimi"
	nutriment_amt = 6

/obj/item/reagent_containers/food/snacks/sashimi/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	reagents.add_reagent("carpotoxin", 2)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/benedict // Buff 6 >> 8
	name = "eggs benedict"
	desc = "Hey, there's only one egg in this!"
	filling_color = "#FFDF78"
	icon_state = "benedict"
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/benedict/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/beans
	name = "baked beans"
	desc = "Musical fruit in a slightly less musical container."
	filling_color = "#FC6F28"
	icon_state = "beans"
	nutriment_amt = 4
	nutriment_desc = list("beans" = 4)

/obj/item/reagent_containers/food/snacks/beans/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarcookie
	name = "sugar cookie"
	desc = "Just like your little sister used to make."
	filling_color = "#DBC94F"
	icon_state = "sugarcookie"
	nutriment_amt = 5
	nutriment_desc = list("sweetness" = 4, "cookie" = 1)

/obj/item/reagent_containers/food/snacks/sugarcookie/Initialize()
	. = ..()
	bitesize = 1

/obj/item/reagent_containers/food/snacks/berrymuffin
	name = "berry muffin"
	desc = "A delicious and spongy little cake, with berries."
	icon_state = "berrymuffin"
	filling_color = "#E0CF9B"
	nutriment_amt = 6
	nutriment_desc = list("sweetness" = 2, "muffin" = 2, "berries" = 2)

/obj/item/reagent_containers/food/snacks/berrymuffin/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/ghostmuffin
	name = "booberry muffin"
	desc = "My stomach is a graveyard! No living being can quench my bloodthirst!"
	icon_state = "berrymuffin"
	filling_color = "#799ACE"
	nutriment_amt = 6
	nutriment_desc = list("spookiness" = 4, "muffin" = 1, "berries" = 1)

/obj/item/reagent_containers/food/snacks/ghostmuffin/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/eggroll // Buff 8 >> 12
	name = "egg roll"
	desc = "Free with orders over 10 thalers."
	icon_state = "eggroll"
	filling_color = "#799ACE"
	nutriment_desc = list("egg" = 4)

/obj/item/reagent_containers/food/snacks/eggroll/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 6)
	reagents.add_reagent("protein", 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/fruitsalad // Buff 10 >> 15
	name = "fruit salad"
	desc = "Your standard fruit salad."
	icon_state = "fruitsalad"
	filling_color = "#FF3867"
	nutriment_desc = list("fruit" = 10)

/obj/item/reagent_containers/food/snacks/fruitsalad/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 15)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/eggbowl // Buff 10 >> 15
	name = "egg bowl"
	desc = "A bowl of fried rice with egg mixed in."
	icon_state = "eggbowl"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	nutriment_desc = list("rice" = 2, "egg" = 4)

/obj/item/reagent_containers/food/snacks/eggbowl/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 10)
	reagents.add_reagent("protein", 5)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/porkbowl // Buff 10 >> 16
	name = "pork bowl"
	desc = "A bowl of fried rice with cuts of meat."
	icon_state = "porkbowl"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	nutriment_desc = list("rice" = 2, "meat" = 4)

/obj/item/reagent_containers/food/snacks/porkbowl/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 11)
	reagents.add_reagent("protein", 5)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/tortilla
	name = "tortilla"
	desc = "The base for all your burritos."
	icon_state = "tortilla"
	nutriment_amt = 1
	nutriment_desc = list("bread" = 1)

/obj/item/reagent_containers/food/snacks/tortilla/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 2)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatburrito
	name = "carne asada burrito"
	desc = "The best burrito for meat lovers."
	icon_state = "carneburrito"
	nutriment_amt = 6
	nutriment_desc = list("tortilla" = 3, "meat" = 3)

/obj/item/reagent_containers/food/snacks/meatburrito/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cheeseburrito // Balance
	name = "Cheese burrito"
	desc = "It's a burrito filled with cheese."
	icon_state = "cheeseburrito"
	nutriment_desc = list("tortilla" = 3, "cheese" = 3)

/obj/item/reagent_containers/food/snacks/cheeseburrito/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 10)
	reagents.add_reagent("protein", 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/fuegoburrito
	name = "fuego phoron burrito"
	desc = "A super spicy burrito."
	icon_state = "fuegoburrito"
	nutriment_amt = 6
	nutriment_desc = list("chili peppers" = 5, "tortilla" = 1)

/obj/item/reagent_containers/food/snacks/fuegoburrito/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 6)
	reagents.add_reagent("capsaicin", 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/nachos // Buff 1 >> 4
	name = "nachos"
	desc = "Chips from Old Mexico."
	icon_state = "nachos"
	nutriment_desc = list("salt" = 1)

/obj/item/reagent_containers/food/snacks/nachos/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 4)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/cheesenachos
	name = "cheesy nachos"
	desc = "The delicious combination of nachos and melting cheese."
	icon_state = "cheesenachos"
	nutriment_desc = list("salt" = 2, "cheese" = 3)

/obj/item/reagent_containers/food/snacks/cheesenachos/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 5)
	reagents.add_reagent("protein", 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cubannachos
	name = "cuban nachos"
	desc = "That's some dangerously spicy nachos."
	icon_state = "cubannachos"
	nutriment_amt = 6
	nutriment_desc = list("salt" = 1, "cheese" = 2, "chili peppers" = 3)

/obj/item/reagent_containers/food/snacks/cubannachos/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 5)
	reagents.add_reagent("capsaicin", 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/piginblanket
	name = "pig in a blanket"
	desc = "A sausage embedded in soft, fluffy pastry. Free this pig from its blanket prison by eating it."
	icon_state = "piginblanket"
	nutriment_amt = 6
	nutriment_desc = list("meat" = 3, "pastry" = 3)

/obj/item/reagent_containers/food/snacks/piginblanket/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 6)
	reagents.add_reagent("protein", 4)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/macncheese
	name = "macaroni and cheese"
	desc = "The perfect combination of noodles and dairy."
	icon = 'modular_citadel/icons/obj/food_cit.dmi'
	icon_state = "macncheese"
	trash = /obj/item/trash/snack_bowl
	nutriment_amt = 9
	nutriment_desc = list("Cheese" = 5, "pasta" = 4, "happiness" = 1)

/obj/item/reagent_containers/food/snacks/macncheese/Initialize()
	. = ..()
	bitesize = 3

//Code for dipping food in batter
/obj/item/reagent_containers/food/snacks/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(O.is_open_container() && O.reagents && !(istype(O, /obj/item/reagent_containers/food)))
		for (var/r in O.reagents.reagent_list)

			var/datum/reagent/R = r
			if (istype(R, /datum/reagent/nutriment/coating))
				if (apply_coating(R, user))
					return 1

	return ..()

//This proc handles drawing coatings out of a container when this food is dipped into it
/obj/item/reagent_containers/food/snacks/proc/apply_coating(var/datum/reagent/nutriment/coating/C, var/mob/user)
	if (coating)
		to_chat(user, "The [src] is already coated in [coating.name]!")
		return 0

	//Calculate the reagents of the coating needed
	var/req = 0
	for (var/r in reagents.reagent_list)
		var/datum/reagent/R = r
		if (istype(R, /datum/reagent/nutriment))
			req += R.volume * 0.2
		else
			req += R.volume * 0.1

	req += w_class*0.5

	if (!req)
		//the food has no reagents left, its probably getting deleted soon
		return 0

	if (C.volume < req)
		user << span("warning", "There's not enough [C.name] to coat the [src]!")
		return 0

	var/id = C.id

	//First make sure there's space for our batter
	if (reagents.get_free_space() < req+5)
		var/extra = req+5 - reagents.get_free_space()
		reagents.maximum_volume += extra

	//Suck the coating out of the holder
	C.holder.trans_to_holder(reagents, req)

	//We're done with C now, repurpose the var to hold a reference to our local instance of it
	C = reagents.get_reagent(id)
	if (!C)
		return

	coating = C
	//Now we have to do the witchcraft with masking images
	//var/icon/I = new /icon(icon, icon_state)

	if (!flat_icon)
		flat_icon = getFlatIcon(src)
	var/icon/I = flat_icon
	color = "#FFFFFF" //Some fruits use the color var. Reset this so it doesnt tint the batter
	I.Blend(new /icon('icons/obj/food_custom.dmi', rgb(255,255,255)),ICON_ADD)
	I.Blend(new /icon('icons/obj/food_custom.dmi', coating.icon_raw),ICON_MULTIPLY)
	var/image/J = image(I)
	J.alpha = 200
	J.blend_mode = BLEND_OVERLAY
	J.tag = "coating"
	overlays += J

	if (user)
		user.visible_message(span("notice", "[user] dips \the [src] into \the [coating.name]"), span("notice", "You dip \the [src] into \the [coating.name]"))

	return 1


//Called by cooking machines. This is mainly intended to set properties on the food that differ between raw/cooked
/obj/item/reagent_containers/food/snacks/proc/cook()
	if (coating)
		var/list/temp = overlays.Copy()
		for (var/i in temp)
			if (istype(i, /image))
				var/image/I = i
				if (I.tag == "coating")
					temp.Remove(I)
					break

		overlays = temp
		//Carefully removing the old raw-batter overlay

		if (!flat_icon)
			flat_icon = getFlatIcon(src)
		var/icon/I = flat_icon
		color = "#FFFFFF" //Some fruits use the color var
		I.Blend(new /icon('icons/obj/food_custom.dmi', rgb(255,255,255)),ICON_ADD)
		I.Blend(new /icon('icons/obj/food_custom.dmi', coating.icon_cooked),ICON_MULTIPLY)
		var/image/J = image(I)
		J.alpha = 200
		J.tag = "coating"
		overlays += J


		if (do_coating_prefix == 1)
			name = "[coating.coated_adj] [name]"

	for (var/r in reagents.reagent_list)
		var/datum/reagent/R = r
		if (istype(R, /datum/reagent/nutriment/coating))
			var/datum/reagent/nutriment/coating/C = R
			C.data["cooked"] = 1
			C.name = C.cooked_name

/obj/item/reagent_containers/food/snacks/proc/on_consume(var/mob/eater, var/mob/feeder = null)
	if(!reagents.total_volume)
		eater.visible_message("<span class='notice'>[eater] finishes eating \the [src].</span>","<span class='notice'>You finish eating \the [src].</span>")

		if (!feeder)
			feeder = eater

		feeder.drop_from_inventory(src)	//so icons update :[ //what the fuck is this????

		if(trash)
			if(ispath(trash,/obj/item))
				var/obj/item/TrashItem = new trash(feeder)
				feeder.put_in_hands(TrashItem)
			else if(istype(trash,/obj/item))
				feeder.put_in_hands(trash)
		qdel(src)
	return
////////////////////////////////////////////////////////////////////////////////
/// FOOD END
////////////////////////////////////////////////////////////////////////////////

/mob/living
	var/composition_reagent
	var/composition_reagent_quantity

/mob/living/simple_animal/adultslime
	composition_reagent = "slimejelly"

/mob/living/carbon/slime
	composition_reagent = "slimejelly"

/mob/living/carbon/alien/diona
	composition_reagent = "nutriment"//Dionae are plants, so eating them doesn't give animal protein

/mob/living/simple_mob/slime
	composition_reagent = "slimejelly"

/mob/living/simple_animal
	var/kitchen_tag = "animal" //Used for cooking with animals

/mob/living/simple_animal/mouse
	kitchen_tag = "rodent"

/mob/living/simple_animal/lizard
	kitchen_tag = "lizard"

/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel
	slices_num = 8

/obj/item/reagent_containers/food/snacks/sausage/battered
	name = "battered sausage"
	desc = "A piece of mixed, long meat, battered and then deepfried."
	icon_state = "batteredsausage"
	filling_color = "#DB0000"
	do_coating_prefix = 0

/obj/item/reagent_containers/food/snacks/sausage/battered/Initialize()
		. = ..()
		reagents.add_reagent("protein", 6)
		reagents.add_reagent("batter", 1.7)
		reagents.add_reagent("oil", 1.5)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/jalapeno_poppers
	name = "jalapeno popper"
	desc = "A battered, deep-fried chilli pepper."
	icon_state = "popper"
	filling_color = "#00AA00"
	do_coating_prefix = 0
	nutriment_amt = 2
	nutriment_desc = list("chilli pepper" = 2)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/jalapeno_poppers/Initialize()
	. = ..()
	reagents.add_reagent("batter", 2)
	reagents.add_reagent("oil", 2)

/obj/item/reagent_containers/food/snacks/mouseburger
	name = "mouse burger"
	desc = "Squeaky and a little furry."
	icon_state = "ratburger"

/obj/item/reagent_containers/food/snacks/mouseburger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/lizardburger
	name = "lizard burger"
	desc = "Tastes like chicken."
	icon_state = "baconburger"

/obj/item/reagent_containers/food/snacks/lizardburger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/chickenkatsu
	name = "chicken katsu"
	desc = "A Terran delicacy consisting of chicken fried in a light beer batter."
	icon_state = "katsu"
	trash = /obj/item/trash/plate
	filling_color = "#E9ADFF"
	do_coating_prefix = 0

/obj/item/reagent_containers/food/snacks/chickenkatsu/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("beerbatter", 2)
	reagents.add_reagent("oil", 1)
	bitesize = 1.5

/obj/item/reagent_containers/food/snacks/fries
	nutriment_amt = 4
	nutriment_desc = list("fries" = 4)

/obj/item/reagent_containers/food/snacks/fries/Initialize()
	. = ..()
	reagents.add_reagent("oil", 1.2)//This is mainly for the benefit of adminspawning
	bitesize = 2

/obj/item/reagent_containers/food/snacks/microchips
	name = "micro chips"
	desc = "Soft and rubbery, should have fried them. Good for smaller crewmembers, maybe?"
	icon_state = "microchips"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	nutriment_amt = 4
	nutriment_desc = list("soggy fries" = 4)

/obj/item/reagent_containers/food/snacks/microchips/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/ovenchips
	name = "oven chips"
	desc = "Dark and crispy, but a bit dry."
	icon_state = "ovenchips"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	nutriment_amt = 4
	nutriment_desc = list("crisp, dry fries" = 4)

/obj/item/reagent_containers/food/snacks/ovenchips/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatsteak/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("triglyceride", 2)
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("blackpepper", 1)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/pizza/crunch
	name = "pizza crunch"
	desc = "This was once a normal pizza, but it has been coated in batter and deep-fried. Whatever toppings it once had are a mystery, but they're still under there, somewhere..."
	icon_state = "pizzacrunch"
	slice_path = /obj/item/reagent_containers/food/snacks/pizzacrunchslice
	slices_num = 6
	nutriment_amt = 25
	nutriment_desc = list("fried pizza" = 25)

/obj/item/reagent_containers/food/snacks/sliceable/pizza/crunch/Initialize()
	. = ..()
	reagents.add_reagent("batter", 6.5)
	coating = reagents.get_reagent("batter")
	reagents.add_reagent("oil", 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/pizzacrunchslice
	name = "pizza crunch"
	desc = "A little piece of a heart attack. Its toppings are a mystery, hidden under batter."
	icon_state = "pizzacrunchslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/funnelcake
	name = "funnel cake"
	desc = "Funnel cakes rule!"
	icon_state = "funnelcake"
	filling_color = "#Ef1479"
	do_coating_prefix = 0

/obj/item/reagent_containers/food/snacks/funnelcake/Initialize()
	. = ..()
	reagents.add_reagent("batter", 10)
	reagents.add_reagent("sugar", 5)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/spreads
	name = "nutri-spread"
	desc = "A stick of plant-based nutriments in a semi-solid form. I can't believe it's not margarine!"
	icon_state = "marge"
	bitesize = 2
	nutriment_desc = list("margarine" = 1)
	nutriment_amt = 20

/obj/item/reagent_containers/food/snacks/spreads/butter
	name = "butter"
	desc = "A stick of pure butterfat made from milk products."
	icon_state = "butter"
	bitesize = 2
	nutriment_desc = list("butter" = 1)
	nutriment_amt = 0

/obj/item/reagent_containers/food/snacks/spreads/Initialize()
	. = ..()
	reagents.add_reagent("triglyceride", 20)
	reagents.add_reagent("sodiumchloride",1)

/obj/item/reagent_containers/food/snacks/rawcutlet/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/material/knife))
		new /obj/item/reagent_containers/food/snacks/rawbacon(src)
		new /obj/item/reagent_containers/food/snacks/rawbacon(src)
		to_chat(user, "You slice the cutlet into thin strips of bacon.")
		qdel(src)
	else
		. = ..()

/obj/item/reagent_containers/food/snacks/rawbacon
	name = "raw bacon"
	desc = "A very thin piece of raw meat, cut from beef."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawbacon"
	bitesize = 1

/obj/item/reagent_containers/food/snacks/rawbacon/Initialize()
	. = ..()
	reagents.add_reagent("protein", 0.33)

/obj/item/reagent_containers/food/snacks/bacon
	name = "bacon"
	desc = "A tasty meat slice. You don't see any pigs on this station, do you?"
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "bacon"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bacon/microwave
	name = "microwaved bacon"
	desc = "A tasty meat slice. You don't see any pigs on this station, do you?"
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "bacon"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bacon/oven
	name = "oven-cooked bacon"
	desc = "A tasty meat slice. You don't see any pigs on this station, do you?"
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "bacon"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bacon/Initialize()
	. = ..()
	reagents.add_reagent("protein", 0.33)
	reagents.add_reagent("triglyceride", 1)

/obj/item/reagent_containers/food/snacks/bacon_stick
	name = "eggpop"
	desc = "A bacon wrapped boiled egg, conviently skewered on a wooden stick."
	icon_state = "bacon_stick"

/obj/item/reagent_containers/food/snacks/bacon_stick/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)
	reagents.add_reagent("egg", 1)

/obj/item/reagent_containers/food/snacks/chilied_eggs
	name = "chilied eggs"
	desc = "Three deviled eggs floating in a bowl of meat chili. A popular lunchtime meal for Unathi in Ouerea."
	icon_state = "chilied_eggs"
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_containers/food/snacks/chilied_eggs/Initialize()
	. = ..()
	reagents.add_reagent("egg", 6)
	reagents.add_reagent("protein", 2)


/obj/item/reagent_containers/food/snacks/cheese_cracker
	name = "supreme cheese toast"
	desc = "A piece of toast lathered with butter, cheese, spices, and herbs."
	icon_state = "cheese_cracker"
	nutriment_desc = list("cheese toast" = 8)
	nutriment_amt = 8

/obj/item/reagent_containers/food/snacks/bacon_and_eggs
	name = "bacon and eggs"
	desc = "A piece of bacon and two fried eggs."
	icon_state = "bacon_and_eggs"
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/bacon_and_eggs/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)
	reagents.add_reagent("egg", 1)

/obj/item/reagent_containers/food/snacks/sweet_and_sour
	name = "sweet and sour pork"
	desc = "A traditional ancient sol recipe with a few liberties taken with meat selection."
	icon_state = "sweet_and_sour"
	nutriment_desc = list("sweet and sour" = 6)
	nutriment_amt = 6
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/sweet_and_sour/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)

/obj/item/reagent_containers/food/snacks/corn_dog
	name = "corn dog"
	desc = "A cornbread covered sausage deepfried in oil."
	icon_state = "corndog"
	nutriment_desc = list("corn batter" = 4)
	nutriment_amt = 4

/obj/item/reagent_containers/food/snacks/corn_dog/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)

/obj/item/reagent_containers/food/snacks/truffle
	name = "chocolate truffle"
	desc = "Rich bite-sized chocolate."
	icon_state = "truffle"
	nutriment_amt = 0
	bitesize = 4

/obj/item/reagent_containers/food/snacks/truffle/Initialize()
	. = ..()
	reagents.add_reagent("coco", 6)

/obj/item/reagent_containers/food/snacks/truffle/random
	name = "mystery chocolate truffle"
	desc = "Rich bite-sized chocolate with a mystery filling!"

/obj/item/reagent_containers/food/snacks/truffle/random/Initialize()
	. = ..()
	var/reagent_string = pick(list("cream","cherryjelly","mint","frostoil","capsaicin","cream","coffee","milkshake"))
	reagents.add_reagent(reagent_string, 4)

/obj/item/reagent_containers/food/snacks/bacon_flatbread
	name = "bacon cheese flatbread"
	desc = "Not a pizza."
	icon_state = "bacon_pizza"
	nutriment_desc = list("flatbread" = 5)
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/bacon_flatbread/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)

/obj/item/reagent_containers/food/snacks/meat_pocket
	name = "meat pocket"
	desc = "Meat and cheese stuffed in a flatbread pocket, grilled to perfection."
	icon_state = "meat_pocket"
	nutriment_desc = list("flatbread" = 3)
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/meat_pocket/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)

/obj/item/reagent_containers/food/snacks/fish_taco
	name = "carp taco"
	desc = "A questionably cooked fish taco decorated with herbs, spices, and special sauce."
	icon_state = "fish_taco"
	nutriment_desc = list("flatbread" = 3)
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/fish_taco/Initialize()
	. = ..()
	reagents.add_reagent("seafood",3)

/obj/item/reagent_containers/food/snacks/nt_muffin
	name = "\improper NtMuffin"
	desc = "A NanoTrasen sponsered biscuit with egg, cheese, and sausage."
	icon_state = "nt_muffin"
	nutriment_desc = list("biscuit" = 3)
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/nt_muffin/Initialize()
	. = ..()
	reagents.add_reagent("protein",5)

/obj/item/reagent_containers/food/snacks/pineapple_ring
	name = "pineapple ring"
	desc = "What the hell is this?"
	icon_state = "pineapple_ring"
	nutriment_desc = list("sweetness" = 2)
	nutriment_amt = 2

/obj/item/reagent_containers/food/snacks/pineapple_ring/Initialize()
	. = ..()
	reagents.add_reagent("pineapplejuice",3)

/obj/item/reagent_containers/food/snacks/sliceable/pizza/pineapple
	name = "ham & pineapple pizza"
	desc = "One of the most debated pizzas in existence."
	icon_state = "pineapple_pizza"
	slice_path = /obj/item/reagent_containers/food/snacks/pineappleslice
	slices_num = 6
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "ham" = 10)
	nutriment_amt = 30
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/pizza/pineapple/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	reagents.add_reagent("cheese", 5)
	reagents.add_reagent("tomatojuice", 6)

/obj/item/reagent_containers/food/snacks/pineappleslice
	name = "ham & pineapple pizza slice"
	desc = "A slice of contraband."
	icon_state = "pineapple_pizza_slice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/pineappleslice/filled
	nutriment_desc = list("pizza crust" = 5, "tomato" = 5)
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/burger/bacon // Buff 7 >> 15
	name = "bacon burger"
	desc = "The cornerstone of every nutritious breakfast, now with bacon!"
	icon_state = "baconburger"
	filling_color = "#D63C3C"
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 8
	bitesize = 3

/obj/item/reagent_containers/food/snacks/burger/bacon/Initialize()
	. = ..()
	reagents.add_reagent("protein", 7)

/obj/item/reagent_containers/food/snacks/blt // Buff 8 >> 16
	name = "BLT"
	desc = "Bacon, lettuce, tomatoes. The perfect lunch."
	icon_state = "blt"
	filling_color = "#D63C3C"
	nutriment_desc = list("bread" = 4)
	nutriment_amt = 8
	bitesize = 2

/obj/item/reagent_containers/food/snacks/blt/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)

/obj/item/reagent_containers/food/snacks/onionrings
	name = "onion rings"
	desc = "Like circular fries but better."
	icon_state = "onionrings"
	trash = /obj/item/trash/plate
	filling_color = "#eddd00"
	nutriment_desc = list("fried onions" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/berrymuffin
	name = "berry muffin"
	desc = "A delicious and spongy little cake, with berries."
	icon_state = "berrymuffin"
	filling_color = "#E0CF9B"
	nutriment_amt = 5
	nutriment_desc = list("sweetness" = 1, "muffin" = 2, "berries" = 2)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/soup/onion
	name = "onion soup"
	desc = "A soup with layers."
	icon_state = "onionsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#E0C367"
	nutriment_amt = 5
	nutriment_desc = list("onion" = 2, "soup" = 2)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/porkbowl
	name = "pork bowl"
	desc = "A bowl of fried rice with cuts of meat."
	icon_state = "porkbowl"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/porkbowl/Initialize()
	. = ..()
	reagents.add_reagent("rice", 6)
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/mashedpotato
	name = "mashed potato"
	desc = "Pillowy mounds of mashed potato."
	icon_state = "mashedpotato"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	nutriment_amt = 4
	nutriment_desc = list("mashed potatoes" = 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/croissant
	name = "croissant"
	desc = "True french cuisine."
	filling_color = "#E3D796"
	icon_state = "croissant"
	nutriment_amt = 4
	nutriment_desc = list("french bread" = 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/crabmeat
	name = "crab legs"
	desc = "... Coffee? Is that you?"
	icon_state = "crabmeat"
	bitesize = 1

/obj/item/reagent_containers/food/snacks/crabmeat/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 2)

/obj/item/reagent_containers/food/snacks/crab_legs
	name = "steamed crab legs"
	desc = "Crab legs steamed and buttered to perfection. One day when the boss gets hungry..."
	icon_state = "crablegs"
	nutriment_amt = 2
	nutriment_desc = list("savory butter" = 2)
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/crab_legs/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 6)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_containers/food/snacks/pancakes
	name = "pancakes"
	desc = "Pancakes with berries, delicious."
	icon_state = "pancakes"
	trash = /obj/item/trash/plate
	nutriment_desc = list("pancake" = 8)
	nutriment_amt = 8
	bitesize = 2

/obj/item/reagent_containers/food/snacks/nugget
	name = "chicken nugget"
	icon_state = "nugget_lump"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/nugget/Initialize()
	. = ..()
	var/shape = pick("lump", "star", "lizard", "corgi")
	desc = "A chicken nugget vaguely shaped like a [shape]."
	icon_state = "nugget_[shape]"
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/icecreamsandwich
	name = "ice cream sandwich"
	desc = "Portable ice cream in its own packaging."
	icon_state = "icecreamsandwich"
	filling_color = "#343834"
	nutriment_desc = list("ice cream" = 4)
	nutriment_amt = 4

/obj/item/reagent_containers/food/snacks/honeybun
	name = "honey bun"
	desc = "A sticky pastry bun glazed with honey."
	icon_state = "honeybun"
	nutriment_desc = list("pastry" = 1)
	nutriment_amt = 3
	bitesize = 3

/obj/item/reagent_containers/food/snacks/honeybun/Initialize()
	. = ..()
	reagents.add_reagent("honey", 3)

// Moved /bun/attackby() from /code/modules/food/food/snacks.dm
/obj/item/reagent_containers/food/snacks/bun/attackby(obj/item/W as obj, mob/user as mob)
	//i honestly should probably refactor this whole thing but idgaf
	if(istype(W,/obj/item/storage))
		. = ..() //if you want to bag a ton of buns idk i don't play chef
		return

	var/obj/item/reagent_containers/food/snacks/result = null
	// Bun + meatball = burger
	if(istype(W,/obj/item/reagent_containers/food/snacks/meatball))
		result = new /obj/item/reagent_containers/food/snacks/monkeyburger(src)
		to_chat(user, "You make a burger.")
		qdel(W)
		qdel(src)

	// Bun + cutlet = hamburger
	else if(istype(W,/obj/item/reagent_containers/food/snacks/cutlet))
		result = new /obj/item/reagent_containers/food/snacks/monkeyburger(src)
		to_chat(user, "You make a burger.")
		qdel(W)
		qdel(src)

	// Bun + sausage = hotdog
	else if(istype(W,/obj/item/reagent_containers/food/snacks/sausage))
		result = new /obj/item/reagent_containers/food/snacks/hotdog(src)
		to_chat(user, "You make a hotdog.")
		qdel(W)
		qdel(src)

	// Bun + mouse = mouseburger
	else if(istype(W,/obj/item/reagent_containers/food/snacks/variable/mob))
		var/obj/item/reagent_containers/food/snacks/variable/mob/MF = W

		switch (MF.kitchen_tag)
			if ("rodent")
				result = new /obj/item/reagent_containers/food/snacks/mouseburger(src)
				to_chat(user, "You make a mouse burger!")

		switch (MF.kitchen_tag)
			if ("lizard")
				result = new /obj/item/reagent_containers/food/snacks/mouseburger(src)
				to_chat(user, "You make a lizard burger!")
	if (result)
		if (W.reagents)
			//Reagents of reuslt objects will be the sum total of both.  Except in special cases where nonfood items are used
			//Eg robot head
			result.reagents.clear_reagents()
			W.reagents.trans_to(result, W.reagents.total_volume)
			reagents.trans_to(result, reagents.total_volume)

		//If the bun was in your hands, the result will be too
		if (loc == user)
			user.drop_from_inventory(src)
			user.put_in_hands(result)

// Chip update.
/obj/item/reagent_containers/food/snacks/tortilla
	name = "tortilla"
	desc = "A thin, flour-based tortilla that can be used in a variety of dishes, or can be served as is."
	icon_state = "tortilla"
	bitesize = 3
	nutriment_desc = list("tortilla" = 1)
	nutriment_amt = 6

//chips
/obj/item/reagent_containers/food/snacks/chip
	name = "chip"
	desc = "A portion sized chip good for dipping."
	icon_state = "chip"
	var/bitten_state = "chip_half"
	bitesize = 1
	nutriment_desc = list("fried tortilla chips" = 2)
	nutriment_amt = 2

/obj/item/reagent_containers/food/snacks/chip/on_consume(mob/M as mob)
	. = ..()
	if(reagents && reagents.total_volume)
		icon_state = bitten_state

/obj/item/reagent_containers/food/snacks/chip/salsa
	name = "salsa chip"
	desc = "A portion sized chip good for dipping. This one has salsa on it."
	icon_state = "chip_salsa"
	bitten_state = "chip_half"
	nutriment_desc = list("fried tortilla chips" = 1, "salsa" = 1)

/obj/item/reagent_containers/food/snacks/chip/guac
	name = "guac chip"
	desc = "A portion sized chip good for dipping. This one has guac on it."
	icon_state = "chip_guac"
	bitten_state = "chip_half"
	nutriment_desc = list("fried tortilla chips" = 1, "guacamole" = 1)

/obj/item/reagent_containers/food/snacks/chip/cheese
	name = "cheese chip"
	desc = "A portion sized chip good for dipping. This one has cheese sauce on it."
	icon_state = "chip_cheese"
	bitten_state = "chip_half"
	nutriment_desc = list("fried tortilla chips" = 1, "cheese" = 1)

/obj/item/reagent_containers/food/snacks/chip/nacho
	name = "nacho chip"
	desc = "A nacho ship stray from a plate of cheesy nachos."
	icon_state = "chip_nacho"
	bitten_state = "chip_half"
	nutriment_desc = list("nacho chips" = 2)

/obj/item/reagent_containers/food/snacks/chip/nacho/salsa
	name = "nacho chip"
	desc = "A nacho ship stray from a plate of cheesy nachos. This one has salsa on it."
	icon_state = "chip_nacho_salsa"
	bitten_state = "chip_half"

/obj/item/reagent_containers/food/snacks/chip/nacho/guac
	name = "nacho chip"
	desc = "A nacho ship stray from a plate of cheesy nachos. This one has guac on it."
	icon_state = "chip_nacho_guac"
	bitten_state = "chip_half"

/obj/item/reagent_containers/food/snacks/chip/nacho/cheese
	name = "nacho chip"
	desc = "A nacho ship stray from a plate of cheesy nachos. This one has extra cheese on it."
	icon_state = "chip_nacho_cheese"
	bitten_state = "chip_half"

// chip plates
/obj/item/reagent_containers/food/snacks/chipplate
	name = "basket of chips"
	desc = "A plate of chips intended for dipping."
	icon_state = "chip_basket"
	trash = /obj/item/trash/chipbasket
	var/vendingobject = /obj/item/reagent_containers/food/snacks/chip
	nutriment_desc = list("tortilla chips" = 10)
	bitesize = 1
	nutriment_amt = 10

/obj/item/reagent_containers/food/snacks/chipplate/attack_hand(mob/user)
	. = ..()
	var/obj/item/reagent_containers/food/snacks/returningitem = new vendingobject(loc)
	returningitem.reagents.clear_reagents()
	reagents.trans_to_holder(returningitem.reagents, bitesize)
	returningitem.bitesize = bitesize/2
	user.put_in_hands(returningitem)
	if (reagents && reagents.total_volume)
		to_chat(user, "You take a chip from the plate.")
	else
		to_chat(user, "You take the last chip from the plate.")
		var/obj/waste = new trash(loc)
		if (loc == user)
			user.put_in_hands(waste)
		qdel(src)

/obj/item/reagent_containers/food/snacks/chipplate/MouseDrop(mob/user) //Dropping the chip onto the user
	if(istype(user) && user == usr)
		user.put_in_active_hand(src)
		src.pickup(user)
		return
	. = ..()

/obj/item/reagent_containers/food/snacks/chipplate/nachos
	name = "plate of nachos"
	desc = "A very cheesy nacho plate."
	icon_state = "nachos"
	trash = /obj/item/trash/plate
	vendingobject = /obj/item/reagent_containers/food/snacks/chip/nacho
	nutriment_desc = list("tortilla chips" = 10)
	bitesize = 1
	nutriment_amt = 10

//dips
/obj/item/reagent_containers/food/snacks/dip
	name = "queso dip"
	desc = "A simple, cheesy dip consisting of tomatos, cheese, and spices."
	var/nachotrans = /obj/item/reagent_containers/food/snacks/chip/nacho/cheese
	var/chiptrans = /obj/item/reagent_containers/food/snacks/chip/cheese
	icon_state = "dip_cheese"
	trash = /obj/item/trash/dipbowl
	bitesize = 1
	nutriment_desc = list("queso" = 20)
	nutriment_amt = 20

/obj/item/reagent_containers/food/snacks/dip/attackby(obj/item/reagent_containers/food/snacks/item as obj, mob/user as mob)
	. = ..()
	var/obj/item/reagent_containers/food/snacks/returningitem
	if(istype(item,/obj/item/reagent_containers/food/snacks/chip/nacho) && item.icon_state == "chip_nacho")
		returningitem = new nachotrans(src)
	else if (istype(item,/obj/item/reagent_containers/food/snacks/chip) && (item.icon_state == "chip" || item.icon_state == "chip_half"))
		returningitem = new chiptrans(src)
	if(returningitem)
		returningitem.reagents.clear_reagents() //Clear the new chip
		var/memed = 0
		item.reagents.trans_to_holder(returningitem.reagents, item.reagents.total_volume) //Old chip to new chip
		if(item.icon_state == "chip_half")
			returningitem.icon_state = "[returningitem.icon_state]_half"
			returningitem.bitesize = clamp(returningitem.reagents.total_volume,1,10)
		else if(prob(1))
			memed = 1
			to_chat(user, "You scoop up some dip with the chip, but mid-scoop, the chip breaks off into the dreadful abyss of dip, never to be seen again...")
			returningitem.icon_state = "[returningitem.icon_state]_half"
			returningitem.bitesize = clamp(returningitem.reagents.total_volume,1,10)
		else
			returningitem.bitesize = clamp(returningitem.reagents.total_volume*0.5,1,10)
		qdel(item)
		reagents.trans_to_holder(returningitem.reagents, bitesize) //Dip to new chip
		user.put_in_hands(returningitem)

		if (reagents && reagents.total_volume)
			if(!memed)
				to_chat(user, "You scoop up some dip with the chip.")
		else
			if(!memed)
				to_chat(user, "You scoop up the remaining dip with the chip.")
			var/obj/waste = new trash(loc)
			if (loc == user)
				user.put_in_hands(waste)
			qdel(src)

/obj/item/reagent_containers/food/snacks/dip/salsa
	name = "salsa dip"
	desc = "Traditional Sol chunky salsa dip containing tomatos, peppers, and spices."
	nachotrans = /obj/item/reagent_containers/food/snacks/chip/nacho/salsa
	chiptrans = /obj/item/reagent_containers/food/snacks/chip/salsa
	icon_state = "dip_salsa"
	nutriment_desc = list("salsa" = 20)
	nutriment_amt = 20

/obj/item/reagent_containers/food/snacks/dip/guac
	name = "guac dip"
	desc = "A recreation of the ancient Sol 'Guacamole' dip using tofu, limes, and spices. This recreation obviously leaves out mole meat."
	nachotrans = /obj/item/reagent_containers/food/snacks/chip/nacho/guac
	chiptrans = /obj/item/reagent_containers/food/snacks/chip/guac
	icon_state = "dip_guac"
	nutriment_desc = list("guacamole" = 20)
	nutriment_amt = 20

//burritos
/obj/item/reagent_containers/food/snacks/burrito
	name = "meat burrito"
	desc = "Meat wrapped in a flour tortilla. It's a burrito by definition."
	icon_state = "burrito"
	bitesize = 4
	nutriment_desc = list("tortilla" = 6)
	nutriment_amt = 6

/obj/item/reagent_containers/food/snacks/burrito/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)


/obj/item/reagent_containers/food/snacks/burrito_vegan
	name = "vegan burrito"
	desc = "Tofu wrapped in a flour tortilla. Those seen with this food object are Valid."
	icon_state = "burrito_vegan"
	bitesize = 4
	nutriment_desc = list("tortilla" = 6)
	nutriment_amt = 6

/obj/item/reagent_containers/food/snacks/burrito_vegan/Initialize()
	. = ..()
	reagents.add_reagent("tofu", 6)

/obj/item/reagent_containers/food/snacks/burrito_spicy
	name = "spicy meat burrito"
	desc = "Meat and chilis wrapped in a flour tortilla."
	icon_state = "burrito_spicy"
	bitesize = 4
	nutriment_desc = list("tortilla" = 6)
	nutriment_amt = 6

/obj/item/reagent_containers/food/snacks/burrito_spicy/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)

/obj/item/reagent_containers/food/snacks/burrito_cheese
	name = "meat cheese burrito"
	desc = "Meat and melted cheese wrapped in a flour tortilla."
	icon_state = "burrito_cheese"
	bitesize = 4
	nutriment_desc = list("tortilla" = 6)
	nutriment_amt = 6

/obj/item/reagent_containers/food/snacks/burrito_cheese/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)

/obj/item/reagent_containers/food/snacks/burrito_cheese_spicy
	name = "spicy cheese meat burrito"
	desc = "Meat, melted cheese, and chilis wrapped in a flour tortilla."
	icon_state = "burrito_cheese_spicy"
	bitesize = 4
	nutriment_desc = list("tortilla" = 6)
	nutriment_amt = 6

/obj/item/reagent_containers/food/snacks/burrito_cheese_spicy/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)

/obj/item/reagent_containers/food/snacks/burrito_hell
	name = "el diablo"
	desc = "Meat and an insane amount of chilis packed in a flour tortilla. The Chaplain will see you now."
	icon_state = "burrito_hell"
	bitesize = 4
	nutriment_desc = list("hellfire" = 6)
	nutriment_amt = 24// 10 Chilis is a lot.

/obj/item/reagent_containers/food/snacks/breakfast_wrap
	name = "breakfast wrap"
	desc = "Bacon, eggs, cheese, and tortilla grilled to perfection."
	icon_state = "breakfast_wrap"
	bitesize = 4
	nutriment_desc = list("tortilla" = 6)
	nutriment_amt = 6

/obj/item/reagent_containers/food/snacks/burrito_hell/Initialize()
	. = ..()
	reagents.add_reagent("protein", 9)
	reagents.add_reagent("condensedcapsaicin", 20) //what could possibly go wrong

/obj/item/reagent_containers/food/snacks/burrito_mystery
	name = "mystery meat burrito"
	desc = "The mystery is, why aren't you BSAing it?"
	icon_state = "burrito_mystery"
	bitesize = 5
	nutriment_desc = list("regret" = 6)
	nutriment_amt = 6

/obj/item/reagent_containers/food/snacks/hatchling_suprise
	name = "hatchling suprise"
	desc = "A poached egg on top of three slices of bacon. A typical breakfast for hungry Unathi children."
	icon_state = "hatchling_suprise"
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_containers/food/snacks/hatchling_suprise/Initialize()
	. = ..()
	reagents.add_reagent("egg", 2)
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/red_sun_special
	name = "red sun special"
	desc = "One lousy piece of sausage sitting on melted cheese curds. A cheap meal for the Unathi peasants of Moghes."
	icon_state = "red_sun_special"
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/red_sun_special/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)

/obj/item/reagent_containers/food/snacks/riztizkzi_sea
	name = "moghesian sea delight"
	desc = "Three raw eggs floating in a sea of blood. An authentic replication of an ancient Unathi delicacy."
	icon_state = "riztizkzi_sea"
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_containers/food/snacks/riztizkzi_sea/Initialize()
	. = ..()
	reagents.add_reagent("egg", 4)

/obj/item/reagent_containers/food/snacks/father_breakfast
	name = "breakfast of champions"
	desc = "A sausage and an omelette on top of a grilled steak."
	icon_state = "father_breakfast"
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/father_breakfast/Initialize()
	. = ..()
	reagents.add_reagent("egg", 4)
	reagents.add_reagent("protein", 6)

/obj/item/reagent_containers/food/snacks/stuffed_meatball
	name = "stuffed meatball" //YES
	desc = "A meatball loaded with cheese."
	icon_state = "stuffed_meatball"

/obj/item/reagent_containers/food/snacks/stuffed_meatball/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/egg_pancake
	name = "meat pancake"
	desc = "An omelette baked on top of a giant meat patty. This monstrousity is typically shared between four people during a dinnertime meal."
	icon_state = "egg_pancake"
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/egg_pancake/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("egg", 2)

/obj/item/reagent_containers/food/snacks/sliceable/grilled_carp
	name = "korlaaskak"
	desc = "A well-dressed carp, seared to perfection and adorned with herbs and spices. Can be sliced into proper serving sizes."
	icon_state = "grilled_carp"
	slice_path = /obj/item/reagent_containers/food/snacks/grilled_carp_slice
	slices_num = 6
	trash = /obj/item/trash/snacktray

/obj/item/reagent_containers/food/snacks/sliceable/grilled_carp/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 12)

/obj/item/reagent_containers/food/snacks/grilled_carp_slice
	name = "korlaaskak slice"
	desc = "A well-dressed fillet of carp, seared to perfection and adorned with herbs and spices."
	icon_state = "grilled_carp_slice"
	trash = /obj/item/trash/plate


// SYNNONO MEME FOODS EXPANSION - Credit to Synnono from Aurorastation. Come play here sometime :(

/obj/item/reagent_containers/food/snacks/redcurry
	name = "red curry"
	gender = PLURAL
	desc = "A bowl of creamy red curry with meat and rice. This one looks savory."
	icon_state = "redcurry"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#f73333"
	nutriment_amt = 8
	nutriment_desc = list("savory meat and rice" = 8)

/obj/item/reagent_containers/food/snacks/redcurry/Initialize()
	. = ..()
	reagents.add_reagent("protein", 7)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/greencurry
	name = "green curry"
	gender = PLURAL
	desc = "A bowl of creamy green curry with tofu, hot peppers and rice. This one looks spicy!"
	icon_state = "greencurry"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#58b76c"
	nutriment_amt = 12
	nutriment_desc = list("tofu and rice" = 12)

/obj/item/reagent_containers/food/snacks/greencurry/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)
	reagents.add_reagent("capsaicin", 2)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/yellowcurry
	name = "yellow curry"
	gender = PLURAL
	desc = "A bowl of creamy yellow curry with potatoes, peanuts and rice. This one looks mild."
	icon_state = "yellowcurry"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#bc9509"
	nutriment_amt = 13
	nutriment_desc = list("rice and potatoes" = 13)

/obj/item/reagent_containers/food/snacks/yellowcurry/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/bearburger
	name = "bearburger"
	desc = "The solution to your unbearable hunger."
	icon_state = "bearburger"
	filling_color = "#5d5260"

/obj/item/reagent_containers/food/snacks/bearburger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4) //So spawned burgers will not be empty I guess?
	bitesize = 5

/obj/item/reagent_containers/food/snacks/bearchili
	name = "bear chili"
	gender = PLURAL
	desc = "A dark, hearty chili. Can you bear the heat?"
	icon_state = "bearchili"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#702708"
	nutriment_amt = 3
	nutriment_desc = list("dark, hearty chili" = 3)

/obj/item/reagent_containers/food/snacks/bearchili/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)
	reagents.add_reagent("capsaicin", 3)
	reagents.add_reagent("tomatojuice", 2)
	reagents.add_reagent("hyperzine", 5)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/bearstew
	name = "bear stew"
	gender = PLURAL
	desc = "A thick, dark stew of bear meat and vegetables."
	icon_state = "bearstew"
	filling_color = "#9E673A"
	nutriment_amt = 6
	nutriment_desc = list("hearty stew" = 6)

/obj/item/reagent_containers/food/snacks/bearstew/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	reagents.add_reagent("hyperzine", 5)
	reagents.add_reagent("tomatojuice", 5)
	reagents.add_reagent("imidazoline", 5)
	reagents.add_reagent("water", 5)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/bibimbap
	name = "bibimbap bowl"
	desc = "A traditional Korean meal of meat and mixed vegetables. It's served on a bed of rice, and topped with a fried egg."
	icon_state = "bibimbap"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#4f2100"
	nutriment_amt = 10
	nutriment_desc = list("egg" = 5, "vegetables" = 5)

/obj/item/reagent_containers/food/snacks/bibimbap/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/lomein
	name = "lo mein"
	gender = PLURAL
	desc = "A popular Chinese noodle dish. Chopsticks optional."
	icon_state = "lomein"
	trash = /obj/item/trash/plate
	filling_color = "#FCEE81"
	nutriment_amt = 8
	nutriment_desc = list("noodles" = 6, "sesame sauce" = 2)

/obj/item/reagent_containers/food/snacks/lomein/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/friedrice
	name = "fried rice"
	gender = PLURAL
	desc = "A less-boring dish of less-boring rice!"
	icon_state = "friedrice"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	nutriment_amt = 7
	nutriment_desc = list("rice" = 7)

/obj/item/reagent_containers/food/snacks/friedrice/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/chickenfillet
	name = "chicken fillet sandwich"
	desc = "Fried chicken, in sandwich format. Beauty is simplicity."
	icon_state = "chickenfillet"
	filling_color = "#E9ADFF"
	nutriment_amt = 4
	nutriment_desc = list("breading" = 4)

/obj/item/reagent_containers/food/snacks/chickenfillet/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/chilicheesefries
	name = "chili cheese fries"
	gender = PLURAL
	desc = "A mighty plate of fries, drowned in hot chili and cheese sauce. Because your arteries are overrated."
	icon_state = "chilicheesefries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	nutriment_amt = 8
	nutriment_desc = list("hearty, cheesy fries" = 8)

/obj/item/reagent_containers/food/snacks/chilicheesefries/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)
	reagents.add_reagent("capsaicin", 2)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/friedmushroom
	name = "fried mushroom"
	desc = "A tender, beer-battered plump helmet, fried to crispy perfection."
	icon_state = "friedmushroom"
	filling_color = "#EDDD00"
	nutriment_amt = 4
	nutriment_desc = list("alcoholic mushrooms" = 4)

/obj/item/reagent_containers/food/snacks/friedmushroom/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/pisanggoreng
	name = "pisang goreng"
	gender = PLURAL
	desc = "Crispy, starchy, sweet banana fritters. Popular street food in parts of Sol."
	icon_state = "pisanggoreng"
	trash = /obj/item/trash/plate
	filling_color = "#301301"
	nutriment_amt = 8
	nutriment_desc = list("sweet bananas" = 8)

/obj/item/reagent_containers/food/snacks/pisanggoreng/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/meatbun
	name = "meat bun"
	desc = "A soft, fluffy flour bun also known as baozi. This one is filled with a spiced meat filling."
	icon_state = "meatbun"
	filling_color = "#edd7d7"
	nutriment_amt = 5
	nutriment_desc = list("spice" = 5)

/obj/item/reagent_containers/food/snacks/meatbun/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/custardbun
	name = "custard bun"
	desc = "A soft, fluffy flour bun also known as baozi. This one is filled with an egg custard."
	icon_state = "meatbun"
	nutriment_amt = 6
	nutriment_desc = list("egg custard" = 6)
	filling_color = "#ebedc2"

/obj/item/reagent_containers/food/snacks/custardbun/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/chickenmomo
	name = "chicken momo"
	gender = PLURAL
	desc = "A plate of spiced and steamed chicken dumplings. The style originates from south Asia."
	icon_state = "tajaran_soup"
	trash = /obj/item/trash/snacktray
	filling_color = "#edd7d7"
	nutriment_amt = 9
	nutriment_desc = list("spiced chicken" = 9)

/obj/item/reagent_containers/food/snacks/chickenmomo/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/veggiemomo
	name = "veggie momo"
	gender = PLURAL
	desc = "A plate of spiced and steamed vegetable dumplings. The style originates from south Asia."
	icon_state = "tajaran_soup"
	trash = /obj/item/trash/snacktray
	filling_color = "#edd7d7"
	nutriment_amt = 13
	nutriment_desc = list("spiced vegetables" = 13)

/obj/item/reagent_containers/food/snacks/veggiemomo/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/risotto
	name = "risotto"
	gender = PLURAL
	desc = "A creamy, savory rice dish from southern Europe, typically cooked slowly with wine and broth. This one has bits of mushroom."
	icon_state = "risotto"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#edd7d7"
	nutriment_amt = 9
	nutriment_desc = list("savory rice" = 6, "cream" = 3)

/obj/item/reagent_containers/food/snacks/risotto/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/risottoballs
	name = "risotto balls"
	gender = PLURAL
	desc = "Mushroom risotto that has been battered and deep fried. The best use of leftovers!"
	icon_state = "risottoballs"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#edd7d7"
	nutriment_amt = 1
	nutriment_desc = list("batter" = 1)

/obj/item/reagent_containers/food/snacks/risottoballs/Initialize()
	. = ..()
	bitesize = 3

/obj/item/reagent_containers/food/snacks/honeytoast
	name = "piece of honeyed toast"
	desc = "For those who like their breakfast sweet."
	icon_state = "honeytoast"
	trash = /obj/item/trash/plate
	filling_color = "#EDE5AD"
	nutriment_amt = 1
	nutriment_desc = list("sweet, crunchy bread" = 1)

/obj/item/reagent_containers/food/snacks/honeytoast/Initialize()
	. = ..()
	bitesize = 4

/obj/item/reagent_containers/food/snacks/poachedegg
	name = "poached egg"
	desc = "A delicately poached egg with a runny yolk. Healthier than its fried counterpart."
	icon_state = "poachedegg"
	trash = /obj/item/trash/plate
	filling_color = "#FFDF78"
	nutriment_amt = 1
	nutriment_desc = list("egg" = 1)

/obj/item/reagent_containers/food/snacks/poachedegg/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)
	reagents.add_reagent("blackpepper", 1)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/ribplate
	name = "plate of ribs"
	desc = "A half-rack of ribs, brushed with some sort of honey-glaze. Why are there no napkins on board?"
	icon_state = "ribplate"
	trash = /obj/item/trash/plate
	filling_color = "#7A3D11"
	nutriment_amt = 6
	nutriment_desc = list("barbecue" = 6)

/obj/item/reagent_containers/food/snacks/ribplate/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("triglyceride", 2)
	reagents.add_reagent("blackpepper", 1)
	reagents.add_reagent("honey", 5)
	bitesize = 4

// SLICEABLE FOODS - SYNNONO MEME FOOD EXPANSION - Credit to Synnono from Aurorastation (again)

/obj/item/reagent_containers/food/snacks/sliceable/keylimepie
	name = "key lime pie"
	desc = "A tart, sweet dessert. What's a key lime, anyway?"
	icon_state = "keylimepie"
	slice_path = /obj/item/reagent_containers/food/snacks/keylimepieslice
	slices_num = 5
	filling_color = "#F5B951"
	nutriment_amt = 16
	nutriment_desc = list("lime" = 12, "graham crackers" = 4)

/obj/item/reagent_containers/food/snacks/sliceable/keylimepie/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/keylimepieslice
	name = "slice of key lime pie"
	desc = "A slice of tart pie, with whipped cream on top."
	icon_state = "keylimepieslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 3
	nutriment_desc = list("lime" = 1)

/obj/item/reagent_containers/food/snacks/keylimepieslice/filled
	nutriment_amt = 1

/obj/item/reagent_containers/food/snacks/sliceable/quiche
	name = "quiche"
	desc = "Real men eat this, contrary to popular belief."
	icon_state = "quiche"
	slice_path = /obj/item/reagent_containers/food/snacks/quicheslice
	slices_num = 5
	filling_color = "#F5B951"
	nutriment_amt = 10
	nutriment_desc = list("cheese" = 5, "egg" = 5)

/obj/item/reagent_containers/food/snacks/sliceable/quiche/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)

/obj/item/reagent_containers/food/snacks/quicheslice
	name = "slice of quiche"
	desc = "A slice of delicious quiche. Eggy, cheesy goodness."
	icon_state = "quicheslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 3
	nutriment_desc = list("cheesy eggs" = 1)

/obj/item/reagent_containers/food/snacks/quicheslice/filled
	nutriment_amt = 1

/obj/item/reagent_containers/food/snacks/quicheslice/filled/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)

/obj/item/reagent_containers/food/snacks/sliceable/brownies
	name = "brownies"
	gender = PLURAL
	desc = "Halfway to fudge, or halfway to cake? Who cares!"
	icon_state = "brownies"
	slice_path = /obj/item/reagent_containers/food/snacks/browniesslice
	slices_num = 4
	trash = /obj/item/trash/brownies
	filling_color = "#301301"
	nutriment_amt = 8
	nutriment_desc = list("fudge" = 8)

/obj/item/reagent_containers/food/snacks/sliceable/brownies/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/browniesslice
	name = "brownie"
	desc = "A dense, decadent chocolate brownie."
	icon_state = "browniesslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 2
	nutriment_desc = list("fudge" = 1)

/obj/item/reagent_containers/food/snacks/browniesslice/filled
	nutriment_amt = 1

/obj/item/reagent_containers/food/snacks/browniesslice/filled/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)

/obj/item/reagent_containers/food/snacks/sliceable/cosmicbrownies
	name = "cosmic brownies"
	gender = PLURAL
	desc = "Like, ultra-trippy. Brownies HAVE no gender, man." //Except I had to add one!
	icon_state = "cosmicbrownies"
	slice_path = /obj/item/reagent_containers/food/snacks/cosmicbrowniesslice
	slices_num = 4
	trash = /obj/item/trash/brownies
	filling_color = "#301301"
	nutriment_amt = 8
	nutriment_desc = list("fudge" = 8)

/obj/item/reagent_containers/food/snacks/sliceable/cosmicbrownies/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)
	reagents.add_reagent("space_drugs", 2)
	reagents.add_reagent("bicaridine", 1)
	reagents.add_reagent("kelotane", 1)
	reagents.add_reagent("toxin", 1)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cosmicbrowniesslice
	name = "cosmic brownie"
	desc = "A dense, decadent and fun-looking chocolate brownie."
	icon_state = "cosmicbrowniesslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 3
	nutriment_desc = list("fudge" = 1)

/obj/item/reagent_containers/food/snacks/cosmicbrowniesslice/filled
	nutriment_amt = 1

/obj/item/reagent_containers/food/snacks/cosmicbrowniesslice/filled/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)


/obj/item/reagent_containers/food/snacks/wormsickly
	name = "sickly worm"
	desc = "A worm, it doesn't look particularily healthy, but it will still serve as good fishing bait."
	icon_state = "worm_sickly"
	nutriment_amt = 1
	nutriment_desc = list("bugflesh" = 1)
	w_class = ITEMSIZE_TINY

/obj/item/reagent_containers/food/snacks/wormsickly/Initialize()
	. = ..()
	reagents.add_reagent("fishbait", 10)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/worm
	name = "strange worm"
	desc = "A peculiar worm, freshly plucked from the earth."
	icon_state = "worm"
	nutriment_amt = 1
	nutriment_desc = list("bugflesh" = 1)
	w_class = ITEMSIZE_TINY

/obj/item/reagent_containers/food/snacks/worm/Initialize()
	. = ..()
	reagents.add_reagent("fishbait", 20)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/wormdeluxe
	name = "deluxe worm"
	desc = "A fancy worm, genetically engineered to appeal to fish."
	icon_state = "worm_deluxe"
	nutriment_amt = 5
	nutriment_desc = list("bugflesh" = 1)
	w_class = ITEMSIZE_TINY

/obj/item/reagent_containers/food/snacks/wormdeluxe/Initialize()
	. = ..()
	reagents.add_reagent("fishbait", 40)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/siffruit
	name = "pulsing fruit"
	desc = "A blue-ish sac encased in a tough black shell."
	icon = 'icons/obj/flora/foraging.dmi'
	icon_state = "siffruit"
	nutriment_amt = 2
	nutriment_desc = list("tart" = 1)
	w_class = ITEMSIZE_TINY

/obj/item/reagent_containers/food/snacks/siffruit/Initialize()
	. = ..()
	reagents.add_reagent("sifsap", 2)

/obj/item/reagent_containers/food/snacks/siffruit/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(istype(O,/obj/machinery/microwave))
		return ..()
	if(!(proximity && O.is_open_container()))
		return
	to_chat(user, "<span class='notice'>You tear \the [src]'s sac open, pouring it into \the [O].</span>")
	reagents.trans_to(O, reagents.total_volume)
	user.drop_from_inventory(src)
	qdel(src)

/obj/item/reagent_containers/food/snacks/baschbeans
	name = "Basch's Baked Beans"
	icon_state = "baschbeans"
	desc = "In partnership with the Cyan Consumables Corporation, Basch is proud to produce its classic beans in a brand new package. A frontier favorite!"
	trash = /obj/item/trash/baschbeans
	filling_color = "#FC6F28"
	nutriment_amt = 4
	nutriment_desc = list("beans" = 4)

/obj/item/reagent_containers/food/snacks/baschbeans/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/creamcorn
	name = "Garm n' Bozia's Cream Corn"
	icon_state = "creamcorn"
	desc = "This is a formica label. Green is its color. The Cyan Consumables Corporation refuses to reveal where these cans come from."
	trash = /obj/item/trash/creamcorn
	filling_color = "#FFFAD4"
	nutriment_amt = 5
	nutriment_desc = list("corn" = 5)

/obj/item/reagent_containers/food/snacks/creamcorn/Initialize()
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/crayonburger_red // Buff 6 >> 15
	name = "red crayonburger"
	desc = "Someone has melted a whole crayon over the top of this patty!"
	icon_state = "crayonburg_red"
	nutriment_amt = 7
	nutriment_desc = list("bun" = 2, "wax" = 2, "meat" = 1)

/obj/item/reagent_containers/food/snacks/crayonburger_red/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/crayonburger_org // Buff 6 >> 15
	name = "orange crayonburger"
	desc = "Someone has melted a whole crayon over the top of this patty!"
	icon_state = "crayonburg_org"
	nutriment_amt = 7
	nutriment_desc = list("bun" = 2, "wax" = 2, "meat" = 1)

/obj/item/reagent_containers/food/snacks/crayonburger_org/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/crayonburger_yel // Buff 6 >> 15
	name = "yellow crayonburger"
	desc = "Someone has melted a whole crayon over the top of this patty!"
	icon_state = "crayonburg_yel"
	nutriment_amt = 7
	nutriment_desc = list("bun" = 2, "wax" = 2, "meat" = 1)

/obj/item/reagent_containers/food/snacks/crayonburger_yel/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/crayonburger_grn // Buff 6 >> 15
	name = "green crayonburger"
	desc = "Someone has melted a whole crayon over the top of this patty!"
	icon_state = "crayonburg_grn"
	nutriment_amt = 7
	nutriment_desc = list("bun" = 2, "wax" = 2, "meat" = 1)

/obj/item/reagent_containers/food/snacks/crayonburger_grn/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/crayonburger_blu // Buff 6 >> 15
	name = "blue crayonburger"
	desc = "Someone has melted a whole crayon over the top of this patty!"
	icon_state = "crayonburg_blu"
	nutriment_amt = 7
	nutriment_desc = list("bun" = 2, "wax" = 2, "meat" = 1)

/obj/item/reagent_containers/food/snacks/crayonburger_blu/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/crayonburger_prp // Buff 6 >> 15
	name = "purple crayonburger"
	desc = "Someone has melted a whole crayon over the top of this patty!"
	icon_state = "crayonburg_prp"
	nutriment_amt = 7
	nutriment_desc = list("bun" = 2, "wax" = 2, "meat" = 1)

/obj/item/reagent_containers/food/snacks/crayonburger_prp/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/crayonburger_rbw // Buff 6 >> 15
	name = "rainbow crayonburger"
	desc = "Someone has melted a whole crayon over the top of this patty! This one seems especially rare!"
	icon_state = "crayonburg_rbw"
	nutriment_amt = 7
	nutriment_desc = list("bun" = 2, "wax" = 2, "meat" = 1, "color" = 1)

/obj/item/reagent_containers/food/snacks/crayonburger_rbw/Initialize()
	. = ..()
	reagents.add_reagent("protein", 12)
	bitesize = 3

//I guess we're not always eating PEOPLE.
/*
/obj/item/reagent_containers/food/snacks/my_new_food
	name = "cheesemeaties"
	desc = "The cheese adds a good flavor. Not great. Just good"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "cheesemeaties"
	trash = /obj/item/trash/plate //What I leave behind when eaten (waffles instead of plate = bigsquareplate)
	center_of_mass = list("x"=16, "y"=16) //If your thing is too huge and you don't want it in the center.
	nutriment_amt = 5
	nutriment_desc = list("gargonzola" = 2, "burning" = 2)

/obj/item/reagent_containers/food/snacks/my_new_food/Initialize()
	..()
	reagents.add_reagent("protein", 2) //For meaty things.
	bitesize = 3 //How many reagents to transfer per bite?
*/

/obj/item/reagent_containers/food/snacks/sliceable/sushi // Buff 25 >> 35
	name = "sushi roll"
	desc = "A whole sushi roll! Slice it up and enjoy with some soy sauce and wasabi."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "sushi"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/sushi/filled
	slices_num = 5
	nutriment_desc = list("rice" = 5, "fish" = 5)
	nutriment_amt = 20

/obj/item/reagent_containers/food/snacks/sliceable/sushi/Initialize()
	..()
	reagents.add_reagent("protein", 15)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/slice/sushi/filled
	name = "piece of sushi"
	desc = "A slice of a larger sushi roll, ready to devour."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "sushi_s"
	bitesize = 5
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/sushi

/obj/item/reagent_containers/food/snacks/slice/sushi/filled/filled
	filled = TRUE


/obj/item/reagent_containers/food/snacks/lasagna
	name = "lasagna"
	desc = "Meaty, tomato-y, and ready to eat-y. Favorite of cats."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "lasagna"
	nutriment_amt = 5
	nutriment_desc = list("tomato" = 4, "meat" = 2)

/obj/item/reagent_containers/food/snacks/lasagna/Initialize()
	..()
	reagents.add_reagent("protein", 2) //For meaty things.


/obj/item/reagent_containers/food/snacks/goulash
	name = "goulash"
	desc = "Paprika put to good use, finally, in a soup of meat and vegetables."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "goulash"
	trash = /obj/item/trash/snack_bowl
	nutriment_amt = 6
	nutriment_desc = list("meat" = 2, "vegetables" = 2, "seasoning" = 5)

/obj/item/reagent_containers/food/snacks/goulash/Initialize()
	..()
	reagents.add_reagent("protein", 3) //For meaty things.
	reagents.add_reagent("water", 5)


/obj/item/reagent_containers/food/snacks/donerkebab
	name = "doner kebab"
	desc = "A delicious sandwich-like food from ancient Earth. The meat is typically cooked on a vertical rotisserie."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "doner_kebab"
	nutriment_amt = 5
	nutriment_desc = list("vegetables" = 2, "seasoned meat" = 5)

/obj/item/reagent_containers/food/snacks/donerkebab/Initialize()
	..()
	reagents.add_reagent("protein", 2) //For meaty things.


/obj/item/reagent_containers/food/snacks/roastbeef
	name = "roast beef"
	desc = "It's beef. It's roasted. It's been a staple of dining tradition for centuries."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "roastbeef"
	trash = /obj/item/trash/waffles
	nutriment_amt = 8
	nutriment_desc = list("cooked meat" = 5)

/obj/item/reagent_containers/food/snacks/roastbeef/Initialize()
	..()
	reagents.add_reagent("protein", 4) //For meaty things.
	bitesize = 2


/obj/item/reagent_containers/food/snacks/reishicup
	name = "reishi's cup"
	desc = "A chocolate treat with an odd flavor."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "reishiscup"
	nutriment_amt = 3
	nutriment_desc = list("chocolate" = 4, "colors" = 2)

/obj/item/reagent_containers/food/snacks/reishicup/Initialize()
	..()
	reagents.add_reagent("psilocybin", 3)
	bitesize = 6

/obj/item/storage/box/wings //This is kinda like the donut box.
	name = "wing basket"
	desc = "A basket of chicken wings! Get some before they're all gone! Or maybe you're too late..."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "wings5"
	var/startswith = 5
	max_storage_space = ITEMSIZE_COST_SMALL * 5
	can_hold = list(/obj/item/reagent_containers/food/snacks/chickenwing)
	foldable = null

/obj/item/storage/box/wings/Initialize()
	..()
	for(var/i=1 to startswith)
		new /obj/item/reagent_containers/food/snacks/chickenwing(src)
	update_icon()
	return

/obj/item/storage/box/wings/update_icon()
	var/i = 0
	for(var/obj/item/reagent_containers/food/snacks/chickenwing/W in contents)
		i++
	icon_state = "wings[i]"

/obj/item/reagent_containers/food/snacks/chickenwing
	name = "chicken wing"
	desc = "What flavor even is this? Buffalo? Barbeque? Or something more exotic?"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "wing"
	nutriment_amt = 2
	nutriment_desc = list("chicken" = 2, "unplacable flavor sauce" = 4)

/obj/item/reagent_containers/food/snacks/chickenwing/Initialize()
	..()
	reagents.add_reagent("protein", 1)
	bitesize = 3


/obj/item/reagent_containers/food/snacks/hotandsoursoup
	name = "hot & sour soup"
	desc = "A soup both spicy and sour from ancient Earth cooking traditions. This one is made with tofu."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "hotandsoursoup"
	trash = /obj/item/trash/snack_bowl
	nutriment_amt = 6
	nutriment_desc = list("spicyness" = 4, "sourness" = 4, "tofu" = 1)

/obj/item/reagent_containers/food/snacks/hotandsoursoup/Initialize()
	..()
	bitesize = 2


/obj/item/reagent_containers/food/snacks/kitsuneudon
	name = "kitsune udon"
	desc = "A purported favorite of kitsunes in ancient japanese myth: udon noodles, fried egg, and tofu."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "kitsuneudon"
	trash = /obj/item/trash/snack_bowl
	nutriment_amt = 6
	nutriment_desc = list("fried egg" = 2, "egg noodles" = 4)

/obj/item/reagent_containers/food/snacks/kitsuneudon/Initialize()
	..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/generalschicken
	name = "general's chicken"
	desc = "Sweet, spicy, and fried. General's Chicken has been around for more than five-hundred years now, and still tastes good."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "generaltso"
	trash = /obj/item/trash/plate
	nutriment_amt = 6
	nutriment_desc = list("sweet and spicy sauce" = 5, "chicken" = 3)

/obj/item/reagent_containers/food/snacks/generalschicken/Initialize()
	..()
	reagents.add_reagent("protein", 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meat/grubmeat
	name = "grubmeat"
	desc = "A slab of grub meat, it gives a gentle shock if you touch it"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "grubmeat"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/snacks/meat/grubmeat/Initialize()
	..()
	reagents.add_reagent("protein", 1)
	reagents.add_reagent("shockchem", 6)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/bugball
	name = "bugball"
	desc = "A hard chitin, dont chip a tooth!"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "pillbugball"
	slice_path = /obj/item/reagent_containers/food/snacks/pillbug
	slices_num = 1
	trash = /obj/item/reagent_containers/food/snacks/pillbug
	nutriment_amt = 1
	nutriment_desc = list("crunchy shell bits" = 5)

/obj/item/reagent_containers/food/snacks/bugball/Initialize()
	..()
	reagents.add_reagent("protein", 1)
	reagents.add_reagent("carbon", 5)
	bitesize = 7

/obj/item/reagent_containers/food/snacks/pillbug
	name = "pillbug"
	desc = "A delicacy discovered and popularized by a famous restaurant called Mudca's Meat Hut."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "pillbug"
	trash = /obj/item/reagent_containers/food/snacks/pillbugempty
	nutriment_amt = 3
	nutriment_desc = list("sparkles" = 5, "ancient inca culture" =3)

/obj/item/reagent_containers/food/snacks/pillbug/Initialize()
	..()
	reagents.add_reagent("protein", 3)
	reagents.add_reagent("shockchem", 6)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/pillbugempty
	name = "pillbug shell"
	desc = "Waste not, want not."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "pillbugempty"
	nutriment_amt = 1
	nutriment_desc = list("crunchy shell bits" = 5)

/obj/item/reagent_containers/food/snacks/pillbug/Initialize()
	..()
	reagents.add_reagent("protein", 1)
	reagents.add_reagent("carbon", 5)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/mammi
	name = "mämmi"
	desc = "Traditional finnish desert, some like it, others don't. It's drifting in some milk, add sugar!"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "mammi"
	trash = /obj/item/trash/plate
	nutriment_amt = 3
	nutriment_desc = list("brothy sweet goodness" = 5)

/obj/item/reagent_containers/food/snacks/mammi/Initialize()
	..()
	bitesize = 3

/obj/item/reagent_containers/food/snacks/makaroni
	name = "makaronilaatikko"
	desc = "A special kind of macaroni, it's a big dish, and this one has special meat in it."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "makaroni"
	trash = /obj/item/trash/plate
	nutriment_amt = 15
	nutriment_desc = list("cheese" = 5, "eggs" = 3, "pasta" = 4, "sparkles" = 3)

/obj/item/reagent_containers/food/snacks/makaroni/Initialize()
	..()
	reagents.add_reagent("protein", 1)
	reagents.add_reagent("shockchem", 6)
	bitesize = 7

/obj/item/reagent_containers/food/snacks/lobster
	name = "raw lobster"
	desc = "a shifty lobster. You can try eating it, but its shell is extremely tough."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "lobster_raw"
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/lobster/Initialize()
	..()
	bitesize = 0.1

/obj/item/reagent_containers/food/snacks/lobstercooked
	name = "cooked lobster"
	desc = "a luxurious plate of cooked lobster, its taste accentuated by lemon juice. Reinvigorating!"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "lobster_cooked"
	trash = /obj/item/trash/plate
	nutriment_amt = 20
	nutriment_desc = list("lemon" = 2, "lobster" = 5, "salad" = 2)

/obj/item/reagent_containers/food/snacks/lobstercooked/Initialize()
	..()
	bitesize = 5
	reagents.add_reagent("protein", 20)
	reagents.add_reagent("tricordrazine", 5)
	reagents.add_reagent("iron", 5)

/obj/item/reagent_containers/food/snacks/cuttlefish
	name = "raw cuttlefish"
	desc = "it's an adorable squid! you can't possible be thinking about eating this right?"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "cuttlefish_raw"
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/cuttlefish/Initialize()
	..()
	bitesize = 10

/obj/item/reagent_containers/food/snacks/cuttlefishcooked
	name = "cooked cuttlefish"
	desc = "it's a roasted cuttlefish. rubbery, squishy, an acquired taste."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "cuttlefish_cooked"
	nutriment_amt = 20
	nutriment_desc = list("cuttlefish" = 5, "rubber" = 5, "grease" = 1)

/obj/item/reagent_containers/food/snacks/cuttlefishcooked/Initialize()
	..()
	bitesize = 5
	reagents.add_reagent("protein", 10)

/obj/item/reagent_containers/food/snacks/sliceable/monkfish
	name = "extra large monkfish"
	desc = "it's a huge monkfish. better clean it first, you can't possibly eat it like this."
	icon = 'icons/obj/food48x48_vr.dmi'
	icon_state = "monkfish_raw"
	nutriment_amt = 30
	w_class = ITEMSIZE_HUGE //Is that a monkfish in your pocket, or are you just happy to see me?
	slice_path = /obj/item/reagent_containers/food/snacks/monkfishfillet
	slices_num = 6
	trash = /obj/item/reagent_containers/food/snacks/sliceable/monkfishremains

/obj/item/reagent_containers/food/snacks/sliceable/monkfish/Initialize()
	..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/monkfishfillet
	name = "monkfish fillet"
	desc = "it's a fillet sliced from a monkfish."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "monkfish_fillet"
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/monkfishfillet/Initialize()
	..()
	bitesize = 3
	reagents.add_reagent("protein", 1)

/obj/item/reagent_containers/food/snacks/monkfishcooked
	name = "seasoned monkfish"
	desc = "a delicious slice of monkfish prepared with sweet chili and spring onion."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "monkfish_cooked"
	nutriment_amt = 10
	nutriment_desc = list("fish" = 3, "oil" = 1, "sweet chili" = 3, "spring onion" = 2)
	trash = /obj/item/trash/fancyplate

/obj/item/reagent_containers/food/snacks/monkfishcooked/Initialize()
	..()
	bitesize = 4
	reagents.add_reagent("protein", 5)

/obj/item/reagent_containers/food/snacks/sliceable/monkfishremains
	name = "monkfish remains"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "monkfish_remains"
	desc = "the work of a madman."
	w_class = ITEMSIZE_LARGE
	nutriment_amt = 10
	slice_path = /obj/item/clothing/head/fish
	slices_num = 1

/obj/item/reagent_containers/food/snacks/sliceable/monkfishremains/Initialize()
	..()
	bitesize = 0.01 //impossible to eat
	reagents.add_reagent("carbon", 5)

/obj/item/reagent_containers/food/snacks/monkeycube/sobakacube
	name = "sobaka cube"
	monkey_type = "Sobaka"

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/sobakacube
	name = "sobaka cube"
	monkey_type = "Sobaka"

/obj/item/reagent_containers/food/snacks/monkeycube/sarucube
	name = "saru cube"
	monkey_type = "Saru"

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/sarucube
	name = "saru cube"
	monkey_type = "Saru"

/obj/item/reagent_containers/food/snacks/monkeycube/sparracube
	name = "sparra cube"
	monkey_type = "Sparra"

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/sparracube
	name = "sparra cube"
	monkey_type = "Sparra"

/obj/item/reagent_containers/food/snacks/monkeycube/wolpincube
	name = "wolpin cube"
	monkey_type = "Wolpin"

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/wolpincube
	name = "wolpin cube"
	monkey_type = "Wolpin"

/obj/item/reagent_containers/food/snacks/pizza/margfrozen
	name = "frozen margherita pizza"
	desc = "It's frozen rock solid, better thaw it in a microwave."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "margharita_pizza_frozen"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 15
	nutriment_desc = list("ice" = 5, "toothache" = 1, "frozen cheese" = 5, "frozen tomato" = 5)

/obj/item/reagent_containers/food/snacks/pizza/margfrozen/Initialize()
	..()
	bitesize = 20
	//reagents.add_reagent("frostoil",3)

/obj/item/reagent_containers/food/snacks/sliceable/pizza/margcargo
	name = "Margherita"
	desc = "The golden standard of pizzas, it looks drowned in tomato sauce."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "margharita_pizza_cargo"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/margcargo
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("pizza crust" = 10, "tomato" = 15, "cheese" = 5)
	nutriment_amt = 10

/obj/item/reagent_containers/food/snacks/sliceable/pizza/margcargo/Initialize()
	..()
	reagents.add_reagent("protein", 2)
	reagents.add_reagent("tomatojuice", 10)
	bitesize = 2
	//reagents.remove_reagent("frostoil",3)

/obj/item/reagent_containers/food/snacks/slice/margcargo
	name = "Margherita slice"
	desc = "A slice of the classic pizza, it's hard not to spill any tomato juice on yourself."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "margharita_pizza_slice_cargo"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/margcargo

/obj/item/reagent_containers/food/snacks/slice/margcargo/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/pizza/meatfrozen
	name = "frozen meat pizza"
	desc = "It's frozen rock solid, better thaw it in a microwave."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "meat_pizza_frozen"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 15
	nutriment_desc = list("ice" = 5, "toothache" = 1, "frozen meat" = 5, "frozen cow screams" = 5)

/obj/item/reagent_containers/food/snacks/pizza/meatfrozen/Initialize()
	..()
	bitesize = 20
	//reagents.add_reagent("frostoil",3)

/obj/item/reagent_containers/food/snacks/sliceable/pizza/meatcargo
	name = "Meatpizza"
	desc = "A pizza with meat topping, some of it suspiciously pink."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "meat_pizza_cargo"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/meatcargo
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("meat" = 10, "beef" = 10, "squeaky pork" = 15, "longpig" = 5)
	nutriment_amt = 10

/obj/item/reagent_containers/food/snacks/sliceable/pizza/meatcargo/Initialize()
	..()
	reagents.add_reagent("protein", 20)
	reagents.add_reagent("tomatojuice", 6)
	bitesize = 2
	//reagents.remove_reagent("frostoil",3)

/obj/item/reagent_containers/food/snacks/slice/meatcargo
	name = "Meatpizza slice"
	desc = "A slice of a meaty pizza, there are some bits of supiciously pink meat."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "meat_pizza_slice_cargo"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatcargo

/obj/item/reagent_containers/food/snacks/slice/meatcargo/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/pizza/mushfrozen
	name = "frozen mushroom pizza"
	desc = "It's frozen rock solid, better thaw it in a microwave."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "mushroom_pizza_frozen"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 15
	nutriment_desc = list("ice" = 5, "toothache" = 1, "frozen mushrooms" = 5, "frozen cream" = 5)

/obj/item/reagent_containers/food/snacks/pizza/mushfrozen/Initialize()
	..()
	bitesize = 20
	//reagents.add_reagent("frostoil",3)

/obj/item/reagent_containers/food/snacks/sliceable/pizza/mushcargo
	name = "Mushroompizza"
	desc = "Very special pizza, it looks to be drowned in cream."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "mushroom_pizza_cargo"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/mushcargo
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("pizza crust" = 10, "cheese" = 5, "creamy sauce" = 5, "mushroom" = 5)
	nutriment_amt = 10

/obj/item/reagent_containers/food/snacks/sliceable/pizza/mushcargo/Initialize()
	..()
	reagents.add_reagent("protein", 4)
	bitesize = 2
	//reagents.remove_reagent("frostoil",3)

/obj/item/reagent_containers/food/snacks/slice/mushcargo
	name = "Mushroompizza slice"
	desc = "Very special pizza slice, it looks to be drowned in cream."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "mushroom_pizza_slice_cargo"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushcargo

/obj/item/reagent_containers/food/snacks/slice/mushcargp/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/pizza/vegfrozen
	name = "frozen vegtable pizza"
	desc = "It's frozen rock solid, better thaw it in a microwave."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "vegetable_pizza_frozen"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 15
	nutriment_desc = list("ice" = 5, "toothache" = 1, "frozen vegtable chunks" = 5)

/obj/item/reagent_containers/food/snacks/pizza/vegfrozen/Initialize()
	..()
	bitesize = 20
	//reagents.add_reagent("frostoil",3)

/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegcargo
	name = "Vegetablepizza"
	desc = "At least 10 of Tomato Sapiens were harmed during making this pizza."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "vegetable_pizza_cargo"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/vegcargo
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("pizza crust" = 10, "tomato" = 20, "cheese" = 5, "eggplant" = 5, "carrot" = 5, "corn" = 5)
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegcargo/Initialize()
	..()
	reagents.add_reagent("protein", 4)
	reagents.add_reagent("tomatojuice", 15)
	reagents.add_reagent("imidazoline", 10)
	bitesize = 2
	//reagents.remove_reagent("frostoil",3)

/obj/item/reagent_containers/food/snacks/slice/vegcargo
	name = "Vegtablepizza slice"
	desc = "At least 10 of Tomato Sapiens were harmed during making this pizza."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "vegetable_pizza_slice_cargo"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegcargo

/obj/item/reagent_containers/food/snacks/slice/vegcargo/filled
	filled = TRUE

/obj/item/pizzabox/margherita/Initialize()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/margcargo(src)

/obj/item/pizzabox/vegetable/Initialize()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegcargo(src)

/obj/item/pizzabox/mushroom/Initialize()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushcargo(src)

/obj/item/pizzabox/meat/Initialize()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatcargo(src)
