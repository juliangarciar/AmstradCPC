#include "boss1.h"
// Data created with Img2CPC - (c) Retroworks - 2007-2015
// Tile sprite_boss1: 32x32 pixels, 16x32 bytes.
const u8 sprite_boss1[16 * 32] = {
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x3c, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3c, 0x3c, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x14, 0xff, 0x28, 0x00, 0x00, 0x14, 0x3c, 0x33, 0x33, 0x28, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x39, 0xff, 0x28, 0x00, 0x14, 0x39, 0x33, 0xff, 0x33, 0x9e, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x6d, 0x77, 0x28, 0x14, 0x39, 0x33, 0x33, 0xff, 0x33, 0x67, 0x28, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x6d, 0x33, 0x36, 0x39, 0x33, 0x33, 0x33, 0x33, 0x33, 0x67, 0x28, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x6d, 0x9b, 0x33, 0x33, 0xff, 0xbb, 0x33, 0x39, 0x33, 0x33, 0x28, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x14, 0xcf, 0x33, 0x77, 0x3c, 0x7d, 0xbb, 0x33, 0x39, 0x33, 0x9e, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x6d, 0x33, 0xbe, 0x3c, 0x3c, 0xff, 0xbb, 0x33, 0x33, 0x67, 0x28, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x39, 0x33, 0xbe, 0x3c, 0x28, 0x00, 0xff, 0xff, 0xbb, 0x67, 0x9e, 0x00, 0x00, 0x00,
	0x00, 0x14, 0x33, 0x33, 0x77, 0x3c, 0x00, 0x00, 0x00, 0xbe, 0x7d, 0x33, 0x9e, 0x00, 0x3c, 0x28,
	0x00, 0x39, 0x33, 0xff, 0x33, 0xff, 0xcf, 0x3f, 0x00, 0x00, 0x3c, 0xbb, 0x9e, 0x14, 0xff, 0x36,
	0x00, 0x39, 0x77, 0xff, 0xbb, 0x77, 0xff, 0xcf, 0x2a, 0x00, 0x3c, 0xbb, 0x67, 0x7d, 0xbb, 0x9e,
	0x14, 0x67, 0x77, 0xff, 0xbb, 0x33, 0x77, 0xff, 0x8a, 0xaa, 0x3c, 0xbb, 0x33, 0xff, 0x67, 0x9e,
	0x14, 0x67, 0x33, 0xff, 0x33, 0x33, 0x33, 0x77, 0xff, 0xff, 0xff, 0x33, 0x9b, 0x33, 0xcf, 0x28,
	0x14, 0x67, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0xcf, 0xcf, 0x3c, 0x00,
	0x14, 0xcf, 0x9b, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x67, 0x9e, 0x3c, 0x00, 0x00,
	0x14, 0xed, 0xcf, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x9b, 0x9e, 0x00, 0x00, 0x00,
	0x6d, 0xfc, 0xcf, 0xcf, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x67, 0x67, 0x36, 0x00, 0x00, 0x00,
	0x6d, 0xde, 0xfc, 0xde, 0x9b, 0x33, 0x33, 0x33, 0x33, 0x33, 0xcf, 0xcf, 0x36, 0x00, 0x00, 0x00,
	0x6d, 0x67, 0xfc, 0xfc, 0xcf, 0xcf, 0x33, 0x33, 0x33, 0xcf, 0xcf, 0xde, 0x36, 0x00, 0x00, 0x00,
	0x14, 0x33, 0xde, 0x7c, 0xcf, 0xcf, 0xcf, 0xcf, 0xcf, 0xcf, 0xcf, 0xfc, 0x36, 0x00, 0x00, 0x00,
	0x00, 0x3c, 0x3c, 0xfc, 0xfc, 0xcf, 0xcf, 0xcf, 0xde, 0xcf, 0xfc, 0xfc, 0x36, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x14, 0xcf, 0xfc, 0xfc, 0xfc, 0xfc, 0xfc, 0xfc, 0xfc, 0xb9, 0x28, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x14, 0x33, 0xde, 0xbc, 0xed, 0xde, 0xfc, 0xfc, 0xfc, 0x36, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x6d, 0xfc, 0x3c, 0x9b, 0x67, 0xbc, 0xfc, 0xbc, 0x28, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x14, 0x3c, 0x14, 0x39, 0xde, 0x3c, 0xcf, 0xde, 0x28, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x14, 0x3c, 0x14, 0x33, 0xde, 0x28, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3c, 0x3c, 0x00, 0x00, 0x00, 0x00, 0x00
};
