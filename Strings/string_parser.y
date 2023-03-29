%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *value;
    int length;
} string_literal;

void yyerror(const char *s);

%}

%union {
    int ival;
    char *sval;
    string_literal sl;
}

%token <sval> IDENTIFIER
%token <sl> STRING_LITERAL
%token EOL

%%

start: program { printf("String parsing completed.\n"); }
     ;

program: statement
       | program statement
       ;

statement: expr EOL
         ;

expr: IDENTIFIER
    | STRING_LITERAL { printf("Parsed string: %s\nLength: %d\n", $1.value, $1.length); }
    ;

%%

int main(int argc, char **argv) {
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
