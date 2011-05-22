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

our $VERSION = '0.02';

require XSLoader;
XSLoader::load('QGames', $VERSION);

# Preloaded methods go here.
#
#

package  QGames::Tipojuego;
use overload '""' => sub { shift->nombre };

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

  foreach my $possible_move( @{$game->posibles} ){
      print  "Move number: " . $possible_move->{numero} . " Notation: " . $possible_move->{notacion} . "\n";
  }

  $game->mover( "e4" );
  foreach my $board( @{$game->tablero} ){
      print  "Piece: " . $board->{pieza} . "  Square: " . $board->{casillero} . " Owner: " . $board->{color} . "\n";
  }

  print $game->color; # Prints negro

  # Returns QGames::FINAL_ENJUEGO, QGames::FINAL_EMPATE or color number
  print $game->final . "\n";

  # Returns winner color
  print $game->ganador . "\n";

=head1 DESCRIPTION

This extension wraps QGames Engine functions. Two class are exported:
QGames::Tipojuego and QGames::Partida

QGames::Tipojuego exports functions to create game and describe game
features.

QGames::Partida is usefull for manage games, exporting possible moves,
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
