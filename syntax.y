%{
    #include "lex.yy.c"
    #define YYSTYPE TreeNode *
    extern "C" {
        #include "TreeNode.hpp"
    }
    void yyerror(const char*);
    struct TreeNode *root;
%}

%initial-action
{
  @$.first_line = 1;
  @$.first_column = 1;
  @$.last_line = 1;
  @$.last_column = 1;
};

%token INT FLOAT CHAR ID
%token TYPE
%token STRUCT
%token IF ELSE
%token WHILE
%token RETURN
%token DOT SEMI COMMA
%token ASSIGN
%token LT LE GT GE NE EQ
%token PLUS MINUS MUL DIV
%token AND OR NOT
%token LP RP LB RB LC RC

%right ASSIGN
%left OR
%left AND
%left GT GE LT LE EQ NE
%left PLUS MINUS
%left MUL DIV
%right NOT
%left LC RC LB RB DOT

%%
Program: 
      ExtDefList                            { $$ = create_child_node("Program", @$, {$1}); root = $$; }
    ;
ExtDefList: 
      ExtDef ExtDefList                     { $$ = create_child_node("ExtDefList", @$, {$1, $2}); }
    | %empty                                { $$ = create_child_node("ExtDefList", @$, {}); }
    ;   
ExtDef: 
      Specifier ExtDecList SEMI             { $$ = create_child_node("ExtDef", @$, {$1, $2, $3}); }
    | Specifier SEMI                        { $$ = create_child_node("ExtDef", @$, {$1, $2}); }
    | Specifier FunDec CompSt               { $$ = create_child_node("ExtDef", @$, {$1, $2, $3}); }
    ;
ExtDecList: 
      VarDec                                { $$ = create_child_node("ExtDecList", @$, {$1}); }
    | VarDec COMMA ExtDecList               { $$ = create_child_node("ExtDecList", @$, {$1, $2, $3}); }
    ;

Specifier: 
      TYPE                                  { $$ = create_child_node("Specifier", @$, {$1}); }
    | StructSpecifier                       { $$ = create_child_node("Specifier", @$, {$1}); }
    ;
StructSpecifier: 
      STRUCT ID LC DefList RC               { $$ = create_child_node("StructSpecifier", @$, {$1, $2, $3, $4, $5}); }
    | STRUCT ID                             { $$ = create_child_node("StructSpecifier", @$, {$1, $2}); }
    ;

VarDec:
      ID                                    { $$ = create_child_node("VarDec", @$, {$1}); }
    | VarDec LB INT RB                      { $$ = create_child_node("VarDec", @$, {$1, $2, $3, $4}); }
    ;
FunDec: 
      ID LP VarList RP                      { $$ = create_child_node("FunDec", @$, {$1, $2, $3, $4}); }
    | ID LP RP                              { $$ = create_child_node("FunDec", @$, {$1, $2, $3}); }
    ;
VarList: 
      ParamDec COMMA VarList                { $$ = create_child_node("VarList", @$, {$1, $2, $3}); }
    | ParamDec                              { $$ = create_child_node("VarList", @$, {$1}); }
    ;
ParamDec: 
      Specifier VarDec                      { $$ = create_child_node("ParamDec", @$, {$1, $2}); }
    ;

CompSt: 
      LC DefList StmtList RC                { $$ = create_child_node("CompSt", @$, {$1, $2, $3, $4}); }
    ;
StmtList: 
      Stmt StmtList                         { $$ = create_child_node("StmtList", @$, {$1, $2}); }
    | %empty                                { $$ = create_child_node("StmtList", @$, {}); }
    ;
Stmt: 
      Exp SEMI                              { $$ = create_child_node("Stmt", @$, {$1, $2}); }
    | CompSt                                { $$ = create_child_node("Stmt", @$, {$1}); }
    | RETURN Exp SEMI                       { $$ = create_child_node("Stmt", @$, {$1, $2, $3}); }
    | IF LP Exp RP Stmt                     { $$ = create_child_node("Stmt", @$, {$1, $2, $3, $4, $5}); }
    | IF LP Exp RP Stmt ELSE Stmt           { $$ = create_child_node("Stmt", @$, {$1, $2, $3, $4, $5, $6, $7}); }
    | WHILE LP Exp RP Stmt                  { $$ = create_child_node("Stmt", @$, {$1, $2, $3, $4, $5}); }
    ;
DefList: 
      Def DefList                           { $$ = create_child_node("DefList", @$, {$1, $2}); }
    | %empty                                { $$ = create_child_node("DefList", @$, {}); }
    ;
Def: 
      Specifier DecList SEMI                { $$ = create_child_node("Def", @$, {$1, $2, $3}); }
    ;
DecList: 
      Dec                                   { $$ = create_child_node("DecList", @$, {$1}); }
    | Dec COMMA DecList                     { $$ = create_child_node("DecList", @$, {$1, $2, $3}); }
    ;
Dec: 
      VarDec                                { $$ = create_child_node("Dec", @$, {$1}); }
    | VarDec ASSIGN Exp                     { $$ = create_child_node("Dec", @$, {$1, $2, $3}); }
    ;

Exp: 
      Exp ASSIGN Exp                        { $$ = create_child_node("Exp", @$, {$1, $2, $3}); }
    | Exp AND Exp                           { $$ = create_child_node("Exp", @$, {$1, $2, $3}); }
    | Exp OR Exp                            { $$ = create_child_node("Exp", @$, {$1, $2, $3}); }
    | Exp LT Exp                            { $$ = create_child_node("Exp", @$, {$1, $2, $3}); }
    | Exp LE Exp                            { $$ = create_child_node("Exp", @$, {$1, $2, $3}); }
    | Exp GT Exp                            { $$ = create_child_node("Exp", @$, {$1, $2, $3}); }
    | Exp GE Exp                            { $$ = create_child_node("Exp", @$, {$1, $2, $3}); }
    | Exp NE Exp                            { $$ = create_child_node("Exp", @$, {$1, $2, $3}); }
    | Exp EQ Exp                            { $$ = create_child_node("Exp", @$, {$1, $2, $3}); }
    | Exp PLUS Exp                          { $$ = create_child_node("Exp", @$, {$1, $2, $3}); }
    | Exp MINUS Exp                         { $$ = create_child_node("Exp", @$, {$1, $2, $3}); }
    | Exp MUL Exp                           { $$ = create_child_node("Exp", @$, {$1, $2, $3}); }
    | Exp DIV Exp                           { $$ = create_child_node("Exp", @$, {$1, $2, $3}); }
    | LP Exp RP                             { $$ = create_child_node("Exp", @$, {$1, $2, $3}); }
    | MINUS Exp                             { $$ = create_child_node("Exp", @$, {$1, $2}); }
    | NOT Exp                               { $$ = create_child_node("Exp", @$, {$1, $2}); }
    | ID LP Args RP                         { $$ = create_child_node("Exp", @$, {$1, $2, $3, $4}); }
    | ID LP RP                              { $$ = create_child_node("Exp", @$, {$1, $2, $3}); }
    | Exp LB Exp RB                         { $$ = create_child_node("Exp", @$, {$1, $2, $3, $4}); }
    | Exp DOT ID                            { $$ = create_child_node("Exp", @$, {$1, $2, $3}); }
    | ID                                    { $$ = create_child_node("Exp", @$, {$1}); }
    | INT                                   { $$ = create_child_node("Exp", @$, {$1}); }
    | FLOAT                                 { $$ = create_child_node("Exp", @$, {$1}); }
    | CHAR                                  { $$ = create_child_node("Exp", @$, {$1}); }
    ;
Args: 
      Exp COMMA Args                        { $$ = create_child_node("Args", @$, {$1, $2, $3}); }
    | Exp                                   { $$ = create_child_node("Args", @$, {$1}); }
    ;

%%
void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
}

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
        yyparse();
        PrintTreeNode(root, file_path);
        return EXIT_OK;
    } else{
        fputs("Too many arguments! Expected: 2.\n", stderr);
        return EXIT_FAIL;
    }
}