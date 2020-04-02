//
//  SFCSBView.m
//  UICornerShadowView
//
//  Created by Jiang on 2020/2/28.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "SFCSBView.h"

@interface SFCSBViewImageCache: NSObject
@property (nonatomic, strong)NSCache *cache;
@end

@implementation SFCSBViewImageCache
+ (instancetype)shared{
    static dispatch_once_t onceToken;
    static SFCSBViewImageCache *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [SFCSBViewImageCache new];
    });
    return _instance;
}
- (instancetype)init
{
    self = [super init];
    self.cache = [[NSCache alloc] init];
    self.cache.totalCostLimit = 10 * 1024 * 1024;
    return self;
}
- (nullable UIImage *)objectForKey:(NSString *)key{
    return [self.cache objectForKey:key];
}
- (void)setObject:(nullable UIImage *)obj forKey:(NSString *)key{
    if (!obj) {
        return;
    }
    [self.cache setObject:obj forKey:key];
}
@end

@interface SFCSBView()
@property (nonatomic, strong)UIColor * initailBackGroundColor;
@property (nonatomic, copy)NSString * lastBackGroundImageIdentifer;
@property (nonatomic, strong)UIImageView * backGroundImageView;
@end
@implementation SFCSBView
- (SFShadowImageMaker *)shadowProcessor{
    SFShadowImageMaker *maker = [[SFShadowImageMaker alloc] init];
    maker.shadowColor = self.shadowColor;
    maker.shadowOffset = self.shadowOffset;
    maker.shadowBlurRadius = self.shadowRadius;
    maker.position = self.shadowPosition;
    return maker;
}
- (SFCornerImageMaker *)cornerProcessor{
    SFCornerImageMaker *maker = [[SFCornerImageMaker alloc] init];
    maker.radius = self.cornerRadius;
    maker.position = self.rectCornner;
    return maker;
}
- (SFBorderImageMaker *)borderProcessor{
    SFBorderImageMaker *maker = [[SFBorderImageMaker alloc] init];
    maker.width = self.borderWidth;
    maker.color = self.borderColor;
    maker.position = self.borderPosition;
    maker.cornerMaker = self.cornerProcessor;
    return maker;
}
- (SFColorImageMaker *)colorProcessor{
    // Radius ShadowRadius BorderWidth 取最大值
    CGFloat maxValue = self.cornerProcessor.radius > (self.borderProcessor.width + 1) && self.cornerProcessor.isEnable ? self.cornerProcessor.radius : self.borderProcessor.width + 1;
    maxValue = self.shadowProcessor.shadowBlurRadius > maxValue ? self.shadowProcessor.shadowBlurRadius : maxValue;
    CGSize size = CGSizeMake(maxValue * 2, maxValue * 2);
    return [SFColorImageMaker imageMakerWithColor:self.initailBackGroundColor size:size];
}
- (UIImageView *)backGroundImageView{
    if (!_backGroundImageView){
        _backGroundImageView = [UIImageView new];
        _backGroundImageView.clipsToBounds = NO;
        [self addSubview:_backGroundImageView];
    }
    return _backGroundImageView;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}
- (void)setDefaultValues{
    self.rectCornner = UIRectCornerAllCorners;
    self.cornerRadius = 8;
    self.shadowColor = [UIColor.blueColor colorWithAlphaComponent:0.08];
    self.shadowOffset = CGSizeZero;
    self.shadowRadius = 4;
    self.borderWidth = 0;
    self.borderColor = UIColor.clearColor;
    self.shadowPosition = UIShadowPostionAll;
    self.borderPosition = UIBorderPostionAll;
    self.clipsToBounds = NO;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self reloadBackGourndImage];
}
- (void)reloadBackGourndImage{
    [self sendSubviewToBack:self.backGroundImageView];
    if (!CGColorEqualToColor(self.backgroundColor.CGColor, UIColor.clearColor.CGColor) && self.backgroundColor != nil) {
        self.initailBackGroundColor = self.backgroundColor;
    }
    //保证不会在子线程中调用self获取值
    //TODO: 增加网络图片的处理
    SFShadowImageMaker *shadowMaker = self.shadowProcessor;
    SFCornerImageMaker *cornerMaker = self.cornerProcessor;
    SFBorderImageMaker *borderMaker = self.borderProcessor;
    SFColorImageMaker  *colorMaker = self.colorProcessor;
    if (self.handleMakers)
        self.handleMakers(@[colorMaker,cornerMaker,borderMaker,shadowMaker]);
    
    NSString *identifier = [NSString stringWithFormat:@"%@%@%@%@",colorMaker.identifier,cornerMaker.identifier,borderMaker.identifier,shadowMaker.identifier];
    CGRect backImageViewFrame = self.bounds;
    if (shadowMaker.isEnable){
        //FIXME: 外边框 border和shadow同时存在时，宽高的计算，一大一小。
        //FIXME: 外边框 border和shadow只有一者存在时，宽高的计算。
        backImageViewFrame = [shadowMaker viewRectForSize:self.bounds.size];
        //insetValue: 特意增加的误差 0.o。解决tableView显示时，cell上下阴影衔接时会有一空缺的问题。
        CGFloat insertValue = -1;
        // CGRect(2,2,2,2) -> CGRect(1,1,4,4)
        backImageViewFrame = CGRectInset(backImageViewFrame, insertValue, insertValue);
    }
    // 每修改一次subview的frame，view会调用layoutSubviews方法。
    // 目的：在高度重用UICornerShadowView的情况，并且每次都更新的情况下，减少frame更新。
    // 如果上一次的identifer相同说明是重用图片
    // 如果当前frame和需要的frame相同，也不用更新frame
    if (![identifier isEqualToString:self.lastBackGroundImageIdentifer] || !CGRectEqualToRect(self.backGroundImageView.frame, backImageViewFrame)) {
        self.backGroundImageView.frame = backImageViewFrame;
    }
    UIImage *cacheImage = [[SFCSBViewImageCache shared] objectForKey:identifier];
    if (cacheImage) {
        self.backGroundImageView.image = cacheImage;
        self.backgroundColor = UIColor.clearColor;
        self.lastBackGroundImageIdentifer = identifier;
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [SFImageMakerManager.shared startWithGenerator:colorMaker processors:@[cornerMaker,borderMaker,shadowMaker]];
        if (shadowMaker.isEnable) {
            UIEdgeInsets inset = shadowMaker.convasEdgeInsets;
            CGFloat x = (image.size.width - inset.left - inset.right) / 2;
            CGFloat y = (image.size.height - inset.top - inset.bottom) / 2;
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(y + inset.top, x + inset.left, y + inset.bottom, x + inset.right)];
        }else{
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height / 2, image.size.width / 2, image.size.height / 2, image.size.width / 2)];
        }
        [SFCSBViewImageCache.shared setObject:image forKey:identifier];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!weakSelf) {
                return;
            }
            weakSelf.lastBackGroundImageIdentifer = identifier;
            weakSelf.backGroundImageView.image = image;
        });
    });
    self.backgroundColor = UIColor.clearColor;
}
@end
