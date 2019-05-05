//
//  FunctionImp.h
//  oc2mango
//
//  Created by Jiang on 2019/4/22.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Statement.h"
#import "Expression.h"
@interface FunctionImp : NSObject
@property NSMutableArray <id <Expression>>* expressions;
@property NSMutableArray <Statement  *>* statements;
@end
