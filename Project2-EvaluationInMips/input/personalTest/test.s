<Type> -> <INTEGER>
<VarDecl> -> <IDENTIFIER
sw $fp, ($sp)
move $fp, $sp
sub $sp, $sp, 12
<IdentifierList> -> <VarDecl>
<VarDecl> -> <IDENTIFIER
sw $fp, ($sp)
move $fp, $sp
sub $sp, $sp, 12
<IdentifierList> -> <IdentifierList> <CM> <VarDecl>
<DeclList> -> <Type> <IdentifierList> <SC>
<Type> -> <INTEGER>
	.data
.newl:.asciiz "\n" 
	.text
	.globl main 
main: nop
<ProcedureHead> -> <FunctionDecl>
<Expr> -> <SimpleExpr>
<Assignment> -> <Variable> <ASSIGN> <Expr> <SC>
<Statement> -> <Assignment>
<StatementList> -> <Statement>
<Expr> -> <SimpleExpr>
<Assignment> -> <Variable> <ASSIGN> <Expr> <SC>
<Statement> -> <Assignment>
<StatementList> -> <StatementList> <Statement>
