use strict;
use warnings;
use ExtUtils::MakeMaker;
use PDL::Core::Dev;
 
# ta-lib detection taken from Finance::TA

my $libs = $ENV{TALIB_LIBS};
if (!defined $libs) {
  $libs = `ta-lib-config --libs`;
  $libs =~ s/[\s\n\r]*$//;
  #XXX-HACK fixing broken ta-lib-config output
  $libs .= " -lta_lib" if $libs && $libs !~ /-lta_lib/;
}

my $cflags = $ENV{TALIB_CFLAGS};
if (!defined $cflags) {
 $cflags = `ta-lib-config --cflags`;
 $cflags =~ s/[\s\n\r]*$//;
}

unless ($libs) {
  warn "\nERROR: ta-lib not found on your system!\n\n";
  exit 0;
}

my $package = [qw/Talib.pd Talib PDL::Finance::Talib/];
my %eumm_args = pdlpp_stdargs($package);
$eumm_args{INC} .= " $cflags";
push @{$eumm_args{LIBS}}, $libs;

WriteMakefile(
  %eumm_args,
  VERSION_FROM  => 'Talib.pd',
  AUTHOR        => 'KMX <kmx@cpan.org>',
  ABSTRACT      => 'PDL interface to ta-lib library',
  LICENSE       => 'perl',
  PREREQ_PM     => {
        'PDL' => 2.006,
  },
  BUILD_REQUIRES     => {
        'PDL' => 2.006,
        'Test::More' => 0,
        'Test::Number::Delta' => 0,
  },
  CONFIGURE_REQUIRES => {
        'PDL' => 2.006,
  },
  dist => { PREOP=> '$(PERL) "-MPDL::PP qw/PDL::Finance::Talib PDL::Finance::Talib Talib/" Talib.pd && perldoc -u Talib.pm > $(DISTVNAME)/Talib.pod' }
);

sub MY::postamble {
        pdlpp_postamble($package) . <<'END'

mypod:
	$(PERL) "-MPDL::PP qw/PDL::Finance::Talib PDL::Finance::Talib Talib/" Talib.pd
	perldoc -u Talib.pm > Talib.pod

END
}
