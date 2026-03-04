// Eidolon
/obj/item/mecha_part/chassis/eidolon
	name = "\improper Eidolon chassis"

	construct_type = /datum/component/construction/mecha_chassis/eidolon
	target_icon = 'icons/obj/mecha/construction/eidolon.dmi'

/obj/item/mecha_part/part/eidolon
	icon = 'icons/obj/mecha/parts/eidolon.dmi'

/obj/item/mecha_part/part/eidolon/torso
	name = "\improper Eidolon torso"
	desc = "A torso salvaged from a destroyed Eidolon. Some of the material had to be scrapped, but at least the seat can fit a regular humanoid."
	icon_state = "harness"

/obj/item/mecha_part/part/eidolon/head
	name = "\improper Eidolon head"
	desc = "A head salvaged from a destroyed Eidolon. Gyroscopic sensors keep the user's vision stable while rolling. Do swarmers get sick or is it a design of their masters?"
	icon_state = "head"

/obj/item/mecha_part/part/eidolon/left_arm
	name = "\improper Eidolon left arm"
	desc = "A left arm salvaged from a destroyed Eidolon. Telescopic servos allow it to retract into the chassis, leaving only the armoured part exposed. As far as salvage goes, it appears to be in pristine condition."
	icon_state = "l_arm"

/obj/item/mecha_part/part/eidolon/right_arm
	name = "\improper Eidolon right arm"
	desc = "A right arm salvaged from a destroyed Eidolon. Telescopic servos allow it to retract into the chassis, leaving only the armoured part exposed. As far as salvage goes, it appears to be in pristine condition."
	icon_state = "r_arm"

/obj/item/mecha_part/part/eidolon/left_leg
	name = "\improper Eidolon left leg"
	desc = "A left leg salvaged from a destroyed Eidolon. Originally a well-muscled artificial leg, after being scrapped it lost most of its joints. Hopefully that won't affect performance."
	icon_state = "l_leg"

/obj/item/mecha_part/part/eidolon/right_leg
	name = "\improper Eidolon right leg"
	desc = "A right leg salvaged from a destroyed Eidolon. Originally a well-muscled artificial leg, after being scrapped it lost most of its joints. Hopefully that won't affect performance."
	icon_state = "r_leg"

/obj/item/mecha_part/part/eidolon/armour
	name = "\improper Eidolon armour plates"
	desc = "A set of armour plates salvaged from a destroyed Eidolon. They fit together spherically and are covered by a strange matrix that appears to shock anything on contact. Most of them are battered, but should still work."
	icon_state = "armour"

// Circuit Boards
/obj/item/circuitboard/mecha/eidolon
	icon = 'icons/obj/mecha/parts/eidolon.dmi'

/obj/item/circuitboard/mecha/eidolon/main
	name = "circuit board (\"Eidolon\" central control module)"

/obj/item/circuitboard/mecha/eidolon/peripherals
	name = "circuit board (\"Eidolon\" peripherals control module)"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/eidolon/targeting
	name = "circuit board (\"Eidolon\" weapon control & targeting module)"
	icon_state = "mcontroller"