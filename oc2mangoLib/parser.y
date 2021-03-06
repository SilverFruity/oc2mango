%{
#define YYDEBUG 1
#define YYERROR_VERBOSE
#import <Foundation/Foundation.h>
#import "Log.h"
#import "MakeDeclare.h"
extern int yylex (void);
extern void yyerror(const char *s);
extern bool is_variable;
%}
%union{
    void *identifier;
    __unsafe_unretained id object;
    NSInteger intValue;
    NSUInteger uIntValue;
    double doubleValue;
}

%token STATIC _STRONG _WEAK _BLOCK _AUTORELEASE NONNULL NULLABLE
%token IF ENDIF IFDEF IFNDEF UNDEF IMPORT INCLUDE  TILDE
%token PROPERTY _return _break _continue _goto _else  _while _do _in _for _case _switch _default TYPEOF _sizeof
%token QUESTION _union _struct _enum NS_ENUM NS_OPTIONS INTERFACE IMPLEMENTATION DYNAMIC PROTOCOL END CLASS_DECLARE
%token COMMA COLON SEMICOLON  LP RP RIP LB RB LC RC DOT AT PS ARROW
%token EQ NE LT LE GT GE LOGIC_AND LOGIC_OR NOT AND OR POWER SUB ADD DIV ASTERISK AND_ASSIGN OR_ASSIGN POWER_ASSIGN SUB_ASSIGN ADD_ASSIGN DIV_ASSIGN ASTERISK_ASSIGN INCREMENT DECREMENT
%token SHIFTLEFT SHIFTRIGHT MOD ASSIGN MOD_ASSIGN
%token _Class _id _void _BOOL _SEL _CHAR _SHORT _INT _LONG _LLONG  _UCHAR _USHORT _UINT _ULONG  _ULLONG _DOUBLE _FLOAT _instancetype
%token _self _super _nil _NULL _YES _NO
%token <object> IDENTIFIER STRING_LITERAL SELECTOR
%token <identifier> TYPEDEF ELLIPSIS CHILD_COLLECTION POINT __BRIDGE __TRANSFER __RETAINED

%token <intValue> INTETER_LITERAL
%token <doubleValue> DOUBLE_LITERAL
%type <intValue> pointer pointer_optional
%type <intValue>  assign_operator unary_operator
%type <uIntValue> declaration_modifier declaration_modifier_opt

%type  <identifier> global_define

%type  <object>
parameter_declaration
declarator_type
parameter_list
CHILD_COLLECTION_OPTIONAL
declare_left_attribute

%type  <object>
class_declare
protocol_declare
class_implementation
method_declare
class_property_type
class_property_declare
property_list
class_private_varibale_declare
class_private_list

%type  <object>
objc_method_call_pramameters
objc_method_call
primary_expression
numerical_value_type
block_implementation
function_implementation
expression_list
unary_expression
postfix_expression

%type <object>
expression_statement
if_statement // if / else if / else
while_statement // while(){}
dowhile_statement // do{}while()
case_statement   // case:
case_statement_list
switch_statement // switch(){}
for_statement    // for(;;;){}
forin_statement  // for( in ) {}
control_statement // return / break / continue

%type <object>
expression
expression_optional
assign_expression
ternary_expression
logic_or_expression
multiplication_expression
additive_expression
bite_shift_expression
equality_expression
bite_and_expression
bite_xor_expression
relational_expression
bite_or_expression
logic_and_expression
dict_entrys
for_statement_var_list

%type <object>
declaration
init_declarator_list
init_declarator
declarator
declarator_optional
direct_declarator
direct_declarator_optional
block_parameters_optinal
parameter_type_list
declarator_type_opt

%type <object>
union_declare
struct_field_list
struct_declare
enum_field_list
enum_declare
typedef_declare
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
| control_statement
{
    [GlobalAst addGlobalStatements:$1];
}
;
global_define:
expression_statement
{
    [GlobalAst addGlobalStatements:$1];
}
| CLASS_DECLARE IDENTIFIER SEMICOLON
| PROTOCOL IDENTIFIER SEMICOLON
| declarator_type declarator LC function_implementation RC
{
    ORFunctionDeclNode *declare = $2;
    declare.type = $1;
    [GlobalAst addGlobalStatements:makeFunctionNode(declare, $4)];
}
| struct_declare SEMICOLON
{
    [GlobalAst addGlobalStatements:$1];
}
| union_declare SEMICOLON
{
    [GlobalAst addGlobalStatements:$1];
}
| enum_declare SEMICOLON
{
    [GlobalAst addGlobalStatements:$1];
}
| TYPEDEF typedef_declare SEMICOLON
{
    [GlobalAst addGlobalStatements:$2];
}
;

struct_declare:
_struct IDENTIFIER LC struct_field_list RC
{
    $$ = makeStructExp($2, $4);
}
;

union_declare:
_union IDENTIFIER LC struct_field_list RC
{
    $$ = makeUnionExp($2, $4);
}
;

struct_field_list:
declaration SEMICOLON
{
    $$ = $1;
}
| struct_field_list declaration SEMICOLON
{
    [(NSMutableArray *)$1 addObjectsFromArray:$2];
    $$ = $1;
}
;
enum_declare:
NS_ENUM LP declarator_type COMMA IDENTIFIER RP enum_declare
{
    OREnumStatNode *exp = $7;
    exp.enumName = $5;
    exp.valueType = [(ORTypeNode *) $3 type];
    $$ = exp;
}
| NS_OPTIONS LP declarator_type COMMA IDENTIFIER RP enum_declare
{
    OREnumStatNode *exp = $7;
    exp.enumName = $5;
    exp.valueType =  [(ORTypeNode *) $3 type];
    $$ = exp;
}
| _enum IDENTIFIER enum_declare
{
    OREnumStatNode *exp = $3;
    exp.enumName = $2;
    $$ = exp;
}
| _enum enum_declare
{
    OREnumStatNode *exp = $2;
    $$ = exp;
}
| LC enum_field_list RC
{
    $$ = makeEnumExp(@"",makeTypeNode(TypeInt), $2);
}
| COLON declarator_type LC enum_field_list RC
{
    $$ = makeEnumExp(@"",$2, $4);
}
;

enum_field_list:
assign_expression
{
    $$ = makeMutableArray($1);
}
| enum_field_list COMMA assign_expression
{
    NSMutableArray *list = $1;
    [list addObject:$3];
    $$ = list;
}
;

            
typedef_declare:
declarator_type declarator
{
    ORDeclaratorNode *pair = $2;
    pair.type = $1;
    $$ = makeTypedefExp(pair, pair.var.varname);
}
//for NS_ENUM NS_OPTIONS
| enum_declare
{
    $$ = makeTypedefExp($1, @"");
}
| enum_declare IDENTIFIER
{
    $$ = makeTypedefExp($1, $2);
}
| struct_declare IDENTIFIER
{
    $$ = makeTypedefExp($1, $2);
}
;

protocol_declare:
PROTOCOL IDENTIFIER CHILD_COLLECTION_OPTIONAL
{
    ORProtocolNode *orprotcol = [GlobalAst protcolForName:$2];
    NSString *supers = $3;
    if (supers != nil){
        NSArray *protocols = [supers componentsSeparatedByString:@","];
        orprotcol.protocols = [protocols mutableCopy];
    }
    $$ = orprotcol;
}
| protocol_declare PROPERTY class_property_declare parameter_declaration SEMICOLON
{
    ORProtocolNode *orprotcol = $1;
    [orprotcol.properties addObject:makePropertyDeclare($3, $4)];
    $$ = orprotcol;
}
| protocol_declare method_declare SEMICOLON
{
    ORProtocolNode *orprotcol =  $1;
    [orprotcol.methods addObject: $2];
    $$ = orprotcol;
}
| protocol_declare END
;

class_declare:
//
INTERFACE IDENTIFIER COLON IDENTIFIER CHILD_COLLECTION_OPTIONAL
{
    ORClassNode *occlass = [GlobalAst classForName:$2];
    occlass.superClassName = $4;
    NSArray *protocols = [$5 componentsSeparatedByString:@","];
    occlass.protocols = [protocols mutableCopy];
    $$ = occlass;
}
// category
| INTERFACE IDENTIFIER LP IDENTIFIER RP CHILD_COLLECTION_OPTIONAL
{
    ORClassNode *occlass = [GlobalAst classForName:$2];
    NSArray *protocols = [$6 componentsSeparatedByString:@","];
    occlass.protocols = [protocols mutableCopy];
    $$ = occlass;
}
| INTERFACE IDENTIFIER LP RP CHILD_COLLECTION_OPTIONAL
{
    ORClassNode *occlass = [GlobalAst classForName:$2];
    NSArray *protocols = [$5 componentsSeparatedByString:@","];
    occlass.protocols = [protocols mutableCopy];
    $$ = occlass;
}
| class_declare LC class_private_varibale_declare RC
{
    ORClassNode *occlass =  $1;
    [occlass.privateVariables addObjectsFromArray: $3];
    $$ = occlass;
}
| class_declare PROPERTY class_property_declare parameter_declaration SEMICOLON
{
    ORClassNode *occlass =  $1;
    [occlass.properties addObject:makePropertyDeclare($3, $4)];
    $$ = occlass;
}
// 方法声明，不做处理
| class_declare method_declare SEMICOLON
| class_declare END
;


class_implementation:
IMPLEMENTATION IDENTIFIER class_private_list
{
    ORClassNode *occlass = [GlobalAst classForName:$2];
    [occlass.privateVariables addObjectsFromArray: $3];
    $$ = occlass;
}
// category
| IMPLEMENTATION IDENTIFIER LP IDENTIFIER RP
{
    $$ = [GlobalAst classForName:$2];
}
| class_implementation method_declare LC function_implementation RC
{
    ORMethodNode *imp = makeMethodImplementation( $2,  $4);
    ORClassNode *occlass =  $1;
    [occlass.methods addObject:imp];
    $$ = occlass;
}
| class_implementation global_define
| class_implementation END
;

class_private_list:
{
    $$ = makeMutableArray(nil);;
}
| LC class_private_varibale_declare RC
{
    $$ = $2;
}

class_private_varibale_declare: // empty
{
    $$ = makeMutableArray(nil);;
}
| class_private_varibale_declare parameter_declaration SEMICOLON
{
    NSMutableArray *list =  $1;
    [list addObject: $2];
    $$ = list;
}
;

class_property_type:
  IDENTIFIER
| NONNULL
| NULLABLE
;

property_list:
class_property_type
{
    $$ = makeMutableArray($1);
}
| property_list COMMA class_property_type
{
    [$1 addObject:$3];
    $$ = $1;
}
;

class_property_declare:
{
    $$ = makeMutableArray(nil);
}
| LP property_list RP
{
    $$ = $2;
}

declare_left_attribute:
| NONNULL
| NULLABLE
;
method_declare:
SUB LP parameter_declaration RP
{
    ORDeclaratorNode *declare = $3;
    $$ = makeMethodDeclare(NO,declare);
}
| ADD LP parameter_declaration RP
{
    ORDeclaratorNode *declare = $3;
    $$ = makeMethodDeclare(YES,declare);
}
| method_declare IDENTIFIER
{
    ORMethodDeclNode *method = $$;
    [method.methodNames addObject: $2];
    $$ = method;
}
| method_declare IDENTIFIER COLON LP parameter_declaration RP IDENTIFIER
{
    ORDeclaratorNode *pair = $5;
    ORMethodDeclNode *method = $$;
    [method.methodNames addObject: $2];
    [method.parameterTypes addObject:pair];
    [method.parameterNames addObject: $7];
    $$ = method;
}
;

objc_method_call_pramameters:
IDENTIFIER
{
    __autoreleasing NSArray *array = @[makeMutableArray($1),makeMutableArray(nil)];
    $$ = array;
}
| IDENTIFIER COLON expression_list
{
    __autoreleasing NSArray *array = @[makeMutableArray($1), $3];
    $$ = array;
}
| objc_method_call_pramameters IDENTIFIER COLON expression_list
{
    NSArray *array = $1;
    NSMutableArray *names = array[0];
    NSMutableArray *values = array[1];
    [names addObject:$2];
    [values addObjectsFromArray:$4];
    $$ = array;
}
;

objc_method_call:
 LB IDENTIFIER objc_method_call_pramameters RB
{
     ORMethodCall *methodcall = makeMethodCall();
     methodcall.caller =  makeValue(OCValueVariable,$2);
     NSArray *params = $3;
     methodcall.names = params[0];
     methodcall.values = params[1];
     $$ = methodcall;
}
| LB postfix_expression objc_method_call_pramameters RB
{
     ORMethodCall *methodcall = makeMethodCall();
     ORValueNode *caller = $2;
     methodcall.caller =  caller;
     NSArray *params = $3;
     methodcall.names = params[0];
     methodcall.values = params[1];
     $$ = methodcall;
}
;
block_parameters_optinal:
{
    $$ = makeMutableArray(nil);
}
| LP parameter_list RP
{
    $$ = $2;
}
;
declarator_type_opt:
{
    $$ = nil;
}
| declarator_type
        
block_implementation:
//^returnType(optional) parameters(optional){ }
POWER declarator_type_opt pointer_optional block_parameters_optinal LC function_implementation RC
{
    ORFunctionDeclNode *declare = makeFunctionDeclNode();
    declare.type = $2;
    declare.var = makeVarNode(nil,$3);
    declare.params = $4;
    declare.var.isBlock = YES;
    $$ = makeFunctionNode(declare, $6);;
}
;


expression: assign_expression;
expression_optional:
{
    $$ = NULL;
}
|assign_expression;

expression_statement:
assign_expression SEMICOLON
{
    ORNode *node =  $1;
    node.withSemicolon = YES;
    $$ = node;
}
| declaration SEMICOLON
{
    NSArray *declares =  $1;
    for (ORNode* node in declares){
        node.withSemicolon = YES;
    }
    $$ = declares;
}
|_return SEMICOLON
{
    ORNode *node = makeControlStatement(ORControlStatReturn,nil);
    node.withSemicolon = YES;
    $$ = node;
}
| _return expression SEMICOLON
{
    ORNode *node = makeControlStatement(ORControlStatReturn,$2);
    node.withSemicolon = YES;
    $$ = node;
}
| _break SEMICOLON
{
    ORNode *node = makeControlStatement(ORControlStatBreak, nil);
    node.withSemicolon = YES;
    $$ = node;
}
| _continue SEMICOLON
{
    ORNode *node = makeControlStatement(ORControlStatContinue, nil);
    node.withSemicolon = YES;
    $$ = node;
}
;

if_statement:
IF LP expression RP expression_statement
{
    ORBlockNode *imp = makeScopeImp();
    [imp addStatements: $5];
    ORIfStatement *statement = makeIfStatement( $3,imp);
    $$ = statement;
}
| IF LP expression RP LC function_implementation RC
{
    ORIfStatement *statement = makeIfStatement( $3,$6);
    $$ = statement;
}
| if_statement _else IF LP expression RP expression_statement
{
    ORBlockNode *imp = makeScopeImp();
    [imp addStatements: $7];
    ORIfStatement *elseIfStatement = makeIfStatement( $5,imp);
    elseIfStatement.last = $1;
    $$  = elseIfStatement;
}
| if_statement _else IF LP expression RP LC function_implementation RC
{
    ORIfStatement *elseIfStatement = makeIfStatement( $5,$8);
    elseIfStatement.last = $1;
    $$  = elseIfStatement;
}
| if_statement _else expression_statement
{
    ORBlockNode *imp = makeScopeImp();
    [imp addStatements: $3];
    ORIfStatement *elseStatement = makeIfStatement(nil,imp);
    elseStatement.last = $1;
    $$  = elseStatement;
}
| if_statement _else LC function_implementation RC
{
    ORIfStatement *elseStatement = makeIfStatement(nil,$4);
    elseStatement.last = $1;
    $$  = elseStatement;
}
;

dowhile_statement: 
_do LC function_implementation RC _while LP expression RP
{
    ORDoWhileStatement *statement = makeDoWhileStatement($7,$3);
    $$ = statement;
}
;
while_statement:
_while LP expression RP LC function_implementation RC
{
    ORWhileStatement *statement = makeWhileStatement($3,$6);
    $$ = statement;
}
;

case_statement:
_case primary_expression COLON
{
     ORCaseStatement *statement = makeCaseStatement($2);
    $$ = statement;
}
| _default COLON
{
    ORCaseStatement *statement = makeCaseStatement(nil);
    $$ = statement;
}
| case_statement expression_statement
{
    ORCaseStatement *statement =  $1;
    [statement.scopeImp addStatements:$2];
    $$ = statement;
}
| case_statement LC function_implementation RC
{
    ORCaseStatement *statement =  $1;
    statement.scopeImp =  $3;
    $$ = statement;
}
;
case_statement_list:
{
    $$ = makeMutableArray(nil);
}
| case_statement_list case_statement
{
    [$1 addObject: $2];
    $$ = $1;
}
;
switch_statement:
 _switch LP expression RP LC case_statement_list RC
 {
     ORSwitchStatement *statement = makeSwitchStatement( $3);
     statement.cases = $6;
     $$ = statement;
 }
;

for_statement_var_list:
| primary_expression
{
    NSMutableArray *list = makeMutableArray(nil);
    [list addObject:$1];
    $$ = list;
}
| for_statement_var_list COMMA primary_expression
{
    NSMutableArray *list = $1;
    [list addObject: $3];
    $$ = list;
}

for_statement: _for LP declaration SEMICOLON expression SEMICOLON expression_list RP LC function_implementation RC
{
    ORForStatement* statement = makeForStatement( $10);
    statement.varExpressions = $3;
    statement.condition = $5;
    statement.expressions = $7;
    $$ = statement;
}
|  _for LP for_statement_var_list SEMICOLON expression SEMICOLON expression_list RP LC function_implementation RC
       {
           ORForStatement* statement = makeForStatement( $10);
           statement.varExpressions = $3;
           statement.condition = $5;
           statement.expressions = $7;
           $$ = statement;
       }
;

forin_statement: _for LP declaration _in expression RP LC function_implementation RC
{
    ORForInStatement * statement = makeForInStatement($8);
    NSArray *exps = $3;
    statement.expression = exps[0];
    statement.value = $5;
    $$ = statement;
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
    $$ = makeScopeImp();
}
| function_implementation expression_statement
{
    ORBlockNode *imp = $1;
    [imp addStatements: $2];
    $$ = imp;
}
| function_implementation control_statement
{
    ORBlockNode *imp = $1;
    [imp addStatements: $2];
    $$ = imp;
}
;
        

expression_list:
{
    $$ = makeMutableArray(nil);
}
| expression
{
    NSMutableArray *list = makeMutableArray(nil);
    [list addObject:$1];
    $$ = list;
}
| expression_list COMMA expression
{
    NSMutableArray *list = $1;
    [list addObject: $3];
    $$ = list;
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
    ORAssignExpression *expression = makeAssignExpression($2);
    expression.expression =  $3;
    expression.value = $1;
    $$ = expression;
}
;

// ?:
ternary_expression: logic_or_expression
| logic_or_expression QUESTION ternary_expression COLON ternary_expression
{
    ORTernaryExpression *expression = makeTernaryExpression();
    expression.expression = $1;
    [expression.values addObject:$3];
    [expression.values addObject:$5];
    $$ = expression;
}
| logic_or_expression QUESTION COLON ternary_expression
{
    ORTernaryExpression *expression = makeTernaryExpression();
    expression.expression = $1;
    [expression.values addObject:$4];
    $$ = expression;
}
;


// ||
logic_or_expression: logic_and_expression
| logic_or_expression LOGIC_OR logic_or_expression
{
    ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorLOGIC_OR);
    exp.left =  $1;
    exp.right =  $3;
    $$ = exp;
}
;

// &&
logic_and_expression: bite_or_expression
| logic_and_expression LOGIC_AND bite_or_expression
{
    ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorLOGIC_AND);
    exp.left =  $1;
    exp.right =  $3;
    $$ = exp;
}
;
// |
bite_or_expression: bite_xor_expression
| bite_or_expression OR bite_xor_expression
{
    ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorOr);
    exp.left =  $1;
    exp.right =  $3;
    $$ = exp;
}
;
// ^
bite_xor_expression: bite_and_expression
| bite_xor_expression POWER bite_and_expression
{
    ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorXor);
    exp.left =  $1;
    exp.right =  $3;
    $$ = exp;
}
;

// &
bite_and_expression: equality_expression
| bite_and_expression AND equality_expression
{
    ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorAnd);
    exp.left =  $1;
    exp.right =  $3;
    $$ = exp;
}
;

// == !=
equality_expression: relational_expression
| equality_expression EQ relational_expression
{
    ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorEqual);
    exp.left =  $1;
    exp.right =  $3;
    $$ = exp;
}
| equality_expression NE relational_expression
{
    ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorNotEqual);
    exp.left =  $1;
    exp.right =  $3;
    $$ = exp;
}
;
// < <= > >=
relational_expression: bite_shift_expression
| relational_expression LT bite_shift_expression
{
    ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorLT);
    exp.left =  $1;
    exp.right =  $3;
    $$ = exp;
}
| relational_expression LE bite_shift_expression
{
    ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorLE);
    exp.left =  $1;
    exp.right =  $3;
    $$ = exp;
}
| relational_expression GT bite_shift_expression
{
    ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorGT);
    exp.left =  $1;
    exp.right =  $3;
    $$ = exp;
}
| relational_expression GE bite_shift_expression
{
    ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorGE);
    exp.left =  $1;
    exp.right =  $3;
    $$ = exp;
}
;
// >> <<
bite_shift_expression: additive_expression
| bite_shift_expression SHIFTLEFT additive_expression
{
    ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorShiftLeft);
    exp.left =  $1;
    exp.right =  $3;
    $$ = exp;
}
| bite_shift_expression SHIFTRIGHT additive_expression
{
    ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorShiftRight);
    exp.left =  $1;
    exp.right =  $3;
    $$ = exp;
}
;
// + -
additive_expression: multiplication_expression
| additive_expression ADD multiplication_expression
{
    ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorAdd);
    exp.left =  $1;
    exp.right =  $3;
    $$ = exp;
}
| additive_expression SUB multiplication_expression
{
    ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorSub);
    exp.left =  $1;
    exp.right =  $3;
    $$ = exp;
}
;

// * / %
multiplication_expression: unary_expression
| multiplication_expression ASTERISK unary_expression
{
    ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorMulti);
    exp.left =  $1;
    exp.right =  $3;
    $$ = exp;
}
| multiplication_expression DIV unary_expression
{
    ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorDiv);
    exp.left =  $1;
    exp.right =  $3;
    $$ = exp;
}
| multiplication_expression MOD unary_expression
{
    ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorMod);
    exp.left =  $1;
    exp.right =  $3;
    $$ = exp;
}
;

// !x -x *x &x ~x sizof(x) x++ x-- ++x --x
unary_expression: postfix_expression
| unary_operator unary_expression
{
    ORUnaryExpression *exp = makeUnaryExpression($1);
    exp.value = $2;
    $$ = exp;
}
| _sizeof unary_expression
{
    ORUnaryExpression *exp = makeUnaryExpression(UnaryOperatorSizeOf);
    exp.value = $2;
    $$ = exp;
}
| INCREMENT unary_expression
{
    ORUnaryExpression *exp = makeUnaryExpression(UnaryOperatorIncrementPrefix);
    exp.value = $2;
    $$ = exp;
}
| DECREMENT unary_expression
{
    ORUnaryExpression *exp = makeUnaryExpression(UnaryOperatorDecrementPrefix);
    exp.value = $2;
    $$ = exp;
}
;

unary_operator: 
AND
{
    $$ = UnaryOperatorAdressPoint;
}
| ASTERISK
{
    $$ = UnaryOperatorAdressValue;
}
| POINT
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

bridge_set:
__BRIDGE
| __TRANSFER
| __TRANSFER
bridge_set_optional:
| bridge_set

postfix_expression: primary_expression
| postfix_expression INCREMENT
{
    ORUnaryExpression *exp = makeUnaryExpression(UnaryOperatorIncrementSuffix);
    exp.value = $1;
    $$ = exp;
}
| postfix_expression DECREMENT
{
    ORUnaryExpression *exp = makeUnaryExpression(UnaryOperatorDecrementSuffix);
    exp.value = $1;
    $$ = exp;
}
| postfix_expression DOT IDENTIFIER
{
    is_variable = true;
    ORMethodCall *methodcall = makeMethodCall();
    methodcall.caller =  $1;
    methodcall.methodOperator = MethodOpretorDot;
    methodcall.names = [@[$3] mutableCopy];
    $$ = methodcall;
}
| postfix_expression ARROW IDENTIFIER
{
    ORMethodCall *methodcall = makeMethodCall();
    methodcall.caller =  $1;
    methodcall.methodOperator = MethodOpretorArrow;
    methodcall.names = [@[$3] mutableCopy];
    $$ = methodcall;
}
| postfix_expression LP expression_list RP
{
    is_variable = true;
    $$ = makeFuncCall( $1,  $3);
}
| postfix_expression LB expression RB
{
    $$ = makeSubscriptNode($1, $3);
}
| LP declarator_type declarator_optional RP postfix_expression
{
    $$ = $5;
}
| LP bridge_set declarator_type declarator_optional RP postfix_expression
{
    $$ = $6;
}
;

numerical_value_type:
INTETER_LITERAL
{
    $$ = makeIntegerValue($1);
}
| DOUBLE_LITERAL
{
    $$ = makeDoubleValue($1);
}
;
dict_entrys:
{
    NSMutableArray *array = makeMutableArray(nil);
    $$ = array;
}
| dict_entrys expression COLON expression
{
    NSMutableArray *array = $1;
    [array addObject:@[$2,$4]];
    $$ = array;
}
| dict_entrys COMMA
{
    $$ = $1;
}
;


primary_expression:
IDENTIFIER
{
    is_variable = true;
    $$ = makeValue(OCValueVariable, $1);
}
| _self
{
    $$ = makeValue(OCValueSelf);
}
| _super
{
    $$ = makeValue(OCValueSuper);
}
| objc_method_call
{
    is_variable = true;
    $$ = $1;
}
| LP expression RP
{
    is_variable = true;
    $$ = $2;
}
| AT LC dict_entrys RC
{
    $$ = makeValue(OCValueDictionary,$3);
}
| AT LB expression_list RB
{
    $$ = makeValue(OCValueArray,$3);
}
| AT LP expression RP
{
    $$ = makeValue(OCValueNSNumber,$3);
}
| AT numerical_value_type
{
    $$ = makeValue(OCValueNSNumber,$2);
}
| AT STRING_LITERAL
{
    $$ = makeValue(OCValueString,$2);
}
| SELECTOR
{
    NSString *sel = $1;
    NSString *selector = [sel substringWithRange:NSMakeRange(10, sel.length - 11)];
    $$ = makeValue(OCValueSelector,selector);
}
| PROTOCOL LP IDENTIFIER RP
{
    $$ = makeValue(OCValueProtocol,$3);
}
| STRING_LITERAL
{
    $$ = makeValue(OCValueCString,$1);
}
| block_implementation
| numerical_value_type
| _nil
{
    $$ = makeValue(OCValueNil);
}
| _NULL
{
    $$ = makeValue(OCValueNULL);
}
| _YES
{
    $$ = makeBoolValue(YES);
}
| _NO
{
    $$ = makeBoolValue(NO);
}
;

;
declaration_modifier_opt:
| declaration_modifier
;

declaration_modifier: _WEAK
{
    $$ = DeclarationModifierWeak;
}
| _STRONG
{
    $$ = DeclarationModifierStrong;
}
| STATIC
{
    $$ = DeclarationModifierStatic;
}
;

declaration:
declaration_modifier declarator_type init_declarator_list
{
    NSMutableArray *array = $3;
    for (ORInitDeclaratorNode *declare in array){
        declare.declarator.type = $2;
        declare.declarator.type.modifier = $1;
    }
    $$ = array;
}
| declarator_type init_declarator_list
{
    NSMutableArray *array = $2;
    for (ORInitDeclaratorNode *declare in array){
        declare.declarator.type = $1;
    }
    $$ = array;
}
;
init_declarator_list:
init_declarator
{
    $$ = makeMutableArray($1);
}
| init_declarator_list COMMA init_declarator
{
    [(NSMutableArray *)$1 addObject: $3];
    $$ = $1;
}
;

init_declarator:
declarator
{
    $$ = makeInitDeclaratorNode($1, nil);
}
| declarator ASSIGN assign_expression
{
    $$ = makeInitDeclaratorNode($1, $3);
}
;


declarator_optional:
{
    $$ = makeDeclaratorNode(nil, makeVarNode(nil));
}
| declarator
;

declarator:
direct_declarator
| POWER direct_declarator_optional
{
    ORDeclaratorNode *decl = $2;
    decl.var.isBlock = YES;
    $$ = decl;
}
| pointer direct_declarator_optional
{
    ORDeclaratorNode *decl = $2;
    decl.var.ptCount = $1;
    $$ = decl;
}

;

direct_declarator_optional:
{
    $$ = makeDeclaratorNode(nil, makeVarNode(nil));
}
| direct_declarator
;

direct_declarator:
IDENTIFIER
{
    $$ = makeDeclaratorNode(nil, makeVarNode($1));
}
| LP declarator RP
{
    $$ = $2;
}
| direct_declarator LP parameter_type_list RP
{
    ORFunctionDeclNode *funcDecl = [ORFunctionDeclNode copyFromDecl:$1];
    NSMutableArray *pairs = $3;
    if ([pairs lastObject] == [NSNull null]) {
        funcDecl.isMultiArgs = YES;
        [pairs removeLastObject];
    }
    funcDecl.params = pairs;
    $$ = funcDecl;
}
| direct_declarator LB expression_optional RB
{
    ORDeclaratorNode *node = $1;
    if ($3 == NULL){
        node.var.ptCount += 1;
        $$ = node;
    }else{
        ORCArrayDeclNode *arrayVar = [ORCArrayDeclNode copyFromDecl:node];
        arrayVar.capacity = $3;
        $$ = arrayVar;
   }
}
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
{
    [$1 addObject:[NSNull null]];
    $$ = $1;
}
;

parameter_list: /* empty */
{
    $$ = makeMutableArray(nil);
}
| parameter_declaration
{
    NSMutableArray *array = makeMutableArray(nil);
    [array addObject:$1];
    $$ = array;
}
| parameter_list COMMA parameter_declaration
{
    NSMutableArray *array = $1;
    [array addObject: $3];
    $$ = array;
}
;

parameter_declaration: 
declare_left_attribute declarator_type declarator_optional
{
    ORDeclaratorNode *node = $3;
    node.type = $2;
    $$ = node;
};

parameter_declaration_optional:
| parameter_declaration
;

CHILD_COLLECTION_OPTIONAL:
{
    $$ = nil;
}
| CHILD_COLLECTION;

declarator_type:
IDENTIFIER CHILD_COLLECTION_OPTIONAL
{
    $$ = makeTypeNode(TypeObject, $1);
}
| _struct IDENTIFIER
{
    $$ = makeTypeNode(TypeStruct, $2);
}
| _union IDENTIFIER
{
    $$ = makeTypeNode(TypeUnion, $2);
}
| _id CHILD_COLLECTION_OPTIONAL
{
    $$ = makeTypeNode(TypeObject,@"id");
}
| TYPEOF LP expression RP
{
    $$ = makeTypeNode(TypeObject,@"typeof");
}
| _UCHAR
{
    $$ = makeTypeNode(TypeUChar);
}
| _USHORT
{
    $$ = makeTypeNode(TypeUShort);
}
| _UINT
{
    $$ = makeTypeNode(TypeUInt);
}
| _ULONG
{
    $$ = makeTypeNode(TypeULong);
}
| _ULLONG
{
    $$ = makeTypeNode(TypeULongLong);
}
| _CHAR
{
    $$ = makeTypeNode(TypeChar);
}
| _SHORT
{
    $$ = makeTypeNode(TypeShort);
}
| _INT
{
    $$ = makeTypeNode(TypeInt);
}
| _LONG
{
    $$ = makeTypeNode(TypeLong);
}
| _LLONG
{
    $$ = makeTypeNode(TypeLongLong);
}
| _DOUBLE
{
    $$ = makeTypeNode(TypeDouble);
}
| _FLOAT
{
    $$ = makeTypeNode(TypeFloat);
}
| _Class
{
    $$ = makeTypeNode(TypeClass);
}
| _BOOL
{
    $$ = makeTypeNode(TypeBOOL);
}
| _SEL
{
    $$ = makeTypeNode(TypeSEL);
}
| _void
{
    $$ = makeTypeNode(TypeVoid);
}
| _instancetype
{
    $$ = makeTypeNode(TypeObject,@"id");
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
    NSString *errorInfo = [NSString stringWithFormat:@"\n------yyerror------\nline: %lu\n%@\n%@\nerror: %s\n-------------------\n",yylineno + 1,line,str,s];
    OCParser.error = errorInfo;
}
