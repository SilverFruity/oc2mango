//
//  SFBorderImageMaker.m
//  SFImageMaker
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "SFBorderImageMaker.h"
#import "SFCornerImageMaker.h"


@implementation SFBorderImageMaker
- (instancetype)init
{
    self = [super init];
    self.fillColor = [UIColor clearColor];
    self.dependencies = [NSMutableArray array];
    return self;
}
- (BOOL)isEnable{
    return self.color != nil && self.color != [UIColor clearColor] && self.width != 0;
}
- (UIEdgeInsets)strokeEdgeInsets{
    CGFloat left=0, right = 0, top = 0, bottom = 0;
    left = self.position&UIBorderPostionLeft? self.width/2 : -self.width/2;
    right = self.position&UIBorderPostionRight? self.width/2 : -self.width/2;
    top = self.position&UIBorderPostionTop?  self.width/2 : -self.width/2;
    bottom = self.position&UIBorderPostionBottom? self.width/2 : -self.width/2;
    return UIEdgeInsetsMake(top, left, bottom, right);
}
- (CGPoint)strokeOrigin{
    UIEdgeInsets insets = [self strokeEdgeInsets];
    return CGPointMake(insets.left, insets.top);
}
- (CGSize)strokeSizeWithSize:(CGSize)size{
    UIEdgeInsets insets = [self strokeEdgeInsets];
    return CGSizeMake(size.width - insets.left - insets.right,size.height - insets.top - insets.bottom);
}
- (CGRect)strokeRectWithSize:(CGSize)size{
    CGPoint origin = [self strokeOrigin];
    CGSize rectSize = [self strokeSizeWithSize:size];
    return CGRectMake(origin.x, origin.y, rectSize.width, rectSize.height);
}
- (nonnull UIImage *)process:(nullable UIImage *)target {
    if (!self.isEnable) return target;
    if (!target) return [UIImage new];
    CGRect rect = CGRectMake(0, 0, target.size.width, target.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.color setStroke];
    [self.fillColor setFill];
    CGContextFillRect(context, rect);
    [target drawInRect:rect];
    SFCornerImageMaker *cornerMaker = self.cornerMaker;
    if (cornerMaker){
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:cornerMaker.position cornerRadii:CGSizeMake(cornerMaker.radius, cornerMaker.radius)];
        [clipPath addClip];
    }
    
    CGRect strokeRect = CGContextGetClipBoundingBox(context);
    strokeRect = [self strokeRectWithSize:target.size];
    UIBezierPath *linePath;
    if (!cornerMaker || self.width > cornerMaker.radius || cornerMaker.radius == 0){ // 当 width 40 radius 20的情况下
        linePath = [UIBezierPath bezierPathWithRect:strokeRect];
    }else{
        linePath = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:cornerMaker.position cornerRadii:CGSizeMake(cornerMaker.radius, cornerMaker.radius)];
    }
    linePath.lineWidth = self.width;
    if (cornerMaker.radius > 0){
        linePath.lineCapStyle = kCGLineCapRound;
        linePath.lineJoinStyle = kCGLineJoinRound;
    }
    [linePath stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (nonnull NSString *)identifier {
    return self.isEnable ? [NSString stringWithFormat:@"_%@_%@_%@",@(self.color.hash),@(self.width),@(self.position)] : @"";
}

@end
