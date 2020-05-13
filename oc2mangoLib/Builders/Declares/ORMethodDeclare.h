//
//  MethodDeclare.h
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORTypeSpecial.h"
@interface ORMethodDeclare : NSObject
@property(nonatomic,assign) BOOL isClassMethod;
@property(nonatomic,strong) ORTypeVarPair *returnType;
@property(nonatomic,strong) NSMutableArray *methodNames;
@property(nonatomic,strong) NSMutableArray <ORTypeVarPair *>*parameterTypes;
@property(nonatomic,strong) NSMutableArray *parameterNames;
@end

