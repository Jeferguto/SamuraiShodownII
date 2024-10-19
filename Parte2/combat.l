%{
#include "combat.tab.h"
%}

%%
"izquierda"            { return MOVER_IZQUIERDA; }
"derecha"              { return MOVER_DERECHA; }
"saltar"               { return SALTAR; }
"agacharse"            { return AGACHAR; }
"corte_debil"          { return CORTE_DEBIL; }
"corte_medio"          { return CORTE_MEDIO; }
"corte_fuerte"         { return CORTE_FUERTE; }
"patada_debil"         { return PATADA_DEBIL; }
"patada_medio"         { return PATADA_MEDIO; }
"patada_fuerte"        { return PATADA_FUERTE; }
"burla"                { return BURLA; }
"cancelar_burla"       { return CANCELAR_BURLA; }
"rodar"                { return RODAR; }
"ataque_especial"      { return ATAQUE_ESPECIAL; }
[ \t\n]                { /* Ignorar espacios, tabs y saltos de línea */ }
.                      { /* Ignorar cualquier otro carácter */ }

%%

int yywrap(void) {
    return 1;
}
