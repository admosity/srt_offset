#!/usr/bin/perl

sub srt_stamp_to_millis {
	my $stamp = shift;
	my ($hour, $minute, $seconds, $millis) = ($stamp =~ /^(\d+):(\d+):(\d+),(\d+)$/);
	my $totalMillis = 0;
	$totalMillis += $hour * 60 * 60 * 1000;
	$totalMillis += $minute * 60 * 1000;
	$totalMillis += $seconds * 1000;
	$totalMillis += $millis;
	return $totalMillis;
}

sub millis_to_srt_stamp {
	my $time_in_millis = shift;
	{
		use integer;
		my $hour = $time_in_millis/(60*60*1000);
		$time_in_millis-= $hour * 60 * 60 * 1000;
		my $minute = $time_in_millis/(60 * 1000);
		$time_in_millis-= $minute * 60 * 1000;
		my $seconds = $time_in_millis/1000;
		$time_in_millis -= $seconds * 1000;

		if ($hour < 10) {
			$hour = "0$hour";
		}
		if ($minute < 10) {
			$minute = "0$minute";
		}
		if ($seconds < 10) {
			$seconds = "0$seconds";
		}
		if ($time_in_millis < 10) {
			$time_in_millis = "00$time_in_millis";
		} elsif ($time_in_millis < 100) {
			$time_in_millis = "0$time_in_millis";
		}
		return "$hour:$minute:$seconds,$time_in_millis";
	}
}

open(my $fh, '<', $ARGV[0]);

my $the_start = srt_stamp_to_millis($ARGV[1]);

while(<$fh>) {
	s/(\r\n|\r|\n)$//;
	if(!$FIRST) {
		$FIRST = 1;
		$counter++;
		print "$counter\n";
		next;	
	}
	if(/^(.*) --> (.*)$/) {
		my $first_stamp = srt_stamp_to_millis($1);
		my $second_stamp = srt_stamp_to_millis($2);
		if(!$FIRST_STAMP) {
			$FIRST_STAMP = 1;
			$offset = $first_stamp - $the_start;
		}

		my $new_first_stamp = millis_to_srt_stamp($first_stamp - $offset);
		my $new_second_stamp = millis_to_srt_stamp($second_stamp - $offset);
		print "$new_first_stamp --> $new_second_stamp\n";
	} elsif(/^$/) {
		$EMPTY_LINE = 1;
		print "\n";
	} else {
		if($EMPTY_LINE) {
			$EMPTY_LINE = 0;
			print ++$counter, "\n";
		} else {
			print "$_\n";
		}
	}

	
}
