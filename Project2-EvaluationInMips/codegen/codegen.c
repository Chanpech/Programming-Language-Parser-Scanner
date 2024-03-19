#include <stdlib.h>
#include <string.h>
#include <util/string_utils.h>
#include <util/symtab.h>
#include <util/dlink.h>
#include "reg.h"
#include "codegen.h"
#include "symfields.h"
#include "types.h"
//Added headers//
#include "stdio.h"
//END//
#define SYMTAB_VALUE_FIELD     "value"
#define SYMTAB_REGISTER_INDEX_FIELD "reg_index"
#define SYMTAB_OFFSET_FIELD "offset"
#define SYM_NAME_FIELD "name"
int genANDExpr(DLinkList *instList, SymTable symtab, int expr, int simpExpr){
    int reg_result = getFreeIntegerRegisterIndex(symtab);
    Generic reg1Cell = getIntegerRegisterName(expr); //Should already be $fp
    Generic reg2Cell = getIntegerRegisterName(simpExpr);
    Generic reg_result_Cell = getIntegerRegisterName(reg_result);
   
    char *inst = nssave(7,"\t", "and ", (char*)reg_result_Cell, ", ", (char*)reg1Cell, ", ", (char*)reg2Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(5,"\t", "move ", "$a0", ", ", (char*)reg_result_Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    return reg_result;
} 

int genORExpr(DLinkList *instList, SymTable symtab, int expr, int simpExpr){
    int reg_result = getFreeIntegerRegisterIndex(symtab);
    Generic reg1Cell = getIntegerRegisterName(expr); //Should already be $fp
    Generic reg2Cell = getIntegerRegisterName(simpExpr);
    Generic reg_result_Cell = getIntegerRegisterName(reg_result);
   
    char *inst = nssave(7,"\t", "or ", (char*)reg_result_Cell, ", ", (char*)reg1Cell, ", ", (char*)reg2Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(5,"\t", "move ", "$a0", ", ", (char*)reg_result_Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    return reg_result;
} 

// lw $t0, neg_value         # Load the value from memory
//     nor $t1, $t0, $zero       # Negate the value and store the result in $t1
int genNotExpr(DLinkList *instList, SymTable symtab, int simpExpr){
     int reg_result = getFreeIntegerRegisterIndex(symtab);
    Generic reg1Cell = getIntegerRegisterName(simpExpr); 
    Generic reg_result_Cell = getIntegerRegisterName(reg_result);
    char *inst = nssave(5,"\t", "not ", (char*)reg_result_Cell, ", ",(char*)reg1Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(5,"\t", "move ", "$a0", ", ", (char*)reg_result_Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    return reg_result;
} 

/*
li $v0, 4         # Load the print string system call code (4) into $v0
la $a0, prompt    # Load the address of the prompt into $a0
syscall

li $v0, 5            # System call code for reading an integer
la $a0, input_buffer # Load the address of the input buffer
syscall
    */
int genReadInt(DLinkList *instList, SymTable  symtab, int readIn){
   
	Generic globalID = SymGetFieldByIndex(symtab, readIn, SYM_NAME_FIELD);
   
    char *inst = nssave(5, "\t", "li ", "$v0", ", ", "5"); 
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(2, "\t", "syscall");
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(5, "\t", "sw ", "$v0", ", ", (char*)globalID);
    dlinkAppend(instList, dlinkNodeAlloc(inst));


    return readIn;
}

void funcDeclList(SymTable  symTab, int functionDecl, int declList){
    // printf("\t.text\n");
    // printf("\t.global main\n");
    // printf("main: nop\n");
    //main nop
}
void procedureTerminate(DLinkList *instList, SymTable  symtab){
    // printf("\tli $v0, 10\n");
	// printf("\tsyscall\n");
    //int reg_result = getFreeIntegerRegisterIndex(symtab);
    //bool *allocatedIntegerRegisters; 
    //int resultReg = allocateRegister(allocatedIntegerRegisters, 1);
    char *inst = nssave(7, "\t", "li ", "$v0", ", ", "10", "\n\t", "syscall");
    dlinkAppend(instList, dlinkNodeAlloc(inst));
}
void recordID(int id){

}

//     li $v0, 4         # Load the print string system call code (4) into $v0
//     la $a0, hello     # Load the address of the string into $a0
//     syscall           # Perform the system call to print the string
void storeInStringDataSection(DLinkList *dataList,DLinkList *instList, Generic varName, char* str, int count){
    char strCount[4];
    snprintf(strCount, sizeof(strCount), "%d", count);
    char *dataResult = nssave(7,".string", strCount, ": ", ".asciiz ", "\"", str, "\"");
    DLinkNode *node =  dlinkNodeAlloc(dataResult);//24 + 4
    dlinkAppend(dataList,node);

    char *instResult = nssave(5,"\t", "li ", "$v0", ", ", "4");
    node =  dlinkNodeAlloc(instResult);
    dlinkAppend(instList,node);
    instResult = nssave(6, "\t", "la ", "$a0", ", ", ".string", strCount);
    node =  dlinkNodeAlloc(instResult);
    dlinkAppend(instList,node);
    node =  dlinkNodeAlloc("\tsyscall");
    dlinkAppend(instList,node);

}

void storeInGlobalDataSection(DLinkList *dataList, Generic varName, int varCount, Generic name){
    //global_var: space "
   //ssave(varCount);
    char str[4];
    snprintf(str, sizeof(str), "%d", varCount);
    char *dataResult = nssave(4, name, ": ", ".word ", str);
    DLinkNode *node =  dlinkNodeAlloc(dataResult);//24 + 4
    dlinkAppend(dataList,node);
}

void loadVariableToRegister(SymTable symtab, char* stringConst){
    //add $s0, $gp, 16
    //li $s1, 45
    //sw $s1, 0($s0)
    //he memory address of the variable b? Offset to gp is 16
    //
    int intReg = getFreeIntegerRegisterIndex(symtab);
    
    //return allocated register
    //return intReg
}

// li $a0, 7
// li $v0, 1
// syscall
void storeWriteExpr(DLinkList *instList, SymTable symtab, int expr){
    // printf("NUM: %d\n", num );
    
    // char strCount[4];
    // snprintf(strCount, sizeof(strCount), "%d", num);
    
    Generic strCount = getIntegerRegisterName(expr);
    
    
    char *inst = nssave(5, "\t", "li ", "$v0", ", ", "1");
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    dlinkAppend(instList, dlinkNodeAlloc("\tsyscall"));

}

int genPlusExpr(DLinkList *instList, SymTable symtab, int expr, int mulExpr){

    int reg_result = getFreeIntegerRegisterIndex(symtab);
    Generic reg1Cell = getIntegerRegisterName(expr); //Should already be $fp
    Generic reg2Cell = getIntegerRegisterName(mulExpr);
    Generic reg_result_Cell = getIntegerRegisterName(reg_result);

    char *inst = nssave(7,"\t", "add ", (char*)reg_result_Cell, ", ", (char*)reg1Cell, ", ", (char*)reg2Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(5,"\t", "move ", "$a0", ", ", (char*)reg_result_Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));

//    freeIntegerRegister(expr);
//    freeIntegerRegister(mulExpr);
//    freeIntegerRegister(reg3);

    return reg_result;
}


int genMinusExpr(DLinkList *instList, SymTable symtab, int expr, int mulExpr){

    int reg_result = getFreeIntegerRegisterIndex(symtab);
    Generic reg1Cell = getIntegerRegisterName(expr); 
    Generic reg2Cell = getIntegerRegisterName(mulExpr);
    Generic reg_result_Cell = getIntegerRegisterName(reg_result);

    char *inst = nssave(7,"\t", "sub ", (char*)reg_result_Cell, ", ", (char*)reg1Cell, ", ", (char*)reg2Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));

    inst = nssave(5,"\t", "move ", "$a0", ", ", (char*)reg_result_Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));

    return reg_result;
}

int genTimesExpr(DLinkList *instList, SymTable symtab, int expr, int mulExpr){
    int reg_result = getFreeIntegerRegisterIndex(symtab);
    Generic reg1Cell = getIntegerRegisterName(expr); //Should already be $fp
    Generic reg2Cell = getIntegerRegisterName(mulExpr);
    Generic reg_result_Cell = getIntegerRegisterName(reg_result);
   
    char *inst = nssave(7,"\t", "mul ", (char*)reg_result_Cell, ", ", (char*)reg1Cell, ", ", (char*)reg2Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(5,"\t", "move ", "$a0", ", ", (char*)reg_result_Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    return reg_result;
}


int genDivideExpr(DLinkList *instList, SymTable symtab, int expr, int mulExpr){
    int reg_result = getFreeIntegerRegisterIndex(symtab);
    Generic reg1Cell = getIntegerRegisterName(expr); //Should already be $fp
    Generic reg2Cell = getIntegerRegisterName(mulExpr);
    Generic reg_result_Cell = getIntegerRegisterName(reg_result);
   
    char *inst = nssave(5,"\t", "div ", (char*)reg1Cell, ", ", (char*)reg2Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(3,"\t", "mflo ", (char*)reg_result_Cell); //quotient
    dlinkAppend(instList, dlinkNodeAlloc(inst));
     inst = nssave(5,"\t", "move ", "$a0", ", ", (char*)reg_result_Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    return reg_result;
}


//Inequality
// lw $t0, value1         # Load value from memory into $t0
// lw $t1, value2         # Load value from memory into $t1
// beq $t0, $t1, equal    # Branch to 'equal' if $t0 equals $t1
int genEqExpr(DLinkList *instList, SymTable symtab, int expr, int mulExpr, int eqMade){
    int reg_result = getFreeIntegerRegisterIndex(symtab);
    Generic reg1Cell = getIntegerRegisterName(expr); //Should already be $fp
    Generic reg2Cell = getIntegerRegisterName(mulExpr);
    Generic reg_result_Cell = getIntegerRegisterName(reg_result);
    
    
    char str[64];
    snprintf(str, sizeof(str), "%d", eqMade);
    char *inst = nssave(7,"\t", "beq ", (char*)reg1Cell, ", ", (char*)reg2Cell, " equal" ,str );
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(4,"\t", "li ", (char*)reg_result_Cell, " 0" );
    dlinkAppend(instList, dlinkNodeAlloc(inst));
     inst = nssave(3,"\t", "j done", str);
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(3,"equal", str, ":");
    dlinkAppend(instList, dlinkNodeAlloc(inst));
     inst = nssave(4,"\t", "li ", (char*)reg_result_Cell, " 1" );
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(3,"done", str, ":");
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(5,"\t", "move ", "$a0", ", ", (char*)reg_result_Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));

    return reg_result;
}

// lw $t0, value1         # Load value from memory into $t0
// lw $t1, value2         # Load value from memory into $t1
// bne $t0, $t1, not_equal    # Branch to 'not_equal' if $t0 is not equal to $t1
int genNEExpr(DLinkList *instList, SymTable symtab, int expr, int mulExpr, int neMade){
      int reg_result = getFreeIntegerRegisterIndex(symtab);
    Generic reg1Cell = getIntegerRegisterName(expr); //Should already be $fp
    Generic reg2Cell = getIntegerRegisterName(mulExpr);
    Generic reg_result_Cell = getIntegerRegisterName(reg_result);
    
    
    char str[64];
    snprintf(str, sizeof(str), "%d", neMade);
    char *inst = nssave(7,"\t", "bne ", (char*)reg1Cell, ", ", (char*)reg2Cell, " not_equal" ,str );
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(4,"\t", "li ", (char*)reg_result_Cell, " 0" );
    dlinkAppend(instList, dlinkNodeAlloc(inst));
     inst = nssave(3,"\t", "j bne_done", str);
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(3,"not_equal", str, ":");
    dlinkAppend(instList, dlinkNodeAlloc(inst));
     inst = nssave(4,"\t", "li ", (char*)reg_result_Cell, " 1" );
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(3,"bne_done", str, ":");
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(5,"\t", "move ", "$a0", ", ", (char*)reg_result_Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));

    return reg_result;
}

// lw $t0, value1         # Load value from memory into $t0
// lw $t1, value2         # Load value from memory into $t1
// ble $t0, $t1, less_than_or_equal    # Branch to 'less_than_or_equal' if $t0 <= $t1  
int genLEExpr(DLinkList *instList, SymTable symtab, int expr, int mulExpr, int ble){
    int reg_result = getFreeIntegerRegisterIndex(symtab);
    Generic reg1Cell = getIntegerRegisterName(expr); //Should already be $fp
    Generic reg2Cell = getIntegerRegisterName(mulExpr);
    Generic reg_result_Cell = getIntegerRegisterName(reg_result);
    
    
    char str[64];
    snprintf(str, sizeof(str), "%d", ble);
    char *inst = nssave(7,"\t", "ble ", (char*)reg1Cell, ", ", (char*)reg2Cell, " less_than" ,str );
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(4,"\t", "li ", (char*)reg_result_Cell, " 0" );
    dlinkAppend(instList, dlinkNodeAlloc(inst));
     inst = nssave(3,"\t", "j ble_done", str);
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(3,"less_than", str, ":");
    dlinkAppend(instList, dlinkNodeAlloc(inst));
     inst = nssave(4,"\t", "li ", (char*)reg_result_Cell, " 1" );
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(3,"ble_done", str, ":");
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(5,"\t", "move ", "$a0", ", ", (char*)reg_result_Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));

    return reg_result;
    
}

// lw $t0, value1         # Load value from memory into $t0
// lw $t1, value2         # Load value from memory into $t1
// blt $t0, $t1, less_than    # Branch to 'less_than' if $t0 < $t1
int genLTExpr(DLinkList *instList, SymTable symtab, int expr, int mulExpr, int blt){
    int reg_result = getFreeIntegerRegisterIndex(symtab);
    Generic reg1Cell = getIntegerRegisterName(expr); //Should already be $fp
    Generic reg2Cell = getIntegerRegisterName(mulExpr);
    Generic reg_result_Cell = getIntegerRegisterName(reg_result);
    
    
    char str[64];
    snprintf(str, sizeof(str), "%d", blt);
    char *inst = nssave(7,"\t", "blt ", (char*)reg1Cell, ", ", (char*)reg2Cell, " less_than_equal" ,str );
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(4,"\t", "li ", (char*)reg_result_Cell, " 0" );
    dlinkAppend(instList, dlinkNodeAlloc(inst));
     inst = nssave(3,"\t", "j blt_done", str);
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(3,"less_than_equal", str, ":");
    dlinkAppend(instList, dlinkNodeAlloc(inst));
     inst = nssave(4,"\t", "li ", (char*)reg_result_Cell, " 1" );
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(3,"blt_done", str, ":");
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(5,"\t", "move ", "$a0", ", ", (char*)reg_result_Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));

    return reg_result;
}

// lw $t0, value1         # Load value1 from memory into $t0
// lw $t1, value2         # Load value2 from memory into $t1
// bge $t0, $t1, greater_than_or_equal  # Branch to 'greater_than_or_equal' if $t0 >= $t1

int genGEExpr(DLinkList *instList, SymTable symtab, int expr, int mulExpr, int bge){
     int reg_result = getFreeIntegerRegisterIndex(symtab);
    Generic reg1Cell = getIntegerRegisterName(expr); //Should already be $fp
    Generic reg2Cell = getIntegerRegisterName(mulExpr);
    Generic reg_result_Cell = getIntegerRegisterName(reg_result);
    
    char str[64];
    snprintf(str, sizeof(str), "%d", bge);
    char *inst = nssave(7,"\t", "bge ", (char*)reg1Cell, ", ", (char*)reg2Cell, " greater_than_equal" ,str );
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(4,"\t", "li ", (char*)reg_result_Cell, " 0" );
    dlinkAppend(instList, dlinkNodeAlloc(inst));
     inst = nssave(3,"\t", "j bge_done", str);
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(3,"greater_than_equal", str, ":");
    dlinkAppend(instList, dlinkNodeAlloc(inst));
     inst = nssave(4,"\t", "li ", (char*)reg_result_Cell, " 1" );
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(3,"bge_done", str, ":");
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(5,"\t", "move ", "$a0", ", ", (char*)reg_result_Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));

    return reg_result;
}

// lw $t0, value1         # Load value1 from memory into $t0
// lw $t1, value2         # Load value2 from memory into $t1
// bge $t0, $t1, greater_than_or_equal  # Branch to 'greater_than_or_equal' if $t0 >= $t1

int genGTExpr(DLinkList *instList, SymTable symtab, int expr, int mulExpr, int bgt){
       int reg_result = getFreeIntegerRegisterIndex(symtab);
    Generic reg1Cell = getIntegerRegisterName(expr); //Should already be $fp
    Generic reg2Cell = getIntegerRegisterName(mulExpr);
    Generic reg_result_Cell = getIntegerRegisterName(reg_result);
    
    char str[64];
    snprintf(str, sizeof(str), "%d", bgt);
    char *inst = nssave(7,"\t", "bgt ", (char*)reg1Cell, ", ", (char*)reg2Cell, " greater_than" ,str );
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(4,"\t", "li ", (char*)reg_result_Cell, " 0" );
    dlinkAppend(instList, dlinkNodeAlloc(inst));
     inst = nssave(3,"\t", "j bgt_done", str);
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(3,"greater_than", str, ":");
    dlinkAppend(instList, dlinkNodeAlloc(inst));
     inst = nssave(4,"\t", "li ", (char*)reg_result_Cell, " 1" );
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(3,"bgt_done", str, ":");
    dlinkAppend(instList, dlinkNodeAlloc(inst));
    inst = nssave(5,"\t", "move ", "$a0", ", ", (char*)reg_result_Cell);
    dlinkAppend(instList, dlinkNodeAlloc(inst));

    return reg_result;
}

//For Global:
// add $s0, $gp, 8
// lw $s1, 0($s0)
// // For local
// sub $s0, $fp, 4
// lw $s1, 0($s0)


//lw $a0, a
int accessGlobalVar(DLinkList *dataList, DLinkList *instList, SymTable symtab, int var){
    Generic reg1Cell = getIntegerRegisterName(var); 
    Generic offset = SymGetFieldByIndex(symtab, var, SYMTAB_OFFSET_FIELD);

    char offsetStr[3];
    snprintf(offsetStr, sizeof(offsetStr), "%d", offset);
    
    char *inst = nssave(6,"\t", "lw ", (char*)reg1Cell, ", ", offsetStr, "($gp)");
    dlinkAppend(instList, dlinkNodeAlloc(inst)); 
    inst = nssave(6,"\t", "lw ", "$a0", ", ", offsetStr, "($gp)");
    dlinkAppend(instList, dlinkNodeAlloc(inst)); 
    
//     freeIntegerRegister(reg1);   
    return var;
}

//li $t0, 10         # Load the value 10 into $t0
//li $t1, 20         # Load the value 20 into $t1

int genINTCon(DLinkList *instList, SymTable symtab, int var){
     int reg1 = getFreeIntegerRegisterIndex(symtab);
    Generic reg1Cell = getIntegerRegisterName(reg1); 
    
    char str[10];
    snprintf(str, sizeof(str), "%d", var);
    char *inst = nssave(5,"\t", "li ", (char*)reg1Cell, ", ", str);// some byte
    dlinkAppend(instList, dlinkNodeAlloc(inst)); 

    return reg1;
}

//Global value
int genAssignVar(DLinkList *instList, SymTable symtab, int var, int expr){
    Generic reg1Cell = getIntegerRegisterName(var);
    Generic reg2Cell = getIntegerRegisterName(expr); 
    Generic offset = SymGetFieldByIndex(symtab, var, SYMTAB_OFFSET_FIELD);
    //printf("Expr: %d reg2Cell %d Offset%d Type \n",expr, var, offset);
    //printf("Expr: %d reg2Cell %d\n",expr, var);
    char str[3];
    snprintf(str, sizeof(expr), "%d", expr);

    char offsetStr[3];
    snprintf(offsetStr, sizeof(offsetStr), "%d", offset);
    
    char *inst = nssave(5,"\t", "move ", (char*)reg1Cell, ", ",(char*)reg2Cell);// some byte
    dlinkAppend(instList, dlinkNodeAlloc(inst)); 
    inst = nssave(6,"\t", "sw ", (char*)reg1Cell, ", ", offsetStr, "($gp)");// some byte
    dlinkAppend(instList, dlinkNodeAlloc(inst)); 

    freeIntegerRegister(expr);

    return var;
}