//
//  ORFileSection.m
//  oc2mangoLib
//
//  Created by Jiang on 2021/12/11.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "ORFileSection.hpp"
#import "RunnerClasses.h"
#import <string>
#import <unordered_map>
#import <iostream>
using namespace std;

int ORDataRecorder::findInCache(string key){
    auto iter = item_cache.find(key);
    if (iter != item_cache.end()) {
        return iter->second;
    }
    return -1;
}
void ORDataRecorder::saveInCache(string key, int value){
    assert(value > -1);
    item_cache.insert(pair<string, int>(key, value));
}
void ORDataRecorder::add(void *data, size_t len) {
    check(len);
    void *dst = (char *)buffer + buffer_offset;
    if (data != NULL) {
        memcpy(dst, data, len);
    }else{
        memset(dst, 0, len);
    }
    buffer_offset += len;
    list[list_count] = dst;
    list_count += 1;
}
void ORDataRecorder::check(size_t add_len) {
    if (buffer_offset + add_len > buffer_capacity) {
        buffer_capacity += buffer_capacity;
        buffer = (char *)realloc(buffer, buffer_capacity);
    }
    if (list_count + 1 > list_capacity) {
        list_capacity += list_capacity;
        list = (void **)realloc(list, list_capacity);
    }
}


ORStringItem ORSectionRecorderManager::addCString(const char *str) {
    assert(str != NULL);
    string key = string(str);
    int cached = stringRecorder.findInCache(key);
    if (cached > -1) {
        return ORStringItem{ cached };
    }
    assert(str[strlen(str)] == '\0');
    int offset = stringRecorder.buffer_offset;
    stringRecorder.saveInCache(key, offset);
    stringRecorder.add((char *)str, strlen(str) + 1);
    return ORStringItem { offset };
}

int ORSectionRecorderManager::addCFString(const char *str) {
    assert(str != NULL);
    struct ORCFString cfstring;
    cfstring.ref = NULL;
    cfstring.cstring = addCString(str);
    string key = to_string(cfstring.cstring.offset);
    int cached = cfstringRecorder.findInCache(key);
    if (cached > -1) {
        return cached;
    }
    int index = cfstringRecorder.list_count;
    cfstringRecorder.saveInCache(key, index);
    cfstringRecorder.add(&cfstring, sizeof(struct ORCFString));
    return index;
}

int ORSectionRecorderManager::addLinkedClass(const char *className) {
    assert(className != NULL);
    struct ORLinkedClass linked;
    linked.class_ptr = NULL;
    linked.class_name = addCString(className);
    string key = to_string(linked.class_name.offset);
    int cached = linkedClassRecorder.findInCache(key);
    if (cached > -1) {
        return cached;
    }
    int index = linkedClassRecorder.list_count;
    linkedClassRecorder.saveInCache(key, index);
    linkedClassRecorder.add(&linked, sizeof(struct ORLinkedClass));
    return index;
}
int ORSectionRecorderManager::addLinkedCFunction(const char *typeencode, const char *name) {
    assert(name != NULL);
    string key = string(name);
    int cached = linkedCFunctionRecorder.findInCache(key);
    if (cached > -1) {
        return cached;
    }
    struct ORLinkedCFunction func;
    func.function_address = 0;
    func.function_name = addCString(name);
    func.type_encode = addCString(typeencode);
    // FIXME: generate function signature
//    func.signature = { 0, 0 };
    int index = linkedCFunctionRecorder.list_count;
    linkedCFunctionRecorder.saveInCache(key, index);
    linkedCFunctionRecorder.add(&func, sizeof(struct ORLinkedCFunction));
    return index;
}
int ORSectionRecorderManager::addDataSection(size_t len) {
    int offset = globalDataRecorder.buffer_offset;
    globalDataRecorder.add(NULL, len);
    return offset;
}
int ORSectionRecorderManager::addConstant(void *data) {
    int index = constantsRecorder.list_count;
    constantsRecorder.add(NULL, sizeof(UInt64));
    return index;
}

const char *ORSectionRecorderManager::getString(int offset) {
    return stringRecorder.buffer + offset;
}

struct ORCFString *ORSectionRecorderManager::getCFString(int index) {
    return (struct ORCFString *)cfstringRecorder.buffer + index;
}

struct ORLinkedCFunction *ORSectionRecorderManager::getLinkdCFunction(int index) {
    return (struct ORLinkedCFunction *)linkedCFunctionRecorder.buffer + index;
}
struct ORLinkedClass *ORSectionRecorderManager::getLinkdClass(int index) {
    return (struct ORLinkedClass *)cfstringRecorder.buffer + index;
}
