//  BinaryPatchHelper.m
//  Generate By BinaryPatchGenerator
//  Created by Jiang on 1614919207
//  Copyright © 2020 SilverFruity. All rights reserved.
#import "BinaryPatchHelper.h"
#import "ORPatchFile.h"
typedef enum: uint8_t{
    ORNodeType = 0,
    PatchNodeType = 1,
    StringNodeType = 2,
    StringsNodeType = 3,
    ListNodeType = 4,
    _ORTypeNodeNode = 5,
    _ORVariableNodeNode = 6,
    _ORDeclaratorNodeNode = 7,
    _ORFunctionDeclaratorNode = 8,
    _ORCArrayVariableNode = 9,
    _ORBlockNodeNode = 10,
    _ORValueExpressionNode = 11,
    _ORIntegerValueNode = 12,
    _ORUIntegerValueNode = 13,
    _ORDoubleValueNode = 14,
    _ORBoolValueNode = 15,
    _ORMethodCallNode = 16,
    _ORFunctionCallNode = 17,
    _ORFunctionImpNode = 18,
    _ORSubscriptExpressionNode = 19,
    _ORAssignExpressionNode = 20,
    _ORInitDeclaratorNodeNode = 21,
    _ORUnaryExpressionNode = 22,
    _ORBinaryExpressionNode = 23,
    _ORTernaryExpressionNode = 24,
    _ORIfStatementNode = 25,
    _ORWhileStatementNode = 26,
    _ORDoWhileStatementNode = 27,
    _ORCaseStatementNode = 28,
    _ORSwitchStatementNode = 29,
    _ORForStatementNode = 30,
    _ORForInStatementNode = 31,
    _ORControlStatementNode = 32,
    _ORPropertyDeclareNode = 33,
    _ORMethodDeclareNode = 34,
    _ORMethodImplementationNode = 35,
    _ORClassNode = 36,
    _ORProtocolNode = 37,
    _ORStructStatNodeNode = 38,
    _ORUnionStatNodeNode = 39,
    _OREnumStatNodeNode = 40,
    _ORTypedefStatNodeNode = 41,

}_NodeType;
#pragma pack(1)
#pragma pack(show)

_ORNode *_ORNodeConvert(id exp, _PatchNode *patch, uint32_t *length);
id _ORNodeDeConvert(_ORNode *node, _PatchNode *patch);

_ListNode *_ListNodeConvert(NSArray *array, _PatchNode *patch, uint32_t *length){
    _ListNode *node = malloc(sizeof(_ListNode));
    memset(node, 0, sizeof(_ListNode));
    node->nodes = malloc(sizeof(void *) * array.count);
    node->nodeType = ListNodeType;
    *length += _ListNodeBaseLength;
    for (id object in array) {
        _ORNode *element = _ORNodeConvert(object, patch, length);;
        node->nodes[node->count] = element;
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
_StringNode *saveNewString(NSString *string, _PatchNode *patch, uint32_t *length){
    _StringNode * strNode = malloc(sizeof(_StringNode));
    memset(strNode, 0, sizeof(_StringNode));
    const char *str = string.UTF8String;
    size_t len = strlen(str);
    strNode->strLen = (unsigned int)len;
    strNode->nodeType = StringNodeType;
    *length += _StringNodeBaseLength;
    if (_stringMap[string]) {
        uint32_t offset = [_stringMap[string] unsignedIntValue];
        strNode->offset = offset;
        return strNode;
    }
    
    NSUInteger needLength = len + patch->strings->cursor;
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
    *length += len;
    return strNode;
}

NSString *getString(_StringNode *node, _PatchNode *patch){
    char *cursor = patch->strings->buffer + node->offset;
    char *buffer = alloca(node->strLen + 1);
    memcpy(buffer, cursor, node->strLen);
    buffer[node->strLen] = '\0';
    return [NSString stringWithUTF8String:buffer];
}

_PatchNode *_PatchNodeConvert(ORPatchFile *patch, uint32_t *length){
    _stringMap = [NSMutableDictionary dictionary];
    _PatchNode *node = malloc(sizeof(_PatchNode));
    memset(node, 0, sizeof(_PatchNode));
    *length += _PatchNodeBaseLength;

    node->strings = malloc(sizeof(_StringsNode));
    memset(node->strings, 0, sizeof(_StringsNode));
    node->strings->nodeType = StringsNodeType;
    *length += _StringsNodeBaseLength;
    
    node->nodeType = PatchNodeType;
    node->enable = patch.enable;
    node->appVersion = (_StringNode *)_ORNodeConvert(patch.appVersion, node, length);
    node->osVersion = (_StringNode *)_ORNodeConvert(patch.osVersion, node, length);
    node->nodes = (_ListNode *)_ORNodeConvert(patch.nodes, node, length);
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
ORPatchFile *_PatchNodeGenerateCheckFile(void *buffer, uint32_t bufferLength){
    uint32_t cursor = 0;
    _PatchNode *node = malloc(sizeof(_PatchNode));
    memcpy(node, buffer + cursor, _PatchNodeBaseLength);
    cursor += _PatchNodeBaseLength;
    node->strings = (_StringsNode *)_StringsNodeDeserialization(buffer, &cursor, bufferLength);
    node->appVersion = (_StringNode *)_ORNodeDeserialization(buffer, &cursor, bufferLength);
    node->osVersion = (_StringNode *)_ORNodeDeserialization(buffer, &cursor, bufferLength);
    node->nodes = NULL;
    ORPatchFile *file = [ORPatchFile new];
    file.appVersion = getString(node->appVersion, node);
    file.osVersion = getString(node->osVersion, node);
    file.enable = node->enable;
    _PatchNodeDestroy(node);
    return file;
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
void _ORNodeDestroy(_ORNode *node);
void _StringNodeDestroy(_StringNode *node){
    free(node);
}
void _ListNodeDestroy(_ListNode *node){
    for (int i = 0; i < node->count; i++) {
         _ORNodeDestroy(node->nodes[i]);
    }
    free(node);
}
void _StringsNodeDestroy(_StringsNode *node){
    free(node->buffer);
    free(node);
}
void _PatchNodeDestroy(_PatchNode *node){
    _ORNodeDestroy((_ORNode *)node->strings);
    _ORNodeDestroy((_ORNode *)node->appVersion);
    _ORNodeDestroy((_ORNode *)node->osVersion);
    _ORNodeDestroy((_ORNode *)node->nodes);
    free(node);
}
typedef struct {
    _ORNodeFields
    uint32_t type;
    _StringNode * name;
    uint32_t modifier;
}_ORTypeNode;
static uint32_t _ORTypeNodeBaseLength = 9;
_ORTypeNode *_ORTypeNodeConvert(ORTypeNode *exp, _PatchNode *patch, uint32_t *length){
    _ORTypeNode *node = malloc(sizeof(_ORTypeNode));
    memset(node, 0, sizeof(_ORTypeNode));
    node->nodeType = _ORTypeNodeNode;
    node->type = exp.type;
    node->name = (_StringNode *)_ORNodeConvert(exp.name, patch, length);
    node->modifier = exp.modifier;
    *length += _ORTypeNodeBaseLength;
    return node;
}
ORTypeNode *_ORTypeNodeDeConvert(_ORTypeNode *node, _PatchNode *patch){
    ORTypeNode *exp = [ORTypeNode new];
    exp.type = node->type;
    exp.name = (NSString *)_ORNodeDeConvert((_ORNode *)node->name, patch);
    exp.modifier = node->modifier;
    return exp;
}
void _ORTypeNodeSerailization(_ORTypeNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORTypeNodeBaseLength);
    *cursor += _ORTypeNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->name, buffer, cursor);
}
_ORTypeNode *_ORTypeNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORTypeNode *node = malloc(sizeof(_ORTypeNode));
    memcpy(node, buffer + *cursor, _ORTypeNodeBaseLength);
    *cursor += _ORTypeNodeBaseLength;
    node->name =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORTypeNodeDestroy(_ORTypeNode *node){
    _ORNodeDestroy((_ORNode *)node->name);
    free(node);
}
typedef struct {
    _ORNodeFields
    BOOL isBlock;
    uint8_t ptCount;
    _StringNode * varname;
}_ORVariableNode;
static uint32_t _ORVariableNodeBaseLength = 3;
_ORVariableNode *_ORVariableNodeConvert(ORVariableNode *exp, _PatchNode *patch, uint32_t *length){
    _ORVariableNode *node = malloc(sizeof(_ORVariableNode));
    memset(node, 0, sizeof(_ORVariableNode));
    node->nodeType = _ORVariableNodeNode;
    node->isBlock = exp.isBlock;
    node->ptCount = exp.ptCount;
    node->varname = (_StringNode *)_ORNodeConvert(exp.varname, patch, length);
    *length += _ORVariableNodeBaseLength;
    return node;
}
ORVariableNode *_ORVariableNodeDeConvert(_ORVariableNode *node, _PatchNode *patch){
    ORVariableNode *exp = [ORVariableNode new];
    exp.isBlock = node->isBlock;
    exp.ptCount = node->ptCount;
    exp.varname = (NSString *)_ORNodeDeConvert((_ORNode *)node->varname, patch);
    return exp;
}
void _ORVariableNodeSerailization(_ORVariableNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORVariableNodeBaseLength);
    *cursor += _ORVariableNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->varname, buffer, cursor);
}
_ORVariableNode *_ORVariableNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORVariableNode *node = malloc(sizeof(_ORVariableNode));
    memcpy(node, buffer + *cursor, _ORVariableNodeBaseLength);
    *cursor += _ORVariableNodeBaseLength;
    node->varname =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORVariableNodeDestroy(_ORVariableNode *node){
    _ORNodeDestroy((_ORNode *)node->varname);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ORNode * type;
    _ORNode * var;
}_ORDeclaratorNode;
static uint32_t _ORDeclaratorNodeBaseLength = 1;
_ORDeclaratorNode *_ORDeclaratorNodeConvert(ORDeclaratorNode *exp, _PatchNode *patch, uint32_t *length){
    _ORDeclaratorNode *node = malloc(sizeof(_ORDeclaratorNode));
    memset(node, 0, sizeof(_ORDeclaratorNode));
    node->nodeType = _ORDeclaratorNodeNode;
    node->type = (_ORNode *)_ORNodeConvert(exp.type, patch, length);
    node->var = (_ORNode *)_ORNodeConvert(exp.var, patch, length);
    *length += _ORDeclaratorNodeBaseLength;
    return node;
}
ORDeclaratorNode *_ORDeclaratorNodeDeConvert(_ORDeclaratorNode *node, _PatchNode *patch){
    ORDeclaratorNode *exp = [ORDeclaratorNode new];
    exp.type = (id)_ORNodeDeConvert((_ORNode *)node->type, patch);
    exp.var = (id)_ORNodeDeConvert((_ORNode *)node->var, patch);
    return exp;
}
void _ORDeclaratorNodeSerailization(_ORDeclaratorNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORDeclaratorNodeBaseLength);
    *cursor += _ORDeclaratorNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->type, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->var, buffer, cursor);
}
_ORDeclaratorNode *_ORDeclaratorNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORDeclaratorNode *node = malloc(sizeof(_ORDeclaratorNode));
    memcpy(node, buffer + *cursor, _ORDeclaratorNodeBaseLength);
    *cursor += _ORDeclaratorNodeBaseLength;
    node->type =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->var =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORDeclaratorNodeDestroy(_ORDeclaratorNode *node){
    _ORNodeDestroy((_ORNode *)node->type);
    _ORNodeDestroy((_ORNode *)node->var);
    free(node);
}
typedef struct {
    _ORNodeFields
    BOOL isBlock;
    uint8_t ptCount;
    BOOL isMultiArgs;
    _StringNode * varname;
    _ORNode * returnNode;
    _ListNode * declarators;
}_ORFunctionDeclarator;
static uint32_t _ORFunctionDeclaratorBaseLength = 4;
_ORFunctionDeclarator *_ORFunctionDeclaratorConvert(ORFunctionDeclarator *exp, _PatchNode *patch, uint32_t *length){
    _ORFunctionDeclarator *node = malloc(sizeof(_ORFunctionDeclarator));
    memset(node, 0, sizeof(_ORFunctionDeclarator));
    node->nodeType = _ORFunctionDeclaratorNode;
    node->isBlock = exp.isBlock;
    node->ptCount = exp.ptCount;
    node->varname = (_StringNode *)_ORNodeConvert(exp.varname, patch, length);
    node->isMultiArgs = exp.isMultiArgs;
    node->returnNode = (_ORNode *)_ORNodeConvert(exp.returnNode, patch, length);
    node->declarators = (_ListNode *)_ORNodeConvert(exp.declarators, patch, length);
    *length += _ORFunctionDeclaratorBaseLength;
    return node;
}
ORFunctionDeclarator *_ORFunctionDeclaratorDeConvert(_ORFunctionDeclarator *node, _PatchNode *patch){
    ORFunctionDeclarator *exp = [ORFunctionDeclarator new];
    exp.isBlock = node->isBlock;
    exp.ptCount = node->ptCount;
    exp.varname = (NSString *)_ORNodeDeConvert((_ORNode *)node->varname, patch);
    exp.isMultiArgs = node->isMultiArgs;
    exp.returnNode = (id)_ORNodeDeConvert((_ORNode *)node->returnNode, patch);
    exp.declarators = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->declarators, patch);
    return exp;
}
void _ORFunctionDeclaratorSerailization(_ORFunctionDeclarator *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORFunctionDeclaratorBaseLength);
    *cursor += _ORFunctionDeclaratorBaseLength;
    _ORNodeSerailization((_ORNode *)node->varname, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->returnNode, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->declarators, buffer, cursor);
}
_ORFunctionDeclarator *_ORFunctionDeclaratorDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORFunctionDeclarator *node = malloc(sizeof(_ORFunctionDeclarator));
    memcpy(node, buffer + *cursor, _ORFunctionDeclaratorBaseLength);
    *cursor += _ORFunctionDeclaratorBaseLength;
    node->varname =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->returnNode =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->declarators =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORFunctionDeclaratorDestroy(_ORFunctionDeclarator *node){
    _ORNodeDestroy((_ORNode *)node->returnNode);
    _ORNodeDestroy((_ORNode *)node->declarators);
    free(node);
}
typedef struct {
    _ORNodeFields
    BOOL isBlock;
    uint8_t ptCount;
    _StringNode * varname;
    _ORNode * capacity;
}_ORCArrayVariable;
static uint32_t _ORCArrayVariableBaseLength = 3;
_ORCArrayVariable *_ORCArrayVariableConvert(ORCArrayVariable *exp, _PatchNode *patch, uint32_t *length){
    _ORCArrayVariable *node = malloc(sizeof(_ORCArrayVariable));
    memset(node, 0, sizeof(_ORCArrayVariable));
    node->nodeType = _ORCArrayVariableNode;
    node->isBlock = exp.isBlock;
    node->ptCount = exp.ptCount;
    node->varname = (_StringNode *)_ORNodeConvert(exp.varname, patch, length);
    node->capacity = (_ORNode *)_ORNodeConvert(exp.capacity, patch, length);
    *length += _ORCArrayVariableBaseLength;
    return node;
}
ORCArrayVariable *_ORCArrayVariableDeConvert(_ORCArrayVariable *node, _PatchNode *patch){
    ORCArrayVariable *exp = [ORCArrayVariable new];
    exp.isBlock = node->isBlock;
    exp.ptCount = node->ptCount;
    exp.varname = (NSString *)_ORNodeDeConvert((_ORNode *)node->varname, patch);
    exp.capacity = (id)_ORNodeDeConvert((_ORNode *)node->capacity, patch);
    return exp;
}
void _ORCArrayVariableSerailization(_ORCArrayVariable *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORCArrayVariableBaseLength);
    *cursor += _ORCArrayVariableBaseLength;
    _ORNodeSerailization((_ORNode *)node->varname, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->capacity, buffer, cursor);
}
_ORCArrayVariable *_ORCArrayVariableDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORCArrayVariable *node = malloc(sizeof(_ORCArrayVariable));
    memcpy(node, buffer + *cursor, _ORCArrayVariableBaseLength);
    *cursor += _ORCArrayVariableBaseLength;
    node->varname =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->capacity =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORCArrayVariableDestroy(_ORCArrayVariable *node){
    _ORNodeDestroy((_ORNode *)node->capacity);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ListNode * statements;
}_ORBlockNode;
static uint32_t _ORBlockNodeBaseLength = 1;
_ORBlockNode *_ORBlockNodeConvert(ORBlockNode *exp, _PatchNode *patch, uint32_t *length){
    _ORBlockNode *node = malloc(sizeof(_ORBlockNode));
    memset(node, 0, sizeof(_ORBlockNode));
    node->nodeType = _ORBlockNodeNode;
    node->statements = (_ListNode *)_ORNodeConvert(exp.statements, patch, length);
    *length += _ORBlockNodeBaseLength;
    return node;
}
ORBlockNode *_ORBlockNodeDeConvert(_ORBlockNode *node, _PatchNode *patch){
    ORBlockNode *exp = [ORBlockNode new];
    exp.statements = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->statements, patch);
    return exp;
}
void _ORBlockNodeSerailization(_ORBlockNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORBlockNodeBaseLength);
    *cursor += _ORBlockNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->statements, buffer, cursor);
}
_ORBlockNode *_ORBlockNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORBlockNode *node = malloc(sizeof(_ORBlockNode));
    memcpy(node, buffer + *cursor, _ORBlockNodeBaseLength);
    *cursor += _ORBlockNodeBaseLength;
    node->statements =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORBlockNodeDestroy(_ORBlockNode *node){
    _ORNodeDestroy((_ORNode *)node->statements);
    free(node);
}
typedef struct {
    _ORNodeFields
    uint32_t value_type;
    _ORNode * value;
}_ORValueExpression;
static uint32_t _ORValueExpressionBaseLength = 5;
_ORValueExpression *_ORValueExpressionConvert(ORValueExpression *exp, _PatchNode *patch, uint32_t *length){
    _ORValueExpression *node = malloc(sizeof(_ORValueExpression));
    memset(node, 0, sizeof(_ORValueExpression));
    node->nodeType = _ORValueExpressionNode;
    node->value_type = exp.value_type;
    node->value = (_ORNode *)_ORNodeConvert(exp.value, patch, length);
    *length += _ORValueExpressionBaseLength;
    return node;
}
ORValueExpression *_ORValueExpressionDeConvert(_ORValueExpression *node, _PatchNode *patch){
    ORValueExpression *exp = [ORValueExpression new];
    exp.value_type = node->value_type;
    exp.value = (id)_ORNodeDeConvert((_ORNode *)node->value, patch);
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
void _ORValueExpressionDestroy(_ORValueExpression *node){
    _ORNodeDestroy((_ORNode *)node->value);
    free(node);
}
typedef struct {
    _ORNodeFields
    int64_t value;
}_ORIntegerValue;
static uint32_t _ORIntegerValueBaseLength = 9;
_ORIntegerValue *_ORIntegerValueConvert(ORIntegerValue *exp, _PatchNode *patch, uint32_t *length){
    _ORIntegerValue *node = malloc(sizeof(_ORIntegerValue));
    memset(node, 0, sizeof(_ORIntegerValue));
    node->nodeType = _ORIntegerValueNode;
    node->value = exp.value;
    *length += _ORIntegerValueBaseLength;
    return node;
}
ORIntegerValue *_ORIntegerValueDeConvert(_ORIntegerValue *node, _PatchNode *patch){
    ORIntegerValue *exp = [ORIntegerValue new];
    exp.value = node->value;
    return exp;
}
void _ORIntegerValueSerailization(_ORIntegerValue *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORIntegerValueBaseLength);
    *cursor += _ORIntegerValueBaseLength;
    
}
_ORIntegerValue *_ORIntegerValueDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORIntegerValue *node = malloc(sizeof(_ORIntegerValue));
    memcpy(node, buffer + *cursor, _ORIntegerValueBaseLength);
    *cursor += _ORIntegerValueBaseLength;
    
    return node;
}
void _ORIntegerValueDestroy(_ORIntegerValue *node){
    
    free(node);
}
typedef struct {
    _ORNodeFields
    uint64_t value;
}_ORUIntegerValue;
static uint32_t _ORUIntegerValueBaseLength = 9;
_ORUIntegerValue *_ORUIntegerValueConvert(ORUIntegerValue *exp, _PatchNode *patch, uint32_t *length){
    _ORUIntegerValue *node = malloc(sizeof(_ORUIntegerValue));
    memset(node, 0, sizeof(_ORUIntegerValue));
    node->nodeType = _ORUIntegerValueNode;
    node->value = exp.value;
    *length += _ORUIntegerValueBaseLength;
    return node;
}
ORUIntegerValue *_ORUIntegerValueDeConvert(_ORUIntegerValue *node, _PatchNode *patch){
    ORUIntegerValue *exp = [ORUIntegerValue new];
    exp.value = node->value;
    return exp;
}
void _ORUIntegerValueSerailization(_ORUIntegerValue *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORUIntegerValueBaseLength);
    *cursor += _ORUIntegerValueBaseLength;
    
}
_ORUIntegerValue *_ORUIntegerValueDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORUIntegerValue *node = malloc(sizeof(_ORUIntegerValue));
    memcpy(node, buffer + *cursor, _ORUIntegerValueBaseLength);
    *cursor += _ORUIntegerValueBaseLength;
    
    return node;
}
void _ORUIntegerValueDestroy(_ORUIntegerValue *node){
    
    free(node);
}
typedef struct {
    _ORNodeFields
    double value;
}_ORDoubleValue;
static uint32_t _ORDoubleValueBaseLength = 9;
_ORDoubleValue *_ORDoubleValueConvert(ORDoubleValue *exp, _PatchNode *patch, uint32_t *length){
    _ORDoubleValue *node = malloc(sizeof(_ORDoubleValue));
    memset(node, 0, sizeof(_ORDoubleValue));
    node->nodeType = _ORDoubleValueNode;
    node->value = exp.value;
    *length += _ORDoubleValueBaseLength;
    return node;
}
ORDoubleValue *_ORDoubleValueDeConvert(_ORDoubleValue *node, _PatchNode *patch){
    ORDoubleValue *exp = [ORDoubleValue new];
    exp.value = node->value;
    return exp;
}
void _ORDoubleValueSerailization(_ORDoubleValue *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORDoubleValueBaseLength);
    *cursor += _ORDoubleValueBaseLength;
    
}
_ORDoubleValue *_ORDoubleValueDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORDoubleValue *node = malloc(sizeof(_ORDoubleValue));
    memcpy(node, buffer + *cursor, _ORDoubleValueBaseLength);
    *cursor += _ORDoubleValueBaseLength;
    
    return node;
}
void _ORDoubleValueDestroy(_ORDoubleValue *node){
    
    free(node);
}
typedef struct {
    _ORNodeFields
    BOOL value;
}_ORBoolValue;
static uint32_t _ORBoolValueBaseLength = 2;
_ORBoolValue *_ORBoolValueConvert(ORBoolValue *exp, _PatchNode *patch, uint32_t *length){
    _ORBoolValue *node = malloc(sizeof(_ORBoolValue));
    memset(node, 0, sizeof(_ORBoolValue));
    node->nodeType = _ORBoolValueNode;
    node->value = exp.value;
    *length += _ORBoolValueBaseLength;
    return node;
}
ORBoolValue *_ORBoolValueDeConvert(_ORBoolValue *node, _PatchNode *patch){
    ORBoolValue *exp = [ORBoolValue new];
    exp.value = node->value;
    return exp;
}
void _ORBoolValueSerailization(_ORBoolValue *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORBoolValueBaseLength);
    *cursor += _ORBoolValueBaseLength;
    
}
_ORBoolValue *_ORBoolValueDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORBoolValue *node = malloc(sizeof(_ORBoolValue));
    memcpy(node, buffer + *cursor, _ORBoolValueBaseLength);
    *cursor += _ORBoolValueBaseLength;
    
    return node;
}
void _ORBoolValueDestroy(_ORBoolValue *node){
    
    free(node);
}
typedef struct {
    _ORNodeFields
    uint8_t methodOperator;
    BOOL isAssignedValue;
    _ORNode * caller;
    _ListNode * names;
    _ListNode * values;
}_ORMethodCall;
static uint32_t _ORMethodCallBaseLength = 3;
_ORMethodCall *_ORMethodCallConvert(ORMethodCall *exp, _PatchNode *patch, uint32_t *length){
    _ORMethodCall *node = malloc(sizeof(_ORMethodCall));
    memset(node, 0, sizeof(_ORMethodCall));
    node->nodeType = _ORMethodCallNode;
    node->methodOperator = exp.methodOperator;
    node->isAssignedValue = exp.isAssignedValue;
    node->caller = (_ORNode *)_ORNodeConvert(exp.caller, patch, length);
    node->names = (_ListNode *)_ORNodeConvert(exp.names, patch, length);
    node->values = (_ListNode *)_ORNodeConvert(exp.values, patch, length);
    *length += _ORMethodCallBaseLength;
    return node;
}
ORMethodCall *_ORMethodCallDeConvert(_ORMethodCall *node, _PatchNode *patch){
    ORMethodCall *exp = [ORMethodCall new];
    exp.methodOperator = node->methodOperator;
    exp.isAssignedValue = node->isAssignedValue;
    exp.caller = (id)_ORNodeDeConvert((_ORNode *)node->caller, patch);
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
void _ORMethodCallDestroy(_ORMethodCall *node){
    _ORNodeDestroy((_ORNode *)node->caller);
    _ORNodeDestroy((_ORNode *)node->names);
    _ORNodeDestroy((_ORNode *)node->values);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ORNode * caller;
    _ListNode * expressions;
}_ORFunctionCall;
static uint32_t _ORFunctionCallBaseLength = 1;
_ORFunctionCall *_ORFunctionCallConvert(ORFunctionCall *exp, _PatchNode *patch, uint32_t *length){
    _ORFunctionCall *node = malloc(sizeof(_ORFunctionCall));
    memset(node, 0, sizeof(_ORFunctionCall));
    node->nodeType = _ORFunctionCallNode;
    node->caller = (_ORNode *)_ORNodeConvert(exp.caller, patch, length);
    node->expressions = (_ListNode *)_ORNodeConvert(exp.expressions, patch, length);
    *length += _ORFunctionCallBaseLength;
    return node;
}
ORFunctionCall *_ORFunctionCallDeConvert(_ORFunctionCall *node, _PatchNode *patch){
    ORFunctionCall *exp = [ORFunctionCall new];
    exp.caller = (id)_ORNodeDeConvert((_ORNode *)node->caller, patch);
    exp.expressions = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->expressions, patch);
    return exp;
}
void _ORFunctionCallSerailization(_ORFunctionCall *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORFunctionCallBaseLength);
    *cursor += _ORFunctionCallBaseLength;
    _ORNodeSerailization((_ORNode *)node->caller, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->expressions, buffer, cursor);
}
_ORFunctionCall *_ORFunctionCallDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORFunctionCall *node = malloc(sizeof(_ORFunctionCall));
    memcpy(node, buffer + *cursor, _ORFunctionCallBaseLength);
    *cursor += _ORFunctionCallBaseLength;
    node->caller =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->expressions =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORFunctionCallDestroy(_ORFunctionCall *node){
    _ORNodeDestroy((_ORNode *)node->caller);
    _ORNodeDestroy((_ORNode *)node->expressions);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ORNode * declare;
    _ORNode * scopeImp;
}_ORFunctionImp;
static uint32_t _ORFunctionImpBaseLength = 1;
_ORFunctionImp *_ORFunctionImpConvert(ORFunctionImp *exp, _PatchNode *patch, uint32_t *length){
    _ORFunctionImp *node = malloc(sizeof(_ORFunctionImp));
    memset(node, 0, sizeof(_ORFunctionImp));
    node->nodeType = _ORFunctionImpNode;
    node->declare = (_ORNode *)_ORNodeConvert(exp.declare, patch, length);
    node->scopeImp = (_ORNode *)_ORNodeConvert(exp.scopeImp, patch, length);
    *length += _ORFunctionImpBaseLength;
    return node;
}
ORFunctionImp *_ORFunctionImpDeConvert(_ORFunctionImp *node, _PatchNode *patch){
    ORFunctionImp *exp = [ORFunctionImp new];
    exp.declare = (id)_ORNodeDeConvert((_ORNode *)node->declare, patch);
    exp.scopeImp = (id)_ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
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
void _ORFunctionImpDestroy(_ORFunctionImp *node){
    _ORNodeDestroy((_ORNode *)node->declare);
    _ORNodeDestroy((_ORNode *)node->scopeImp);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ORNode * caller;
    _ORNode * keyExp;
}_ORSubscriptExpression;
static uint32_t _ORSubscriptExpressionBaseLength = 1;
_ORSubscriptExpression *_ORSubscriptExpressionConvert(ORSubscriptExpression *exp, _PatchNode *patch, uint32_t *length){
    _ORSubscriptExpression *node = malloc(sizeof(_ORSubscriptExpression));
    memset(node, 0, sizeof(_ORSubscriptExpression));
    node->nodeType = _ORSubscriptExpressionNode;
    node->caller = (_ORNode *)_ORNodeConvert(exp.caller, patch, length);
    node->keyExp = (_ORNode *)_ORNodeConvert(exp.keyExp, patch, length);
    *length += _ORSubscriptExpressionBaseLength;
    return node;
}
ORSubscriptExpression *_ORSubscriptExpressionDeConvert(_ORSubscriptExpression *node, _PatchNode *patch){
    ORSubscriptExpression *exp = [ORSubscriptExpression new];
    exp.caller = (id)_ORNodeDeConvert((_ORNode *)node->caller, patch);
    exp.keyExp = (id)_ORNodeDeConvert((_ORNode *)node->keyExp, patch);
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
void _ORSubscriptExpressionDestroy(_ORSubscriptExpression *node){
    _ORNodeDestroy((_ORNode *)node->caller);
    _ORNodeDestroy((_ORNode *)node->keyExp);
    free(node);
}
typedef struct {
    _ORNodeFields
    uint32_t assignType;
    _ORNode * value;
    _ORNode * expression;
}_ORAssignExpression;
static uint32_t _ORAssignExpressionBaseLength = 5;
_ORAssignExpression *_ORAssignExpressionConvert(ORAssignExpression *exp, _PatchNode *patch, uint32_t *length){
    _ORAssignExpression *node = malloc(sizeof(_ORAssignExpression));
    memset(node, 0, sizeof(_ORAssignExpression));
    node->nodeType = _ORAssignExpressionNode;
    node->assignType = exp.assignType;
    node->value = (_ORNode *)_ORNodeConvert(exp.value, patch, length);
    node->expression = (_ORNode *)_ORNodeConvert(exp.expression, patch, length);
    *length += _ORAssignExpressionBaseLength;
    return node;
}
ORAssignExpression *_ORAssignExpressionDeConvert(_ORAssignExpression *node, _PatchNode *patch){
    ORAssignExpression *exp = [ORAssignExpression new];
    exp.assignType = node->assignType;
    exp.value = (id)_ORNodeDeConvert((_ORNode *)node->value, patch);
    exp.expression = (id)_ORNodeDeConvert((_ORNode *)node->expression, patch);
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
void _ORAssignExpressionDestroy(_ORAssignExpression *node){
    _ORNodeDestroy((_ORNode *)node->value);
    _ORNodeDestroy((_ORNode *)node->expression);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ORNode * declarator;
    _ORNode * expression;
}_ORInitDeclaratorNode;
static uint32_t _ORInitDeclaratorNodeBaseLength = 1;
_ORInitDeclaratorNode *_ORInitDeclaratorNodeConvert(ORInitDeclaratorNode *exp, _PatchNode *patch, uint32_t *length){
    _ORInitDeclaratorNode *node = malloc(sizeof(_ORInitDeclaratorNode));
    memset(node, 0, sizeof(_ORInitDeclaratorNode));
    node->nodeType = _ORInitDeclaratorNodeNode;
    node->declarator = (_ORNode *)_ORNodeConvert(exp.declarator, patch, length);
    node->expression = (_ORNode *)_ORNodeConvert(exp.expression, patch, length);
    *length += _ORInitDeclaratorNodeBaseLength;
    return node;
}
ORInitDeclaratorNode *_ORInitDeclaratorNodeDeConvert(_ORInitDeclaratorNode *node, _PatchNode *patch){
    ORInitDeclaratorNode *exp = [ORInitDeclaratorNode new];
    exp.declarator = (id)_ORNodeDeConvert((_ORNode *)node->declarator, patch);
    exp.expression = (id)_ORNodeDeConvert((_ORNode *)node->expression, patch);
    return exp;
}
void _ORInitDeclaratorNodeSerailization(_ORInitDeclaratorNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORInitDeclaratorNodeBaseLength);
    *cursor += _ORInitDeclaratorNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->declarator, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->expression, buffer, cursor);
}
_ORInitDeclaratorNode *_ORInitDeclaratorNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORInitDeclaratorNode *node = malloc(sizeof(_ORInitDeclaratorNode));
    memcpy(node, buffer + *cursor, _ORInitDeclaratorNodeBaseLength);
    *cursor += _ORInitDeclaratorNodeBaseLength;
    node->declarator =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->expression =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORInitDeclaratorNodeDestroy(_ORInitDeclaratorNode *node){
    _ORNodeDestroy((_ORNode *)node->declarator);
    _ORNodeDestroy((_ORNode *)node->expression);
    free(node);
}
typedef struct {
    _ORNodeFields
    uint32_t operatorType;
    _ORNode * value;
}_ORUnaryExpression;
static uint32_t _ORUnaryExpressionBaseLength = 5;
_ORUnaryExpression *_ORUnaryExpressionConvert(ORUnaryExpression *exp, _PatchNode *patch, uint32_t *length){
    _ORUnaryExpression *node = malloc(sizeof(_ORUnaryExpression));
    memset(node, 0, sizeof(_ORUnaryExpression));
    node->nodeType = _ORUnaryExpressionNode;
    node->operatorType = exp.operatorType;
    node->value = (_ORNode *)_ORNodeConvert(exp.value, patch, length);
    *length += _ORUnaryExpressionBaseLength;
    return node;
}
ORUnaryExpression *_ORUnaryExpressionDeConvert(_ORUnaryExpression *node, _PatchNode *patch){
    ORUnaryExpression *exp = [ORUnaryExpression new];
    exp.operatorType = node->operatorType;
    exp.value = (id)_ORNodeDeConvert((_ORNode *)node->value, patch);
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
void _ORUnaryExpressionDestroy(_ORUnaryExpression *node){
    _ORNodeDestroy((_ORNode *)node->value);
    free(node);
}
typedef struct {
    _ORNodeFields
    uint32_t operatorType;
    _ORNode * left;
    _ORNode * right;
}_ORBinaryExpression;
static uint32_t _ORBinaryExpressionBaseLength = 5;
_ORBinaryExpression *_ORBinaryExpressionConvert(ORBinaryExpression *exp, _PatchNode *patch, uint32_t *length){
    _ORBinaryExpression *node = malloc(sizeof(_ORBinaryExpression));
    memset(node, 0, sizeof(_ORBinaryExpression));
    node->nodeType = _ORBinaryExpressionNode;
    node->operatorType = exp.operatorType;
    node->left = (_ORNode *)_ORNodeConvert(exp.left, patch, length);
    node->right = (_ORNode *)_ORNodeConvert(exp.right, patch, length);
    *length += _ORBinaryExpressionBaseLength;
    return node;
}
ORBinaryExpression *_ORBinaryExpressionDeConvert(_ORBinaryExpression *node, _PatchNode *patch){
    ORBinaryExpression *exp = [ORBinaryExpression new];
    exp.operatorType = node->operatorType;
    exp.left = (id)_ORNodeDeConvert((_ORNode *)node->left, patch);
    exp.right = (id)_ORNodeDeConvert((_ORNode *)node->right, patch);
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
void _ORBinaryExpressionDestroy(_ORBinaryExpression *node){
    _ORNodeDestroy((_ORNode *)node->left);
    _ORNodeDestroy((_ORNode *)node->right);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ORNode * expression;
    _ListNode * values;
}_ORTernaryExpression;
static uint32_t _ORTernaryExpressionBaseLength = 1;
_ORTernaryExpression *_ORTernaryExpressionConvert(ORTernaryExpression *exp, _PatchNode *patch, uint32_t *length){
    _ORTernaryExpression *node = malloc(sizeof(_ORTernaryExpression));
    memset(node, 0, sizeof(_ORTernaryExpression));
    node->nodeType = _ORTernaryExpressionNode;
    node->expression = (_ORNode *)_ORNodeConvert(exp.expression, patch, length);
    node->values = (_ListNode *)_ORNodeConvert(exp.values, patch, length);
    *length += _ORTernaryExpressionBaseLength;
    return node;
}
ORTernaryExpression *_ORTernaryExpressionDeConvert(_ORTernaryExpression *node, _PatchNode *patch){
    ORTernaryExpression *exp = [ORTernaryExpression new];
    exp.expression = (id)_ORNodeDeConvert((_ORNode *)node->expression, patch);
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
void _ORTernaryExpressionDestroy(_ORTernaryExpression *node){
    _ORNodeDestroy((_ORNode *)node->expression);
    _ORNodeDestroy((_ORNode *)node->values);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ORNode * condition;
    _ORNode * last;
    _ORNode * scopeImp;
}_ORIfStatement;
static uint32_t _ORIfStatementBaseLength = 1;
_ORIfStatement *_ORIfStatementConvert(ORIfStatement *exp, _PatchNode *patch, uint32_t *length){
    _ORIfStatement *node = malloc(sizeof(_ORIfStatement));
    memset(node, 0, sizeof(_ORIfStatement));
    node->nodeType = _ORIfStatementNode;
    node->condition = (_ORNode *)_ORNodeConvert(exp.condition, patch, length);
    node->last = (_ORNode *)_ORNodeConvert(exp.last, patch, length);
    node->scopeImp = (_ORNode *)_ORNodeConvert(exp.scopeImp, patch, length);
    *length += _ORIfStatementBaseLength;
    return node;
}
ORIfStatement *_ORIfStatementDeConvert(_ORIfStatement *node, _PatchNode *patch){
    ORIfStatement *exp = [ORIfStatement new];
    exp.condition = (id)_ORNodeDeConvert((_ORNode *)node->condition, patch);
    exp.last = (id)_ORNodeDeConvert((_ORNode *)node->last, patch);
    exp.scopeImp = (id)_ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
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
void _ORIfStatementDestroy(_ORIfStatement *node){
    _ORNodeDestroy((_ORNode *)node->condition);
    _ORNodeDestroy((_ORNode *)node->last);
    _ORNodeDestroy((_ORNode *)node->scopeImp);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ORNode * condition;
    _ORNode * scopeImp;
}_ORWhileStatement;
static uint32_t _ORWhileStatementBaseLength = 1;
_ORWhileStatement *_ORWhileStatementConvert(ORWhileStatement *exp, _PatchNode *patch, uint32_t *length){
    _ORWhileStatement *node = malloc(sizeof(_ORWhileStatement));
    memset(node, 0, sizeof(_ORWhileStatement));
    node->nodeType = _ORWhileStatementNode;
    node->condition = (_ORNode *)_ORNodeConvert(exp.condition, patch, length);
    node->scopeImp = (_ORNode *)_ORNodeConvert(exp.scopeImp, patch, length);
    *length += _ORWhileStatementBaseLength;
    return node;
}
ORWhileStatement *_ORWhileStatementDeConvert(_ORWhileStatement *node, _PatchNode *patch){
    ORWhileStatement *exp = [ORWhileStatement new];
    exp.condition = (id)_ORNodeDeConvert((_ORNode *)node->condition, patch);
    exp.scopeImp = (id)_ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
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
void _ORWhileStatementDestroy(_ORWhileStatement *node){
    _ORNodeDestroy((_ORNode *)node->condition);
    _ORNodeDestroy((_ORNode *)node->scopeImp);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ORNode * condition;
    _ORNode * scopeImp;
}_ORDoWhileStatement;
static uint32_t _ORDoWhileStatementBaseLength = 1;
_ORDoWhileStatement *_ORDoWhileStatementConvert(ORDoWhileStatement *exp, _PatchNode *patch, uint32_t *length){
    _ORDoWhileStatement *node = malloc(sizeof(_ORDoWhileStatement));
    memset(node, 0, sizeof(_ORDoWhileStatement));
    node->nodeType = _ORDoWhileStatementNode;
    node->condition = (_ORNode *)_ORNodeConvert(exp.condition, patch, length);
    node->scopeImp = (_ORNode *)_ORNodeConvert(exp.scopeImp, patch, length);
    *length += _ORDoWhileStatementBaseLength;
    return node;
}
ORDoWhileStatement *_ORDoWhileStatementDeConvert(_ORDoWhileStatement *node, _PatchNode *patch){
    ORDoWhileStatement *exp = [ORDoWhileStatement new];
    exp.condition = (id)_ORNodeDeConvert((_ORNode *)node->condition, patch);
    exp.scopeImp = (id)_ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
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
void _ORDoWhileStatementDestroy(_ORDoWhileStatement *node){
    _ORNodeDestroy((_ORNode *)node->condition);
    _ORNodeDestroy((_ORNode *)node->scopeImp);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ORNode * value;
    _ORNode * scopeImp;
}_ORCaseStatement;
static uint32_t _ORCaseStatementBaseLength = 1;
_ORCaseStatement *_ORCaseStatementConvert(ORCaseStatement *exp, _PatchNode *patch, uint32_t *length){
    _ORCaseStatement *node = malloc(sizeof(_ORCaseStatement));
    memset(node, 0, sizeof(_ORCaseStatement));
    node->nodeType = _ORCaseStatementNode;
    node->value = (_ORNode *)_ORNodeConvert(exp.value, patch, length);
    node->scopeImp = (_ORNode *)_ORNodeConvert(exp.scopeImp, patch, length);
    *length += _ORCaseStatementBaseLength;
    return node;
}
ORCaseStatement *_ORCaseStatementDeConvert(_ORCaseStatement *node, _PatchNode *patch){
    ORCaseStatement *exp = [ORCaseStatement new];
    exp.value = (id)_ORNodeDeConvert((_ORNode *)node->value, patch);
    exp.scopeImp = (id)_ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
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
void _ORCaseStatementDestroy(_ORCaseStatement *node){
    _ORNodeDestroy((_ORNode *)node->value);
    _ORNodeDestroy((_ORNode *)node->scopeImp);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ORNode * value;
    _ListNode * cases;
    _ORNode * scopeImp;
}_ORSwitchStatement;
static uint32_t _ORSwitchStatementBaseLength = 1;
_ORSwitchStatement *_ORSwitchStatementConvert(ORSwitchStatement *exp, _PatchNode *patch, uint32_t *length){
    _ORSwitchStatement *node = malloc(sizeof(_ORSwitchStatement));
    memset(node, 0, sizeof(_ORSwitchStatement));
    node->nodeType = _ORSwitchStatementNode;
    node->value = (_ORNode *)_ORNodeConvert(exp.value, patch, length);
    node->cases = (_ListNode *)_ORNodeConvert(exp.cases, patch, length);
    node->scopeImp = (_ORNode *)_ORNodeConvert(exp.scopeImp, patch, length);
    *length += _ORSwitchStatementBaseLength;
    return node;
}
ORSwitchStatement *_ORSwitchStatementDeConvert(_ORSwitchStatement *node, _PatchNode *patch){
    ORSwitchStatement *exp = [ORSwitchStatement new];
    exp.value = (id)_ORNodeDeConvert((_ORNode *)node->value, patch);
    exp.cases = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->cases, patch);
    exp.scopeImp = (id)_ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
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
void _ORSwitchStatementDestroy(_ORSwitchStatement *node){
    _ORNodeDestroy((_ORNode *)node->value);
    _ORNodeDestroy((_ORNode *)node->cases);
    _ORNodeDestroy((_ORNode *)node->scopeImp);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ListNode * varExpressions;
    _ORNode * condition;
    _ListNode * expressions;
    _ORNode * scopeImp;
}_ORForStatement;
static uint32_t _ORForStatementBaseLength = 1;
_ORForStatement *_ORForStatementConvert(ORForStatement *exp, _PatchNode *patch, uint32_t *length){
    _ORForStatement *node = malloc(sizeof(_ORForStatement));
    memset(node, 0, sizeof(_ORForStatement));
    node->nodeType = _ORForStatementNode;
    node->varExpressions = (_ListNode *)_ORNodeConvert(exp.varExpressions, patch, length);
    node->condition = (_ORNode *)_ORNodeConvert(exp.condition, patch, length);
    node->expressions = (_ListNode *)_ORNodeConvert(exp.expressions, patch, length);
    node->scopeImp = (_ORNode *)_ORNodeConvert(exp.scopeImp, patch, length);
    *length += _ORForStatementBaseLength;
    return node;
}
ORForStatement *_ORForStatementDeConvert(_ORForStatement *node, _PatchNode *patch){
    ORForStatement *exp = [ORForStatement new];
    exp.varExpressions = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->varExpressions, patch);
    exp.condition = (id)_ORNodeDeConvert((_ORNode *)node->condition, patch);
    exp.expressions = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->expressions, patch);
    exp.scopeImp = (id)_ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
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
void _ORForStatementDestroy(_ORForStatement *node){
    _ORNodeDestroy((_ORNode *)node->varExpressions);
    _ORNodeDestroy((_ORNode *)node->condition);
    _ORNodeDestroy((_ORNode *)node->expressions);
    _ORNodeDestroy((_ORNode *)node->scopeImp);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ORNode * expression;
    _ORNode * value;
    _ORNode * scopeImp;
}_ORForInStatement;
static uint32_t _ORForInStatementBaseLength = 1;
_ORForInStatement *_ORForInStatementConvert(ORForInStatement *exp, _PatchNode *patch, uint32_t *length){
    _ORForInStatement *node = malloc(sizeof(_ORForInStatement));
    memset(node, 0, sizeof(_ORForInStatement));
    node->nodeType = _ORForInStatementNode;
    node->expression = (_ORNode *)_ORNodeConvert(exp.expression, patch, length);
    node->value = (_ORNode *)_ORNodeConvert(exp.value, patch, length);
    node->scopeImp = (_ORNode *)_ORNodeConvert(exp.scopeImp, patch, length);
    *length += _ORForInStatementBaseLength;
    return node;
}
ORForInStatement *_ORForInStatementDeConvert(_ORForInStatement *node, _PatchNode *patch){
    ORForInStatement *exp = [ORForInStatement new];
    exp.expression = (id)_ORNodeDeConvert((_ORNode *)node->expression, patch);
    exp.value = (id)_ORNodeDeConvert((_ORNode *)node->value, patch);
    exp.scopeImp = (id)_ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
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
void _ORForInStatementDestroy(_ORForInStatement *node){
    _ORNodeDestroy((_ORNode *)node->expression);
    _ORNodeDestroy((_ORNode *)node->value);
    _ORNodeDestroy((_ORNode *)node->scopeImp);
    free(node);
}
typedef struct {
    _ORNodeFields
    uint64_t type;
    _ORNode * expression;
}_ORControlStatement;
static uint32_t _ORControlStatementBaseLength = 9;
_ORControlStatement *_ORControlStatementConvert(ORControlStatement *exp, _PatchNode *patch, uint32_t *length){
    _ORControlStatement *node = malloc(sizeof(_ORControlStatement));
    memset(node, 0, sizeof(_ORControlStatement));
    node->nodeType = _ORControlStatementNode;
    node->type = exp.type;
    node->expression = (_ORNode *)_ORNodeConvert(exp.expression, patch, length);
    *length += _ORControlStatementBaseLength;
    return node;
}
ORControlStatement *_ORControlStatementDeConvert(_ORControlStatement *node, _PatchNode *patch){
    ORControlStatement *exp = [ORControlStatement new];
    exp.type = node->type;
    exp.expression = (id)_ORNodeDeConvert((_ORNode *)node->expression, patch);
    return exp;
}
void _ORControlStatementSerailization(_ORControlStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORControlStatementBaseLength);
    *cursor += _ORControlStatementBaseLength;
    _ORNodeSerailization((_ORNode *)node->expression, buffer, cursor);
}
_ORControlStatement *_ORControlStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORControlStatement *node = malloc(sizeof(_ORControlStatement));
    memcpy(node, buffer + *cursor, _ORControlStatementBaseLength);
    *cursor += _ORControlStatementBaseLength;
    node->expression =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORControlStatementDestroy(_ORControlStatement *node){
    _ORNodeDestroy((_ORNode *)node->expression);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ListNode * keywords;
    _ORNode * var;
}_ORPropertyDeclare;
static uint32_t _ORPropertyDeclareBaseLength = 1;
_ORPropertyDeclare *_ORPropertyDeclareConvert(ORPropertyDeclare *exp, _PatchNode *patch, uint32_t *length){
    _ORPropertyDeclare *node = malloc(sizeof(_ORPropertyDeclare));
    memset(node, 0, sizeof(_ORPropertyDeclare));
    node->nodeType = _ORPropertyDeclareNode;
    node->keywords = (_ListNode *)_ORNodeConvert(exp.keywords, patch, length);
    node->var = (_ORNode *)_ORNodeConvert(exp.var, patch, length);
    *length += _ORPropertyDeclareBaseLength;
    return node;
}
ORPropertyDeclare *_ORPropertyDeclareDeConvert(_ORPropertyDeclare *node, _PatchNode *patch){
    ORPropertyDeclare *exp = [ORPropertyDeclare new];
    exp.keywords = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->keywords, patch);
    exp.var = (id)_ORNodeDeConvert((_ORNode *)node->var, patch);
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
void _ORPropertyDeclareDestroy(_ORPropertyDeclare *node){
    _ORNodeDestroy((_ORNode *)node->keywords);
    _ORNodeDestroy((_ORNode *)node->var);
    free(node);
}
typedef struct {
    _ORNodeFields
    BOOL isClassMethod;
    _ORNode * returnType;
    _ListNode * methodNames;
    _ListNode * parameterTypes;
    _ListNode * parameterNames;
}_ORMethodDeclare;
static uint32_t _ORMethodDeclareBaseLength = 2;
_ORMethodDeclare *_ORMethodDeclareConvert(ORMethodDeclare *exp, _PatchNode *patch, uint32_t *length){
    _ORMethodDeclare *node = malloc(sizeof(_ORMethodDeclare));
    memset(node, 0, sizeof(_ORMethodDeclare));
    node->nodeType = _ORMethodDeclareNode;
    node->isClassMethod = exp.isClassMethod;
    node->returnType = (_ORNode *)_ORNodeConvert(exp.returnType, patch, length);
    node->methodNames = (_ListNode *)_ORNodeConvert(exp.methodNames, patch, length);
    node->parameterTypes = (_ListNode *)_ORNodeConvert(exp.parameterTypes, patch, length);
    node->parameterNames = (_ListNode *)_ORNodeConvert(exp.parameterNames, patch, length);
    *length += _ORMethodDeclareBaseLength;
    return node;
}
ORMethodDeclare *_ORMethodDeclareDeConvert(_ORMethodDeclare *node, _PatchNode *patch){
    ORMethodDeclare *exp = [ORMethodDeclare new];
    exp.isClassMethod = node->isClassMethod;
    exp.returnType = (id)_ORNodeDeConvert((_ORNode *)node->returnType, patch);
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
void _ORMethodDeclareDestroy(_ORMethodDeclare *node){
    _ORNodeDestroy((_ORNode *)node->returnType);
    _ORNodeDestroy((_ORNode *)node->methodNames);
    _ORNodeDestroy((_ORNode *)node->parameterTypes);
    _ORNodeDestroy((_ORNode *)node->parameterNames);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ORNode * declare;
    _ORNode * scopeImp;
}_ORMethodImplementation;
static uint32_t _ORMethodImplementationBaseLength = 1;
_ORMethodImplementation *_ORMethodImplementationConvert(ORMethodImplementation *exp, _PatchNode *patch, uint32_t *length){
    _ORMethodImplementation *node = malloc(sizeof(_ORMethodImplementation));
    memset(node, 0, sizeof(_ORMethodImplementation));
    node->nodeType = _ORMethodImplementationNode;
    node->declare = (_ORNode *)_ORNodeConvert(exp.declare, patch, length);
    node->scopeImp = (_ORNode *)_ORNodeConvert(exp.scopeImp, patch, length);
    *length += _ORMethodImplementationBaseLength;
    return node;
}
ORMethodImplementation *_ORMethodImplementationDeConvert(_ORMethodImplementation *node, _PatchNode *patch){
    ORMethodImplementation *exp = [ORMethodImplementation new];
    exp.declare = (id)_ORNodeDeConvert((_ORNode *)node->declare, patch);
    exp.scopeImp = (id)_ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
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
void _ORMethodImplementationDestroy(_ORMethodImplementation *node){
    _ORNodeDestroy((_ORNode *)node->declare);
    _ORNodeDestroy((_ORNode *)node->scopeImp);
    free(node);
}
typedef struct {
    _ORNodeFields
    _StringNode * className;
    _StringNode * superClassName;
    _ListNode * protocols;
    _ListNode * properties;
    _ListNode * privateVariables;
    _ListNode * methods;
}_ORClass;
static uint32_t _ORClassBaseLength = 1;
_ORClass *_ORClassConvert(ORClass *exp, _PatchNode *patch, uint32_t *length){
    _ORClass *node = malloc(sizeof(_ORClass));
    memset(node, 0, sizeof(_ORClass));
    node->nodeType = _ORClassNode;
    node->className = (_StringNode *)_ORNodeConvert(exp.className, patch, length);
    node->superClassName = (_StringNode *)_ORNodeConvert(exp.superClassName, patch, length);
    node->protocols = (_ListNode *)_ORNodeConvert(exp.protocols, patch, length);
    node->properties = (_ListNode *)_ORNodeConvert(exp.properties, patch, length);
    node->privateVariables = (_ListNode *)_ORNodeConvert(exp.privateVariables, patch, length);
    node->methods = (_ListNode *)_ORNodeConvert(exp.methods, patch, length);
    *length += _ORClassBaseLength;
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
void _ORClassDestroy(_ORClass *node){
    _ORNodeDestroy((_ORNode *)node->className);
    _ORNodeDestroy((_ORNode *)node->superClassName);
    _ORNodeDestroy((_ORNode *)node->protocols);
    _ORNodeDestroy((_ORNode *)node->properties);
    _ORNodeDestroy((_ORNode *)node->privateVariables);
    _ORNodeDestroy((_ORNode *)node->methods);
    free(node);
}
typedef struct {
    _ORNodeFields
    _StringNode * protcolName;
    _ListNode * protocols;
    _ListNode * properties;
    _ListNode * methods;
}_ORProtocol;
static uint32_t _ORProtocolBaseLength = 1;
_ORProtocol *_ORProtocolConvert(ORProtocol *exp, _PatchNode *patch, uint32_t *length){
    _ORProtocol *node = malloc(sizeof(_ORProtocol));
    memset(node, 0, sizeof(_ORProtocol));
    node->nodeType = _ORProtocolNode;
    node->protcolName = (_StringNode *)_ORNodeConvert(exp.protcolName, patch, length);
    node->protocols = (_ListNode *)_ORNodeConvert(exp.protocols, patch, length);
    node->properties = (_ListNode *)_ORNodeConvert(exp.properties, patch, length);
    node->methods = (_ListNode *)_ORNodeConvert(exp.methods, patch, length);
    *length += _ORProtocolBaseLength;
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
void _ORProtocolDestroy(_ORProtocol *node){
    _ORNodeDestroy((_ORNode *)node->protcolName);
    _ORNodeDestroy((_ORNode *)node->protocols);
    _ORNodeDestroy((_ORNode *)node->properties);
    _ORNodeDestroy((_ORNode *)node->methods);
    free(node);
}
typedef struct {
    _ORNodeFields
    _StringNode * sturctName;
    _ListNode * fields;
}_ORStructStatNode;
static uint32_t _ORStructStatNodeBaseLength = 1;
_ORStructStatNode *_ORStructStatNodeConvert(ORStructStatNode *exp, _PatchNode *patch, uint32_t *length){
    _ORStructStatNode *node = malloc(sizeof(_ORStructStatNode));
    memset(node, 0, sizeof(_ORStructStatNode));
    node->nodeType = _ORStructStatNodeNode;
    node->sturctName = (_StringNode *)_ORNodeConvert(exp.sturctName, patch, length);
    node->fields = (_ListNode *)_ORNodeConvert(exp.fields, patch, length);
    *length += _ORStructStatNodeBaseLength;
    return node;
}
ORStructStatNode *_ORStructStatNodeDeConvert(_ORStructStatNode *node, _PatchNode *patch){
    ORStructStatNode *exp = [ORStructStatNode new];
    exp.sturctName = (NSString *)_ORNodeDeConvert((_ORNode *)node->sturctName, patch);
    exp.fields = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->fields, patch);
    return exp;
}
void _ORStructStatNodeSerailization(_ORStructStatNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORStructStatNodeBaseLength);
    *cursor += _ORStructStatNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->sturctName, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->fields, buffer, cursor);
}
_ORStructStatNode *_ORStructStatNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORStructStatNode *node = malloc(sizeof(_ORStructStatNode));
    memcpy(node, buffer + *cursor, _ORStructStatNodeBaseLength);
    *cursor += _ORStructStatNodeBaseLength;
    node->sturctName =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->fields =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORStructStatNodeDestroy(_ORStructStatNode *node){
    _ORNodeDestroy((_ORNode *)node->sturctName);
    _ORNodeDestroy((_ORNode *)node->fields);
    free(node);
}
typedef struct {
    _ORNodeFields
    _StringNode * unionName;
    _ListNode * fields;
}_ORUnionStatNode;
static uint32_t _ORUnionStatNodeBaseLength = 1;
_ORUnionStatNode *_ORUnionStatNodeConvert(ORUnionStatNode *exp, _PatchNode *patch, uint32_t *length){
    _ORUnionStatNode *node = malloc(sizeof(_ORUnionStatNode));
    memset(node, 0, sizeof(_ORUnionStatNode));
    node->nodeType = _ORUnionStatNodeNode;
    node->unionName = (_StringNode *)_ORNodeConvert(exp.unionName, patch, length);
    node->fields = (_ListNode *)_ORNodeConvert(exp.fields, patch, length);
    *length += _ORUnionStatNodeBaseLength;
    return node;
}
ORUnionStatNode *_ORUnionStatNodeDeConvert(_ORUnionStatNode *node, _PatchNode *patch){
    ORUnionStatNode *exp = [ORUnionStatNode new];
    exp.unionName = (NSString *)_ORNodeDeConvert((_ORNode *)node->unionName, patch);
    exp.fields = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->fields, patch);
    return exp;
}
void _ORUnionStatNodeSerailization(_ORUnionStatNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORUnionStatNodeBaseLength);
    *cursor += _ORUnionStatNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->unionName, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->fields, buffer, cursor);
}
_ORUnionStatNode *_ORUnionStatNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORUnionStatNode *node = malloc(sizeof(_ORUnionStatNode));
    memcpy(node, buffer + *cursor, _ORUnionStatNodeBaseLength);
    *cursor += _ORUnionStatNodeBaseLength;
    node->unionName =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->fields =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORUnionStatNodeDestroy(_ORUnionStatNode *node){
    _ORNodeDestroy((_ORNode *)node->unionName);
    _ORNodeDestroy((_ORNode *)node->fields);
    free(node);
}
typedef struct {
    _ORNodeFields
    uint32_t valueType;
    _StringNode * enumName;
    _ListNode * fields;
}_OREnumStatNode;
static uint32_t _OREnumStatNodeBaseLength = 5;
_OREnumStatNode *_OREnumStatNodeConvert(OREnumStatNode *exp, _PatchNode *patch, uint32_t *length){
    _OREnumStatNode *node = malloc(sizeof(_OREnumStatNode));
    memset(node, 0, sizeof(_OREnumStatNode));
    node->nodeType = _OREnumStatNodeNode;
    node->valueType = exp.valueType;
    node->enumName = (_StringNode *)_ORNodeConvert(exp.enumName, patch, length);
    node->fields = (_ListNode *)_ORNodeConvert(exp.fields, patch, length);
    *length += _OREnumStatNodeBaseLength;
    return node;
}
OREnumStatNode *_OREnumStatNodeDeConvert(_OREnumStatNode *node, _PatchNode *patch){
    OREnumStatNode *exp = [OREnumStatNode new];
    exp.valueType = node->valueType;
    exp.enumName = (NSString *)_ORNodeDeConvert((_ORNode *)node->enumName, patch);
    exp.fields = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->fields, patch);
    return exp;
}
void _OREnumStatNodeSerailization(_OREnumStatNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _OREnumStatNodeBaseLength);
    *cursor += _OREnumStatNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->enumName, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->fields, buffer, cursor);
}
_OREnumStatNode *_OREnumStatNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _OREnumStatNode *node = malloc(sizeof(_OREnumStatNode));
    memcpy(node, buffer + *cursor, _OREnumStatNodeBaseLength);
    *cursor += _OREnumStatNodeBaseLength;
    node->enumName =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->fields =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _OREnumStatNodeDestroy(_OREnumStatNode *node){
    _ORNodeDestroy((_ORNode *)node->enumName);
    _ORNodeDestroy((_ORNode *)node->fields);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ORNode * expression;
    _StringNode * typeNewName;
}_ORTypedefStatNode;
static uint32_t _ORTypedefStatNodeBaseLength = 1;
_ORTypedefStatNode *_ORTypedefStatNodeConvert(ORTypedefStatNode *exp, _PatchNode *patch, uint32_t *length){
    _ORTypedefStatNode *node = malloc(sizeof(_ORTypedefStatNode));
    memset(node, 0, sizeof(_ORTypedefStatNode));
    node->nodeType = _ORTypedefStatNodeNode;
    node->expression = (_ORNode *)_ORNodeConvert(exp.expression, patch, length);
    node->typeNewName = (_StringNode *)_ORNodeConvert(exp.typeNewName, patch, length);
    *length += _ORTypedefStatNodeBaseLength;
    return node;
}
ORTypedefStatNode *_ORTypedefStatNodeDeConvert(_ORTypedefStatNode *node, _PatchNode *patch){
    ORTypedefStatNode *exp = [ORTypedefStatNode new];
    exp.expression = (id)_ORNodeDeConvert((_ORNode *)node->expression, patch);
    exp.typeNewName = (NSString *)_ORNodeDeConvert((_ORNode *)node->typeNewName, patch);
    return exp;
}
void _ORTypedefStatNodeSerailization(_ORTypedefStatNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORTypedefStatNodeBaseLength);
    *cursor += _ORTypedefStatNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->expression, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->typeNewName, buffer, cursor);
}
_ORTypedefStatNode *_ORTypedefStatNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORTypedefStatNode *node = malloc(sizeof(_ORTypedefStatNode));
    memcpy(node, buffer + *cursor, _ORTypedefStatNodeBaseLength);
    *cursor += _ORTypedefStatNodeBaseLength;
    node->expression =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->typeNewName =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORTypedefStatNodeDestroy(_ORTypedefStatNode *node){
    _ORNodeDestroy((_ORNode *)node->expression);
    _ORNodeDestroy((_ORNode *)node->typeNewName);
    free(node);
}
#pragma pack()
#pragma pack(show)
_ORNode *_ORNodeConvert(id exp, _PatchNode *patch, uint32_t *length){
    if ([exp isKindOfClass:[NSString class]]) {
        return (_ORNode *)saveNewString((NSString *)exp, patch, length);
    }else if ([exp isKindOfClass:[NSArray class]]) {
        return (_ORNode *)_ListNodeConvert((NSArray *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORCArrayVariable class]]){
        return (_ORNode *)_ORCArrayVariableConvert((ORCArrayVariable *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORFunctionDeclarator class]]){
        return (_ORNode *)_ORFunctionDeclaratorConvert((ORFunctionDeclarator *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORTypeNode class]]){
        return (_ORNode *)_ORTypeNodeConvert((ORTypeNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORVariableNode class]]){
        return (_ORNode *)_ORVariableNodeConvert((ORVariableNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORDeclaratorNode class]]){
        return (_ORNode *)_ORDeclaratorNodeConvert((ORDeclaratorNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORBlockNode class]]){
        return (_ORNode *)_ORBlockNodeConvert((ORBlockNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORValueExpression class]]){
        return (_ORNode *)_ORValueExpressionConvert((ORValueExpression *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORIntegerValue class]]){
        return (_ORNode *)_ORIntegerValueConvert((ORIntegerValue *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORUIntegerValue class]]){
        return (_ORNode *)_ORUIntegerValueConvert((ORUIntegerValue *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORDoubleValue class]]){
        return (_ORNode *)_ORDoubleValueConvert((ORDoubleValue *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORBoolValue class]]){
        return (_ORNode *)_ORBoolValueConvert((ORBoolValue *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORMethodCall class]]){
        return (_ORNode *)_ORMethodCallConvert((ORMethodCall *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORFunctionCall class]]){
        return (_ORNode *)_ORFunctionCallConvert((ORFunctionCall *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORFunctionImp class]]){
        return (_ORNode *)_ORFunctionImpConvert((ORFunctionImp *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORSubscriptExpression class]]){
        return (_ORNode *)_ORSubscriptExpressionConvert((ORSubscriptExpression *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORAssignExpression class]]){
        return (_ORNode *)_ORAssignExpressionConvert((ORAssignExpression *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORInitDeclaratorNode class]]){
        return (_ORNode *)_ORInitDeclaratorNodeConvert((ORInitDeclaratorNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORUnaryExpression class]]){
        return (_ORNode *)_ORUnaryExpressionConvert((ORUnaryExpression *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORBinaryExpression class]]){
        return (_ORNode *)_ORBinaryExpressionConvert((ORBinaryExpression *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORTernaryExpression class]]){
        return (_ORNode *)_ORTernaryExpressionConvert((ORTernaryExpression *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORIfStatement class]]){
        return (_ORNode *)_ORIfStatementConvert((ORIfStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORWhileStatement class]]){
        return (_ORNode *)_ORWhileStatementConvert((ORWhileStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORDoWhileStatement class]]){
        return (_ORNode *)_ORDoWhileStatementConvert((ORDoWhileStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORCaseStatement class]]){
        return (_ORNode *)_ORCaseStatementConvert((ORCaseStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORSwitchStatement class]]){
        return (_ORNode *)_ORSwitchStatementConvert((ORSwitchStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORForStatement class]]){
        return (_ORNode *)_ORForStatementConvert((ORForStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORForInStatement class]]){
        return (_ORNode *)_ORForInStatementConvert((ORForInStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORControlStatement class]]){
        return (_ORNode *)_ORControlStatementConvert((ORControlStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORPropertyDeclare class]]){
        return (_ORNode *)_ORPropertyDeclareConvert((ORPropertyDeclare *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORMethodDeclare class]]){
        return (_ORNode *)_ORMethodDeclareConvert((ORMethodDeclare *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORMethodImplementation class]]){
        return (_ORNode *)_ORMethodImplementationConvert((ORMethodImplementation *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORClass class]]){
        return (_ORNode *)_ORClassConvert((ORClass *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORProtocol class]]){
        return (_ORNode *)_ORProtocolConvert((ORProtocol *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORStructStatNode class]]){
        return (_ORNode *)_ORStructStatNodeConvert((ORStructStatNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORUnionStatNode class]]){
        return (_ORNode *)_ORUnionStatNodeConvert((ORUnionStatNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[OREnumStatNode class]]){
        return (_ORNode *)_OREnumStatNodeConvert((OREnumStatNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORTypedefStatNode class]]){
        return (_ORNode *)_ORTypedefStatNodeConvert((ORTypedefStatNode *)exp, patch, length);
    }
    _ORNode *node = malloc(sizeof(_ORNode));
    memset(node, 0, sizeof(_ORNode));
    *length += 1;
    return node;
}
id _ORNodeDeConvert(_ORNode *node, _PatchNode *patch){
    if (node->nodeType == ORNodeType) return nil;
    if (node->nodeType == ListNodeType) {
        return _ListNodeDeConvert((_ListNode *)node, patch);
    }else if (node->nodeType == StringNodeType) {
        return getString((_StringNode *) node, patch);
    }else if (node->nodeType == _ORTypeNodeNode){
        return (ORNode *)_ORTypeNodeDeConvert((_ORTypeNode *)node, patch);
    }else if (node->nodeType == _ORVariableNodeNode){
        return (ORNode *)_ORVariableNodeDeConvert((_ORVariableNode *)node, patch);
    }else if (node->nodeType == _ORDeclaratorNodeNode){
        return (ORNode *)_ORDeclaratorNodeDeConvert((_ORDeclaratorNode *)node, patch);
    }else if (node->nodeType == _ORFunctionDeclaratorNode){
        return (ORNode *)_ORFunctionDeclaratorDeConvert((_ORFunctionDeclarator *)node, patch);
    }else if (node->nodeType == _ORCArrayVariableNode){
        return (ORNode *)_ORCArrayVariableDeConvert((_ORCArrayVariable *)node, patch);
    }else if (node->nodeType == _ORBlockNodeNode){
        return (ORNode *)_ORBlockNodeDeConvert((_ORBlockNode *)node, patch);
    }else if (node->nodeType == _ORValueExpressionNode){
        return (ORNode *)_ORValueExpressionDeConvert((_ORValueExpression *)node, patch);
    }else if (node->nodeType == _ORIntegerValueNode){
        return (ORNode *)_ORIntegerValueDeConvert((_ORIntegerValue *)node, patch);
    }else if (node->nodeType == _ORUIntegerValueNode){
        return (ORNode *)_ORUIntegerValueDeConvert((_ORUIntegerValue *)node, patch);
    }else if (node->nodeType == _ORDoubleValueNode){
        return (ORNode *)_ORDoubleValueDeConvert((_ORDoubleValue *)node, patch);
    }else if (node->nodeType == _ORBoolValueNode){
        return (ORNode *)_ORBoolValueDeConvert((_ORBoolValue *)node, patch);
    }else if (node->nodeType == _ORMethodCallNode){
        return (ORNode *)_ORMethodCallDeConvert((_ORMethodCall *)node, patch);
    }else if (node->nodeType == _ORFunctionCallNode){
        return (ORNode *)_ORFunctionCallDeConvert((_ORFunctionCall *)node, patch);
    }else if (node->nodeType == _ORFunctionImpNode){
        return (ORNode *)_ORFunctionImpDeConvert((_ORFunctionImp *)node, patch);
    }else if (node->nodeType == _ORSubscriptExpressionNode){
        return (ORNode *)_ORSubscriptExpressionDeConvert((_ORSubscriptExpression *)node, patch);
    }else if (node->nodeType == _ORAssignExpressionNode){
        return (ORNode *)_ORAssignExpressionDeConvert((_ORAssignExpression *)node, patch);
    }else if (node->nodeType == _ORInitDeclaratorNodeNode){
        return (ORNode *)_ORInitDeclaratorNodeDeConvert((_ORInitDeclaratorNode *)node, patch);
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
    }else if (node->nodeType == _ORControlStatementNode){
        return (ORNode *)_ORControlStatementDeConvert((_ORControlStatement *)node, patch);
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
    }else if (node->nodeType == _ORStructStatNodeNode){
        return (ORNode *)_ORStructStatNodeDeConvert((_ORStructStatNode *)node, patch);
    }else if (node->nodeType == _ORUnionStatNodeNode){
        return (ORNode *)_ORUnionStatNodeDeConvert((_ORUnionStatNode *)node, patch);
    }else if (node->nodeType == _OREnumStatNodeNode){
        return (ORNode *)_OREnumStatNodeDeConvert((_OREnumStatNode *)node, patch);
    }else if (node->nodeType == _ORTypedefStatNodeNode){
        return (ORNode *)_ORTypedefStatNodeDeConvert((_ORTypedefStatNode *)node, patch);
    }
    return [ORNode new];
}
void _ORNodeSerailization(_ORNode *node, void *buffer, uint32_t *cursor){
    if (node->nodeType == ORNodeType) {
        memcpy(buffer + *cursor, node, 1);
        *cursor += 1;
    }else if (node->nodeType == ListNodeType) {
        _ListNodeSerailization((_ListNode *)node, buffer, cursor);
    }else if (node->nodeType == StringNodeType) {
        _StringNodeSerailization((_StringNode *) node, buffer, cursor);
    }else if (node->nodeType == StringsNodeType) {
        _StringsNodeSerailization((_StringsNode *) node, buffer, cursor);
    }else if (node->nodeType == _ORTypeNodeNode){
        _ORTypeNodeSerailization((_ORTypeNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORVariableNodeNode){
        _ORVariableNodeSerailization((_ORVariableNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORDeclaratorNodeNode){
        _ORDeclaratorNodeSerailization((_ORDeclaratorNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORFunctionDeclaratorNode){
        _ORFunctionDeclaratorSerailization((_ORFunctionDeclarator *)node, buffer, cursor);
    }else if (node->nodeType == _ORCArrayVariableNode){
        _ORCArrayVariableSerailization((_ORCArrayVariable *)node, buffer, cursor);
    }else if (node->nodeType == _ORBlockNodeNode){
        _ORBlockNodeSerailization((_ORBlockNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORValueExpressionNode){
        _ORValueExpressionSerailization((_ORValueExpression *)node, buffer, cursor);
    }else if (node->nodeType == _ORIntegerValueNode){
        _ORIntegerValueSerailization((_ORIntegerValue *)node, buffer, cursor);
    }else if (node->nodeType == _ORUIntegerValueNode){
        _ORUIntegerValueSerailization((_ORUIntegerValue *)node, buffer, cursor);
    }else if (node->nodeType == _ORDoubleValueNode){
        _ORDoubleValueSerailization((_ORDoubleValue *)node, buffer, cursor);
    }else if (node->nodeType == _ORBoolValueNode){
        _ORBoolValueSerailization((_ORBoolValue *)node, buffer, cursor);
    }else if (node->nodeType == _ORMethodCallNode){
        _ORMethodCallSerailization((_ORMethodCall *)node, buffer, cursor);
    }else if (node->nodeType == _ORFunctionCallNode){
        _ORFunctionCallSerailization((_ORFunctionCall *)node, buffer, cursor);
    }else if (node->nodeType == _ORFunctionImpNode){
        _ORFunctionImpSerailization((_ORFunctionImp *)node, buffer, cursor);
    }else if (node->nodeType == _ORSubscriptExpressionNode){
        _ORSubscriptExpressionSerailization((_ORSubscriptExpression *)node, buffer, cursor);
    }else if (node->nodeType == _ORAssignExpressionNode){
        _ORAssignExpressionSerailization((_ORAssignExpression *)node, buffer, cursor);
    }else if (node->nodeType == _ORInitDeclaratorNodeNode){
        _ORInitDeclaratorNodeSerailization((_ORInitDeclaratorNode *)node, buffer, cursor);
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
    }else if (node->nodeType == _ORControlStatementNode){
        _ORControlStatementSerailization((_ORControlStatement *)node, buffer, cursor);
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
    }else if (node->nodeType == _ORStructStatNodeNode){
        _ORStructStatNodeSerailization((_ORStructStatNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORUnionStatNodeNode){
        _ORUnionStatNodeSerailization((_ORUnionStatNode *)node, buffer, cursor);
    }else if (node->nodeType == _OREnumStatNodeNode){
        _OREnumStatNodeSerailization((_OREnumStatNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORTypedefStatNodeNode){
        _ORTypedefStatNodeSerailization((_ORTypedefStatNode *)node, buffer, cursor);
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
    }else if (nodeType == _ORTypeNodeNode){
        return (_ORNode *)_ORTypeNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORVariableNodeNode){
        return (_ORNode *)_ORVariableNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORDeclaratorNodeNode){
        return (_ORNode *)_ORDeclaratorNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORFunctionDeclaratorNode){
        return (_ORNode *)_ORFunctionDeclaratorDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORCArrayVariableNode){
        return (_ORNode *)_ORCArrayVariableDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORBlockNodeNode){
        return (_ORNode *)_ORBlockNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORValueExpressionNode){
        return (_ORNode *)_ORValueExpressionDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORIntegerValueNode){
        return (_ORNode *)_ORIntegerValueDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORUIntegerValueNode){
        return (_ORNode *)_ORUIntegerValueDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORDoubleValueNode){
        return (_ORNode *)_ORDoubleValueDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORBoolValueNode){
        return (_ORNode *)_ORBoolValueDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORMethodCallNode){
        return (_ORNode *)_ORMethodCallDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORFunctionCallNode){
        return (_ORNode *)_ORFunctionCallDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORFunctionImpNode){
        return (_ORNode *)_ORFunctionImpDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORSubscriptExpressionNode){
        return (_ORNode *)_ORSubscriptExpressionDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORAssignExpressionNode){
        return (_ORNode *)_ORAssignExpressionDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORInitDeclaratorNodeNode){
        return (_ORNode *)_ORInitDeclaratorNodeDeserialization(buffer, cursor, bufferLength);
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
    }else if (nodeType == _ORControlStatementNode){
        return (_ORNode *)_ORControlStatementDeserialization(buffer, cursor, bufferLength);
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
    }else if (nodeType == _ORStructStatNodeNode){
        return (_ORNode *)_ORStructStatNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORUnionStatNodeNode){
        return (_ORNode *)_ORUnionStatNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _OREnumStatNodeNode){
        return (_ORNode *)_OREnumStatNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORTypedefStatNodeNode){
        return (_ORNode *)_ORTypedefStatNodeDeserialization(buffer, cursor, bufferLength);
    }

    _ORNode *node = malloc(sizeof(_ORNode));
    memset(node, 0, sizeof(_ORNode));
    *cursor += 1;
    return node;
}
void _ORNodeDestroy(_ORNode *node){
    if(node == NULL) return;
    if (node->nodeType == ORNodeType) {
        free(node);
    }else if (node->nodeType == ListNodeType) {
        _ListNodeDestroy((_ListNode *)node);
    }else if (node->nodeType == StringNodeType) {
        _StringNodeDestroy((_StringNode *) node);
    }else if (node->nodeType == StringsNodeType) {
        _StringsNodeDestroy((_StringsNode *) node);
    }else if (node->nodeType == _ORTypeNodeNode){
        _ORTypeNodeDestroy((_ORTypeNode *)node);
    }else if (node->nodeType == _ORVariableNodeNode){
        _ORVariableNodeDestroy((_ORVariableNode *)node);
    }else if (node->nodeType == _ORDeclaratorNodeNode){
        _ORDeclaratorNodeDestroy((_ORDeclaratorNode *)node);
    }else if (node->nodeType == _ORFunctionDeclaratorNode){
        _ORFunctionDeclaratorDestroy((_ORFunctionDeclarator *)node);
    }else if (node->nodeType == _ORCArrayVariableNode){
        _ORCArrayVariableDestroy((_ORCArrayVariable *)node);
    }else if (node->nodeType == _ORBlockNodeNode){
        _ORBlockNodeDestroy((_ORBlockNode *)node);
    }else if (node->nodeType == _ORValueExpressionNode){
        _ORValueExpressionDestroy((_ORValueExpression *)node);
    }else if (node->nodeType == _ORIntegerValueNode){
        _ORIntegerValueDestroy((_ORIntegerValue *)node);
    }else if (node->nodeType == _ORUIntegerValueNode){
        _ORUIntegerValueDestroy((_ORUIntegerValue *)node);
    }else if (node->nodeType == _ORDoubleValueNode){
        _ORDoubleValueDestroy((_ORDoubleValue *)node);
    }else if (node->nodeType == _ORBoolValueNode){
        _ORBoolValueDestroy((_ORBoolValue *)node);
    }else if (node->nodeType == _ORMethodCallNode){
        _ORMethodCallDestroy((_ORMethodCall *)node);
    }else if (node->nodeType == _ORFunctionCallNode){
        _ORFunctionCallDestroy((_ORFunctionCall *)node);
    }else if (node->nodeType == _ORFunctionImpNode){
        _ORFunctionImpDestroy((_ORFunctionImp *)node);
    }else if (node->nodeType == _ORSubscriptExpressionNode){
        _ORSubscriptExpressionDestroy((_ORSubscriptExpression *)node);
    }else if (node->nodeType == _ORAssignExpressionNode){
        _ORAssignExpressionDestroy((_ORAssignExpression *)node);
    }else if (node->nodeType == _ORInitDeclaratorNodeNode){
        _ORInitDeclaratorNodeDestroy((_ORInitDeclaratorNode *)node);
    }else if (node->nodeType == _ORUnaryExpressionNode){
        _ORUnaryExpressionDestroy((_ORUnaryExpression *)node);
    }else if (node->nodeType == _ORBinaryExpressionNode){
        _ORBinaryExpressionDestroy((_ORBinaryExpression *)node);
    }else if (node->nodeType == _ORTernaryExpressionNode){
        _ORTernaryExpressionDestroy((_ORTernaryExpression *)node);
    }else if (node->nodeType == _ORIfStatementNode){
        _ORIfStatementDestroy((_ORIfStatement *)node);
    }else if (node->nodeType == _ORWhileStatementNode){
        _ORWhileStatementDestroy((_ORWhileStatement *)node);
    }else if (node->nodeType == _ORDoWhileStatementNode){
        _ORDoWhileStatementDestroy((_ORDoWhileStatement *)node);
    }else if (node->nodeType == _ORCaseStatementNode){
        _ORCaseStatementDestroy((_ORCaseStatement *)node);
    }else if (node->nodeType == _ORSwitchStatementNode){
        _ORSwitchStatementDestroy((_ORSwitchStatement *)node);
    }else if (node->nodeType == _ORForStatementNode){
        _ORForStatementDestroy((_ORForStatement *)node);
    }else if (node->nodeType == _ORForInStatementNode){
        _ORForInStatementDestroy((_ORForInStatement *)node);
    }else if (node->nodeType == _ORControlStatementNode){
        _ORControlStatementDestroy((_ORControlStatement *)node);
    }else if (node->nodeType == _ORPropertyDeclareNode){
        _ORPropertyDeclareDestroy((_ORPropertyDeclare *)node);
    }else if (node->nodeType == _ORMethodDeclareNode){
        _ORMethodDeclareDestroy((_ORMethodDeclare *)node);
    }else if (node->nodeType == _ORMethodImplementationNode){
        _ORMethodImplementationDestroy((_ORMethodImplementation *)node);
    }else if (node->nodeType == _ORClassNode){
        _ORClassDestroy((_ORClass *)node);
    }else if (node->nodeType == _ORProtocolNode){
        _ORProtocolDestroy((_ORProtocol *)node);
    }else if (node->nodeType == _ORStructStatNodeNode){
        _ORStructStatNodeDestroy((_ORStructStatNode *)node);
    }else if (node->nodeType == _ORUnionStatNodeNode){
        _ORUnionStatNodeDestroy((_ORUnionStatNode *)node);
    }else if (node->nodeType == _OREnumStatNodeNode){
        _OREnumStatNodeDestroy((_OREnumStatNode *)node);
    }else if (node->nodeType == _ORTypedefStatNodeNode){
        _ORTypedefStatNodeDestroy((_ORTypedefStatNode *)node);
    }
}
