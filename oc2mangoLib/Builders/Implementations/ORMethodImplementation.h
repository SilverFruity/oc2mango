//
//  MethodImplementation.h
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORMethodDeclare.h"
#import "ORValueExpression.h"
@interface ORMethodImplementation : NSObject
@property (nonatomic,strong) ORMethodDeclare *declare;
@property (nonatomic,strong) ORBlockImp *imp;
@end

