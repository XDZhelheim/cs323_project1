%{
    #define EXIT_OK 0
    #define EXIT_FAIL 1

    #define YY_USER_ACTION \
        yylloc.first_line = yylloc.last_line; \
        yylloc.first_column = yylloc.last_column; \
        for (int i = 0; yytext[i] != '\0'; i++) { \
            if(yytext[i] == '\n') { \
                yylloc.last_line++; \
                yylloc.last_column = 1; \
            } \
            else { \
                yylloc.last_column++; \
            } \
        }
%}

letter [a-zA-Z]
letter_ {letter}|_
digit [0-9]
hexdigit [0-9a-fA-F]

%%
(\+?|-)0x{hexdigit}+|(\+?|-){digit}+    { return INT; }
{digit}+\.{digit}+                      { return FLOAT; }
\'([\x20-\x7E]|\\x{hexdigit}{1,2})\'    { return CHAR; }
{letter_}({letter_}|{digit})*           { return ID; }

int|float|char  { return TYPE; }
struct          { return STRUCT; }
if              { return IF; }
else            { return ELSE; }
while           { return WHILE; }
return          { return RETURN; }

"."     { return DOT; }
";"     { return SEMI; }
","     { return COMMA; }
"="     { return ASSIGN; }
"<"     { return LT; }
"<="    { return LE; }
">"     { return GT; }
">="    { return GE; }
"!="    { return NE; }
"=="    { return EQ; }
"+"     { return PLUS; }
"-"     { return MINUS; }
"*"     { return MUL; }
"/"     { return DIV; }
"&&"    { return AND; }
"||"    { return OR; }
"!"     { return NOT; }
"("     { return LP; }
")"     { return RP; }
"["     { return LB; }
"]"     { return RB; }
"{"     { return LC; }
"}"     { return RC; }

[ \n\r\t] {}

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