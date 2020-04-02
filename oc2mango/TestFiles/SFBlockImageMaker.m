//
//  SFBlockImageMaker.m
//  SFImageMaker
//
//  Created by Jiang on 2020/2/29.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "SFBlockImageMaker.h"
#import "SFCornerImageMaker.h"

@interface SFBlockImageMaker()
@property (nonatomic,copy)UIImage *(^processHandler)(UIImage *image);
@property (nonatomic,copy)BOOL (^isEnableHandler)(void);
@property (nonatomic,copy)NSString *(^identifierHandler)(void);
@end
@implementation SFBlockImageMaker
+ (instancetype)imageMakerWithProcessHandler:(UIImage * (^)(UIImage *image))processHandler
                             isEnableHandler:(BOOL (^)(void))isEnableHandler
                           identifierHandler:(NSString *(^)(void))identifierHandler{
    SFBlockImageMaker *maker = [SFBlockImageMaker new];
    maker.processHandler = processHandler;
    maker.isEnableHandler = isEnableHandler;
    maker.identifierHandler = identifierHandler;
    return maker;
}
- (instancetype)init
{
    self = [super init];
    self.dependencies = [NSMutableArray array];
    return self;
}
- (BOOL)isEnable{
    if (self.isEnableHandler) {
        return self.isEnableHandler();
    }
    return NO;
}
- (nonnull NSString *)identifier {
    if (self.identifierHandler && self.isEnable){
        return self.identifierHandler();
    }
    return @"";
}

- (nonnull UIImage *)process:(nullable UIImage *)target {
    if (self.processHandler && self.isEnable) {
        return self.processHandler(target);
    }
    return target;
}

+ (instancetype)centerRectWithAspect:(CGFloat)aspectRatio{
   return [SFBlockImageMaker imageMakerWithProcessHandler:^UIImage * _Nonnull(UIImage * _Nonnull image) {
        CGFloat width = floor(image.size.width);
        CGFloat height = floor(image.size.height);
        CGFloat imageAspectRatio = width / height;
        if(imageAspectRatio == aspectRatio) return image;
        CGFloat x = 0, y = 0;
        if (imageAspectRatio < aspectRatio) {
            y = floor((height - width/aspectRatio) * 0.5);
            height = width / aspectRatio;
        }else{
            x = floor((width - height * aspectRatio * 1) * 0.5);
            width = height * aspectRatio * 1;
        }
        CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(x, y, width, height));
        UIImage *newImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        return newImage;
    } isEnableHandler:^BOOL{
        return aspectRatio != 0;
    } identifierHandler:^NSString * _Nonnull{
        return [NSString stringWithFormat:@"centerRect_%f",aspectRatio];
    }];
}
+ (instancetype)centerSquare{
    return [self centerRectWithAspect:1.0];
}
+ (instancetype)circle{
    return [SFBlockImageMaker imageMakerWithProcessHandler:^UIImage * _Nonnull(UIImage * _Nonnull image) {
        if (ceil(image.size.width) != ceil(image.size.height)) {
            image = [[self centerSquare] process:image];
        }
        SFCornerImageMaker *cornerMaker = [SFCornerImageMaker new];
        cornerMaker.position = UIRectEdgeAll;
        cornerMaker.radius = image.size.width * 0.5;
        return [cornerMaker process:image];
    } isEnableHandler:^BOOL{
        return YES;
    } identifierHandler:^NSString * _Nonnull{
        return [NSString stringWithFormat:@"circle"];
    }];
}
+ (instancetype)edgeInsets:(UIEdgeInsets)insets fillColor:(UIColor *)color{
    color = color?:[UIColor clearColor];
    return [SFBlockImageMaker imageMakerWithProcessHandler:^UIImage * _Nonnull(UIImage * _Nonnull image) {
        CGRect imageRect =  CGRectMake(insets.left, insets.top, image.size.width, image.size.height);
        CGSize newSize = CGSizeZero;
        newSize.height = imageRect.size.height + (insets.top + insets.bottom);
        newSize.width  = imageRect.size.width + (insets.left + insets.right);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [color setFill];
        CGContextFillRect(context, CGRectMake(0, 0, newSize.width, newSize.height));
        [image drawInRect:imageRect];
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return result;
    } isEnableHandler:^BOOL{
        return YES;
    } identifierHandler:^NSString * _Nonnull{
        return [NSString stringWithFormat:@"edgeInsets_%@_%lu",[NSValue valueWithUIEdgeInsets:insets],color.hash];
    }];
}
+ (instancetype)resizeWithSize:(CGSize)targetSize{
    return [SFBlockImageMaker imageMakerWithProcessHandler:^UIImage * _Nonnull(UIImage * _Nonnull image) {
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
        CGRect rect = CGRectMake(0, 0, targetSize.width, targetSize.height);
        CGContextFillRect(ctx, rect);
        [image drawInRect:rect];
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return result;
    } isEnableHandler:^BOOL{
        return !CGSizeEqualToSize(targetSize, CGSizeZero);
    } identifierHandler:^NSString * _Nonnull{
        return [NSString stringWithFormat:@"resize_%@",[NSValue valueWithCGSize:targetSize]];
    }];
}
+ (instancetype)resizeWithMaxValue:(CGFloat)maxValue{
    return [SFBlockImageMaker imageMakerWithProcessHandler:^UIImage * _Nonnull(UIImage * _Nonnull image) {
        CGFloat currentMax = MAX(image.size.width, image.size.height);
        if (maxValue > currentMax) return image;
        CGFloat ratio = image.size.width / image.size.height;
        CGSize size = ratio > 1 ? CGSizeMake(maxValue, maxValue/ratio) : CGSizeMake(maxValue/ratio, maxValue);
        return [[SFBlockImageMaker resizeWithSize:size] process:image];
    } isEnableHandler:^BOOL{
        return maxValue != 0;
    } identifierHandler:^NSString * _Nonnull{
        return [NSString stringWithFormat:@"resizeMax_%@",@(maxValue)];
    }];
}
@end
