//  BinaryPatchHelper.m
//  Generate By BinaryPatchGenerator
//  Created by Jiang on 1615050029
//  Copyright © 2020 SilverFruity. All rights reserved.
#import "BinaryPatchHelper.h"
#import "ORPatchFile.h"
typedef enum: uint8_t{
    ORNodeType = 0,
    PatchNodeType = 1,
    StringNodeType = 2,
    StringsNodeType = 3,
    ListNodeType = 4,
    _ORTypeNodeType = 5,
    _ORVariableNodeType = 6,
    _ORDeclaratorNodeType = 7,
    _ORFunctionDeclNodeType = 8,
    _ORCArrayDeclNodeType = 9,
    _ORBlockNodeType = 10,
    _ORValueNodeType = 11,
    _ORIntegerValueType = 12,
    _ORUIntegerValueType = 13,
    _ORDoubleValueType = 14,
    _ORBoolValueType = 15,
    _ORMethodCallType = 16,
    _ORFunctionCallType = 17,
    _ORFunctionNodeType = 18,
    _ORSubscriptNodeType = 19,
    _ORAssignNodeType = 20,
    _ORInitDeclaratorNodeType = 21,
    _ORUnaryNodeType = 22,
    _ORBinaryNodeType = 23,
    _ORTernaryNodeType = 24,
    _ORIfStatementType = 25,
    _ORWhileStatementType = 26,
    _ORDoWhileStatementType = 27,
    _ORCaseStatementType = 28,
    _ORSwitchStatementType = 29,
    _ORForStatementType = 30,
    _ORForInStatementType = 31,
    _ORControlStatNodeType = 32,
    _ORPropertyNodeType = 33,
    _ORMethodDeclNodeType = 34,
    _ORMethodNodeType = 35,
    _ORClassNodeType = 36,
    _ORProtocolNodeType = 37,
    _ORStructStatNodeType = 38,
    _ORUnionStatNodeType = 39,
    _OREnumStatNodeType = 40,
    _ORTypedefStatNodeType = 41,

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
    node->nodeType = _ORTypeNodeType;
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
    node->nodeType = _ORVariableNodeType;
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
    node->nodeType = _ORDeclaratorNodeType;
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
    BOOL isMultiArgs;
    _ORNode * type;
    _ORNode * var;
    _ListNode * params;
}_ORFunctionDeclNode;
static uint32_t _ORFunctionDeclNodeBaseLength = 2;
_ORFunctionDeclNode *_ORFunctionDeclNodeConvert(ORFunctionDeclNode *exp, _PatchNode *patch, uint32_t *length){
    _ORFunctionDeclNode *node = malloc(sizeof(_ORFunctionDeclNode));
    memset(node, 0, sizeof(_ORFunctionDeclNode));
    node->nodeType = _ORFunctionDeclNodeType;
    node->type = (_ORNode *)_ORNodeConvert(exp.type, patch, length);
    node->var = (_ORNode *)_ORNodeConvert(exp.var, patch, length);
    node->isMultiArgs = exp.isMultiArgs;
    node->params = (_ListNode *)_ORNodeConvert(exp.params, patch, length);
    *length += _ORFunctionDeclNodeBaseLength;
    return node;
}
ORFunctionDeclNode *_ORFunctionDeclNodeDeConvert(_ORFunctionDeclNode *node, _PatchNode *patch){
    ORFunctionDeclNode *exp = [ORFunctionDeclNode new];
    exp.type = (id)_ORNodeDeConvert((_ORNode *)node->type, patch);
    exp.var = (id)_ORNodeDeConvert((_ORNode *)node->var, patch);
    exp.isMultiArgs = node->isMultiArgs;
    exp.params = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->params, patch);
    return exp;
}
void _ORFunctionDeclNodeSerailization(_ORFunctionDeclNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORFunctionDeclNodeBaseLength);
    *cursor += _ORFunctionDeclNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->type, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->var, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->params, buffer, cursor);
}
_ORFunctionDeclNode *_ORFunctionDeclNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORFunctionDeclNode *node = malloc(sizeof(_ORFunctionDeclNode));
    memcpy(node, buffer + *cursor, _ORFunctionDeclNodeBaseLength);
    *cursor += _ORFunctionDeclNodeBaseLength;
    node->type =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->var =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->params =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORFunctionDeclNodeDestroy(_ORFunctionDeclNode *node){
    _ORNodeDestroy((_ORNode *)node->params);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ORNode * type;
    _ORNode * var;
    _ORNode * capacity;
}_ORCArrayDeclNode;
static uint32_t _ORCArrayDeclNodeBaseLength = 1;
_ORCArrayDeclNode *_ORCArrayDeclNodeConvert(ORCArrayDeclNode *exp, _PatchNode *patch, uint32_t *length){
    _ORCArrayDeclNode *node = malloc(sizeof(_ORCArrayDeclNode));
    memset(node, 0, sizeof(_ORCArrayDeclNode));
    node->nodeType = _ORCArrayDeclNodeType;
    node->type = (_ORNode *)_ORNodeConvert(exp.type, patch, length);
    node->var = (_ORNode *)_ORNodeConvert(exp.var, patch, length);
    node->capacity = (_ORNode *)_ORNodeConvert(exp.capacity, patch, length);
    *length += _ORCArrayDeclNodeBaseLength;
    return node;
}
ORCArrayDeclNode *_ORCArrayDeclNodeDeConvert(_ORCArrayDeclNode *node, _PatchNode *patch){
    ORCArrayDeclNode *exp = [ORCArrayDeclNode new];
    exp.type = (id)_ORNodeDeConvert((_ORNode *)node->type, patch);
    exp.var = (id)_ORNodeDeConvert((_ORNode *)node->var, patch);
    exp.capacity = (id)_ORNodeDeConvert((_ORNode *)node->capacity, patch);
    return exp;
}
void _ORCArrayDeclNodeSerailization(_ORCArrayDeclNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORCArrayDeclNodeBaseLength);
    *cursor += _ORCArrayDeclNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->type, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->var, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->capacity, buffer, cursor);
}
_ORCArrayDeclNode *_ORCArrayDeclNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORCArrayDeclNode *node = malloc(sizeof(_ORCArrayDeclNode));
    memcpy(node, buffer + *cursor, _ORCArrayDeclNodeBaseLength);
    *cursor += _ORCArrayDeclNodeBaseLength;
    node->type =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->var =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->capacity =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORCArrayDeclNodeDestroy(_ORCArrayDeclNode *node){
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
    node->nodeType = _ORBlockNodeType;
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
}_ORValueNode;
static uint32_t _ORValueNodeBaseLength = 5;
_ORValueNode *_ORValueNodeConvert(ORValueNode *exp, _PatchNode *patch, uint32_t *length){
    _ORValueNode *node = malloc(sizeof(_ORValueNode));
    memset(node, 0, sizeof(_ORValueNode));
    node->nodeType = _ORValueNodeType;
    node->value_type = exp.value_type;
    node->value = (_ORNode *)_ORNodeConvert(exp.value, patch, length);
    *length += _ORValueNodeBaseLength;
    return node;
}
ORValueNode *_ORValueNodeDeConvert(_ORValueNode *node, _PatchNode *patch){
    ORValueNode *exp = [ORValueNode new];
    exp.value_type = node->value_type;
    exp.value = (id)_ORNodeDeConvert((_ORNode *)node->value, patch);
    return exp;
}
void _ORValueNodeSerailization(_ORValueNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORValueNodeBaseLength);
    *cursor += _ORValueNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->value, buffer, cursor);
}
_ORValueNode *_ORValueNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORValueNode *node = malloc(sizeof(_ORValueNode));
    memcpy(node, buffer + *cursor, _ORValueNodeBaseLength);
    *cursor += _ORValueNodeBaseLength;
    node->value =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORValueNodeDestroy(_ORValueNode *node){
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
    node->nodeType = _ORIntegerValueType;
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
    node->nodeType = _ORUIntegerValueType;
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
    node->nodeType = _ORDoubleValueType;
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
    node->nodeType = _ORBoolValueType;
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
    node->nodeType = _ORMethodCallType;
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
    node->nodeType = _ORFunctionCallType;
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
}_ORFunctionNode;
static uint32_t _ORFunctionNodeBaseLength = 1;
_ORFunctionNode *_ORFunctionNodeConvert(ORFunctionNode *exp, _PatchNode *patch, uint32_t *length){
    _ORFunctionNode *node = malloc(sizeof(_ORFunctionNode));
    memset(node, 0, sizeof(_ORFunctionNode));
    node->nodeType = _ORFunctionNodeType;
    node->declare = (_ORNode *)_ORNodeConvert(exp.declare, patch, length);
    node->scopeImp = (_ORNode *)_ORNodeConvert(exp.scopeImp, patch, length);
    *length += _ORFunctionNodeBaseLength;
    return node;
}
ORFunctionNode *_ORFunctionNodeDeConvert(_ORFunctionNode *node, _PatchNode *patch){
    ORFunctionNode *exp = [ORFunctionNode new];
    exp.declare = (id)_ORNodeDeConvert((_ORNode *)node->declare, patch);
    exp.scopeImp = (id)_ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
    return exp;
}
void _ORFunctionNodeSerailization(_ORFunctionNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORFunctionNodeBaseLength);
    *cursor += _ORFunctionNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->declare, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->scopeImp, buffer, cursor);
}
_ORFunctionNode *_ORFunctionNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORFunctionNode *node = malloc(sizeof(_ORFunctionNode));
    memcpy(node, buffer + *cursor, _ORFunctionNodeBaseLength);
    *cursor += _ORFunctionNodeBaseLength;
    node->declare =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORFunctionNodeDestroy(_ORFunctionNode *node){
    _ORNodeDestroy((_ORNode *)node->declare);
    _ORNodeDestroy((_ORNode *)node->scopeImp);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ORNode * caller;
    _ORNode * keyExp;
}_ORSubscriptNode;
static uint32_t _ORSubscriptNodeBaseLength = 1;
_ORSubscriptNode *_ORSubscriptNodeConvert(ORSubscriptNode *exp, _PatchNode *patch, uint32_t *length){
    _ORSubscriptNode *node = malloc(sizeof(_ORSubscriptNode));
    memset(node, 0, sizeof(_ORSubscriptNode));
    node->nodeType = _ORSubscriptNodeType;
    node->caller = (_ORNode *)_ORNodeConvert(exp.caller, patch, length);
    node->keyExp = (_ORNode *)_ORNodeConvert(exp.keyExp, patch, length);
    *length += _ORSubscriptNodeBaseLength;
    return node;
}
ORSubscriptNode *_ORSubscriptNodeDeConvert(_ORSubscriptNode *node, _PatchNode *patch){
    ORSubscriptNode *exp = [ORSubscriptNode new];
    exp.caller = (id)_ORNodeDeConvert((_ORNode *)node->caller, patch);
    exp.keyExp = (id)_ORNodeDeConvert((_ORNode *)node->keyExp, patch);
    return exp;
}
void _ORSubscriptNodeSerailization(_ORSubscriptNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORSubscriptNodeBaseLength);
    *cursor += _ORSubscriptNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->caller, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->keyExp, buffer, cursor);
}
_ORSubscriptNode *_ORSubscriptNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORSubscriptNode *node = malloc(sizeof(_ORSubscriptNode));
    memcpy(node, buffer + *cursor, _ORSubscriptNodeBaseLength);
    *cursor += _ORSubscriptNodeBaseLength;
    node->caller =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->keyExp =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORSubscriptNodeDestroy(_ORSubscriptNode *node){
    _ORNodeDestroy((_ORNode *)node->caller);
    _ORNodeDestroy((_ORNode *)node->keyExp);
    free(node);
}
typedef struct {
    _ORNodeFields
    uint32_t assignType;
    _ORNode * value;
    _ORNode * expression;
}_ORAssignNode;
static uint32_t _ORAssignNodeBaseLength = 5;
_ORAssignNode *_ORAssignNodeConvert(ORAssignNode *exp, _PatchNode *patch, uint32_t *length){
    _ORAssignNode *node = malloc(sizeof(_ORAssignNode));
    memset(node, 0, sizeof(_ORAssignNode));
    node->nodeType = _ORAssignNodeType;
    node->assignType = exp.assignType;
    node->value = (_ORNode *)_ORNodeConvert(exp.value, patch, length);
    node->expression = (_ORNode *)_ORNodeConvert(exp.expression, patch, length);
    *length += _ORAssignNodeBaseLength;
    return node;
}
ORAssignNode *_ORAssignNodeDeConvert(_ORAssignNode *node, _PatchNode *patch){
    ORAssignNode *exp = [ORAssignNode new];
    exp.assignType = node->assignType;
    exp.value = (id)_ORNodeDeConvert((_ORNode *)node->value, patch);
    exp.expression = (id)_ORNodeDeConvert((_ORNode *)node->expression, patch);
    return exp;
}
void _ORAssignNodeSerailization(_ORAssignNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORAssignNodeBaseLength);
    *cursor += _ORAssignNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->value, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->expression, buffer, cursor);
}
_ORAssignNode *_ORAssignNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORAssignNode *node = malloc(sizeof(_ORAssignNode));
    memcpy(node, buffer + *cursor, _ORAssignNodeBaseLength);
    *cursor += _ORAssignNodeBaseLength;
    node->value =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->expression =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORAssignNodeDestroy(_ORAssignNode *node){
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
    node->nodeType = _ORInitDeclaratorNodeType;
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
}_ORUnaryNode;
static uint32_t _ORUnaryNodeBaseLength = 5;
_ORUnaryNode *_ORUnaryNodeConvert(ORUnaryNode *exp, _PatchNode *patch, uint32_t *length){
    _ORUnaryNode *node = malloc(sizeof(_ORUnaryNode));
    memset(node, 0, sizeof(_ORUnaryNode));
    node->nodeType = _ORUnaryNodeType;
    node->operatorType = exp.operatorType;
    node->value = (_ORNode *)_ORNodeConvert(exp.value, patch, length);
    *length += _ORUnaryNodeBaseLength;
    return node;
}
ORUnaryNode *_ORUnaryNodeDeConvert(_ORUnaryNode *node, _PatchNode *patch){
    ORUnaryNode *exp = [ORUnaryNode new];
    exp.operatorType = node->operatorType;
    exp.value = (id)_ORNodeDeConvert((_ORNode *)node->value, patch);
    return exp;
}
void _ORUnaryNodeSerailization(_ORUnaryNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORUnaryNodeBaseLength);
    *cursor += _ORUnaryNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->value, buffer, cursor);
}
_ORUnaryNode *_ORUnaryNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORUnaryNode *node = malloc(sizeof(_ORUnaryNode));
    memcpy(node, buffer + *cursor, _ORUnaryNodeBaseLength);
    *cursor += _ORUnaryNodeBaseLength;
    node->value =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORUnaryNodeDestroy(_ORUnaryNode *node){
    _ORNodeDestroy((_ORNode *)node->value);
    free(node);
}
typedef struct {
    _ORNodeFields
    uint32_t operatorType;
    _ORNode * left;
    _ORNode * right;
}_ORBinaryNode;
static uint32_t _ORBinaryNodeBaseLength = 5;
_ORBinaryNode *_ORBinaryNodeConvert(ORBinaryNode *exp, _PatchNode *patch, uint32_t *length){
    _ORBinaryNode *node = malloc(sizeof(_ORBinaryNode));
    memset(node, 0, sizeof(_ORBinaryNode));
    node->nodeType = _ORBinaryNodeType;
    node->operatorType = exp.operatorType;
    node->left = (_ORNode *)_ORNodeConvert(exp.left, patch, length);
    node->right = (_ORNode *)_ORNodeConvert(exp.right, patch, length);
    *length += _ORBinaryNodeBaseLength;
    return node;
}
ORBinaryNode *_ORBinaryNodeDeConvert(_ORBinaryNode *node, _PatchNode *patch){
    ORBinaryNode *exp = [ORBinaryNode new];
    exp.operatorType = node->operatorType;
    exp.left = (id)_ORNodeDeConvert((_ORNode *)node->left, patch);
    exp.right = (id)_ORNodeDeConvert((_ORNode *)node->right, patch);
    return exp;
}
void _ORBinaryNodeSerailization(_ORBinaryNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORBinaryNodeBaseLength);
    *cursor += _ORBinaryNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->left, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->right, buffer, cursor);
}
_ORBinaryNode *_ORBinaryNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORBinaryNode *node = malloc(sizeof(_ORBinaryNode));
    memcpy(node, buffer + *cursor, _ORBinaryNodeBaseLength);
    *cursor += _ORBinaryNodeBaseLength;
    node->left =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->right =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORBinaryNodeDestroy(_ORBinaryNode *node){
    _ORNodeDestroy((_ORNode *)node->left);
    _ORNodeDestroy((_ORNode *)node->right);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ORNode * expression;
    _ListNode * values;
}_ORTernaryNode;
static uint32_t _ORTernaryNodeBaseLength = 1;
_ORTernaryNode *_ORTernaryNodeConvert(ORTernaryNode *exp, _PatchNode *patch, uint32_t *length){
    _ORTernaryNode *node = malloc(sizeof(_ORTernaryNode));
    memset(node, 0, sizeof(_ORTernaryNode));
    node->nodeType = _ORTernaryNodeType;
    node->expression = (_ORNode *)_ORNodeConvert(exp.expression, patch, length);
    node->values = (_ListNode *)_ORNodeConvert(exp.values, patch, length);
    *length += _ORTernaryNodeBaseLength;
    return node;
}
ORTernaryNode *_ORTernaryNodeDeConvert(_ORTernaryNode *node, _PatchNode *patch){
    ORTernaryNode *exp = [ORTernaryNode new];
    exp.expression = (id)_ORNodeDeConvert((_ORNode *)node->expression, patch);
    exp.values = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->values, patch);
    return exp;
}
void _ORTernaryNodeSerailization(_ORTernaryNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORTernaryNodeBaseLength);
    *cursor += _ORTernaryNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->expression, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->values, buffer, cursor);
}
_ORTernaryNode *_ORTernaryNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORTernaryNode *node = malloc(sizeof(_ORTernaryNode));
    memcpy(node, buffer + *cursor, _ORTernaryNodeBaseLength);
    *cursor += _ORTernaryNodeBaseLength;
    node->expression =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->values =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORTernaryNodeDestroy(_ORTernaryNode *node){
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
    node->nodeType = _ORIfStatementType;
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
    node->nodeType = _ORWhileStatementType;
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
    node->nodeType = _ORDoWhileStatementType;
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
    node->nodeType = _ORCaseStatementType;
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
    node->nodeType = _ORSwitchStatementType;
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
    node->nodeType = _ORForStatementType;
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
    node->nodeType = _ORForInStatementType;
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
}_ORControlStatNode;
static uint32_t _ORControlStatNodeBaseLength = 9;
_ORControlStatNode *_ORControlStatNodeConvert(ORControlStatNode *exp, _PatchNode *patch, uint32_t *length){
    _ORControlStatNode *node = malloc(sizeof(_ORControlStatNode));
    memset(node, 0, sizeof(_ORControlStatNode));
    node->nodeType = _ORControlStatNodeType;
    node->type = exp.type;
    node->expression = (_ORNode *)_ORNodeConvert(exp.expression, patch, length);
    *length += _ORControlStatNodeBaseLength;
    return node;
}
ORControlStatNode *_ORControlStatNodeDeConvert(_ORControlStatNode *node, _PatchNode *patch){
    ORControlStatNode *exp = [ORControlStatNode new];
    exp.type = node->type;
    exp.expression = (id)_ORNodeDeConvert((_ORNode *)node->expression, patch);
    return exp;
}
void _ORControlStatNodeSerailization(_ORControlStatNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORControlStatNodeBaseLength);
    *cursor += _ORControlStatNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->expression, buffer, cursor);
}
_ORControlStatNode *_ORControlStatNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORControlStatNode *node = malloc(sizeof(_ORControlStatNode));
    memcpy(node, buffer + *cursor, _ORControlStatNodeBaseLength);
    *cursor += _ORControlStatNodeBaseLength;
    node->expression =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORControlStatNodeDestroy(_ORControlStatNode *node){
    _ORNodeDestroy((_ORNode *)node->expression);
    free(node);
}
typedef struct {
    _ORNodeFields
    _ListNode * keywords;
    _ORNode * var;
}_ORPropertyNode;
static uint32_t _ORPropertyNodeBaseLength = 1;
_ORPropertyNode *_ORPropertyNodeConvert(ORPropertyNode *exp, _PatchNode *patch, uint32_t *length){
    _ORPropertyNode *node = malloc(sizeof(_ORPropertyNode));
    memset(node, 0, sizeof(_ORPropertyNode));
    node->nodeType = _ORPropertyNodeType;
    node->keywords = (_ListNode *)_ORNodeConvert(exp.keywords, patch, length);
    node->var = (_ORNode *)_ORNodeConvert(exp.var, patch, length);
    *length += _ORPropertyNodeBaseLength;
    return node;
}
ORPropertyNode *_ORPropertyNodeDeConvert(_ORPropertyNode *node, _PatchNode *patch){
    ORPropertyNode *exp = [ORPropertyNode new];
    exp.keywords = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->keywords, patch);
    exp.var = (id)_ORNodeDeConvert((_ORNode *)node->var, patch);
    return exp;
}
void _ORPropertyNodeSerailization(_ORPropertyNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORPropertyNodeBaseLength);
    *cursor += _ORPropertyNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->keywords, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->var, buffer, cursor);
}
_ORPropertyNode *_ORPropertyNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORPropertyNode *node = malloc(sizeof(_ORPropertyNode));
    memcpy(node, buffer + *cursor, _ORPropertyNodeBaseLength);
    *cursor += _ORPropertyNodeBaseLength;
    node->keywords =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->var =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORPropertyNodeDestroy(_ORPropertyNode *node){
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
}_ORMethodDeclNode;
static uint32_t _ORMethodDeclNodeBaseLength = 2;
_ORMethodDeclNode *_ORMethodDeclNodeConvert(ORMethodDeclNode *exp, _PatchNode *patch, uint32_t *length){
    _ORMethodDeclNode *node = malloc(sizeof(_ORMethodDeclNode));
    memset(node, 0, sizeof(_ORMethodDeclNode));
    node->nodeType = _ORMethodDeclNodeType;
    node->isClassMethod = exp.isClassMethod;
    node->returnType = (_ORNode *)_ORNodeConvert(exp.returnType, patch, length);
    node->methodNames = (_ListNode *)_ORNodeConvert(exp.methodNames, patch, length);
    node->parameterTypes = (_ListNode *)_ORNodeConvert(exp.parameterTypes, patch, length);
    node->parameterNames = (_ListNode *)_ORNodeConvert(exp.parameterNames, patch, length);
    *length += _ORMethodDeclNodeBaseLength;
    return node;
}
ORMethodDeclNode *_ORMethodDeclNodeDeConvert(_ORMethodDeclNode *node, _PatchNode *patch){
    ORMethodDeclNode *exp = [ORMethodDeclNode new];
    exp.isClassMethod = node->isClassMethod;
    exp.returnType = (id)_ORNodeDeConvert((_ORNode *)node->returnType, patch);
    exp.methodNames = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->methodNames, patch);
    exp.parameterTypes = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->parameterTypes, patch);
    exp.parameterNames = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->parameterNames, patch);
    return exp;
}
void _ORMethodDeclNodeSerailization(_ORMethodDeclNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORMethodDeclNodeBaseLength);
    *cursor += _ORMethodDeclNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->returnType, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->methodNames, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->parameterTypes, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->parameterNames, buffer, cursor);
}
_ORMethodDeclNode *_ORMethodDeclNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORMethodDeclNode *node = malloc(sizeof(_ORMethodDeclNode));
    memcpy(node, buffer + *cursor, _ORMethodDeclNodeBaseLength);
    *cursor += _ORMethodDeclNodeBaseLength;
    node->returnType =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->methodNames =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->parameterTypes =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->parameterNames =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORMethodDeclNodeDestroy(_ORMethodDeclNode *node){
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
}_ORMethodNode;
static uint32_t _ORMethodNodeBaseLength = 1;
_ORMethodNode *_ORMethodNodeConvert(ORMethodNode *exp, _PatchNode *patch, uint32_t *length){
    _ORMethodNode *node = malloc(sizeof(_ORMethodNode));
    memset(node, 0, sizeof(_ORMethodNode));
    node->nodeType = _ORMethodNodeType;
    node->declare = (_ORNode *)_ORNodeConvert(exp.declare, patch, length);
    node->scopeImp = (_ORNode *)_ORNodeConvert(exp.scopeImp, patch, length);
    *length += _ORMethodNodeBaseLength;
    return node;
}
ORMethodNode *_ORMethodNodeDeConvert(_ORMethodNode *node, _PatchNode *patch){
    ORMethodNode *exp = [ORMethodNode new];
    exp.declare = (id)_ORNodeDeConvert((_ORNode *)node->declare, patch);
    exp.scopeImp = (id)_ORNodeDeConvert((_ORNode *)node->scopeImp, patch);
    return exp;
}
void _ORMethodNodeSerailization(_ORMethodNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORMethodNodeBaseLength);
    *cursor += _ORMethodNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->declare, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->scopeImp, buffer, cursor);
}
_ORMethodNode *_ORMethodNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORMethodNode *node = malloc(sizeof(_ORMethodNode));
    memcpy(node, buffer + *cursor, _ORMethodNodeBaseLength);
    *cursor += _ORMethodNodeBaseLength;
    node->declare =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORMethodNodeDestroy(_ORMethodNode *node){
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
}_ORClassNode;
static uint32_t _ORClassNodeBaseLength = 1;
_ORClassNode *_ORClassNodeConvert(ORClassNode *exp, _PatchNode *patch, uint32_t *length){
    _ORClassNode *node = malloc(sizeof(_ORClassNode));
    memset(node, 0, sizeof(_ORClassNode));
    node->nodeType = _ORClassNodeType;
    node->className = (_StringNode *)_ORNodeConvert(exp.className, patch, length);
    node->superClassName = (_StringNode *)_ORNodeConvert(exp.superClassName, patch, length);
    node->protocols = (_ListNode *)_ORNodeConvert(exp.protocols, patch, length);
    node->properties = (_ListNode *)_ORNodeConvert(exp.properties, patch, length);
    node->privateVariables = (_ListNode *)_ORNodeConvert(exp.privateVariables, patch, length);
    node->methods = (_ListNode *)_ORNodeConvert(exp.methods, patch, length);
    *length += _ORClassNodeBaseLength;
    return node;
}
ORClassNode *_ORClassNodeDeConvert(_ORClassNode *node, _PatchNode *patch){
    ORClassNode *exp = [ORClassNode new];
    exp.className = (NSString *)_ORNodeDeConvert((_ORNode *)node->className, patch);
    exp.superClassName = (NSString *)_ORNodeDeConvert((_ORNode *)node->superClassName, patch);
    exp.protocols = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->protocols, patch);
    exp.properties = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->properties, patch);
    exp.privateVariables = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->privateVariables, patch);
    exp.methods = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->methods, patch);
    return exp;
}
void _ORClassNodeSerailization(_ORClassNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORClassNodeBaseLength);
    *cursor += _ORClassNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->className, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->superClassName, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->protocols, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->properties, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->privateVariables, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->methods, buffer, cursor);
}
_ORClassNode *_ORClassNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORClassNode *node = malloc(sizeof(_ORClassNode));
    memcpy(node, buffer + *cursor, _ORClassNodeBaseLength);
    *cursor += _ORClassNodeBaseLength;
    node->className =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->superClassName =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->protocols =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->properties =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->privateVariables =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->methods =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORClassNodeDestroy(_ORClassNode *node){
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
}_ORProtocolNode;
static uint32_t _ORProtocolNodeBaseLength = 1;
_ORProtocolNode *_ORProtocolNodeConvert(ORProtocolNode *exp, _PatchNode *patch, uint32_t *length){
    _ORProtocolNode *node = malloc(sizeof(_ORProtocolNode));
    memset(node, 0, sizeof(_ORProtocolNode));
    node->nodeType = _ORProtocolNodeType;
    node->protcolName = (_StringNode *)_ORNodeConvert(exp.protcolName, patch, length);
    node->protocols = (_ListNode *)_ORNodeConvert(exp.protocols, patch, length);
    node->properties = (_ListNode *)_ORNodeConvert(exp.properties, patch, length);
    node->methods = (_ListNode *)_ORNodeConvert(exp.methods, patch, length);
    *length += _ORProtocolNodeBaseLength;
    return node;
}
ORProtocolNode *_ORProtocolNodeDeConvert(_ORProtocolNode *node, _PatchNode *patch){
    ORProtocolNode *exp = [ORProtocolNode new];
    exp.protcolName = (NSString *)_ORNodeDeConvert((_ORNode *)node->protcolName, patch);
    exp.protocols = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->protocols, patch);
    exp.properties = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->properties, patch);
    exp.methods = (NSMutableArray *)_ORNodeDeConvert((_ORNode *)node->methods, patch);
    return exp;
}
void _ORProtocolNodeSerailization(_ORProtocolNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, _ORProtocolNodeBaseLength);
    *cursor += _ORProtocolNodeBaseLength;
    _ORNodeSerailization((_ORNode *)node->protcolName, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->protocols, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->properties, buffer, cursor);
    _ORNodeSerailization((_ORNode *)node->methods, buffer, cursor);
}
_ORProtocolNode *_ORProtocolNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _ORProtocolNode *node = malloc(sizeof(_ORProtocolNode));
    memcpy(node, buffer + *cursor, _ORProtocolNodeBaseLength);
    *cursor += _ORProtocolNodeBaseLength;
    node->protcolName =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->protocols =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->properties =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    node->methods =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void _ORProtocolNodeDestroy(_ORProtocolNode *node){
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
    node->nodeType = _ORStructStatNodeType;
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
    node->nodeType = _ORUnionStatNodeType;
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
    node->nodeType = _OREnumStatNodeType;
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
    node->nodeType = _ORTypedefStatNodeType;
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
    }else if ([exp isKindOfClass:[ORCArrayDeclNode class]]){
        return (_ORNode *)_ORCArrayDeclNodeConvert((ORCArrayDeclNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORFunctionDeclNode class]]){
        return (_ORNode *)_ORFunctionDeclNodeConvert((ORFunctionDeclNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORTypeNode class]]){
        return (_ORNode *)_ORTypeNodeConvert((ORTypeNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORVariableNode class]]){
        return (_ORNode *)_ORVariableNodeConvert((ORVariableNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORDeclaratorNode class]]){
        return (_ORNode *)_ORDeclaratorNodeConvert((ORDeclaratorNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORBlockNode class]]){
        return (_ORNode *)_ORBlockNodeConvert((ORBlockNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORValueNode class]]){
        return (_ORNode *)_ORValueNodeConvert((ORValueNode *)exp, patch, length);
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
    }else if ([exp isKindOfClass:[ORFunctionNode class]]){
        return (_ORNode *)_ORFunctionNodeConvert((ORFunctionNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORSubscriptNode class]]){
        return (_ORNode *)_ORSubscriptNodeConvert((ORSubscriptNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORAssignNode class]]){
        return (_ORNode *)_ORAssignNodeConvert((ORAssignNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORInitDeclaratorNode class]]){
        return (_ORNode *)_ORInitDeclaratorNodeConvert((ORInitDeclaratorNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORUnaryNode class]]){
        return (_ORNode *)_ORUnaryNodeConvert((ORUnaryNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORBinaryNode class]]){
        return (_ORNode *)_ORBinaryNodeConvert((ORBinaryNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORTernaryNode class]]){
        return (_ORNode *)_ORTernaryNodeConvert((ORTernaryNode *)exp, patch, length);
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
    }else if ([exp isKindOfClass:[ORControlStatNode class]]){
        return (_ORNode *)_ORControlStatNodeConvert((ORControlStatNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORPropertyNode class]]){
        return (_ORNode *)_ORPropertyNodeConvert((ORPropertyNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORMethodDeclNode class]]){
        return (_ORNode *)_ORMethodDeclNodeConvert((ORMethodDeclNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORMethodNode class]]){
        return (_ORNode *)_ORMethodNodeConvert((ORMethodNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORClassNode class]]){
        return (_ORNode *)_ORClassNodeConvert((ORClassNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORProtocolNode class]]){
        return (_ORNode *)_ORProtocolNodeConvert((ORProtocolNode *)exp, patch, length);
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
    }else if (node->nodeType == _ORTypeNodeType){
        return (ORNode *)_ORTypeNodeDeConvert((_ORTypeNode *)node, patch);
    }else if (node->nodeType == _ORVariableNodeType){
        return (ORNode *)_ORVariableNodeDeConvert((_ORVariableNode *)node, patch);
    }else if (node->nodeType == _ORDeclaratorNodeType){
        return (ORNode *)_ORDeclaratorNodeDeConvert((_ORDeclaratorNode *)node, patch);
    }else if (node->nodeType == _ORFunctionDeclNodeType){
        return (ORNode *)_ORFunctionDeclNodeDeConvert((_ORFunctionDeclNode *)node, patch);
    }else if (node->nodeType == _ORCArrayDeclNodeType){
        return (ORNode *)_ORCArrayDeclNodeDeConvert((_ORCArrayDeclNode *)node, patch);
    }else if (node->nodeType == _ORBlockNodeType){
        return (ORNode *)_ORBlockNodeDeConvert((_ORBlockNode *)node, patch);
    }else if (node->nodeType == _ORValueNodeType){
        return (ORNode *)_ORValueNodeDeConvert((_ORValueNode *)node, patch);
    }else if (node->nodeType == _ORIntegerValueType){
        return (ORNode *)_ORIntegerValueDeConvert((_ORIntegerValue *)node, patch);
    }else if (node->nodeType == _ORUIntegerValueType){
        return (ORNode *)_ORUIntegerValueDeConvert((_ORUIntegerValue *)node, patch);
    }else if (node->nodeType == _ORDoubleValueType){
        return (ORNode *)_ORDoubleValueDeConvert((_ORDoubleValue *)node, patch);
    }else if (node->nodeType == _ORBoolValueType){
        return (ORNode *)_ORBoolValueDeConvert((_ORBoolValue *)node, patch);
    }else if (node->nodeType == _ORMethodCallType){
        return (ORNode *)_ORMethodCallDeConvert((_ORMethodCall *)node, patch);
    }else if (node->nodeType == _ORFunctionCallType){
        return (ORNode *)_ORFunctionCallDeConvert((_ORFunctionCall *)node, patch);
    }else if (node->nodeType == _ORFunctionNodeType){
        return (ORNode *)_ORFunctionNodeDeConvert((_ORFunctionNode *)node, patch);
    }else if (node->nodeType == _ORSubscriptNodeType){
        return (ORNode *)_ORSubscriptNodeDeConvert((_ORSubscriptNode *)node, patch);
    }else if (node->nodeType == _ORAssignNodeType){
        return (ORNode *)_ORAssignNodeDeConvert((_ORAssignNode *)node, patch);
    }else if (node->nodeType == _ORInitDeclaratorNodeType){
        return (ORNode *)_ORInitDeclaratorNodeDeConvert((_ORInitDeclaratorNode *)node, patch);
    }else if (node->nodeType == _ORUnaryNodeType){
        return (ORNode *)_ORUnaryNodeDeConvert((_ORUnaryNode *)node, patch);
    }else if (node->nodeType == _ORBinaryNodeType){
        return (ORNode *)_ORBinaryNodeDeConvert((_ORBinaryNode *)node, patch);
    }else if (node->nodeType == _ORTernaryNodeType){
        return (ORNode *)_ORTernaryNodeDeConvert((_ORTernaryNode *)node, patch);
    }else if (node->nodeType == _ORIfStatementType){
        return (ORNode *)_ORIfStatementDeConvert((_ORIfStatement *)node, patch);
    }else if (node->nodeType == _ORWhileStatementType){
        return (ORNode *)_ORWhileStatementDeConvert((_ORWhileStatement *)node, patch);
    }else if (node->nodeType == _ORDoWhileStatementType){
        return (ORNode *)_ORDoWhileStatementDeConvert((_ORDoWhileStatement *)node, patch);
    }else if (node->nodeType == _ORCaseStatementType){
        return (ORNode *)_ORCaseStatementDeConvert((_ORCaseStatement *)node, patch);
    }else if (node->nodeType == _ORSwitchStatementType){
        return (ORNode *)_ORSwitchStatementDeConvert((_ORSwitchStatement *)node, patch);
    }else if (node->nodeType == _ORForStatementType){
        return (ORNode *)_ORForStatementDeConvert((_ORForStatement *)node, patch);
    }else if (node->nodeType == _ORForInStatementType){
        return (ORNode *)_ORForInStatementDeConvert((_ORForInStatement *)node, patch);
    }else if (node->nodeType == _ORControlStatNodeType){
        return (ORNode *)_ORControlStatNodeDeConvert((_ORControlStatNode *)node, patch);
    }else if (node->nodeType == _ORPropertyNodeType){
        return (ORNode *)_ORPropertyNodeDeConvert((_ORPropertyNode *)node, patch);
    }else if (node->nodeType == _ORMethodDeclNodeType){
        return (ORNode *)_ORMethodDeclNodeDeConvert((_ORMethodDeclNode *)node, patch);
    }else if (node->nodeType == _ORMethodNodeType){
        return (ORNode *)_ORMethodNodeDeConvert((_ORMethodNode *)node, patch);
    }else if (node->nodeType == _ORClassNodeType){
        return (ORNode *)_ORClassNodeDeConvert((_ORClassNode *)node, patch);
    }else if (node->nodeType == _ORProtocolNodeType){
        return (ORNode *)_ORProtocolNodeDeConvert((_ORProtocolNode *)node, patch);
    }else if (node->nodeType == _ORStructStatNodeType){
        return (ORNode *)_ORStructStatNodeDeConvert((_ORStructStatNode *)node, patch);
    }else if (node->nodeType == _ORUnionStatNodeType){
        return (ORNode *)_ORUnionStatNodeDeConvert((_ORUnionStatNode *)node, patch);
    }else if (node->nodeType == _OREnumStatNodeType){
        return (ORNode *)_OREnumStatNodeDeConvert((_OREnumStatNode *)node, patch);
    }else if (node->nodeType == _ORTypedefStatNodeType){
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
    }else if (node->nodeType == _ORTypeNodeType){
        _ORTypeNodeSerailization((_ORTypeNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORVariableNodeType){
        _ORVariableNodeSerailization((_ORVariableNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORDeclaratorNodeType){
        _ORDeclaratorNodeSerailization((_ORDeclaratorNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORFunctionDeclNodeType){
        _ORFunctionDeclNodeSerailization((_ORFunctionDeclNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORCArrayDeclNodeType){
        _ORCArrayDeclNodeSerailization((_ORCArrayDeclNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORBlockNodeType){
        _ORBlockNodeSerailization((_ORBlockNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORValueNodeType){
        _ORValueNodeSerailization((_ORValueNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORIntegerValueType){
        _ORIntegerValueSerailization((_ORIntegerValue *)node, buffer, cursor);
    }else if (node->nodeType == _ORUIntegerValueType){
        _ORUIntegerValueSerailization((_ORUIntegerValue *)node, buffer, cursor);
    }else if (node->nodeType == _ORDoubleValueType){
        _ORDoubleValueSerailization((_ORDoubleValue *)node, buffer, cursor);
    }else if (node->nodeType == _ORBoolValueType){
        _ORBoolValueSerailization((_ORBoolValue *)node, buffer, cursor);
    }else if (node->nodeType == _ORMethodCallType){
        _ORMethodCallSerailization((_ORMethodCall *)node, buffer, cursor);
    }else if (node->nodeType == _ORFunctionCallType){
        _ORFunctionCallSerailization((_ORFunctionCall *)node, buffer, cursor);
    }else if (node->nodeType == _ORFunctionNodeType){
        _ORFunctionNodeSerailization((_ORFunctionNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORSubscriptNodeType){
        _ORSubscriptNodeSerailization((_ORSubscriptNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORAssignNodeType){
        _ORAssignNodeSerailization((_ORAssignNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORInitDeclaratorNodeType){
        _ORInitDeclaratorNodeSerailization((_ORInitDeclaratorNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORUnaryNodeType){
        _ORUnaryNodeSerailization((_ORUnaryNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORBinaryNodeType){
        _ORBinaryNodeSerailization((_ORBinaryNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORTernaryNodeType){
        _ORTernaryNodeSerailization((_ORTernaryNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORIfStatementType){
        _ORIfStatementSerailization((_ORIfStatement *)node, buffer, cursor);
    }else if (node->nodeType == _ORWhileStatementType){
        _ORWhileStatementSerailization((_ORWhileStatement *)node, buffer, cursor);
    }else if (node->nodeType == _ORDoWhileStatementType){
        _ORDoWhileStatementSerailization((_ORDoWhileStatement *)node, buffer, cursor);
    }else if (node->nodeType == _ORCaseStatementType){
        _ORCaseStatementSerailization((_ORCaseStatement *)node, buffer, cursor);
    }else if (node->nodeType == _ORSwitchStatementType){
        _ORSwitchStatementSerailization((_ORSwitchStatement *)node, buffer, cursor);
    }else if (node->nodeType == _ORForStatementType){
        _ORForStatementSerailization((_ORForStatement *)node, buffer, cursor);
    }else if (node->nodeType == _ORForInStatementType){
        _ORForInStatementSerailization((_ORForInStatement *)node, buffer, cursor);
    }else if (node->nodeType == _ORControlStatNodeType){
        _ORControlStatNodeSerailization((_ORControlStatNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORPropertyNodeType){
        _ORPropertyNodeSerailization((_ORPropertyNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORMethodDeclNodeType){
        _ORMethodDeclNodeSerailization((_ORMethodDeclNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORMethodNodeType){
        _ORMethodNodeSerailization((_ORMethodNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORClassNodeType){
        _ORClassNodeSerailization((_ORClassNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORProtocolNodeType){
        _ORProtocolNodeSerailization((_ORProtocolNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORStructStatNodeType){
        _ORStructStatNodeSerailization((_ORStructStatNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORUnionStatNodeType){
        _ORUnionStatNodeSerailization((_ORUnionStatNode *)node, buffer, cursor);
    }else if (node->nodeType == _OREnumStatNodeType){
        _OREnumStatNodeSerailization((_OREnumStatNode *)node, buffer, cursor);
    }else if (node->nodeType == _ORTypedefStatNodeType){
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
    }else if (nodeType == _ORTypeNodeType){
        return (_ORNode *)_ORTypeNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORVariableNodeType){
        return (_ORNode *)_ORVariableNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORDeclaratorNodeType){
        return (_ORNode *)_ORDeclaratorNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORFunctionDeclNodeType){
        return (_ORNode *)_ORFunctionDeclNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORCArrayDeclNodeType){
        return (_ORNode *)_ORCArrayDeclNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORBlockNodeType){
        return (_ORNode *)_ORBlockNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORValueNodeType){
        return (_ORNode *)_ORValueNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORIntegerValueType){
        return (_ORNode *)_ORIntegerValueDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORUIntegerValueType){
        return (_ORNode *)_ORUIntegerValueDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORDoubleValueType){
        return (_ORNode *)_ORDoubleValueDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORBoolValueType){
        return (_ORNode *)_ORBoolValueDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORMethodCallType){
        return (_ORNode *)_ORMethodCallDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORFunctionCallType){
        return (_ORNode *)_ORFunctionCallDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORFunctionNodeType){
        return (_ORNode *)_ORFunctionNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORSubscriptNodeType){
        return (_ORNode *)_ORSubscriptNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORAssignNodeType){
        return (_ORNode *)_ORAssignNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORInitDeclaratorNodeType){
        return (_ORNode *)_ORInitDeclaratorNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORUnaryNodeType){
        return (_ORNode *)_ORUnaryNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORBinaryNodeType){
        return (_ORNode *)_ORBinaryNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORTernaryNodeType){
        return (_ORNode *)_ORTernaryNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORIfStatementType){
        return (_ORNode *)_ORIfStatementDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORWhileStatementType){
        return (_ORNode *)_ORWhileStatementDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORDoWhileStatementType){
        return (_ORNode *)_ORDoWhileStatementDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORCaseStatementType){
        return (_ORNode *)_ORCaseStatementDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORSwitchStatementType){
        return (_ORNode *)_ORSwitchStatementDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORForStatementType){
        return (_ORNode *)_ORForStatementDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORForInStatementType){
        return (_ORNode *)_ORForInStatementDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORControlStatNodeType){
        return (_ORNode *)_ORControlStatNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORPropertyNodeType){
        return (_ORNode *)_ORPropertyNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORMethodDeclNodeType){
        return (_ORNode *)_ORMethodDeclNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORMethodNodeType){
        return (_ORNode *)_ORMethodNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORClassNodeType){
        return (_ORNode *)_ORClassNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORProtocolNodeType){
        return (_ORNode *)_ORProtocolNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORStructStatNodeType){
        return (_ORNode *)_ORStructStatNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORUnionStatNodeType){
        return (_ORNode *)_ORUnionStatNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _OREnumStatNodeType){
        return (_ORNode *)_OREnumStatNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == _ORTypedefStatNodeType){
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
    }else if (node->nodeType == _ORTypeNodeType){
        _ORTypeNodeDestroy((_ORTypeNode *)node);
    }else if (node->nodeType == _ORVariableNodeType){
        _ORVariableNodeDestroy((_ORVariableNode *)node);
    }else if (node->nodeType == _ORDeclaratorNodeType){
        _ORDeclaratorNodeDestroy((_ORDeclaratorNode *)node);
    }else if (node->nodeType == _ORFunctionDeclNodeType){
        _ORFunctionDeclNodeDestroy((_ORFunctionDeclNode *)node);
    }else if (node->nodeType == _ORCArrayDeclNodeType){
        _ORCArrayDeclNodeDestroy((_ORCArrayDeclNode *)node);
    }else if (node->nodeType == _ORBlockNodeType){
        _ORBlockNodeDestroy((_ORBlockNode *)node);
    }else if (node->nodeType == _ORValueNodeType){
        _ORValueNodeDestroy((_ORValueNode *)node);
    }else if (node->nodeType == _ORIntegerValueType){
        _ORIntegerValueDestroy((_ORIntegerValue *)node);
    }else if (node->nodeType == _ORUIntegerValueType){
        _ORUIntegerValueDestroy((_ORUIntegerValue *)node);
    }else if (node->nodeType == _ORDoubleValueType){
        _ORDoubleValueDestroy((_ORDoubleValue *)node);
    }else if (node->nodeType == _ORBoolValueType){
        _ORBoolValueDestroy((_ORBoolValue *)node);
    }else if (node->nodeType == _ORMethodCallType){
        _ORMethodCallDestroy((_ORMethodCall *)node);
    }else if (node->nodeType == _ORFunctionCallType){
        _ORFunctionCallDestroy((_ORFunctionCall *)node);
    }else if (node->nodeType == _ORFunctionNodeType){
        _ORFunctionNodeDestroy((_ORFunctionNode *)node);
    }else if (node->nodeType == _ORSubscriptNodeType){
        _ORSubscriptNodeDestroy((_ORSubscriptNode *)node);
    }else if (node->nodeType == _ORAssignNodeType){
        _ORAssignNodeDestroy((_ORAssignNode *)node);
    }else if (node->nodeType == _ORInitDeclaratorNodeType){
        _ORInitDeclaratorNodeDestroy((_ORInitDeclaratorNode *)node);
    }else if (node->nodeType == _ORUnaryNodeType){
        _ORUnaryNodeDestroy((_ORUnaryNode *)node);
    }else if (node->nodeType == _ORBinaryNodeType){
        _ORBinaryNodeDestroy((_ORBinaryNode *)node);
    }else if (node->nodeType == _ORTernaryNodeType){
        _ORTernaryNodeDestroy((_ORTernaryNode *)node);
    }else if (node->nodeType == _ORIfStatementType){
        _ORIfStatementDestroy((_ORIfStatement *)node);
    }else if (node->nodeType == _ORWhileStatementType){
        _ORWhileStatementDestroy((_ORWhileStatement *)node);
    }else if (node->nodeType == _ORDoWhileStatementType){
        _ORDoWhileStatementDestroy((_ORDoWhileStatement *)node);
    }else if (node->nodeType == _ORCaseStatementType){
        _ORCaseStatementDestroy((_ORCaseStatement *)node);
    }else if (node->nodeType == _ORSwitchStatementType){
        _ORSwitchStatementDestroy((_ORSwitchStatement *)node);
    }else if (node->nodeType == _ORForStatementType){
        _ORForStatementDestroy((_ORForStatement *)node);
    }else if (node->nodeType == _ORForInStatementType){
        _ORForInStatementDestroy((_ORForInStatement *)node);
    }else if (node->nodeType == _ORControlStatNodeType){
        _ORControlStatNodeDestroy((_ORControlStatNode *)node);
    }else if (node->nodeType == _ORPropertyNodeType){
        _ORPropertyNodeDestroy((_ORPropertyNode *)node);
    }else if (node->nodeType == _ORMethodDeclNodeType){
        _ORMethodDeclNodeDestroy((_ORMethodDeclNode *)node);
    }else if (node->nodeType == _ORMethodNodeType){
        _ORMethodNodeDestroy((_ORMethodNode *)node);
    }else if (node->nodeType == _ORClassNodeType){
        _ORClassNodeDestroy((_ORClassNode *)node);
    }else if (node->nodeType == _ORProtocolNodeType){
        _ORProtocolNodeDestroy((_ORProtocolNode *)node);
    }else if (node->nodeType == _ORStructStatNodeType){
        _ORStructStatNodeDestroy((_ORStructStatNode *)node);
    }else if (node->nodeType == _ORUnionStatNodeType){
        _ORUnionStatNodeDestroy((_ORUnionStatNode *)node);
    }else if (node->nodeType == _OREnumStatNodeType){
        _OREnumStatNodeDestroy((_OREnumStatNode *)node);
    }else if (node->nodeType == _ORTypedefStatNodeType){
        _ORTypedefStatNodeDestroy((_ORTypedefStatNode *)node);
    }
}
