//
//  NSArray+Functional.m
//  LiveReport
//
//  Created by Jiang on 2019/3/25.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "NSArray+Functional.h"

@implementation NSArray (Functional)
- (instancetype)filter:(BOOL (^)(NSUInteger index,id Object))block{
    NSMutableArray *array1 = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(idx,obj)) {
            [array1 addObject:obj];
        }
    }];
    return array1;
}
- (instancetype)map:(id (^)(NSUInteger index,id Object))block{
    NSMutableArray *array1 = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id object = block(idx,obj);
        if (object) {
            [array1 addObject:object];
        }
    }];
    return array1;
}
- (id)reduce:(id)startValue map:(id (^)(id object1,id object2))block{
    id left = startValue;
    for (int i = 1; i< self.count; i++) {
        left = block(left,self[i]);
    }
    return left;
}
@end
