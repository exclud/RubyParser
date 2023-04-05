%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"

typedef struct {
    char *value;
    int length;
} string_literal;

void yyerror(const char *s);

int my_yywrap();
%}

%option noyywrap

%%

[ \t]+                  /* Ignore whitespace */
[0-9]+                  { yylval.ival = atoi(yytext); return INTEGER_CONST; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.sval = strdup(yytext); return IDENTIFIER; }
\"([^\\\"]|\\.)*\"       { yylval.sl.value = strdup(yytext + 1); yylval.sl.value[strlen(yytext) - 2] = '\0'; yylval.sl.length = strlen(yylval.sl.value); return STRING_LITERAL; }

\(                      { return LPAREN; }
\)                      { return RPAREN; }
\{                      { return LBRACE; }
\}                      { return RBRACE; }
,                       { return COMMA; }
\n                      { return EOL; }

.                       { yyerror("Unrecognized character"); }

%%

int my_yywrap() {
    return 1;
}
