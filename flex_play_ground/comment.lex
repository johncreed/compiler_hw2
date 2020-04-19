%{
#include <math.h>
%}

comment \/\*([^*]*\*)([^/][^*]*\*)*\/

%%
{comment} { printf("decimal floating seq: %s", yytext);} 
%%

main(int argc, char **argv){
    argc--; ++argv;
    if(argc > 0)
        yyin = fopen(argv[0], "r");
    else
        yyin = stdin;
    yylex();
}
