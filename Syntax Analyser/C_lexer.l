/*Definition Section*/
%{
	#include<stdio.h>
	#include "C_parser.tab.h" 
	 
	 
%}
%option yylineno


KeywT "auto"|"include"|"enum"|"register"|"typedef"|"extern"|"return"|"signed"|"void"|"static"|"default"|"goto"|"sizeof"|"volatile"|"const"|"short"

DataT "int"|"char"|"float"|"double"|"long"

returnT "int"|"char"|"float"|"double"|"long"|"struct"|"union"

idenT ([a-zA-Z_])[a-zA-Z0-9_]*
%x C
%%

"/*"][.]*"*/"	{return COMMENT;}
"/*"		{BEGIN C;}
<C>"*/"	{BEGIN 0; return COMMENT;}
<C>\n		{;}
<C>.		{;}
\/\/.*		{return COMMENT;}
"#include <"[ ]*[a-z]+".h"[ ]*">" {return HEADER;}
{DataT} {return DT;}
"struct"|([a-zA-Z_])[a-zA-Z0-9_]*(\[[1-9][0-9]*\])+|"union"|{returnT}[ ]*[*]+[ ]*{idenT} {printf("%s\t Derived Data Type\n", yytext);}

"else" {return ELSE;}
"if" {return IF;}
"case" {return CASE;}
"switch" {return SWITCH;}
"continue" {return CONTINUE;}
"while" {return WHILE;}
"break" {return BREAK;}
"do" {return DO;}
"for" {return FOR;}
"return" {return RETURN;}
"printf" {return PRINT;}
"scanf" {return SCAN;}

{KeywT} {printf("\n%s\tOTHER KEYWORD\n",yytext);} 	
"&"{idenT} {printf("%s\tADDRESS\n",yytext);}			
"||"|"&&" {yylval.tuple.result = strdup(yytext);return LOP;}
"!" {yylval.tuple.result = strdup(yytext);return NOT;}
">="|">"|"<="|"<"|"=="|"!=" {yylval.tuple.result = strdup(yytext);return COP;}
"=" {yylval.tuple.result = strdup(yytext);return EQ;}
"++"|"--" {yylval.tuple.result = strdup(yytext);return UOP;}
"+"|"-"|"/"|"*"|"%"  {yylval.tuple.result = strdup(yytext); return AOP;}	
"^"|"|"|"&"|"~"|">>"|"<<" {yylval.tuple.result = strdup(yytext);return BOP;}				
{idenT} {yylval.tuple.result = strdup(yytext);return IDENTIFIER;} 
'"'.*'"'|'\'[^\']\''|"\""[^\n;]+"\"" {return STRINGLITERAL;}
[0-9]+|[0-9]+"."[0-9]+|[0-9]+x[0-9A_F] {yylval.tuple.num= atoi(yytext);return NUMBER;}


[ \t\n] ; 
  


. {return yytext[0];}

											
%%
int yywrap() 
{ 
 return 1; 
} 

