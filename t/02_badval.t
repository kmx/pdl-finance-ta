use strict;
use warnings;

use PDL;
use PDL::Finance::Talib;
use Test::More;

my $T  = pdl([0, 3, 6, 9, 12, 15, 18, 21, 24, 27, 30]);

my $MA1 = TA_MA($T, 3, 1);
is_deeply([$MA1->list], ['BAD', 'BAD', 3, 6, 9, 12, 15, 18, 21, 24, 27]);
my $MA2 = TA_MA($MA1, 3, 1);
is_deeply([$MA2->list], ['BAD', 'BAD', 'BAD', 'BAD', 6, 9, 12, 15, 18, 21, 24]);
my $MA3 = TA_MA($MA2, 3, 1);
is_deeply([$MA3->list], ['BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD', 9, 12, 15, 18, 21]);
my $MA4 = TA_MA($MA3, 3, 1);
is_deeply([$MA4->list], ['BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD', 12, 15, 18]);
my $MA5 = TA_MA($MA4, 3, 1);
is_deeply([$MA5->list], ['BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD', 15]);
my $MA6 = TA_MA($MA5, 3, 1);
is_deeply([$MA6->list], ['BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD']);
my $MA7 = TA_MA($MA6, 3, 1);
is_deeply([$MA7->list], ['BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD', 'BAD']);

done_testing;