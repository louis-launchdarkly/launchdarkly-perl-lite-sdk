package XS::LaunchDarkly::User;
require XSLoader;

XSLoader::load();
# While there is an argument to just have a separate XS module to wrap an LDUser in C,
# Let's try to see can we do this in a way that just works like a simple Perl hash

sub buildLDUser {
    my $class = shift;
    print "Class is $class\n";

    # Like the SDK typical API, the constructor only takes in a userKey
    my $userKey = shift;

    my $ldUser = $class->new($userKey);

    # I don't know why that other systax doesn't work here
    my $self = {
        _ldUser => $ldUser,
    };
    $self{_userKey} = $userKey;
    $self{_custom} = {};

    bless $self, $class;
    return $self;
}

sub set {
    $self = shift;
    my $key = shift;
    my $value = shift;

    $self{$key} = $value;
    if($key == "name") {
        $self->{_ldUser}->set_user_name($value);
    }
}

sub setCustom {
    $self = shift;
    my $key = shift;
    my $value = shift;

    $self{_custom}{$key} = $value;
    $self->{_ldUser}->set_custom_attribute($key, $value);
}

sub get {
    $self = shift;
    my $key = shift;
    my $value = $self{$key};
    return $value;
}

sub getCustom {
    $self = shift;
    my $key = shift;
    my $value = $self{_custom}{$key};
    return $value;
}

1;