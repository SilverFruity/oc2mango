//
//  NSArray+Functional.h
//  LiveReport
//
//  Created by Jiang on 2019/3/25.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSArray<ObjectType> (Functional)
- (instancetype)filter:(BOOL (^)(NSUInteger index,ObjectType Object))block;
- (id)map:(id (^)(NSUInteger index,ObjectType Object))block;
- (id)reduce:(id)startValue map:(id (^)(id object1,ObjectType object2))block;
@end
