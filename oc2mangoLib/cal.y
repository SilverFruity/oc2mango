%{
#import <Foundation/Foundation.h>
#import "Log.h"
#import "MakeDeclare.h"
#import "Parser.h"
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
    int Operator;
}


%token <identifier> IF ENDIF IFDEF IFNDEF UNDEF IMPORT INCLUDE 
%token <identifier> QUESTION  _return _break _continue _goto _else  _while _do _in _for _case _switch _default _enum _typeof
%token <identifier> INTERFACE IMPLEMENTATION PROTOCOL END CLASS_DECLARE
%token <identifier> PROPERTY WEAK STRONG COPY ASSIGN_MEM NONATOMIC ATOMIC READONLY READWRITE
%token <identifier> IDENTIFIER STRING_LITERAL
%token <identifier> COMMA COLON SEMICOLON  LP RP RIP LB RB LC RC DOT AT PS
%token <identifier> EQ NE LT LE GT GE LOGIC_AND LOGIC_OR LOGIC_NOT
%token <identifier> AND OR POWER SUB ADD DIV ASTERISK AND_ASSIGN OR_ASSIGN POWER_ASSIGN SUB_ASSIGN ADD_ASSIGN DIV_ASSIGN ASTERISK_ASSIGN INCREMENT DECREMENT
SHIFTLEFT SHIFTRIGHT MOD ASSIGN MOD_ASSIGN
%token <identifier> _self _super _nil _NULL _YES _NO 
%token <identifier>  _Class _id _void _BOOL _SEL _CHAR _SHORT _INT _LONG _LLONG  _UCHAR _USHORT _UINT _ULONG  _ULLONG _DOUBLE _FLOAT _instancetype
%token <identifier> INTETER_LITERAL DOUBLE_LITERAL SELECTOR 
%type  <include> PS_Define includeHeader
%type  <declare>  class_declare protocol_list class_private_varibale_declare
%type  <declare>  class_property_declare method_declare 
%type  <declare>  value_declare block_declare func_declare_parameters class_property_type
%type  <type> value_declare_type block_type method_caller_type value_type object_value_type selector_value_type
%type  <implementation> class_implementation  objc_method_call
%type  <expression> numerical_value_type block_implementation declare_assign_expression var_assign_expression
 ternary_expression calculator_expression judgement_expression value_expression assign_expression control_statement function_implementation  control_expression
expression objc_method_call_pramameters objc_method_get value_expression_list for_parameter_list
%type <Operator> judgement_operator binary_operator unary_operator assign_operator
%type <statement> if_statement while_statement dowhile_statement switch_statement for_statement forin_statement case_statement
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
                [OCParser.classInterfaces addObject:_transfer(ClassDeclare *)$1];
            }
            | class_implementation
            {
                [OCParser.classImps addObject:_transfer(ClassImplementation *)$1];
            }
            | 
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
            | INTERFACE IDENTIFIER LP IDENTIFIER RP
            {
                ClassDeclare *declare = makeClassDeclare(_transfer(NSString *) $2);
                declare.categoryName = _transfer(NSString *)$4;
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
            | class_declare PROPERTY class_property_declare value_declare SEMICOLON
            {
                PropertyDeclare *property = [PropertyDeclare new];
                property.keywords = _transfer(NSMutableArray *) $3;
                property.var = _transfer(VariableDeclare *) $4;
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
            | IMPLEMENTATION IDENTIFIER LP IDENTIFIER RP
            {
                ClassImplementation *imp = makeClassImplementation(_transfer(NSString *)$2);
                imp.categoryName = _transfer(NSString *)$4;
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
                FunctionImp * funcImp = _transfer(FunctionImp *) $3;
                imp.imp = funcImp;
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
            | READONLY 
            | READWRITE
            ;

class_property_declare:
            {
                NSMutableArray *list = [NSMutableArray array];
				$$ = (__bridge_retained void *)list;
            }
            | LP
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

// FIXME: id <protocl> vlaue
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
            | _instancetype
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeId);
            }
            | IDENTIFIER ASTERISK
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeObject,(__bridge NSString *)$1);
            }
            // FIXME: implementation typeof type
            | _typeof LP value_expression RP
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeObject,@"typeof");
            }
            | _enum IDENTIFIER
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeInt);
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
            | block_declare LP func_declare_parameters RP
            ;
block_type: 
             value_declare_type LP POWER RP
            | block_type LP func_declare_parameters RP
            ;

block_parametere_type: 
              value_declare
            | value_declare_type
            ;
func_declare_parameters: /* empty */
            | block_parametere_type
            | func_declare_parameters COMMA block_parametere_type 
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

value_expression_list:
            | value_expression
            {
                NSMutableArray *list = [NSMutableArray array];
				[list addObject:_transfer(id)$1];
				$$ = _vretained list;
            }
            | value_expression_list COMMA value_expression
            {
                NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				[list addObject:_transfer(id) $3];
				$$ = (__bridge_retained void *)list;
            }
            ;
objc_method_get:
         object_value_type DOT IDENTIFIER
         {
             OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
             OCValue *caller = _transfer(OCValue *)$1;
             methodcall.caller =  caller;

             OCMethodCallGetElement *element = makeMethodCallElement(OCMethodCallDotGet);
             element.name = _transfer(NSString *)$3;
             methodcall.element = element;

             $$ = _vretained methodcall;
         }
         // Block Get
         | object_value_type DOT IDENTIFIER LP value_expression_list RP
         {
             OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
             OCValue *caller = _transfer(OCValue *)$1;
             methodcall.caller = caller;

             OCMethodCallGetElement *element = makeMethodCallElement(OCMethodCallDotGet);
             element.name = _transfer(NSString *)$3;
             [element.values addObject:_transfer(id) $5];
             methodcall.element = element;

             $$ = _vretained methodcall;
         }
         // Get
         | objc_method_get DOT IDENTIFIER
         {
             OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
             methodcall.caller =  _transfer(OCValue *)$1;

             OCMethodCallGetElement *element = makeMethodCallElement(OCMethodCallDotGet);
             element.name = _transfer(NSString *)$3;
             methodcall.element = element;

             $$ = _vretained methodcall;
         }
         // Block Get
         | objc_method_get DOT IDENTIFIER LP value_expression_list RP
         {
             OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
             methodcall.caller =  _transfer(OCValue *)$1;

             OCMethodCallGetElement *element = makeMethodCallElement(OCMethodCallDotGet);
             element.name = _transfer(NSString *)$3;
             [element.values addObject:_transfer(id) $5];
             methodcall.element = element;

             $$ = _vretained methodcall;
         }
        ;

method_caller_type:
         object_value_type
         | objc_method_get
         ;
objc_method_call_pramameters:
        IDENTIFIER
        {
            OCMethodCallNormalElement *element = makeMethodCallElement(OCMethodCallNormalCall);
            [element.names addObject:_transfer(NSString *)$1];
            $$ = _vretained element;
        }
        | IDENTIFIER COLON value_expression
        {
            OCMethodCallNormalElement *element = makeMethodCallElement(OCMethodCallNormalCall);
            [element.names addObject:_transfer(NSString *)$1];
            [element.values addObject:_transfer(id)$3];
            $$ = _vretained element;
        }
        | objc_method_call_pramameters IDENTIFIER COLON value_expression
        {
            OCMethodCallNormalElement *element = _transfer(OCMethodCallNormalElement *)$1;
            [element.names addObject:_transfer(NSString *)$2];
            [element.values addObject:_transfer(id)$4];
            $$ = _vretained element;
        }
        ;

objc_method_call:
        objc_method_get
        | LB method_caller_type objc_method_call_pramameters RB
        {
             OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
             OCValue *caller = _transfer(OCValue *)$2;
             methodcall.caller =  caller;
             methodcall.element = _transfer(id <OCMethodElement>)$3;
             $$ = _vretained methodcall;
        }
        ;


block_implementation:
        POWER value_declare_type function_implementation
        | POWER value_declare_type LP func_declare_parameters RP function_implementation
        | POWER function_implementation
        | POWER LP func_declare_parameters RP function_implementation  
        ;
// FIXME: implementation selector_value_type
selector_value_type:
        SELECTOR LP IDENTIFIER RP
        {
            $$ = _vretained makeValue(OCValueSelector);
        }
        | SELECTOR LP IDENTIFIER COLON
        {
            $$ = _vretained makeValue(OCValueSelector);
        }
        | selector_value_type IDENTIFIER COLON
        | selector_value_type RP
        ;
object_value_type:
        IDENTIFIER
        {
            $$ = _vretained makeValue(OCValueObject);
        }
        | _self
        {
            $$ = _vretained makeValue(OCValueSelf);
        }
        | _super
        {
            $$ = _vretained makeValue(OCValueSuper);
        }
        // NSDictionary
        // NSArray
        | AT LP value_expression RP 
        {
            $$ = _vretained makeValue(OCValueNSNumber);
        }
        | AT numerical_value_type
        {
            $$ = _vretained makeValue(OCValueNSNumber);
        }
        | AT STRING_LITERAL
        {
            $$ = _vretained makeValue(OCValueString);
        }
        | objc_method_call
        // FIXME:  C func call
        | IDENTIFIER LP value_expression_list RP
        {
            $$ = _vretained makeValue(OCValueFuncCall);
        }
        ;

numerical_value_type:
          INTETER_LITERAL
        | DOUBLE_LITERAL
        ;


value_type:
        object_value_type
        | selector_value_type
        | STRING_LITERAL
        {
            $$ = _vretained makeValue(OCValueCString);
        }
        | block_implementation
        {
            $$ = _vretained makeValue(OCValueBlock);
        }
        | numerical_value_type
        {
            $$ = _vretained makeValue(OCValueNumber);
        }
        | LP value_declare_type RP value_type
        {
            $$ = _vretained makeValue(OCValueConvert);
        }
        | _nil
        {
            $$ = _vretained makeValue(OCValueNil);
        }
        | _NULL
        {
            $$ = _vretained makeValue(OCValueNULL);
        }
        | ASTERISK IDENTIFIER
        {
            $$ = _vretained makeValue(OCValuePointValue);
        }
        | AND IDENTIFIER
        {
            $$ = _vretained makeValue(OCValueVarPoint);
        }
        ;



assign_operator:
        ASSIGN
        {
            $$ = AssignOperatorAssign;
        }
        | AND_ASSIGN
        {
            $$ = AssignOperatorAssignAnd;
        }
        | OR_ASSIGN
        {
            $$ = AssignOperatorAssignOr;
        }
        | POWER_ASSIGN
        {
            $$ = AssignOperatorAssignXor;
        }
        | ADD_ASSIGN
        {
            $$ = AssignOperatorAssignAdd;
        }
        | SUB_ASSIGN
        {
            $$ = AssignOperatorAssignSub;
        }
        | DIV_ASSIGN
        {
            $$ = AssignOperatorAssignDiv;
        }
        | ASTERISK_ASSIGN
        {
            $$ = AssignOperatorAssignMuti;
        }
        | MOD_ASSIGN
        {
            $$ = AssignOperatorAssignMod;
        }
        ; 

unary_operator: 
        INCREMENT
        {
            $$ = UnaryOperatorIncrement;
        }
        | DECREMENT
        {
            $$ = UnaryOperatorDecrement;
        }
        ;

binary_operator:
        ADD
        {
            $$ = BinaryOperatorAdd;
        }
        | SUB
        {
            $$ = BinaryOperatorSub;
        }
        | ASTERISK
        {
            $$ = BinaryOperatorMulti;
        }
        | DIV
        {
            $$ = BinaryOperatorDiv;
        }
        | MOD
        {
            $$ = BinaryOperatorMod;
        }
        | SHIFTLEFT
        {
            $$ = BinaryOperatorShiftLeft;
        }
        | SHIFTRIGHT
        {
            $$ = BinaryOperatorShiftRight;
        }
        | AND
        {
            $$ = BinaryOperatorAnd;
        }
        | OR
        {
            $$ = BinaryOperatorOr;
        }
        | POWER
        {
            $$ = BinaryOperatorXor;
        }
        ;




ternary_expression:
        judgement_expression QUESTION value_expression COLON value_expression
        {
            TernaryExpression *expression = makeTernaryExpression();
            expression.judgeExpression = _transfer(JudgementExpression *)$1;
            [expression.values addObject:_transfer(id)$3];
            [expression.values addObject:_transfer(id)$5];
            $$ = _vretained expression;
        }
        | judgement_expression QUESTION COLON value_expression 
        {
            TernaryExpression *expression = makeTernaryExpression();
            expression.judgeExpression = _transfer(JudgementExpression *)$1;
            [expression.values addObject:_transfer(id)$4];
            $$ = _vretained expression;
        }
        ;

calculator_expression:
        value_expression binary_operator value_expression
        {
             BinaryExpression *expression = makeBinaryExpression($2);
             expression.left = _transfer(id) $1;
             expression.right = _transfer(id) $3;
             $$ = _vretained expression;
        }
        | value_expression unary_operator
        {
            UnaryExpression *expression = makeUnaryExpression($2);
            expression.value = _transfer(id) $1;
            $$ = _vretained expression;
        }
        | ternary_expression
        {
            log(@"ternary");
        }
        ;

judgement_operator:
        EQ
        {
            $$ = JudgementOperatorEQ;
        }
        | NE
        {
            $$ = JudgementOperatorNE;
        }
        | LE
        {
            $$ = JudgementOperatorLE;
        }
        | LT
        {
            $$ = JudgementOperatorLT;
        }
        | GE
        {
            $$ = JudgementOperatorGE;
        }
        | GT
        {
            $$ = JudgementOperatorGT;
        }
        | LOGIC_AND
        {
            $$ = JudgementOperatorAND;
        }
        | LOGIC_OR
        {
            $$ = JudgementOperatorOR;
        }
        ;

/*
FIXME
    if (x)
    if (!x)
*/
judgement_expression:
         LOGIC_NOT value_expression
         {
             JudgementExpression *expression = makeJudgementExpression(JudgementOperatorNOT);
             expression.left = _transfer(id) $2;
             $$ = _vretained expression;
         }
         |value_expression judgement_operator value_expression
         {
             JudgementExpression *expression = makeJudgementExpression($2);
             expression.left = _transfer(id) $1;
             expression.right = _transfer(id) $3;
             $$ = _vretained expression;
         }
        ;

value_expression:
        value_type
        | judgement_expression
        | calculator_expression
        | LP value_expression RP
        {
            $$ = $2;
        }
        ;

control_expression:
        _return
        {
            ControlExpression *expression = makeControlExpression(ControlExpressionReturn);
            $$ = _vretained expression;
        }
        | _return value_expression
        {
            ControlExpression *expression = makeControlExpression(ControlExpressionReturn);
            expression.expression = _transfer(id) $2;
            $$ = _vretained expression;
        }
        | _break
        {
            $$ = _vretained makeControlExpression(ControlExpressionBreak);
        }
        | _continue
        {
            $$ = _vretained makeControlExpression(ControlExpressionContinue);
        }
        | _goto IDENTIFIER COLON
        {
            $$ = _vretained makeControlExpression(ControlExpressionGoto);
        }
        ;

assign_expression:
        declare_assign_expression
        | var_assign_expression
        ;
declare_assign_expression:
        value_declare
        {
            DeclareAssignExpression *expression = makeDeaclareAssignExpression(_transfer(VariableDeclare *) $1);
            $$ = _vretained expression;
        }
        | value_declare ASSIGN value_expression
        {
            DeclareAssignExpression *expression = makeDeaclareAssignExpression(_transfer(VariableDeclare *) $1);
            expression.expression = _transfer(id) $3;
            $$ = _vretained expression;
        }
        ;
var_assign_expression: 
        value_type assign_operator value_expression
        {
            VariableAssignExpression *expression = makeVarAssignExpression($2);
            expression.expression = _transfer(id) $3;
            expression.value = _transfer(OCValue *)$1;
            $$ = _vretained expression;
        }
        ;

expression:
        assign_expression
        | value_expression
        | control_expression
        ;

if_statement:
         IF LP value_expression RP function_implementation
         {
            IfStatement *statement = makeIfStatement(_transfer(id) $3,_transfer(FunctionImp *)$4);
            $$ = _vretained statement;
         }
        | if_statement _else IF LP value_expression RP function_implementation
        {
            IfStatement *statement = _transfer(IfStatement *)$1;
            IfStatement *elseIfStatement = makeIfStatement(_transfer(id) $5,_transfer(FunctionImp *)$7);
            elseIfStatement.last = statement;
            $$  = _vretained elseIfStatement;
        }
        | if_statement _else function_implementation
        {
            IfStatement *statement = _transfer(IfStatement *)$1;
            IfStatement *elseStatement = makeIfStatement(nil,_transfer(FunctionImp *)$3);
            elseStatement.last = statement;
            $$  = _vretained elseStatement;
        }
        ;

dowhile_statement: 
        _do function_implementation _while LP value_expression RP
        {
            DoWhileStatement *statement = makeDoWhileStatement(_transfer(id)$5,_transfer(FunctionImp *)$2);
            $$ = _vretained statement;
        }
        ;
while_statement:
        _while LP value_expression RP function_implementation
        {
            WhileStatement *statement = makeWhileStatement(_transfer(id)$3,_transfer(FunctionImp *)$5);
            $$ = _vretained statement;
        }
        ;
/*
FIXME:
    case condition:
        int x = 0;
        // .... 不含有{ } 
        break;

*/
case_statement:
         _case value_type COLON
         {
             $$ = _vretained makeCaseStatement(_transfer(OCValue *)$2);
         }
        | _default COLON
        {
            $$ = _vretained makeCaseStatement(nil);
        }
        | case_statement function_implementation
        {
            CaseStatement *statement =  _transfer(CaseStatement *)$1;
            statement.funcImp = _transfer(FunctionImp *) $2;
            $$ = _vretained statement;
        }
        ;
switch_statement:
         _switch LP value_type RP LC
         {
             SwitchStatement *statement = makeSwitchStatement(_transfer(id) $3);
             $$ = _vretained statement;
         }
        | switch_statement case_statement
        {
            SwitchStatement *statement = _transfer(SwitchStatement *)$1;
            [statement.cases addObject:_transfer(id) $2];
            $$ = _vretained statement;
        }
        | switch_statement RC
        ;
/*
FIXME
    int x = 0;
    for(x; x < value; x ++){}
*/
for_parameter_list:
        expression
        {
            NSMutableArray *expressions = [NSMutableArray array];
            [expressions addObject:_transfer(id)$1];
            $$ = _vretained expressions;
        }
        | for_parameter_list SEMICOLON expression
        {
            NSMutableArray *expressions = _transfer(NSMutableArray *)$$;
            [expressions addObject:_transfer(id) $3];
            $$ = _vretained expressions;
        }
        ;
for_statement: _for LP for_parameter_list RP function_implementation
        {
            ForStatement* statement = makeForStatement(_transfer(FunctionImp *) $5);
            statement.expressions = _transfer(NSMutableArray *) $3;
            $$ = _vretained statement;
        }
        ;

forin_statement: _for LP value_declare _in value_type RP function_implementation
        {
            ForInStatement * statement = makeForInStatement(_transfer(FunctionImp *)$7);
            statement.declare = _transfer(id) $3;
            statement.value = _transfer(id)$5;
            $$ = _vretained statement;
        }
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
        {
            $$ = _vretained makeFuncImp();
        }
        | function_implementation expression SEMICOLON
        {
            FunctionImp *imp = _transfer(FunctionImp *)$1;
            [imp.statements addObject:_transfer(id) $2];
            $$ = _vretained imp;
        }
        | function_implementation control_statement
        {
            FunctionImp *imp = _transfer(FunctionImp *)$1;
            [imp.statements addObject:_transfer(id) $2];
            $$ = _vretained imp;
        }
        | function_implementation RC
        {
            $$ = $1;
        }
        ;
        

%%
int yyerror(char *s){
    extern unsigned long lex_read_line;
    extern char const *st_source_string;
    NSArray *lines = [[NSString stringWithUTF8String:st_source_string] componentsSeparatedByString:@"\n"];
    
    NSString *errorInfo = [NSString stringWithFormat:@"------yyerror------\nline:%lu\nsource:%s \nerror: %s\n-------------------\n",lex_read_line,[lines[lex_read_line - 1] UTF8String],s];
    OCParser.error = errorInfo;
    log(OCParser.error);
    return 0;
}

