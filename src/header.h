struct symtab{
	char lexeme[256];
	struct symtab *front;
	struct symtab *back;
	int line;
	int counter;
};

typedef struct symtab symtab;
void init_table();
symtab * lookup(char *name);
void insert(char *name);
