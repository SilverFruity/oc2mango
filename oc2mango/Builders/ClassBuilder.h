//
//  ClassBuilder.h
//  oc2mango
//
//  Created by Jiang on 2019/4/20.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "CodeBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassBuilder : NSObject <CodeBuilder>
@property NSString *className;
@property NSString *superClassName;
@property NSMutableArray *protocolNames;
@end

NS_ASSUME_NONNULL_END
