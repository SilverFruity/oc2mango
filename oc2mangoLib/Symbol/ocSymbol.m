//
//  OCSymbol.m
//  oc2mangoLib
//
//  Created by Jiang on 2021/6/24.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "ocSymbol.h"

@implementation ocSymbol
+ (instancetype)symbolWithName:(NSString *)name{
    ocSymbol *symbol = [ocSymbol new];
    symbol.name = name;
    return symbol;
}
@end
