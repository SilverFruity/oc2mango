//
//  MethodBuilder.h
//  oc2mango
//
//  Created by Jiang on 2019/4/20.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "CodeBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface MethodBuilder : NSObject <CodeBuilder>
@property BOOL isClassMethod;
@property NSString *returnType;
@property NSArray *methodNames;
@property NSArray *parameterTypes;
@property NSArray *parameterNames;
@end

NS_ASSUME_NONNULL_END
