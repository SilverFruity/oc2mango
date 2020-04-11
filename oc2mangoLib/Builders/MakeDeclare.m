//
//  MakeDeclare.m
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "MakeDeclare.h"


TypeSpecial *makeTypeSpecial(TypeKind type ,NSString *name){
    return [TypeSpecial specialWithType:type name:name];
}
TypeSpecial *makeTypeSpecial(TypeKind type) __attribute__((overloadable)){
    return makeTypeSpecial(type, nil);
}
Variable *makeVar(NSString *name, NSUInteger ptCount){
    Variable *var = [Variable new];
    var.ptCount = ptCount;
    var.varname = name;
    return var;
}
Variable *makeVar(NSString *name) __attribute__((overloadable)){
    return makeVar(name, 0);
}
extern TypeVarPair *makeTypeVarPair(TypeSpecial *type, Variable *var){
    TypeVarPair *pair = [TypeVarPair new];
    pair.type = type;
    pair.var = var;
    return pair;
}

OCClass *makeOCClass(NSString *className){
    return [OCClass classWithClassName:className];
}

MethodDeclare *makeMethodDeclare(BOOL isClassMethod, TypeVarPair *returnType){
    MethodDeclare *method = [MethodDeclare new];
    method.methodNames = [NSMutableArray array];
    method.parameterNames  = [NSMutableArray array];
    method.parameterTypes = [NSMutableArray array];
    method.isClassMethod = isClassMethod;
    method.returnType = returnType;
    return method;
}
FuncDeclare *makeFuncDeclare(TypeVarPair *returnType,FuncVariable *var){
    FuncDeclare *decl = [FuncDeclare new];
    decl.returnType = returnType;
    decl.var = var;
    return decl;
}

MethodImplementation *makeMethodImplementation(MethodDeclare *declare){
    MethodImplementation *imp = [MethodImplementation new];
    imp.declare = declare;
    return imp;
}



OCValue *makeValue(OC_VALUE_TYPE type, id value){
    OCValue *ocvalue;
    switch (type){
        case OCValueMethodCall:
            ocvalue = [OCMethodCall new];
            break;
        case OCValueFuncCall:
            ocvalue = [CFuncCall new];
            break;
        case OCValueBlock:
            ocvalue = [BlockImp new];
            break;
        case OCValueCollectionGetValue:
            ocvalue = [OCCollectionGetValue new];
            break;
        default:
            ocvalue = [OCValue new];
            break;
    }
    ocvalue.value_type = type;
    ocvalue.value = value;
    return ocvalue;
}
OCValue *makeValue(OC_VALUE_TYPE type) __attribute__((overloadable)){
    return makeValue(type, nil);
}
CFuncCall *makeFuncCall(OCValue *caller, NSMutableArray *expressions){
    CFuncCall *call = [CFuncCall new];
    call.value_type = OCValueFuncCall;
    call.caller = caller;
    call.expressions = expressions;
    if ([caller.value isKindOfClass:[NSString class]]) {
        NSLog(@"%@",caller.value);
    }
    return call;
}
UnaryExpression *makeUnaryExpression(UnaryOperatorType type){
    UnaryExpression *expression = [UnaryExpression  new];
    expression.operatorType = type;
    return expression;
}
BinaryExpression *makeBinaryExpression(BinaryOperatorType type)
{
    BinaryExpression *expression = [BinaryExpression new];
    expression.operatorType = type;
    return expression;
}
TernaryExpression *makeTernaryExpression(){
    return [TernaryExpression  new];
}

AssignExpression *makeAssignExpression(AssignOperatorType type){
    AssignExpression *expression = [AssignExpression new];
    expression.assignType = type;
    return expression;
}
extern DeclareExpression *makeDeclareExpression(TypeSpecial *type,Variable *var,id <Expression> exp){
    DeclareExpression *declare = [DeclareExpression new];
    declare.pair = makeTypeVarPair(type, var);
    declare.expression = exp;
    return declare;
}



IfStatement *makeIfStatement(id <Expression> judgement, BlockImp *imp){
    IfStatement *statement = [IfStatement new];
    statement.funcImp = imp;
    statement.condition = judgement;
    return statement;
}
WhileStatement *makeWhileStatement(id <Expression>judgement, BlockImp *imp){
    WhileStatement *statement = [WhileStatement new];
    statement.funcImp = imp;
    statement.condition = judgement;
    return statement;
}
DoWhileStatement *makeDoWhileStatement(id <Expression>judgement, BlockImp *imp){
    DoWhileStatement *statement = [DoWhileStatement new];
    statement.condition = judgement;
    statement.funcImp = imp;
    return statement;
}
CaseStatement *makeCaseStatement(OCValue *value){
    CaseStatement *statement = [CaseStatement new];
    statement.value = value;
    statement.funcImp = [BlockImp new];
    return statement;
}
SwitchStatement *makeSwitchStatement(OCValue *value){
    SwitchStatement *statement = [SwitchStatement new];
    statement.value = value;
    return statement;
}
ForStatement *makeForStatement(BlockImp *imp){
    ForStatement *statement = [ForStatement new];
    statement.funcImp = imp;
    return statement;
}
ForInStatement *makeForInStatement(BlockImp *imp){
    ForInStatement *statement = [ForInStatement new];
    statement.funcImp = imp;
    return statement;
}

ReturnStatement *makeReturnStatement(id <ValueExpression> expression){
    ReturnStatement *statement = [ReturnStatement new];
    statement.expression = expression;
    return statement;
}
BreakStatement *makeBreakStatement(void){
    return [BreakStatement new];
}

ContinueStatement *makeContinueStatement(void){
    return [ContinueStatement new];
}

static NSMutableString *buffer = nil;
static char *string_buffer = NULL;
static int string_buffer_index = 0;
static int string_buffer_size = 0;
#define STRING_BUFFER_ALLOC_SIZE 256;
void startStringBuffer(void){
    string_buffer_index = 0;
}
char *endStringBuffer(void){
    stringBufferAppendCharacter('\0');
    size_t strLen = strlen(string_buffer);
    char *str = malloc(strLen + 1);
    strcpy(str, string_buffer);
    free(string_buffer);
    string_buffer = NULL;
    string_buffer_index = 0;
    string_buffer_size = 0;
    return str;
}
void stringBufferAppendCharacter(char chr){
   if (string_buffer_index >= string_buffer_size) {
        string_buffer_size +=  STRING_BUFFER_ALLOC_SIZE;
        void *new_pointer = realloc(string_buffer, string_buffer_size);
        free(string_buffer);
        string_buffer = new_pointer;
    }
    string_buffer[string_buffer_index] = chr;
    string_buffer_index++;
}
