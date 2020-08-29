//  BinaryPatchHelper.m
//  Generate By BinaryPatchGenerator
//  Created by Jiang on 1598706932
//  Copyright © 2020 SilverFruity. All rights reserved.
#import "BinaryPatchHelper.h"
#import "ORPatchFile.h"
typedef enum: uint8_t{
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
    node->nodeType = ListNodeType;
    node->length = _ListNodeBaseLength;
    for (id object in array) {
        _ORNode *element = _ORNodeConvert(object, patch);;
        node->nodes[node->count] = element;
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
    strNode->strLen = (unsigned int)len;
    strNode->length = _StringNodeBaseLength;
    strNode->nodeType = StringNodeType;
    
    if (_stringMap[string]) {
        uint32_t offset = [_stringMap[string] unsignedIntValue];
        strNode->offset = offset;
        return strNode;
    }
    
    NSUInteger needLength = len + patch->strings->length;
    if (patch->strings->buffer == NULL) {
        patch->strings->buffer = malloc(needLength + 1);
        //FIX: strlen() heap overflow
        patch->strings->buffer[needLength] = '\0';
    }else if (needLength > strlen(patch->strings->buffer)){
        NSUInteger bufferLength = strlen(patch->strings->buffer);
        NSUInteger addLength = 1000;
        NSUInteger newLength = addLength + bufferLength;
        patch->strings->buffer = realloc(patch->strings->buffer, newLength);
        // placeholder
        memset(patch->strings->buffer + bufferLength, 1, addLength);
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

    node->strings = malloc(sizeof(_StringsNode));
    memset(node->strings, 0, sizeof(_StringsNode));
    node->strings->nodeType = StringsNodeType;
    node->strings->length = _StringsNodeBaseLength;
    
    node->nodeType = PatchNodeType;
    node->enable = patch.enable;
    node->appVersion = (_StringNode *)_ORNodeConvert(patch.appVersion, node);
    node->osVersion = (_StringNode *)_ORNodeConvert(patch.osVersion, node);
    node->nodes = (_ListNode *)_ORNodeConvert(patch.nodes, node);
    node->length = _PatchNodeBaseLength + node->appVersion->length + node->strings->length + node->osVersion->length + node->nodes->length;
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

void _ORNodeSerailization(_ORNode *node, void *buffer, uint32_t *cursor);
void _StringNodeSerailization(_StringNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _StringNodeBaseLength);
    *cursor += _StringNodeBaseLength;
}
void _ListNodeSerailization(_ListNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ListNodeBaseLength);
    *cursor += _ListNodeBaseLength;
    for (int i = 0; i < node->count; i++) {
        _ORNodeSerailization(node->nodes[i], buffer, cursor);
    }
}
void _StringsNodeSerailization(_StringsNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _StringsNodeBaseLength);
    *cursor += _StringsNodeBaseLength;
    memcpy(buffer + *cursor, node->buffer, node->cursor);
    *cursor += node->cursor;
}
void _PatchNodeSerialization(_PatchNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _PatchNodeBaseLength);
    *cursor += _PatchNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->strings, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->appVersion, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->osVersion, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->nodes, buffer, cursor);
}

_ORNode *_ORNodeDeserialization(void *buffer, uint32_t *cursor,uint32_t bufferLength);
_StringNode * _StringNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _StringNode *node = malloc(sizeof(_StringNode));
    memcpy(node, buffer + *cursor, _StringNodeBaseLength);
    *cursor += _StringNodeBaseLength;
    return node;
}
_ListNode *_ListNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ListNode *node = malloc(sizeof(_ListNode));
    memcpy(node, buffer + *cursor, _ListNodeBaseLength);
    *cursor += _ListNodeBaseLength;
    node->nodes = malloc(sizeof(void *) * node->count);
    for (int i = 0; i < node->count; i++) {
        node->nodes[i] = _ORNodeDeserialization(buffer, cursor, bufferLength);
    }
    return node;
}
_StringsNode *_StringsNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _StringsNode *node = malloc(sizeof(_StringsNode));
    memcpy(node, buffer + *cursor, _StringsNodeBaseLength);
    *cursor += _StringsNodeBaseLength;
    node->buffer = malloc(node->cursor);
    memcpy(node->buffer, buffer + *cursor, node->cursor);
    *cursor += node->cursor;
    return node;
}
_PatchNode *_PatchNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _PatchNode *node = malloc(sizeof(_PatchNode));
    memcpy(node, buffer + *cursor, _PatchNodeBaseLength);
    *cursor += _PatchNodeBaseLength;
    node->strings = (_StringsNode *)_StringsNodeDeserialization(buffer, cursor, bufferLength);
    node->appVersion = (_StringNode *)_ORNodeDeserialization(buffer, cursor, bufferLength);
    node->osVersion = (_StringNode *)_ORNodeDeserialization(buffer, cursor, bufferLength);
    node->nodes = (_ListNode *)_ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    uint32_t type;
    _StringNode *name;
}_ORTypeSpecial;
static uint32_t _ORTypeSpecialBaseLength = 9;
_ORTypeSpecial *_ORTypeSpecialConvert(ORTypeSpecial *exp, _PatchNode *patch){
    _ORTypeSpecial *node = malloc(sizeof(_ORTypeSpecial));
    memset(node, 0, sizeof(_ORTypeSpecial));
    node->nodeType = _ORTypeSpecialNode;
    node->type = exp.type;
    node->name = (_StringNode *)_ORNodeConvert(exp.name, patch);
    node->length = _ORTypeSpecialBaseLength +node->name->length;
    return node;
}
ORTypeSpecial *_ORTypeSpecialDeConvert(_ORTypeSpecial *node, _PatchNode *patch){
    ORTypeSpecial *exp = [ORTypeSpecial new];
    exp.type = node->type;
    exp.name = (NSString *)_ORNodeDeConvert((_ORNode *)node->name, patch);
    return exp;
}
void _ORTypeSpecialSerailization(_ORTypeSpecial *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORTypeSpecialBaseLength);
    *cursor += _ORTypeSpecialBaseLength;
    _ORNodeSerailization((_ORNode *)node->name, buffer, cursor);
}
_ORTypeSpecial *_ORTypeSpecialDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORTypeSpecial *node = malloc(sizeof(_ORTypeSpecial));
    memcpy(node, buffer + *cursor, _ORTypeSpecialBaseLength);
    *cursor += _ORTypeSpecialBaseLength;
    node->name =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    BOOL isBlock;
    uint32_t ptCount;
    _StringNode *varname;
}_ORVariable;
static uint32_t _ORVariableBaseLength = 10;
_ORVariable *_ORVariableConvert(ORVariable *exp, _PatchNode *patch){
    _ORVariable *node = malloc(sizeof(_ORVariable));
    memset(node, 0, sizeof(_ORVariable));
    node->nodeType = _ORVariableNode;
    node->isBlock = exp.isBlock;
    node->ptCount = exp.ptCount;
    node->varname = (_StringNode *)_ORNodeConvert(exp.varname, patch);
    node->length = _ORVariableBaseLength +node->varname->length;
    return node;
}
ORVariable *_ORVariableDeConvert(_ORVariable *node, _PatchNode *patch){
    ORVariable *exp = [ORVariable new];
    exp.isBlock = node->isBlock;
    exp.ptCount = node->ptCount;
    exp.varname = (NSString *)_ORNodeDeConvert((_ORNode *)node->varname, patch);
    return exp;
}
void _ORVariableSerailization(_ORVariable *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORVariableBaseLength);
    *cursor += _ORVariableBaseLength;
    _ORNodeSerailization((_ORNode *)node->varname, buffer, cursor);
}
_ORVariable *_ORVariableDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORVariable *node = malloc(sizeof(_ORVariable));
    memcpy(node, buffer + *cursor, _ORVariableBaseLength);
    *cursor += _ORVariableBaseLength;
    node->varname =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _ORNode *type;
    _ORNode *var;
}_ORTypeVarPair;
static uint32_t _ORTypeVarPairBaseLength = 5;
_ORTypeVarPair *_ORTypeVarPairConvert(ORTypeVarPair *exp, _PatchNode *patch){
    _ORTypeVarPair *node = malloc(sizeof(_ORTypeVarPair));
    memset(node, 0, sizeof(_ORTypeVarPair));
    node->nodeType = _ORTypeVarPairNode;
    node->type = _ORNodeConvert(exp.type, patch);
    node->var = _ORNodeConvert(exp.var, patch);
    node->length = _ORTypeVarPairBaseLength +node->type->length + node->var->length;
    return node;
}
ORTypeVarPair *_ORTypeVarPairDeConvert(_ORTypeVarPair *node, _PatchNode *patch){
    ORTypeVarPair *exp = [ORTypeVarPair new];
    exp.type = _ORNodeDeConvert((_ORNode *)node->type, patch);
    exp.var = _ORNodeDeConvert((_ORNode *)node->var, patch);
    return exp;
}
void _ORTypeVarPairSerailization(_ORTypeVarPair *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORTypeVarPairBaseLength);
    *cursor += _ORTypeVarPairBaseLength;
    _ORNodeSerailization((_ORNode *)node->type, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->var, buffer, cursor);
}
_ORTypeVarPair *_ORTypeVarPairDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORTypeVarPair *node = malloc(sizeof(_ORTypeVarPair));
    memcpy(node, buffer + *cursor, _ORTypeVarPairBaseLength);
    *cursor += _ORTypeVarPairBaseLength;
    node->type =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->var =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _ListNode *pairs;
    BOOL isMultiArgs;
}_ORFuncVariable;
static uint32_t _ORFuncVariableBaseLength = 6;
_ORFuncVariable *_ORFuncVariableConvert(ORFuncVariable *exp, _PatchNode *patch){
    _ORFuncVariable *node = malloc(sizeof(_ORFuncVariable));
    memset(node, 0, sizeof(_ORFuncVariable));
    node->nodeType = _ORFuncVariableNode;
    node->pairs = (_ListNode *)_ORNodeConvert(exp.pairs, patch);
    node->isMultiArgs = exp.isMultiArgs;
    node->length = _ORFuncVariableBaseLength +node->pairs->length;
    return node;
}
ORFuncVariable *_ORFuncVariableDeConvert(_ORFuncVariable *node, _PatchNode *patch){
    ORFuncVariable *exp = [ORFuncVariable new];
    exp.pairs = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->pairs, patch);
    exp.isMultiArgs = node->isMultiArgs;
    return exp;
}
void _ORFuncVariableSerailization(_ORFuncVariable *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORFuncVariableBaseLength);
    *cursor += _ORFuncVariableBaseLength;
    _ORNodeSerailization((_ORNode *)node->pairs, buffer, cursor);
}
_ORFuncVariable *_ORFuncVariableDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORFuncVariable *node = malloc(sizeof(_ORFuncVariable));
    memcpy(node, buffer + *cursor, _ORFuncVariableBaseLength);
    *cursor += _ORFuncVariableBaseLength;
    node->pairs =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _ORNode *returnType;
    _ORNode *funVar;
}_ORFuncDeclare;
static uint32_t _ORFuncDeclareBaseLength = 5;
_ORFuncDeclare *_ORFuncDeclareConvert(ORFuncDeclare *exp, _PatchNode *patch){
    _ORFuncDeclare *node = malloc(sizeof(_ORFuncDeclare));
    memset(node, 0, sizeof(_ORFuncDeclare));
    node->nodeType = _ORFuncDeclareNode;
    node->returnType = _ORNodeConvert(exp.returnType, patch);
    node->funVar = _ORNodeConvert(exp.funVar, patch);
    node->length = _ORFuncDeclareBaseLength +node->returnType->length + node->funVar->length;
    return node;
}
ORFuncDeclare *_ORFuncDeclareDeConvert(_ORFuncDeclare *node, _PatchNode *patch){
    ORFuncDeclare *exp = [ORFuncDeclare new];
    exp.returnType = _ORNodeDeConvert((_ORNode *)node->returnType, patch);
    exp.funVar = _ORNodeDeConvert((_ORNode *)node->funVar, patch);
    return exp;
}
void _ORFuncDeclareSerailization(_ORFuncDeclare *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORFuncDeclareBaseLength);
    *cursor += _ORFuncDeclareBaseLength;
    _ORNodeSerailization((_ORNode *)node->returnType, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->funVar, buffer, cursor);
}
_ORFuncDeclare *_ORFuncDeclareDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORFuncDeclare *node = malloc(sizeof(_ORFuncDeclare));
    memcpy(node, buffer + *cursor, _ORFuncDeclareBaseLength);
    *cursor += _ORFuncDeclareBaseLength;
    node->returnType =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->funVar =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _ListNode *statements;
}_ORScopeImp;
static uint32_t _ORScopeImpBaseLength = 5;
_ORScopeImp *_ORScopeImpConvert(ORScopeImp *exp, _PatchNode *patch){
    _ORScopeImp *node = malloc(sizeof(_ORScopeImp));
    memset(node, 0, sizeof(_ORScopeImp));
    node->nodeType = _ORScopeImpNode;
    node->statements = (_ListNode *)_ORNodeConvert(exp.statements, patch);
    node->length = _ORScopeImpBaseLength +node->statements->length;
    return node;
}
ORScopeImp *_ORScopeImpDeConvert(_ORScopeImp *node, _PatchNode *patch){
    ORScopeImp *exp = [ORScopeImp new];
    exp.statements = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->statements, patch);
    return exp;
}
void _ORScopeImpSerailization(_ORScopeImp *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORScopeImpBaseLength);
    *cursor += _ORScopeImpBaseLength;
    _ORNodeSerailization((_ORNode *)node->statements, buffer, cursor);
}
_ORScopeImp *_ORScopeImpDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORScopeImp *node = malloc(sizeof(_ORScopeImp));
    memcpy(node, buffer + *cursor, _ORScopeImpBaseLength);
    *cursor += _ORScopeImpBaseLength;
    node->statements =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    uint32_t value_type;
    _ORNode *value;
}_ORValueExpression;
static uint32_t _ORValueExpressionBaseLength = 9;
_ORValueExpression *_ORValueExpressionConvert(ORValueExpression *exp, _PatchNode *patch){
    _ORValueExpression *node = malloc(sizeof(_ORValueExpression));
    memset(node, 0, sizeof(_ORValueExpression));
    node->nodeType = _ORValueExpressionNode;
    node->value_type = exp.value_type;
    node->value = _ORNodeConvert(exp.value, patch);
    node->length = _ORValueExpressionBaseLength +node->value->length;
    return node;
}
ORValueExpression *_ORValueExpressionDeConvert(_ORValueExpression *node, _PatchNode *patch){
    ORValueExpression *exp = [ORValueExpression new];
    exp.value_type = node->value_type;
    exp.value = _ORNodeDeConvert((_ORNode *)node->value, patch);
    return exp;
}
void _ORValueExpressionSerailization(_ORValueExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORValueExpressionBaseLength);
    *cursor += _ORValueExpressionBaseLength;
    _ORNodeSerailization((_ORNode *)node->value, buffer, cursor);
}
_ORValueExpression *_ORValueExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORValueExpression *node = malloc(sizeof(_ORValueExpression));
    memcpy(node, buffer + *cursor, _ORValueExpressionBaseLength);
    *cursor += _ORValueExpressionBaseLength;
    node->value =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    BOOL isDot;
    BOOL isAssignedValue;
    _ORNode *caller;
    _ListNode *names;
    _ListNode *values;
}_ORMethodCall;
static uint32_t _ORMethodCallBaseLength = 7;
_ORMethodCall *_ORMethodCallConvert(ORMethodCall *exp, _PatchNode *patch){
    _ORMethodCall *node = malloc(sizeof(_ORMethodCall));
    memset(node, 0, sizeof(_ORMethodCall));
    node->nodeType = _ORMethodCallNode;
    node->isDot = exp.isDot;
    node->isAssignedValue = exp.isAssignedValue;
    node->caller = _ORNodeConvert(exp.caller, patch);
    node->names = (_ListNode *)_ORNodeConvert(exp.names, patch);
    node->values = (_ListNode *)_ORNodeConvert(exp.values, patch);
    node->length = _ORMethodCallBaseLength +node->caller->length + node->names->length + node->values->length;
    return node;
}
ORMethodCall *_ORMethodCallDeConvert(_ORMethodCall *node, _PatchNode *patch){
    ORMethodCall *exp = [ORMethodCall new];
    exp.isDot = node->isDot;
    exp.isAssignedValue = node->isAssignedValue;
    exp.caller = _ORNodeDeConvert((_ORNode *)node->caller, patch);
    exp.names = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->names, patch);
    exp.values = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->values, patch);
    return exp;
}
void _ORMethodCallSerailization(_ORMethodCall *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORMethodCallBaseLength);
    *cursor += _ORMethodCallBaseLength;
    _ORNodeSerailization((_ORNode *)node->caller, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->names, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->values, buffer, cursor);
}
_ORMethodCall *_ORMethodCallDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORMethodCall *node = malloc(sizeof(_ORMethodCall));
    memcpy(node, buffer + *cursor, _ORMethodCallBaseLength);
    *cursor += _ORMethodCallBaseLength;
    node->caller =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->names =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->values =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _ORNode *caller;
    _ListNode *expressions;
}_ORCFuncCall;
static uint32_t _ORCFuncCallBaseLength = 5;
_ORCFuncCall *_ORCFuncCallConvert(ORCFuncCall *exp, _PatchNode *patch){
    _ORCFuncCall *node = malloc(sizeof(_ORCFuncCall));
    memset(node, 0, sizeof(_ORCFuncCall));
    node->nodeType = _ORCFuncCallNode;
    node->caller = _ORNodeConvert(exp.caller, patch);
    node->expressions = (_ListNode *)_ORNodeConvert(exp.expressions, patch);
    node->length = _ORCFuncCallBaseLength +node->caller->length + node->expressions->length;
    return node;
}
ORCFuncCall *_ORCFuncCallDeConvert(_ORCFuncCall *node, _PatchNode *patch){
    ORCFuncCall *exp = [ORCFuncCall new];
    exp.caller = _ORNodeDeConvert((_ORNode *)node->caller, patch);
    exp.expressions = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->expressions, patch);
    return exp;
}
void _ORCFuncCallSerailization(_ORCFuncCall *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORCFuncCallBaseLength);
    *cursor += _ORCFuncCallBaseLength;
    _ORNodeSerailization((_ORNode *)node->caller, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->expressions, buffer, cursor);
}
_ORCFuncCall *_ORCFuncCallDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORCFuncCall *node = malloc(sizeof(_ORCFuncCall));
    memcpy(node, buffer + *cursor, _ORCFuncCallBaseLength);
    *cursor += _ORCFuncCallBaseLength;
    node->caller =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->expressions =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _ORNode *declare;
    _ORNode *scopeImp;
}_ORFunctionImp;
static uint32_t _ORFunctionImpBaseLength = 5;
_ORFunctionImp *_ORFunctionImpConvert(ORFunctionImp *exp, _PatchNode *patch){
    _ORFunctionImp *node = malloc(sizeof(_ORFunctionImp));
    memset(node, 0, sizeof(_ORFunctionImp));
    node->nodeType = _ORFunctionImpNode;
    node->declare = _ORNodeConvert(exp.declare, patch);
    node->scopeImp = _ORNodeConvert(exp.scopeImp, patch);
    node->length = _ORFunctionImpBaseLength +node->declare->length + node->scopeImp->length;
    return node;
}
ORFunctionImp *_ORFunctionImpDeConvert(_ORFunctionImp *node, _PatchNode *patch){
    ORFunctionImp *exp = [ORFunctionImp new];
    exp.declare = _ORNodeDeConvert((_ORNode *)node->declare, patch);
    exp.scopeImp = _ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
    return exp;
}
void _ORFunctionImpSerailization(_ORFunctionImp *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORFunctionImpBaseLength);
    *cursor += _ORFunctionImpBaseLength;
    _ORNodeSerailization((_ORNode *)node->declare, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->scopeImp, buffer, cursor);
}
_ORFunctionImp *_ORFunctionImpDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORFunctionImp *node = malloc(sizeof(_ORFunctionImp));
    memcpy(node, buffer + *cursor, _ORFunctionImpBaseLength);
    *cursor += _ORFunctionImpBaseLength;
    node->declare =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _ORNode *caller;
    _ORNode *keyExp;
}_ORSubscriptExpression;
static uint32_t _ORSubscriptExpressionBaseLength = 5;
_ORSubscriptExpression *_ORSubscriptExpressionConvert(ORSubscriptExpression *exp, _PatchNode *patch){
    _ORSubscriptExpression *node = malloc(sizeof(_ORSubscriptExpression));
    memset(node, 0, sizeof(_ORSubscriptExpression));
    node->nodeType = _ORSubscriptExpressionNode;
    node->caller = _ORNodeConvert(exp.caller, patch);
    node->keyExp = _ORNodeConvert(exp.keyExp, patch);
    node->length = _ORSubscriptExpressionBaseLength +node->caller->length + node->keyExp->length;
    return node;
}
ORSubscriptExpression *_ORSubscriptExpressionDeConvert(_ORSubscriptExpression *node, _PatchNode *patch){
    ORSubscriptExpression *exp = [ORSubscriptExpression new];
    exp.caller = _ORNodeDeConvert((_ORNode *)node->caller, patch);
    exp.keyExp = _ORNodeDeConvert((_ORNode *)node->keyExp, patch);
    return exp;
}
void _ORSubscriptExpressionSerailization(_ORSubscriptExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORSubscriptExpressionBaseLength);
    *cursor += _ORSubscriptExpressionBaseLength;
    _ORNodeSerailization((_ORNode *)node->caller, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->keyExp, buffer, cursor);
}
_ORSubscriptExpression *_ORSubscriptExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORSubscriptExpression *node = malloc(sizeof(_ORSubscriptExpression));
    memcpy(node, buffer + *cursor, _ORSubscriptExpressionBaseLength);
    *cursor += _ORSubscriptExpressionBaseLength;
    node->caller =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->keyExp =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    uint32_t assignType;
    _ORNode *value;
    _ORNode *expression;
}_ORAssignExpression;
static uint32_t _ORAssignExpressionBaseLength = 9;
_ORAssignExpression *_ORAssignExpressionConvert(ORAssignExpression *exp, _PatchNode *patch){
    _ORAssignExpression *node = malloc(sizeof(_ORAssignExpression));
    memset(node, 0, sizeof(_ORAssignExpression));
    node->nodeType = _ORAssignExpressionNode;
    node->assignType = exp.assignType;
    node->value = _ORNodeConvert(exp.value, patch);
    node->expression = _ORNodeConvert(exp.expression, patch);
    node->length = _ORAssignExpressionBaseLength +node->value->length + node->expression->length;
    return node;
}
ORAssignExpression *_ORAssignExpressionDeConvert(_ORAssignExpression *node, _PatchNode *patch){
    ORAssignExpression *exp = [ORAssignExpression new];
    exp.assignType = node->assignType;
    exp.value = _ORNodeDeConvert((_ORNode *)node->value, patch);
    exp.expression = _ORNodeDeConvert((_ORNode *)node->expression, patch);
    return exp;
}
void _ORAssignExpressionSerailization(_ORAssignExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORAssignExpressionBaseLength);
    *cursor += _ORAssignExpressionBaseLength;
    _ORNodeSerailization((_ORNode *)node->value, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->expression, buffer, cursor);
}
_ORAssignExpression *_ORAssignExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORAssignExpression *node = malloc(sizeof(_ORAssignExpression));
    memcpy(node, buffer + *cursor, _ORAssignExpressionBaseLength);
    *cursor += _ORAssignExpressionBaseLength;
    node->value =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->expression =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    uint32_t modifier;
    _ORNode *pair;
    _ORNode *expression;
}_ORDeclareExpression;
static uint32_t _ORDeclareExpressionBaseLength = 9;
_ORDeclareExpression *_ORDeclareExpressionConvert(ORDeclareExpression *exp, _PatchNode *patch){
    _ORDeclareExpression *node = malloc(sizeof(_ORDeclareExpression));
    memset(node, 0, sizeof(_ORDeclareExpression));
    node->nodeType = _ORDeclareExpressionNode;
    node->modifier = exp.modifier;
    node->pair = _ORNodeConvert(exp.pair, patch);
    node->expression = _ORNodeConvert(exp.expression, patch);
    node->length = _ORDeclareExpressionBaseLength +node->pair->length + node->expression->length;
    return node;
}
ORDeclareExpression *_ORDeclareExpressionDeConvert(_ORDeclareExpression *node, _PatchNode *patch){
    ORDeclareExpression *exp = [ORDeclareExpression new];
    exp.modifier = node->modifier;
    exp.pair = _ORNodeDeConvert((_ORNode *)node->pair, patch);
    exp.expression = _ORNodeDeConvert((_ORNode *)node->expression, patch);
    return exp;
}
void _ORDeclareExpressionSerailization(_ORDeclareExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORDeclareExpressionBaseLength);
    *cursor += _ORDeclareExpressionBaseLength;
    _ORNodeSerailization((_ORNode *)node->pair, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->expression, buffer, cursor);
}
_ORDeclareExpression *_ORDeclareExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORDeclareExpression *node = malloc(sizeof(_ORDeclareExpression));
    memcpy(node, buffer + *cursor, _ORDeclareExpressionBaseLength);
    *cursor += _ORDeclareExpressionBaseLength;
    node->pair =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->expression =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    uint32_t operatorType;
    _ORNode *value;
}_ORUnaryExpression;
static uint32_t _ORUnaryExpressionBaseLength = 9;
_ORUnaryExpression *_ORUnaryExpressionConvert(ORUnaryExpression *exp, _PatchNode *patch){
    _ORUnaryExpression *node = malloc(sizeof(_ORUnaryExpression));
    memset(node, 0, sizeof(_ORUnaryExpression));
    node->nodeType = _ORUnaryExpressionNode;
    node->operatorType = exp.operatorType;
    node->value = _ORNodeConvert(exp.value, patch);
    node->length = _ORUnaryExpressionBaseLength +node->value->length;
    return node;
}
ORUnaryExpression *_ORUnaryExpressionDeConvert(_ORUnaryExpression *node, _PatchNode *patch){
    ORUnaryExpression *exp = [ORUnaryExpression new];
    exp.operatorType = node->operatorType;
    exp.value = _ORNodeDeConvert((_ORNode *)node->value, patch);
    return exp;
}
void _ORUnaryExpressionSerailization(_ORUnaryExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORUnaryExpressionBaseLength);
    *cursor += _ORUnaryExpressionBaseLength;
    _ORNodeSerailization((_ORNode *)node->value, buffer, cursor);
}
_ORUnaryExpression *_ORUnaryExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORUnaryExpression *node = malloc(sizeof(_ORUnaryExpression));
    memcpy(node, buffer + *cursor, _ORUnaryExpressionBaseLength);
    *cursor += _ORUnaryExpressionBaseLength;
    node->value =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    uint32_t operatorType;
    _ORNode *left;
    _ORNode *right;
}_ORBinaryExpression;
static uint32_t _ORBinaryExpressionBaseLength = 9;
_ORBinaryExpression *_ORBinaryExpressionConvert(ORBinaryExpression *exp, _PatchNode *patch){
    _ORBinaryExpression *node = malloc(sizeof(_ORBinaryExpression));
    memset(node, 0, sizeof(_ORBinaryExpression));
    node->nodeType = _ORBinaryExpressionNode;
    node->operatorType = exp.operatorType;
    node->left = _ORNodeConvert(exp.left, patch);
    node->right = _ORNodeConvert(exp.right, patch);
    node->length = _ORBinaryExpressionBaseLength +node->left->length + node->right->length;
    return node;
}
ORBinaryExpression *_ORBinaryExpressionDeConvert(_ORBinaryExpression *node, _PatchNode *patch){
    ORBinaryExpression *exp = [ORBinaryExpression new];
    exp.operatorType = node->operatorType;
    exp.left = _ORNodeDeConvert((_ORNode *)node->left, patch);
    exp.right = _ORNodeDeConvert((_ORNode *)node->right, patch);
    return exp;
}
void _ORBinaryExpressionSerailization(_ORBinaryExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORBinaryExpressionBaseLength);
    *cursor += _ORBinaryExpressionBaseLength;
    _ORNodeSerailization((_ORNode *)node->left, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->right, buffer, cursor);
}
_ORBinaryExpression *_ORBinaryExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORBinaryExpression *node = malloc(sizeof(_ORBinaryExpression));
    memcpy(node, buffer + *cursor, _ORBinaryExpressionBaseLength);
    *cursor += _ORBinaryExpressionBaseLength;
    node->left =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->right =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _ORNode *expression;
    _ListNode *values;
}_ORTernaryExpression;
static uint32_t _ORTernaryExpressionBaseLength = 5;
_ORTernaryExpression *_ORTernaryExpressionConvert(ORTernaryExpression *exp, _PatchNode *patch){
    _ORTernaryExpression *node = malloc(sizeof(_ORTernaryExpression));
    memset(node, 0, sizeof(_ORTernaryExpression));
    node->nodeType = _ORTernaryExpressionNode;
    node->expression = _ORNodeConvert(exp.expression, patch);
    node->values = (_ListNode *)_ORNodeConvert(exp.values, patch);
    node->length = _ORTernaryExpressionBaseLength +node->expression->length + node->values->length;
    return node;
}
ORTernaryExpression *_ORTernaryExpressionDeConvert(_ORTernaryExpression *node, _PatchNode *patch){
    ORTernaryExpression *exp = [ORTernaryExpression new];
    exp.expression = _ORNodeDeConvert((_ORNode *)node->expression, patch);
    exp.values = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->values, patch);
    return exp;
}
void _ORTernaryExpressionSerailization(_ORTernaryExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORTernaryExpressionBaseLength);
    *cursor += _ORTernaryExpressionBaseLength;
    _ORNodeSerailization((_ORNode *)node->expression, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->values, buffer, cursor);
}
_ORTernaryExpression *_ORTernaryExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORTernaryExpression *node = malloc(sizeof(_ORTernaryExpression));
    memcpy(node, buffer + *cursor, _ORTernaryExpressionBaseLength);
    *cursor += _ORTernaryExpressionBaseLength;
    node->expression =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->values =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _ORNode *condition;
    _ORNode *last;
    _ORNode *scopeImp;
}_ORIfStatement;
static uint32_t _ORIfStatementBaseLength = 5;
_ORIfStatement *_ORIfStatementConvert(ORIfStatement *exp, _PatchNode *patch){
    _ORIfStatement *node = malloc(sizeof(_ORIfStatement));
    memset(node, 0, sizeof(_ORIfStatement));
    node->nodeType = _ORIfStatementNode;
    node->condition = _ORNodeConvert(exp.condition, patch);
    node->last = _ORNodeConvert(exp.last, patch);
    node->scopeImp = _ORNodeConvert(exp.scopeImp, patch);
    node->length = _ORIfStatementBaseLength +node->condition->length + node->last->length + node->scopeImp->length;
    return node;
}
ORIfStatement *_ORIfStatementDeConvert(_ORIfStatement *node, _PatchNode *patch){
    ORIfStatement *exp = [ORIfStatement new];
    exp.condition = _ORNodeDeConvert((_ORNode *)node->condition, patch);
    exp.last = _ORNodeDeConvert((_ORNode *)node->last, patch);
    exp.scopeImp = _ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
    return exp;
}
void _ORIfStatementSerailization(_ORIfStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORIfStatementBaseLength);
    *cursor += _ORIfStatementBaseLength;
    _ORNodeSerailization((_ORNode *)node->condition, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->last, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->scopeImp, buffer, cursor);
}
_ORIfStatement *_ORIfStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORIfStatement *node = malloc(sizeof(_ORIfStatement));
    memcpy(node, buffer + *cursor, _ORIfStatementBaseLength);
    *cursor += _ORIfStatementBaseLength;
    node->condition =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->last =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _ORNode *condition;
    _ORNode *scopeImp;
}_ORWhileStatement;
static uint32_t _ORWhileStatementBaseLength = 5;
_ORWhileStatement *_ORWhileStatementConvert(ORWhileStatement *exp, _PatchNode *patch){
    _ORWhileStatement *node = malloc(sizeof(_ORWhileStatement));
    memset(node, 0, sizeof(_ORWhileStatement));
    node->nodeType = _ORWhileStatementNode;
    node->condition = _ORNodeConvert(exp.condition, patch);
    node->scopeImp = _ORNodeConvert(exp.scopeImp, patch);
    node->length = _ORWhileStatementBaseLength +node->condition->length + node->scopeImp->length;
    return node;
}
ORWhileStatement *_ORWhileStatementDeConvert(_ORWhileStatement *node, _PatchNode *patch){
    ORWhileStatement *exp = [ORWhileStatement new];
    exp.condition = _ORNodeDeConvert((_ORNode *)node->condition, patch);
    exp.scopeImp = _ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
    return exp;
}
void _ORWhileStatementSerailization(_ORWhileStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORWhileStatementBaseLength);
    *cursor += _ORWhileStatementBaseLength;
    _ORNodeSerailization((_ORNode *)node->condition, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->scopeImp, buffer, cursor);
}
_ORWhileStatement *_ORWhileStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORWhileStatement *node = malloc(sizeof(_ORWhileStatement));
    memcpy(node, buffer + *cursor, _ORWhileStatementBaseLength);
    *cursor += _ORWhileStatementBaseLength;
    node->condition =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _ORNode *condition;
    _ORNode *scopeImp;
}_ORDoWhileStatement;
static uint32_t _ORDoWhileStatementBaseLength = 5;
_ORDoWhileStatement *_ORDoWhileStatementConvert(ORDoWhileStatement *exp, _PatchNode *patch){
    _ORDoWhileStatement *node = malloc(sizeof(_ORDoWhileStatement));
    memset(node, 0, sizeof(_ORDoWhileStatement));
    node->nodeType = _ORDoWhileStatementNode;
    node->condition = _ORNodeConvert(exp.condition, patch);
    node->scopeImp = _ORNodeConvert(exp.scopeImp, patch);
    node->length = _ORDoWhileStatementBaseLength +node->condition->length + node->scopeImp->length;
    return node;
}
ORDoWhileStatement *_ORDoWhileStatementDeConvert(_ORDoWhileStatement *node, _PatchNode *patch){
    ORDoWhileStatement *exp = [ORDoWhileStatement new];
    exp.condition = _ORNodeDeConvert((_ORNode *)node->condition, patch);
    exp.scopeImp = _ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
    return exp;
}
void _ORDoWhileStatementSerailization(_ORDoWhileStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORDoWhileStatementBaseLength);
    *cursor += _ORDoWhileStatementBaseLength;
    _ORNodeSerailization((_ORNode *)node->condition, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->scopeImp, buffer, cursor);
}
_ORDoWhileStatement *_ORDoWhileStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORDoWhileStatement *node = malloc(sizeof(_ORDoWhileStatement));
    memcpy(node, buffer + *cursor, _ORDoWhileStatementBaseLength);
    *cursor += _ORDoWhileStatementBaseLength;
    node->condition =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _ORNode *value;
    _ORNode *scopeImp;
}_ORCaseStatement;
static uint32_t _ORCaseStatementBaseLength = 5;
_ORCaseStatement *_ORCaseStatementConvert(ORCaseStatement *exp, _PatchNode *patch){
    _ORCaseStatement *node = malloc(sizeof(_ORCaseStatement));
    memset(node, 0, sizeof(_ORCaseStatement));
    node->nodeType = _ORCaseStatementNode;
    node->value = _ORNodeConvert(exp.value, patch);
    node->scopeImp = _ORNodeConvert(exp.scopeImp, patch);
    node->length = _ORCaseStatementBaseLength +node->value->length + node->scopeImp->length;
    return node;
}
ORCaseStatement *_ORCaseStatementDeConvert(_ORCaseStatement *node, _PatchNode *patch){
    ORCaseStatement *exp = [ORCaseStatement new];
    exp.value = _ORNodeDeConvert((_ORNode *)node->value, patch);
    exp.scopeImp = _ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
    return exp;
}
void _ORCaseStatementSerailization(_ORCaseStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORCaseStatementBaseLength);
    *cursor += _ORCaseStatementBaseLength;
    _ORNodeSerailization((_ORNode *)node->value, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->scopeImp, buffer, cursor);
}
_ORCaseStatement *_ORCaseStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORCaseStatement *node = malloc(sizeof(_ORCaseStatement));
    memcpy(node, buffer + *cursor, _ORCaseStatementBaseLength);
    *cursor += _ORCaseStatementBaseLength;
    node->value =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _ORNode *value;
    _ListNode *cases;
    _ORNode *scopeImp;
}_ORSwitchStatement;
static uint32_t _ORSwitchStatementBaseLength = 5;
_ORSwitchStatement *_ORSwitchStatementConvert(ORSwitchStatement *exp, _PatchNode *patch){
    _ORSwitchStatement *node = malloc(sizeof(_ORSwitchStatement));
    memset(node, 0, sizeof(_ORSwitchStatement));
    node->nodeType = _ORSwitchStatementNode;
    node->value = _ORNodeConvert(exp.value, patch);
    node->cases = (_ListNode *)_ORNodeConvert(exp.cases, patch);
    node->scopeImp = _ORNodeConvert(exp.scopeImp, patch);
    node->length = _ORSwitchStatementBaseLength +node->value->length + node->cases->length + node->scopeImp->length;
    return node;
}
ORSwitchStatement *_ORSwitchStatementDeConvert(_ORSwitchStatement *node, _PatchNode *patch){
    ORSwitchStatement *exp = [ORSwitchStatement new];
    exp.value = _ORNodeDeConvert((_ORNode *)node->value, patch);
    exp.cases = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->cases, patch);
    exp.scopeImp = _ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
    return exp;
}
void _ORSwitchStatementSerailization(_ORSwitchStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORSwitchStatementBaseLength);
    *cursor += _ORSwitchStatementBaseLength;
    _ORNodeSerailization((_ORNode *)node->value, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->cases, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->scopeImp, buffer, cursor);
}
_ORSwitchStatement *_ORSwitchStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORSwitchStatement *node = malloc(sizeof(_ORSwitchStatement));
    memcpy(node, buffer + *cursor, _ORSwitchStatementBaseLength);
    *cursor += _ORSwitchStatementBaseLength;
    node->value =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->cases =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _ListNode *varExpressions;
    _ORNode *condition;
    _ListNode *expressions;
    _ORNode *scopeImp;
}_ORForStatement;
static uint32_t _ORForStatementBaseLength = 5;
_ORForStatement *_ORForStatementConvert(ORForStatement *exp, _PatchNode *patch){
    _ORForStatement *node = malloc(sizeof(_ORForStatement));
    memset(node, 0, sizeof(_ORForStatement));
    node->nodeType = _ORForStatementNode;
    node->varExpressions = (_ListNode *)_ORNodeConvert(exp.varExpressions, patch);
    node->condition = _ORNodeConvert(exp.condition, patch);
    node->expressions = (_ListNode *)_ORNodeConvert(exp.expressions, patch);
    node->scopeImp = _ORNodeConvert(exp.scopeImp, patch);
    node->length = _ORForStatementBaseLength +node->varExpressions->length + node->condition->length + node->expressions->length + node->scopeImp->length;
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
void _ORForStatementSerailization(_ORForStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORForStatementBaseLength);
    *cursor += _ORForStatementBaseLength;
    _ORNodeSerailization((_ORNode *)node->varExpressions, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->condition, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->expressions, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->scopeImp, buffer, cursor);
}
_ORForStatement *_ORForStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORForStatement *node = malloc(sizeof(_ORForStatement));
    memcpy(node, buffer + *cursor, _ORForStatementBaseLength);
    *cursor += _ORForStatementBaseLength;
    node->varExpressions =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->condition =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->expressions =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _ORNode *expression;
    _ORNode *value;
    _ORNode *scopeImp;
}_ORForInStatement;
static uint32_t _ORForInStatementBaseLength = 5;
_ORForInStatement *_ORForInStatementConvert(ORForInStatement *exp, _PatchNode *patch){
    _ORForInStatement *node = malloc(sizeof(_ORForInStatement));
    memset(node, 0, sizeof(_ORForInStatement));
    node->nodeType = _ORForInStatementNode;
    node->expression = _ORNodeConvert(exp.expression, patch);
    node->value = _ORNodeConvert(exp.value, patch);
    node->scopeImp = _ORNodeConvert(exp.scopeImp, patch);
    node->length = _ORForInStatementBaseLength +node->expression->length + node->value->length + node->scopeImp->length;
    return node;
}
ORForInStatement *_ORForInStatementDeConvert(_ORForInStatement *node, _PatchNode *patch){
    ORForInStatement *exp = [ORForInStatement new];
    exp.expression = _ORNodeDeConvert((_ORNode *)node->expression, patch);
    exp.value = _ORNodeDeConvert((_ORNode *)node->value, patch);
    exp.scopeImp = _ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
    return exp;
}
void _ORForInStatementSerailization(_ORForInStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORForInStatementBaseLength);
    *cursor += _ORForInStatementBaseLength;
    _ORNodeSerailization((_ORNode *)node->expression, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->value, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->scopeImp, buffer, cursor);
}
_ORForInStatement *_ORForInStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORForInStatement *node = malloc(sizeof(_ORForInStatement));
    memcpy(node, buffer + *cursor, _ORForInStatementBaseLength);
    *cursor += _ORForInStatementBaseLength;
    node->expression =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->value =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _ORNode *expression;
}_ORReturnStatement;
static uint32_t _ORReturnStatementBaseLength = 5;
_ORReturnStatement *_ORReturnStatementConvert(ORReturnStatement *exp, _PatchNode *patch){
    _ORReturnStatement *node = malloc(sizeof(_ORReturnStatement));
    memset(node, 0, sizeof(_ORReturnStatement));
    node->nodeType = _ORReturnStatementNode;
    node->expression = _ORNodeConvert(exp.expression, patch);
    node->length = _ORReturnStatementBaseLength +node->expression->length;
    return node;
}
ORReturnStatement *_ORReturnStatementDeConvert(_ORReturnStatement *node, _PatchNode *patch){
    ORReturnStatement *exp = [ORReturnStatement new];
    exp.expression = _ORNodeDeConvert((_ORNode *)node->expression, patch);
    return exp;
}
void _ORReturnStatementSerailization(_ORReturnStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORReturnStatementBaseLength);
    *cursor += _ORReturnStatementBaseLength;
    _ORNodeSerailization((_ORNode *)node->expression, buffer, cursor);
}
_ORReturnStatement *_ORReturnStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORReturnStatement *node = malloc(sizeof(_ORReturnStatement));
    memcpy(node, buffer + *cursor, _ORReturnStatementBaseLength);
    *cursor += _ORReturnStatementBaseLength;
    node->expression =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    
}_ORBreakStatement;
static uint32_t _ORBreakStatementBaseLength = 5;
_ORBreakStatement *_ORBreakStatementConvert(ORBreakStatement *exp, _PatchNode *patch){
    _ORBreakStatement *node = malloc(sizeof(_ORBreakStatement));
    memset(node, 0, sizeof(_ORBreakStatement));
    node->nodeType = _ORBreakStatementNode;
    
    node->length = _ORBreakStatementBaseLength ;
    return node;
}
ORBreakStatement *_ORBreakStatementDeConvert(_ORBreakStatement *node, _PatchNode *patch){
    ORBreakStatement *exp = [ORBreakStatement new];
    
    return exp;
}
void _ORBreakStatementSerailization(_ORBreakStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORBreakStatementBaseLength);
    *cursor += _ORBreakStatementBaseLength;
    
}
_ORBreakStatement *_ORBreakStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORBreakStatement *node = malloc(sizeof(_ORBreakStatement));
    memcpy(node, buffer + *cursor, _ORBreakStatementBaseLength);
    *cursor += _ORBreakStatementBaseLength;
    
    return node;
}
typedef struct {
    _ORNodeFields
    
}_ORContinueStatement;
static uint32_t _ORContinueStatementBaseLength = 5;
_ORContinueStatement *_ORContinueStatementConvert(ORContinueStatement *exp, _PatchNode *patch){
    _ORContinueStatement *node = malloc(sizeof(_ORContinueStatement));
    memset(node, 0, sizeof(_ORContinueStatement));
    node->nodeType = _ORContinueStatementNode;
    
    node->length = _ORContinueStatementBaseLength ;
    return node;
}
ORContinueStatement *_ORContinueStatementDeConvert(_ORContinueStatement *node, _PatchNode *patch){
    ORContinueStatement *exp = [ORContinueStatement new];
    
    return exp;
}
void _ORContinueStatementSerailization(_ORContinueStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORContinueStatementBaseLength);
    *cursor += _ORContinueStatementBaseLength;
    
}
_ORContinueStatement *_ORContinueStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORContinueStatement *node = malloc(sizeof(_ORContinueStatement));
    memcpy(node, buffer + *cursor, _ORContinueStatementBaseLength);
    *cursor += _ORContinueStatementBaseLength;
    
    return node;
}
typedef struct {
    _ORNodeFields
    _ListNode *keywords;
    _ORNode *var;
}_ORPropertyDeclare;
static uint32_t _ORPropertyDeclareBaseLength = 5;
_ORPropertyDeclare *_ORPropertyDeclareConvert(ORPropertyDeclare *exp, _PatchNode *patch){
    _ORPropertyDeclare *node = malloc(sizeof(_ORPropertyDeclare));
    memset(node, 0, sizeof(_ORPropertyDeclare));
    node->nodeType = _ORPropertyDeclareNode;
    node->keywords = (_ListNode *)_ORNodeConvert(exp.keywords, patch);
    node->var = _ORNodeConvert(exp.var, patch);
    node->length = _ORPropertyDeclareBaseLength +node->keywords->length + node->var->length;
    return node;
}
ORPropertyDeclare *_ORPropertyDeclareDeConvert(_ORPropertyDeclare *node, _PatchNode *patch){
    ORPropertyDeclare *exp = [ORPropertyDeclare new];
    exp.keywords = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->keywords, patch);
    exp.var = _ORNodeDeConvert((_ORNode *)node->var, patch);
    return exp;
}
void _ORPropertyDeclareSerailization(_ORPropertyDeclare *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORPropertyDeclareBaseLength);
    *cursor += _ORPropertyDeclareBaseLength;
    _ORNodeSerailization((_ORNode *)node->keywords, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->var, buffer, cursor);
}
_ORPropertyDeclare *_ORPropertyDeclareDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORPropertyDeclare *node = malloc(sizeof(_ORPropertyDeclare));
    memcpy(node, buffer + *cursor, _ORPropertyDeclareBaseLength);
    *cursor += _ORPropertyDeclareBaseLength;
    node->keywords =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->var =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    BOOL isClassMethod;
    _ORNode *returnType;
    _ListNode *methodNames;
    _ListNode *parameterTypes;
    _ListNode *parameterNames;
}_ORMethodDeclare;
static uint32_t _ORMethodDeclareBaseLength = 6;
_ORMethodDeclare *_ORMethodDeclareConvert(ORMethodDeclare *exp, _PatchNode *patch){
    _ORMethodDeclare *node = malloc(sizeof(_ORMethodDeclare));
    memset(node, 0, sizeof(_ORMethodDeclare));
    node->nodeType = _ORMethodDeclareNode;
    node->isClassMethod = exp.isClassMethod;
    node->returnType = _ORNodeConvert(exp.returnType, patch);
    node->methodNames = (_ListNode *)_ORNodeConvert(exp.methodNames, patch);
    node->parameterTypes = (_ListNode *)_ORNodeConvert(exp.parameterTypes, patch);
    node->parameterNames = (_ListNode *)_ORNodeConvert(exp.parameterNames, patch);
    node->length = _ORMethodDeclareBaseLength +node->returnType->length + node->methodNames->length + node->parameterTypes->length + node->parameterNames->length;
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
void _ORMethodDeclareSerailization(_ORMethodDeclare *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORMethodDeclareBaseLength);
    *cursor += _ORMethodDeclareBaseLength;
    _ORNodeSerailization((_ORNode *)node->returnType, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->methodNames, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->parameterTypes, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->parameterNames, buffer, cursor);
}
_ORMethodDeclare *_ORMethodDeclareDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORMethodDeclare *node = malloc(sizeof(_ORMethodDeclare));
    memcpy(node, buffer + *cursor, _ORMethodDeclareBaseLength);
    *cursor += _ORMethodDeclareBaseLength;
    node->returnType =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->methodNames =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->parameterTypes =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->parameterNames =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _ORNode *declare;
    _ORNode *scopeImp;
}_ORMethodImplementation;
static uint32_t _ORMethodImplementationBaseLength = 5;
_ORMethodImplementation *_ORMethodImplementationConvert(ORMethodImplementation *exp, _PatchNode *patch){
    _ORMethodImplementation *node = malloc(sizeof(_ORMethodImplementation));
    memset(node, 0, sizeof(_ORMethodImplementation));
    node->nodeType = _ORMethodImplementationNode;
    node->declare = _ORNodeConvert(exp.declare, patch);
    node->scopeImp = _ORNodeConvert(exp.scopeImp, patch);
    node->length = _ORMethodImplementationBaseLength +node->declare->length + node->scopeImp->length;
    return node;
}
ORMethodImplementation *_ORMethodImplementationDeConvert(_ORMethodImplementation *node, _PatchNode *patch){
    ORMethodImplementation *exp = [ORMethodImplementation new];
    exp.declare = _ORNodeDeConvert((_ORNode *)node->declare, patch);
    exp.scopeImp = _ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
    return exp;
}
void _ORMethodImplementationSerailization(_ORMethodImplementation *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORMethodImplementationBaseLength);
    *cursor += _ORMethodImplementationBaseLength;
    _ORNodeSerailization((_ORNode *)node->declare, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->scopeImp, buffer, cursor);
}
_ORMethodImplementation *_ORMethodImplementationDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORMethodImplementation *node = malloc(sizeof(_ORMethodImplementation));
    memcpy(node, buffer + *cursor, _ORMethodImplementationBaseLength);
    *cursor += _ORMethodImplementationBaseLength;
    node->declare =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
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
static uint32_t _ORClassBaseLength = 5;
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
    node->length = _ORClassBaseLength +node->className->length + node->superClassName->length + node->protocols->length + node->properties->length + node->privateVariables->length + node->methods->length;
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
void _ORClassSerailization(_ORClass *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORClassBaseLength);
    *cursor += _ORClassBaseLength;
    _ORNodeSerailization((_ORNode *)node->className, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->superClassName, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->protocols, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->properties, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->privateVariables, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->methods, buffer, cursor);
}
_ORClass *_ORClassDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORClass *node = malloc(sizeof(_ORClass));
    memcpy(node, buffer + *cursor, _ORClassBaseLength);
    *cursor += _ORClassBaseLength;
    node->className =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->superClassName =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->protocols =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->properties =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->privateVariables =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->methods =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _StringNode *protcolName;
    _ListNode *protocols;
    _ListNode *properties;
    _ListNode *methods;
}_ORProtocol;
static uint32_t _ORProtocolBaseLength = 5;
_ORProtocol *_ORProtocolConvert(ORProtocol *exp, _PatchNode *patch){
    _ORProtocol *node = malloc(sizeof(_ORProtocol));
    memset(node, 0, sizeof(_ORProtocol));
    node->nodeType = _ORProtocolNode;
    node->protcolName = (_StringNode *)_ORNodeConvert(exp.protcolName, patch);
    node->protocols = (_ListNode *)_ORNodeConvert(exp.protocols, patch);
    node->properties = (_ListNode *)_ORNodeConvert(exp.properties, patch);
    node->methods = (_ListNode *)_ORNodeConvert(exp.methods, patch);
    node->length = _ORProtocolBaseLength +node->protcolName->length + node->protocols->length + node->properties->length + node->methods->length;
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
void _ORProtocolSerailization(_ORProtocol *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORProtocolBaseLength);
    *cursor += _ORProtocolBaseLength;
    _ORNodeSerailization((_ORNode *)node->protcolName, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->protocols, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->properties, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->methods, buffer, cursor);
}
_ORProtocol *_ORProtocolDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORProtocol *node = malloc(sizeof(_ORProtocol));
    memcpy(node, buffer + *cursor, _ORProtocolBaseLength);
    *cursor += _ORProtocolBaseLength;
    node->protcolName =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->protocols =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->properties =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->methods =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _StringNode *sturctName;
    _ListNode *fields;
}_ORStructExpressoin;
static uint32_t _ORStructExpressoinBaseLength = 5;
_ORStructExpressoin *_ORStructExpressoinConvert(ORStructExpressoin *exp, _PatchNode *patch){
    _ORStructExpressoin *node = malloc(sizeof(_ORStructExpressoin));
    memset(node, 0, sizeof(_ORStructExpressoin));
    node->nodeType = _ORStructExpressoinNode;
    node->sturctName = (_StringNode *)_ORNodeConvert(exp.sturctName, patch);
    node->fields = (_ListNode *)_ORNodeConvert(exp.fields, patch);
    node->length = _ORStructExpressoinBaseLength +node->sturctName->length + node->fields->length;
    return node;
}
ORStructExpressoin *_ORStructExpressoinDeConvert(_ORStructExpressoin *node, _PatchNode *patch){
    ORStructExpressoin *exp = [ORStructExpressoin new];
    exp.sturctName = (NSString *)_ORNodeDeConvert((_ORNode *)node->sturctName, patch);
    exp.fields = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->fields, patch);
    return exp;
}
void _ORStructExpressoinSerailization(_ORStructExpressoin *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORStructExpressoinBaseLength);
    *cursor += _ORStructExpressoinBaseLength;
    _ORNodeSerailization((_ORNode *)node->sturctName, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->fields, buffer, cursor);
}
_ORStructExpressoin *_ORStructExpressoinDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORStructExpressoin *node = malloc(sizeof(_ORStructExpressoin));
    memcpy(node, buffer + *cursor, _ORStructExpressoinBaseLength);
    *cursor += _ORStructExpressoinBaseLength;
    node->sturctName =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->fields =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    uint32_t valueType;
    _StringNode *enumName;
    _ListNode *fields;
}_OREnumExpressoin;
static uint32_t _OREnumExpressoinBaseLength = 9;
_OREnumExpressoin *_OREnumExpressoinConvert(OREnumExpressoin *exp, _PatchNode *patch){
    _OREnumExpressoin *node = malloc(sizeof(_OREnumExpressoin));
    memset(node, 0, sizeof(_OREnumExpressoin));
    node->nodeType = _OREnumExpressoinNode;
    node->valueType = exp.valueType;
    node->enumName = (_StringNode *)_ORNodeConvert(exp.enumName, patch);
    node->fields = (_ListNode *)_ORNodeConvert(exp.fields, patch);
    node->length = _OREnumExpressoinBaseLength +node->enumName->length + node->fields->length;
    return node;
}
OREnumExpressoin *_OREnumExpressoinDeConvert(_OREnumExpressoin *node, _PatchNode *patch){
    OREnumExpressoin *exp = [OREnumExpressoin new];
    exp.valueType = node->valueType;
    exp.enumName = (NSString *)_ORNodeDeConvert((_ORNode *)node->enumName, patch);
    exp.fields = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->fields, patch);
    return exp;
}
void _OREnumExpressoinSerailization(_OREnumExpressoin *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _OREnumExpressoinBaseLength);
    *cursor += _OREnumExpressoinBaseLength;
    _ORNodeSerailization((_ORNode *)node->enumName, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->fields, buffer, cursor);
}
_OREnumExpressoin *_OREnumExpressoinDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _OREnumExpressoin *node = malloc(sizeof(_OREnumExpressoin));
    memcpy(node, buffer + *cursor, _OREnumExpressoinBaseLength);
    *cursor += _OREnumExpressoinBaseLength;
    node->enumName =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->fields =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
typedef struct {
    _ORNodeFields
    _ORNode *expression;
    _StringNode *typeNewName;
}_ORTypedefExpressoin;
static uint32_t _ORTypedefExpressoinBaseLength = 5;
_ORTypedefExpressoin *_ORTypedefExpressoinConvert(ORTypedefExpressoin *exp, _PatchNode *patch){
    _ORTypedefExpressoin *node = malloc(sizeof(_ORTypedefExpressoin));
    memset(node, 0, sizeof(_ORTypedefExpressoin));
    node->nodeType = _ORTypedefExpressoinNode;
    node->expression = _ORNodeConvert(exp.expression, patch);
    node->typeNewName = (_StringNode *)_ORNodeConvert(exp.typeNewName, patch);
    node->length = _ORTypedefExpressoinBaseLength +node->expression->length + node->typeNewName->length;
    return node;
}
ORTypedefExpressoin *_ORTypedefExpressoinDeConvert(_ORTypedefExpressoin *node, _PatchNode *patch){
    ORTypedefExpressoin *exp = [ORTypedefExpressoin new];
    exp.expression = _ORNodeDeConvert((_ORNode *)node->expression, patch);
    exp.typeNewName = (NSString *)_ORNodeDeConvert((_ORNode *)node->typeNewName, patch);
    return exp;
}
void _ORTypedefExpressoinSerailization(_ORTypedefExpressoin *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORTypedefExpressoinBaseLength);
    *cursor += _ORTypedefExpressoinBaseLength;
    _ORNodeSerailization((_ORNode *)node->expression, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->typeNewName, buffer, cursor);
}
_ORTypedefExpressoin *_ORTypedefExpressoinDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORTypedefExpressoin *node = malloc(sizeof(_ORTypedefExpressoin));
    memcpy(node, buffer + *cursor, _ORTypedefExpressoinBaseLength);
    *cursor += _ORTypedefExpressoinBaseLength;
    node->expression =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->typeNewName =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
#pragma pack()
#pragma pack(show)
_ORNode *_ORNodeConvert(id exp, _PatchNode *patch){
    if ([exp isKindOfClass:[NSString class]]) {
        return (_ORNode *)saveNewString((NSString *)exp, patch);
    }else if ([exp isKindOfClass:[NSArray class]]) {
        return (_ORNode *)_ListNodeConvert((NSArray *)exp, patch);
    }else if ([exp isKindOfClass:[ORFuncVariable class]]){
        return (_ORNode *)_ORFuncVariableConvert((ORFuncVariable *)exp, patch);
    }else if ([exp isKindOfClass:[ORTypeSpecial class]]){
        return (_ORNode *)_ORTypeSpecialConvert((ORTypeSpecial *)exp, patch);
    }else if ([exp isKindOfClass:[ORVariable class]]){
        return (_ORNode *)_ORVariableConvert((ORVariable *)exp, patch);
    }else if ([exp isKindOfClass:[ORTypeVarPair class]]){
        return (_ORNode *)_ORTypeVarPairConvert((ORTypeVarPair *)exp, patch);
    }else if ([exp isKindOfClass:[ORFuncDeclare class]]){
        return (_ORNode *)_ORFuncDeclareConvert((ORFuncDeclare *)exp, patch);
    }else if ([exp isKindOfClass:[ORScopeImp class]]){
        return (_ORNode *)_ORScopeImpConvert((ORScopeImp *)exp, patch);
    }else if ([exp isKindOfClass:[ORValueExpression class]]){
        return (_ORNode *)_ORValueExpressionConvert((ORValueExpression *)exp, patch);
    }else if ([exp isKindOfClass:[ORMethodCall class]]){
        return (_ORNode *)_ORMethodCallConvert((ORMethodCall *)exp, patch);
    }else if ([exp isKindOfClass:[ORCFuncCall class]]){
        return (_ORNode *)_ORCFuncCallConvert((ORCFuncCall *)exp, patch);
    }else if ([exp isKindOfClass:[ORFunctionImp class]]){
        return (_ORNode *)_ORFunctionImpConvert((ORFunctionImp *)exp, patch);
    }else if ([exp isKindOfClass:[ORSubscriptExpression class]]){
        return (_ORNode *)_ORSubscriptExpressionConvert((ORSubscriptExpression *)exp, patch);
    }else if ([exp isKindOfClass:[ORAssignExpression class]]){
        return (_ORNode *)_ORAssignExpressionConvert((ORAssignExpression *)exp, patch);
    }else if ([exp isKindOfClass:[ORDeclareExpression class]]){
        return (_ORNode *)_ORDeclareExpressionConvert((ORDeclareExpression *)exp, patch);
    }else if ([exp isKindOfClass:[ORUnaryExpression class]]){
        return (_ORNode *)_ORUnaryExpressionConvert((ORUnaryExpression *)exp, patch);
    }else if ([exp isKindOfClass:[ORBinaryExpression class]]){
        return (_ORNode *)_ORBinaryExpressionConvert((ORBinaryExpression *)exp, patch);
    }else if ([exp isKindOfClass:[ORTernaryExpression class]]){
        return (_ORNode *)_ORTernaryExpressionConvert((ORTernaryExpression *)exp, patch);
    }else if ([exp isKindOfClass:[ORIfStatement class]]){
        return (_ORNode *)_ORIfStatementConvert((ORIfStatement *)exp, patch);
    }else if ([exp isKindOfClass:[ORWhileStatement class]]){
        return (_ORNode *)_ORWhileStatementConvert((ORWhileStatement *)exp, patch);
    }else if ([exp isKindOfClass:[ORDoWhileStatement class]]){
        return (_ORNode *)_ORDoWhileStatementConvert((ORDoWhileStatement *)exp, patch);
    }else if ([exp isKindOfClass:[ORCaseStatement class]]){
        return (_ORNode *)_ORCaseStatementConvert((ORCaseStatement *)exp, patch);
    }else if ([exp isKindOfClass:[ORSwitchStatement class]]){
        return (_ORNode *)_ORSwitchStatementConvert((ORSwitchStatement *)exp, patch);
    }else if ([exp isKindOfClass:[ORForStatement class]]){
        return (_ORNode *)_ORForStatementConvert((ORForStatement *)exp, patch);
    }else if ([exp isKindOfClass:[ORForInStatement class]]){
        return (_ORNode *)_ORForInStatementConvert((ORForInStatement *)exp, patch);
    }else if ([exp isKindOfClass:[ORReturnStatement class]]){
        return (_ORNode *)_ORReturnStatementConvert((ORReturnStatement *)exp, patch);
    }else if ([exp isKindOfClass:[ORBreakStatement class]]){
        return (_ORNode *)_ORBreakStatementConvert((ORBreakStatement *)exp, patch);
    }else if ([exp isKindOfClass:[ORContinueStatement class]]){
        return (_ORNode *)_ORContinueStatementConvert((ORContinueStatement *)exp, patch);
    }else if ([exp isKindOfClass:[ORPropertyDeclare class]]){
        return (_ORNode *)_ORPropertyDeclareConvert((ORPropertyDeclare *)exp, patch);
    }else if ([exp isKindOfClass:[ORMethodDeclare class]]){
        return (_ORNode *)_ORMethodDeclareConvert((ORMethodDeclare *)exp, patch);
    }else if ([exp isKindOfClass:[ORMethodImplementation class]]){
        return (_ORNode *)_ORMethodImplementationConvert((ORMethodImplementation *)exp, patch);
    }else if ([exp isKindOfClass:[ORClass class]]){
        return (_ORNode *)_ORClassConvert((ORClass *)exp, patch);
    }else if ([exp isKindOfClass:[ORProtocol class]]){
        return (_ORNode *)_ORProtocolConvert((ORProtocol *)exp, patch);
    }else if ([exp isKindOfClass:[ORStructExpressoin class]]){
        return (_ORNode *)_ORStructExpressoinConvert((ORStructExpressoin *)exp, patch);
    }else if ([exp isKindOfClass:[OREnumExpressoin class]]){
        return (_ORNode *)_OREnumExpressoinConvert((OREnumExpressoin *)exp, patch);
    }else if ([exp isKindOfClass:[ORTypedefExpressoin class]]){
        return (_ORNode *)_ORTypedefExpressoinConvert((ORTypedefExpressoin *)exp, patch);
    }
    _ORNode *node = malloc(sizeof(_ORNode));
    memset(node, 0, sizeof(_ORNode));
    node->length = 5;
    return node;
}
id _ORNodeDeConvert(_ORNode *node, _PatchNode *patch){
    if (node->nodeType == ORNodeType) return nil;
    if (node->nodeType == ListNodeType) {
        return _ListNodeDeConvert((_ListNode *)node, patch);
    }else if (node->nodeType == StringNodeType) {
        return getString((_StringNode *) node, patch);
    }else if (node->nodeType == _ORTypeSpecialNode){
        return (ORNode *)_ORTypeSpecialDeConvert((_ORTypeSpecial *)node, patch);
    }else if (node->nodeType == _ORVariableNode){
        return (ORNode *)_ORVariableDeConvert((_ORVariable *)node, patch);
    }else if (node->nodeType == _ORTypeVarPairNode){
        return (ORNode *)_ORTypeVarPairDeConvert((_ORTypeVarPair *)node, patch);
    }else if (node->nodeType == _ORFuncVariableNode){
        return (ORNode *)_ORFuncVariableDeConvert((_ORFuncVariable *)node, patch);
    }else if (node->nodeType == _ORFuncDeclareNode){
        return (ORNode *)_ORFuncDeclareDeConvert((_ORFuncDeclare *)node, patch);
    }else if (node->nodeType == _ORScopeImpNode){
        return (ORNode *)_ORScopeImpDeConvert((_ORScopeImp *)node, patch);
    }else if (node->nodeType == _ORValueExpressionNode){
        return (ORNode *)_ORValueExpressionDeConvert((_ORValueExpression *)node, patch);
    }else if (node->nodeType == _ORMethodCallNode){
        return (ORNode *)_ORMethodCallDeConvert((_ORMethodCall *)node, patch);
    }else if (node->nodeType == _ORCFuncCallNode){
        return (ORNode *)_ORCFuncCallDeConvert((_ORCFuncCall *)node, patch);
    }else if (node->nodeType == _ORFunctionImpNode){
        return (ORNode *)_ORFunctionImpDeConvert((_ORFunctionImp *)node, patch);
    }else if (node->nodeType == _ORSubscriptExpressionNode){
        return (ORNode *)_ORSubscriptExpressionDeConvert((_ORSubscriptExpression *)node, patch);
    }else if (node->nodeType == _ORAssignExpressionNode){
        return (ORNode *)_ORAssignExpressionDeConvert((_ORAssignExpression *)node, patch);
    }else if (node->nodeType == _ORDeclareExpressionNode){
        return (ORNode *)_ORDeclareExpressionDeConvert((_ORDeclareExpression *)node, patch);
    }else if (node->nodeType == _ORUnaryExpressionNode){
        return (ORNode *)_ORUnaryExpressionDeConvert((_ORUnaryExpression *)node, patch);
    }else if (node->nodeType == _ORBinaryExpressionNode){
        return (ORNode *)_ORBinaryExpressionDeConvert((_ORBinaryExpression *)node, patch);
    }else if (node->nodeType == _ORTernaryExpressionNode){
        return (ORNode *)_ORTernaryExpressionDeConvert((_ORTernaryExpression *)node, patch);
    }else if (node->nodeType == _ORIfStatementNode){
        return (ORNode *)_ORIfStatementDeConvert((_ORIfStatement *)node, patch);
    }else if (node->nodeType == _ORWhileStatementNode){
        return (ORNode *)_ORWhileStatementDeConvert((_ORWhileStatement *)node, patch);
    }else if (node->nodeType == _ORDoWhileStatementNode){
        return (ORNode *)_ORDoWhileStatementDeConvert((_ORDoWhileStatement *)node, patch);
    }else if (node->nodeType == _ORCaseStatementNode){
        return (ORNode *)_ORCaseStatementDeConvert((_ORCaseStatement *)node, patch);
    }else if (node->nodeType == _ORSwitchStatementNode){
        return (ORNode *)_ORSwitchStatementDeConvert((_ORSwitchStatement *)node, patch);
    }else if (node->nodeType == _ORForStatementNode){
        return (ORNode *)_ORForStatementDeConvert((_ORForStatement *)node, patch);
    }else if (node->nodeType == _ORForInStatementNode){
        return (ORNode *)_ORForInStatementDeConvert((_ORForInStatement *)node, patch);
    }else if (node->nodeType == _ORReturnStatementNode){
        return (ORNode *)_ORReturnStatementDeConvert((_ORReturnStatement *)node, patch);
    }else if (node->nodeType == _ORBreakStatementNode){
        return (ORNode *)_ORBreakStatementDeConvert((_ORBreakStatement *)node, patch);
    }else if (node->nodeType == _ORContinueStatementNode){
        return (ORNode *)_ORContinueStatementDeConvert((_ORContinueStatement *)node, patch);
    }else if (node->nodeType == _ORPropertyDeclareNode){
        return (ORNode *)_ORPropertyDeclareDeConvert((_ORPropertyDeclare *)node, patch);
    }else if (node->nodeType == _ORMethodDeclareNode){
        return (ORNode *)_ORMethodDeclareDeConvert((_ORMethodDeclare *)node, patch);
    }else if (node->nodeType == _ORMethodImplementationNode){
        return (ORNode *)_ORMethodImplementationDeConvert((_ORMethodImplementation *)node, patch);
    }else if (node->nodeType == _ORClassNode){
        return (ORNode *)_ORClassDeConvert((_ORClass *)node, patch);
    }else if (node->nodeType == _ORProtocolNode){
        return (ORNode *)_ORProtocolDeConvert((_ORProtocol *)node, patch);
    }else if (node->nodeType == _ORStructExpressoinNode){
        return (ORNode *)_ORStructExpressoinDeConvert((_ORStructExpressoin *)node, patch);
    }else if (node->nodeType == _OREnumExpressoinNode){
        return (ORNode *)_OREnumExpressoinDeConvert((_OREnumExpressoin *)node, patch);
    }else if (node->nodeType == _ORTypedefExpressoinNode){
        return (ORNode *)_ORTypedefExpressoinDeConvert((_ORTypedefExpressoin *)node, patch);
    }
    return [ORNode new];
}
void _ORNodeSerailization(_ORNode *node, void *buffer, uint32_t *cursor){
    if (node->nodeType == ORNodeType) {
        memcpy(buffer + *cursor, node, 5);
        *cursor += 5;
    }else if (node->nodeType == ListNodeType) {
        _ListNodeSerailization((_ListNode *)node, buffer, cursor);
    }else if (node->nodeType == StringNodeType) {
        _StringNodeSerailization((_StringNode *) node, buffer, cursor);
    }else if (node->nodeType == StringsNodeType) {
        _StringsNodeSerailization((_StringsNode *) node, buffer, cursor);
    }else if (node->nodeType == _ORTypeSpecialNode){
        _ORTypeSpecialSerailization((_ORTypeSpecial *)node, buffer, cursor);
    }else if (node->nodeType == _ORVariableNode){
        _ORVariableSerailization((_ORVariable *)node, buffer, cursor);
    }else if (node->nodeType == _ORTypeVarPairNode){
        _ORTypeVarPairSerailization((_ORTypeVarPair *)node, buffer, cursor);
    }else if (node->nodeType == _ORFuncVariableNode){
        _ORFuncVariableSerailization((_ORFuncVariable *)node, buffer, cursor);
    }else if (node->nodeType == _ORFuncDeclareNode){
        _ORFuncDeclareSerailization((_ORFuncDeclare *)node, buffer, cursor);
    }else if (node->nodeType == _ORScopeImpNode){
        _ORScopeImpSerailization((_ORScopeImp *)node, buffer, cursor);
    }else if (node->nodeType == _ORValueExpressionNode){
        _ORValueExpressionSerailization((_ORValueExpression *)node, buffer, cursor);
    }else if (node->nodeType == _ORMethodCallNode){
        _ORMethodCallSerailization((_ORMethodCall *)node, buffer, cursor);
    }else if (node->nodeType == _ORCFuncCallNode){
        _ORCFuncCallSerailization((_ORCFuncCall *)node, buffer, cursor);
    }else if (node->nodeType == _ORFunctionImpNode){
        _ORFunctionImpSerailization((_ORFunctionImp *)node, buffer, cursor);
    }else if (node->nodeType == _ORSubscriptExpressionNode){
        _ORSubscriptExpressionSerailization((_ORSubscriptExpression *)node, buffer, cursor);
    }else if (node->nodeType == _ORAssignExpressionNode){
        _ORAssignExpressionSerailization((_ORAssignExpression *)node, buffer, cursor);
    }else if (node->nodeType == _ORDeclareExpressionNode){
        _ORDeclareExpressionSerailization((_ORDeclareExpression *)node, buffer, cursor);
    }else if (node->nodeType == _ORUnaryExpressionNode){
        _ORUnaryExpressionSerailization((_ORUnaryExpression *)node, buffer, cursor);
    }else if (node->nodeType == _ORBinaryExpressionNode){
        _ORBinaryExpressionSerailization((_ORBinaryExpression *)node, buffer, cursor);
    }else if (node->nodeType == _ORTernaryExpressionNode){
        _ORTernaryExpressionSerailization((_ORTernaryExpression *)node, buffer, cursor);
    }else if (node->nodeType == _ORIfStatementNode){
        _ORIfStatementSerailization((_ORIfStatement *)node, buffer, cursor);
    }else if (node->nodeType == _ORWhileStatementNode){
        _ORWhileStatementSerailization((_ORWhileStatement *)node, buffer, cursor);
    }else if (node->nodeType == _ORDoWhileStatementNode){
        _ORDoWhileStatementSerailization((_ORDoWhileStatement *)node, buffer, cursor);
    }else if (node->nodeType == _ORCaseStatementNode){
        _ORCaseStatementSerailization((_ORCaseStatement *)node, buffer, cursor);
    }else if (node->nodeType == _ORSwitchStatementNode){
        _ORSwitchStatementSerailization((_ORSwitchStatement *)node, buffer, cursor);
    }else if (node->nodeType == _ORForStatementNode){
        _ORForStatementSerailization((_ORForStatement *)node, buffer, cursor);
    }else if (node->nodeType == _ORForInStatementNode){
        _ORForInStatementSerailization((_ORForInStatement *)node, buffer, cursor);
    }else if (node->nodeType == _ORReturnStatementNode){
        _ORReturnStatementSerailization((_ORReturnStatement *)node, buffer, cursor);
    }else if (node->nodeType == _ORBreakStatementNode){
        _ORBreakStatementSerailization((_ORBreakStatement *)node, buffer, cursor);
    }else if (node->nodeType == _ORContinueStatementNode){
        _ORContinueStatementSerailization((_ORContinueStatement *)node, buffer, cursor);
    }else if (node->nodeType == _ORPropertyDeclareNode){
        _ORPropertyDeclareSerailization((_ORPropertyDeclare *)node, buffer, cursor);
    }else if (node->nodeType == _ORMethodDeclareNode){
        _ORMethodDeclareSerailization((_ORMethodDeclare *)node, buffer, cursor);
    }else if (node->nodeType == _ORMethodImplementationNode){
        _ORMethodImplementationSerailization((_ORMethodImplementation *)node, buffer, cursor);
    }else if (node->nodeType == _ORClassNode){
        _ORClassSerailization((_ORClass *)node, buffer, cursor);
    }else if (node->nodeType == _ORProtocolNode){
        _ORProtocolSerailization((_ORProtocol *)node, buffer, cursor);
    }else if (node->nodeType == _ORStructExpressoinNode){
        _ORStructExpressoinSerailization((_ORStructExpressoin *)node, buffer, cursor);
    }else if (node->nodeType == _OREnumExpressoinNode){
        _OREnumExpressoinSerailization((_OREnumExpressoin *)node, buffer, cursor);
    }else if (node->nodeType == _ORTypedefExpressoinNode){
        _ORTypedefExpressoinSerailization((_ORTypedefExpressoin *)node, buffer, cursor);
    }
}
_ORNode *_ORNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _NodeType nodeType = ORNodeType;
    if (*cursor < bufferLength) {
        nodeType = *(_NodeType *)(buffer + *cursor);
    }
    if (nodeType == ListNodeType) {
        return (_ORNode *)_ListNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == StringNodeType) {
        return (_ORNode *)_StringNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORTypeSpecialNode){
        return (_ORNode *)_ORTypeSpecialDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORVariableNode){
        return (_ORNode *)_ORVariableDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORTypeVarPairNode){
        return (_ORNode *)_ORTypeVarPairDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORFuncVariableNode){
        return (_ORNode *)_ORFuncVariableDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORFuncDeclareNode){
        return (_ORNode *)_ORFuncDeclareDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORScopeImpNode){
        return (_ORNode *)_ORScopeImpDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORValueExpressionNode){
        return (_ORNode *)_ORValueExpressionDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORMethodCallNode){
        return (_ORNode *)_ORMethodCallDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORCFuncCallNode){
        return (_ORNode *)_ORCFuncCallDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORFunctionImpNode){
        return (_ORNode *)_ORFunctionImpDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORSubscriptExpressionNode){
        return (_ORNode *)_ORSubscriptExpressionDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORAssignExpressionNode){
        return (_ORNode *)_ORAssignExpressionDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORDeclareExpressionNode){
        return (_ORNode *)_ORDeclareExpressionDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORUnaryExpressionNode){
        return (_ORNode *)_ORUnaryExpressionDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORBinaryExpressionNode){
        return (_ORNode *)_ORBinaryExpressionDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORTernaryExpressionNode){
        return (_ORNode *)_ORTernaryExpressionDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORIfStatementNode){
        return (_ORNode *)_ORIfStatementDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORWhileStatementNode){
        return (_ORNode *)_ORWhileStatementDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORDoWhileStatementNode){
        return (_ORNode *)_ORDoWhileStatementDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORCaseStatementNode){
        return (_ORNode *)_ORCaseStatementDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORSwitchStatementNode){
        return (_ORNode *)_ORSwitchStatementDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORForStatementNode){
        return (_ORNode *)_ORForStatementDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORForInStatementNode){
        return (_ORNode *)_ORForInStatementDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORReturnStatementNode){
        return (_ORNode *)_ORReturnStatementDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORBreakStatementNode){
        return (_ORNode *)_ORBreakStatementDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORContinueStatementNode){
        return (_ORNode *)_ORContinueStatementDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORPropertyDeclareNode){
        return (_ORNode *)_ORPropertyDeclareDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORMethodDeclareNode){
        return (_ORNode *)_ORMethodDeclareDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORMethodImplementationNode){
        return (_ORNode *)_ORMethodImplementationDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORClassNode){
        return (_ORNode *)_ORClassDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORProtocolNode){
        return (_ORNode *)_ORProtocolDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORStructExpressoinNode){
        return (_ORNode *)_ORStructExpressoinDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _OREnumExpressoinNode){
        return (_ORNode *)_OREnumExpressoinDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORTypedefExpressoinNode){
        return (_ORNode *)_ORTypedefExpressoinDeserialization(buffer, cursor, bufferLength);
    }

    _ORNode *node = malloc(sizeof(_ORNode));
    memset(node, 0, sizeof(_ORNode));
    *cursor += 5;
    return node;
}
