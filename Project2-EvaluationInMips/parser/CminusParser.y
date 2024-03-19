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

//Added Header//
#include <codegen/codegen.h>
//End//

#define SYMTABLE_SIZE 100
#define SYMTAB_VALUE_FIELD     "value"
#define SYMTAB_REGISTER_INDEX_FIELD "reg_index"
#define SYMTAB_OFFSET_FIELD "offset"
#define SYMTAB_NAME_FIELD "offset"

/*********************EXTERNAL DECLARATIONS***********************/

EXTERN(void,Cminus_error,(const char*));

EXTERN(int,Cminus_lex,(void));

char *fileName;

SymTable symtab;

extern int Cminus_lineno;

extern FILE *Cminus_in;
//Added global
DLinkList *instList;
DLinkList *dataList;

SymtabStack symtabStack;
SymTable symtabRegister;
static int stringCounter;
static int globalCounter;
static int byteSize;
static int globalVarCounter;
static int equalCreated;
static int nequalMade;
static int lessThanEqual;
static int lessThan;
static int greaterThan;
static int greaterThanEq;
//End 
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
   Program		: Procedures 
		{
			//printf("<Program> -> <Procedures>\n");
			//printf("\tli $v0, 10\nSyscall");
			//printf("\t.data\n.newl:.asciiz \"\\n\" \n");

		}
	  	| DeclList Procedures
		{
			//printf("<Program> -> <DeclList> <Procedures>\n");
			// printf("Global Variable here\n");
			// //assignGlobalVariable();
			
			// printf("\tli $v0, 10\n");
			// printf("\tSyscall\n");

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
			//Generate instruction to terminate the program
			//Generate instructions to make the system call to end the program.
			procedureTerminate(instList, symtab);
		}
              ;

ProcedureHead : FunctionDecl DeclList 
		{
			//printf("<ProcedureHead> -> <FunctionDecl> <DeclList>\n");
			//Generate instruction for the function prologue.
			//Generate the assembly directive for the function.
			funcDeclList(symtab, $1, $2);
		}
	      | FunctionDecl
		{
			//printf("<ProcedureHead> -> <FunctionDecl>\n");
		}
              ;

FunctionDecl :  Type IDENTIFIER LPAREN RPAREN LBRACE 
		{
			//printf("<FunctionDecl> ->  <Type> <IDENTIFIER> <LP> <RP> <LBR>\n"); 
			// printf("\t.text\n\t.globl main \nmain: nop\n");
			
			//RecordID of function name
			recordID(dataList,$2);
			//This will be used to generates directives to the function.
			//The ID will be used to generate the directive to the function.
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
			printf("<DeclList> -> <DeclList> <Type> <IdentifierList> <SC>\n");
	 		//Tasks: Major task in the action code is how to set the offset for ID
			//We should utilize the idnex in the symtab_stack.
			// Note: all IDs are global variables in Project 2
			
		}
          	;


IdentifierList 	: VarDecl  
		{
			//printf("<IdentifierList> -> <VarDecl>\n");
			//Handle global here
			//Allocate the memory space from global area for the global variables.
			//we shouldn't need any more than 64K of space in the static data 
			
			// Generic idConst = SymGetFieldByIndex(symtab, $1, SYM_NAME_FIELD);
			// SymPutFieldByIndex(symtab, $1, SYMTAB_OFFSET_FIELD, (Generic)byteSize);
			// //printf("Vardecl: %d %s idConst\n", $1, idConst);
			
			// //printf("\t.global_var%d: .space %d\n", globalCounter, byteSize);
			// //printf("OFFSET: %d\n", offset);
			// storeInGlobalDataSection(dataList, idConst, byteSize, idConst);
			// byteSize+=4;
			// globalVarCounter++;
		}
						
                | IdentifierList COMMA VarDecl
		{
			//printf("<IdentifierList> -> <IdentifierList> <CM> <VarDecl>\n");
			
		}
                ;

VarDecl 	: IDENTIFIER
		{ 
			//printf("<VarDecl> -> <IDENTIFIER\n");
			
			Generic idConst = SymGetFieldByIndex(symtab, $1, SYM_NAME_FIELD);
			SymPutFieldByIndex(symtab, $1, SYMTAB_OFFSET_FIELD, (Generic)byteSize);
			storeInGlobalDataSection(dataList, idConst, byteSize, idConst);
			byteSize+=4;
			globalVarCounter++;
			// printf("sw $fp, ($sp)\n");
			// printf("move $fp, $sp\n");
			// printf("sub $sp, $sp, 12\n");
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
			genAssignVar(instList, symtab, $1, $3);
			setValue($1, $3);
			//printf("<Assignment> -> <Variable> <ASSIGN> <Expr> <SC>\n");
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
		//    int t;
		//    scanf("%d", &t);
        //            setValue($3, t); 
		    // printf("<IOStatement> -> <READ> <LP> <Variable> <RP> <SC>\n");
			
			int t = $3;
			genReadInt(instList, symtab, $3);
			printf("T: %d", t);
			setValue($3, t); 
			//printf("li $v0, 5\n");
			//printf("syscall\n");

		}
                | WRITE LPAREN Expr RPAREN SEMICOLON
		{
			//printf("%d\n", $3);
			//printf("<IOStatement> -> <WRITE> <LP> <Expr> <RP> <SC>\n");
			// printf("\tli $a0, %d\n", $3);
			// printf("\tli $v0, 1\n");
			// printf("\tsyscall\n");
			//printf("$3 is %d\n", $3);
			storeWriteExpr(instList, symtab,$3);
		
		}
                | WRITE LPAREN StringConstant RPAREN SEMICOLON         
		{
		  	//printf("%s\n", (char *)SymGetFieldByIndex(symtab,$3, SYM_NAME_FIELD));
			//printf("<IOStatement> -> <WRITE> <LP> <StringConstant> <RP> <SC>\n");
			Generic stringConst = SymGetFieldByIndex(symtab,$3, SYM_NAME_FIELD);
			//int offset = findOffSet();
			storeInStringDataSection(dataList, instList, stringConst, stringConst, stringCounter);
			stringCounter++;
		}
                ;

ReturnStatement : RETURN Expr SEMICOLON
		{
			//printf("<ReturnStatement> -> <RETURN> <Expr> <SC>\n");
		}
                ;

ExitStatement 	: EXIT SEMICOLON
		{
			//printf("<ExitStatement> -> <EXIT> <SC>\n");
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
		}
                | StatementList Statement
		{		
			//printf("<StatementList> -> <StatementList> <Statement>\n");
		}
                ;

Expr            : SimpleExpr
		{
			$$ = $1;
			//printf("<Expr> -> <SimpleExpr>\n");
		}
                | Expr OR SimpleExpr 
		{
		       // $$ = $1 | $3;
			//printf("<Expr> -> <Expr> <OR> <SimpleExpr> \n");
			$$ = genORExpr(instList, symtab, $1, $3);
		}
                | Expr AND SimpleExpr 
		{
			//$$ = $1 & $3;
			//printf("<Expr> -> <Expr> <AND> <SimpleExpr> \n");
			$$ = genANDExpr(instList, symtab, $1, $3);
		}
                | NOT SimpleExpr 
		{
			//$$ = $2 ^ 1;
			//printf("<Expr> -> <NOT> <SimpleExpr> \n");
			$$ = genNotExpr(instList, symtab, $2);
		}
                ;

SimpleExpr	: AddExpr
		{
			$$ = $1;
			//printf("<SimpleExpr> -> <AddExpr>\n");
		}
                | SimpleExpr EQ AddExpr
		{
		        //$$ = ($1 == $3);

				$$ = genEqExpr(instList, symtab, $1, $3, equalCreated);
			//printf("<SimpleExpr> -> <SimpleExpr> <EQ> <AddExpr> \n");
				equalCreated++;;
		}
                | SimpleExpr NE AddExpr
		{
		        //$$ = ($1 != $3);
			//printf("<SimpleExpr> -> <SimpleExpr> <NE> <AddExpr> \n");
			$$ = genNEExpr(instList, symtab, $1, $3, nequalMade);
			nequalMade++;
		
		}
                | SimpleExpr LE AddExpr
		{
		        //$$ = ($1 <= $3);
			//printf("<SimpleExpr> -> <SimpleExpr> <LE> <AddExpr> \n");
						$$ = genLEExpr(instList, symtab, $1, $3, lessThanEqual);
						lessThanEqual++;
		}
                | SimpleExpr LT AddExpr
		{
		        //$$ = ($1 < $3);
			//printf("<SimpleExpr> -> <SimpleExpr> <LT> <AddExpr> \n");
				$$ = genLTExpr(instList, symtab, $1, $3, lessThan);
				lessThan++;
		}
                | SimpleExpr GE AddExpr
		{
		        //$$ = ($1 >= $3);
			//printf("<SimpleExpr> -> <SimpleExpr> <GE> <AddExpr> \n");
				$$ = genGEExpr(instList, symtab, $1, $3, greaterThanEq);
				greaterThanEq++;
		}
                | SimpleExpr GT AddExpr
		{
			//printf("<SimpleExpr> -> <SimpleExpr> <GT> <AddExpr> \n");
		    //    $$ = ($1 > $3);
			$$ = genGTExpr(instList, symtab, $1, $3, greaterThan);
			greaterThan++;
		}
                ;

AddExpr		:  MulExpr            
		{
			$$ = $1;
			//printf("<AddExpr> -> <MulExpr>\n");
		}
                |  AddExpr PLUS MulExpr
		{
			//$$ = $1 + $3;

			//int regIndex = getFreeIntegerRegisterIndex(symtab);
			
			
			$$ = genPlusExpr(instList, symtab, $1, $3);
			//printf("<AddExpr> -> <AddExpr> <PLUS> <MulExpr> \n");
			
		}
                |  AddExpr MINUS MulExpr
		{

			/**$$ = $1 - $3;*/
			$$ = genMinusExpr(instList, symtab, $1, $3);
			//printf("<AddExpr> -> <AddExpr> <MINUS> <MulExpr> \n");
		}
                ;

MulExpr		:  Factor
		{
			$$ = $1;
			//printf("<MulExpr> -> <Factor>\n");
		}
                |  MulExpr TIMES Factor
		{
			//$$ = $1 * $3;
			//printf("<MulExpr> -> <MulExpr> <TIMES> <Factor> \n");
			$$ = genTimesExpr(instList, symtab, $1, $3);
		}
                |  MulExpr DIVIDE Factor
		{
			$$ = $1 / $3;
			//printf("<MulExpr> -> <MulExpr> <DIVIDE> <Factor> \n");
			$$ = genDivideExpr(instList, symtab, $1, $3);
		}		
                ;
				
Factor          : Variable
		{ 
			Generic stringConst = SymGetFieldByIndex(symtab, $1, SYM_NAME_FIELD); 
			//printf("$1 IS %d\n",$1);
			
			$$ = accessGlobalVar(dataList, instList, symtab, $1);
			//printf("<Factor> -> <Variable>\n");
			
		}
                | Constant
		{ 
			$$ = $1;
			//printf("<Factor> -> <Constant>\n");
		}
                | IDENTIFIER LPAREN RPAREN
       		{	
			//printf("<Factor> -> <IDENTIFIER> <LP> <RP>\n");
		}
         	| LPAREN Expr RPAREN
		{
			$$ = $2;
			//printf("<Factor> -> <LP> <Expr> <RP>\n");
		}
                ;  

Variable        : IDENTIFIER
		{
			$$ = $1;
			//printf("<Variable> -> <IDENTIFIER>\n");
			
			 
		}
                | IDENTIFIER LBRACKET Expr RBRACKET    
               	{
			//printf("<Variable> -> <IDENTIFIER> <LBK> <Expr> <RBK>\n");
               	}
                ;			       

StringConstant 	: STRING
		{ 
		       $$ = $1;
			//printf("<StringConstant> -> <STRING>\n");
			
		}
                ;

Constant        : INTCON
		{ 

			$$ = genINTCon(instList, symtab, $1);
			//$$ = $1;
			//printf("<Constant> -> <INTCON>\n");
			
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

	symtab = SymInit(SYMTABLE_SIZE);
	SymInitField(symtab,SYMTAB_VALUE_FIELD,(Generic)-1,NULL);
	SymInitField(symtab,SYMTAB_REGISTER_INDEX_FIELD,(Generic)-1,NULL);
	SymInitField(symtab,SYMTAB_OFFSET_FIELD,(Generic)-1,NULL);
	
	//symtabRegister = SymInit(SYMTABLE_SIZE);
	//SymInitField(symtabRegister,SYMTAB_REGISTER_INDEX_FIELD,(Generic)-1,NULL);

	//Added Below init
	instList = dlinkListAlloc((Generic)-1);
	dataList = dlinkListAlloc((Generic)-1);
	
	initRegisters();
	symtabStackInit();
	stringCounter = 0;
	globalCounter = 0;
	byteSize = 0;
	globalVarCounter = 0;
	equalCreated = 1;
	nequalMade = 1;
	lessThanEqual = 1;
	lessThan = 1;
	greaterThan = 1;
	greaterThanEq = 1;
}

static void finalize() {

    SymKillField(symtab,SYMTAB_VALUE_FIELD);
    SymKill(symtab);
    fclose(Cminus_in);
    fclose(stdout);

}

int main(int argc, char** argv)

{	
	fileName = argv[1];
	initialize(fileName);
	
        Cminus_parse();
		//Data section
		//printf("PRINTING DATA\n");
		printf("\t.data\n");
		while(!dlinkListEmpty(dataList)){
			DLinkNode *node  = dlinkPop(dataList);
			Generic string = dlinkNodeAtom(node);
			printf("%s\n",string);
		}
		printf("\t.text\n");
		printf("\t.globl main\n");
		printf("main:\tnop\n");
		printf("\tla $gp, data_start\n");
		//Instruction section
		while(!dlinkListEmpty(instList)){
			DLinkNode *node  = dlinkPop(instList);
			Generic string = dlinkNodeAtom(node);
			printf("%s\n",string);
		}
		printf(".data\n");
		printf("data_start:\n");

  	finalize();
  
  	return 0;
}

int getValue(int index)
{
  return (int)SymGetFieldByIndex(symtab, index, SYMTAB_VALUE_FIELD); 
}

int setValue(int index, int value)
{
  SymPutFieldByIndex(symtab, index, SYMTAB_VALUE_FIELD, (Generic)value); 
}
/******************END OF C ROUTINES**********************/
