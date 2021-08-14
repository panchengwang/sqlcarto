#ifndef __SQLCARTO_H
#define __SQLCARTO_H

#include "postgres.h"

#include <stdio.h>
#include <math.h>
#include <string.h>
#include "access/gist.h"
#include "access/stratnum.h"
#include "utils/array.h"
#include "utils/float.h"


#include "libpgcommon/lwgeom_pg.h"
#include "liblwgeom/liblwgeom.h"
#include "geos_c.h"


#define SKIP_SPACE(p)       \
  while(p && isspace(*p))   \
  {                         \
    p++;                    \
  }


#endif
