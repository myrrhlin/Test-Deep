use strict;
use warnings;

package Test::Deep::ArrayNone;

use Test::Deep::Cmp;
use Scalar::Util ();

# Failed Test Output:
# Comparing $data->{"foo"} as a INTEGER  <-- diag_message
#    got : '9'                           <-- renderGot
# expect : 1                             <-- renderExp

# deals with the arguments to the comparitor (representing the expected value)
sub init
{
	my $self = shift;

	my $val = shift;

	$self->{val} = $val;
}

# interprets the got value (first argument to cmp_deeply et al.)
# and does the comparison; should return true/false.
sub descend
{
	my $self = shift;
	my $got = shift;

	# array_none requires an array as $got value
	return unless Scalar::Util::reftype($got) eq 'ARRAY';

	my $match;
	foreach my $got_elem (@$got) {
		next unless $match = Test::Deep::descend($got_elem, $self->{val});
		# found a match, test will fail, save matching element
		$self->{got_elem} = $got_elem;
		last;
	}

	return $match ? 0 : 1;
}

sub renderExp {
	my ($self, $exp) = @_;
	return sprintf 'not %s', $self->SUPER::renderExp($self->{val});
}

sub renderGot {
	my ($self, $val) = @_;
	return sprintf '[ %s, ... ]', $self->SUPER::renderGot($self->{got_elem});
}

1;
