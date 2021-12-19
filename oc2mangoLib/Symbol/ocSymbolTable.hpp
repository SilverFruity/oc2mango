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
#import "ORFileSection.hpp"

NS_ASSUME_NONNULL_BEGIN
@class ocSymbolTable;
extern const ocSymbolTable * symbolTableRoot;
@interface ocSymbolTable : NSObject
{
    @private
    ORSectionRecorderManager recorder;
}
@property (nonatomic, strong)ocScope *scope;
@property (nonatomic, assign, readonly)ORSectionRecorderManager& recorder;
- (ocSymbol *)insert:(ocSymbol *)symbol;
- (ocSymbol *)insertRoot:(ocSymbol *)symbol;
- (ocSymbol *)insertRootWithName:(NSString *)name symbol:(ocSymbol *)symbol;
- (ocSymbol *)lookup:(NSString *)name;
- (ocSymbol *)localLookup:(NSString *)name;
- (ocScope *)increaseScope;
- (ocScope *)decreaseScope;
@end


@interface ocSymbolTable (Tools)
- (ocSymbol *)addLinkedClassWithName:(NSString *)name;
- (ocSymbol *)addStringSection:(const char *)typeencode string:(const char *)str;
- (ocSymbol *)addLinkedCFunctionSection:(const char *)typeencode name:(const char *)name;
- (ocSymbol *)addConstantSection:(const char *)typeencode data:(void *)data;
- (ocSymbol *)addDataSection:(const char *)typeencode size:(size_t)size;
- (ocSymbol *)addClassDefineWithName:(ORClassNode *)node;
- (ocSymbol *)addPropertySection:(ORPropertyNode *)node className:(NSString *)className;
- (ocSymbol *)addIvarSection:(ORDeclaratorNode *)node className:(NSString *)className;
- (ocSymbol *)addMethodSection:(ORMethodNode *)node className:(NSString *)className;
@end
NS_ASSUME_NONNULL_END

#ifdef __cplusplus
extern "C" {
#endif //__cplusplus

void SymbolTableAddLinkedClassWithName(NSString * name);

#ifdef __cplusplus
}
#endif //__cplusplus
