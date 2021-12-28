//
//  OCTypeEncode.h
//  ORPatchFile
//
//  Created by Jiang on 2021/6/22.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#ifndef OCTypeEncode_h
#define OCTypeEncode_h

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

#define TypeEncodeCharIsBaseType(chr) ((('a'<= chr && chr <= 'z') || ('A'<= chr && chr <= 'Z')) && chr != 'v')
#define TypeEncodeIsBaseType(code) TypeEncodeCharIsBaseType(*code)

static const char *OCTypeStringBlock = "@?";
static const char *OCTypeStringFunction = "^?";

#endif /* OCTypeEncode_h */
