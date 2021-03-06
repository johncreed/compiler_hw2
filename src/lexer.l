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
int_constant {digit}+

 /* decimal float */
sign_part [+-]
digit_seq {digit}+
test_float ({digit_seq}\.{digit_seq}|{digit_seq}\.)
dot_digit ({digit_seq}\.)|({digit_seq}\.{digit_seq})|(\.{digit_seq})
exponent [eE]{sign_part}?{digit_seq}
floating_suffix [fFlL]
decimal_floating_constant ({digit_seq}{exponent}{floating_suffix}?)|({dot_digit}{exponent}?{floating_suffix}?)
 /* hexadecimal float */
hex_prefix 0[xX]
hex_digit_sequence {hex_digit}+
binary_exponent [pP]{sign_part}?{digit_seq}
dot_hex_digits ({hex_digit_sequence}\.)|({hex_digit_sequence}\.{hex_digit_sequence})|\.{hex_digit_sequence}
hexadecimal_floating_constant ({hex_prefix}{dot_hex_digits}{binary_exponent}{floating_suffix}?)|({hex_prefix}{hex_digit_sequence}{binary_exponent}{floating_suffix}?)
 /* float literal */
float_constant {decimal_floating_constant}|{hexadecimal_floating_constant}

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

 /* assignment operation */
OP_assign        "="
 /* boolean operations */
OP_or   "||"
OP_and "&&"
OP_not "!"
 /* relational operations */
OP_gt ">"
OP_lt "<"
OP_ge ">="
OP_le "<="
OP_neq "!="
OP_eq "=="
 /* arithmetic operations */
OP_plus "+"
OP_minus "-"
OP_div "/"
OP_mul "*"

newline  "\n"
 /* Separators */
DL_lparen "("
DL_rparen ")"
DL_lbraket "["
DL_rbraket "]"
DL_lbrace "{"
DL_rbrace "}"
DL_comma  ","
DL_semicol ";"
DL_dot  "."

error    .

%%

 /* reserved words */
return   {/*ECHO;*/}
typedef   {/*ECHO;*/}
if   {/*ECHO;*/}
else   {/*ECHO;*/}
int   {/*ECHO;*/}
float   {/*ECHO;*/}
for   {/*ECHO;*/}
void   {/*ECHO;*/}
while   {/*ECHO;*/}

    /* identifiers */
{WS}            { /*ECHO;*/}
{ID}            { /*ECHO;*/
            ptr = lookup(yytext);
            if (ptr == NULL)
                 insertID(yytext);  
            else 
                 ptr->counter++;
        }

    /* constants */
{int_constant}         { /*ECHO;*/ /* return INT; */ }
{float_constant}       { /*ECHO;*/ /* return FLOAT; */}
{string_constant}       { /*ECHO;*/ /* return string;*/}
{comment}       { printf("%s\n", yytext); /*ECHO;*/ }


 /* assignment operation */
{OP_assign}        { /*ECHO;*/ /*return OP_ASSIGN;*/ } 
 /* boolean operations */
{OP_or}   { /*ECHO;*/ /*return OP_ASSIGN;*/ } 
{OP_and} { /*ECHO;*/ /*return OP_ASSIGN;*/ } 
{OP_not} { /*ECHO;*/ /*return OP_ASSIGN;*/ } 
 /* relational operations */
{OP_gt} { /*ECHO;*/ /*return OP_ASSIGN;*/ } 
{OP_lt} { /*ECHO;*/ /*return OP_ASSIGN;*/ } 
{OP_ge} { /*ECHO;*/ /*return OP_ASSIGN;*/ } 
{OP_le} { /*ECHO;*/ /*return OP_ASSIGN;*/ } 
{OP_neq} { /*ECHO;*/ /*return OP_ASSIGN;*/ } 
{OP_eq} { /*ECHO;*/ /*return OP_ASSIGN;*/ } 
 /* arithmetic operations */
{OP_plus} { /*ECHO;*/ /*return OP_ASSIGN;*/ } 
{OP_minus} { /*ECHO;*/ /*return OP_ASSIGN;*/ } 
{OP_div} { /*ECHO;*/ /*return OP_ASSIGN;*/ } 
{OP_mul} { /*ECHO;*/ /*return OP_ASSIGN;*/ } 

{DL_lparen}    {/*ECHO;*/} /* return MK_LPAREN; */
{DL_rparen}     {/*ECHO;*/} /* return MK_RPAREN; */
{DL_lbraket}     {/*ECHO;*/} /* return MK_LBRAKET; */
{DL_rbraket}     {/*ECHO;*/}  /* return MK_RBRAKET; */
{DL_lbrace}     {/*ECHO;*/}  /* return MK_LBRACE; */
{DL_rbrace}     {/*ECHO;*/}  /* return MK_RBRACE; */
{DL_comma}      {/*ECHO;*/}
{DL_semicol}    {/*ECHO;*/}
{DL_dot}          {/*ECHO;*/}
{newline}       {/*ECHO;*/linenumber += 1;}
{error}        {/*ECHO;*/ printf("ERR \n"); /* return ERROR; */}


%%

main(int argc, char **argv)
{
    argc--; ++argv;
    if (argc > 0)
        yyin = fopen(argv[0], "r");
    else
        yyin = stdin;

    init_table();
    yylex();
    //printSymTab();
    printFreq();
}

