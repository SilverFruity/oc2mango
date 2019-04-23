#include "stdlib.h"
#import <Foundation/Foundation.h>

@interface Demo: NSObject
@property (nonatomic, assign)NSInteger value;
@property (nonatomic, strong)NSObject *object;
@property (nonatomic, copy)NSObject* (^callback)(NSInteger *);
- (Demo *)objectMethod;
- (Demo *)objectMethod:(NSInteger)parameter;
- (Demo *)objectMethod:(NSInteger)parameter parameter1:(NSInteger)parameter1;
+ (void)classMethod;
@end

@implementation Demo
- (Demo *)objectMethod{
    int x = 1;
    if (x) {
        [NSDictionary dictionary];
    }else if (x){
        [NSDictionary dictionary];
    }else{
        [NSDictionary dictionary];
    }
    NSMutableArray *array  = [NSMutableArray array];
    [[self objectMethod] objectMethod:1 parameter1:2];
    [NSDictionary dictionary];
    return self;
}

- (Demo *)objectMethod:(NSInteger)parameter parameter1:(NSInteger)parameter1{
    return self;
}
+ (void)classMethod{

}

@end
