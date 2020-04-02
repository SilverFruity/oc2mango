//
//  SFGradientImageMaker.h
//  SFImageMaker
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SFImageMaker/SFImageMaker-Protocol.h>
NS_ASSUME_NONNULL_BEGIN

@interface SFGradientImageMaker : NSObject <SFImageGenerator,SFImageProcessor>
@property (nonatomic, assign)BOOL isHorizontal;
@property (nonatomic, assign)CGSize size;
@property (nonatomic, assign)NSArray<NSNumber *> *locations;
@property (nonatomic, copy)NSArray<UIColor *> *colors;
@property (nonatomic, strong)NSMutableArray <id <SFImageProcessor>> *dependencies;

+ (instancetype)isHorizontal:(BOOL)isHorizontal startColor:(UIColor *)startColor endColor:(UIColor *)endColor;
@end

NS_ASSUME_NONNULL_END
