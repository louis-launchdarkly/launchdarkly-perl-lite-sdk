#!/usr/bin/perl
use strict;
use warnings;

my $sdkKey = "SDK-KEY";
my $timeout = 3000;
my $userKey = "123-456-789-000";

my $ldClient = XS::LaunchDarkly::ld->buildLDClient($sdkKey, $timeout);

print $ldClient;
# This line is calling a Perl native sub routine that is defined in ld.pm
$ldClient->getSdkKey();
print "Sleep for a bit\n";
sleep(5);

# This line is calling the XS generated sub routine that is defined in ld.xs, "generated to the Client object"-ish
my $isInit = $ldClient->{_client}->is_initialized();

if($isInit) {
	print "Initialzied\n";
} else {
	print "Is not initialized\n";
}

# Create Client and Set User Key / Request Context ID
XS::LaunchDarkly::ld::CreateClient($sdkKey, $timeout);
XS::LaunchDarkly::ld::UserNew($userKey);

# Set Username - Optional Custom Field
XS::LaunchDarkly::ld::SetUserName("St. Glass");

# Set Custom attributes - any key/value pair
XS::LaunchDarkly::ld::SetCustomAttribute("geo","northeast");
XS::LaunchDarkly::ld::SetCustomAttribute("plan","platinum");
XS::LaunchDarkly::ld::SetCustomAttribute("secret","yyz-yyz-yyz");

# Set any custom attribute to private by referencing the key 
XS::LaunchDarkly::ld::SetPrivateCustomAttribute("secret");

# Once all your custom attributes are set, we need to build the object on the backend 
XS::LaunchDarkly::ld::BuildCustomAttributes();

# Optionally, set all attriutes private 
#XS::LaunchDarkly::ld::ConfigSetAllAttributesPrivate(1);

# Compare calling a perl sub routine with below, the XS generated sub routine
my $boolFg = $ldClient->getBoolVariation("first-flag-in-ld", 0);
if ($boolFg == 1) {
	print "Louis Bool Variation: True\n";
}
else {
	print "Louis Bool Variation: False\n";
}

# Boolean flag example - include flag name and fallback value 
my $boolFlag = XS::LaunchDarkly::ld::BoolVariation("first-flag-in-ld", 0);
if ($boolFlag == 1) {
	print "Bool Variation: True\n";
}
else {
	print "Bool Variation: False\n";
}

# Number flag example
# my $intFlag = XS::LaunchDarkly::ld::IntVariation("number-flag", 0);
# print "Int Variation: $intFlag\n";

# String flag example
# my $stringFlag = XS::LaunchDarkly::ld::StringVariation("test-string", "Oakland");
# print "String Variation: $stringFlag\n";

# Flush events
XS::LaunchDarkly::ld::ClientFlush();

# Give the library time to flush all events just to be safe
sleep(5);

# Clean up the user and client 
XS::LaunchDarkly::ld::UserFree();
XS::LaunchDarkly::ld::ClientClose();
