
# Ruby Parser

This is a fully functioning Parser for Ruby using Yacc. Yacc generates a parser from a grammar file, which defines the rules for your language. 



## Features

 - Support for arithmetic expressions including addition, subtraction, multiplication, division, and parentheses for grouping. 
- Support Integer Values.
## Installation

To run the parser, you need to install Yacc and Lex: 

    sudo apt-get install bison flex

In the project directory, run the following commands to Generate lexer and parser:

    yacc -d ruby_parser.y
    lex -o lexer.c lexer.l

To compile the parser and lexer:

    gcc -o parser y.tab.c lexer.c -lfl

To test the parser run : 
    
    ./parser test.txt