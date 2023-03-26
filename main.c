/* Include necessary headers */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Define token types */
#define NUMBER 100
#define IDENTIFIER 200
#define OPERATOR 300
#define KEYWORD 400
#define PUNCTUATION 500

/* Declare yylval variable */
int yylval;

/* Declare parsing functions */
int yyparse();
void yyerror(const char *);

/* Define the grammar rules */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Declare parsing functions */
int yylex();
int yyparse();
void yyerror(const char *);

/* Define token types */
#define NUMBER 100
#define IDENTIFIER 200
#define OPERATOR 300
#define KEYWORD 400
#define PUNCTUATION 500
%}

/* Define token types */
%token NUMBER
%token IDENTIFIER
%token OPERATOR
%token KEYWORD
%token PUNCTUATION

/* Define the start symbol */
%start program

%%

program: statement_list;

statement_list:
    statement
    | statement_list statement
    ;

statement:
    expression_statement
    | if_statement
    | while_statement
    | for_statement
    | print_statement
    | assignment_statement
    ;

expression_statement:
    expression ';'
    ;

expression:
    NUMBER
    | IDENTIFIER
    | expression OPERATOR expression
    ;

if_statement:
    KEYWORD '(' expression ')' '{' statement_list '}' 
    | KEYWORD '(' expression ')' '{' statement_list '}' KEYWORD '{' statement_list '}'
    ;

while_statement:
    KEYWORD '(' expression ')' '{' statement_list '}'
    ;

for_statement:
    KEYWORD '(' assignment_statement ';' expression ';' expression ')' '{' statement_list '}'
    ;

print_statement:
    KEYWORD '(' expression ')' ';'
    ;

assignment_statement:
    IDENTIFIER '=' expression ';'
    ;

%%

/* Define the lexer */
int yylex() {
    int c;

    /* Ignore whitespace and newlines */
    while ((c = getchar()) == ' ' || c == '\t' || c == '\n');

    if (c == EOF) {
        return 0;
    }

    if (isdigit(c)) {
        yylval = c - '0';
        while (isdigit(c = getchar())) {
            yylval = yylval * 10 + c - '0';
        }
        ungetc(c, stdin);
        return NUMBER;
    }

    if (isalpha(c)) {
        char buf[128];
        char *p = buf;
        *p++ = c;
        while (isalnum(c = getchar()) || c == '_') {
            *p++ = c;
        }
        ungetc(c, stdin);
        *p = '\0';
        yylval = strdup(buf);
        return IDENTIFIER;
    }

    if (c == '+' || c == '-' || c == '*' || c == '/') {
        yylval = c;
        return OPERATOR;
    }

    if (c == '(' || c == ')' || c == '{' || c == '}' || c == ';' || c == ',') {
        yylval = c;
        return PUNCTUATION;
    }

    return 0;
}

/* Define the error function */
void yyerror(const char *s) {
    fprintf(stderr, "error: %s\n", s);
}

/* Define the main function */
int main() {
    yyparse();
    return 0;
}
