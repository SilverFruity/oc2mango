//
//  ORunner.m
//  MangoFix
//
//  Created by Jiang on 2020/4/26.
//  Copyright © 2020 yongpengliang. All rights reserved.
//

#import "RunnerClasses.h"
#import "AstVisitor.h"

#define OR_IMPL(node_name)\
@implementation OR##node_name (AstEnumExtension)\
- (void)initialNodeType:(AstEnum)nodeType{\
    self.nodeType = AstEnum##node_name;\
}\
@end
NODE_LIST(OR_IMPL)
#undef OR_IMPL
@implementation ORNode (AstEnumExtension)
- (void)initialNodeType:(AstEnum)nodeType{
    self.nodeType = AstEnumEmptyNode;
}
@end

@implementation ORNode
- (instancetype)init{
    self = [super init];
    [self initialNodeType:AstEnumEmptyNode];
    return self;
}
- (BOOL)isConst{
    return NO;
}
+ (id)copyWithNode:(ORNode *)node{
    ORVariableNode *new = [[[self class] alloc] init];
    new.nodeType = node.nodeType;
    new.parentNode = node.parentNode;
    new.withSemicolon = node.withSemicolon;
    return new;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end

@implementation ORTypeNode
+ (instancetype)specialWithType:(OCType)type name:(NSString *)name{
    ORTypeNode *s = [ORTypeNode new];
    s.type = type;
    s.name = name;
    return s;
}

@end

@implementation ORVariableNode
+ (instancetype)copyFromVar:(ORVariableNode *)var{
    ORVariableNode *new = [self copyWithNode:var];
    new.ptCount = var.ptCount;
    new.varname = var.varname;
    new.isBlock = var.isBlock;
    return new;
}
@end

@implementation ORDeclaratorNode
- (NSUInteger)hash{
    return [self.var.varname hash];
}
- (BOOL)isEqual:(id)object{
    return [self hash] == [object hash];
}
+ (instancetype)copyFromDecl:(ORDeclaratorNode *)var{
    __autoreleasing ORDeclaratorNode *new = [[self class] new];
    new.type = var.type;
    new.var = [ORVariableNode copyFromVar:var.var];
    return new;
}

@end

@implementation ORFunctionDeclNode
- (instancetype)copy{
    ORFunctionDeclNode *declare = [ORFunctionDeclNode copyWithNode:self];
    declare.var = [self.var copy];
    return declare;
}
- (BOOL)isBlockDeclare{
    return self.var.isBlock;
}

@end

@implementation ORCArrayDeclNode
+ (instancetype)copyFromDecl:(ORDeclaratorNode *)decl{
    ORCArrayDeclNode *array  = [super copyFromDecl:decl];
    if ([decl isKindOfClass:[ORCArrayDeclNode class]]) {
        array.prev = (ORCArrayDeclNode *)decl;
    }
    return array;
}

@end

@implementation ORBlockNode
- (instancetype)init
{
    self = [super init];
    self.statements = [NSMutableArray array];
    return self;
}
- (void)addStatements:(id)statements{
    if ([statements isKindOfClass:[NSArray class]]) {
        [self.statements addObjectsFromArray:statements];
    }else{
        [self.statements addObject:statements];
    }
}
- (void)copyFromImp:(ORBlockNode *)imp{
    self.statements = imp.statements;
}
@end
@implementation ORValueNode
@end

@implementation ORIntegerValue
- (BOOL)isConst{
    return YES;
}
- (NSInteger)integerValue{
    return self.value;
}
@end

@implementation ORUIntegerValue
- (BOOL)isConst{
    return YES;
}
- (NSInteger)integerValue{
    return (NSInteger)self.value;
}
@end

@implementation ORDoubleValue
@end

@implementation ORBoolValue
@end

@interface ORMethodCall()
@property (nonatomic, copy)NSString *selectorName;
@end

@implementation ORMethodCall
- (NSString *)selectorName{
    if (_selectorName == nil){
        NSMutableArray *names = [self.names mutableCopy];
        if (self.values.count >= 1){
            [names addObject:@""];
        }
        _selectorName = [names componentsJoinedByString:@":"];
    }
    return _selectorName;
}
@end

@implementation ORFunctionCall
@end



@implementation ORFunctionNode
- (instancetype)convertToNormalFunctionImp{
    ORFunctionNode *imp = [ORFunctionNode new];
    imp.declare = [self.declare copy];
    imp.scopeImp = self.scopeImp;
    imp.declare.var.isBlock = NO;
    return imp;
}
- (BOOL)isBlockImp{
    return self.declare.var.isBlock;
}
@end

@implementation ORSubscriptNode
@end

@implementation ORAssignNode
- (NSString *)varname{
    if ([self.value isKindOfClass:[ORValueNode class]]) {
        return [(ORValueNode *)self.value value];
    }
    return nil;
}
@end



@implementation ORInitDeclaratorNode
@end

@implementation ORUnaryNode
@end

@implementation ORBinaryNode
@end

@implementation ORTernaryNode
- (instancetype)init
{
    self = [super init];
    self.values = [NSMutableArray array];
    return self;
}
@end

@implementation ORIfStatement
@end

@implementation ORWhileStatement
@end

@implementation ORDoWhileStatement
@end

@implementation ORCaseStatement
@end

@implementation ORSwitchStatement
- (instancetype)init
{
    self = [super init];
    self.cases = [NSMutableArray array];
    return self;
}
@end

@implementation ORForStatement
@end

@implementation ORForInStatement
@end

@implementation ORControlStatNode
@end

@implementation ORPropertyNode
- (MFPropertyModifier)modifier{
    NSDictionary *cache = @{
        @"strong":@(MFPropertyModifierMemStrong),
        @"weak":@(MFPropertyModifierMemWeak),
        @"copy":@(MFPropertyModifierMemCopy),
        @"assign":@(MFPropertyModifierMemAssign),
        @"nonatomic":@(MFPropertyModifierNonatomic),
        @"atomic":@(MFPropertyModifierAtomic)
    };
    uint32_t value = 0;
    for (NSString *keyword in self.keywords) {
        NSNumber *keywordValue = cache[keyword];
        if (keywordValue) {
            value = value | keywordValue.unsignedIntValue;
        }
    }
    return value;
}
- (NSUInteger)hash{
    return [self.var hash];
}
- (BOOL)isEqual:(ORPropertyNode *)object{
    return [self hash] == [object hash];
}
@end
@interface ORMethodDeclNode()
@property (nonatomic, copy)NSString *selectorName;
@end

@implementation ORMethodDeclNode
- (NSString *)selectorName{
    if (_selectorName == nil){
        NSMutableArray *names = [self.methodNames mutableCopy];
        if (self.parameters.count >= 1){
            [names addObject:@""];
        }
        _selectorName = [names componentsJoinedByString:@":"];
    }
    return _selectorName;
}
@end

@implementation ORMethodNode
- (NSUInteger)hash{
    return [[self.declare selectorName] stringByAppendingFormat:@"%d",self.declare.isClassMethod].hash;
}
- (BOOL)isEqual:(id)object{
    return [self hash] == [object hash];
}
@end

@implementation ORClassNode
+ (instancetype)classNodeWithClassName:(NSString *)className{
    ORClassNode *class = [ORClassNode new];
    class.className = className;
    return class;
}
- (instancetype)init
{
    self = [super init];
    self.properties  = [NSMutableArray array];
    self.privateVariables = [NSMutableArray array];
    self.properties = [NSMutableArray array];
    self.methods = [NSMutableArray array];
    
    return self;
}
- (void)merge:(ORClassNode *)target key:(nonnull NSString *)key{
    NSMutableSet *sourceSet = [NSMutableSet setWithArray:[self valueForKey:key]];
    NSMutableSet *compredSet = [NSMutableSet setWithArray:[target valueForKey:key]];
    [compredSet unionSet:sourceSet];
    [compredSet minusSet:sourceSet];
    NSMutableArray *array = [self valueForKey:key];
    [array addObjectsFromArray:compredSet.allObjects];
}
@end

@implementation ORProtocolNode
+ (instancetype)protcolWithProtcolName:(NSString *)protcolName{
    ORProtocolNode *protcol = [ORProtocolNode new];
    protcol.protcolName = protcolName;
    return protcol;
}
- (instancetype)init
{
    self = [super init];
    self.properties  = [NSMutableArray array];
    self.properties = [NSMutableArray array];
    self.methods = [NSMutableArray array];
    return self;
}
@end

@implementation ORStructStatNode

@end

@implementation ORUnionStatNode

@end

@implementation OREnumStatNode

@end

@implementation ORTypedefStatNode

@end


