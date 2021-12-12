//
//  ocSymbolTable.h
//  oc2mangoLib
//
//  Created by Jiang on 2021/6/24.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ocSymbol.h"
#import "ocScope.h"

NS_ASSUME_NONNULL_BEGIN
@class ocSymbolTable;
extern const ocSymbolTable * symbolTableRoot;
@interface ocSymbolTable : NSObject
{
    @public
    char *constants;
    unsigned long constants_size;
}
@property (nonatomic, strong)ocScope *scope;
- (ocSymbol *)insert:(ocSymbol *)symbol;
- (ocSymbol *)insertRoot:(ocSymbol *)symbol;
- (ocSymbol *)insertRootWithName:(NSString *)name symbol:(ocSymbol *)symbol;
- (ocSymbol *)lookup:(NSString *)name;
- (ocSymbol *)localLookup:(NSString *)name;
- (ocScope *)increaseScope;
- (ocScope *)decreaseScope;
- (void)addConstantSymbol:(ocSymbol *)symbol withKey:(id <NSCopying>)key;
- (ocSymbol *)getConstantSymbol:(id <NSCopying>)key;
@end


@interface ocSymbolTable (Tools)
- (ocSymbol *)addClassRefWithName:(NSString *)name;
@end



NS_ASSUME_NONNULL_END
