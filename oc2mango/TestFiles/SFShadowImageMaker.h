//
//  SFShadowImageMaker.h
//  SFImageMaker
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SFImageMaker/SFImageMaker-Protocol.h>
NS_ASSUME_NONNULL_BEGIN

@interface SFShadowImageMaker : NSObject <SFImageProcessor>
@property (nonatomic, assign)CGSize shadowOffset;
@property (nonatomic, assign)CGFloat shadowBlurRadius;
@property (nonatomic, strong)UIColor *shadowColor;
@property (nonatomic, strong)UIColor *fillColor;
@property (nonatomic, assign)UIShadowPostion position;
@property (nonatomic)BOOL enable;
@property(nonatomic, strong)NSMutableArray <id <SFImageProcessor>> *dependencies;

- (CGRect)viewRectForSize:(CGSize)size;
- (UIEdgeInsets)convasEdgeInsets;
@end

NS_ASSUME_NONNULL_END
