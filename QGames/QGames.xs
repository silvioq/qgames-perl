#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include  <qgames.h>

#include "ppport.h"
typedef Tipojuego* QGames_Tipojuego;
typedef Partida* QGames_Partida;

MODULE = QGames		PACKAGE = QGames		

void
set_path(path)
        char* path
    CODE:
        qg_path_set( path );

const char*
get_path()
    CODE:
        RETVAL = qg_path_games();
    OUTPUT:
        RETVAL


QGames_Tipojuego
open(juego)
        char* juego
    CODE:
        RETVAL = qg_tipojuego_open( juego );
    OUTPUT:
        RETVAL

MODULE = QGames		PACKAGE = QGames::Tipojuego  PREFIX = tjuego_

QGames_Partida
tjuego_crea_partida(tj,id=NULL)
        QGames_Tipojuego tj
        char* id
    CODE:
        RETVAL = qg_tipojuego_create_partida( tj, id );
    OUTPUT:
        RETVAL
