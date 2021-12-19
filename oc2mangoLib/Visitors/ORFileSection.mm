//
//  ORFileSection.m
//  oc2mangoLib
//
//  Created by Jiang on 2021/12/11.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "ORFileSection.hpp"
#import "RunnerClasses.h"
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

int ORSectionRecorderManager::addObjcClass(const char *className,
                                           const char *superClassName) {
    
    struct ORClassItem item;
    memset(&item, 0, sizeof(struct ORClassItem));
    item.class_name = addCString(className);
    item.super_class_name = addCString(superClassName);
    string key = string(className);
    int result = objcClassesRecorder.findInCache(key);
    if (result > -1) {
        return result;
    }
    int index = objcClassesRecorder.list_count;
    objcClassesRecorder.saveInCache(key, index);
    objcClassesRecorder.add(&item, sizeof(struct ORClassItem));
    return index;
};
int ORSectionRecorderManager::addObjcProperty(const char *dstClassName,
                                              int modifer,
                                              const char *typeName,
                                              const char *propertyName,
                                              const char *typeencode){
    int classIndex = objcClassesRecorder.findInCache(string(dstClassName));
    assert(classIndex > -1);
    struct ORClassItem *dstClass = getClassItem(classIndex);
    if (dstClass->prop_list.count == 0) {
        dstClass->prop_list.start_index = objcPropsRecroder.list_count;
    }
    dstClass->prop_list.count += 1;
    struct ORObjcProperty prop;
    memset(&prop, 0, sizeof(struct ORObjcProperty));
    prop.property_name = addCString(propertyName);
    prop.modifer = modifer;
    prop.type_name = addCString(typeName);
    prop.type_encode = addCString(typeencode);
    prop.getter_name = addCString(propertyName);
    string prop_name = string(propertyName);
    string ivar_name = "_" + prop_name;
    prop.ivar_name = addCString(ivar_name.data());
    string setter_name = prop_name;
    char *chrs = (char *)setter_name.data();
    chrs[0] = std::toupper(chrs[0]);
    setter_name = "set" + setter_name;
    prop.setter_name = addCString(setter_name.data());
    int index = objcPropsRecroder.list_count;
    objcPropsRecroder.add(&prop, sizeof(struct ORObjcProperty));
    addObjcIvar(dstClassName, typeName, ivar_name.data(), typeencode);
    return index;
}
int ORSectionRecorderManager::addObjcClassMethod(const char *dstClassName, const char *selector, const char *typeencode) {
    int classIndex = objcClassesRecorder.findInCache(string(dstClassName));
    assert(classIndex > -1);
    struct ORClassItem *dstClass = getClassItem(classIndex);
    if (dstClass->class_method_list.count == 0) {
        dstClass->class_method_list.start_index = objcClassMethodsRecroder.list_count;
    }
    dstClass->class_method_list.count += 1;
    struct ORObjcMethod method;
    method.selector = addCString(selector);
    method.type_encode = addCString(typeencode);
    int index = objcClassMethodsRecroder.list_count;
    objcClassMethodsRecroder.add(&method, sizeof(struct ORObjcMethod));
    return index;
}
int ORSectionRecorderManager::addObjcInstanceMethod(const char *dstClassName, const char *selector, const char *typeencode) {
    int classIndex = objcClassesRecorder.findInCache(string(dstClassName));
    assert(classIndex > -1);
    struct ORClassItem *dstClass = getClassItem(classIndex);
    if (dstClass->instance_method_list.count == 0) {
        dstClass->instance_method_list.start_index = objcInstanceMethodsRecroder.list_count;
    }
    dstClass->instance_method_list.count += 1;
    struct ORObjcMethod method;
    method.selector = addCString(selector);
    method.type_encode = addCString(typeencode);
    int index = objcInstanceMethodsRecroder.list_count;
    objcInstanceMethodsRecroder.add(&method, sizeof(struct ORObjcMethod));
    return index;
}

int ORSectionRecorderManager::addObjcIvar(const char *dstClassName,
                const char *typeName,
                const char *ivarName,
                const char *typeencode){
    string ivarKey = string(dstClassName) + "." + string(ivarName);
    int ivarIndex = objcIvarsRecroder.findInCache(ivarKey);
    if (ivarIndex > -1) {
        return ivarIndex;
    }
    int classIndex = objcClassesRecorder.findInCache(string(dstClassName));
    assert(classIndex > -1);
    struct ORClassItem *dstClass = getClassItem(classIndex);
    if (dstClass->ivar_list.count == 0) {
        dstClass->ivar_list.start_index = objcIvarsRecroder.list_count;
    }
    dstClass->ivar_list.count += 1;
    struct ORObjcIvar ivar;
    ivar.type_name = addCString(typeName);
    ivar.ivar_name = addCString(ivarName);
    ivar.type_encode = addCString(typeencode);
    int index = objcIvarsRecroder.list_count;
    objcIvarsRecroder.saveInCache(ivarKey, index);
    objcIvarsRecroder.add(&ivar, sizeof(struct ORObjcIvar));
    return index;
}
