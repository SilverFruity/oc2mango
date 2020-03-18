//
//  TypeSpecial.m
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "TypeSpecial.h"

@implementation TypeSpecial
+ (instancetype)specialWithType:(TypeKind)type name:(NSString *)name{
    TypeSpecial *s = [TypeSpecial new];
    s.type = type;
    s.name = name;
    return s;
}
@end

@implementation Variable

+ (instancetype)copyFromVar:(Variable *)var{
    Variable *new = [[self class] new];
    new.ptCount = var.ptCount;
    new.varname = var.varname;
    return new;
}
@end

@implementation TypeVarPair

@end

@implementation FuncVariable

@end
