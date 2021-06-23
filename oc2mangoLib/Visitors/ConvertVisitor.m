//
//  ConvertVisitor.m
//  oc2mangoLib
//
//  Created by APPLE on 2021/6/23.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "ConvertVisitor.h"
static NSString *convertBuffer = nil;
@implementation ConvertVisitor
//- (void)visitAllNode:(ORNode *)node{
//    [super visitAllNode:node];
//}
- (void)visitClassNode:(ORClassNode *)node{
    NSMutableString *content = [NSMutableString string];
    [content appendFormat:@"class %@:%@",node.className,node.superClassName];
    if (node.protocols.count > 0) {
        [content appendFormat:@"<%@>",[node.protocols componentsJoinedByString:@","]];
    }
    [content appendString:@"{\n"];
    for (ORPropertyNode *prop in node.properties) {
        [self visitAllNode:prop];
        [content appendString:convertBuffer];
    }
    for (ORMethodNode *imp in node.methods) {
        [self visitAllNode:imp];
        [content appendString:convertBuffer];
    }
    [content appendString:@"\n}\n"];
    convertBuffer = content;
}
- (void)visitTypeNode:(ORTypeNode *)node{
    if (node == nil) {
        convertBuffer = @"void ";
        return;
    }
    NSMutableString *result = [NSMutableString string];
    switch (node.type){
        case OCTypeUChar:
        case OCTypeUShort:
        case OCTypeUInt:
        case OCTypeULong:
        case OCTypeULongLong:
            [result appendString:@"uint"]; break;
        case OCTypeChar:
        case OCTypeShort:
        case OCTypeInt:
        case OCTypeLong:
        case OCTypeLongLong:
            [result appendString:@"int"]; break;
        case OCTypeDouble:
        case OCTypeFloat:
            [result appendString:@"double"]; break;
        case OCTypeVoid:
            [result appendString:@"void"]; break;
        case OCTypeSEL:
            [result appendString:@"SEL"]; break;
        case OCTypeClass:
            [result appendString:@"Class"]; break;
        case OCTypeBOOL:
            [result appendString:@"BOOL"]; break;
        case OCTypeObject:
            [result appendString:node.name]; break;
            
        case OCTypeStruct:
            [result appendString:node.name]; break;
            break;
        default:
            [result appendString:@"UnKnownType"];
            break;
    }
    [result appendString:@" "];
    convertBuffer = result;
}
- (void)visitPropertyNode:(ORPropertyNode *)node{
    NSString *propKeywords =  [node.keywords componentsJoinedByString:@","];
    [self visitAllNode:node.var];
    NSString *var = convertBuffer;
    convertBuffer = [NSString stringWithFormat:@"@property(%@)%@;\n",propKeywords, var];
}
- (void)visitMethodDeclNode:(ORMethodDeclNode *)node{
    NSString *methodName = @"";
    if (node.parameterNames.count == 0) {
        methodName = node.methodNames.firstObject;
    }else{
        NSMutableArray *list = [NSMutableArray array];
        
        for (int i = 0; i < node.parameterNames.count; i++) {
            [self visitAllNode:node.parameterTypes[i]];
            NSString *paramType = convertBuffer;
            [list addObject:[NSString stringWithFormat:@"%@:(%@)%@",
                             node.methodNames[i],
                             paramType,
                             node.parameterNames[i]]];
        }
        methodName = [list componentsJoinedByString:@" "];
    }
    [self visitAllNode:node.returnType];
    convertBuffer = [NSString stringWithFormat:@"%@(%@)%@",node.isClassMethod?@"+":@"-",convertBuffer,methodName];
}
- (void)visitMethodNode:(ORMethodNode *)node{
    [self visitAllNode:node.declare];
    NSString *decalre = convertBuffer.copy;
    [self visitAllNode:node.scopeImp];
    NSString *imp = convertBuffer.copy;
    convertBuffer = [NSString stringWithFormat:@"\n%@%@",decalre, imp];
}

int convert_indentationCont = 0;
- (void)visitBlockNode:(ORBlockNode *)node{
    NSMutableString *content = [NSMutableString string];
    convert_indentationCont++;
    [content appendString:@"{\n"];
    NSMutableString *tabs = [@"" mutableCopy];
    for (int i = 0; i < convert_indentationCont - 1; i++) {
        [tabs appendString:@"    "];
    }
    for (id statement in node.statements) {
        if ([statement isKindOfClass:[ORNode class]]) {
            [self visitAllNode:statement];
            [content appendFormat:@"%@    %@\n",tabs,convertBuffer];
        }
    }
    [content appendFormat:@"%@}",tabs];
    convert_indentationCont--;
    convertBuffer = content;
}
- (void)visitFunctionNode:(ORFunctionNode *)node{
    NSMutableString *content = [NSMutableString string];
    if (node.declare) {
        if (!node.declare.var.isBlock) {
            // void x(int y){ }
            [self visitDeclaratorNode:node.declare];
            [content appendFormat:@"%@", convertBuffer];
        }else{
            // ^void (int x){ }
            [self visitDeclaratorNode:node.declare];
            [content appendFormat:@"^%@", convertBuffer];
        }
    }
    [self visitBlockNode:node.scopeImp];
    [content appendString:convertBuffer];
    convertBuffer = content;
}
- (void)visitBinaryNode:(ORBinaryNode *)node{
    NSString *operator = @"";
    switch (node.operatorType) {
        case BinaryOperatorAdd:
            operator = @"+";
            break;
        case BinaryOperatorSub:
            operator = @"-";
            break;
        case BinaryOperatorDiv:
            operator = @"/";
            break;
        case BinaryOperatorMulti:
            operator = @"*";
            break;
        case BinaryOperatorMod:
            operator = @"%";
            break;
        case BinaryOperatorShiftLeft:
            operator = @"<<";
            break;
        case BinaryOperatorShiftRight:
            operator = @">>";
            break;
        case BinaryOperatorAnd:
            operator = @"&";
            break;
        case BinaryOperatorOr:
            operator = @"|";
            break;
        case BinaryOperatorXor:
            operator = @"^";
            break;
        case BinaryOperatorLT:
            operator = @"<";
            break;
        case BinaryOperatorGT:
            operator = @">";
            break;
        case BinaryOperatorLE:
            operator = @"<=";
            break;
        case BinaryOperatorGE:
            operator = @">=";
            break;
        case BinaryOperatorNotEqual:
            operator = @"!=";
            break;
        case BinaryOperatorEqual:
            operator = @"==";
            break;
        case BinaryOperatorLOGIC_AND:
            operator = @"&&";
            break;
        case BinaryOperatorLOGIC_OR:
            operator = @"||";
            break;
    }
    [self visitAllNode:node.left];
    NSString *left = convertBuffer.copy;
    [self visitAllNode:node.right];
    NSString *right = convertBuffer.copy;
    convertBuffer = [NSString stringWithFormat:@"%@ %@ %@",left,operator,right];
}
- (void)visitUnaryNode:(ORUnaryNode *)node{
    NSString *format = @"%@";
    switch (node.operatorType) {
        case UnaryOperatorIncrementSuffix:
            format = @"%@++";
            break;
        case UnaryOperatorDecrementSuffix:
            format = @"%@--";
            break;
        case UnaryOperatorIncrementPrefix:
            format = @"++%@";
            break;
        case UnaryOperatorDecrementPrefix:
            format = @"--%@";
            break;
        case UnaryOperatorNot:
            format = @"!%@";
            break;
        case UnaryOperatorNegative:
            format = @"-%@";
            break;
        case UnaryOperatorBiteNot:
            format = @"-%@";
            break;
        case UnaryOperatorSizeOf:
            format = @"~%@";
            break;
        case UnaryOperatorAdressPoint:
            format = @"&%@";
            break;
        case UnaryOperatorAdressValue:
            format = @"*%@";
            break;
    }
    [self visitAllNode:node.value];
    convertBuffer = [NSString stringWithFormat:format,convertBuffer];
}
- (void)visitTernaryNode:(ORTernaryNode *)node{
    if (node.values.count == 1) {
        [self visitAllNode:node.expression];
        NSString *condition = convertBuffer.copy;
        [self visitAllNode:node.values.firstObject];
        NSString *value = convertBuffer.copy;
        convertBuffer = [NSString stringWithFormat:@"%@ ?: %@",condition,value];
    }else{
        [self visitAllNode:node.expression];
        NSString *condition = convertBuffer.copy;
        [self visitAllNode:node.values.firstObject];
        NSString *value1 = convertBuffer.copy;
        [self visitAllNode:node.values.lastObject];
        NSString *value2 = convertBuffer.copy;
        convertBuffer = [NSString stringWithFormat:@"%@ ? %@ : %@",condition, value1, value2];
    }
}
BOOL convert_is_left_value = true;
- (void)visitInitDeclaratorNode:(ORInitDeclaratorNode *)node{
    if (node.expression) {
        NSMutableString *str = [NSMutableString string];
        convert_is_left_value = true;
        [self visitAllNode:node.declarator];
        [str appendString:convertBuffer];
        convert_is_left_value = false;
        [str appendString:@" = "];
        [self visitAllNode:node.expression];
        [str appendString:convertBuffer];
        convertBuffer = str;
    }else{
        [self visitAllNode:node.declarator];
        convertBuffer = [NSString stringWithFormat:@"%@",convertBuffer];
    }
}
- (void)visitAssignNode:(ORAssignNode *)node{
    NSMutableString *str = [NSMutableString string];
    convert_is_left_value = true;
    [self visitAllNode:node.value];
    [str appendString:convertBuffer];
    convert_is_left_value = false;
    [str appendString:@" = "];
    [self visitAllNode:node.expression];
    [str appendString:convertBuffer];
    convertBuffer = str;
}
- (void)visitIntegerValue:(ORIntegerValue *)node{
    convertBuffer = [NSString stringWithFormat:@"%lld",node.value];
}
- (void)visitUIntegerValue:(ORUIntegerValue *)node{
    convertBuffer = [NSString stringWithFormat:@"%llu",node.value];
}
- (void)visitDoubleValue:(ORDoubleValue *)node{
    convertBuffer = [NSString stringWithFormat:@"%f",node.value];
}
- (void)visitBoolValue:(ORBoolValue *)node{
    convertBuffer = [NSString stringWithFormat:@"%@",node.value ? @"YES" : @"NO"];
}
- (void)visitValueNode:(ORValueNode *)node{
    switch (node.value_type){
        case OCValueSelector:
            convertBuffer = [NSString stringWithFormat:@"@selector(%@)",node.value];
            return;
        case OCValueVariable:
            convertBuffer = node.value;
            return;
        case OCValueSelf:
            convertBuffer =@"self";
            return;
        case OCValueSuper:
            convertBuffer = @"super";
            return;
            
        case OCValueClass:
            assert(false);
            return;
            
        case OCValueString:
            convertBuffer = [NSString stringWithFormat:@"@\"%@\"",node.value?:@""];
            return;
        case OCValueCString:
            convertBuffer = [NSString stringWithFormat:@"\"%@\"",node.value?:@""];
            return;
        case OCValueProtocol:
            convertBuffer = [NSString stringWithFormat:@"@protocol(%@)",node.value];
            return;
        case OCValueDictionary:
        {
            NSMutableArray <NSMutableArray *>*keyValuePairs = node.value;
            NSMutableArray *pairs = [NSMutableArray array];
            for (NSMutableArray *keyValue in keyValuePairs) {
                [self visitAllNode:keyValue[0]];
                NSString *key = convertBuffer.copy;
                [self visitAllNode:keyValue[1]];
                NSString *value = convertBuffer.copy;
                [pairs addObject:[NSString stringWithFormat:@"%@:%@",key,value]];
            }
            convertBuffer =[NSString stringWithFormat:@"@{%@}",[pairs componentsJoinedByString:@","]];
            return;
        }
        case OCValueArray:{
            NSMutableArray *exps = node.value;
            NSMutableArray *elements = [NSMutableArray array];
            for (ORNode * exp in exps) {
                [self visitAllNode:exp];
                [elements addObject:convertBuffer];
            }
            convertBuffer = [NSString stringWithFormat:@"@[%@]",[elements componentsJoinedByString:@","]];
            return;
        }
        case OCValueNSNumber:{
            if ([node.value isKindOfClass:[NSString class]]) {
                convertBuffer =[NSString stringWithFormat:@"@(%@)",node.value];
            }
            if ([node.value isKindOfClass:[ORNode class]]) {
                [self visitAllNode:node.value];
                convertBuffer = [NSString stringWithFormat:@"@(%@)",convertBuffer];
            }
            return;
            
        }
        case OCValueNil:
            convertBuffer = @"nil";
            return;
        case OCValueNULL:
            convertBuffer = @"NULL";
            return;
    }
    convertBuffer = @"";
}
- (void)visitSubscriptNode:(ORSubscriptNode *)node{
    [self visitAllNode:node.caller];
    NSString *caller = convertBuffer.copy;
    [self visitAllNode:node.keyExp];
    NSString *key = convertBuffer.copy;
    convertBuffer = [NSString stringWithFormat:@"%@[%@]", caller, key];
}
@end
