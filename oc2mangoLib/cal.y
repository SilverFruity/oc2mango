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
extern int yylex (void);
extern void yyerror(const char *s);
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
%token <identifier> QUESTION  _return _break _continue _goto _else  _while _do _in _for _case _switch _default _enum _typeof _struct
%token <identifier> INTERFACE IMPLEMENTATION PROTOCOL END CLASS_DECLARE
%token <identifier> PROPERTY WEAK STRONG COPY ASSIGN_MEM NONATOMIC ATOMIC READONLY READWRITE NONNULL NULLABLE 
%token <identifier> EXTERN STATIC CONST _NONNULL _NULLABLE _STRONG _WEAK _BLOCK
%token <identifier> IDENTIFIER STRING_LITERAL
%token <identifier> COMMA COLON SEMICOLON  LP RP RIP LB RB LC RC DOT AT PS
%token <identifier> EQ NE LT LE GT GE LOGIC_AND LOGIC_OR LOGIC_NOT
%token <identifier> AND OR POWER SUB ADD DIV ASTERISK AND_ASSIGN OR_ASSIGN POWER_ASSIGN SUB_ASSIGN ADD_ASSIGN DIV_ASSIGN ASTERISK_ASSIGN INCREMENT DECREMENT
SHIFTLEFT SHIFTRIGHT MOD ASSIGN MOD_ASSIGN
%token <identifier> _self _super _nil _NULL _YES _NO 
%token <identifier>  _Class _id _void _BOOL _SEL _CHAR _SHORT _INT _LONG _LLONG  _UCHAR _USHORT _UINT _ULONG  _ULLONG _DOUBLE _FLOAT _instancetype
%token <identifier> INTETER_LITERAL DOUBLE_LITERAL SELECTOR 
%type  <identifier> class_property_type declare_left_attribute declare_right_attribute
%type  <include> PS_Define includeHeader
%type  <declare>  class_declare protocol_list class_private_varibale_declare
%type  <declare>  class_property_declare method_declare
%type  <declare>  value_declare block_declare func_declare_parameters 
%type  <type> value_declare_type block_parametere_type block_type method_caller_type  object_value_type objc_method_call 
%type  <implementation> class_implementation  
%type  <expression> value_type numerical_value_type block_implementation declare_assign_expression var_assign_expression
 ternary_expression calculator_expression judgement_expression value_expression assign_expression  function_implementation  control_expression
expression objc_method_call_pramameters objc_method_get value_expression_list for_parameter_list
%type <Operator> judgement_operator binary_operator unary_operator assign_operator value_get_operator
%type <statement> if_statement while_statement dowhile_statement switch_statement for_statement forin_statement case_statement control_statement
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
// TODO: Global
// TODO: C func declare && implementation
            | value_declare_type IDENTIFIER LP func_declare_parameters RP  SEMICOLON
            | value_declare_type IDENTIFIER LP func_declare_parameters RP  LC function_implementation RC
            {
                BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
                imp.declare = makeFuncDeclare(_transfer(id)$2,_transfer(id)$4);
                imp.funcImp = _transfer(id)$7;
                [LibAst.globalStatements addObject:_transfer(id) $1];
            }
            | expression SEMICOLON
            {
                [LibAst.globalStatements addObject:_transfer(id) $1];
            }
            | control_statement
            {
                [LibAst.globalStatements addObject:_transfer(id) $1];
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
            //
            INTERFACE IDENTIFIER COLON IDENTIFIER
            {
                OCClass *occlass = [LibAst classForName:_transfer(id)$2];
                occlass.superClassName = _transfer(id)$4;
                $$ = _vretained occlass;
            }
            // category 
            | INTERFACE IDENTIFIER LP IDENTIFIER RP
            {
                $$ = _vretained [LibAst classForName:_transfer(id)$2];
            }
            | INTERFACE IDENTIFIER LP RP
            {
                $$ = _vretained [LibAst classForName:_transfer(id)$2];
            }
            | class_declare LT protocol_list GT
            {
                OCClass *occlass = _transfer(OCClass *) $1;
                occlass.protocols = _transfer(id) $3;
                $$ = _vretained occlass;
            }
            | class_declare class_private_varibale_declare
            {
                OCClass *occlass = _transfer(OCClass *) $1;
                [occlass.privateVariables addObjectsFromArray:_transfer(id) $2];
                $$ = _vretained occlass;
            }
            | class_declare PROPERTY class_property_declare value_declare SEMICOLON
            {
                OCClass *occlass = _transfer(OCClass *) $1;

                PropertyDeclare *property = [PropertyDeclare new];
                property.keywords = _transfer(NSMutableArray *) $3;
                property.var = _transfer(VariableDeclare *) $4;
                
                [occlass.properties addObject:property];
                $$ = _vretained occlass;
            }
            // 方法声明，不做处理
            | class_declare method_declare SEMICOLON
            | class_declare END
            ;
class_implementation:
            IMPLEMENTATION IDENTIFIER
            {
                $$ = _vretained [LibAst classForName:_transfer(id)$2];
            }
            // category
            | IMPLEMENTATION IDENTIFIER LP IDENTIFIER RP
            {
                $$ = _vretained [LibAst classForName:_transfer(id)$2];
            }
            | class_implementation class_private_varibale_declare
            {
                OCClass *occlass = _transfer(OCClass *) $1;
                [occlass.privateVariables addObjectsFromArray:_transfer(id) $2];
                $$ = _vretained occlass;
            }
            | class_implementation method_declare LC function_implementation RC
            {
                MethodImplementation *imp = makeMethodImplementation(_transfer(MethodDeclare *) $2);
                imp.imp = _transfer(FunctionImp *) $4;
                OCClass *occlass = _transfer(OCClass *) $1;
                [occlass.methods addObject:imp];
                $$ = _vretained occlass;
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
            | NONNULL
            | NULLABLE
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
            | _id LE IDENTIFIER GT
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
            | IDENTIFIER
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeObject,(__bridge NSString *)$1);
            }
            // FIXME: implementation typeof type
            | _typeof LP value_expression RP
            {
                $$ = _vretained makeTypeSpecial(SpecialTypeObject,@"typeof");
            }
            // FIXME: id <protocol>
            | value_declare_type LT IDENTIFIER GT
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
            | declare_left_attribute value_declare_type
            {
                $$ = $2;
            }
            | value_declare_type declare_right_attribute
            ;

declare_left_attribute:
            EXTERN
            | STATIC
            | CONST
            | NONNULL
            | NULLABLE
            | _STRONG
            | _WEAK
            | _BLOCK
            ;
declare_right_attribute:
            _NONNULL
            | _NULLABLE
            | CONST
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
            {
                $$ = _vretained [NSMutableArray array];
            }
            | block_parametere_type
            {
                NSMutableArray *array = [NSMutableArray array];
                [array addObject:_transfer(id)$1];
                $$ = _vretained array;
            }
            | func_declare_parameters COMMA block_parametere_type 
            {
                NSMutableArray *array = _transfer(NSMutableArray *)$1;
                [array addObject:_transfer(id) $3];
                $$ = _vretained array;
            }
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
value_get_operator:
             DOT
            | SUB GT
            ;
objc_method_get:
         object_value_type value_get_operator IDENTIFIER
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
         | object_value_type value_get_operator IDENTIFIER LP value_expression_list RP
         {
             OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
             OCValue *caller = _transfer(OCValue *)$1;
             methodcall.caller = caller;

             OCMethodCallGetElement *element = makeMethodCallElement(OCMethodCallDotGet);
             element.name = _transfer(NSString *)$3;
             [element.values addObjectsFromArray:_transfer(id) $5];
             methodcall.element = element;

             $$ = _vretained methodcall;
         }
         // Get
         | objc_method_get value_get_operator IDENTIFIER
         {
             OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
             methodcall.caller =  _transfer(OCValue *)$1;

             OCMethodCallGetElement *element = makeMethodCallElement(OCMethodCallDotGet);
             element.name = _transfer(NSString *)$3;
             methodcall.element = element;

             $$ = _vretained methodcall;
         }
         // Block Get
         | objc_method_get value_get_operator IDENTIFIER LP value_expression_list RP
         {
             OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
             methodcall.caller =  _transfer(OCValue *)$1;

             OCMethodCallGetElement *element = makeMethodCallElement(OCMethodCallDotGet);
             element.name = _transfer(NSString *)$3;
             [element.values addObjectsFromArray:_transfer(id) $5];
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
        | IDENTIFIER COLON value_expression_list
        {
            OCMethodCallNormalElement *element = makeMethodCallElement(OCMethodCallNormalCall);
            [element.names addObject:_transfer(NSString *)$1];
            [element.values addObjectsFromArray:_transfer(id)$3];
            $$ = _vretained element;
        }
        | objc_method_call_pramameters IDENTIFIER COLON value_expression_list
        {
            OCMethodCallNormalElement *element = _transfer(OCMethodCallNormalElement *)$1;
            [element.names addObject:_transfer(NSString *)$2];
            [element.values addObjectsFromArray:_transfer(id)$4];
            $$ = _vretained element;
        }
        ;
/*
 FIXME:
 1. self->var
 2. struct NAME var; var.name = xxx; var->name = xxx;
 */
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
        //^returnType{ }
        POWER value_declare_type LC function_implementation RC
        {
            BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
            imp.funcImp = _transfer(id)$4;
            imp.declare = makeFuncDeclare(_transfer(id)$2,nil);
            $$ = _vretained imp; 
        }
        //^returnType(int x, int y, int z){  }
        | POWER value_declare_type LP func_declare_parameters RP LC function_implementation RC
        {
            BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
            imp.declare = makeFuncDeclare(_transfer(id)$2,_transfer(id)$4);
            imp.funcImp = _transfer(id)$7;
            $$ = _vretained imp; 
        }
        //^{   }
        | POWER LC function_implementation RC
        {
            BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
            imp.declare = makeFuncDeclare(makeTypeSpecial(SpecialTypeVoid),nil);
            imp.funcImp = _transfer(id)$3;
            $$ = _vretained imp; 
        }
        //^(int x, int y){    }
        | POWER LP func_declare_parameters RP LC function_implementation RC
        {
            BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
            imp.declare = makeFuncDeclare(makeTypeSpecial(SpecialTypeVoid),_transfer(id) $3);
            imp.funcImp = _transfer(id)$6;
            $$ = _vretained imp; 
        }
        ;
object_value_type:
        IDENTIFIER
        {
            $$ = _vretained makeValue(OCValueObject,_transfer(id)$1);
        }
        | _self
        {
            $$ = _vretained makeValue(OCValueSelf,_transfer(id)$1);
        }
        | _super
        {
            $$ = _vretained makeValue(OCValueSuper,_transfer(id)$1);
        }
        // NSDictionary
        // NSArray
        | AT LP value_expression RP 
        {
            $$ = _vretained makeValue(OCValueNSNumber,_transfer(id)$3);
        }
        | AT numerical_value_type
        {
            $$ = _vretained makeValue(OCValueNSNumber,_transfer(id)$2);
        }
// FIXME: NSString
        | AT STRING_LITERAL
        {
//            $$ = _vretained makeValue(OCValueString,_transfer(id)$2);
            $$ = _vretained makeValue(OCValueString);
        }
        | objc_method_call
        // FIXME:  C func call
        | IDENTIFIER LP value_expression_list RP
        {
            CFuncCall *call = makeValue(OCValueFuncCall);
            call.name = _transfer(id) $1;
            call.expressions = _transfer(id) $3;
            $$ = _vretained call;
        }
        ;

numerical_value_type:
          INTETER_LITERAL
        | DOUBLE_LITERAL
        ;


value_type:
        object_value_type
        | SELECTOR
        {
            $$ = _vretained makeValue(OCValueSelector,_transfer(id)$1);
        }
        | PROTOCOL LP IDENTIFIER RP
        {
            $$ = _vretained makeValue(OCValueProtocol,_transfer(id)$3);
        }
        | STRING_LITERAL
        {
            $$ = _vretained makeValue(OCValueCString,_transfer(id)$1);
        }
        | block_implementation
        | numerical_value_type
        {
            $$ = _vretained makeValue(OCValueNumber,_transfer(id)$1);
        }
        | LP value_declare_type RP value_type
        {
            $$ = _vretained makeValue(OCValueConvert,_transfer(id)$4);
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
            $$ = _vretained makeValue(OCValuePointValue,_transfer(id)$2);
        }
        | AND IDENTIFIER
        {
            $$ = _vretained makeValue(OCValueVarPoint,_transfer(id)$2);
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
 FIXME:
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
         value_expression
        | assign_expression
        | control_expression
        ;

if_statement:
         IF LP value_expression RP LC function_implementation RC
         {
            IfStatement *statement = makeIfStatement(_transfer(id) $3,_transfer(FunctionImp *)$5);
            $$ = _vretained statement;
         }
        | if_statement _else IF LP value_expression RP LC function_implementation RC
        {
            IfStatement *statement = _transfer(IfStatement *)$1;
            IfStatement *elseIfStatement = makeIfStatement(_transfer(id) $5,_transfer(FunctionImp *)$8);
            elseIfStatement.last = statement;
            $$  = _vretained elseIfStatement;
        }
        | if_statement _else LC function_implementation RC
        {
            IfStatement *statement = _transfer(IfStatement *)$1;
            IfStatement *elseStatement = makeIfStatement(nil,_transfer(FunctionImp *)$4);
            elseStatement.last = statement;
            $$  = _vretained elseStatement;
        }
        ;

dowhile_statement: 
        _do LC function_implementation RC _while LP value_expression RP
        {
            DoWhileStatement *statement = makeDoWhileStatement(_transfer(id)$5,_transfer(FunctionImp *)$3);
            $$ = _vretained statement;
        }
        ;
while_statement:
        _while LP value_expression RP LC function_implementation RC
        {
            WhileStatement *statement = makeWhileStatement(_transfer(id)$3,_transfer(FunctionImp *)$6);
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
        | case_statement LC function_implementation RC
        {
            CaseStatement *statement =  _transfer(CaseStatement *)$1;
            statement.funcImp = _transfer(FunctionImp *) $3;
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
 FIXME:
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
for_statement: _for LP for_parameter_list RP LC function_implementation RC
        {
            ForStatement* statement = makeForStatement(_transfer(FunctionImp *) $6);
            statement.expressions = _transfer(NSMutableArray *) $3;
            $$ = _vretained statement;
        }
        ;

forin_statement: _for LP value_declare _in value_type RP LC function_implementation RC
        {
            ForInStatement * statement = makeForInStatement(_transfer(FunctionImp *)$8);
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
        ;
        

%%
void yyerror(const char *s){
    extern unsigned long yylineno , yycolumn , yylen;
    extern char const *st_source_string;
    NSArray *lines = [[NSString stringWithUTF8String:st_source_string] componentsSeparatedByString:@"\n"];
    if(lines.count < yylineno) return;
    NSString *line = lines[yylineno - 1];
    unsigned long location = yycolumn - yylen - 1;
    unsigned long len = yylen;
    NSMutableString *str = [NSMutableString string];
    for (unsigned i = 0; i < location; i++){
        [str appendString:@" "];
    }
    for (unsigned i = 0; i < len; i++){
        [str appendString:@"^"];
    }
    NSString *errorInfo = [NSString stringWithFormat:@"\n------yyerror------\n%@\n%@\n error: %s\n-------------------\n",line,str,s];
    OCParser.error = errorInfo;
    log(OCParser.error);

}

