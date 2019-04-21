#include "stdlib.h"
#import <Foundation/Foundation.h>

@interface Demo: NSObject
@property (nonatomic, assign)NSInteger value;
@property (nonatomic, strong)NSObject *object;
@property (nonatomic, copy)NSObject* (^callback)(NSInteger *);
- (void)objectMethod;
- (NSInteger)objectMethod:(NSInteger)parameter;
- (NSInteger)objectMethod:(NSInteger)parameter parameter1:(NSInteger)parameter1;
+ (void)classMethod;
@end

@implementation Demo
- (void)objectMethod{
    [self objectMethod:[self objectMethod:1 parameter1:2]];
}
- (NSInteger)objectMethod:(NSInteger)parameter{
    return 1;
}
- (NSInteger)objectMethod:(NSInteger)parameter parameter1:(NSInteger)parameter1{
    return 1;
}
+ (void)classMethod{

}

@end
