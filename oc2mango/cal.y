%{
#import <Foundation/Foundation.h>
#import "CodeBuilder.h"
#import "Log.h"
#import "VariableDeclare.h"

#define YYDEBUG 1
#define YYERROR_VERBOSE
#define _retained(type) (__bridge_retained type)
#define _vretained _retained(void *)
#define _transfer(type) (__bridge_transfer type)
%}
%union{
    void *identifier;
    void *include;
    void *statement;
    void *declare;
    void *expression;
}


%token <identifier> IF ENDIF IFDEF IFNDEF UNDEF IMPORT INCLUDE
%token <identifier> INTERFACE IMPLEMENTATION PROTOCOL END CLASS_DECLARE
%token <identifier> PROPERTY WEAK STRONG COPY ASSIGN_MEM NONATOMIC ATOMIC ASTERISK
%token <identifier> IDENTIFIER STRING_LITERAL
%token <identifier> SUB ADD COMMA COLON POWER SEMICOLON LT GT DIV LP RP RIP LB RB LC RC DOT AT  ASSIGN PS
%token <identifier> SELECTOR _Class _id _void _BOOL _SEL _CHAR _SHORT _INT _LONG _LLONG  _UCHAR _USHORT _UINT _ULONG  _ULLONG _DOUBLE _FLOAT
%type  <include> PS_Define includeHeader
%type  <statement>  class_declare
%type  <statement> class_property_declare class_property_type
%type  <statement> value_declaer value_type block_declare block_type block_parameteres

%type  <statement>  methodcall
%type  <statement> primary_expression 

%%

compile_util: /*empty*/
			| definition_list
			;
definition_list: definition
            | definition_list definition
            ;
definition:  
            | PS_Define
            | class_declare
			;
PS_Define: 
            | PS PS_Define 
            | includeHeader
            ;
includeHeader:
            | IMPORT 
            | INCLUDE 
            | includeHeader LT IDENTIFIER DIV IDENTIFIER DOT IDENTIFIER GT
            | includeHeader STRING_LITERAL
            ;
class_declare:
            | INTERFACE IDENTIFIER COLON IDENTIFIER
            | class_declare LT protocol_list GT
            | class_private_varibale_declare
            | class_property_declare value_declaer SEMICOLON
            | method_declare SEMICOLON;
            | END
            ;
protocol_list:
            | IDENTIFIER
            | protocol_list COMMA IDENTIFIER
            ;
class_private_varibale_declare:
            | LC
            | class_private_varibale_declare value_declaer SEMICOLON
            {
                log($2);
            }
            | class_private_varibale_declare RC
            ;

class_property_type:
            | ASSIGN_MEM
            | WEAK
            | STRONG
            | COPY
            | NONATOMIC
            | ATOMIC
            ;
class_property_declare:
            | PROPERTY LP
            | class_property_declare class_property_type COMMA
            | class_property_declare class_property_type RP
            ;

value_declaer:
            | value_type IDENTIFIER
            {
                $$ = _vretained format($1,@" ",$2);
            }
            | block_declare
            ;
value_type: 
            | _UCHAR
            | _USHORT
            | _UINT
            | _ULONG
            | _ULLONG            
            | _CHAR
            | _SHORT
            | _LONG
            | _LLONG
            | _DOUBLE
            | _FLOAT
            | _Class
            | _BOOL
            | _id
            | _void
            | IDENTIFIER
            | value_type ASTERISK
            {
                $$ = _vretained format($1,@" *");
            }
            | block_type
            {
                $$ = @"Block";
            }
            ;
block_declare: 
            | value_type LP POWER IDENTIFIER RP
            {
                $$ = _vretained format(@"Block ",$4);
            }
            | block_declare LP block_parameteres RP
            ;
block_type: 
            | value_type LP POWER RP
            | block_type LP block_parameteres RP
            ;

block_parametere_type:
            | value_declaer
            | value_type
            ;
block_parameteres:
            | block_parametere_type
            | block_parameteres block_parametere_type COMMA
            ;

method_declare:
            | SUB LP value_type RP
            | ADD LP value_type RP
            | method_declare IDENTIFIER
            {
                log(@"declare",$2);
            }
            | method_declare IDENTIFIER COLON LP value_type RP IDENTIFIER
            {
                log($2,$7);
            }
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

