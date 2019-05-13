//
//  MethodImplementation.m
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "MethodImplementation.h"

@implementation MethodImplementation
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@\n%@", self.declare,self.imp];
}
@end
