//
//  ORunner.m
//  MangoFix
//
//  Created by Jiang on 2020/4/26.
//  Copyright © 2020 yongpengliang. All rights reserved.
//

#import "RunnerClasses.h"
#define OR_IMPL(node_name)\
@implementation OR##node_name\
- (void)initialNodeType:(AstEnum)nodeType{\
    self.nodeType = AstEnum##node_name;\
}

OR_IMPL(TypeNode)
+ (instancetype)specialWithType:(OCType)type name:(NSString *)name{
    ORTypeNode *s = [ORTypeNode new];
    s.type = type;
    s.name = name;
    return s;
}
@end

OR_IMPL(FunctionDeclNode)
- (instancetype)copy{
    ORFunctionDeclNode *declare = [ORFunctionDeclNode copyWithNode:self];
    declare.var = [self.var copy];
    return declare;
}
- (BOOL)isBlockDeclare{
    return self.var.isBlock;
}
@end

@implementation ORNode
- (void)initialNodeType:(AstEnum)nodeType{
    self.nodeType = nodeType;
}
- (instancetype)init{
    self = [super init];
    [self initialNodeType:AstEnumEmptyNode];
    return self;
}
+ (id)copyWithNode:(ORNode *)node{
    ORVariableNode *new = [[[self class] alloc] init];
    new.nodeType = node.nodeType;
    new.parentNode = node.parentNode;
    new.withSemicolon = node.withSemicolon;
    return new;
}
@end

OR_IMPL(VariableNode)
+ (instancetype)copyFromVar:(ORVariableNode *)var{
    ORVariableNode *new = [self copyWithNode:var];
    new.ptCount = var.ptCount;
    new.varname = var.varname;
    new.isBlock = var.isBlock;
    return new;
}
@end

OR_IMPL(ValueNode)
@end

OR_IMPL(IntegerValue)
@end

OR_IMPL(UIntegerValue)
@end

OR_IMPL(DoubleValue)
@end

OR_IMPL(BoolValue)
@end

@interface ORMethodCall()
@property (nonatomic, copy)NSString *selectorName;
@end

OR_IMPL(MethodCall)
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

OR_IMPL(FunctionCall)
@end

OR_IMPL(BlockNode)
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

OR_IMPL(FunctionNode)
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

OR_IMPL(SubscriptNode)
@end

OR_IMPL(AssignNode)
- (NSString *)varname{
    if ([self.value isKindOfClass:[ORValueNode class]]) {
        return [(ORValueNode *)self.value value];
    }
    return nil;
}
@end

OR_IMPL(DeclaratorNode)
- (NSUInteger)hash{
    return [self.var.varname hash];
}
- (BOOL)isEqual:(id)object{
    return [self hash] == [object hash];
}
+ (instancetype)copyFromDecl:(ORDeclaratorNode *)var{
    __autoreleasing ORDeclaratorNode *new = [[self class] new];
    new.type = var.type;
    new.var = var.var;
    return new;
}
@end

OR_IMPL(InitDeclaratorNode)
@end

OR_IMPL(UnaryNode)
@end

OR_IMPL(BinaryNode)
@end

OR_IMPL(TernaryNode)
- (instancetype)init
{
    self = [super init];
    self.values = [NSMutableArray array];
    return self;
}
@end

OR_IMPL(IfStatement)
@end

OR_IMPL(WhileStatement)
@end

OR_IMPL(DoWhileStatement)
@end

OR_IMPL(CaseStatement)
@end

OR_IMPL(SwitchStatement)
- (instancetype)init
{
    self = [super init];
    self.cases = [NSMutableArray array];
    return self;
}
@end

OR_IMPL(ForStatement)
@end

OR_IMPL(ForInStatement)
@end

OR_IMPL(ControlStatNode)
@end

OR_IMPL(PropertyNode)
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

OR_IMPL(MethodDeclNode)
- (NSString *)selectorName{
    if (_selectorName == nil){
        NSMutableArray *names = [self.methodNames mutableCopy];
        if (self.parameterNames.count >= 1){
            [names addObject:@""];
        }
        _selectorName = [names componentsJoinedByString:@":"];
    }
    return _selectorName;
}
@end

OR_IMPL(MethodNode)
- (NSUInteger)hash{
    return [[self.declare selectorName] stringByAppendingFormat:@"%d",self.declare.isClassMethod].hash;
}
- (BOOL)isEqual:(id)object{
    return [self hash] == [object hash];
}
@end

OR_IMPL(ClassNode)
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

OR_IMPL(ProtocolNode)
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

OR_IMPL(StructStatNode)

@end

OR_IMPL(UnionStatNode)

@end

OR_IMPL(EnumStatNode)

@end

OR_IMPL(TypedefStatNode)

@end


OR_IMPL(CArrayDeclNode)
+ (instancetype)copyFromDecl:(ORDeclaratorNode *)decl{
    ORCArrayDeclNode *array  = [super copyFromDecl:decl];
    if ([decl isKindOfClass:[ORCArrayDeclNode class]]) {
        array.prev = (ORCArrayDeclNode *)decl;
    }
    return array;
}

@end

