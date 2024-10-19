%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

typedef struct {
    int vida;
    int posicion;
    int poder;
} Jugador;

Jugador jugador1 = {10, -1, 0};  // Posición inicial del Jugador 1
Jugador jugador2 = {10, 1, 0};   // Posición inicial del Jugador 2

int calcular_probabilidad(int distancia);
void procesar_movimiento(int movimiento, Jugador *jugador, Jugador *oponente);
void procesar_ataque(int ataque, Jugador *jugador, Jugador *oponente);
void procesar_ataque_especial(Jugador *jugador, Jugador *oponente);
void imprimir_estado();

extern FILE *yyin;  // Para manejar la entrada desde archivo

// Declaración de yyerror
void yyerror(const char *s);

// Declaración de yylex (función generada por flex)
int yylex(void);

%}

%union {
    int num;
}

%token <num> MOVER_IZQUIERDA MOVER_DERECHA SALTAR AGACHAR
%token <num> CORTE_DEBIL CORTE_MEDIO CORTE_FUERTE
%token <num> PATADA_DEBIL PATADA_MEDIO PATADA_FUERTE
%token <num> BURLA CANCELAR_BURLA RODAR ATAQUE_ESPECIAL

%type <num> movimiento ataque

%%
combat:
    instrucciones
    ;

instrucciones:
    instrucciones instruccion
    | instruccion
    ;

instruccion:
    movimiento { procesar_movimiento($1, &jugador1, &jugador2); imprimir_estado(); }
    | ataque   { procesar_ataque($1, &jugador1, &jugador2); imprimir_estado(); }
    ;

movimiento:
    MOVER_IZQUIERDA   { $$ = MOVER_IZQUIERDA; }
    | MOVER_DERECHA   { $$ = MOVER_DERECHA; }
    | SALTAR          { printf("Jugador saltó.\n"); $$ = 0; }
    | AGACHAR         { printf("Jugador se agachó.\n"); $$ = 0; }
    | BURLA           { printf("Jugador burla.\n"); $$ = 0; }
    | CANCELAR_BURLA  { printf("Jugador cancela burla.\n"); $$ = 0; }
    | RODAR           { printf("Jugador rodó.\n"); $$ = 0; }
    ;

ataque:
    CORTE_DEBIL       { $$ = CORTE_DEBIL; }
    | CORTE_MEDIO     { $$ = CORTE_MEDIO; }
    | CORTE_FUERTE    { $$ = CORTE_FUERTE; }
    | PATADA_DEBIL    { $$ = PATADA_DEBIL; }
    | PATADA_MEDIO    { $$ = PATADA_MEDIO; }
    | PATADA_FUERTE   { $$ = PATADA_FUERTE; }
    | ATAQUE_ESPECIAL { procesar_ataque_especial(&jugador1, &jugador2); $$ = 0; }
    ;

%%

int calcular_probabilidad(int distancia) {
    if (distancia < 2) return 1;
    else if (distancia < 4) return 0.5;
    return 0;
}

void procesar_movimiento(int movimiento, Jugador *jugador, Jugador *oponente) {
    if (movimiento == MOVER_IZQUIERDA && jugador->posicion > -3) jugador->posicion--;
    else if (movimiento == MOVER_DERECHA && jugador->posicion < 3) jugador->posicion++;
    printf("Jugador en posición: %d\n", jugador->posicion);
}

void procesar_ataque(int ataque, Jugador *jugador, Jugador *oponente) {
    int distancia = abs(jugador->posicion - oponente->posicion);
    float probabilidad = calcular_probabilidad(distancia);
    float dano = 0;

    if (ataque == CORTE_DEBIL || ataque == PATADA_DEBIL) dano = 0.33;
    else if (ataque == CORTE_MEDIO || ataque == PATADA_MEDIO) dano = 0.66;
    else if (ataque == CORTE_FUERTE || ataque == PATADA_FUERTE) dano = 1.0;

    if ((rand() % 100) / 100.0 < probabilidad) {
        oponente->vida -= dano;
        jugador->poder++;
        printf("Ataque exitoso! Daño: %.2f\n", dano);
        if (jugador->poder >= 5) printf("Poder lleno! Puedes usar un ataque especial.\n");
    } else {
        printf("Ataque fallido.\n");
    }
}

void procesar_ataque_especial(Jugador *jugador, Jugador *oponente) {
    int distancia = abs(jugador->posicion - oponente->posicion);
    float probabilidad = calcular_probabilidad(distancia);

    if ((rand() % 100) / 100.0 < probabilidad) {
        oponente->vida -= 3;
        jugador->poder = 0;
        printf("Ataque especial exitoso! Daño: 3\n");
    } else {
        printf("Ataque especial fallido.\n");
    }
}

void imprimir_estado() {
    printf("Jugador 1 - Vida: %d, Posición: %d, Poder: %d\n", jugador1.vida, jugador1.posicion, jugador1.poder);
    printf("Jugador 2 - Vida: %d, Posición: %d, Poder: %d\n", jugador2.vida, jugador2.posicion, jugador2.poder);
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("Error abriendo archivo");
            return 1;
        }
        yyin = file;  // Asignación de la entrada al archivo proporcionado
        yyparse();
        fclose(file);
    } else {
        printf("Uso: ./combate <archivo.txt>\n");
    }
    return 0;
}
