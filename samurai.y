%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h> // Para usar abs() para calcular la distancia

// Declaración de variables globales
int vida1 = 10, vida2 = 10;
int poder1 = 0, poder2 = 0;
int posicion1 = 0, posicion2 = 0;

void realizar_golpe(int tipo_golpe, int *vida_oponente);
int calcular_probabilidad_golpe(int distancia);
void yyerror(const char *s);  // Declaración de yyerror
%}

%token CORTE_DEBIL CORTE_MEDIO CORTE_FUERTE PATADA_DEBIL PATADA_MEDIA PATADA_FUERTE
%token SALTAR DERECHA IZQUIERDA AGACHAR

%%
turno:
    movimiento '\n' { /* lógica del turno */ }
  ;

movimiento:
    CORTE_DEBIL   { realizar_golpe(1, &vida2); }
  | CORTE_MEDIO   { realizar_golpe(2, &vida2); }
  | CORTE_FUERTE  { realizar_golpe(3, &vida2); }
  | PATADA_DEBIL  { realizar_golpe(1, &vida2); }
  | PATADA_MEDIA  { realizar_golpe(2, &vida2); }
  | PATADA_FUERTE { realizar_golpe(3, &vida2); }
  | SALTAR        { printf("Salta\n"); }
  | DERECHA       { posicion1++; printf("Se mueve a la derecha\n"); }
  | IZQUIERDA     { posicion1--; printf("Se mueve a la izquierda\n"); }
  | AGACHAR       { printf("Se agacha\n"); }
  ;

%%

void realizar_golpe(int tipo_golpe, int *vida_oponente) {
    int distancia = abs(posicion1 - posicion2);
    float probabilidad = calcular_probabilidad_golpe(distancia);
    
    printf("Distancia: %d, Probabilidad: %.2f\n", distancia, probabilidad);

    if (probabilidad >= 0.5) {
        switch(tipo_golpe) {
            case 1: *vida_oponente -= 0.33; printf("Golpe débil! Vida oponente: %.2f\n", *vida_oponente); break;
            case 2: *vida_oponente -= 0.66; printf("Golpe medio! Vida oponente: %.2f\n", *vida_oponente); break;
            case 3: *vida_oponente -= 1.0;  printf("Golpe fuerte! Vida oponente: %.2f\n", *vida_oponente); break;
        }
    } else {
        printf("El golpe falló por la distancia\n");
    }
}

int calcular_probabilidad_golpe(int distancia) {
    if (distancia < 2) return 1;
    if (distancia < 4) return 0.5;
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}

