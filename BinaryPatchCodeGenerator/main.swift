//
//  main.swift
//  BinaryPatchGenerator
//
//  Created by Jiang on 2020/8/28.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

import Foundation
let filepath = CommandLine.arguments[1]
let resultDir = CommandLine.arguments[2]

let parser = Parser()
let source = CodeSource.init(filePath: filepath)
let ast = parser.parseCodeSource(source)

let NodeDefine = "AstNodeFields"
let PatchFileClass = "ORPatchFile"
let resultFileName = "BinaryPatchHelper"

let forUnitTest = true
let withSemicolon =  forUnitTest ? "\nuint8_t withSemicolon;\\" : ""
let setNodeTypeWhileDeconvert = "\n    exp.nodeType = node->nodeType;"
let withSemicolonConvertExp =  forUnitTest ? "\n    node->withSemicolon = exp.withSemicolon;" : ""
var withSemicolonDeconvertExp =  forUnitTest ? "\n    exp.withSemicolon = node->withSemicolon;" : ""
withSemicolonDeconvertExp += setNodeTypeWhileDeconvert

let withSemicolonLength = forUnitTest ? 1 : 0

let AstEmptyNodeLength = 1 + withSemicolonLength
let _byteType = "uint8_t"
let _byteLength = 1
let _uintType = "uint32_t"
let _uintLength = 4
let _uint64Type = "uint64_t"
let _uint64Length = 8
let _int64Type = "int64_t"
let _int64Length = 8
let _doubleType = "double"
let _doubleLength = 8
let EnumValueType = "uint8_t"

var enumVarDecls = [String]()
for (i, node) in ast.nodes.enumerated(){
    guard let classNode = node as? ORClass else {
        continue
    }
    if classNode.className == "ORNode" {
        continue
    }
    let generator = ClassCodeGenerator.init(className: classNode.className, superClassName: classNode.superClassName)
    enumVarDecls.append("    \(generator.enumName) = \(i + 5),")
}
let AstEnums =
"""
typedef enum: \(EnumValueType){
    AstEnumEmptyNode = 0,
    AstEnumPatchFile = 1,
    AstEnumStringCursorNode = 2,
    AstEnumStringBufferNode = 3,
    AstEnumListNode = 4,
\(enumVarDecls.joined(separator: "\n"))
}AstEnum;\n
"""

//TODO: Header
var headerSource =
"""
//  \(resultFileName).h
//  Generate By BinaryPatchGenerator
//  Created by Jiang on \(Int(Date.init().timeIntervalSince1970))
//  Copyright © 2020 SilverFruity. All rights reserved.

#import <Foundation/Foundation.h>
@class \(PatchFileClass);

\(AstEnums)

#define \(NodeDefine) \\
\(EnumValueType) nodeType;\\\(withSemicolon)

#pragma pack(1)
#pragma pack(show)
typedef struct {
    \(NodeDefine)
}AstNode;

static \(_uintType) AstNodeLength = \(AstEmptyNodeLength);

typedef struct {
    \(NodeDefine)
    \(_uintType) count;
    AstNode **nodes;
}AstNodeList;
static uint32_t AstNodeListBaseLength = \(AstEmptyNodeLength + _uintLength);

typedef struct {
    \(NodeDefine)
    \(_uintType) offset;
    \(_uintType) strLen;
}ORStringCursor;
static \(_uintType) ORStringCursorBaseLength = \(AstEmptyNodeLength + _uintLength * 2);

typedef struct {
    \(NodeDefine)
    \(_uintType) cursor;
    char *buffer;
}ORStringBufferNode;
static \(_uintType) ORStringBufferNodeBaseLength = \(AstEmptyNodeLength + _uintLength);

typedef struct {
    \(NodeDefine)
    BOOL enable;
    ORStringBufferNode *strings;
    ORStringCursor *appVersion;
    ORStringCursor *osVersion;
    AstNodeList *nodes;
}AstPatchFile;
static \(_uintType) AstPatchFileBaseLength = \(AstEmptyNodeLength + 1);

#pragma pack()
#pragma pack(show)

AstPatchFile *AstPatchFileConvert(\(PatchFileClass) *patch, uint32_t *length);
\(PatchFileClass) *AstPatchFileDeConvert(AstPatchFile *node);
void AstPatchFileSerialization(AstPatchFile *node, void *buffer, uint32_t *cursor);
AstPatchFile *AstPatchFileDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength);
void AstPatchFileDestroy(AstPatchFile *node);
ORPatchFile *AstPatchFileGenerateCheckFile(void *buffer, uint32_t bufferLength);
"""

var impSource = """
//  \(resultFileName).m
//  Generate By BinaryPatchGenerator
//  Created by Jiang on \(Int(Date.init().timeIntervalSince1970))
//  Copyright © 2020 SilverFruity. All rights reserved.
#import "\(resultFileName).h"
#import "\(PatchFileClass).h"
"""

impSource +=
"""
#pragma pack(1)
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
        \(_uintType) offset = [_stringMap[string] unsignedIntValue];
        strNode->offset = offset;
        return strNode;
    }
    
    NSUInteger needLength = len + patch->strings->cursor;
    if (patch->strings->buffer == NULL) {
        patch->strings->buffer = malloc(needLength + 1);
        //FIX: strlen() heap overflow
        patch->strings->buffer[needLength] = '\\0';
    }else if (needLength > strlen(patch->strings->buffer)){
        NSUInteger bufferLength = strlen(patch->strings->buffer);
        NSUInteger addLength = 1000;
        NSUInteger newLength = addLength + bufferLength;
        patch->strings->buffer = realloc(patch->strings->buffer, newLength);
        // placeholder
        memset(patch->strings->buffer + bufferLength, 1, addLength);
        patch->strings->buffer[newLength - 1] = '\\0';
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
    buffer[node->strLen] = '\\0';
    return [NSString stringWithUTF8String:buffer];
}

AstPatchFile *AstPatchFileConvert(\(PatchFileClass) *patch, uint32_t *length){
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

\(PatchFileClass) *AstPatchFileDeConvert(AstPatchFile *patch){
    \(PatchFileClass) *file = [\(PatchFileClass) new];
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

"""

for node in ast.nodes{
    guard let classNode = node as? ORClass, classNode.className != "ORNode" else {
        continue
    }
    let item = ClassCodeGenerator(className: classNode.className, superClassName:classNode.superClassName)
    let properties = classNode.properties as! [ORPropertyDeclare]
    for prop in properties{
        if prop.keywords.contains("readonly"){
            continue
        }
        let varname = prop.var.var.varname ?? ""
        if let typename = prop.var.type.name{
            if typename == "NSMutableArray" {
                item.addStructNodeField(type: "AstNodeList *", varname: varname)
                item.addNodeConvertExp(varname: varname, nodeName: "AstNodeList")
                item.addNodeDeconvertExp(varname: varname, className: "NSMutableArray *")
                item.addSerializationExp(varname: varname)
                item.addDeserializationExp(varname: varname, nodeName: "AstNodeList")
                item.addDestroyExp(varname: varname)
            }else if typename.hasPrefix("OR") || typename == "id"{
                item.addStructNodeField(type: "AstNode *", varname: varname)
                item.addNodeConvertExp(varname: varname, nodeName: "AstNode")
                item.addNodeDeconvertExp(varname: varname, className: "id")
                item.addSerializationExp(varname: varname)
                item.addDeserializationExp(varname: varname, nodeName: "AstNode")
                item.addDestroyExp(varname: varname)
            }else if typename == "NSString"{
                item.addStructNodeField(type: "ORStringCursor *", varname: varname)
                item.addNodeConvertExp(varname: varname, nodeName: "ORStringCursor")
                item.addNodeDeconvertExp(varname: varname, className: "NSString *")
                item.addSerializationExp(varname: varname)
                item.addDeserializationExp(varname: varname, nodeName: "ORStringCursor")
                item.addDestroyExp(varname: varname)
            }else{
                item.addStructNodeField(type: _uintType, varname: varname)
                item.addBaseConvertExp(varname: varname)
                item.addBaseDeconvertExp(varname: varname)
                item.baseLength += _uintLength
            }
            
        }else{
            if prop.var.type.type == TypeBOOL {
                item.addStructBaseFiled(type: "BOOL", varname: varname)
                item.addBaseConvertExp(varname: varname)
                item.addBaseDeconvertExp(varname: varname)
                item.baseLength += 1
            }else if prop.var.type.type == TypeUChar{
                item.addStructBaseFiled(type: _byteType, varname: varname)
                item.addBaseConvertExp(varname: varname)
                item.addBaseDeconvertExp(varname: varname)
                item.baseLength += _byteLength
            }else if prop.var.type.type == TypeLongLong{
                item.addStructBaseFiled(type: _int64Type, varname: varname)
                item.addBaseConvertExp(varname: varname)
                item.addBaseDeconvertExp(varname: varname)
                item.baseLength += _int64Length
            }else if prop.var.type.type == TypeULongLong{
                item.addStructBaseFiled(type: _uint64Type, varname: varname)
                item.addBaseConvertExp(varname: varname)
                item.addBaseDeconvertExp(varname: varname)
                item.baseLength += _uint64Length
            }else if prop.var.type.type == TypeDouble{
                item.addStructBaseFiled(type: _doubleType, varname: varname)
                item.addBaseConvertExp(varname: varname)
                item.addBaseDeconvertExp(varname: varname)
                item.baseLength += _doubleLength
            }
        }
    }
    impSource += item.structDeclareSource()
    
    impSource += item.convertFunctionSource()
    
    impSource += item.deconvertFunctionSource()
    
    impSource += item.serailizationFunctionSource()
    
    impSource += item.deserializationFunctionSource()
    
    impSource += item.destoryFunctionSource()
}

impSource +=
"""
#pragma pack()
#pragma pack(show)

"""
var convertExps = [String]()
var deConvertExps = [String]()
var serializationExps = [String]()
var deserializationExps = [String]()
var destoryExps = [String]()
for node in ast.nodes{
    guard let classNode = node as? ORClass else {
        continue
    }
    if classNode.className == "ORNode" {
        continue
    }
    let content = ClassCodeGenerator.init(className: classNode.className, superClassName: classNode.superClassName)
    let structName = content.structName
    let enumName = content.enumName
    let className = content.className
    let convertExp =
    """
    else if ([exp isKindOfClass:[\(className) class]]){
            return (AstNode *)\(structName)Convert((\(className) *)exp, patch, length);
        }
    """
    if classNode.superClassName.hasPrefix("OR") && classNode.superClassName != "ORNode"{
        convertExps.insert(convertExp, at: 0)
    }else{
        convertExps.append(convertExp)
    }
    
    deConvertExps.append(
    """
            case \(enumName):
                return (ORNode *)\(structName)DeConvert((\(structName) *)node, patch);
    
    """)
    serializationExps.append(
    """
            case \(enumName):
                \(structName)Serailization((\(structName) *)node, buffer, cursor); break;
    
    """)
    deserializationExps.append(
    """
            case \(enumName):
                return (AstNode *)\(structName)Deserialization(buffer, cursor, bufferLength);
    
    """)
    destoryExps.append(
    """
        case \(enumName):
                \(structName)Destroy((\(structName) *)node); break;
        
    """
    )
    
}

impSource +=
"""
AstNode *AstNodeConvert(id exp, AstPatchFile *patch, uint32_t *length){
    if ([exp isKindOfClass:[NSString class]]) {
        return (AstNode *)createStringCursor((NSString *)exp, patch, length);
    }else if ([exp isKindOfClass:[NSArray class]]) {
        return (AstNode *)AstNodeListConvert((NSArray *)exp, patch, length);
    }\(convertExps.joined(separator: ""))
    AstNode *node = malloc(sizeof(AstNode));
    memset(node, 0, sizeof(AstNode));
    *length += \(AstEmptyNodeLength);
    return node;
}

"""
impSource +=
"""
id AstNodeDeConvert(AstNode *node, AstPatchFile *patch){
    switch(node->nodeType){
        case AstEnumEmptyNode:
            return nil;
        case AstEnumListNode:
            return AstNodeListDeConvert((AstNodeList *)node, patch);
        case AstEnumStringCursorNode:
            return getNSStringWithStringCursor((ORStringCursor *) node, patch);
\(deConvertExps.joined(separator: ""))
        default: return [ORNode new];
    }
    return [ORNode new];
}

"""
impSource +=
"""
void AstNodeSerailization(AstNode *node, void *buffer, uint32_t *cursor){
    switch(node->nodeType){
        case AstEnumEmptyNode: {
            memcpy(buffer + *cursor, node, \(AstEmptyNodeLength));
            *cursor += \(AstEmptyNodeLength);
            break;
        }
        case AstEnumListNode:
            AstNodeListSerailization((AstNodeList *)node, buffer, cursor); break;
        case AstEnumStringCursorNode:
            ORStringCursorSerailization((ORStringCursor *) node, buffer, cursor); break;
        case AstEnumStringBufferNode:
            ORStringBufferNodeSerailization((ORStringBufferNode *) node, buffer, cursor);break;
\(serializationExps.joined(separator: ""))
        default: break;
    }
}

"""
impSource +=
"""
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
\(deserializationExps.joined(separator: ""))
        default:{
            AstNode *node = malloc(sizeof(AstNode));
            memset(node, 0, sizeof(AstNode));
            *cursor += \(AstEmptyNodeLength);
            return node;
        }
    }
}

"""
impSource +=
"""
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
    \(destoryExps.joined(separator: ""))
        default: break;
    }
}

"""
let headerFilePath = resultDir + "/" + resultFileName + ".h"
let impFilePath = resultDir + "/" + resultFileName + ".m"
try? headerSource.write(toFile: headerFilePath, atomically: true, encoding: .utf8)
try? impSource.write(toFile: impFilePath, atomically: true, encoding: .utf8)

print(headerFilePath)
print(impFilePath)
