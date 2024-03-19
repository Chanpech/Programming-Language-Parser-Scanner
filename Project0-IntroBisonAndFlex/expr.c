#include "expr.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

/*
Create one node in an expression tree and return the structure.
*/
extern FILE *yyin;
extern int yyparse();
struct expr *parser_result;

extern struct SymbolTable symtab;
extern struct expr *parser_array[16];

void expr_updateKeyPair(struct expr *e, char *name, float value)
{
	//printf("Address of parser_array[0]%p e->address %p evaluate ID %s value %f", e, (e->address), name, value);
	struct KeyValuePair *pair = getAdd_symTab(&symtab, name, value);
	pair->value = value;
}
struct KeyValuePair *findExistingExpression(struct expr *e, char *name)
{
	struct KeyValuePair *pair = getAdd_symTab(&symtab, name, 0);
	/*
	if (pair != NULL)
	{
		printf("Key: %s ", pair->key);
		printf("Value: %f ", pair->value);
		printf("Next: %p\n", pair->next);
	} 
	*/
	return pair;
}

struct expr *expr_create(expr_t kind, struct expr *left, struct expr *right)
{
	/* Shortcut: sizeof(*e) means "the size of what e points to" */
	/*if (kind == EXPR_SEMI)
		printf("EXPRESSION SEMI\n");*/
	struct expr *e = malloc(sizeof(*e));
	// else{}
	e->kind = kind;
	e->value = 0;
	e->left = left;
	e->right = right; 
	e->address = NULL; 
	e->id = NULL; 
	return e; 
} 

struct expr *expr_create_value(float value)
{
	struct expr *e = expr_create(EXPR_VALUE, 0, 0);
	e->value = value;
	return e;
}

// struct KeyValuePair *pair lookUpNode();
// Store the keyvalue pair in the expression tree.
// Found the key pair
// Should check return the address of the struct expression
// Then the TOKEN Assign should somehow
//	check the value of the existing variable.
//  	new grammar rule or new function
struct expr *expr_assign_address(char *variable)
{
	//printf("\n\nPRINTING: %s ADDRESS: %p\n", variable, variable);
	struct expr *e = expr_create(EXPR_VARIABLE, 0, 0);
	//printf("EXPRESSION Variable Address%p\n", e);
	struct KeyValuePair *pair = findExistingExpression(e, variable);
	e->id = variable;
	e->address = pair;
	e->value = strlen(variable);
	return e;
}

/*
Recursively delete an expression tree.
*/
// You will use a symbol table to access variables and evaluate
// assignment statements. The symbol table implementa:on is
// provided in expr.c
void expr_delete(struct expr *e)
{
	/* Careful: Stop on null pointer. */
	if (!e)
		return;
	expr_delete(e->left);
	expr_delete(e->right);
	free(e);
}

/**
int createAddress(char *letter){
	char *variable = malloc(sizeof(char*) * 5);

	return ;
} */

void expr_variable(char *name, struct expr *e)
{
	/* Careful: Stop on null pointer. */
	if (!e)
		return;
	expr_variable(name, e->left);
	if (e->kind == EXPR_VARIABLE)
	{
		//printf("%.*s this is the one", (int)e->value, (e->id)); // Point thing to the key value of address
		sprintf(name, "%.*s", (int)e->value, (e->id));
	}
}
/*
Recursively print an expression tree by performing an
in-order traversal of the tree, printing the current node
between the left and right nodes.
*/

void expr_print(struct expr *e)
{
	/* Careful: Stop on null pointer. */
	if (!e)
		return;

	printf("(");

	expr_print(e->left);

	switch (e->kind)
	{
	case EXPR_ADD:
		printf("+");
		break;
	case EXPR_SUBTRACT:
		printf("-");
		break;
	case EXPR_MULTIPLY:
		printf("*");
		break;
	case EXPR_DIVIDE:
		printf("/");
		break;
	case EXPR_VALUE:
		printf("%f", e->value);
		break;
	case EXPR_SIN:
		printf("sin ");
		break;
	case EXPR_COS:
		printf("cos ");
		break;
	case EXPR_VARIABLE:
		printf("%.*s", (int)e->value, (e->id)); // Point thing to the key value of address
		break;
	case EXPR_ASSIGN:
		printf("=");
		break;
	case EXPR_SEMI:
		printf("; ");
		break;
	}

	expr_print(e->right);
	printf(")");
}

/*
Recursively evaluate an expression by performing
the desired operation and returning it up the tree.
*/

float expr_evaluate(struct expr *e)
{
	/* Careful: Return zero on null pointer. */
	if (!e)
		return 0;

	float l = expr_evaluate(e->left);
	float r = expr_evaluate(e->right);
	// Add something here to evaluate existing variable
	switch (e->kind)
	{
	case EXPR_ADD:
		return l + r;
	case EXPR_SUBTRACT:
		return l - r;
	case EXPR_MULTIPLY:
		return l * r;
	case EXPR_DIVIDE:
		if (r == 0)
		{
			printf("runtime error: divide by zero\n");
			exit(1);
		}
		return l / r;
	case EXPR_VALUE:
		return e->value;
	case EXPR_SIN:
		printf("sin( %f )\n", r);
		return sin(r);
	case EXPR_COS:
		printf("cos( %f )\n", r);
		return cos(r);
	case EXPR_ASSIGN:
		return r;
	case EXPR_SEMI:
		return l;
	case EXPR_VARIABLE:
		return ((struct KeyValuePair *)(e->address))->value;
	}

	return 0;
}

// Hash function to convert a string key into an index
unsigned int hash(const char *key)
{
	unsigned int hash = 0;
	while (*key)
	{
		hash = (hash * 31) + (*key++);
	}
	return hash % TABLE_SIZE;
}

// Function to create a new key-value pair
struct KeyValuePair *createKeyValuePair(const char *key, float value)
{
	struct KeyValuePair *pair = (struct KeyValuePair *)malloc(sizeof(struct KeyValuePair));
	if (pair)
	{
		pair->key = strdup(key);
		pair->value = value;
		pair->next = NULL;
	}
	return pair;
}

// Function to insert a key-value pair into the hash table
struct KeyValuePair *insert(struct SymbolTable *ht, const char *key, float value)
{
	unsigned int index = hash(key);
	struct KeyValuePair *newPair = createKeyValuePair(key, value);

	if (!ht->table[index])
	{
		// No collision, insert at the beginning of the chain
		ht->table[index] = newPair;
		printf("index is %u\n", index);
	}
	else
	{
		// Collision, insert at the end of the chain
		struct KeyValuePair *current = ht->table[index];
		while (current->next)
		{
			current = current->next;
		}

		current->next = newPair;
		printf("Insert( ) returns index %d key %s\n,", index, ht->table[index]->key);
	}
	return newPair;
}

// Function to look up a value by key
struct KeyValuePair *lookup(struct SymbolTable *ht, const char *key)
{
	unsigned int index = hash(key);
	struct KeyValuePair *current = ht->table[index];

	while (current)
	{
		if (strcmp(current->key, key) == 0)
		{
			//printf("RETURNED Identical Found Key Pair\n");
			return current; // Return the identically match key pair.
		}
		current = current->next;
	}

	// Key not found, return a default value (you can choose your own behavior)
	return NULL;
}

// Function to free memory used by the hash table
void destroyHashTable(struct SymbolTable *ht)
{
	for (int i = 0; i < TABLE_SIZE; i++)
	{
		struct KeyValuePair *current = ht->table[i];
		while (current)
		{
			struct KeyValuePair *temp = current;
			current = current->next;
			free(temp->key);
			free(temp);
		}
	}
}

struct KeyValuePair *getAdd_symTab(struct SymbolTable *tab, char *name, float value)
{
	// printf("FLOAT VALUE getAddress_symTab is %f\n", value);
	struct KeyValuePair *p = lookup(tab, name);
	if (p == NULL)
		p = insert(tab, name, value); // Return the new pair
	else
		printf("P is not NULL\n");
	return p; //
}
