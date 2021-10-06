%{
    extern "C" int yylex();
    #include "TreeNode.hpp"
    #define YYSTYPE TreeNode *
    #include "syntax.tab.h"

    #define EXIT_OK 0
    #define EXIT_FAIL 1

    int yycolno = 1;
    #define YY_USER_ACTION \
        yylloc.first_line = yylineno; \
        yylloc.first_column = yycolno; \
        yylloc.last_line = yylineno; \
        yylloc.last_column = yycolno + yyleng; \
        yycolno += yyleng;
%}

%option yylineno

letter [a-zA-Z]
letter_ {letter}|_
digit [0-9]
hexdigit [0-9a-fA-F]

%%
(\+?|-)0x{hexdigit}+|(\+?|-){digit}+    { yylval = create_node("INT", 0, DataType::INT_TYPE, yytext); return INT; }
{digit}+\.{digit}+                      { yylval = create_node("FLOAT", 0, DataType::FLOAT_TYPE, yytext); return FLOAT; }
\'([\x20-\x7E]|\\x{hexdigit}{1,2})\'    { yylval = create_node("CHAR", 0, DataType::CHAR_TYPE, yytext); return CHAR; }

int|float|char  { yylval = create_node("TYPE", 0, DataType::TYPE_TYPE, yytext); return TYPE; }
struct          { yylval = create_node("STRUCT", 0); return STRUCT; }
if              { yylval = create_node("IF", 0); return IF; }
else            { yylval = create_node("ELSE", 0); return ELSE; }
while           { yylval = create_node("WHILE", 0); return WHILE; }
return          { yylval = create_node("RETURN", 0); return RETURN; }

{letter_}({letter_}|{digit})*           { yylval = create_node("ID", 0, DataType::ID_TYPE, yytext); return ID; }

"."     { yylval = create_node("DOT", 0); return DOT; }
";"     { yylval = create_node("SEMI", 0); return SEMI; }
","     { yylval = create_node("COMMA", 0); return COMMA; }
"="     { yylval = create_node("ASSIGN", 0); return ASSIGN; }
"<"     { yylval = create_node("LT", 0); return LT; }
"<="    { yylval = create_node("LE", 0); return LE; }
">"     { yylval = create_node("GT", 0); return GT; }
">="    { yylval = create_node("GE", 0); return GE; }
"!="    { yylval = create_node("NE", 0); return NE; }
"=="    { yylval = create_node("EQ", 0); return EQ; }
"+"     { yylval = create_node("PLUS", 0); return PLUS; }
"-"     { yylval = create_node("MINUS", 0); return MINUS; }
"*"     { yylval = create_node("MUL", 0); return MUL; }
"/"     { yylval = create_node("DIV", 0); return DIV; }
"&&"    { yylval = create_node("AND", 0); return AND; }
"||"    { yylval = create_node("OR", 0); return OR; }
"!"     { yylval = create_node("NOT", 0); return NOT; }
"("     { yylval = create_node("LP", 0); return LP; }
")"     { yylval = create_node("RP", 0); return RP; }
"["     { yylval = create_node("LB", 0); return LB; }
"]"     { yylval = create_node("RB", 0); return RB; }
"{"     { yylval = create_node("LC", 0); return LC; }
"}"     { yylval = create_node("RC", 0); return RC; }

"//" {
    char c = yyinput();
    while(c != '\n') {
        c = yyinput();
    }
}

"\n" { yycolno = 1; }
[ \r\t] {}

. { fprintf(tmp_file, "Error type A at Line %d: unknown lexeme %s\n", yylineno, yytext); error_happen = 1; }

%%