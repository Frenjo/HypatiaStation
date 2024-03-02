/*
 * Item Flags
 * These are used by /obj/item/var/item_flags.
 */
// This flag is used on the flags variable for SUIT and HEAD items which stop pressure damage.
// To successfully stop you taking all pressure damage you must have both a suit and head item with this flag.
#define ITEM_FLAG_STOPS_PRESSURE_DAMAGE BITFLAG(0)
#define ITEM_FLAG_HAS_USE_DELAY			BITFLAG(1) // 1 second extra delay on use (Can be used once every 2s)
// 1 second attackby delay skipped (Can be used once every 0.2s).
// Most objects have a 1s attackby delay, which doesn't require a flag.
#define ITEM_FLAG_HAS_NO_DELAY				BITFLAG(2)
#define ITEM_FLAG_AIRTIGHT					BITFLAG(3) // Mask allows internals.
#define ITEM_FLAG_NO_SHIELD					BITFLAG(4) // Weapon not affected by shields.
#define ITEM_FLAG_NO_BLUDGEON				BITFLAG(5) // When an item has this it produces no "X has been hit by Y with Z" message with the default handler.
#define ITEM_FLAG_NO_SLIP					BITFLAG(6) // Prevents slipping on wet floors, in space etc.
#define ITEM_FLAG_COVERS_EYES				BITFLAG(7) // The item covers the eyes when worn.
#define ITEM_FLAG_COVERS_MOUTH				BITFLAG(8) // The item covers the mouth when worn.
#define ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT	BITFLAG(9) // Blocks the effect that chemical clouds would have on a mob --glasses, mask and helmets ONLY!
#define ITEM_FLAG_ONE_SIZE_FITS_ALL			BITFLAG(10)
#define ITEM_FLAG_PLASMAGUARD				BITFLAG(11) // Does not get contaminated by plasma.

/*
 * Inventory Slot Flags
 * These are used by /obj/item/var/slot_flags.
 */
#define SLOT_OCLOTHING	BITFLAG(1)
#define SLOT_ICLOTHING	BITFLAG(2)
#define SLOT_GLOVES		BITFLAG(3)
#define SLOT_EYES		BITFLAG(4)
#define SLOT_EARS		BITFLAG(5)
#define SLOT_MASK		BITFLAG(6)
#define SLOT_HEAD		BITFLAG(7)
#define SLOT_FEET		BITFLAG(8)
#define SLOT_ID			BITFLAG(9)
#define SLOT_BELT		BITFLAG(10)
#define SLOT_BACK		BITFLAG(11)
#define SLOT_POCKET		BITFLAG(12) // This is to allow items with a w_class of 3 or 4 to fit in pockets.
#define SLOT_DENYPOCKET	BITFLAG(13) // This is to deny items with a w_class of 2 or 1 to fit in pockets.
#define SLOT_TWOEARS	BITFLAG(14)
#define SLOT_LEGS		BITFLAG(15)

/*
 * Inventory Hiding Flags
 * These determine when a piece of clothing hides another. IE a helmet hiding glasses.
 * Used by /obj/item/var/inv_flags.
 */
// These apply only to the exterior suit:
#define INV_FLAG_HIDE_GLOVES		BITFLAG(0)
#define INV_FLAG_HIDE_SUIT_STORAGE	BITFLAG(1)
#define INV_FLAG_HIDE_JUMPSUIT		BITFLAG(2)
#define INV_FLAG_HIDE_SHOES			BITFLAG(3)
#define INV_FLAG_HIDE_TAIL 			BITFLAG(4)
// These apply only to helmets/masks:
#define INV_FLAG_HIDE_MASK	BITFLAG(5)
#define INV_FLAG_HIDE_EARS	BITFLAG(6)	// Ears means headsets and such.
#define INV_FLAG_HIDE_EYES	BITFLAG(7)	// Eyes means glasses.
#define INV_FLAG_HIDE_FACE	BITFLAG(8)	// Dictates whether we appear as unknown.

#define INV_FLAG_BLOCK_HEAD_HAIR	BITFLAG(9)	// temporarily removes the user's hair overlay. Leaves facial hair.
#define INV_FLAG_BLOCK_HAIR			BITFLAG(10)	// temporarily removes the user's hair, facial and otherwise.