/**
Author: Chanpech Hoeng
Course: CS4121 R01
Last Update: 10/13/2023
*/
/*******************************************************/
/*                     Cminus Parser                   */
/*                                                     */
/*******************************************************/

/*********************DEFINITIONS***********************/
%{
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <string.h>
#include <util/general.h>
#include <util/symtab.h>
#include <util/symtab_stack.h>
#include <util/dlink.h>
#include <util/string_utils.h>

#define SYMTABLE_SIZE 100
#define SYMTAB_VALUE_FIELD "value"
#define SYMTAB_NAME_FIELD "name"
#define SYMTAB_INDEX_FIELD "index"
/*********************EXTERNAL DECLARATIONS***********************/

EXTERN(void,Cminus_error,(const char*));

EXTERN(int,Cminus_lex,(void));

char *fileName;

extern int Cminus_lineno;

extern FILE *Cminus_in;

//Extern symbol table 
extern SymTable *symtab;
//This will be initialized in the initialize() function.
%}

%name-prefix="Cminus_"
%defines

%start Program

%token AND
%token ELSE
%token EXIT
%token FOR
%token IF 		
%token INTEGER 
%token NOT 		
%token OR 		
%token READ
%token WHILE
%token WRITE
%token LBRACE
%token RBRACE
%token LE
%token LT
%token GE
%token GT
%token EQ
%token NE
%token ASSIGN
%token COMMA
%token SEMICOLON
%token LBRACKET
%token RBRACKET
%token LPAREN
%token RPAREN
%token PLUS
%token TIMES
%token IDENTIFIER
%token DIVIDE
%token RETURN
%token STRING	
%token INTCON
%token MINUS

%left OR
%left AND
%left NOT
%left LT LE GT GE NE EQ
%left PLUS MINUS
%left TIMES DIVDE

/***********************PRODUCTIONS****************************/
%%
//For final submission, I have commented out all of the production printf()
//The printf() should only be use in write();
Program		: Procedures 
		{
			//printf("<Program> -> <Procedures>\n");
		}
	  	| DeclList Procedures
		{
			//printf("<Program> -> <DeclList> <Procedures>\n");
		}
          ;

Procedures 	: ProcedureDecl Procedures
		{
			//printf("<Procedures> -> <ProcedureDecl> <Procedures>\n");
		}
	   	|
		{
			//printf("<Procedures> -> epsilon\n");
		}
	   	;

ProcedureDecl : ProcedureHead ProcedureBody
		{
			//printf("<ProcedureDecl> -> <ProcedureHead> <ProcedureBody>\n");
		}
              ;

ProcedureHead : FunctionDecl DeclList 
		{
			//printf("<ProcedureHead> -> <FunctionDecl> <DeclList>\n");
		}
	      | FunctionDecl
		{
			//printf("<ProcedureHead> -> <FunctionDecl>\n");
		}
              ;

FunctionDecl :  Type IDENTIFIER LPAREN RPAREN LBRACE 
		{
			//printf("<FunctionDecl> ->  <Type> <IDENTIFIER> <LP> <RP> <LBR>\n"); 
		}
	      	;

ProcedureBody : StatementList RBRACE
		{
			//printf("<ProcedureBody> -> <StatementList> <RBR>\n");
		}
	      ;


DeclList 	: Type IdentifierList  SEMICOLON 
		{
			//printf("<DeclList> -> <Type> <IdentifierList> <SC>\n");
		}		
	   	| DeclList Type IdentifierList SEMICOLON
	 	{
			//printf("<DeclList> -> <DeclList> <Type> <IdentifierList> <SC>\n");
	 	}
          	;


IdentifierList 	: VarDecl  
		{
			//printf("<IdentifierList> -> <VarDecl>\n");
		}
						
                | IdentifierList COMMA VarDecl
		{
			//printf("<IdentifierList> -> <IdentifierList> <CM> <VarDecl>\n");
		}
                ;

VarDecl 	: IDENTIFIER
		{ 
			//printf("<VarDecl> -> <IDENTIFIER\n");
		}
		| IDENTIFIER LBRACKET INTCON RBRACKET
                {
			//printf("<VarDecl> -> <IDENTIFIER> <LBK> <INTCON> <RBK>\n");
		}
		;

Type     	: INTEGER 
		{ 
			//printf("<Type> -> <INTEGER>\n");
		}
                ;

Statement 	: Assignment
		{ 
			//printf("<Statement> -> <Assignment>\n");
		}
                | IfStatement
		{ 
			//printf("<Statement> -> <IfStatement>\n");
		}
		| WhileStatement
		{ 
			//printf("<Statement> -> <WhileStatement>\n");
		}
                | IOStatement 
		{ 
			//printf("<Statement> -> <IOStatement>\n");
		}
		| ReturnStatement
		{ 
			//printf("<Statement> -> <ReturnStatement>\n");
		}
		| ExitStatement	
		{ 
			//printf("<Statement> -> <ExitStatement>\n");
		}
		| CompoundStatement
		{ 
			//printf("<Statement> -> <CompoundStatement>\n");
		}
                ;

Assignment      : Variable ASSIGN Expr SEMICOLON
		{
			//printf("<Assignment> -> <Variable> <ASSIGN> <Expr> <SC>\n");
			//$1 == index, $3 is the evaluated result of the expression
			//Given the about information, we can just place it in the symbol table.  
			SymPutFieldByIndex(symtab, $1, SYMTAB_VALUE_FIELD, (Generic)$3);
		
		}
                ;
				
IfStatement	: IF TestAndThen ELSE CompoundStatement
		{
			//printf("<IfStatement> -> <IF> <TestAndThen> <ELSE> <CompoundStatement>\n");
		}
		| IF TestAndThen
		{
			//printf("<IfStatement> -> <IF> <TestAndThen>\n");
		}
		;
		
				
TestAndThen	: Test CompoundStatement
		{
			//printf("<TestAndThen> -> <Test> <CompoundStatement>\n");
		}
		;
				
Test		: LPAREN Expr RPAREN
		{
			//printf("<Test> -> <LP> <Expr> <RP>\n");
			$$ = $2;
		}
		;
	

WhileStatement  : WhileToken WhileExpr Statement
		{
			//printf("<WhileStatement> -> <WhileToken> <WhileExpr> <Statement>\n");
		}
                ;
                
WhileExpr	: LPAREN Expr RPAREN
		{
			//printf("<WhileExpr> -> <LP> <Expr> <RP>\n");
		}
		;
				
WhileToken	: WHILE
		{
			//printf("<WhileToken> -> <WHILE>\n");
		}
		;


IOStatement     : READ LPAREN Variable RPAREN SEMICOLON
		{
			//printf("<IOStatement> -> <READ> <LP> <Variable> <RP> <SC>\n");
			int value;
			scanf("%d", &value);
			SymPutFieldByIndex( symtab, $3, SYMTAB_VALUE_FIELD, value);
			//This scanner will only works with integer value. Anything else will cause the program to fail.
			//After integer is read in the value will be placed within the "value" field.
		}
                | WRITE LPAREN Expr RPAREN SEMICOLON
		{
			//printf("<IOStatement> -> <WRITE> <LP> <Expr> <RP> <SC>\n");
			//$3 should be an already evaluated expression. So jus print it.
			printf("%d\n", $3);
		}
                | WRITE LPAREN StringConstant RPAREN SEMICOLON         
		{
			//printf("<IOStatement> -> <WRITE> <LP> <StringConstant> <RP> <SC>\n");
			
			//$3 is an index
			//Retrieve the entry of the STRING from the symtable by passing $3: index and field "name"
			Generic stringConst = SymGetFieldByIndex(symtab, $3, SYMTAB_NAME_FIELD);
			printf("%s\n", stringConst);
		}
                ;

ReturnStatement : RETURN Expr SEMICOLON
		{
			//printf("<ReturnStatement> -> <RETURN> <Expr> <SC>\n");
			return $2;
		}
                ;

ExitStatement 	: EXIT SEMICOLON
		{
			//printf("<ExitStatement> -> <EXIT> <SC>\n");
			exit(0);
		}
		;

CompoundStatement : LBRACE StatementList RBRACE
		{
			//printf("<CompoundStatement> -> <LBR> <StatementList> <RBR>\n");
		}
                ;

StatementList   : Statement
		{		
			//printf("<StatementList> -> <Statement>\n");
			//$$ = $1;
		}
                | StatementList Statement
		{		
			//printf("<StatementList> -> <StatementList> <Statement>\n");

		}
                ;

Expr            : SimpleExpr
		{
			//printf("<Expr> -> <SimpleExpr>\n");
		}
                | Expr OR SimpleExpr 
		{
			//printf("<Expr> -> <Expr> <OR> <SimpleExpr> \n");
			$$ = ($1 || $3);
		}
                | Expr AND SimpleExpr 
		{
			//printf("<Expr> -> <Expr> <AND> <SimpleExpr> \n");
			$$ = ($1 && $3);
		}
                | NOT SimpleExpr 
		{
			//printf("<Expr> -> <NOT> <SimpleExpr> \n");
			$$ = (!$2);
		}
                ;

SimpleExpr	: AddExpr
		{
			//printf("<SimpleExpr> -> <AddExpr>\n");

		}
                | SimpleExpr EQ AddExpr
		{
			//printf("<SimpleExpr> -> <SimpleExpr> <EQ> <AddExpr> \n");
			bool eq = ($1 == $3);
			$$ = eq;
		}
                | SimpleExpr NE AddExpr
		{
			//printf("<SimpleExpr> -> <SimpleExpr> <NE> <AddExpr> \n");
			bool ne = ($1 != $3);
			$$ = ne;
		}
                | SimpleExpr LE AddExpr
		{
			//printf("<SimpleExpr> -> <SimpleExpr> <LE> <AddExpr> \n");
			bool le = ($1 <= $3);
			$$ = le;
		}
                | SimpleExpr LT AddExpr
		{
			//printf("<SimpleExpr> -> <SimpleExpr> <LT> <AddExpr> \n");
			bool lt = ($1 < $3);
			$$ = lt;
		}
                | SimpleExpr GE AddExpr
		{
			//printf("<SimpleExpr> -> <SimpleExpr> <GE> <AddExpr> \n");
			bool ge = ($1 >= $3);
			$$ = ge;
		}
                | SimpleExpr GT AddExpr
		{
			//printf("<SimpleExpr> -> <SimpleExpr> <GT> <AddExpr> \n");
			bool gt = ($1 > $3);
			$$ = gt;
		}
                ;

AddExpr		:  MulExpr            
		{
			//printf("<AddExpr> -> <MulExpr>\n");
			//$$ = $1;
		}
                |  AddExpr PLUS MulExpr
		{
			//printf("<AddExpr> -> <AddExpr> <PLUS> <MulExpr> \n");
			$$ = $1 + $3;
		}
                |  AddExpr MINUS MulExpr
		{
			//printf("<AddExpr> -> <AddExpr> <MINUS> <MulExpr> \n");
			$$ = $1 - $3;
		}
                ;

MulExpr		:  Factor
		{
			//printf("<MulExpr> -> <Factor>\n");
			//$$ = $1;
		}
                |  MulExpr TIMES Factor
		{
			//printf("<MulExpr> -> <MulExpr> <TIMES> <Factor> \n");
			$$ = $1 * $3;
		}
                |  MulExpr DIVIDE Factor
		{
			//printf("<MulExpr> -> <MulExpr> <DIVIDE> <Factor> \n");
			$$ = $1 / $3;
		}		
                ;
				
Factor          : Variable
		{ 
			//printf("<Factor> -> <Variable>\n");
			Generic value = SymGetFieldByIndex(symtab, $1,SYMTAB_VALUE_FIELD);
			$$ = (int) value;
			//Find the value of the Varaible within the symbol table. 
			//$1 is the index of the IDENTIFIER
		}
                | Constant
		{ 
			//printf("<Factor> -> <Constant>\n");
			$$ = $1;
		}
                | IDENTIFIER LPAREN RPAREN
       		{	
			//printf("<Factor> -> <IDENTIFIER> <LP> <RP>\n");
		}
         	| LPAREN Expr RPAREN
		{
			//printf("<Factor> -> <LP> <Expr> <RP>\n");
			$$ = ($2);
		}
                ;  

Variable        : IDENTIFIER
		{
			//printf("<Variable> -> <IDENTIFIER>\n");
			$$ = $1;
			//This is passing in the Cminus_lval of the IDENTIFIER.
			//Cminus_lval is the index of the IDENTIFIER within the symbol table.
		
		}
                | IDENTIFIER LBRACKET Expr RBRACKET    
               	{
			//printf("<Variable> -> <IDENTIFIER> <LBK> <Expr> <RBK>\n");
               	}
                ;			       

StringConstant 	: STRING
		{ 
			//printf("<StringConstant> -> <STRING>\n");
			$$ = $1;;
			//This is passing in the Cminus_lval of the STRING constant.
			//Cminus_lval is the index of the string within the symbol table.
		}
                ;

Constant        : INTCON
		{ 
			//printf("<Constant> -> <INTCON>\n");
			$$ = $1; 
			//This is passing in the Cminus_lval of INTCON
		}
                ;

%%


/********************C ROUTINES *********************************/

void Cminus_error(const char *s)
{
  fprintf(stderr,"%s: line %d: %s\n",fileName,Cminus_lineno,s);
}

int Cminus_wrap() {
	return 1;
}

SymTable *symtab; 
static void initialize(char* inputFileName) {

	Cminus_in = fopen(inputFileName,"r");
        if (Cminus_in == NULL) {
          fprintf(stderr,"Error: Could not open file %s\n",inputFileName);
          exit(-1);
        }

	char* dotChar = rindex(inputFileName,'.');
	int endIndex = strlen(inputFileName) - strlen(dotChar);
	char *outputFileName = nssave(2,substr(inputFileName,0,endIndex),".s");
	stdout = freopen(outputFileName,"w",stdout);
        if (stdout == NULL) {
          fprintf(stderr,"Error: Could not open file %s\n",outputFileName);
          exit(-1);
        }

	//Modification: 
	//Add symbol table initailization and field initialization.
	symtab = SymInit(SYMTABLE_SIZE);
	SymInitField(symtab, SYMTAB_VALUE_FIELD, (Generic)-1,NULL);

}

static void finalize() {

    fclose(Cminus_in);
    fclose(stdout);
    

}

int main(int argc, char** argv)

{	
	fileName = argv[1];
	initialize(fileName);
	
        Cminus_parse();
  
  	finalize();
  
  	return 0;
}
/******************END OF C ROUTINES**********************/
