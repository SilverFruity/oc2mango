//
//  SFBlurImageMaker.h
//  SFImageMaker
//
//  Created by Jiang on 2020/2/29.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SFImageMaker/SFImageMaker-Protocol.h>
NS_ASSUME_NONNULL_BEGIN

@interface SFBlurImageMaker : NSObject <SFImageProcessor>
@property (nonatomic, assign)CGFloat blurRadius;
@property (nonatomic, strong)UIColor * tintColor;
@property (nonatomic, assign)CGFloat saturationDeltaFactor;
@property (nonatomic, strong, nullable)UIImage *maskImage;
@property(nonatomic, strong)NSMutableArray <id <SFImageProcessor>> *dependencies;

+ (instancetype)lightEffect;
+ (instancetype)extraLightEffect;
+ (instancetype)darkEffect;
+ (instancetype)tintEffectWithColor:(UIColor *)tintColor;

@end

NS_ASSUME_NONNULL_END
