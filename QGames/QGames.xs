#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include  <qgames.h>

#include "ppport.h"
typedef Tipojuego* QGames_Gametype;
typedef Partida* QGames_Game;

#define  hv_store_str( hash, key, str ) hv_store( hash, key, sizeof( key ) - 1, newSVpv( str, strlen( str ) ), 0 )

static HV* generate_hash_movida( Partida* par, Movdata movdat ){
    HV* hashmov = newHV();
    sv_2mortal((SV*)hashmov);
    hv_store( hashmov, "num", 3, newSViv( movdat.numero ), 0 );
    hv_store_str( hashmov, "d", movdat.descripcion );
    hv_store_str( hashmov, "n", movdat.notacion );
    hv_store_str( hashmov, "p", movdat.pieza );
    hv_store_str( hashmov, "c", movdat.color );
    if( movdat.origen )
        hv_store_str( hashmov, "f", movdat.origen );
    hv_store_str( hashmov, "t", movdat.destino );

    if( movdat.captura ){
        AV* arrcap = newAV();
        sv_2mortal( (SV*) arrcap );
        while(1){
            HV* hashcap = newHV();
            sv_2mortal( (SV*)hashcap );
            hv_store_str( hashcap, "cp", movdat.captura_pieza );
            hv_store_str( hashcap, "cs", movdat.captura_casillero );
            hv_store_str( hashcap, "cc", movdat.captura_color );
            av_push( arrcap, newRV((SV*)hashcap) );
            if( !qg_partida_movdata_nextcap( par, &movdat ) ) break;
        }
        hv_store( hashmov, "cap", 3, newRV( (SV*)arrcap ), 0 );
    }

    if( movdat.movida > 1 ){
        AV* arrmov = newAV();
        sv_2mortal( (SV*) arrmov );
        qg_partida_movdata_nextmov( par, &movdat );
        while(1){
            HV* hashmmm = newHV();
            sv_2mortal( (SV*)hashmmm );
            hv_store_str( hashmmm, "mp", movdat.movida_pieza );
            if( movdat.movida_origen )
                hv_store_str( hashmmm, "mf", movdat.movida_origen );
            if( movdat.movida_destino )
                hv_store_str( hashmmm, "mt", movdat.movida_destino );
            if( movdat.movida_color )
                hv_store_str( hashmmm, "mc", movdat.movida_color );
            
            av_push( arrmov, newRV((SV*)hashmmm) );
            if( !qg_partida_movdata_nextmov( par, &movdat ) ) break;
        }
        hv_store( hashmov, "move", 4, newRV((SV*)arrmov), 0 );
    }

    if( movdat.transforma ){
        AV* arrtra = newAV();
        sv_2mortal( (SV*) arrtra );
        while(1){
            HV* hashtra = newHV();
            sv_2mortal( (SV*)hashtra );
            hv_store_str( hashtra, "tp", movdat.transforma_pieza );
            hv_store_str( hashtra, "tc", movdat.transforma_color );
            av_push( arrtra, newRV((SV*)hashtra) );
            if( !qg_partida_movdata_nexttran( par, &movdat ) ) break;
        }
        hv_store( hashmov, "tr", 2, newRV( (SV*)arrtra ), 0 );
    }

    if( movdat.crea ){
        AV* arrcre = newAV();
        sv_2mortal( (SV*) arrcre );
        while(1){
            HV* hashcre = newHV();
            sv_2mortal( (SV*)hashcre );
            hv_store_str( hashcre, "rp", movdat.crea_pieza );
            hv_store_str( hashcre, "rc", movdat.crea_color );
            hv_store_str( hashcre, "rs", movdat.crea_casillero );
            av_push( arrcre, newRV((SV*)hashcre) );
            if( !qg_partida_movdata_nextcrea( par, &movdat ) ) break;
        }
        hv_store( hashmov, "crea", 4, newRV( (SV*)arrcre ), 0 );
    }

    return hashmov;
}



MODULE = QGames		PACKAGE = QGames		

BOOT:
  {
      HV *stash;
      stash = gv_stashpv("QGames", TRUE);
      newCONSTSUB(stash, "PLAYING", newSViv(FINAL_ENJUEGO));
      newCONSTSUB(stash, "DRAW", newSViv(FINAL_EMPATE));
  }




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


QGames_Gametype
open(juego)
        char* juego
    CODE:
        static  HV*  hv_listgames = NULL;
        int  len = strlen( juego );
        RETVAL = NULL;
        if( hv_listgames ){
            SV** game = hv_fetch( hv_listgames, juego, len, 0 );
            if( game ){
                RETVAL = (Tipojuego*)(*game);
            }
        } else {
            hv_listgames = newHV();
        }
        if( !RETVAL ){
            RETVAL = qg_tipojuego_open( juego );
            hv_store( hv_listgames, juego, len, (SV*)RETVAL, 0 );
        }
    OUTPUT:
        RETVAL


MODULE = QGames		PACKAGE = QGames::Gametype  PREFIX = tjuego_

QGames_Game
tjuego_crea(tj,id=NULL)
        QGames_Gametype tj
        char* id
    CODE:
        RETVAL = qg_tipojuego_create_partida( tj, id );
    OUTPUT:
        RETVAL

QGames_Game
tjuego_load(tj, bin)
        QGames_Gametype tj
        SV* bin
    CODE:
        STRLEN len;
        char* dat;
        dat = SvPV( bin, len );
        RETVAL = qg_partida_load( tj, (void*)dat, len );
    OUTPUT:
        RETVAL

HV*
tjuego_describe(tj)
        QGames_Gametype tj
    CODE:
        RETVAL = newHV();
        sv_2mortal((SV*)RETVAL);
        {
            HV* hashcol = newHV();
            int i = 1; const char* color ;
            while( color = qg_tipojuego_info_color( tj, i ) ){
                HV* hashrot = newHV();
                if( qg_tipojuego_info_color_rotado( tj, i ) ) {
                    hv_store( hashrot, "rot", 3, newSViv( 1 ), 0 );
                } else {
                    hv_store( hashrot, "rot", 3, newSViv( 0 ), 0 );
                }
                hv_store( hashcol, color, strlen(color), newRV( (SV*)hashrot ), 0 );
                i ++;
            }
            hv_store( RETVAL, "c", 1, newRV((SV*)hashcol), 0 );
        }
        {
            AV* arrpie = newAV();
            int i = 1; const char* tpieza;
            while( tpieza = qg_tipojuego_info_tpieza( tj, i ) ){
                av_push( arrpie, newSVpv( tpieza, strlen( tpieza ) ) );
                i ++;
            }
            hv_store( RETVAL, "p", 1, newRV((SV*)arrpie), 0 );
        }
        {
            HV* hashcas = newHV();
            int i = 1; const char* cas; int* pos;
            int dims = qg_tipojuego_get_dims( tj );
            while( cas = qg_tipojuego_info_casillero( tj, i, &pos ) ){
                AV* coord   = newAV();
                int j;
                for( j = 0; j < dims; j ++ ){
                    av_push( coord, newSViv( pos[j] ) );
                }
                hv_store( hashcas, cas, strlen(cas), newRV((SV*)coord), 0 );
                i ++;
            }
            hv_store( RETVAL, "s", 1, newRV((SV*)hashcas), 0 );
            hv_store( RETVAL, "dims", 4, newSViv( dims ), 0 );
        }
        { 
            const char* nombre = qg_tipojuego_get_nombre( tj );
            hv_store( RETVAL, "name", 4, newSVpv( nombre, strlen( nombre ) ), 0 );
        }
    OUTPUT:
        RETVAL

const char* 
tjuego_name(tj)
        QGames_Gametype tj
    CODE:
        RETVAL = qg_tipojuego_get_nombre( tj );
    OUTPUT:
        RETVAL


HV*
tjuego_img(tj, ...)
        QGames_Gametype tj
    CODE:
        // tablero
        STRLEN  len;
        if( items == 1 || ( items == 2 && strcmp( "tablero", (char*)SvPV(ST(1), len ) ) == 0 ) ){
            RETVAL = newHV();
            sv_2mortal((SV*)RETVAL);
            // Tablero
            int w, h;
            void* png;
            int size;
            if( size = qg_tipojuego_get_tablero_png( tj, BOARD_ACTUAL, 0, &png, &w, &h ) ){
                hv_store( RETVAL, "png", 3, newSVpv( png, size ), 0 );
                hv_store( RETVAL, "w", 1, newSViv( w ), 0 );
                hv_store( RETVAL, "h", 1, newSViv( h ), 0 );
            }
        } else if( items == 2 && strcmp( "rotado", (char*)SvPV(ST(1), len ) ) == 0 ){
            RETVAL = newHV();
            sv_2mortal((SV*)RETVAL);
            // Tablero
            int w, h;
            void* png;
            int size;
            if( size = qg_tipojuego_get_tablero_png( tj, BOARD_ACTUAL, GETPNG_ROTADO, &png, &w, &h ) ){
                hv_store( RETVAL, "png", 3, newSVpv( png, size ), 0 );
                hv_store( RETVAL, "w", 1, newSViv( w ), 0 );
                hv_store( RETVAL, "h", 1, newSViv( h ), 0 );
            }
        } else if( items == 3 || items == 4 ){
            char* color = NULL; char* tpieza = NULL;
            char* arg =  (char*)SvPV(ST(1), len );
            if( qg_tipojuego_get_color( tj, arg ) != NOT_FOUND ){
                color = arg;
            } else if( qg_tipojuego_get_tipopieza( tj, arg ) != NOT_FOUND ){
                tpieza = arg;
            } else {
                croak( "arg 2/%d: Debe ser pieza o color (%s)", items, arg );
            }

            arg =  (char*)SvPV(ST(2), len );
            if( qg_tipojuego_get_color( tj, arg ) != NOT_FOUND ){
                color = arg;
            } else if( qg_tipojuego_get_tipopieza( tj, arg ) != NOT_FOUND ){
                tpieza = arg;
            } else {
                croak( "arg 3/%d: Debe ser pieza o color (%s)", items, arg );
            }
            if( !tpieza || !color ){
                croak( "Mal definidos los parametros" );
                RETVAL = (HV*) &PL_sv_undef;
            } else {
                RETVAL = newHV();
                sv_2mortal((SV*)RETVAL);
                // Tablero
                int w, h;
                void* png;
                int size;
                int flags = ( items == 4 && strncmp( "cap", (char*)SvPV(ST(3), len ), 3 ) == 0 ? 
                              GETPNG_PIEZA_CAPTURADA : 0 );
                if( size = qg_tipojuego_get_tpieza_png( tj, color, tpieza, flags, &png, &w, &h ) ){
                    hv_store( RETVAL, "png", 3, newSVpv( png, size ), 0 );
                    hv_store( RETVAL, "w", 1, newSViv( w ), 0 );
                    hv_store( RETVAL, "h", 1, newSViv( h ), 0 );
                }
            }
        } else {
            RETVAL = (HV*) &PL_sv_undef;
        }
    OUTPUT:
        RETVAL
        

HV*
tjuego_logo(tj)
        QGames_Gametype tj
    CODE:
        void*  png; int w, h, size;
        if( size = qg_tipojuego_get_logo( tj, &png, &w, &h ) ){
            RETVAL = newHV();
            sv_2mortal((SV*)RETVAL);
            hv_store( RETVAL, "png", 3, newSVpv( png, size ), 0 );
            hv_store( RETVAL, "w", 1, newSViv( w ), 0 );
            hv_store( RETVAL, "h", 1, newSViv( h ), 0 );
            qgames_free_png( png );
        } else {
            RETVAL = (HV*) &PL_sv_undef;
        }
    OUTPUT:
        RETVAL





MODULE = QGames		PACKAGE = QGames::Game  PREFIX = partida_

void
partida_DESTROY(par)
        QGames_Game par
    CODE:
        printf( "Destroying partida %s\n", qg_partida_id( par ) );
        qg_partida_free( par );

char*
partida_id(par)
        QGames_Game par
    CODE:
        RETVAL = qg_partida_id( par );
    OUTPUT:
        RETVAL


AV*
partida_possible(par)
        QGames_Game par
    CODE:
        int movnum = 0;
        Movdata movdat;
        RETVAL = newAV();
        sv_2mortal((SV*)RETVAL);
        while( qg_partida_movidas_data( par, movnum, &movdat ) ){
            av_push( RETVAL, newRV( (SV*)generate_hash_movida(par, movdat) ) );
            movnum ++;
        }
    OUTPUT:
        RETVAL

AV*
partida_history(par)
        QGames_Game par
    CODE:
        int movnum = 0;
        Movdata movdat;
        RETVAL = newAV();
        sv_2mortal((SV*)RETVAL);
        while( qg_partida_movhist_data( par, movnum, &movdat ) ){
            av_push( RETVAL, newRV( (SV*)generate_hash_movida(par, movdat) ) );
            movnum ++;
        }
    OUTPUT:
        RETVAL


int
partida_move(par, mov)
        QGames_Game par
        SV*  mov
    CODE:
        STRLEN len;
        char* ptrmov;
        if( SvIOK( mov )) {
            RETVAL = qg_partida_mover( par, SvIV( mov ) );
            if( !RETVAL )
                croak( "Incorrect move %d", SvIV(mov) );
        } else {
            ptrmov = SvPV( mov, len );
            if( ptrmov ){
                RETVAL = qg_partida_mover_notacion( par, ptrmov );
                if( !RETVAL )
                    croak( "Incorrect move %s", ptrmov );
            } else {
                croak( "Incorrect move" );
            }
        }
    OUTPUT:
        RETVAL


AV*
partida_board(par)
        QGames_Game par
    CODE:
        RETVAL = newAV();
        sv_2mortal((SV*)RETVAL);
        int pie = qg_partida_tablero_count( par, LAST_MOVE );
        int cap = qg_partida_tablero_countcap( par, LAST_MOVE );
        int i;
        for( i = 0; i < pie; i ++ ){
            char* casillero; char* tipo; char* color;
            qg_partida_tablero_data( par, LAST_MOVE, i, &casillero, &tipo, &color );
            HV* hashpie = newHV();
            sv_2mortal( (SV*)hashpie );
            hv_store_str( hashpie, "p", tipo );
            hv_store_str( hashpie, "s", casillero );
            hv_store_str( hashpie, "c", color );
            av_push( RETVAL, newRV((SV*)hashpie) );
        }
        for( i = 0; i < cap; i ++ ){
            char* tipo; char* color;
            qg_partida_tablero_datacap( par, LAST_MOVE, i, &tipo, &color );
            HV* hashpie = newHV();
            sv_2mortal( (SV*)hashpie );
            hv_store_str( hashpie, "p", tipo );
            hv_store_str( hashpie, "s", ":captured" );
            hv_store_str( hashpie, "c", color );
            av_push( RETVAL, newRV((SV*)hashpie) );
        }
    OUTPUT:
        RETVAL

const char*
partida_color(par)
        QGames_Game par
    CODE:
        RETVAL = qg_partida_color( par );
    OUTPUT:
        RETVAL


int
partida_move_count(par)
        QGames_Game par
    CODE:
        RETVAL = qg_partida_movhist_count( par );
    OUTPUT:
        RETVAL

char*
partida_state(par)
        QGames_Game par
    CODE:
        char* res;
        qg_partida_final( par, &res );
        RETVAL = res ? res : "Playing";
    OUTPUT:
        RETVAL

int 
partida_final(par)
        QGames_Game par
    CODE:
        RETVAL = qg_partida_final( par, NULL );
    OUTPUT:
        RETVAL

const char*
partida_winner(par)
        QGames_Game par
    CODE:
        int ret = qg_partida_final( par, NULL );
        switch(ret){
            case FINAL_ENJUEGO:
            case FINAL_EMPATE:
                RETVAL = NULL;
                break;
            default:
                RETVAL = qg_partida_color( par );
        }
    OUTPUT:
        RETVAL
      


SV*
partida_dump(par)
        QGames_Game par
    CODE:
        void* dat; int len;
        if( !qg_partida_dump( par, &dat, &len ) ){
            croak( "Error en dump de partida" );
            RETVAL = newSViv( 0 );
        } else {
            RETVAL = newSVpv( (char*) dat, len );
        };
    OUTPUT:
        RETVAL

