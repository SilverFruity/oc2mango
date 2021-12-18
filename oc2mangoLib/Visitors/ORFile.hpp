//
//  ORFile.h
//  oc2mangoLib
//
//  Created by Jiang on 2021/12/7.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
typedef int or_file_offset;

struct ORLoadCommand{
    or_file_offset section_offset;
    or_file_offset section_size;
    int item_count;
};

struct ORFileHeader{
    char sha256_data[256];
    char target_os_version[64];
    char target_app_version[64];
    char target_framework_version[64];
    int load_command_count;
};

enum OR_LOAD_COMMAND: int{
    or_load_string_section,
    or_load_linked_class_section,
    or_load_link_cfunction_section,
    or_load_class_section,
    or_load_text_section,
};

struct ORStringItem{
    // the offset in string seciton
    int offset;
};

struct ORCFString {
    void * ref;
    struct ORStringItem cstring;
};

struct ORStringSection{
    char *buffer;
};

struct ORLinkedClass {
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

#pragma mark - Objc Sections
struct ORStruct{
    struct ORStringItem struct_name;
    struct ORStringItem type_encode;
};

struct ORObjcMethod{
    struct objc_method *method;
    BOOL isClassMethod;
    struct ORStringItem class_name;
    struct ORStringItem selector;
    struct ORStringItem method_name;
    struct ORStringItem method_type_encode;
    or_file_offset imp;
};

//typedef int MFPropertyModifier;
struct ORObjcProperty {
    struct objc_property * objc_prop;
    int modifer;
    struct ORStringItem class_name;
    struct ORStringItem property_name;
    struct ORStringItem property_type_encode;
    struct ORStringItem getter_name;
    struct ORStringItem setter_name;
    struct ORStringItem ivar_name;
};

struct ORObjcIvar {
    struct objc_ivar * ivar;
    struct ORStringItem class_name;
    struct ORStringItem ivar_name;
    struct ORStringItem type_encode;
};

struct ORFileList {
    int count;
    or_file_offset item_start_offset;
};

struct ORClassItem {
    struct objc_object *class_t;
    struct ORStringItem class_name;
    struct ORStringItem super_class_name;
    // struct ORObjcIvar *
    struct ORFileList ivar_list;
    // struct ORObjcProperty *
    struct ORFileList prop_list;
    // struct ORObjcMethod *
    struct ORFileList class_method_list;
    // struct ORObjcMethod *
    struct ORFileList instance_method_list;
};
#pragma mark - ----

struct ORFile {
    struct ORFileHeader *header;
    struct ORLoadCommand *commands;
    struct ORLinkedClass *linked_class_section;
    struct ORLinkedCFunction *linked_cfunction_section;
    struct ORStruct *struct_section;
    struct ORVariableData *data_section;
    struct ORCFString *cf_string_section;
    struct ORStringSection *string_section;
    uint64_t *constant_section;
    
    struct ORObjcMethod *instance_method_section;
    struct ORObjcMethod *class_method_section;
    struct ORObjcProperty *property_section;
    struct ORObjcIvar *ivar_section;
    struct ORClassItem *class_section;
    
    const void *instructions;
};

inline const char * const or_file_string(struct ORFile *file, int64_t offset){
    return file->string_section->buffer + offset;
}
