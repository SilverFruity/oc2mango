//
//  ORCoreHeader.h
//  ORPatchFile
//
//  Created by Jiang on 2021/6/22.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#ifndef ORCoreHeader_h
#define ORCoreHeader_h

// MARK: - Base
typedef enum: uint32_t {
    OCTypeChar = 'c',
    OCTypeShort = 's',
    OCTypeInt = 'i',
    OCTypeLong = 'l',
    OCTypeLongLong = 'q',

    OCTypeUChar = 'C',
    OCTypeUShort = 'S',
    OCTypeUInt = 'I',
    OCTypeULong = 'L',
    OCTypeULongLong = 'Q',
    OCTypeBOOL = 'B',

    OCTypeFloat = 'f',
    OCTypeDouble = 'd',

    OCTypeVoid = 'v',
    OCTypeCString = '*',
    OCTypeObject = '@',
    OCTypeClass = '#',
    OCTypeSEL = ':',

    OCTypeArray = '[',
    OCTypeStruct = '{',
    OCTypeUnion = '(',
    OCTypeBit = 'b',

    OCTypePointer = '^',
    OCTypeUnknown = '?'
}OCType;

#define ExternOCTypeString(Type) static const char OCTypeString##Type[2] = {OCType##Type, '\0'};
ExternOCTypeString(Char)
ExternOCTypeString(Short)
ExternOCTypeString(Int)
ExternOCTypeString(Long)
ExternOCTypeString(LongLong)

ExternOCTypeString(UChar)
ExternOCTypeString(UShort)
ExternOCTypeString(UInt)
ExternOCTypeString(ULong)
ExternOCTypeString(ULongLong)
ExternOCTypeString(BOOL)

ExternOCTypeString(Float)
ExternOCTypeString(Double)
ExternOCTypeString(Void)
ExternOCTypeString(CString)
ExternOCTypeString(Object)
ExternOCTypeString(Class)
ExternOCTypeString(SEL)

ExternOCTypeString(Array)
ExternOCTypeString(Struct)
ExternOCTypeString(Union)
ExternOCTypeString(Bit)

ExternOCTypeString(Pointer)
ExternOCTypeString(Unknown)

//NOTE: ignore bit 'b'
#define TypeEncodeIsBaseType(code) (('a'<= *code && *code <= 'z') || ('A'<= *code && *code <= 'Z'))

static const char *OCTypeStringBlock = "@?";

//VSCode正则: @interface (.*)?:[.\w\W]*?@end
#define NODE_LIST(V)\
V(TypeNode)\
V(VariableNode)\
V(DeclaratorNode)\
V(FunctionDeclNode)\
V(CArrayDeclNode)\
V(BlockNode)\
V(ValueNode)\
V(IntegerValue)\
V(UIntegerValue)\
V(DoubleValue)\
V(BoolValue)\
V(MethodCall)\
V(FunctionCall)\
V(FunctionNode)\
V(SubscriptNode)\
V(AssignNode)\
V(InitDeclaratorNode)\
V(UnaryNode)\
V(BinaryNode)\
V(TernaryNode)\
V(IfStatement)\
V(WhileStatement)\
V(DoWhileStatement)\
V(CaseStatement)\
V(SwitchStatement)\
V(ForStatement)\
V(ForInStatement)\
V(ControlStatNode)\
V(PropertyNode)\
V(MethodDeclNode)\
V(MethodNode)\
V(ClassNode)\
V(ProtocolNode)\
V(StructStatNode)\
V(UnionStatNode)\
V(EnumStatNode)\
V(TypedefStatNode)\

#endif /* ORCoreHeader_h */
