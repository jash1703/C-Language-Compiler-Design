%{
#include<stdio.h>
%}

%%
"include"[^\n;]+ {printf("Header: %s",yytext );}
"int"|"char"|"short"|"long"|"long long"|"float"|"double"|"long double"|"_Bool"|"void"|"enum"|"struct"|"union"|"main"|"printf"|"scanf"|"return"|"typedef"|"volatile"|"%d"|"%s"|"%u"|"%f"|"dict"|"const" {printf("KEYWORD : %s\n",yytext);}

"+"|"-"|"*"|"/"|"%"|"="|"+="|"-="|"=="|"*="|"<<="|">>="|"&="|"^="|"\/="|"\|"|"&"|"^"|"~"|"<<"|">>"|"!="|"<"|">"|"<="|">="|"**"|"++"|"--" {printf("OPERATOR : %s\n",yytext);}


"if"|"else"|"else if"|"while"|"for"|"switch"|"do" {printf("STATEMENT : %s\n",yytext);}

[a-zA-Z_][a-zA-Z0-9_]* {printf("IDENTIFIER : %s\n",yytext);}

\\n|\\t {printf("SPACES : %s\n",yytext);}

"-"[0-9.]+|[0-9.]+|"\""[^\n;]+"\""|\'(\\.|[^\\\'])\' {printf("CONSTANT : %s \n",yytext);}

":"|";"|","|"("|")"|"["|"]"|"{"|"}" {printf("SEPERATOR : %s \n",yytext);}

\/\/[^\n;]+|\/\*[^\n;]+\*\/        { printf("COMMENT : %s\n", yytext); }
.
%%

int yywrap() {return 1;}
int main(){
	printf("ENTER INPUT\n");
	yylex();
}



