//
//  SymbolStack.h
//  oc2mangoLib
//
//  Created by Jiang on 2019/5/23.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeSpecial.h"
typedef enum{
    SymbolKindVariable,
    SymbolKindTypeDeclare,
    SymbolKindFunction,
    SymbolKindTypeDef,
    SymbolKindEnumConstant
}SymbolKind;

@interface Symbol:NSObject
@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign)SymbolKind kind;
@property (nonatomic,strong)TypeSpecial *type;
+ (instancetype)symbolWithName:(NSString *)name kind:(SymbolKind)kind;
@end

@interface FuncSymbolTable: NSObject
- (Symbol *)lookup:(NSString *)key;
- (void)addSymbol:(Symbol *)symbol forKey:(NSString *)key;
@end

@interface FuncSymbolStack : NSObject
- (Symbol *)lookup:(NSString *)key;
- (void)addSymbol:(Symbol *)symbol forKey:(NSString *)key;
- (void)push:(FuncSymbolTable *)funcSymbol;
- (void)pop;
- (FuncSymbolTable *)topTable;
@end
