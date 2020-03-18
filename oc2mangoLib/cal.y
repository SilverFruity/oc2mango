%{
#import <Foundation/Foundation.h>
#import "Log.h"
#import "MakeDeclare.h"
#import "Parser.h"
#define YYDEBUG 1
#define YYERROR_VERBOSE
#define _retained(IDENTIFIER) (__bridge_retained IDENTIFIER)
#define _vretained _retained(void *)
#define _transfer(IDENTIFIER) (__bridge_transfer IDENTIFIER)
#define _typeId _transfer(id)
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
    int IntValue;
}

%token <identifier> IDENTIFIER  STRING_LITERAL TYPEDEF ELLIPSIS CHILD_COLLECTION POINT
%token <identifier> IF ENDIF IFDEF IFNDEF UNDEF IMPORT INCLUDE  TILDE 
%token <identifier> QUESTION  _return _break _continue _goto _else  _while _do _in _for _case _switch _default TYPEOF __TYPEOF  _sizeof
%token <identifier> INTERFACE IMPLEMENTATION DYNAMIC PROTOCOL END CLASS_DECLARE 
%token <identifier> PROPERTY WEAK STRONG COPY ASSIGN_MEM NONATOMIC ATOMIC READONLY READWRITE NONNULL NULLABLE 
%token <identifier> EXTERN STATIC CONST _NONNULL _NULLABLE _STRONG _WEAK _BLOCK _BRIDGE _AUTORELEASE _BRIDGE_TRANSFER _BRIDGE_RETAINED _UNUSED
%token <identifier> COMMA COLON SEMICOLON  LP RP RIP LB RB LC RC DOT AT PS ARROW
%token <identifier> EQ NE LT LE GT GE LOGIC_AND LOGIC_OR NOT
%token <identifier> AND OR POWER SUB ADD DIV ASTERISK AND_ASSIGN OR_ASSIGN POWER_ASSIGN SUB_ASSIGN ADD_ASSIGN DIV_ASSIGN ASTERISK_ASSIGN INCREMENT DECREMENT
SHIFTLEFT SHIFTRIGHT MOD ASSIGN MOD_ASSIGN
%token <identifier> _self _super _nil _NULL _YES _NO 
%token <identifier>  _Class _id _void _BOOL _SEL _CHAR _SHORT _INT _LONG _LLONG  _UCHAR _USHORT _UINT _ULONG  _ULLONG _DOUBLE _FLOAT _instancetype
%token <identifier> INTETER_LITERAL DOUBLE_LITERAL SELECTOR 
%type  <identifier> class_property_type declare_left_attribute declare_right_attribute
%type  <identifier> global_define 
%type  <declare>  protocol_declare class_declare protocol_list class_private_varibale_declare
%type  <declare>  class_property_declare method_declare
%type  <declare>  parameter_declaration  type_specifier  parameter_list CHILD_COLLECTION_OPTIONAL
%type  <implementation> class_implementation
%type  <expression> objc_method_call primary_expression numerical_value_type block_implementation  function_implementation  objc_method_call_pramameters  expression_list  unary_expression postfix_expression
%type <Operator>  assign_operator unary_operator
%type <statement> expression_statement if_statement while_statement dowhile_statement switch_statement for_statement forin_statement  case_statement_list control_statement  case_statement
%type <expression> expression  assign_expression ternary_expression logic_or_expression multiplication_expression additive_expression bite_shift_expression equality_expression bite_and_expression bite_xor_expression  relational_expression bite_or_expression logic_and_expression dict_entrys
%type <expression> declaration init_declarator declarator declarator_optional direct_declarator direct_declarator_optional init_declarator_list  block_parameters_optinal parameter_type_list
%type <IntValue> pointer pointer_optional
%%

compile_util: /*empty*/
			| definition_list
			;
definition_list: definition
            | definition_list definition
            ;
definition:
            global_define
            | class_declare
            | protocol_declare
            | class_implementation
            | expression_statement
            {
                [LibAst addGlobalStatements:_typeId $1];
            }
            | control_statement
            {
                [LibAst addGlobalStatements:_typeId $1];
            }
	    ;
global_define:
            CLASS_DECLARE IDENTIFIER SEMICOLON
          | PROTOCOL IDENTIFIER SEMICOLON
          | type_specifier declarator SEMICOLON
          | type_specifier declarator LC function_implementation RC
        //   {
        //       NSString *name = _typeId $2;
        //       BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
        //       imp.declare = makeFuncDeclare(_typeId $1,_typeId $4,name);
        //       [imp copyFromImp:_typeId $7];
        //       [LibAst addGlobalStatements:imp];
        //   }
          ;

protocol_declare:
            PROTOCOL IDENTIFIER CHILD_COLLECTION
            | protocol_declare PROPERTY class_property_declare parameter_declaration SEMICOLON
            | protocol_declare method_declare SEMICOLON
            | protocol_declare END
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
            | class_declare LC class_private_varibale_declare RC
            {
                OCClass *occlass = _transfer(OCClass *) $1;
                [occlass.privateVariables addObjectsFromArray:_transfer(id) $3];
                $$ = _vretained occlass;
            }
            | class_declare PROPERTY class_property_declare parameter_declaration SEMICOLON
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
            | class_implementation LC class_private_varibale_declare RC
            {
                OCClass *occlass = _transfer(OCClass *) $1;
                [occlass.privateVariables addObjectsFromArray:_transfer(id) $3];
                $$ = _vretained occlass;
            }
            | class_implementation method_declare LC function_implementation RC
            {
                MethodImplementation *imp = makeMethodImplementation(_transfer(MethodDeclare *) $2);
                imp.imp = _transfer(BlockImp *) $4;
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

class_private_varibale_declare: // empty
            {
                NSMutableArray *list = [NSMutableArray array];
				$$ = (__bridge_retained void *)list;
            }
            | class_private_varibale_declare parameter_declaration SEMICOLON
            {
                NSMutableArray *list = _transfer(NSMutableArray *) $1;
				[list addObject:_transfer(VariableDeclare *) $2];
				$$ = (__bridge_retained void *)list;
            }
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



declare_left_attribute:
            EXTERN
            | STATIC
            | CONST
            | NONNULL
            | NULLABLE
            | _STRONG
            | _WEAK
            | _BLOCK
            | _BRIDGE
            | _BRIDGE_RETAINED
            | _BRIDGE_TRANSFER
            ;
declare_right_attribute:
            _NONNULL
            | _NULLABLE
            | CONST
            | _AUTORELEASE
            | _UNUSED
            ;


method_declare:
            SUB LP parameter_declaration RP
            {   
                VariableDeclare *declare = _transfer(VariableDeclare *)$3;
                $$ = _vretained makeMethodDeclare(NO,declare.type);
            }
            | ADD LP parameter_declaration RP
            {
                VariableDeclare *declare = _transfer(VariableDeclare *)$3;
                $$ = _vretained makeMethodDeclare(YES,declare.type);
            }
            | method_declare IDENTIFIER
            {
                MethodDeclare *method = _transfer(MethodDeclare *)$$;
                [method.methodNames addObject:_transfer(NSString *) $2];
                $$ = _vretained method;
            }
            | method_declare IDENTIFIER COLON LP parameter_declaration RP IDENTIFIER
            {
                VariableDeclare *declare = _transfer(VariableDeclare *)$5;
                MethodDeclare *method = _transfer(MethodDeclare *)$$;
                [method.methodNames addObject:_transfer(NSString *) $2];
                [method.parameterTypes addObject:declare.type];
                [method.parameterNames addObject:_transfer(NSString *) $7];
                $$ = _vretained method;
            }
            ;

objc_method_call_pramameters:
        IDENTIFIER
        {
            NSMutableArray *names = [@[_typeId $1] mutableCopy];
            $$ = _vretained @[names,[NSMutableArray array]];
        }
        | IDENTIFIER COLON expression_list
        {
            NSMutableArray *names = [@[_typeId $1] mutableCopy];
            NSMutableArray *values = _typeId $3;
            $$ = _vretained @[names,values];
        }
        | objc_method_call_pramameters IDENTIFIER COLON expression_list
        {
            NSArray *array = _transfer(id)$1;
            NSMutableArray *names = array[0];
            NSMutableArray *values = array[1];
            [names addObject:_transfer(NSString *)$2];
            [values addObjectsFromArray:_transfer(id)$4];
            $$ = _vretained array;
        }
        ;

objc_method_call:
         LB IDENTIFIER objc_method_call_pramameters RB
        {
             OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
             methodcall.caller =  makeValue(OCValueClassType,_typeId $2);
             NSArray *params = _transfer(NSArray *)$3;
             methodcall.names = params[0];
             methodcall.values = params[1];
             $$ = _vretained methodcall;
        }
        | LB postfix_expression objc_method_call_pramameters RB
        {
             OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
             OCValue *caller = _transfer(OCValue *)$2;
             methodcall.caller =  caller;
             NSArray *params = _transfer(NSArray *)$3;
             methodcall.names = params[0];
             methodcall.values = params[1];
             $$ = _vretained methodcall;
        }
        ;
block_parameters_optinal:
    {
        $$ = _vretained [NSMutableArray array];
    }
    | LP parameter_list RP
    {
        $$ = _vretained (__bridge NSMutableArray *)$2;
    }
    ;
block_implementation:
        //^returnType(optional) parameters(optional){ }
        POWER type_specifier declarator block_parameters_optinal LC function_implementation RC
        {
            FuncDeclare *declare = makeFuncDeclare( _typeId $2,_typeId $3);
            BlockImp *imp = _transfer(BlockImp *) $5;
            imp.declare = declare;
            $$ = _vretained imp;
        }
        ;


expression: assign_expression;

expression_statement:
          assign_expression SEMICOLON
        | declaration SEMICOLON
        |_return SEMICOLON
        {
            $$ = _vretained makeReturnStatement(nil);
        }
        | _return expression SEMICOLON
        {
            $$ = _vretained makeReturnStatement(_transfer(id)$2);
        }
        | _break SEMICOLON
        {
            $$ = _vretained makeBreakStatement();
        }
        | _continue SEMICOLON
        {
            $$ = _vretained makeContinueStatement();
        }
        ;

if_statement:
         IF LP expression RP LC function_implementation RC
         {
            IfStatement *statement = makeIfStatement(_transfer(id) $3,_transfer(BlockImp *)$6);
            $$ = _vretained statement;
         }
        | if_statement _else IF LP expression RP LC function_implementation RC
        {
            IfStatement *statement = _transfer(IfStatement *)$1;
            IfStatement *elseIfStatement = makeIfStatement(_transfer(id) $5,_transfer(BlockImp *)$8);
            elseIfStatement.last = statement;
            $$  = _vretained elseIfStatement;
        }
        | if_statement _else LC function_implementation RC
        {
            IfStatement *statement = _transfer(IfStatement *)$1;
            IfStatement *elseStatement = makeIfStatement(nil,_transfer(BlockImp *)$4);
            elseStatement.last = statement;
            $$  = _vretained elseStatement;
        }
        ;

dowhile_statement: 
        _do LC function_implementation RC _while LP expression RP
        {
            DoWhileStatement *statement = makeDoWhileStatement(_transfer(id)$7,_transfer(BlockImp *)$3);
            $$ = _vretained statement;
        }
        ;
while_statement:
        _while LP expression RP LC function_implementation RC
        {
            WhileStatement *statement = makeWhileStatement(_transfer(id)$3,_transfer(BlockImp *)$6);
            $$ = _vretained statement;
        }
        ;

case_statement:
        _case primary_expression COLON
        {
             CaseStatement *statement = makeCaseStatement(_typeId $2);
            $$ = _vretained statement;
        }
        | _default COLON
        {
            CaseStatement *statement = makeCaseStatement(nil);
            $$ = _vretained statement;
        }
        | case_statement expression_statement
        {
            CaseStatement *statement =  _typeId $1;
            [statement.funcImp addStatements:_typeId $2];
            $$ = _vretained statement;
        }
        | case_statement LC function_implementation RC
        {
            CaseStatement *statement =  _transfer(CaseStatement *)$1;
            statement.funcImp = _transfer(BlockImp *) $3;
            $$ = _vretained statement;
        }
        ;
case_statement_list:
            {
                $$ = _vretained [NSMutableArray array];
            }
            | case_statement_list case_statement
            {
                NSMutableArray *array = _typeId $1;
                [array addObject: _typeId $2];
                $$ = _vretained array;
            }
            ;
switch_statement:
         _switch LP expression RP LC case_statement_list RC
         {
             SwitchStatement *statement = makeSwitchStatement(_transfer(id) $3);
             statement.cases = _typeId $6;
             $$ = _vretained statement;
         }
        ;
for_statement: _for LP declaration SEMICOLON expression SEMICOLON expression_list RP LC function_implementation RC
        {
            ForStatement* statement = makeForStatement(_transfer(BlockImp *) $10);
            statement.declareExpressions = _typeId $3;
            statement.condition = _typeId $5;
            statement.expressions = _typeId $7;
            $$ = _vretained statement;
        }
        ;

forin_statement: _for LP declaration _in expression RP LC function_implementation RC
        {
            ForInStatement * statement = makeForInStatement(_transfer(BlockImp *)$8);
            NSArray *exps = _typeId $3;
            statement.expression = exps[0];
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
            $$ = _vretained makeValue(OCValueBlock);
        }
        | function_implementation expression_statement 
        {
            BlockImp *imp = _transfer(BlockImp *)$1;
            [imp addStatements:_transfer(id) $2];
            $$ = _vretained imp;
        }
        | function_implementation control_statement
        {
            BlockImp *imp = _transfer(BlockImp *)$1;
            [imp addStatements:_transfer(id) $2];
            $$ = _vretained imp;
        }
        ;
        

expression_list:
        {
            $$ = _vretained [NSMutableArray array];
        }
        | expression
        {
            NSMutableArray *list = [NSMutableArray array];
            [list addObject:_transfer(id)$1];
            $$ = _vretained list;
        }
        | expression_list COMMA expression
        {
            NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
            [list addObject:_transfer(id) $3];
            $$ = _vretained list;
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

// = /= %= /= *=  -= += <<= >>= &= ^= |= 
assign_expression: ternary_expression
    | unary_expression assign_operator assign_expression
    {
        AssignExpression *expression = makeAssignExpression($2);
        expression.expression = _transfer(id) $3;
        expression.value = _transfer(OCValue *)$1;
        $$ = _vretained expression;
    }
;

// ?:
ternary_expression: logic_or_expression
    | logic_or_expression QUESTION ternary_expression COLON ternary_expression
    {
        TernaryExpression *expression = makeTernaryExpression();
        expression.expression = _transfer(id)$1;
        [expression.values addObject:_transfer(id)$3];
        [expression.values addObject:_transfer(id)$5];
        $$ = _vretained expression;
    }
    | logic_or_expression QUESTION COLON ternary_expression
    {
        TernaryExpression *expression = makeTernaryExpression();
        expression.expression = _transfer(id)$1;
        [expression.values addObject:_transfer(id)$4];
        $$ = _vretained expression;
    }
    ;


// ||
logic_or_expression: logic_and_expression
    | logic_or_expression LOGIC_OR logic_or_expression
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorLOGIC_OR);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    ;

// &&
logic_and_expression: bite_or_expression
    | logic_and_expression LOGIC_AND bite_or_expression
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorLOGIC_AND);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    ;
// |
bite_or_expression: bite_xor_expression
    | bite_or_expression OR bite_xor_expression
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorOr);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    ;
// ^
bite_xor_expression: bite_and_expression
    | bite_xor_expression POWER bite_and_expression
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorXor);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    ;

// &
bite_and_expression: equality_expression
    | bite_and_expression AND equality_expression
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorAnd);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    ;

// == !=
equality_expression: relational_expression
    | equality_expression EQ relational_expression
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorEqual);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    | equality_expression NE relational_expression
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorNotEqual);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
;
// < <= > >=
relational_expression: bite_shift_expression
    | relational_expression LT bite_shift_expression
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorLT);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    | relational_expression LE bite_shift_expression
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorLE);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    | relational_expression GT bite_shift_expression
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorGT);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    | relational_expression GE bite_shift_expression
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorGE);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    ;
// >> <<
bite_shift_expression: additive_expression
    | bite_shift_expression SHIFTLEFT additive_expression
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorShiftLeft);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    | bite_shift_expression SHIFTRIGHT additive_expression
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorShiftRight);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    ;
// + -
additive_expression: multiplication_expression
    | additive_expression ADD multiplication_expression
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorAdd);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    | additive_expression SUB multiplication_expression
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorSub);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    ;

// * / %
multiplication_expression: unary_expression
    | multiplication_expression ASTERISK unary_expression
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorMulti);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    | multiplication_expression DIV unary_expression
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorDiv);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    | multiplication_expression MOD unary_expression
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorMod);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    ;

// !x -x *x &x ~x sizof(x) (IDENTIFIER)x x++ x-- ++x --x
unary_expression: postfix_expression
    | unary_operator unary_expression
    {
        UnaryExpression *exp = makeUnaryExpression($1);
        exp.value = _transfer(id)$2;
        $$ = _vretained exp;
    }
    | _sizeof unary_expression
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorSizeOf);
        exp.value = _transfer(id)$2;
        $$ = _vretained exp;
    }
    | LP parameter_declaration RP unary_expression
    {
        $$ = $4;
    }
    | INCREMENT unary_expression
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorIncrementPrefix);
        exp.value = _transfer(id)$2;
        $$ = _vretained exp;
    }
    | DECREMENT unary_expression
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorDecrementPrefix);
        exp.value = _transfer(id)$2;
        $$ = _vretained exp;
    }
    ;

unary_operator: 
    AND
    {
        $$ = UnaryOperatorAdressPoint;
    }
    | POINT
    {
        $$ = UnaryOperatorAdressValue;
    }
    | ASTERISK
    {
        $$ = UnaryOperatorAdressValue;
    }
    | SUB
    {
        $$ = UnaryOperatorNegative;
    }
    | TILDE
    {
        $$ = UnaryOperatorBiteNot;
    }
    | NOT
    {
        $$ = UnaryOperatorNot;
    }
    ;

postfix_expression: primary_expression
    | postfix_expression INCREMENT
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorIncrementSuffix);
        exp.value = _transfer(id)$1;
        $$ = _vretained exp;
    }
    | postfix_expression DECREMENT
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorDecrementSuffix);
        exp.value = _transfer(id)$1;
        $$ = _vretained exp;
    }
    | postfix_expression DOT IDENTIFIER
    {
        OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
        methodcall.caller =  _transfer(OCValue *)$1;
        methodcall.isDot = YES;
        methodcall.names = [@[_typeId $3] mutableCopy];
        $$ = _vretained methodcall;
    }
    | postfix_expression ARROW IDENTIFIER
    {
        OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
        methodcall.caller =  _transfer(OCValue *)$1;
        methodcall.isDot = YES;
        methodcall.names = [@[_typeId $3] mutableCopy];
        $$ = _vretained methodcall;
    }
    | postfix_expression LP expression_list RP
    {   
        CFuncCall *call = (CFuncCall *)makeValue(OCValueFuncCall);
        call.caller = _transfer(id) $1;
        call.expressions = _transfer(id) $3;
        $$ = _vretained call;
    }
    | postfix_expression LB expression RB
    {
        OCCollectionGetValue *value = (OCCollectionGetValue *)makeValue(OCValueCollectionGetValue);
        value.caller = _typeId $1;
        value.keyExp = _typeId $3;
        $$ = _vretained value;
    }
    ;

numerical_value_type:
        INTETER_LITERAL
        {
            $$ = _vretained makeValue(OCValueInt,_transfer(id)$1);
        }
        | DOUBLE_LITERAL
        {
            $$ = _vretained makeValue(OCValueInt,_transfer(id)$1);
        }
    ;
dict_entrys:
        expression COLON expression
        {
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:@[_transfer(id)$1,_transfer(id)$3]];
            $$ = _vretained array;
        }
        |dict_entrys COMMA expression COLON expression
        {
            NSMutableArray *array = _transfer(id)$1;
            [array addObject:@[_transfer(id)$3,_transfer(id)$5]];
            $$ = _vretained array;
        }
        ;


primary_expression:
         IDENTIFIER
        {
            $$ = _vretained makeValue(OCValueVariable,_transfer(id) $1);
        }
        | _self
        {
            $$ = _vretained makeValue(OCValueSelf);
        }
        | _super
        {
            $$ = _vretained makeValue(OCValueSuper);
        }
        | objc_method_call
        | LP expression RP
        {
            $$ = $2;
        }
        | AT LC dict_entrys RC
        {
            $$ = _vretained makeValue(OCValueDictionary,_transfer(id)$3);
        }
        | AT LB expression_list RB
        {
            $$ = _vretained makeValue(OCValueArray,_transfer(id)$3);
        }
        | AT LP expression RP 
        {
            $$ = _vretained makeValue(OCValueNSNumber,_transfer(id)$3);
        }
        | AT numerical_value_type
        {
            $$ = _vretained makeValue(OCValueNSNumber,_transfer(id)$2);
        }
        | AT STRING_LITERAL
        {
            $$ = _vretained makeValue(OCValueString,_typeId $2);
        }
        | SELECTOR
        {
            $$ = _vretained makeValue(OCValueSelector,_typeId $1);
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
        | _nil
        {
            $$ = _vretained makeValue(OCValueNil);
        }
        | _NULL
        {
            $$ = _vretained makeValue(OCValueNULL);
        }
        | _YES
        {
            $$ = _vretained makeValue(OCValueBOOL);
        }
        | _NO
        {
            $$ = _vretained makeValue(OCValueBOOL);
        }
        ;

;

declaration:
	type_specifier init_declarator_list
    {
        NSMutableArray *array = _transfer(NSMutableArray *)$2;
        for (DeclareExpression *declare in array){
            declare.type = _typeId $1;
        }
        $$ = _vretained array;
    }
	;
init_declarator_list:
     init_declarator
     {
         $$ = _vretained [@[_typeId $1] mutableCopy];
     }
	| init_declarator_list COMMA init_declarator
    {
        NSMutableArray *array = _transfer(NSMutableArray *)$1;
        [array addObject:_transfer(id) $3];
        $$ = _vretained array;
    }
	;

init_declarator:
     declarator
	| declarator ASSIGN assign_expression
    {
        DeclareExpression *declare = _transfer(DeclareExpression *) $1;
        declare.expression = _typeId $3;
        $$ = _vretained declare;
    }
	;

declarator:
        direct_declarator
        | POWER direct_declarator_optional 
        {
            Variable *var = _transfer(Variable *)$2;
            var.ptCount = -1;
            $$ = _vretained var;
        }
        | pointer direct_declarator_optional
        {
            Variable *var = _transfer(Variable *)$2;
            var.ptCount = $1;
            $$ = _vretained var;
        }
        ;
declarator_optional:
        {
            $$ = _vretained makeVar(nil);
        }
        | declarator
        ;

direct_declarator:
        IDENTIFIER
        {
            $$ = _vretained makeVar(_typeId $1);
        }
        |LP declarator RP
        {
            $$ = _vretained _typeId $2;
        }
        // ***(int *,value *,id) 这种情况不处理
        |direct_declarator LP parameter_type_list RP
        {
            FuncVariable *funVar = [FuncVariable copyFromVar:_transfer(Variable *)$1];
            funVar.pairs = _transfer(NSMutableArray *)$3;
            $$ = _vretained funVar;
        }
        ;
direct_declarator_optional:
        {
            $$ = nil;
        }
        | direct_declarator
        ;

pointer:
        POINT
        {
            $$ = 1;
        }
	   | POINT pointer 
       {
           $$ = $2 + 1;
       }
	   ;
pointer_optional:
        {
            $$ = 0;
        }
        | pointer;

parameter_type_list:
         parameter_list
        | parameter_list COMMA ELLIPSIS
        ;

parameter_list: /* empty */
            {
                $$ = _vretained [NSMutableArray array];
            }
            | parameter_declaration
            {
                NSMutableArray *array = [NSMutableArray array];
                [array addObject:_transfer(id)$1];
                $$ = _vretained array;
            }
            | parameter_list COMMA parameter_declaration 
            {
                NSMutableArray *array = _transfer(NSMutableArray *)$1;
                [array addObject:_transfer(id) $3];
                $$ = _vretained array;
            }
            ;

parameter_declaration: 
    type_specifier declarator_optional
    {
        $$ = _vretained makeTypeVarPair(_typeId $1, _typeId $2);
    };
parameter_declaration_optional:
        | parameter_declaration
        ;

CHILD_COLLECTION_OPTIONAL:
        | CHILD_COLLECTION;
type_specifier:
            IDENTIFIER CHILD_COLLECTION_OPTIONAL
            {
                $$ = _vretained makeTypeSpecial(TypeObject,(__bridge NSString *)$1);
            }
            | TYPEOF LP expression RP
            {
                $$ = _vretained makeTypeSpecial(TypeObject,@"typeof");
            }
            | __TYPEOF LP expression RP
            {
                $$ = _vretained makeTypeSpecial(TypeObject,@"typeof");
            }
            | _UCHAR
            {
                 $$ = _vretained makeTypeSpecial(TypeUChar);
            }
            | _USHORT
            {
                $$ = _vretained makeTypeSpecial(TypeUShort);
            }
            | _UINT
            {
                $$ = _vretained makeTypeSpecial(TypeUInt);
            }
            | _ULONG
            {
                $$ = _vretained makeTypeSpecial(TypeULong);
            }
            | _ULLONG
            {
                $$ = _vretained makeTypeSpecial(TypeULongLong);
            }
            | _CHAR
            {
                $$ = _vretained makeTypeSpecial(TypeChar);
            }
            | _SHORT
            {
                $$ = _vretained makeTypeSpecial(TypeShort);
            }
            | _INT
            {
                $$ = _vretained makeTypeSpecial(TypeInt);
            }
            | _LONG
            {
                $$ = _vretained makeTypeSpecial(TypeLong);
            }
            | _LLONG
            {
                $$ = _vretained makeTypeSpecial(TypeLongLong);
            }
            | _DOUBLE
            {
                $$ = _vretained makeTypeSpecial(TypeDouble);
            }
            | _FLOAT
            {
                $$ = _vretained makeTypeSpecial(TypeFloat);
            }
            | _Class
            {
                $$ = _vretained makeTypeSpecial(TypeClass);
            }
            | _BOOL
            {
                $$ = _vretained makeTypeSpecial(TypeBOOL);
            }
            | _void
            {
                $$ = _vretained makeTypeSpecial(TypeVoid);
            }
            | _instancetype
            {
                $$ = _vretained makeTypeSpecial(TypeId);
            }
            ;

%%
void yyerror(const char *s){
    extern unsigned long yylineno , yycolumn , yylen;
    extern char linebuf[500];
    extern char *yytext;
    NSString *text = [NSString stringWithUTF8String:yytext];
    NSString *line = [NSString stringWithUTF8String:linebuf];
    NSRange range = [line rangeOfString:text];
    NSMutableString *str = [NSMutableString string];
    if(range.location != NSNotFound){
        for (int i = 0; i < range.location; i++){
            [str appendString:@" "];
        }
        for (int i = 0; i < range.length; i++){
            [str appendString:@"^"];
        }
    }else{
        str = [text mutableCopy];
    }
    NSString *errorInfo = [NSString stringWithFormat:@"\n------yyerror------\n%@\n%@\nerror: %s\n-------------------\n",line,str,s];
    OCParser.error = errorInfo;
    log(OCParser.error);
}
