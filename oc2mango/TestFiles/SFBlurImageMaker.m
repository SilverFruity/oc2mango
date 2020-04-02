//
//  SFBlurImageMaker.m
//  SFImageMaker
//
//  Created by Jiang on 2020/2/29.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "SFBlurImageMaker.h"
#import "UIImageEffects.h"
@implementation SFBlurImageMaker 
- (instancetype)init
{
    self = [super init];
    self.dependencies = [NSMutableArray array];
    return self;
}
- (BOOL)isEnable{
    return self.blurRadius != 0  && self.tintColor != nil;
}
- (nonnull NSString *)identifier {
    return self.isEnable ? [NSString stringWithFormat:@"blureImage%.1f%lu%.1f",self.blurRadius,self.tintColor.hash,self.saturationDeltaFactor] : @"";
}
+ (instancetype)lightEffect{
    SFBlurImageMaker *maker = [SFBlurImageMaker new];
    maker.blurRadius = 60;
    maker.tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    maker.saturationDeltaFactor = 1.8;
    return maker;
}
+ (instancetype)extraLightEffect{
    SFBlurImageMaker *maker = [SFBlurImageMaker new];
    maker.blurRadius = 40;
    maker.tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
    maker.saturationDeltaFactor = 1.8;
    return maker;
}
+ (instancetype)darkEffect{
    SFBlurImageMaker *maker = [SFBlurImageMaker new];
    maker.blurRadius = 40;
    maker.tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    maker.saturationDeltaFactor = 1.8;
    return maker;
}
+ (instancetype)tintEffectWithColor:(UIColor *)tintColor{
    SFBlurImageMaker *maker = [SFBlurImageMaker new];
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    size_t componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    }
    else {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    maker.blurRadius = 20;
    maker.saturationDeltaFactor = -1.0;
    maker.tintColor = effectColor;
    return maker;
}

- (nonnull UIImage *)process:(nullable UIImage *)target {
    if (self.isEnable) {
        return [UIImageEffects imageByApplyingBlurToImage:target withRadius:self.blurRadius tintColor:self.tintColor saturationDeltaFactor:self.saturationDeltaFactor maskImage:self.maskImage];
    }
    return target;
}

@end
