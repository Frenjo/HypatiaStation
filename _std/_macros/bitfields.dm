// Macros to test for bits in a bitfield. Note, that this is for use with indexes, not bit-masks!
#define BITTEST(bitfield, index) ((bitfield) & (1 << (index)))
#define BITSET(bitfield, index) (bitfield) |= (1 << (index))
#define BITRESET(bitfield, index) (bitfield) &= ~(1 << (index))
#define BITFLIP(bitfield, index) (bitfield) ^= (1 << (index))