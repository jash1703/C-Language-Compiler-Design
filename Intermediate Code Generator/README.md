# Intermediate Code Generator

## Description 
The intermediate code generator translates the validated syntax tree into an intermediate representation that is closer to machine language but still independent of the target machine.

## Technologies Used 
- C programming language
- lex and yacc 

## Key Features:
- Generates intermediate code using quadruples, triples, or abstract syntax trees (AST).
- Prepares the code for further processing by the code optimizer and code generator.

## Run the program
To run the program 
1. Compile the flex and the yacc files:
```
flex C_lexer.l
bison -d C_parser.y
gcc lex.yy.c C_parser.tab.c -o C_ICG -ll
```

2. Run the executable 
```
./C_ICG
```
