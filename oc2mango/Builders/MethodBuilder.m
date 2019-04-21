//
//  MethodBuilder.m
//  oc2mango
//
//  Created by Jiang on 2019/4/20.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "MethodBuilder.h"

@implementation MethodBuilder
- (NSString *)build{
    NSMutableString *string = [NSMutableString string];
    if (self.methodNames.count == 1) {
        [string appendString:self.methodNames.firstObject];
    }else{
        for (int i = 0 ; i < self.methodNames.count; i++) {
            [string appendFormat:@"%@:(%@)%@ ",
             self.methodNames[i],self.parameterTypes[i],self.parameterNames[i]];
        }
    }
    return [NSString stringWithFormat:@"%@(%@)%@",self.isClassMethod?@"+":@"-",self.returnType,string];
}
@end
