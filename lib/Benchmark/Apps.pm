package Benchmark::Apps;

use warnings;
use strict;

use Time::HiRes qw.gettimeofday tv_interval.;

=head1 NAME

Benchmark::Apps - Simple interface to benchmark applications.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

This module provides a simple interface to benchmark applications (not
necessarily Perl applications).

    use Benchmark::Apps;

		Benchmark::Apps::compare_these(
			cmd1 => 'run_command_1 with arguments',
			cmd2 => 'run_command_2 with other arguments',
		);

=head1 FUNCTIONS

=head2 compare_these

This is the main method of the module. You call it and it prints nice
formated results of the benchmarks performed. The first argument might
be a reference to an hash. In that case, the hash is used as
configuration information.

=cut

sub compare_these {
	my $cfg = { iters => 5 };
	$cfg = { %{shift @_}, %$cfg} if ref $_[0] eq "HASH";
	my %command = @_;

	_show_start_info($cfg, %command);
	
	for my $iter (1..$cfg->{iters}) {
		_show_iter($iter);

		for my $c (keys %command) {
			my $time = time_this($command{$c});
			printf " %8s => %8.4f s\n", $c, $time;
		}

	}
}

=head2 time_this

This method is not meant to be used directly, although it can be useful.
It receives a command line and executes it via system, taking care
of registering the elapsed time.

=cut

sub time_this {
	my $cmd_line = shift;
	my $start_time = [gettimeofday];
	system("$cmd_line > /dev/null");
	return tv_interval($start_time);
}

sub _show_iter {
	my $i = shift;
	printf "%d%s iteration:\n", $i, $i==1?"st":$i==2?"nd":$i==3?"rd":"th";
}

sub _show_start_info {
	my ($cfg, %command) = @_;
	
	print "-" x 50, "\n";
	printf "Running %d iterations of:\n", $cfg->{iters};
	for my $c (keys %command) {
		printf " %8s => %s\n", $c, $command{$c};
	}
	print "-" x 50, "\n\n";
}

=head1 AUTHOR

Aberto Simoes, C<< <ambs at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-benchmark-apps at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Benchmark-Apps>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Benchmark::Apps

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Benchmark-Apps>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Benchmark-Apps>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Benchmark-Apps>

=item * Search CPAN

L<http://search.cpan.org/dist/Benchmark-Apps>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2008 Aberto Simoes, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

!!1; # End of Benchmark::Apps

__END__
