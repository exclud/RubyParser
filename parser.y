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

%%
input:
      /* %empty */
    | input line
    ;

line:
      INTEGER { printf("Parsed an integer: %d\n", $1); }
    | '\n'
    | error '\n' { yyerrok; }
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
