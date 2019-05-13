//
//  TypeSpecial.m
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "TypeSpecial.h"

@implementation TypeSpecial
+ (instancetype)specialWithType:(SpecialType)type name:(NSString *)name{
    TypeSpecial *s = [TypeSpecial new];
    s.type = type;
    s.name = name;
    return s;
}
-(NSString *)name{
    switch (self.type){
        case SpecialTypeUChar:
        case SpecialTypeUShort:
        case SpecialTypeUInt:
        case SpecialTypeULong:
        case SpecialTypeULongLong:
            return @"uint";
        case SpecialTypeChar:
        case SpecialTypeShort:
        case SpecialTypeInt:
        case SpecialTypeLong:
        case SpecialTypeLongLong:
            return @"int";
        case SpecialTypeDouble:
        case SpecialTypeFloat:
            return @"double";
        case SpecialTypeVoid:
            return @"void";
        case SpecialTypeSEL:
            return @"SEL";
        case SpecialTypeClass:
            return @"Class";
        case SpecialTypeBOOL:
            return @"BOOL";
        case SpecialTypeId:
            return @"id";
        case SpecialTypeObject:
            return [NSString stringWithFormat:@"%@ *",_name];
        case SpecialTypeBlock:
            return @"Block";
        default:
            return @"UnknownType";
    }
}
- (NSString *)description{
    return [NSString stringWithFormat:@"%@%@", self.name,self.isPointer?@" *":@""];
}
@end
