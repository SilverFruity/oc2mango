//
//  SFImageManager.m
//  SFImageMaker
//
//  Created by Jiang on 2020/2/25.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "SFImageMakerManager.h"

@implementation SFImageMakerManager
+ (instancetype)shared{
    static dispatch_once_t onceToken;
    static SFImageMakerManager *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [SFImageMakerManager new];
    });
    return _instance;
}
- (UIImage *)startWithGenerator:(id <SFImageGenerator>)generator processors:(NSArray<id<SFImageProcessor>> *)processors{
    UIImage *image = generator.generate;
    if ([generator conformsToProtocol:@protocol(SFImageProcessor)]) {
        id <SFImageProcessor> processor = (id <SFImageProcessor>)generator;
        for (id <SFImageProcessor> sub in processor.dependencies) {
            image = [self recursiveProcess:image processor:sub];
        }
    }
    return [self startWithImage:image processors:processors];
}
- (UIImage *)startWithImage:(UIImage *)image processors:(NSArray <id <SFImageProcessor>>*)processors{
    for (id <SFImageProcessor> processor in processors){
        image = [self recursiveProcess:image processor:processor];
    }
    return image;
}
- (UIImage *)recursiveProcess:(UIImage *)image processor:(id <SFImageProcessor>)processor{
    image = [processor process:image];
    for (id <SFImageProcessor> subProcessor in processor.dependencies) {
        image = [self recursiveProcess:image processor:subProcessor];
    }
    return image;
}
@end
