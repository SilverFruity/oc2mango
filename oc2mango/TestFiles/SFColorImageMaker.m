//
//  SFColorImageMaker.m
//  SFImageMaker
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "SFColorImageMaker.h"

@implementation SFColorImageMaker
+ (instancetype)imageMakerWithColor:(UIColor *)color{
    SFColorImageMaker *colorImage = [[self class] new];
    colorImage.color = color;
    colorImage.size = CGSizeMake(1, 1);
    return colorImage;
}
- (instancetype)init
{
    self = [super init];
    self.dependencies = [NSMutableArray array];
    return self;
}
+ (instancetype)imageMakerWithColor:(UIColor *)color size:(CGSize)size{
    SFColorImageMaker *colorImage = [self imageMakerWithColor:color];
    colorImage.size = size;
    return colorImage;
}
- (BOOL)isEnable{
    return self.color != [UIColor clearColor] && !CGSizeEqualToSize(self.size, CGSizeZero);
}
- (nonnull UIImage *)generate {
    return [self process:nil];
}
- (nonnull UIImage *)process:(nullable UIImage *)target {
    if (!self.isEnable) return [UIImage new];
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGContextRef context =  UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGContextSetAlpha(context, CGColorGetAlpha(self.color.CGColor));
    CGContextFillRect(context, rect);
    if (target){
        if (self.size.width < target.size.width || self.size.height < target.size.height){
            //TODO: resize with aspect ratio
        }else{
            // Draw in center
            CGPoint point = CGPointMake((self.size.width - target.size.width) / 2, (self.size.height - target.size.height) / 2);
            [target drawInRect:CGRectMake(point.x, point.y, target.size.width, target.size.height)];
        }
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (nonnull NSString *)identifier {
    return self.isEnable ? [NSString stringWithFormat:@"_%@_%@",@(self.color.hash),[NSValue valueWithCGSize:self.size]] : @"";
}
@end
