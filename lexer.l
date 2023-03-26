%{
#include "y.tab.h"
%}

%%

[0-9]+      { yylval.ival = atoi(yytext); return INTEGER; }
[ \t]       { /* Ignore whitespace */ }
\n          { return '\n'; }
[+\-*/()]    { return yytext[0]; }

%%

int yywrap() { return 1; }
