#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "zt.h"

MODULE = ZT::XS 	PACKAGE = ZT::XS

void
zt ()
	CODE:
		zt();
	
