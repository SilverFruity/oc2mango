//
//  ClassImplementation.m
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "ClassImplementation.h"

@implementation ClassImplementation
- (NSString *)description
{
    return [NSString stringWithFormat:@"\n@implementation %@\n"
            "{\n"
            "%@ \n"
            "}\n"
            "%@",
            self.className,
            [self.privateVariables componentsJoinedByString:@"\n"],
            [self.methodImps componentsJoinedByString:@"\n"]];
}
@end
