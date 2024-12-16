 /**********************************************************************
 *
 * Copyright 2012-2013 pcwang <sqlcarto@163.com>
 *
 **********************************************************************/

#include "sqlcarto.h"


/*
 * This is required for builds against pgsql
 */
PG_MODULE_MAGIC;
#ifdef WIN32
static void interruptCallback() {
  if (UNBLOCKED_SIGNAL_QUEUE())
    pgwin32_dispatch_queued_signals();
}
#endif

static pqsigfunc coreIntHandler = 0;
static void handleInterrupt(int sig);

/*
 * Module load callback
 */
void _PG_init(void);
void
_PG_init(void)
{

  coreIntHandler = pqsignal(SIGINT, handleInterrupt);

#ifdef WIN32
  GEOS_interruptRegisterCallback(interruptCallback);
  lwgeom_register_interrupt_callback(interruptCallback);
#endif

    /* install PostgreSQL handlers */
    pg_install_lwgeom_handlers();
}

/*
 * Module unload callback
 */
void _PG_fini(void);
void
_PG_fini(void)
{
  elog(NOTICE, "Goodbye from PostGIS sqlcarto %s", POSTGIS_VERSION);
  pqsignal(SIGINT, coreIntHandler);
}


static void
handleInterrupt(int sig)
{
  /* NOTE: printf here would be dangerous, see
   * https://trac.osgeo.org/postgis/ticket/3644
   *
   * TODO: block interrupts during execution, to fix the problem
   */
  /* printf("Interrupt requested\n"); fflush(stdout); */

  /* request interruption of liblwgeom as well */
  lwgeom_request_interrupt();

  if ( coreIntHandler ) {
    (*coreIntHandler)(sig);
  }
}

