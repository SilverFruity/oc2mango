//
//  VariableDeclare.m
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "VariableDeclare.h"

@implementation VariableDeclare
- (instancetype)init
{
    self = [super init];
    
    return self;
}

- (id)copy{
    VariableDeclare *var = [VariableDeclare new];
    var.type = self.type;
    var.name = self.name;
    return var;
}
@end


