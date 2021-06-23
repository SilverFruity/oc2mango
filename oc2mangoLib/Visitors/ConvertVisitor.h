//
//  ConvertVisitor.h
//  oc2mangoLib
//
//  Created by APPLE on 2021/6/23.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <ORPatchFile/ORPatchFile.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConvertVisitor : ORVisitor
/// Convert
/// @param node ORNode
- (NSString *)convert:(id)node;
@end

NS_ASSUME_NONNULL_END
