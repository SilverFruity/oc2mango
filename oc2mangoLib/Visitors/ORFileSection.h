//
//  ORFileSection.h
//  oc2mangoLib
//
//  Created by Jiang on 2021/12/11.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORFile.h"

struct or_data_recorder {
    void *buffer;
    int cursor;
    void **list;
    int count;
    int buffer_capacity;
    int list_capacity;
};

#pragma mark - String Section
const void *init_string_recorder(void);
int or_string_recorder_add(const char *str);
const char * unwrapStringItem(struct ORStringItem item);
#pragma mark - CFString Section
/*
 when virtual machine started, all NSString References which need to be initialized
 */
const void *init_cfstring_recorder(void);
int or_cfstring_recorder_add(const char *str);

#pragma mark - LinkedClass
/*
 when virtual machine started, all Objc class References which need to be initialized
 */
const void *init_linked_class_recorder(void);
int or_linked_class_recorder_add(const char *className);
#pragma mark - LinkedCFunction
/*
 when virtual machine started, all c functions linked by
 SystemFunctionSearch( fishhook )
 */
const void *init_linked_cfunction_recorder(void);
int or_linked_cfunction_recorder_add(const char *typeencode, const char *name);
#pragma mark - Data
/*
 Data section used to store global var or static var. when in virtual machine
 running, used the offset to r/w them. In codegen, according its
 type to determine r/w data length.
 */
const void *init_data_section_recorder(void);
int or_data_section_recorder_add(size_t len);
#pragma mark - Constant
/*
 Constant is 8 bytes, when read it, auto use 8 as memeory offset.
 */
const void *init_constant_section_recorder(void);
int or_constant_section_recorder_add(void *data);
