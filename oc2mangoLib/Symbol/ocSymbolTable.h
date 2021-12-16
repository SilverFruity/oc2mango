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
    
    const void *string_recorder;
    const void *cfstring_recorder;
    const void *data_section_recorder;
    const void *constant_recorder;
    const void *linked_class_recorder;
    const void *linked_cfunction_recorder;
}
@property (nonatomic, strong)ocScope *scope;
- (ocSymbol *)insert:(ocSymbol *)symbol;
- (ocSymbol *)insertRoot:(ocSymbol *)symbol;
- (ocSymbol *)insertRootWithName:(NSString *)name symbol:(ocSymbol *)symbol;
- (ocSymbol *)lookup:(NSString *)name;
- (ocSymbol *)localLookup:(NSString *)name;
- (ocScope *)increaseScope;
- (ocScope *)decreaseScope;
@end


@interface ocSymbolTable (Tools)
- (ocSymbol *)addClassDefineWithName:(NSString *)name;
- (ocSymbol *)addLinkedClassWithName:(NSString *)name;
- (ocSymbol *)addStringSection:(const char *)typeencode string:(const char *)str;
- (ocSymbol *)addLinkedCFunctionSection:(const char *)typeencode name:(const char *)name;
- (ocSymbol *)addConstantSection:(const char *)typeencode data:(void *)data;
- (ocSymbol *)addDataSection:(const char *)typeencode size:(size_t)size;
@end



NS_ASSUME_NONNULL_END
