//
//  ClassImplementation.h
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MethodImplementation.h"
@interface ClassImplementation : NSObject
@property NSString *className;
@property NSString *categoryName;
@property NSMutableArray *privateVariables;
@property NSMutableArray <MethodImplementation *>*methodImps;
@end
