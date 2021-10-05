%{
    #include "lex.yy.c"
    extern "C" {
        #include "TreeNode.hpp"
    }
    void yyerror(const char*);
    struct TreeNode *root;
%}
%define api.value.type {struct TreeNode *}

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
Program: ExtDefList;
ExtDefList: ExtDef ExtDefList
    | %empty;
ExtDef: Specifier ExtDecList SEMI
    | Specifier SEMI
    | Specifier FunDec CompSt;
ExtDecList: VarDec
    | VarDec COMMA ExtDecList;

Specifier: TYPE
    | StructSpecifier;
StructSpecifier: STRUCT ID LC DefList RC
    | STRUCT ID;

VarDec: ID
    | VarDec LB INT RB;
FunDec: ID LP VarList RP
    | ID LP RP;
VarList: ParamDec COMMA VarList
    | ParamDec;
ParamDec: Specifier VarDec;

CompSt: LC DefList StmtList RC;
StmtList: Stmt StmtList
    | %empty;
Stmt: Exp SEMI
    | CompSt
    | RETURN Exp SEMI
    | IF LP Exp RP Stmt
    | IF LP Exp RP Stmt ELSE Stmt
    | WHILE LP Exp RP Stmt;

DefList: Def DefList
    | %empty;
Def: Specifier DecList SEMI;
DecList: Dec
    | Dec COMMA DecList;
Dec: VarDec
    | VarDec ASSIGN Exp;

Exp: Exp ASSIGN Exp
    | Exp AND Exp
    | Exp OR Exp
    | Exp LT Exp
    | Exp LE Exp
    | Exp GT Exp
    | Exp GE Exp
    | Exp NE Exp
    | Exp EQ Exp
    | Exp PLUS Exp
    | Exp MINUS Exp
    | Exp MUL Exp
    | Exp DIV Exp
    | LP Exp RP
    | MINUS Exp
    | NOT Exp
    | ID LP Args RP
    | ID LP RP
    | Exp LB Exp RB
    | Exp DOT ID
    | ID
    | INT
    | FLOAT
    | CHAR;
Args: Exp COMMA Args
    | Exp;

%%
void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
}
int main() {
    yyparse();
}