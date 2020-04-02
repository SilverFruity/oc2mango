//
//  SFBorderImageMaker.h
//  SFImageMaker
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SFImageMaker/SFImageMaker-Protocol.h>

NS_ASSUME_NONNULL_BEGIN


@interface SFBorderImageMaker: NSObject <SFImageProcessor>
@property (nonatomic, assign)CGFloat width;
@property (nonatomic, strong)UIColor *color;
@property (nonatomic, strong)UIColor *fillColor;
@property (nonatomic, assign)UIBorderPostion position;
@property (nonatomic, assign)BOOL enable;
@property (nonatomic, strong, nullable)SFCornerImageMaker *cornerMaker;
@property (nonatomic, strong)NSMutableArray <id <SFImageProcessor>> *dependencies;
- (CGRect)strokeRectWithSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
