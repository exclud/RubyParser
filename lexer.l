%{
#include "y.tab.h"
%}

%%

[0-9]+      { yylval.ival = atoi(yytext); return INTEGER; }
[ \t\n]      { /* Ignore whitespace */ }
.           { return yytext[0]; }

%%

int yywrap() { return 1; }
