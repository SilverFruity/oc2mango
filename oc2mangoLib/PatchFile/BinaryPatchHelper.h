//  BinaryPatchHelper.h
//  Generate By BinaryPatchGenerator
//  Created by Jiang on 1624888141
//  Copyright © 2020 SilverFruity. All rights reserved.

#import <Foundation/Foundation.h>
@class ORPatchFile;

typedef enum: uint8_t{
    AstEnumEmptyNode = 0,
    AstEnumPatchFile = 1,
    AstEnumStringCursorNode = 2,
    AstEnumStringBufferNode = 3,
    AstEnumListNode = 4,
    AstEnumTypeNode = 5,
    AstEnumVariableNode = 6,
    AstEnumDeclaratorNode = 7,
    AstEnumFunctionDeclNode = 8,
    AstEnumCArrayDeclNode = 9,
    AstEnumBlockNode = 10,
    AstEnumValueNode = 11,
    AstEnumIntegerValue = 12,
    AstEnumUIntegerValue = 13,
    AstEnumDoubleValue = 14,
    AstEnumBoolValue = 15,
    AstEnumMethodCall = 16,
    AstEnumFunctionCall = 17,
    AstEnumFunctionNode = 18,
    AstEnumSubscriptNode = 19,
    AstEnumAssignNode = 20,
    AstEnumInitDeclaratorNode = 21,
    AstEnumUnaryNode = 22,
    AstEnumBinaryNode = 23,
    AstEnumTernaryNode = 24,
    AstEnumIfStatement = 25,
    AstEnumWhileStatement = 26,
    AstEnumDoWhileStatement = 27,
    AstEnumCaseStatement = 28,
    AstEnumSwitchStatement = 29,
    AstEnumForStatement = 30,
    AstEnumForInStatement = 31,
    AstEnumControlStatNode = 32,
    AstEnumPropertyNode = 33,
    AstEnumMethodDeclNode = 34,
    AstEnumMethodNode = 35,
    AstEnumClassNode = 36,
    AstEnumProtocolNode = 37,
    AstEnumStructStatNode = 38,
    AstEnumUnionStatNode = 39,
    AstEnumEnumStatNode = 40,
    AstEnumTypedefStatNode = 41,
}AstEnum;


#define AstNodeFields \
uint8_t nodeType;\

#pragma pack(1)
#pragma pack(show)
typedef struct {
    AstNodeFields
}AstEmptyNode;

static uint32_t AstEmptyNodeLength = 1;

typedef struct {
    AstNodeFields
    uint32_t count;
    AstEmptyNode **nodes;
}AstNodeList;
static uint32_t AstNodeListBaseLength = 5;

typedef struct {
    AstNodeFields
    uint32_t offset;
    uint32_t strLen;
}AstStringCursor;
static uint32_t AstStringCursorBaseLength = 9;

typedef struct {
    AstNodeFields
    uint32_t cursor;
    char *buffer;
}AstStringBufferNode;
static uint32_t AstStringBufferNodeBaseLength = 5;

typedef struct {
    AstNodeFields
    BOOL enable;
    AstStringBufferNode *strings;
    AstStringCursor *appVersion;
    AstStringCursor *osVersion;
    AstNodeList *nodes;
}AstPatchFile;
static uint32_t AstPatchFileBaseLength = 2;

#pragma pack()
#pragma pack(show)

AstPatchFile *AstPatchFileConvert(ORPatchFile *patch, uint32_t *length);
ORPatchFile *AstPatchFileDeConvert(AstPatchFile *node);
void AstPatchFileSerialization(AstPatchFile *node, void *buffer, uint32_t *cursor);
AstPatchFile *AstPatchFileDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength);
void AstPatchFileDestroy(AstPatchFile *node);
ORPatchFile *AstPatchFileGenerateCheckFile(void *buffer, uint32_t bufferLength);
#pragma pack(1)

typedef struct {
    AstNodeFields
    uint32_t type;
    uint32_t modifier;
    AstStringCursor * name;
}AstTypeNode;

typedef struct {
    AstNodeFields
    BOOL isBlock;
    uint8_t ptCount;
    AstStringCursor * varname;
}AstVariableNode;

typedef struct {
    AstNodeFields
    AstEmptyNode * type;
    AstEmptyNode * var;
}AstDeclaratorNode;

typedef struct {
    AstNodeFields
    BOOL isMultiArgs;
    AstEmptyNode * type;
    AstEmptyNode * var;
    AstNodeList * params;
}AstFunctionDeclNode;

typedef struct {
    AstNodeFields
    AstEmptyNode * type;
    AstEmptyNode * var;
    AstEmptyNode * prev;
    AstEmptyNode * capacity;
}AstCArrayDeclNode;

typedef struct {
    AstNodeFields
    AstNodeList * statements;
}AstBlockNode;

typedef struct {
    AstNodeFields
    uint32_t value_type;
    AstEmptyNode * value;
}AstValueNode;

typedef struct {
    AstNodeFields
    int64_t value;
}AstIntegerValue;

typedef struct {
    AstNodeFields
    uint64_t value;
}AstUIntegerValue;

typedef struct {
    AstNodeFields
    double value;
}AstDoubleValue;

typedef struct {
    AstNodeFields
    BOOL value;
}AstBoolValue;

typedef struct {
    AstNodeFields
    uint8_t methodOperator;
    BOOL isAssignedValue;
    AstEmptyNode * caller;
    AstNodeList * names;
    AstNodeList * values;
}AstMethodCall;

typedef struct {
    AstNodeFields
    AstEmptyNode * caller;
    AstNodeList * expressions;
}AstFunctionCall;

typedef struct {
    AstNodeFields
    AstEmptyNode * declare;
    AstEmptyNode * scopeImp;
}AstFunctionNode;

typedef struct {
    AstNodeFields
    AstEmptyNode * caller;
    AstEmptyNode * keyExp;
}AstSubscriptNode;

typedef struct {
    AstNodeFields
    uint32_t assignType;
    AstEmptyNode * value;
    AstEmptyNode * expression;
}AstAssignNode;

typedef struct {
    AstNodeFields
    AstEmptyNode * declarator;
    AstEmptyNode * expression;
}AstInitDeclaratorNode;

typedef struct {
    AstNodeFields
    uint32_t operatorType;
    AstEmptyNode * value;
}AstUnaryNode;

typedef struct {
    AstNodeFields
    uint32_t operatorType;
    AstEmptyNode * left;
    AstEmptyNode * right;
}AstBinaryNode;

typedef struct {
    AstNodeFields
    AstEmptyNode * expression;
    AstNodeList * values;
}AstTernaryNode;

typedef struct {
    AstNodeFields
    AstEmptyNode * condition;
    AstEmptyNode * last;
    AstEmptyNode * scopeImp;
}AstIfStatement;

typedef struct {
    AstNodeFields
    AstEmptyNode * condition;
    AstEmptyNode * scopeImp;
}AstWhileStatement;

typedef struct {
    AstNodeFields
    AstEmptyNode * condition;
    AstEmptyNode * scopeImp;
}AstDoWhileStatement;

typedef struct {
    AstNodeFields
    AstEmptyNode * value;
    AstEmptyNode * scopeImp;
}AstCaseStatement;

typedef struct {
    AstNodeFields
    AstEmptyNode * value;
    AstNodeList * cases;
}AstSwitchStatement;

typedef struct {
    AstNodeFields
    AstNodeList * varExpressions;
    AstEmptyNode * condition;
    AstNodeList * expressions;
    AstEmptyNode * scopeImp;
}AstForStatement;

typedef struct {
    AstNodeFields
    AstEmptyNode * expression;
    AstEmptyNode * value;
    AstEmptyNode * scopeImp;
}AstForInStatement;

typedef struct {
    AstNodeFields
    uint64_t type;
    AstEmptyNode * expression;
}AstControlStatNode;

typedef struct {
    AstNodeFields
    AstNodeList * keywords;
    AstEmptyNode * var;
}AstPropertyNode;

typedef struct {
    AstNodeFields
    BOOL isClassMethod;
    AstEmptyNode * returnType;
    AstNodeList * methodNames;
    AstNodeList * parameters;
}AstMethodDeclNode;

typedef struct {
    AstNodeFields
    AstEmptyNode * declare;
    AstEmptyNode * scopeImp;
}AstMethodNode;

typedef struct {
    AstNodeFields
    AstStringCursor * className;
    AstStringCursor * superClassName;
    AstNodeList * protocols;
    AstNodeList * properties;
    AstNodeList * privateVariables;
    AstNodeList * methods;
}AstClassNode;

typedef struct {
    AstNodeFields
    AstStringCursor * protcolName;
    AstNodeList * protocols;
    AstNodeList * properties;
    AstNodeList * methods;
}AstProtocolNode;

typedef struct {
    AstNodeFields
    AstStringCursor * sturctName;
    AstNodeList * fields;
}AstStructStatNode;

typedef struct {
    AstNodeFields
    AstStringCursor * unionName;
    AstNodeList * fields;
}AstUnionStatNode;

typedef struct {
    AstNodeFields
    uint32_t valueType;
    AstStringCursor * enumName;
    AstNodeList * fields;
}AstEnumStatNode;

typedef struct {
    AstNodeFields
    AstEmptyNode * expression;
    AstStringCursor * typeNewName;
}AstTypedefStatNode;

#pragma pack()
#pragma pack(show)
