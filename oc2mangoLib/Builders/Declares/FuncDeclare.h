//
//  FuncDeclare.h
//  oc2mangoLib
//
//  Created by Jiang on 2019/5/14.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VariableDeclare.h"
NS_ASSUME_NONNULL_BEGIN

@interface FuncDeclare : NSObject
@property(nonatomic,strong) TypeSpecial *returnType;
@property(nonatomic,strong) NSMutableArray  *variables;
@end

NS_ASSUME_NONNULL_END
