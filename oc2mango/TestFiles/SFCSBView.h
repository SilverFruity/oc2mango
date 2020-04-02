//
//  SFCSBView.h
//  UICornerShadowView
//
//  Created by Jiang on 2020/2/28.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SFImageMaker/SFImageMaker.h>
NS_ASSUME_NONNULL_BEGIN

@interface SFCSBView : UIView
@property (nonatomic,assign)IBInspectable CGFloat cornerRadius ;
@property (nonatomic,strong)IBInspectable UIColor *shadowColor ;
@property (nonatomic,assign)IBInspectable CGSize shadowOffset  ;
@property (nonatomic,assign)IBInspectable CGFloat shadowRadius ;
@property (nonatomic,assign)IBInspectable CGFloat borderWidth  ;
@property (nonatomic,strong)IBInspectable UIColor *borderColor ;
@property (nonatomic,assign)IBInspectable UIRectCorner rectCornner ;
@property (nonatomic,assign)IBInspectable UIShadowPostion shadowPosition UI_APPEARANCE_SELECTOR;
@property (nonatomic,assign)IBInspectable UIBorderPostion borderPosition UI_APPEARANCE_SELECTOR;
@property (nonatomic,nullable,copy)void(^handleMakers)(NSArray <id <SFImageProcessor>> * makers);
@property (nonatomic,readonly)SFShadowImageMaker *shadowProcessor;
@property (nonatomic,readonly)SFCornerImageMaker *cornerProcessor;
@property (nonatomic,readonly)SFBorderImageMaker *borderProcessor;
@property (nonatomic,readonly)SFColorImageMaker  *colorProcessor;
- (void)reloadBackGourndImage;
@end

NS_ASSUME_NONNULL_END
