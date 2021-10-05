%{
    #include "syntax.tab.h"
    #include "TreeNode.hpp"

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
(\+?|-)0x{hexdigit}+|(\+?|-){digit}+    { yylval = create_node("INT", yylloc, DataType::INT, yytext); return INT; }
{digit}+\.{digit}+                      { yylval = create_node("FLOAT", yylloc, DataType::FLOAT, yytext); return FLOAT; }
\'([\x20-\x7E]|\\x{hexdigit}{1,2})\'    { yylval = create_node("CHAR", yylloc, DataType::CHAR, yytext); return CHAR; }
{letter_}({letter_}|{digit})*           { yylval = create_node("ID", yylloc, DataType::ID, yytext); return ID; }

int|float|char  { yylval = create_node("TYPE", yylloc, DataType::TYPE, yytext); return TYPE; }
struct          { yylval = create_node("STRUCT", yylloc; return STRUCT; }
if              { yylval = create_node("IF", yylloc; return IF; }
else            { yylval = create_node("ELSE", yylloc); return ELSE; }
while           { yylval = create_node("WHILE", yylloc); return WHILE; }
return          { yylval = create_node("RETURN", yylloc); return RETURN; }

"."     { yylval = create_node("DOT", yylloc); return DOT; }
";"     { yylval = create_node("SEMI", yylloc); return SEMI; }
","     { yylval = create_node("COMMA", yylloc); return COMMA; }
"="     { yylval = create_node("ASSIGN", yylloc); return ASSIGN; }
"<"     { yylval = create_node("LT", yylloc); return LT; }
"<="    { yylval = create_node("LE", yylloc); return LE; }
">"     { yylval = create_node("GT", yylloc); return GT; }
">="    { yylval = create_node("GE", yylloc); return GE; }
"!="    { yylval = create_node("NE", yylloc); return NE; }
"=="    { yylval = create_node("EQ", yylloc); return EQ; }
"+"     { yylval = create_node("PLUS", yylloc); return PLUS; }
"-"     { yylval = create_node("MINUS", yylloc); return MINUS; }
"*"     { yylval = create_node("MUL", yylloc); return MUL; }
"/"     { yylval = create_node("DIV", yylloc); return DIV; }
"&&"    { yylval = create_node("AND", yylloc); return AND; }
"||"    { yylval = create_node("OR", yylloc); return OR; }
"!"     { yylval = create_node("NOT", yylloc); return NOT; }
"("     { yylval = create_node("LP", yylloc); return LP; }
")"     { yylval = create_node("RP", yylloc); return RP; }
"["     { yylval = create_node("LB", yylloc); return LB; }
"]"     { yylval = create_node("RB", yylloc); return RB; }
"{"     { yylval = create_node("LC", yylloc); return LC; }
"}"     { yylval = create_node("RC", yylloc); return RC; }

"//" {
    char c = yyinput();
    while(c != '\n') {
        c = yyinput();
    }
}

"\n" { yycolumn = 1; }
[ \r\t] {}

. { fprintf(stderr, "Mysterious lexeme: %s\n", yytext); }

%%
int main(int argc, char **argv){
    char *file_path;
    if(argc < 2){
        fprintf(stderr, "Usage: %s <file_path>\n", argv[0]);
        return EXIT_FAIL;
    } else if(argc == 2){
        file_path = argv[1];
        if(!(yyin = fopen(file_path, "r"))){
            perror(argv[1]);
            return EXIT_FAIL;
        }
        yylex();
        return EXIT_OK;
    } else{
        fputs("Too many arguments! Expected: 2.\n", stderr);
        return EXIT_FAIL;
    }
}