//  BinaryPatchHelper.m
//  Generate By BinaryPatchGenerator
//  Created by Jiang on 1626333610
//  Copyright © 2020 SilverFruity. All rights reserved.
#import "BinaryPatchHelper.h"
#import "ORPatchFile.h"

AstEmptyNode *AstNodeConvert(id exp, AstPatchFile *patch, uint32_t *length);
id AstNodeDeConvert(ORNode *parent, AstEmptyNode *node, AstPatchFile *patch);

#pragma mark - Base Data Struct

AstNodeList *AstNodeListConvert(NSArray *array, AstPatchFile *patch, uint32_t *length){
    AstNodeList *node = malloc(sizeof(AstNodeList));
    memset(node, 0, sizeof(AstNodeList));
    node->nodes = malloc(sizeof(void *) * array.count);
    node->nodeType = AstEnumListNode;
    *length += AstNodeListBaseLength;
    for (id object in array) {
        AstEmptyNode *element = AstNodeConvert(object, patch, length);;
        node->nodes[node->count] = element;
        node->count++;
    }
    return node;
}

NSMutableArray *AstNodeListDeConvert(ORNode *parent,AstNodeList *node, AstPatchFile *patch){
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < node->count; i++) {
        id result = AstNodeDeConvert(parent, node->nodes[i], patch);
        [array addObject:result];
    }
    return array;
}

static NSMutableDictionary *_stringMap = nil;
AstStringCursor *createStringCursor(NSString *string, AstPatchFile *patch, uint32_t *length){
    AstStringCursor * strNode = malloc(sizeof(AstStringCursor));
    memset(strNode, 0, sizeof(AstStringCursor));
    const char *str = string.UTF8String;
    size_t len = strlen(str);
    strNode->strLen = (unsigned int)len;
    strNode->nodeType = AstEnumStringCursorNode;
    *length += AstStringCursorBaseLength;
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

NSString *getNSStringWithStringCursor(AstStringCursor *node, AstPatchFile *patch){
    char *cursor = patch->strings->buffer + node->offset;
    char *buffer = alloca(node->strLen + 1);
    memcpy(buffer, cursor, node->strLen);
    buffer[node->strLen] = '\0';
    return [NSString stringWithUTF8String:buffer];
}

AstPatchFile *AstPatchFileConvert(ORPatchFile *patch, uint32_t *length){
    _stringMap = [NSMutableDictionary dictionary];
    AstPatchFile *node = malloc(sizeof(AstPatchFile));
    memset(node, 0, sizeof(AstPatchFile));
    *length += AstPatchFileBaseLength;

    node->strings = malloc(sizeof(AstStringBufferNode));
    memset(node->strings, 0, sizeof(AstStringBufferNode));
    node->strings->nodeType = AstEnumStringBufferNode;
    *length += AstStringBufferNodeBaseLength;
    
    node->nodeType = AstEnumPatchFile;
    node->enable = patch.enable;
    node->appVersion = (AstStringCursor *)AstNodeConvert(patch.appVersion, node, length);
    node->osVersion = (AstStringCursor *)AstNodeConvert(patch.patchInternalVersion, node, length);
    node->nodes = (AstNodeList *)AstNodeConvert(patch.nodes, node, length);
    return node;
}

ORPatchFile *AstPatchFileDeConvert(AstPatchFile *patch){
    ORPatchFile *file = [ORPatchFile new];
    file.appVersion = AstNodeDeConvert(nil, (AstEmptyNode *)patch->appVersion, patch);
    file.patchInternalVersion = AstNodeDeConvert(nil, (AstEmptyNode *)patch->osVersion, patch);
    file.enable = patch->enable;
    NSMutableArray *nodes = [NSMutableArray array];
    for (int i = 0; i < patch->nodes->count; i++) {
        [nodes addObject:AstNodeDeConvert(nil, patch->nodes->nodes[i], patch)];
    }
    file.nodes = nodes;
    return file;
}

void AstNodeSerailization(AstEmptyNode *node, void *buffer, uint32_t *cursor);
void AstStringCursorSerailization(AstStringCursor *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstStringCursorBaseLength);
    *cursor += AstStringCursorBaseLength;
}
void AstNodeListSerailization(AstNodeList *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstNodeListBaseLength);
    *cursor += AstNodeListBaseLength;
    for (int i = 0; i < node->count; i++) {
        AstNodeSerailization(node->nodes[i], buffer, cursor);
    }
}
void AstStringBufferNodeSerailization(AstStringBufferNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstStringBufferNodeBaseLength);
    *cursor += AstStringBufferNodeBaseLength;
    char *dst = buffer + *cursor;
    memcpy(dst, node->buffer, node->cursor);
    // encrypt
    for (uint32_t i = 0; i < node->cursor; i++) dst[i] ^= 'A';
    *cursor += node->cursor;
}
void AstPatchFileSerialization(AstPatchFile *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstPatchFileBaseLength);
    *cursor += AstPatchFileBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->strings, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->appVersion, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->osVersion, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->nodes, buffer, cursor);
}

AstEmptyNode *AstNodeDeserialization(void *buffer, uint32_t *cursor,uint32_t bufferLength);
AstStringCursor * AstStringCursorDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstStringCursor *node = malloc(sizeof(AstStringCursor));
    memcpy(node, buffer + *cursor, AstStringCursorBaseLength);
    *cursor += AstStringCursorBaseLength;
    return node;
}
AstNodeList *AstNodeListDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstNodeList *node = malloc(sizeof(AstNodeList));
    memcpy(node, buffer + *cursor, AstNodeListBaseLength);
    *cursor += AstNodeListBaseLength;
    node->nodes = malloc(sizeof(void *) * node->count);
    for (int i = 0; i < node->count; i++) {
        node->nodes[i] = AstNodeDeserialization(buffer, cursor, bufferLength);
    }
    return node;
}
AstStringBufferNode *AstStringBufferNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstStringBufferNode *node = malloc(sizeof(AstStringBufferNode));
    memcpy(node, buffer + *cursor, AstStringBufferNodeBaseLength);
    *cursor += AstStringBufferNodeBaseLength;
    node->buffer = malloc(node->cursor);
    memcpy(node->buffer, buffer + *cursor, node->cursor);
    // decrypt
    for (uint32_t i = 0; i < node->cursor; i++) node->buffer[i] ^= 'A';
    *cursor += node->cursor;
    return node;
}
ORPatchFile *AstPatchFileGenerateCheckFile(void *buffer, uint32_t bufferLength){
    uint32_t cursor = 0;
    AstPatchFile *node = malloc(sizeof(AstPatchFile));
    memcpy(node, buffer + cursor, AstPatchFileBaseLength);
    cursor += AstPatchFileBaseLength;
    node->strings = (AstStringBufferNode *)AstStringBufferNodeDeserialization(buffer, &cursor, bufferLength);
    node->appVersion = (AstStringCursor *)AstNodeDeserialization(buffer, &cursor, bufferLength);
    node->osVersion = (AstStringCursor *)AstNodeDeserialization(buffer, &cursor, bufferLength);
    node->nodes = NULL;
    ORPatchFile *file = [ORPatchFile new];
    file.appVersion = getNSStringWithStringCursor(node->appVersion, node);
    file.patchInternalVersion = getNSStringWithStringCursor(node->osVersion, node);
    file.enable = node->enable;
    AstPatchFileDestroy(node);
    return file;
}
AstPatchFile *AstPatchFileDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstPatchFile *node = malloc(sizeof(AstPatchFile));
    memcpy(node, buffer + *cursor, AstPatchFileBaseLength);
    *cursor += AstPatchFileBaseLength;
    node->strings = (AstStringBufferNode *)AstStringBufferNodeDeserialization(buffer, cursor, bufferLength);
    node->appVersion = (AstStringCursor *)AstNodeDeserialization(buffer, cursor, bufferLength);
    node->osVersion = (AstStringCursor *)AstNodeDeserialization(buffer, cursor, bufferLength);
    node->nodes = (AstNodeList *)AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstNodeDestroy(AstEmptyNode *node);
void AstStringCursorDestroy(AstStringCursor *node){
    free(node);
}
void AstNodeListDestroy(AstNodeList *node){
    for (int i = 0; i < node->count; i++) {
         AstNodeDestroy(node->nodes[i]);
    }
    free(node);
}
void AstStringBufferNodeDestroy(AstStringBufferNode *node){
    free(node->buffer);
    free(node);
}
void AstPatchFileDestroy(AstPatchFile *node){
    AstNodeDestroy((AstEmptyNode *)node->strings);
    AstNodeDestroy((AstEmptyNode *)node->appVersion);
    AstNodeDestroy((AstEmptyNode *)node->osVersion);
    AstNodeDestroy((AstEmptyNode *)node->nodes);
    free(node);
}

#pragma mark - Struct BaseLength
static uint32_t AstTypeNodeBaseLength = 9;
static uint32_t AstVariableNodeBaseLength = 3;
static uint32_t AstDeclaratorNodeBaseLength = 1;
static uint32_t AstFunctionDeclNodeBaseLength = 2;
static uint32_t AstCArrayDeclNodeBaseLength = 1;
static uint32_t AstBlockNodeBaseLength = 1;
static uint32_t AstValueNodeBaseLength = 5;
static uint32_t AstIntegerValueBaseLength = 9;
static uint32_t AstUIntegerValueBaseLength = 9;
static uint32_t AstDoubleValueBaseLength = 9;
static uint32_t AstBoolValueBaseLength = 2;
static uint32_t AstMethodCallBaseLength = 3;
static uint32_t AstFunctionCallBaseLength = 1;
static uint32_t AstFunctionNodeBaseLength = 1;
static uint32_t AstSubscriptNodeBaseLength = 1;
static uint32_t AstAssignNodeBaseLength = 5;
static uint32_t AstInitDeclaratorNodeBaseLength = 1;
static uint32_t AstUnaryNodeBaseLength = 5;
static uint32_t AstBinaryNodeBaseLength = 5;
static uint32_t AstTernaryNodeBaseLength = 1;
static uint32_t AstIfStatementBaseLength = 1;
static uint32_t AstWhileStatementBaseLength = 1;
static uint32_t AstDoWhileStatementBaseLength = 1;
static uint32_t AstCaseStatementBaseLength = 1;
static uint32_t AstSwitchStatementBaseLength = 1;
static uint32_t AstForStatementBaseLength = 1;
static uint32_t AstForInStatementBaseLength = 1;
static uint32_t AstControlStatNodeBaseLength = 9;
static uint32_t AstPropertyNodeBaseLength = 1;
static uint32_t AstMethodDeclNodeBaseLength = 2;
static uint32_t AstMethodNodeBaseLength = 1;
static uint32_t AstClassNodeBaseLength = 1;
static uint32_t AstProtocolNodeBaseLength = 1;
static uint32_t AstStructStatNodeBaseLength = 1;
static uint32_t AstUnionStatNodeBaseLength = 1;
static uint32_t AstEnumStatNodeBaseLength = 5;
static uint32_t AstTypedefStatNodeBaseLength = 1;

#pragma mark - Class Convert To Struct
AstTypeNode *AstTypeNodeConvert(ORTypeNode *exp, AstPatchFile *patch, uint32_t *length){
    AstTypeNode *node = malloc(sizeof(AstTypeNode));
    memset(node, 0, sizeof(AstTypeNode));
    node->nodeType = AstEnumTypeNode;
    node->type = exp.type;
    node->modifier = exp.modifier;
    node->name = (AstStringCursor *)AstNodeConvert(exp.name, patch, length);
    *length += AstTypeNodeBaseLength;
    return node;
}
AstVariableNode *AstVariableNodeConvert(ORVariableNode *exp, AstPatchFile *patch, uint32_t *length){
    AstVariableNode *node = malloc(sizeof(AstVariableNode));
    memset(node, 0, sizeof(AstVariableNode));
    node->nodeType = AstEnumVariableNode;
    node->isBlock = exp.isBlock;
    node->ptCount = exp.ptCount;
    node->varname = (AstStringCursor *)AstNodeConvert(exp.varname, patch, length);
    *length += AstVariableNodeBaseLength;
    return node;
}
AstDeclaratorNode *AstDeclaratorNodeConvert(ORDeclaratorNode *exp, AstPatchFile *patch, uint32_t *length){
    AstDeclaratorNode *node = malloc(sizeof(AstDeclaratorNode));
    memset(node, 0, sizeof(AstDeclaratorNode));
    node->nodeType = AstEnumDeclaratorNode;
    node->type = (AstEmptyNode *)AstNodeConvert(exp.type, patch, length);
    node->var = (AstEmptyNode *)AstNodeConvert(exp.var, patch, length);
    *length += AstDeclaratorNodeBaseLength;
    return node;
}
AstFunctionDeclNode *AstFunctionDeclNodeConvert(ORFunctionDeclNode *exp, AstPatchFile *patch, uint32_t *length){
    AstFunctionDeclNode *node = malloc(sizeof(AstFunctionDeclNode));
    memset(node, 0, sizeof(AstFunctionDeclNode));
    node->nodeType = AstEnumFunctionDeclNode;
    node->type = (AstEmptyNode *)AstNodeConvert(exp.type, patch, length);
    node->var = (AstEmptyNode *)AstNodeConvert(exp.var, patch, length);
    node->isMultiArgs = exp.isMultiArgs;
    node->params = (AstNodeList *)AstNodeConvert(exp.params, patch, length);
    *length += AstFunctionDeclNodeBaseLength;
    return node;
}
AstCArrayDeclNode *AstCArrayDeclNodeConvert(ORCArrayDeclNode *exp, AstPatchFile *patch, uint32_t *length){
    AstCArrayDeclNode *node = malloc(sizeof(AstCArrayDeclNode));
    memset(node, 0, sizeof(AstCArrayDeclNode));
    node->nodeType = AstEnumCArrayDeclNode;
    node->type = (AstEmptyNode *)AstNodeConvert(exp.type, patch, length);
    node->var = (AstEmptyNode *)AstNodeConvert(exp.var, patch, length);
    node->prev = (AstEmptyNode *)AstNodeConvert(exp.prev, patch, length);
    node->capacity = (AstEmptyNode *)AstNodeConvert(exp.capacity, patch, length);
    *length += AstCArrayDeclNodeBaseLength;
    return node;
}
AstBlockNode *AstBlockNodeConvert(ORBlockNode *exp, AstPatchFile *patch, uint32_t *length){
    AstBlockNode *node = malloc(sizeof(AstBlockNode));
    memset(node, 0, sizeof(AstBlockNode));
    node->nodeType = AstEnumBlockNode;
    node->statements = (AstNodeList *)AstNodeConvert(exp.statements, patch, length);
    *length += AstBlockNodeBaseLength;
    return node;
}
AstValueNode *AstValueNodeConvert(ORValueNode *exp, AstPatchFile *patch, uint32_t *length){
    AstValueNode *node = malloc(sizeof(AstValueNode));
    memset(node, 0, sizeof(AstValueNode));
    node->nodeType = AstEnumValueNode;
    node->value_type = exp.value_type;
    node->value = (AstEmptyNode *)AstNodeConvert(exp.value, patch, length);
    *length += AstValueNodeBaseLength;
    return node;
}
AstIntegerValue *AstIntegerValueConvert(ORIntegerValue *exp, AstPatchFile *patch, uint32_t *length){
    AstIntegerValue *node = malloc(sizeof(AstIntegerValue));
    memset(node, 0, sizeof(AstIntegerValue));
    node->nodeType = AstEnumIntegerValue;
    node->value = exp.value;
    *length += AstIntegerValueBaseLength;
    return node;
}
AstUIntegerValue *AstUIntegerValueConvert(ORUIntegerValue *exp, AstPatchFile *patch, uint32_t *length){
    AstUIntegerValue *node = malloc(sizeof(AstUIntegerValue));
    memset(node, 0, sizeof(AstUIntegerValue));
    node->nodeType = AstEnumUIntegerValue;
    node->value = exp.value;
    *length += AstUIntegerValueBaseLength;
    return node;
}
AstDoubleValue *AstDoubleValueConvert(ORDoubleValue *exp, AstPatchFile *patch, uint32_t *length){
    AstDoubleValue *node = malloc(sizeof(AstDoubleValue));
    memset(node, 0, sizeof(AstDoubleValue));
    node->nodeType = AstEnumDoubleValue;
    node->value = exp.value;
    *length += AstDoubleValueBaseLength;
    return node;
}
AstBoolValue *AstBoolValueConvert(ORBoolValue *exp, AstPatchFile *patch, uint32_t *length){
    AstBoolValue *node = malloc(sizeof(AstBoolValue));
    memset(node, 0, sizeof(AstBoolValue));
    node->nodeType = AstEnumBoolValue;
    node->value = exp.value;
    *length += AstBoolValueBaseLength;
    return node;
}
AstMethodCall *AstMethodCallConvert(ORMethodCall *exp, AstPatchFile *patch, uint32_t *length){
    AstMethodCall *node = malloc(sizeof(AstMethodCall));
    memset(node, 0, sizeof(AstMethodCall));
    node->nodeType = AstEnumMethodCall;
    node->methodOperator = exp.methodOperator;
    node->isStructRef = exp.isStructRef;
    node->caller = (AstEmptyNode *)AstNodeConvert(exp.caller, patch, length);
    node->selectorName = (AstStringCursor *)AstNodeConvert(exp.selectorName, patch, length);
    node->values = (AstNodeList *)AstNodeConvert(exp.values, patch, length);
    *length += AstMethodCallBaseLength;
    return node;
}
AstFunctionCall *AstFunctionCallConvert(ORFunctionCall *exp, AstPatchFile *patch, uint32_t *length){
    AstFunctionCall *node = malloc(sizeof(AstFunctionCall));
    memset(node, 0, sizeof(AstFunctionCall));
    node->nodeType = AstEnumFunctionCall;
    node->caller = (AstEmptyNode *)AstNodeConvert(exp.caller, patch, length);
    node->expressions = (AstNodeList *)AstNodeConvert(exp.expressions, patch, length);
    *length += AstFunctionCallBaseLength;
    return node;
}
AstFunctionNode *AstFunctionNodeConvert(ORFunctionNode *exp, AstPatchFile *patch, uint32_t *length){
    AstFunctionNode *node = malloc(sizeof(AstFunctionNode));
    memset(node, 0, sizeof(AstFunctionNode));
    node->nodeType = AstEnumFunctionNode;
    node->declare = (AstEmptyNode *)AstNodeConvert(exp.declare, patch, length);
    node->scopeImp = (AstEmptyNode *)AstNodeConvert(exp.scopeImp, patch, length);
    *length += AstFunctionNodeBaseLength;
    return node;
}
AstSubscriptNode *AstSubscriptNodeConvert(ORSubscriptNode *exp, AstPatchFile *patch, uint32_t *length){
    AstSubscriptNode *node = malloc(sizeof(AstSubscriptNode));
    memset(node, 0, sizeof(AstSubscriptNode));
    node->nodeType = AstEnumSubscriptNode;
    node->caller = (AstEmptyNode *)AstNodeConvert(exp.caller, patch, length);
    node->keyExp = (AstEmptyNode *)AstNodeConvert(exp.keyExp, patch, length);
    *length += AstSubscriptNodeBaseLength;
    return node;
}
AstAssignNode *AstAssignNodeConvert(ORAssignNode *exp, AstPatchFile *patch, uint32_t *length){
    AstAssignNode *node = malloc(sizeof(AstAssignNode));
    memset(node, 0, sizeof(AstAssignNode));
    node->nodeType = AstEnumAssignNode;
    node->assignType = exp.assignType;
    node->value = (AstEmptyNode *)AstNodeConvert(exp.value, patch, length);
    node->expression = (AstEmptyNode *)AstNodeConvert(exp.expression, patch, length);
    *length += AstAssignNodeBaseLength;
    return node;
}
AstInitDeclaratorNode *AstInitDeclaratorNodeConvert(ORInitDeclaratorNode *exp, AstPatchFile *patch, uint32_t *length){
    AstInitDeclaratorNode *node = malloc(sizeof(AstInitDeclaratorNode));
    memset(node, 0, sizeof(AstInitDeclaratorNode));
    node->nodeType = AstEnumInitDeclaratorNode;
    node->declarator = (AstEmptyNode *)AstNodeConvert(exp.declarator, patch, length);
    node->expression = (AstEmptyNode *)AstNodeConvert(exp.expression, patch, length);
    *length += AstInitDeclaratorNodeBaseLength;
    return node;
}
AstUnaryNode *AstUnaryNodeConvert(ORUnaryNode *exp, AstPatchFile *patch, uint32_t *length){
    AstUnaryNode *node = malloc(sizeof(AstUnaryNode));
    memset(node, 0, sizeof(AstUnaryNode));
    node->nodeType = AstEnumUnaryNode;
    node->operatorType = exp.operatorType;
    node->value = (AstEmptyNode *)AstNodeConvert(exp.value, patch, length);
    *length += AstUnaryNodeBaseLength;
    return node;
}
AstBinaryNode *AstBinaryNodeConvert(ORBinaryNode *exp, AstPatchFile *patch, uint32_t *length){
    AstBinaryNode *node = malloc(sizeof(AstBinaryNode));
    memset(node, 0, sizeof(AstBinaryNode));
    node->nodeType = AstEnumBinaryNode;
    node->operatorType = exp.operatorType;
    node->left = (AstEmptyNode *)AstNodeConvert(exp.left, patch, length);
    node->right = (AstEmptyNode *)AstNodeConvert(exp.right, patch, length);
    *length += AstBinaryNodeBaseLength;
    return node;
}
AstTernaryNode *AstTernaryNodeConvert(ORTernaryNode *exp, AstPatchFile *patch, uint32_t *length){
    AstTernaryNode *node = malloc(sizeof(AstTernaryNode));
    memset(node, 0, sizeof(AstTernaryNode));
    node->nodeType = AstEnumTernaryNode;
    node->expression = (AstEmptyNode *)AstNodeConvert(exp.expression, patch, length);
    node->values = (AstNodeList *)AstNodeConvert(exp.values, patch, length);
    *length += AstTernaryNodeBaseLength;
    return node;
}
AstIfStatement *AstIfStatementConvert(ORIfStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstIfStatement *node = malloc(sizeof(AstIfStatement));
    memset(node, 0, sizeof(AstIfStatement));
    node->nodeType = AstEnumIfStatement;
    node->condition = (AstEmptyNode *)AstNodeConvert(exp.condition, patch, length);
    node->scopeImp = (AstEmptyNode *)AstNodeConvert(exp.scopeImp, patch, length);
    node->statements = (AstNodeList *)AstNodeConvert(exp.statements, patch, length);
    *length += AstIfStatementBaseLength;
    return node;
}
AstWhileStatement *AstWhileStatementConvert(ORWhileStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstWhileStatement *node = malloc(sizeof(AstWhileStatement));
    memset(node, 0, sizeof(AstWhileStatement));
    node->nodeType = AstEnumWhileStatement;
    node->condition = (AstEmptyNode *)AstNodeConvert(exp.condition, patch, length);
    node->scopeImp = (AstEmptyNode *)AstNodeConvert(exp.scopeImp, patch, length);
    *length += AstWhileStatementBaseLength;
    return node;
}
AstDoWhileStatement *AstDoWhileStatementConvert(ORDoWhileStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstDoWhileStatement *node = malloc(sizeof(AstDoWhileStatement));
    memset(node, 0, sizeof(AstDoWhileStatement));
    node->nodeType = AstEnumDoWhileStatement;
    node->condition = (AstEmptyNode *)AstNodeConvert(exp.condition, patch, length);
    node->scopeImp = (AstEmptyNode *)AstNodeConvert(exp.scopeImp, patch, length);
    *length += AstDoWhileStatementBaseLength;
    return node;
}
AstCaseStatement *AstCaseStatementConvert(ORCaseStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstCaseStatement *node = malloc(sizeof(AstCaseStatement));
    memset(node, 0, sizeof(AstCaseStatement));
    node->nodeType = AstEnumCaseStatement;
    node->value = (AstEmptyNode *)AstNodeConvert(exp.value, patch, length);
    node->scopeImp = (AstEmptyNode *)AstNodeConvert(exp.scopeImp, patch, length);
    *length += AstCaseStatementBaseLength;
    return node;
}
AstSwitchStatement *AstSwitchStatementConvert(ORSwitchStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstSwitchStatement *node = malloc(sizeof(AstSwitchStatement));
    memset(node, 0, sizeof(AstSwitchStatement));
    node->nodeType = AstEnumSwitchStatement;
    node->value = (AstEmptyNode *)AstNodeConvert(exp.value, patch, length);
    node->cases = (AstNodeList *)AstNodeConvert(exp.cases, patch, length);
    *length += AstSwitchStatementBaseLength;
    return node;
}
AstForStatement *AstForStatementConvert(ORForStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstForStatement *node = malloc(sizeof(AstForStatement));
    memset(node, 0, sizeof(AstForStatement));
    node->nodeType = AstEnumForStatement;
    node->varExpressions = (AstNodeList *)AstNodeConvert(exp.varExpressions, patch, length);
    node->condition = (AstEmptyNode *)AstNodeConvert(exp.condition, patch, length);
    node->expressions = (AstNodeList *)AstNodeConvert(exp.expressions, patch, length);
    node->scopeImp = (AstEmptyNode *)AstNodeConvert(exp.scopeImp, patch, length);
    *length += AstForStatementBaseLength;
    return node;
}
AstForInStatement *AstForInStatementConvert(ORForInStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstForInStatement *node = malloc(sizeof(AstForInStatement));
    memset(node, 0, sizeof(AstForInStatement));
    node->nodeType = AstEnumForInStatement;
    node->expression = (AstEmptyNode *)AstNodeConvert(exp.expression, patch, length);
    node->value = (AstEmptyNode *)AstNodeConvert(exp.value, patch, length);
    node->scopeImp = (AstEmptyNode *)AstNodeConvert(exp.scopeImp, patch, length);
    *length += AstForInStatementBaseLength;
    return node;
}
AstControlStatNode *AstControlStatNodeConvert(ORControlStatNode *exp, AstPatchFile *patch, uint32_t *length){
    AstControlStatNode *node = malloc(sizeof(AstControlStatNode));
    memset(node, 0, sizeof(AstControlStatNode));
    node->nodeType = AstEnumControlStatNode;
    node->type = exp.type;
    node->expression = (AstEmptyNode *)AstNodeConvert(exp.expression, patch, length);
    *length += AstControlStatNodeBaseLength;
    return node;
}
AstPropertyNode *AstPropertyNodeConvert(ORPropertyNode *exp, AstPatchFile *patch, uint32_t *length){
    AstPropertyNode *node = malloc(sizeof(AstPropertyNode));
    memset(node, 0, sizeof(AstPropertyNode));
    node->nodeType = AstEnumPropertyNode;
    node->keywords = (AstNodeList *)AstNodeConvert(exp.keywords, patch, length);
    node->var = (AstEmptyNode *)AstNodeConvert(exp.var, patch, length);
    *length += AstPropertyNodeBaseLength;
    return node;
}
AstMethodDeclNode *AstMethodDeclNodeConvert(ORMethodDeclNode *exp, AstPatchFile *patch, uint32_t *length){
    AstMethodDeclNode *node = malloc(sizeof(AstMethodDeclNode));
    memset(node, 0, sizeof(AstMethodDeclNode));
    node->nodeType = AstEnumMethodDeclNode;
    node->isClassMethod = exp.isClassMethod;
    node->returnType = (AstEmptyNode *)AstNodeConvert(exp.returnType, patch, length);
    node->methodNames = (AstNodeList *)AstNodeConvert(exp.methodNames, patch, length);
    node->parameters = (AstNodeList *)AstNodeConvert(exp.parameters, patch, length);
    *length += AstMethodDeclNodeBaseLength;
    return node;
}
AstMethodNode *AstMethodNodeConvert(ORMethodNode *exp, AstPatchFile *patch, uint32_t *length){
    AstMethodNode *node = malloc(sizeof(AstMethodNode));
    memset(node, 0, sizeof(AstMethodNode));
    node->nodeType = AstEnumMethodNode;
    node->declare = (AstEmptyNode *)AstNodeConvert(exp.declare, patch, length);
    node->scopeImp = (AstEmptyNode *)AstNodeConvert(exp.scopeImp, patch, length);
    *length += AstMethodNodeBaseLength;
    return node;
}
AstClassNode *AstClassNodeConvert(ORClassNode *exp, AstPatchFile *patch, uint32_t *length){
    AstClassNode *node = malloc(sizeof(AstClassNode));
    memset(node, 0, sizeof(AstClassNode));
    node->nodeType = AstEnumClassNode;
    node->className = (AstStringCursor *)AstNodeConvert(exp.className, patch, length);
    node->superClassName = (AstStringCursor *)AstNodeConvert(exp.superClassName, patch, length);
    node->protocols = (AstNodeList *)AstNodeConvert(exp.protocols, patch, length);
    node->properties = (AstNodeList *)AstNodeConvert(exp.properties, patch, length);
    node->privateVariables = (AstNodeList *)AstNodeConvert(exp.privateVariables, patch, length);
    node->methods = (AstNodeList *)AstNodeConvert(exp.methods, patch, length);
    *length += AstClassNodeBaseLength;
    return node;
}
AstProtocolNode *AstProtocolNodeConvert(ORProtocolNode *exp, AstPatchFile *patch, uint32_t *length){
    AstProtocolNode *node = malloc(sizeof(AstProtocolNode));
    memset(node, 0, sizeof(AstProtocolNode));
    node->nodeType = AstEnumProtocolNode;
    node->protcolName = (AstStringCursor *)AstNodeConvert(exp.protcolName, patch, length);
    node->protocols = (AstNodeList *)AstNodeConvert(exp.protocols, patch, length);
    node->properties = (AstNodeList *)AstNodeConvert(exp.properties, patch, length);
    node->methods = (AstNodeList *)AstNodeConvert(exp.methods, patch, length);
    *length += AstProtocolNodeBaseLength;
    return node;
}
AstStructStatNode *AstStructStatNodeConvert(ORStructStatNode *exp, AstPatchFile *patch, uint32_t *length){
    AstStructStatNode *node = malloc(sizeof(AstStructStatNode));
    memset(node, 0, sizeof(AstStructStatNode));
    node->nodeType = AstEnumStructStatNode;
    node->sturctName = (AstStringCursor *)AstNodeConvert(exp.sturctName, patch, length);
    node->fields = (AstNodeList *)AstNodeConvert(exp.fields, patch, length);
    *length += AstStructStatNodeBaseLength;
    return node;
}
AstUnionStatNode *AstUnionStatNodeConvert(ORUnionStatNode *exp, AstPatchFile *patch, uint32_t *length){
    AstUnionStatNode *node = malloc(sizeof(AstUnionStatNode));
    memset(node, 0, sizeof(AstUnionStatNode));
    node->nodeType = AstEnumUnionStatNode;
    node->unionName = (AstStringCursor *)AstNodeConvert(exp.unionName, patch, length);
    node->fields = (AstNodeList *)AstNodeConvert(exp.fields, patch, length);
    *length += AstUnionStatNodeBaseLength;
    return node;
}
AstEnumStatNode *AstEnumStatNodeConvert(OREnumStatNode *exp, AstPatchFile *patch, uint32_t *length){
    AstEnumStatNode *node = malloc(sizeof(AstEnumStatNode));
    memset(node, 0, sizeof(AstEnumStatNode));
    node->nodeType = AstEnumEnumStatNode;
    node->valueType = exp.valueType;
    node->enumName = (AstStringCursor *)AstNodeConvert(exp.enumName, patch, length);
    node->fields = (AstNodeList *)AstNodeConvert(exp.fields, patch, length);
    *length += AstEnumStatNodeBaseLength;
    return node;
}
AstTypedefStatNode *AstTypedefStatNodeConvert(ORTypedefStatNode *exp, AstPatchFile *patch, uint32_t *length){
    AstTypedefStatNode *node = malloc(sizeof(AstTypedefStatNode));
    memset(node, 0, sizeof(AstTypedefStatNode));
    node->nodeType = AstEnumTypedefStatNode;
    node->expression = (AstEmptyNode *)AstNodeConvert(exp.expression, patch, length);
    node->typeNewName = (AstStringCursor *)AstNodeConvert(exp.typeNewName, patch, length);
    *length += AstTypedefStatNodeBaseLength;
    return node;
}

#pragma mark - Struct Convert To Class
ORTypeNode *AstTypeNodeDeConvert(ORNode *parent, AstTypeNode *node, AstPatchFile *patch){
    ORTypeNode *exp = [ORTypeNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.type = node->type;
    exp.modifier = node->modifier;
    exp.name = (NSString *)AstNodeDeConvert(exp, (AstEmptyNode *)node->name, patch);
    return exp;
}
ORVariableNode *AstVariableNodeDeConvert(ORNode *parent, AstVariableNode *node, AstPatchFile *patch){
    ORVariableNode *exp = [ORVariableNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.isBlock = node->isBlock;
    exp.ptCount = node->ptCount;
    exp.varname = (NSString *)AstNodeDeConvert(exp, (AstEmptyNode *)node->varname, patch);
    return exp;
}
ORDeclaratorNode *AstDeclaratorNodeDeConvert(ORNode *parent, AstDeclaratorNode *node, AstPatchFile *patch){
    ORDeclaratorNode *exp = [ORDeclaratorNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.type = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->type, patch);
    exp.var = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->var, patch);
    return exp;
}
ORFunctionDeclNode *AstFunctionDeclNodeDeConvert(ORNode *parent, AstFunctionDeclNode *node, AstPatchFile *patch){
    ORFunctionDeclNode *exp = [ORFunctionDeclNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.type = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->type, patch);
    exp.var = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->var, patch);
    exp.isMultiArgs = node->isMultiArgs;
    exp.params = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->params, patch);
    return exp;
}
ORCArrayDeclNode *AstCArrayDeclNodeDeConvert(ORNode *parent, AstCArrayDeclNode *node, AstPatchFile *patch){
    ORCArrayDeclNode *exp = [ORCArrayDeclNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.type = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->type, patch);
    exp.var = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->var, patch);
    exp.prev = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->prev, patch);
    exp.capacity = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->capacity, patch);
    return exp;
}
ORBlockNode *AstBlockNodeDeConvert(ORNode *parent, AstBlockNode *node, AstPatchFile *patch){
    ORBlockNode *exp = [ORBlockNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.statements = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->statements, patch);
    return exp;
}
ORValueNode *AstValueNodeDeConvert(ORNode *parent, AstValueNode *node, AstPatchFile *patch){
    ORValueNode *exp = [ORValueNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.value_type = node->value_type;
    exp.value = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->value, patch);
    return exp;
}
ORIntegerValue *AstIntegerValueDeConvert(ORNode *parent, AstIntegerValue *node, AstPatchFile *patch){
    ORIntegerValue *exp = [ORIntegerValue new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.value = node->value;
    return exp;
}
ORUIntegerValue *AstUIntegerValueDeConvert(ORNode *parent, AstUIntegerValue *node, AstPatchFile *patch){
    ORUIntegerValue *exp = [ORUIntegerValue new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.value = node->value;
    return exp;
}
ORDoubleValue *AstDoubleValueDeConvert(ORNode *parent, AstDoubleValue *node, AstPatchFile *patch){
    ORDoubleValue *exp = [ORDoubleValue new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.value = node->value;
    return exp;
}
ORBoolValue *AstBoolValueDeConvert(ORNode *parent, AstBoolValue *node, AstPatchFile *patch){
    ORBoolValue *exp = [ORBoolValue new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.value = node->value;
    return exp;
}
ORMethodCall *AstMethodCallDeConvert(ORNode *parent, AstMethodCall *node, AstPatchFile *patch){
    ORMethodCall *exp = [ORMethodCall new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.methodOperator = node->methodOperator;
    exp.isStructRef = node->isStructRef;
    exp.caller = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->caller, patch);
    exp.selectorName = (NSString *)AstNodeDeConvert(exp, (AstEmptyNode *)node->selectorName, patch);
    exp.values = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->values, patch);
    return exp;
}
ORFunctionCall *AstFunctionCallDeConvert(ORNode *parent, AstFunctionCall *node, AstPatchFile *patch){
    ORFunctionCall *exp = [ORFunctionCall new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.caller = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->caller, patch);
    exp.expressions = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->expressions, patch);
    return exp;
}
ORFunctionNode *AstFunctionNodeDeConvert(ORNode *parent, AstFunctionNode *node, AstPatchFile *patch){
    ORFunctionNode *exp = [ORFunctionNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.declare = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->declare, patch);
    exp.scopeImp = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->scopeImp, patch);
    return exp;
}
ORSubscriptNode *AstSubscriptNodeDeConvert(ORNode *parent, AstSubscriptNode *node, AstPatchFile *patch){
    ORSubscriptNode *exp = [ORSubscriptNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.caller = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->caller, patch);
    exp.keyExp = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->keyExp, patch);
    return exp;
}
ORAssignNode *AstAssignNodeDeConvert(ORNode *parent, AstAssignNode *node, AstPatchFile *patch){
    ORAssignNode *exp = [ORAssignNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.assignType = node->assignType;
    exp.value = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->value, patch);
    exp.expression = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->expression, patch);
    return exp;
}
ORInitDeclaratorNode *AstInitDeclaratorNodeDeConvert(ORNode *parent, AstInitDeclaratorNode *node, AstPatchFile *patch){
    ORInitDeclaratorNode *exp = [ORInitDeclaratorNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.declarator = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->declarator, patch);
    exp.expression = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->expression, patch);
    return exp;
}
ORUnaryNode *AstUnaryNodeDeConvert(ORNode *parent, AstUnaryNode *node, AstPatchFile *patch){
    ORUnaryNode *exp = [ORUnaryNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.operatorType = node->operatorType;
    exp.value = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->value, patch);
    return exp;
}
ORBinaryNode *AstBinaryNodeDeConvert(ORNode *parent, AstBinaryNode *node, AstPatchFile *patch){
    ORBinaryNode *exp = [ORBinaryNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.operatorType = node->operatorType;
    exp.left = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->left, patch);
    exp.right = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->right, patch);
    return exp;
}
ORTernaryNode *AstTernaryNodeDeConvert(ORNode *parent, AstTernaryNode *node, AstPatchFile *patch){
    ORTernaryNode *exp = [ORTernaryNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.expression = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->expression, patch);
    exp.values = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->values, patch);
    return exp;
}
ORIfStatement *AstIfStatementDeConvert(ORNode *parent, AstIfStatement *node, AstPatchFile *patch){
    ORIfStatement *exp = [ORIfStatement new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.condition = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->condition, patch);
    exp.scopeImp = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->scopeImp, patch);
    exp.statements = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->statements, patch);
    return exp;
}
ORWhileStatement *AstWhileStatementDeConvert(ORNode *parent, AstWhileStatement *node, AstPatchFile *patch){
    ORWhileStatement *exp = [ORWhileStatement new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.condition = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->condition, patch);
    exp.scopeImp = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->scopeImp, patch);
    return exp;
}
ORDoWhileStatement *AstDoWhileStatementDeConvert(ORNode *parent, AstDoWhileStatement *node, AstPatchFile *patch){
    ORDoWhileStatement *exp = [ORDoWhileStatement new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.condition = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->condition, patch);
    exp.scopeImp = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->scopeImp, patch);
    return exp;
}
ORCaseStatement *AstCaseStatementDeConvert(ORNode *parent, AstCaseStatement *node, AstPatchFile *patch){
    ORCaseStatement *exp = [ORCaseStatement new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.value = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->value, patch);
    exp.scopeImp = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->scopeImp, patch);
    return exp;
}
ORSwitchStatement *AstSwitchStatementDeConvert(ORNode *parent, AstSwitchStatement *node, AstPatchFile *patch){
    ORSwitchStatement *exp = [ORSwitchStatement new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.value = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->value, patch);
    exp.cases = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->cases, patch);
    return exp;
}
ORForStatement *AstForStatementDeConvert(ORNode *parent, AstForStatement *node, AstPatchFile *patch){
    ORForStatement *exp = [ORForStatement new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.varExpressions = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->varExpressions, patch);
    exp.condition = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->condition, patch);
    exp.expressions = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->expressions, patch);
    exp.scopeImp = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->scopeImp, patch);
    return exp;
}
ORForInStatement *AstForInStatementDeConvert(ORNode *parent, AstForInStatement *node, AstPatchFile *patch){
    ORForInStatement *exp = [ORForInStatement new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.expression = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->expression, patch);
    exp.value = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->value, patch);
    exp.scopeImp = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->scopeImp, patch);
    return exp;
}
ORControlStatNode *AstControlStatNodeDeConvert(ORNode *parent, AstControlStatNode *node, AstPatchFile *patch){
    ORControlStatNode *exp = [ORControlStatNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.type = node->type;
    exp.expression = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->expression, patch);
    return exp;
}
ORPropertyNode *AstPropertyNodeDeConvert(ORNode *parent, AstPropertyNode *node, AstPatchFile *patch){
    ORPropertyNode *exp = [ORPropertyNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.keywords = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->keywords, patch);
    exp.var = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->var, patch);
    return exp;
}
ORMethodDeclNode *AstMethodDeclNodeDeConvert(ORNode *parent, AstMethodDeclNode *node, AstPatchFile *patch){
    ORMethodDeclNode *exp = [ORMethodDeclNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.isClassMethod = node->isClassMethod;
    exp.returnType = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->returnType, patch);
    exp.methodNames = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->methodNames, patch);
    exp.parameters = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->parameters, patch);
    return exp;
}
ORMethodNode *AstMethodNodeDeConvert(ORNode *parent, AstMethodNode *node, AstPatchFile *patch){
    ORMethodNode *exp = [ORMethodNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.declare = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->declare, patch);
    exp.scopeImp = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->scopeImp, patch);
    return exp;
}
ORClassNode *AstClassNodeDeConvert(ORNode *parent, AstClassNode *node, AstPatchFile *patch){
    ORClassNode *exp = [ORClassNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.className = (NSString *)AstNodeDeConvert(exp, (AstEmptyNode *)node->className, patch);
    exp.superClassName = (NSString *)AstNodeDeConvert(exp, (AstEmptyNode *)node->superClassName, patch);
    exp.protocols = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->protocols, patch);
    exp.properties = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->properties, patch);
    exp.privateVariables = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->privateVariables, patch);
    exp.methods = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->methods, patch);
    return exp;
}
ORProtocolNode *AstProtocolNodeDeConvert(ORNode *parent, AstProtocolNode *node, AstPatchFile *patch){
    ORProtocolNode *exp = [ORProtocolNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.protcolName = (NSString *)AstNodeDeConvert(exp, (AstEmptyNode *)node->protcolName, patch);
    exp.protocols = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->protocols, patch);
    exp.properties = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->properties, patch);
    exp.methods = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->methods, patch);
    return exp;
}
ORStructStatNode *AstStructStatNodeDeConvert(ORNode *parent, AstStructStatNode *node, AstPatchFile *patch){
    ORStructStatNode *exp = [ORStructStatNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.sturctName = (NSString *)AstNodeDeConvert(exp, (AstEmptyNode *)node->sturctName, patch);
    exp.fields = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->fields, patch);
    return exp;
}
ORUnionStatNode *AstUnionStatNodeDeConvert(ORNode *parent, AstUnionStatNode *node, AstPatchFile *patch){
    ORUnionStatNode *exp = [ORUnionStatNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.unionName = (NSString *)AstNodeDeConvert(exp, (AstEmptyNode *)node->unionName, patch);
    exp.fields = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->fields, patch);
    return exp;
}
OREnumStatNode *AstEnumStatNodeDeConvert(ORNode *parent, AstEnumStatNode *node, AstPatchFile *patch){
    OREnumStatNode *exp = [OREnumStatNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.valueType = node->valueType;
    exp.enumName = (NSString *)AstNodeDeConvert(exp, (AstEmptyNode *)node->enumName, patch);
    exp.fields = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->fields, patch);
    return exp;
}
ORTypedefStatNode *AstTypedefStatNodeDeConvert(ORNode *parent, AstTypedefStatNode *node, AstPatchFile *patch){
    ORTypedefStatNode *exp = [ORTypedefStatNode new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.expression = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->expression, patch);
    exp.typeNewName = (NSString *)AstNodeDeConvert(exp, (AstEmptyNode *)node->typeNewName, patch);
    return exp;
}

#pragma mark - Struct Write To Buffer
void AstTypeNodeSerailization(AstTypeNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstTypeNodeBaseLength);
    *cursor += AstTypeNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->name, buffer, cursor);
}
void AstVariableNodeSerailization(AstVariableNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstVariableNodeBaseLength);
    *cursor += AstVariableNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->varname, buffer, cursor);
}
void AstDeclaratorNodeSerailization(AstDeclaratorNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstDeclaratorNodeBaseLength);
    *cursor += AstDeclaratorNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->type, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->var, buffer, cursor);
}
void AstFunctionDeclNodeSerailization(AstFunctionDeclNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstFunctionDeclNodeBaseLength);
    *cursor += AstFunctionDeclNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->type, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->var, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->params, buffer, cursor);
}
void AstCArrayDeclNodeSerailization(AstCArrayDeclNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstCArrayDeclNodeBaseLength);
    *cursor += AstCArrayDeclNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->type, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->var, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->prev, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->capacity, buffer, cursor);
}
void AstBlockNodeSerailization(AstBlockNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstBlockNodeBaseLength);
    *cursor += AstBlockNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->statements, buffer, cursor);
}
void AstValueNodeSerailization(AstValueNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstValueNodeBaseLength);
    *cursor += AstValueNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->value, buffer, cursor);
}
void AstIntegerValueSerailization(AstIntegerValue *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstIntegerValueBaseLength);
    *cursor += AstIntegerValueBaseLength;
    
}
void AstUIntegerValueSerailization(AstUIntegerValue *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstUIntegerValueBaseLength);
    *cursor += AstUIntegerValueBaseLength;
    
}
void AstDoubleValueSerailization(AstDoubleValue *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstDoubleValueBaseLength);
    *cursor += AstDoubleValueBaseLength;
    
}
void AstBoolValueSerailization(AstBoolValue *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstBoolValueBaseLength);
    *cursor += AstBoolValueBaseLength;
    
}
void AstMethodCallSerailization(AstMethodCall *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstMethodCallBaseLength);
    *cursor += AstMethodCallBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->caller, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->selectorName, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->values, buffer, cursor);
}
void AstFunctionCallSerailization(AstFunctionCall *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstFunctionCallBaseLength);
    *cursor += AstFunctionCallBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->caller, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->expressions, buffer, cursor);
}
void AstFunctionNodeSerailization(AstFunctionNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstFunctionNodeBaseLength);
    *cursor += AstFunctionNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->declare, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->scopeImp, buffer, cursor);
}
void AstSubscriptNodeSerailization(AstSubscriptNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstSubscriptNodeBaseLength);
    *cursor += AstSubscriptNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->caller, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->keyExp, buffer, cursor);
}
void AstAssignNodeSerailization(AstAssignNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstAssignNodeBaseLength);
    *cursor += AstAssignNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->value, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->expression, buffer, cursor);
}
void AstInitDeclaratorNodeSerailization(AstInitDeclaratorNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstInitDeclaratorNodeBaseLength);
    *cursor += AstInitDeclaratorNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->declarator, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->expression, buffer, cursor);
}
void AstUnaryNodeSerailization(AstUnaryNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstUnaryNodeBaseLength);
    *cursor += AstUnaryNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->value, buffer, cursor);
}
void AstBinaryNodeSerailization(AstBinaryNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstBinaryNodeBaseLength);
    *cursor += AstBinaryNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->left, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->right, buffer, cursor);
}
void AstTernaryNodeSerailization(AstTernaryNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstTernaryNodeBaseLength);
    *cursor += AstTernaryNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->expression, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->values, buffer, cursor);
}
void AstIfStatementSerailization(AstIfStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstIfStatementBaseLength);
    *cursor += AstIfStatementBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->condition, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->scopeImp, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->statements, buffer, cursor);
}
void AstWhileStatementSerailization(AstWhileStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstWhileStatementBaseLength);
    *cursor += AstWhileStatementBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->condition, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->scopeImp, buffer, cursor);
}
void AstDoWhileStatementSerailization(AstDoWhileStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstDoWhileStatementBaseLength);
    *cursor += AstDoWhileStatementBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->condition, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->scopeImp, buffer, cursor);
}
void AstCaseStatementSerailization(AstCaseStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstCaseStatementBaseLength);
    *cursor += AstCaseStatementBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->value, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->scopeImp, buffer, cursor);
}
void AstSwitchStatementSerailization(AstSwitchStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstSwitchStatementBaseLength);
    *cursor += AstSwitchStatementBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->value, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->cases, buffer, cursor);
}
void AstForStatementSerailization(AstForStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstForStatementBaseLength);
    *cursor += AstForStatementBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->varExpressions, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->condition, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->expressions, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->scopeImp, buffer, cursor);
}
void AstForInStatementSerailization(AstForInStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstForInStatementBaseLength);
    *cursor += AstForInStatementBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->expression, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->value, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->scopeImp, buffer, cursor);
}
void AstControlStatNodeSerailization(AstControlStatNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstControlStatNodeBaseLength);
    *cursor += AstControlStatNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->expression, buffer, cursor);
}
void AstPropertyNodeSerailization(AstPropertyNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstPropertyNodeBaseLength);
    *cursor += AstPropertyNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->keywords, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->var, buffer, cursor);
}
void AstMethodDeclNodeSerailization(AstMethodDeclNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstMethodDeclNodeBaseLength);
    *cursor += AstMethodDeclNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->returnType, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->methodNames, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->parameters, buffer, cursor);
}
void AstMethodNodeSerailization(AstMethodNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstMethodNodeBaseLength);
    *cursor += AstMethodNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->declare, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->scopeImp, buffer, cursor);
}
void AstClassNodeSerailization(AstClassNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstClassNodeBaseLength);
    *cursor += AstClassNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->className, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->superClassName, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->protocols, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->properties, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->privateVariables, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->methods, buffer, cursor);
}
void AstProtocolNodeSerailization(AstProtocolNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstProtocolNodeBaseLength);
    *cursor += AstProtocolNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->protcolName, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->protocols, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->properties, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->methods, buffer, cursor);
}
void AstStructStatNodeSerailization(AstStructStatNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstStructStatNodeBaseLength);
    *cursor += AstStructStatNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->sturctName, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->fields, buffer, cursor);
}
void AstUnionStatNodeSerailization(AstUnionStatNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstUnionStatNodeBaseLength);
    *cursor += AstUnionStatNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->unionName, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->fields, buffer, cursor);
}
void AstEnumStatNodeSerailization(AstEnumStatNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstEnumStatNodeBaseLength);
    *cursor += AstEnumStatNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->enumName, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->fields, buffer, cursor);
}
void AstTypedefStatNodeSerailization(AstTypedefStatNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstTypedefStatNodeBaseLength);
    *cursor += AstTypedefStatNodeBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->expression, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->typeNewName, buffer, cursor);
}

#pragma mark - Buffer Data Convert To Struct
AstTypeNode *AstTypeNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstTypeNode *node = malloc(sizeof(AstTypeNode));
    memcpy(node, buffer + *cursor, AstTypeNodeBaseLength);
    *cursor += AstTypeNodeBaseLength;
    node->name =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstVariableNode *AstVariableNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstVariableNode *node = malloc(sizeof(AstVariableNode));
    memcpy(node, buffer + *cursor, AstVariableNodeBaseLength);
    *cursor += AstVariableNodeBaseLength;
    node->varname =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstDeclaratorNode *AstDeclaratorNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstDeclaratorNode *node = malloc(sizeof(AstDeclaratorNode));
    memcpy(node, buffer + *cursor, AstDeclaratorNodeBaseLength);
    *cursor += AstDeclaratorNodeBaseLength;
    node->type =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->var =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstFunctionDeclNode *AstFunctionDeclNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstFunctionDeclNode *node = malloc(sizeof(AstFunctionDeclNode));
    memcpy(node, buffer + *cursor, AstFunctionDeclNodeBaseLength);
    *cursor += AstFunctionDeclNodeBaseLength;
    node->type =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->var =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->params =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstCArrayDeclNode *AstCArrayDeclNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstCArrayDeclNode *node = malloc(sizeof(AstCArrayDeclNode));
    memcpy(node, buffer + *cursor, AstCArrayDeclNodeBaseLength);
    *cursor += AstCArrayDeclNodeBaseLength;
    node->type =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->var =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->prev =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->capacity =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstBlockNode *AstBlockNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstBlockNode *node = malloc(sizeof(AstBlockNode));
    memcpy(node, buffer + *cursor, AstBlockNodeBaseLength);
    *cursor += AstBlockNodeBaseLength;
    node->statements =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstValueNode *AstValueNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstValueNode *node = malloc(sizeof(AstValueNode));
    memcpy(node, buffer + *cursor, AstValueNodeBaseLength);
    *cursor += AstValueNodeBaseLength;
    node->value =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstIntegerValue *AstIntegerValueDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstIntegerValue *node = malloc(sizeof(AstIntegerValue));
    memcpy(node, buffer + *cursor, AstIntegerValueBaseLength);
    *cursor += AstIntegerValueBaseLength;
    
    return node;
}
AstUIntegerValue *AstUIntegerValueDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstUIntegerValue *node = malloc(sizeof(AstUIntegerValue));
    memcpy(node, buffer + *cursor, AstUIntegerValueBaseLength);
    *cursor += AstUIntegerValueBaseLength;
    
    return node;
}
AstDoubleValue *AstDoubleValueDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstDoubleValue *node = malloc(sizeof(AstDoubleValue));
    memcpy(node, buffer + *cursor, AstDoubleValueBaseLength);
    *cursor += AstDoubleValueBaseLength;
    
    return node;
}
AstBoolValue *AstBoolValueDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstBoolValue *node = malloc(sizeof(AstBoolValue));
    memcpy(node, buffer + *cursor, AstBoolValueBaseLength);
    *cursor += AstBoolValueBaseLength;
    
    return node;
}
AstMethodCall *AstMethodCallDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstMethodCall *node = malloc(sizeof(AstMethodCall));
    memcpy(node, buffer + *cursor, AstMethodCallBaseLength);
    *cursor += AstMethodCallBaseLength;
    node->caller =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->selectorName =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->values =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstFunctionCall *AstFunctionCallDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstFunctionCall *node = malloc(sizeof(AstFunctionCall));
    memcpy(node, buffer + *cursor, AstFunctionCallBaseLength);
    *cursor += AstFunctionCallBaseLength;
    node->caller =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->expressions =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstFunctionNode *AstFunctionNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstFunctionNode *node = malloc(sizeof(AstFunctionNode));
    memcpy(node, buffer + *cursor, AstFunctionNodeBaseLength);
    *cursor += AstFunctionNodeBaseLength;
    node->declare =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstSubscriptNode *AstSubscriptNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstSubscriptNode *node = malloc(sizeof(AstSubscriptNode));
    memcpy(node, buffer + *cursor, AstSubscriptNodeBaseLength);
    *cursor += AstSubscriptNodeBaseLength;
    node->caller =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->keyExp =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstAssignNode *AstAssignNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstAssignNode *node = malloc(sizeof(AstAssignNode));
    memcpy(node, buffer + *cursor, AstAssignNodeBaseLength);
    *cursor += AstAssignNodeBaseLength;
    node->value =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->expression =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstInitDeclaratorNode *AstInitDeclaratorNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstInitDeclaratorNode *node = malloc(sizeof(AstInitDeclaratorNode));
    memcpy(node, buffer + *cursor, AstInitDeclaratorNodeBaseLength);
    *cursor += AstInitDeclaratorNodeBaseLength;
    node->declarator =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->expression =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstUnaryNode *AstUnaryNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstUnaryNode *node = malloc(sizeof(AstUnaryNode));
    memcpy(node, buffer + *cursor, AstUnaryNodeBaseLength);
    *cursor += AstUnaryNodeBaseLength;
    node->value =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstBinaryNode *AstBinaryNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstBinaryNode *node = malloc(sizeof(AstBinaryNode));
    memcpy(node, buffer + *cursor, AstBinaryNodeBaseLength);
    *cursor += AstBinaryNodeBaseLength;
    node->left =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->right =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstTernaryNode *AstTernaryNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstTernaryNode *node = malloc(sizeof(AstTernaryNode));
    memcpy(node, buffer + *cursor, AstTernaryNodeBaseLength);
    *cursor += AstTernaryNodeBaseLength;
    node->expression =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->values =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstIfStatement *AstIfStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstIfStatement *node = malloc(sizeof(AstIfStatement));
    memcpy(node, buffer + *cursor, AstIfStatementBaseLength);
    *cursor += AstIfStatementBaseLength;
    node->condition =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->statements =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstWhileStatement *AstWhileStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstWhileStatement *node = malloc(sizeof(AstWhileStatement));
    memcpy(node, buffer + *cursor, AstWhileStatementBaseLength);
    *cursor += AstWhileStatementBaseLength;
    node->condition =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstDoWhileStatement *AstDoWhileStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstDoWhileStatement *node = malloc(sizeof(AstDoWhileStatement));
    memcpy(node, buffer + *cursor, AstDoWhileStatementBaseLength);
    *cursor += AstDoWhileStatementBaseLength;
    node->condition =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstCaseStatement *AstCaseStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstCaseStatement *node = malloc(sizeof(AstCaseStatement));
    memcpy(node, buffer + *cursor, AstCaseStatementBaseLength);
    *cursor += AstCaseStatementBaseLength;
    node->value =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstSwitchStatement *AstSwitchStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstSwitchStatement *node = malloc(sizeof(AstSwitchStatement));
    memcpy(node, buffer + *cursor, AstSwitchStatementBaseLength);
    *cursor += AstSwitchStatementBaseLength;
    node->value =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->cases =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstForStatement *AstForStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstForStatement *node = malloc(sizeof(AstForStatement));
    memcpy(node, buffer + *cursor, AstForStatementBaseLength);
    *cursor += AstForStatementBaseLength;
    node->varExpressions =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->condition =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->expressions =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstForInStatement *AstForInStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstForInStatement *node = malloc(sizeof(AstForInStatement));
    memcpy(node, buffer + *cursor, AstForInStatementBaseLength);
    *cursor += AstForInStatementBaseLength;
    node->expression =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->value =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstControlStatNode *AstControlStatNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstControlStatNode *node = malloc(sizeof(AstControlStatNode));
    memcpy(node, buffer + *cursor, AstControlStatNodeBaseLength);
    *cursor += AstControlStatNodeBaseLength;
    node->expression =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstPropertyNode *AstPropertyNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstPropertyNode *node = malloc(sizeof(AstPropertyNode));
    memcpy(node, buffer + *cursor, AstPropertyNodeBaseLength);
    *cursor += AstPropertyNodeBaseLength;
    node->keywords =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->var =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstMethodDeclNode *AstMethodDeclNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstMethodDeclNode *node = malloc(sizeof(AstMethodDeclNode));
    memcpy(node, buffer + *cursor, AstMethodDeclNodeBaseLength);
    *cursor += AstMethodDeclNodeBaseLength;
    node->returnType =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->methodNames =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->parameters =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstMethodNode *AstMethodNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstMethodNode *node = malloc(sizeof(AstMethodNode));
    memcpy(node, buffer + *cursor, AstMethodNodeBaseLength);
    *cursor += AstMethodNodeBaseLength;
    node->declare =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstClassNode *AstClassNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstClassNode *node = malloc(sizeof(AstClassNode));
    memcpy(node, buffer + *cursor, AstClassNodeBaseLength);
    *cursor += AstClassNodeBaseLength;
    node->className =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->superClassName =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->protocols =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->properties =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->privateVariables =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->methods =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstProtocolNode *AstProtocolNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstProtocolNode *node = malloc(sizeof(AstProtocolNode));
    memcpy(node, buffer + *cursor, AstProtocolNodeBaseLength);
    *cursor += AstProtocolNodeBaseLength;
    node->protcolName =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->protocols =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->properties =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->methods =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstStructStatNode *AstStructStatNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstStructStatNode *node = malloc(sizeof(AstStructStatNode));
    memcpy(node, buffer + *cursor, AstStructStatNodeBaseLength);
    *cursor += AstStructStatNodeBaseLength;
    node->sturctName =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->fields =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstUnionStatNode *AstUnionStatNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstUnionStatNode *node = malloc(sizeof(AstUnionStatNode));
    memcpy(node, buffer + *cursor, AstUnionStatNodeBaseLength);
    *cursor += AstUnionStatNodeBaseLength;
    node->unionName =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->fields =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstEnumStatNode *AstEnumStatNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstEnumStatNode *node = malloc(sizeof(AstEnumStatNode));
    memcpy(node, buffer + *cursor, AstEnumStatNodeBaseLength);
    *cursor += AstEnumStatNodeBaseLength;
    node->enumName =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->fields =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstTypedefStatNode *AstTypedefStatNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstTypedefStatNode *node = malloc(sizeof(AstTypedefStatNode));
    memcpy(node, buffer + *cursor, AstTypedefStatNodeBaseLength);
    *cursor += AstTypedefStatNodeBaseLength;
    node->expression =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->typeNewName =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}

#pragma mark - Free Struct Memory
void AstTypeNodeDestroy(AstTypeNode *node){
    AstNodeDestroy((AstEmptyNode *)node->name);
    free(node);
}
void AstVariableNodeDestroy(AstVariableNode *node){
    AstNodeDestroy((AstEmptyNode *)node->varname);
    free(node);
}
void AstDeclaratorNodeDestroy(AstDeclaratorNode *node){
    AstNodeDestroy((AstEmptyNode *)node->type);
    AstNodeDestroy((AstEmptyNode *)node->var);
    free(node);
}
void AstFunctionDeclNodeDestroy(AstFunctionDeclNode *node){
    AstNodeDestroy((AstEmptyNode *)node->params);
    free(node);
}
void AstCArrayDeclNodeDestroy(AstCArrayDeclNode *node){
    AstNodeDestroy((AstEmptyNode *)node->prev);
    AstNodeDestroy((AstEmptyNode *)node->capacity);
    free(node);
}
void AstBlockNodeDestroy(AstBlockNode *node){
    AstNodeDestroy((AstEmptyNode *)node->statements);
    free(node);
}
void AstValueNodeDestroy(AstValueNode *node){
    AstNodeDestroy((AstEmptyNode *)node->value);
    free(node);
}
void AstIntegerValueDestroy(AstIntegerValue *node){
    
    free(node);
}
void AstUIntegerValueDestroy(AstUIntegerValue *node){
    
    free(node);
}
void AstDoubleValueDestroy(AstDoubleValue *node){
    
    free(node);
}
void AstBoolValueDestroy(AstBoolValue *node){
    
    free(node);
}
void AstMethodCallDestroy(AstMethodCall *node){
    AstNodeDestroy((AstEmptyNode *)node->caller);
    AstNodeDestroy((AstEmptyNode *)node->selectorName);
    AstNodeDestroy((AstEmptyNode *)node->values);
    free(node);
}
void AstFunctionCallDestroy(AstFunctionCall *node){
    AstNodeDestroy((AstEmptyNode *)node->caller);
    AstNodeDestroy((AstEmptyNode *)node->expressions);
    free(node);
}
void AstFunctionNodeDestroy(AstFunctionNode *node){
    AstNodeDestroy((AstEmptyNode *)node->declare);
    AstNodeDestroy((AstEmptyNode *)node->scopeImp);
    free(node);
}
void AstSubscriptNodeDestroy(AstSubscriptNode *node){
    AstNodeDestroy((AstEmptyNode *)node->caller);
    AstNodeDestroy((AstEmptyNode *)node->keyExp);
    free(node);
}
void AstAssignNodeDestroy(AstAssignNode *node){
    AstNodeDestroy((AstEmptyNode *)node->value);
    AstNodeDestroy((AstEmptyNode *)node->expression);
    free(node);
}
void AstInitDeclaratorNodeDestroy(AstInitDeclaratorNode *node){
    AstNodeDestroy((AstEmptyNode *)node->declarator);
    AstNodeDestroy((AstEmptyNode *)node->expression);
    free(node);
}
void AstUnaryNodeDestroy(AstUnaryNode *node){
    AstNodeDestroy((AstEmptyNode *)node->value);
    free(node);
}
void AstBinaryNodeDestroy(AstBinaryNode *node){
    AstNodeDestroy((AstEmptyNode *)node->left);
    AstNodeDestroy((AstEmptyNode *)node->right);
    free(node);
}
void AstTernaryNodeDestroy(AstTernaryNode *node){
    AstNodeDestroy((AstEmptyNode *)node->expression);
    AstNodeDestroy((AstEmptyNode *)node->values);
    free(node);
}
void AstIfStatementDestroy(AstIfStatement *node){
    AstNodeDestroy((AstEmptyNode *)node->condition);
    AstNodeDestroy((AstEmptyNode *)node->scopeImp);
    AstNodeDestroy((AstEmptyNode *)node->statements);
    free(node);
}
void AstWhileStatementDestroy(AstWhileStatement *node){
    AstNodeDestroy((AstEmptyNode *)node->condition);
    AstNodeDestroy((AstEmptyNode *)node->scopeImp);
    free(node);
}
void AstDoWhileStatementDestroy(AstDoWhileStatement *node){
    AstNodeDestroy((AstEmptyNode *)node->condition);
    AstNodeDestroy((AstEmptyNode *)node->scopeImp);
    free(node);
}
void AstCaseStatementDestroy(AstCaseStatement *node){
    AstNodeDestroy((AstEmptyNode *)node->value);
    AstNodeDestroy((AstEmptyNode *)node->scopeImp);
    free(node);
}
void AstSwitchStatementDestroy(AstSwitchStatement *node){
    AstNodeDestroy((AstEmptyNode *)node->value);
    AstNodeDestroy((AstEmptyNode *)node->cases);
    free(node);
}
void AstForStatementDestroy(AstForStatement *node){
    AstNodeDestroy((AstEmptyNode *)node->varExpressions);
    AstNodeDestroy((AstEmptyNode *)node->condition);
    AstNodeDestroy((AstEmptyNode *)node->expressions);
    AstNodeDestroy((AstEmptyNode *)node->scopeImp);
    free(node);
}
void AstForInStatementDestroy(AstForInStatement *node){
    AstNodeDestroy((AstEmptyNode *)node->expression);
    AstNodeDestroy((AstEmptyNode *)node->value);
    AstNodeDestroy((AstEmptyNode *)node->scopeImp);
    free(node);
}
void AstControlStatNodeDestroy(AstControlStatNode *node){
    AstNodeDestroy((AstEmptyNode *)node->expression);
    free(node);
}
void AstPropertyNodeDestroy(AstPropertyNode *node){
    AstNodeDestroy((AstEmptyNode *)node->keywords);
    AstNodeDestroy((AstEmptyNode *)node->var);
    free(node);
}
void AstMethodDeclNodeDestroy(AstMethodDeclNode *node){
    AstNodeDestroy((AstEmptyNode *)node->returnType);
    AstNodeDestroy((AstEmptyNode *)node->methodNames);
    AstNodeDestroy((AstEmptyNode *)node->parameters);
    free(node);
}
void AstMethodNodeDestroy(AstMethodNode *node){
    AstNodeDestroy((AstEmptyNode *)node->declare);
    AstNodeDestroy((AstEmptyNode *)node->scopeImp);
    free(node);
}
void AstClassNodeDestroy(AstClassNode *node){
    AstNodeDestroy((AstEmptyNode *)node->className);
    AstNodeDestroy((AstEmptyNode *)node->superClassName);
    AstNodeDestroy((AstEmptyNode *)node->protocols);
    AstNodeDestroy((AstEmptyNode *)node->properties);
    AstNodeDestroy((AstEmptyNode *)node->privateVariables);
    AstNodeDestroy((AstEmptyNode *)node->methods);
    free(node);
}
void AstProtocolNodeDestroy(AstProtocolNode *node){
    AstNodeDestroy((AstEmptyNode *)node->protcolName);
    AstNodeDestroy((AstEmptyNode *)node->protocols);
    AstNodeDestroy((AstEmptyNode *)node->properties);
    AstNodeDestroy((AstEmptyNode *)node->methods);
    free(node);
}
void AstStructStatNodeDestroy(AstStructStatNode *node){
    AstNodeDestroy((AstEmptyNode *)node->sturctName);
    AstNodeDestroy((AstEmptyNode *)node->fields);
    free(node);
}
void AstUnionStatNodeDestroy(AstUnionStatNode *node){
    AstNodeDestroy((AstEmptyNode *)node->unionName);
    AstNodeDestroy((AstEmptyNode *)node->fields);
    free(node);
}
void AstEnumStatNodeDestroy(AstEnumStatNode *node){
    AstNodeDestroy((AstEmptyNode *)node->enumName);
    AstNodeDestroy((AstEmptyNode *)node->fields);
    free(node);
}
void AstTypedefStatNodeDestroy(AstTypedefStatNode *node){
    AstNodeDestroy((AstEmptyNode *)node->expression);
    AstNodeDestroy((AstEmptyNode *)node->typeNewName);
    free(node);
}

#pragma mark - Dispatch
AstEmptyNode *AstNodeConvert(id exp, AstPatchFile *patch, uint32_t *length){
    if ([exp isKindOfClass:[NSString class]]) {
        return (AstEmptyNode *)createStringCursor((NSString *)exp, patch, length);
    }else if ([exp isKindOfClass:[NSArray class]]) {
        return (AstEmptyNode *)AstNodeListConvert((NSArray *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORCArrayDeclNode class]]){
        return (AstEmptyNode *)AstCArrayDeclNodeConvert((ORCArrayDeclNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORFunctionDeclNode class]]){
        return (AstEmptyNode *)AstFunctionDeclNodeConvert((ORFunctionDeclNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORTypeNode class]]){
        return (AstEmptyNode *)AstTypeNodeConvert((ORTypeNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORVariableNode class]]){
        return (AstEmptyNode *)AstVariableNodeConvert((ORVariableNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORDeclaratorNode class]]){
        return (AstEmptyNode *)AstDeclaratorNodeConvert((ORDeclaratorNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORBlockNode class]]){
        return (AstEmptyNode *)AstBlockNodeConvert((ORBlockNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORValueNode class]]){
        return (AstEmptyNode *)AstValueNodeConvert((ORValueNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORIntegerValue class]]){
        return (AstEmptyNode *)AstIntegerValueConvert((ORIntegerValue *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORUIntegerValue class]]){
        return (AstEmptyNode *)AstUIntegerValueConvert((ORUIntegerValue *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORDoubleValue class]]){
        return (AstEmptyNode *)AstDoubleValueConvert((ORDoubleValue *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORBoolValue class]]){
        return (AstEmptyNode *)AstBoolValueConvert((ORBoolValue *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORMethodCall class]]){
        return (AstEmptyNode *)AstMethodCallConvert((ORMethodCall *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORFunctionCall class]]){
        return (AstEmptyNode *)AstFunctionCallConvert((ORFunctionCall *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORFunctionNode class]]){
        return (AstEmptyNode *)AstFunctionNodeConvert((ORFunctionNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORSubscriptNode class]]){
        return (AstEmptyNode *)AstSubscriptNodeConvert((ORSubscriptNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORAssignNode class]]){
        return (AstEmptyNode *)AstAssignNodeConvert((ORAssignNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORInitDeclaratorNode class]]){
        return (AstEmptyNode *)AstInitDeclaratorNodeConvert((ORInitDeclaratorNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORUnaryNode class]]){
        return (AstEmptyNode *)AstUnaryNodeConvert((ORUnaryNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORBinaryNode class]]){
        return (AstEmptyNode *)AstBinaryNodeConvert((ORBinaryNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORTernaryNode class]]){
        return (AstEmptyNode *)AstTernaryNodeConvert((ORTernaryNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORIfStatement class]]){
        return (AstEmptyNode *)AstIfStatementConvert((ORIfStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORWhileStatement class]]){
        return (AstEmptyNode *)AstWhileStatementConvert((ORWhileStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORDoWhileStatement class]]){
        return (AstEmptyNode *)AstDoWhileStatementConvert((ORDoWhileStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORCaseStatement class]]){
        return (AstEmptyNode *)AstCaseStatementConvert((ORCaseStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORSwitchStatement class]]){
        return (AstEmptyNode *)AstSwitchStatementConvert((ORSwitchStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORForStatement class]]){
        return (AstEmptyNode *)AstForStatementConvert((ORForStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORForInStatement class]]){
        return (AstEmptyNode *)AstForInStatementConvert((ORForInStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORControlStatNode class]]){
        return (AstEmptyNode *)AstControlStatNodeConvert((ORControlStatNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORPropertyNode class]]){
        return (AstEmptyNode *)AstPropertyNodeConvert((ORPropertyNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORMethodDeclNode class]]){
        return (AstEmptyNode *)AstMethodDeclNodeConvert((ORMethodDeclNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORMethodNode class]]){
        return (AstEmptyNode *)AstMethodNodeConvert((ORMethodNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORClassNode class]]){
        return (AstEmptyNode *)AstClassNodeConvert((ORClassNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORProtocolNode class]]){
        return (AstEmptyNode *)AstProtocolNodeConvert((ORProtocolNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORStructStatNode class]]){
        return (AstEmptyNode *)AstStructStatNodeConvert((ORStructStatNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORUnionStatNode class]]){
        return (AstEmptyNode *)AstUnionStatNodeConvert((ORUnionStatNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[OREnumStatNode class]]){
        return (AstEmptyNode *)AstEnumStatNodeConvert((OREnumStatNode *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORTypedefStatNode class]]){
        return (AstEmptyNode *)AstTypedefStatNodeConvert((ORTypedefStatNode *)exp, patch, length);
    }
    AstEmptyNode *node = malloc(sizeof(AstEmptyNode));
    memset(node, 0, sizeof(AstEmptyNode));
    *length += 1;
    return node;
}
id AstNodeDeConvert(ORNode *parent,AstEmptyNode *node, AstPatchFile *patch){
    switch(node->nodeType){
        case AstEnumEmptyNode:
            return nil;
        case AstEnumListNode:
            return AstNodeListDeConvert(parent, (AstNodeList *)node, patch);
        case AstEnumStringCursorNode:
            return getNSStringWithStringCursor((AstStringCursor *) node, patch);
        case AstEnumTypeNode:
            return (ORNode *)AstTypeNodeDeConvert(parent, (AstTypeNode *)node, patch);
        case AstEnumVariableNode:
            return (ORNode *)AstVariableNodeDeConvert(parent, (AstVariableNode *)node, patch);
        case AstEnumDeclaratorNode:
            return (ORNode *)AstDeclaratorNodeDeConvert(parent, (AstDeclaratorNode *)node, patch);
        case AstEnumFunctionDeclNode:
            return (ORNode *)AstFunctionDeclNodeDeConvert(parent, (AstFunctionDeclNode *)node, patch);
        case AstEnumCArrayDeclNode:
            return (ORNode *)AstCArrayDeclNodeDeConvert(parent, (AstCArrayDeclNode *)node, patch);
        case AstEnumBlockNode:
            return (ORNode *)AstBlockNodeDeConvert(parent, (AstBlockNode *)node, patch);
        case AstEnumValueNode:
            return (ORNode *)AstValueNodeDeConvert(parent, (AstValueNode *)node, patch);
        case AstEnumIntegerValue:
            return (ORNode *)AstIntegerValueDeConvert(parent, (AstIntegerValue *)node, patch);
        case AstEnumUIntegerValue:
            return (ORNode *)AstUIntegerValueDeConvert(parent, (AstUIntegerValue *)node, patch);
        case AstEnumDoubleValue:
            return (ORNode *)AstDoubleValueDeConvert(parent, (AstDoubleValue *)node, patch);
        case AstEnumBoolValue:
            return (ORNode *)AstBoolValueDeConvert(parent, (AstBoolValue *)node, patch);
        case AstEnumMethodCall:
            return (ORNode *)AstMethodCallDeConvert(parent, (AstMethodCall *)node, patch);
        case AstEnumFunctionCall:
            return (ORNode *)AstFunctionCallDeConvert(parent, (AstFunctionCall *)node, patch);
        case AstEnumFunctionNode:
            return (ORNode *)AstFunctionNodeDeConvert(parent, (AstFunctionNode *)node, patch);
        case AstEnumSubscriptNode:
            return (ORNode *)AstSubscriptNodeDeConvert(parent, (AstSubscriptNode *)node, patch);
        case AstEnumAssignNode:
            return (ORNode *)AstAssignNodeDeConvert(parent, (AstAssignNode *)node, patch);
        case AstEnumInitDeclaratorNode:
            return (ORNode *)AstInitDeclaratorNodeDeConvert(parent, (AstInitDeclaratorNode *)node, patch);
        case AstEnumUnaryNode:
            return (ORNode *)AstUnaryNodeDeConvert(parent, (AstUnaryNode *)node, patch);
        case AstEnumBinaryNode:
            return (ORNode *)AstBinaryNodeDeConvert(parent, (AstBinaryNode *)node, patch);
        case AstEnumTernaryNode:
            return (ORNode *)AstTernaryNodeDeConvert(parent, (AstTernaryNode *)node, patch);
        case AstEnumIfStatement:
            return (ORNode *)AstIfStatementDeConvert(parent, (AstIfStatement *)node, patch);
        case AstEnumWhileStatement:
            return (ORNode *)AstWhileStatementDeConvert(parent, (AstWhileStatement *)node, patch);
        case AstEnumDoWhileStatement:
            return (ORNode *)AstDoWhileStatementDeConvert(parent, (AstDoWhileStatement *)node, patch);
        case AstEnumCaseStatement:
            return (ORNode *)AstCaseStatementDeConvert(parent, (AstCaseStatement *)node, patch);
        case AstEnumSwitchStatement:
            return (ORNode *)AstSwitchStatementDeConvert(parent, (AstSwitchStatement *)node, patch);
        case AstEnumForStatement:
            return (ORNode *)AstForStatementDeConvert(parent, (AstForStatement *)node, patch);
        case AstEnumForInStatement:
            return (ORNode *)AstForInStatementDeConvert(parent, (AstForInStatement *)node, patch);
        case AstEnumControlStatNode:
            return (ORNode *)AstControlStatNodeDeConvert(parent, (AstControlStatNode *)node, patch);
        case AstEnumPropertyNode:
            return (ORNode *)AstPropertyNodeDeConvert(parent, (AstPropertyNode *)node, patch);
        case AstEnumMethodDeclNode:
            return (ORNode *)AstMethodDeclNodeDeConvert(parent, (AstMethodDeclNode *)node, patch);
        case AstEnumMethodNode:
            return (ORNode *)AstMethodNodeDeConvert(parent, (AstMethodNode *)node, patch);
        case AstEnumClassNode:
            return (ORNode *)AstClassNodeDeConvert(parent, (AstClassNode *)node, patch);
        case AstEnumProtocolNode:
            return (ORNode *)AstProtocolNodeDeConvert(parent, (AstProtocolNode *)node, patch);
        case AstEnumStructStatNode:
            return (ORNode *)AstStructStatNodeDeConvert(parent, (AstStructStatNode *)node, patch);
        case AstEnumUnionStatNode:
            return (ORNode *)AstUnionStatNodeDeConvert(parent, (AstUnionStatNode *)node, patch);
        case AstEnumEnumStatNode:
            return (ORNode *)AstEnumStatNodeDeConvert(parent, (AstEnumStatNode *)node, patch);
        case AstEnumTypedefStatNode:
            return (ORNode *)AstTypedefStatNodeDeConvert(parent, (AstTypedefStatNode *)node, patch);

        default: return [ORNode new];
    }
    return [ORNode new];
}
void AstNodeSerailization(AstEmptyNode *node, void *buffer, uint32_t *cursor){
    switch(node->nodeType){
        case AstEnumEmptyNode: {
            memcpy(buffer + *cursor, node, 1);
            *cursor += 1;
            break;
        }
        case AstEnumListNode:
            AstNodeListSerailization((AstNodeList *)node, buffer, cursor); break;
        case AstEnumStringCursorNode:
            AstStringCursorSerailization((AstStringCursor *) node, buffer, cursor); break;
        case AstEnumStringBufferNode:
            AstStringBufferNodeSerailization((AstStringBufferNode *) node, buffer, cursor);break;
        case AstEnumTypeNode:
            AstTypeNodeSerailization((AstTypeNode *)node, buffer, cursor); break;
        case AstEnumVariableNode:
            AstVariableNodeSerailization((AstVariableNode *)node, buffer, cursor); break;
        case AstEnumDeclaratorNode:
            AstDeclaratorNodeSerailization((AstDeclaratorNode *)node, buffer, cursor); break;
        case AstEnumFunctionDeclNode:
            AstFunctionDeclNodeSerailization((AstFunctionDeclNode *)node, buffer, cursor); break;
        case AstEnumCArrayDeclNode:
            AstCArrayDeclNodeSerailization((AstCArrayDeclNode *)node, buffer, cursor); break;
        case AstEnumBlockNode:
            AstBlockNodeSerailization((AstBlockNode *)node, buffer, cursor); break;
        case AstEnumValueNode:
            AstValueNodeSerailization((AstValueNode *)node, buffer, cursor); break;
        case AstEnumIntegerValue:
            AstIntegerValueSerailization((AstIntegerValue *)node, buffer, cursor); break;
        case AstEnumUIntegerValue:
            AstUIntegerValueSerailization((AstUIntegerValue *)node, buffer, cursor); break;
        case AstEnumDoubleValue:
            AstDoubleValueSerailization((AstDoubleValue *)node, buffer, cursor); break;
        case AstEnumBoolValue:
            AstBoolValueSerailization((AstBoolValue *)node, buffer, cursor); break;
        case AstEnumMethodCall:
            AstMethodCallSerailization((AstMethodCall *)node, buffer, cursor); break;
        case AstEnumFunctionCall:
            AstFunctionCallSerailization((AstFunctionCall *)node, buffer, cursor); break;
        case AstEnumFunctionNode:
            AstFunctionNodeSerailization((AstFunctionNode *)node, buffer, cursor); break;
        case AstEnumSubscriptNode:
            AstSubscriptNodeSerailization((AstSubscriptNode *)node, buffer, cursor); break;
        case AstEnumAssignNode:
            AstAssignNodeSerailization((AstAssignNode *)node, buffer, cursor); break;
        case AstEnumInitDeclaratorNode:
            AstInitDeclaratorNodeSerailization((AstInitDeclaratorNode *)node, buffer, cursor); break;
        case AstEnumUnaryNode:
            AstUnaryNodeSerailization((AstUnaryNode *)node, buffer, cursor); break;
        case AstEnumBinaryNode:
            AstBinaryNodeSerailization((AstBinaryNode *)node, buffer, cursor); break;
        case AstEnumTernaryNode:
            AstTernaryNodeSerailization((AstTernaryNode *)node, buffer, cursor); break;
        case AstEnumIfStatement:
            AstIfStatementSerailization((AstIfStatement *)node, buffer, cursor); break;
        case AstEnumWhileStatement:
            AstWhileStatementSerailization((AstWhileStatement *)node, buffer, cursor); break;
        case AstEnumDoWhileStatement:
            AstDoWhileStatementSerailization((AstDoWhileStatement *)node, buffer, cursor); break;
        case AstEnumCaseStatement:
            AstCaseStatementSerailization((AstCaseStatement *)node, buffer, cursor); break;
        case AstEnumSwitchStatement:
            AstSwitchStatementSerailization((AstSwitchStatement *)node, buffer, cursor); break;
        case AstEnumForStatement:
            AstForStatementSerailization((AstForStatement *)node, buffer, cursor); break;
        case AstEnumForInStatement:
            AstForInStatementSerailization((AstForInStatement *)node, buffer, cursor); break;
        case AstEnumControlStatNode:
            AstControlStatNodeSerailization((AstControlStatNode *)node, buffer, cursor); break;
        case AstEnumPropertyNode:
            AstPropertyNodeSerailization((AstPropertyNode *)node, buffer, cursor); break;
        case AstEnumMethodDeclNode:
            AstMethodDeclNodeSerailization((AstMethodDeclNode *)node, buffer, cursor); break;
        case AstEnumMethodNode:
            AstMethodNodeSerailization((AstMethodNode *)node, buffer, cursor); break;
        case AstEnumClassNode:
            AstClassNodeSerailization((AstClassNode *)node, buffer, cursor); break;
        case AstEnumProtocolNode:
            AstProtocolNodeSerailization((AstProtocolNode *)node, buffer, cursor); break;
        case AstEnumStructStatNode:
            AstStructStatNodeSerailization((AstStructStatNode *)node, buffer, cursor); break;
        case AstEnumUnionStatNode:
            AstUnionStatNodeSerailization((AstUnionStatNode *)node, buffer, cursor); break;
        case AstEnumEnumStatNode:
            AstEnumStatNodeSerailization((AstEnumStatNode *)node, buffer, cursor); break;
        case AstEnumTypedefStatNode:
            AstTypedefStatNodeSerailization((AstTypedefStatNode *)node, buffer, cursor); break;

        default: break;
    }
}
AstEmptyNode *AstNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstEnum nodeType = AstEnumEmptyNode;
    if (*cursor < bufferLength) {
        nodeType = *(AstEnum *)(buffer + *cursor);
    }
    switch(nodeType){
        case AstEnumListNode:
            return (AstEmptyNode *)AstNodeListDeserialization(buffer, cursor, bufferLength);
        case AstEnumStringCursorNode:
            return (AstEmptyNode *)AstStringCursorDeserialization(buffer, cursor, bufferLength);
        case AstEnumTypeNode:
            return (AstEmptyNode *)AstTypeNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumVariableNode:
            return (AstEmptyNode *)AstVariableNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumDeclaratorNode:
            return (AstEmptyNode *)AstDeclaratorNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumFunctionDeclNode:
            return (AstEmptyNode *)AstFunctionDeclNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumCArrayDeclNode:
            return (AstEmptyNode *)AstCArrayDeclNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumBlockNode:
            return (AstEmptyNode *)AstBlockNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumValueNode:
            return (AstEmptyNode *)AstValueNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumIntegerValue:
            return (AstEmptyNode *)AstIntegerValueDeserialization(buffer, cursor, bufferLength);
        case AstEnumUIntegerValue:
            return (AstEmptyNode *)AstUIntegerValueDeserialization(buffer, cursor, bufferLength);
        case AstEnumDoubleValue:
            return (AstEmptyNode *)AstDoubleValueDeserialization(buffer, cursor, bufferLength);
        case AstEnumBoolValue:
            return (AstEmptyNode *)AstBoolValueDeserialization(buffer, cursor, bufferLength);
        case AstEnumMethodCall:
            return (AstEmptyNode *)AstMethodCallDeserialization(buffer, cursor, bufferLength);
        case AstEnumFunctionCall:
            return (AstEmptyNode *)AstFunctionCallDeserialization(buffer, cursor, bufferLength);
        case AstEnumFunctionNode:
            return (AstEmptyNode *)AstFunctionNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumSubscriptNode:
            return (AstEmptyNode *)AstSubscriptNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumAssignNode:
            return (AstEmptyNode *)AstAssignNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumInitDeclaratorNode:
            return (AstEmptyNode *)AstInitDeclaratorNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumUnaryNode:
            return (AstEmptyNode *)AstUnaryNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumBinaryNode:
            return (AstEmptyNode *)AstBinaryNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumTernaryNode:
            return (AstEmptyNode *)AstTernaryNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumIfStatement:
            return (AstEmptyNode *)AstIfStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumWhileStatement:
            return (AstEmptyNode *)AstWhileStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumDoWhileStatement:
            return (AstEmptyNode *)AstDoWhileStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumCaseStatement:
            return (AstEmptyNode *)AstCaseStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumSwitchStatement:
            return (AstEmptyNode *)AstSwitchStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumForStatement:
            return (AstEmptyNode *)AstForStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumForInStatement:
            return (AstEmptyNode *)AstForInStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumControlStatNode:
            return (AstEmptyNode *)AstControlStatNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumPropertyNode:
            return (AstEmptyNode *)AstPropertyNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumMethodDeclNode:
            return (AstEmptyNode *)AstMethodDeclNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumMethodNode:
            return (AstEmptyNode *)AstMethodNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumClassNode:
            return (AstEmptyNode *)AstClassNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumProtocolNode:
            return (AstEmptyNode *)AstProtocolNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumStructStatNode:
            return (AstEmptyNode *)AstStructStatNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumUnionStatNode:
            return (AstEmptyNode *)AstUnionStatNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumEnumStatNode:
            return (AstEmptyNode *)AstEnumStatNodeDeserialization(buffer, cursor, bufferLength);
        case AstEnumTypedefStatNode:
            return (AstEmptyNode *)AstTypedefStatNodeDeserialization(buffer, cursor, bufferLength);

        default:{
            AstEmptyNode *node = malloc(sizeof(AstEmptyNode));
            memset(node, 0, sizeof(AstEmptyNode));
            *cursor += 1;
            return node;
        }
    }
}
void AstNodeDestroy(AstEmptyNode *node){
    if(node == NULL) return;
    switch(node->nodeType){
        case AstEnumEmptyNode:
            free(node); break;
        case AstEnumListNode:
            AstNodeListDestroy((AstNodeList *)node); break;
        case AstEnumStringCursorNode:
            AstStringCursorDestroy((AstStringCursor *) node); break;
        case AstEnumStringBufferNode:
            AstStringBufferNodeDestroy((AstStringBufferNode *) node); break;
        case AstEnumTypeNode:
            AstTypeNodeDestroy((AstTypeNode *)node); break;
        case AstEnumVariableNode:
            AstVariableNodeDestroy((AstVariableNode *)node); break;
        case AstEnumDeclaratorNode:
            AstDeclaratorNodeDestroy((AstDeclaratorNode *)node); break;
        case AstEnumFunctionDeclNode:
            AstFunctionDeclNodeDestroy((AstFunctionDeclNode *)node); break;
        case AstEnumCArrayDeclNode:
            AstCArrayDeclNodeDestroy((AstCArrayDeclNode *)node); break;
        case AstEnumBlockNode:
            AstBlockNodeDestroy((AstBlockNode *)node); break;
        case AstEnumValueNode:
            AstValueNodeDestroy((AstValueNode *)node); break;
        case AstEnumIntegerValue:
            AstIntegerValueDestroy((AstIntegerValue *)node); break;
        case AstEnumUIntegerValue:
            AstUIntegerValueDestroy((AstUIntegerValue *)node); break;
        case AstEnumDoubleValue:
            AstDoubleValueDestroy((AstDoubleValue *)node); break;
        case AstEnumBoolValue:
            AstBoolValueDestroy((AstBoolValue *)node); break;
        case AstEnumMethodCall:
            AstMethodCallDestroy((AstMethodCall *)node); break;
        case AstEnumFunctionCall:
            AstFunctionCallDestroy((AstFunctionCall *)node); break;
        case AstEnumFunctionNode:
            AstFunctionNodeDestroy((AstFunctionNode *)node); break;
        case AstEnumSubscriptNode:
            AstSubscriptNodeDestroy((AstSubscriptNode *)node); break;
        case AstEnumAssignNode:
            AstAssignNodeDestroy((AstAssignNode *)node); break;
        case AstEnumInitDeclaratorNode:
            AstInitDeclaratorNodeDestroy((AstInitDeclaratorNode *)node); break;
        case AstEnumUnaryNode:
            AstUnaryNodeDestroy((AstUnaryNode *)node); break;
        case AstEnumBinaryNode:
            AstBinaryNodeDestroy((AstBinaryNode *)node); break;
        case AstEnumTernaryNode:
            AstTernaryNodeDestroy((AstTernaryNode *)node); break;
        case AstEnumIfStatement:
            AstIfStatementDestroy((AstIfStatement *)node); break;
        case AstEnumWhileStatement:
            AstWhileStatementDestroy((AstWhileStatement *)node); break;
        case AstEnumDoWhileStatement:
            AstDoWhileStatementDestroy((AstDoWhileStatement *)node); break;
        case AstEnumCaseStatement:
            AstCaseStatementDestroy((AstCaseStatement *)node); break;
        case AstEnumSwitchStatement:
            AstSwitchStatementDestroy((AstSwitchStatement *)node); break;
        case AstEnumForStatement:
            AstForStatementDestroy((AstForStatement *)node); break;
        case AstEnumForInStatement:
            AstForInStatementDestroy((AstForInStatement *)node); break;
        case AstEnumControlStatNode:
            AstControlStatNodeDestroy((AstControlStatNode *)node); break;
        case AstEnumPropertyNode:
            AstPropertyNodeDestroy((AstPropertyNode *)node); break;
        case AstEnumMethodDeclNode:
            AstMethodDeclNodeDestroy((AstMethodDeclNode *)node); break;
        case AstEnumMethodNode:
            AstMethodNodeDestroy((AstMethodNode *)node); break;
        case AstEnumClassNode:
            AstClassNodeDestroy((AstClassNode *)node); break;
        case AstEnumProtocolNode:
            AstProtocolNodeDestroy((AstProtocolNode *)node); break;
        case AstEnumStructStatNode:
            AstStructStatNodeDestroy((AstStructStatNode *)node); break;
        case AstEnumUnionStatNode:
            AstUnionStatNodeDestroy((AstUnionStatNode *)node); break;
        case AstEnumEnumStatNode:
            AstEnumStatNodeDestroy((AstEnumStatNode *)node); break;
        case AstEnumTypedefStatNode:
            AstTypedefStatNodeDestroy((AstTypedefStatNode *)node); break;
    
        default: break;
    }
}
