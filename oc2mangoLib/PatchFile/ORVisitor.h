//
//  ORVisitor.h
//  ORPatchFile
//
//  Created by Jiang on 2021/6/22.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORCoreHeader.h"
#import "RunnerClasses.h"

NS_ASSUME_NONNULL_BEGIN
@interface ORVisitor : NSObject
- (void)visitAllNode:(ORNode *)node;
- (void)visitEmptyNode:(ORNode *)node;
#define VISITOR_METHOD(node_name)\
- (void)visit##node_name:(OR##node_name *)node;
NODE_LIST(VISITOR_METHOD);
#undef VISITOR_METHOD
@end

NS_ASSUME_NONNULL_END
