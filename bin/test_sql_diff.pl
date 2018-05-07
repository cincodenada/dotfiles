#!/usr/bin/env perl
open(my $out_expected, '>', 'expected.sql');
open(my $out_actual, '>', 'actual.sql');

my $testname, $outfile;
while(<STDIN>) {
  if(/RUN.* ([\w\.]+)$/) {
    $testname = $1;
  }
  if(/Expected/) {
    $outfile = $out_actual; 
  }
  if(/To be equal to/) {
    $outfile = $out_expected;
  }
  if(/Which is: "(.*)"$/) {
    print $outfile "-- $testname\n";
    print $outfile "$1;\n";
  }
}

foreach my $fname (['expected','actual']) {
  system("sqlformat --reindent --wrap_after 80 $fname.sql | sponge $fname.sql");
}

