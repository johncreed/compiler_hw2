%{
#include <math.h>
%}

letter   [A-Za-z]
digit    [0-9]
ID	 {letter}({letter}|{digit}|"_")*
WS	 [ \t]+

Int_constant {digit}+

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
binary_exponent [pP]{sign_part}{digit_seq}
dot_hex_digits ({hex_digit_sequence}\.)|({hex_digit_sequence}\.{hex_digit_sequence})|\.{hex_digit_sequence}
hexadecimal_floating_constant ({hex_prefix}{dot_hex_digits}{binary_exponent}{floating_suffix})|({hex_prefix}{hex_digit_sequence}{binary_exponent}{floating_suffix})

Float_constant {decimal_floating_constant}|{hexadecimal_floating_constant}

%%
{decimal_floating_constant} { printf("decimal floating seq: %-15s%-20f", yytext, atof(yytext));} 
%%

main(int argc, char **argv){
    argc--; ++argv;
    if(argc > 0)
        yyin = fopen(argv[0], "r");
    else
        yyin = stdin;
    yylex();
}
