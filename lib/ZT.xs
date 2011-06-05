#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "zt.h"

MODULE = ZT 	PACKAGE = ZT

void
foo ()
	CODE:
		zt();
	
