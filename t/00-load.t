use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Log::Any::Adapter::Test::More' ) || print "Bail out!\n";
}

diag( "Testing Log::Any::Adapter::Test::More $Log::Any::Adapter::Test::More::VERSION, Perl $], $^X" );
