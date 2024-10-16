%{
#include "samurai.tab.h"
%}

%%
A         { return CORTE_DEBIL; }
B         { return CORTE_MEDIO; }
AB        { return CORTE_FUERTE; }
C         { return PATADA_DEBIL; }
D         { return PATADA_MEDIA; }
CD        { return PATADA_FUERTE; }
⇑         { return SALTAR; }
⇒         { return DERECHA; }
⇐         { return IZQUIERDA; }
⇓         { return AGACHAR; }
%%

int yywrap(void) {
  return 1;
}

