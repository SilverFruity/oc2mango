//
//  SFImageManager.h
//  SFImageMaker
//
//  Created by Jiang on 2020/2/25.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFImageMaker-Protocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFImageMakerManager : NSObject
+ (instancetype)shared;
- (UIImage *)startWithGenerator:(id <SFImageGenerator>)generator processors:(NSArray <id <SFImageProcessor>>*)processors;
- (UIImage *)startWithImage:(UIImage *)image processors:(NSArray <id <SFImageProcessor>>*)processors;

@end

NS_ASSUME_NONNULL_END
