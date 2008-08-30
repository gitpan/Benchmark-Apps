package Benchmark::Apps;

use warnings;
use strict;

use Time::HiRes qw.gettimeofday tv_interval.;

=head1 NAME

Benchmark::Apps - Simple interface to benchmark applications.

=cut

our $VERSION = '0.03';


=head1 SYNOPSIS

This module provides a simple interface to benchmark applications (not
necessarily Perl applications).

  use Benchmark::Apps;

  my $b = Benchmark::Apps->new(
                             pretty_print=>1,
                             iters=>5,
                           );

  my %result = $b->run(
                     cmd1 => 'run_command_1 with arguments',
                     cmd2 => 'run_command_2 with other arguments',
                   );

=head1 FUNCTIONS

=head2 new

Create a new benchmarking object with a set of options. The set of
options is a simple hash. Available options at the moment are:

=over 4

=item C<pretty_print>

When enabled it will print to stdout, in a formatted way the results
of the benchmarks as they finish running. This option should de used
when you want to run benchmarks and want to see the results progress
as the tests run. You can disable it, so you can perform automated
benchmarks.

Options: true (1) or false (0)

Default: false (0)

=item C<iters>

This is the number of iterations that each test will run.

Options: integer greater than 1

Default: 5

=item C<args>

This is a reference to an anonymous function that will calculate the
command argument based on the iteraction number.

Options: any function reference that returns a string

Default: identity function: the iteration number is passed as an argument
to the command)

=back

=head2 run

This method runs the commands described in the hash passed as argument.
It returns an hash of the results and return codes for each command.

=cut

sub _id { return shift }

my %cfg = ( pretty_print => 1,
	          iters        => 5 ,
	 					args         => \&_id );
my %command = ();
my %res = ();

sub new {
	my $class = shift;
	my %args = @_;
	my $self = bless({}, $class);

   my @options = keys %cfg;

	foreach (@options) {
		if (defined $args{$_} and _validate_option($_,$args{$_})) {
			$cfg{$_} = $args{$_};
		}
	}

	return $self;
}

sub _validate_option {
	my ($option, $value) = @_;

	# TODO do some validations
	# validate everything ok for now

	return 1;
}

sub run {
	my $self = shift;
	%command = @_;

	for my $iter (1..$cfg{'iters'}) {
		for my $c (keys %command) {
			$res{$c}{'run'} = $command{$c};
			my $time = time_this($command{$c} . ' ' . &{$cfg{'args'}}($iter));
			$res{$c}{'result'}{$iter} = $time;
		}
	}
	pretty_print(%res) if $cfg{'pretty_print'};

	return %res;
}

sub pretty_print {
	my $self = shift;

	for my $c (sort keys %command) {
   	for my $iter (1..$cfg{'iters'}) {
      	_show_iter($iter);

      	for my $c (keys %command) {
         	printf " %8s => %8.4f s\n", $c, $res{$c}{'result'}{$iter};
      	}
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
	system("$cmd_line 2>&1 > /dev/null");
	return tv_interval($start_time);
}

sub _show_iter {
	my $i = shift;
	printf "%d%s iteration:\n", $i, $i==1?"st":$i==2?"nd":$i==3?"rd":"th";
}

=head1 EXAMPLES

=head2 Example One

This simple example illustrates how to run benchmarks.

The commands hash tells the module which script to run, and options.

  my %commands = (
    cmd1=> 'script.pl --options',
    cmd1=> 'script.py -options',
  );

The C<args> method is used to calculate the arguments that will be
concatenated to the command line for each iteration. In this example
we are saying that we want to pass as an argument to the command the
current iteration times 1000.

  sub args {
		my $iteration = shift;
		return $iteration * 1000;
	}

We then create our Benchmark::Apps instance, with pretty printing
enabled. We also want to run each command 10 times and finally
pass it an C<args> sub ref.

  my $t = Benchmark::Apps->new( pretty_print => 1,
	                              iters        => 10,
	                              args         => \&args);

Finally we run the benchmark for the commands defined.

  $t->run(%command);

This would be similiar to run the following commands, for the first
iteration:

  $ script.pl --options 10000
  $ script.py --options 10000

the second iteration:

  $ script.pl --options 20000
  $ script.py --options 20000

the third iteration:

  $ script.pl --options 30000
  $ script.py --options 30000

And so on... The result of each iteration will be printed to stdout.

=head1 AUTHOR

Aberto Simoes (aka ambs), C<< <ambs at cpan.org> >>
Nuno Carvalho (aka smash), C<< <smash @ cpan.org> >>

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

Copyright 2008 Aberto Simoes, Nuno Carvalho, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

!!1; # End of Benchmark::Apps

__END__
