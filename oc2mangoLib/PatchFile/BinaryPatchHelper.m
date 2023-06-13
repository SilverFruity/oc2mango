//  BinaryPatchHelper.m
//  Generate By BinaryPatchGenerator
//  Created by Jiang on 1686668443
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
    free(node->nodes);
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
static uint32_t AstTypeSpecialBaseLength = 5;
static uint32_t AstVariableBaseLength = 3;
static uint32_t AstTypeVarPairBaseLength = 1;
static uint32_t AstFuncVariableBaseLength = 4;
static uint32_t AstFuncDeclareBaseLength = 1;
static uint32_t AstScopeImpBaseLength = 1;
static uint32_t AstValueExpressionBaseLength = 5;
static uint32_t AstIntegerValueBaseLength = 9;
static uint32_t AstUIntegerValueBaseLength = 9;
static uint32_t AstDoubleValueBaseLength = 9;
static uint32_t AstBoolValueBaseLength = 2;
static uint32_t AstMethodCallBaseLength = 3;
static uint32_t AstCFuncCallBaseLength = 1;
static uint32_t AstFunctionImpBaseLength = 1;
static uint32_t AstSubscriptExpressionBaseLength = 1;
static uint32_t AstAssignExpressionBaseLength = 5;
static uint32_t AstDeclareExpressionBaseLength = 5;
static uint32_t AstUnaryExpressionBaseLength = 5;
static uint32_t AstBinaryExpressionBaseLength = 5;
static uint32_t AstTernaryExpressionBaseLength = 1;
static uint32_t AstIfStatementBaseLength = 1;
static uint32_t AstWhileStatementBaseLength = 1;
static uint32_t AstDoWhileStatementBaseLength = 1;
static uint32_t AstCaseStatementBaseLength = 1;
static uint32_t AstSwitchStatementBaseLength = 1;
static uint32_t AstForStatementBaseLength = 1;
static uint32_t AstForInStatementBaseLength = 1;
static uint32_t AstReturnStatementBaseLength = 1;
static uint32_t AstBreakStatementBaseLength = 1;
static uint32_t AstContinueStatementBaseLength = 1;
static uint32_t AstPropertyDeclareBaseLength = 1;
static uint32_t AstMethodDeclareBaseLength = 2;
static uint32_t AstMethodImplementationBaseLength = 1;
static uint32_t AstClassBaseLength = 1;
static uint32_t AstProtocolBaseLength = 1;
static uint32_t AstStructExpressoinBaseLength = 1;
static uint32_t AstEnumExpressoinBaseLength = 5;
static uint32_t AstTypedefExpressoinBaseLength = 1;
static uint32_t AstCArrayVariableBaseLength = 3;
static uint32_t AstUnionExpressoinBaseLength = 1;

#pragma mark - Class Convert To Struct
AstTypeSpecial *AstTypeSpecialConvert(ORTypeSpecial *exp, AstPatchFile *patch, uint32_t *length){
    AstTypeSpecial *node = malloc(sizeof(AstTypeSpecial));
    memset(node, 0, sizeof(AstTypeSpecial));
    node->nodeType = AstEnumTypeSpecial;
    node->type = exp.type;
    node->name = (AstStringCursor *)AstNodeConvert(exp.name, patch, length);
    *length += AstTypeSpecialBaseLength;
    return node;
}
AstVariable *AstVariableConvert(ORVariable *exp, AstPatchFile *patch, uint32_t *length){
    AstVariable *node = malloc(sizeof(AstVariable));
    memset(node, 0, sizeof(AstVariable));
    node->nodeType = AstEnumVariable;
    node->isBlock = exp.isBlock;
    node->ptCount = exp.ptCount;
    node->varname = (AstStringCursor *)AstNodeConvert(exp.varname, patch, length);
    *length += AstVariableBaseLength;
    return node;
}
AstTypeVarPair *AstTypeVarPairConvert(ORTypeVarPair *exp, AstPatchFile *patch, uint32_t *length){
    AstTypeVarPair *node = malloc(sizeof(AstTypeVarPair));
    memset(node, 0, sizeof(AstTypeVarPair));
    node->nodeType = AstEnumTypeVarPair;
    node->type = (AstEmptyNode *)AstNodeConvert(exp.type, patch, length);
    node->var = (AstEmptyNode *)AstNodeConvert(exp.var, patch, length);
    *length += AstTypeVarPairBaseLength;
    return node;
}
AstFuncVariable *AstFuncVariableConvert(ORFuncVariable *exp, AstPatchFile *patch, uint32_t *length){
    AstFuncVariable *node = malloc(sizeof(AstFuncVariable));
    memset(node, 0, sizeof(AstFuncVariable));
    node->nodeType = AstEnumFuncVariable;
    node->isBlock = exp.isBlock;
    node->ptCount = exp.ptCount;
    node->varname = (AstStringCursor *)AstNodeConvert(exp.varname, patch, length);
    node->isMultiArgs = exp.isMultiArgs;
    node->pairs = (AstNodeList *)AstNodeConvert(exp.pairs, patch, length);
    *length += AstFuncVariableBaseLength;
    return node;
}
AstFuncDeclare *AstFuncDeclareConvert(ORFuncDeclare *exp, AstPatchFile *patch, uint32_t *length){
    AstFuncDeclare *node = malloc(sizeof(AstFuncDeclare));
    memset(node, 0, sizeof(AstFuncDeclare));
    node->nodeType = AstEnumFuncDeclare;
    node->returnType = (AstEmptyNode *)AstNodeConvert(exp.returnType, patch, length);
    node->funVar = (AstEmptyNode *)AstNodeConvert(exp.funVar, patch, length);
    *length += AstFuncDeclareBaseLength;
    return node;
}
AstScopeImp *AstScopeImpConvert(ORScopeImp *exp, AstPatchFile *patch, uint32_t *length){
    AstScopeImp *node = malloc(sizeof(AstScopeImp));
    memset(node, 0, sizeof(AstScopeImp));
    node->nodeType = AstEnumScopeImp;
    node->statements = (AstNodeList *)AstNodeConvert(exp.statements, patch, length);
    *length += AstScopeImpBaseLength;
    return node;
}
AstValueExpression *AstValueExpressionConvert(ORValueExpression *exp, AstPatchFile *patch, uint32_t *length){
    AstValueExpression *node = malloc(sizeof(AstValueExpression));
    memset(node, 0, sizeof(AstValueExpression));
    node->nodeType = AstEnumValueExpression;
    node->value_type = exp.value_type;
    node->value = (AstEmptyNode *)AstNodeConvert(exp.value, patch, length);
    *length += AstValueExpressionBaseLength;
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
    node->isAssignedValue = exp.isAssignedValue;
    node->caller = (AstEmptyNode *)AstNodeConvert(exp.caller, patch, length);
    node->names = (AstNodeList *)AstNodeConvert(exp.names, patch, length);
    node->values = (AstNodeList *)AstNodeConvert(exp.values, patch, length);
    *length += AstMethodCallBaseLength;
    return node;
}
AstCFuncCall *AstCFuncCallConvert(ORCFuncCall *exp, AstPatchFile *patch, uint32_t *length){
    AstCFuncCall *node = malloc(sizeof(AstCFuncCall));
    memset(node, 0, sizeof(AstCFuncCall));
    node->nodeType = AstEnumCFuncCall;
    node->caller = (AstEmptyNode *)AstNodeConvert(exp.caller, patch, length);
    node->expressions = (AstNodeList *)AstNodeConvert(exp.expressions, patch, length);
    *length += AstCFuncCallBaseLength;
    return node;
}
AstFunctionImp *AstFunctionImpConvert(ORFunctionImp *exp, AstPatchFile *patch, uint32_t *length){
    AstFunctionImp *node = malloc(sizeof(AstFunctionImp));
    memset(node, 0, sizeof(AstFunctionImp));
    node->nodeType = AstEnumFunctionImp;
    node->declare = (AstEmptyNode *)AstNodeConvert(exp.declare, patch, length);
    node->scopeImp = (AstEmptyNode *)AstNodeConvert(exp.scopeImp, patch, length);
    *length += AstFunctionImpBaseLength;
    return node;
}
AstSubscriptExpression *AstSubscriptExpressionConvert(ORSubscriptExpression *exp, AstPatchFile *patch, uint32_t *length){
    AstSubscriptExpression *node = malloc(sizeof(AstSubscriptExpression));
    memset(node, 0, sizeof(AstSubscriptExpression));
    node->nodeType = AstEnumSubscriptExpression;
    node->caller = (AstEmptyNode *)AstNodeConvert(exp.caller, patch, length);
    node->keyExp = (AstEmptyNode *)AstNodeConvert(exp.keyExp, patch, length);
    *length += AstSubscriptExpressionBaseLength;
    return node;
}
AstAssignExpression *AstAssignExpressionConvert(ORAssignExpression *exp, AstPatchFile *patch, uint32_t *length){
    AstAssignExpression *node = malloc(sizeof(AstAssignExpression));
    memset(node, 0, sizeof(AstAssignExpression));
    node->nodeType = AstEnumAssignExpression;
    node->assignType = exp.assignType;
    node->value = (AstEmptyNode *)AstNodeConvert(exp.value, patch, length);
    node->expression = (AstEmptyNode *)AstNodeConvert(exp.expression, patch, length);
    *length += AstAssignExpressionBaseLength;
    return node;
}
AstDeclareExpression *AstDeclareExpressionConvert(ORDeclareExpression *exp, AstPatchFile *patch, uint32_t *length){
    AstDeclareExpression *node = malloc(sizeof(AstDeclareExpression));
    memset(node, 0, sizeof(AstDeclareExpression));
    node->nodeType = AstEnumDeclareExpression;
    node->modifier = exp.modifier;
    node->pair = (AstEmptyNode *)AstNodeConvert(exp.pair, patch, length);
    node->expression = (AstEmptyNode *)AstNodeConvert(exp.expression, patch, length);
    *length += AstDeclareExpressionBaseLength;
    return node;
}
AstUnaryExpression *AstUnaryExpressionConvert(ORUnaryExpression *exp, AstPatchFile *patch, uint32_t *length){
    AstUnaryExpression *node = malloc(sizeof(AstUnaryExpression));
    memset(node, 0, sizeof(AstUnaryExpression));
    node->nodeType = AstEnumUnaryExpression;
    node->operatorType = exp.operatorType;
    node->value = (AstEmptyNode *)AstNodeConvert(exp.value, patch, length);
    *length += AstUnaryExpressionBaseLength;
    return node;
}
AstBinaryExpression *AstBinaryExpressionConvert(ORBinaryExpression *exp, AstPatchFile *patch, uint32_t *length){
    AstBinaryExpression *node = malloc(sizeof(AstBinaryExpression));
    memset(node, 0, sizeof(AstBinaryExpression));
    node->nodeType = AstEnumBinaryExpression;
    node->operatorType = exp.operatorType;
    node->left = (AstEmptyNode *)AstNodeConvert(exp.left, patch, length);
    node->right = (AstEmptyNode *)AstNodeConvert(exp.right, patch, length);
    *length += AstBinaryExpressionBaseLength;
    return node;
}
AstTernaryExpression *AstTernaryExpressionConvert(ORTernaryExpression *exp, AstPatchFile *patch, uint32_t *length){
    AstTernaryExpression *node = malloc(sizeof(AstTernaryExpression));
    memset(node, 0, sizeof(AstTernaryExpression));
    node->nodeType = AstEnumTernaryExpression;
    node->expression = (AstEmptyNode *)AstNodeConvert(exp.expression, patch, length);
    node->values = (AstNodeList *)AstNodeConvert(exp.values, patch, length);
    *length += AstTernaryExpressionBaseLength;
    return node;
}
AstIfStatement *AstIfStatementConvert(ORIfStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstIfStatement *node = malloc(sizeof(AstIfStatement));
    memset(node, 0, sizeof(AstIfStatement));
    node->nodeType = AstEnumIfStatement;
    node->condition = (AstEmptyNode *)AstNodeConvert(exp.condition, patch, length);
    node->last = (AstEmptyNode *)AstNodeConvert(exp.last, patch, length);
    node->scopeImp = (AstEmptyNode *)AstNodeConvert(exp.scopeImp, patch, length);
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
    node->scopeImp = (AstEmptyNode *)AstNodeConvert(exp.scopeImp, patch, length);
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
AstReturnStatement *AstReturnStatementConvert(ORReturnStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstReturnStatement *node = malloc(sizeof(AstReturnStatement));
    memset(node, 0, sizeof(AstReturnStatement));
    node->nodeType = AstEnumReturnStatement;
    node->expression = (AstEmptyNode *)AstNodeConvert(exp.expression, patch, length);
    *length += AstReturnStatementBaseLength;
    return node;
}
AstBreakStatement *AstBreakStatementConvert(ORBreakStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstBreakStatement *node = malloc(sizeof(AstBreakStatement));
    memset(node, 0, sizeof(AstBreakStatement));
    node->nodeType = AstEnumBreakStatement;
    
    *length += AstBreakStatementBaseLength;
    return node;
}
AstContinueStatement *AstContinueStatementConvert(ORContinueStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstContinueStatement *node = malloc(sizeof(AstContinueStatement));
    memset(node, 0, sizeof(AstContinueStatement));
    node->nodeType = AstEnumContinueStatement;
    
    *length += AstContinueStatementBaseLength;
    return node;
}
AstPropertyDeclare *AstPropertyDeclareConvert(ORPropertyDeclare *exp, AstPatchFile *patch, uint32_t *length){
    AstPropertyDeclare *node = malloc(sizeof(AstPropertyDeclare));
    memset(node, 0, sizeof(AstPropertyDeclare));
    node->nodeType = AstEnumPropertyDeclare;
    node->keywords = (AstNodeList *)AstNodeConvert(exp.keywords, patch, length);
    node->var = (AstEmptyNode *)AstNodeConvert(exp.var, patch, length);
    *length += AstPropertyDeclareBaseLength;
    return node;
}
AstMethodDeclare *AstMethodDeclareConvert(ORMethodDeclare *exp, AstPatchFile *patch, uint32_t *length){
    AstMethodDeclare *node = malloc(sizeof(AstMethodDeclare));
    memset(node, 0, sizeof(AstMethodDeclare));
    node->nodeType = AstEnumMethodDeclare;
    node->isClassMethod = exp.isClassMethod;
    node->returnType = (AstEmptyNode *)AstNodeConvert(exp.returnType, patch, length);
    node->methodNames = (AstNodeList *)AstNodeConvert(exp.methodNames, patch, length);
    node->parameterTypes = (AstNodeList *)AstNodeConvert(exp.parameterTypes, patch, length);
    node->parameterNames = (AstNodeList *)AstNodeConvert(exp.parameterNames, patch, length);
    *length += AstMethodDeclareBaseLength;
    return node;
}
AstMethodImplementation *AstMethodImplementationConvert(ORMethodImplementation *exp, AstPatchFile *patch, uint32_t *length){
    AstMethodImplementation *node = malloc(sizeof(AstMethodImplementation));
    memset(node, 0, sizeof(AstMethodImplementation));
    node->nodeType = AstEnumMethodImplementation;
    node->declare = (AstEmptyNode *)AstNodeConvert(exp.declare, patch, length);
    node->scopeImp = (AstEmptyNode *)AstNodeConvert(exp.scopeImp, patch, length);
    *length += AstMethodImplementationBaseLength;
    return node;
}
AstClass *AstClassConvert(ORClass *exp, AstPatchFile *patch, uint32_t *length){
    AstClass *node = malloc(sizeof(AstClass));
    memset(node, 0, sizeof(AstClass));
    node->nodeType = AstEnumClass;
    node->className = (AstStringCursor *)AstNodeConvert(exp.className, patch, length);
    node->superClassName = (AstStringCursor *)AstNodeConvert(exp.superClassName, patch, length);
    node->protocols = (AstNodeList *)AstNodeConvert(exp.protocols, patch, length);
    node->properties = (AstNodeList *)AstNodeConvert(exp.properties, patch, length);
    node->privateVariables = (AstNodeList *)AstNodeConvert(exp.privateVariables, patch, length);
    node->methods = (AstNodeList *)AstNodeConvert(exp.methods, patch, length);
    *length += AstClassBaseLength;
    return node;
}
AstProtocol *AstProtocolConvert(ORProtocol *exp, AstPatchFile *patch, uint32_t *length){
    AstProtocol *node = malloc(sizeof(AstProtocol));
    memset(node, 0, sizeof(AstProtocol));
    node->nodeType = AstEnumProtocol;
    node->protcolName = (AstStringCursor *)AstNodeConvert(exp.protcolName, patch, length);
    node->protocols = (AstNodeList *)AstNodeConvert(exp.protocols, patch, length);
    node->properties = (AstNodeList *)AstNodeConvert(exp.properties, patch, length);
    node->methods = (AstNodeList *)AstNodeConvert(exp.methods, patch, length);
    *length += AstProtocolBaseLength;
    return node;
}
AstStructExpressoin *AstStructExpressoinConvert(ORStructExpressoin *exp, AstPatchFile *patch, uint32_t *length){
    AstStructExpressoin *node = malloc(sizeof(AstStructExpressoin));
    memset(node, 0, sizeof(AstStructExpressoin));
    node->nodeType = AstEnumStructExpressoin;
    node->sturctName = (AstStringCursor *)AstNodeConvert(exp.sturctName, patch, length);
    node->fields = (AstNodeList *)AstNodeConvert(exp.fields, patch, length);
    *length += AstStructExpressoinBaseLength;
    return node;
}
AstEnumExpressoin *AstEnumExpressoinConvert(OREnumExpressoin *exp, AstPatchFile *patch, uint32_t *length){
    AstEnumExpressoin *node = malloc(sizeof(AstEnumExpressoin));
    memset(node, 0, sizeof(AstEnumExpressoin));
    node->nodeType = AstEnumEnumExpressoin;
    node->valueType = exp.valueType;
    node->enumName = (AstStringCursor *)AstNodeConvert(exp.enumName, patch, length);
    node->fields = (AstNodeList *)AstNodeConvert(exp.fields, patch, length);
    *length += AstEnumExpressoinBaseLength;
    return node;
}
AstTypedefExpressoin *AstTypedefExpressoinConvert(ORTypedefExpressoin *exp, AstPatchFile *patch, uint32_t *length){
    AstTypedefExpressoin *node = malloc(sizeof(AstTypedefExpressoin));
    memset(node, 0, sizeof(AstTypedefExpressoin));
    node->nodeType = AstEnumTypedefExpressoin;
    node->expression = (AstEmptyNode *)AstNodeConvert(exp.expression, patch, length);
    node->typeNewName = (AstStringCursor *)AstNodeConvert(exp.typeNewName, patch, length);
    *length += AstTypedefExpressoinBaseLength;
    return node;
}
AstCArrayVariable *AstCArrayVariableConvert(ORCArrayVariable *exp, AstPatchFile *patch, uint32_t *length){
    AstCArrayVariable *node = malloc(sizeof(AstCArrayVariable));
    memset(node, 0, sizeof(AstCArrayVariable));
    node->nodeType = AstEnumCArrayVariable;
    node->isBlock = exp.isBlock;
    node->ptCount = exp.ptCount;
    node->varname = (AstStringCursor *)AstNodeConvert(exp.varname, patch, length);
    node->prev = (AstEmptyNode *)AstNodeConvert(exp.prev, patch, length);
    node->capacity = (AstEmptyNode *)AstNodeConvert(exp.capacity, patch, length);
    *length += AstCArrayVariableBaseLength;
    return node;
}
AstUnionExpressoin *AstUnionExpressoinConvert(ORUnionExpressoin *exp, AstPatchFile *patch, uint32_t *length){
    AstUnionExpressoin *node = malloc(sizeof(AstUnionExpressoin));
    memset(node, 0, sizeof(AstUnionExpressoin));
    node->nodeType = AstEnumUnionExpressoin;
    node->unionName = (AstStringCursor *)AstNodeConvert(exp.unionName, patch, length);
    node->fields = (AstNodeList *)AstNodeConvert(exp.fields, patch, length);
    *length += AstUnionExpressoinBaseLength;
    return node;
}

#pragma mark - Struct Convert To Class
ORTypeSpecial *AstTypeSpecialDeConvert(ORNode *parent, AstTypeSpecial *node, AstPatchFile *patch){
    ORTypeSpecial *exp = [ORTypeSpecial new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.type = node->type;
    exp.name = (NSString *)AstNodeDeConvert(exp, (AstEmptyNode *)node->name, patch);
    return exp;
}
ORVariable *AstVariableDeConvert(ORNode *parent, AstVariable *node, AstPatchFile *patch){
    ORVariable *exp = [ORVariable new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.isBlock = node->isBlock;
    exp.ptCount = node->ptCount;
    exp.varname = (NSString *)AstNodeDeConvert(exp, (AstEmptyNode *)node->varname, patch);
    return exp;
}
ORTypeVarPair *AstTypeVarPairDeConvert(ORNode *parent, AstTypeVarPair *node, AstPatchFile *patch){
    ORTypeVarPair *exp = [ORTypeVarPair new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.type = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->type, patch);
    exp.var = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->var, patch);
    return exp;
}
ORFuncVariable *AstFuncVariableDeConvert(ORNode *parent, AstFuncVariable *node, AstPatchFile *patch){
    ORFuncVariable *exp = [ORFuncVariable new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.isBlock = node->isBlock;
    exp.ptCount = node->ptCount;
    exp.varname = (NSString *)AstNodeDeConvert(exp, (AstEmptyNode *)node->varname, patch);
    exp.isMultiArgs = node->isMultiArgs;
    exp.pairs = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->pairs, patch);
    return exp;
}
ORFuncDeclare *AstFuncDeclareDeConvert(ORNode *parent, AstFuncDeclare *node, AstPatchFile *patch){
    ORFuncDeclare *exp = [ORFuncDeclare new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.returnType = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->returnType, patch);
    exp.funVar = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->funVar, patch);
    return exp;
}
ORScopeImp *AstScopeImpDeConvert(ORNode *parent, AstScopeImp *node, AstPatchFile *patch){
    ORScopeImp *exp = [ORScopeImp new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.statements = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->statements, patch);
    return exp;
}
ORValueExpression *AstValueExpressionDeConvert(ORNode *parent, AstValueExpression *node, AstPatchFile *patch){
    ORValueExpression *exp = [ORValueExpression new];
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
    exp.isAssignedValue = node->isAssignedValue;
    exp.caller = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->caller, patch);
    exp.names = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->names, patch);
    exp.values = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->values, patch);
    return exp;
}
ORCFuncCall *AstCFuncCallDeConvert(ORNode *parent, AstCFuncCall *node, AstPatchFile *patch){
    ORCFuncCall *exp = [ORCFuncCall new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.caller = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->caller, patch);
    exp.expressions = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->expressions, patch);
    return exp;
}
ORFunctionImp *AstFunctionImpDeConvert(ORNode *parent, AstFunctionImp *node, AstPatchFile *patch){
    ORFunctionImp *exp = [ORFunctionImp new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.declare = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->declare, patch);
    exp.scopeImp = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->scopeImp, patch);
    return exp;
}
ORSubscriptExpression *AstSubscriptExpressionDeConvert(ORNode *parent, AstSubscriptExpression *node, AstPatchFile *patch){
    ORSubscriptExpression *exp = [ORSubscriptExpression new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.caller = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->caller, patch);
    exp.keyExp = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->keyExp, patch);
    return exp;
}
ORAssignExpression *AstAssignExpressionDeConvert(ORNode *parent, AstAssignExpression *node, AstPatchFile *patch){
    ORAssignExpression *exp = [ORAssignExpression new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.assignType = node->assignType;
    exp.value = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->value, patch);
    exp.expression = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->expression, patch);
    return exp;
}
ORDeclareExpression *AstDeclareExpressionDeConvert(ORNode *parent, AstDeclareExpression *node, AstPatchFile *patch){
    ORDeclareExpression *exp = [ORDeclareExpression new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.modifier = node->modifier;
    exp.pair = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->pair, patch);
    exp.expression = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->expression, patch);
    return exp;
}
ORUnaryExpression *AstUnaryExpressionDeConvert(ORNode *parent, AstUnaryExpression *node, AstPatchFile *patch){
    ORUnaryExpression *exp = [ORUnaryExpression new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.operatorType = node->operatorType;
    exp.value = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->value, patch);
    return exp;
}
ORBinaryExpression *AstBinaryExpressionDeConvert(ORNode *parent, AstBinaryExpression *node, AstPatchFile *patch){
    ORBinaryExpression *exp = [ORBinaryExpression new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.operatorType = node->operatorType;
    exp.left = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->left, patch);
    exp.right = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->right, patch);
    return exp;
}
ORTernaryExpression *AstTernaryExpressionDeConvert(ORNode *parent, AstTernaryExpression *node, AstPatchFile *patch){
    ORTernaryExpression *exp = [ORTernaryExpression new];
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
    exp.last = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->last, patch);
    exp.scopeImp = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->scopeImp, patch);
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
    exp.scopeImp = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->scopeImp, patch);
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
ORReturnStatement *AstReturnStatementDeConvert(ORNode *parent, AstReturnStatement *node, AstPatchFile *patch){
    ORReturnStatement *exp = [ORReturnStatement new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.expression = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->expression, patch);
    return exp;
}
ORBreakStatement *AstBreakStatementDeConvert(ORNode *parent, AstBreakStatement *node, AstPatchFile *patch){
    ORBreakStatement *exp = [ORBreakStatement new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    
    return exp;
}
ORContinueStatement *AstContinueStatementDeConvert(ORNode *parent, AstContinueStatement *node, AstPatchFile *patch){
    ORContinueStatement *exp = [ORContinueStatement new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    
    return exp;
}
ORPropertyDeclare *AstPropertyDeclareDeConvert(ORNode *parent, AstPropertyDeclare *node, AstPatchFile *patch){
    ORPropertyDeclare *exp = [ORPropertyDeclare new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.keywords = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->keywords, patch);
    exp.var = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->var, patch);
    return exp;
}
ORMethodDeclare *AstMethodDeclareDeConvert(ORNode *parent, AstMethodDeclare *node, AstPatchFile *patch){
    ORMethodDeclare *exp = [ORMethodDeclare new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.isClassMethod = node->isClassMethod;
    exp.returnType = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->returnType, patch);
    exp.methodNames = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->methodNames, patch);
    exp.parameterTypes = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->parameterTypes, patch);
    exp.parameterNames = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->parameterNames, patch);
    return exp;
}
ORMethodImplementation *AstMethodImplementationDeConvert(ORNode *parent, AstMethodImplementation *node, AstPatchFile *patch){
    ORMethodImplementation *exp = [ORMethodImplementation new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.declare = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->declare, patch);
    exp.scopeImp = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->scopeImp, patch);
    return exp;
}
ORClass *AstClassDeConvert(ORNode *parent, AstClass *node, AstPatchFile *patch){
    ORClass *exp = [ORClass new];
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
ORProtocol *AstProtocolDeConvert(ORNode *parent, AstProtocol *node, AstPatchFile *patch){
    ORProtocol *exp = [ORProtocol new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.protcolName = (NSString *)AstNodeDeConvert(exp, (AstEmptyNode *)node->protcolName, patch);
    exp.protocols = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->protocols, patch);
    exp.properties = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->properties, patch);
    exp.methods = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->methods, patch);
    return exp;
}
ORStructExpressoin *AstStructExpressoinDeConvert(ORNode *parent, AstStructExpressoin *node, AstPatchFile *patch){
    ORStructExpressoin *exp = [ORStructExpressoin new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.sturctName = (NSString *)AstNodeDeConvert(exp, (AstEmptyNode *)node->sturctName, patch);
    exp.fields = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->fields, patch);
    return exp;
}
OREnumExpressoin *AstEnumExpressoinDeConvert(ORNode *parent, AstEnumExpressoin *node, AstPatchFile *patch){
    OREnumExpressoin *exp = [OREnumExpressoin new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.valueType = node->valueType;
    exp.enumName = (NSString *)AstNodeDeConvert(exp, (AstEmptyNode *)node->enumName, patch);
    exp.fields = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->fields, patch);
    return exp;
}
ORTypedefExpressoin *AstTypedefExpressoinDeConvert(ORNode *parent, AstTypedefExpressoin *node, AstPatchFile *patch){
    ORTypedefExpressoin *exp = [ORTypedefExpressoin new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.expression = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->expression, patch);
    exp.typeNewName = (NSString *)AstNodeDeConvert(exp, (AstEmptyNode *)node->typeNewName, patch);
    return exp;
}
ORCArrayVariable *AstCArrayVariableDeConvert(ORNode *parent, AstCArrayVariable *node, AstPatchFile *patch){
    ORCArrayVariable *exp = [ORCArrayVariable new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.isBlock = node->isBlock;
    exp.ptCount = node->ptCount;
    exp.varname = (NSString *)AstNodeDeConvert(exp, (AstEmptyNode *)node->varname, patch);
    exp.prev = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->prev, patch);
    exp.capacity = (id)AstNodeDeConvert(exp, (AstEmptyNode *)node->capacity, patch);
    return exp;
}
ORUnionExpressoin *AstUnionExpressoinDeConvert(ORNode *parent, AstUnionExpressoin *node, AstPatchFile *patch){
    ORUnionExpressoin *exp = [ORUnionExpressoin new];
    exp.parentNode = parent;
    exp.nodeType = node->nodeType;
    exp.unionName = (NSString *)AstNodeDeConvert(exp, (AstEmptyNode *)node->unionName, patch);
    exp.fields = (NSMutableArray *)AstNodeDeConvert(exp, (AstEmptyNode *)node->fields, patch);
    return exp;
}

#pragma mark - Struct Write To Buffer
void AstTypeSpecialSerailization(AstTypeSpecial *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstTypeSpecialBaseLength);
    *cursor += AstTypeSpecialBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->name, buffer, cursor);
}
void AstVariableSerailization(AstVariable *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstVariableBaseLength);
    *cursor += AstVariableBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->varname, buffer, cursor);
}
void AstTypeVarPairSerailization(AstTypeVarPair *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstTypeVarPairBaseLength);
    *cursor += AstTypeVarPairBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->type, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->var, buffer, cursor);
}
void AstFuncVariableSerailization(AstFuncVariable *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstFuncVariableBaseLength);
    *cursor += AstFuncVariableBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->varname, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->pairs, buffer, cursor);
}
void AstFuncDeclareSerailization(AstFuncDeclare *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstFuncDeclareBaseLength);
    *cursor += AstFuncDeclareBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->returnType, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->funVar, buffer, cursor);
}
void AstScopeImpSerailization(AstScopeImp *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstScopeImpBaseLength);
    *cursor += AstScopeImpBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->statements, buffer, cursor);
}
void AstValueExpressionSerailization(AstValueExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstValueExpressionBaseLength);
    *cursor += AstValueExpressionBaseLength;
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
    AstNodeSerailization((AstEmptyNode *)node->names, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->values, buffer, cursor);
}
void AstCFuncCallSerailization(AstCFuncCall *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstCFuncCallBaseLength);
    *cursor += AstCFuncCallBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->caller, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->expressions, buffer, cursor);
}
void AstFunctionImpSerailization(AstFunctionImp *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstFunctionImpBaseLength);
    *cursor += AstFunctionImpBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->declare, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->scopeImp, buffer, cursor);
}
void AstSubscriptExpressionSerailization(AstSubscriptExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstSubscriptExpressionBaseLength);
    *cursor += AstSubscriptExpressionBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->caller, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->keyExp, buffer, cursor);
}
void AstAssignExpressionSerailization(AstAssignExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstAssignExpressionBaseLength);
    *cursor += AstAssignExpressionBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->value, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->expression, buffer, cursor);
}
void AstDeclareExpressionSerailization(AstDeclareExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstDeclareExpressionBaseLength);
    *cursor += AstDeclareExpressionBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->pair, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->expression, buffer, cursor);
}
void AstUnaryExpressionSerailization(AstUnaryExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstUnaryExpressionBaseLength);
    *cursor += AstUnaryExpressionBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->value, buffer, cursor);
}
void AstBinaryExpressionSerailization(AstBinaryExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstBinaryExpressionBaseLength);
    *cursor += AstBinaryExpressionBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->left, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->right, buffer, cursor);
}
void AstTernaryExpressionSerailization(AstTernaryExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstTernaryExpressionBaseLength);
    *cursor += AstTernaryExpressionBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->expression, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->values, buffer, cursor);
}
void AstIfStatementSerailization(AstIfStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstIfStatementBaseLength);
    *cursor += AstIfStatementBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->condition, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->last, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->scopeImp, buffer, cursor);
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
    AstNodeSerailization((AstEmptyNode *)node->scopeImp, buffer, cursor);
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
void AstReturnStatementSerailization(AstReturnStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstReturnStatementBaseLength);
    *cursor += AstReturnStatementBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->expression, buffer, cursor);
}
void AstBreakStatementSerailization(AstBreakStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstBreakStatementBaseLength);
    *cursor += AstBreakStatementBaseLength;
    
}
void AstContinueStatementSerailization(AstContinueStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstContinueStatementBaseLength);
    *cursor += AstContinueStatementBaseLength;
    
}
void AstPropertyDeclareSerailization(AstPropertyDeclare *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstPropertyDeclareBaseLength);
    *cursor += AstPropertyDeclareBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->keywords, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->var, buffer, cursor);
}
void AstMethodDeclareSerailization(AstMethodDeclare *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstMethodDeclareBaseLength);
    *cursor += AstMethodDeclareBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->returnType, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->methodNames, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->parameterTypes, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->parameterNames, buffer, cursor);
}
void AstMethodImplementationSerailization(AstMethodImplementation *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstMethodImplementationBaseLength);
    *cursor += AstMethodImplementationBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->declare, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->scopeImp, buffer, cursor);
}
void AstClassSerailization(AstClass *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstClassBaseLength);
    *cursor += AstClassBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->className, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->superClassName, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->protocols, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->properties, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->privateVariables, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->methods, buffer, cursor);
}
void AstProtocolSerailization(AstProtocol *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstProtocolBaseLength);
    *cursor += AstProtocolBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->protcolName, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->protocols, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->properties, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->methods, buffer, cursor);
}
void AstStructExpressoinSerailization(AstStructExpressoin *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstStructExpressoinBaseLength);
    *cursor += AstStructExpressoinBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->sturctName, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->fields, buffer, cursor);
}
void AstEnumExpressoinSerailization(AstEnumExpressoin *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstEnumExpressoinBaseLength);
    *cursor += AstEnumExpressoinBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->enumName, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->fields, buffer, cursor);
}
void AstTypedefExpressoinSerailization(AstTypedefExpressoin *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstTypedefExpressoinBaseLength);
    *cursor += AstTypedefExpressoinBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->expression, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->typeNewName, buffer, cursor);
}
void AstCArrayVariableSerailization(AstCArrayVariable *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstCArrayVariableBaseLength);
    *cursor += AstCArrayVariableBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->varname, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->prev, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->capacity, buffer, cursor);
}
void AstUnionExpressoinSerailization(AstUnionExpressoin *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstUnionExpressoinBaseLength);
    *cursor += AstUnionExpressoinBaseLength;
    AstNodeSerailization((AstEmptyNode *)node->unionName, buffer, cursor);
    AstNodeSerailization((AstEmptyNode *)node->fields, buffer, cursor);
}

#pragma mark - Buffer Data Convert To Struct
AstTypeSpecial *AstTypeSpecialDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstTypeSpecial *node = malloc(sizeof(AstTypeSpecial));
    memcpy(node, buffer + *cursor, AstTypeSpecialBaseLength);
    *cursor += AstTypeSpecialBaseLength;
    node->name =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstVariable *AstVariableDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstVariable *node = malloc(sizeof(AstVariable));
    memcpy(node, buffer + *cursor, AstVariableBaseLength);
    *cursor += AstVariableBaseLength;
    node->varname =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstTypeVarPair *AstTypeVarPairDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstTypeVarPair *node = malloc(sizeof(AstTypeVarPair));
    memcpy(node, buffer + *cursor, AstTypeVarPairBaseLength);
    *cursor += AstTypeVarPairBaseLength;
    node->type =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->var =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstFuncVariable *AstFuncVariableDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstFuncVariable *node = malloc(sizeof(AstFuncVariable));
    memcpy(node, buffer + *cursor, AstFuncVariableBaseLength);
    *cursor += AstFuncVariableBaseLength;
    node->varname =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->pairs =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstFuncDeclare *AstFuncDeclareDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstFuncDeclare *node = malloc(sizeof(AstFuncDeclare));
    memcpy(node, buffer + *cursor, AstFuncDeclareBaseLength);
    *cursor += AstFuncDeclareBaseLength;
    node->returnType =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->funVar =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstScopeImp *AstScopeImpDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstScopeImp *node = malloc(sizeof(AstScopeImp));
    memcpy(node, buffer + *cursor, AstScopeImpBaseLength);
    *cursor += AstScopeImpBaseLength;
    node->statements =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstValueExpression *AstValueExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstValueExpression *node = malloc(sizeof(AstValueExpression));
    memcpy(node, buffer + *cursor, AstValueExpressionBaseLength);
    *cursor += AstValueExpressionBaseLength;
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
    node->names =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->values =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstCFuncCall *AstCFuncCallDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstCFuncCall *node = malloc(sizeof(AstCFuncCall));
    memcpy(node, buffer + *cursor, AstCFuncCallBaseLength);
    *cursor += AstCFuncCallBaseLength;
    node->caller =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->expressions =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstFunctionImp *AstFunctionImpDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstFunctionImp *node = malloc(sizeof(AstFunctionImp));
    memcpy(node, buffer + *cursor, AstFunctionImpBaseLength);
    *cursor += AstFunctionImpBaseLength;
    node->declare =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstSubscriptExpression *AstSubscriptExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstSubscriptExpression *node = malloc(sizeof(AstSubscriptExpression));
    memcpy(node, buffer + *cursor, AstSubscriptExpressionBaseLength);
    *cursor += AstSubscriptExpressionBaseLength;
    node->caller =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->keyExp =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstAssignExpression *AstAssignExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstAssignExpression *node = malloc(sizeof(AstAssignExpression));
    memcpy(node, buffer + *cursor, AstAssignExpressionBaseLength);
    *cursor += AstAssignExpressionBaseLength;
    node->value =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->expression =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstDeclareExpression *AstDeclareExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstDeclareExpression *node = malloc(sizeof(AstDeclareExpression));
    memcpy(node, buffer + *cursor, AstDeclareExpressionBaseLength);
    *cursor += AstDeclareExpressionBaseLength;
    node->pair =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->expression =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstUnaryExpression *AstUnaryExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstUnaryExpression *node = malloc(sizeof(AstUnaryExpression));
    memcpy(node, buffer + *cursor, AstUnaryExpressionBaseLength);
    *cursor += AstUnaryExpressionBaseLength;
    node->value =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstBinaryExpression *AstBinaryExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstBinaryExpression *node = malloc(sizeof(AstBinaryExpression));
    memcpy(node, buffer + *cursor, AstBinaryExpressionBaseLength);
    *cursor += AstBinaryExpressionBaseLength;
    node->left =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->right =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstTernaryExpression *AstTernaryExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstTernaryExpression *node = malloc(sizeof(AstTernaryExpression));
    memcpy(node, buffer + *cursor, AstTernaryExpressionBaseLength);
    *cursor += AstTernaryExpressionBaseLength;
    node->expression =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->values =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstIfStatement *AstIfStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstIfStatement *node = malloc(sizeof(AstIfStatement));
    memcpy(node, buffer + *cursor, AstIfStatementBaseLength);
    *cursor += AstIfStatementBaseLength;
    node->condition =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->last =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
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
    node->scopeImp =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
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
AstReturnStatement *AstReturnStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstReturnStatement *node = malloc(sizeof(AstReturnStatement));
    memcpy(node, buffer + *cursor, AstReturnStatementBaseLength);
    *cursor += AstReturnStatementBaseLength;
    node->expression =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstBreakStatement *AstBreakStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstBreakStatement *node = malloc(sizeof(AstBreakStatement));
    memcpy(node, buffer + *cursor, AstBreakStatementBaseLength);
    *cursor += AstBreakStatementBaseLength;
    
    return node;
}
AstContinueStatement *AstContinueStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstContinueStatement *node = malloc(sizeof(AstContinueStatement));
    memcpy(node, buffer + *cursor, AstContinueStatementBaseLength);
    *cursor += AstContinueStatementBaseLength;
    
    return node;
}
AstPropertyDeclare *AstPropertyDeclareDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstPropertyDeclare *node = malloc(sizeof(AstPropertyDeclare));
    memcpy(node, buffer + *cursor, AstPropertyDeclareBaseLength);
    *cursor += AstPropertyDeclareBaseLength;
    node->keywords =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->var =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstMethodDeclare *AstMethodDeclareDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstMethodDeclare *node = malloc(sizeof(AstMethodDeclare));
    memcpy(node, buffer + *cursor, AstMethodDeclareBaseLength);
    *cursor += AstMethodDeclareBaseLength;
    node->returnType =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->methodNames =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->parameterTypes =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->parameterNames =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstMethodImplementation *AstMethodImplementationDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstMethodImplementation *node = malloc(sizeof(AstMethodImplementation));
    memcpy(node, buffer + *cursor, AstMethodImplementationBaseLength);
    *cursor += AstMethodImplementationBaseLength;
    node->declare =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstClass *AstClassDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstClass *node = malloc(sizeof(AstClass));
    memcpy(node, buffer + *cursor, AstClassBaseLength);
    *cursor += AstClassBaseLength;
    node->className =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->superClassName =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->protocols =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->properties =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->privateVariables =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->methods =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstProtocol *AstProtocolDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstProtocol *node = malloc(sizeof(AstProtocol));
    memcpy(node, buffer + *cursor, AstProtocolBaseLength);
    *cursor += AstProtocolBaseLength;
    node->protcolName =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->protocols =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->properties =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->methods =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstStructExpressoin *AstStructExpressoinDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstStructExpressoin *node = malloc(sizeof(AstStructExpressoin));
    memcpy(node, buffer + *cursor, AstStructExpressoinBaseLength);
    *cursor += AstStructExpressoinBaseLength;
    node->sturctName =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->fields =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstEnumExpressoin *AstEnumExpressoinDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstEnumExpressoin *node = malloc(sizeof(AstEnumExpressoin));
    memcpy(node, buffer + *cursor, AstEnumExpressoinBaseLength);
    *cursor += AstEnumExpressoinBaseLength;
    node->enumName =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->fields =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstTypedefExpressoin *AstTypedefExpressoinDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstTypedefExpressoin *node = malloc(sizeof(AstTypedefExpressoin));
    memcpy(node, buffer + *cursor, AstTypedefExpressoinBaseLength);
    *cursor += AstTypedefExpressoinBaseLength;
    node->expression =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->typeNewName =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstCArrayVariable *AstCArrayVariableDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstCArrayVariable *node = malloc(sizeof(AstCArrayVariable));
    memcpy(node, buffer + *cursor, AstCArrayVariableBaseLength);
    *cursor += AstCArrayVariableBaseLength;
    node->varname =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->prev =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->capacity =(AstEmptyNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
AstUnionExpressoin *AstUnionExpressoinDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstUnionExpressoin *node = malloc(sizeof(AstUnionExpressoin));
    memcpy(node, buffer + *cursor, AstUnionExpressoinBaseLength);
    *cursor += AstUnionExpressoinBaseLength;
    node->unionName =(AstStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->fields =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}

#pragma mark - Free Struct Memory
void AstTypeSpecialDestroy(AstTypeSpecial *node){
    AstNodeDestroy((AstEmptyNode *)node->name);
    free(node);
}
void AstVariableDestroy(AstVariable *node){
    AstNodeDestroy((AstEmptyNode *)node->varname);
    free(node);
}
void AstTypeVarPairDestroy(AstTypeVarPair *node){
    AstNodeDestroy((AstEmptyNode *)node->type);
    AstNodeDestroy((AstEmptyNode *)node->var);
    free(node);
}
void AstFuncVariableDestroy(AstFuncVariable *node){
    AstNodeDestroy((AstEmptyNode *)node->varname);
    AstNodeDestroy((AstEmptyNode *)node->pairs);
    free(node);
}
void AstFuncDeclareDestroy(AstFuncDeclare *node){
    AstNodeDestroy((AstEmptyNode *)node->returnType);
    AstNodeDestroy((AstEmptyNode *)node->funVar);
    free(node);
}
void AstScopeImpDestroy(AstScopeImp *node){
    AstNodeDestroy((AstEmptyNode *)node->statements);
    free(node);
}
void AstValueExpressionDestroy(AstValueExpression *node){
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
    AstNodeDestroy((AstEmptyNode *)node->names);
    AstNodeDestroy((AstEmptyNode *)node->values);
    free(node);
}
void AstCFuncCallDestroy(AstCFuncCall *node){
    AstNodeDestroy((AstEmptyNode *)node->caller);
    AstNodeDestroy((AstEmptyNode *)node->expressions);
    free(node);
}
void AstFunctionImpDestroy(AstFunctionImp *node){
    AstNodeDestroy((AstEmptyNode *)node->declare);
    AstNodeDestroy((AstEmptyNode *)node->scopeImp);
    free(node);
}
void AstSubscriptExpressionDestroy(AstSubscriptExpression *node){
    AstNodeDestroy((AstEmptyNode *)node->caller);
    AstNodeDestroy((AstEmptyNode *)node->keyExp);
    free(node);
}
void AstAssignExpressionDestroy(AstAssignExpression *node){
    AstNodeDestroy((AstEmptyNode *)node->value);
    AstNodeDestroy((AstEmptyNode *)node->expression);
    free(node);
}
void AstDeclareExpressionDestroy(AstDeclareExpression *node){
    AstNodeDestroy((AstEmptyNode *)node->pair);
    AstNodeDestroy((AstEmptyNode *)node->expression);
    free(node);
}
void AstUnaryExpressionDestroy(AstUnaryExpression *node){
    AstNodeDestroy((AstEmptyNode *)node->value);
    free(node);
}
void AstBinaryExpressionDestroy(AstBinaryExpression *node){
    AstNodeDestroy((AstEmptyNode *)node->left);
    AstNodeDestroy((AstEmptyNode *)node->right);
    free(node);
}
void AstTernaryExpressionDestroy(AstTernaryExpression *node){
    AstNodeDestroy((AstEmptyNode *)node->expression);
    AstNodeDestroy((AstEmptyNode *)node->values);
    free(node);
}
void AstIfStatementDestroy(AstIfStatement *node){
    AstNodeDestroy((AstEmptyNode *)node->condition);
    AstNodeDestroy((AstEmptyNode *)node->last);
    AstNodeDestroy((AstEmptyNode *)node->scopeImp);
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
    AstNodeDestroy((AstEmptyNode *)node->scopeImp);
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
void AstReturnStatementDestroy(AstReturnStatement *node){
    AstNodeDestroy((AstEmptyNode *)node->expression);
    free(node);
}
void AstBreakStatementDestroy(AstBreakStatement *node){
    
    free(node);
}
void AstContinueStatementDestroy(AstContinueStatement *node){
    
    free(node);
}
void AstPropertyDeclareDestroy(AstPropertyDeclare *node){
    AstNodeDestroy((AstEmptyNode *)node->keywords);
    AstNodeDestroy((AstEmptyNode *)node->var);
    free(node);
}
void AstMethodDeclareDestroy(AstMethodDeclare *node){
    AstNodeDestroy((AstEmptyNode *)node->returnType);
    AstNodeDestroy((AstEmptyNode *)node->methodNames);
    AstNodeDestroy((AstEmptyNode *)node->parameterTypes);
    AstNodeDestroy((AstEmptyNode *)node->parameterNames);
    free(node);
}
void AstMethodImplementationDestroy(AstMethodImplementation *node){
    AstNodeDestroy((AstEmptyNode *)node->declare);
    AstNodeDestroy((AstEmptyNode *)node->scopeImp);
    free(node);
}
void AstClassDestroy(AstClass *node){
    AstNodeDestroy((AstEmptyNode *)node->className);
    AstNodeDestroy((AstEmptyNode *)node->superClassName);
    AstNodeDestroy((AstEmptyNode *)node->protocols);
    AstNodeDestroy((AstEmptyNode *)node->properties);
    AstNodeDestroy((AstEmptyNode *)node->privateVariables);
    AstNodeDestroy((AstEmptyNode *)node->methods);
    free(node);
}
void AstProtocolDestroy(AstProtocol *node){
    AstNodeDestroy((AstEmptyNode *)node->protcolName);
    AstNodeDestroy((AstEmptyNode *)node->protocols);
    AstNodeDestroy((AstEmptyNode *)node->properties);
    AstNodeDestroy((AstEmptyNode *)node->methods);
    free(node);
}
void AstStructExpressoinDestroy(AstStructExpressoin *node){
    AstNodeDestroy((AstEmptyNode *)node->sturctName);
    AstNodeDestroy((AstEmptyNode *)node->fields);
    free(node);
}
void AstEnumExpressoinDestroy(AstEnumExpressoin *node){
    AstNodeDestroy((AstEmptyNode *)node->enumName);
    AstNodeDestroy((AstEmptyNode *)node->fields);
    free(node);
}
void AstTypedefExpressoinDestroy(AstTypedefExpressoin *node){
    AstNodeDestroy((AstEmptyNode *)node->expression);
    AstNodeDestroy((AstEmptyNode *)node->typeNewName);
    free(node);
}
void AstCArrayVariableDestroy(AstCArrayVariable *node){
    AstNodeDestroy((AstEmptyNode *)node->varname);
    AstNodeDestroy((AstEmptyNode *)node->prev);
    AstNodeDestroy((AstEmptyNode *)node->capacity);
    free(node);
}
void AstUnionExpressoinDestroy(AstUnionExpressoin *node){
    AstNodeDestroy((AstEmptyNode *)node->unionName);
    AstNodeDestroy((AstEmptyNode *)node->fields);
    free(node);
}

#pragma mark - Add NodeType To Node
void AstNodeTagged(id parentNode, id node);
void ORTypeSpecialTagged(id parentNode, ORTypeSpecial *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumTypeSpecial;
    
}
void ORVariableTagged(id parentNode, ORVariable *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumVariable;
    
}
void ORTypeVarPairTagged(id parentNode, ORTypeVarPair *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumTypeVarPair;
    AstNodeTagged(exp, exp.type);
    AstNodeTagged(exp, exp.var);
}
void ORFuncVariableTagged(id parentNode, ORFuncVariable *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumFuncVariable;
    AstNodeTagged(exp, exp.pairs);
}
void ORFuncDeclareTagged(id parentNode, ORFuncDeclare *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumFuncDeclare;
    AstNodeTagged(exp, exp.returnType);
    AstNodeTagged(exp, exp.funVar);
}
void ORScopeImpTagged(id parentNode, ORScopeImp *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumScopeImp;
    AstNodeTagged(exp, exp.statements);
}
void ORValueExpressionTagged(id parentNode, ORValueExpression *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumValueExpression;
    AstNodeTagged(exp, exp.value);
}
void ORIntegerValueTagged(id parentNode, ORIntegerValue *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumIntegerValue;
    
}
void ORUIntegerValueTagged(id parentNode, ORUIntegerValue *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumUIntegerValue;
    
}
void ORDoubleValueTagged(id parentNode, ORDoubleValue *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumDoubleValue;
    
}
void ORBoolValueTagged(id parentNode, ORBoolValue *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumBoolValue;
    
}
void ORMethodCallTagged(id parentNode, ORMethodCall *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumMethodCall;
    AstNodeTagged(exp, exp.caller);
    AstNodeTagged(exp, exp.names);
    AstNodeTagged(exp, exp.values);
}
void ORCFuncCallTagged(id parentNode, ORCFuncCall *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumCFuncCall;
    AstNodeTagged(exp, exp.caller);
    AstNodeTagged(exp, exp.expressions);
}
void ORFunctionImpTagged(id parentNode, ORFunctionImp *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumFunctionImp;
    AstNodeTagged(exp, exp.declare);
    AstNodeTagged(exp, exp.scopeImp);
}
void ORSubscriptExpressionTagged(id parentNode, ORSubscriptExpression *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumSubscriptExpression;
    AstNodeTagged(exp, exp.caller);
    AstNodeTagged(exp, exp.keyExp);
}
void ORAssignExpressionTagged(id parentNode, ORAssignExpression *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumAssignExpression;
    AstNodeTagged(exp, exp.value);
    AstNodeTagged(exp, exp.expression);
}
void ORDeclareExpressionTagged(id parentNode, ORDeclareExpression *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumDeclareExpression;
    AstNodeTagged(exp, exp.pair);
    AstNodeTagged(exp, exp.expression);
}
void ORUnaryExpressionTagged(id parentNode, ORUnaryExpression *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumUnaryExpression;
    AstNodeTagged(exp, exp.value);
}
void ORBinaryExpressionTagged(id parentNode, ORBinaryExpression *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumBinaryExpression;
    AstNodeTagged(exp, exp.left);
    AstNodeTagged(exp, exp.right);
}
void ORTernaryExpressionTagged(id parentNode, ORTernaryExpression *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumTernaryExpression;
    AstNodeTagged(exp, exp.expression);
    AstNodeTagged(exp, exp.values);
}
void ORIfStatementTagged(id parentNode, ORIfStatement *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumIfStatement;
    AstNodeTagged(exp, exp.condition);
    AstNodeTagged(exp, exp.last);
    AstNodeTagged(exp, exp.scopeImp);
}
void ORWhileStatementTagged(id parentNode, ORWhileStatement *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumWhileStatement;
    AstNodeTagged(exp, exp.condition);
    AstNodeTagged(exp, exp.scopeImp);
}
void ORDoWhileStatementTagged(id parentNode, ORDoWhileStatement *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumDoWhileStatement;
    AstNodeTagged(exp, exp.condition);
    AstNodeTagged(exp, exp.scopeImp);
}
void ORCaseStatementTagged(id parentNode, ORCaseStatement *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumCaseStatement;
    AstNodeTagged(exp, exp.value);
    AstNodeTagged(exp, exp.scopeImp);
}
void ORSwitchStatementTagged(id parentNode, ORSwitchStatement *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumSwitchStatement;
    AstNodeTagged(exp, exp.value);
    AstNodeTagged(exp, exp.cases);
    AstNodeTagged(exp, exp.scopeImp);
}
void ORForStatementTagged(id parentNode, ORForStatement *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumForStatement;
    AstNodeTagged(exp, exp.varExpressions);
    AstNodeTagged(exp, exp.condition);
    AstNodeTagged(exp, exp.expressions);
    AstNodeTagged(exp, exp.scopeImp);
}
void ORForInStatementTagged(id parentNode, ORForInStatement *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumForInStatement;
    AstNodeTagged(exp, exp.expression);
    AstNodeTagged(exp, exp.value);
    AstNodeTagged(exp, exp.scopeImp);
}
void ORReturnStatementTagged(id parentNode, ORReturnStatement *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumReturnStatement;
    AstNodeTagged(exp, exp.expression);
}
void ORBreakStatementTagged(id parentNode, ORBreakStatement *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumBreakStatement;
    
}
void ORContinueStatementTagged(id parentNode, ORContinueStatement *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumContinueStatement;
    
}
void ORPropertyDeclareTagged(id parentNode, ORPropertyDeclare *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumPropertyDeclare;
    AstNodeTagged(exp, exp.keywords);
    AstNodeTagged(exp, exp.var);
}
void ORMethodDeclareTagged(id parentNode, ORMethodDeclare *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumMethodDeclare;
    AstNodeTagged(exp, exp.returnType);
    AstNodeTagged(exp, exp.methodNames);
    AstNodeTagged(exp, exp.parameterTypes);
    AstNodeTagged(exp, exp.parameterNames);
}
void ORMethodImplementationTagged(id parentNode, ORMethodImplementation *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumMethodImplementation;
    AstNodeTagged(exp, exp.declare);
    AstNodeTagged(exp, exp.scopeImp);
}
void ORClassTagged(id parentNode, ORClass *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumClass;
    AstNodeTagged(exp, exp.protocols);
    AstNodeTagged(exp, exp.properties);
    AstNodeTagged(exp, exp.privateVariables);
    AstNodeTagged(exp, exp.methods);
}
void ORProtocolTagged(id parentNode, ORProtocol *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumProtocol;
    AstNodeTagged(exp, exp.protocols);
    AstNodeTagged(exp, exp.properties);
    AstNodeTagged(exp, exp.methods);
}
void ORStructExpressoinTagged(id parentNode, ORStructExpressoin *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumStructExpressoin;
    AstNodeTagged(exp, exp.fields);
}
void OREnumExpressoinTagged(id parentNode, OREnumExpressoin *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumEnumExpressoin;
    AstNodeTagged(exp, exp.fields);
}
void ORTypedefExpressoinTagged(id parentNode, ORTypedefExpressoin *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumTypedefExpressoin;
    AstNodeTagged(exp, exp.expression);
}
void ORCArrayVariableTagged(id parentNode, ORCArrayVariable *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumCArrayVariable;
    AstNodeTagged(exp, exp.prev);
    AstNodeTagged(exp, exp.capacity);
}
void ORUnionExpressoinTagged(id parentNode, ORUnionExpressoin *exp){
    exp.parentNode = parentNode;
    exp.nodeType = AstEnumUnionExpressoin;
    AstNodeTagged(exp, exp.fields);
}

#pragma mark - Dispatch
AstEmptyNode *AstNodeConvert(id exp, AstPatchFile *patch, uint32_t *length){
    if ([exp isKindOfClass:[NSString class]]) {
        return (AstEmptyNode *)createStringCursor((NSString *)exp, patch, length);
    }else if ([exp isKindOfClass:[NSArray class]]) {
        return (AstEmptyNode *)AstNodeListConvert((NSArray *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORCArrayVariable class]]){
        return (AstEmptyNode *)AstCArrayVariableConvert((ORCArrayVariable *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORFuncVariable class]]){
        return (AstEmptyNode *)AstFuncVariableConvert((ORFuncVariable *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORTypeSpecial class]]){
        return (AstEmptyNode *)AstTypeSpecialConvert((ORTypeSpecial *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORVariable class]]){
        return (AstEmptyNode *)AstVariableConvert((ORVariable *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORTypeVarPair class]]){
        return (AstEmptyNode *)AstTypeVarPairConvert((ORTypeVarPair *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORFuncDeclare class]]){
        return (AstEmptyNode *)AstFuncDeclareConvert((ORFuncDeclare *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORScopeImp class]]){
        return (AstEmptyNode *)AstScopeImpConvert((ORScopeImp *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORValueExpression class]]){
        return (AstEmptyNode *)AstValueExpressionConvert((ORValueExpression *)exp, patch, length);
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
    }else if ([exp isKindOfClass:[ORCFuncCall class]]){
        return (AstEmptyNode *)AstCFuncCallConvert((ORCFuncCall *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORFunctionImp class]]){
        return (AstEmptyNode *)AstFunctionImpConvert((ORFunctionImp *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORSubscriptExpression class]]){
        return (AstEmptyNode *)AstSubscriptExpressionConvert((ORSubscriptExpression *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORAssignExpression class]]){
        return (AstEmptyNode *)AstAssignExpressionConvert((ORAssignExpression *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORDeclareExpression class]]){
        return (AstEmptyNode *)AstDeclareExpressionConvert((ORDeclareExpression *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORUnaryExpression class]]){
        return (AstEmptyNode *)AstUnaryExpressionConvert((ORUnaryExpression *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORBinaryExpression class]]){
        return (AstEmptyNode *)AstBinaryExpressionConvert((ORBinaryExpression *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORTernaryExpression class]]){
        return (AstEmptyNode *)AstTernaryExpressionConvert((ORTernaryExpression *)exp, patch, length);
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
    }else if ([exp isKindOfClass:[ORReturnStatement class]]){
        return (AstEmptyNode *)AstReturnStatementConvert((ORReturnStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORBreakStatement class]]){
        return (AstEmptyNode *)AstBreakStatementConvert((ORBreakStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORContinueStatement class]]){
        return (AstEmptyNode *)AstContinueStatementConvert((ORContinueStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORPropertyDeclare class]]){
        return (AstEmptyNode *)AstPropertyDeclareConvert((ORPropertyDeclare *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORMethodDeclare class]]){
        return (AstEmptyNode *)AstMethodDeclareConvert((ORMethodDeclare *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORMethodImplementation class]]){
        return (AstEmptyNode *)AstMethodImplementationConvert((ORMethodImplementation *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORClass class]]){
        return (AstEmptyNode *)AstClassConvert((ORClass *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORProtocol class]]){
        return (AstEmptyNode *)AstProtocolConvert((ORProtocol *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORStructExpressoin class]]){
        return (AstEmptyNode *)AstStructExpressoinConvert((ORStructExpressoin *)exp, patch, length);
    }else if ([exp isKindOfClass:[OREnumExpressoin class]]){
        return (AstEmptyNode *)AstEnumExpressoinConvert((OREnumExpressoin *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORTypedefExpressoin class]]){
        return (AstEmptyNode *)AstTypedefExpressoinConvert((ORTypedefExpressoin *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORUnionExpressoin class]]){
        return (AstEmptyNode *)AstUnionExpressoinConvert((ORUnionExpressoin *)exp, patch, length);
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
        case AstEnumTypeSpecial:
            return (ORNode *)AstTypeSpecialDeConvert(parent, (AstTypeSpecial *)node, patch);
        case AstEnumVariable:
            return (ORNode *)AstVariableDeConvert(parent, (AstVariable *)node, patch);
        case AstEnumTypeVarPair:
            return (ORNode *)AstTypeVarPairDeConvert(parent, (AstTypeVarPair *)node, patch);
        case AstEnumFuncVariable:
            return (ORNode *)AstFuncVariableDeConvert(parent, (AstFuncVariable *)node, patch);
        case AstEnumFuncDeclare:
            return (ORNode *)AstFuncDeclareDeConvert(parent, (AstFuncDeclare *)node, patch);
        case AstEnumScopeImp:
            return (ORNode *)AstScopeImpDeConvert(parent, (AstScopeImp *)node, patch);
        case AstEnumValueExpression:
            return (ORNode *)AstValueExpressionDeConvert(parent, (AstValueExpression *)node, patch);
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
        case AstEnumCFuncCall:
            return (ORNode *)AstCFuncCallDeConvert(parent, (AstCFuncCall *)node, patch);
        case AstEnumFunctionImp:
            return (ORNode *)AstFunctionImpDeConvert(parent, (AstFunctionImp *)node, patch);
        case AstEnumSubscriptExpression:
            return (ORNode *)AstSubscriptExpressionDeConvert(parent, (AstSubscriptExpression *)node, patch);
        case AstEnumAssignExpression:
            return (ORNode *)AstAssignExpressionDeConvert(parent, (AstAssignExpression *)node, patch);
        case AstEnumDeclareExpression:
            return (ORNode *)AstDeclareExpressionDeConvert(parent, (AstDeclareExpression *)node, patch);
        case AstEnumUnaryExpression:
            return (ORNode *)AstUnaryExpressionDeConvert(parent, (AstUnaryExpression *)node, patch);
        case AstEnumBinaryExpression:
            return (ORNode *)AstBinaryExpressionDeConvert(parent, (AstBinaryExpression *)node, patch);
        case AstEnumTernaryExpression:
            return (ORNode *)AstTernaryExpressionDeConvert(parent, (AstTernaryExpression *)node, patch);
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
        case AstEnumReturnStatement:
            return (ORNode *)AstReturnStatementDeConvert(parent, (AstReturnStatement *)node, patch);
        case AstEnumBreakStatement:
            return (ORNode *)AstBreakStatementDeConvert(parent, (AstBreakStatement *)node, patch);
        case AstEnumContinueStatement:
            return (ORNode *)AstContinueStatementDeConvert(parent, (AstContinueStatement *)node, patch);
        case AstEnumPropertyDeclare:
            return (ORNode *)AstPropertyDeclareDeConvert(parent, (AstPropertyDeclare *)node, patch);
        case AstEnumMethodDeclare:
            return (ORNode *)AstMethodDeclareDeConvert(parent, (AstMethodDeclare *)node, patch);
        case AstEnumMethodImplementation:
            return (ORNode *)AstMethodImplementationDeConvert(parent, (AstMethodImplementation *)node, patch);
        case AstEnumClass:
            return (ORNode *)AstClassDeConvert(parent, (AstClass *)node, patch);
        case AstEnumProtocol:
            return (ORNode *)AstProtocolDeConvert(parent, (AstProtocol *)node, patch);
        case AstEnumStructExpressoin:
            return (ORNode *)AstStructExpressoinDeConvert(parent, (AstStructExpressoin *)node, patch);
        case AstEnumEnumExpressoin:
            return (ORNode *)AstEnumExpressoinDeConvert(parent, (AstEnumExpressoin *)node, patch);
        case AstEnumTypedefExpressoin:
            return (ORNode *)AstTypedefExpressoinDeConvert(parent, (AstTypedefExpressoin *)node, patch);
        case AstEnumCArrayVariable:
            return (ORNode *)AstCArrayVariableDeConvert(parent, (AstCArrayVariable *)node, patch);
        case AstEnumUnionExpressoin:
            return (ORNode *)AstUnionExpressoinDeConvert(parent, (AstUnionExpressoin *)node, patch);

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
        case AstEnumTypeSpecial:
            AstTypeSpecialSerailization((AstTypeSpecial *)node, buffer, cursor); break;
        case AstEnumVariable:
            AstVariableSerailization((AstVariable *)node, buffer, cursor); break;
        case AstEnumTypeVarPair:
            AstTypeVarPairSerailization((AstTypeVarPair *)node, buffer, cursor); break;
        case AstEnumFuncVariable:
            AstFuncVariableSerailization((AstFuncVariable *)node, buffer, cursor); break;
        case AstEnumFuncDeclare:
            AstFuncDeclareSerailization((AstFuncDeclare *)node, buffer, cursor); break;
        case AstEnumScopeImp:
            AstScopeImpSerailization((AstScopeImp *)node, buffer, cursor); break;
        case AstEnumValueExpression:
            AstValueExpressionSerailization((AstValueExpression *)node, buffer, cursor); break;
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
        case AstEnumCFuncCall:
            AstCFuncCallSerailization((AstCFuncCall *)node, buffer, cursor); break;
        case AstEnumFunctionImp:
            AstFunctionImpSerailization((AstFunctionImp *)node, buffer, cursor); break;
        case AstEnumSubscriptExpression:
            AstSubscriptExpressionSerailization((AstSubscriptExpression *)node, buffer, cursor); break;
        case AstEnumAssignExpression:
            AstAssignExpressionSerailization((AstAssignExpression *)node, buffer, cursor); break;
        case AstEnumDeclareExpression:
            AstDeclareExpressionSerailization((AstDeclareExpression *)node, buffer, cursor); break;
        case AstEnumUnaryExpression:
            AstUnaryExpressionSerailization((AstUnaryExpression *)node, buffer, cursor); break;
        case AstEnumBinaryExpression:
            AstBinaryExpressionSerailization((AstBinaryExpression *)node, buffer, cursor); break;
        case AstEnumTernaryExpression:
            AstTernaryExpressionSerailization((AstTernaryExpression *)node, buffer, cursor); break;
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
        case AstEnumReturnStatement:
            AstReturnStatementSerailization((AstReturnStatement *)node, buffer, cursor); break;
        case AstEnumBreakStatement:
            AstBreakStatementSerailization((AstBreakStatement *)node, buffer, cursor); break;
        case AstEnumContinueStatement:
            AstContinueStatementSerailization((AstContinueStatement *)node, buffer, cursor); break;
        case AstEnumPropertyDeclare:
            AstPropertyDeclareSerailization((AstPropertyDeclare *)node, buffer, cursor); break;
        case AstEnumMethodDeclare:
            AstMethodDeclareSerailization((AstMethodDeclare *)node, buffer, cursor); break;
        case AstEnumMethodImplementation:
            AstMethodImplementationSerailization((AstMethodImplementation *)node, buffer, cursor); break;
        case AstEnumClass:
            AstClassSerailization((AstClass *)node, buffer, cursor); break;
        case AstEnumProtocol:
            AstProtocolSerailization((AstProtocol *)node, buffer, cursor); break;
        case AstEnumStructExpressoin:
            AstStructExpressoinSerailization((AstStructExpressoin *)node, buffer, cursor); break;
        case AstEnumEnumExpressoin:
            AstEnumExpressoinSerailization((AstEnumExpressoin *)node, buffer, cursor); break;
        case AstEnumTypedefExpressoin:
            AstTypedefExpressoinSerailization((AstTypedefExpressoin *)node, buffer, cursor); break;
        case AstEnumCArrayVariable:
            AstCArrayVariableSerailization((AstCArrayVariable *)node, buffer, cursor); break;
        case AstEnumUnionExpressoin:
            AstUnionExpressoinSerailization((AstUnionExpressoin *)node, buffer, cursor); break;

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
        case AstEnumTypeSpecial:
            return (AstEmptyNode *)AstTypeSpecialDeserialization(buffer, cursor, bufferLength);
        case AstEnumVariable:
            return (AstEmptyNode *)AstVariableDeserialization(buffer, cursor, bufferLength);
        case AstEnumTypeVarPair:
            return (AstEmptyNode *)AstTypeVarPairDeserialization(buffer, cursor, bufferLength);
        case AstEnumFuncVariable:
            return (AstEmptyNode *)AstFuncVariableDeserialization(buffer, cursor, bufferLength);
        case AstEnumFuncDeclare:
            return (AstEmptyNode *)AstFuncDeclareDeserialization(buffer, cursor, bufferLength);
        case AstEnumScopeImp:
            return (AstEmptyNode *)AstScopeImpDeserialization(buffer, cursor, bufferLength);
        case AstEnumValueExpression:
            return (AstEmptyNode *)AstValueExpressionDeserialization(buffer, cursor, bufferLength);
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
        case AstEnumCFuncCall:
            return (AstEmptyNode *)AstCFuncCallDeserialization(buffer, cursor, bufferLength);
        case AstEnumFunctionImp:
            return (AstEmptyNode *)AstFunctionImpDeserialization(buffer, cursor, bufferLength);
        case AstEnumSubscriptExpression:
            return (AstEmptyNode *)AstSubscriptExpressionDeserialization(buffer, cursor, bufferLength);
        case AstEnumAssignExpression:
            return (AstEmptyNode *)AstAssignExpressionDeserialization(buffer, cursor, bufferLength);
        case AstEnumDeclareExpression:
            return (AstEmptyNode *)AstDeclareExpressionDeserialization(buffer, cursor, bufferLength);
        case AstEnumUnaryExpression:
            return (AstEmptyNode *)AstUnaryExpressionDeserialization(buffer, cursor, bufferLength);
        case AstEnumBinaryExpression:
            return (AstEmptyNode *)AstBinaryExpressionDeserialization(buffer, cursor, bufferLength);
        case AstEnumTernaryExpression:
            return (AstEmptyNode *)AstTernaryExpressionDeserialization(buffer, cursor, bufferLength);
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
        case AstEnumReturnStatement:
            return (AstEmptyNode *)AstReturnStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumBreakStatement:
            return (AstEmptyNode *)AstBreakStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumContinueStatement:
            return (AstEmptyNode *)AstContinueStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumPropertyDeclare:
            return (AstEmptyNode *)AstPropertyDeclareDeserialization(buffer, cursor, bufferLength);
        case AstEnumMethodDeclare:
            return (AstEmptyNode *)AstMethodDeclareDeserialization(buffer, cursor, bufferLength);
        case AstEnumMethodImplementation:
            return (AstEmptyNode *)AstMethodImplementationDeserialization(buffer, cursor, bufferLength);
        case AstEnumClass:
            return (AstEmptyNode *)AstClassDeserialization(buffer, cursor, bufferLength);
        case AstEnumProtocol:
            return (AstEmptyNode *)AstProtocolDeserialization(buffer, cursor, bufferLength);
        case AstEnumStructExpressoin:
            return (AstEmptyNode *)AstStructExpressoinDeserialization(buffer, cursor, bufferLength);
        case AstEnumEnumExpressoin:
            return (AstEmptyNode *)AstEnumExpressoinDeserialization(buffer, cursor, bufferLength);
        case AstEnumTypedefExpressoin:
            return (AstEmptyNode *)AstTypedefExpressoinDeserialization(buffer, cursor, bufferLength);
        case AstEnumCArrayVariable:
            return (AstEmptyNode *)AstCArrayVariableDeserialization(buffer, cursor, bufferLength);
        case AstEnumUnionExpressoin:
            return (AstEmptyNode *)AstUnionExpressoinDeserialization(buffer, cursor, bufferLength);

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
        case AstEnumTypeSpecial:
            AstTypeSpecialDestroy((AstTypeSpecial *)node); break;
        case AstEnumVariable:
            AstVariableDestroy((AstVariable *)node); break;
        case AstEnumTypeVarPair:
            AstTypeVarPairDestroy((AstTypeVarPair *)node); break;
        case AstEnumFuncVariable:
            AstFuncVariableDestroy((AstFuncVariable *)node); break;
        case AstEnumFuncDeclare:
            AstFuncDeclareDestroy((AstFuncDeclare *)node); break;
        case AstEnumScopeImp:
            AstScopeImpDestroy((AstScopeImp *)node); break;
        case AstEnumValueExpression:
            AstValueExpressionDestroy((AstValueExpression *)node); break;
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
        case AstEnumCFuncCall:
            AstCFuncCallDestroy((AstCFuncCall *)node); break;
        case AstEnumFunctionImp:
            AstFunctionImpDestroy((AstFunctionImp *)node); break;
        case AstEnumSubscriptExpression:
            AstSubscriptExpressionDestroy((AstSubscriptExpression *)node); break;
        case AstEnumAssignExpression:
            AstAssignExpressionDestroy((AstAssignExpression *)node); break;
        case AstEnumDeclareExpression:
            AstDeclareExpressionDestroy((AstDeclareExpression *)node); break;
        case AstEnumUnaryExpression:
            AstUnaryExpressionDestroy((AstUnaryExpression *)node); break;
        case AstEnumBinaryExpression:
            AstBinaryExpressionDestroy((AstBinaryExpression *)node); break;
        case AstEnumTernaryExpression:
            AstTernaryExpressionDestroy((AstTernaryExpression *)node); break;
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
        case AstEnumReturnStatement:
            AstReturnStatementDestroy((AstReturnStatement *)node); break;
        case AstEnumBreakStatement:
            AstBreakStatementDestroy((AstBreakStatement *)node); break;
        case AstEnumContinueStatement:
            AstContinueStatementDestroy((AstContinueStatement *)node); break;
        case AstEnumPropertyDeclare:
            AstPropertyDeclareDestroy((AstPropertyDeclare *)node); break;
        case AstEnumMethodDeclare:
            AstMethodDeclareDestroy((AstMethodDeclare *)node); break;
        case AstEnumMethodImplementation:
            AstMethodImplementationDestroy((AstMethodImplementation *)node); break;
        case AstEnumClass:
            AstClassDestroy((AstClass *)node); break;
        case AstEnumProtocol:
            AstProtocolDestroy((AstProtocol *)node); break;
        case AstEnumStructExpressoin:
            AstStructExpressoinDestroy((AstStructExpressoin *)node); break;
        case AstEnumEnumExpressoin:
            AstEnumExpressoinDestroy((AstEnumExpressoin *)node); break;
        case AstEnumTypedefExpressoin:
            AstTypedefExpressoinDestroy((AstTypedefExpressoin *)node); break;
        case AstEnumCArrayVariable:
            AstCArrayVariableDestroy((AstCArrayVariable *)node); break;
        case AstEnumUnionExpressoin:
            AstUnionExpressoinDestroy((AstUnionExpressoin *)node); break;
    
        default: break;
    }
}
void AstNodeListTagged(id parentNode, NSArray *nodes) {
    for (id node in nodes) {
        AstNodeTagged(parentNode, node);
    }
}
void AstNodeTagged(id parentNode, id node) {
    if ([node isKindOfClass:[NSArray class]]) {
        AstNodeListTagged(parentNode, node);
    }else if ([node isKindOfClass:[ORTypeSpecial class]]){
        ORTypeSpecialTagged(parentNode, (ORTypeSpecial *)node);
        return;
    }else if ([node isKindOfClass:[ORVariable class]]){
        ORVariableTagged(parentNode, (ORVariable *)node);
        return;
    }else if ([node isKindOfClass:[ORTypeVarPair class]]){
        ORTypeVarPairTagged(parentNode, (ORTypeVarPair *)node);
        return;
    }else if ([node isKindOfClass:[ORFuncVariable class]]){
        ORFuncVariableTagged(parentNode, (ORFuncVariable *)node);
        return;
    }else if ([node isKindOfClass:[ORFuncDeclare class]]){
        ORFuncDeclareTagged(parentNode, (ORFuncDeclare *)node);
        return;
    }else if ([node isKindOfClass:[ORScopeImp class]]){
        ORScopeImpTagged(parentNode, (ORScopeImp *)node);
        return;
    }else if ([node isKindOfClass:[ORValueExpression class]]){
        ORValueExpressionTagged(parentNode, (ORValueExpression *)node);
        return;
    }else if ([node isKindOfClass:[ORIntegerValue class]]){
        ORIntegerValueTagged(parentNode, (ORIntegerValue *)node);
        return;
    }else if ([node isKindOfClass:[ORUIntegerValue class]]){
        ORUIntegerValueTagged(parentNode, (ORUIntegerValue *)node);
        return;
    }else if ([node isKindOfClass:[ORDoubleValue class]]){
        ORDoubleValueTagged(parentNode, (ORDoubleValue *)node);
        return;
    }else if ([node isKindOfClass:[ORBoolValue class]]){
        ORBoolValueTagged(parentNode, (ORBoolValue *)node);
        return;
    }else if ([node isKindOfClass:[ORMethodCall class]]){
        ORMethodCallTagged(parentNode, (ORMethodCall *)node);
        return;
    }else if ([node isKindOfClass:[ORCFuncCall class]]){
        ORCFuncCallTagged(parentNode, (ORCFuncCall *)node);
        return;
    }else if ([node isKindOfClass:[ORFunctionImp class]]){
        ORFunctionImpTagged(parentNode, (ORFunctionImp *)node);
        return;
    }else if ([node isKindOfClass:[ORSubscriptExpression class]]){
        ORSubscriptExpressionTagged(parentNode, (ORSubscriptExpression *)node);
        return;
    }else if ([node isKindOfClass:[ORAssignExpression class]]){
        ORAssignExpressionTagged(parentNode, (ORAssignExpression *)node);
        return;
    }else if ([node isKindOfClass:[ORDeclareExpression class]]){
        ORDeclareExpressionTagged(parentNode, (ORDeclareExpression *)node);
        return;
    }else if ([node isKindOfClass:[ORUnaryExpression class]]){
        ORUnaryExpressionTagged(parentNode, (ORUnaryExpression *)node);
        return;
    }else if ([node isKindOfClass:[ORBinaryExpression class]]){
        ORBinaryExpressionTagged(parentNode, (ORBinaryExpression *)node);
        return;
    }else if ([node isKindOfClass:[ORTernaryExpression class]]){
        ORTernaryExpressionTagged(parentNode, (ORTernaryExpression *)node);
        return;
    }else if ([node isKindOfClass:[ORIfStatement class]]){
        ORIfStatementTagged(parentNode, (ORIfStatement *)node);
        return;
    }else if ([node isKindOfClass:[ORWhileStatement class]]){
        ORWhileStatementTagged(parentNode, (ORWhileStatement *)node);
        return;
    }else if ([node isKindOfClass:[ORDoWhileStatement class]]){
        ORDoWhileStatementTagged(parentNode, (ORDoWhileStatement *)node);
        return;
    }else if ([node isKindOfClass:[ORCaseStatement class]]){
        ORCaseStatementTagged(parentNode, (ORCaseStatement *)node);
        return;
    }else if ([node isKindOfClass:[ORSwitchStatement class]]){
        ORSwitchStatementTagged(parentNode, (ORSwitchStatement *)node);
        return;
    }else if ([node isKindOfClass:[ORForStatement class]]){
        ORForStatementTagged(parentNode, (ORForStatement *)node);
        return;
    }else if ([node isKindOfClass:[ORForInStatement class]]){
        ORForInStatementTagged(parentNode, (ORForInStatement *)node);
        return;
    }else if ([node isKindOfClass:[ORReturnStatement class]]){
        ORReturnStatementTagged(parentNode, (ORReturnStatement *)node);
        return;
    }else if ([node isKindOfClass:[ORBreakStatement class]]){
        ORBreakStatementTagged(parentNode, (ORBreakStatement *)node);
        return;
    }else if ([node isKindOfClass:[ORContinueStatement class]]){
        ORContinueStatementTagged(parentNode, (ORContinueStatement *)node);
        return;
    }else if ([node isKindOfClass:[ORPropertyDeclare class]]){
        ORPropertyDeclareTagged(parentNode, (ORPropertyDeclare *)node);
        return;
    }else if ([node isKindOfClass:[ORMethodDeclare class]]){
        ORMethodDeclareTagged(parentNode, (ORMethodDeclare *)node);
        return;
    }else if ([node isKindOfClass:[ORMethodImplementation class]]){
        ORMethodImplementationTagged(parentNode, (ORMethodImplementation *)node);
        return;
    }else if ([node isKindOfClass:[ORClass class]]){
        ORClassTagged(parentNode, (ORClass *)node);
        return;
    }else if ([node isKindOfClass:[ORProtocol class]]){
        ORProtocolTagged(parentNode, (ORProtocol *)node);
        return;
    }else if ([node isKindOfClass:[ORStructExpressoin class]]){
        ORStructExpressoinTagged(parentNode, (ORStructExpressoin *)node);
        return;
    }else if ([node isKindOfClass:[OREnumExpressoin class]]){
        OREnumExpressoinTagged(parentNode, (OREnumExpressoin *)node);
        return;
    }else if ([node isKindOfClass:[ORTypedefExpressoin class]]){
        ORTypedefExpressoinTagged(parentNode, (ORTypedefExpressoin *)node);
        return;
    }else if ([node isKindOfClass:[ORCArrayVariable class]]){
        ORCArrayVariableTagged(parentNode, (ORCArrayVariable *)node);
        return;
    }else if ([node isKindOfClass:[ORUnionExpressoin class]]){
        ORUnionExpressoinTagged(parentNode, (ORUnionExpressoin *)node);
        return;
    }
}