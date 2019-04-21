#include "stdlib.h"
#import <Foundation/Foundation.h>

@interface Demo: NSObject
{
    NSObject *a;
    NSObject *b;
}
@property (nonatomic, assign)NSInteger value;
@property (nonatomic, strong)NSObject *object;
@property (nonatomic, copy)NSObject* (^callback)(NSInteger *);
- (void)objectMethod;
- (void)objectMethod:(NSInteger)parameter;
- (void)objectMethod:(NSInteger)parameter parameter1:(NSInteger)parameter1;
+ (void)classMethod;
@end

//@implementation Demo
//- (void)objectMethod{
//    int a = 1;
//    int b = 2;
//    a = b;
//    self.value = a;
//    self.object = [NSObject new];
//}
//- (void)objectMethod:(NSInteger)parameter{
//
//}
//- (void)objectMethod:(NSInteger)parameter parameter1:(NSInteger)parameter1{
//
//}
//+ (void)classMethod{
//
//}
//
//@end
