%{
#import <Foundation/Foundation.h>
#define YYDEBUG 1
#define YYERROR_VERBOSE
%}
%union{
    void *identifier;
    void *statement;
    void *declare;
    void *expression;
}

%token _IF _ENDIF _IFDEF _IFNDEF _IMPORT  _UNDEF _INCLUDE COMMA INTERFACE IMPLEMENTATION PROTOCOL END CLASS_DECLARE COLON POWER SEMICOLON LP RP RIP LB RB LC RC DOT AT UINT INT DOUBLE  ANYWORDS STRING_LITERAL ASSIGN

%token <identifier> IDENTIFIER
%type  <statement>  methodcall
%type  <expression> primary_expression 
%type  <declare> class_declare
%%

class_declare:
INTERFACE IDENTIFIER COLON IDENTIFIER
{
    printf("%s %d %s\n",__FILE__,__LINE__,$2);
}
| class_declare primary_expression
| class_declare END
;
primary_expression:
| IDENTIFIER ASSIGN methodcall SEMICOLON
| methodcall SEMICOLON
;

methodcall:
| IDENTIFIER
{
    printf("start %s\n",$1);
}
| methodcall IDENTIFIER
{
    printf("next %s\n",$2);
}
| LB methodcall RB IDENTIFIER
{
    printf("next: %s\n",$4);
}
| LB methodcall RB
;





%%
int yyerror(char *s){
    printf("error: %s\n",s);
    return 0;
}

