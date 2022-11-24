//
//  ConvertVisitor.h
//  oc2mangoLib
//
//  Created by Jiang on 2021/6/23.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AstVisitor;
@interface Convert2MangoVisitor : NSObject <AstVisitor>
/// Convert
/// @param node ORNode
- (NSString *)convert:(id)node;
@end

NS_ASSUME_NONNULL_END
