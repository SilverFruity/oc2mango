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
- (NSString *)description {
    NSMutableArray *array = [NSMutableArray array];
    if (self.values.count > 0) {
        for (int i = 0; i < self.names.count; i++) {
            [array addObject:[NSString stringWithFormat:@"%@:%@",self.names[i],self.values[i]]];
        }
    }else{
        [array addObject:[NSString stringWithFormat:@"%@",self.names.firstObject]];
    }
    
    return [NSString stringWithFormat:@"%@",[array componentsJoinedByString:@" "]];
}
@end


@implementation OCMethodCallGetElement
- (instancetype)init {
    self = [super init];
    self.values = [NSMutableArray array];
    return self;
}
- (NSString *)description{
    if (self.values.count > 0) {
        return [NSString stringWithFormat:@"%@(%@)",self.name,self.values];
    }else{
        return [NSString stringWithFormat:@"%@",self.name];
    }
}
@end

@implementation OCMethodCall {

}
- (NSString *)description{
    if ([self.element isKindOfClass:[OCMethodCallGetElement class]]) {
        return [NSString stringWithFormat:@"%@.%@",self.caller,self.element];
    }else{
        return [NSString stringWithFormat:@"[%@ %@]",self.caller,self.element];
    }
    
}
@end

@implementation BlockImp
- (NSString *)description{
    return [NSString stringWithFormat:@"%@(%@)%@",self.returnType,self.varibles,self.funcImp];
}

@end
