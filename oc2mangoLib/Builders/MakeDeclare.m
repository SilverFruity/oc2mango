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
ORProtocol *makeORProtcol(NSString *protocolName){
    return [ORProtocol protcolWithProtcolName:protocolName];
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

ORMethodImplementation *makeMethodImplementation(ORMethodDeclare *declare, ORScopeImp *scopeImp){
    ORMethodImplementation *imp = [ORMethodImplementation new];
    imp.declare = declare;
    imp.scopeImp = scopeImp;
    return imp;
}



ORValueExpression *makeValue(OC_VALUE_TYPE type, id value){
    ORValueExpression *ocvalue = [ORValueExpression new];
    ocvalue.value_type = type;
    ocvalue.value = value;
    return ocvalue;
}
ORValueExpression *makeValue(OC_VALUE_TYPE type) __attribute__((overloadable)){
    return makeValue(type, nil);
}

ORScopeImp *makeScopeImp(){
    return [[ORScopeImp alloc] init];
}
ORCFuncCall *makeFuncCall(ORValueExpression *caller, NSMutableArray *expressions){
    ORCFuncCall *call = [ORCFuncCall new];
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
extern ORDeclareExpression *makeDeclareExpression(ORTypeSpecial *type,ORVariable *var,ORNode * exp){
    ORDeclareExpression *declare = [ORDeclareExpression new];
    declare.pair = makeTypeVarPair(type, var);
    declare.expression = exp;
    return declare;
}



ORIfStatement *makeIfStatement(ORNode * judgement, ORScopeImp *imp){
    ORIfStatement *statement = [ORIfStatement new];
    statement.scopeImp = imp;
    statement.condition = judgement;
    return statement;
}
ORWhileStatement *makeWhileStatement(ORNode *judgement, ORScopeImp *imp){
    ORWhileStatement *statement = [ORWhileStatement new];
    statement.scopeImp = imp;
    statement.condition = judgement;
    return statement;
}
ORDoWhileStatement *makeDoWhileStatement(ORNode *judgement, ORScopeImp *imp){
    ORDoWhileStatement *statement = [ORDoWhileStatement new];
    statement.condition = judgement;
    statement.scopeImp = imp;
    return statement;
}
ORCaseStatement *makeCaseStatement(ORValueExpression *value){
    ORCaseStatement *statement = [ORCaseStatement new];
    statement.value = value;
    statement.scopeImp = makeScopeImp();
    return statement;
}
ORSwitchStatement *makeSwitchStatement(ORValueExpression *value){
    ORSwitchStatement *statement = [ORSwitchStatement new];
    statement.value = value;
    return statement;
}
ORForStatement *makeForStatement(ORScopeImp *imp){
    ORForStatement *statement = [ORForStatement new];
    statement.scopeImp = imp;
    return statement;
}
ORForInStatement *makeForInStatement(ORScopeImp *imp){
    ORForInStatement *statement = [ORForInStatement new];
    statement.scopeImp = imp;
    return statement;
}

ORReturnStatement *makeReturnStatement(ORNode* expression){
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

extern ORTypedefExpressoin *makeTypedefExp(id exp,NSString *newName){
    ORTypedefExpressoin *typedefExp = [[ORTypedefExpressoin alloc] init];
    typedefExp.expression = exp;
    typedefExp.typeNewName = newName;
    return typedefExp;
}
extern ORStructExpressoin *makeStructExp(NSString *name, NSMutableArray *fields){
    ORStructExpressoin *exp = [[ORStructExpressoin alloc] init];
    exp.sturctName = name;
    exp.fields = fields;
    return exp;
}
extern OREnumExpressoin *makeEnumExp(NSString *name, ORTypeSpecial *type, NSMutableArray *fields){
    OREnumExpressoin *exp = [[OREnumExpressoin alloc] init];
    exp.enumName = name;
    exp.valueType = type.type;
    exp.fields = fields;
    return exp;
}

ORNode *makeIntegerValue(uint64_t value){
    if (value <= INT64_MAX) {
        ORIntegerValue *ivalue = [ORIntegerValue new];
        ivalue.value = (int64_t)value;
        return ivalue;
    }else{
        ORUIntegerValue *uvalue = [ORUIntegerValue new];
        uvalue.value = value;
        return uvalue;
    }
}

ORDoubleValue *makeDoubleValue(double value){
    ORDoubleValue *dvalue = [ORDoubleValue new];
    dvalue.value = value;
    return dvalue;
}

ORBoolValue *makeBoolValue(BOOL value){
    ORBoolValue *dvalue = [ORBoolValue new];
    dvalue.value = value;
    return dvalue;
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
void stringBufferAppendString(char *str){
    size_t len = strlen(str);
    if (string_buffer_index + len > string_buffer_size) {
         string_buffer_size +=  STRING_BUFFER_ALLOC_SIZE;
         void *new_pointer = realloc(string_buffer, string_buffer_size);
         free(string_buffer);
         string_buffer = new_pointer;
    }
    strncpy(string_buffer+string_buffer_index, str, len);
    string_buffer_index += len;
}
