# Lexical Analyzer:
## Description 
The lexical analyzer, also known as the scanner, reads the source code character by character and groups them into meaningful tokens.
## Technologies Used 
- C programming language
- lex and yacc
## Key Features:
- Identifies keywords, identifiers, constants, operators, and special symbols.
- Handles comments, whitespace, and newline characters.
- Implements tokenization using regular expressions or finite automata.

## Running the program
To run the ```C_lexer.l``` file 
1. Compile the flex file  
```
flex C_lexer.l
gcc lex.yy.c -o C_lexer
```

2. Run the executable 
```
./C_lexer
```
