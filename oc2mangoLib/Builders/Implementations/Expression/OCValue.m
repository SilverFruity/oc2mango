//
// Created by Jiang on 2019-05-06.
// Copyright (c) 2019 SilverFruity. All rights reserved.
//

#import "OCValue.h"


@implementation OCValue {

}
- (NSString *)description{
    return [NSString stringWithFormat:@"<OCValue:%d>",self.value_type];
}
@end
@implementation OCMethodCallNormalElement
- (instancetype)init {
    self = [super init];
    self.names = [NSMutableArray array];
    self.values = [NSMutableArray array];
    return self;
}
@end


@implementation OCMethodCallGetElement
- (instancetype)init {
    self = [super init];
    self.values = [NSMutableArray array];
    return self;
}
@end

@implementation OCMethodCall
@end

@implementation BlockImp
- (instancetype)init
{
    self = [super init];
    self.declare  = [FuncDeclare new];
    return self;
}
@end
