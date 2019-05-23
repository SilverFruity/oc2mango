//
//  Convert.m
//  oc2mangoLib
//
//  Created by Jiang on 2019/5/18.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "Convert.h"
#import "MakeDeclare.h"
@implementation Convert
- (NSString *)convert:(id)content{
    if ([content isKindOfClass:[OCClass class]]) {
        return [self convertOCClass:content];
    }else if ([content conformsToProtocol:@protocol(Expression)]){
        return [self convertExpression:content];
    }else if ([content isKindOfClass:[Statement class]]){
        return [self convertStatement:content];
    }else if ([content isKindOfClass:[MethodImplementation class]]){
        return [self convertMethodImp:content];
    }
    NSAssert(NO, @"%s %d ",__FILE__,__LINE__);
    return @"";
}
- (NSString *)convertOCClass:(OCClass *)occlass{
    NSMutableString *content = [NSMutableString string];
    [content appendFormat:@"class %@:%@",occlass.className,occlass.superClassName];
    [content appendString:@"{\n"];
    for (PropertyDeclare *prop in occlass.properties) {
        [content appendString:[self convertPropertyDeclare:prop]];
    }
    for (MethodImplementation *imp in occlass.methods) {
        [content appendString:[self convertMethodImp:imp]];
    }
    [content appendString:@"\n}\n"];
    return content;
}
- (NSString *)convertExpression:(id <Expression>)exp{
    if ([exp isKindOfClass:[DeclareExpression class]]) {
        return [self convertDeclareExp:exp];
    }else if ([exp isKindOfClass:[AssignExpression class]]) {
        return [self convertAssginExp:exp];
    }else if ([exp isKindOfClass:[OCValue class]]){
        return [self convertOCValue:exp];
    }
    return @"";
}
- (NSString *)convertStatement:(Statement *)statement{
    if ([Statement isKindOfClass:[IfStatement class]]) {
        return [self convertIfStatement:(IfStatement *) statement];
    }else if([statement isKindOfClass:[WhileStatement class]]){
        return [self convertWhileStatement:(WhileStatement *) statement];
    }else if([statement isKindOfClass:[DoWhileStatement class]]){
        return [self convertDoWhileStatement:(DoWhileStatement *) statement];
    }else if ([statement isKindOfClass:[SwitchStatement class]]) {
        return [self convertSwitchStatement:(SwitchStatement *) statement];
    } else if ([statement isKindOfClass:[ForStatement class]]) {
        return [self convertForStatement:(ForStatement *) statement];
    } else if ([statement isKindOfClass:[ForInStatement class]]) {
        return [self convertForInStatement:(ForInStatement *) statement];
    }
    return @"";
}

- (NSString *)convertTypeSpecial:(TypeSpecial *)typeSpecial{
    NSMutableString *result = [NSMutableString string];
    switch (typeSpecial.type){
        case SpecialTypeUChar:
        case SpecialTypeUShort:
        case SpecialTypeUInt:
        case SpecialTypeULong:
        case SpecialTypeULongLong:
            [result appendString:@"uint"]; break;
        case SpecialTypeChar:
        case SpecialTypeShort:
        case SpecialTypeInt:
        case SpecialTypeLong:
        case SpecialTypeLongLong:
            [result appendString:@"int"]; break;
        case SpecialTypeDouble:
        case SpecialTypeFloat:
            [result appendString:@"double"]; break;
        case SpecialTypeVoid:
            [result appendString:@"void"]; break;
        case SpecialTypeSEL:
            [result appendString:@"SEL"]; break;
        case SpecialTypeClass:
            [result appendString:@"Class"]; break;
        case SpecialTypeBOOL:
            [result appendString:@"BOOL"]; break;
        case SpecialTypeId:
            [result appendString:@"id"]; break;
        case SpecialTypeObject:
            [result appendString:typeSpecial.name]; break;
        case SpecialTypeBlock:
            [result appendString:@"Block"]; break;
        default:
            [result appendString:@"UnknownType"]; break;
    }
    if (typeSpecial.isPointer) {
        [result appendString:@" *"];
    }else{
        [result appendString:@" "];
    }
    return result;
}
- (NSString *)convertVariableDeclare:(VariableDeclare *)varDecl{
    return [NSString stringWithFormat:@"%@%@",[self convertTypeSpecial:varDecl.type],varDecl.name];;
}
- (NSString *)convertPropertyDeclare:(PropertyDeclare *)propertyDecl{
    return @"";
}
- (NSString *)convertMethoDeclare:(MethodDeclare *)methodDecl{
    return @"";
}
- (NSString *)convertMethodImp:(MethodImplementation *)methodImp{
    return @"";
}
- (NSString *)convertFuncDeclare:(FuncDeclare *)funcDecl{
    if (funcDecl.variables.count > 0){
        if ([funcDecl.variables.firstObject isKindOfClass:[VariableDeclare class]]){
            return [NSString stringWithFormat:@"%@(%@)",[self convertTypeSpecial:funcDecl.returnType],[self convertVariableDeclares:funcDecl.variables]];
        }else if([funcDecl.variables.firstObject isKindOfClass:[TypeSpecial class]]){
            return [NSString stringWithFormat:@"%@(%@)",[self convertTypeSpecial:funcDecl.returnType],[self convertTypeSpecails:funcDecl.variables]];
        }
    } else{
        return [NSString stringWithFormat:@"%@()",[self convertTypeSpecial:funcDecl.returnType]];
    }
    return @"";
}


- (NSString *)convertFuncImp:(FunctionImp *)imp{
    NSMutableString *content = [NSMutableString string];
    [content appendString:@"{\n"];
    for (id statement in imp.statements) {
        if ([statement conformsToProtocol:@protocol(Expression)]) {
            [content appendFormat:@"%@;\n",[self convertExpression:statement]];
        }else if ([statement isKindOfClass:[Statement class]]){
            [content appendFormat:@"%@\n",[self convertStatement:statement]];
        }
    }
    [content appendString:@"}"];
    return content;
}

- (NSString *)convertDeclareExp:(DeclareExpression *)exp{
    if (exp.expression) {
        return [NSString stringWithFormat:@"%@ = %@",[self convertVariableDeclare:exp.declare],[self convertExpression:exp.expression]];
    }else{
        return [NSString stringWithFormat:@"%@",[self convertVariableDeclare:exp.declare]];
    }
}
- (NSString *)convertAssginExp:(AssignExpression *)exp{
    NSString *operator = @"=";
    return [NSString stringWithFormat:@"%@ %@ %@",[self convertOCValue:exp.value],operator,[self convertExpression:exp.expression]];
}

- (NSString *)convertOCValue:(OCValue *)value{
    switch (value.value_type){
        case OCValueClassType:
        case OCValueSelector:
        case OCValueInt:
        case OCValueDouble:
        case OCValueConvert:
        case OCValueVariable:
            return value.value;
            
        case OCValueSelf:
            return @"self";
        case OCValueSuper:
            return @"super";

        case OCValueString:
            return [NSString stringWithFormat:@"@\"%@\"",value.value];
        case OCValueCString:
            return [NSString stringWithFormat:@"\"%@\"",value.value];
        case OCValueProtocol:
            return [NSString stringWithFormat:@"@protocol(%@)",value.value];
        case OCValueDictionary:break;
        case OCValueArray:break;
        case OCValueNSNumber:
            return [NSString stringWithFormat:@"@(%@)",value.value];

        case OCValueBlock:
        {
            BlockImp *imp = (BlockImp *)value;
            return [NSString stringWithFormat:@"^%@%@", [self convertFuncDeclare:imp.declare],[self convertFuncImp:imp.funcImp]];
        }
        case OCValueNil:
            return @"nil";
        case OCValueNULL:
            return @"NULL";
        case OCValuePointValue:
            return [NSString stringWithFormat:@"*%@",value.value];
        case OCValueVarPoint:
            return [NSString stringWithFormat:@"&%@",value.value];
        case OCValueMethodCall:
            return [self convertOCMethodCall:(OCMethodCall *) value];
        case OCValueFuncCall:{
            CFuncCall *call = (CFuncCall *)value;
            return [NSString stringWithFormat:@"%@(%@)",call.name,[self convertExpressionList:call.expressions]];
        }

    }
    return @"";
}
- (NSString *)convertOCMethodCall:(OCMethodCall *)call{
    if ([call.element isKindOfClass:[OCMethodCallGetElement class]]) {
        return [NSString stringWithFormat:@"%@%@",[self convertExpression:call.caller],[self convertOCMethodGetElement:call.element]];
    }else{
        return [NSString stringWithFormat:@"%@%@",[self convertExpression:call.caller],[self convertOCMethodNormalElement:call.element]];
    }
}
- (NSString *)convertOCMethodGetElement:(OCMethodCallGetElement *)element{
    if (element.values.count == 0) {
        return [NSString stringWithFormat:@".%@",element.name];
    }else{
        return [NSString stringWithFormat:@".%@(%@)",element.name,[self convertExpressionList:element.values]];
    }
    
}
- (NSString *)convertOCMethodNormalElement:(OCMethodCallNormalElement *)element{
    NSMutableString *methodName = [[element.names componentsJoinedByString:@":"] mutableCopy];
    if (element.values.count > 0)
        [methodName appendString:@":"];
    return [NSString stringWithFormat:@".%@(%@)",methodName,[self convertExpressionList:element.values]];;
}

- (NSString *)convertIfStatement:(IfStatement *)statement{
    return @"";
}
- (NSString *)convertWhileStatement:(WhileStatement *)statement{
    NSMutableString *content = [NSMutableString string];
    [content appendFormat:@"while(%@)\n",[self convertExpression:statement.condition]];
    [content appendString:[self convertFuncImp:statement.funcImp]];
    return content;
}
- (NSString *)convertDoWhileStatement:(DoWhileStatement *)statement{
    return @"";
}
- (NSString *)convertSwitchStatement:(SwitchStatement *)statement{
    return @"";
}
- (NSString *)convertForStatement:(ForStatement *)statement{
    return @"";
}
- (NSString *)convertForInStatement:(ForInStatement *)statement{
    return @"";
}
- (NSString * )convertExpressionList:(NSArray *)list{    
    NSMutableArray *array = [NSMutableArray array];
    for (id <Expression> exp in list){
        [array addObject:[self convertExpression:exp]];
    }
    return [array componentsJoinedByString:@","];
}
- (NSString * )convertVariableDeclares:(NSArray *)list{
    NSMutableArray *array = [NSMutableArray array];
    for (VariableDeclare * declare in list){
        [array addObject:[self convertVariableDeclare:declare]];
    }
    return [array componentsJoinedByString:@","];
}
- (NSString * )convertTypeSpecails:(NSArray *)list{
    NSMutableArray *array = [NSMutableArray array];
    for (TypeSpecial * special in list){
        [array addObject:[self convertTypeSpecial:special]];
    }
    return [array componentsJoinedByString:@","];
}
@end
