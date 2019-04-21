//
//  PropertyBuilder.m
//  oc2mango
//
//  Created by Jiang on 2019/4/20.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "PropertyBuilder.h"

@implementation PropertyBuilder
- (NSString *)build{
    return [NSString stringWithFormat:@"@property (%@) %@ %@", [self.kewords componentsJoinedByString:@","],self.typeName,self.varName];
}
@end
