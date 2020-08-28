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

let _ORNodeLength = 16
var headerSource =
"""
//  \(resultFileName).h
//  Generate By BinaryPatchGenerator
//  Created by Jiang on \(Int(Date.init().timeIntervalSince1970))
//  Copyright © 2020 SilverFruity. All rights reserved.

#import <Foundation/Foundation.h>
@class \(PatchClass);
#define \(NodeDefine) \\
uint64_t nodeType;\\
uint64_t length;

#pragma pack(1)
#pragma pack(show)
typedef struct {
    \(NodeDefine)
}_ORNode;

static uint64_t _ORNodeLength = \(_ORNodeLength);

typedef struct {
    \(NodeDefine)
    uint64_t count;
    _ORNode **nodes;
}_ListNode;

typedef struct {
    \(NodeDefine)
    uint64_t offset;
    uint64_t strLen;
}_StringNode;
static uint64_t _StringNodeLength = \(_ORNodeLength) + 16;

typedef struct {
    \(NodeDefine)
    char *buffer;
    uint64_t cursor;
}_StringsNode;

typedef struct {
    \(NodeDefine)
    _StringNode *appVersion;
    _StringNode *osVersion;
    _ListNode *nodes;
    _StringsNode *strings;
    BOOL enable;
}_PatchNode;
#pragma pack()
#pragma pack(show)

_PatchNode *_PatchNodeConvert(\(PatchClass) *patch);
\(PatchClass) *_PatchNodeDeConvert(_PatchNode *node);
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
typedef enum: uint64_t{
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
    for (id object in array) {
        _ORNode *element = _ORNodeConvert(object, patch);;
        node->nodes[node->count] = element;
        node->nodeType = ListNodeType;
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
    strNode->strLen = len;
    strNode->length = _StringNodeLength;
    strNode->nodeType = StringNodeType;
    
    if (_stringMap[string]) {
        uint64_t offset = [_stringMap[string] unsignedLongLongValue];
        strNode->offset = offset;
        return strNode;
    }
    
    NSUInteger needLength = string.length + patch->strings->length;
    if (patch->strings->buffer == NULL) {
        patch->strings->buffer = malloc(string.length + patch->strings->length);
    }else if (needLength > strlen(patch->strings->buffer)){
        NSUInteger bufferLength = strlen(patch->strings->buffer);
        NSUInteger addLength = 512;
        NSUInteger newLength = addLength + bufferLength;
        patch->strings->buffer = realloc(patch->strings->buffer, newLength);
        memset(patch->strings->buffer + bufferLength, 0, addLength);
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
    node->strings = malloc(sizeof(_StringNode));
    memset(node->strings, 0, sizeof(_StringNode));
    node->nodeType = PatchNodeType;
    node->enable = patch.enable;
    node->appVersion = (_StringNode *)_ORNodeConvert(patch.appVersion, node);
    node->osVersion = (_StringNode *)_ORNodeConvert(patch.osVersion, node);
    node->nodes = (_ListNode *)_ORNodeConvert(patch.nodes, node);
    node->length = _ORNodeLength + node->appVersion->length + node->strings->length + node->osVersion->length + node->nodes->length;
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

"""
for node in ast.nodes{
    guard let classNode = node as? ORClass else {
        continue
    }
    if classNode.className == "ORNode" {
        continue
    }
    let properties = classNode.properties as! [ORPropertyDeclare]
    let define = classNode.className.hasPrefix("OR") ? NodeDefine : ""
    var structFiels = [String]()
    var convertExps = [String]()
    var deConvertExps = [String]()
    
    var offset = _ORNodeLength
    var fieldOffsetPair:[(String, Int)] = []
    var fieldLengthPair:[(String, Int)] = []
    var hasList = false
    var listLengthExps = [String]()
    for prop in properties{
        if prop.keywords.contains("readonly"){
            continue
        }
        let varname = prop.var.var.varname ?? ""
        var fiedLength = 0
        if let typename = prop.var.type.name{
            if typename == "NSMutableArray" {
                hasList = true
                listLengthExps.append("node->\(varname)->length");
                structFiels.append("_ListNode *\(varname);")
                convertExps.append("node->\(varname) = (_ListNode *)_ORNodeConvert(exp.\(varname), patch);")
                deConvertExps.append("exp.\(varname) = (\(typename) *)_ORNodeDeConvert((_ORNode *)node->\(varname), patch);")
            }else if typename.hasPrefix("OR") || typename == "id"{
                structFiels.append("_ORNode *\(varname);")
                convertExps.append("node->\(varname) = _ORNodeConvert(exp.\(varname), patch);")
                deConvertExps.append("exp.\(varname) = _ORNodeDeConvert((_ORNode *)node->\(varname), patch);")
                fiedLength = 8
            }else if typename == "NSString"{
                structFiels.append("_StringNode *\(varname);")
                convertExps.append("node->\(varname) = (_StringNode *)_ORNodeConvert(exp.\(varname), patch);")
                deConvertExps.append("exp.\(varname) = (\(typename) *)_ORNodeDeConvert((_ORNode *)node->\(varname), patch);")
                fiedLength = 8
            }else{
                structFiels.append("uint64_t \(varname);")
                convertExps.append("node->\(varname) = exp.\(varname);")
                deConvertExps.append("exp.\(varname) = node->\(varname);")
                fiedLength = 8
            }
            
        }else{
            if prop.var.type.type == TypeBOOL {
                structFiels.append("BOOL \(varname);")
                convertExps.append("node->\(varname) = exp.\(varname);")
                deConvertExps.append("exp.\(varname) = node->\(varname);")
                fiedLength = 1
            }
        }
        fieldOffsetPair.append(("_\(classNode.className)_\(varname)_offset", offset))
        offset += fiedLength
        fieldLengthPair.append(("_\(classNode.className)_\(varname)_length", fiedLength))
    }
    let structName = "_\(classNode.className)";
    impSource +=
    """
    typedef struct {
        \(define)
        \(structFiels.joined(separator: "\n    "))
    }\(structName);\n
    """
//    for (name, offset) in fieldOffsetPair{
//        impSource += "static uint64_t \(name) = \(offset);\n"
//    }
//    for (name, len) in fieldLengthPair{
//        impSource += "static uint64_t \(name) = \(len);\n"
//    }
    if hasList {
        impSource += "static uint64_t \(structName)BaseLength = \(offset);\n"
    }else{
        impSource += "static uint64_t \(structName)Length = \(offset);\n"
    }
    if hasList {
        impSource +=
        """
        \(structName) *\(structName)Convert(\(classNode.className) *exp, _PatchNode *patch){
            \(structName) *node = malloc(sizeof(\(structName)));
            memset(node, 0, sizeof(\(structName)));
            node->nodeType = \(structName)Node;
            \(convertExps.joined(separator: "\n    "))
            node->length = \(structName)BaseLength + \(listLengthExps.joined(separator: " + "));
            return node;
        }
        
        """
    }else{
        impSource +=
        """
        \(structName) *\(structName)Convert(\(classNode.className) *exp, _PatchNode *patch){
            \(structName) *node = malloc(sizeof(\(structName)));
            memset(node, 0, sizeof(\(structName)));
            node->nodeType = \(structName)Node;
            node->length = \(structName)Length;
            \(convertExps.joined(separator: "\n    "))
            return node;
        }
        
        """
    }
    impSource +=
    """
    \(classNode.className) *\(structName)DeConvert(\(structName) *node, _PatchNode *patch){
        \(classNode.className) *exp = [\(classNode.className) new];
        \(deConvertExps.joined(separator: "\n    "))
        return exp;
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
for node in ast.nodes{
    guard let classNode = node as? ORClass else {
        continue
    }
    if classNode.className == "ORNode" {
        continue
    }
    let structName = "_\(classNode.className)";
    convertExps.append(
    """
        if ([exp isKindOfClass:[\(classNode.className) class]]){
            return (_ORNode *)\(structName)Convert((\(classNode.className) *)exp, patch);
        }
    """)
    
    deConvertExps.append(
    """
        if (node->nodeType == \(structName)Node){
            return (ORNode *)\(structName)DeConvert((\(structName) *)node, patch);
        }
    """)
}

impSource +=
"""
_ORNode *_ORNodeConvert(id exp, _PatchNode *patch){
    if ([exp isKindOfClass:[NSString class]]) {
        return (_ORNode *)saveNewString((NSString *)exp, patch);
    }
    if ([exp isKindOfClass:[NSArray class]]) {
        return (_ORNode *)_ListNodeConvert((NSArray *)exp, patch);
    }
\(convertExps.joined(separator: "\n"))
    _ORNode *node = malloc(sizeof(_ORNode));
    memset(node, 0, sizeof(_ORNode));
    return node;
}

"""
impSource +=
"""
id _ORNodeDeConvert(_ORNode *node, _PatchNode *patch){
    if (node->nodeType == ORNodeType) return nil;
    if (node->nodeType == ListNodeType) {
        return _ListNodeDeConvert((_ListNode *)node, patch);
    }
    if (node->nodeType == StringNodeType) {
        return getString((_StringNode *) node, patch);
    }
\(deConvertExps.joined(separator: "\n"))
    return [ORNode new];
}

"""
let headerFilePath = resultDir + "/" + resultFileName + ".h"
let impFilePath = resultDir + "/" + resultFileName + ".m"
try? headerSource.write(toFile: headerFilePath, atomically: true, encoding: .utf8)
try? impSource.write(toFile: impFilePath, atomically: true, encoding: .utf8)

print(headerFilePath)
print(impFilePath)
