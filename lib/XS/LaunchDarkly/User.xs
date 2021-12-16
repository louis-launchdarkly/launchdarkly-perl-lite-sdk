#define PERL_NO_GET_CONTEXT // we'll define thread context if necessary (faster)
#include "EXTERN.h"         // globals/constant import locations
#include "perl.h"           // Perl symbols, structures and constants definition
#include "XSUB.h"           // xsubpp functions and macros
#include <stdlib.h>       
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <launchdarkly/api.h>

/* My C is jank so I just create a pointer here to make calloc below works */
struct LDUser   *user;

/* Needed typedef to properly bind the LDClient C struct to the corresponding Perl object. */
typedef struct LDUser * XS__LaunchDarkly__User;

/* End of C Code */

MODULE = XS::LaunchDarkly::User  PACKAGE = XS::LaunchDarkly::User
PROTOTYPES: ENABLE

 # XS code goes here

 # XS comments begin with " #" to avoid them being interpreted as pre-processor
 # directives

TYPEMAP: <<HERE
XS::LaunchDarkly::User    T_PTROBJ
HERE

XS::LaunchDarkly::User
new (char * class, char * userKey)
CODE:
        RETVAL = calloc (1, sizeof (user));
        if (! RETVAL) {
                Perl_croak ("No memory for %s", class);
        }
        RETVAL = LDUserNew(userKey);
OUTPUT:
        RETVAL

void
DESTROY (ldUser)
        XS::LaunchDarkly::User ldUser;
CODE:
        free (ldUser);

int
set_user_name(XS::LaunchDarkly::User ldUser, char * username)
CODE:
    RETVAL = LDUserSetName(ldUser, username);
OUTPUT:
    RETVAL