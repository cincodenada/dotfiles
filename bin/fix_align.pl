#!/usr/bin/env perl
$indent = 4;
while(<>) {
    if($check_next) { 
        if(/^( +)(.*)/) {
            unless(/^\w+\".*\"$/) {
                $numspace = length($1); 
                $gap = $len - $numspace;
                if($gap != 0) { 
                    if($numspace - $indent_space > 4) {
                        if($gap > 0) {
                            print " "x$gap . $_;
                        } else {
                            print substr $_, -$gap;
                        }
                        if(/[{;]$/) { $check_next = 0; }
                        next;
                    }
                }
            }
        }
        $check_next = 0;
        print;
    } elsif(/^(.+?)(\S+\(\{?)(.+)/) {
        $check_next=0;
        print;
        if(/ +V?LOG/) { next; }
        $num_lft = ($3 =~ tr/\(//);
        $num_rgt = ($3 =~ tr/\)//);
        if ($num_lft == $num_rgt) {
            $check_next = 1;
            $indent_space = length $1;
            $len = $indent_space + length $2;
            $num_us = ($2 =~ tr/_//);
        }
    } else {
        $check_next = 0;
        print;
    }
}
