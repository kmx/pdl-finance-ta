use strict;
use warnings;
use ExtUtils::MakeMaker;
use PDL::Core::Dev;
use Alien::TALib;
 
# ta-lib detection taken from Finance::TA

my $alien = Alien::TALib->new;
my $libs = $ENV{TALIB_LIBS} || $alien->libs;
if (!defined $libs) {
  $libs = `ta-lib-config --libs`;
  $libs =~ s/[\s\n\r]*$//;
  #XXX-HACK fixing broken ta-lib-config output
  $libs .= " -lta_lib" if $libs && $libs !~ /-lta_lib/;
}

my $cflags = $ENV{TALIB_CFLAGS} || $alien->cflags;
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
        'Alien::TALib' => 0.05,
  },
  BUILD_REQUIRES     => {
        'PDL' => 2.006,
        'Test::More' => 0,
        'Test::Number::Delta' => 0,
        'Alien::TALib' => 0.05,
  },
  CONFIGURE_REQUIRES => {
        'PDL' => 2.006,
        'Alien::TALib' => 0.05,
  },
  META_MERGE   => { 
      resources    => {
          repository   => 'https://github.com/kmx/pdl-finance-talib',
      },
  },
  dist => {
      PREOP => '$(MKPATH) $(DISTVNAME)/GENERATED'
               . ' && $(PERL) "-MPDL::PP qw[PDL::Finance::Talib PDL::Finance::Talib $(DISTVNAME)/GENERATED/Talib]" Talib.pd'
               . ' && $(RM_F) $(DISTVNAME)/GENERATED/*.xs'
               . ' && pod2text $(DISTVNAME)/GENERATED/Talib.pm > README'
      },
);

sub MY::postamble {
        pdlpp_postamble($package) . <<'END'

mypod:
	$(PERL) "-MPDL::PP qw/PDL::Finance::Talib PDL::Finance::Talib TMP/" Talib.pd
	perldoc -u TMP.pm > README.pod
	$(RM_F) TMP.pm TMP.xs

END
}
