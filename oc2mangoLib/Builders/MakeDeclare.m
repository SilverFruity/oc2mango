//
//  MakeDeclare.m
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "MakeDeclare.h"


ORTypeSpecial *makeTypeSpecial(TypeKind type ,NSString *name){
    return [ORTypeSpecial specialWithType:type name:name];
}
ORTypeSpecial *makeTypeSpecial(TypeKind type) __attribute__((overloadable)){
    return makeTypeSpecial(type, nil);
}
ORVariable *makeVar(NSString *name, NSUInteger ptCount){
    ORVariable *var = [ORVariable new];
    var.ptCount = ptCount;
    var.varname = name;
    return var;
}
ORVariable *makeVar(NSString *name) __attribute__((overloadable)){
    return makeVar(name, 0);
}
extern ORTypeVarPair *makeTypeVarPair(ORTypeSpecial *type, ORVariable *var){
    ORTypeVarPair *pair = [ORTypeVarPair new];
    pair.type = type;
    pair.var = var;
    return pair;
}

ORClass *makeOCClass(NSString *className){
    return [ORClass classWithClassName:className];
}

ORMethodDeclare *makeMethodDeclare(BOOL isClassMethod, ORTypeVarPair *returnType){
    ORMethodDeclare *method = [ORMethodDeclare new];
    method.methodNames = [NSMutableArray array];
    method.parameterNames  = [NSMutableArray array];
    method.parameterTypes = [NSMutableArray array];
    method.isClassMethod = isClassMethod;
    method.returnType = returnType;
    return method;
}
ORFuncDeclare *makeFuncDeclare(ORTypeVarPair *returnType,ORFuncVariable *var){
    ORFuncDeclare *decl = [ORFuncDeclare new];
    decl.returnType = returnType;
    decl.funVar = var;
    return decl;
}

ORMethodImplementation *makeMethodImplementation(ORMethodDeclare *declare){
    ORMethodImplementation *imp = [ORMethodImplementation new];
    imp.declare = declare;
    return imp;
}



ORValueExpression *makeValue(OC_VALUE_TYPE type, id value){
    ORValueExpression *ocvalue;
    switch (type){
        case OCValueMethodCall:
            ocvalue = [ORMethodCall new];
            break;
        case OCValueFuncCall:
            ocvalue = [ORCFuncCall new];
            break;
        case OCValueBlock:
            ocvalue = [ORBlockImp new];
            break;
        case OCValueCollectionGetValue:
            ocvalue = [ORSubscriptExpression new];
            break;
        default:
            ocvalue = [ORValueExpression new];
            break;
    }
    ocvalue.value_type = type;
    ocvalue.value = value;
    return ocvalue;
}
ORValueExpression *makeValue(OC_VALUE_TYPE type) __attribute__((overloadable)){
    return makeValue(type, nil);
}
ORCFuncCall *makeFuncCall(ORValueExpression *caller, NSMutableArray *expressions){
    ORCFuncCall *call = [ORCFuncCall new];
    call.value_type = OCValueFuncCall;
    call.caller = caller;
    call.expressions = expressions;
    return call;
}
ORUnaryExpression *makeUnaryExpression(UnaryOperatorType type){
    ORUnaryExpression *expression = [ORUnaryExpression  new];
    expression.operatorType = type;
    return expression;
}
ORBinaryExpression *makeBinaryExpression(BinaryOperatorType type)
{
    ORBinaryExpression *expression = [ORBinaryExpression new];
    expression.operatorType = type;
    return expression;
}
ORTernaryExpression *makeTernaryExpression(){
    return [ORTernaryExpression  new];
}

ORAssignExpression *makeAssignExpression(AssignOperatorType type){
    ORAssignExpression *expression = [ORAssignExpression new];
    expression.assignType = type;
    return expression;
}
extern ORDeclareExpression *makeDeclareExpression(ORTypeSpecial *type,ORVariable *var,ORExpression * exp){
    ORDeclareExpression *declare = [ORDeclareExpression new];
    declare.pair = makeTypeVarPair(type, var);
    declare.expression = exp;
    return declare;
}



ORIfStatement *makeIfStatement(ORExpression * judgement, ORBlockImp *imp){
    ORIfStatement *statement = [ORIfStatement new];
    statement.funcImp = imp;
    statement.condition = judgement;
    return statement;
}
ORWhileStatement *makeWhileStatement(ORExpression *judgement, ORBlockImp *imp){
    ORWhileStatement *statement = [ORWhileStatement new];
    statement.funcImp = imp;
    statement.condition = judgement;
    return statement;
}
ORDoWhileStatement *makeDoWhileStatement(ORExpression *judgement, ORBlockImp *imp){
    ORDoWhileStatement *statement = [ORDoWhileStatement new];
    statement.condition = judgement;
    statement.funcImp = imp;
    return statement;
}
ORCaseStatement *makeCaseStatement(ORValueExpression *value){
    ORCaseStatement *statement = [ORCaseStatement new];
    statement.value = value;
    statement.funcImp = [ORBlockImp new];
    return statement;
}
ORSwitchStatement *makeSwitchStatement(ORValueExpression *value){
    ORSwitchStatement *statement = [ORSwitchStatement new];
    statement.value = value;
    return statement;
}
ORForStatement *makeForStatement(ORBlockImp *imp){
    ORForStatement *statement = [ORForStatement new];
    statement.funcImp = imp;
    return statement;
}
ORForInStatement *makeForInStatement(ORBlockImp *imp){
    ORForInStatement *statement = [ORForInStatement new];
    statement.funcImp = imp;
    return statement;
}

ORReturnStatement *makeReturnStatement(ORExpression* expression){
    ORReturnStatement *statement = [ORReturnStatement new];
    statement.expression = expression;
    return statement;
}
ORBreakStatement *makeBreakStatement(void){
    return [ORBreakStatement new];
}

ORContinueStatement *makeContinueStatement(void){
    return [ORContinueStatement new];
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
