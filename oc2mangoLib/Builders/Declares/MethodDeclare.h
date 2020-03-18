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
@property(nonatomic,assign) BOOL isClassMethod;
@property(nonatomic,strong) TypeVarPair *returnType;
@property(nonatomic,strong) NSMutableArray *methodNames;
@property(nonatomic,strong) NSMutableArray <TypeVarPair *>*parameterTypes;
@property(nonatomic,strong) NSMutableArray *parameterNames;
@end

