package Net::UDAP::Util;

# $Id$

use warnings;
use strict;
use Carp;

use version; our $VERSION = qv('0.1');

use vars qw(@ISA @EXPORT @EXPORT_OK %EXPORT_TAGS $VERSION);
use Exporter qw(import);

%EXPORT_TAGS
    = (
    all => [qw( hexstr decode_hex encode_ip decode_ip encode_mac decode_mac )]
    );
Exporter::export_tags('all');

{

    sub decode_hex {

        # Decode a hex string of specified length into a human-readable string
        # $rawstr	- the raw hex string
        # $strlen	- the length of the hex string
        # $fmt		- the format to use to unpack each byte
        # $separator	- the string to use as separator in the output string
        my ( $rawstr, $strlen, $fmt, $separator ) = @_;
        $separator = '' if !defined $separator;
        if ( length($rawstr) == $strlen ) {
            my @parts = unpack( "($fmt)*", $rawstr );
            if (wantarray) {
                return @parts;
            }
            else {
                return join( "$separator", @parts );
            }
        }
        else {
            carp "Expecting string with length: $strlen";
            return undef;
        }
    }

    sub encode_ip {

        # Encode a dotted-quad IP address into a 4-byte string
        # $ip		- IP address in format xxx.xxx.xxx.xxx
        my $ip = shift;
        if ($ip =~ /
		    \A		    # start of string
		    ( [0-9]{1,3} )  # match and capture between 1-3 digits
		    [.]		    # period literal
		    ( [0-9]{1,3} )  # match and capture between 1-3 digits
		    [.]		    # period literal
		    ( [0-9]{1,3} )  # match and capture between 1-3 digits
		    [.]		    # period literal
		    ( [0-9]{1,3} )  # match and capture between 1-3 digits
		    /xms
            )
        {
            return pack( 'C4', $1, $2, $3, $4 );
        }
        else {
            carp "IP address \"$ip\" not in expected format (x.x.x.x)";
            return undef;
        }
    }

    sub decode_ip {

        # Decode a 4-byte IP string into human-readable form
        # $rawstr	- 4-byte hex string representing IP address
        my $rawstr = shift;
        return decode_hex( $rawstr, 4, 'C', '.' );
    }

    sub encode_mac {

        # Encode a mac address to a 6-byte string
        # $mac		- MAC address in format xx:xx:xx:xx:xx:xx
        my $mac = shift;
        if ($mac =~ /
		    \A			# start of string
		    ( [0-9A-Fa-f]{2} )	# match and capture two hex digits
		    :			# semi-colon literal
		    ( [0-9A-Fa-f]{2} )	# match and capture two hex digits
		    :			# semi-colon literal
		    ( [0-9A-Fa-f]{2} )	# match and capture two hex digits
		    :			# semi-colon literal
		    ( [0-9A-Fa-f]{2} )	# match and capture two hex digits
		    :			# semi-colon literal
		    ( [0-9A-Fa-f]{2} )	# match and capture two hex digits
		    :			# semi-colon literal
		    ( [0-9A-Fa-f]{2} )	# match and capture two hex digits
		    /xms
            )
        {
            return pack( 'C6',
                hex($1), hex($2), hex($3), hex($4), hex($5), hex($6) );
        }
        else {
            carp
                "MAC address \"$mac\" not in expected format (xx:xx:xx:xx:xx:xx)";
            return undef;
        }
    }

    sub decode_mac {

        # Decode a 6-byte MAC string into human-readable form
        # $rawstr	- 6-byte hex string representing MAC address
        my $rawstr = shift;
        return decode_hex( $rawstr, 6, 'H2', ':' );
    }

    sub hexstr {

        # decode the supplied bytes as a hex number string
        # $bytes	- the byte string to decode
        # $width	- the width of the output
        # sample output (width=4): 0x0001
        my ( $bytes, $width ) = @_;
        return
            sprintf( join( q{}, '0x%0', int($width), 'x' ),
            unpack( 'n', $bytes ) );
    }
}

1;    # Magic true value required at end of module
__END__

=head1 NAME

Net::UDAP::Util - [One line description of module's purpose here]


=head1 VERSION

This document describes Net::UDAP::Util version 0.0.1


=head1 SYNOPSIS

    use Net::UDAP::Util;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.
  
  
=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE 

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.


=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.
  
Net::UDAP::Util requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-net-udap-util@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Robin Bowes  C<< <robin@robinbowes.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008, Robin Bowes C<< <robin@robinbowes.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=cut

# vim:set softtabstop=4:
# vim:set shiftwidth=4: