%{
#include <stdio.h>
extern int yylex();
extern int yyparse();
extern FILE *yyin;
void yyerror(const char *s);
%}

%union {
    int ival;
}

%token <ival> INTEGER
%left '+' '-'
%left '*' '/'
%right UMINUS
%type <ival> exp

%%
input
    : /* empty */
    | input line
    ;

line
    : exp '\n' { printf("Result: %d\n", $1); }
    | error '\n' { yyerrok; }
    ;

exp
    : INTEGER
    | exp '+' exp { $$ = $1 + $3; }
    | exp '-' exp { $$ = $1 - $3; }
    | exp '*' exp { $$ = $1 * $3; }
    | exp '/' exp { if ($3 == 0) { yyerror("division by zero"); } else { $$ = $1 / $3; } }
    | '-' exp %prec UMINUS { $$ = -$2; }
    | '(' exp ')' { $$ = $2; }
    ;

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Cannot open file %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    }
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}