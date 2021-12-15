package XS::LaunchDarkly::ld;
require XSLoader;

XSLoader::load();

sub buildLDClient {
    my $class = shift;
    # print "Class is $class\n";
    my $sdkKey = shift;
    # print "SDK Key is $sdkKey\n";
    my $timeout = shift;
    # print "Time out is $timeout\n";

    my $ldClient = $class->new($sdkKey, $timeout);

    my $self = {
        _sdkKey => $sdkKey,
        _client => $ldClient,
    };
    bless $self, $class;
    return $self;
}

sub getSdkKey {
    my $this = shift;
    print "Self is $this\n";
    my $value = $this->{_sdkKey};
    print "The Value is $value\n";
    # my $sdkKeyValue = $this->$self{_sdkKey};
    # print "SDK Key is $sdkKeyValue";
    return $this->{_sdkKey};
}

sub getBoolVariation {
    my $this = shift;
    print "Self is $this\n";
    my $client = $this->{_client};
    print "Self.client is $client\n";
    my $flagKey = shift;
    print "Flag Key is $flagKey\n";
    my $default = shift;
    print "Default is $default\n";

    my $boolValue = $this->{_client}->get_bool_variation($flagKey, $default);

    return $boolValue;
}

1;
