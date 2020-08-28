//  BinaryPatch.m
//  Generate By BinaryPatchGenerator
//  Created by Jiang on 1598646865
//  Copyright © 2020 SilverFruity. All rights reserved.
#import "BinaryPatch.h"
#import "ORPatchFile.h"
typedef enum: uint64_t{
    ORNodeType = 0,
    PatchNodeType = 1,
    StringNodeType = 2,
    StringsNodeType = 3,
    ListNodeType = 4,
    _ORTypeSpecialNode = 5,
    _ORVariableNode = 6,
    _ORTypeVarPairNode = 7,
    _ORFuncVariableNode = 8,
    _ORFuncDeclareNode = 9,
    _ORScopeImpNode = 10,
    _ORValueExpressionNode = 11,
    _ORMethodCallNode = 12,
    _ORCFuncCallNode = 13,
    _ORFunctionImpNode = 14,
    _ORSubscriptExpressionNode = 15,
    _ORAssignExpressionNode = 16,
    _ORDeclareExpressionNode = 17,
    _ORUnaryExpressionNode = 18,
    _ORBinaryExpressionNode = 19,
    _ORTernaryExpressionNode = 20,
    _ORIfStatementNode = 21,
    _ORWhileStatementNode = 22,
    _ORDoWhileStatementNode = 23,
    _ORCaseStatementNode = 24,
    _ORSwitchStatementNode = 25,
    _ORForStatementNode = 26,
    _ORForInStatementNode = 27,
    _ORReturnStatementNode = 28,
    _ORBreakStatementNode = 29,
    _ORContinueStatementNode = 30,
    _ORPropertyDeclareNode = 31,
    _ORMethodDeclareNode = 32,
    _ORMethodImplementationNode = 33,
    _ORClassNode = 34,
    _ORProtocolNode = 35,
    _ORStructExpressoinNode = 36,
    _OREnumExpressoinNode = 37,
    _ORTypedefExpressoinNode = 38,

}_NodeType;
#pragma pack(1)
#pragma pack(show)

_ORNode *_ORNodeConvert(id exp, _PatchNode *patch);
id _ORNodeDeConvert(_ORNode *node, _PatchNode *patch);

_ListNode *_ListNodeConvert(NSArray *array, _PatchNode *patch){
    _ListNode *node = malloc(sizeof(_ListNode));
    memset(node, 0, sizeof(_ListNode));
    node->nodes = malloc(sizeof(void *) * array.count);
    for (id object in array) {
        _ORNode *element = _ORNodeConvert(object, patch);;
        node->nodes[node->count] = element;
        node->nodeType = ListNodeType;
        node->length += element->length;
        node->count++;
    }
    return node;
}

NSMutableArray *_ListNodeDeConvert(_ListNode *node, _PatchNode *patch){
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < node->count; i++) {
        id result = _ORNodeDeConvert(node->nodes[i], patch);
        [array addObject:result];
    }
    return array;
}

static NSMutableDictionary *_stringMap = nil;
_StringNode *saveNewString(NSString *string, _PatchNode *patch){
    _StringNode * strNode = malloc(sizeof(_StringNode));
    memset(strNode, 0, sizeof(_StringNode));
    const char *str = string.UTF8String;
    size_t len = strlen(str);
    strNode->strLen = len;
    strNode->length = _StringNodeLength;
    strNode->nodeType = StringNodeType;
    
    if (_stringMap[string]) {
        uint64_t offset = [_stringMap[string] unsignedLongLongValue];
        strNode->offset = offset;
        return strNode;
    }
    
    NSUInteger needLength = string.length + patch->strings->length;
    if (patch->strings->buffer == NULL) {
        patch->strings->buffer = malloc(string.length + patch->strings->length);
    }else if (needLength > strlen(patch->strings->buffer)){
        NSUInteger bufferLength = strlen(patch->strings->buffer);
        NSUInteger addLength = 512;
        NSUInteger newLength = addLength + bufferLength;
        patch->strings->buffer = realloc(patch->strings->buffer, newLength);
        memset(patch->strings->buffer + bufferLength, 0, addLength);
        patch->strings->buffer[newLength - 1] = '\0';
    }
    
    strNode->offset = patch->strings->cursor;
    _stringMap[string] = @(strNode->offset);
    memcpy(patch->strings->buffer + patch->strings->cursor, str, len);
    patch->strings->cursor += len;
    patch->strings->length += len;
    return strNode;
}

NSString *getString(_StringNode *node, _PatchNode *patch){
    char *cursor = patch->strings->buffer + node->offset;
    char *buffer = alloca(node->strLen + 1);
    memcpy(buffer, cursor, node->strLen);
    buffer[node->strLen] = '\0';
    return [NSString stringWithUTF8String:buffer];
}

_PatchNode *_PatchNodeConvert(ORPatchFile *patch){
    _stringMap = [NSMutableDictionary dictionary];
    _PatchNode *node = malloc(sizeof(_PatchNode));
    memset(node, 0, sizeof(_PatchNode));
    node->strings = malloc(sizeof(_StringNode));
    memset(node->strings, 0, sizeof(_StringNode));
    node->nodeType = PatchNodeType;
    node->enable = patch.enable;
    node->appVersion = (_StringNode *)_ORNodeConvert(patch.appVersion, node);
    node->osVersion = (_StringNode *)_ORNodeConvert(patch.osVersion, node);
    node->nodes = (_ListNode *)_ORNodeConvert(patch.nodes, node);
    node->length = _ORNodeLength + node->appVersion->length + node->strings->length + node->osVersion->length + node->nodes->length;
    return node;
}

ORPatchFile *_PatchNodeDeConvert(_PatchNode *patch){
    ORPatchFile *file = [ORPatchFile new];
    file.appVersion = _ORNodeDeConvert((_ORNode *)patch->appVersion, patch);
    file.osVersion = _ORNodeDeConvert((_ORNode *)patch->osVersion, patch);
    file.enable = patch->enable;
    NSMutableArray *nodes = [NSMutableArray array];
    for (int i = 0; i < patch->nodes->count; i++) {
        [nodes addObject:_ORNodeDeConvert(patch->nodes->nodes[i], patch)];
    }
    file.nodes = nodes;
    return file;
}
typedef struct {
    _ORNodeFields
    uint64_t type;
    _StringNode *name;
}_ORTypeSpecial;
static uint64_t _ORTypeSpecialLength = 32;
_ORTypeSpecial *_ORTypeSpecialConvert(ORTypeSpecial *exp, _PatchNode *patch){
    _ORTypeSpecial *node = malloc(sizeof(_ORTypeSpecial));
    memset(node, 0, sizeof(_ORTypeSpecial));
    node->nodeType = _ORTypeSpecialNode;
    node->length = _ORTypeSpecialLength;
    node->type = exp.type;
    node->name = (_StringNode *)_ORNodeConvert(exp.name, patch);
    return node;
}
ORTypeSpecial *_ORTypeSpecialDeConvert(_ORTypeSpecial *node, _PatchNode *patch){
    ORTypeSpecial *exp = [ORTypeSpecial new];
    exp.type = node->type;
    exp.name = (NSString *)_ORNodeDeConvert((_ORNode *)node->name, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    BOOL isBlock;
    _StringNode *varname;
}_ORVariable;
static uint64_t _ORVariableLength = 25;
_ORVariable *_ORVariableConvert(ORVariable *exp, _PatchNode *patch){
    _ORVariable *node = malloc(sizeof(_ORVariable));
    memset(node, 0, sizeof(_ORVariable));
    node->nodeType = _ORVariableNode;
    node->length = _ORVariableLength;
    node->isBlock = exp.isBlock;
    node->varname = (_StringNode *)_ORNodeConvert(exp.varname, patch);
    return node;
}
ORVariable *_ORVariableDeConvert(_ORVariable *node, _PatchNode *patch){
    ORVariable *exp = [ORVariable new];
    exp.isBlock = node->isBlock;
    exp.varname = (NSString *)_ORNodeDeConvert((_ORNode *)node->varname, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _ORNode *type;
    _ORNode *var;
}_ORTypeVarPair;
static uint64_t _ORTypeVarPairLength = 32;
_ORTypeVarPair *_ORTypeVarPairConvert(ORTypeVarPair *exp, _PatchNode *patch){
    _ORTypeVarPair *node = malloc(sizeof(_ORTypeVarPair));
    memset(node, 0, sizeof(_ORTypeVarPair));
    node->nodeType = _ORTypeVarPairNode;
    node->length = _ORTypeVarPairLength;
    node->type = _ORNodeConvert(exp.type, patch);
    node->var = _ORNodeConvert(exp.var, patch);
    return node;
}
ORTypeVarPair *_ORTypeVarPairDeConvert(_ORTypeVarPair *node, _PatchNode *patch){
    ORTypeVarPair *exp = [ORTypeVarPair new];
    exp.type = _ORNodeDeConvert((_ORNode *)node->type, patch);
    exp.var = _ORNodeDeConvert((_ORNode *)node->var, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _ListNode *pairs;
    BOOL isMultiArgs;
}_ORFuncVariable;
static uint64_t _ORFuncVariableBaseLength = 17;
_ORFuncVariable *_ORFuncVariableConvert(ORFuncVariable *exp, _PatchNode *patch){
    _ORFuncVariable *node = malloc(sizeof(_ORFuncVariable));
    memset(node, 0, sizeof(_ORFuncVariable));
    node->nodeType = _ORFuncVariableNode;
    node->pairs = (_ListNode *)_ORNodeConvert(exp.pairs, patch);
    node->isMultiArgs = exp.isMultiArgs;
    node->length = _ORFuncVariableBaseLength + node->pairs->length;
    return node;
}
ORFuncVariable *_ORFuncVariableDeConvert(_ORFuncVariable *node, _PatchNode *patch){
    ORFuncVariable *exp = [ORFuncVariable new];
    exp.pairs = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->pairs, patch);
    exp.isMultiArgs = node->isMultiArgs;
    return exp;
}
typedef struct {
    _ORNodeFields
    _ORNode *returnType;
    _ORNode *funVar;
}_ORFuncDeclare;
static uint64_t _ORFuncDeclareLength = 32;
_ORFuncDeclare *_ORFuncDeclareConvert(ORFuncDeclare *exp, _PatchNode *patch){
    _ORFuncDeclare *node = malloc(sizeof(_ORFuncDeclare));
    memset(node, 0, sizeof(_ORFuncDeclare));
    node->nodeType = _ORFuncDeclareNode;
    node->length = _ORFuncDeclareLength;
    node->returnType = _ORNodeConvert(exp.returnType, patch);
    node->funVar = _ORNodeConvert(exp.funVar, patch);
    return node;
}
ORFuncDeclare *_ORFuncDeclareDeConvert(_ORFuncDeclare *node, _PatchNode *patch){
    ORFuncDeclare *exp = [ORFuncDeclare new];
    exp.returnType = _ORNodeDeConvert((_ORNode *)node->returnType, patch);
    exp.funVar = _ORNodeDeConvert((_ORNode *)node->funVar, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _ListNode *statements;
}_ORScopeImp;
static uint64_t _ORScopeImpBaseLength = 16;
_ORScopeImp *_ORScopeImpConvert(ORScopeImp *exp, _PatchNode *patch){
    _ORScopeImp *node = malloc(sizeof(_ORScopeImp));
    memset(node, 0, sizeof(_ORScopeImp));
    node->nodeType = _ORScopeImpNode;
    node->statements = (_ListNode *)_ORNodeConvert(exp.statements, patch);
    node->length = _ORScopeImpBaseLength + node->statements->length;
    return node;
}
ORScopeImp *_ORScopeImpDeConvert(_ORScopeImp *node, _PatchNode *patch){
    ORScopeImp *exp = [ORScopeImp new];
    exp.statements = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->statements, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    uint64_t value_type;
    _ORNode *value;
}_ORValueExpression;
static uint64_t _ORValueExpressionLength = 32;
_ORValueExpression *_ORValueExpressionConvert(ORValueExpression *exp, _PatchNode *patch){
    _ORValueExpression *node = malloc(sizeof(_ORValueExpression));
    memset(node, 0, sizeof(_ORValueExpression));
    node->nodeType = _ORValueExpressionNode;
    node->length = _ORValueExpressionLength;
    node->value_type = exp.value_type;
    node->value = _ORNodeConvert(exp.value, patch);
    return node;
}
ORValueExpression *_ORValueExpressionDeConvert(_ORValueExpression *node, _PatchNode *patch){
    ORValueExpression *exp = [ORValueExpression new];
    exp.value_type = node->value_type;
    exp.value = _ORNodeDeConvert((_ORNode *)node->value, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _ORNode *caller;
    BOOL isDot;
    _ListNode *names;
    _ListNode *values;
    BOOL isAssignedValue;
}_ORMethodCall;
static uint64_t _ORMethodCallBaseLength = 26;
_ORMethodCall *_ORMethodCallConvert(ORMethodCall *exp, _PatchNode *patch){
    _ORMethodCall *node = malloc(sizeof(_ORMethodCall));
    memset(node, 0, sizeof(_ORMethodCall));
    node->nodeType = _ORMethodCallNode;
    node->caller = _ORNodeConvert(exp.caller, patch);
    node->isDot = exp.isDot;
    node->names = (_ListNode *)_ORNodeConvert(exp.names, patch);
    node->values = (_ListNode *)_ORNodeConvert(exp.values, patch);
    node->isAssignedValue = exp.isAssignedValue;
    node->length = _ORMethodCallBaseLength + node->names->length + node->values->length;
    return node;
}
ORMethodCall *_ORMethodCallDeConvert(_ORMethodCall *node, _PatchNode *patch){
    ORMethodCall *exp = [ORMethodCall new];
    exp.caller = _ORNodeDeConvert((_ORNode *)node->caller, patch);
    exp.isDot = node->isDot;
    exp.names = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->names, patch);
    exp.values = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->values, patch);
    exp.isAssignedValue = node->isAssignedValue;
    return exp;
}
typedef struct {
    _ORNodeFields
    _ORNode *caller;
    _ListNode *expressions;
}_ORCFuncCall;
static uint64_t _ORCFuncCallBaseLength = 24;
_ORCFuncCall *_ORCFuncCallConvert(ORCFuncCall *exp, _PatchNode *patch){
    _ORCFuncCall *node = malloc(sizeof(_ORCFuncCall));
    memset(node, 0, sizeof(_ORCFuncCall));
    node->nodeType = _ORCFuncCallNode;
    node->caller = _ORNodeConvert(exp.caller, patch);
    node->expressions = (_ListNode *)_ORNodeConvert(exp.expressions, patch);
    node->length = _ORCFuncCallBaseLength + node->expressions->length;
    return node;
}
ORCFuncCall *_ORCFuncCallDeConvert(_ORCFuncCall *node, _PatchNode *patch){
    ORCFuncCall *exp = [ORCFuncCall new];
    exp.caller = _ORNodeDeConvert((_ORNode *)node->caller, patch);
    exp.expressions = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->expressions, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _ORNode *declare;
    _ORNode *scopeImp;
}_ORFunctionImp;
static uint64_t _ORFunctionImpLength = 32;
_ORFunctionImp *_ORFunctionImpConvert(ORFunctionImp *exp, _PatchNode *patch){
    _ORFunctionImp *node = malloc(sizeof(_ORFunctionImp));
    memset(node, 0, sizeof(_ORFunctionImp));
    node->nodeType = _ORFunctionImpNode;
    node->length = _ORFunctionImpLength;
    node->declare = _ORNodeConvert(exp.declare, patch);
    node->scopeImp = _ORNodeConvert(exp.scopeImp, patch);
    return node;
}
ORFunctionImp *_ORFunctionImpDeConvert(_ORFunctionImp *node, _PatchNode *patch){
    ORFunctionImp *exp = [ORFunctionImp new];
    exp.declare = _ORNodeDeConvert((_ORNode *)node->declare, patch);
    exp.scopeImp = _ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _ORNode *caller;
    _ORNode *keyExp;
}_ORSubscriptExpression;
static uint64_t _ORSubscriptExpressionLength = 32;
_ORSubscriptExpression *_ORSubscriptExpressionConvert(ORSubscriptExpression *exp, _PatchNode *patch){
    _ORSubscriptExpression *node = malloc(sizeof(_ORSubscriptExpression));
    memset(node, 0, sizeof(_ORSubscriptExpression));
    node->nodeType = _ORSubscriptExpressionNode;
    node->length = _ORSubscriptExpressionLength;
    node->caller = _ORNodeConvert(exp.caller, patch);
    node->keyExp = _ORNodeConvert(exp.keyExp, patch);
    return node;
}
ORSubscriptExpression *_ORSubscriptExpressionDeConvert(_ORSubscriptExpression *node, _PatchNode *patch){
    ORSubscriptExpression *exp = [ORSubscriptExpression new];
    exp.caller = _ORNodeDeConvert((_ORNode *)node->caller, patch);
    exp.keyExp = _ORNodeDeConvert((_ORNode *)node->keyExp, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _ORNode *value;
    uint64_t assignType;
    _ORNode *expression;
}_ORAssignExpression;
static uint64_t _ORAssignExpressionLength = 40;
_ORAssignExpression *_ORAssignExpressionConvert(ORAssignExpression *exp, _PatchNode *patch){
    _ORAssignExpression *node = malloc(sizeof(_ORAssignExpression));
    memset(node, 0, sizeof(_ORAssignExpression));
    node->nodeType = _ORAssignExpressionNode;
    node->length = _ORAssignExpressionLength;
    node->value = _ORNodeConvert(exp.value, patch);
    node->assignType = exp.assignType;
    node->expression = _ORNodeConvert(exp.expression, patch);
    return node;
}
ORAssignExpression *_ORAssignExpressionDeConvert(_ORAssignExpression *node, _PatchNode *patch){
    ORAssignExpression *exp = [ORAssignExpression new];
    exp.value = _ORNodeDeConvert((_ORNode *)node->value, patch);
    exp.assignType = node->assignType;
    exp.expression = _ORNodeDeConvert((_ORNode *)node->expression, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    uint64_t modifier;
    _ORNode *pair;
    _ORNode *expression;
}_ORDeclareExpression;
static uint64_t _ORDeclareExpressionLength = 40;
_ORDeclareExpression *_ORDeclareExpressionConvert(ORDeclareExpression *exp, _PatchNode *patch){
    _ORDeclareExpression *node = malloc(sizeof(_ORDeclareExpression));
    memset(node, 0, sizeof(_ORDeclareExpression));
    node->nodeType = _ORDeclareExpressionNode;
    node->length = _ORDeclareExpressionLength;
    node->modifier = exp.modifier;
    node->pair = _ORNodeConvert(exp.pair, patch);
    node->expression = _ORNodeConvert(exp.expression, patch);
    return node;
}
ORDeclareExpression *_ORDeclareExpressionDeConvert(_ORDeclareExpression *node, _PatchNode *patch){
    ORDeclareExpression *exp = [ORDeclareExpression new];
    exp.modifier = node->modifier;
    exp.pair = _ORNodeDeConvert((_ORNode *)node->pair, patch);
    exp.expression = _ORNodeDeConvert((_ORNode *)node->expression, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _ORNode *value;
    uint64_t operatorType;
}_ORUnaryExpression;
static uint64_t _ORUnaryExpressionLength = 32;
_ORUnaryExpression *_ORUnaryExpressionConvert(ORUnaryExpression *exp, _PatchNode *patch){
    _ORUnaryExpression *node = malloc(sizeof(_ORUnaryExpression));
    memset(node, 0, sizeof(_ORUnaryExpression));
    node->nodeType = _ORUnaryExpressionNode;
    node->length = _ORUnaryExpressionLength;
    node->value = _ORNodeConvert(exp.value, patch);
    node->operatorType = exp.operatorType;
    return node;
}
ORUnaryExpression *_ORUnaryExpressionDeConvert(_ORUnaryExpression *node, _PatchNode *patch){
    ORUnaryExpression *exp = [ORUnaryExpression new];
    exp.value = _ORNodeDeConvert((_ORNode *)node->value, patch);
    exp.operatorType = node->operatorType;
    return exp;
}
typedef struct {
    _ORNodeFields
    _ORNode *left;
    uint64_t operatorType;
    _ORNode *right;
}_ORBinaryExpression;
static uint64_t _ORBinaryExpressionLength = 40;
_ORBinaryExpression *_ORBinaryExpressionConvert(ORBinaryExpression *exp, _PatchNode *patch){
    _ORBinaryExpression *node = malloc(sizeof(_ORBinaryExpression));
    memset(node, 0, sizeof(_ORBinaryExpression));
    node->nodeType = _ORBinaryExpressionNode;
    node->length = _ORBinaryExpressionLength;
    node->left = _ORNodeConvert(exp.left, patch);
    node->operatorType = exp.operatorType;
    node->right = _ORNodeConvert(exp.right, patch);
    return node;
}
ORBinaryExpression *_ORBinaryExpressionDeConvert(_ORBinaryExpression *node, _PatchNode *patch){
    ORBinaryExpression *exp = [ORBinaryExpression new];
    exp.left = _ORNodeDeConvert((_ORNode *)node->left, patch);
    exp.operatorType = node->operatorType;
    exp.right = _ORNodeDeConvert((_ORNode *)node->right, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _ORNode *expression;
    _ListNode *values;
}_ORTernaryExpression;
static uint64_t _ORTernaryExpressionBaseLength = 24;
_ORTernaryExpression *_ORTernaryExpressionConvert(ORTernaryExpression *exp, _PatchNode *patch){
    _ORTernaryExpression *node = malloc(sizeof(_ORTernaryExpression));
    memset(node, 0, sizeof(_ORTernaryExpression));
    node->nodeType = _ORTernaryExpressionNode;
    node->expression = _ORNodeConvert(exp.expression, patch);
    node->values = (_ListNode *)_ORNodeConvert(exp.values, patch);
    node->length = _ORTernaryExpressionBaseLength + node->values->length;
    return node;
}
ORTernaryExpression *_ORTernaryExpressionDeConvert(_ORTernaryExpression *node, _PatchNode *patch){
    ORTernaryExpression *exp = [ORTernaryExpression new];
    exp.expression = _ORNodeDeConvert((_ORNode *)node->expression, patch);
    exp.values = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->values, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _ORNode *condition;
    _ORNode *last;
    _ORNode *scopeImp;
}_ORIfStatement;
static uint64_t _ORIfStatementLength = 40;
_ORIfStatement *_ORIfStatementConvert(ORIfStatement *exp, _PatchNode *patch){
    _ORIfStatement *node = malloc(sizeof(_ORIfStatement));
    memset(node, 0, sizeof(_ORIfStatement));
    node->nodeType = _ORIfStatementNode;
    node->length = _ORIfStatementLength;
    node->condition = _ORNodeConvert(exp.condition, patch);
    node->last = _ORNodeConvert(exp.last, patch);
    node->scopeImp = _ORNodeConvert(exp.scopeImp, patch);
    return node;
}
ORIfStatement *_ORIfStatementDeConvert(_ORIfStatement *node, _PatchNode *patch){
    ORIfStatement *exp = [ORIfStatement new];
    exp.condition = _ORNodeDeConvert((_ORNode *)node->condition, patch);
    exp.last = _ORNodeDeConvert((_ORNode *)node->last, patch);
    exp.scopeImp = _ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _ORNode *condition;
    _ORNode *scopeImp;
}_ORWhileStatement;
static uint64_t _ORWhileStatementLength = 32;
_ORWhileStatement *_ORWhileStatementConvert(ORWhileStatement *exp, _PatchNode *patch){
    _ORWhileStatement *node = malloc(sizeof(_ORWhileStatement));
    memset(node, 0, sizeof(_ORWhileStatement));
    node->nodeType = _ORWhileStatementNode;
    node->length = _ORWhileStatementLength;
    node->condition = _ORNodeConvert(exp.condition, patch);
    node->scopeImp = _ORNodeConvert(exp.scopeImp, patch);
    return node;
}
ORWhileStatement *_ORWhileStatementDeConvert(_ORWhileStatement *node, _PatchNode *patch){
    ORWhileStatement *exp = [ORWhileStatement new];
    exp.condition = _ORNodeDeConvert((_ORNode *)node->condition, patch);
    exp.scopeImp = _ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _ORNode *condition;
    _ORNode *scopeImp;
}_ORDoWhileStatement;
static uint64_t _ORDoWhileStatementLength = 32;
_ORDoWhileStatement *_ORDoWhileStatementConvert(ORDoWhileStatement *exp, _PatchNode *patch){
    _ORDoWhileStatement *node = malloc(sizeof(_ORDoWhileStatement));
    memset(node, 0, sizeof(_ORDoWhileStatement));
    node->nodeType = _ORDoWhileStatementNode;
    node->length = _ORDoWhileStatementLength;
    node->condition = _ORNodeConvert(exp.condition, patch);
    node->scopeImp = _ORNodeConvert(exp.scopeImp, patch);
    return node;
}
ORDoWhileStatement *_ORDoWhileStatementDeConvert(_ORDoWhileStatement *node, _PatchNode *patch){
    ORDoWhileStatement *exp = [ORDoWhileStatement new];
    exp.condition = _ORNodeDeConvert((_ORNode *)node->condition, patch);
    exp.scopeImp = _ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _ORNode *value;
    _ORNode *scopeImp;
}_ORCaseStatement;
static uint64_t _ORCaseStatementLength = 32;
_ORCaseStatement *_ORCaseStatementConvert(ORCaseStatement *exp, _PatchNode *patch){
    _ORCaseStatement *node = malloc(sizeof(_ORCaseStatement));
    memset(node, 0, sizeof(_ORCaseStatement));
    node->nodeType = _ORCaseStatementNode;
    node->length = _ORCaseStatementLength;
    node->value = _ORNodeConvert(exp.value, patch);
    node->scopeImp = _ORNodeConvert(exp.scopeImp, patch);
    return node;
}
ORCaseStatement *_ORCaseStatementDeConvert(_ORCaseStatement *node, _PatchNode *patch){
    ORCaseStatement *exp = [ORCaseStatement new];
    exp.value = _ORNodeDeConvert((_ORNode *)node->value, patch);
    exp.scopeImp = _ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _ORNode *value;
    _ListNode *cases;
    _ORNode *scopeImp;
}_ORSwitchStatement;
static uint64_t _ORSwitchStatementBaseLength = 32;
_ORSwitchStatement *_ORSwitchStatementConvert(ORSwitchStatement *exp, _PatchNode *patch){
    _ORSwitchStatement *node = malloc(sizeof(_ORSwitchStatement));
    memset(node, 0, sizeof(_ORSwitchStatement));
    node->nodeType = _ORSwitchStatementNode;
    node->value = _ORNodeConvert(exp.value, patch);
    node->cases = (_ListNode *)_ORNodeConvert(exp.cases, patch);
    node->scopeImp = _ORNodeConvert(exp.scopeImp, patch);
    node->length = _ORSwitchStatementBaseLength + node->cases->length;
    return node;
}
ORSwitchStatement *_ORSwitchStatementDeConvert(_ORSwitchStatement *node, _PatchNode *patch){
    ORSwitchStatement *exp = [ORSwitchStatement new];
    exp.value = _ORNodeDeConvert((_ORNode *)node->value, patch);
    exp.cases = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->cases, patch);
    exp.scopeImp = _ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _ListNode *varExpressions;
    _ORNode *condition;
    _ListNode *expressions;
    _ORNode *scopeImp;
}_ORForStatement;
static uint64_t _ORForStatementBaseLength = 32;
_ORForStatement *_ORForStatementConvert(ORForStatement *exp, _PatchNode *patch){
    _ORForStatement *node = malloc(sizeof(_ORForStatement));
    memset(node, 0, sizeof(_ORForStatement));
    node->nodeType = _ORForStatementNode;
    node->varExpressions = (_ListNode *)_ORNodeConvert(exp.varExpressions, patch);
    node->condition = _ORNodeConvert(exp.condition, patch);
    node->expressions = (_ListNode *)_ORNodeConvert(exp.expressions, patch);
    node->scopeImp = _ORNodeConvert(exp.scopeImp, patch);
    node->length = _ORForStatementBaseLength + node->varExpressions->length + node->expressions->length;
    return node;
}
ORForStatement *_ORForStatementDeConvert(_ORForStatement *node, _PatchNode *patch){
    ORForStatement *exp = [ORForStatement new];
    exp.varExpressions = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->varExpressions, patch);
    exp.condition = _ORNodeDeConvert((_ORNode *)node->condition, patch);
    exp.expressions = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->expressions, patch);
    exp.scopeImp = _ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _ORNode *expression;
    _ORNode *value;
    _ORNode *scopeImp;
}_ORForInStatement;
static uint64_t _ORForInStatementLength = 40;
_ORForInStatement *_ORForInStatementConvert(ORForInStatement *exp, _PatchNode *patch){
    _ORForInStatement *node = malloc(sizeof(_ORForInStatement));
    memset(node, 0, sizeof(_ORForInStatement));
    node->nodeType = _ORForInStatementNode;
    node->length = _ORForInStatementLength;
    node->expression = _ORNodeConvert(exp.expression, patch);
    node->value = _ORNodeConvert(exp.value, patch);
    node->scopeImp = _ORNodeConvert(exp.scopeImp, patch);
    return node;
}
ORForInStatement *_ORForInStatementDeConvert(_ORForInStatement *node, _PatchNode *patch){
    ORForInStatement *exp = [ORForInStatement new];
    exp.expression = _ORNodeDeConvert((_ORNode *)node->expression, patch);
    exp.value = _ORNodeDeConvert((_ORNode *)node->value, patch);
    exp.scopeImp = _ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _ORNode *expression;
}_ORReturnStatement;
static uint64_t _ORReturnStatementLength = 24;
_ORReturnStatement *_ORReturnStatementConvert(ORReturnStatement *exp, _PatchNode *patch){
    _ORReturnStatement *node = malloc(sizeof(_ORReturnStatement));
    memset(node, 0, sizeof(_ORReturnStatement));
    node->nodeType = _ORReturnStatementNode;
    node->length = _ORReturnStatementLength;
    node->expression = _ORNodeConvert(exp.expression, patch);
    return node;
}
ORReturnStatement *_ORReturnStatementDeConvert(_ORReturnStatement *node, _PatchNode *patch){
    ORReturnStatement *exp = [ORReturnStatement new];
    exp.expression = _ORNodeDeConvert((_ORNode *)node->expression, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    
}_ORBreakStatement;
static uint64_t _ORBreakStatementLength = 16;
_ORBreakStatement *_ORBreakStatementConvert(ORBreakStatement *exp, _PatchNode *patch){
    _ORBreakStatement *node = malloc(sizeof(_ORBreakStatement));
    memset(node, 0, sizeof(_ORBreakStatement));
    node->nodeType = _ORBreakStatementNode;
    node->length = _ORBreakStatementLength;
    
    return node;
}
ORBreakStatement *_ORBreakStatementDeConvert(_ORBreakStatement *node, _PatchNode *patch){
    ORBreakStatement *exp = [ORBreakStatement new];
    
    return exp;
}
typedef struct {
    _ORNodeFields
    
}_ORContinueStatement;
static uint64_t _ORContinueStatementLength = 16;
_ORContinueStatement *_ORContinueStatementConvert(ORContinueStatement *exp, _PatchNode *patch){
    _ORContinueStatement *node = malloc(sizeof(_ORContinueStatement));
    memset(node, 0, sizeof(_ORContinueStatement));
    node->nodeType = _ORContinueStatementNode;
    node->length = _ORContinueStatementLength;
    
    return node;
}
ORContinueStatement *_ORContinueStatementDeConvert(_ORContinueStatement *node, _PatchNode *patch){
    ORContinueStatement *exp = [ORContinueStatement new];
    
    return exp;
}
typedef struct {
    _ORNodeFields
    _ListNode *keywords;
    _ORNode *var;
}_ORPropertyDeclare;
static uint64_t _ORPropertyDeclareBaseLength = 24;
_ORPropertyDeclare *_ORPropertyDeclareConvert(ORPropertyDeclare *exp, _PatchNode *patch){
    _ORPropertyDeclare *node = malloc(sizeof(_ORPropertyDeclare));
    memset(node, 0, sizeof(_ORPropertyDeclare));
    node->nodeType = _ORPropertyDeclareNode;
    node->keywords = (_ListNode *)_ORNodeConvert(exp.keywords, patch);
    node->var = _ORNodeConvert(exp.var, patch);
    node->length = _ORPropertyDeclareBaseLength + node->keywords->length;
    return node;
}
ORPropertyDeclare *_ORPropertyDeclareDeConvert(_ORPropertyDeclare *node, _PatchNode *patch){
    ORPropertyDeclare *exp = [ORPropertyDeclare new];
    exp.keywords = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->keywords, patch);
    exp.var = _ORNodeDeConvert((_ORNode *)node->var, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    BOOL isClassMethod;
    _ORNode *returnType;
    _ListNode *methodNames;
    _ListNode *parameterTypes;
    _ListNode *parameterNames;
}_ORMethodDeclare;
static uint64_t _ORMethodDeclareBaseLength = 25;
_ORMethodDeclare *_ORMethodDeclareConvert(ORMethodDeclare *exp, _PatchNode *patch){
    _ORMethodDeclare *node = malloc(sizeof(_ORMethodDeclare));
    memset(node, 0, sizeof(_ORMethodDeclare));
    node->nodeType = _ORMethodDeclareNode;
    node->isClassMethod = exp.isClassMethod;
    node->returnType = _ORNodeConvert(exp.returnType, patch);
    node->methodNames = (_ListNode *)_ORNodeConvert(exp.methodNames, patch);
    node->parameterTypes = (_ListNode *)_ORNodeConvert(exp.parameterTypes, patch);
    node->parameterNames = (_ListNode *)_ORNodeConvert(exp.parameterNames, patch);
    node->length = _ORMethodDeclareBaseLength + node->methodNames->length + node->parameterTypes->length + node->parameterNames->length;
    return node;
}
ORMethodDeclare *_ORMethodDeclareDeConvert(_ORMethodDeclare *node, _PatchNode *patch){
    ORMethodDeclare *exp = [ORMethodDeclare new];
    exp.isClassMethod = node->isClassMethod;
    exp.returnType = _ORNodeDeConvert((_ORNode *)node->returnType, patch);
    exp.methodNames = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->methodNames, patch);
    exp.parameterTypes = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->parameterTypes, patch);
    exp.parameterNames = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->parameterNames, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _ORNode *declare;
    _ORNode *scopeImp;
}_ORMethodImplementation;
static uint64_t _ORMethodImplementationLength = 32;
_ORMethodImplementation *_ORMethodImplementationConvert(ORMethodImplementation *exp, _PatchNode *patch){
    _ORMethodImplementation *node = malloc(sizeof(_ORMethodImplementation));
    memset(node, 0, sizeof(_ORMethodImplementation));
    node->nodeType = _ORMethodImplementationNode;
    node->length = _ORMethodImplementationLength;
    node->declare = _ORNodeConvert(exp.declare, patch);
    node->scopeImp = _ORNodeConvert(exp.scopeImp, patch);
    return node;
}
ORMethodImplementation *_ORMethodImplementationDeConvert(_ORMethodImplementation *node, _PatchNode *patch){
    ORMethodImplementation *exp = [ORMethodImplementation new];
    exp.declare = _ORNodeDeConvert((_ORNode *)node->declare, patch);
    exp.scopeImp = _ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _StringNode *className;
    _StringNode *superClassName;
    _ListNode *protocols;
    _ListNode *properties;
    _ListNode *privateVariables;
    _ListNode *methods;
}_ORClass;
static uint64_t _ORClassBaseLength = 32;
_ORClass *_ORClassConvert(ORClass *exp, _PatchNode *patch){
    _ORClass *node = malloc(sizeof(_ORClass));
    memset(node, 0, sizeof(_ORClass));
    node->nodeType = _ORClassNode;
    node->className = (_StringNode *)_ORNodeConvert(exp.className, patch);
    node->superClassName = (_StringNode *)_ORNodeConvert(exp.superClassName, patch);
    node->protocols = (_ListNode *)_ORNodeConvert(exp.protocols, patch);
    node->properties = (_ListNode *)_ORNodeConvert(exp.properties, patch);
    node->privateVariables = (_ListNode *)_ORNodeConvert(exp.privateVariables, patch);
    node->methods = (_ListNode *)_ORNodeConvert(exp.methods, patch);
    node->length = _ORClassBaseLength + node->protocols->length + node->properties->length + node->privateVariables->length + node->methods->length;
    return node;
}
ORClass *_ORClassDeConvert(_ORClass *node, _PatchNode *patch){
    ORClass *exp = [ORClass new];
    exp.className = (NSString *)_ORNodeDeConvert((_ORNode *)node->className, patch);
    exp.superClassName = (NSString *)_ORNodeDeConvert((_ORNode *)node->superClassName, patch);
    exp.protocols = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->protocols, patch);
    exp.properties = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->properties, patch);
    exp.privateVariables = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->privateVariables, patch);
    exp.methods = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->methods, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _StringNode *protcolName;
    _ListNode *protocols;
    _ListNode *properties;
    _ListNode *methods;
}_ORProtocol;
static uint64_t _ORProtocolBaseLength = 24;
_ORProtocol *_ORProtocolConvert(ORProtocol *exp, _PatchNode *patch){
    _ORProtocol *node = malloc(sizeof(_ORProtocol));
    memset(node, 0, sizeof(_ORProtocol));
    node->nodeType = _ORProtocolNode;
    node->protcolName = (_StringNode *)_ORNodeConvert(exp.protcolName, patch);
    node->protocols = (_ListNode *)_ORNodeConvert(exp.protocols, patch);
    node->properties = (_ListNode *)_ORNodeConvert(exp.properties, patch);
    node->methods = (_ListNode *)_ORNodeConvert(exp.methods, patch);
    node->length = _ORProtocolBaseLength + node->protocols->length + node->properties->length + node->methods->length;
    return node;
}
ORProtocol *_ORProtocolDeConvert(_ORProtocol *node, _PatchNode *patch){
    ORProtocol *exp = [ORProtocol new];
    exp.protcolName = (NSString *)_ORNodeDeConvert((_ORNode *)node->protcolName, patch);
    exp.protocols = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->protocols, patch);
    exp.properties = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->properties, patch);
    exp.methods = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->methods, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _StringNode *sturctName;
    _ListNode *fields;
}_ORStructExpressoin;
static uint64_t _ORStructExpressoinBaseLength = 24;
_ORStructExpressoin *_ORStructExpressoinConvert(ORStructExpressoin *exp, _PatchNode *patch){
    _ORStructExpressoin *node = malloc(sizeof(_ORStructExpressoin));
    memset(node, 0, sizeof(_ORStructExpressoin));
    node->nodeType = _ORStructExpressoinNode;
    node->sturctName = (_StringNode *)_ORNodeConvert(exp.sturctName, patch);
    node->fields = (_ListNode *)_ORNodeConvert(exp.fields, patch);
    node->length = _ORStructExpressoinBaseLength + node->fields->length;
    return node;
}
ORStructExpressoin *_ORStructExpressoinDeConvert(_ORStructExpressoin *node, _PatchNode *patch){
    ORStructExpressoin *exp = [ORStructExpressoin new];
    exp.sturctName = (NSString *)_ORNodeDeConvert((_ORNode *)node->sturctName, patch);
    exp.fields = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->fields, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _StringNode *enumName;
    uint64_t valueType;
    _ListNode *fields;
}_OREnumExpressoin;
static uint64_t _OREnumExpressoinBaseLength = 32;
_OREnumExpressoin *_OREnumExpressoinConvert(OREnumExpressoin *exp, _PatchNode *patch){
    _OREnumExpressoin *node = malloc(sizeof(_OREnumExpressoin));
    memset(node, 0, sizeof(_OREnumExpressoin));
    node->nodeType = _OREnumExpressoinNode;
    node->enumName = (_StringNode *)_ORNodeConvert(exp.enumName, patch);
    node->valueType = exp.valueType;
    node->fields = (_ListNode *)_ORNodeConvert(exp.fields, patch);
    node->length = _OREnumExpressoinBaseLength + node->fields->length;
    return node;
}
OREnumExpressoin *_OREnumExpressoinDeConvert(_OREnumExpressoin *node, _PatchNode *patch){
    OREnumExpressoin *exp = [OREnumExpressoin new];
    exp.enumName = (NSString *)_ORNodeDeConvert((_ORNode *)node->enumName, patch);
    exp.valueType = node->valueType;
    exp.fields = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->fields, patch);
    return exp;
}
typedef struct {
    _ORNodeFields
    _ORNode *expression;
    _StringNode *typeNewName;
}_ORTypedefExpressoin;
static uint64_t _ORTypedefExpressoinLength = 32;
_ORTypedefExpressoin *_ORTypedefExpressoinConvert(ORTypedefExpressoin *exp, _PatchNode *patch){
    _ORTypedefExpressoin *node = malloc(sizeof(_ORTypedefExpressoin));
    memset(node, 0, sizeof(_ORTypedefExpressoin));
    node->nodeType = _ORTypedefExpressoinNode;
    node->length = _ORTypedefExpressoinLength;
    node->expression = _ORNodeConvert(exp.expression, patch);
    node->typeNewName = (_StringNode *)_ORNodeConvert(exp.typeNewName, patch);
    return node;
}
ORTypedefExpressoin *_ORTypedefExpressoinDeConvert(_ORTypedefExpressoin *node, _PatchNode *patch){
    ORTypedefExpressoin *exp = [ORTypedefExpressoin new];
    exp.expression = _ORNodeDeConvert((_ORNode *)node->expression, patch);
    exp.typeNewName = (NSString *)_ORNodeDeConvert((_ORNode *)node->typeNewName, patch);
    return exp;
}
#pragma pack()
#pragma pack(show)
_ORNode *_ORNodeConvert(id exp, _PatchNode *patch){
    if ([exp isKindOfClass:[NSString class]]) {
        return (_ORNode *)saveNewString((NSString *)exp, patch);
    }
    if ([exp isKindOfClass:[NSArray class]]) {
        return (_ORNode *)_ListNodeConvert((NSArray *)exp, patch);
    }
    if ([exp isKindOfClass:[ORTypeSpecial class]]){
        return (_ORNode *)_ORTypeSpecialConvert((ORTypeSpecial *)exp, patch);
    }
    if ([exp isKindOfClass:[ORVariable class]]){
        return (_ORNode *)_ORVariableConvert((ORVariable *)exp, patch);
    }
    if ([exp isKindOfClass:[ORTypeVarPair class]]){
        return (_ORNode *)_ORTypeVarPairConvert((ORTypeVarPair *)exp, patch);
    }
    if ([exp isKindOfClass:[ORFuncVariable class]]){
        return (_ORNode *)_ORFuncVariableConvert((ORFuncVariable *)exp, patch);
    }
    if ([exp isKindOfClass:[ORFuncDeclare class]]){
        return (_ORNode *)_ORFuncDeclareConvert((ORFuncDeclare *)exp, patch);
    }
    if ([exp isKindOfClass:[ORScopeImp class]]){
        return (_ORNode *)_ORScopeImpConvert((ORScopeImp *)exp, patch);
    }
    if ([exp isKindOfClass:[ORValueExpression class]]){
        return (_ORNode *)_ORValueExpressionConvert((ORValueExpression *)exp, patch);
    }
    if ([exp isKindOfClass:[ORMethodCall class]]){
        return (_ORNode *)_ORMethodCallConvert((ORMethodCall *)exp, patch);
    }
    if ([exp isKindOfClass:[ORCFuncCall class]]){
        return (_ORNode *)_ORCFuncCallConvert((ORCFuncCall *)exp, patch);
    }
    if ([exp isKindOfClass:[ORFunctionImp class]]){
        return (_ORNode *)_ORFunctionImpConvert((ORFunctionImp *)exp, patch);
    }
    if ([exp isKindOfClass:[ORSubscriptExpression class]]){
        return (_ORNode *)_ORSubscriptExpressionConvert((ORSubscriptExpression *)exp, patch);
    }
    if ([exp isKindOfClass:[ORAssignExpression class]]){
        return (_ORNode *)_ORAssignExpressionConvert((ORAssignExpression *)exp, patch);
    }
    if ([exp isKindOfClass:[ORDeclareExpression class]]){
        return (_ORNode *)_ORDeclareExpressionConvert((ORDeclareExpression *)exp, patch);
    }
    if ([exp isKindOfClass:[ORUnaryExpression class]]){
        return (_ORNode *)_ORUnaryExpressionConvert((ORUnaryExpression *)exp, patch);
    }
    if ([exp isKindOfClass:[ORBinaryExpression class]]){
        return (_ORNode *)_ORBinaryExpressionConvert((ORBinaryExpression *)exp, patch);
    }
    if ([exp isKindOfClass:[ORTernaryExpression class]]){
        return (_ORNode *)_ORTernaryExpressionConvert((ORTernaryExpression *)exp, patch);
    }
    if ([exp isKindOfClass:[ORIfStatement class]]){
        return (_ORNode *)_ORIfStatementConvert((ORIfStatement *)exp, patch);
    }
    if ([exp isKindOfClass:[ORWhileStatement class]]){
        return (_ORNode *)_ORWhileStatementConvert((ORWhileStatement *)exp, patch);
    }
    if ([exp isKindOfClass:[ORDoWhileStatement class]]){
        return (_ORNode *)_ORDoWhileStatementConvert((ORDoWhileStatement *)exp, patch);
    }
    if ([exp isKindOfClass:[ORCaseStatement class]]){
        return (_ORNode *)_ORCaseStatementConvert((ORCaseStatement *)exp, patch);
    }
    if ([exp isKindOfClass:[ORSwitchStatement class]]){
        return (_ORNode *)_ORSwitchStatementConvert((ORSwitchStatement *)exp, patch);
    }
    if ([exp isKindOfClass:[ORForStatement class]]){
        return (_ORNode *)_ORForStatementConvert((ORForStatement *)exp, patch);
    }
    if ([exp isKindOfClass:[ORForInStatement class]]){
        return (_ORNode *)_ORForInStatementConvert((ORForInStatement *)exp, patch);
    }
    if ([exp isKindOfClass:[ORReturnStatement class]]){
        return (_ORNode *)_ORReturnStatementConvert((ORReturnStatement *)exp, patch);
    }
    if ([exp isKindOfClass:[ORBreakStatement class]]){
        return (_ORNode *)_ORBreakStatementConvert((ORBreakStatement *)exp, patch);
    }
    if ([exp isKindOfClass:[ORContinueStatement class]]){
        return (_ORNode *)_ORContinueStatementConvert((ORContinueStatement *)exp, patch);
    }
    if ([exp isKindOfClass:[ORPropertyDeclare class]]){
        return (_ORNode *)_ORPropertyDeclareConvert((ORPropertyDeclare *)exp, patch);
    }
    if ([exp isKindOfClass:[ORMethodDeclare class]]){
        return (_ORNode *)_ORMethodDeclareConvert((ORMethodDeclare *)exp, patch);
    }
    if ([exp isKindOfClass:[ORMethodImplementation class]]){
        return (_ORNode *)_ORMethodImplementationConvert((ORMethodImplementation *)exp, patch);
    }
    if ([exp isKindOfClass:[ORClass class]]){
        return (_ORNode *)_ORClassConvert((ORClass *)exp, patch);
    }
    if ([exp isKindOfClass:[ORProtocol class]]){
        return (_ORNode *)_ORProtocolConvert((ORProtocol *)exp, patch);
    }
    if ([exp isKindOfClass:[ORStructExpressoin class]]){
        return (_ORNode *)_ORStructExpressoinConvert((ORStructExpressoin *)exp, patch);
    }
    if ([exp isKindOfClass:[OREnumExpressoin class]]){
        return (_ORNode *)_OREnumExpressoinConvert((OREnumExpressoin *)exp, patch);
    }
    if ([exp isKindOfClass:[ORTypedefExpressoin class]]){
        return (_ORNode *)_ORTypedefExpressoinConvert((ORTypedefExpressoin *)exp, patch);
    }
    _ORNode *node = malloc(sizeof(_ORNode));
    memset(node, 0, sizeof(_ORNode));
    return node;
}
id _ORNodeDeConvert(_ORNode *node, _PatchNode *patch){
    if (node->nodeType == ORNodeType) return nil;
    if (node->nodeType == ListNodeType) {
        return _ListNodeDeConvert((_ListNode *)node, patch);
    }
    if (node->nodeType == StringNodeType) {
        return getString((_StringNode *) node, patch);
    }
    if (node->nodeType == _ORTypeSpecialNode){
        return (ORNode *)_ORTypeSpecialDeConvert((_ORTypeSpecial *)node, patch);
    }
    if (node->nodeType == _ORVariableNode){
        return (ORNode *)_ORVariableDeConvert((_ORVariable *)node, patch);
    }
    if (node->nodeType == _ORTypeVarPairNode){
        return (ORNode *)_ORTypeVarPairDeConvert((_ORTypeVarPair *)node, patch);
    }
    if (node->nodeType == _ORFuncVariableNode){
        return (ORNode *)_ORFuncVariableDeConvert((_ORFuncVariable *)node, patch);
    }
    if (node->nodeType == _ORFuncDeclareNode){
        return (ORNode *)_ORFuncDeclareDeConvert((_ORFuncDeclare *)node, patch);
    }
    if (node->nodeType == _ORScopeImpNode){
        return (ORNode *)_ORScopeImpDeConvert((_ORScopeImp *)node, patch);
    }
    if (node->nodeType == _ORValueExpressionNode){
        return (ORNode *)_ORValueExpressionDeConvert((_ORValueExpression *)node, patch);
    }
    if (node->nodeType == _ORMethodCallNode){
        return (ORNode *)_ORMethodCallDeConvert((_ORMethodCall *)node, patch);
    }
    if (node->nodeType == _ORCFuncCallNode){
        return (ORNode *)_ORCFuncCallDeConvert((_ORCFuncCall *)node, patch);
    }
    if (node->nodeType == _ORFunctionImpNode){
        return (ORNode *)_ORFunctionImpDeConvert((_ORFunctionImp *)node, patch);
    }
    if (node->nodeType == _ORSubscriptExpressionNode){
        return (ORNode *)_ORSubscriptExpressionDeConvert((_ORSubscriptExpression *)node, patch);
    }
    if (node->nodeType == _ORAssignExpressionNode){
        return (ORNode *)_ORAssignExpressionDeConvert((_ORAssignExpression *)node, patch);
    }
    if (node->nodeType == _ORDeclareExpressionNode){
        return (ORNode *)_ORDeclareExpressionDeConvert((_ORDeclareExpression *)node, patch);
    }
    if (node->nodeType == _ORUnaryExpressionNode){
        return (ORNode *)_ORUnaryExpressionDeConvert((_ORUnaryExpression *)node, patch);
    }
    if (node->nodeType == _ORBinaryExpressionNode){
        return (ORNode *)_ORBinaryExpressionDeConvert((_ORBinaryExpression *)node, patch);
    }
    if (node->nodeType == _ORTernaryExpressionNode){
        return (ORNode *)_ORTernaryExpressionDeConvert((_ORTernaryExpression *)node, patch);
    }
    if (node->nodeType == _ORIfStatementNode){
        return (ORNode *)_ORIfStatementDeConvert((_ORIfStatement *)node, patch);
    }
    if (node->nodeType == _ORWhileStatementNode){
        return (ORNode *)_ORWhileStatementDeConvert((_ORWhileStatement *)node, patch);
    }
    if (node->nodeType == _ORDoWhileStatementNode){
        return (ORNode *)_ORDoWhileStatementDeConvert((_ORDoWhileStatement *)node, patch);
    }
    if (node->nodeType == _ORCaseStatementNode){
        return (ORNode *)_ORCaseStatementDeConvert((_ORCaseStatement *)node, patch);
    }
    if (node->nodeType == _ORSwitchStatementNode){
        return (ORNode *)_ORSwitchStatementDeConvert((_ORSwitchStatement *)node, patch);
    }
    if (node->nodeType == _ORForStatementNode){
        return (ORNode *)_ORForStatementDeConvert((_ORForStatement *)node, patch);
    }
    if (node->nodeType == _ORForInStatementNode){
        return (ORNode *)_ORForInStatementDeConvert((_ORForInStatement *)node, patch);
    }
    if (node->nodeType == _ORReturnStatementNode){
        return (ORNode *)_ORReturnStatementDeConvert((_ORReturnStatement *)node, patch);
    }
    if (node->nodeType == _ORBreakStatementNode){
        return (ORNode *)_ORBreakStatementDeConvert((_ORBreakStatement *)node, patch);
    }
    if (node->nodeType == _ORContinueStatementNode){
        return (ORNode *)_ORContinueStatementDeConvert((_ORContinueStatement *)node, patch);
    }
    if (node->nodeType == _ORPropertyDeclareNode){
        return (ORNode *)_ORPropertyDeclareDeConvert((_ORPropertyDeclare *)node, patch);
    }
    if (node->nodeType == _ORMethodDeclareNode){
        return (ORNode *)_ORMethodDeclareDeConvert((_ORMethodDeclare *)node, patch);
    }
    if (node->nodeType == _ORMethodImplementationNode){
        return (ORNode *)_ORMethodImplementationDeConvert((_ORMethodImplementation *)node, patch);
    }
    if (node->nodeType == _ORClassNode){
        return (ORNode *)_ORClassDeConvert((_ORClass *)node, patch);
    }
    if (node->nodeType == _ORProtocolNode){
        return (ORNode *)_ORProtocolDeConvert((_ORProtocol *)node, patch);
    }
    if (node->nodeType == _ORStructExpressoinNode){
        return (ORNode *)_ORStructExpressoinDeConvert((_ORStructExpressoin *)node, patch);
    }
    if (node->nodeType == _OREnumExpressoinNode){
        return (ORNode *)_OREnumExpressoinDeConvert((_OREnumExpressoin *)node, patch);
    }
    if (node->nodeType == _ORTypedefExpressoinNode){
        return (ORNode *)_ORTypedefExpressoinDeConvert((_ORTypedefExpressoin *)node, patch);
    }
    return [ORNode new];
}
