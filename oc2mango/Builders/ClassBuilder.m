//
//  ClassBuilder.m
//  oc2mango
//
//  Created by Jiang on 2019/4/20.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "ClassBuilder.h"

@implementation ClassBuilder
- (NSString *)build{

    return [NSString stringWithFormat:@"class %@:%@ <%@>",self.className,self.superclass,[self.protocolNames componentsJoinedByString:@","]];;
}
@end
