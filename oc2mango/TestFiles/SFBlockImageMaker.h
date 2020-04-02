//
//  SFBlockImageMaker.h
//  SFImageMaker
//
//  Created by Jiang on 2020/2/29.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SFImageMaker/SFImageMaker-Protocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFBlockImageMaker : NSObject <SFImageProcessor>
@property(nonatomic, strong)NSMutableArray <id <SFImageProcessor>> *dependencies;

+ (instancetype)imageMakerWithProcessHandler:(UIImage * (^)(UIImage *image))processHandler
                             isEnableHandler:(BOOL (^)(void))isEnableHandler
                           identifierHandler:(NSString *(^)(void))identifierHandler;

+ (instancetype)centerRectWithAspect:(CGFloat)aspect;
+ (instancetype)centerSquare;
+ (instancetype)circle;
+ (instancetype)edgeInsets:(UIEdgeInsets)insets fillColor:(nullable UIColor *)color;
+ (instancetype)resizeWithSize:(CGSize)targetSize;
+ (instancetype)resizeWithMaxValue:(CGFloat)maxValue;
@end

NS_ASSUME_NONNULL_END
