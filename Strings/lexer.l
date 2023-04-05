%{
#include "y.tab.h"
%}

%%

[0-9]+          { yylval.ival = atoi(yytext); return INTEGER; }
[ \t]           { /* Ignore whitespace */ }
\n              { return '\n'; }
[+\-*/()]       { return yytext[0]; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return IDENTIFIER; }
"\""([^"\\]|\\.)*"\"" { yylval.sval = strdup(yytext + 1); yylval.sval[strlen(yytext) - 2] = '\0'; return STRING; }  // added for string support
=               { return ASSIGN; }

%%

int yywrap() { return 1; }
