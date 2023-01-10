/obj/machinery/computer/podbay_doors //Idea: Check access or for password to open pod bay from outside
	name = "Pod bay manual door controls"
	icon = 'icons/obj/computer.dmi'
	icon_state = "tetris"
	desc = "Manual pod bay doors. Scan your ID or type in the password"
	machine_registry_idx = MACHINES_MISC
	circuit_type = /obj/item/circuitboard/tetris
	var/id = null
	var/timer = 0
	var/cooldown = 0 SECONDS
	var/inuse = FALSE


/obj/machinery/door_control/New()
	..()
	UnsubscribeProcess()

/obj/machinery/door_control/attack_ai(mob/user as mob)
	return src.Attackhand(user)

/obj/machinery/door_control/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/device/detective_scanner))
		return
	return src.Attackhand(user)

/obj/machinery/door_control/attack_hand(mob/user)
	if((src.status & (NOPOWER|BROKEN)) || inuse)
		return

	if (user.getStatusDuration("stunned") || user.getStatusDuration("weakened") || user.stat)
		return

	src.use_power(5)
	playsound(src.loc, 'sound/machines/button.ogg', 40, 0.5)

	if (!src.id)
		return

	logTheThing(LOG_STATION, user, "toggled the [src.name] at [log_loc(src)].")

	for (var/obj/machinery/door/poddoor/M in by_type[/obj/machinery/door])
		if (M.id == src.id)
			if (M.density)
				M.open()
				if (src.timer)
					SPAWN(src.timer)
						M.close()
			else
				M.close()
				if (src.timer)
					SPAWN(src.timer)
						M.open()

	for (var/obj/machinery/door/airlock/M in by_type[/obj/machinery/door])
		if (M.id == src.id)
			if (M.density)
				M.open()
			else
				M.close()

	for (var/obj/machinery/conveyor/M as anything in machine_registry[MACHINES_CONVEYORS]) // Workaround for the stacked conveyor belt issue (Convair880).
		if (M.id == src.id)
			if (M.operating)
				M.operating = 0
				if (src.timer)
					SPAWN(src.timer)
						M.operating = 1
			else
				M.operating = 1
				if (src.timer)
					SPAWN(src.timer)
						M.operating = 0
			M.setdir()

	if(src.cooldown)
		inuse = TRUE
		sleep(src.cooldown)
		inuse = FALSE

	SPAWN(1.5 SECONDS)
		if(!(src.status & NOPOWER))
			icon_state = "doorctrl0"
	src.add_fingerprint(user)

/obj/machinery/door_control/power_change()
	..()
	if(src.status & NOPOWER)
		icon_state = "doorctrl-p"
	else
		icon_state = "doorctrl0"

/obj/machinery/door_control/oneshot/attack_hand(mob/user)
	..()
	if (!(src.status & BROKEN))
		src.status |= BROKEN
		src.visible_message("<span class='alert'>[src] emits a sad thunk.  That can't be good.</span>")
		playsound(src.loc, 'sound/impact_sounds/Generic_Click_1.ogg', 50, 1)
	else
		boutput(user, "<span class='alert'>It's broken.</span>")
