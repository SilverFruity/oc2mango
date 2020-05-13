//
//  TypeSpecial.m
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "ORTypeSpecial.h"

@implementation ORTypeSpecial
+ (instancetype)specialWithType:(TypeKind)type name:(NSString *)name{
    ORTypeSpecial *s = [ORTypeSpecial new];
    s.type = type;
    s.name = name;
    return s;
}
@end

@implementation ORVariable

+ (instancetype)copyFromVar:(ORVariable *)var{
    ORVariable *new = [[self class] new];
    new.ptCount = var.ptCount;
    new.varname = var.varname;
    return new;
}
@end

@implementation ORTypeVarPair

@end

@implementation ORFuncVariable

@end
