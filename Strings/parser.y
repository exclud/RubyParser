%{
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylex();
extern int yyparse();
extern FILE *yyin;
void yyerror(const char *s);

typedef struct symbol {
  char *name;
  int value;
  char *str_value;
  struct symbol *next;
} symbol;

symbol *symbol_table = NULL;

symbol *lookup_symbol(const char *name);
void add_symbol(const char *name, int value, char *str_value);
%}

%union {
    int ival;
    char *sval;
}

%token <ival> INTEGER
%token <sval> IDENTIFIER
%token <sval> STRING_LITERAL
%token ASSIGN
%left '+' '-'
%left '*' '/'
%right UMINUS
%type <ival> exp
%type <sval> identifier
%type <sval> string_exp

%%
input
    : /* empty */
    | input line
    ;

line
    : exp '\n' { printf("Result: %d\n", $1); }
    | string_exp '\n' { printf("Result: %s\n", $1); free($1); }
    | assignment '\n'
    | error '\n' { yyerrok; }
    ;

assignment
    : int_assignment
    | str_assignment
    ;

int_assignment
    : IDENTIFIER ASSIGN exp {
        symbol *sym = lookup_symbol($1);
        if (!sym) {
            add_symbol($1, $3, NULL);
        } else {
            sym->value = $3;
        }
        free($1);
      }
    ;

str_assignment
    : IDENTIFIER ASSIGN string_exp {
        symbol *sym = lookup_symbol($1);
        if (!sym) {
            add_symbol($1, 0, $3);
        } else {
            if (sym->str_value) free(sym->str_value);
            sym->str_value = $3;
        }
        free($1);
      }
    ;

identifier
    : IDENTIFIER {
        symbol *sym = lookup_symbol($1);
        if (!sym) {
            yyerror("Undefined variable");
            YYERROR;
        }
        $$ = $1;
      }
    ;

exp
    : INTEGER
    | identifier { $$ = lookup_symbol($1)->value; free($1); }
    | exp '+' exp { $$ = $1 + $3; }
    | exp '-' exp { $$ = $1 - $3; }
    | exp '*' exp { $$ = $1 * $3; }
    | exp '/' exp { if ($3 == 0) { yyerror("division by zero"); } else { $$ = $1 / $3; } }
    | '-' exp %prec UMINUS { $$ = -$2; }
    | '(' exp ')' { $$ = $2; }
    ;

string_exp
    : STRING_LITERAL
    | identifier { $$ = strdup(lookup_symbol($1)->str_value); free($1); }
    | string_exp '+' string_exp { asprintf(&$$, "%s%s", $1, $3); free($1); free($3); }
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

void yyerror(const char * s) {
fprintf(stderr, "Error: %s\n", s);
}
symbol *lookup_symbol(const char *name) {
symbol *sym = symbol_table;
while (sym) {
if (strcmp(sym->name, name) == 0) {
return sym;
}
sym = sym->next;
}
return NULL;
}

void add_symbol(const char *name, int value, char *str_value) {
symbol *sym = lookup_symbol(name);
if (sym) {
sym->value = value;
if (sym->str_value) free(sym->str_value);
sym->str_value = str_value ? strdup(str_value) : NULL;
} else {
sym = (symbol *) malloc(sizeof(symbol));
sym->name = strdup(name);
sym->value = value;
sym->str_value = str_value ? strdup(str_value) : NULL;
sym->next = symbol_table;
symbol_table = sym;
}
}


