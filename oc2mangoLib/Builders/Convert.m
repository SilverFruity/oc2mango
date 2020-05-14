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
    if ([content isKindOfClass:[ORClass class]]) {
        return [self convertOCClass:content];
    }else if ([content isKindOfClass:[ORExpression class]]){
        NSMutableString *result = [[self convertExpression:content] mutableCopy];
        if ([content isKindOfClass:[ORAssignExpression class]] || [content isKindOfClass:[ORDeclareExpression class]]) {
            [result appendString:@";"];
        }
        return result;
    }else if ([content isKindOfClass:[ORStatement class]]){
        return [self convertStatement:content];
    }
    NSAssert(NO, @"%s %d ",__FILE__,__LINE__);
    return @"";
}
- (NSString *)convertOCClass:(ORClass *)occlass{
    NSMutableString *content = [NSMutableString string];
    [content appendFormat:@"class %@:%@",occlass.className,occlass.superClassName];
    if (occlass.protocols.count > 0) {
        [content appendFormat:@"<%@>",[occlass.protocols componentsJoinedByString:@","]];
    }
    [content appendString:@"{\n"];
    for (ORPropertyDeclare *prop in occlass.properties) {
        [content appendString:[self convertPropertyDeclare:prop]];
    }
    for (ORMethodImplementation *imp in occlass.methods) {
        [content appendString:[self convertMethodImp:imp]];
    }
    [content appendString:@"\n}\n"];
    return content;
}
- (NSString *)convertExpression:(ORExpression *)exp{
    if ([exp isKindOfClass:[ORDeclareExpression class]]) {
        return [self convertDeclareExp:(ORDeclareExpression *)exp];
    }else if ([exp isKindOfClass:[ORAssignExpression class]]) {
        return [self convertAssginExp:(ORAssignExpression *)exp];
    }else if ([exp isKindOfClass:[ORValueExpression class]]){
        return [self convertOCValue:(ORValueExpression *)exp];
    }else if ([exp isKindOfClass:[ORBinaryExpression class]]){
        return [self convertBinaryExp:(ORBinaryExpression *)exp];
    }else if ([exp isKindOfClass:[ORUnaryExpression class]]){
        return [self convertUnaryExp:(ORUnaryExpression *)exp];
    }else if ([exp isKindOfClass:[ORTernaryExpression class]]){
        return [self convertTernaryExp:(ORTernaryExpression *)exp];
    }
    return @"";
}
- (NSString *)convertStatement:(ORStatement *)statement{
    if ([statement isKindOfClass:[ORIfStatement class]]) {
        return [self convertIfStatement:(ORIfStatement *) statement];
    }else if([statement isKindOfClass:[ORWhileStatement class]]){
        return [self convertWhileStatement:(ORWhileStatement *) statement];
    }else if([statement isKindOfClass:[ORDoWhileStatement class]]){
        return [self convertDoWhileStatement:(ORDoWhileStatement *) statement];
    }else if ([statement isKindOfClass:[ORSwitchStatement class]]) {
        return [self convertSwitchStatement:(ORSwitchStatement *) statement];
    } else if ([statement isKindOfClass:[ORForStatement class]]) {
        return [self convertForStatement:(ORForStatement *) statement];
    } else if ([statement isKindOfClass:[ORForInStatement class]]) {
        return [self convertForInStatement:(ORForInStatement *) statement];
    } else if ([statement isKindOfClass:[ORReturnStatement class]]) {
        return [self convertReturnStatement:(ORReturnStatement *) statement];
    } else if ([statement isKindOfClass:[ORBreakStatement class]]) {
        return [self convertBreakStatement:(ORBreakStatement *) statement];
    } else if ([statement isKindOfClass:[ORContinueStatement class]]) {
        return [self convertContinueStatement:(ORContinueStatement *) statement];
    }
    return @"";
}

- (NSString *)convertTypeSpecial:(ORTypeSpecial *)typeSpecial{
    NSMutableString *result = [NSMutableString string];
    switch (typeSpecial.type){
        case TypeUChar:
        case TypeUShort:
        case TypeUInt:
        case TypeULong:
        case TypeULongLong:
            [result appendString:@"uint"]; break;
        case TypeChar:
        case TypeShort:
        case TypeInt:
        case TypeLong:
        case TypeLongLong:
            [result appendString:@"int"]; break;
        case TypeDouble:
        case TypeFloat:
            [result appendString:@"double"]; break;
        case TypeVoid:
            [result appendString:@"void"]; break;
        case TypeSEL:
            [result appendString:@"SEL"]; break;
        case TypeClass:
            [result appendString:@"Class"]; break;
        case TypeBOOL:
            [result appendString:@"BOOL"]; break;
        case TypeId:
            [result appendString:@"id"]; break;
        case TypeObject:
            [result appendString:typeSpecial.name]; break;
        case TypeBlock:
            [result appendString:@"Block"]; break;
        
        case TypeEnum:
            [result appendString:@"int"]; break;
            break;
            break;
        case TypeStruct:
            [result appendString:typeSpecial.name]; break;
            break;
            break;
        default:
            [result appendString:@"UnKnownType"];
            break;
    }
    [result appendString:@" "];

    return result;
}

- (NSString *)convertPropertyDeclare:(ORPropertyDeclare *)propertyDecl{
    
    return [NSString stringWithFormat:@"@property(%@)%@;\n",[propertyDecl.keywords componentsJoinedByString:@","],[self convertDeclareTypeVarPair:propertyDecl.var]];
    return @"";
}
- (NSString *)convertMethoDeclare:(ORMethodDeclare *)methodDecl{
    NSString *methodName = @"";
    if (methodDecl.parameterNames.count == 0) {
        methodName = methodDecl.methodNames.firstObject;
    }else{
        NSMutableArray *list = [NSMutableArray array];
        for (int i = 0; i < methodDecl.parameterNames.count; i++) {
            [list addObject:[NSString stringWithFormat:@"%@:(%@)%@",
                             methodDecl.methodNames[i],
                             [self convertDeclareTypeVarPair:methodDecl.parameterTypes[i]],
                             methodDecl.parameterNames[i]]];
        }
        methodName = [list componentsJoinedByString:@" "];
    }
    return [NSString stringWithFormat:@"%@(%@)%@",methodDecl.isClassMethod?@"+":@"-",[self convertDeclareTypeVarPair:methodDecl.returnType],methodName];
}
- (NSString *)convertMethodImp:(ORMethodImplementation *)methodImp{
    return [NSString stringWithFormat:@"\n%@%@",[self convertMethoDeclare:methodImp.declare],[self convertBlockImp:methodImp.imp]];
}
- (NSString *)convertFuncDeclare:(ORFuncDeclare *)funcDecl{
    return [NSString stringWithFormat:@"%@%@",[self convertDeclareTypeVarPair:funcDecl.returnType],[self convertVariable:funcDecl.funVar]];;
}

int indentationCont = 0;
- (NSString *)convertBlockImp:(ORBlockImp *)imp{
    NSMutableString *content = [NSMutableString string];
    if (imp.declare) {
        if (imp.declare.funVar.ptCount > 0) {
            // void x(int y){ }
            [content appendFormat:@"%@", [self convertFuncDeclare:imp.declare]];
        }else{
            // ^void (int x){ }
            [content appendFormat:@"^%@", [self convertFuncDeclare:imp.declare]];
        }
    }
    indentationCont++;
    [content appendString:@"{\n"];
    NSMutableString *tabs = [@"" mutableCopy];
    for (int i = 0; i < indentationCont - 1; i++) {
        [tabs appendString:@"    "];
    }
    for (id statement in imp.statements) {
        if ([statement isKindOfClass:[ORExpression class]]) {
            [content appendFormat:@"%@    %@;\n",tabs,[self convertExpression:statement]];
        }else if ([statement isKindOfClass:[ORStatement class]]){
            [content appendFormat:@"%@    %@\n",tabs,[self convertStatement:statement]];
        }
    }
    [content appendFormat:@"%@}",tabs];
    indentationCont--;
    return content;
    return @"";
}
- (NSString *)convertBinaryExp:(ORBinaryExpression *)exp{
    NSString *operator = @"";
    switch (exp.operatorType) {
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
    return [NSString stringWithFormat:@"%@ %@ %@",[self convertExpression:exp.left],operator,[self convertExpression:exp.right]];
}
- (NSString *)convertUnaryExp:(ORUnaryExpression *)exp{
    NSString *format = @"%@";
    switch (exp.operatorType) {
        
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
    return [NSString stringWithFormat:format,[self convertExpression:exp.value]];
}
- (NSString *)convertTernaryExp:(ORTernaryExpression *)exp{
    if (exp.values.count == 1) {
        return [NSString stringWithFormat:@"%@ ?: %@",[self convertExpression:exp.expression],[self convertExpression:exp.values.firstObject]];
    }else{
        return [NSString stringWithFormat:@"%@ ? %@ : %@",[self convertExpression:exp.expression],[self convertExpression:exp.values.firstObject],[self convertExpression:exp.values.lastObject]];
    }
}
- (NSString *)convertDeclareExp:(ORDeclareExpression *)exp{
    if (exp.expression) {
        return [NSString stringWithFormat:@"%@ = %@",[self convertDeclareTypeVarPair:exp.pair],[self convertExpression:exp.expression]];
    }else{
        return [NSString stringWithFormat:@"%@",[self convertDeclareTypeVarPair:exp.pair]];
    }
    return @"";
}
- (NSString *)convertAssginExp:(ORAssignExpression *)exp{
    NSString *operator = @"=";
    return [NSString stringWithFormat:@"%@ %@ %@",[self convertOCValue:exp.value],operator,[self convertExpression:exp.expression]];
}

- (NSString *)convertOCValue:(ORValueExpression *)value{
    switch (value.value_type){
        case OCValueSelector:
        case OCValueInt:
        case OCValueDouble:
        case OCValueBOOL:
        case OCValueVariable:
            return value.value;
            
        case OCValueSelf:
            return @"self";
        case OCValueSuper:
            return @"super";

        case OCValueString:
            return [NSString stringWithFormat:@"@\"%@\"",value.value?:@""];
        case OCValueCString:
            return [NSString stringWithFormat:@"\"%@\"",value.value?:@""];
        case OCValueProtocol:
            return [NSString stringWithFormat:@"@protocol(%@)",value.value];
        case OCValueDictionary:
        {
            NSMutableArray <NSMutableArray *>*keyValuePairs = value.value;
            NSMutableArray *pairs = [NSMutableArray array];
            for (NSMutableArray *keyValue in keyValuePairs) {
                [pairs addObject:[NSString stringWithFormat:@"%@:%@",[self convertExpression:keyValue[0]],[self convertExpression:keyValue[1]]]];
            }
            return [NSString stringWithFormat:@"@{%@}",[pairs componentsJoinedByString:@","]];
        }
        case OCValueArray:{
            NSMutableArray *exps = value.value;
            NSMutableArray *elements = [NSMutableArray array];
            for (ORExpression * exp in exps) {
                [elements addObject:[self convertExpression:exp]];
            }
            return [NSString stringWithFormat:@"@[%@]",[elements componentsJoinedByString:@","]];
        }
        case OCValueNSNumber:{
            if ([value.value isKindOfClass:[NSString class]]) {
                return [NSString stringWithFormat:@"@(%@)",value.value];
            }
            if ([value.value isKindOfClass:[ORValueExpression class]]) {
                return [NSString stringWithFormat:@"@(%@)",[self convertOCValue:value.value]];
            }
        }
            

        case OCValueBlock:
        {
            return [self convertBlockImp:(ORBlockImp *)value];
        }
        case OCValueNil:
            return @"nil";
        case OCValueNULL:
            return @"NULL";
        case OCValueMethodCall:
            return [self convertOCMethodCall:(ORMethodCall *) value];
        case OCValueFuncCall:{
            return [self convertFunCall:(ORCFuncCall *)value];
        }
        case OCValueCollectionGetValue:
        {
            ORSubscriptExpression *collection = (ORSubscriptExpression *)value;
            return [NSString stringWithFormat:@"%@[%@]",[self convertExpression:collection.caller],[self convertExpression:collection.keyExp]];
        }
    }
    return @"";
}
- (NSString *)convertFunCall:(ORCFuncCall *)call{
    // FIX: make.left.equalTo(superview.mas_left) to make.left.equalTo()(superview.mas_left)
    // FIX: x.left(a) to x.left()(a)
    if ([call.caller isKindOfClass:[ORMethodCall class]] && [(ORMethodCall *)call.caller isDot]){
        return [NSString stringWithFormat:@"%@()(%@)",[self convertExpression:call.caller],[self convertExpressionList:call.expressions]];
    }
    return [NSString stringWithFormat:@"%@(%@)",[self convertExpression:call.caller],[self convertExpressionList:call.expressions]];
}
- (NSString *)convertOCMethodCall:(ORMethodCall *)call{
    NSMutableString *methodName = [[call.names componentsJoinedByString:@":"] mutableCopy];
    NSString *sel;
    if (call.values.count == 0) {
        if (call.isDot) {
            sel = [NSString stringWithFormat:@".%@",methodName];
        }else{
            sel = [NSString stringWithFormat:@".%@()",methodName];
        }
    }else{
        sel = [NSString stringWithFormat:@".%@:(%@)",methodName,[self convertExpressionList:call.values]];
    }
    return [NSString stringWithFormat:@"%@%@",[self convertExpression:call.caller],sel];
}
- (NSString *)convertIfStatement:(ORIfStatement *)statement{
    NSString *content = @"";
    while (statement.last) {
        if (!statement.condition) {
           content = [NSString stringWithFormat:@"%@else%@",content,[self convertBlockImp:statement.funcImp]];
        }else{
           content = [NSString stringWithFormat:@"else if(%@)%@%@",[self convertExpression:statement.condition],[self convertBlockImp:statement.funcImp],content];
        }
        statement = statement.last;
    }
    content = [NSString stringWithFormat:@"if(%@)%@%@",[self convertExpression:statement.condition],[self convertBlockImp:statement.funcImp],content];
    return content;
}
- (NSString *)convertWhileStatement:(ORWhileStatement *)statement{
    NSMutableString *content = [NSMutableString string];
    [content appendFormat:@"while(%@)",[self convertExpression:statement.condition]];
    [content appendString:[self convertBlockImp:statement.funcImp]];
    return content;
}
- (NSString *)convertDoWhileStatement:(ORDoWhileStatement *)statement{
    return [NSString stringWithFormat:@"do%@while(%@)",[self convertBlockImp:statement.funcImp],[self convertExpression:statement.condition]];
}
- (NSString *)convertSwitchStatement:(ORSwitchStatement *)statement{
    return [NSString stringWithFormat:@"switch(%@){\n%@}",[self convertExpression:statement.value],[self convertCaseStatements:statement.cases]];
}
- (NSString *)convertCaseStatements:(NSArray *)cases{
    NSMutableString *content = [NSMutableString string];
    for (ORCaseStatement *statement in cases) {
        if (statement.value) {
            [content appendFormat:@"case %@:%@\n",[self convertExpression:statement.value],[self convertBlockImp:statement.funcImp]];
        }else{
            [content appendFormat:@"default:%@\n",[self convertBlockImp:statement.funcImp]];
        }
    }
    return content;
}
- (NSString *)convertForStatement:(ORForStatement *)statement{
    NSMutableString *content = [@"for (" mutableCopy];
    [content appendFormat:@"%@; ",[self convertExpressionList:statement.varExpressions]];
    [content appendFormat:@"%@; ",[self convertExpression:statement.condition]];
    [content appendFormat:@"%@)",[self convertExpressionList:statement.expressions]];
    [content appendFormat:@"%@",[self convertBlockImp:statement.funcImp]];
    return content;
}
- (NSString *)convertForInStatement:(ORForInStatement *)statement{
    return [NSString stringWithFormat:@"for (%@ in %@)%@",[self convertDeclareExp:statement.expression],[self convertExpression:statement.value],[self convertBlockImp:statement.funcImp]];
}
- (NSString *)convertReturnStatement:(ORReturnStatement *)statement{
    return [NSString stringWithFormat:@"return %@;",[self convertExpression:statement.expression]];
}
- (NSString *)convertBreakStatement:(ORBreakStatement *) statement{
    return @"break;";
}
- (NSString *)convertContinueStatement:(ORContinueStatement *) statement{
    return @"continue;";
}
- (NSString * )convertExpressionList:(NSArray *)list{    
    NSMutableArray *array = [NSMutableArray array];
    for (ORExpression * exp in list){
        [array addObject:[self convertExpression:exp]];
    }
    return [array componentsJoinedByString:@","];
}
- (NSString *)convertVariable:(ORVariable *)var{
    NSMutableString *result = [@"" mutableCopy];
    for (int i = 0; i < var.ptCount; i++) {
        [result appendString:@"*"];
    }
    if ([var isKindOfClass:[ORFuncVariable class]]) {
        ORFuncVariable *funVar = (ORFuncVariable *)var;
        if (funVar.pairs.count > 0){
            if (funVar.varname) {
                [result appendFormat:@"%@(%@)",funVar.varname,[self convertDeclareTypeVarPairs:funVar.pairs]];
            }else{
                [result appendFormat:@"(%@)",[self convertDeclareTypeVarPairs:funVar.pairs]];
            }
        } else if (funVar.ptCount > 0){
            [result appendFormat:@"%@()",funVar.varname];
        }
    }else if (var.varname){
        [result appendString:var.varname];
    }
    return result;
}
- (NSString *)convertTypeVarPair:(ORTypeVarPair *)pair{
    NSString *type = pair.type ? [self convertTypeSpecial:pair.type] : @"void ";
    return [NSString stringWithFormat:@"%@%@",type,[self convertVariable:pair.var]];
}
- (NSString *)convertDeclareTypeVarPair:(ORTypeVarPair *)pair{
    if ([pair.var isKindOfClass:[ORFuncVariable class]]){
        if (pair.var.varname == nil){
            return [NSString stringWithFormat:@"Block"];
        }
        if (pair.var.ptCount > 0) {
            return [NSString stringWithFormat:@"Point %@", pair.var.varname];
        }
        if (pair.var.ptCount < 0) {
            return [NSString stringWithFormat:@"Block %@", pair.var.varname];
        }
    }else{
        switch (pair.type.type){
            case TypeUChar:
            case TypeUShort:
            case TypeUInt:
            case TypeULong:
            case TypeULongLong:
            case TypeChar:
            case TypeShort:
            case TypeInt:
            case TypeLong:
            case TypeFloat:
            case TypeDouble:
            case TypeBOOL:
            case TypeLongLong:{
                if (pair.var.ptCount > 0){
                    return [NSString stringWithFormat:@"Point %@",pair.var.varname];
                }
                break;
            }
            default:
                break;
        }
    }
        
    return [self convertTypeVarPair:pair];
}
- (NSString *)convertDeclareTypeVarPairs:(NSArray *)list{
    NSMutableArray *array = [NSMutableArray array];
    for (ORTypeVarPair * pair in list){
        [array addObject:[self convertDeclareTypeVarPair:pair]];
    }
    return [array componentsJoinedByString:@","];
}
@end
