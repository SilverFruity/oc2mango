//
//  FuncDeclare.h
//  oc2mangoLib
//
//  Created by Jiang on 2019/5/14.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORTypeSpecial.h"
NS_ASSUME_NONNULL_BEGIN

@interface ORFuncDeclare : NSObject
@property(nonatomic,strong) ORTypeVarPair *returnType;
@property(nonatomic,strong) ORFuncVariable *var;
@end

NS_ASSUME_NONNULL_END
