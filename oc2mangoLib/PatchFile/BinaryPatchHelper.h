//  BinaryPatchHelper.h
//  Generate By BinaryPatchGenerator
//  Created by Jiang on 1686668443
//  Copyright © 2020 SilverFruity. All rights reserved.

#import <Foundation/Foundation.h>
@class ORPatchFile;

typedef enum: uint8_t{
    AstEnumEmptyNode = 0,
    AstEnumPatchFile = 1,
    AstEnumStringCursorNode = 2,
    AstEnumStringBufferNode = 3,
    AstEnumListNode = 4,
    AstEnumTypeSpecial = 5,
    AstEnumVariable = 6,
    AstEnumTypeVarPair = 7,
    AstEnumFuncVariable = 8,
    AstEnumFuncDeclare = 9,
    AstEnumScopeImp = 10,
    AstEnumValueExpression = 11,
    AstEnumIntegerValue = 12,
    AstEnumUIntegerValue = 13,
    AstEnumDoubleValue = 14,
    AstEnumBoolValue = 15,
    AstEnumMethodCall = 16,
    AstEnumCFuncCall = 17,
    AstEnumFunctionImp = 18,
    AstEnumSubscriptExpression = 19,
    AstEnumAssignExpression = 20,
    AstEnumDeclareExpression = 21,
    AstEnumUnaryExpression = 22,
    AstEnumBinaryExpression = 23,
    AstEnumTernaryExpression = 24,
    AstEnumIfStatement = 25,
    AstEnumWhileStatement = 26,
    AstEnumDoWhileStatement = 27,
    AstEnumCaseStatement = 28,
    AstEnumSwitchStatement = 29,
    AstEnumForStatement = 30,
    AstEnumForInStatement = 31,
    AstEnumReturnStatement = 32,
    AstEnumBreakStatement = 33,
    AstEnumContinueStatement = 34,
    AstEnumPropertyDeclare = 35,
    AstEnumMethodDeclare = 36,
    AstEnumMethodImplementation = 37,
    AstEnumClass = 38,
    AstEnumProtocol = 39,
    AstEnumStructExpressoin = 40,
    AstEnumEnumExpressoin = 41,
    AstEnumTypedefExpressoin = 42,
    AstEnumCArrayVariable = 43,
    AstEnumUnionExpressoin = 44,
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
void AstNodeListTagged(id parentNode, NSArray *nodes);
#pragma pack(1)

typedef struct {
    AstNodeFields
    uint32_t type;
    AstStringCursor * name;
}AstTypeSpecial;

typedef struct {
    AstNodeFields
    BOOL isBlock;
    uint8_t ptCount;
    AstStringCursor * varname;
}AstVariable;

typedef struct {
    AstNodeFields
    AstEmptyNode * type;
    AstEmptyNode * var;
}AstTypeVarPair;

typedef struct {
    AstNodeFields
    BOOL isBlock;
    uint8_t ptCount;
    BOOL isMultiArgs;
    AstStringCursor * varname;
    AstNodeList * pairs;
}AstFuncVariable;

typedef struct {
    AstNodeFields
    AstEmptyNode * returnType;
    AstEmptyNode * funVar;
}AstFuncDeclare;

typedef struct {
    AstNodeFields
    AstNodeList * statements;
}AstScopeImp;

typedef struct {
    AstNodeFields
    uint32_t value_type;
    AstEmptyNode * value;
}AstValueExpression;

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
}AstCFuncCall;

typedef struct {
    AstNodeFields
    AstEmptyNode * declare;
    AstEmptyNode * scopeImp;
}AstFunctionImp;

typedef struct {
    AstNodeFields
    AstEmptyNode * caller;
    AstEmptyNode * keyExp;
}AstSubscriptExpression;

typedef struct {
    AstNodeFields
    uint32_t assignType;
    AstEmptyNode * value;
    AstEmptyNode * expression;
}AstAssignExpression;

typedef struct {
    AstNodeFields
    uint32_t modifier;
    AstEmptyNode * pair;
    AstEmptyNode * expression;
}AstDeclareExpression;

typedef struct {
    AstNodeFields
    uint32_t operatorType;
    AstEmptyNode * value;
}AstUnaryExpression;

typedef struct {
    AstNodeFields
    uint32_t operatorType;
    AstEmptyNode * left;
    AstEmptyNode * right;
}AstBinaryExpression;

typedef struct {
    AstNodeFields
    AstEmptyNode * expression;
    AstNodeList * values;
}AstTernaryExpression;

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
    AstEmptyNode * scopeImp;
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
    AstEmptyNode * expression;
}AstReturnStatement;

typedef struct {
    AstNodeFields
    
}AstBreakStatement;

typedef struct {
    AstNodeFields
    
}AstContinueStatement;

typedef struct {
    AstNodeFields
    AstNodeList * keywords;
    AstEmptyNode * var;
}AstPropertyDeclare;

typedef struct {
    AstNodeFields
    BOOL isClassMethod;
    AstEmptyNode * returnType;
    AstNodeList * methodNames;
    AstNodeList * parameterTypes;
    AstNodeList * parameterNames;
}AstMethodDeclare;

typedef struct {
    AstNodeFields
    AstEmptyNode * declare;
    AstEmptyNode * scopeImp;
}AstMethodImplementation;

typedef struct {
    AstNodeFields
    AstStringCursor * className;
    AstStringCursor * superClassName;
    AstNodeList * protocols;
    AstNodeList * properties;
    AstNodeList * privateVariables;
    AstNodeList * methods;
}AstClass;

typedef struct {
    AstNodeFields
    AstStringCursor * protcolName;
    AstNodeList * protocols;
    AstNodeList * properties;
    AstNodeList * methods;
}AstProtocol;

typedef struct {
    AstNodeFields
    AstStringCursor * sturctName;
    AstNodeList * fields;
}AstStructExpressoin;

typedef struct {
    AstNodeFields
    uint32_t valueType;
    AstStringCursor * enumName;
    AstNodeList * fields;
}AstEnumExpressoin;

typedef struct {
    AstNodeFields
    AstEmptyNode * expression;
    AstStringCursor * typeNewName;
}AstTypedefExpressoin;

typedef struct {
    AstNodeFields
    BOOL isBlock;
    uint8_t ptCount;
    AstStringCursor * varname;
    AstEmptyNode * prev;
    AstEmptyNode * capacity;
}AstCArrayVariable;

typedef struct {
    AstNodeFields
    AstStringCursor * unionName;
    AstNodeList * fields;
}AstUnionExpressoin;

#pragma pack()
#pragma pack(show)
