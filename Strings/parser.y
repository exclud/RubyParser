%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
extern int yylex();
extern int yyparse();
extern FILE *yyin;
void yyerror(const char *s);

typedef struct symbol {
  char *name;
  int value;
  char *str_value;  // added for string support
  struct symbol *next;
} symbol;

symbol *symbol_table = NULL;

symbol *lookup_symbol(const char *name);
void add_symbol(const char *name, int value, const char *str_value);
%}

%union {
    int ival;
    char *sval;
}

%token <ival> INTEGER
%token <sval> IDENTIFIER
%token <sval> STRING  // added for string support
%token ASSIGN
%left '+' '-'
%left '*' '/'
%right UMINUS
%type <ival> exp
%type <sval> identifier

%%
input
    : /* empty */
    | input line
    ;

line
    : exp '\n' { printf("Result: %d\n", $1); }
    | assignment '\n'
    | error '\n' { yyerrok; }
    ;

assignment
    : IDENTIFIER ASSIGN exp {
        symbol *sym = lookup_symbol($1);
        if (!sym) {
            add_symbol($1, $3, NULL);
        } else {
            sym->value = $3;
            free(sym->str_value);
            sym->str_value = NULL;
        }
        free($1);
      }
    | IDENTIFIER ASSIGN STRING {  // added for string support
        symbol *sym = lookup_symbol($1);
        if (!sym) {
            add_symbol($1, 0, $3);
        } else {
            sym->value = 0;
            free(sym->str_value);
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

void add_symbol(const char *name, int value, const char *str_value) {
symbol *sym = lookup_symbol(name);
if (sym) {
sym->value = value;
if (str_value) {
free(sym->str_value);
sym->str_value = strdup(str_value);
} else {
sym->str_value = NULL;
}
} else {
sym = (symbol *) malloc(sizeof(symbol));
sym->name = strdup(name);
sym->value = value;
sym->str_value = str_value ? strdup(str_value) : NULL;
sym->next = symbol_table;
symbol_table = sym;
}
}