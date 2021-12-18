//
//  ORFileSection.h
//  oc2mangoLib
//
//  Created by Jiang on 2021/12/11.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORFile.hpp"

struct or_data_recorder {
    void *buffer;
    int cursor;
    void **list;
    int count;
    int buffer_capacity;
    int list_capacity;
};

#include <string>
#import <unordered_map>

struct ORDataRecorder {
    char *buffer;
    int buffer_offset;
    int buffer_capacity;
    void **list;
    int list_count;
    int list_capacity;
    std::unordered_multimap<std::string, int> item_cache;

    ORDataRecorder(void) {
        buffer_capacity = 4096;
        buffer = (char *)malloc(sizeof(char) * buffer_capacity);
        buffer_offset = 0;
        list_capacity = 1024;
        list = (void **)malloc(sizeof(void *) * list_capacity);
        list_count = 0;
        item_cache = std::unordered_multimap<std::string, int>();
    }
    ~ORDataRecorder(){
        free(buffer);
        free(list);
    }

    void check(size_t add_len);
    void add(void *data, size_t len);
    int findInCache(std::string key);
    void saveInCache(std::string key, int value);
};

class ORSectionRecorderManager {
public:
    ORDataRecorder stringRecorder = ORDataRecorder();
    
    /*
     when virtual machine started, all NSString References which need to be initialized
     */
    ORDataRecorder cfstringRecorder = ORDataRecorder();
    
    /*
     when virtual machine started, all Objc class References which need to be initialized
     */
    ORDataRecorder linkedClassRecorder = ORDataRecorder();
    
    /*
     when virtual machine started, all c functions linked by
     SystemFunctionSearch( fishhook )
     */
    ORDataRecorder linkedCFunctionRecorder = ORDataRecorder();
    
    /*
     Data section used to store global var or static var. when in virtual machine
     running, used the offset to r/w them. In codegen, according its
     type to determine r/w data length.
     */
    ORDataRecorder globalDataRecorder = ORDataRecorder();
    
    /*
     Constant is 8 bytes, when read it, auto use 8 as memeory offset.
     */
    ORDataRecorder constantsRecorder = ORDataRecorder();
    

    ORStringItem addCString(const char *str);
    
    int addCFString(const char *str);
    int addLinkedClass(const char *className);
    int addLinkedCFunction(const char *typeencode, const char *name);
    int addDataSection(size_t len);
    int addConstant(void *data);
    const char *getString(int offset);
    struct ORCFString *getCFString(int index);
    struct ORLinkedCFunction *getLinkdCFunction(int index);
    struct ORLinkedClass *getLinkdClass(int index);
};
