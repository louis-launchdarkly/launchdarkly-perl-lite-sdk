#define PERL_NO_GET_CONTEXT // we'll define thread context if necessary (faster)
#include "EXTERN.h"         // globals/constant import locations
#include "perl.h"           // Perl symbols, structures and constants definition
#include "XSUB.h"           // xsubpp functions and macros
#include <stdlib.h>       
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <launchdarkly/api.h>

/* Globals */
char * sdkKey;
struct LDClient *client;
struct LDConfig *config;
struct LDUser   *user;
struct LDJSON   *custom;

/* Create LD client */
int CreateClient(char * key, int timeout) {
    config = LDConfigNew(key);
    client = LDClientInit(config, timeout);
    if (LDClientIsInitialized(client) != 1) 
        return 0;

    custom = LDNewObject();
    return 1;
}

/* To disable streaming, set to false */
int ConfigSetStream(bool stream) {
    LDConfigSetStream(config, stream);

    return 1;
}

/* Set the stream URI */
int ConfigSetStreamURI(char * URI) {
    if (LDConfigSetStreamURI(config, URI) != 1)
        return 0;

    return 1;
}

/* Set the base URI for LDCOnfig */
int ConfigSetBaseURI(char * URI) {
    if (LDConfigSetBaseURI(config, URI) != 1)
        return 0;

    return 1;
}

/* Set events URI */
int ConfigSetEventsURI(char * URI) {
    if (LDConfigSetEventsURI(config, URI) != 1)
        return 0;
    
    return 1;
}

/* Set User Key */
int UserNew(char * userkey) {
    user = LDUserNew(userkey);
    if (user == NULL)
        return 0;

    return 1;
}

/* Set Username - built in field */
int SetUserName(char * username) {
    if (LDUserSetName(user, username) != 1)
        return 0;

    return 1;
}

/* Set Country - built in field */
int UserSetCountry(char * country) {
     if (LDUserSetCountry(user, country) != 1)
        return 0;
     
     return 1;
}

/* Set Email - built in field */
int UserSetEmail(char * email) {
    if (LDUserSetEmail(user, email) != 1)
        return 0;

    return 1;
}

/* Set IP - built in field */
int UserSetIP(char * IP) {
    if (LDUserSetIP(user, IP) != 1)
         return 0;

    return 1;
}

/* Set First Name - built in field */
int UserSetFirstName(char * firstname) {
     if (LDUserSetFirstName(user, firstname) != 1)
        return 0;

     return 1;
}

/* Set Last Name - built in field */
int UserSetLastName(char * lastname) {
     if (LDUserSetLastName(user, lastname) != 1)
        return 0;
     
     return 1;
}

/* Set user to be anonymous */
int UserSetAnonymous(bool anon) {
    LDUserSetAnonymous(user, anon);

    return 1;
}

/* Set Custom Attribute */
int SetCustomAttribute(char * key, char * value) {
    struct LDJSON *tmp;
    struct LDJSON *values = LDNewArray();

    tmp = LDNewText(value);
    if (tmp == NULL)
        return 0;
    if (LDArrayPush(values, tmp) != 1)
        return 0;
    if (LDObjectSetKey(custom, key, values) != 1)
        return 0;

    return 1;
}

/* Build Custom Attributes */
int BuildCustomAttributes() {
    LDUserSetCustom(user, custom);

    return 1;
}

/* Set Private Custom Attribute */
int SetPrivateCustomAttribute(char * key) {
    if (LDConfigAddPrivateAttribute(config, key) != 1)
        return 0;

    return 1;
}

/* Sets all custom attributes private if true */
int ConfigSetAllAttributesPrivate(bool private) {
    LDConfigSetAllAttributesPrivate(config, private);

    return 1;
}

/* Bool Variation */
bool BoolVariation(char *flagKey, bool fallback) {
    LDBoolean flag_value = LDBoolVariation(client, user, flagKey, fallback, NULL);
    return flag_value;
}

/* Int Variation */
int IntVariation(char *flagKey, int fallback) {
    int flag_value = LDIntVariation(client, user, flagKey, fallback, NULL);
    return flag_value;
}

/* String variation */
char * StringVariation(char *flagKey, char * fallback) {
    char * flag_value = LDStringVariation(client, user, flagKey, fallback, NULL);
    return flag_value;
}

/* Flush Events */
int ClientFlush() {
    if (LDClientFlush(client) != 1)
        return 0;

    return 1;
}

/* Free User */
int UserFree() {
    LDUserFree(user);

    return 1;
}

/* Free client */
int ClientClose() {
    if (LDClientClose(client) != 1)
        return 0;

    return 1;
}

/* Louis test */
typedef struct LDClient * XS__LaunchDarkly__ld;

/* End of C Code */

MODULE = XS::LaunchDarkly::ld  PACKAGE = XS::LaunchDarkly::ld
PROTOTYPES: ENABLE

 # XS code goes here

 # XS comments begin with " #" to avoid them being interpreted as pre-processor
 # directives

TYPEMAP: <<HERE
LDClient *  T_PTROBJ
XS::LaunchDarkly::ld    T_PTROBJ
HERE

 # start potential perl object code

XS::LaunchDarkly::ld
new (char * class, char * sdkKey, int timeout)
CODE:
        RETVAL = calloc (1, sizeof (client));
        if (! RETVAL) {
                Perl_croak ("No memory for %s", class);
        }
        struct LDConfig * cfg = LDConfigNew(sdkKey);
        RETVAL = LDClientInit(cfg, timeout);
OUTPUT:
        RETVAL

void
DESTROY (ldClient)
        XS::LaunchDarkly::ld ldClient;
CODE:
        free (ldClient);

const char *
get_string (ldClient)
        XS::LaunchDarkly::ld ldClient;
CODE:
        RETVAL = "Louis test\n";
OUTPUT:
        RETVAL

int
is_initialized(ldClient)
        XS::LaunchDarkly::ld ldClient;
CODE:
        RETVAL = LDClientIsInitialized(ldClient);
OUTPUT:
        RETVAL

bool
get_bool_variation(XS::LaunchDarkly::ld ldClient, char * flagKey, bool defaultValue)
CODE:
        RETVAL = LDBoolVariation(ldClient, user, flagKey, defaultValue, NULL);
OUTPUT:
        RETVAL


 # End potential perl object code

int
CreateClient(char * key, int timeout)

int 
UserNew(char * userkey)

int 
ConfigSetStream(bool stream)

int 
ConfigSetStreamURI(char * URI)

int 
ConfigSetBaseURI(char * URI)

int
ConfigSetEventsURI(char * URI)

int 
SetUserName(char * username)

int 
UserSetCountry(char * country)

int 
UserSetEmail(char * email)

int 
UserSetIP(char * IP)

int 
UserSetFirstName(char * firstname)

int 
UserSetLastName(char * lastname)

int 
UserSetAnonymous(bool anon)

int 
SetCustomAttribute(char * key, char * value)

int
BuildCustomAttributes()

int
SetPrivateCustomAttribute(char * key)

int 
ConfigSetAllAttributesPrivate(bool private)

bool
BoolVariation(char *flagKey, bool fallback)

int 
IntVariation(char *flagKey, int fallback)

char * 
StringVariation(char *flagKey, char * fallback)

int 
ClientFlush()

int 
UserFree()

int 
ClientClose()
