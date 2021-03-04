%{
#define YYDEBUG 1
#define YYERROR_VERBOSE
#define _retained(IDENTIFIER) (__bridge_retained IDENTIFIER)
#define _vretained _retained(void *)
#define _transfer(IDENTIFIER) (__bridge_transfer IDENTIFIER)
#define _typeId _transfer(id)
#import <Foundation/Foundation.h>
#import "Log.h"
#import "MakeDeclare.h"
extern int yylex (void);
extern void yyerror(const char *s);
extern bool is_variable;
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
    NSUInteger declaration_modifier;
}

%token <identifier> IDENTIFIER  STRING_LITERAL TYPEDEF ELLIPSIS CHILD_COLLECTION POINT __BRIDGE __TRANSFER __RETAINED
%token <identifier> IF ENDIF IFDEF IFNDEF UNDEF IMPORT INCLUDE  TILDE 
%token <identifier> QUESTION  _return _break _continue _goto _else  _while _do _in _for _case _switch _default TYPEOF _sizeof
%token <identifier> _union _struct _enum NS_ENUM NS_OPTIONS INTERFACE IMPLEMENTATION DYNAMIC PROTOCOL END CLASS_DECLARE
%token <identifier> PROPERTY
%token <identifier> STATIC _STRONG _WEAK _BLOCK _AUTORELEASE NONNULL NULLABLE
%token <identifier> COMMA COLON SEMICOLON  LP RP RIP LB RB LC RC DOT AT PS ARROW
%token <identifier> EQ NE LT LE GT GE LOGIC_AND LOGIC_OR NOT
%token <identifier> AND OR POWER SUB ADD DIV ASTERISK AND_ASSIGN OR_ASSIGN POWER_ASSIGN SUB_ASSIGN ADD_ASSIGN DIV_ASSIGN ASTERISK_ASSIGN INCREMENT DECREMENT
SHIFTLEFT SHIFTRIGHT MOD ASSIGN MOD_ASSIGN
%token <identifier> _self _super _nil _NULL _YES _NO 
%token <identifier>  _Class _id _void _BOOL _SEL _CHAR _SHORT _INT _LONG _LLONG  _UCHAR _USHORT _UINT _ULONG  _ULLONG _DOUBLE _FLOAT _instancetype
%token <identifier> INTETER_LITERAL DOUBLE_LITERAL SELECTOR
%type  <identifier> global_define 
%type  <declare>  protocol_declare class_declare property_list class_private_varibale_declare class_private_list
%type  <declare>  class_property_declare method_declare declare_left_attribute class_property_type
%type  <declare>  parameter_declaration  declarator_type  parameter_list CHILD_COLLECTION_OPTIONAL
%type  <implementation> class_implementation
%type  <expression> objc_method_call primary_expression numerical_value_type block_implementation  function_implementation  objc_method_call_pramameters  expression_list  unary_expression postfix_expression
%type <Operator>  assign_operator unary_operator
%type <statement> expression_statement if_statement while_statement dowhile_statement switch_statement for_statement forin_statement  case_statement_list control_statement  case_statement
%type <expression> expression expression_optional  assign_expression ternary_expression logic_or_expression multiplication_expression additive_expression bite_shift_expression equality_expression bite_and_expression bite_xor_expression  relational_expression bite_or_expression logic_and_expression dict_entrys for_statement_var_list
%type <expression> declaration init_declarator declarator declarator_optional direct_declarator direct_declarator_optional init_declarator_list  block_parameters_optinal parameter_type_list declarator_type_opt
%type <IntValue> pointer pointer_optional
%type <declaration_modifier> declaration_modifier declaration_modifier_opt
%type <expression> union_declare struct_declare struct_field_list enum_declare enum_field_list typedef_declare
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
                [GlobalAst addGlobalStatements:_typeId $1];
            }
	    ;
global_define:
    expression_statement
    {
        [GlobalAst addGlobalStatements:_typeId $1];
    }
    | CLASS_DECLARE IDENTIFIER SEMICOLON
    | PROTOCOL IDENTIFIER SEMICOLON
    | declarator_type declarator LC function_implementation RC
    {
        ORDeclaratorNode *returnType = makeDeclaratorNode(_typeId $1, nil);
        ORFunctionDeclarator *declare = _typeId $2;
        declare.returnNode = returnType;
        ORFunctionImp *imp = [ORFunctionImp new];
        imp.scopeImp = _transfer(ORBlockNode *)$4;
        imp.declare = declare;
        [GlobalAst addGlobalStatements:imp];
    }
    | struct_declare SEMICOLON
    {
        [GlobalAst addGlobalStatements:_typeId $1];
    }
    | union_declare SEMICOLON
    {
        [GlobalAst addGlobalStatements:_typeId $1];
    }
    | enum_declare SEMICOLON
    {
        [GlobalAst addGlobalStatements:_typeId $1];
    }
    | TYPEDEF typedef_declare SEMICOLON
    {
        [GlobalAst addGlobalStatements:_typeId $2];
    }
    ;

struct_declare:
_struct IDENTIFIER LC struct_field_list RC
{
    $$ = _vretained makeStructExp(_typeId $2, _typeId $4);
}
;

union_declare:
_union IDENTIFIER LC struct_field_list RC
{
    $$ = _vretained makeUnionExp(_typeId $2, _typeId $4);
}
;

struct_field_list:
            declaration SEMICOLON
            {
                NSMutableArray *list = [_typeId $1 mutableCopy];
                $$ = _vretained list;
            }
            | struct_field_list declaration SEMICOLON
            {
                NSMutableArray *list = _transfer(NSMutableArray *) $1;
                [list addObjectsFromArray:_transfer(NSMutableArray *) $2];
                $$ = _vretained list;
            }
            ;
enum_declare:
NS_ENUM LP declarator_type COMMA IDENTIFIER RP enum_declare
{
    OREnumStatNode *exp = _transfer(OREnumStatNode *) $7;
    exp.enumName = _typeId $5;
    exp.valueType = [_transfer(ORTypeNode *) $3 type];
    $$ = _vretained exp;
}
| NS_OPTIONS LP declarator_type COMMA IDENTIFIER RP enum_declare
{
    OREnumStatNode *exp = _transfer(OREnumStatNode *) $7;
    exp.enumName = _typeId $5;
    exp.valueType =  [_transfer(ORTypeNode *) $3 type];
    $$ = _vretained exp;
}
| _enum IDENTIFIER enum_declare
{
    OREnumStatNode *exp = _transfer(OREnumStatNode *) $3;
    exp.enumName = _typeId $2;
    $$ = _vretained exp;
}
| _enum enum_declare
{
    OREnumStatNode *exp = _transfer(OREnumStatNode *) $2;
    $$ = _vretained exp;
}
| LC enum_field_list RC
{
    $$ = _vretained makeEnumExp(@"",makeTypeNode(TypeInt), _typeId $2);
}
| COLON declarator_type LC enum_field_list RC
{
    $$ = _vretained makeEnumExp(@"",_typeId $2, _typeId $4);
}
;

enum_field_list:
assign_expression
{
    NSMutableArray *list = [@[_typeId $1] mutableCopy];
    $$ = (__bridge_retained void *)list;
}
| enum_field_list assign_expression
{
    NSMutableArray *list = _transfer(NSMutableArray *) $1;
    [list addObject:_typeId $2];
    $$ = _vretained list;
}
| enum_field_list COMMA
;

            
typedef_declare:
declarator_type declarator
{
    ORDeclaratorNode *pair = makeDeclaratorNode(_typeId $1, _typeId $2);
    $$ = _vretained makeTypedefExp(pair, pair.var.varname);
}
//for NS_ENUM NS_OPTIONS
| enum_declare
{
    $$ = _vretained makeTypedefExp(_typeId $1, @"");
}
| enum_declare IDENTIFIER
{
    $$ = _vretained makeTypedefExp(_typeId $1, _typeId $2);
}
| struct_declare IDENTIFIER
{
    $$ = _vretained makeTypedefExp(_typeId $1, _typeId $2);
}
;

protocol_declare:
PROTOCOL IDENTIFIER CHILD_COLLECTION_OPTIONAL
{
    ORProtocol *orprotcol = [GlobalAst protcolForName:_transfer(id)$2];
    NSString *supers = _transfer(NSString *)$3;
    if (supers != nil){
        NSArray *protocols = [supers componentsSeparatedByString:@","];
        orprotcol.protocols = [protocols mutableCopy];
    }
    $$ = _vretained orprotcol;
}
| protocol_declare PROPERTY class_property_declare parameter_declaration SEMICOLON
{
    ORProtocol *orprotcol = _transfer(ORProtocol *) $1;

    ORPropertyDeclare *property = [ORPropertyDeclare new];
    property.keywords = _transfer(NSMutableArray *) $3;
    property.var = _transfer(ORDeclaratorNode *) $4;
    
    [orprotcol.properties addObject:property];
    $$ = _vretained orprotcol;
}
| protocol_declare method_declare SEMICOLON
{
    ORProtocol *orprotcol = _transfer(ORProtocol *) $1;
    [orprotcol.methods addObject:_transfer(ORMethodDeclare *) $2];
    $$ = _vretained orprotcol;
}
| protocol_declare END
;
class_declare:
            //
            INTERFACE IDENTIFIER COLON IDENTIFIER CHILD_COLLECTION_OPTIONAL
            {
                ORClass *occlass = [GlobalAst classForName:_transfer(id)$2];
                occlass.superClassName = _transfer(id)$4;
                NSArray *protocols = [_transfer(NSString *)$5 componentsSeparatedByString:@","];
                occlass.protocols = [protocols mutableCopy];
                $$ = _vretained occlass;
            }
            // category 
            | INTERFACE IDENTIFIER LP IDENTIFIER RP CHILD_COLLECTION_OPTIONAL
            {
                ORClass *occlass = [GlobalAst classForName:_transfer(id)$2];
                NSArray *protocols = [_transfer(NSString *)$6 componentsSeparatedByString:@","];
                occlass.protocols = [protocols mutableCopy];
                $$ = _vretained occlass;
            }
            | INTERFACE IDENTIFIER LP RP CHILD_COLLECTION_OPTIONAL
            {
                ORClass *occlass = [GlobalAst classForName:_transfer(id)$2];
                NSArray *protocols = [_transfer(NSString *)$5 componentsSeparatedByString:@","];
                occlass.protocols = [protocols mutableCopy];
                $$ = _vretained occlass;
            }
            | class_declare LC class_private_varibale_declare RC
            {
                ORClass *occlass = _transfer(ORClass *) $1;
                [occlass.privateVariables addObjectsFromArray:_transfer(id) $3];
                $$ = _vretained occlass;
            }
            | class_declare PROPERTY class_property_declare parameter_declaration SEMICOLON
            {
                ORClass *occlass = _transfer(ORClass *) $1;

                ORPropertyDeclare *property = [ORPropertyDeclare new];
                property.keywords = _transfer(NSMutableArray *) $3;
                property.var = _transfer(ORDeclaratorNode *) $4;
                
                [occlass.properties addObject:property];
                $$ = _vretained occlass;
            }
            // 方法声明，不做处理
            | class_declare method_declare SEMICOLON
            | class_declare END
            ;


class_implementation:
            IMPLEMENTATION IDENTIFIER class_private_list
            {
                ORClass *occlass = [GlobalAst classForName:_transfer(id)$2];
                [occlass.privateVariables addObjectsFromArray:_transfer(id) $3];
                $$ = _vretained occlass;
            }
            // category
            | IMPLEMENTATION IDENTIFIER LP IDENTIFIER RP
            {
                $$ = _vretained [GlobalAst classForName:_transfer(id)$2];
            }
            | class_implementation method_declare LC function_implementation RC
            {
                ORMethodImplementation *imp = makeMethodImplementation(_transfer(ORMethodDeclare *) $2, _transfer(ORBlockNode *) $4);
                ORClass *occlass = _transfer(ORClass *) $1;
                [occlass.methods addObject:imp];
                $$ = _vretained occlass;
            }
            | class_implementation global_define
            | class_implementation END
            ;

class_private_list:
{
    NSMutableArray *list = [NSMutableArray array];
    $$ = (__bridge_retained void *)list;
}
| LC class_private_varibale_declare RC
{
    $$ = $2;
}

class_private_varibale_declare: // empty
            {
                NSMutableArray *list = [NSMutableArray array];
				$$ = (__bridge_retained void *)list;
            }
            | class_private_varibale_declare parameter_declaration SEMICOLON
            {
                NSMutableArray *list = _transfer(NSMutableArray *) $1;
				[list addObject:_transfer(ORDeclaratorNode *) $2];
				$$ = (__bridge_retained void *)list;
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
    NSMutableArray *list = [NSMutableArray array];
    NSString *identifier = (__bridge_transfer NSString *)$1;
    [list addObject:identifier];
    $$ = (__bridge_retained void *)list;
}
| property_list COMMA class_property_type
{
    NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
    NSString *identifier = (__bridge_transfer NSString *)$3;
    [list addObject:identifier];
    $$ = (__bridge_retained void *)list;
}
;

class_property_declare:
{
    NSMutableArray *list = [NSMutableArray array];
    $$ = (__bridge_retained void *)list;
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
                ORDeclaratorNode *declare = _transfer(ORDeclaratorNode *)$3;
                $$ = _vretained makeMethodDeclare(NO,declare);
            }
            | ADD LP parameter_declaration RP
            {
                ORDeclaratorNode *declare = _transfer(ORDeclaratorNode *)$3;
                $$ = _vretained makeMethodDeclare(YES,declare);
            }
            | method_declare IDENTIFIER
            {
                ORMethodDeclare *method = _transfer(ORMethodDeclare *)$$;
                [method.methodNames addObject:_transfer(NSString *) $2];
                $$ = _vretained method;
            }
            | method_declare IDENTIFIER COLON LP parameter_declaration RP IDENTIFIER
            {
                ORDeclaratorNode *pair = _transfer(ORDeclaratorNode *)$5;
                ORMethodDeclare *method = _transfer(ORMethodDeclare *)$$;
                [method.methodNames addObject:_transfer(NSString *) $2];
                [method.parameterTypes addObject:pair];
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
             ORMethodCall *methodcall = (ORMethodCall *) [ORMethodCall new];
             methodcall.caller =  makeValue(OCValueVariable,_typeId $2);
             NSArray *params = _transfer(NSArray *)$3;
             methodcall.names = params[0];
             methodcall.values = params[1];
             $$ = _vretained methodcall;
        }
        | LB postfix_expression objc_method_call_pramameters RB
        {
             ORMethodCall *methodcall = (ORMethodCall *) [ORMethodCall new];
             ORValueExpression *caller = _transfer(ORValueExpression *)$2;
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
declarator_type_opt:
{
    $$ = nil;
}
| declarator_type
        
block_implementation:
    //^returnType(optional) parameters(optional){ }
    POWER declarator_type_opt pointer_optional block_parameters_optinal LC function_implementation RC
    {
        ORDeclaratorNode *returnNode = makeDeclaratorNode(_typeId $2, makeVarNode(nil,$3));
        ORFunctionDeclarator *declare = [ORFunctionDeclarator new];
        declare.declarators = _transfer(NSMutableArray *)$4;
        declare.isBlock = YES;
        declare.returnNode = returnNode;
        ORFunctionImp *imp = [ORFunctionImp new];
        imp.scopeImp = _transfer(ORBlockNode *) $6;
        imp.declare = declare;
        $$ = _vretained imp;
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
            ORNode *node = _transfer(ORNode *) $1;
            node.withSemicolon = YES;
            $$ = _vretained node;
        }
        | declaration SEMICOLON
        {
            NSArray *declares = _transfer(NSArray *) $1;
            for (ORNode* node in declares){
                node.withSemicolon = YES;
            }
            $$ = _vretained declares;
        }
        |_return SEMICOLON
        {
            ORNode *node = makeControlStatement(ORControlStatReturn,nil);
            node.withSemicolon = YES;
            $$ = _vretained node;
        }
        | _return expression SEMICOLON
        {
            ORNode *node = makeControlStatement(ORControlStatReturn,_transfer(id)$2);
            node.withSemicolon = YES;
            $$ = _vretained node;
        }
        | _break SEMICOLON
        {
            ORNode *node = makeControlStatement(ORControlStatBreak, nil);
            node.withSemicolon = YES;
            $$ = _vretained node;
        }
        | _continue SEMICOLON
        {
            ORNode *node = makeControlStatement(ORControlStatContinue, nil);
            node.withSemicolon = YES;
            $$ = _vretained node;
        }
        ;

if_statement:
        IF LP expression RP expression_statement
        {
            ORBlockNode *imp = makeScopeImp();
            [imp addStatements:_transfer(id) $5];
            ORIfStatement *statement = makeIfStatement(_transfer(id) $3,imp);
            $$ = _vretained statement;
        }
        | IF LP expression RP LC function_implementation RC
        {
            ORIfStatement *statement = makeIfStatement(_transfer(id) $3,_transfer(ORBlockNode *)$6);
            $$ = _vretained statement;
        }
        | if_statement _else IF LP expression RP expression_statement
        {
            ORBlockNode *imp = makeScopeImp();
            [imp addStatements:_transfer(id) $7];
            ORIfStatement *elseIfStatement = makeIfStatement(_transfer(id) $5,imp);
            elseIfStatement.last = _transfer(ORIfStatement *)$1;
            $$  = _vretained elseIfStatement;
        }
        | if_statement _else IF LP expression RP LC function_implementation RC
        {
            ORIfStatement *elseIfStatement = makeIfStatement(_transfer(id) $5,_transfer(ORBlockNode *)$8);
            elseIfStatement.last = _transfer(ORIfStatement *)$1;
            $$  = _vretained elseIfStatement;
        }
        | if_statement _else expression_statement
        {
            ORBlockNode *imp = makeScopeImp();
            [imp addStatements:_transfer(id) $3];
            ORIfStatement *elseStatement = makeIfStatement(nil,imp);
            elseStatement.last = _transfer(ORIfStatement *)$1;
            $$  = _vretained elseStatement;
        }
        | if_statement _else LC function_implementation RC
        {
            ORIfStatement *elseStatement = makeIfStatement(nil,_transfer(ORBlockNode *)$4);
            elseStatement.last = _transfer(ORIfStatement *)$1;
            $$  = _vretained elseStatement;
        }
        ;

dowhile_statement: 
        _do LC function_implementation RC _while LP expression RP
        {
            ORDoWhileStatement *statement = makeDoWhileStatement(_transfer(id)$7,_transfer(ORBlockNode *)$3);
            $$ = _vretained statement;
        }
        ;
while_statement:
        _while LP expression RP LC function_implementation RC
        {
            ORWhileStatement *statement = makeWhileStatement(_transfer(id)$3,_transfer(ORBlockNode *)$6);
            $$ = _vretained statement;
        }
        ;

case_statement:
        _case primary_expression COLON
        {
             ORCaseStatement *statement = makeCaseStatement(_typeId $2);
            $$ = _vretained statement;
        }
        | _default COLON
        {
            ORCaseStatement *statement = makeCaseStatement(nil);
            $$ = _vretained statement;
        }
        | case_statement expression_statement
        {
            ORCaseStatement *statement =  _typeId $1;
            [statement.scopeImp addStatements:_typeId $2];
            $$ = _vretained statement;
        }
        | case_statement LC function_implementation RC
        {
            ORCaseStatement *statement =  _transfer(ORCaseStatement *)$1;
            statement.scopeImp = _transfer(ORBlockNode *) $3;
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
             ORSwitchStatement *statement = makeSwitchStatement(_transfer(id) $3);
             statement.cases = _typeId $6;
             $$ = _vretained statement;
         }
        ;

for_statement_var_list:
        | primary_expression
        {
            NSMutableArray *list = [NSMutableArray array];
            [list addObject:_transfer(id)$1];
            $$ = _vretained list;
        }
        | for_statement_var_list COMMA primary_expression
        {
            NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
            [list addObject:_transfer(id) $3];
            $$ = _vretained list;
        }

for_statement: _for LP declaration SEMICOLON expression SEMICOLON expression_list RP LC function_implementation RC
        {
            ORForStatement* statement = makeForStatement(_transfer(ORBlockNode *) $10);
            statement.varExpressions = _typeId $3;
            statement.condition = _typeId $5;
            statement.expressions = _typeId $7;
            $$ = _vretained statement;
        }
        |  _for LP for_statement_var_list SEMICOLON expression SEMICOLON expression_list RP LC function_implementation RC
               {
                   ORForStatement* statement = makeForStatement(_transfer(ORBlockNode *) $10);
                   statement.varExpressions = _typeId $3;
                   statement.condition = _typeId $5;
                   statement.expressions = _typeId $7;
                   $$ = _vretained statement;
               }
        ;

forin_statement: _for LP declaration _in expression RP LC function_implementation RC
        {
            ORForInStatement * statement = makeForInStatement(_transfer(ORBlockNode *)$8);
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
            $$ = _vretained makeScopeImp();
        }
        | function_implementation expression_statement 
        {
            ORBlockNode *imp = _transfer(ORBlockNode *)$1;
            [imp addStatements:_transfer(id) $2];
            $$ = _vretained imp;
        }
        | function_implementation control_statement
        {
            ORBlockNode *imp = _transfer(ORBlockNode *)$1;
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
        ORAssignExpression *expression = makeAssignExpression($2);
        expression.expression = _transfer(id) $3;
        expression.value = _transfer(ORValueExpression *)$1;
        $$ = _vretained expression;
    }
;

// ?:
ternary_expression: logic_or_expression
    | logic_or_expression QUESTION ternary_expression COLON ternary_expression
    {
        ORTernaryExpression *expression = makeTernaryExpression();
        expression.expression = _transfer(id)$1;
        [expression.values addObject:_transfer(id)$3];
        [expression.values addObject:_transfer(id)$5];
        $$ = _vretained expression;
    }
    | logic_or_expression QUESTION COLON ternary_expression
    {
        ORTernaryExpression *expression = makeTernaryExpression();
        expression.expression = _transfer(id)$1;
        [expression.values addObject:_transfer(id)$4];
        $$ = _vretained expression;
    }
    ;


// ||
logic_or_expression: logic_and_expression
    | logic_or_expression LOGIC_OR logic_or_expression
    {
        ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorLOGIC_OR);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    ;

// &&
logic_and_expression: bite_or_expression
    | logic_and_expression LOGIC_AND bite_or_expression
    {
        ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorLOGIC_AND);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    ;
// |
bite_or_expression: bite_xor_expression
    | bite_or_expression OR bite_xor_expression
    {
        ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorOr);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    ;
// ^
bite_xor_expression: bite_and_expression
    | bite_xor_expression POWER bite_and_expression
    {
        ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorXor);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    ;

// &
bite_and_expression: equality_expression
    | bite_and_expression AND equality_expression
    {
        ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorAnd);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    ;

// == !=
equality_expression: relational_expression
    | equality_expression EQ relational_expression
    {
        ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorEqual);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    | equality_expression NE relational_expression
    {
        ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorNotEqual);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
;
// < <= > >=
relational_expression: bite_shift_expression
    | relational_expression LT bite_shift_expression
    {
        ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorLT);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    | relational_expression LE bite_shift_expression
    {
        ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorLE);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    | relational_expression GT bite_shift_expression
    {
        ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorGT);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    | relational_expression GE bite_shift_expression
    {
        ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorGE);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    ;
// >> <<
bite_shift_expression: additive_expression
    | bite_shift_expression SHIFTLEFT additive_expression
    {
        ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorShiftLeft);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    | bite_shift_expression SHIFTRIGHT additive_expression
    {
        ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorShiftRight);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    ;
// + -
additive_expression: multiplication_expression
    | additive_expression ADD multiplication_expression
    {
        ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorAdd);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    | additive_expression SUB multiplication_expression
    {
        ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorSub);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    ;

// * / %
multiplication_expression: unary_expression
    | multiplication_expression ASTERISK unary_expression
    {
        ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorMulti);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    | multiplication_expression DIV unary_expression
    {
        ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorDiv);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    | multiplication_expression MOD unary_expression
    {
        ORBinaryExpression *exp = makeBinaryExpression(BinaryOperatorMod);
        exp.left = _transfer(id) $1;
        exp.right = _transfer(id) $3;
        $$ = _vretained exp;
    }
    ;

// !x -x *x &x ~x sizof(x) x++ x-- ++x --x
unary_expression: postfix_expression
    | unary_operator unary_expression
    {
        ORUnaryExpression *exp = makeUnaryExpression($1);
        exp.value = _transfer(id)$2;
        $$ = _vretained exp;
    }
    | _sizeof unary_expression
    {
        ORUnaryExpression *exp = makeUnaryExpression(UnaryOperatorSizeOf);
        exp.value = _transfer(id)$2;
        $$ = _vretained exp;
    }
    | INCREMENT unary_expression
    {
        ORUnaryExpression *exp = makeUnaryExpression(UnaryOperatorIncrementPrefix);
        exp.value = _transfer(id)$2;
        $$ = _vretained exp;
    }
    | DECREMENT unary_expression
    {
        ORUnaryExpression *exp = makeUnaryExpression(UnaryOperatorDecrementPrefix);
        exp.value = _transfer(id)$2;
        $$ = _vretained exp;
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
        exp.value = _transfer(id)$1;
        $$ = _vretained exp;
    }
    | postfix_expression DECREMENT
    {
        ORUnaryExpression *exp = makeUnaryExpression(UnaryOperatorDecrementSuffix);
        exp.value = _transfer(id)$1;
        $$ = _vretained exp;
    }
    | postfix_expression DOT IDENTIFIER
    {
        is_variable = true;
        ORMethodCall *methodcall = (ORMethodCall *)[ORMethodCall new];
        methodcall.caller =  _transfer(ORValueExpression *)$1;
        methodcall.methodOperator = MethodOpretorDot;
        methodcall.names = [@[_typeId $3] mutableCopy];
        $$ = _vretained methodcall;
    }
    | postfix_expression ARROW IDENTIFIER
    {
        ORMethodCall *methodcall = (ORMethodCall *) [ORMethodCall new];
        methodcall.caller =  _transfer(ORValueExpression *)$1;
        methodcall.methodOperator = MethodOpretorArrow;
        methodcall.names = [@[_typeId $3] mutableCopy];
        $$ = _vretained methodcall;
    }
    | postfix_expression LP expression_list RP
    {
        is_variable = true;
        $$ = _vretained makeFuncCall(_transfer(id) $1, _transfer(id) $3);
    }
    | postfix_expression LB expression RB
    {
        ORSubscriptExpression *value = [ORSubscriptExpression new];
        value.caller = _typeId $1;
        value.keyExp = _typeId $3;
        $$ = _vretained value;
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
            NSString *value = _transfer(NSString *)$1;
            
            if ([value hasPrefix:@"0x"]) {
                unsigned long long ullvalue = strtoull(value.UTF8String, NULL, 16);
                $$ = _vretained makeIntegerValue(ullvalue);
            }else{
                unsigned long long ullvalue = strtoull(value.UTF8String, NULL, 0);
                $$ = _vretained makeIntegerValue(ullvalue);
            }
        }
        | DOUBLE_LITERAL
        {
            NSString *value = _transfer(NSString *)$1;
            $$ = _vretained makeDoubleValue(value.doubleValue);
        }
    ;
dict_entrys:
        {
            NSMutableArray *array = [NSMutableArray array];
            $$ = _vretained array;
        }
        | dict_entrys expression COLON expression
        {
            NSMutableArray *array = _transfer(id)$1;
            [array addObject:@[_transfer(id)$2,_transfer(id)$4]];
            $$ = _vretained array;
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
            NSString *sel = _typeId $1;
            NSString *selector = [sel substringWithRange:NSMakeRange(10, sel.length - 11)];
            $$ = _vretained makeValue(OCValueSelector,selector);
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
            $$ = _vretained makeBoolValue(YES);
        }
        | _NO
        {
            $$ = _vretained makeBoolValue(NO);
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
        NSMutableArray *array = _transfer(NSMutableArray *)$3;
        for (ORInitDeclaratorNode *declare in array){
            declare.declarator.type = _typeId $2;
            declare.declarator.type.modifier = $1;
            _vretained declare;
        }
        $$ = _vretained array;
    }
    | declarator_type init_declarator_list
    {
        NSMutableArray *array = _transfer(NSMutableArray *)$2;
        for (ORInitDeclaratorNode *declare in array){
            declare.declarator.type = _typeId $1;
            _vretained declare;
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
    {
        ORDeclaratorNode *node = makeDeclaratorNode(nil, _typeId $1);
        $$ = _vretained makeInitDeclaratorNode(node, nil);
    }
    | declarator ASSIGN assign_expression
    {
        ORDeclaratorNode *node = makeDeclaratorNode(nil, _typeId $1);
        $$ = _vretained makeInitDeclaratorNode(node, _typeId $3);
    }
	;


declarator_optional:
        {
            $$ = _vretained makeVarNode(nil);
        }
        | declarator
        ;

declarator:
        direct_declarator
        | POWER direct_declarator_optional 
        {
            ORVariableNode *var = _transfer(ORVariableNode *)$2;
            var.isBlock = YES;
            $$ = _vretained var;
        }
        | pointer direct_declarator_optional
        {
            ORVariableNode *var = _transfer(ORVariableNode *)$2;
            var.ptCount = $1;
            $$ = _vretained var;
        }

        ;

direct_declarator_optional:
        {
            $$ = _vretained makeVarNode(nil);
        }
        | direct_declarator
        ;

direct_declarator:
IDENTIFIER
{
    $$ = _vretained makeVarNode(_typeId $1);
}
| LP declarator RP
{
    $$ = _vretained _typeId $2;
}
| direct_declarator LP parameter_type_list RP
{
    ORFunctionDeclarator *funVar = [ORFunctionDeclarator copyFromVar:_transfer(ORVariableNode *)$1];
    NSMutableArray *pairs = _transfer(NSMutableArray *)$3;
    if ([pairs lastObject] == [NSNull null]) {
        funVar.isMultiArgs = YES;
        [pairs removeLastObject];
    }
    funVar.declarators = pairs;
    $$ = _vretained funVar;
}
| direct_declarator LB expression_optional RB
{
    ORVariableNode *var = _transfer(ORVariableNode *)$1;
    if ($3 == NULL){
        var.ptCount += 1;
        $$ = _vretained var;
    }else{
        ORCArrayVariable *arrayVar = [ORCArrayVariable copyFromVar:var];
        arrayVar.capacity = _transfer(ORNode *)$3;
        $$ = _vretained arrayVar;
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
            NSMutableArray *array = _transfer(NSMutableArray *)$1;
            [array addObject:[NSNull null]];
            $$ = _vretained array;
        }
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
    declare_left_attribute declarator_type declarator_optional
    {
        $$ = _vretained makeDeclaratorNode(_typeId $2, _typeId $3);
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
    $$ = _vretained makeTypeNode(TypeObject, _typeId $1);
}
| _struct IDENTIFIER
{
    $$ = _vretained makeTypeNode(TypeStruct, _typeId $1);
}
| _union IDENTIFIER
{
    $$ = _vretained makeTypeNode(TypeUnion, _typeId $1);
}
| _id CHILD_COLLECTION_OPTIONAL
{
    $$ = _vretained makeTypeNode(TypeObject,@"id");
}
| TYPEOF LP expression RP
{
    $$ = _vretained makeTypeNode(TypeObject,@"typeof");
}
| _UCHAR
{
        $$ = _vretained makeTypeNode(TypeUChar);
}
| _USHORT
{
    $$ = _vretained makeTypeNode(TypeUShort);
}
| _UINT
{
    $$ = _vretained makeTypeNode(TypeUInt);
}
| _ULONG
{
    $$ = _vretained makeTypeNode(TypeULong);
}
| _ULLONG
{
    $$ = _vretained makeTypeNode(TypeULongLong);
}
| _CHAR
{
    $$ = _vretained makeTypeNode(TypeChar);
}
| _SHORT
{
    $$ = _vretained makeTypeNode(TypeShort);
}
| _INT
{
    $$ = _vretained makeTypeNode(TypeInt);
}
| _LONG
{
    $$ = _vretained makeTypeNode(TypeLong);
}
| _LLONG
{
    $$ = _vretained makeTypeNode(TypeLongLong);
}
| _DOUBLE
{
    $$ = _vretained makeTypeNode(TypeDouble);
}
| _FLOAT
{
    $$ = _vretained makeTypeNode(TypeFloat);
}
| _Class
{
    $$ = _vretained makeTypeNode(TypeClass);
}
| _BOOL
{
    $$ = _vretained makeTypeNode(TypeBOOL);
}
| _SEL
{
    $$ = _vretained makeTypeNode(TypeSEL);
}
| _void
{
    $$ = _vretained makeTypeNode(TypeVoid);
}
| _instancetype
{
    $$ = _vretained makeTypeNode(TypeObject,@"id");
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
