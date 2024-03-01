%{
#include <stdio.h>
#include <string.h>

// Define global variables and functions
int flag = 0;
int sCounter = 0;
int lCounter = 0;
char var[100][50];
int var_no = 0;

// Forward declarations
void validvar(char* str, int p);
void yyerror(const char* s);

%}

%start P

%union {
    struct quadruple {
        int num;
        int isnum;
        char* arg1;
        char* arg2;
        char* arg3;
        char* arg4;
        char* result;
    } tuple;
}

%token <tuple> COMMENT
%token <tuple> HEADER
%token <tuple> NUMBER
%token <tuple> EQ
%token <tuple> UOP
%token <tuple> ELSE
%token <tuple> IF
%token <tuple> CASE
%token <tuple> SWITCH
%token <tuple> CONTINUE
%token <tuple> WHILE
%token <tuple> BREAK
%token <tuple> DO
%token <tuple> FOR
%token <tuple> IDENTIFIER
%token <tuple> LOP
%token <tuple> COP
%token <tuple> AOP
%token <tuple> BOP
%token <tuple> STRINGLITERAL
%token <tuple> DT
%token <tuple> RETURN
%token <tuple> NOT
%token PRINT SCAN

%type <tuple> P HEADERS REST FUNC STMT DECLS2 RETURNSTMT STMTS DECLR DECLS INS E

%left '+' '-'
%left '*' '/' '%'
%left '(' ')'

%%

P: HEADERS REST 
   | COMMENTS HEADERS REST

HEADERS: HEADER
    | HEADER HEADERS
    | /*epsilon*/

REST: REST REST
    | STMT
    | COMMENTS
    | FUNC
    | /*epsilon*/

FUNC: DT IDENTIFIER '(' DECLS2 ')' '{' STMTS '}'
    | DT IDENTIFIER '(' ')' '{' STMTS '}' 


DECLR: DT DECLS ';'

DECLS2: DT IDENTIFIER { validvar($2.result, 1); }
    | DT IDENTIFIER ',' DECLS2 { validvar($2.result, 1); }

DECLS: IDENTIFIER EQ E { validvar($1.result, 1); }
    | IDENTIFIER { validvar($1.result, 1); }
    | IDENTIFIER ',' DECLS { validvar($1.result, 1); }
    | IDENTIFIER EQ E ',' DECLS { validvar($1.result, 1); }

STMT: E ';'
    | IDENTIFIER AOP EQ E ';'
    | IDENTIFIER EQ E ';'
    | IF '(' E ')' STMT 
    | IF '(' E ')' STMT ELSE STMT
    | IF '(' E ')' '{' STMTS '}' ELSE STMT
    | IF '(' E ')' '{' STMTS '}' ELSE '{' STMTS '}'
    | IF '(' E ')' '{' STMTS '}'
    | IF '(' E ')' STMT ELSE '{' STMTS '}'
    | WHILE '(' E ')' '{' STMT '}'
    | WHILE '(' E ')' '{' STMTS '}'
    | DO '{' STMTS '}' WHILE '(' E ')' ';'
    | FOR '(' DECLR E ';' E ')' '{' STMT '}'
    | FOR '(' DECLR E ';' E ')' '{' STMTS '}'
    | BREAK ';'
    | CONTINUE ';'
    | FUNC
    | RETURNSTMT
    | PRINT '(' STRINGLITERAL ')' ';'
    | PRINT '(' STRINGLITERAL IDENTIFIERS ')' ';'
    | SCAN '(' STRINGLITERAL ',' '&' IDENTIFIER ')' ';'
    | COMMENT
    | DECLR

RETURNSTMT: RETURN ';'
    | RETURN IDENTIFIER ';'
    | RETURN E ';'
    | RETURN NUMBER ';'
    | RETURN STRINGLITERAL ';'
	| RETURN '(' STRINGLITERAL ')' ';'
	| RETURN '(' STRINGLITERAL IDENTIFIERS ')' ';'
	
IDENTIFIERS :',' IDENTIFIER IDENTIFIERS
			  | /*epsilon*/

STMTS: /*epsilon*/
    | STMT STMTS

E: IDENTIFIER { validvar($1.result, 0); }
    | IDENTIFIER '(' E ')'
    | IDENTIFIER '(' ')'
    | UOP IDENTIFIER { validvar($2.result, 0); }
    | IDENTIFIER UOP { validvar($1.result, 0); }
    | E AOP E
    | E COP E
    | E LOP E
    | E BOP E
    | NOT E
    | '(' E ')'
    | NUMBER
    | STRINGLITERAL

COMMENTS : /*epsilon*/
    | COMMENT COMMENTS

%%

char* Temp() {
    sCounter++;
    char* temp = (char*)malloc(10 * sizeof(char));
    sprintf(temp, "t%d", sCounter);
    return temp;
}

char* Label() {
    lCounter++;
    char* temp = (char*)malloc(10 * sizeof(char));
    sprintf(temp, "L%d", lCounter);
    return temp;
}

void validvar(char* str, int p) {
    int j = 0, flag = 0;
    while (j < var_no) {
        if (strcmp(var[j], str) == 0) {
            flag = 1;
            break;
        }
        j++;
    }

    if (p == 1 && flag == 1) {
        yyerror(strcat(str, " - Error: variable is already declared!"));
        return;
    } else if (p == 0 && flag == 0) {
        yyerror(strcat(str, " - Error: variable is not defined!"));
        return;
    } else if (p == 1) {
        strcpy(var[var_no++], str);
    }
    return;
}

int main() {
    printf("\n\n");
    yyparse();
    if (flag == 0)
        printf("\nEntered C code is Valid\n\n");
    return 0;
}

void yyerror(const char* s) {
    extern int yylineno;
    extern char* yytext;
    fprintf(stderr, "%s on lines %d-%d near '%s'\n", s, yylineno - 1, yylineno, yytext);

    flag = 1;
}

