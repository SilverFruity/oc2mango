//
//  PropertyDeclare.h
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "TypeSpecial.h"
NS_ASSUME_NONNULL_BEGIN

@interface PropertyDeclare : NSObject
@property(nonatomic,strong) NSMutableArray *keywords;
@property(nonatomic,strong) TypeVarPair *var;
@end

NS_ASSUME_NONNULL_END
