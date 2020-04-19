%option noyywrap 
%{
#include <stdio.h>
#include "header.h" 
int linenumber;
symtab * lookup();
symtab * ptr;
void     insertID();
void 	 printSymTab();
/* You need to define for all tokens in C--, here are some examples */
#define INT		10
#define FLOAT 		11 
#define OP_ASSIGN 	12 
#define OP_OR 		13 
#define MK_LPAREN 	14 
#define MK_RPAREN 	15 
#define ERROR 		100 

%}

letter   [A-Za-z]
digit    [0-9]
ID	 {letter}({letter}|{digit}|"_")*
WS	 [ \t]+
Int_constant {digit}+

/* Float constant */
sign_part [+-]
digit_seq {digit}+
test_float ({digit_seq}\.{digit_seq}|{digit_seq}\.)
dot_digit ({digit_seq}\.)|({digit_seq}\.{digit_seq})|(\.{digit_seq})
exponent [eE]{sign_part}?{digit_seq}
float_suffix [fFlL]
decimal_floating_constant ({digit_seq}{exponent}{float_suffix}?)|({dot_digit}{exponent}?{float_suffix}?)
hex_digit [0-9a-fA-F]
hex_prefix 0[xX]
hex_digit_sequence {hex_digit}+
binary_exponent [pP]{sign_part}?{digit_seq}
dot_hex_digits ({hex_digit_sequence}\.)|({hex_digit_sequence}\.{hex_digit_sequence})|\.{hex_digit_sequence}
hexadecimal_floating_constant ({hex_prefix}{dot_hex_digits}{binary_exponent}{floating_suffix}?)|({hex_prefix}{hex_digit_sequence}{binary_exponent}{floating_suffix}?)
Float_constant {decimal_floating_constant}|{hexadecimal_floating_constant}


/* You need to define the following RE's 
String_constant
comment
*/

OP_assign        "="
OP_or   "||"

/* Other operators appear here */ 


newline  "\n"

DL_lparen "("
DL_rparen ")"
DL_lbrace "{"
DL_rbrace "}"
DL_comma  ","
DL_semicol ";"
DL_dot  "."

/* Other separators appear here */

error    .

%%

{WS}            {}
{RWInt}         {/* return INT; */ }
{RWFloat}       {/* return FLOAT; */}
{ID}            { 
			ptr = lookup(yytext);
			if (ptr == NULL)
			     insertID(yytext);	
			else 
			     ptr->counter++;
		}

{OP_assign}     /* return OP_ASSIGN; */ 
{OP_or}         /* return OP_OR; */
{DL_lparen}     /* return MK_LPAREN; */
{DL_rparen}     /* return MK_RPAREN; */
{DL_lbrace}     /* return MK_LBRACE; */
{DL_rbrace}     /* return MK_RBRACE; */
{DL_comma}      {}
{DL_semicol}    {}
{newline}       linenumber += 1;
{error}         printf("ERR \n");/* return ERROR; */


%%

main(int argc, char **argv)
{
 argc--; ++argv;
   if (argc > 0)
      yyin = fopen(argv[0], "r");
   else
      yyin = stdin;
   yylex();
   printSymTab();
}

