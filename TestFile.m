#include "stdlib.h"
#import <Foundation/Foundation.h>

@interface Demo: NSObject
@property (nonatomic, assign)NSInteger value;
@property (nonatomic, strong)NSObject *object;
@property (nonatomic, copy)NSObject* (^callback)(NSInteger *);
- (Demo *)objectMethod;
- (Demo *)objectMethod:(NSInteger)parameter;
- (Demo *)objectMethod1:(NSInteger)parameter parameter1:(NSInteger)parameter1;
+ (void)classMethod;
@end

@implementation Demo
- (Demo *)objectMethod{
    [self objectMethod1:1 parameter1:1].value;
    return self;
}

- (Demo *)objectMethod1:(NSInteger)parameter parameter1:(NSInteger)parameter1{
    return self;
}
+ (void)classMethod{

}

@end
