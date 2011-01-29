
use Test::More tests => 90;
BEGIN { use_ok('QGames') };

ok( my $tipojuego = QGames::open( "Ajedrez" ) );
ok( my $img = $tipojuego->img );
ok( $img->{w} eq 48 * 8 );
ok( $img->{h} eq 48 * 8 );
ok( $img = $tipojuego->img( "rotado" ) );
ok( $img->{w} eq 48 * 8 );
ok( $img->{h} eq 48 * 8 );

foreach my $color( qw{ blanco negro } ){
    foreach my $pieza( qw{ torre caballo alfil dama rey peon } ){
        ok( $img = $tipojuego->img( $pieza, $color ) );
        ok( $img->{w} eq 48  );
        ok( $img->{h} eq 48  );
        ok( $img = $tipojuego->img( $pieza, $color, "cap" ) );
        ok( $img->{w} eq 24 );
        ok( $img->{h} eq 24 );
    }
}
        
ok( $tipojuego = QGames::open( "Gomoku" ) );
ok( $img = $tipojuego->img );
ok( $img->{w} eq 30 * 13 + 6 );
ok( $img->{h} eq 30 * 13 + 6 );
foreach my $color( qw{ blanco negro } ){
    foreach my $pieza( qw{ gema } ){
        ok( $img = $tipojuego->img( $pieza, $color ) );
        ok( $img->{w} eq 30 );
        ok( $img->{h} eq 30 );
    }
}
