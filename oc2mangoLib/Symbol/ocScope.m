//
//  ocScope.m
//  oc2mangoLib
//
//  Created by Jiang on 2021/6/24.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "ocScope.h"

@implementation ocScope
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.table = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)insert:(NSString *)name symbol:(ocSymbol *)symbol{
    if (symbol) {
        self.table[name] = symbol;
    }
}
- (ocSymbol *)lookup:(NSString *)name{
    return self.table[name];
}
@end
