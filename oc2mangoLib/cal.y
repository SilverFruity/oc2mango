%{
#import <Foundation/Foundation.h>
#import "Log.h"
#import "MakeDeclare.h"

#define YYDEBUG 1
#define YYERROR_VERBOSE
#define _retained(type) (__bridge_retained type)
#define _vretained _retained(void *)
#define _transfer(type) (__bridge_transfer type)
%}
%union{
    void *identifier;
    void *include;
    void *type;
    void *declare;
    void *implementation;
    void *statement;
    void *expression;
}


%token <identifier> IF ENDIF IFDEF IFNDEF UNDEF IMPORT INCLUDE 
%token <identifier> QUESTION  _return _break _continue _goto _else  _while _do _in _for _case _switch _default
%token <identifier> INTERFACE IMPLEMENTATION PROTOCOL END CLASS_DECLARE
%token <identifier> PROPERTY WEAK STRONG COPY ASSIGN_MEM NONATOMIC ATOMIC
%token <identifier> IDENTIFIER STRING_LITERAL
%token <identifier> COMMA COLON SEMICOLON  LP RP RIP LB RB LC RC DOT AT PS
%token <identifier> EQ NE LT LE GT GE LOGIC_AND LOGIC_OR LOGIC_NOT
%token <identifier> AND OR POWER SUB ADD DIV ASTERISK AND_ASSIGN OR_ASSIGN POWER_ASSIGN SUB_ASSIGN ADD_ASSIGN DIV_ASSIGN ASTERISK_ASSIGN INCREMENT DECREMENT
SHIFTLEFT SHIFTRIGHT MOD ASSIGN MOD_ASSIGN
%token <identifier> _self _super _nil _NULL _YES _NO 
%token <identifier>  _Class _id _void _BOOL _SEL _CHAR _SHORT _INT _LONG _LLONG  _UCHAR _USHORT _UINT _ULONG  _ULLONG _DOUBLE _FLOAT 
%token <identifier> INTETER_LITERAL DOUBLE_LITERAL SELECTOR 
%type  <include> PS_Define includeHeader
%type  <declare>  class_declare protocol_list class_private_varibale_declare
%type  <declare>  class_property_declare method_declare 
%type  <declare>  value_declare block_declare block_parameteres class_property_type
%type  <type> value_declare_type block_type method_caller_type value_type
%type  <implementation> class_implementation  objc_method_call
%type  <expression> numerical_value_type block_implementation assign_operator unary_operator binary_operator 
judgement_operator ternary_exression calculator_expression judgement_expression value_expression assign_expression control_statement function_implementation  return_expressoin

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
            | class_implementation
            {
                log($1);
            }
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
            INTERFACE IDENTIFIER COLON IDENTIFIER
            {
                ClassDeclare *declare = makeClassDeclare(_transfer(NSString *) $2);
                declare.superClassName = _transfer(NSString *)$4;
                $$ = _vretained declare;
            }
            | class_declare LT protocol_list GT
            {
                ClassDeclare *declare = _transfer(ClassDeclare *) $1;
                declare.protocolNames = _transfer(NSMutableArray *) $3;
                $$ = _vretained declare;
            }
            | class_declare class_private_varibale_declare
            {
                ClassDeclare *declare = _transfer(ClassDeclare *) $1;
                declare.privateVariables = _transfer(NSMutableArray *) $2;
                $$ = _vretained declare;
            }
            | class_declare class_property_declare value_declare SEMICOLON
            {
                PropertyDeclare *property = [PropertyDeclare new];
                property.keywords = _transfer(NSMutableArray *) $2;
                property.var = _transfer(VariableDeclare *) $3;
                ClassDeclare *declare = _transfer(ClassDeclare *) $1;
                [declare.properties addObject:property];
                [declare.privateVariables addObject:property.privateVar];
                $$ = _vretained declare;
            }
            | class_declare method_declare SEMICOLON
            {
                ClassDeclare *declare = _transfer(ClassDeclare *) $1;
                [declare.methods addObject: _transfer(MethodDeclare *) $2];
                $$ = _vretained declare;
            }
            | class_declare END
            ;
class_category:
            ;
class_implementation:
            IMPLEMENTATION IDENTIFIER
            {
                ClassImplementation *imp = makeClassImplementation(_transfer(NSString *)$2);
                $$ = _vretained imp;
            }
            | class_implementation class_private_varibale_declare
            {
                ClassImplementation *imp = _transfer(ClassImplementation *) $1;
                imp.privateVariables = _transfer(NSMutableArray *)$2;
                $$ = _vretained imp;
            }
            | class_implementation method_declare function_implementation
            {
                MethodImplementation *imp = makeMethodImplementation(_transfer(MethodDeclare *) $2);
                ClassImplementation *clasImp = _transfer(ClassImplementation *) $1;
                [clasImp.methodImps addObject:imp];
                $$ = _vretained clasImp;
            }
            | class_implementation END
            ;
protocol_list: IDENTIFIER
			{
				NSMutableArray *list = [NSMutableArray array];
				NSString *identifier = (__bridge_transfer NSString *)$1;
				[list addObject:identifier];
				$$ = (__bridge_retained void *)list;
			}
			| protocol_list COMMA IDENTIFIER
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				NSString *identifier = (__bridge_transfer NSString *)$3;
				[list addObject:identifier];
				$$ = (__bridge_retained void *)list;
			}
			;

class_private_varibale_declare:
            LC
            {
                NSMutableArray *list = [NSMutableArray array];
				$$ = (__bridge_retained void *)list;
            }
            | class_private_varibale_declare value_declare SEMICOLON
            {
                NSMutableArray *list = _transfer(NSMutableArray *) $1;
				[list addObject:_transfer(VariableDeclare *) $2];
				$$ = (__bridge_retained void *)list;
            }
            | class_private_varibale_declare RC
            ;

class_property_type:
              ASSIGN_MEM
            | WEAK
            | STRONG
            | COPY
            | NONATOMIC
            | ATOMIC
            ;

class_property_declare:
            PROPERTY LP
            {
                NSMutableArray *list = [NSMutableArray array];
				$$ = (__bridge_retained void *)list;
            }
            | class_property_declare class_property_type COMMA
            {
                NSMutableArray *list = _transfer(NSMutableArray *) $1;
				[list addObject:_transfer(NSString *) $2];
				$$ = (__bridge_retained void *)list;
            }
            | class_property_declare class_property_type RP
            {
                NSMutableArray *list = _transfer(NSMutableArray *) $1;
				[list addObject:_transfer(NSString *) $2];
				$$ = (__bridge_retained void *)list;
            }
            ;

value_declare:
             value_declare_type IDENTIFIER
            {
                $$ = _vretained makeVariableDeclare((__bridge TypeSpecial *)$1,(__bridge NSString *)$2);
            }
            | block_declare
            ;
value_declare_type:  _UCHAR
            {
                 $$ = _vretained makeTypeSpecial(SpecialTypeUChar);
            }
            | _USHORT
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeUShort);
            }
            | _UINT
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeUInt);
            }
            | _ULONG
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeULong);
            }
            | _ULLONG
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeULongLong);
            }            
            | _CHAR
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeChar);
            }
            | _SHORT
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeShort);
            }
            | _INT
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeInt);
            }
            | _LONG
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeLong);
            }
            | _LLONG
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeLongLong);
            }
            | _DOUBLE
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeDouble);
            }
            | _FLOAT
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeFloat);
            }
            | _Class
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeClass);
            }
            | _BOOL
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeBOOL);
            }
            | _id
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeId);
            }
            | _void
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeVoid);
            }
            | IDENTIFIER
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeObject,(__bridge NSString *)$1);
            }
            | value_declare_type ASTERISK
            {
                TypeSpecial *specail = _transfer(TypeSpecial *) $1;
                specail.isPointer = YES;
                $$ =  _vretained specail;
            }
            | block_type
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeBlock);
            }
            ;
block_declare: 
              value_declare_type LP POWER IDENTIFIER RP
            {
                $$ = _vretained makeVariableDeclare(makeTypeSpecial(SpecialTypeBlock),(__bridge NSString *)$4);
            }
            | block_declare LP block_parameteres RP
            ;
block_type: 
             value_declare_type LP POWER RP
            | block_type LP block_parameteres RP
            ;

block_parametere_type: 
              value_declare
            | value_declare_type
            ;
block_parameteres:
            block_parametere_type
            | block_parameteres COMMA block_parametere_type 
            ;

method_declare:
            SUB LP value_declare_type RP
            {   
                $$ = _vretained makeMethodDeclare(NO,_transfer(TypeSpecial *) $3);
            }
            | ADD LP value_declare_type RP
            {
                $$ = _vretained makeMethodDeclare(YES,_transfer(TypeSpecial *) $3);
            }
            | method_declare IDENTIFIER
            {
                MethodDeclare *method = _transfer(MethodDeclare *)$$;
                [method.methodNames addObject:_transfer(NSString *) $2];
                $$ = _vretained method;
            }
            | method_declare IDENTIFIER COLON LP value_declare_type RP IDENTIFIER
            {
                MethodDeclare *method = _transfer(MethodDeclare *)$$;
                [method.methodNames addObject:_transfer(NSString *) $2];
                [method.parameterTypes addObject:_transfer(TypeSpecial *) $5];
                [method.parameterNames addObject:_transfer(NSString *) $7];
                $$ = _vretained method;
            }
            ;
            
method_caller_type:
         _self
         | _super
         | IDENTIFIER
         {
             log($1);
         }
         ;

objc_property_get: 
         method_caller_type IDENTIFIER
         {
             log($1,$2);
         }
         | method_caller_type IDENTIFIER COLON value_expression 
         {
             log($1,$2,$4);
         }
         | method_caller_type DOT IDENTIFIER
         {
             log($1,$3);
         }
         | method_caller_type DOT LP value_expression RP
         {
             log($4);
         }
         ;
objc_method_call:
        objc_property_get
        | objc_method_call IDENTIFIER
        {
            log($2);
        }
        | objc_method_call IDENTIFIER COLON value_expression
        {
            log($2,$4);
        }
        | objc_method_call DOT IDENTIFIER
        {
            log($3);
        }
        | objc_method_call DOT LP value_expression RP
        | LB objc_method_call RB
        ;

numerical_value_type:
          INTETER_LITERAL
        | DOUBLE_LITERAL
        ;

block_implementation: 
        value_declare_type POWER LP block_parameteres RP function_implementation

        | POWER LP block_parameteres RP function_implementation  

        ;

value_type:
        IDENTIFIER
         {
             log($$);
         }
        | numerical_value_type
        {
            $$ = @"num";
            log($$);
        }
        | LP value_declare_type RP value_type
        {
            $$ = @"convert";
            log($$);
        }
        | _self
        {
            $$ = @"self";
            log($$);
        }
        | _super
        {
            $$ = @"super";
        }
        | _nil
        {
            $$ = @"nil";
            log($$);
        }
        | _NULL
        {
            $$ = @"NULL";
            log($$);
        }
        //| NSDictionary
        //| NSArray
        // NSNumber
        | AT LP numerical_value_type RP 
        {
            $$ = @"@(num)";
            log($$);
        }
        | ASTERISK IDENTIFIER
        {
            $$ = @"*取值";
            log($$);
        }
        | AND IDENTIFIER
        {
            $$ = @"&去地址";
            log($$);
        }
        | _break
        {
            $$ = @"break";
            log($$);
        }
        | _continue
        {
            $$ = @"continue";
            log($$);
        }
        | block_implementation
        {
            $$ = @"block imp";
            log($$);
        }
        | objc_method_call
        {
            $$ = @"method return -- "; 
            log(@"method return -- ");
        }
        ;

assign_operator:
        AND_ASSIGN
        | OR_ASSIGN
        | POWER_ASSIGN
        | ADD_ASSIGN
        | SUB_ASSIGN
        | DIV_ASSIGN
        | MOD_ASSIGN
        ; 

unary_operator: 
        INCREMENT
        | DECREMENT
        ;

binary_operator:
        ADD
        | SUB
        | ASTERISK
        | DIV
        | MOD
        | SHIFTLEFT
        | SHIFTRIGHT
        | AND
        | OR
        | POWER
        ;

judgement_operator:
        EQ        
        | NE
        | LE
        | LT
        | GE
        | GT
        | LOGIC_AND
        | LOGIC_OR
        | LOGIC_NOT
        ;


ternary_exression:
        judgement_expression QUESTION value_expression COLON value_expression
        | judgement_expression QUESTION COLON value_expression 
        ;

calculator_expression:
        value_expression binary_operator value_expression
        {
            log(@"binary");
        }
        | value_expression unary_operator
        {
            log(@"unary");
        }
        | ternary_exression
        {
            log(@"ternary");
        }
        ;
judgement_expression:
         value_expression judgement_operator value_expression
        ;

value_expression:
        value_type
        | judgement_expression
        {
            log(@"judge expressoin");
        }
        | calculator_expression
        {
            log(@"calculator expressoin");
        }
        ;

assign_expression:
        value_expression
        | value_declare
        | value_declare ASSIGN value_expression
        {
            log($1);
        }
        | value_type assign_operator value_expression
        | assign_expression SEMICOLON
        ; 
return_expressoin:
        _return value_expression SEMICOLON
        | _return SEMICOLON
        ;
if_statement:
         IF LP value_expression RP function_implementation
         {
             log(@"if statement");
         }
        | if_statement _else IF LP value_expression RP function_implementation
        | if_statement _else function_implementation
        ;

dowhile_statement:
        _do function_implementation
        | dowhile_statement RC _while LP value_expression RP
        ;
while_statement:
        _while LP value_expression RP LC
        | while_statement function_implementation
        | while_statement RC
        ;
case_value_type:
        //数字或者枚举类型
          INTETER_LITERAL
        | IDENTIFIER
        ;
case_statement:
         _case case_value_type COLON
        | _default case_value_type COLON
        | case_statement LC
        | case_statement function_implementation
        | case_statement RC
        ;
switch_statement:
         _switch LP value_expression RP LC  
        | switch_statement case_statement
        | switch_statement RC
        ;
for_parameter_list:
        | assign_expression
        | for_parameter_list SEMICOLON value_expression
        ;
for_statement: _for LP for_parameter_list RP function_implementation
        ;

forin_statement: _for LP value_declare RP _in value_expression function_implementation
        ;

control_statement: 
        if_statement
        | switch_statement
        | while_statement
        | dowhile_statement
        | for_statement
        | forin_statement
        ;


function_implementation:
        LC
        | function_implementation assign_expression
        {
            log(@"function -> assign");
        }
        | function_implementation control_statement
        {
            log(@"function -> control statement");
        }
        | function_implementation return_expressoin
        | function_implementation RC
        ;
        

%%
int yyerror(char *s){
    printf("error: %s\n",s);
    return 0;
}

