## no critic ()

package PERLANCAR::YAML::Any;

# DATE
# VERSION

use strict 'subs', 'vars';
use warnings;
use Log::ger;

use Exporter qw(import);
our @EXPORT = qw(Dump Load);
our @EXPORT_OK = qw(DumpFile LoadFile);

our @IMPLEMENTATIONS = (
    'YAML::XS',
    'YAML::Syck',
    'YAML::Old',
    'YAML',
    'YAML::Tiny',
);

sub _do {
    my $sub = shift;

    for my $impl (@IMPLEMENTATIONS) {
        (my $impl_pm = "$impl.pm") =~ s!::!/!g;
        eval { require $impl; 1 };
        next if $@;
        my $res; eval { $res = &{"$impl\::$sub"}(@_) };
        if ($@) {
            log_trace "$impl\::$sub died: $@, trying other implementation ...";
            last;
        }
        return $res;
    }
    die "No YAML implementation can be used for $sub()";
}

sub Load     { _do('Load', @_) }
sub LoadFile { _do('LoadFile', @_) }
sub Dump     { _do('Dump', @_) }
sub DumpFile { _do('DumpFile', @_) }

1;
# ABSTRACT: Pick a YAML implementation and use it

=head1 SYNOPSIS

 use PERLANCAR::YAML::Any;
 my $data = Load("yaml ...");


=head1 DESCRIPTION

This is like L<YAML::Any> (or L<YAML>) except that it tries the next
implementation when an implementation dies.


=head1 SEE ALSO

L<YAML::Any>, L<YAML>

=cut
