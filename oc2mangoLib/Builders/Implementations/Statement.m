//
//  Statement.m
//  oc2mango
//
//  Created by Jiang on 2019/4/22.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "Statement.h"

@implementation Statement

@end

@implementation IfStatement
- (NSString *)description{
    NSString *str = [NSString string];
    IfStatement *start = self;
    while (start) {
        if (start.condition) {
            if (start.last) {
                str = [NSString stringWithFormat:@"elseif(%@)%@\n%@",start.condition,start.funcImp,str];
            }else{
                str = [NSString stringWithFormat:@"if(%@)%@\n%@",start.condition,start.funcImp,str];
            }
        }else{
            str = [NSString stringWithFormat:@"%@else%@\n",str,start.funcImp];
        }
        
        start = start.last;
    }
    return str;
}
@end

@implementation WhileStatement

@end

@implementation DoWhileStatement

@end

@implementation CaseStatement

@end

@implementation SwitchStatement
- (instancetype)init
{
    self = [super init];
    self.cases = [NSMutableArray array];
    return self;
}
@end

@implementation ForStatement

@end

@implementation ForInStatement

@end
