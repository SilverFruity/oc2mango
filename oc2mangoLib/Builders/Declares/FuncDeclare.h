//
//  FuncDeclare.h
//  oc2mangoLib
//
//  Created by Jiang on 2019/5/14.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeSpecial.h"
NS_ASSUME_NONNULL_BEGIN

@interface FuncDeclare : NSObject
@property(nonatomic,strong) TypeVarPair *returnType;
@property(nonatomic,strong) FuncVariable *var;
@end

NS_ASSUME_NONNULL_END
