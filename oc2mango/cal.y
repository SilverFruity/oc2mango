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
%token <identifier> QUESTION  _return _break _continue _goto _else _elseif _while _do _in _for _case _switch _default
%token <identifier> INTERFACE IMPLEMENTATION PROTOCOL END CLASS_DECLARE
%token <identifier> PROPERTY WEAK STRONG COPY ASSIGN_MEM NONATOMIC ATOMIC
%token <identifier> IDENTIFIER STRING_LITERAL
%token <identifier> COMMA COLON SEMICOLON  LP RP RIP LB RB LC RC DOT AT PS
%token <identifier> EQ NE LT LE GT GE LOGIC_AND LOGIC_OR LOGIC_NOT
%token <identifier> AND OR POWER SUB ADD DIV ASTERISK AND_ASSIGN OR_ASSIGN POWER_ASSIGN SUB_ASSIGN ADD_ASSIGN DIV_ASSIGN ASTERISK_ASSIGN INCREMENT DECREMENT
%token <identifier> _self _super _nil _NULL _YES _NO 
%token <identifier>  _Class _id _void _BOOL _SEL _CHAR _SHORT _INT _LONG _LLONG  _UCHAR _USHORT _UINT _ULONG  _ULLONG _DOUBLE _FLOAT 
%token <identifier> INTETER_LITERAL DOUBLE_LITERAL SELECTOR 
%type  <include> PS_Define includeHeader
%type  <declare>  class_declare protocol_list class_private_varibale_declare
%type  <declare>  class_property_declare method_declare 
%type  <declare>  value_declaer block_declare block_parameteres class_property_type
%type  <type> value_declare_type block_type method_caller_type value_type
%type  <implementation> class_implementation method_implementation objc_method_call
%type  <expression> primary_expression 

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
            {
                log($1);
            }
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
            | INTERFACE IDENTIFIER COLON IDENTIFIER
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
            | class_declare class_property_declare value_declaer SEMICOLON
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
            | IMPLEMENTATION IDENTIFIER
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
            | class_implementation method_implementation
            {
                ClassImplementation *imp = _transfer(ClassImplementation *) $1;
                [imp.methodImps addObject:_transfer(MethodImplementation *)$2];
                $$ = _vretained imp;
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
            | LC
            {
                NSMutableArray *list = [NSMutableArray array];
				$$ = (__bridge_retained void *)list;
            }
            | class_private_varibale_declare value_declaer SEMICOLON
            {
                NSMutableArray *list = _transfer(NSMutableArray *) $1;
				[list addObject:_transfer(VariableDeclare *) $2];
				$$ = (__bridge_retained void *)list;
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

value_declaer:
            | value_declare_type IDENTIFIER
            {
                $$ = _vretained makeVariableDeclare((__bridge TypeSpecial *)$1,(__bridge NSString *)$2);
            }
            | block_declare
            ;
value_declare_type: 
            | _UCHAR
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
            | value_declare_type LP POWER IDENTIFIER RP
            {
                $$ = _vretained makeVariableDeclare(makeTypeSpecial(SpecialTypeBlock),(__bridge NSString *)$4);
            }
            | block_declare LP block_parameteres RP
            ;
block_type: 
            | value_declare_type LP POWER RP
            | block_type LP block_parameteres RP
            ;

block_parametere_type:
            | value_declaer
            | value_declare_type
            ;
block_parameteres:
            | block_parametere_type
            | block_parameteres COMMA block_parametere_type 
            ;

method_declare:
            | SUB LP value_declare_type RP
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

method_implementation:
            |  method_declare LC
            {
                MethodImplementation *imp = makeMethodImplementation(_transfer(MethodDeclare *) $1);
                $$ = _vretained imp;
            }
            |  method_implementation primary_expression
            |  method_implementation RC
            ;
primary_expression:
            | objc_method_call SEMICOLON
            {
                log(@"success");
            }
            | _return value_type SEMICOLON
            | _return SEMICOLON
            ;


method_caller_type:
         | _self
         | _super
         | IDENTIFIER
         | LP value_declare_type RP IDENTIFIER
         {
             $$ = $4;
         }
         ;
value_type:
        | INTETER_LITERAL
        | DOUBLE_LITERAL
        | SELECTOR
        | objc_method_call
        {
            $$ = _vretained [NSString stringWithFormat:@"ret"];
        }
        | LP value_declare_type RP value_type
        ;
objc_method_call:
          | method_caller_type
          {
              log(@"start ",$1);
          }
          | objc_method_call IDENTIFIER
          {
              log(@"next ",$2);
          }
          | objc_method_call IDENTIFIER COLON value_type
          {
              log(@"next ",$2,$4);
          }
          | LB objc_method_call RB
          ;


if_statement:
        | IF LP value_type RP LC
        // 类似函数实现 LC{ .... }RC
        | if_statement primary_expression
        | if_statement elseif_statement
        | if_statement else_statement
        | if_statement RC
        ;
else_statement:
        | _else LC
        // 类似函数实现 LC{ .... }RC
        | else_statement primary_expression
        | else_statement RC
        ;
elseif_statement:
        | _elseif LP value_type RP LC
        // 类似函数实现 LC{ .... }RC
        | else_statement primary_expression
        | else_statement RC
        ;
dowhile_statement:
        | _do LC
        // 类似函数实现 LC{ .... }RC
        | dowhile_statement primary_expression
        | dowhile_statement RC _while LP value_type RP
        ;
while_statement:
        | _while LP value_type RP LC
        // 类似函数实现 LC{ .... }RC
        | while_statement primary_expression
        | while_statement RC
        ;
case_value_type:
        //数字或者枚举类型
        | INTETER_LITERAL
        | IDENTIFIER
        ;
case_statement:
        | _case case_value_type COLON
        | _default case_value_type COLON
        | case_statement LC
        // 类似函数实现 LC{ .... }RC
        | case_statement primary_expression
        | case_statement RC
        ;
switch_statement:
        | _switch LP value_type RP LC
        | switch_statement case_statement
        | switch_statement RC
        ;
for_parameter_list:
        // 赋值表达式
        | primary_expression
        // 判断表达式 或者 基本加减表达式
        | for_parameter_list SEMICOLON primary_expression 
        ;
for_statement:
        | _for LP for_parameter_list RP LC
        | for_statement primary_expression
        | for_statement RC
        ;
forin_loop_value_tyep:
        | IDENTIFIER
        | objc_method_call
        ;
forin_statement:
        // 变量名称或者方法调用
        | _for value_declaer _in forin_loop_value_tyep LC
        // 类似函数实现 LC{ .... }RC
        | forin_statement primary_expression
        | forin_statement RC
        ;

%%
int yyerror(char *s){
    printf("error: %s\n",s);
    return 0;
}

