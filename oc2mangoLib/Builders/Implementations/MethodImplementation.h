//
//  MethodImplementation.h
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MethodDeclare.h"
#import "FunctionImp.h"
@interface MethodImplementation : NSObject
@property (nonatomic,strong) MethodDeclare *declare;
@property (nonatomic,strong) FunctionImp *imp;
@end

