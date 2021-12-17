#!/usr/bin/perl
use strict;
use warnings;

my $sdkKey = "SDK-KEY";
my $timeout = 3000;
my $userKey = "123-456-789-000";

# Create Client
my $ldClient = XS::LaunchDarkly::ld->buildLDClient($sdkKey, $timeout);

# This line is calling a Perl native sub routine that is defined in ld.pm
my $sdkKeyCheck = $ldClient->getSdkKey();
if($sdkKey eq $sdkKeyCheck) {
	print "Key check successful, the client has the key we inputted";
} else {
	print "Key check failed, Why???";
}

# Create User with key Louis and set the name attribute to hello
my $user = XS::LaunchDarkly::User->buildLDUser("Louis");
$user->set("name", "hello");
$user->setCustom("go","east");
my $key = $user->get("name");
my $customKey = $user->getCustom("go");

# Sanity check to make sure the code can get back the things we set
print "This is the name $key\n";
print "This is the custom $customKey\n";

# Create User with key Toaster and set the name attribute to Flying
my $user2 = XS::LaunchDarkly::User->buildLDUser("Toaster");
$user2->set("name", "Flying");
$user2->setCustom("go","west2");

print "Sleep for a bit to wait for initialization\n";
sleep(2);

# This line is calling the XS generated sub routine that is defined in ld.xs, "generated to the Client object"-ish
my $isInit = $ldClient->{_client}->is_initialized();

if($isInit) {
	print "Client is Initialzied\n";
} else {
	print "Client is not initialized\n";
}

# # Set Custom attributes - any key/value pair
# XS::LaunchDarkly::ld::SetCustomAttribute("geo","northeast");
# XS::LaunchDarkly::ld::SetCustomAttribute("plan","platinum");
# XS::LaunchDarkly::ld::SetCustomAttribute("secret","yyz-yyz-yyz");

# # Set any custom attribute to private by referencing the key 
# XS::LaunchDarkly::ld::SetPrivateCustomAttribute("secret");

# # Once all your custom attributes are set, we need to build the object on the backend 
# XS::LaunchDarkly::ld::BuildCustomAttributes();

# Optionally, set all attriutes private 
#XS::LaunchDarkly::ld::ConfigSetAllAttributesPrivate(1);

# Compare calling a perl sub routine with below, the XS generated sub routine
my $boolFg = $ldClient->getBoolVariation($user, "first-flag-in-ld", 0);
if ($boolFg == 1) {
	print "Louis Bool Variation: True\n";
}
else {
	print "Louis Bool Variation: False\n";
}

my $intFg = $ldClient->getIntVariation($user2, "int-flag", 10);
print "Int Variation: $intFg\n";

# Boolean flag example - include flag name and fallback value 
# my $boolFlag = XS::LaunchDarkly::ld::BoolVariation("first-flag-in-ld", 0);
# if ($boolFlag == 1) {
# 	print "Bool Variation: True\n";
# }
# else {
# 	print "Bool Variation: False\n";
# }

# Number flag example
# my $intFlag = XS::LaunchDarkly::ld::IntVariation("number-flag", 0);
# print "Int Variation: $intFlag\n";

# String flag example
# my $stringFlag = XS::LaunchDarkly::ld::StringVariation("test-string", "Oakland");
# print "String Variation: $stringFlag\n";

# Flush events
XS::LaunchDarkly::ld::ClientFlush();

# Give the library time to flush all events just to be safe
sleep(2);

# Clean up the user and client 
XS::LaunchDarkly::ld::UserFree();
$ldClient->closeClient();
