%{
#include "function_parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

identifier [a-zA-Z_][a-zA-Z0-9_]*
integer    [0-9]+
whitespace [ \t]+

%%

{identifier} {
    yylval.sval = strdup(yytext);
    return IDENTIFIER;
}

{integer} {
    yylval.ival = atoi(yytext);
    return INTEGER;
}

{whitespace} { /* ignore whitespace */ }

"("          { return LPAREN; }
")"          { return RPAREN; }
","          { return COMMA; }
"def"        { return DEF; }
"end"        { return END; }
"return"     { return RETURN; }

\n           { return EOL; }
.            { return yytext[0]; }

%%

int yywrap() {
    return 1;
}
