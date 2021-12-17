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
/* In real Object Oriented Programming, LDJSON should be a separate Perl Class */
/* So I am doing something like the original proof of concept, just holding a pointer here */
/* This is still a per User custom attribute instead of a global custom attribute */
struct LDJSON   *custom;

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

        custom = LDNewObject();
        # Becasue this is a pointer, I can set the custom attribute here. This is not the standard SDK way though.
        LDUserSetCustom(RETVAL, custom);
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

int
set_custom_attribute(XS::LaunchDarkly::User ldUser, char * key, char * value)
CODE:
    struct LDJSON *tmp;
    struct LDJSON *values = LDNewArray();

    tmp = LDNewText(value);
    if (tmp == NULL)
        RETVAL = 0;
    if (LDArrayPush(values, tmp) != 1)
        RETVAL = 0;
    if (LDObjectSetKey(custom, key, values) != 1)
        RETVAL = 0;

    RETVAL = 1;
OUTPUT:
    RETVAL

