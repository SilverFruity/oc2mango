//
//  ORFile.h
//  oc2mangoLib
//
//  Created by Jiang on 2021/12/7.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>

struct ORLoadCommand{
    int64_t section_offset;
    int64_t section_size;
    int64_t item_count;
};

struct ORFileHeader{
    char sha256_data[256];
    char target_os_version[64];
    char target_app_version[64];
    char target_framework_version[64];
    int64_t load_command_count;
};

enum OR_LOAD_COMMAND{
    or_load_string_section,
    or_load_linked_class_section,
    or_load_link_cfunction_section,
    or_load_class_section,
    or_load_text_section,
};

struct ORStringItem{
    uint64 offset;
};

struct ORCFString {
    void * ref;
    struct ORStringItem string;
};

struct ORStringSection{
    char *buffer;
};

struct ORLinkedClass{
    void *class_ptr;
    struct ORStringItem class_name;
};

// a argument signature is 8 bit
// 1 0 0 0 0 0 0 0
// first bit used to determin base type: 0 -> integer, 1 -> float.
// because it in arm/x86 will be used the different register. in arm, x0 or d0.
// less 7 bit used to descrip the length of argument, so max bytes of a argument
// is 127 bytes, if gether than 127 bytes, we can't resolve it.
// so function signature mostly hava 8 argument
// | 08 | 90 | 8F | 00 | 00 | 00 | 00 | 00 |
// in this example: function has 2 argument
// return signature 00010000 : integer, length is 8 bytes
// first  argument  10010000 : float, length is 16 bytes
// second argument  10001111 : float, length is 15 bytes
struct or_function_signature{
    UInt8 decl_arg_count;
    UInt8 *signature;
};
struct ORLinkedCFunction{
    intptr_t function_address;
    struct ORStringItem function_name;
    struct ORStringItem type_encode;
    struct or_function_signature signature;
};

struct ORVariableData {
    uintptr_t data;
};

struct ORObjcMethod{
    NSMethodSignature *signature;
    SEL selector;
    struct ORStringItem method_name;
    struct ORStringItem method_type_encode;
};

//typedef int MFPropertyModifier;
struct ORObjcProperty {
    int modifer;
    struct ORStringItem property_name;
    struct ORStringItem property_type_encode;
    struct ORStringItem getter_name;
    struct ORStringItem setter_name;
    struct ORStringItem ivar_name;
};

struct ORClassItem {
    struct ORObjcProperty *properties;
    struct ORObjcMethod *method;
};

struct ORStruct{
    struct ORStringItem struct_name;
    struct ORStringItem type_encode;
};

struct ORFile {
    struct ORFileHeader *header;
    struct ORLoadCommand *commands;
    struct ORLinkedClass *linked_class_section;
    struct ORLinkedCFunction *linked_cfunction_section;
    struct ORClassItem *dynamic_class_section;
    struct ORObjcMethod *method_section;
    struct ORObjcProperty *property_section;
    struct ORStruct *struct_section;
    struct ORVariableData *data_section;
    struct ORCFString *cf_string_section;
    struct ORStringSection *string_section;
    const void *instructions;
};

inline const char * const or_file_string(struct ORFile *file, int64_t offset){
    return file->string_section->buffer + offset;
}

/// save string in string_section
/// @param str string
/// @retrun  the offset in string_section
uint32_t or_file_write_string(struct ORFile *file, char *str);

/// use the offset to get str in string_section
/// @param offset  offset in string_section
/// @retunrn the string result
char *or_file_get_read_string(struct ORFile *file, uint32_t offset);

