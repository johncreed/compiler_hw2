%{
#include <math.h>
%}

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

%%
{OP_assign} {printf("assign: %s\n", yytext);}
{OP_or} {printf("or: %s\n", yytext);}
{OP_and} {printf("and: %s\n", yytext);}
{OP_not} {printf("not: %s\n", yytext);}
{OP_gt} {printf("gt: %s\n", yytext);}
{OP_lt} {printf("lt: %s\n", yytext);}
{OP_ge} {printf("ge: %s\n", yytext);}
{OP_le} {printf("le: %s\n", yytext);}
{OP_neq} {printf("neq: %s\n", yytext);}
{OP_eq} {printf("eq: %s\n", yytext);}
{OP_plus} {printf("plus: %s\n", yytext);}
{OP_minus} {printf("minus: %s\n", yytext);}
{OP_div} {printf("div: %s\n", yytext);}
{OP_mul} {printf("mul: %s\n", yytext);}
%%

main(int argc, char **argv){
    argc--; ++argv;
    if(argc > 0)
        yyin = fopen(argv[0], "r");
    else
        yyin = stdin;
    yylex();
}
