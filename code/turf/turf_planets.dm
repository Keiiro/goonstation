/* ============================================== */
/* -------------------- Base -------------------- */
/* ============================================== */

/turf/space/planet //Base for planet turfs.
	name = "planet base floor"
	desc = "You shouldn't be seeing this! Bug report this if you are."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "grass"
	pathable = 0
	mat_changename = 0
	mat_changedesc = 0
	mat_changeappearance = 0
	fullbright = 0
	luminosity = 1
	intact = 0
	throw_unlimited = 0

	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature = T20C // 293.15 - 235

	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 700000

	step_priority = STEP_PRIORITY_MED
	special_volume_override = -1

	//#ifdef MAP_OVERRIDE_DONUT3
	//turf = /turf/space/planet/mysli //Fix this
	//#endif

/* ============================================== */
/* --------------- Mysli - Floors --------------- */
/* ============================================== */

/turf/space/planet/mysli // Mysli's default terrain, snow.
	name = "Snow"
	desc = "Cold, cold snow."
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow1"
	step_material = "step_outdoors"
	step_priority = STEP_PRIORITY_MED
	var/overlay_ammount = 0

	New()
		..()
		if (prob(50))
			icon_state = "snow2"
		else if (prob(25))
			icon_state = "snow3"
		else if (prob(5))
			icon_state = "snow4"
		src.set_dir(pick(cardinal)) //Mesage admin

	Entered(mob/living/carbon/M as mob ) //Footprints handling. Caused an error when I spawned it while standing on it, however, couldn't replicate on further attempts.
		..()
		SPAWN(0.8)
			if(ishuman(M))
				if(src.overlay_ammount < 3) //Three seems good for tile, may change it to two if it's too much.
					var/image/F = image('icons/misc/mars_outpost.dmi', icon_state = "footprint", dir = M.dir) //Interesting...
					src.overlay_ammount += 1
					src.overlays += F
					sleep(30 SECONDS)
					src.overlays -= F
					src.overlay_ammount -= 1

	dense
		density = 1
		opacity = 1 //Mesage admin
