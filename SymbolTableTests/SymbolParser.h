//
//  SymbolParser.h
//  SymbolTableTests
//
//  Created by Jiang on 2021/12/12.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <oc2mangoLib/oc2mangoLib.h>

NS_ASSUME_NONNULL_BEGIN

@interface SymbolParser: Parser
@property (nonatomic, strong)SymbolTableVisitor *visitor;
@end


NS_ASSUME_NONNULL_END
