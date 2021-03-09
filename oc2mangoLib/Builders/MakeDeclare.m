//
//  MakeDeclare.m
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "MakeDeclare.h"
#import "Env.h"
ORTypeNode *makeTypeNode(OCType type ,NSString *name){
    __autoreleasing ORTypeNode *node = [ORTypeNode specialWithType:type name:name];
    return node;
}
ORTypeNode *makeTypeNode(OCType type) __attribute__((overloadable)){
    return makeTypeNode(type, nil);
}
ORVariableNode *makeVarNode(NSString *name, NSUInteger ptCount){
    __autoreleasing ORVariableNode *var = [ORVariableNode new];
    var.ptCount = ptCount;
    var.varname = name;
    return var;
}
ORVariableNode *makeVarNode(NSString *name) __attribute__((overloadable)){
    return makeVarNode(name, 0);
}

ORClassNode *makeOCClass(NSString *className){
    __autoreleasing ORClassNode *node = [ORClassNode classNodeWithClassName:className];
    return node;
}
ORProtocolNode *makeORProtcol(NSString *protocolName){
    __autoreleasing ORProtocolNode *node = [ORProtocolNode protcolWithProtcolName:protocolName];
    return node;
}
ORPropertyNode *makePropertyDeclare(NSMutableArray *keywords, ORDeclaratorNode *var){
    __autoreleasing ORPropertyNode *node = [ORPropertyNode new];
    node.keywords = keywords;
    node.var = var;
    return node;
}
ORMethodDeclNode *makeMethodDeclare(BOOL isClassMethod, ORDeclaratorNode *returnType){
    __autoreleasing ORMethodDeclNode *method = [ORMethodDeclNode new];
    method.methodNames = [NSMutableArray array];
    method.parameterNames  = [NSMutableArray array];
    method.parameterTypes = [NSMutableArray array];
    method.isClassMethod = isClassMethod;
    method.returnType = returnType;
    return method;
}
ORFunctionDeclNode *makeFunctionSignNode(void){
    __autoreleasing ORFunctionDeclNode *decl = [ORFunctionDeclNode new];
    return decl;
}
extern ORMethodCall *makeMethodCall(void){
    __autoreleasing ORMethodCall *call = [ORMethodCall new];
    return call;
}
ORMethodNode *makeMethodImplementation(ORMethodDeclNode *declare, ORBlockNode *scopeImp){
    __autoreleasing ORMethodNode *imp = [ORMethodNode new];
    imp.declare = declare;
    imp.scopeImp = scopeImp;
    return imp;
}



ORValueNode *makeValue(OC_VALUE_TYPE type, id value){
    __autoreleasing ORValueNode *ocvalue = [ORValueNode new];
    ocvalue.value_type = type;
    ocvalue.value = value;
    return ocvalue;
}
ORValueNode *makeValue(OC_VALUE_TYPE type) __attribute__((overloadable)){
    return makeValue(type, nil);
}
ORBlockNode *makeScopeImp(NSMutableArray *stats){
    __autoreleasing ORBlockNode *node = [ORBlockNode new];
    if (stats) {
        node.statements = stats;
    }
    return node;
}
ORBlockNode *makeScopeImp(void) __attribute__((overloadable)){
    return makeScopeImp(nil);
}
ORFunctionCall *makeFuncCall(ORValueNode *caller, NSMutableArray *expressions){
    __autoreleasing ORFunctionCall *call = [ORFunctionCall new];
    call.caller = caller;
    call.expressions = expressions;
    return call;
}
ORUnaryNode *makeUnaryExpression(UnaryOperatorType type, ORNode *node){
    __autoreleasing ORUnaryNode *expression = [ORUnaryNode  new];
    expression.operatorType = type;
    expression.value = node;
    return expression;
}
ORBinaryNode *makeBinaryExpression(BinaryOperatorType type, ORNode *left, ORNode *right){
    __autoreleasing ORBinaryNode *expression = [ORBinaryNode new];
    expression.operatorType = type;
    expression.left = left;
    expression.right = right;
    return expression;
}
ORTernaryNode *makeTernaryExpression(){
    __autoreleasing ORTernaryNode *node = [ORTernaryNode new];
    return node;
}

ORAssignNode *makeAssignExpression(AssignOperatorType type){
    __autoreleasing ORAssignNode *expression = [ORAssignNode new];
    expression.assignType = type;
    return expression;
}
ORDeclaratorNode *makeDeclaratorNode(ORTypeNode *type,ORVariableNode *var){
    __autoreleasing ORDeclaratorNode *node = [ORDeclaratorNode new];
    node.type = type;
    node.var = var;
    return node;
}

ORInitDeclaratorNode *makeInitDeclaratorNode(ORDeclaratorNode *declarator,ORNode * exp){
    
    __autoreleasing ORInitDeclaratorNode *declare = [ORInitDeclaratorNode new];
    declare.declarator = declarator;
    declare.expression = exp;
    return declare;
}

ORFunctionDeclNode *makeFunctionDeclNode(void){
    __autoreleasing ORFunctionDeclNode *node = [ORFunctionDeclNode new];
    return node;
}
ORSubscriptNode *makeSubscriptNode(ORNode *caller, ORNode *key){
    __autoreleasing ORSubscriptNode *node = [ORSubscriptNode new];
    node.caller = caller;
    node.keyExp = key;
    return node;
}
ORFunctionNode *makeFunctionNode(ORFunctionDeclNode *decl, ORBlockNode *block){
    __autoreleasing ORFunctionNode *node = [ORFunctionNode new];
    node.declare = decl;
    node.scopeImp = block;
    return node;
}
ORIfStatement *makeIfStatement(ORNode * judgement, ORBlockNode *imp){
    __autoreleasing ORIfStatement *statement = [ORIfStatement new];
    statement.scopeImp = imp;
    statement.condition = judgement;
    return statement;
}
ORWhileStatement *makeWhileStatement(ORNode *judgement, ORBlockNode *imp){
    __autoreleasing ORWhileStatement *statement = [ORWhileStatement new];
    statement.scopeImp = imp;
    statement.condition = judgement;
    return statement;
}
ORDoWhileStatement *makeDoWhileStatement(ORNode *judgement, ORBlockNode *imp){
    __autoreleasing ORDoWhileStatement *statement = [ORDoWhileStatement new];
    statement.condition = judgement;
    statement.scopeImp = imp;
    return statement;
}
ORCaseStatement *makeCaseStatement(ORValueNode *value){
    __autoreleasing ORCaseStatement *statement = [ORCaseStatement new];
    statement.value = value;
    statement.scopeImp = makeScopeImp();
    return statement;
}
ORSwitchStatement *makeSwitchStatement(ORValueNode *value){
    __autoreleasing ORSwitchStatement *statement = [ORSwitchStatement new];
    statement.value = value;
    return statement;
}
ORForStatement *makeForStatement(ORBlockNode *imp){
    __autoreleasing ORForStatement *statement = [ORForStatement new];
    statement.scopeImp = imp;
    return statement;
}
ORForInStatement *makeForInStatement(ORBlockNode *imp){
    __autoreleasing ORForInStatement *statement = [ORForInStatement new];
    statement.scopeImp = imp;
    return statement;
}

extern ORControlStatNode *makeControlStatement(ORControlStateType type,ORNode * expression){
    __autoreleasing ORControlStatNode *statement = [ORControlStatNode new];
    statement.type = type;
    statement.expression = expression;
    return statement;
}

ORTypedefStatNode *makeTypedefExp(id exp,NSString *newName){
    __autoreleasing ORTypedefStatNode *typedefExp = [[ORTypedefStatNode alloc] init];
    typedefExp.expression = exp;
    typedefExp.typeNewName = newName;
    return typedefExp;
}
ORStructStatNode *makeStructExp(NSString *name, NSMutableArray *fields){
    __autoreleasing ORStructStatNode *exp = [[ORStructStatNode alloc] init];
    exp.sturctName = name;
    exp.fields = fields;
    return exp;
}
ORUnionStatNode *makeUnionExp(NSString *name, NSMutableArray *fields){
    __autoreleasing ORUnionStatNode *exp = [[ORUnionStatNode alloc] init];
    exp.unionName = name;
    exp.fields = fields;
    return exp;
}
OREnumStatNode *makeEnumExp(NSString *name, ORTypeNode *type, NSMutableArray *fields){
    __autoreleasing OREnumStatNode *exp = [[OREnumStatNode alloc] init];
    exp.enumName = name;
    exp.valueType = type.type;
    exp.fields = fields;
    return exp;
}

ORNode *makeIntegerValue(uint64_t value){
    if (value <= INT64_MAX) {
        __autoreleasing ORIntegerValue *ivalue = [ORIntegerValue new];
        ivalue.value = (int64_t)value;
        return ivalue;
    }else{
        __autoreleasing ORUIntegerValue *uvalue = [ORUIntegerValue new];
        uvalue.value = value;
        return uvalue;
    }
}

ORDoubleValue *makeDoubleValue(double value){
    __autoreleasing ORDoubleValue *dvalue = [ORDoubleValue new];
    dvalue.value = value;
    return dvalue;
}

ORBoolValue *makeBoolValue(BOOL value){
    __autoreleasing ORBoolValue *dvalue = [ORBoolValue new];
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
        string_buffer = realloc(string_buffer, string_buffer_size);
    }
    string_buffer[string_buffer_index] = chr;
    string_buffer_index++;
}
void stringBufferAppendString(char *str){
    size_t len = strlen(str);
    if (string_buffer_index + len > string_buffer_size) {
         string_buffer_size +=  STRING_BUFFER_ALLOC_SIZE;
         string_buffer = realloc(string_buffer, string_buffer_size);
    }
    strncpy(string_buffer+string_buffer_index, str, len);
    string_buffer_index += len;
}
NSMutableArray *makeMutableArray(id object){
    __autoreleasing NSMutableArray *array = [NSMutableArray array];
    if (object) {
        [array addObject:object];
    }
    return array;
}
