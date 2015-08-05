use warnings;
use strict;
use Test::More tests => 31;
use Reprepro::Uploaders;

my $uploaders = Reprepro::Uploaders->new(
   uploaders   => "/etc/reprepro/uploaders",
   augeas_opts => {
      root     => "fakeroot",
      loadpath => "lenses",
   },
);


my %test_package = (
   source         => 'test',
   binaries       => [ 'test', 'test-doc' ],
   architectures  => [ 'all', 'amd64', 'i386', 'source' ],
   sections       => [ 'contrib', 'main' ],
);

my %perl_package = (
   source         => 'libfoo-bar-perl',
   binaries       => [ 'libfoo-bar-perl' ],
   architectures  => [ 'source' ],
   sections       => [ 'infra/perl' ],
);

my %bin_package = (
   source         => 'test',
   binaries       => [ 'test', 'test-doc' ],
   architectures  => [ 'all', 'amd64', 'i386' ],
   sections       => [ 'contrib', 'main' ],
);

my %dist_package = (
   source         => 'libfoo-bar-perl',
   binaries       => [ 'libfoo-bar-perl' ],
   architectures  => [ 'source' ],
   sections       => [ 'contrib' ],
   distribution   => [ 'sid' ],
);


$test_package{key} = "1234ABCD";
$perl_package{key} = "1234ABCD";
$bin_package{key}  = "1234ABCD";
$dist_package{key} = "1234ABCD";
is($uploaders->check_package(\%test_package), 1, "Ftpmaster has all rights");
is($uploaders->check_package(\%perl_package), 1, "Ftpmaster has all rights");
is($uploaders->check_package(\%bin_package), 1, "Ftpmaster has all rights");
is($uploaders->check_package(\%dist_package), 1, "Ftpmaster has all rights");


$test_package{key} = "12AB34CD";
$perl_package{key} = "12AB34CD";
$bin_package{key}  = "12AB34CD";
$dist_package{key} = "12AB34CD";
is($uploaders->check_package(\%test_package), 0, "Autobuilders uploads only binaries");
is($#{$uploaders->{errors}}, 5, "6 errors found");
is($uploaders->check_package(\%perl_package), 0, "Autobuilders uploads only binaries");
is($#{$uploaders->{errors}}, 2, "3 errors found");
is($uploaders->check_package(\%bin_package), 1, "Autobuilders uploads only binaries");
is($uploaders->check_package(\%dist_package), 0, "Autobuilders uploads only binaries");


$test_package{key} = "ABCD1234";
$perl_package{key} = "ABCD1234";
$bin_package{key}  = "ABCD1234";
$dist_package{key} = "ABCD1234";
is($uploaders->check_package(\%test_package), 0, "Perl dev uploads specific packages");
is($#{$uploaders->{errors}}, 2, "3 errors found");
is($uploaders->check_package(\%perl_package), 1, "Perl dev uploads specific packages");
is($uploaders->check_package(\%bin_package), 0, "Perl dev uploads specific packages");
is($#{$uploaders->{errors}}, 2, "3 errors found");
is($uploaders->check_package(\%dist_package), 1, "Perl dev uploads specific packages");


$test_package{key} = "123ABC4D";
$perl_package{key} = "123ABC4D";
$bin_package{key}  = "123ABC4D";
$dist_package{key} = "123ABC4D";
is($uploaders->check_package(\%test_package), 0, "Unknown key");
is($#{$uploaders->{errors}}, 0, "1 error found");
is($uploaders->check_package(\%perl_package), 0, "Unknown key");
is($#{$uploaders->{errors}}, 0, "1 error found");
is($uploaders->check_package(\%bin_package), 0, "Unknown key");
is($#{$uploaders->{errors}}, 0, "1 error found");
is($uploaders->check_package(\%dist_package), 0, "Unknown key");
is($#{$uploaders->{errors}}, 0, "1 error found");



$test_package{key} = "AB12CD34";
$perl_package{key} = "AB12CD34";
$bin_package{key}  = "AB12CD34";
$dist_package{key} = "AB12CD34";
is($uploaders->check_package(\%test_package), 0, "Distribution checks");
is($#{$uploaders->{errors}}, 2, "3 errors found");
is($uploaders->check_package(\%perl_package), 0, "Distribution checks");
is($#{$uploaders->{errors}}, 0, "1 errors found");
is($uploaders->check_package(\%bin_package), 0, "Distribution checks");
is($#{$uploaders->{errors}}, 2, "3 errors found");
is($uploaders->check_package(\%dist_package), 1, "Distribution checks");
