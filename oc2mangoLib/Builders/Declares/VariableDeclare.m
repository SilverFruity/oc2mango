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
- (NSString *)description{
    return [NSString stringWithFormat:@"%@ %@",self.type.description,self.name];
}
- (id)copy{
    VariableDeclare *var = [VariableDeclare new];
    var.type = self.type;
    var.name = self.name;
    var.expression = self.expression;
    return var;
}
@end


