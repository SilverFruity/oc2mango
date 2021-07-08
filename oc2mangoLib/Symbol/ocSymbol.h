//
//  OCSymbol.h
//  oc2mangoLib
//
//  Created by Jiang on 2021/6/24.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ocDecl.h"
NS_ASSUME_NONNULL_BEGIN

@interface ocSymbol : NSObject
@property (nonatomic, copy)NSString *name;
@property (nonatomic, strong)ocDecl *decl;
+ (instancetype)symbolWithName:(nullable NSString *)name decl:(nullable ocDecl *)decl;
@end

NS_ASSUME_NONNULL_END
