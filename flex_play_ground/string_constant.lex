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

 /* string constant */
s_char [^"\\\n]|{escape_character}
s_char_sequence {s_char}+
string_constant L?\"{s_char_sequence}\"

%%
 /*{escape_character} { printf("escape_character seq: %s\n", yytext);} */
{string_constant} { printf("string constant: %s", yytext);} 
 /* {s_char} { printf("s char: %s\n", yytext);} */
%%

main(int argc, char **argv){
    argc--; ++argv;
    if(argc > 0)
        yyin = fopen(argv[0], "r");
    else
        yyin = stdin;
    yylex();
}
