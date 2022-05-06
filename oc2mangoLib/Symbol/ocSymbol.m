//
//  OCSymbol.m
//  oc2mangoLib
//
//  Created by Jiang on 2021/6/24.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "ocSymbol.h"

@implementation ocSymbol
+ (instancetype)symbolWithName:(NSString *)name decl:(ocDecl *)decl{
    ocSymbol *symbol = [ocSymbol new];
    symbol.name = name;
    symbol.decl = decl;
    return symbol;
}
@end
