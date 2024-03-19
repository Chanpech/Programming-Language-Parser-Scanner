#ifndef CODEGEN_H_
#define CODEGEN_H_

#include <util/symtab.h>
#include <codegen/types.h>
//Added headers
#include <util/dlink.h>



//End
#define SYSCALL_PRINT_INTEGER "1"	/**< The syscall code for printing an integer */
#define SYSCALL_PRINT_FLOAT "2"	/**< The syscall code for printing a float */
#define SYSCALL_PRINT_STRING "4"	/**< The syscall code for printing a string */
#define SYSCALL_READ_INTEGER "5"	/**< The syscall code for reading an integer */
#define SYSCALL_READ_FLOAT "6"	/**< The syscall code for reading a float */
#define SYSCALL_EXIT "10"			/**< The syscall code for exiting the interpreter */


#endif /*CODEGEN_H_*/

int genANDExpr(DLinkList *instList, SymTable symtab, int expr, int simpExpr);

int genReadInt(DLinkList *instList, SymTable  SymTab, int simplExpr);