package XS::LaunchDarkly::ld;
require XSLoader;

XSLoader::load();
# Perl operates in the order of code layout - hence if we want to call XS code, we need to Load it first and write Perl below.

sub buildLDClient {
    # When using Arrow operator, the first argument is the left side of the arrow
    # Hence for initialization, we call XS::LaunchDarkly::ld->buildLDClient($sdkKey, $timeout);
    my $class = shift;
    # Shift takes the next parameter from the input variables.
    my $sdkKey = shift;
    my $timeout = shift;

    # This calls the XS code that build into Perl Subroutine (which is different from the pure C code)
    my $ldClient = $class->new($sdkKey, $timeout);

    # When we call new, what we get back is a Scalar variable that containes the client.
    # And as far as I can tell, there is no multiple object variables in Perl. So if we want to return more stuff, make a hash for it.
    my $self = {
        # We don't allow reading for the SDK Key in real SDKs. This is just a demo to show we can hold more variables.
        _sdkKey => $sdkKey,
        _client => $ldClient,
    };
    
    # This is the key statement to make sure other subroutine in this class is now available to this hash.
    # Which enables we say <variable>->getSdkKey();
    bless $self, $class;
    return $self;
}

sub getSdkKey {
    my $this = shift;
    return $this->{_sdkKey};
}

sub getBoolVariation {
    my $this = shift;
    my $perlUserHash = shift;
    my $flagKey = shift;
    my $default = shift;

    my $boolValue = $this->{_client}->get_bool_variation($perlUserHash->{_ldUser}, $flagKey, $default);

    return $boolValue;
}

1;
