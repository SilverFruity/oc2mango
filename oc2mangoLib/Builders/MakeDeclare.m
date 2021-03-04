//
//  MakeDeclare.m
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "MakeDeclare.h"


ORTypeNode *makeTypeNode(TypeKind type ,NSString *name){
    return [ORTypeNode specialWithType:type name:name];
}
ORTypeNode *makeTypeNode(TypeKind type) __attribute__((overloadable)){
    return makeTypeNode(type, nil);
}
ORVariableNode *makeVarNode(NSString *name, NSUInteger ptCount){
    ORVariableNode *var = [ORVariableNode new];
    var.ptCount = ptCount;
    var.varname = name;
    return var;
}
ORVariableNode *makeVarNode(NSString *name) __attribute__((overloadable)){
    return makeVarNode(name, 0);
}

ORClass *makeOCClass(NSString *className){
    return [ORClass classWithClassName:className];
}
ORProtocol *makeORProtcol(NSString *protocolName){
    return [ORProtocol protcolWithProtcolName:protocolName];
}
ORMethodDeclare *makeMethodDeclare(BOOL isClassMethod, ORDeclaratorNode *returnType){
    ORMethodDeclare *method = [ORMethodDeclare new];
    method.methodNames = [NSMutableArray array];
    method.parameterNames  = [NSMutableArray array];
    method.parameterTypes = [NSMutableArray array];
    method.isClassMethod = isClassMethod;
    method.returnType = returnType;
    return method;
}
ORFunctionDeclarator *makeFunctionSignNode(void){
    ORFunctionDeclarator *decl = [ORFunctionDeclarator new];
    return decl;
}

ORMethodImplementation *makeMethodImplementation(ORMethodDeclare *declare, ORBlockNode *scopeImp){
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

ORBlockNode *makeScopeImp(){
    return [[ORBlockNode alloc] init];
}
ORFunctionCall *makeFuncCall(ORValueExpression *caller, NSMutableArray *expressions){
    ORFunctionCall *call = [ORFunctionCall new];
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
ORDeclaratorNode *makeDeclaratorNode(ORTypeNode *type,ORVariableNode *var){
    ORDeclaratorNode *node = [ORDeclaratorNode new];
    node.type = type;
    node.var = var;
    return node;
}

ORInitDeclaratorNode *makeInitDeclaratorNode(ORDeclaratorNode *declarator,ORNode * exp){
    ORInitDeclaratorNode *declare = [ORInitDeclaratorNode new];
    declare.declarator = declarator;
    declare.expression = exp;
    return declare;
}


ORIfStatement *makeIfStatement(ORNode * judgement, ORBlockNode *imp){
    ORIfStatement *statement = [ORIfStatement new];
    statement.scopeImp = imp;
    statement.condition = judgement;
    return statement;
}
ORWhileStatement *makeWhileStatement(ORNode *judgement, ORBlockNode *imp){
    ORWhileStatement *statement = [ORWhileStatement new];
    statement.scopeImp = imp;
    statement.condition = judgement;
    return statement;
}
ORDoWhileStatement *makeDoWhileStatement(ORNode *judgement, ORBlockNode *imp){
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
ORForStatement *makeForStatement(ORBlockNode *imp){
    ORForStatement *statement = [ORForStatement new];
    statement.scopeImp = imp;
    return statement;
}
ORForInStatement *makeForInStatement(ORBlockNode *imp){
    ORForInStatement *statement = [ORForInStatement new];
    statement.scopeImp = imp;
    return statement;
}

extern ORControlStatement *makeControlStatement(ORControlStateType type,ORNode * expression){
    ORControlStatement *statement = [ORControlStatement new];
    statement.type = type;
    statement.expression = expression;
    return statement;
}

ORTypedefStatNode *makeTypedefExp(id exp,NSString *newName){
    ORTypedefStatNode *typedefExp = [[ORTypedefStatNode alloc] init];
    typedefExp.expression = exp;
    typedefExp.typeNewName = newName;
    return typedefExp;
}
ORStructStatNode *makeStructExp(NSString *name, NSMutableArray *fields){
    ORStructStatNode *exp = [[ORStructStatNode alloc] init];
    exp.sturctName = name;
    exp.fields = fields;
    return exp;
}
ORUnionStatNode *makeUnionExp(NSString *name, NSMutableArray *fields){
    ORUnionStatNode *exp = [[ORUnionStatNode alloc] init];
    exp.unionName = name;
    exp.fields = fields;
    return exp;
}
OREnumStatNode *makeEnumExp(NSString *name, ORTypeNode *type, NSMutableArray *fields){
    OREnumStatNode *exp = [[OREnumStatNode alloc] init];
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
