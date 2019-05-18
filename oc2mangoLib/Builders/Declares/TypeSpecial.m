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
@end
