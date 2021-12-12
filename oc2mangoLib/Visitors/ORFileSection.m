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

struct or_data_recorder string_recorder;
struct or_data_recorder cfstring_recorder;
struct or_data_recorder linked_class_recorder;
struct or_data_recorder linked_function_recorder;
struct or_data_recorder data_recorder;
struct or_data_recorder constant_data_recorder;

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
    data_recorder_check(recorder, len);
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
int or_string_recorder_add(const char *str) {
    assert(str != NULL);
    NSString *key = [NSString stringWithUTF8String:str];
    NSNumber *offest = string_cahce[key];
    if (offest) {
        return offest.intValue;
    }
    assert(str[strlen(str)] == '\0');
    int offset = string_recorder.cursor;
    string_cahce[key] = @(offset);
    data_recorder_add(&string_recorder, (char *)str, strlen(str) + 1);
    return offset;
}
struct ORStringItem or_string_item(const char *str) {
    struct ORStringItem item;
    item.offset = or_string_recorder_add(str);
    return item;
}

#pragma mark - CFString Section
static NSMutableDictionary *cfstring_section_cache = nil;
const void *init_cfstring_recorder(void) {
    init_data_recorder(&cfstring_recorder);
    cfstring_section_cache = [NSMutableDictionary dictionary];
    return &cfstring_recorder;
}

int or_cfstring_recorder_add(const char *str) {
    assert(str != NULL);
    struct ORCFString cfstring;
    cfstring.ref = NULL;
    cfstring.string = or_string_item((char *)str);
    NSNumber *cached = cfstring_section_cache[@(cfstring.string.offset)];
    if (cached) {
        return cached.intValue;
    }
    int index = cfstring_recorder.count;
    cfstring_section_cache[@(cfstring.string.offset)] = @(index);
    data_recorder_add(&cfstring_recorder, &cfstring, sizeof(struct ORCFString));
    return index;
}

#pragma mark - LinkedClass
static NSMutableDictionary *linked_class_section_cache = nil;
const void *init_linked_class_recorder(void) {
    init_data_recorder(&linked_class_recorder);
    linked_class_section_cache = [NSMutableDictionary dictionary];
    return &linked_class_recorder;
}

int or_linked_class_recorder_add(const char *className) {
    assert(className != NULL);
    struct ORLinkedClass linked;
    linked.class_ptr = NULL;
    linked.class_name = or_string_item((char *)className);
    NSNumber *cached = linked_class_section_cache[@(linked.class_name.offset)];
    if (cached) {
        return cached.intValue;
    }
    int index = cfstring_recorder.count;
    cfstring_section_cache[@(linked.class_name.offset)] = @(index);
    data_recorder_add(&linked_class_recorder, &linked, sizeof(struct ORLinkedClass));
    return index;
}
#pragma mark - LinkedCFunction
static NSMutableDictionary *linked_cfunc_cache = nil;
const void *init_linked_cfunction_recorder(void) {
    init_data_recorder(&linked_function_recorder);
    linked_cfunc_cache = [NSMutableDictionary dictionary];
    return &linked_function_recorder;
}

int or_linked_cfunction_recorder_add(const char *typeencode, const char *name) {
    assert(name != NULL);
    NSString *key = [NSString stringWithUTF8String:name];
    NSNumber *value = linked_cfunc_cache[key];
    if (value) {
        return value.intValue;
    }
    struct ORLinkedCFunction func;
    func.function_address = 0;
    func.function_name = or_string_item(name);
    func.type_encode = or_string_item(typeencode);
//    func.signature = { 0, 0 };
    int index = linked_function_recorder.count;
    linked_cfunc_cache[key] = @(index);
    data_recorder_add(&linked_function_recorder, &func, sizeof(struct ORLinkedCFunction));
    return index;
}
#pragma mark - Data
const void *init_data_section_recorder(void) {
    init_data_recorder(&data_recorder);
    return &data_recorder;
}

int or_data_section_recorder_add(size_t len) {
    int offset = string_recorder.cursor;
    data_recorder_add(&data_recorder, NULL, len);
    return offset;
}

#pragma mark - Constant
const void *init_constant_section_recorder(void) {
    init_data_recorder(&constant_data_recorder);
    return &constant_data_recorder;
}

int or_constant_section_recorder_add(void *data) {
    assert(data != NULL);
    data_recorder_add(&constant_data_recorder, NULL, sizeof(UInt64));
    return constant_data_recorder.count - 1;
}
