//  BinaryPatchHelper.m
//  Generate By BinaryPatchGenerator
//  Created by Jiang on 1622714604
//  Copyright © 2020 SilverFruity. All rights reserved.
#import "BinaryPatchHelper.h"
#import "ORPatchFile.h"#pragma pack(1)
#pragma pack(show)

AstNode *AstNodeConvert(id exp, AstPatchFile *patch, uint32_t *length);
id AstNodeDeConvert(AstNode *node, AstPatchFile *patch);

AstNodeList *AstNodeListConvert(NSArray *array, AstPatchFile *patch, uint32_t *length){
    AstNodeList *node = malloc(sizeof(AstNodeList));
    memset(node, 0, sizeof(AstNodeList));
    node->nodes = malloc(sizeof(void *) * array.count);
    node->nodeType = AstEnumListNode;
    *length += AstNodeListBaseLength;
    for (id object in array) {
        AstNode *element = AstNodeConvert(object, patch, length);;
        node->nodes[node->count] = element;
        node->count++;
    }
    return node;
}

NSMutableArray *AstNodeListDeConvert(AstNodeList *node, AstPatchFile *patch){
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < node->count; i++) {
        id result = AstNodeDeConvert(node->nodes[i], patch);
        [array addObject:result];
    }
    return array;
}

static NSMutableDictionary *_stringMap = nil;
ORStringCursor *createStringCursor(NSString *string, AstPatchFile *patch, uint32_t *length){
    ORStringCursor * strNode = malloc(sizeof(ORStringCursor));
    memset(strNode, 0, sizeof(ORStringCursor));
    const char *str = string.UTF8String;
    size_t len = strlen(str);
    strNode->strLen = (unsigned int)len;
    strNode->nodeType = AstEnumStringCursorNode;
    *length += ORStringCursorBaseLength;
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

NSString *getNSStringWithStringCursor(ORStringCursor *node, AstPatchFile *patch){
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

    node->strings = malloc(sizeof(ORStringBufferNode));
    memset(node->strings, 0, sizeof(ORStringBufferNode));
    node->strings->nodeType = AstEnumStringBufferNode;
    *length += ORStringBufferNodeBaseLength;
    
    node->nodeType = AstEnumPatchFile;
    node->enable = patch.enable;
    node->appVersion = (ORStringCursor *)AstNodeConvert(patch.appVersion, node, length);
    node->osVersion = (ORStringCursor *)AstNodeConvert(patch.osVersion, node, length);
    node->nodes = (AstNodeList *)AstNodeConvert(patch.nodes, node, length);
    return node;
}

ORPatchFile *AstPatchFileDeConvert(AstPatchFile *patch){
    ORPatchFile *file = [ORPatchFile new];
    file.appVersion = AstNodeDeConvert((AstNode *)patch->appVersion, patch);
    file.osVersion = AstNodeDeConvert((AstNode *)patch->osVersion, patch);
    file.enable = patch->enable;
    NSMutableArray *nodes = [NSMutableArray array];
    for (int i = 0; i < patch->nodes->count; i++) {
        [nodes addObject:AstNodeDeConvert(patch->nodes->nodes[i], patch)];
    }
    file.nodes = nodes;
    return file;
}

void AstNodeSerailization(AstNode *node, void *buffer, uint32_t *cursor);
void ORStringCursorSerailization(ORStringCursor *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, ORStringCursorBaseLength);
    *cursor += ORStringCursorBaseLength;
}
void AstNodeListSerailization(AstNodeList *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstNodeListBaseLength);
    *cursor += AstNodeListBaseLength;
    for (int i = 0; i < node->count; i++) {
        AstNodeSerailization(node->nodes[i], buffer, cursor);
    }
}
void ORStringBufferNodeSerailization(ORStringBufferNode *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, ORStringBufferNodeBaseLength);
    *cursor += ORStringBufferNodeBaseLength;
    memcpy(buffer + *cursor, node->buffer, node->cursor);
    *cursor += node->cursor;
}
void AstPatchFileSerialization(AstPatchFile *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstPatchFileBaseLength);
    *cursor += AstPatchFileBaseLength;
    AstNodeSerailization((AstNode *)node->strings, buffer, cursor);
    AstNodeSerailization((AstNode *)node->appVersion, buffer, cursor);
    AstNodeSerailization((AstNode *)node->osVersion, buffer, cursor);
    AstNodeSerailization((AstNode *)node->nodes, buffer, cursor);
}

AstNode *AstNodeDeserialization(void *buffer, uint32_t *cursor,uint32_t bufferLength);
ORStringCursor * ORStringCursorDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    ORStringCursor *node = malloc(sizeof(ORStringCursor));
    memcpy(node, buffer + *cursor, ORStringCursorBaseLength);
    *cursor += ORStringCursorBaseLength;
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
ORStringBufferNode *ORStringBufferNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    ORStringBufferNode *node = malloc(sizeof(ORStringBufferNode));
    memcpy(node, buffer + *cursor, ORStringBufferNodeBaseLength);
    *cursor += ORStringBufferNodeBaseLength;
    node->buffer = malloc(node->cursor);
    memcpy(node->buffer, buffer + *cursor, node->cursor);
    *cursor += node->cursor;
    return node;
}
ORPatchFile *AstPatchFileGenerateCheckFile(void *buffer, uint32_t bufferLength){
    uint32_t cursor = 0;
    AstPatchFile *node = malloc(sizeof(AstPatchFile));
    memcpy(node, buffer + cursor, AstPatchFileBaseLength);
    cursor += AstPatchFileBaseLength;
    node->strings = (ORStringBufferNode *)ORStringBufferNodeDeserialization(buffer, &cursor, bufferLength);
    node->appVersion = (ORStringCursor *)AstNodeDeserialization(buffer, &cursor, bufferLength);
    node->osVersion = (ORStringCursor *)AstNodeDeserialization(buffer, &cursor, bufferLength);
    node->nodes = NULL;
    ORPatchFile *file = [ORPatchFile new];
    file.appVersion = getNSStringWithStringCursor(node->appVersion, node);
    file.osVersion = getNSStringWithStringCursor(node->osVersion, node);
    file.enable = node->enable;
    AstPatchFileDestroy(node);
    return file;
}
AstPatchFile *AstPatchFileDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstPatchFile *node = malloc(sizeof(AstPatchFile));
    memcpy(node, buffer + *cursor, AstPatchFileBaseLength);
    *cursor += AstPatchFileBaseLength;
    node->strings = (ORStringBufferNode *)ORStringBufferNodeDeserialization(buffer, cursor, bufferLength);
    node->appVersion = (ORStringCursor *)AstNodeDeserialization(buffer, cursor, bufferLength);
    node->osVersion = (ORStringCursor *)AstNodeDeserialization(buffer, cursor, bufferLength);
    node->nodes = (AstNodeList *)AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstNodeDestroy(AstNode *node);
void ORStringCursorDestroy(ORStringCursor *node){
    free(node);
}
void AstNodeListDestroy(AstNodeList *node){
    for (int i = 0; i < node->count; i++) {
         AstNodeDestroy(node->nodes[i]);
    }
    free(node);
}
void ORStringBufferNodeDestroy(ORStringBufferNode *node){
    free(node->buffer);
    free(node);
}
void AstPatchFileDestroy(AstPatchFile *node){
    AstNodeDestroy((AstNode *)node->strings);
    AstNodeDestroy((AstNode *)node->appVersion);
    AstNodeDestroy((AstNode *)node->osVersion);
    AstNodeDestroy((AstNode *)node->nodes);
    free(node);
}
typedef struct {
    AstNodeFields
    uint32_t type;
    ORStringCursor * name;
}AstTypeSpecial;
static uint32_t AstTypeSpecialBaseLength = 6;
AstTypeSpecial *AstTypeSpecialConvert(ORTypeSpecial *exp, AstPatchFile *patch, uint32_t *length){
    AstTypeSpecial *node = malloc(sizeof(AstTypeSpecial));
    memset(node, 0, sizeof(AstTypeSpecial));
    node->nodeType = AstEnumTypeSpecial;
    node->withSemicolon = exp.withSemicolon;
    node->type = exp.type;
    node->name = (ORStringCursor *)AstNodeConvert(exp.name, patch, length);
    *length += AstTypeSpecialBaseLength;
    return node;
}
ORTypeSpecial *AstTypeSpecialDeConvert(AstTypeSpecial *node, AstPatchFile *patch){
    ORTypeSpecial *exp = [ORTypeSpecial new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.type = node->type;
    exp.name = (NSString *)AstNodeDeConvert((AstNode *)node->name, patch);
    return exp;
}
void AstTypeSpecialSerailization(AstTypeSpecial *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstTypeSpecialBaseLength);
    *cursor += AstTypeSpecialBaseLength;
    AstNodeSerailization((AstNode *)node->name, buffer, cursor);
}
AstTypeSpecial *AstTypeSpecialDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstTypeSpecial *node = malloc(sizeof(AstTypeSpecial));
    memcpy(node, buffer + *cursor, AstTypeSpecialBaseLength);
    *cursor += AstTypeSpecialBaseLength;
    node->name =(ORStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstTypeSpecialDestroy(AstTypeSpecial *node){
    AstNodeDestroy((AstNode *)node->name);
    free(node);
}
typedef struct {
    AstNodeFields
    BOOL isBlock;
    uint8_t ptCount;
    ORStringCursor * varname;
}AstVariable;
static uint32_t AstVariableBaseLength = 4;
AstVariable *AstVariableConvert(ORVariable *exp, AstPatchFile *patch, uint32_t *length){
    AstVariable *node = malloc(sizeof(AstVariable));
    memset(node, 0, sizeof(AstVariable));
    node->nodeType = AstEnumVariable;
    node->withSemicolon = exp.withSemicolon;
    node->isBlock = exp.isBlock;
    node->ptCount = exp.ptCount;
    node->varname = (ORStringCursor *)AstNodeConvert(exp.varname, patch, length);
    *length += AstVariableBaseLength;
    return node;
}
ORVariable *AstVariableDeConvert(AstVariable *node, AstPatchFile *patch){
    ORVariable *exp = [ORVariable new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.isBlock = node->isBlock;
    exp.ptCount = node->ptCount;
    exp.varname = (NSString *)AstNodeDeConvert((AstNode *)node->varname, patch);
    return exp;
}
void AstVariableSerailization(AstVariable *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstVariableBaseLength);
    *cursor += AstVariableBaseLength;
    AstNodeSerailization((AstNode *)node->varname, buffer, cursor);
}
AstVariable *AstVariableDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstVariable *node = malloc(sizeof(AstVariable));
    memcpy(node, buffer + *cursor, AstVariableBaseLength);
    *cursor += AstVariableBaseLength;
    node->varname =(ORStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstVariableDestroy(AstVariable *node){
    AstNodeDestroy((AstNode *)node->varname);
    free(node);
}
typedef struct {
    AstNodeFields
    AstNode * type;
    AstNode * var;
}AstTypeVarPair;
static uint32_t AstTypeVarPairBaseLength = 2;
AstTypeVarPair *AstTypeVarPairConvert(ORTypeVarPair *exp, AstPatchFile *patch, uint32_t *length){
    AstTypeVarPair *node = malloc(sizeof(AstTypeVarPair));
    memset(node, 0, sizeof(AstTypeVarPair));
    node->nodeType = AstEnumTypeVarPair;
    node->withSemicolon = exp.withSemicolon;
    node->type = (AstNode *)AstNodeConvert(exp.type, patch, length);
    node->var = (AstNode *)AstNodeConvert(exp.var, patch, length);
    *length += AstTypeVarPairBaseLength;
    return node;
}
ORTypeVarPair *AstTypeVarPairDeConvert(AstTypeVarPair *node, AstPatchFile *patch){
    ORTypeVarPair *exp = [ORTypeVarPair new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.type = (id)AstNodeDeConvert((AstNode *)node->type, patch);
    exp.var = (id)AstNodeDeConvert((AstNode *)node->var, patch);
    return exp;
}
void AstTypeVarPairSerailization(AstTypeVarPair *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstTypeVarPairBaseLength);
    *cursor += AstTypeVarPairBaseLength;
    AstNodeSerailization((AstNode *)node->type, buffer, cursor);
    AstNodeSerailization((AstNode *)node->var, buffer, cursor);
}
AstTypeVarPair *AstTypeVarPairDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstTypeVarPair *node = malloc(sizeof(AstTypeVarPair));
    memcpy(node, buffer + *cursor, AstTypeVarPairBaseLength);
    *cursor += AstTypeVarPairBaseLength;
    node->type =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->var =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstTypeVarPairDestroy(AstTypeVarPair *node){
    AstNodeDestroy((AstNode *)node->type);
    AstNodeDestroy((AstNode *)node->var);
    free(node);
}
typedef struct {
    AstNodeFields
    BOOL isBlock;
    uint8_t ptCount;
    BOOL isMultiArgs;
    ORStringCursor * varname;
    AstNodeList * pairs;
}AstFuncVariable;
static uint32_t AstFuncVariableBaseLength = 5;
AstFuncVariable *AstFuncVariableConvert(ORFuncVariable *exp, AstPatchFile *patch, uint32_t *length){
    AstFuncVariable *node = malloc(sizeof(AstFuncVariable));
    memset(node, 0, sizeof(AstFuncVariable));
    node->nodeType = AstEnumFuncVariable;
    node->withSemicolon = exp.withSemicolon;
    node->isBlock = exp.isBlock;
    node->ptCount = exp.ptCount;
    node->varname = (ORStringCursor *)AstNodeConvert(exp.varname, patch, length);
    node->isMultiArgs = exp.isMultiArgs;
    node->pairs = (AstNodeList *)AstNodeConvert(exp.pairs, patch, length);
    *length += AstFuncVariableBaseLength;
    return node;
}
ORFuncVariable *AstFuncVariableDeConvert(AstFuncVariable *node, AstPatchFile *patch){
    ORFuncVariable *exp = [ORFuncVariable new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.isBlock = node->isBlock;
    exp.ptCount = node->ptCount;
    exp.varname = (NSString *)AstNodeDeConvert((AstNode *)node->varname, patch);
    exp.isMultiArgs = node->isMultiArgs;
    exp.pairs = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->pairs, patch);
    return exp;
}
void AstFuncVariableSerailization(AstFuncVariable *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstFuncVariableBaseLength);
    *cursor += AstFuncVariableBaseLength;
    AstNodeSerailization((AstNode *)node->varname, buffer, cursor);
    AstNodeSerailization((AstNode *)node->pairs, buffer, cursor);
}
AstFuncVariable *AstFuncVariableDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstFuncVariable *node = malloc(sizeof(AstFuncVariable));
    memcpy(node, buffer + *cursor, AstFuncVariableBaseLength);
    *cursor += AstFuncVariableBaseLength;
    node->varname =(ORStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->pairs =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstFuncVariableDestroy(AstFuncVariable *node){
    AstNodeDestroy((AstNode *)node->pairs);
    free(node);
}
typedef struct {
    AstNodeFields
    AstNode * returnType;
    AstNode * funVar;
}AstFuncDeclare;
static uint32_t AstFuncDeclareBaseLength = 2;
AstFuncDeclare *AstFuncDeclareConvert(ORFuncDeclare *exp, AstPatchFile *patch, uint32_t *length){
    AstFuncDeclare *node = malloc(sizeof(AstFuncDeclare));
    memset(node, 0, sizeof(AstFuncDeclare));
    node->nodeType = AstEnumFuncDeclare;
    node->withSemicolon = exp.withSemicolon;
    node->returnType = (AstNode *)AstNodeConvert(exp.returnType, patch, length);
    node->funVar = (AstNode *)AstNodeConvert(exp.funVar, patch, length);
    *length += AstFuncDeclareBaseLength;
    return node;
}
ORFuncDeclare *AstFuncDeclareDeConvert(AstFuncDeclare *node, AstPatchFile *patch){
    ORFuncDeclare *exp = [ORFuncDeclare new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.returnType = (id)AstNodeDeConvert((AstNode *)node->returnType, patch);
    exp.funVar = (id)AstNodeDeConvert((AstNode *)node->funVar, patch);
    return exp;
}
void AstFuncDeclareSerailization(AstFuncDeclare *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstFuncDeclareBaseLength);
    *cursor += AstFuncDeclareBaseLength;
    AstNodeSerailization((AstNode *)node->returnType, buffer, cursor);
    AstNodeSerailization((AstNode *)node->funVar, buffer, cursor);
}
AstFuncDeclare *AstFuncDeclareDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstFuncDeclare *node = malloc(sizeof(AstFuncDeclare));
    memcpy(node, buffer + *cursor, AstFuncDeclareBaseLength);
    *cursor += AstFuncDeclareBaseLength;
    node->returnType =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->funVar =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstFuncDeclareDestroy(AstFuncDeclare *node){
    AstNodeDestroy((AstNode *)node->returnType);
    AstNodeDestroy((AstNode *)node->funVar);
    free(node);
}
typedef struct {
    AstNodeFields
    AstNodeList * statements;
}AstScopeImp;
static uint32_t AstScopeImpBaseLength = 2;
AstScopeImp *AstScopeImpConvert(ORScopeImp *exp, AstPatchFile *patch, uint32_t *length){
    AstScopeImp *node = malloc(sizeof(AstScopeImp));
    memset(node, 0, sizeof(AstScopeImp));
    node->nodeType = AstEnumScopeImp;
    node->withSemicolon = exp.withSemicolon;
    node->statements = (AstNodeList *)AstNodeConvert(exp.statements, patch, length);
    *length += AstScopeImpBaseLength;
    return node;
}
ORScopeImp *AstScopeImpDeConvert(AstScopeImp *node, AstPatchFile *patch){
    ORScopeImp *exp = [ORScopeImp new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.statements = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->statements, patch);
    return exp;
}
void AstScopeImpSerailization(AstScopeImp *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstScopeImpBaseLength);
    *cursor += AstScopeImpBaseLength;
    AstNodeSerailization((AstNode *)node->statements, buffer, cursor);
}
AstScopeImp *AstScopeImpDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstScopeImp *node = malloc(sizeof(AstScopeImp));
    memcpy(node, buffer + *cursor, AstScopeImpBaseLength);
    *cursor += AstScopeImpBaseLength;
    node->statements =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstScopeImpDestroy(AstScopeImp *node){
    AstNodeDestroy((AstNode *)node->statements);
    free(node);
}
typedef struct {
    AstNodeFields
    uint32_t value_type;
    AstNode * value;
}AstValueExpression;
static uint32_t AstValueExpressionBaseLength = 6;
AstValueExpression *AstValueExpressionConvert(ORValueExpression *exp, AstPatchFile *patch, uint32_t *length){
    AstValueExpression *node = malloc(sizeof(AstValueExpression));
    memset(node, 0, sizeof(AstValueExpression));
    node->nodeType = AstEnumValueExpression;
    node->withSemicolon = exp.withSemicolon;
    node->value_type = exp.value_type;
    node->value = (AstNode *)AstNodeConvert(exp.value, patch, length);
    *length += AstValueExpressionBaseLength;
    return node;
}
ORValueExpression *AstValueExpressionDeConvert(AstValueExpression *node, AstPatchFile *patch){
    ORValueExpression *exp = [ORValueExpression new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.value_type = node->value_type;
    exp.value = (id)AstNodeDeConvert((AstNode *)node->value, patch);
    return exp;
}
void AstValueExpressionSerailization(AstValueExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstValueExpressionBaseLength);
    *cursor += AstValueExpressionBaseLength;
    AstNodeSerailization((AstNode *)node->value, buffer, cursor);
}
AstValueExpression *AstValueExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstValueExpression *node = malloc(sizeof(AstValueExpression));
    memcpy(node, buffer + *cursor, AstValueExpressionBaseLength);
    *cursor += AstValueExpressionBaseLength;
    node->value =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstValueExpressionDestroy(AstValueExpression *node){
    AstNodeDestroy((AstNode *)node->value);
    free(node);
}
typedef struct {
    AstNodeFields
    int64_t value;
}AstIntegerValue;
static uint32_t AstIntegerValueBaseLength = 10;
AstIntegerValue *AstIntegerValueConvert(ORIntegerValue *exp, AstPatchFile *patch, uint32_t *length){
    AstIntegerValue *node = malloc(sizeof(AstIntegerValue));
    memset(node, 0, sizeof(AstIntegerValue));
    node->nodeType = AstEnumIntegerValue;
    node->withSemicolon = exp.withSemicolon;
    node->value = exp.value;
    *length += AstIntegerValueBaseLength;
    return node;
}
ORIntegerValue *AstIntegerValueDeConvert(AstIntegerValue *node, AstPatchFile *patch){
    ORIntegerValue *exp = [ORIntegerValue new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.value = node->value;
    return exp;
}
void AstIntegerValueSerailization(AstIntegerValue *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstIntegerValueBaseLength);
    *cursor += AstIntegerValueBaseLength;
    
}
AstIntegerValue *AstIntegerValueDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstIntegerValue *node = malloc(sizeof(AstIntegerValue));
    memcpy(node, buffer + *cursor, AstIntegerValueBaseLength);
    *cursor += AstIntegerValueBaseLength;
    
    return node;
}
void AstIntegerValueDestroy(AstIntegerValue *node){
    
    free(node);
}
typedef struct {
    AstNodeFields
    uint64_t value;
}AstUIntegerValue;
static uint32_t AstUIntegerValueBaseLength = 10;
AstUIntegerValue *AstUIntegerValueConvert(ORUIntegerValue *exp, AstPatchFile *patch, uint32_t *length){
    AstUIntegerValue *node = malloc(sizeof(AstUIntegerValue));
    memset(node, 0, sizeof(AstUIntegerValue));
    node->nodeType = AstEnumUIntegerValue;
    node->withSemicolon = exp.withSemicolon;
    node->value = exp.value;
    *length += AstUIntegerValueBaseLength;
    return node;
}
ORUIntegerValue *AstUIntegerValueDeConvert(AstUIntegerValue *node, AstPatchFile *patch){
    ORUIntegerValue *exp = [ORUIntegerValue new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.value = node->value;
    return exp;
}
void AstUIntegerValueSerailization(AstUIntegerValue *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstUIntegerValueBaseLength);
    *cursor += AstUIntegerValueBaseLength;
    
}
AstUIntegerValue *AstUIntegerValueDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstUIntegerValue *node = malloc(sizeof(AstUIntegerValue));
    memcpy(node, buffer + *cursor, AstUIntegerValueBaseLength);
    *cursor += AstUIntegerValueBaseLength;
    
    return node;
}
void AstUIntegerValueDestroy(AstUIntegerValue *node){
    
    free(node);
}
typedef struct {
    AstNodeFields
    double value;
}AstDoubleValue;
static uint32_t AstDoubleValueBaseLength = 10;
AstDoubleValue *AstDoubleValueConvert(ORDoubleValue *exp, AstPatchFile *patch, uint32_t *length){
    AstDoubleValue *node = malloc(sizeof(AstDoubleValue));
    memset(node, 0, sizeof(AstDoubleValue));
    node->nodeType = AstEnumDoubleValue;
    node->withSemicolon = exp.withSemicolon;
    node->value = exp.value;
    *length += AstDoubleValueBaseLength;
    return node;
}
ORDoubleValue *AstDoubleValueDeConvert(AstDoubleValue *node, AstPatchFile *patch){
    ORDoubleValue *exp = [ORDoubleValue new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.value = node->value;
    return exp;
}
void AstDoubleValueSerailization(AstDoubleValue *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstDoubleValueBaseLength);
    *cursor += AstDoubleValueBaseLength;
    
}
AstDoubleValue *AstDoubleValueDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstDoubleValue *node = malloc(sizeof(AstDoubleValue));
    memcpy(node, buffer + *cursor, AstDoubleValueBaseLength);
    *cursor += AstDoubleValueBaseLength;
    
    return node;
}
void AstDoubleValueDestroy(AstDoubleValue *node){
    
    free(node);
}
typedef struct {
    AstNodeFields
    BOOL value;
}AstBoolValue;
static uint32_t AstBoolValueBaseLength = 3;
AstBoolValue *AstBoolValueConvert(ORBoolValue *exp, AstPatchFile *patch, uint32_t *length){
    AstBoolValue *node = malloc(sizeof(AstBoolValue));
    memset(node, 0, sizeof(AstBoolValue));
    node->nodeType = AstEnumBoolValue;
    node->withSemicolon = exp.withSemicolon;
    node->value = exp.value;
    *length += AstBoolValueBaseLength;
    return node;
}
ORBoolValue *AstBoolValueDeConvert(AstBoolValue *node, AstPatchFile *patch){
    ORBoolValue *exp = [ORBoolValue new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.value = node->value;
    return exp;
}
void AstBoolValueSerailization(AstBoolValue *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstBoolValueBaseLength);
    *cursor += AstBoolValueBaseLength;
    
}
AstBoolValue *AstBoolValueDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstBoolValue *node = malloc(sizeof(AstBoolValue));
    memcpy(node, buffer + *cursor, AstBoolValueBaseLength);
    *cursor += AstBoolValueBaseLength;
    
    return node;
}
void AstBoolValueDestroy(AstBoolValue *node){
    
    free(node);
}
typedef struct {
    AstNodeFields
    uint8_t methodOperator;
    BOOL isAssignedValue;
    AstNode * caller;
    AstNodeList * names;
    AstNodeList * values;
}AstMethodCall;
static uint32_t AstMethodCallBaseLength = 4;
AstMethodCall *AstMethodCallConvert(ORMethodCall *exp, AstPatchFile *patch, uint32_t *length){
    AstMethodCall *node = malloc(sizeof(AstMethodCall));
    memset(node, 0, sizeof(AstMethodCall));
    node->nodeType = AstEnumMethodCall;
    node->withSemicolon = exp.withSemicolon;
    node->methodOperator = exp.methodOperator;
    node->isAssignedValue = exp.isAssignedValue;
    node->caller = (AstNode *)AstNodeConvert(exp.caller, patch, length);
    node->names = (AstNodeList *)AstNodeConvert(exp.names, patch, length);
    node->values = (AstNodeList *)AstNodeConvert(exp.values, patch, length);
    *length += AstMethodCallBaseLength;
    return node;
}
ORMethodCall *AstMethodCallDeConvert(AstMethodCall *node, AstPatchFile *patch){
    ORMethodCall *exp = [ORMethodCall new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.methodOperator = node->methodOperator;
    exp.isAssignedValue = node->isAssignedValue;
    exp.caller = (id)AstNodeDeConvert((AstNode *)node->caller, patch);
    exp.names = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->names, patch);
    exp.values = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->values, patch);
    return exp;
}
void AstMethodCallSerailization(AstMethodCall *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstMethodCallBaseLength);
    *cursor += AstMethodCallBaseLength;
    AstNodeSerailization((AstNode *)node->caller, buffer, cursor);
    AstNodeSerailization((AstNode *)node->names, buffer, cursor);
    AstNodeSerailization((AstNode *)node->values, buffer, cursor);
}
AstMethodCall *AstMethodCallDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstMethodCall *node = malloc(sizeof(AstMethodCall));
    memcpy(node, buffer + *cursor, AstMethodCallBaseLength);
    *cursor += AstMethodCallBaseLength;
    node->caller =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->names =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->values =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstMethodCallDestroy(AstMethodCall *node){
    AstNodeDestroy((AstNode *)node->caller);
    AstNodeDestroy((AstNode *)node->names);
    AstNodeDestroy((AstNode *)node->values);
    free(node);
}
typedef struct {
    AstNodeFields
    AstNode * caller;
    AstNodeList * expressions;
}AstCFuncCall;
static uint32_t AstCFuncCallBaseLength = 2;
AstCFuncCall *AstCFuncCallConvert(ORCFuncCall *exp, AstPatchFile *patch, uint32_t *length){
    AstCFuncCall *node = malloc(sizeof(AstCFuncCall));
    memset(node, 0, sizeof(AstCFuncCall));
    node->nodeType = AstEnumCFuncCall;
    node->withSemicolon = exp.withSemicolon;
    node->caller = (AstNode *)AstNodeConvert(exp.caller, patch, length);
    node->expressions = (AstNodeList *)AstNodeConvert(exp.expressions, patch, length);
    *length += AstCFuncCallBaseLength;
    return node;
}
ORCFuncCall *AstCFuncCallDeConvert(AstCFuncCall *node, AstPatchFile *patch){
    ORCFuncCall *exp = [ORCFuncCall new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.caller = (id)AstNodeDeConvert((AstNode *)node->caller, patch);
    exp.expressions = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->expressions, patch);
    return exp;
}
void AstCFuncCallSerailization(AstCFuncCall *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstCFuncCallBaseLength);
    *cursor += AstCFuncCallBaseLength;
    AstNodeSerailization((AstNode *)node->caller, buffer, cursor);
    AstNodeSerailization((AstNode *)node->expressions, buffer, cursor);
}
AstCFuncCall *AstCFuncCallDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstCFuncCall *node = malloc(sizeof(AstCFuncCall));
    memcpy(node, buffer + *cursor, AstCFuncCallBaseLength);
    *cursor += AstCFuncCallBaseLength;
    node->caller =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->expressions =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstCFuncCallDestroy(AstCFuncCall *node){
    AstNodeDestroy((AstNode *)node->caller);
    AstNodeDestroy((AstNode *)node->expressions);
    free(node);
}
typedef struct {
    AstNodeFields
    AstNode * declare;
    AstNode * scopeImp;
}AstFunctionImp;
static uint32_t AstFunctionImpBaseLength = 2;
AstFunctionImp *AstFunctionImpConvert(ORFunctionImp *exp, AstPatchFile *patch, uint32_t *length){
    AstFunctionImp *node = malloc(sizeof(AstFunctionImp));
    memset(node, 0, sizeof(AstFunctionImp));
    node->nodeType = AstEnumFunctionImp;
    node->withSemicolon = exp.withSemicolon;
    node->declare = (AstNode *)AstNodeConvert(exp.declare, patch, length);
    node->scopeImp = (AstNode *)AstNodeConvert(exp.scopeImp, patch, length);
    *length += AstFunctionImpBaseLength;
    return node;
}
ORFunctionImp *AstFunctionImpDeConvert(AstFunctionImp *node, AstPatchFile *patch){
    ORFunctionImp *exp = [ORFunctionImp new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.declare = (id)AstNodeDeConvert((AstNode *)node->declare, patch);
    exp.scopeImp = (id)AstNodeDeConvert((AstNode *)node->scopeImp, patch);
    return exp;
}
void AstFunctionImpSerailization(AstFunctionImp *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstFunctionImpBaseLength);
    *cursor += AstFunctionImpBaseLength;
    AstNodeSerailization((AstNode *)node->declare, buffer, cursor);
    AstNodeSerailization((AstNode *)node->scopeImp, buffer, cursor);
}
AstFunctionImp *AstFunctionImpDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstFunctionImp *node = malloc(sizeof(AstFunctionImp));
    memcpy(node, buffer + *cursor, AstFunctionImpBaseLength);
    *cursor += AstFunctionImpBaseLength;
    node->declare =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstFunctionImpDestroy(AstFunctionImp *node){
    AstNodeDestroy((AstNode *)node->declare);
    AstNodeDestroy((AstNode *)node->scopeImp);
    free(node);
}
typedef struct {
    AstNodeFields
    AstNode * caller;
    AstNode * keyExp;
}AstSubscriptExpression;
static uint32_t AstSubscriptExpressionBaseLength = 2;
AstSubscriptExpression *AstSubscriptExpressionConvert(ORSubscriptExpression *exp, AstPatchFile *patch, uint32_t *length){
    AstSubscriptExpression *node = malloc(sizeof(AstSubscriptExpression));
    memset(node, 0, sizeof(AstSubscriptExpression));
    node->nodeType = AstEnumSubscriptExpression;
    node->withSemicolon = exp.withSemicolon;
    node->caller = (AstNode *)AstNodeConvert(exp.caller, patch, length);
    node->keyExp = (AstNode *)AstNodeConvert(exp.keyExp, patch, length);
    *length += AstSubscriptExpressionBaseLength;
    return node;
}
ORSubscriptExpression *AstSubscriptExpressionDeConvert(AstSubscriptExpression *node, AstPatchFile *patch){
    ORSubscriptExpression *exp = [ORSubscriptExpression new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.caller = (id)AstNodeDeConvert((AstNode *)node->caller, patch);
    exp.keyExp = (id)AstNodeDeConvert((AstNode *)node->keyExp, patch);
    return exp;
}
void AstSubscriptExpressionSerailization(AstSubscriptExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstSubscriptExpressionBaseLength);
    *cursor += AstSubscriptExpressionBaseLength;
    AstNodeSerailization((AstNode *)node->caller, buffer, cursor);
    AstNodeSerailization((AstNode *)node->keyExp, buffer, cursor);
}
AstSubscriptExpression *AstSubscriptExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstSubscriptExpression *node = malloc(sizeof(AstSubscriptExpression));
    memcpy(node, buffer + *cursor, AstSubscriptExpressionBaseLength);
    *cursor += AstSubscriptExpressionBaseLength;
    node->caller =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->keyExp =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstSubscriptExpressionDestroy(AstSubscriptExpression *node){
    AstNodeDestroy((AstNode *)node->caller);
    AstNodeDestroy((AstNode *)node->keyExp);
    free(node);
}
typedef struct {
    AstNodeFields
    uint32_t assignType;
    AstNode * value;
    AstNode * expression;
}AstAssignExpression;
static uint32_t AstAssignExpressionBaseLength = 6;
AstAssignExpression *AstAssignExpressionConvert(ORAssignExpression *exp, AstPatchFile *patch, uint32_t *length){
    AstAssignExpression *node = malloc(sizeof(AstAssignExpression));
    memset(node, 0, sizeof(AstAssignExpression));
    node->nodeType = AstEnumAssignExpression;
    node->withSemicolon = exp.withSemicolon;
    node->assignType = exp.assignType;
    node->value = (AstNode *)AstNodeConvert(exp.value, patch, length);
    node->expression = (AstNode *)AstNodeConvert(exp.expression, patch, length);
    *length += AstAssignExpressionBaseLength;
    return node;
}
ORAssignExpression *AstAssignExpressionDeConvert(AstAssignExpression *node, AstPatchFile *patch){
    ORAssignExpression *exp = [ORAssignExpression new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.assignType = node->assignType;
    exp.value = (id)AstNodeDeConvert((AstNode *)node->value, patch);
    exp.expression = (id)AstNodeDeConvert((AstNode *)node->expression, patch);
    return exp;
}
void AstAssignExpressionSerailization(AstAssignExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstAssignExpressionBaseLength);
    *cursor += AstAssignExpressionBaseLength;
    AstNodeSerailization((AstNode *)node->value, buffer, cursor);
    AstNodeSerailization((AstNode *)node->expression, buffer, cursor);
}
AstAssignExpression *AstAssignExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstAssignExpression *node = malloc(sizeof(AstAssignExpression));
    memcpy(node, buffer + *cursor, AstAssignExpressionBaseLength);
    *cursor += AstAssignExpressionBaseLength;
    node->value =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->expression =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstAssignExpressionDestroy(AstAssignExpression *node){
    AstNodeDestroy((AstNode *)node->value);
    AstNodeDestroy((AstNode *)node->expression);
    free(node);
}
typedef struct {
    AstNodeFields
    uint32_t modifier;
    AstNode * pair;
    AstNode * expression;
}AstDeclareExpression;
static uint32_t AstDeclareExpressionBaseLength = 6;
AstDeclareExpression *AstDeclareExpressionConvert(ORDeclareExpression *exp, AstPatchFile *patch, uint32_t *length){
    AstDeclareExpression *node = malloc(sizeof(AstDeclareExpression));
    memset(node, 0, sizeof(AstDeclareExpression));
    node->nodeType = AstEnumDeclareExpression;
    node->withSemicolon = exp.withSemicolon;
    node->modifier = exp.modifier;
    node->pair = (AstNode *)AstNodeConvert(exp.pair, patch, length);
    node->expression = (AstNode *)AstNodeConvert(exp.expression, patch, length);
    *length += AstDeclareExpressionBaseLength;
    return node;
}
ORDeclareExpression *AstDeclareExpressionDeConvert(AstDeclareExpression *node, AstPatchFile *patch){
    ORDeclareExpression *exp = [ORDeclareExpression new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.modifier = node->modifier;
    exp.pair = (id)AstNodeDeConvert((AstNode *)node->pair, patch);
    exp.expression = (id)AstNodeDeConvert((AstNode *)node->expression, patch);
    return exp;
}
void AstDeclareExpressionSerailization(AstDeclareExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstDeclareExpressionBaseLength);
    *cursor += AstDeclareExpressionBaseLength;
    AstNodeSerailization((AstNode *)node->pair, buffer, cursor);
    AstNodeSerailization((AstNode *)node->expression, buffer, cursor);
}
AstDeclareExpression *AstDeclareExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstDeclareExpression *node = malloc(sizeof(AstDeclareExpression));
    memcpy(node, buffer + *cursor, AstDeclareExpressionBaseLength);
    *cursor += AstDeclareExpressionBaseLength;
    node->pair =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->expression =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstDeclareExpressionDestroy(AstDeclareExpression *node){
    AstNodeDestroy((AstNode *)node->pair);
    AstNodeDestroy((AstNode *)node->expression);
    free(node);
}
typedef struct {
    AstNodeFields
    uint32_t operatorType;
    AstNode * value;
}AstUnaryExpression;
static uint32_t AstUnaryExpressionBaseLength = 6;
AstUnaryExpression *AstUnaryExpressionConvert(ORUnaryExpression *exp, AstPatchFile *patch, uint32_t *length){
    AstUnaryExpression *node = malloc(sizeof(AstUnaryExpression));
    memset(node, 0, sizeof(AstUnaryExpression));
    node->nodeType = AstEnumUnaryExpression;
    node->withSemicolon = exp.withSemicolon;
    node->operatorType = exp.operatorType;
    node->value = (AstNode *)AstNodeConvert(exp.value, patch, length);
    *length += AstUnaryExpressionBaseLength;
    return node;
}
ORUnaryExpression *AstUnaryExpressionDeConvert(AstUnaryExpression *node, AstPatchFile *patch){
    ORUnaryExpression *exp = [ORUnaryExpression new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.operatorType = node->operatorType;
    exp.value = (id)AstNodeDeConvert((AstNode *)node->value, patch);
    return exp;
}
void AstUnaryExpressionSerailization(AstUnaryExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstUnaryExpressionBaseLength);
    *cursor += AstUnaryExpressionBaseLength;
    AstNodeSerailization((AstNode *)node->value, buffer, cursor);
}
AstUnaryExpression *AstUnaryExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstUnaryExpression *node = malloc(sizeof(AstUnaryExpression));
    memcpy(node, buffer + *cursor, AstUnaryExpressionBaseLength);
    *cursor += AstUnaryExpressionBaseLength;
    node->value =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstUnaryExpressionDestroy(AstUnaryExpression *node){
    AstNodeDestroy((AstNode *)node->value);
    free(node);
}
typedef struct {
    AstNodeFields
    uint32_t operatorType;
    AstNode * left;
    AstNode * right;
}AstBinaryExpression;
static uint32_t AstBinaryExpressionBaseLength = 6;
AstBinaryExpression *AstBinaryExpressionConvert(ORBinaryExpression *exp, AstPatchFile *patch, uint32_t *length){
    AstBinaryExpression *node = malloc(sizeof(AstBinaryExpression));
    memset(node, 0, sizeof(AstBinaryExpression));
    node->nodeType = AstEnumBinaryExpression;
    node->withSemicolon = exp.withSemicolon;
    node->operatorType = exp.operatorType;
    node->left = (AstNode *)AstNodeConvert(exp.left, patch, length);
    node->right = (AstNode *)AstNodeConvert(exp.right, patch, length);
    *length += AstBinaryExpressionBaseLength;
    return node;
}
ORBinaryExpression *AstBinaryExpressionDeConvert(AstBinaryExpression *node, AstPatchFile *patch){
    ORBinaryExpression *exp = [ORBinaryExpression new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.operatorType = node->operatorType;
    exp.left = (id)AstNodeDeConvert((AstNode *)node->left, patch);
    exp.right = (id)AstNodeDeConvert((AstNode *)node->right, patch);
    return exp;
}
void AstBinaryExpressionSerailization(AstBinaryExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstBinaryExpressionBaseLength);
    *cursor += AstBinaryExpressionBaseLength;
    AstNodeSerailization((AstNode *)node->left, buffer, cursor);
    AstNodeSerailization((AstNode *)node->right, buffer, cursor);
}
AstBinaryExpression *AstBinaryExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstBinaryExpression *node = malloc(sizeof(AstBinaryExpression));
    memcpy(node, buffer + *cursor, AstBinaryExpressionBaseLength);
    *cursor += AstBinaryExpressionBaseLength;
    node->left =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->right =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstBinaryExpressionDestroy(AstBinaryExpression *node){
    AstNodeDestroy((AstNode *)node->left);
    AstNodeDestroy((AstNode *)node->right);
    free(node);
}
typedef struct {
    AstNodeFields
    AstNode * expression;
    AstNodeList * values;
}AstTernaryExpression;
static uint32_t AstTernaryExpressionBaseLength = 2;
AstTernaryExpression *AstTernaryExpressionConvert(ORTernaryExpression *exp, AstPatchFile *patch, uint32_t *length){
    AstTernaryExpression *node = malloc(sizeof(AstTernaryExpression));
    memset(node, 0, sizeof(AstTernaryExpression));
    node->nodeType = AstEnumTernaryExpression;
    node->withSemicolon = exp.withSemicolon;
    node->expression = (AstNode *)AstNodeConvert(exp.expression, patch, length);
    node->values = (AstNodeList *)AstNodeConvert(exp.values, patch, length);
    *length += AstTernaryExpressionBaseLength;
    return node;
}
ORTernaryExpression *AstTernaryExpressionDeConvert(AstTernaryExpression *node, AstPatchFile *patch){
    ORTernaryExpression *exp = [ORTernaryExpression new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.expression = (id)AstNodeDeConvert((AstNode *)node->expression, patch);
    exp.values = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->values, patch);
    return exp;
}
void AstTernaryExpressionSerailization(AstTernaryExpression *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstTernaryExpressionBaseLength);
    *cursor += AstTernaryExpressionBaseLength;
    AstNodeSerailization((AstNode *)node->expression, buffer, cursor);
    AstNodeSerailization((AstNode *)node->values, buffer, cursor);
}
AstTernaryExpression *AstTernaryExpressionDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstTernaryExpression *node = malloc(sizeof(AstTernaryExpression));
    memcpy(node, buffer + *cursor, AstTernaryExpressionBaseLength);
    *cursor += AstTernaryExpressionBaseLength;
    node->expression =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->values =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstTernaryExpressionDestroy(AstTernaryExpression *node){
    AstNodeDestroy((AstNode *)node->expression);
    AstNodeDestroy((AstNode *)node->values);
    free(node);
}
typedef struct {
    AstNodeFields
    AstNode * condition;
    AstNode * last;
    AstNode * scopeImp;
}AstIfStatement;
static uint32_t AstIfStatementBaseLength = 2;
AstIfStatement *AstIfStatementConvert(ORIfStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstIfStatement *node = malloc(sizeof(AstIfStatement));
    memset(node, 0, sizeof(AstIfStatement));
    node->nodeType = AstEnumIfStatement;
    node->withSemicolon = exp.withSemicolon;
    node->condition = (AstNode *)AstNodeConvert(exp.condition, patch, length);
    node->last = (AstNode *)AstNodeConvert(exp.last, patch, length);
    node->scopeImp = (AstNode *)AstNodeConvert(exp.scopeImp, patch, length);
    *length += AstIfStatementBaseLength;
    return node;
}
ORIfStatement *AstIfStatementDeConvert(AstIfStatement *node, AstPatchFile *patch){
    ORIfStatement *exp = [ORIfStatement new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.condition = (id)AstNodeDeConvert((AstNode *)node->condition, patch);
    exp.last = (id)AstNodeDeConvert((AstNode *)node->last, patch);
    exp.scopeImp = (id)AstNodeDeConvert((AstNode *)node->scopeImp, patch);
    return exp;
}
void AstIfStatementSerailization(AstIfStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstIfStatementBaseLength);
    *cursor += AstIfStatementBaseLength;
    AstNodeSerailization((AstNode *)node->condition, buffer, cursor);
    AstNodeSerailization((AstNode *)node->last, buffer, cursor);
    AstNodeSerailization((AstNode *)node->scopeImp, buffer, cursor);
}
AstIfStatement *AstIfStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstIfStatement *node = malloc(sizeof(AstIfStatement));
    memcpy(node, buffer + *cursor, AstIfStatementBaseLength);
    *cursor += AstIfStatementBaseLength;
    node->condition =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->last =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstIfStatementDestroy(AstIfStatement *node){
    AstNodeDestroy((AstNode *)node->condition);
    AstNodeDestroy((AstNode *)node->last);
    AstNodeDestroy((AstNode *)node->scopeImp);
    free(node);
}
typedef struct {
    AstNodeFields
    AstNode * condition;
    AstNode * scopeImp;
}AstWhileStatement;
static uint32_t AstWhileStatementBaseLength = 2;
AstWhileStatement *AstWhileStatementConvert(ORWhileStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstWhileStatement *node = malloc(sizeof(AstWhileStatement));
    memset(node, 0, sizeof(AstWhileStatement));
    node->nodeType = AstEnumWhileStatement;
    node->withSemicolon = exp.withSemicolon;
    node->condition = (AstNode *)AstNodeConvert(exp.condition, patch, length);
    node->scopeImp = (AstNode *)AstNodeConvert(exp.scopeImp, patch, length);
    *length += AstWhileStatementBaseLength;
    return node;
}
ORWhileStatement *AstWhileStatementDeConvert(AstWhileStatement *node, AstPatchFile *patch){
    ORWhileStatement *exp = [ORWhileStatement new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.condition = (id)AstNodeDeConvert((AstNode *)node->condition, patch);
    exp.scopeImp = (id)AstNodeDeConvert((AstNode *)node->scopeImp, patch);
    return exp;
}
void AstWhileStatementSerailization(AstWhileStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstWhileStatementBaseLength);
    *cursor += AstWhileStatementBaseLength;
    AstNodeSerailization((AstNode *)node->condition, buffer, cursor);
    AstNodeSerailization((AstNode *)node->scopeImp, buffer, cursor);
}
AstWhileStatement *AstWhileStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstWhileStatement *node = malloc(sizeof(AstWhileStatement));
    memcpy(node, buffer + *cursor, AstWhileStatementBaseLength);
    *cursor += AstWhileStatementBaseLength;
    node->condition =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstWhileStatementDestroy(AstWhileStatement *node){
    AstNodeDestroy((AstNode *)node->condition);
    AstNodeDestroy((AstNode *)node->scopeImp);
    free(node);
}
typedef struct {
    AstNodeFields
    AstNode * condition;
    AstNode * scopeImp;
}AstDoWhileStatement;
static uint32_t AstDoWhileStatementBaseLength = 2;
AstDoWhileStatement *AstDoWhileStatementConvert(ORDoWhileStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstDoWhileStatement *node = malloc(sizeof(AstDoWhileStatement));
    memset(node, 0, sizeof(AstDoWhileStatement));
    node->nodeType = AstEnumDoWhileStatement;
    node->withSemicolon = exp.withSemicolon;
    node->condition = (AstNode *)AstNodeConvert(exp.condition, patch, length);
    node->scopeImp = (AstNode *)AstNodeConvert(exp.scopeImp, patch, length);
    *length += AstDoWhileStatementBaseLength;
    return node;
}
ORDoWhileStatement *AstDoWhileStatementDeConvert(AstDoWhileStatement *node, AstPatchFile *patch){
    ORDoWhileStatement *exp = [ORDoWhileStatement new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.condition = (id)AstNodeDeConvert((AstNode *)node->condition, patch);
    exp.scopeImp = (id)AstNodeDeConvert((AstNode *)node->scopeImp, patch);
    return exp;
}
void AstDoWhileStatementSerailization(AstDoWhileStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstDoWhileStatementBaseLength);
    *cursor += AstDoWhileStatementBaseLength;
    AstNodeSerailization((AstNode *)node->condition, buffer, cursor);
    AstNodeSerailization((AstNode *)node->scopeImp, buffer, cursor);
}
AstDoWhileStatement *AstDoWhileStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstDoWhileStatement *node = malloc(sizeof(AstDoWhileStatement));
    memcpy(node, buffer + *cursor, AstDoWhileStatementBaseLength);
    *cursor += AstDoWhileStatementBaseLength;
    node->condition =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstDoWhileStatementDestroy(AstDoWhileStatement *node){
    AstNodeDestroy((AstNode *)node->condition);
    AstNodeDestroy((AstNode *)node->scopeImp);
    free(node);
}
typedef struct {
    AstNodeFields
    AstNode * value;
    AstNode * scopeImp;
}AstCaseStatement;
static uint32_t AstCaseStatementBaseLength = 2;
AstCaseStatement *AstCaseStatementConvert(ORCaseStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstCaseStatement *node = malloc(sizeof(AstCaseStatement));
    memset(node, 0, sizeof(AstCaseStatement));
    node->nodeType = AstEnumCaseStatement;
    node->withSemicolon = exp.withSemicolon;
    node->value = (AstNode *)AstNodeConvert(exp.value, patch, length);
    node->scopeImp = (AstNode *)AstNodeConvert(exp.scopeImp, patch, length);
    *length += AstCaseStatementBaseLength;
    return node;
}
ORCaseStatement *AstCaseStatementDeConvert(AstCaseStatement *node, AstPatchFile *patch){
    ORCaseStatement *exp = [ORCaseStatement new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.value = (id)AstNodeDeConvert((AstNode *)node->value, patch);
    exp.scopeImp = (id)AstNodeDeConvert((AstNode *)node->scopeImp, patch);
    return exp;
}
void AstCaseStatementSerailization(AstCaseStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstCaseStatementBaseLength);
    *cursor += AstCaseStatementBaseLength;
    AstNodeSerailization((AstNode *)node->value, buffer, cursor);
    AstNodeSerailization((AstNode *)node->scopeImp, buffer, cursor);
}
AstCaseStatement *AstCaseStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstCaseStatement *node = malloc(sizeof(AstCaseStatement));
    memcpy(node, buffer + *cursor, AstCaseStatementBaseLength);
    *cursor += AstCaseStatementBaseLength;
    node->value =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstCaseStatementDestroy(AstCaseStatement *node){
    AstNodeDestroy((AstNode *)node->value);
    AstNodeDestroy((AstNode *)node->scopeImp);
    free(node);
}
typedef struct {
    AstNodeFields
    AstNode * value;
    AstNodeList * cases;
    AstNode * scopeImp;
}AstSwitchStatement;
static uint32_t AstSwitchStatementBaseLength = 2;
AstSwitchStatement *AstSwitchStatementConvert(ORSwitchStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstSwitchStatement *node = malloc(sizeof(AstSwitchStatement));
    memset(node, 0, sizeof(AstSwitchStatement));
    node->nodeType = AstEnumSwitchStatement;
    node->withSemicolon = exp.withSemicolon;
    node->value = (AstNode *)AstNodeConvert(exp.value, patch, length);
    node->cases = (AstNodeList *)AstNodeConvert(exp.cases, patch, length);
    node->scopeImp = (AstNode *)AstNodeConvert(exp.scopeImp, patch, length);
    *length += AstSwitchStatementBaseLength;
    return node;
}
ORSwitchStatement *AstSwitchStatementDeConvert(AstSwitchStatement *node, AstPatchFile *patch){
    ORSwitchStatement *exp = [ORSwitchStatement new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.value = (id)AstNodeDeConvert((AstNode *)node->value, patch);
    exp.cases = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->cases, patch);
    exp.scopeImp = (id)AstNodeDeConvert((AstNode *)node->scopeImp, patch);
    return exp;
}
void AstSwitchStatementSerailization(AstSwitchStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstSwitchStatementBaseLength);
    *cursor += AstSwitchStatementBaseLength;
    AstNodeSerailization((AstNode *)node->value, buffer, cursor);
    AstNodeSerailization((AstNode *)node->cases, buffer, cursor);
    AstNodeSerailization((AstNode *)node->scopeImp, buffer, cursor);
}
AstSwitchStatement *AstSwitchStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstSwitchStatement *node = malloc(sizeof(AstSwitchStatement));
    memcpy(node, buffer + *cursor, AstSwitchStatementBaseLength);
    *cursor += AstSwitchStatementBaseLength;
    node->value =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->cases =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstSwitchStatementDestroy(AstSwitchStatement *node){
    AstNodeDestroy((AstNode *)node->value);
    AstNodeDestroy((AstNode *)node->cases);
    AstNodeDestroy((AstNode *)node->scopeImp);
    free(node);
}
typedef struct {
    AstNodeFields
    AstNodeList * varExpressions;
    AstNode * condition;
    AstNodeList * expressions;
    AstNode * scopeImp;
}AstForStatement;
static uint32_t AstForStatementBaseLength = 2;
AstForStatement *AstForStatementConvert(ORForStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstForStatement *node = malloc(sizeof(AstForStatement));
    memset(node, 0, sizeof(AstForStatement));
    node->nodeType = AstEnumForStatement;
    node->withSemicolon = exp.withSemicolon;
    node->varExpressions = (AstNodeList *)AstNodeConvert(exp.varExpressions, patch, length);
    node->condition = (AstNode *)AstNodeConvert(exp.condition, patch, length);
    node->expressions = (AstNodeList *)AstNodeConvert(exp.expressions, patch, length);
    node->scopeImp = (AstNode *)AstNodeConvert(exp.scopeImp, patch, length);
    *length += AstForStatementBaseLength;
    return node;
}
ORForStatement *AstForStatementDeConvert(AstForStatement *node, AstPatchFile *patch){
    ORForStatement *exp = [ORForStatement new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.varExpressions = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->varExpressions, patch);
    exp.condition = (id)AstNodeDeConvert((AstNode *)node->condition, patch);
    exp.expressions = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->expressions, patch);
    exp.scopeImp = (id)AstNodeDeConvert((AstNode *)node->scopeImp, patch);
    return exp;
}
void AstForStatementSerailization(AstForStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstForStatementBaseLength);
    *cursor += AstForStatementBaseLength;
    AstNodeSerailization((AstNode *)node->varExpressions, buffer, cursor);
    AstNodeSerailization((AstNode *)node->condition, buffer, cursor);
    AstNodeSerailization((AstNode *)node->expressions, buffer, cursor);
    AstNodeSerailization((AstNode *)node->scopeImp, buffer, cursor);
}
AstForStatement *AstForStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstForStatement *node = malloc(sizeof(AstForStatement));
    memcpy(node, buffer + *cursor, AstForStatementBaseLength);
    *cursor += AstForStatementBaseLength;
    node->varExpressions =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->condition =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->expressions =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstForStatementDestroy(AstForStatement *node){
    AstNodeDestroy((AstNode *)node->varExpressions);
    AstNodeDestroy((AstNode *)node->condition);
    AstNodeDestroy((AstNode *)node->expressions);
    AstNodeDestroy((AstNode *)node->scopeImp);
    free(node);
}
typedef struct {
    AstNodeFields
    AstNode * expression;
    AstNode * value;
    AstNode * scopeImp;
}AstForInStatement;
static uint32_t AstForInStatementBaseLength = 2;
AstForInStatement *AstForInStatementConvert(ORForInStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstForInStatement *node = malloc(sizeof(AstForInStatement));
    memset(node, 0, sizeof(AstForInStatement));
    node->nodeType = AstEnumForInStatement;
    node->withSemicolon = exp.withSemicolon;
    node->expression = (AstNode *)AstNodeConvert(exp.expression, patch, length);
    node->value = (AstNode *)AstNodeConvert(exp.value, patch, length);
    node->scopeImp = (AstNode *)AstNodeConvert(exp.scopeImp, patch, length);
    *length += AstForInStatementBaseLength;
    return node;
}
ORForInStatement *AstForInStatementDeConvert(AstForInStatement *node, AstPatchFile *patch){
    ORForInStatement *exp = [ORForInStatement new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.expression = (id)AstNodeDeConvert((AstNode *)node->expression, patch);
    exp.value = (id)AstNodeDeConvert((AstNode *)node->value, patch);
    exp.scopeImp = (id)AstNodeDeConvert((AstNode *)node->scopeImp, patch);
    return exp;
}
void AstForInStatementSerailization(AstForInStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstForInStatementBaseLength);
    *cursor += AstForInStatementBaseLength;
    AstNodeSerailization((AstNode *)node->expression, buffer, cursor);
    AstNodeSerailization((AstNode *)node->value, buffer, cursor);
    AstNodeSerailization((AstNode *)node->scopeImp, buffer, cursor);
}
AstForInStatement *AstForInStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstForInStatement *node = malloc(sizeof(AstForInStatement));
    memcpy(node, buffer + *cursor, AstForInStatementBaseLength);
    *cursor += AstForInStatementBaseLength;
    node->expression =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->value =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstForInStatementDestroy(AstForInStatement *node){
    AstNodeDestroy((AstNode *)node->expression);
    AstNodeDestroy((AstNode *)node->value);
    AstNodeDestroy((AstNode *)node->scopeImp);
    free(node);
}
typedef struct {
    AstNodeFields
    AstNode * expression;
}AstReturnStatement;
static uint32_t AstReturnStatementBaseLength = 2;
AstReturnStatement *AstReturnStatementConvert(ORReturnStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstReturnStatement *node = malloc(sizeof(AstReturnStatement));
    memset(node, 0, sizeof(AstReturnStatement));
    node->nodeType = AstEnumReturnStatement;
    node->withSemicolon = exp.withSemicolon;
    node->expression = (AstNode *)AstNodeConvert(exp.expression, patch, length);
    *length += AstReturnStatementBaseLength;
    return node;
}
ORReturnStatement *AstReturnStatementDeConvert(AstReturnStatement *node, AstPatchFile *patch){
    ORReturnStatement *exp = [ORReturnStatement new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.expression = (id)AstNodeDeConvert((AstNode *)node->expression, patch);
    return exp;
}
void AstReturnStatementSerailization(AstReturnStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstReturnStatementBaseLength);
    *cursor += AstReturnStatementBaseLength;
    AstNodeSerailization((AstNode *)node->expression, buffer, cursor);
}
AstReturnStatement *AstReturnStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstReturnStatement *node = malloc(sizeof(AstReturnStatement));
    memcpy(node, buffer + *cursor, AstReturnStatementBaseLength);
    *cursor += AstReturnStatementBaseLength;
    node->expression =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstReturnStatementDestroy(AstReturnStatement *node){
    AstNodeDestroy((AstNode *)node->expression);
    free(node);
}
typedef struct {
    AstNodeFields
    
}AstBreakStatement;
static uint32_t AstBreakStatementBaseLength = 2;
AstBreakStatement *AstBreakStatementConvert(ORBreakStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstBreakStatement *node = malloc(sizeof(AstBreakStatement));
    memset(node, 0, sizeof(AstBreakStatement));
    node->nodeType = AstEnumBreakStatement;
    node->withSemicolon = exp.withSemicolon;
    
    *length += AstBreakStatementBaseLength;
    return node;
}
ORBreakStatement *AstBreakStatementDeConvert(AstBreakStatement *node, AstPatchFile *patch){
    ORBreakStatement *exp = [ORBreakStatement new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    
    return exp;
}
void AstBreakStatementSerailization(AstBreakStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstBreakStatementBaseLength);
    *cursor += AstBreakStatementBaseLength;
    
}
AstBreakStatement *AstBreakStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstBreakStatement *node = malloc(sizeof(AstBreakStatement));
    memcpy(node, buffer + *cursor, AstBreakStatementBaseLength);
    *cursor += AstBreakStatementBaseLength;
    
    return node;
}
void AstBreakStatementDestroy(AstBreakStatement *node){
    
    free(node);
}
typedef struct {
    AstNodeFields
    
}AstContinueStatement;
static uint32_t AstContinueStatementBaseLength = 2;
AstContinueStatement *AstContinueStatementConvert(ORContinueStatement *exp, AstPatchFile *patch, uint32_t *length){
    AstContinueStatement *node = malloc(sizeof(AstContinueStatement));
    memset(node, 0, sizeof(AstContinueStatement));
    node->nodeType = AstEnumContinueStatement;
    node->withSemicolon = exp.withSemicolon;
    
    *length += AstContinueStatementBaseLength;
    return node;
}
ORContinueStatement *AstContinueStatementDeConvert(AstContinueStatement *node, AstPatchFile *patch){
    ORContinueStatement *exp = [ORContinueStatement new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    
    return exp;
}
void AstContinueStatementSerailization(AstContinueStatement *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstContinueStatementBaseLength);
    *cursor += AstContinueStatementBaseLength;
    
}
AstContinueStatement *AstContinueStatementDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstContinueStatement *node = malloc(sizeof(AstContinueStatement));
    memcpy(node, buffer + *cursor, AstContinueStatementBaseLength);
    *cursor += AstContinueStatementBaseLength;
    
    return node;
}
void AstContinueStatementDestroy(AstContinueStatement *node){
    
    free(node);
}
typedef struct {
    AstNodeFields
    AstNodeList * keywords;
    AstNode * var;
}AstPropertyDeclare;
static uint32_t AstPropertyDeclareBaseLength = 2;
AstPropertyDeclare *AstPropertyDeclareConvert(ORPropertyDeclare *exp, AstPatchFile *patch, uint32_t *length){
    AstPropertyDeclare *node = malloc(sizeof(AstPropertyDeclare));
    memset(node, 0, sizeof(AstPropertyDeclare));
    node->nodeType = AstEnumPropertyDeclare;
    node->withSemicolon = exp.withSemicolon;
    node->keywords = (AstNodeList *)AstNodeConvert(exp.keywords, patch, length);
    node->var = (AstNode *)AstNodeConvert(exp.var, patch, length);
    *length += AstPropertyDeclareBaseLength;
    return node;
}
ORPropertyDeclare *AstPropertyDeclareDeConvert(AstPropertyDeclare *node, AstPatchFile *patch){
    ORPropertyDeclare *exp = [ORPropertyDeclare new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.keywords = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->keywords, patch);
    exp.var = (id)AstNodeDeConvert((AstNode *)node->var, patch);
    return exp;
}
void AstPropertyDeclareSerailization(AstPropertyDeclare *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstPropertyDeclareBaseLength);
    *cursor += AstPropertyDeclareBaseLength;
    AstNodeSerailization((AstNode *)node->keywords, buffer, cursor);
    AstNodeSerailization((AstNode *)node->var, buffer, cursor);
}
AstPropertyDeclare *AstPropertyDeclareDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstPropertyDeclare *node = malloc(sizeof(AstPropertyDeclare));
    memcpy(node, buffer + *cursor, AstPropertyDeclareBaseLength);
    *cursor += AstPropertyDeclareBaseLength;
    node->keywords =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->var =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstPropertyDeclareDestroy(AstPropertyDeclare *node){
    AstNodeDestroy((AstNode *)node->keywords);
    AstNodeDestroy((AstNode *)node->var);
    free(node);
}
typedef struct {
    AstNodeFields
    BOOL isClassMethod;
    AstNode * returnType;
    AstNodeList * methodNames;
    AstNodeList * parameterTypes;
    AstNodeList * parameterNames;
}AstMethodDeclare;
static uint32_t AstMethodDeclareBaseLength = 3;
AstMethodDeclare *AstMethodDeclareConvert(ORMethodDeclare *exp, AstPatchFile *patch, uint32_t *length){
    AstMethodDeclare *node = malloc(sizeof(AstMethodDeclare));
    memset(node, 0, sizeof(AstMethodDeclare));
    node->nodeType = AstEnumMethodDeclare;
    node->withSemicolon = exp.withSemicolon;
    node->isClassMethod = exp.isClassMethod;
    node->returnType = (AstNode *)AstNodeConvert(exp.returnType, patch, length);
    node->methodNames = (AstNodeList *)AstNodeConvert(exp.methodNames, patch, length);
    node->parameterTypes = (AstNodeList *)AstNodeConvert(exp.parameterTypes, patch, length);
    node->parameterNames = (AstNodeList *)AstNodeConvert(exp.parameterNames, patch, length);
    *length += AstMethodDeclareBaseLength;
    return node;
}
ORMethodDeclare *AstMethodDeclareDeConvert(AstMethodDeclare *node, AstPatchFile *patch){
    ORMethodDeclare *exp = [ORMethodDeclare new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.isClassMethod = node->isClassMethod;
    exp.returnType = (id)AstNodeDeConvert((AstNode *)node->returnType, patch);
    exp.methodNames = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->methodNames, patch);
    exp.parameterTypes = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->parameterTypes, patch);
    exp.parameterNames = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->parameterNames, patch);
    return exp;
}
void AstMethodDeclareSerailization(AstMethodDeclare *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstMethodDeclareBaseLength);
    *cursor += AstMethodDeclareBaseLength;
    AstNodeSerailization((AstNode *)node->returnType, buffer, cursor);
    AstNodeSerailization((AstNode *)node->methodNames, buffer, cursor);
    AstNodeSerailization((AstNode *)node->parameterTypes, buffer, cursor);
    AstNodeSerailization((AstNode *)node->parameterNames, buffer, cursor);
}
AstMethodDeclare *AstMethodDeclareDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstMethodDeclare *node = malloc(sizeof(AstMethodDeclare));
    memcpy(node, buffer + *cursor, AstMethodDeclareBaseLength);
    *cursor += AstMethodDeclareBaseLength;
    node->returnType =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->methodNames =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->parameterTypes =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->parameterNames =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstMethodDeclareDestroy(AstMethodDeclare *node){
    AstNodeDestroy((AstNode *)node->returnType);
    AstNodeDestroy((AstNode *)node->methodNames);
    AstNodeDestroy((AstNode *)node->parameterTypes);
    AstNodeDestroy((AstNode *)node->parameterNames);
    free(node);
}
typedef struct {
    AstNodeFields
    AstNode * declare;
    AstNode * scopeImp;
}AstMethodImplementation;
static uint32_t AstMethodImplementationBaseLength = 2;
AstMethodImplementation *AstMethodImplementationConvert(ORMethodImplementation *exp, AstPatchFile *patch, uint32_t *length){
    AstMethodImplementation *node = malloc(sizeof(AstMethodImplementation));
    memset(node, 0, sizeof(AstMethodImplementation));
    node->nodeType = AstEnumMethodImplementation;
    node->withSemicolon = exp.withSemicolon;
    node->declare = (AstNode *)AstNodeConvert(exp.declare, patch, length);
    node->scopeImp = (AstNode *)AstNodeConvert(exp.scopeImp, patch, length);
    *length += AstMethodImplementationBaseLength;
    return node;
}
ORMethodImplementation *AstMethodImplementationDeConvert(AstMethodImplementation *node, AstPatchFile *patch){
    ORMethodImplementation *exp = [ORMethodImplementation new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.declare = (id)AstNodeDeConvert((AstNode *)node->declare, patch);
    exp.scopeImp = (id)AstNodeDeConvert((AstNode *)node->scopeImp, patch);
    return exp;
}
void AstMethodImplementationSerailization(AstMethodImplementation *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstMethodImplementationBaseLength);
    *cursor += AstMethodImplementationBaseLength;
    AstNodeSerailization((AstNode *)node->declare, buffer, cursor);
    AstNodeSerailization((AstNode *)node->scopeImp, buffer, cursor);
}
AstMethodImplementation *AstMethodImplementationDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstMethodImplementation *node = malloc(sizeof(AstMethodImplementation));
    memcpy(node, buffer + *cursor, AstMethodImplementationBaseLength);
    *cursor += AstMethodImplementationBaseLength;
    node->declare =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->scopeImp =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstMethodImplementationDestroy(AstMethodImplementation *node){
    AstNodeDestroy((AstNode *)node->declare);
    AstNodeDestroy((AstNode *)node->scopeImp);
    free(node);
}
typedef struct {
    AstNodeFields
    ORStringCursor * className;
    ORStringCursor * superClassName;
    AstNodeList * protocols;
    AstNodeList * properties;
    AstNodeList * privateVariables;
    AstNodeList * methods;
}AstClass;
static uint32_t AstClassBaseLength = 2;
AstClass *AstClassConvert(ORClass *exp, AstPatchFile *patch, uint32_t *length){
    AstClass *node = malloc(sizeof(AstClass));
    memset(node, 0, sizeof(AstClass));
    node->nodeType = AstEnumClass;
    node->withSemicolon = exp.withSemicolon;
    node->className = (ORStringCursor *)AstNodeConvert(exp.className, patch, length);
    node->superClassName = (ORStringCursor *)AstNodeConvert(exp.superClassName, patch, length);
    node->protocols = (AstNodeList *)AstNodeConvert(exp.protocols, patch, length);
    node->properties = (AstNodeList *)AstNodeConvert(exp.properties, patch, length);
    node->privateVariables = (AstNodeList *)AstNodeConvert(exp.privateVariables, patch, length);
    node->methods = (AstNodeList *)AstNodeConvert(exp.methods, patch, length);
    *length += AstClassBaseLength;
    return node;
}
ORClass *AstClassDeConvert(AstClass *node, AstPatchFile *patch){
    ORClass *exp = [ORClass new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.className = (NSString *)AstNodeDeConvert((AstNode *)node->className, patch);
    exp.superClassName = (NSString *)AstNodeDeConvert((AstNode *)node->superClassName, patch);
    exp.protocols = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->protocols, patch);
    exp.properties = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->properties, patch);
    exp.privateVariables = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->privateVariables, patch);
    exp.methods = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->methods, patch);
    return exp;
}
void AstClassSerailization(AstClass *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstClassBaseLength);
    *cursor += AstClassBaseLength;
    AstNodeSerailization((AstNode *)node->className, buffer, cursor);
    AstNodeSerailization((AstNode *)node->superClassName, buffer, cursor);
    AstNodeSerailization((AstNode *)node->protocols, buffer, cursor);
    AstNodeSerailization((AstNode *)node->properties, buffer, cursor);
    AstNodeSerailization((AstNode *)node->privateVariables, buffer, cursor);
    AstNodeSerailization((AstNode *)node->methods, buffer, cursor);
}
AstClass *AstClassDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstClass *node = malloc(sizeof(AstClass));
    memcpy(node, buffer + *cursor, AstClassBaseLength);
    *cursor += AstClassBaseLength;
    node->className =(ORStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->superClassName =(ORStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->protocols =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->properties =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->privateVariables =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->methods =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstClassDestroy(AstClass *node){
    AstNodeDestroy((AstNode *)node->className);
    AstNodeDestroy((AstNode *)node->superClassName);
    AstNodeDestroy((AstNode *)node->protocols);
    AstNodeDestroy((AstNode *)node->properties);
    AstNodeDestroy((AstNode *)node->privateVariables);
    AstNodeDestroy((AstNode *)node->methods);
    free(node);
}
typedef struct {
    AstNodeFields
    ORStringCursor * protcolName;
    AstNodeList * protocols;
    AstNodeList * properties;
    AstNodeList * methods;
}AstProtocol;
static uint32_t AstProtocolBaseLength = 2;
AstProtocol *AstProtocolConvert(ORProtocol *exp, AstPatchFile *patch, uint32_t *length){
    AstProtocol *node = malloc(sizeof(AstProtocol));
    memset(node, 0, sizeof(AstProtocol));
    node->nodeType = AstEnumProtocol;
    node->withSemicolon = exp.withSemicolon;
    node->protcolName = (ORStringCursor *)AstNodeConvert(exp.protcolName, patch, length);
    node->protocols = (AstNodeList *)AstNodeConvert(exp.protocols, patch, length);
    node->properties = (AstNodeList *)AstNodeConvert(exp.properties, patch, length);
    node->methods = (AstNodeList *)AstNodeConvert(exp.methods, patch, length);
    *length += AstProtocolBaseLength;
    return node;
}
ORProtocol *AstProtocolDeConvert(AstProtocol *node, AstPatchFile *patch){
    ORProtocol *exp = [ORProtocol new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.protcolName = (NSString *)AstNodeDeConvert((AstNode *)node->protcolName, patch);
    exp.protocols = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->protocols, patch);
    exp.properties = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->properties, patch);
    exp.methods = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->methods, patch);
    return exp;
}
void AstProtocolSerailization(AstProtocol *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstProtocolBaseLength);
    *cursor += AstProtocolBaseLength;
    AstNodeSerailization((AstNode *)node->protcolName, buffer, cursor);
    AstNodeSerailization((AstNode *)node->protocols, buffer, cursor);
    AstNodeSerailization((AstNode *)node->properties, buffer, cursor);
    AstNodeSerailization((AstNode *)node->methods, buffer, cursor);
}
AstProtocol *AstProtocolDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstProtocol *node = malloc(sizeof(AstProtocol));
    memcpy(node, buffer + *cursor, AstProtocolBaseLength);
    *cursor += AstProtocolBaseLength;
    node->protcolName =(ORStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->protocols =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->properties =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->methods =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstProtocolDestroy(AstProtocol *node){
    AstNodeDestroy((AstNode *)node->protcolName);
    AstNodeDestroy((AstNode *)node->protocols);
    AstNodeDestroy((AstNode *)node->properties);
    AstNodeDestroy((AstNode *)node->methods);
    free(node);
}
typedef struct {
    AstNodeFields
    ORStringCursor * sturctName;
    AstNodeList * fields;
}AstStructExpressoin;
static uint32_t AstStructExpressoinBaseLength = 2;
AstStructExpressoin *AstStructExpressoinConvert(ORStructExpressoin *exp, AstPatchFile *patch, uint32_t *length){
    AstStructExpressoin *node = malloc(sizeof(AstStructExpressoin));
    memset(node, 0, sizeof(AstStructExpressoin));
    node->nodeType = AstEnumStructExpressoin;
    node->withSemicolon = exp.withSemicolon;
    node->sturctName = (ORStringCursor *)AstNodeConvert(exp.sturctName, patch, length);
    node->fields = (AstNodeList *)AstNodeConvert(exp.fields, patch, length);
    *length += AstStructExpressoinBaseLength;
    return node;
}
ORStructExpressoin *AstStructExpressoinDeConvert(AstStructExpressoin *node, AstPatchFile *patch){
    ORStructExpressoin *exp = [ORStructExpressoin new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.sturctName = (NSString *)AstNodeDeConvert((AstNode *)node->sturctName, patch);
    exp.fields = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->fields, patch);
    return exp;
}
void AstStructExpressoinSerailization(AstStructExpressoin *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstStructExpressoinBaseLength);
    *cursor += AstStructExpressoinBaseLength;
    AstNodeSerailization((AstNode *)node->sturctName, buffer, cursor);
    AstNodeSerailization((AstNode *)node->fields, buffer, cursor);
}
AstStructExpressoin *AstStructExpressoinDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstStructExpressoin *node = malloc(sizeof(AstStructExpressoin));
    memcpy(node, buffer + *cursor, AstStructExpressoinBaseLength);
    *cursor += AstStructExpressoinBaseLength;
    node->sturctName =(ORStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->fields =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstStructExpressoinDestroy(AstStructExpressoin *node){
    AstNodeDestroy((AstNode *)node->sturctName);
    AstNodeDestroy((AstNode *)node->fields);
    free(node);
}
typedef struct {
    AstNodeFields
    uint32_t valueType;
    ORStringCursor * enumName;
    AstNodeList * fields;
}AstEnumExpressoin;
static uint32_t AstEnumExpressoinBaseLength = 6;
AstEnumExpressoin *AstEnumExpressoinConvert(OREnumExpressoin *exp, AstPatchFile *patch, uint32_t *length){
    AstEnumExpressoin *node = malloc(sizeof(AstEnumExpressoin));
    memset(node, 0, sizeof(AstEnumExpressoin));
    node->nodeType = AstEnumEnumExpressoin;
    node->withSemicolon = exp.withSemicolon;
    node->valueType = exp.valueType;
    node->enumName = (ORStringCursor *)AstNodeConvert(exp.enumName, patch, length);
    node->fields = (AstNodeList *)AstNodeConvert(exp.fields, patch, length);
    *length += AstEnumExpressoinBaseLength;
    return node;
}
OREnumExpressoin *AstEnumExpressoinDeConvert(AstEnumExpressoin *node, AstPatchFile *patch){
    OREnumExpressoin *exp = [OREnumExpressoin new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.valueType = node->valueType;
    exp.enumName = (NSString *)AstNodeDeConvert((AstNode *)node->enumName, patch);
    exp.fields = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->fields, patch);
    return exp;
}
void AstEnumExpressoinSerailization(AstEnumExpressoin *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstEnumExpressoinBaseLength);
    *cursor += AstEnumExpressoinBaseLength;
    AstNodeSerailization((AstNode *)node->enumName, buffer, cursor);
    AstNodeSerailization((AstNode *)node->fields, buffer, cursor);
}
AstEnumExpressoin *AstEnumExpressoinDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstEnumExpressoin *node = malloc(sizeof(AstEnumExpressoin));
    memcpy(node, buffer + *cursor, AstEnumExpressoinBaseLength);
    *cursor += AstEnumExpressoinBaseLength;
    node->enumName =(ORStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->fields =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstEnumExpressoinDestroy(AstEnumExpressoin *node){
    AstNodeDestroy((AstNode *)node->enumName);
    AstNodeDestroy((AstNode *)node->fields);
    free(node);
}
typedef struct {
    AstNodeFields
    AstNode * expression;
    ORStringCursor * typeNewName;
}AstTypedefExpressoin;
static uint32_t AstTypedefExpressoinBaseLength = 2;
AstTypedefExpressoin *AstTypedefExpressoinConvert(ORTypedefExpressoin *exp, AstPatchFile *patch, uint32_t *length){
    AstTypedefExpressoin *node = malloc(sizeof(AstTypedefExpressoin));
    memset(node, 0, sizeof(AstTypedefExpressoin));
    node->nodeType = AstEnumTypedefExpressoin;
    node->withSemicolon = exp.withSemicolon;
    node->expression = (AstNode *)AstNodeConvert(exp.expression, patch, length);
    node->typeNewName = (ORStringCursor *)AstNodeConvert(exp.typeNewName, patch, length);
    *length += AstTypedefExpressoinBaseLength;
    return node;
}
ORTypedefExpressoin *AstTypedefExpressoinDeConvert(AstTypedefExpressoin *node, AstPatchFile *patch){
    ORTypedefExpressoin *exp = [ORTypedefExpressoin new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.expression = (id)AstNodeDeConvert((AstNode *)node->expression, patch);
    exp.typeNewName = (NSString *)AstNodeDeConvert((AstNode *)node->typeNewName, patch);
    return exp;
}
void AstTypedefExpressoinSerailization(AstTypedefExpressoin *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstTypedefExpressoinBaseLength);
    *cursor += AstTypedefExpressoinBaseLength;
    AstNodeSerailization((AstNode *)node->expression, buffer, cursor);
    AstNodeSerailization((AstNode *)node->typeNewName, buffer, cursor);
}
AstTypedefExpressoin *AstTypedefExpressoinDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstTypedefExpressoin *node = malloc(sizeof(AstTypedefExpressoin));
    memcpy(node, buffer + *cursor, AstTypedefExpressoinBaseLength);
    *cursor += AstTypedefExpressoinBaseLength;
    node->expression =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->typeNewName =(ORStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstTypedefExpressoinDestroy(AstTypedefExpressoin *node){
    AstNodeDestroy((AstNode *)node->expression);
    AstNodeDestroy((AstNode *)node->typeNewName);
    free(node);
}
typedef struct {
    AstNodeFields
    BOOL isBlock;
    uint8_t ptCount;
    ORStringCursor * varname;
    AstNode * prev;
    AstNode * capacity;
}AstCArrayVariable;
static uint32_t AstCArrayVariableBaseLength = 4;
AstCArrayVariable *AstCArrayVariableConvert(ORCArrayVariable *exp, AstPatchFile *patch, uint32_t *length){
    AstCArrayVariable *node = malloc(sizeof(AstCArrayVariable));
    memset(node, 0, sizeof(AstCArrayVariable));
    node->nodeType = AstEnumCArrayVariable;
    node->withSemicolon = exp.withSemicolon;
    node->isBlock = exp.isBlock;
    node->ptCount = exp.ptCount;
    node->varname = (ORStringCursor *)AstNodeConvert(exp.varname, patch, length);
    node->prev = (AstNode *)AstNodeConvert(exp.prev, patch, length);
    node->capacity = (AstNode *)AstNodeConvert(exp.capacity, patch, length);
    *length += AstCArrayVariableBaseLength;
    return node;
}
ORCArrayVariable *AstCArrayVariableDeConvert(AstCArrayVariable *node, AstPatchFile *patch){
    ORCArrayVariable *exp = [ORCArrayVariable new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.isBlock = node->isBlock;
    exp.ptCount = node->ptCount;
    exp.varname = (NSString *)AstNodeDeConvert((AstNode *)node->varname, patch);
    exp.prev = (id)AstNodeDeConvert((AstNode *)node->prev, patch);
    exp.capacity = (id)AstNodeDeConvert((AstNode *)node->capacity, patch);
    return exp;
}
void AstCArrayVariableSerailization(AstCArrayVariable *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstCArrayVariableBaseLength);
    *cursor += AstCArrayVariableBaseLength;
    AstNodeSerailization((AstNode *)node->varname, buffer, cursor);
    AstNodeSerailization((AstNode *)node->prev, buffer, cursor);
    AstNodeSerailization((AstNode *)node->capacity, buffer, cursor);
}
AstCArrayVariable *AstCArrayVariableDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstCArrayVariable *node = malloc(sizeof(AstCArrayVariable));
    memcpy(node, buffer + *cursor, AstCArrayVariableBaseLength);
    *cursor += AstCArrayVariableBaseLength;
    node->varname =(ORStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->prev =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->capacity =(AstNode *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstCArrayVariableDestroy(AstCArrayVariable *node){
    AstNodeDestroy((AstNode *)node->prev);
    AstNodeDestroy((AstNode *)node->capacity);
    free(node);
}
typedef struct {
    AstNodeFields
    ORStringCursor * unionName;
    AstNodeList * fields;
}AstUnionExpressoin;
static uint32_t AstUnionExpressoinBaseLength = 2;
AstUnionExpressoin *AstUnionExpressoinConvert(ORUnionExpressoin *exp, AstPatchFile *patch, uint32_t *length){
    AstUnionExpressoin *node = malloc(sizeof(AstUnionExpressoin));
    memset(node, 0, sizeof(AstUnionExpressoin));
    node->nodeType = AstEnumUnionExpressoin;
    node->withSemicolon = exp.withSemicolon;
    node->unionName = (ORStringCursor *)AstNodeConvert(exp.unionName, patch, length);
    node->fields = (AstNodeList *)AstNodeConvert(exp.fields, patch, length);
    *length += AstUnionExpressoinBaseLength;
    return node;
}
ORUnionExpressoin *AstUnionExpressoinDeConvert(AstUnionExpressoin *node, AstPatchFile *patch){
    ORUnionExpressoin *exp = [ORUnionExpressoin new];
    exp.withSemicolon = node->withSemicolon;
    exp.nodeType = node->nodeType;
    exp.unionName = (NSString *)AstNodeDeConvert((AstNode *)node->unionName, patch);
    exp.fields = (NSMutableArray *)AstNodeDeConvert((AstNode *)node->fields, patch);
    return exp;
}
void AstUnionExpressoinSerailization(AstUnionExpressoin *node, void *buffer, uint32_t *cursor){
    memcpy(buffer + *cursor, node, AstUnionExpressoinBaseLength);
    *cursor += AstUnionExpressoinBaseLength;
    AstNodeSerailization((AstNode *)node->unionName, buffer, cursor);
    AstNodeSerailization((AstNode *)node->fields, buffer, cursor);
}
AstUnionExpressoin *AstUnionExpressoinDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstUnionExpressoin *node = malloc(sizeof(AstUnionExpressoin));
    memcpy(node, buffer + *cursor, AstUnionExpressoinBaseLength);
    *cursor += AstUnionExpressoinBaseLength;
    node->unionName =(ORStringCursor *) AstNodeDeserialization(buffer, cursor, bufferLength);
    node->fields =(AstNodeList *) AstNodeDeserialization(buffer, cursor, bufferLength);
    return node;
}
void AstUnionExpressoinDestroy(AstUnionExpressoin *node){
    AstNodeDestroy((AstNode *)node->unionName);
    AstNodeDestroy((AstNode *)node->fields);
    free(node);
}
#pragma pack()
#pragma pack(show)
AstNode *AstNodeConvert(id exp, AstPatchFile *patch, uint32_t *length){
    if ([exp isKindOfClass:[NSString class]]) {
        return (AstNode *)createStringCursor((NSString *)exp, patch, length);
    }else if ([exp isKindOfClass:[NSArray class]]) {
        return (AstNode *)AstNodeListConvert((NSArray *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORCArrayVariable class]]){
        return (AstNode *)AstCArrayVariableConvert((ORCArrayVariable *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORFuncVariable class]]){
        return (AstNode *)AstFuncVariableConvert((ORFuncVariable *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORTypeSpecial class]]){
        return (AstNode *)AstTypeSpecialConvert((ORTypeSpecial *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORVariable class]]){
        return (AstNode *)AstVariableConvert((ORVariable *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORTypeVarPair class]]){
        return (AstNode *)AstTypeVarPairConvert((ORTypeVarPair *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORFuncDeclare class]]){
        return (AstNode *)AstFuncDeclareConvert((ORFuncDeclare *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORScopeImp class]]){
        return (AstNode *)AstScopeImpConvert((ORScopeImp *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORValueExpression class]]){
        return (AstNode *)AstValueExpressionConvert((ORValueExpression *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORIntegerValue class]]){
        return (AstNode *)AstIntegerValueConvert((ORIntegerValue *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORUIntegerValue class]]){
        return (AstNode *)AstUIntegerValueConvert((ORUIntegerValue *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORDoubleValue class]]){
        return (AstNode *)AstDoubleValueConvert((ORDoubleValue *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORBoolValue class]]){
        return (AstNode *)AstBoolValueConvert((ORBoolValue *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORMethodCall class]]){
        return (AstNode *)AstMethodCallConvert((ORMethodCall *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORCFuncCall class]]){
        return (AstNode *)AstCFuncCallConvert((ORCFuncCall *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORFunctionImp class]]){
        return (AstNode *)AstFunctionImpConvert((ORFunctionImp *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORSubscriptExpression class]]){
        return (AstNode *)AstSubscriptExpressionConvert((ORSubscriptExpression *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORAssignExpression class]]){
        return (AstNode *)AstAssignExpressionConvert((ORAssignExpression *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORDeclareExpression class]]){
        return (AstNode *)AstDeclareExpressionConvert((ORDeclareExpression *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORUnaryExpression class]]){
        return (AstNode *)AstUnaryExpressionConvert((ORUnaryExpression *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORBinaryExpression class]]){
        return (AstNode *)AstBinaryExpressionConvert((ORBinaryExpression *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORTernaryExpression class]]){
        return (AstNode *)AstTernaryExpressionConvert((ORTernaryExpression *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORIfStatement class]]){
        return (AstNode *)AstIfStatementConvert((ORIfStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORWhileStatement class]]){
        return (AstNode *)AstWhileStatementConvert((ORWhileStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORDoWhileStatement class]]){
        return (AstNode *)AstDoWhileStatementConvert((ORDoWhileStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORCaseStatement class]]){
        return (AstNode *)AstCaseStatementConvert((ORCaseStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORSwitchStatement class]]){
        return (AstNode *)AstSwitchStatementConvert((ORSwitchStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORForStatement class]]){
        return (AstNode *)AstForStatementConvert((ORForStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORForInStatement class]]){
        return (AstNode *)AstForInStatementConvert((ORForInStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORReturnStatement class]]){
        return (AstNode *)AstReturnStatementConvert((ORReturnStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORBreakStatement class]]){
        return (AstNode *)AstBreakStatementConvert((ORBreakStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORContinueStatement class]]){
        return (AstNode *)AstContinueStatementConvert((ORContinueStatement *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORPropertyDeclare class]]){
        return (AstNode *)AstPropertyDeclareConvert((ORPropertyDeclare *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORMethodDeclare class]]){
        return (AstNode *)AstMethodDeclareConvert((ORMethodDeclare *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORMethodImplementation class]]){
        return (AstNode *)AstMethodImplementationConvert((ORMethodImplementation *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORClass class]]){
        return (AstNode *)AstClassConvert((ORClass *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORProtocol class]]){
        return (AstNode *)AstProtocolConvert((ORProtocol *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORStructExpressoin class]]){
        return (AstNode *)AstStructExpressoinConvert((ORStructExpressoin *)exp, patch, length);
    }else if ([exp isKindOfClass:[OREnumExpressoin class]]){
        return (AstNode *)AstEnumExpressoinConvert((OREnumExpressoin *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORTypedefExpressoin class]]){
        return (AstNode *)AstTypedefExpressoinConvert((ORTypedefExpressoin *)exp, patch, length);
    }else if ([exp isKindOfClass:[ORUnionExpressoin class]]){
        return (AstNode *)AstUnionExpressoinConvert((ORUnionExpressoin *)exp, patch, length);
    }
    AstNode *node = malloc(sizeof(AstNode));
    memset(node, 0, sizeof(AstNode));
    *length += 2;
    return node;
}
id AstNodeDeConvert(AstNode *node, AstPatchFile *patch){
    switch(node->nodeType){
        case AstEnumEmptyNode:
            return nil;
        case AstEnumListNode:
            return AstNodeListDeConvert((AstNodeList *)node, patch);
        case AstEnumStringCursorNode:
            return getNSStringWithStringCursor((ORStringCursor *) node, patch);
        case AstEnumTypeSpecial:
            return (ORNode *)AstTypeSpecialDeConvert((AstTypeSpecial *)node, patch);
        case AstEnumVariable:
            return (ORNode *)AstVariableDeConvert((AstVariable *)node, patch);
        case AstEnumTypeVarPair:
            return (ORNode *)AstTypeVarPairDeConvert((AstTypeVarPair *)node, patch);
        case AstEnumFuncVariable:
            return (ORNode *)AstFuncVariableDeConvert((AstFuncVariable *)node, patch);
        case AstEnumFuncDeclare:
            return (ORNode *)AstFuncDeclareDeConvert((AstFuncDeclare *)node, patch);
        case AstEnumScopeImp:
            return (ORNode *)AstScopeImpDeConvert((AstScopeImp *)node, patch);
        case AstEnumValueExpression:
            return (ORNode *)AstValueExpressionDeConvert((AstValueExpression *)node, patch);
        case AstEnumIntegerValue:
            return (ORNode *)AstIntegerValueDeConvert((AstIntegerValue *)node, patch);
        case AstEnumUIntegerValue:
            return (ORNode *)AstUIntegerValueDeConvert((AstUIntegerValue *)node, patch);
        case AstEnumDoubleValue:
            return (ORNode *)AstDoubleValueDeConvert((AstDoubleValue *)node, patch);
        case AstEnumBoolValue:
            return (ORNode *)AstBoolValueDeConvert((AstBoolValue *)node, patch);
        case AstEnumMethodCall:
            return (ORNode *)AstMethodCallDeConvert((AstMethodCall *)node, patch);
        case AstEnumCFuncCall:
            return (ORNode *)AstCFuncCallDeConvert((AstCFuncCall *)node, patch);
        case AstEnumFunctionImp:
            return (ORNode *)AstFunctionImpDeConvert((AstFunctionImp *)node, patch);
        case AstEnumSubscriptExpression:
            return (ORNode *)AstSubscriptExpressionDeConvert((AstSubscriptExpression *)node, patch);
        case AstEnumAssignExpression:
            return (ORNode *)AstAssignExpressionDeConvert((AstAssignExpression *)node, patch);
        case AstEnumDeclareExpression:
            return (ORNode *)AstDeclareExpressionDeConvert((AstDeclareExpression *)node, patch);
        case AstEnumUnaryExpression:
            return (ORNode *)AstUnaryExpressionDeConvert((AstUnaryExpression *)node, patch);
        case AstEnumBinaryExpression:
            return (ORNode *)AstBinaryExpressionDeConvert((AstBinaryExpression *)node, patch);
        case AstEnumTernaryExpression:
            return (ORNode *)AstTernaryExpressionDeConvert((AstTernaryExpression *)node, patch);
        case AstEnumIfStatement:
            return (ORNode *)AstIfStatementDeConvert((AstIfStatement *)node, patch);
        case AstEnumWhileStatement:
            return (ORNode *)AstWhileStatementDeConvert((AstWhileStatement *)node, patch);
        case AstEnumDoWhileStatement:
            return (ORNode *)AstDoWhileStatementDeConvert((AstDoWhileStatement *)node, patch);
        case AstEnumCaseStatement:
            return (ORNode *)AstCaseStatementDeConvert((AstCaseStatement *)node, patch);
        case AstEnumSwitchStatement:
            return (ORNode *)AstSwitchStatementDeConvert((AstSwitchStatement *)node, patch);
        case AstEnumForStatement:
            return (ORNode *)AstForStatementDeConvert((AstForStatement *)node, patch);
        case AstEnumForInStatement:
            return (ORNode *)AstForInStatementDeConvert((AstForInStatement *)node, patch);
        case AstEnumReturnStatement:
            return (ORNode *)AstReturnStatementDeConvert((AstReturnStatement *)node, patch);
        case AstEnumBreakStatement:
            return (ORNode *)AstBreakStatementDeConvert((AstBreakStatement *)node, patch);
        case AstEnumContinueStatement:
            return (ORNode *)AstContinueStatementDeConvert((AstContinueStatement *)node, patch);
        case AstEnumPropertyDeclare:
            return (ORNode *)AstPropertyDeclareDeConvert((AstPropertyDeclare *)node, patch);
        case AstEnumMethodDeclare:
            return (ORNode *)AstMethodDeclareDeConvert((AstMethodDeclare *)node, patch);
        case AstEnumMethodImplementation:
            return (ORNode *)AstMethodImplementationDeConvert((AstMethodImplementation *)node, patch);
        case AstEnumClass:
            return (ORNode *)AstClassDeConvert((AstClass *)node, patch);
        case AstEnumProtocol:
            return (ORNode *)AstProtocolDeConvert((AstProtocol *)node, patch);
        case AstEnumStructExpressoin:
            return (ORNode *)AstStructExpressoinDeConvert((AstStructExpressoin *)node, patch);
        case AstEnumEnumExpressoin:
            return (ORNode *)AstEnumExpressoinDeConvert((AstEnumExpressoin *)node, patch);
        case AstEnumTypedefExpressoin:
            return (ORNode *)AstTypedefExpressoinDeConvert((AstTypedefExpressoin *)node, patch);
        case AstEnumCArrayVariable:
            return (ORNode *)AstCArrayVariableDeConvert((AstCArrayVariable *)node, patch);
        case AstEnumUnionExpressoin:
            return (ORNode *)AstUnionExpressoinDeConvert((AstUnionExpressoin *)node, patch);

        default: return [ORNode new];
    }
    return [ORNode new];
}
void AstNodeSerailization(AstNode *node, void *buffer, uint32_t *cursor){
    switch(node->nodeType){
        case AstEnumEmptyNode: {
            memcpy(buffer + *cursor, node, 2);
            *cursor += 2;
            break;
        }
        case AstEnumListNode:
            AstNodeListSerailization((AstNodeList *)node, buffer, cursor); break;
        case AstEnumStringCursorNode:
            ORStringCursorSerailization((ORStringCursor *) node, buffer, cursor); break;
        case AstEnumStringBufferNode:
            ORStringBufferNodeSerailization((ORStringBufferNode *) node, buffer, cursor);break;
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
AstNode *AstNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    AstEnum nodeType = AstEnumEmptyNode;
    if (*cursor < bufferLength) {
        nodeType = *(AstEnum *)(buffer + *cursor);
    }
    switch(nodeType){
        case AstEnumListNode:
            return (AstNode *)AstNodeListDeserialization(buffer, cursor, bufferLength);
        case AstEnumStringCursorNode:
            return (AstNode *)ORStringCursorDeserialization(buffer, cursor, bufferLength);
        case AstEnumTypeSpecial:
            return (AstNode *)AstTypeSpecialDeserialization(buffer, cursor, bufferLength);
        case AstEnumVariable:
            return (AstNode *)AstVariableDeserialization(buffer, cursor, bufferLength);
        case AstEnumTypeVarPair:
            return (AstNode *)AstTypeVarPairDeserialization(buffer, cursor, bufferLength);
        case AstEnumFuncVariable:
            return (AstNode *)AstFuncVariableDeserialization(buffer, cursor, bufferLength);
        case AstEnumFuncDeclare:
            return (AstNode *)AstFuncDeclareDeserialization(buffer, cursor, bufferLength);
        case AstEnumScopeImp:
            return (AstNode *)AstScopeImpDeserialization(buffer, cursor, bufferLength);
        case AstEnumValueExpression:
            return (AstNode *)AstValueExpressionDeserialization(buffer, cursor, bufferLength);
        case AstEnumIntegerValue:
            return (AstNode *)AstIntegerValueDeserialization(buffer, cursor, bufferLength);
        case AstEnumUIntegerValue:
            return (AstNode *)AstUIntegerValueDeserialization(buffer, cursor, bufferLength);
        case AstEnumDoubleValue:
            return (AstNode *)AstDoubleValueDeserialization(buffer, cursor, bufferLength);
        case AstEnumBoolValue:
            return (AstNode *)AstBoolValueDeserialization(buffer, cursor, bufferLength);
        case AstEnumMethodCall:
            return (AstNode *)AstMethodCallDeserialization(buffer, cursor, bufferLength);
        case AstEnumCFuncCall:
            return (AstNode *)AstCFuncCallDeserialization(buffer, cursor, bufferLength);
        case AstEnumFunctionImp:
            return (AstNode *)AstFunctionImpDeserialization(buffer, cursor, bufferLength);
        case AstEnumSubscriptExpression:
            return (AstNode *)AstSubscriptExpressionDeserialization(buffer, cursor, bufferLength);
        case AstEnumAssignExpression:
            return (AstNode *)AstAssignExpressionDeserialization(buffer, cursor, bufferLength);
        case AstEnumDeclareExpression:
            return (AstNode *)AstDeclareExpressionDeserialization(buffer, cursor, bufferLength);
        case AstEnumUnaryExpression:
            return (AstNode *)AstUnaryExpressionDeserialization(buffer, cursor, bufferLength);
        case AstEnumBinaryExpression:
            return (AstNode *)AstBinaryExpressionDeserialization(buffer, cursor, bufferLength);
        case AstEnumTernaryExpression:
            return (AstNode *)AstTernaryExpressionDeserialization(buffer, cursor, bufferLength);
        case AstEnumIfStatement:
            return (AstNode *)AstIfStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumWhileStatement:
            return (AstNode *)AstWhileStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumDoWhileStatement:
            return (AstNode *)AstDoWhileStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumCaseStatement:
            return (AstNode *)AstCaseStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumSwitchStatement:
            return (AstNode *)AstSwitchStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumForStatement:
            return (AstNode *)AstForStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumForInStatement:
            return (AstNode *)AstForInStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumReturnStatement:
            return (AstNode *)AstReturnStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumBreakStatement:
            return (AstNode *)AstBreakStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumContinueStatement:
            return (AstNode *)AstContinueStatementDeserialization(buffer, cursor, bufferLength);
        case AstEnumPropertyDeclare:
            return (AstNode *)AstPropertyDeclareDeserialization(buffer, cursor, bufferLength);
        case AstEnumMethodDeclare:
            return (AstNode *)AstMethodDeclareDeserialization(buffer, cursor, bufferLength);
        case AstEnumMethodImplementation:
            return (AstNode *)AstMethodImplementationDeserialization(buffer, cursor, bufferLength);
        case AstEnumClass:
            return (AstNode *)AstClassDeserialization(buffer, cursor, bufferLength);
        case AstEnumProtocol:
            return (AstNode *)AstProtocolDeserialization(buffer, cursor, bufferLength);
        case AstEnumStructExpressoin:
            return (AstNode *)AstStructExpressoinDeserialization(buffer, cursor, bufferLength);
        case AstEnumEnumExpressoin:
            return (AstNode *)AstEnumExpressoinDeserialization(buffer, cursor, bufferLength);
        case AstEnumTypedefExpressoin:
            return (AstNode *)AstTypedefExpressoinDeserialization(buffer, cursor, bufferLength);
        case AstEnumCArrayVariable:
            return (AstNode *)AstCArrayVariableDeserialization(buffer, cursor, bufferLength);
        case AstEnumUnionExpressoin:
            return (AstNode *)AstUnionExpressoinDeserialization(buffer, cursor, bufferLength);

        default:{
            AstNode *node = malloc(sizeof(AstNode));
            memset(node, 0, sizeof(AstNode));
            *cursor += 2;
            return node;
        }
    }
}
void AstNodeDestroy(AstNode *node){
    if(node == NULL) return;
    switch(node->nodeType){
        case AstEnumEmptyNode:
            free(node); break;
        case AstEnumListNode:
            AstNodeListDestroy((AstNodeList *)node); break;
        case AstEnumStringCursorNode:
            ORStringCursorDestroy((ORStringCursor *) node); break;
        case AstEnumStringBufferNode:
            ORStringBufferNodeDestroy((ORStringBufferNode *) node); break;
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
