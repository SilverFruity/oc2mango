//
//  OCSymbol.h
//  oc2mangoLib
//
//  Created by Jiang on 2021/6/24.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ocSymbol : NSObject
@property (nonatomic, copy)NSString *name;
+ (instancetype)symbolWithName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
