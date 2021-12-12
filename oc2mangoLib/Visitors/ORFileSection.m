//
//  ORFileSection.m
//  oc2mangoLib
//
//  Created by Jiang on 2021/12/11.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "ORFileSection.h"
#import "ORFile.h"
#import "RunnerClasses.h"
extern const char *typeEncodeForDeclaratorNode(ORDeclaratorNode * node);

struct or_data_recorder {
    void *buffer;
    int cursor;
    void **list;
    int count;
    int buffer_capacity;
    int list_capacity;
};
struct or_data_recorder string_recorder;
struct or_data_recorder linked_class_recorder;
struct or_data_recorder linked_function_recorder;
struct or_data_recorder data_recorder;


void init_data_recorder(struct or_data_recorder *recorder) {
    recorder->buffer_capacity = 4096;
    recorder->buffer = malloc(sizeof(char) * recorder->buffer_capacity);
    recorder->cursor = 0;
    recorder->list_capacity = 1024;
    recorder->list = malloc(sizeof(void *) * recorder->list_capacity);
    recorder->count = 0;
}
void data_recorder_check(struct or_data_recorder *recorder, size_t len) {
    if (recorder->cursor + len > recorder->buffer_capacity) {
        recorder->buffer_capacity += recorder->buffer_capacity;
        recorder->buffer = realloc(recorder->buffer, recorder->buffer_capacity);
    }
    if (recorder->count + 1 > recorder->list_capacity) {
        recorder->list_capacity += recorder->list_capacity;
        recorder->list = realloc(recorder->list, recorder->list_capacity);
    }
}
void data_recorder_add(struct or_data_recorder *recorder, void *data, size_t len) {
    void *dst = recorder->buffer + recorder->cursor;
    if (data != NULL) {
        memcpy(dst, data, len);
    }else{
        memset(dst, 0, len);
    }
    recorder->cursor += len;
    recorder->list[recorder->count] = dst;
    recorder->count += 1;
}
#pragma mark - String Section
static NSMutableDictionary *string_cahce = nil;
const void *init_string_recorder(void) {
    init_data_recorder(&string_recorder);
    string_cahce = [NSMutableDictionary dictionary];
    return &string_recorder;
}
int or_string_recorder_add(char *str) {
    assert(str != NULL);
    NSString *key = [NSString stringWithUTF8String:str];
    NSNumber *offest = string_cahce[key];
    if (offest) {
        return offest.intValue;
    }
    assert(str[strlen(str)] == '\0');
    data_recorder_add(&string_recorder, str, strlen(str) + 1);
    return string_recorder.cursor;
}
struct ORStringItem or_string_item(char *str) {
    struct ORStringItem item;
    item.offset = or_string_recorder_add(str);
    return item;
}
#pragma mark - LinkedClass
const void *init_linked_class_recorder(void) {
    init_data_recorder(&linked_class_recorder);
    return &linked_class_recorder;
}

int or_linked_class_recorder_add(char *className) {
    assert(className != NULL);
    struct ORStringItem item;
    item.offset = (uint32_t)or_string_recorder_add(className);
    struct ORLinkedClass linked;
    linked.class_ptr = NULL;
    linked.class_name = item;
    data_recorder_add(&linked_class_recorder, &linked, sizeof(struct ORLinkedClass));
    return linked_class_recorder.count - 1;
}
#pragma mark - LinkedCFunction
static NSMutableDictionary *linked_cfunc_cache = nil;
const void *init_linked_cfunction_recorder(void) {
    init_data_recorder(&linked_function_recorder);
    linked_cfunc_cache = [NSMutableDictionary dictionary];
    return &linked_function_recorder;
}

int or_linked_cfunction_recorder_add(ORFunctionDeclNode *decl) {
    char *func_name = (char *)decl.var.varname.UTF8String;
    assert(func_name != NULL);
    NSString *key = [NSString stringWithUTF8String:func_name];
    NSNumber *index = linked_cfunc_cache[key];
    if (index) {
        return index.intValue;
    }
    char *typeencode = (char *)typeEncodeForDeclaratorNode(decl);
    struct LinkedCFunction func;
    func.function_address = 0;
    func.function_name = or_string_item(func_name);;
    func.type_encode = or_string_item(typeencode);
//    func.signature = { 0, 0 };
    data_recorder_add(&linked_function_recorder, &func, sizeof(struct LinkedCFunction));
    return linked_function_recorder.count - 1;
}
#pragma mark - Data
const void *init_data_section_recorder(void) {
    init_data_recorder(&data_recorder);
    return &data_recorder;
}

int data_section_recorder_add(size_t len) {
    data_recorder_add(&data_recorder, NULL, len);
    return data_recorder.cursor;
}

