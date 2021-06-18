# launchdarkly-perl-lite-sdk

## Purpose

A lite Perl SDK for LaunchDarkly. This is built using Perl's XS module which bridges C code and libraries into Perl. It's a "lite" version of the LaunchDarkly SDK because it is not a 1:1 mapping of the full LaunchDarkly SDK. Some limitations exist such as
* No JSON Flag support
* Only 1 singleton at a time 
* No array support for custom attribute values (single value for each key)

## Pre-requisites 

You will need the LaunchDarkly C library installed and the library in the LD_LIBRARY_PATH for the environment running your Perl apps. 

## Support

This SDK is not supported by LaunchDarkly. 

## Build

```
$~  perl Makefile.pl
$~  make
$~  make install
```

## Run 

```
$~  perl -MXS::LaunchDarkly::ld sample.pl
```
