package Log::Any::Adapter::Test::More;

use strict;
use warnings;

use Test::More;
use Log::Any::Adapter::Util qw(make_method);

use base qw(Log::Any::Adapter::Base);

our $VERSION = '0.01';

sub init {
    my ($self) = @_;
    my $level_count = 0;
    my %level_val = map { $_ => ++$level_count } Log::Any->logging_methods();
    $self->{level_val} = \%level_val;
    $self->{level} ||= 'trace';
}

sub level_threshold {
    my ( $self, $level ) = @_;
    my $lv = $self->{level_val};
    return ( $lv->{ $level } >= $lv->{ $self->{level} } ) ? 1 : 0; 
}

foreach my $method ( Log::Any->logging_methods() ) {
    my $log_more_sub = ( $method =~ /^(trace|debug|info|notice)$/ ) 
                     ? 'note'
                     : 'diag';

    make_method( $method, sub {
        my $self = shift;
        return if !$self->level_threshold( $method );
        my $sub = \&{$log_more_sub};
        return $sub->(@_);
    } );

    make_method( "is_$method", sub {
        my $self = shift;
        return $self->level_threshold( $method );
    } );
}

1;

__END__

=pod

=head1 NAME

Log::Any::Adapter::Test::More - Output Log::Any logs as Test::More diagnostics

=head1 SYNOPSIS

    use Log::Any::Adapter;

    Log::Any::Adapter->set( 'Test::More', level => 'info' );


=head1 DESCRIPTION

This Log::Any adapter uses L<Test::More|Test::More> diagnostics for logging.

=head1 LOG LEVEL TRANSLATION

Log levels are translated from Log::Any to Test::More as follows:

    trace, debug, info, notice                 => note
    warning, error, critical, alert, emergency => diag

=head1 LOG LEVEL LIMITING

You can set the log level to limit output. Default is trace.

    Log::Any::Adapter->set( 'Test::More', level => 'debug' );

=head1 SEE ALSO

L<Log::Any|Log::Any>, L<Log::Any::Adapter|Log::Any::Adapter>,

=head1 AUTHOR

Hugh Gallagher 

=head1 COPYRIGHT & LICENSE

Copyright (C) 2013 Hugh Gallagher, all rights reserved.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
