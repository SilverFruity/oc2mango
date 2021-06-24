//
//  ocScope.h
//  oc2mangoLib
//
//  Created by Jiang on 2021/6/24.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ocSymbol.h"
NS_ASSUME_NONNULL_BEGIN

@interface ocScope : NSObject
@property (nonatomic, strong)NSMutableDictionary <NSString *, ocSymbol *>*table;
@property (nonatomic, strong)ocScope *parent;
- (void)insert:(NSString *)name symbol:(ocSymbol *)symbol;
- (ocSymbol *)lookup:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
