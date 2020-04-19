#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
#include<math.h>
#include"header.h"

#define TABLE_SIZE	256

symtab * hash_table[TABLE_SIZE];
extern int linenumber;

void init_table(){
    for(int i = 0; i < 256; i++)
        hash_table[i] = NULL;
}

int HASH(char * str){
	int idx=0;
	while(*str){
		idx = idx << 1;
		idx+=*str;
		str++;
	}	
	return (idx & (TABLE_SIZE-1));
}

/*returns the symbol table entry if found else NULL*/

symtab * lookup(char *name){
	int hash_key;
	symtab* symptr;
	if(!name)
		return NULL;
	hash_key=HASH(name);
	symptr=hash_table[hash_key];

	while(symptr){
		if(!(strcmp(name,symptr->lexeme)))
			return symptr;
		symptr=symptr->front;
	}
	return NULL;
}


void insertID(char *name){
	int hash_key;
	symtab* ptr;
	symtab* symptr=(symtab*)malloc(sizeof(symtab));	
	
	hash_key=HASH(name);
	ptr=hash_table[hash_key];
	
	if(ptr==NULL){
		/*first entry for this hash_key*/
		hash_table[hash_key]=symptr;
		symptr->front=NULL;
		symptr->back=symptr;
	}
	else{
		symptr->front=ptr;
		ptr->back=symptr;
		symptr->back=symptr;
		hash_table[hash_key]=symptr;	
	}
	
	strcpy(symptr->lexeme,name);
	symptr->line=linenumber;
	symptr->counter=1;
}

void printSym(symtab* ptr) 
{
	    printf(" Name = %s \n", ptr->lexeme);
	    printf(" References = %d \n", ptr->counter);
}

void printSymTab()
{
    int i;
    printf("----- Symbol Table ---------\n");
    for (i=0; i<TABLE_SIZE; i++)
    {
        symtab* symptr;
	symptr = hash_table[i];
	while (symptr != NULL)
	{
            printf("====>  index = %d \n", i);
	    printSym(symptr);
	    symptr=symptr->front;
	}
    }
}

int sym_counter_compare(const void *a, const void *b){
    symtab **ptra = (symtab **) a;
    symtab **ptrb = (symtab **) b;

    return ((*ptra)->counter < (*ptrb)->counter); 
}
 
void printFreq(){

    printf("Frequency of identifiers:\n");
    int cnt = 0;
    symtab *freq_array[TABLE_SIZE];
    
    for(int i = 0; i < TABLE_SIZE; i++){
        symtab *symptr = hash_table[i];
        if(symptr != NULL){
            freq_array[cnt] = symptr;
            cnt++;
        }
    }
    
    qsort(freq_array, cnt, sizeof(symtab *), sym_counter_compare);

    for(int i = 0; i < cnt; i++){
        symtab *ptr = freq_array[i];
        printf("%s\t%d\n", ptr->lexeme, ptr->counter);
    }
}
