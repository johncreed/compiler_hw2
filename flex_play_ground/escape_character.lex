%{
#include <math.h>
%}
hex_digit [0-9a-fA-F]

 /* escape character */
hex_quad {hex_digit}{4}
universal_character_name \\u{hex_quad}|\\U{hex_quad}{2}

character_escape_code [ntbrfv\\'"a?]
octal_escape_code [0-7]{1,3}
hex_escape_code x{hex_digit}+
escape_code {character_escape_code}|{octal_escape_code}|{hex_escape_code}
escape_character \\{escape_code}|{universal_character_name}

%%
{escape_character} { printf("decimal floating seq: %s", yytext);} 
%%

main(int argc, char **argv){
    argc--; ++argv;
    if(argc > 0)
        yyin = fopen(argv[0], "r");
    else
        yyin = stdin;
    yylex();
}
