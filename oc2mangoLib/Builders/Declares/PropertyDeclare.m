//
//  PropertyDeclare.m
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "PropertyDeclare.h"

@implementation PropertyDeclare

- (VariableDeclare *)privateVar{
    if (!_privateVar) {
        _privateVar = [self.var copy];
        _privateVar.name = [NSString stringWithFormat:@"_%@",self.var.name];
    }
    return _privateVar;
}
@end
