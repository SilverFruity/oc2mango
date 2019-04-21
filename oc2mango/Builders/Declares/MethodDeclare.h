//
//  MethodDeclare.h
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeSpecial.h"
@interface MethodDeclare : NSObject
@property BOOL isClassMethod;
@property TypeSpecial *returnType;
@property NSMutableArray *methodNames;
@property NSMutableArray <TypeSpecial *>*parameterTypes;
@property NSMutableArray *parameterNames;
@end

