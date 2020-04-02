//
//  SFShadowImageMaker.m
//  SFImageMaker
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "SFShadowImageMaker.h"

@implementation SFShadowImageMaker
- (instancetype)init
{
    self = [super init];
    self.fillColor = [UIColor clearColor];
    self.dependencies = [NSMutableArray array];
    return self;
}
- (BOOL)isEnable{
    return self.shadowColor != nil && self.shadowColor != [UIColor clearColor] && self.shadowBlurRadius != 0;
}
- (CGRect)viewRectForSize:(CGSize)size{
    UIEdgeInsets insets = [self convasEdgeInsets];
    CGSize convasSize = [self convasSizeWithSize:size];
    return CGRectMake(-insets.left, -insets.top, convasSize.width, convasSize.height);
}
- (CGSize)convasSizeWithSize:(CGSize)size{
    UIEdgeInsets insets = [self convasEdgeInsets];
    return CGSizeMake(size.width + insets.left + insets.right, size.height + insets.top + insets.bottom);
}
- (UIEdgeInsets)convasEdgeInsets{
    CGFloat left=0, right = 0, top = 0, bottom = 0;
    if (self.position&UIShadowPostionRight&&self.shadowOffset.width>0) {
        right += fabs(self.shadowOffset.width);
    }else if (self.position&UIShadowPostionLeft&&self.shadowOffset.width<0) {
        left += fabs(self.shadowOffset.width);
    }
    if (self.position&UIShadowPostionBottom&&self.shadowOffset.height>0) {
        bottom += fabs(self.shadowOffset.height);
    }else if (self.position&UIShadowPostionTop&&self.shadowOffset.height<0) {
        top += fabs(self.shadowOffset.height);
    }
    top += self.position&UIShadowPostionTop?self.shadowBlurRadius:0;
    bottom += self.position&UIShadowPostionBottom?self.shadowBlurRadius:0;
    left  += self.position&UIShadowPostionLeft?self.shadowBlurRadius:0;
    right  += self.position&UIShadowPostionRight?self.shadowBlurRadius:0;
    return UIEdgeInsetsMake(top, left, bottom, right);
}
- (UIImage *)process:(UIImage *)target{
    if (!self.isEnable) return target;
    UIEdgeInsets insets = [self convasEdgeInsets];
    CGSize canvasSize = [self convasSizeWithSize:target.size];
    CGRect canvasRect = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
    UIGraphicsBeginImageContextWithOptions(canvasRect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.fillColor setFill];
    CGContextFillRect(context,canvasRect);
    CGContextSetShadowWithColor(context, self.shadowOffset, self.shadowBlurRadius, self.shadowColor.CGColor);
    [target drawInRect:CGRectMake(insets.left, insets.top, target.size.width, target.size.height)];
    //获取图像
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (nonnull NSString *)identifier {
    return self.isEnable ? [NSString stringWithFormat:@"_%@_%@_%@_%@",[NSValue valueWithCGSize:self.shadowOffset],@(self.shadowBlurRadius),@(self.shadowColor.hash),@(self.position)] : @"";
}
@end
