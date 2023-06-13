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

let forUnitTest = false
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
var enumStartIndex = 5;
for node in ast.nodes{
    guard let classNode = node as? ORClass else {
        continue
    }
    if classNode.className == "ORNode" {
        continue
    }
    let generator = ClassCodeGenerator.init(className: classNode.className, superClassName: classNode.superClassName)
    enumVarDecls.append("    \(generator.enumName) = \(enumStartIndex),")
    enumStartIndex += 1;
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
}AstEmptyNode;

static \(_uintType) AstEmptyNodeLength = \(AstEmptyNodeLength);

typedef struct {
    \(NodeDefine)
    \(_uintType) count;
    AstEmptyNode **nodes;
}AstNodeList;
static uint32_t AstNodeListBaseLength = \(AstEmptyNodeLength + _uintLength);

typedef struct {
    \(NodeDefine)
    \(_uintType) offset;
    \(_uintType) strLen;
}AstStringCursor;
static \(_uintType) AstStringCursorBaseLength = \(AstEmptyNodeLength + _uintLength * 2);

typedef struct {
    \(NodeDefine)
    \(_uintType) cursor;
    char *buffer;
}AstStringBufferNode;
static \(_uintType) AstStringBufferNodeBaseLength = \(AstEmptyNodeLength + _uintLength);

typedef struct {
    \(NodeDefine)
    BOOL enable;
    AstStringBufferNode *strings;
    AstStringCursor *appVersion;
    AstStringCursor *osVersion;
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
void AstNodeListTagged(id parentNode, NSArray *nodes);
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

NSString *getNSStringWithStringCursor(AstStringCursor *node, AstPatchFile *patch){
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

\(PatchFileClass) *AstPatchFileDeConvert(AstPatchFile *patch){
    \(PatchFileClass) *file = [\(PatchFileClass) new];
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

"""
var generators = [ClassCodeGenerator]()
for node in ast.nodes{
    guard let classNode = node as? ORClass, classNode.className != "ORNode" else {
        continue
    }
    let generator = ClassCodeGenerator(className: classNode.className, superClassName:classNode.superClassName)
    let properties = classNode.properties as! [ORPropertyDeclare]
    for prop in properties{
        if prop.keywords.contains("readonly"){
            continue
        }
        let varname = prop.var.var.varname ?? ""
        if let typename = prop.var.type.name{
            if typename == "NSMutableArray" {
                generator.addStructNodeField(type: "AstNodeList *", varname: varname)
                generator.addNodeConvertExp(varname: varname, nodeName: "AstNodeList")
                generator.addNodeDeconvertExp(varname: varname, className: "NSMutableArray *")
                generator.addSerializationExp(varname: varname)
                generator.addDeserializationExp(varname: varname, nodeName: "AstNodeList")
                generator.addDestroyExp(varname: varname)
                generator.addNodeTaggedExp(varname: varname);
            }else if typename.hasPrefix("OR") || typename == "id"{
                generator.addStructNodeField(type: "AstEmptyNode *", varname: varname)
                generator.addNodeConvertExp(varname: varname, nodeName: "AstEmptyNode")
                generator.addNodeDeconvertExp(varname: varname, className: "id")
                generator.addSerializationExp(varname: varname)
                generator.addDeserializationExp(varname: varname, nodeName: "AstEmptyNode")
                generator.addDestroyExp(varname: varname)
                generator.addNodeTaggedExp(varname: varname);
            }else if typename == "NSString"{
                generator.addStructNodeField(type: "AstStringCursor *", varname: varname)
                generator.addNodeConvertExp(varname: varname, nodeName: "AstStringCursor")
                generator.addNodeDeconvertExp(varname: varname, className: "NSString *")
                generator.addSerializationExp(varname: varname)
                generator.addDeserializationExp(varname: varname, nodeName: "AstStringCursor")
                generator.addDestroyExp(varname: varname)
            }else{
                generator.addStructNodeField(type: _uintType, varname: varname)
                generator.addBaseConvertExp(varname: varname)
                generator.addBaseDeconvertExp(varname: varname)
                generator.baseLength += _uintLength
            }
            
        }else{
            if prop.var.type.type == TypeBOOL {
                generator.addStructBaseFiled(type: "BOOL", varname: varname)
                generator.addBaseConvertExp(varname: varname)
                generator.addBaseDeconvertExp(varname: varname)
                generator.baseLength += 1
            }else if prop.var.type.type == TypeUChar{
                generator.addStructBaseFiled(type: _byteType, varname: varname)
                generator.addBaseConvertExp(varname: varname)
                generator.addBaseDeconvertExp(varname: varname)
                generator.baseLength += _byteLength
            }else if prop.var.type.type == TypeLongLong{
                generator.addStructBaseFiled(type: _int64Type, varname: varname)
                generator.addBaseConvertExp(varname: varname)
                generator.addBaseDeconvertExp(varname: varname)
                generator.baseLength += _int64Length
            }else if prop.var.type.type == TypeULongLong{
                generator.addStructBaseFiled(type: _uint64Type, varname: varname)
                generator.addBaseConvertExp(varname: varname)
                generator.addBaseDeconvertExp(varname: varname)
                generator.baseLength += _uint64Length
            }else if prop.var.type.type == TypeDouble{
                generator.addStructBaseFiled(type: _doubleType, varname: varname)
                generator.addBaseConvertExp(varname: varname)
                generator.addBaseDeconvertExp(varname: varname)
                generator.baseLength += _doubleLength
            }
        }
    }
    generators.append(generator)
}
headerSource +=
"""

#pragma pack(1)

"""
_ = generators.map({ headerSource += $0.structDeclareSource() })

headerSource +=
"""

#pragma pack()
#pragma pack(show)

"""

impSource +=
"""

#pragma mark - Struct BaseLength

"""

_ = generators.map({ impSource += $0.baseLengthCode })

impSource +=
"""

#pragma mark - Class Convert To Struct

"""

_ = generators.map({ impSource += $0.convertFunctionSource() })

impSource +=
"""

#pragma mark - Struct Convert To Class

"""

_ = generators.map({ impSource += $0.deconvertFunctionSource() })

impSource +=
"""

#pragma mark - Struct Write To Buffer

"""

_ = generators.map({ impSource += $0.serailizationFunctionSource() })

impSource +=
"""

#pragma mark - Buffer Data Convert To Struct

"""

_ = generators.map({ impSource += $0.deserializationFunctionSource() })

impSource +=
"""

#pragma mark - Free Struct Memory

"""

_ = generators.map({ impSource += $0.destoryFunctionSource() })

impSource +=
"""

#pragma mark - Add NodeType To Node
void AstNodeTagged(id parentNode, id node);

"""

_ = generators.map({ impSource += $0.taggedFunctionSource() })

var convertExps = [String]()
var deConvertExps = [String]()
var serializationExps = [String]()
var deserializationExps = [String]()
var destoryExps = [String]()
var taggedExps = [String]()
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
            return (AstEmptyNode *)\(structName)Convert((\(className) *)exp, patch, length);
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
                return (ORNode *)\(structName)DeConvert(parent, (\(structName) *)node, patch);
    
    """)
    serializationExps.append(
    """
            case \(enumName):
                \(structName)Serailization((\(structName) *)node, buffer, cursor); break;
    
    """)
    deserializationExps.append(
    """
            case \(enumName):
                return (AstEmptyNode *)\(structName)Deserialization(buffer, cursor, bufferLength);
    
    """)
    destoryExps.append(
    """
        case \(enumName):
                \(structName)Destroy((\(structName) *)node); break;
        
    """
    )
    taggedExps.append(
    """
    else if ([node isKindOfClass:[\(className) class]]){
            \(className)Tagged(parentNode, (\(className) *)node);
            return;
        }
    """
    )
    
}

impSource +=
"""

#pragma mark - Dispatch

"""

impSource +=
"""
AstEmptyNode *AstNodeConvert(id exp, AstPatchFile *patch, uint32_t *length){
    if ([exp isKindOfClass:[NSString class]]) {
        return (AstEmptyNode *)createStringCursor((NSString *)exp, patch, length);
    }else if ([exp isKindOfClass:[NSArray class]]) {
        return (AstEmptyNode *)AstNodeListConvert((NSArray *)exp, patch, length);
    }\(convertExps.joined(separator: ""))
    AstEmptyNode *node = malloc(sizeof(AstEmptyNode));
    memset(node, 0, sizeof(AstEmptyNode));
    *length += \(AstEmptyNodeLength);
    return node;
}

"""
impSource +=
"""
id AstNodeDeConvert(ORNode *parent,AstEmptyNode *node, AstPatchFile *patch){
    switch(node->nodeType){
        case AstEnumEmptyNode:
            return nil;
        case AstEnumListNode:
            return AstNodeListDeConvert(parent, (AstNodeList *)node, patch);
        case AstEnumStringCursorNode:
            return getNSStringWithStringCursor((AstStringCursor *) node, patch);
\(deConvertExps.joined(separator: ""))
        default: return [ORNode new];
    }
    return [ORNode new];
}

"""
impSource +=
"""
void AstNodeSerailization(AstEmptyNode *node, void *buffer, uint32_t *cursor){
    switch(node->nodeType){
        case AstEnumEmptyNode: {
            memcpy(buffer + *cursor, node, \(AstEmptyNodeLength));
            *cursor += \(AstEmptyNodeLength);
            break;
        }
        case AstEnumListNode:
            AstNodeListSerailization((AstNodeList *)node, buffer, cursor); break;
        case AstEnumStringCursorNode:
            AstStringCursorSerailization((AstStringCursor *) node, buffer, cursor); break;
        case AstEnumStringBufferNode:
            AstStringBufferNodeSerailization((AstStringBufferNode *) node, buffer, cursor);break;
\(serializationExps.joined(separator: ""))
        default: break;
    }
}

"""
impSource +=
"""
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
\(deserializationExps.joined(separator: ""))
        default:{
            AstEmptyNode *node = malloc(sizeof(AstEmptyNode));
            memset(node, 0, sizeof(AstEmptyNode));
            *cursor += \(AstEmptyNodeLength);
            return node;
        }
    }
}

"""
impSource +=
"""
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
    \(destoryExps.joined(separator: ""))
        default: break;
    }
}

"""

impSource +=
"""
void AstNodeListTagged(id parentNode, NSArray *nodes) {
    for (id node in nodes) {
        AstNodeTagged(parentNode, node);
    }
}
void AstNodeTagged(id parentNode, id node) {
    if ([node isKindOfClass:[NSArray class]]) {
        AstNodeListTagged(parentNode, node);
    }\(taggedExps.joined(separator: ""))
}
"""

let headerFilePath = resultDir + "/" + resultFileName + ".h"
let impFilePath = resultDir + "/" + resultFileName + ".m"
try? headerSource.write(toFile: headerFilePath, atomically: true, encoding: .utf8)
try? impSource.write(toFile: impFilePath, atomically: true, encoding: .utf8)

print(headerFilePath)
print(impFilePath)
