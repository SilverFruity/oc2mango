//
//  ClassCodeGenerator.swift
//  BinaryPatchCodeGenerator
//
//  Created by APPLE on 2021/6/3.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

import Foundation
var generatorCache = [String: ClassCodeGenerator]()
class ClassCodeGenerator{
    var className: String
    var superClassName: String
    var structName: String {
        return self.className.replacingOccurrences(of: "OR", with: "Ast")
    }
    var enumName: String{
        return self.className.replacingOccurrences(of: "OR", with: "AstEnum")
    }
    var structNodeFiels = [String]()
    var structBaseFiels = [String]()
    var convertExps = [String]()
    var deConvertExps = [String]()
    var serializationExps = [String]()
    var deserializationExps = [String]()
    var taggedExps = [String]()
    var destoryExps = [String]()
    var baseLengthCode = ""
    var baseLength = 0
    func addStructNodeField(type: String, varname: String){
        self.structNodeFiels.append("\(type) \(varname);")
    }
    func addStructBaseFiled(type: String, varname: String){
        self.structBaseFiels.append("\(type) \(varname);")
    }
    func addNodeConvertExp(varname: String, nodeName:String){
        self.convertExps.append("node->\(varname) = (\(nodeName) *)AstNodeConvert(exp.\(varname), patch, length);")
    }
    func addBaseConvertExp(varname: String){
        self.convertExps.append("node->\(varname) = exp.\(varname);")
    }
    func addNodeDeconvertExp(varname: String, className:String){
        self.deConvertExps.append("exp.\(varname) = (\(className))AstNodeDeConvert(exp, (AstEmptyNode *)node->\(varname), patch);")
    }
    func addBaseDeconvertExp(varname: String){
        self.deConvertExps.append("exp.\(varname) = node->\(varname);")
    }
    func addSerializationExp(varname: String){
        self.serializationExps.append("AstNodeSerailization((AstEmptyNode *)node->\(varname), buffer, cursor);");
    }
    func addDeserializationExp(varname: String, nodeName:String){
        deserializationExps.append("node->\(varname) =(\(nodeName) *) AstNodeDeserialization(buffer, cursor, bufferLength);");
    }
    func addDestroyExp(varname: String){
        destoryExps.append("AstNodeDestroy((AstEmptyNode *)node->\(varname));")
    }
    func addNodeTaggedExp(varname: String){
        self.taggedExps.append("AstNodeTagged(exp, exp.\(varname));")
    }
    init(className: String, superClassName: String) {
        self.className = className
        self.superClassName = superClassName
        generatorCache[className] = self
    }
    //TODO: Struct
    func structDeclareSource()->String{
        //FIX: ORFuncVariable继承问题
        var baseFiels = self.structBaseFiels
        var nodeFiles = self.structNodeFiels
        var baseLength = AstEmptyNodeLength + self.baseLength
        if let superContent = generatorCache[self.superClassName]{
            baseFiels = superContent.structBaseFiels + baseFiels
            nodeFiles = superContent.structNodeFiels + nodeFiles
            baseLength += superContent.baseLength
        }
        let structFiels = baseFiels + nodeFiles
        baseLengthCode =
        """
        static \(_uintType) \(structName)BaseLength = \(baseLength);\n
        """
        return """

        typedef struct {
            \(NodeDefine)
            \(structFiels.joined(separator: "\n    "))
        }\(structName);

        """
    }
    //TODO: Convert
    func convertFunctionSource()->String{
        var convertExps = self.convertExps
        if let superContent = generatorCache[self.superClassName]{
            convertExps = superContent.convertExps + convertExps
        }
        return """
        \(structName) *\(structName)Convert(\(className) *exp, AstPatchFile *patch, uint32_t *length){
            \(structName) *node = malloc(sizeof(\(structName)));
            memset(node, 0, sizeof(\(structName)));
            node->nodeType = \(enumName);\(withSemicolonConvertExp)
            \(convertExps.joined(separator: "\n    "))
            *length += \(structName)BaseLength;
            return node;
        }
        
        """
    }
    //TODO: Deconvert
    func deconvertFunctionSource()->String{
        var deConvertExps = self.deConvertExps
        if let superContent = generatorCache[self.superClassName]{
            deConvertExps = superContent.deConvertExps + deConvertExps
        }
        return """
        \(className) *\(structName)DeConvert(ORNode *parent, \(structName) *node, AstPatchFile *patch){
            \(className) *exp = [\(className) new];
            exp.parentNode = parent;\(withSemicolonDeconvertExp)
            \(deConvertExps.joined(separator: "\n    "))
            return exp;
        }
        
        """
    }
    //TODO: Serailization
    func serailizationFunctionSource()->String{
        var serializationExps = self.serializationExps
        if let superContent = generatorCache[self.superClassName]{
            serializationExps = superContent.serializationExps + serializationExps
        }
        return """
        void \(structName)Serailization(\(structName) *node, void *buffer, uint32_t *cursor){
            memcpy(buffer + *cursor, node, \(structName)BaseLength);
            *cursor += \(structName)BaseLength;
            \(serializationExps.joined(separator: "\n    "))
        }
        
        """
    }
    //TODO: Deserialization
    func deserializationFunctionSource()->String{
        var deserializationExps = self.deserializationExps
        if let superContent = generatorCache[self.superClassName]{
            deserializationExps = superContent.deserializationExps + deserializationExps
        }
        return """
         \(structName) *\(structName)Deserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength){
             \(structName) *node = malloc(sizeof(\(structName)));
             memcpy(node, buffer + *cursor, \(structName)BaseLength);
             *cursor += \(structName)BaseLength;
             \(deserializationExps.joined(separator: "\n    "))
             return node;
         }
         
         """
    }
    //TODO: Destroy
    func destoryFunctionSource()->String{
        var destoryExps = self.destoryExps
        if let superContent = generatorCache[self.superClassName]{
            destoryExps = superContent.destoryExps + destoryExps
        }
        return """
        void \(structName)Destroy(\(structName) *node){
            \(destoryExps.joined(separator: "\n    "))
            free(node);
        }
        
        """
    }
    //TODO: Tagged
    func taggedFunctionSource()->String{
        return """
        void \(className)Tagged(id parentNode, \(className) *exp){
            exp.parentNode = parentNode;
            exp.nodeType = \(enumName);
            \(self.taggedExps.joined(separator: "\n    "))
        }
        
        """
    }
}
