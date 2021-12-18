# launchdarkly-perl-lite-sdk

## Purpose

WARNING: If you find this repository, please be aware that this is currently an incomplete proof of concept that is not ready for any usage, even if the example may run.

A lite Perl SDK for LaunchDarkly. This is built using Perl's XS module which bridges C code and libraries into Perl. It's a "lite" version of the LaunchDarkly SDK because it is not a 1:1 mapping of the full LaunchDarkly SDK. Some limitations exist such as
* No JSON Flag support
* Only 1 singleton at a time 
* No array support for custom attribute values (single value for each key)

## Pre-requisites 

You will need the LaunchDarkly C Server SDK installed and the library in the LD_LIBRARY_PATH for the environment running your Perl apps.
Remember to do `make install` when installing the C Server SDK so the headers are available for the XS make.

## Support

This SDK is not supported by LaunchDarkly. 

## Build

```
$~  perl Makefile.pl
$~  make
$~  make install
```

## Run 
We need to load both the ld modules for this to run.

```
$~  perl -MXS::LaunchDarkly::ld -MXS::LaunchDarkly::User sample.pl
```
