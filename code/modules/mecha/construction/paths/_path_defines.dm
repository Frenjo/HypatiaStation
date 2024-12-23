// These are some temporary defines to centrally organise things and avoid spaghettification pending a larger construction step rework.
// I think eventually there will be /decl/construction_step similar to how /decl/air_alarm_mode works.

// Construction step examine descriptions
#define MECHA_DESC_PERIPHERAL_MODULE_SECURED	"The peripherals control module is secured."
#define MECHA_DESC_TARGETING_MODULE_INSTALLED	"The targeting module is installed."
#define MECHA_DESC_TARGETING_MODULE_SECURED		"The targeting module is secured."

#define MECHA_DESC_INTERNAL_ARMOUR_INSTALLED	"The internal armour is installed."
#define MECHA_DESC_INTERNAL_ARMOUR_WRENCHED		"The internal armour is wrenched."
#define MECHA_DESC_INTERNAL_ARMOUR_WELDED		"The internal armour is welded."

#define MECHA_DESC_EXTERNAL_ARMOUR_INSTALLED	"The external armour is installed."
#define MECHA_DESC_EXTERNAL_ARMOUR_WRENCHED		"The external armour is wrenched."
#define MECHA_DESC_EXTERNAL_CARAPACE_INSTALLED	"The external carapace is installed."
#define MECHA_DESC_EXTERNAL_CARAPACE_WRENCHED	"The external carapace is wrenched."

// Construction step text macros
#define MECHA_CONNECT_HYDRAULICS user.visible_message(\
SPAN_NOTICE("[user] connects \the [holder]' hydraulic systems."), SPAN_NOTICE("You connect \the [holder]' hydraulic systems."))
#define MECHA_DISCONNECT_HYDRAULICS user.visible_message(\
SPAN_NOTICE("[user] disconnects \the [holder]' hydraulic systems."), SPAN_NOTICE("You disconnect \the [holder]' hydraulic systems."))
#define MECHA_ACTIVATE_HYDRAULICS user.visible_message(\
SPAN_NOTICE("[user] activates \the [holder]' hydraulic systems."), SPAN_NOTICE("You activate \the [holder]' hydraulic systems."))
#define MECHA_DEACTIVATE_HYDRAULICS user.visible_message(\
SPAN_NOTICE("[user] deactivates \the [holder]' hydraulic systems."), SPAN_NOTICE("You deactivate \the [holder]' hydraulic systems."))
#define MECHA_ADD_WIRING user.visible_message(\
SPAN_NOTICE("[user] adds wiring to \the [holder]."), SPAN_NOTICE("You add wiring to \the [holder]."))
#define MECHA_ADJUST_WIRING user.visible_message(\
SPAN_NOTICE("[user] adjusts \the [holder]' wiring."), SPAN_NOTICE("You adjust \the [holder]' wiring."))
#define MECHA_DISCONNECT_WIRING user.visible_message(\
SPAN_NOTICE("[user] disconnects \the [holder]' wiring."), SPAN_NOTICE("You disconnect \the [holder]' wiring."))
#define MECHA_REMOVE_WIRING user.visible_message(\
SPAN_NOTICE("[user] removes the wiring from \the [holder]."), SPAN_NOTICE("You remove the wiring from \the [holder]."))

#define MECHA_INSTALL_CENTRAL_MODULE user.visible_message(\
SPAN_NOTICE("[user] installs the central control module into \the [holder]."), SPAN_NOTICE("You install the central control module into \the [holder]."))
#define MECHA_REMOVE_CENTRAL_MODULE user.visible_message(\
SPAN_NOTICE("[user] removes the central control module from \the [holder]."), SPAN_NOTICE("You remove the central control module from \the [holder]."))
#define MECHA_SECURE_CENTRAL_MODULE user.visible_message(\
SPAN_NOTICE("[user] secures \the [holder]' mainboard."), SPAN_NOTICE("You secure \the [holder]' mainboard."))
#define MECHA_UNSECURE_CENTRAL_MODULE user.visible_message(\
SPAN_NOTICE("[user] unfastens \the [holder]' mainboard."), SPAN_NOTICE("You unfasten \the [holder]' mainboard."))

#define MECHA_INSTALL_PERIPHERAL_MODULE user.visible_message(\
SPAN_NOTICE("[user] installs the peripherals control module into \the [holder]."), SPAN_NOTICE("You install the peripherals control module into \the [holder]."))
#define MECHA_REMOVE_PERIPHERAL_MODULE user.visible_message(\
SPAN_NOTICE("[user] removes the peripherals control module from \the [holder]."), SPAN_NOTICE("You remove the peripherals control module from \the [holder]."))
#define MECHA_SECURE_PERIPHERAL_MODULE user.visible_message(\
SPAN_NOTICE("[user] secures \the [holder]' peripherals control module."), SPAN_NOTICE("You secure \the [holder]' peripherals control module."))
#define MECHA_UNSECURE_PERIPHERAL_MODULE user.visible_message(\
SPAN_NOTICE("[user] unfastens \the [holder]' peripherals control module."), SPAN_NOTICE("You unfasten \the [holder]' peripherals control module."))

#define MECHA_INSTALL_WEAPON_MODULE user.visible_message(\
SPAN_NOTICE("[user] installs the weapon control module into \the [holder]."), SPAN_NOTICE("You install the weapon control module into \the [holder]."))
#define MECHA_REMOVE_WEAPON_MODULE user.visible_message(\
SPAN_NOTICE("[user] removes the weapon control module from \the [holder]."), SPAN_NOTICE("You remove the weapon control module from \the [holder]."))
#define MECHA_SECURE_WEAPON_MODULE user.visible_message(\
SPAN_NOTICE("[user] secures \the [holder]' weapon control module."), SPAN_NOTICE("You secure \the [holder]' weapon control module."))
#define MECHA_UNSECURE_WEAPON_MODULE user.visible_message(\
SPAN_NOTICE("[user] unfastens \the [holder]' weapon control module."), SPAN_NOTICE("You unfasten \the [holder]' weapon control module."))

#define MECHA_INSTALL_INTERNAL_ARMOUR user.visible_message(\
SPAN_NOTICE("[user] installs the internal armour layer on \the [holder]."), SPAN_NOTICE("You install the internal armour layer on \the [holder]."))
#define MECHA_REMOVE_INTERNAL_ARMOUR user.visible_message(\
SPAN_NOTICE("[user] pries the internal armour layer from \the [holder]."), SPAN_NOTICE("You pry the internal armour layer from \the [holder]."))
#define MECHA_SECURE_INTERNAL_ARMOUR user.visible_message(\
SPAN_NOTICE("[user] secures \the [holder]' internal armour layer."), SPAN_NOTICE("You secure \the [holder]' internal armour layer."))
#define MECHA_UNSECURE_INTERNAL_ARMOUR user.visible_message(\
SPAN_NOTICE("[user] unfastens \the [holder]' internal armour layer."), SPAN_NOTICE("You unfasten \the [holder]' internal armour layer."))
#define MECHA_WELD_INTERNAL_ARMOUR user.visible_message(\
SPAN_NOTICE("[user] welds the internal armour layer to \the [holder]."), SPAN_NOTICE("You weld the the internal armour layer to \the [holder]."))
#define MECHA_UNWELD_INTERNAL_ARMOUR user.visible_message(\
SPAN_NOTICE("[user] cuts the internal armour layer from \the [holder]."), SPAN_NOTICE("You cut the internal armour layer from \the [holder]."))

#define MECHA_INSTALL_EXTERNAL_ARMOUR user.visible_message(\
SPAN_NOTICE("[user] installs the external reinforced armour layer on \the [holder]."), SPAN_NOTICE("You install the external reinforced armour layer on \the [holder]."))
#define MECHA_REMOVE_EXTERNAL_ARMOUR user.visible_message(\
SPAN_NOTICE("[user] pries the external armour layer from \the [holder]."), SPAN_NOTICE("You pry the external armour layer from \the [holder]."))
#define MECHA_SECURE_EXTERNAL_ARMOUR user.visible_message(\
SPAN_NOTICE("[user] secures \the [holder]' external reinforced armour layer."), SPAN_NOTICE("You secure \the [holder]' external reinforced armour layer."))
#define MECHA_UNSECURE_EXTERNAL_ARMOUR user.visible_message(\
SPAN_NOTICE("[user] unfastens \the [holder]' external armour layer."), SPAN_NOTICE("You unfasten \the [holder]' external armour layer."))
#define MECHA_WELD_EXTERNAL_ARMOUR user.visible_message(\
SPAN_NOTICE("[user] welds the external armour layer to \the [holder]."), SPAN_NOTICE("You weld the external armour layer to \the [holder]."))

#define MECHA_INSTALL_EXTERNAL_CARAPACE user.visible_message(\
SPAN_NOTICE("[user] installs the external carapace on \the [holder]."), SPAN_NOTICE("You install the external carapace on \the [holder]."))
#define MECHA_REMOVE_EXTERNAL_CARAPACE user.visible_message(\
SPAN_NOTICE("[user] pries the external carapace from \the [holder]."),SPAN_NOTICE("You pry the external carapace from \the [holder]."))
#define MECHA_SECURE_EXTERNAL_CARAPACE user.visible_message(\
SPAN_NOTICE("[user] secures \the [holder]' external carapace."), SPAN_NOTICE("You secure \the [holder]' external carapace."))
#define MECHA_UNSECURE_EXTERNAL_CARAPACE user.visible_message(\
SPAN_NOTICE("[user] unfastens \the [holder]' external carapace."), SPAN_NOTICE("You unfasten \the [holder]' external carapace."))
#define MECHA_WELD_EXTERNAL_CARAPACE user.visible_message(\
SPAN_NOTICE("[user] welds the external carapace to \the [holder]."), SPAN_NOTICE("You weld the external carapace to \the [holder]."))

#define MECHA_INSTALL_ARMOUR_PLATES user.visible_message(\
SPAN_NOTICE("[user] installs armour plates on \the [holder]."), SPAN_NOTICE("You install armour plates on \the [holder]."))
#define MECHA_REMOVE_ARMOUR_PLATES user.visible_message(\
SPAN_NOTICE("[user] pries the armour plates from \the [holder]."), SPAN_NOTICE("You pry the armour plates from \the [holder]."))
#define MECHA_SECURE_ARMOUR_PLATES user.visible_message(\
SPAN_NOTICE("[user] secures \the [holder]' armour plates."), SPAN_NOTICE("You secure \the [holder]' armour plates."))
#define MECHA_UNSECURE_ARMOUR_PLATES user.visible_message(\
SPAN_NOTICE("[user] unfastens \the [holder]' armour plates."), SPAN_NOTICE("You unfasten \the [holder]' armour plates."))
#define MECHA_WELD_ARMOUR_PLATES user.visible_message(\
SPAN_NOTICE("[user] welds the armour plates to \the [holder]."), SPAN_NOTICE("You weld the armour plates to \the [holder]."))