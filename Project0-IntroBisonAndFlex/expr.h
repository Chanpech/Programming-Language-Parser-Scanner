/*
expr.h defines the structure of an expression node,
and the operations that can be performed upon it.
Note some things about this file that you should emulate:
- Every symbol in expr.[ch] begins with expr_.
- Use enumerations to define variant types.
- Build complex trees one node at a time.
- Define methods with recurse over those trees.
*/

#ifndef EXPR_H
#define EXPR_H

typedef enum {
	EXPR_ADD,
	EXPR_SUBTRACT,
	EXPR_DIVIDE,
	EXPR_MULTIPLY,
    EXPR_VARIABLE,
	EXPR_VALUE,
	EXPR_SIN,
	EXPR_COS,
    EXPR_ASSIGN,
    EXPR_SEMI
} expr_t;

struct expr {
       expr_t kind;
       float value;
       struct expr *left;
       struct expr *right;
       void *address;
       char *id;
};

struct expr * expr_create( expr_t kind, struct expr *left, struct expr *right);
struct expr * expr_create_value( float value);
struct expr * expr_assign_address(char *variable);

void          expr_print( struct expr *e );
void          expr_delete( struct expr *e );
float         expr_evaluate( struct expr *e );
float         expr_assign( struct expr *e );
void          expr_updateKeyPair(struct expr *e, char *name, float value);
void          expr_variable(char *name, struct expr *e);

// Define the maximum number of buckets in the hash table
#define TABLE_SIZE 100

// Define the structure for a key-value pair
struct KeyValuePair {
    char* key;
    float value;
    struct KeyValuePair* next; // Pointer to the next item in the chain
};

struct SymbolTable {
    struct KeyValuePair* table[TABLE_SIZE]; // Array of pointers to key-value pairs
};

struct KeyValuePair * getAdd_symTab(struct SymbolTable * tab, char *text, float value);

void destroyHashTable(struct SymbolTable* ht);
#endif

