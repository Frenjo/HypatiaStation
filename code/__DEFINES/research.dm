#define	DESIGN_TYPE_IMPRINTER	1	// For circuits. Uses glass/chemicals.
#define DESIGN_TYPE_PROTOLATHE	2	// New stuff. Uses glass/metal/chemicals
#define	DESIGN_TYPE_AUTOLATHE	4	// Uses glass/metal only.
#define DESIGN_TYPE_CRAFTLATHE	8	// Uses fuck if I know. For use eventually.
// Remember, objects utilising the below flags should have construction_time and construction_cost vars.
#define DESIGN_TYPE_ROBOFAB		16
#define DESIGN_TYPE_MECHFAB		32
// Note: More then one of these can be added to a design but imprinter and lathe designs are incompatable.