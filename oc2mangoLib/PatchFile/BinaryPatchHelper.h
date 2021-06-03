//  BinaryPatchHelper.h
//  Generate By BinaryPatchGenerator
//  Created by Jiang on 1622714604
//  Copyright © 2020 SilverFruity. All rights reserved.

#import <Foundation/Foundation.h>
@class ORPatchFile;

typedef enum: uint8_t{
    AstEnumEmptyNode = 0,
    AstEnumPatchFile = 1,
    AstEnumStringCursorNode = 2,
    AstEnumStringBufferNode = 3,
    AstEnumListNode = 4,
    AstEnumTypeSpecial = 7,
    AstEnumVariable = 8,
    AstEnumTypeVarPair = 9,
    AstEnumFuncVariable = 10,
    AstEnumFuncDeclare = 11,
    AstEnumScopeImp = 12,
    AstEnumValueExpression = 14,
    AstEnumIntegerValue = 15,
    AstEnumUIntegerValue = 16,
    AstEnumDoubleValue = 17,
    AstEnumBoolValue = 18,
    AstEnumMethodCall = 20,
    AstEnumCFuncCall = 21,
    AstEnumFunctionImp = 22,
    AstEnumSubscriptExpression = 23,
    AstEnumAssignExpression = 25,
    AstEnumDeclareExpression = 27,
    AstEnumUnaryExpression = 29,
    AstEnumBinaryExpression = 31,
    AstEnumTernaryExpression = 32,
    AstEnumIfStatement = 33,
    AstEnumWhileStatement = 34,
    AstEnumDoWhileStatement = 35,
    AstEnumCaseStatement = 36,
    AstEnumSwitchStatement = 37,
    AstEnumForStatement = 38,
    AstEnumForInStatement = 39,
    AstEnumReturnStatement = 40,
    AstEnumBreakStatement = 41,
    AstEnumContinueStatement = 42,
    AstEnumPropertyDeclare = 44,
    AstEnumMethodDeclare = 45,
    AstEnumMethodImplementation = 46,
    AstEnumClass = 47,
    AstEnumProtocol = 48,
    AstEnumStructExpressoin = 49,
    AstEnumEnumExpressoin = 50,
    AstEnumTypedefExpressoin = 51,
    AstEnumCArrayVariable = 52,
    AstEnumUnionExpressoin = 53,
}AstEnum;


#define AstNodeFields \
uint8_t nodeType;\
uint8_t withSemicolon;\

#pragma pack(1)
#pragma pack(show)
typedef struct {
    AstNodeFields
}AstNode;

static uint32_t AstNodeLength = 2;

typedef struct {
    AstNodeFields
    uint32_t count;
    AstNode **nodes;
}AstNodeList;
static uint32_t AstNodeListBaseLength = 6;

typedef struct {
    AstNodeFields
    uint32_t offset;
    uint32_t strLen;
}ORStringCursor;
static uint32_t ORStringCursorBaseLength = 10;

typedef struct {
    AstNodeFields
    uint32_t cursor;
    char *buffer;
}ORStringBufferNode;
static uint32_t ORStringBufferNodeBaseLength = 6;

typedef struct {
    AstNodeFields
    BOOL enable;
    ORStringBufferNode *strings;
    ORStringCursor *appVersion;
    ORStringCursor *osVersion;
    AstNodeList *nodes;
}AstPatchFile;
static uint32_t AstPatchFileBaseLength = 3;

#pragma pack()
#pragma pack(show)

AstPatchFile *AstPatchFileConvert(ORPatchFile *patch, uint32_t *length);
ORPatchFile *AstPatchFileDeConvert(AstPatchFile *node);
void AstPatchFileSerialization(AstPatchFile *node, void *buffer, uint32_t *cursor);
AstPatchFile *AstPatchFileDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength);
void AstPatchFileDestroy(AstPatchFile *node);
ORPatchFile *AstPatchFileGenerateCheckFile(void *buffer, uint32_t bufferLength);