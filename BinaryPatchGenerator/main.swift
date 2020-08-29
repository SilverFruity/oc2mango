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

let NodeDefine = "_ORNodeFields"
let PatchClass = "ORPatchFile"
let resultFileName = "BinaryPatchHelper"

let _ORNodeLength = 5
let _uintType = "uint32_t"
let _uintLength = 4
let _NodeTypeType = "uint8_t"
//TODO: Header
var headerSource =
"""
//  \(resultFileName).h
//  Generate By BinaryPatchGenerator
//  Created by Jiang on \(Int(Date.init().timeIntervalSince1970))
//  Copyright © 2020 SilverFruity. All rights reserved.

#import <Foundation/Foundation.h>
@class \(PatchClass);
#define \(NodeDefine) \\
\(_NodeTypeType) nodeType;\\
uint32_t length;

#pragma pack(1)
#pragma pack(show)
typedef struct {
    \(NodeDefine)
}_ORNode;

static \(_uintType) _ORNodeLength = \(_ORNodeLength);

typedef struct {
    \(NodeDefine)
    \(_uintType) count;
    _ORNode **nodes;
}_ListNode;
static uint32_t _ListNodeBaseLength = \(_ORNodeLength + _uintLength);

typedef struct {
    \(NodeDefine)
    \(_uintType) offset;
    \(_uintType) strLen;
}_StringNode;
static \(_uintType) _StringNodeBaseLength = \(_ORNodeLength + _uintLength * 2);

typedef struct {
    \(NodeDefine)
    \(_uintType) cursor;
    char *buffer;
}_StringsNode;
static \(_uintType) _StringsNodeBaseLength = \(_ORNodeLength + _uintLength);

typedef struct {
    \(NodeDefine)
    BOOL enable;
    _StringsNode *strings;
    _StringNode *appVersion;
    _StringNode *osVersion;
    _ListNode *nodes;
}_PatchNode;
static \(_uintType) _PatchNodeBaseLength = \(_ORNodeLength + 1);

#pragma pack()
#pragma pack(show)

_PatchNode *_PatchNodeConvert(\(PatchClass) *patch);
\(PatchClass) *_PatchNodeDeConvert(_PatchNode *node);
void _PatchNodeSerialization(_PatchNode *node, void *buffer, uint32_t *cursor);
_PatchNode *_PatchNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength);
"""

var NodeTypeEnums = ""
var enumIndex = 5
for node in ast.nodes{
    guard let classNode = node as? ORClass else {
        continue
    }
    if classNode.className == "ORNode" {
        continue
    }
    NodeTypeEnums += "    _\(classNode.className)Node = \(enumIndex),\n"
    enumIndex += 1
}
NodeTypeEnums =
"""
//  \(resultFileName).m
//  Generate By BinaryPatchGenerator
//  Created by Jiang on \(Int(Date.init().timeIntervalSince1970))
//  Copyright © 2020 SilverFruity. All rights reserved.
#import "\(resultFileName).h"
#import "\(PatchClass).h"
typedef enum: \(_NodeTypeType){
    ORNodeType = 0,
    PatchNodeType = 1,
    StringNodeType = 2,
    StringsNodeType = 3,
    ListNodeType = 4,
\(NodeTypeEnums)
}_NodeType;\n
"""
var impSource = NodeTypeEnums
impSource +=
"""
#pragma pack(1)
#pragma pack(show)

_ORNode *_ORNodeConvert(id exp, _PatchNode *patch);
id _ORNodeDeConvert(_ORNode *node, _PatchNode *patch);

_ListNode *_ListNodeConvert(NSArray *array, _PatchNode *patch){
    _ListNode *node = malloc(sizeof(_ListNode));
    memset(node, 0, sizeof(_ListNode));
    node->nodes = malloc(sizeof(void *) * array.count);
    node->nodeType = ListNodeType;
    node->length = _ListNodeBaseLength;
    for (id object in array) {
        _ORNode *element = _ORNodeConvert(object, patch);;
        node->nodes[node->count] = element;
        node->length += element->length;
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
_StringNode *saveNewString(NSString *string, _PatchNode *patch){
    _StringNode * strNode = malloc(sizeof(_StringNode));
    memset(strNode, 0, sizeof(_StringNode));
    const char *str = string.UTF8String;
    size_t len = strlen(str);
    strNode->strLen = (unsigned int)len;
    strNode->length = _StringNodeBaseLength;
    strNode->nodeType = StringNodeType;
    
    if (_stringMap[string]) {
        \(_uintType) offset = [_stringMap[string] unsignedIntValue];
        strNode->offset = offset;
        return strNode;
    }
    
    NSUInteger needLength = len + patch->strings->length;
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
    patch->strings->length += len;
    return strNode;
}

NSString *getString(_StringNode *node, _PatchNode *patch){
    char *cursor = patch->strings->buffer + node->offset;
    char *buffer = alloca(node->strLen + 1);
    memcpy(buffer, cursor, node->strLen);
    buffer[node->strLen] = '\\0';
    return [NSString stringWithUTF8String:buffer];
}

_PatchNode *_PatchNodeConvert(\(PatchClass) *patch){
    _stringMap = [NSMutableDictionary dictionary];
    _PatchNode *node = malloc(sizeof(_PatchNode));
    memset(node, 0, sizeof(_PatchNode));

    node->strings = malloc(sizeof(_StringsNode));
    memset(node->strings, 0, sizeof(_StringsNode));
    node->strings->nodeType = StringsNodeType;
    node->strings->length = _StringsNodeBaseLength;
    
    node->nodeType = PatchNodeType;
    node->enable = patch.enable;
    node->appVersion = (_StringNode *)_ORNodeConvert(patch.appVersion, node);
    node->osVersion = (_StringNode *)_ORNodeConvert(patch.osVersion, node);
    node->nodes = (_ListNode *)_ORNodeConvert(patch.nodes, node);
    node->length = _PatchNodeBaseLength + node->appVersion->length + node->strings->length + node->osVersion->length + node->nodes->length;
    return node;
}

\(PatchClass) *_PatchNodeDeConvert(_PatchNode *patch){
    \(PatchClass) *file = [\(PatchClass) new];
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

"""
for node in ast.nodes{
    guard let classNode = node as? ORClass else {
        continue
    }
    if classNode.className == "ORNode" {
        continue
    }
    var structFiels = [String]()
    var convertExps = [String]()
    var deConvertExps = [String]()
    var serializationExps = [String]()
    var deserializationExps = [String]()
    
    var offset = _ORNodeLength
    var lengthExps = [String]()
    
    let properties = classNode.properties as! [ORPropertyDeclare]
    for prop in properties{
        if prop.keywords.contains("readonly"){
            continue
        }
        let varname = prop.var.var.varname ?? ""
        var fiedLength = 0
        if let typename = prop.var.type.name{
            if typename == "NSMutableArray" {
                structFiels.append("_ListNode *\(varname);")
                lengthExps.append("node->\(varname)->length");
                convertExps.append("node->\(varname) = (_ListNode *)_ORNodeConvert(exp.\(varname), patch);")
                deConvertExps.append("exp.\(varname) = (\(typename) *)_ORNodeDeConvert((_ORNode *)node->\(varname), patch);")
                serializationExps.append("_ORNodeSerailization((_ORNode *)node->\(varname), buffer, cursor);");
                deserializationExps.append("node->\(varname) =(_ListNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);");
            }else if typename.hasPrefix("OR") || typename == "id"{
                structFiels.append("_ORNode *\(varname);")
                lengthExps.append("node->\(varname)->length");
                convertExps.append("node->\(varname) = _ORNodeConvert(exp.\(varname), patch);")
                deConvertExps.append("exp.\(varname) = _ORNodeDeConvert((_ORNode *)node->\(varname), patch);")
                serializationExps.append("_ORNodeSerailization((_ORNode *)node->\(varname), buffer, cursor);");
                deserializationExps.append("node->\(varname) =(_ORNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);");
            }else if typename == "NSString"{
                structFiels.append("_StringNode *\(varname);")
                lengthExps.append("node->\(varname)->length");
                convertExps.append("node->\(varname) = (_StringNode *)_ORNodeConvert(exp.\(varname), patch);")
                deConvertExps.append("exp.\(varname) = (\(typename) *)_ORNodeDeConvert((_ORNode *)node->\(varname), patch);")
                serializationExps.append("_ORNodeSerailization((_ORNode *)node->\(varname), buffer, cursor);");
                deserializationExps.append("node->\(varname) =(_StringNode *) _ORNodeDeserialization(buffer, cursor, bufferLength);");
            }else{
                structFiels.append("\(_uintType) \(varname);")
                convertExps.append("node->\(varname) = exp.\(varname);")
                deConvertExps.append("exp.\(varname) = node->\(varname);")
                fiedLength = _uintLength
//                serializationExps.append("memcpy(buffer, &(node->\(varname)), \(_uintLength));");
//                deserializationExps.append("memcpy(&(node->\(varname)), buffer, \(_uintLength));");
            }
            
        }else{
            if prop.var.type.type == TypeBOOL {
                structFiels.append("BOOL \(varname);")
                convertExps.append("node->\(varname) = exp.\(varname);")
                deConvertExps.append("exp.\(varname) = node->\(varname);")
//                serializationExps.append("memcpy(buffer, &(node->\(varname)), 1);");
//                deserializationExps.append("memcpy(&(node->\(varname)), buffer, 1);");
                fiedLength = 1
            }else if prop.var.type.type == TypeULongLong{
                structFiels.append("\(_uintType) \(varname);")
                convertExps.append("node->\(varname) = exp.\(varname);")
                deConvertExps.append("exp.\(varname) = node->\(varname);")
                fiedLength = _uintLength
            }
        }
        offset += fiedLength
    }
    let structName = "_\(classNode.className)";
    //TODO: Struct
    let define = classNode.className.hasPrefix("OR") ? NodeDefine : ""
    impSource +=
    """
    typedef struct {
        \(define)
        \(structFiels.joined(separator: "\n    "))
    }\(structName);\n
    """

    impSource += "static \(_uintType) \(structName)BaseLength = \(offset);\n"
    
    //TODO: Convert
    impSource +=
    """
    \(structName) *\(structName)Convert(\(classNode.className) *exp, _PatchNode *patch){
        \(structName) *node = malloc(sizeof(\(structName)));
        memset(node, 0, sizeof(\(structName)));
        node->nodeType = \(structName)Node;
        \(convertExps.joined(separator: "\n    "))
        node->length = \(structName)BaseLength \(lengthExps.count > 0 ? "+":"")\(lengthExps.joined(separator: " + "));
        return node;
    }
    
    """
    
    //TODO: DeConvert
    impSource +=
    """
    \(classNode.className) *\(structName)DeConvert(\(structName) *node, _PatchNode *patch){
        \(classNode.className) *exp = [\(classNode.className) new];
        \(deConvertExps.joined(separator: "\n    "))
        return exp;
    }
    
    """
    
    //TODO: Serailization
    impSource +=
    """
    void \(structName)Serailization(\(structName) *node, void *buffer, uint32_t *cursor){
        memcpy(buffer + *cursor, node, \(structName)BaseLength);
        *cursor += \(structName)BaseLength;
        \(serializationExps.joined(separator: "\n    "))
    }
    
    """
    
    //TODO: Deserialization
    impSource +=
    """
    \(structName) *\(structName)Deserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
        \(structName) *node = malloc(sizeof(\(structName)));
        memcpy(node, buffer + *cursor, \(structName)BaseLength);
        *cursor += \(structName)BaseLength;
        \(deserializationExps.joined(separator: "\n    "))
        return node;
    }
    
    """
    

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
for node in ast.nodes{
    guard let classNode = node as? ORClass else {
        continue
    }
    if classNode.className == "ORNode" {
        continue
    }
    let structName = "_\(classNode.className)";
    let convertExp =
    """
    else if ([exp isKindOfClass:[\(classNode.className) class]]){
            return (_ORNode *)\(structName)Convert((\(classNode.className) *)exp, patch);
        }
    """
    if classNode.superClassName.hasPrefix("OR") && classNode.superClassName != "ORNode"{
        convertExps.insert(convertExp, at: 0)
    }else{
        convertExps.append(convertExp)
    }
    
    deConvertExps.append(
    """
    else if (node->nodeType == \(structName)Node){
            return (ORNode *)\(structName)DeConvert((\(structName) *)node, patch);
        }
    """)
    serializationExps.append(
    """
    else if (node->nodeType == \(structName)Node){
            \(structName)Serailization((\(structName) *)node, buffer, cursor);
        }
    """)
    deserializationExps.append(
    """
    else if (nodeType == \(structName)Node){
            return (_ORNode *)\(structName)Deserialization(buffer, cursor, bufferLength);
        }
    """)
    
}

impSource +=
"""
_ORNode *_ORNodeConvert(id exp, _PatchNode *patch){
    if ([exp isKindOfClass:[NSString class]]) {
        return (_ORNode *)saveNewString((NSString *)exp, patch);
    }else if ([exp isKindOfClass:[NSArray class]]) {
        return (_ORNode *)_ListNodeConvert((NSArray *)exp, patch);
    }\(convertExps.joined(separator: ""))
    _ORNode *node = malloc(sizeof(_ORNode));
    memset(node, 0, sizeof(_ORNode));
    node->length = \(_ORNodeLength);
    return node;
}

"""
impSource +=
"""
id _ORNodeDeConvert(_ORNode *node, _PatchNode *patch){
    if (node->nodeType == ORNodeType) return nil;
    if (node->nodeType == ListNodeType) {
        return _ListNodeDeConvert((_ListNode *)node, patch);
    }else if (node->nodeType == StringNodeType) {
        return getString((_StringNode *) node, patch);
    }\(deConvertExps.joined(separator: ""))
    return [ORNode new];
}

"""
impSource +=
"""
void _ORNodeSerailization(_ORNode *node, void *buffer, uint32_t *cursor){
    if (node->nodeType == ORNodeType) {
        memcpy(buffer + *cursor, node, \(_ORNodeLength));
        *cursor += \(_ORNodeLength);
    }else if (node->nodeType == ListNodeType) {
        _ListNodeSerailization((_ListNode *)node, buffer, cursor);
    }else if (node->nodeType == StringNodeType) {
        _StringNodeSerailization((_StringNode *) node, buffer, cursor);
    }else if (node->nodeType == StringsNodeType) {
        _StringsNodeSerailization((_StringsNode *) node, buffer, cursor);
    }\(serializationExps.joined(separator: ""))
}

"""
impSource +=
"""
_ORNode *_ORNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
    _NodeType nodeType = ORNodeType;
    if (*cursor < bufferLength) {
        nodeType = *(_NodeType *)(buffer + *cursor);
    }
    if (nodeType == ListNodeType) {
        return (_ORNode *)_ListNodeDeserialization(buffer, cursor, bufferLength);
    }else if (nodeType == StringNodeType) {
        return (_ORNode *)_StringNodeDeserialization(buffer, cursor, bufferLength);
    }\(deserializationExps.joined(separator: ""))

    _ORNode *node = malloc(sizeof(_ORNode));
    memset(node, 0, sizeof(_ORNode));
    *cursor += \(_ORNodeLength);
    return node;
}

"""
let headerFilePath = resultDir + "/" + resultFileName + ".h"
let impFilePath = resultDir + "/" + resultFileName + ".m"
try? headerSource.write(toFile: headerFilePath, atomically: true, encoding: .utf8)
try? impSource.write(toFile: impFilePath, atomically: true, encoding: .utf8)

print(headerFilePath)
print(impFilePath)
