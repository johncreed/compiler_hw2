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
hex_digit [0-9a-fA-F]
ID	 {letter}({letter}|{digit}|"_")*
WS	 [ \t]+
Int_constant {digit}+

 /* decimal float */
sign_part [+-]
digit_seq {digit}+
test_float ({digit_seq}\.{digit_seq}|{digit_seq}\.)
dot_digit ({digit_seq}\.)|({digit_seq}\.{digit_seq})|(\.{digit_seq})
exponent [eE]{sign_part}?{digit_seq}
float_suffix [fFlL]
decimal_floating_constant ({digit_seq}{exponent}{float_suffix}?)|({dot_digit}{exponent}?{float_suffix}?)
 /* hexadecimal float */
hex_prefix 0[xX]
hex_digit_sequence {hex_digit}+
binary_exponent [pP]{sign_part}?{digit_seq}
dot_hex_digits ({hex_digit_sequence}\.)|({hex_digit_sequence}\.{hex_digit_sequence})|\.{hex_digit_sequence}
hexadecimal_floating_constant ({hex_prefix}{dot_hex_digits}{binary_exponent}{floating_suffix}?)|({hex_prefix}{hex_digit_sequence}{binary_exponent}{floating_suffix}?)
 /* float literal */
Float_constant {decimal_floating_constant}|{hexadecimal_floating_constant}

 /* escape character */
hex_quad {hex_digit}{4}
universal_character_name \\u{hex_quad}|\\U{hex_quad}{2}

character_escape_code [ntbrfv\\'"a?]
octal_escape_code [0-7]{1,3}
hex_escape_code x{hex_digit}+
escape_code {character_escape_code}|{octal_escape_code}|{hex_escape_code}
escape_character \\{escape_code}|{universal_character_name}

 /* string constant */
s_char [^"\\\n]|{escape_character}
s_char_sequence {s_char}+
string_constant L?\"{s_char_sequence}\"

 /* comment */
comment \/\*([^*]*\*)([^/][^*]*\*)*\/

 /* others */
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

