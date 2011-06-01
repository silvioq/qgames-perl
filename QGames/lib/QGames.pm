package QGames;

use 5.008008;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use QGames ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.03';

require XSLoader;
XSLoader::load('QGames', $VERSION);

# Preloaded methods go here.
#
#

package  QGames::Gametype;
use overload '""' => sub { shift->name };

package  QGames::Game;
use overload '""' => sub { "#" . shift->id };

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

QGames - Perl extension for QGames engine

=head1 SYNOPSIS

  use QGames;

=head2 GAME TYPE

  my $gametype = QGames::open( "Ajedrez" );
  my $hash_blanco_def = $gametype->describe->{colores}->{blanco};
  my $logo = $gametype->logo;
  print "width: " . $logo->{w} . " height: " . $logo->{h} . "\n" ;
  open PNG ">/tmp/logo.png";
  print PNG $logo->{png};
  close PNG;

=head2 GAMES

  my $game = $gametype->crea();

=head3 POSSIBLE MOVES

  foreach my $possible_move( @{$game->possible} ){
      print  "Move number: " . $possible_move->{num} . " Notation: " . $possible_move->{n} . "\n";
  }

Possible moves is a array of hash. Each hash contains
- num : Number of move
- d: Description
- n: Notation
- p: Piece
- c: Color
- f: Square from
- t: Square to
- cap : Capture array. Each hash from this array contains
  - cp: Captured piece
  - cs: Captured square
  - cc: Captured color
- tran: Transformation array. Each hash from this array contains
  - tp: Transformed piece
  - tc: Transformed color
- move: Additional move piece array. Each hash from this array contains
  - mp: Moved piece
  - mc: Moved color
  - mf: Moved from
  - mt: Moved to
- crea: Creation piece array. Each hash from this array contains
  - rp: Created piece
  - rc: Created color
  - rs: Created square

=head3 MOVE

  $game->move( "e4" );
  foreach my $board( @{$game->board} ){
      print  "Piece: " . $board->{p} . "  Square: " . $board->{s} . " Owner: " . $board->{c} . "\n";
  }

  print $game->color; # Prints negro

=head3 GAME END

  # Returns QGames::PLAYING, QGames::DRAW or color number
  print $game->final . "\n";

  # Returns winner color
  print $game->winner . "\n";

=head1 DESCRIPTION

This extension wraps QGames Engine functions. Two class are exported:
QGames::Gametype and QGames::Game

QGames::Gametype exports functions to create game and describe game
features.

QGames::Game is usefull for manage games, exporting possible moves,
board status, history moves and move actions.

=head2 EXPORT

None by default.



=head1 SEE ALSO

L<http://github.com/silvioq/qgames>, L<http://github.com/silvioq/qgames-perl>

=head1 AUTHOR

Silvio Quadri, E<lt>silvio@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Silvio Quadri

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
