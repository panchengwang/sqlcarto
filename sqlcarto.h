/**********************************************************************
 *
 * SQLCarto -
 *
 **********************************************************************
 *
 * Copyright 2012-2013 pcwang <sqlcarto@163.com>
 *
 **********************************************************************/

#include "postgres.h"
#include "access/gist.h"
#include "access/itup.h"
#include "fmgr.h"
#include "utils/elog.h"
#include "utils/geo_decls.h"
#include "funcapi.h"
#include "lwgeom_pg.h"
#include "liblwgeom.h"
#include "liblwgeom_internal.h"

#include <stdio.h>
#include <math.h>
#include <string.h>
#include "access/gist.h"
#include "access/stratnum.h"
#include "utils/array.h"
#include "utils/float.h"
#include "utils/builtins.h"
#include <signal.h>

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif


