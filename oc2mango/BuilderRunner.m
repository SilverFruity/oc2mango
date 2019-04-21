//
//  BuilderRunner.m
//  oc2mango
//
//  Created by Jiang on 2019/4/20.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "BuilderRunner.h"

@implementation BuilderRunner
+ (void)run:(id<CodeBuilder>)builder{
    printf("%s \n",[builder build].UTF8String);
}
@end
