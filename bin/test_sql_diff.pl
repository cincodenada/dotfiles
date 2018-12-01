#!/usr/bin/env perl
open(my $out_expected, '>', 'expected.sql');
open(my $out_actual, '>', 'actual.sql');

my $testname, $outfile;
while(<STDIN>) {
  if(/^\/ (.*) \-+$/) {
    if($testname and $outfile) {
      print $outfile "-- $testname\n";
    }
    $testname = $1;
  }
  if(/^with expansion:/) {
    $outfile = $out_expected;
  } elsif(/^  \=\=$/) {
    $outfile = $out_actual;
  } else {
    if($outfile and $testname) {
      if(/^  "(.*)/) {
        print $outfile "$1";
      } elsif(/^  (.*)"$/) {
        print $outfile "$1;";
        $outfile = undef;
      } else {
        print $outfile $_;
      }
    }
  }
}

foreach my $fname ('expected','actual') {
  system("sqlformat --reindent --wrap_after 80 $fname.sql | sponge $fname.sql");
}

