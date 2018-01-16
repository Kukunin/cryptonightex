#ifndef __CRYPTONIGHT_H_INCLUDED
#define __CRYPTONIGHT_H_INCLUDED

#define MEMORY      2097152 /* 2 MiB */
#define MEMORY_LITE 1048576 /* 1 MiB */

#include "align.h"

struct cryptonight_ctx {
  VAR_ALIGN(16, uint8_t state0[200]);
  VAR_ALIGN(16, uint8_t state1[200]);
  VAR_ALIGN(16, uint8_t* memory);
};

#endif
